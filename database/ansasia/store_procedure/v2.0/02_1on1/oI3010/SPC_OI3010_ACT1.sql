IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_OI3010_ACT1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_OI3010_ACT1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*   											
--* 作成日/create date			:	2020/11/19										
--*	作成者/creater				:	nghianm						
--*   					
--*	更新日/update date			:  		
--*	更新者/updater				:　						     	 
--*	更新内容/update content		:	
--*   					
--****************************************************************************************
CREATE PROCEDURE [SPC_OI3010_ACT1] 
	-- Add the parameters for the stored procedure here
	@P_json						nvarchar(max)			=	''
	-- common
,	@P_cre_user					nvarchar(50)			=	''
,	@P_cre_ip					nvarchar(50)			=	''
,	@P_company_cd				smallint				=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			INT					=	0
	-----------------------SCREEN DATA-------------------------
	,	@fiscal_year			SMALLINT			=	0
	,	@1on1_group_cd			SMALLINT			=	0
	,	@times					SMALLINT			=	0
	,	@questionnaire_cd		SMALLINT			=	0
	,	@answer_no				SMALLINT			=	0
	,	@employee_cd			NVARCHAR(10)		=	''
	,	@comment				NVARCHAR(400)		=	''
	,	@ck_search				SMALLINT			=	0
	,	@answer_no_max			INT					=	0
	,	@submit					INT					=	0
	--

	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--CREATE TEMP TABLE
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--
	CREATE TABLE #TABLE_JSON (
		id							INT				IDENTITY(1,1)
	,	questionnaire_gyono			SMALLINT
	,	sentence_answer				NVARCHAR(200)
	,	points_answer				SMALLINT
	)
	CREATE TABLE #TABLE_LIST_POINTS_ANSWER (
		id							INT				IDENTITY(1,1)
	,	questionnaire_gyono			SMALLINT
	,	points_answer				SMALLINT
	)
	--
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		--VALIDATE
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		IF ISJSON(@P_json) <= 0
		BEGIN
			INSERT INTO @ERR_TBL VALUES(		
				22									-- mã lỗi (trùng với mã trong bảng message) 					
			,	''									-- id hoặc class của item(#id , .class), lỗi dạng dialog thì để trống  				
			,	0-- oderby							-- giá trị càng bé thì lỗi được hiển thị trước  				
			,	1-- dialog  						-- Kiểu hiển thị lối : 0. tooltip , 1.dialog 				
			,	0									-- Tùy ý : có thể lưu vị trí index của dòng của lỗi 				
			,	0									-- Tùy ý
			,	'json format'						-- Comment nội dung lỗi (chủ yếu là dùng khi đọc code)
			)
		END
		--
		-- get data from json
		SET	@fiscal_year			=	JSON_VALUE(@P_json,'$.fiscal_year')
		SET	@1on1_group_cd			=	JSON_VALUE(@P_json,'$.group_cd')
		SET	@times					=	JSON_VALUE(@P_json,'$.times')
		SET	@questionnaire_cd		=	JSON_VALUE(@P_json,'$.questionnaire_cd')
		SET	@employee_cd			=	JSON_VALUE(@P_json,'$.employee_cd')
		SET	@ck_search				=	JSON_VALUE(@P_json,'$.ck_search')
		SET	@comment				=	JSON_VALUE(@P_json,'$.comment')
		SET	@answer_no				=	JSON_VALUE(@P_json,'$.answer_no')
		SET @submit					=	(SELECT ISNULL(submit,0) FROM M2400 WHERE company_cd = @P_company_cd AND questionnaire_cd = @questionnaire_cd AND del_datetime IS NULL)
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			-- get list from json data
			INSERT INTO #TABLE_JSON
			SELECT
				questionnaire_gyono
			,	sentence_answer
			,	0
			FROM OPENJSON(@P_json,'$.question_list') WITH(
				questionnaire_gyono			SMALLINT
			,	sentence_answer				NVARCHAR(200)
			)
			--
			INSERT INTO #TABLE_LIST_POINTS_ANSWER
			SELECT 
				questionnaire_gyono
			,	points_answer
			FROM OPENJSON(@P_json,'$.list_points_answer') WITH(
				questionnaire_gyono			SMALLINT
			,	points_answer				SMALLINT
			)
			-- UPDATE #TABLE_JSON
			UPDATE #TABLE_JSON
			SET
				#TABLE_JSON.points_answer = #TABLE_LIST_POINTS_ANSWER.points_answer
			FROM #TABLE_JSON
			INNER JOIN #TABLE_LIST_POINTS_ANSWER ON (
				#TABLE_JSON.questionnaire_gyono = #TABLE_LIST_POINTS_ANSWER.questionnaire_gyono
			)
			----- INSERT INTO F2311
			SET @answer_no_max = ISNULL((SELECT MAX(answer_no) 
											 FROM F2310 
											 WHERE F2310.company_cd  = @P_company_cd
											 AND F2310.fiscal_year = @fiscal_year
											 AND F2310.[1on1_group_cd] = @1on1_group_cd
											 AND F2310.times = @times),0) + 1
			IF NOT EXISTS (SELECT 1 FROM F2310 WHERE F2310.company_cd		= @P_company_cd
												AND	F2310.fiscal_year		= @fiscal_year
												AND	F2310.[1on1_group_cd]	= @1on1_group_cd
												AND F2310.times				= @times
												AND F2310.questionnaire_cd	= @questionnaire_cd
												AND F2310.answer_no			= @answer_no)
			BEGIN
				----- INSERT INTO F2310
				INSERT INTO F2310
				SELECT 
					@P_company_cd
				,	@fiscal_year
				,	@1on1_group_cd
				,	@times
				,	@questionnaire_cd
				,	@answer_no_max
				,	CASE	
						WHEN	@ck_search = 1
						THEN	NULL
						ELSE	@employee_cd
					END
				,	@comment
				,	@P_cre_user
				,	@P_cre_ip
				,	'oI3010'
				,	@w_time
				,	''
				,	''
				,	''
				,	NULL
				,	''
				,	''
				,	''
				,	NULL
				----- INSERT INTO F2311
				INSERT INTO F2311
				SELECT 
					@P_company_cd
				,	@fiscal_year
				,	@1on1_group_cd
				,	@times
				,	@questionnaire_cd
				,	@answer_no_max
				,	#TABLE_JSON.questionnaire_gyono
				,	#TABLE_JSON.sentence_answer
				,	#TABLE_JSON.points_answer
				,	@P_cre_user
				,	@P_cre_ip
				,	'oI3010'
				,	@w_time
				,	''
				,	''
				,	''
				,	NULL
				,	''
				,	''
				,	''
				,	NULL
				FROM #TABLE_JSON
			END
			ELSE
			BEGIN
				UPDATE F2310
				SET F2310.comment	= @comment
				,	upd_user		= @P_cre_user
				,	upd_ip			= @P_cre_ip
				,	upd_prg			= 'oI3010'
				,	upd_datetime	= @w_time
				WHERE F2310.company_cd		= @P_company_cd
				AND	F2310.fiscal_year		= @fiscal_year
				AND	F2310.[1on1_group_cd]	= @1on1_group_cd
				AND F2310.times				= @times
				AND F2310.questionnaire_cd	= @questionnaire_cd
				AND F2310.answer_no			= @answer_no
				--
				UPDATE F2311	
				SET	F2311.sentence_answer = #TABLE_JSON.sentence_answer
				,	F2311.points_answer	  = #TABLE_JSON.points_answer
				,	upd_user			  = @P_cre_user
				,	upd_ip				  = @P_cre_ip
				,	upd_prg				  = 'oI3010'
				,	upd_datetime		  = @w_time
				FROM F2311 
				INNER JOIN #TABLE_JSON ON (
					F2311.questionnaire_gyono = #TABLE_JSON.questionnaire_gyono
				)
				WHERE F2311.company_cd			= @P_company_cd
				AND	F2311.fiscal_year			= @fiscal_year
				AND	F2311.[1on1_group_cd]		= @1on1_group_cd
				AND F2311.times					= @times
				AND F2311.questionnaire_cd		= @questionnaire_cd
				AND F2311.answer_no				= @answer_no 
				AND F2311.questionnaire_gyono	= #TABLE_JSON.questionnaire_gyono
			END

			--UPDATE F2301
			UPDATE F2301
			SET 
				F2301.send_user		=	@P_cre_user
			,	F2301.send_ip		=	@P_cre_ip
			,	F2301.send_datetime	=	@w_time
			,	F2301.upd_user		=	@P_cre_user
			,	F2301.upd_ip		=	@P_cre_ip
			,	F2301.upd_prg		=	'oI3010'
			,	F2301.upd_datetime	=	@w_time
			FROM F2301
			WHERE
				F2301.company_cd		=	@P_company_cd
			AND	F2301.fiscal_year		=	@fiscal_year
			AND	F2301.[1on1_group_cd]	=	@1on1_group_cd
			AND	F2301.times				=	@times
			AND	F2301.submit			=	@submit
			AND	F2301.employee_cd		=	@employee_cd
			AND	F2301.del_datetime		IS NULL
		END

		-------------------
	END TRY
	BEGIN CATCH
	IF (@@TRANCOUNT > 0)
		BEGIN
			ROLLBACK TRANSACTION
		END
		DELETE FROM @ERR_TBL
		INSERT INTO @ERR_TBL
		SELECT	
			0
		,	'EXCEPTION'
		,	0
		,	999 -- exception error
		,	0
		,	0
		,	'Error'                                                          + CHAR(13) + CHAR(10) +
            'Procedure : ' + ISNULL(ERROR_PROCEDURE(), '???')                + CHAR(13) + CHAR(10) +
            'Line : '      + ISNULL(CAST(ERROR_LINE() AS NVARCHAR(10)), '0') + CHAR(13) + CHAR(10) +
            'Message : '   + ISNULL(ERROR_MESSAGE(), 'An unexpected error occurred.')
	END CATCH
	--DELETE FROM @ERR_TBL
	IF(@@TRANCOUNT > 0)
	BEGIN
		COMMIT TRANSACTION
	END
    -- Insert statements for procedure here
	COMPLETE_QUERY:
	-- GET ERROR_TYPE MIN
	SELECT 
		@order_by_min = MIN(order_by)
	FROM @ERR_TBL
	--[0] SELECT ERROR TABLE
	SELECT 
		message_no
	,	item
	,	order_by
	,	error_typ
	,	value1
	,	value2
	,	remark
	FROM @ERR_TBL
	WHERE order_by = @order_by_min
	ORDER BY 
		order_by
END
GO