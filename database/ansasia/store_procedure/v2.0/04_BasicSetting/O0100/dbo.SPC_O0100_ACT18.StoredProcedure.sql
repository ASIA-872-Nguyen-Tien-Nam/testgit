DROP PROCEDURE [SPC_O0100_ACT18]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   	
--*  処理概要/process overview	:	O0100 社員マスタ (有期雇用契約)
--*  
--*  作成日/create date			:	2024/04/11								
--*　作成者/creater				:	Quanlh								
--*   					
--*  更新日/update date			:  						
--*　更新者/updater				:　  　								     	 
--*　更新内容/update content	:
--* 					
--****************************************************************************************

CREATE PROCEDURE [SPC_O0100_ACT18]
	-- Add the parameters for the stored procedure here
	@P_json			NVARCHAR(MAX)	= N''
,	@P_exec_user	NVARCHAR(100)	= N''
,	@P_company_cd	SMALLINT		= 0	
,	@P_cre_user		NVARCHAR(50)	= N''
,	@P_cre_ip		NVARCHAR(50)	= N''
,	@P_no			INT				= 0
,	@P_count		INT				= 0
,	@P_language		NVARCHAR(2)		= N''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 	
		@w_time			DATETIME2	= SYSDATETIME()
	,	@order_by_min	INT			= 0
	,	@ERR_TBL		ERRTABLE	
	--
	CREATE TABLE #TEMP(
		id							INT		IDENTITY(1,1)
	,	exec_user					NVARCHAR(100)
	,	company_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	employment_contract_no		NVARCHAR(50)
	,	detail_no					NVARCHAR(50)
	,	start_date					NVARCHAR(50)
	,	expiration_date				NVARCHAR(50)
	,	contract_renewal_kbn		NVARCHAR(50)
	,	reason_resignation			NVARCHAR(150)
	,	remarks						NVARCHAR(150)
	)
	-- START TRANSACTION 
	BEGIN TRANSACTION
	BEGIN TRY
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- VALIDATE
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		IF ISJSON(@P_json) <= 0
		BEGIN
			INSERT INTO @ERR_TBL VALUES(		
				22						-- mã lỗi (trùng với mã trong bảng message) 					
			,	N''						-- id hoặc class của item(#id , .class), lỗi dạng dialog thì để trống 			
			,	0-- oderby				-- giá trị càng bé thì lỗi được hiển thị trước  				
			,	1-- dialog  			-- Kiểu hiển thị lối : 0. tooltip , 1.dialog 				
			,	0						-- Tùy ý : có thể lưu vị trí index của dòng của lỗi 				
			,	0						-- Tùy ý
			,	N'json format'			-- Comment nội dung lỗi (chủ yếu là dùng khi đọc code)
			)
		END
		-- GET  TEMP
		INSERT INTO #TEMP
		SELECT
			CONCAT(@P_exec_user, CAST(@P_no AS NVARCHAR(10)))																		
		,	@P_company_cd															
		,	RTRIM(LTRIM(employee_cd))
		,	RTRIM(LTRIM(employment_contract_no))
		,	RTRIM(LTRIM(detail_no))
		,	RTRIM(LTRIM(start_date))
		,	RTRIM(LTRIM(expiration_date))											
		,	RTRIM(LTRIM(contract_renewal_kbn))
		,	RTRIM(LTRIM(reason_resignation))
		,	RTRIM(LTRIM(remarks))												
		FROM OPENJSON(@P_json) WITH(										
			employee_cd						NVARCHAR(50)
		,	employment_contract_no			NVARCHAR(50)
		,	detail_no						NVARCHAR(50)
		,	start_date						NVARCHAR(50)
		,	expiration_date					NVARCHAR(50)
		,	contract_renewal_kbn			NVARCHAR(50)	
		,	reason_resignation				NVARCHAR(150)
		,	remarks							NVARCHAR(150)
		)
		--------------------------------------------
		--VALIDATE MAXLENGHT employee_cd 							
		INSERT INTO @ERR_TBL												
		SELECT															
			28				
		,	N'employee_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Employee Code',N'社員コード')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.employee_cd)>10)
		--VALIDATE REQUIRED employee_cd 							
		INSERT INTO @ERR_TBL												
		SELECT															
			8				
		,	N'employee_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Employee Code',N'社員コード')	
		FROM #TEMP 
		WHERE
			(#TEMP.employee_cd = N'')
		--	--
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.employee_cd NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				151				
			,	N'employee_cd'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Employee Code',N'社員コード')	
			FROM #TEMP 
			WHERE
				#TEMP.employee_cd = 0
		END
		-- VALIDATE EXIST employee_cd IN M0070
		IF NOT EXISTS (
			SELECT 1 FROM #TEMP 
			INNER JOIN M0070 ON (
				M0070.company_cd = @P_company_cd
			AND	M0070.employee_cd = #TEMP.employee_cd
			AND M0070.del_datetime is NULL
			)
		)
		BEGIN
		INSERT INTO @ERR_TBL
		SELECT
			111				
		,	'employee_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Employee Code','社員コード')	
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT employment_contract_no
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'employment_contract_no'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Employment Contract No',N'雇用契約番号')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.employment_contract_no)>3)
		--VALIDATE NUMERIC employment_contract_no
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	N'employment_contract_no'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Employment Contract No',N'雇用契約番号')	
		FROM #TEMP 
		WHERE
			(#TEMP.employment_contract_no <> N'')
		AND (#TEMP.employment_contract_no LIKE '%[^0-9]%')
		--VALIDATE NUMERIC employment_contract_no < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.employment_contract_no NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	N'employment_contract_no'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Employment Contract No',N'雇用契約番号')
			FROM #TEMP 
			WHERE 
				(#TEMP.employment_contract_no NOT LIKE '%[^0-9]%')
			AND	(#TEMP.employment_contract_no < 0)
		END
		--	validate required employment_contract_no
		INSERT INTO @ERR_TBL
		SELECT
			8				
		,	N'employment_contract_no'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Employment Contract No',N'雇用契約番号')
		FROM #TEMP 
		WHERE
			#TEMP.employment_contract_no = ''
		-------------------------------------------------
		--VALIDATE MAXLENGHT detail_no
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'detail_no'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Detail No',N'明細番号')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.detail_no)>3)
		--VALIDATE NUMERIC detail_no
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	N'detail_no'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Detail No',N'明細番号')	
		FROM #TEMP 
		WHERE
			(#TEMP.detail_no <> N'')
		AND (#TEMP.detail_no LIKE '%[^0-9]%')
		--VALIDATE NUMERIC detail_no < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.detail_no NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	N'detail_no'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Detail No',N'明細番号')
			FROM #TEMP 
			WHERE 
				(#TEMP.detail_no NOT LIKE '%[^0-9]%')
			AND	(#TEMP.detail_no < 0)
		END
		--	validate detail_no = blank
		INSERT INTO @ERR_TBL
		SELECT
			8				
		,	N'detail_no'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Detail No',N'明細番号')
		FROM #TEMP 
		WHERE
			#TEMP.detail_no = ''
		--	validate detail_no = 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.detail_no NOT LIKE '%[^0-9]%' AND #TEMP.detail_no <> '')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	N'detail_no'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Detail No',N'明細番号')
			FROM #TEMP 
			WHERE
				#TEMP.detail_no = 0
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT  start_date							
		INSERT INTO @ERR_TBL												
		SELECT															
			28				
		,	N'start_date'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Start Date',N'雇用開始日')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.start_date)>10)	
		--VALIDATE DATE start_date
		INSERT INTO @ERR_TBL
		SELECT
			15				
		,	N'start_date'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Start Date',N'雇用開始日')	
		FROM #TEMP 
		WHERE
			(#TEMP.start_date <> N'')
		AND	(ISDATE(#TEMP.start_date)=0)
		--VALIDATE DATE start_date <  expiration_date	
		IF EXISTS (SELECT 1 FROM #TEMP WHERE (ISDATE(#TEMP.start_date)=1) AND (ISDATE(#TEMP.expiration_date)=1))
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				24				
			,	N'start_date'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Start Date',N'雇用開始日')		
			FROM #TEMP 
			WHERE
				CAST(#TEMP.start_date AS DATE) >= CAST(#TEMP.expiration_date AS DATE)
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT  	expiration_date						
		INSERT INTO @ERR_TBL												
		SELECT															
			28				
		,	N'expiration_date'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Expiration Date',N'雇用契約満了日')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.expiration_date)>10)	
		--VALIDATE DATE expiration_date
		INSERT INTO @ERR_TBL
		SELECT
			15				
		,	N'expiration_date'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Expiration Date',N'雇用契約満了日')	
		FROM #TEMP 
		WHERE
			(#TEMP.expiration_date <> N'')
		AND	(ISDATE(#TEMP.expiration_date)=0)
		--VALIDATE DATE start_date <  expiration_date	
		IF EXISTS (SELECT 1 FROM #TEMP WHERE (ISDATE(#TEMP.start_date)=1) AND (ISDATE(#TEMP.expiration_date)=1))
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				24				
			,	N'expiration_date'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Expiration Date',N'雇用契約満了日')		
			FROM #TEMP 
			WHERE
				CAST(#TEMP.start_date AS DATE) >= CAST(#TEMP.expiration_date AS DATE)
		END
		-------------------------------------------------
		-- VALIDATE EXIST contract_renewal_kbn IN L0010
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.contract_renewal_kbn NOT LIKE '%[^0-9]%')
		BEGIN
			IF NOT EXISTS (
				SELECT 1 FROM #TEMP 
				INNER JOIN L0010 ON (
					L0010.number_cd = #TEMP.contract_renewal_kbn
				AND L0010.name_typ = 76
				AND L0010.del_datetime is NULL
				)
			) AND NOT EXISTS (SELECT #TEMP.contract_renewal_kbn FROM #TEMP WHERE #TEMP.contract_renewal_kbn = '' OR #TEMP.contract_renewal_kbn IS NULL)
			BEGIN
				INSERT INTO @ERR_TBL
				SELECT
					70				
				,	N'contract_renewal_kbn'				
				,	0-- oderby		
				,	1-- dialog  	
				,	0				
				,	0				
				,	IIF(@P_language = N'en',N'Contract Renewal',N'契約更新の有無')	
			END
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT reason_resignation 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'reason_resignation'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Reason Resignation',N'退職理由')	
		FROM #TEMP 
		WHERE
			(LEN(reason_resignation)>100)
		-------------------------------------------------
		--VALIDATE MAXLENGHT remarks 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'remarks'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Remarks',N'備考')	
		FROM #TEMP 
		WHERE
			(LEN(remarks)>100)
		-------------------------------------------------
		--VALIDATE UNIQUE detail_no
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.detail_no NOT LIKE '%[^0-9]%' AND #TEMP.employment_contract_no NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				159			
			,	'detail_no'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Detail No','明細番号')	
			FROM #TEMP INNER JOIN WRK_M0088 ON(
				#TEMP.company_cd					= WRK_M0088.company_cd
			AND #TEMP.employee_cd					= WRK_M0088.employee_cd
			AND WRK_M0088.company_cd				= @P_company_cd
			AND WRK_M0088.employment_contract_no	= #TEMP.employment_contract_no
			AND WRK_M0088.detail_no					= #TEMP.detail_no
			)
		END

		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- PROCESS
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- Chổ nay dung de viet code xu ly du lieu sau khi validate xong
		--

		IF NOT EXISTS(SELECT 1 FROM @ERR_TBL)
		BEGIN
			DELETE W FROM  WRK_M0088 AS W LEFT JOIN  #TEMP AS T ON W.company_cd = @P_company_cd AND W.exec_user = T.exec_user  WHERE T.company_cd IS NOT NULL
			--
			INSERT INTO WRK_M0088 
			SELECT 
				#TEMP.exec_user
			,	#TEMP.company_cd
			,	#TEMP.employee_cd	
			,	#TEMP.employment_contract_no	
			,	#TEMP.detail_no						
			,	IIF(#TEMP.start_date = '', NULL, #TEMP.start_date )			
			,	IIF(#TEMP.expiration_date = '', NULL, #TEMP.expiration_date )	
			,	IIF(#TEMP.contract_renewal_kbn = '', 0, #TEMP.contract_renewal_kbn)	 	
			,	#TEMP.reason_resignation		
			,	#TEMP.remarks
			,	@P_cre_user			
			,	@P_cre_ip	
			,	N'O0100'		
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			FROM #TEMP
		END
		ELSE
		BEGIN
			DELETE W FROM  WRK_M0088 AS W LEFT JOIN  #TEMP AS T ON W.company_cd = @P_company_cd AND W.exec_user = T.exec_user  WHERE W.exec_user LIKE '%WRK_M0088_%'
			--
			INSERT INTO WRK_M0088 
			SELECT 
				CONCAT('WRK_M0088', CAST(@P_no AS NVARCHAR(10)))
			,	0
			,	N''								
			,	0	
			,	0			
			,	NULL	
			,	NULL
			,	0
			,	N''
			,	N''
			,	@P_cre_user			
			,	@P_cre_ip	
			,	N'O0100'		
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			FROM #TEMP
		END			
		

		IF (@P_no = @P_count) 
		BEGIN
			--
			IF (EXISTS(SELECT 1 FROM @ERR_TBL) OR EXISTS(SELECT 1 FROM WRK_M0088 WHERE exec_user LIKE '%WRK_M0088%'))
			BEGIN
				TRUNCATE TABLE WRK_M0088
				--
				GOTO COMPLETE_QUERY
			END

			-- UPDATE M0088
			UPDATE M0088
			SET 		
				start_date					=	WRK_M0088.start_date				
			,	expiration_date				=	WRK_M0088.expiration_date			
			,	contract_renewal_kbn		=	WRK_M0088.contract_renewal_kbn	
			,	reason_resignation			=	WRK_M0088.reason_resignation		
			,	remarks						=	WRK_M0088.remarks					
			,	upd_user					=	@P_cre_user		
			,	upd_ip						=	@P_cre_ip	
			,	upd_prg						=	N'O0100'	
			,	upd_datetime				=	@w_time	
			,	del_user					=	SPACE(0)
			,	del_ip						=	SPACE(0)
			,	del_prg						=	SPACE(0)
			,	del_datetime				=	NULL
			FROM M0088 
			INNER JOIN WRK_M0088 ON (
				M0088.company_cd				=	WRK_M0088.company_cd
			AND M0088.employee_cd				=	WRK_M0088.employee_cd
			AND M0088.detail_no					=	WRK_M0088.detail_no
			AND M0088.employment_contract_no	=	WRK_M0088.employment_contract_no
			AND WRK_M0088.company_cd			= @P_company_cd
			)		

			-- INSERT M0088
			INSERT INTO M0088
			SELECT  
				WRK_M0088.company_cd
			,	WRK_M0088.employee_cd
			,	WRK_M0088.employment_contract_no
			,	WRK_M0088.detail_no					
			,	WRK_M0088.start_date						
			,	WRK_M0088.expiration_date		
			,	WRK_M0088.contract_renewal_kbn		
			,	WRK_M0088.reason_resignation	
			,	WRK_M0088.remarks				
			,	@P_cre_user			
			,	@P_cre_ip	
			,	N'O0100'		
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL
			FROM WRK_M0088
			LEFT JOIN M0088 ON (
				M0088.company_cd				=	WRK_M0088.company_cd
			AND M0088.employee_cd				=	WRK_M0088.employee_cd
			AND M0088.detail_no					=	WRK_M0088.detail_no
			AND M0088.employment_contract_no	=	WRK_M0088.employment_contract_no
			)	
			WHERE 
				M0088.employee_cd IS NULL
			AND	WRK_M0088.employee_cd <> N''
			AND M0088.detail_no IS NULL
			AND	WRK_M0088.detail_no <> N''
			AND	WRK_M0088.employment_contract_no <> N''
			AND WRK_M0088.company_cd    = @P_company_cd
			--
			DELETE WRK_M0088
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
		,	N'EXCEPTION'
		,	0
		,	999 -- exception error
		,	0
		,	0
		,	N'Error'                                                          + CHAR(13) + CHAR(10) +
            N'Procedure : ' + ISNULL(ERROR_PROCEDURE(), '???')                + CHAR(13) + CHAR(10) +
            N'Line : '      + ISNULL(CAST(ERROR_LINE() AS NVARCHAR(10)), '0') + CHAR(13) + CHAR(10) +
            N'Message : '   + ISNULL(ERROR_MESSAGE(), 'An unexpected error occurred.')
	END CATCH
	COMPLETE_QUERY:
	--
	IF EXISTS(SELECT 1 FROM @ERR_TBL AS ERR_TBL WHERE ERR_TBL.item = N'EXCEPTION')
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
