DROP PROCEDURE [SPC_O0100_ACT9]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- 
--****************************************************************************************
--*   											
--*  ˆ—ŠT—v/process overview	:	O0100

--*  
--*  ì¬“ú/create date			:	2018/10/03										
--*@ì¬ŽÒ/creater				:	sondh@								
--*   					
--*  XV“ú/update date			:  	2018/10/06						
--*@XVŽÒ/updater				:@ tuantv @								     	 
--*@XV“à—e/update content		:	change processing import CR date 2018/10/31	@	
--****************************************************************************************
CREATE PROCEDURE [SPC_O0100_ACT9]
	-- Add the parameters for the stored procedure here
	@P_json						NVARCHAR(MAX) =	''
,	@P_exec_user				NVARCHAR(100) =	''
,	@P_company_cd				INT	  =	0	
,	@P_cre_user					NVARCHAR(50)  =	''
,	@P_cre_ip					NVARCHAR(50)  =	''
,	@P_no						INT			  =	0
,	@P_count					INT			  =	0
,	@P_language				NVARCHAR(2)			= ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 	
		@w_time					DATETIME2 = SYSDATETIME()
	,	@order_by_min			INT		  = 0
	,	@ERR_TBL				ERRTABLE  
	,	@old_pass				nvarchar(20) = ''
	--

	CREATE TABLE #TEMP(
		id						INT		IDENTITY(1,1)
	,	exec_user				NVARCHAR(50)
	,	company_cd				INT
	,	employee_cd				NVARCHAR(20)
	,	item_cd					NVARCHAR(20)
	,	item_nm					NVARCHAR(50)
	,	item_no					NVARCHAR(50)
	,	item_value				NVARCHAR(500)
	,	item_kind				INT
	,	item_value_kind_4_5		NVARCHAR(50)
	)
		
	-- START TRANSACTION 
	BEGIN TRANSACTION
	BEGIN TRY

		--šššššššššššššššššššššššššššššš
		-- VALIDATE
		--šššššššššššššššššššššššššššššš
		IF ISJSON(@P_json) <= 0
		BEGIN
			INSERT INTO @ERR_TBL VALUES(		
				22						-- mã lỗi (trùng với mã trong bảng message) 					
			,	''						-- id hoặc class của item(#id , .class), lỗi dạng dialog thì để trống 			
			,	0-- oderby				-- giá trị càng bé thì lỗi được hiển thị trước  				
			,	1-- dialog  			-- Kiểu hiển thị lối : 0. tooltip , 1.dialog 				
			,	0						-- Tùy ý : có thể lưu vị trí index của dòng của lỗi 				
			,	0						-- Tùy ý
			,	'json format'			-- Comment nội dung lỗi (chủ yếu là dùng khi đọc code)
			)
		END
		
		-- GET  DATA
		INSERT INTO #TEMP
		SELECT
			@P_exec_user 
		,	@P_company_cd
		,	RTRIM(LTRIM(employee_cd))		
		,	RTRIM(LTRIM(#TBL_JSON.item_cd))		
		,	RTRIM(LTRIM(#TBL_JSON.item_nm))	
		,	RTRIM(LTRIM(#TBL_JSON.item_no))		
		,	RTRIM(LTRIM(item_value))
		,	M0080.item_kind
		,	RTRIM(LTRIM(#TBL_JSON.item_value_kind_4_5))		
		FROM OPENJSON(@P_json) WITH(
			employee_cd				NVARCHAR(20)
		,	item_cd					NVARCHAR(20)
		,	item_nm					NVARCHAR(50)
		,	item_no					NVARCHAR(50)
		,	item_value				NVARCHAR(500)
		,	item_value_kind_4_5		NVARCHAR(50)
		) AS #TBL_JSON
		LEFT JOIN M0080 ON(
			@P_company_cd			= M0080.company_cd			
		AND RTRIM(LTRIM(#TBL_JSON.item_cd))	= CAST(M0080.item_cd AS VARCHAR)
		AND M0080.del_datetime IS NULL
		)
		--VALIDATE MAXLENGHT employee_cd 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'employee_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Employee Code','社員コード')	
		FROM #TEMP 
		WHERE
			(LEN(employee_cd)>10)
		--VALIDATE REQUIRED employee_cd 							
		INSERT INTO @ERR_TBL												
		SELECT															
			8				
		,	'employee_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Employee Code','社員コード')	
		FROM #TEMP 
		WHERE
			(#TEMP.employee_cd = '')
					--	--
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.employee_cd NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				151				
			,	'employee_cd'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Employee Code','社員コード')	
			FROM #TEMP 
			WHERE
				#TEMP.employee_cd = 0
		END
		--VALIDATE MAXLENGHT item_cd 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'item_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Item Code','項目コード')		
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.item_cd)>10)

		--VALIDATE REQUIRED item_cd 
		INSERT INTO @ERR_TBL
		SELECT
			8				
		,	'item_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Item Code','項目コード')		
		FROM #TEMP 
		WHERE
			(#TEMP.item_cd = '')
		--
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.item_cd LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				11				
			,	'item_cd'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Item Code','項目コード')		
			FROM #TEMP 
			WHERE
				(#TEMP.item_cd <> '')
		END	
		--
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.item_cd NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				151				
			,	'item_cd'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Item Code','項目コード')		
			FROM #TEMP 
			WHERE
				#TEMP.item_cd = 0
		END
		--VALIDATE MAXLENGHT character_item 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'character_item'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Character Item','文字項目')	
		FROM #TEMP  
		LEFT JOIN M0080 ON(
			@P_company_cd	=	M0080.company_cd
		AND	#TEMP.item_cd	=	M0080.item_cd
		)
		WHERE
			(LEN(#TEMP.item_value)>M0080.item_digits)
		AND #TEMP.item_kind = 1
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'pulldown_item'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Number Item','数字項目')	
		FROM #TEMP  
		LEFT JOIN M0080 ON(
			@P_company_cd	=	M0080.company_cd
		AND	#TEMP.item_cd	=	M0080.item_cd
		)
		WHERE
			((#TEMP.item_value_kind_4_5 like '%.%' AND #TEMP.item_value_kind_4_5 NOT LIKE '%[0-9]%.[0-9]')
		OR	((#TEMP.item_value_kind_4_5 like '%.%' AND LEN(REPLACE(REPLACE(#TEMP.item_value_kind_4_5,'.',''),'-',''))>9) OR(#TEMP.item_value_kind_4_5 NOT LIKE '%.%' AND (LEN(REPLACE(#TEMP.item_value_kind_4_5,'-',''))>=9)))
		)
		AND #TEMP.item_kind = 5

		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'select_item'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Number Item','数字項目')	
		FROM #TEMP  
		WHERE
			((#TEMP.item_value like '%.%' AND #TEMP.item_value NOT LIKE '%[0-9]%.[0-9]')
		OR	((#TEMP.item_value like '%.%' AND LEN(REPLACE(REPLACE(#TEMP.item_value,'.',''),'-',''))>9) OR(#TEMP.item_value NOT LIKE '%.%' AND (LEN(REPLACE(#TEMP.item_value,'-',''))>=9)))
		)
		AND #TEMP.item_kind = 4
		
		--VALIDATE MAXLENGHT number_item 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'number_item'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Number Item','数字項目')		
		FROM #TEMP 
		LEFT JOIN M0080 ON(
			@P_company_cd	=	M0080.company_cd
		AND	#TEMP.item_cd	=	M0080.item_cd
		AND M0080.item_kind = 2
		)
		WHERE
			(LEN(REPLACE(#TEMP.item_value,'.',''))>M0080.item_digits + 1)
		AND #TEMP.item_kind IN (2)
		--INSERT INTO @ERR_TBL
		--SELECT
		--	28				
		--,	'number_item'				
		--,	0-- oderby		
		--,	1-- dialog  	
		--,	0				
		--,	0				
		--,	IIF(@P_language = 'en','Number Item','数字項目')		
		--FROM #TEMP 
		--LEFT JOIN M0080 ON(
		--	@P_company_cd	=	M0080.company_cd
		--AND	#TEMP.item_cd	=	M0080.item_cd
		--)
		--WHERE
		--	(LEN(REPLACE(#TEMP.item_no,'.',''))>M0080.item_digits + 1)
		--AND #TEMP.item_kind = 4
		--VALIDATE NUMERIC number_item 
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	'number_item'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Number Item','数字項目')		
		FROM #TEMP 
		WHERE
			(#TEMP.item_value <> '') 
		AND (ISNUMERIC(#TEMP.item_value) = 0)
		AND #TEMP.item_kind IN (2)
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	'number_item'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Number Item','数字項目')		
		FROM #TEMP 
		WHERE
			(#TEMP.item_value_kind_4_5 <> '') 
		AND (ISNUMERIC(#TEMP.item_value_kind_4_5) = 0)
		AND #TEMP.item_kind IN (5)
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	'number_item'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Number Item','数字項目')		
		FROM #TEMP 
		WHERE
			(#TEMP.item_value <> '') 
		AND (ISNUMERIC(#TEMP.item_value) = 0)
		AND #TEMP.item_kind IN (4)
		--VALIDATE NUMERIC number_item < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE ISNUMERIC(#TEMP.item_value) =1 AND #TEMP.item_kind IN (2,4) AND LEN(REPLACE(#TEMP.item_value,'.',''))<=8)
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	'number_item'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Number Item','数字項目')	
			FROM #TEMP 
			WHERE 
				(#TEMP.item_value NOT LIKE '%[^0-9]%')
			AND	(CAST(#TEMP.item_value AS NUMERIC(9,1)) < 0)
			AND #TEMP.item_kind IN (2,4)
		END
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.item_value_kind_4_5 NOT LIKE '%[^0-9]%' AND #TEMP.item_kind IN (5) AND LEN(REPLACE(#TEMP.item_value_kind_4_5,'.',''))<=8)
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	'number_item'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Number Item','数字項目')	
			FROM #TEMP 
			WHERE 
				(#TEMP.item_value_kind_4_5 NOT LIKE '%[^0-9]%')
			AND	(#TEMP.item_value_kind_4_5 < 0)
			AND #TEMP.item_kind IN (5)
		END

		--VALIDATE DATE date_item
		INSERT INTO @ERR_TBL
		SELECT
			15				
		,	'date_item'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Date Item','日付項目')
		FROM #TEMP 
		WHERE
			(#TEMP.item_value <> '')
		AND	(ISDATE(#TEMP.item_value)=0)
		AND #TEMP.item_kind = 3
		--
		--
		INSERT INTO @ERR_TBL
		SELECT
			111			
		,	'employee_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Employee Code','社員コード')	
		FROM #TEMP LEFT JOIN M0070 ON(
			@P_company_cd		=	M0070.company_cd
		AND #TEMP.employee_cd	=	M0070.employee_cd
		AND M0070.del_datetime IS NULL
		)
		WHERE M0070.company_cd IS NULL 
		AND #TEMP.employee_cd	<> '0' 
		AND #TEMP.employee_cd	<> ''

		--
		INSERT INTO @ERR_TBL
		SELECT
			112		
		,	'item_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Item Code','項目コード')	
		FROM #TEMP LEFT JOIN M0080 ON(
			@P_company_cd			=	M0080.company_cd
		AND #TEMP.item_cd			=	CAST(M0080.item_cd AS VARCHAR)
		AND M0080.del_datetime IS NULL
		)
		WHERE M0080.company_cd IS NULL 
		AND #TEMP.item_cd	<> '0' 
		AND #TEMP.item_cd	<> ''
		IF NOT EXISTS(SELECT 1 FROM @ERR_TBL)
		BEGIN
		DELETE W FROM  WRK_M0072 AS W INNER JOIN  #TEMP AS T ON W.company_cd = @P_company_cd AND W.exec_user = T.exec_user 
			INSERT INTO WRK_M0072 
			SELECT 
				#TEMP.exec_user								
			,	#TEMP.company_cd
			,	#TEMP.employee_cd
			,	#TEMP.item_cd
			,	#TEMP.item_no
			,	CASE WHEN #TEMP.item_kind = 1  THEN #TEMP.item_value
					 ELSE ''
				END
			,	CASE WHEN #TEMP.item_kind IN (2,4)  THEN   CAST(NULLIF(REPLACE(#TEMP.item_value,'.0',''),'') AS MONEY)
					WHEN #TEMP.item_kind = 5  THEN   CAST(NULLIF(REPLACE(#TEMP.item_value_kind_4_5,'.0',''),'') AS MONEY)
					 ELSE 0
				END		
			,	CASE WHEN #TEMP.item_kind = 3  THEN NULLIF(#TEMP.item_value,'')
					 ELSE NULL
				END
			,	@P_cre_user		
			,	@P_cre_ip	
			,	'o0100'
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	'o0100'
			,	NULL	
			,	SPACE(0)
			,	SPACE(0)
			,	'o0100'
			,	NULL	
			FROM #TEMP
		END
		ELSE
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM WRK_M0072
			WHERE WRK_M0072.exec_user NOT LIKE '%'+CONCAT('WRK_M0072', CAST(@P_no AS NVARCHAR(10)))+'%')
			BEGIN
				INSERT INTO WRK_M0072 
				SELECT 
					CONCAT('WRK_M0072', CAST(@P_no AS NVARCHAR(10)))
				,	0
				,	''
				,	''
				,	''
				,	''
				,	0		
				,	NULL
				,	@P_cre_user		
				,	@P_cre_ip
				,	'o0100'
				,	@w_time
				,	SPACE(0)
				,	SPACE(0)
				,	'o0100'
				,	NULL	
				,	SPACE(0)
				,	SPACE(0)
				,	'o0100'
				,	NULL
			END
		END
		IF (@P_no = @P_count) 
		BEGIN
			--
			IF (EXISTS(SELECT 1 FROM @ERR_TBL) OR EXISTS(SELECT 1 FROM WRK_M0072 WHERE exec_user LIKE '%WRK_M0072%'))
			BEGIN
				TRUNCATE TABLE WRK_M0072
				--
				GOTO COMPLETE_QUERY
			END
			--
			UPDATE M0072
			SET
				character_item		=	WRK_M0072.character_item
			,	number_item			=	WRK_M0072.number_item	
			,	date_item			=	WRK_M0072.date_item
			,	upd_user			=	@P_cre_user
			,	upd_ip				=	@P_cre_ip
			,	upd_prg				=	'O0100'
			,	upd_datetime		=	@w_time
			,	del_user			=	SPACE(0)
			,	del_ip				=	SPACE(0)
			,	del_prg				=	SPACE(0)
			,	del_datetime		=	NULL
			FROM M0072
			INNER JOIN WRK_M0072 ON (
				M0072.company_cd		=		WRK_M0072.company_cd
			AND M0072.employee_cd		=		WRK_M0072.employee_cd
			AND M0072.item_cd			=		WRK_M0072.item_cd
			AND M0072.item_no			=		WRK_M0072.item_no
			)
			WHERE
				WRK_M0072.employee_cd <> ''
			--
			INSERT INTO M0072
			SELECT 
				WRK_M0072.company_cd
			,	WRK_M0072.employee_cd
			,	WRK_M0072.item_cd
			,	WRK_M0072.item_no
			,	WRK_M0072.character_item
			,	WRK_M0072.number_item	
			,	WRK_M0072.date_item
			,	@P_cre_user			
			,	@P_cre_ip
			,	'O0100'			
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			FROM WRK_M0072
			LEFT JOIN M0072 ON (
				M0072.company_cd		=		WRK_M0072.company_cd
			AND M0072.employee_cd		=		WRK_M0072.employee_cd
			AND M0072.item_cd			=		WRK_M0072.item_cd
			AND M0072.item_no			=		WRK_M0072.item_no
			)
			WHERE 
				M0072.employee_cd IS NULL
			AND	WRK_M0072.employee_cd <> ''

			--
			TRUNCATE TABLE WRK_M0072
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
