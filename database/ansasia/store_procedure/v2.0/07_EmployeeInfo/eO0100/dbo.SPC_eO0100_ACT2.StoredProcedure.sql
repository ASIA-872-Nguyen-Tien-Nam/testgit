DROP PROCEDURE [SPC_eO0100_ACT2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	
--*  
--*  作成日/create date			:	2024/04/11
--*　作成者/creater				:	manhnd						
--*  作成内容/create content		:	import eo0100					
--*	 更新日/update date			:  	
--*	 更新者/updater				:　 
--*	 更新内容/update content	:	
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_eO0100_ACT2]
	-- Add the parameters for the stored procedure here
	@P_json									NVARCHAR(MAX)		=	N''
,	@P_exec_user							NVARCHAR(100)		=	N''
,	@P_company_cd							SMALLINT			=	0	
,	@P_cre_user								NVARCHAR(50)		=	N''
,	@P_cre_ip								NVARCHAR(50)		=	N''
,	@P_no									INT					=	0
,	@P_count								INT					=	0
,	@P_language								NVARCHAR(2)			=	N''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 	
		@w_time								DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL							ERRTABLE	
	,	@w_order_by_min						INT					=	0
	,	@w_max_training_cd					INT					=	0
	--
	CREATE TABLE #TBL_M5030 (
		id									INT					IDENTITY(1,1)
	,	exec_user							NVARCHAR(100)
	,	company_cd							SMALLINT
	,	training_cd							NVARCHAR(100)
	,	training_nm							NVARCHAR(100)
	,	training_ab_nm						NVARCHAR(100)
	,	training_category_cd				NVARCHAR(100)
	,	training_course_format_cd			NVARCHAR(100)
	,	editable_kbn						NVARCHAR(100)
	,	arrange_order						NVARCHAR(100)
	)
	-- GET DATA
	INSERT INTO #TBL_M5030
	SELECT
		@P_exec_user + '_' + CAST(@P_no AS NVARCHAR(10))
	,	@P_company_cd
	,	IIF(JSON_VALUE(@P_json,'$.training_cd') = N'', '0', JSON_VALUE(@P_json,'$.training_cd'))		
	,	JSON_VALUE(@P_json,'$.training_nm')		
	,	JSON_VALUE(@P_json,'$.training_ab_nm')		
	,	JSON_VALUE(@P_json,'$.training_category_cd')		
	,	JSON_VALUE(@P_json,'$.training_course_format_cd')		
	,	JSON_VALUE(@P_json,'$.editable_kbn')			
	,	JSON_VALUE(@P_json,'$.arrange_order')		
	FROM OPENJSON(@P_json) WITH (
		training_cd					NVARCHAR(100)
	,	training_nm					NVARCHAR(100)
	,	training_ab_nm				NVARCHAR(100)
	,	training_category_cd		NVARCHAR(100)
	,	training_course_format_cd	NVARCHAR(100)
	,	editable_kbn				NVARCHAR(100)
	,	arrange_order				NVARCHAR(100)
	)
	
	SET @w_max_training_cd = (SELECT ISNULL(MAX(M5030.training_cd),0)+@P_no FROM M5030 WHERE M5030.company_cd = @P_company_cd)

	--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
	--VALIDATE
	--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
	IF ISJSON(@P_json) <= 0
	BEGIN
		INSERT INTO @ERR_TBL VALUES (		
			22						-- mã lỗi (trùng với mã trong bảng message) 					
		,	N''						-- id hoặc class của item(#id , .class), lỗi dạng dialog thì để trống  				
		,	0-- oderby				-- giá trị càng bé thì lỗi được hiển thị trước  				
		,	1-- dialog  			-- Kiểu hiển thị lối : 0. tooltip , 1.dialog 				
		,	0						-- Tùy ý : có thể lưu vị trí index của dòng của lỗi 				
		,	0						-- Tùy ý
		,	N'json format'			-- Comment nội dung lỗi (chủ yếu là dùng khi đọc code)
		)
	END

	--VALIDATE MAXLENGTH
	--VALIDATE MAXLENGTH training_nm 
	INSERT INTO @ERR_TBL
	SELECT
		28				
	,	N'training_nm'				
	,	0				
	,	1				
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Training name','研修名')	
	FROM #TBL_M5030 
	WHERE
		LEN(training_nm) > 50
	--VALIDATE REQUIRED training_nm
	INSERT INTO @ERR_TBL
	SELECT
		8			
	,	N'training_nm'				
	,	0				
	,	1				
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Training name','研修名')	
	FROM #TBL_M5030 
	WHERE
		training_nm = ''

	--VALIDATE MAXLENGTH training_ab_nm 
	INSERT INTO @ERR_TBL
	SELECT
		28				
	,	N'training_ab_nm'				
	,	0				
	,	1				
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Training name abbreviation','研修名略称')	
	FROM #TBL_M5030 
	WHERE
		LEN(training_ab_nm) > 20
	
	--VALIDATE NUMBER
	--VALIDATE NUMBER training_cd
	IF EXISTS (	SELECT 1 
				FROM #TBL_M5030
				WHERE
					#TBL_M5030.training_cd LIKE '%[^0-9]%'
	)
	BEGIN
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	N'training_cd'				
		,	0
		,	1
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Training code','研修コード')	
		
		INSERT INTO @ERR_TBL
		SELECT
			161
		,	N'training_cd'				
		,	0
		,	1
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Training code','研修コード')	
	END	

	--INSERT INTO @ERR_TBL
	--SELECT
	--	11				
	--,	N'training_cd'				
	--,	0
	--,	1
	--,	0				
	--,	0				
	--,	IIF(@P_language = 'en','Training code','研修コード')	
	--FROM #TBL_M5030 
	--WHERE
	--	#TBL_M5030.training_cd LIKE '%[^0-9]%'
	--VALIDATE MAXLENGTH NUMBER training_cd
	INSERT INTO @ERR_TBL
	SELECT
		28				
	,	N'training_cd'				
	,	0				
	,	1				
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Training code','研修コード')	
	FROM #TBL_M5030
	WHERE
		LEN(training_cd) > 4
	
	--VALIDATE NUMBER training_category_cd
	INSERT INTO @ERR_TBL
	SELECT
		11				
	,	N'training_category_cd'				
	,	0
	,	1
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Training category code','研修カテゴリー')		
	FROM #TBL_M5030 
	WHERE
		#TBL_M5030.training_category_cd LIKE '%[^0-9]%'
	--VALIDATE MAXLENGTH NUMBER training_category_cd
	INSERT INTO @ERR_TBL
	SELECT
		28				
	,	N'training_category_cd'				
	,	0				
	,	1				
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Training category code','研修カテゴリー')	
	FROM #TBL_M5030
	WHERE
		LEN(training_category_cd) > 4

	-- VALIDATE training_category_cd NOT IN M5031
	IF NOT EXISTS (	SELECT 1
					FROM #TBL_M5030
					WHERE
						training_category_cd = '0'
					OR	training_category_cd = ''
	)
	BEGIN
		IF NOT EXISTS ( SELECT 1
						FROM #TBL_M5030
						INNER JOIN M5031 ON (
							#TBL_M5030.company_cd			= M5031.company_cd
						AND #TBL_M5030.training_category_cd = M5031.training_category_cd
						)
						WHERE
							M5031.company_cd = @P_company_cd
						AND M5031.del_datetime IS NULL 
						AND #TBL_M5030.training_category_cd NOT LIKE '%[^0-9]%'
		)
		BEGIN 
			INSERT INTO @ERR_TBL
			SELECT
				70				
			,	N'training_category_cd'				
			,	0				
			,	1				
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Training category code','研修カテゴリー')	
		END
	END
	

	--VALIDATE NUMBER training_course_format_cd
	INSERT INTO @ERR_TBL
	SELECT
		11				
	,	N'training_course_format_cd'				
	,	0
	,	1
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Training course format code','受講形式')				
	FROM #TBL_M5030 
	WHERE
		#TBL_M5030.training_course_format_cd LIKE '%[^0-9]%'
	--VALIDATE MAXLENGTH NUMBER training_course_format_cd
	INSERT INTO @ERR_TBL
	SELECT
		28				
	,	N'training_course_format_cd'				
	,	0				
	,	1				
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Training course format code','受講形式')		
	FROM #TBL_M5030
	WHERE
		LEN(training_course_format_cd) > 4

	-- VALIDATE training_course_format_cd NOT IN M5032
	IF NOT EXISTS (	SELECT 1
					FROM #TBL_M5030
					WHERE
						training_course_format_cd = '0'
					OR	training_course_format_cd = ''
	)
	BEGIN
		IF NOT EXISTS ( SELECT 1
						FROM #TBL_M5030
						INNER JOIN M5032 ON (
							#TBL_M5030.company_cd		= M5032.company_cd
						AND #TBL_M5030.training_course_format_cd = M5032.training_course_format_cd
						)
						WHERE
							M5032.company_cd = @P_company_cd
						AND M5032.del_datetime IS NULL 
						AND #TBL_M5030.training_course_format_cd NOT LIKE '%[^0-9]%'
		)
		BEGIN 
			INSERT INTO @ERR_TBL
			SELECT
				70				
			,	N'training_course_format_cd'				
			,	0				
			,	1				
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Training course format code','受講形式')		
		END
	END

	--VALIDATE NUMBER editable_kbn
	INSERT INTO @ERR_TBL
	SELECT
		11				
	,	N'editable_kbn'				
	,	0
	,	1
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Change category','変更区分')					
	FROM #TBL_M5030 
	WHERE
		#TBL_M5030.editable_kbn LIKE '%[^0-9]%'
	--VALIDATE MAXLENGTH NUMBER editable_kbn
	INSERT INTO @ERR_TBL
	SELECT
		28				
	,	N'editable_kbn'				
	,	0				
	,	1				
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Change category','変更区分')		
	FROM #TBL_M5030
	WHERE
		LEN(editable_kbn) > 4
	--VALIDATE ONLY (0,1)
	INSERT INTO @ERR_TBL
	SELECT
		70				
	,	N'editable_kbn'				
	,	0				
	,	1				
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Change category','変更区分')		
	FROM #TBL_M5030
	WHERE
		editable_kbn NOT IN('0','1','')


	--VALIDATE NUMBER arrange_order
	INSERT INTO @ERR_TBL
	SELECT
		11				
	,	N'arrange_order'				
	,	0
	,	1
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Sort order','並び順')				
	FROM #TBL_M5030 
	WHERE
		#TBL_M5030.arrange_order LIKE '%[^0-9]%'
	--VALIDATE MAXLENGTH NUMBER arrange_order
	INSERT INTO @ERR_TBL
	SELECT
		28				
	,	N'arrange_order'				
	,	0				
	,	1				
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Sort order','並び順')
	FROM #TBL_M5030
	WHERE
		LEN(arrange_order) > 4

	--Khi 資格コード không là blank hoặc 0, nếu chưa được đăng kí ở master 資格マスタ thì báo lỗi
	IF EXISTS (SELECT 1 FROM #TBL_M5030 WHERE training_cd <> '0' AND training_cd NOT LIKE '%[^0-9]%')
	BEGIN 
		IF NOT EXISTS (	SELECT 1
						FROM #TBL_M5030
						INNER JOIN M5030 ON (
							#TBL_M5030.company_cd		=	M5030.company_cd
						AND #TBL_M5030.training_cd		=	M5030.training_cd
						)
						WHERE
							#TBL_M5030.training_cd <> 0
						AND M5030.del_datetime IS NULL
		)
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				161				
			,	N'training_cd'				
			,	0
			,	1
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Training code','研修コード')
		END
	END

	-- START TRANSACTION 
	BEGIN TRANSACTION
	BEGIN TRY
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- PROCESS
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		IF NOT EXISTS (SELECT 1 FROM @ERR_TBL)
		BEGIN
			DELETE W
			FROM WRK_M5030 AS W 
			LEFT JOIN #TBL_M5030 ON (
				W.company_cd		=	@P_company_cd
			AND W.exec_user	=	#TBL_M5030.exec_user
			)
			WHERE
				#TBL_M5030.company_cd IS NOT NULL

			-- UPDATE QUALIFICATION_CD IF VALUE = 0
			UPDATE #TBL_M5030 SET
				training_cd	=	@w_max_training_cd
			FROM #TBL_M5030
			WHERE
				training_cd	=	0

			-- CASE INSERT
			INSERT INTO WRK_M5030 
			SELECT 
				#TBL_M5030.exec_user
			,	#TBL_M5030.company_cd
			,	#TBL_M5030.training_cd		
			,	#TBL_M5030.training_nm	
			,	#TBL_M5030.training_ab_nm	
			,	#TBL_M5030.training_category_cd
			,	#TBL_M5030.training_course_format_cd
			,	#TBL_M5030.editable_kbn
			,	#TBL_M5030.arrange_order
			,	@P_cre_user			
			,	@P_cre_ip	
			,	N'eO0100'		
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL
			FROM #TBL_M5030
		END
		ELSE
		BEGIN
			INSERT INTO WRK_M5030 
			SELECT 
				CONCAT('WRK_M5030_', CAST(@P_no AS NVARCHAR(10)))
			,	company_cd
			,	0				
			,	''	
			,	''	
			,	0
			,	0
			,	0
			,	0
			,	@P_cre_user			
			,	@P_cre_ip	
			,	'eO0100'		
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			FROM #TBL_M5030
		END

		IF @P_no = @P_count - 1
		BEGIN 
			IF (EXISTS(SELECT 1 FROM @ERR_TBL) OR EXISTS(SELECT 1 FROM WRK_M5030 WHERE exec_user LIKE '%WRK_M5030%'))
			BEGIN
				TRUNCATE TABLE WRK_M5030
				--
				GOTO COMPLETE_QUERY
			END

			--REAL TABLE
			UPDATE M5030 SET
				M5030.training_nm				=	WRK_M5030.training_nm
			,	M5030.training_ab_nm			=	WRK_M5030.training_ab_nm
			,	M5030.training_category_cd		=	WRK_M5030.training_category_cd
			,	M5030.training_course_format_cd	=	WRK_M5030.training_course_format_cd
			,	M5030.editable_kbn				=	WRK_M5030.editable_kbn
			,	M5030.arrange_order				=	WRK_M5030.arrange_order
			,	M5030.upd_user					=	@P_cre_user	
			,	M5030.upd_ip					=	@P_cre_ip		
			,	M5030.upd_prg					=	N'eO0100'		
			,	M5030.upd_datetime				=	@w_time		
			FROM WRK_M5030
			INNER JOIN M5030 ON (
				WRK_M5030.company_cd			=	M5030.company_cd
			AND WRK_M5030.training_cd			=	M5030.training_cd
			)

			INSERT INTO M5030
			SELECT 
				WRK_M5030.company_cd
			,	WRK_M5030.training_cd
			,	WRK_M5030.training_nm
			,	WRK_M5030.training_ab_nm
			,	WRK_M5030.training_category_cd
			,	WRK_M5030.training_course_format_cd
			,	WRK_M5030.editable_kbn
			,	WRK_M5030.arrange_order
			,	@P_cre_user			
			,	@P_cre_ip	
			,	N'eO0100'		
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			FROM WRK_M5030
			LEFT OUTER JOIN M5030 ON (
				WRK_M5030.company_cd			=	M5030.company_cd
			AND WRK_M5030.training_cd			=	M5030.training_cd
			)
			WHERE 
				M5030.training_cd IS NULL	

			-- CLEAR			
			TRUNCATE TABLE WRK_M5030
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
	COMPLETE_QUERY:
	--
	IF EXISTS(SELECT 1 FROM @ERR_TBL AS ERR_TBL WHERE ERR_TBL.item = 'EXCEPTION')
	BEGIN
		IF @@TRANCOUNT >0
		BEGIN
			ROLLBACK TRANSACTION
		END
	END
	ELSE
	BEGIN
		COMMIT TRANSACTION
	END

	SELECT 
		@w_order_by_min = MIN(order_by)
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
	WHERE order_by = @w_order_by_min
	ORDER BY 
		order_by
END
GO
