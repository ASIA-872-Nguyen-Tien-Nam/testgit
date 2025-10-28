DROP PROCEDURE [SPC_O0100_ACT19]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   	
--
--*  処理概要/process overview	:	O0100 社員マスタ (社会保険)
--*  
--*  作成日/create date			:	2024/04/12							
--*　作成者/creater				:	Quanlh								
--*   					
--*  更新日/update date			:  						
--*　更新者/updater				:　  　								     	 
--*　更新内容/update content	:
--* 					
--****************************************************************************************

CREATE PROCEDURE [SPC_O0100_ACT19]
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
		id										INT		IDENTITY(1,1)
	,	exec_user								NVARCHAR(100)
	,	company_cd								SMALLINT
	,	employee_cd								NVARCHAR(50)
	,	detail_no								NVARCHAR(20)
	,	employment_insurance_no					NVARCHAR(50)
	,	basic_pension_no						NVARCHAR(50)
	,	employment_insurance_status				NVARCHAR(50)
	,	health_insurance_status					NVARCHAR(50)
	,	health_insurance_reference_no			NVARCHAR(100)
	,	employees_pension_insurance_status		NVARCHAR(50)
	,	employees_pension_reference_no			NVARCHAR(100)
	,	welfare_pension_status					NVARCHAR(50)
	,	employees_pension_member_no				NVARCHAR(100)
	,	social_insurance_kbn					NVARCHAR(20)
	,	joining_date							NVARCHAR(50)
	,	date_of_loss							NVARCHAR(50)
	,	reason_for_loss_kbn						NVARCHAR(50)
	,	reason_for_loss							NVARCHAR(200)
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
		,	RTRIM(LTRIM(detail_no))
		,	RTRIM(LTRIM(employment_insurance_no))				
		,	RTRIM(LTRIM(basic_pension_no))												
		,	RTRIM(LTRIM(employment_insurance_status))											
		,	RTRIM(LTRIM(health_insurance_status))				
		,	RTRIM(LTRIM(health_insurance_reference_no))		
		,	RTRIM(LTRIM(employees_pension_insurance_status))	
		,	RTRIM(LTRIM(employees_pension_reference_no))		
		,	RTRIM(LTRIM(welfare_pension_status))				
		,	RTRIM(LTRIM(employees_pension_member_no))			
		,	RTRIM(LTRIM(social_insurance_kbn))				
		,	RTRIM(LTRIM(joining_date))						
		,	RTRIM(LTRIM(date_of_loss))						
		,	RTRIM(LTRIM(reason_for_loss_kbn))					
		,	RTRIM(LTRIM(reason_for_loss))						
		FROM OPENJSON(@P_json) WITH(										
			employee_cd								NVARCHAR(50)
		,	detail_no								NVARCHAR(50)
		,	employment_insurance_no					NVARCHAR(50)
		,	basic_pension_no						NVARCHAR(50)
		,	employment_insurance_status				NVARCHAR(50)
		,	health_insurance_status					NVARCHAR(50)
		,	health_insurance_reference_no			NVARCHAR(50)
		,	employees_pension_insurance_status		NVARCHAR(50)
		,	employees_pension_reference_no			NVARCHAR(50)
		,	welfare_pension_status					NVARCHAR(50)
		,	employees_pension_member_no				NVARCHAR(50)
		,	social_insurance_kbn					NVARCHAR(20)
		,	joining_date							NVARCHAR(50)
		,	date_of_loss							NVARCHAR(50)
		,	reason_for_loss_kbn						NVARCHAR(50)
		,	reason_for_loss							NVARCHAR(100)
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
		--VALIDATE MAXLENGHT 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'employment_insurance_status'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Employment Insurance Status',N'雇用保険加入状況')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.employment_insurance_status)>3)
		--VALIDATE NUMERIC 
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	N'employment_insurance_status'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Employment Insurance Status',N'雇用保険加入状況')	
		FROM #TEMP 
		WHERE
			(#TEMP.employment_insurance_status <> N'')
		AND (#TEMP.employment_insurance_status LIKE '%[^0-9]%')
		--VALIDATE NUMERIC employment_insurance_status < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.employment_insurance_status NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	N'employment_insurance_status'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Employment Insurance Status',N'雇用保険加入状況')
			FROM #TEMP 
			WHERE 
				(#TEMP.employment_insurance_status NOT LIKE '%[^0-9]%')
			AND	(#TEMP.employment_insurance_status < 0)
			-- VALIDATE VALUE 1 OR 2
			INSERT INTO @ERR_TBL
			SELECT
				70				
			,	N'employment_insurance_status'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Employment Insurance Status',N'雇用保険加入状況')
			FROM #TEMP 
			WHERE 
				#TEMP.employment_insurance_status NOT IN(1,2)
			AND #TEMP.employment_insurance_status <> ''
			AND #TEMP.employment_insurance_status IS NOT NULL
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'health_insurance_status'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Health Insurance Status',N'健康保険加入状況')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.health_insurance_status)>3)
		--VALIDATE NUMERIC 
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	N'health_insurance_status'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Health Insurance Status',N'健康保険加入状況')	
		FROM #TEMP 
		WHERE
			(#TEMP.health_insurance_status <> N'')
		AND (#TEMP.health_insurance_status LIKE '%[^0-9]%')
		--VALIDATE NUMERIC health_insurance_status < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.health_insurance_status NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	N'health_insurance_status'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Health Insurance Status',N'健康保険加入状況')
			FROM #TEMP 
			WHERE 
				(#TEMP.health_insurance_status NOT LIKE '%[^0-9]%')
			AND	(#TEMP.health_insurance_status < 0)
			-- VALIDATE VALUE 1 OR 2
			INSERT INTO @ERR_TBL
			SELECT
				70				
			,	N'health_insurance_status'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Health Insurance Status',N'健康保険加入状況')
			FROM #TEMP 
			WHERE 
				#TEMP.health_insurance_status NOT IN(1,2)
			AND #TEMP.health_insurance_status <> ''
			AND #TEMP.health_insurance_status IS NOT NULL
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'health_insurance_reference_no'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Health Insurance Reference No',N'健康保険被保険者整理番号')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.health_insurance_reference_no)>4)
		--VALIDATE NUMERIC 
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	N'health_insurance_reference_no'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Health Insurance Reference No',N'健康保険被保険者整理番号')	
		FROM #TEMP 
		WHERE
			(#TEMP.health_insurance_reference_no <> N'')
		AND (#TEMP.health_insurance_reference_no LIKE '%[^0-9]%')
		--VALIDATE NUMERIC health_insurance_reference_no < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.health_insurance_reference_no NOT LIKE '%[^0-9]%' AND LEN(#TEMP.health_insurance_reference_no) <= 5)
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	N'health_insurance_reference_no'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Health Insurance Reference No',N'健康保険被保険者整理番号')
			FROM #TEMP 
			WHERE 
				(#TEMP.health_insurance_reference_no < 0)
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'employees_pension_insurance_status'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Employees Pension Insurance Status',N'厚生年金保険加入状況')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.employees_pension_insurance_status)>3)
		--VALIDATE NUMERIC 
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	N'employees_pension_insurance_status'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Employees Pension Insurance Status',N'厚生年金保険加入状況')	
		FROM #TEMP 
		WHERE
			(#TEMP.employees_pension_insurance_status <> N'')
		AND (#TEMP.employees_pension_insurance_status LIKE '%[^0-9]%')
		--VALIDATE NUMERIC employees_pension_insurance_status < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.employees_pension_insurance_status NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	N'employees_pension_insurance_status'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Employees Pension Insurance Status',N'厚生年金保険加入状況')
			FROM #TEMP 
			WHERE 
				(#TEMP.employees_pension_insurance_status NOT LIKE '%[^0-9]%')
			AND	(#TEMP.employees_pension_insurance_status < 0)
			-- VALIDATE VALUE 1 OR 2
			INSERT INTO @ERR_TBL
			SELECT
				70				
			,	N'employees_pension_insurance_status'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Employees Pension Insurance Status',N'厚生年金保険加入状況')
			FROM #TEMP 
			WHERE 
				#TEMP.employees_pension_insurance_status NOT IN(1,2)
			AND #TEMP.employees_pension_insurance_status <> ''
			AND #TEMP.employees_pension_insurance_status IS NOT NULL
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'employees_pension_reference_no'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Employees Pension Reference No',N'厚生年金保険被保険者整理番号')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.employees_pension_reference_no)>4)
		--VALIDATE NUMERIC 
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	N'employees_pension_reference_no'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Employees Pension Reference No',N'厚生年金保険被保険者整理番号')	
		FROM #TEMP 
		WHERE
			(#TEMP.employees_pension_reference_no <> N'')
		AND (#TEMP.employees_pension_reference_no LIKE '%[^0-9]%')
		--VALIDATE NUMERIC employees_pension_reference_no < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.employees_pension_reference_no NOT LIKE '%[^0-9]%' AND LEN(#TEMP.employees_pension_reference_no) <= 5)
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	N'employees_pension_reference_no'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Employees Pension Reference No',N'厚生年金保険被保険者整理番号')
			FROM #TEMP 
			WHERE 
				(#TEMP.employees_pension_reference_no < 0)
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'welfare_pension_status'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Welfare Pension Status',N'厚生年金基金加入状況')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.welfare_pension_status)>3)
		--VALIDATE NUMERIC 
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	N'welfare_pension_status'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Welfare Pension Status',N'厚生年金基金加入状況')	
		FROM #TEMP 
		WHERE
			(#TEMP.welfare_pension_status <> N'')
		AND (#TEMP.welfare_pension_status LIKE '%[^0-9]%')
		--VALIDATE NUMERIC welfare_pension_status < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.welfare_pension_status NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	N'welfare_pension_status'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Welfare Pension Status',N'厚生年金基金加入状況')
			FROM #TEMP 
			WHERE 
				(#TEMP.welfare_pension_status NOT LIKE '%[^0-9]%')
			AND	(#TEMP.welfare_pension_status < 0)
			-- VALIDATE VALUE 1 OR 2
			INSERT INTO @ERR_TBL
			SELECT
				70				
			,	N'welfare_pension_status'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Welfare Pension Status',N'厚生年金基金加入状況')
			FROM #TEMP 
			WHERE 
				#TEMP.welfare_pension_status NOT IN(1,2)
			AND #TEMP.welfare_pension_status <> ''
			AND #TEMP.welfare_pension_status IS NOT NULL
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'employees_pension_member_no'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Employees Pension Member No',N'厚生年金基金加入員番号')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.employees_pension_member_no)>4)
		--VALIDATE NUMERIC 
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	N'employees_pension_member_no'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Employees Pension Member No',N'厚生年金基金加入員番号')	
		FROM #TEMP 
		WHERE
			(#TEMP.employees_pension_member_no <> N'')
		AND (#TEMP.employees_pension_member_no LIKE '%[^0-9]%')
		--VALIDATE NUMERIC employees_pension_member_no < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.employees_pension_member_no NOT LIKE '%[^0-9]%' AND LEN(#TEMP.employees_pension_member_no) <= 5)
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	N'employees_pension_member_no'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Employees Pension Member No',N'厚生年金基金加入員番号')
			FROM #TEMP 
			WHERE 
				(#TEMP.employees_pension_member_no < 0)
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'social_insurance_kbn'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Social Insurance',N'区分')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.social_insurance_kbn)>3)
		--VALIDATE NUMERIC 
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	N'social_insurance_kbn'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Social Insurance',N'区分')	
		FROM #TEMP 
		WHERE
			(#TEMP.social_insurance_kbn <> N'')
		AND (#TEMP.social_insurance_kbn LIKE '%[^0-9]%')
		--VALIDATE NUMERIC social_insurance_kbn < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.social_insurance_kbn NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	N'social_insurance_kbn'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Social Insurance',N'区分')
			FROM #TEMP 
			WHERE 
				(#TEMP.social_insurance_kbn NOT LIKE '%[^0-9]%')
			AND	(#TEMP.social_insurance_kbn < 0)
			-- VALIDATE VALUE 1,2,3,4
			INSERT INTO @ERR_TBL
			SELECT
				70				
			,	N'social_insurance_kbn'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Social Insurance',N'区分')
			FROM #TEMP 
			WHERE 
				#TEMP.social_insurance_kbn NOT IN(1,2,3,4)
			AND #TEMP.social_insurance_kbn <> ''
			AND #TEMP.social_insurance_kbn IS NOT NULL
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'reason_for_loss_kbn'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Reason For Loss',N'喪失理由区分')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.reason_for_loss_kbn)>3)
		--VALIDATE NUMERIC 
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	N'reason_for_loss_kbn'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Reason For Loss',N'喪失理由区分')	
		FROM #TEMP 
		WHERE
			(#TEMP.reason_for_loss_kbn <> N'')
		AND (#TEMP.reason_for_loss_kbn LIKE '%[^0-9]%')
		--VALIDATE NUMERIC reason_for_loss_kbn < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.reason_for_loss_kbn NOT LIKE '%[^0-9]%' AND #TEMP.reason_for_loss_kbn <> ''  AND #TEMP.reason_for_loss_kbn <> 0)
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	N'reason_for_loss_kbn'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Reason For Loss',N'喪失理由区分')
			FROM #TEMP 
			WHERE 
				(#TEMP.reason_for_loss_kbn NOT LIKE '%[^0-9]%')
			AND	(#TEMP.reason_for_loss_kbn < 0)
			-- VALIDATE EXIST blood_type IN L0010
			IF NOT EXISTS (
				SELECT 1 FROM #TEMP 
				INNER JOIN L0010 ON (
					L0010.number_cd = #TEMP.reason_for_loss_kbn
				AND L0010.name_typ = 71
				AND L0010.del_datetime is NULL
				)
			)
			BEGIN
				INSERT INTO @ERR_TBL
				SELECT
					70				
				,	N'reason_for_loss_kbn'				
				,	0-- oderby		
				,	1-- dialog  	
				,	0				
				,	0				
				,	IIF(@P_language = N'en',N'Reason For Loss',N'喪失理由区分')
			END
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT joining_date 							
		INSERT INTO @ERR_TBL												
		SELECT															
			28				
		,	N'joining_date'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Joining Date',N'加入日')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.joining_date)>10)	
		--VALIDATE DATE Joining Date
		INSERT INTO @ERR_TBL
		SELECT
			15				
		,	N'joining_date'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Joining Date',N'加入日')	
		FROM #TEMP 
		WHERE
			(#TEMP.joining_date <> N'')
		AND	(ISDATE(#TEMP.joining_date)=0)
		--VALIDATE DATE joining_date <  date_of_loss	
		IF EXISTS (SELECT 1 FROM #TEMP WHERE (ISDATE(#TEMP.joining_date)=1) AND (ISDATE(#TEMP.date_of_loss)=1))
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				24				
			,	N'joining_date'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Joining Date',N'加入日')	
			FROM #TEMP 
			WHERE
				CAST(#TEMP.joining_date AS DATE) >= CAST(#TEMP.date_of_loss AS DATE)
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT date_of_loss 							
		INSERT INTO @ERR_TBL												
		SELECT															
			28				
		,	N'date_of_loss'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Date Of Loss',N'喪失日')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.date_of_loss)>10)	
		--VALIDATE DATE date_of_loss
		INSERT INTO @ERR_TBL
		SELECT
			15				
		,	N'date_of_loss'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Date Of Loss',N'喪失日')	
		FROM #TEMP 
		WHERE
			(#TEMP.date_of_loss <> N'')
		AND	(ISDATE(#TEMP.date_of_loss)=0)
		--VALIDATE DATE joining_date <  date_of_loss	
		IF EXISTS (SELECT 1 FROM #TEMP WHERE (ISDATE(#TEMP.joining_date)=1) AND (ISDATE(#TEMP.date_of_loss)=1))
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				24				
			,	N'date_of_loss'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Date Of Loss',N'喪失日')	
			FROM #TEMP 
			WHERE
				CAST(#TEMP.joining_date AS DATE) >= CAST(#TEMP.date_of_loss AS DATE)
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT employment_insurance_no 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'employment_insurance_no'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Employment Insurance',N'雇用保険番号')	
		FROM #TEMP 
		WHERE
			(LEN(employment_insurance_no)>20)
		-------------------------------------------------
		--VALIDATE MAXLENGHT basic_pension_no 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'basic_pension_no'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Basic Pension No',N'基礎年金番号')	
		FROM #TEMP 
		WHERE
			(LEN(basic_pension_no)>20)
		-------------------------------------------------
		--VALIDATE MAXLENGHT reason_for_loss 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'reason_for_loss'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Reason For Loss',N'喪失理由')	
		FROM #TEMP 
		WHERE
			(LEN(reason_for_loss)>10)
		-------------------------------------------------
		--VALIDATE UNIQUE detail_no
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.detail_no NOT LIKE '%[^0-9]%')
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
			FROM #TEMP INNER JOIN WRK_M0091 ON(
				#TEMP.company_cd				= WRK_M0091.company_cd
			AND #TEMP.employee_cd				= WRK_M0091.employee_cd
			AND WRK_M0091.company_cd			= @P_company_cd
			AND WRK_M0091.social_insurance_kbn	= #TEMP.social_insurance_kbn
			AND WRK_M0091.detail_no				= #TEMP.detail_no
			)
		END

		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- PROCESS
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- Chổ nay dung de viet code xu ly du lieu sau khi validate xong
		--
		IF NOT EXISTS(SELECT 1 FROM @ERR_TBL)
		BEGIN
			DELETE W FROM  WRK_M0090 AS W INNER JOIN  #TEMP AS T ON W.company_cd = @P_company_cd AND W.exec_user = T.exec_user
			IF NOT EXISTS(SELECT 1 FROM #TEMP INNER JOIN WRK_M0090 ON (
				#TEMP.company_cd =	WRK_M0090.company_cd
			AND	#TEMP.employee_cd =	WRK_M0090.employee_cd
			))
			BEGIN 
				INSERT INTO WRK_M0090 
				SELECT 
					#TEMP.exec_user
				,	#TEMP.company_cd
				,	#TEMP.employee_cd				
				,	#TEMP.employment_insurance_no
				,	#TEMP.basic_pension_no					
				,	IIF(#TEMP.employment_insurance_status='',0,#TEMP.employment_insurance_status)			
				,	IIF(#TEMP.health_insurance_status='',0,#TEMP.health_insurance_status)				
				,	#TEMP.health_insurance_reference_no		
				,	IIF(#TEMP.employees_pension_insurance_status='',0,#TEMP.employees_pension_insurance_status)	
				,	#TEMP.employees_pension_reference_no		
				,	IIF(#TEMP.welfare_pension_status='',0,#TEMP.welfare_pension_status)				
				,	#TEMP.employees_pension_member_no			
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
				UPDATE WRK_M0090
				SET 
					employment_insurance_no					=	#TEMP.employment_insurance_no				
				,	basic_pension_no						=	#TEMP.basic_pension_no					
				,	employment_insurance_status				=	#TEMP.employment_insurance_status			
				,	health_insurance_status					=	#TEMP.health_insurance_status				
				,	health_insurance_reference_no			=	#TEMP.health_insurance_reference_no		
				,	employees_pension_insurance_status		=	#TEMP.employees_pension_insurance_status	
				,	employees_pension_reference_no			=	#TEMP.employees_pension_reference_no		
				,	welfare_pension_status					=	#TEMP.welfare_pension_status				
				,	employees_pension_member_no				=	#TEMP.employees_pension_member_no	
				FROM #TEMP 
				INNER JOIN WRK_M0090 ON (
					#TEMP.company_cd			=	WRK_M0090.company_cd
				AND #TEMP.employee_cd			=	WRK_M0090.employee_cd
				AND WRK_M0090.company_cd    	= 	@P_company_cd
				)
			END

			DELETE W FROM  WRK_M0091 AS W INNER JOIN  #TEMP AS T ON W.company_cd = @P_company_cd AND W.exec_user = T.exec_user
			--
			--DELETE WRK_M0091
			INSERT INTO WRK_M0091 
			SELECT																
				#TEMP.exec_user
			,	#TEMP.company_cd
			,	#TEMP.employee_cd				
			,	#TEMP.social_insurance_kbn
			,	#TEMP.detail_no				
			,	IIF(#TEMP.joining_date = '', NULL, #TEMP.joining_date )		
			,	IIF(#TEMP.date_of_loss = '', NULL, #TEMP.date_of_loss )	
			,	CASE
					WHEN #TEMP.social_insurance_kbn = 1 THEN #TEMP.reason_for_loss_kbn
					WHEN #TEMP.social_insurance_kbn = 2 THEN 0
					WHEN #TEMP.social_insurance_kbn = 3 THEN 0
					WHEN #TEMP.social_insurance_kbn = 4 THEN 0
				END
			,	CASE
					WHEN #TEMP.social_insurance_kbn = 1 THEN ''
					WHEN #TEMP.social_insurance_kbn = 2 THEN #TEMP.reason_for_loss
					WHEN #TEMP.social_insurance_kbn = 3 THEN #TEMP.reason_for_loss
					WHEN #TEMP.social_insurance_kbn = 4 THEN #TEMP.reason_for_loss
				END
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
			IF NOT EXISTS (SELECT 1 FROM WRK_M0090
			WHERE WRK_M0090.exec_user NOT LIKE '%'+CONCAT('WRK_M0090', CAST(@P_no AS NVARCHAR(10)))+'%')
			BEGIN
				INSERT INTO WRK_M0090 
				SELECT 
					CONCAT('WRK_M0090_', CAST(@P_no AS NVARCHAR(10)))
				,	0
				,	N''	
				,	N''
				,	N''
				,	0
				,	0
				,	0
				,	0	
				,	0
				,	0
				,	0
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
			IF NOT EXISTS (SELECT 1 FROM WRK_M0091
			WHERE WRK_M0091.exec_user NOT LIKE '%'+CONCAT('WRK_M0091', CAST(@P_no AS NVARCHAR(10)))+'%')
			BEGIN
				INSERT INTO WRK_M0091
				SELECT 
					CONCAT('WRK_M0091_', CAST(@P_no AS NVARCHAR(10)))
				,	0
				,	N''				
				,	0			
				,	0				
				,	NULL	
				,	NULL	
				,	0	
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
		END																		
		--

		IF (@P_no = @P_count) 
		BEGIN
			--
			IF (EXISTS(SELECT 1 FROM @ERR_TBL) OR EXISTS(SELECT 1 FROM WRK_M0090 WHERE exec_user LIKE '%WRK_M0090%') 
											   OR EXISTS(SELECT 1 FROM WRK_M0091 WHERE exec_user LIKE '%WRK_M0091%'))
			BEGIN
				DELETE WRK_M0090
				DELETE WRK_M0091
				--
				GOTO COMPLETE_QUERY
			END

			-- UPDATE M0090
			UPDATE M0090
			SET 
				employment_insurance_no					=	WRK_M0090.employment_insurance_no				
			,	basic_pension_no						=	WRK_M0090.basic_pension_no					
			,	employment_insurance_status				=	IIF(WRK_M0090.employment_insurance_status='',0,WRK_M0090.employment_insurance_status)			
			,	health_insurance_status					=	IIF(WRK_M0090.health_insurance_status='',0,	WRK_M0090.health_insurance_status)			
			,	health_insurance_reference_no			=	WRK_M0090.health_insurance_reference_no		
			,	employees_pension_insurance_status		=	IIF(WRK_M0090.employees_pension_insurance_status='',0,WRK_M0090.employees_pension_insurance_status)	
			,	employees_pension_reference_no			=	WRK_M0090.employees_pension_reference_no		
			,	welfare_pension_status					=	IIF(WRK_M0090.welfare_pension_status='',0,WRK_M0090.welfare_pension_status)				
			,	employees_pension_member_no				=	WRK_M0090.employees_pension_member_no			
			,	upd_user								=	@P_cre_user		
			,	upd_ip									=	@P_cre_ip	
			,	upd_prg									=	N'O0100'	
			,	upd_datetime							=	@w_time	
			,	del_user								=	SPACE(0)
			,	del_ip									=	SPACE(0)
			,	del_prg									=	SPACE(0)
			,	del_datetime							=	NULL
			FROM M0090 
			INNER JOIN WRK_M0090 ON (
				M0090.company_cd			=	WRK_M0090.company_cd
			AND M0090.employee_cd			=	WRK_M0090.employee_cd
			AND WRK_M0090.company_cd    	= 	@P_company_cd
			)		

			-- INSERT M0090
			INSERT INTO M0090 
			SELECT  
				WRK_M0090.company_cd
			,	WRK_M0090.employee_cd
			,	WRK_M0090.employment_insurance_no			
			,	WRK_M0090.basic_pension_no					
			,	IIF(WRK_M0090.employment_insurance_status='',0,WRK_M0090.employment_insurance_status)				
			,	IIF(WRK_M0090.health_insurance_status='',0,	WRK_M0090.health_insurance_status)	
			,	WRK_M0090.health_insurance_reference_no		
			,	IIF(WRK_M0090.employees_pension_insurance_status='',0,WRK_M0090.employees_pension_insurance_status)
			,	WRK_M0090.employees_pension_reference_no	
			,	IIF(WRK_M0090.welfare_pension_status='',0,WRK_M0090.welfare_pension_status)			
			,	WRK_M0090.employees_pension_member_no		
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
			FROM WRK_M0090 
			LEFT JOIN M0090 ON (
				M0090.company_cd			=	WRK_M0090.company_cd
			AND M0090.employee_cd			=	WRK_M0090.employee_cd
			)	
			WHERE 
				M0090.employee_cd IS NULL
			AND	WRK_M0090.employee_cd <> N''
			AND WRK_M0090.company_cd    = @P_company_cd

			-- UPDATE M0091
			UPDATE M0091
			SET 		
				joining_date							=	WRK_M0091.joining_date			
			,	date_of_loss							=	WRK_M0091.date_of_loss			
			,	reason_for_loss_kbn						=	WRK_M0091.reason_for_loss_kbn	
			,	reason_for_loss							=	WRK_M0091.reason_for_loss		
			,	upd_user								=	@P_cre_user		
			,	upd_ip									=	@P_cre_ip	
			,	upd_prg									=	N'O0100'	
			,	upd_datetime							=	@w_time	
			,	del_user								=	SPACE(0)
			,	del_ip									=	SPACE(0)
			,	del_prg									=	SPACE(0)
			,	del_datetime							=	NULL
			FROM M0091 
			INNER JOIN WRK_M0091 ON (
				M0091.company_cd			=	WRK_M0091.company_cd
			AND M0091.employee_cd			=	WRK_M0091.employee_cd
			AND M0091.detail_no				=	WRK_M0091.detail_no
			AND M0091.social_insurance_kbn	=	WRK_M0091.social_insurance_kbn
			AND WRK_M0091.company_cd    	= 	@P_company_cd
			)		

			-- INSERT M0091
			INSERT INTO M0091 
			SELECT  
				WRK_M0091.company_cd
			,	WRK_M0091.employee_cd
			,	WRK_M0091.social_insurance_kbn	
			,	WRK_M0091.detail_no
			,	WRK_M0091.joining_date			
			,	WRK_M0091.date_of_loss			
			,	WRK_M0091.reason_for_loss_kbn	
			,	WRK_M0091.reason_for_loss		
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
			FROM WRK_M0091 
			LEFT JOIN M0091 ON (
				M0091.company_cd			=	WRK_M0091.company_cd
			AND M0091.employee_cd			=	WRK_M0091.employee_cd
			AND M0091.detail_no				=	WRK_M0091.detail_no
			AND M0091.social_insurance_kbn	=	WRK_M0091.social_insurance_kbn
			)	
			WHERE 
				M0091.employee_cd IS NULL
			AND	WRK_M0091.employee_cd <> N''
			AND M0091.detail_no IS NULL
			AND WRK_M0091.company_cd    = @P_company_cd
			AND M0091.social_insurance_kbn IS NULL
			--
			DELETE WRK_M0090
			DELETE WRK_M0091
			
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
