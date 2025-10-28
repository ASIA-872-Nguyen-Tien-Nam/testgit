SET ANSI_NULLS ON
GO
DROP PROCEDURE [dbo].[SPC_rM0100_ACT1] 
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	SAVE DATA
--*  
--* 作成日/create date			:	2023/04/07									
--*	作成者/creater				:	quangnd						
--*   					
--*	更新日/update date			:	
--*	更新者/updater				:　 	 	 
--*	更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_rM0100_ACT1] 
	@P_json					NVARCHAR(MAX)
,	@P_cre_user				NVARCHAR(50)			= ''	
,	@P_cre_ip				NVARCHAR(50)			= ''
,	@P_company_cd			SMALLINT				= 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time							DATETIME2			= SYSDATETIME()
	,	@ERR_TBL						ERRTABLE	
	,	@order_by_min					INT					= 0
	,	@w_company_cd_refer				INT					= -1
	,	@w_report_kind					SMALLINT			= 0
	,	@w_question_no					INT					= -1
	,	@w_question_title				NVARCHAR(50)		= ''
	,	@w_question						NVARCHAR(200)		= ''
	,	@w_arrange_order				SMALLINT			= 0
	,	@w_answer_kind					SMALLINT			= 0
	,	@w_item_digits					SMALLINT			= 0
	,	@w_answer_kbn					SMALLINT			= 0
	,	@w_refer_kbn					TINYINT				= 0
	,	@w_refer_question_no			INT					= 0
	--
	,	@w_max_question_no				TINYINT				= 0
	,	@w_max_detail_no				SMALLINT			= 0
	,	@w_company_mc					SMALLINT			= 0
	--
	CREATE TABLE #M4125_TMP(
		id					INT IDENTITY(1,1)
	,	company_cd			SMALLINT
	,	report_kind			SMALLINT
	,	question_no			TINYINT
	,	question_title		NVARCHAR(50)
	,	question			NVARCHAR(200)
	,	answer_kind			SMALLINT
	,	answer_digits		SMALLINT
	,	answer_kbn			SMALLINT
	,	refer_kbn			TINYINT
	,	refer_question_no	TINYINT
	,	arrange_oder		INT
	)
	--
	CREATE TABLE #M4126_TMP(
		id					INT IDENTITY(1,1)
	,	company_cd			SMALLINT
	,	question_no			TINYINT
	,	detail_no			SMALLINT 
	,	deltail_name		NVARCHAR(50)
	)
	--
	CREATE TABLE #ERROR_M4126 (
		company_cd		SMALLINT
	,	question_no		TINYINT
	,	detail_no		SMALLINT
	)
	--
	SELECT  top 1
		@w_company_mc = ISNULL(M0001.company_cd,0)
	FROM M0001 
	WHERE 
		M0001.contract_company_attribute = 1
	AND M0001.del_datetime IS NULL
	--
	IF ISJSON(@P_json) <= 0
	BEGIN
		INSERT INTO @ERR_TBL VALUES(		
			22								-- mã lỗi (trùng với mã trong bảng message) 					
		,	''								-- id hoặc class của item(#id , .class), lỗi dạng dialog thì để trống  				
		,	0-- oderby						-- giá trị càng bé thì lỗi được hiển thị trước  				
		,	1-- dialog  					-- Kiểu hiển thị lối : 0. tooltip , 1.dialog 				
		,	0								-- Tùy ý : có thể lưu vị trí index của dòng của lỗi 				
		,	0								-- Tùy ý
		,	'json format'					-- Comment nội dung lỗi (chủ yếu là dùng khi đọc code)
		)
	END
	--INSERT INTO #DATA_TMP
	SELECT
		@w_report_kind		=	ISNULL(JSON_VALUE(@P_json,'$.report_kind'),0)
	,	@w_question_no		=	ISNULL(JSON_VALUE(@P_json,'$.question_no'),-1)
	,	@w_question_title	=	ISNULL(JSON_VALUE(@P_json,'$.question_title'),'')
	,	@w_question			=	ISNULL(JSON_VALUE(@P_json,'$.question'),'')
	,	@w_answer_kind		=	ISNULL(JSON_VALUE(@P_json,'$.answer_kind'),0)
	,	@w_item_digits		=	ISNULL(JSON_VALUE(@P_json,'$.item_digits'),0)
	,	@w_answer_kbn		=	ISNULL(JSON_VALUE(@P_json,'$.answer_kbn'),0)
	,	@w_arrange_order	=	ISNULL(JSON_VALUE(@P_json,'$.arrange_order'),0)	
	,	@w_company_cd_refer	=	ISNULL(JSON_VALUE(@P_json,'$.company_cd_refer'),-1)	
	FROM OPENJSON(@P_json)
	--
	IF(@P_company_cd <> @w_company_mc AND @w_company_cd_refer = @w_company_mc)
	BEGIN
		SET @w_refer_kbn			= 1
		SET @w_refer_question_no	= IIF(@w_question_no = -1, 0, @w_question_no)
		SET @w_question_no			= -1
	END
	--#M4126_TMP
	INSERT INTO #M4126_TMP
	SELECT 
		@P_company_cd
	,	IIF(@w_question_no = -1, 0, @w_question_no)		
	,	detail_no
	,	detail_name
	FROM OPENJSON(@P_json, '$.m4126') WITH(
			detail_no					SMALLINT
		,	detail_name					NVARCHAR(50)
	)
	--INSERT INTO #ERROR_M0081
	INSERT INTO #ERROR_M4126
	SELECT 
		company_cd
	,	question_no
	,	detail_no
	FROM #M4126_TMP 
	GROUP BY #M4126_TMP.detail_no,company_cd,question_no	 HAVING COUNT(detail_no) > 1 
	IF NOT EXISTS(SELECT 1 FROM #M4126_TMP) AND @w_answer_kind = 3 
	BEGIN
		INSERT INTO @ERR_TBL
		SELECT 
			29
		,	''
		,	0
		,	1 -- exception error
		,	0
		,	0
		,	'no row in table question'
	END
	--INSERT INTO @ERR_TBL
	INSERT INTO @ERR_TBL 
	SELECT 
		32
	,	'.detail_no'
	,	0
	,	3
	,	#M4126_TMP.id
	,	#M4126_TMP.id
	,	'32_明細が重複しています'
	FROM #ERROR_M4126
	LEFT JOIN #M4126_TMP ON (
		#ERROR_M4126.company_cd		= #M4126_TMP.company_cd
	AND #ERROR_M4126.question_no	= #M4126_TMP.question_no
	AND #ERROR_M4126.detail_no		= #M4126_TMP.detail_no
	)
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		--
		IF NOT EXISTS (SELECT 1 FROM @ERR_TBL)
		BEGIN		
			--#M4125_TMP
			INSERT INTO #M4125_TMP
			SELECT 
				@P_company_cd
			,	@w_report_kind		
			,	IIF(@w_question_no = -1, 0, @w_question_no)	
			,	@w_question_title	
			,	@w_question			
			,	@w_answer_kind		
			,	@w_item_digits		
			,	@w_answer_kbn	
			,	@w_refer_kbn
			,	@w_refer_question_no
			,	@w_arrange_order	
			--
			SET @w_max_question_no			=	(SELECT ISNULL(MAX(question_no),0) FROM M4125 WHERE company_cd = @P_company_cd) 
			--SAVE m4125
			UPDATE M4125
			SET 
				company_cd				=	@P_company_cd
			,	report_kind				=	#M4125_TMP.report_kind				
			,	question_no				=	#M4125_TMP.question_no			
			,	question_title			=	#M4125_TMP.question_title			
			,	question				=	#M4125_TMP.question					
			,	answer_kind				=	#M4125_TMP.answer_kind					
			,	answer_digits			=	#M4125_TMP.answer_digits			
			,	answer_kbn				=	#M4125_TMP.answer_kbn				
			--,	refer_kbn				=	#M4125_TMP.refer_kbn				
			--,	refer_question_no		=	#M4125_TMP.refer_question_no	
			,	arrange_order			=	#M4125_TMP.arrange_oder		
			,	upd_user				=	@P_cre_user
			,	upd_ip					=	@P_cre_ip
			,	upd_prg					=	'rM0100'
			,	upd_datetime			=	@w_time
			,	del_user				=	''
			,	del_ip					=	''
			,	del_prg					=	''
			,	del_datetime			=	NULL
			FROM M4125 
			INNER JOIN #M4125_TMP ON(
				M4125.company_cd		= @P_company_cd 
			AND M4125.report_kind		= #M4125_TMP.report_kind 
			AND M4125.question_no		= #M4125_TMP.question_no
			)
			WHERE
				@w_question_no <> -1					
			--
			INSERT INTO M4125
			SELECT 
				@P_company_cd
			,	#M4125_TMP.report_kind		
			,	IIF(@w_question_no = -1, @w_max_question_no + 1, @w_question_no)						
			,	#M4125_TMP.question_title	
			,	#M4125_TMP.question			
			,	#M4125_TMP.answer_kind		
			,	#M4125_TMP.answer_digits	
			,	#M4125_TMP.answer_kbn		
			,	#M4125_TMP.refer_kbn		
			,	#M4125_TMP.refer_question_no
			,	#M4125_TMP.arrange_oder		
			,	@P_cre_user
			,	@P_cre_ip
			,	'rM0100'
			,	@w_time
			,	''
			,	''
			,	''
			,	NULL
			,	''
			,	''
			,	''
			,	NULL
			FROM #M4125_TMP 
			LEFT JOIN M4125 ON(
					@P_company_cd			=	M4125.company_cd
			AND  #M4125_TMP.report_kind		=	M4125.report_kind
			AND  #M4125_TMP.question_no		=	M4125.question_no
			)
			WHERE  
				M4125.company_cd	IS  NULL
			OR  @w_question_no		= -1
			--SAVE m4126
			IF(@w_answer_kind = 3)
			BEGIN
				--del m4126
				UPDATE M4126
				SET 
					del_user				=	@P_cre_user
				,	del_ip					=	@P_cre_ip
				,	del_prg					=	'rM0100'
				,	del_datetime			=	@w_time
				FROM M4126 
				WHERE
					@w_question_no			<> -1
				AND	M4126.company_cd		= @P_company_cd 
				AND M4126.question_no		= @w_question_no
				AND M4126.del_datetime IS NULL
				--update m4126	
				UPDATE M4126
				SET 
					company_cd				=	@P_company_cd			
				,	question_no				=	#M4126_TMP.question_no			
				,	detail_no				=	#M4126_TMP.detail_no			
				,	detail_name				=	#M4126_TMP.deltail_name						
				,	upd_user				=	@P_cre_user
				,	upd_ip					=	@P_cre_ip
				,	upd_prg					=	'rM0100'
				,	upd_datetime			=	@w_time
				,	del_user				=	''
				,	del_ip					=	''
				,	del_prg					=	''
				,	del_datetime			=	NULL
				FROM M4126 
				INNER JOIN #M4126_TMP ON(
					M4126.company_cd		= @P_company_cd 
				AND M4126.question_no		= #M4126_TMP.question_no
				AND M4126.detail_no			= #M4126_TMP.detail_no
				)
				WHERE
					@w_question_no <> -1	
				--
				INSERT INTO M4126
				SELECT 
					@P_company_cd	
				,	IIF(@w_question_no = -1, @w_max_question_no + 1, @w_question_no)						
				,	#M4126_TMP.detail_no	
				,	#M4126_TMP.deltail_name		
				,	@P_cre_user
				,	@P_cre_ip
				,	'rM0100'
				,	@w_time
				,	''
				,	''
				,	''
				,	NULL
				,	''
				,	''
				,	''
				,	NULL
				FROM #M4126_TMP
				LEFT JOIN M4126 ON(
						@P_company_cd			=	M4126.company_cd
				AND  #M4126_TMP.question_no		=	M4126.question_no
				AND  #M4126_TMP.detail_no		=	M4126.detail_no
				)
				WHERE  
					M4126.company_cd IS NULL
		  END
		END
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