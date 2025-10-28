DROP PROCEDURE [SPC_O0100_ACT7]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- 
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	O0100
--*  
--*  作成日/create date			:	2018/10/04								
--*　作成者/creater				:	sondh　								
--*   					
--*  更新日/update date			:  	2018/10/06						
--*　更新者/updater				:　 tuantv 　								     	 
--*　更新内容/update content		:	change processing import CR date 2018/10/31　	
--*   					
--*  更新日/update date			:  	2021/08/19						
--*　更新者/updater				:　 viettd 　								     	 
--*　更新内容/update content		:	fix maxlength of item sso_user to 255
--*   					
--*  更新日/update date			:  	2021/09/14						
--*　更新者/updater				:　 viettd 　								     	 
--*　更新内容/update content		:	change authority when update in S0010
--*   					
--*  更新日/update date			:  	2023/11/27					
--*　更新者/updater				:　 yamazaki 　								     	 
--*　更新内容/update content		:	M0070.position_cd SMALLINT→INT
--*
--****************************************************************************************
CREATE PROCEDURE [SPC_O0100_ACT7]
	-- Add the parameters for the stored procedure here
	@P_json			NVARCHAR(MAX) = ''
,	@P_exec_user	NVARCHAR(100)  = ''
,	@P_company_cd	SMALLINT	  = 0	
,	@P_cre_user		NVARCHAR(50)  = ''
,	@P_cre_ip		NVARCHAR(50)  = ''
,	@P_no			INT			  = 0
,	@P_count		INT			  = 0
,	@P_language				NVARCHAR(2)			= ''
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
	,	employee_cd					NVARCHAR(100)
	,	employee_last_nm			NVARCHAR(100)
	,	employee_first_nm			NVARCHAR(100)
	,	employee_nm					NVARCHAR(201)
	,	furigana					NVARCHAR(100)
	,	gender						NVARCHAR(50)
	,	mail						NVARCHAR(100)
	,	birth_date					NVARCHAR(50)
	,	company_in_dt				NVARCHAR(50)
	,	company_out_dt				NVARCHAR(50)
	,	retirement_reason_typ		nvarchar(200)
	,	retirement_reason			nvarchar(200)
	,	evaluated_typ				NVARCHAR(50)
	,	oneonone_typ				nvarchar(200)
	,	multireview_typ				nvarchar(200)
	,	report_typ					nvarchar(200)
	,	office_cd					NVARCHAR(50)
	,	belong_cd1					NVARCHAR(50)
	,	belong_cd2					NVARCHAR(50)
	,	belong_cd3					NVARCHAR(50)
	,	belong_cd4					NVARCHAR(50)
	,	belong_cd5					NVARCHAR(50)
	,	job_cd						NVARCHAR(50)
	,	position_cd					NVARCHAR(50)
	,	employee_typ				NVARCHAR(50)
	,	grade						NVARCHAR(50)
	,	salary_grade				NVARCHAR(50)
	,	company_mobile_number		NVARCHAR(50)
	,	extension_number			NVARCHAR(50)
	,	[user_id]					NVARCHAR(50)
	,	user_sso					NVARCHAR(255)		-- edited by viettd 2021/08/19
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
			CONCAT(@P_exec_user, CAST(@P_no AS NVARCHAR(10)))																		
		,	@P_company_cd															
		,	RTRIM(LTRIM(employee_cd))											
		,	RTRIM(LTRIM(employee_last_nm))
		,	RTRIM(LTRIM(employee_first_nm))
		,	RTRIM(LTRIM(employee_nm))											
		,	RTRIM(LTRIM(furigana))													
		,	RTRIM(LTRIM(gender))												
		,	RTRIM(LTRIM(mail))												
		,	RTRIM(LTRIM(birth_date))											
		,	RTRIM(LTRIM(company_in_dt))										
		,	RTRIM(LTRIM(company_out_dt))
		,	RTRIM(LTRIM(retirement_reason_typ))
		,	RTRIM(LTRIM(retirement_reason))
		,	RTRIM(LTRIM(evaluated_typ))	
		,	RTRIM(LTRIM(oneonone_typ))
		,	RTRIM(LTRIM(multireview_typ))
		,	RTRIM(LTRIM(report_typ))
		,	RTRIM(LTRIM(office_cd))		
		,	RTRIM(LTRIM(belong_cd1))		
		,	RTRIM(LTRIM(belong_cd2))
		,	RTRIM(LTRIM(belong_cd3))
		,	RTRIM(LTRIM(belong_cd4))
		,	RTRIM(LTRIM(belong_cd5))	
		,	RTRIM(LTRIM(job_cd))											
		,	RTRIM(LTRIM(position_cd))										
		,	RTRIM(LTRIM(employee_typ))									
		,	RTRIM(LTRIM(grade))			
		,	REPLACE(RTRIM(LTRIM(salary_grade)),'.00','')	
		,	RTRIM(LTRIM(company_mobile_number))	
		,	RTRIM(LTRIM(extension_number))	
		,	RTRIM(LTRIM([user_id]))	
		,	RTRIM(LTRIM(sso_user))	
		FROM OPENJSON(@P_json) WITH(										
			employee_cd					NVARCHAR(50)
		,	employee_last_nm			NVARCHAR(100)
		,	employee_first_nm			NVARCHAR(100)
		,	employee_nm					NVARCHAR(201)
		,	furigana					NVARCHAR(100)
		,	gender						NVARCHAR(50)
		,	mail						NVARCHAR(100)
		,	birth_date					NVARCHAR(50)
		,	company_in_dt				NVARCHAR(50)
		,	company_out_dt				NVARCHAR(50)
		,	retirement_reason_typ		nvarchar(200)
		,	retirement_reason			nvarchar(200)
		,	evaluated_typ				NVARCHAR(50)
		,	oneonone_typ				nvarchar(200)
		,	multireview_typ				nvarchar(200)
		,	report_typ					nvarchar(200)
		,	office_cd					NVARCHAR(50)
		,	belong_cd1					NVARCHAR(50)
		,	belong_cd2					NVARCHAR(50)
		,	belong_cd3					NVARCHAR(50)
		,	belong_cd4					NVARCHAR(50)
		,	belong_cd5					NVARCHAR(50)
		,	job_cd						NVARCHAR(50)
		,	position_cd					NVARCHAR(50)
		,	employee_typ				NVARCHAR(50)
		,	grade						NVARCHAR(50)
		,	salary_grade				NVARCHAR(50)
		,	company_mobile_number		NVARCHAR(50)
		,	extension_number			NVARCHAR(50)
		,	[user_id]					NVARCHAR(50)
		,	sso_user					NVARCHAR(255)		-- edited by viettd 2021/08/19							
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
			(LEN(#TEMP.employee_cd)>10)
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
		--VALIDATE MAXLENGHT employee_nm 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'employee_nm'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Employee Name','社員名')	
		FROM #TEMP 
		WHERE
			(LEN(employee_nm)>101)
			--VALIDATE MAXLENGHT employee_nm 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'employee_first_nm'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','First Name','社員名')	
		FROM #TEMP 
		WHERE
			(LEN(employee_first_nm)>50)
			--VALIDATE MAXLENGHT employee_nm 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'employee_last_nm'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Surname','社員名')	
		FROM #TEMP 
		WHERE
			(LEN(employee_last_nm)>50)
		--VALIDATE MAXLENGHT furigana 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'furigana'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Furigana','ふりがな')	
		FROM #TEMP 
		WHERE
			(LEN(furigana)>50)
		--VALIDATE MAXLENGHT gender 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'gender'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Gender','性別')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.gender)>3)
		--VALIDATE NUMERIC gender 
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	'gender'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Gender','性別')
		FROM #TEMP 
		WHERE
			(#TEMP.gender <> '')
		AND (#TEMP.gender LIKE '%[^0-9]%')
		--VALIDATE NUMERIC gender < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.gender NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	'gender'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Gender','性別')
			FROM #TEMP 
			WHERE 
				(#TEMP.gender NOT LIKE '%[^0-9]%')
			AND	(#TEMP.gender < 0)
		END
		--VALIDATE MAXLENGHT mail 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'mail'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','E-Mail Address','メールアドレス')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.mail)>50)
		--VALIDATE MAXLENGHT birth_date 							
		INSERT INTO @ERR_TBL												
		SELECT															
			28				
		,	'birth_date'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Date Of Birth','生年月日')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.birth_date)>10)
		--VALIDATE DATE birth_date
		INSERT INTO @ERR_TBL
		SELECT
			15				
		,	'birth_date'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Date Of Birth','生年月日')	
		FROM #TEMP 
		WHERE
			(#TEMP.birth_date <> '')
		AND	(ISDATE(#TEMP.birth_date)=0)
		--VALIDATE MAXLENGHT company_in_dt 							
		INSERT INTO @ERR_TBL												
		SELECT															
			28				
		,	'company_in_dt'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Date of Hire','入社日')		
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.company_in_dt)>10)
		--VALIDATE DATE company_in_dt
		INSERT INTO @ERR_TBL
		SELECT
			15				
		,	'company_in_dt'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Date of Hire','入社日')	
		FROM #TEMP 
		WHERE
			(#TEMP.company_in_dt <> '')
		AND	(ISDATE(#TEMP.company_in_dt)=0)
		--VALIDATE MAXLENGHT company_out_dt 							
		INSERT INTO @ERR_TBL												
		SELECT															
			28				
		,	'company_out_dt'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Termination (Retirement) Date','退社日')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.company_out_dt)>10)
		--VALIDATE DATE company_out_dt
		INSERT INTO @ERR_TBL
		SELECT
			15				
		,	'company_out_dt'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Termination (Retirement) Date','退社日')	
		FROM #TEMP 
		WHERE
			(#TEMP.company_out_dt <> '')
		AND	(ISDATE(#TEMP.company_out_dt)=0)
		--VALIDATE MAXLENGHT evaluated_typ
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'evaluated_typ'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Evaluation  Type','評価対象区分')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.evaluated_typ)>1)
		--VALIDATE NUMERIC evaluated_typ
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	'evaluated_typ'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Evaluation  Type','評価対象区分')	
		FROM #TEMP 
		WHERE
			(#TEMP.evaluated_typ <> '')
		AND (#TEMP.evaluated_typ LIKE '%[^0-9]%')
		--VALIDATE NUMERIC evaluated_typ < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.evaluated_typ NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	'evaluated_typ'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Evaluation  Type','評価対象区分')
			FROM #TEMP 
			WHERE 
				(#TEMP.evaluated_typ NOT LIKE '%[^0-9]%')
			AND	(#TEMP.evaluated_typ < 0)
		END

		--VALIDATE MAXLENGHT retirement_reason_typ M0070
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'retirement_reason'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Retire Reason','退職理由')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.retirement_reason)>50)

		--VALIDATE MAXLENGHT retirement_reason_typ
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'retirement_reason_typ'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Retire Reason Type','退職理由区分')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.retirement_reason_typ)>1)
		--VALIDATE NUMERIC retirement_reason_typ
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	'retirement_reason_typ'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Retire Reason Type','退職理由区分')	
		FROM #TEMP 
		WHERE
			(#TEMP.retirement_reason_typ <> '')
		AND (#TEMP.retirement_reason_typ LIKE '%[^0-9]%')
		--VALIDATE NUMERIC retirement_reason_typ < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.retirement_reason_typ NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	'retirement_reason_typ'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Retire Reason Type','退職理由区分')
			FROM #TEMP 
			WHERE 
				(#TEMP.retirement_reason_typ NOT LIKE '%[^0-9]%')
			AND	(#TEMP.retirement_reason_typ < 0)
		END

		--VALIDATE MAXLENGHT 1on1_typ
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'1on1_typ'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','1o1 Type','１on１対象区分')
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.oneonone_typ)>1)
		--VALIDATE NUMERIC 1on1_typ
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	'1on1_typ'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','1o1 Type','１on１対象区分')
		FROM #TEMP 
		WHERE
			(#TEMP.oneonone_typ <> '')
		AND (#TEMP.oneonone_typ LIKE '%[^0-9]%')
		--VALIDATE NUMERIC retirement_reason_typ < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.oneonone_typ NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	'1on1_typ'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','1o1 Type','１on１対象区分')
			FROM #TEMP 
			WHERE 
				(#TEMP.oneonone_typ NOT LIKE '%[^0-9]%')
			AND	(#TEMP.oneonone_typ < 0)
		END
		--VALIDATE MAXLENGHT multireview_typ
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'multireview_typ'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Multireview Type','マルチレビュー対象区分')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.multireview_typ)>1)
		--VALIDATE NUMERIC multireview_typ
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	'multireview_typ'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Multireview Type','マルチレビュー対象区分')	
		FROM #TEMP 
		WHERE
			(#TEMP.multireview_typ <> '')
		AND (#TEMP.multireview_typ LIKE '%[^0-9]%')
		--VALIDATE MAXLENGHT report_typ
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'report_typ'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Report Type','報告書対象区分')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.report_typ)>1)
		--VALIDATE NUMERIC report_typ
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	'report_typ'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Report Type','報告書対象区分')		
		FROM #TEMP 
		WHERE
			(#TEMP.report_typ <> '')
		AND (#TEMP.report_typ LIKE '%[^0-9]%')
		--VALIDATE NUMERIC retirement_reason_typ < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.multireview_typ NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	'multireview_typ'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Multireview Type','マルチレビュー対象区分')
			FROM #TEMP 
			WHERE 
				(#TEMP.multireview_typ NOT LIKE '%[^0-9]%')
			AND	(#TEMP.multireview_typ < 0)
		END
		--VALIDATE MAXLENGHT office_cd
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'office_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Office Code','営業所コード')		
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.office_cd)>3)
		--VALIDATE NUMERIC office_cd
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	'office_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Office Code','営業所コード')		
		FROM #TEMP 
		WHERE
			#TEMP.office_cd <> ''
		AND (#TEMP.office_cd LIKE '%[^0-9]%')
		--VALIDATE NUMERIC office_cd < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.office_cd NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	'office_cd'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Office Code','営業所コード')	
			FROM #TEMP 
			WHERE 
				(#TEMP.office_cd NOT LIKE '%[^0-9]%')
			AND	(#TEMP.office_cd < 0)
		END
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'belong_cd1'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Department Code 1','所属コード1')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.belong_cd1)>20)
		INSERT INTO @ERR_TBL
			SELECT
				105				
			,	'belong_cd1'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Department Code 1', '所属コード1')		
			FROM #TEMP LEFT JOIN M0020 ON(
				#TEMP.belong_cd1 = M0020.organization_cd_1
			AND M0020.organization_typ = 1
			AND M0020.del_datetime IS NULL
			AND M0020.company_cd = @P_company_cd
			) 
			WHERE
				M0020.organization_cd_1 IS NULL
			AND #TEMP.belong_cd1 <>''
			AND (
				#TEMP.belong_cd1 <> ''
			OR #TEMP.belong_cd2 <> ''
			OR #TEMP.belong_cd3 <> ''
			OR #TEMP.belong_cd4 <> ''
			OR #TEMP.belong_cd5 <> ''
			)
		--VALIDATE MAXLENGHT belong_cd2
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'belong_cd2'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Department Code 2','所属コード2')
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.belong_cd2)>20)
		INSERT INTO @ERR_TBL
			SELECT
				105				
			,	'belong_cd2'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Department Code 2', '所属コード2')		
			FROM #TEMP LEFT JOIN M0020 ON(
				#TEMP.belong_cd1 = M0020.organization_cd_1
			AND M0020.organization_typ = 2
			AND #TEMP.belong_cd2 = M0020.organization_cd_2
			AND M0020.del_datetime IS NULL
			AND M0020.company_cd = @P_company_cd
			) 
			WHERE
				M0020.organization_cd_1 IS NULL

			AND #TEMP.belong_cd2 <>''

		
		--VALIDATE MAXLENGHT belong_cd2
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'belong_cd3'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Department Code 3','所属コード3')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.belong_cd3)>20)
		INSERT INTO @ERR_TBL
			SELECT
				105				
			,	'belong_cd3'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Department Code 3', '所属コード3')		
			FROM #TEMP LEFT JOIN M0020 ON(
				#TEMP.belong_cd1 = M0020.organization_cd_1
			AND M0020.organization_typ = 3
			AND #TEMP.belong_cd2 = M0020.organization_cd_2
			AND #TEMP.belong_cd3 =M0020.organization_cd_3
			AND M0020.del_datetime IS NULL
			AND M0020.company_cd = @P_company_cd
			) 
			WHERE
				M0020.organization_cd_1 IS NULL
		
			AND #TEMP.belong_cd3 <>''
		
		
		--VALIDATE MAXLENGHT belong_cd2
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'belong_cd4'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Department Code 4','所属コード4')
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.belong_cd4)>20)
		INSERT INTO @ERR_TBL
			SELECT
				105				
			,	'belong_cd4'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Department Code 4', '所属コード4')		
			FROM #TEMP LEFT JOIN M0020 ON(
				#TEMP.belong_cd1 = M0020.organization_cd_1
			AND M0020.organization_typ = 4
			AND #TEMP.belong_cd2 = M0020.organization_cd_2
			AND #TEMP.belong_cd3 =M0020.organization_cd_3
			AND #TEMP.belong_cd4 = M0020.organization_cd_4
			AND M0020.del_datetime IS NULL
			AND M0020.company_cd = @P_company_cd
			) 
			WHERE
				M0020.organization_cd_1 IS NULL
			AND #TEMP.belong_cd4 <>''
			
		--VALIDATE MAXLENGHT belong_cd5
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'belong_cd5'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Department Code 5','所属コード5')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.belong_cd5)>20)
		INSERT INTO @ERR_TBL
			SELECT
				105				
			,	'belong_cd5'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Department Code 5', '所属コード5')		
			FROM #TEMP LEFT JOIN M0020 ON(
				#TEMP.belong_cd1 = M0020.organization_cd_1
			AND M0020.organization_typ = 5
			AND #TEMP.belong_cd2 = M0020.organization_cd_2
			AND #TEMP.belong_cd3 = M0020.organization_cd_3
			AND #TEMP.belong_cd4 = M0020.organization_cd_4
			AND #TEMP.belong_cd5 = M0020.organization_cd_5
			AND M0020.del_datetime IS NULL
			AND M0020.company_cd = @P_company_cd
			) 
			WHERE
				M0020.organization_cd_1 IS NULL
			AND #TEMP.belong_cd5 <>''
		--VALIDATE NUMERIC belong_cd5
		
		--VALIDATE MAXLENGHT job_cd
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'job_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Job Code','職種コード')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.job_cd)>3)
		--VALIDATE NUMERIC job_cd
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	'job_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Job Code','職種コード')	
		FROM #TEMP 
		WHERE
			#TEMP.job_cd <> ''
		AND (#TEMP.job_cd LIKE '%[^0-9]%')
		--VALIDATE NUMERIC job_cd < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.job_cd NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	'job_cd'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Job Code','職種コード')	
			FROM #TEMP 
			WHERE 
				(#TEMP.job_cd NOT LIKE '%[^0-9]%')
			AND	(#TEMP.job_cd < 0)
		END
		--VALIDATE MAXLENGHT position_cd
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'position_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Position Code','役職コード')		
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.position_cd)>5) --2023/11/27 3→5
		--VALIDATE NUMERIC position_cd
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	'position_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Position Code','役職コード')	
		FROM #TEMP 
		WHERE
			#TEMP.position_cd <> ''
		AND (#TEMP.position_cd LIKE '%[^0-9-]%')
		--VALIDATE NUMERIC position_cd < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE ISNUMERIC(#TEMP.position_cd) = 0)
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	'position_cd'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Position Code','役職コード')	
			FROM #TEMP 
			WHERE 
				( ISNUMERIC(#TEMP.position_cd) = 0)
			AND	(#TEMP.position_cd < -1)
		END
		--VALIDATE MAXLENGHT employee_typ 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'employee_typ'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Employee Classification','社員区分')		
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.employee_typ)>3)
		--VALIDATE NUMERIC employee_typ 
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	'employee_typ'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Employee Classification','社員区分')	
		FROM #TEMP 
		WHERE
			(#TEMP.employee_typ <> '') 
		AND (#TEMP.employee_typ LIKE '%[^0-9]%')
		--VALIDATE NUMERIC employee_typ < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.employee_typ NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	'employee_typ'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Employee Classification','社員区分')	
			FROM #TEMP 
			WHERE 
				(#TEMP.employee_typ NOT LIKE '%[^0-9]%')
			AND	(#TEMP.employee_typ < 0)
		END
		--VALIDATE MAXLENGHT grade 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'grade'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Rank','等級')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.grade)>3)
		--VALIDATE NUMERIC grade 
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	'grade'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Rank','等級')		
		FROM #TEMP 
		WHERE
			(#TEMP.grade <> '') 
		AND (#TEMP.grade LIKE '%[^0-9]%')
		--VALIDATE NUMERIC grade < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.grade NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	'grade'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Rank','等級')	
			FROM #TEMP 
			WHERE 
				(#TEMP.grade NOT LIKE '%[^0-9]%')
			AND	(#TEMP.grade < 0)
		END
		-- cr 2024/04/08
		------------------------------------------------------
		--VALIDATE MAXLENGHT salary_grade 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'salary_grade'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Salary Grade','号俸')
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.salary_grade)>3)
		--VALIDATE NUMERIC salary_grade 
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	'salary_grade'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Salary Grade','号俸')
		FROM #TEMP 
		WHERE
			(#TEMP.salary_grade <> '') 
		AND (#TEMP.salary_grade LIKE '%[^0-9]%')
		--VALIDATE NUMERIC base_salary < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.salary_grade NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	'salary_grade'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Salary Grade','号俸')
			FROM #TEMP 
			WHERE 
				(#TEMP.salary_grade NOT LIKE '%[^0-9]%')
			AND	(#TEMP.salary_grade < 0)
		END
		------------------------------------------------------
		--VALIDATE MAXLENGHT company_mobile_number 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'company_mobile_number'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Company Mobile Number','社有携帯番号')
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.company_mobile_number)>20)
		--VALIDATE NUMERIC company_mobile_number 
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	'company_mobile_number'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Company Mobile Number','社有携帯番号')
		FROM #TEMP 
		WHERE
			(#TEMP.company_mobile_number <> '') 
		AND (#TEMP.company_mobile_number LIKE '%[^0-9/-]%')
		------------------------------------------------------
		--VALIDATE MAXLENGHT extension_number 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'extension_number'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Extension Number','内線番号')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.extension_number)>20)
		--VALIDATE NUMERIC extension_number 
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	'extension_number'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Extension Number','内線番号')
		FROM #TEMP 
		WHERE
			(#TEMP.extension_number <> '') 
		AND (#TEMP.extension_number LIKE '%[^0-9]%')
		-- end cr 2024/04/08
		--------------------------------------------------------
		--VALIDATE MAXLENGHT user_id 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'user_id'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','User Id','ユーザーID')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.[user_id])>51)
		--cr 2020/09/01
		INSERT INTO @ERR_TBL
		SELECT
			108				
		,	'office_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Office Code','営業所コード')	
		FROM #TEMP LEFT JOIN M0010 ON(
			@P_company_cd	=	M0010.company_cd
		AND #TEMP.office_cd	=	M0010.office_cd
		AND M0010.del_datetime IS NULL
		)
		WHERE M0010.company_cd IS NULL 
		AND #TEMP.office_cd	<> 0 
		AND #TEMP.office_cd	<> ''
		--所属コード
		INSERT INTO @ERR_TBL
		SELECT
			105			
		,	'organization'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Department','所属コード')	
		FROM #TEMP LEFT JOIN M0020 ON(
			@P_company_cd		=	M0020.company_cd
		AND #TEMP.belong_cd1	=	M0020.organization_cd_1
		AND #TEMP.belong_cd2	=	M0020.organization_cd_2
		AND #TEMP.belong_cd3	=	M0020.organization_cd_3
		AND #TEMP.belong_cd4	=	M0020.organization_cd_4
		AND #TEMP.belong_cd5	=	M0020.organization_cd_5
		AND M0020.del_datetime IS NULL
		)
		WHERE M0020.company_cd IS NULL 
		AND #TEMP.belong_cd1	<> '0'
		AND #TEMP.belong_cd2	<> '0'
		AND #TEMP.belong_cd3	<> '0'
		AND #TEMP.belong_cd4	<> '0'
		AND #TEMP.belong_cd5	<> '0'
		AND #TEMP.belong_cd1	<> ''
		AND #TEMP.belong_cd2	<> ''
		AND #TEMP.belong_cd3	<> ''
		AND #TEMP.belong_cd4	<> ''
		AND #TEMP.belong_cd5	<> ''
		--職種コード
		INSERT INTO @ERR_TBL
		SELECT
			109			
		,	'job_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Job Code','職種コード')	
		FROM #TEMP LEFT JOIN M0030 ON(
			@P_company_cd	=	M0030.company_cd
		AND #TEMP.job_cd	=	M0030.job_cd
		AND M0030.del_datetime IS NULL
		)
		WHERE M0030.company_cd IS NULL 
		AND #TEMP.job_cd	<> 0 
		AND #TEMP.job_cd	<> ''
			--'社員区分'
		INSERT INTO @ERR_TBL
		SELECT
			110	
		,	'employee_typ'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Employee Classification','社員区分')	
		FROM #TEMP LEFT JOIN M0060 ON(
			@P_company_cd		=	M0060.company_cd
		AND #TEMP.employee_typ	=	M0060.employee_typ
		AND M0060.del_datetime IS NULL
		)
		WHERE M0060.company_cd IS NULL 
		AND #TEMP.employee_typ	<> 0 
		AND #TEMP.employee_typ	<> ''
			--?????
		INSERT INTO @ERR_TBL
		SELECT
			106
		,	'position_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Position Code', '役職コード')		
		FROM #TEMP LEFT JOIN M0040 ON(
			@P_company_cd		=	M0040.company_cd
		AND #TEMP.position_cd	=	M0040.position_cd
		AND M0040.del_datetime IS NULL
		)
		WHERE M0040.company_cd IS NULL 
		AND (#TEMP.position_cd	<> 0 AND #TEMP.position_cd	<> '-1')
		AND #TEMP.position_cd	<> ''
		--end cr 2020/09/01

		----VALIDATE REQUIRED user_id 
		--INSERT INTO @ERR_TBL
		--SELECT
		--	8				
		--,	'user_id'				
		--,	0-- oderby		
		--,	1-- dialog  	
		--,	0				
		--,	0				
		--,	'ユーザーID'	
		--FROM #TEMP 
		--WHERE
		--	(#TEMP.[user_id] = '')
		--
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- PROCESS
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- Chổ nay dung de viet code xu ly du lieu sau khi validate xong
		--

		IF NOT EXISTS(SELECT 1 FROM @ERR_TBL)
		BEGIN
			DELETE W FROM  WRK_S0010 AS W INNER JOIN  #TEMP AS T ON W.company_cd = @P_company_cd AND W.exec_user = T.exec_user
			INSERT INTO WRK_S0010 
			SELECT 
				#TEMP.exec_user								--exec_user					
			,	#TEMP.company_cd							--company_cd
			,	#TEMP.[user_id]								--user_id
			,	#TEMP.employee_cd							--employee_cd
			,	SPACE(0)									--password
			,	#TEMP.user_sso								--user_sso
			--,	1											--authority_typ
			,	0											--authority_typ  edited by viettd 2021/09/14
			,	0											--authority_cd
			,	0											--[1on1_authority_typ]
			,	0											--authority_cd
			,	0											--[multireview_authority_typ]
			,	0											--authority_cd
			,	0											--[multireview_authority_typ]
			,	0											--authority_cd
			,	0											--[multireview_authority_typ]
			,	0											--authority_cd
			,	0											--[setting_authority_typ]
			,	0											--authority_cd
			,	0											--remember_token
			,	SPACE(0)									--failed_login_count
			,	NULL										--pass_change_datetime
			,	SPACE(0)									--last_login_ip
			,	NULL										--last_login_datetime
			,	@P_cre_user									--cre_user
			,	@P_cre_ip									--cre_ip
			,	'O0100'										--cre_prg
			,	@w_time										--cre_datetime
			,	SPACE(0)									--upd_user
			,	SPACE(0)									--upd_ip
			,	SPACE(0)									--upd_prg
			,	NULL										--upd_datetime
			,	SPACE(0)									--del_user
			,	SPACE(0)									--del_ip
			,	SPACE(0)									--del_prg
			,	NULL										--del_datetime
			FROM #TEMP
			DELETE W FROM  WRK_M0070 AS W INNER JOIN  #TEMP AS T ON W.company_cd = @P_company_cd AND W.exec_user = T.exec_user
			--
			--DELETE WRK_M0070
			INSERT INTO WRK_M0070 
			SELECT																
				#TEMP.exec_user															--exec_user	
			,	#TEMP.company_cd														--company_cd
			,	#TEMP.employee_cd														--employee_cd
			,	#TEMP.employee_last_nm													--employee_last_nm
			,	#TEMP.employee_first_nm													--employee_first_nm
			,	#TEMP.employee_nm														--employee_nm
			,	#TEMP.furigana															--furigana
			,	#TEMP.gender															--gender
			,	#TEMP.mail																--mail
			,	IIF(#TEMP.birth_date = '',NULL,#TEMP.birth_date)						--birth_date
			,	IIF(#TEMP.company_in_dt = '',NULL,#TEMP.company_in_dt)					--company_in_dt
			,	IIF(#TEMP.company_out_dt = '',NULL,#TEMP.company_out_dt)				--company_out_dt
			,	#TEMP.retirement_reason_typ																		--retirement_reason
			,	#TEMP.retirement_reason																	--retirement_reason
			,	#TEMP.evaluated_typ														--evaluated_typ
			,	#TEMP.oneonone_typ																		--1on1_typ
			,	#TEMP.multireview_typ																		--multireview_typ
			,	#TEMP.report_typ	
			,	#TEMP.office_cd															--office_cd
			,	#TEMP.belong_cd1														--belong_cd1
			,	#TEMP.belong_cd2														--belong_cd2
			,	#TEMP.belong_cd3														--belong_cd3
			,	#TEMP.belong_cd4														--belong_cd4
			,	#TEMP.belong_cd5														--belong_cd5
			,	#TEMP.job_cd															--job_cd
			,	#TEMP.position_cd														--position_cd
			,	#TEMP.employee_typ														--employee_typ
			,	#TEMP.grade																--grade
			,	#TEMP.salary_grade														--salary_grade													
			,	SPACE(0)																--picture
			,	#TEMP.company_mobile_number												--company_mobile_number
			,	#TEMP.extension_number													--extension_number
			,	@P_cre_user																--cre_user
			,	@P_cre_ip																--cre_ip
			,	'O0100'																	--cre_prg
			,	@w_time																	--cre_datetime
			,	SPACE(0)																--upd_user
			,	SPACE(0)																--upd_ip
			,	SPACE(0)																--upd_prg
			,	NULL																	--upd_datetime
			,	SPACE(0)																--del_user
			,	SPACE(0)																--del_ip
			,	SPACE(0)																--del_prg
			,	NULL		--del_datetime												--del_datetime
			FROM #TEMP
			--DELETE WRK_M0071
			--
			DELETE W FROM  WRK_M0071 AS W INNER JOIN  #TEMP AS T ON W.company_cd = T.company_cd AND W.exec_user = T.exec_user
			INSERT INTO WRK_M0071 
			SELECT 
				#TEMP.exec_user
			,	#TEMP.company_cd
			,	#TEMP.employee_cd
			,	@w_time
			,	#TEMP.office_cd		
			,	#TEMP.belong_cd1	
			,	#TEMP.belong_cd2
			,	#TEMP.belong_cd3
			,	#TEMP.belong_cd4
			,	#TEMP.belong_cd5	
			,	#TEMP.job_cd		
			,	#TEMP.position_cd	
			,	#TEMP.employee_typ	
			,	#TEMP.grade	
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
			FROM #TEMP
		END
		ELSE
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM WRK_S0010
			WHERE WRK_S0010.exec_user NOT LIKE '%'+CONCAT('WRK_S0010', CAST(@P_no AS NVARCHAR(10)))+'%')
			BEGIN
				INSERT INTO WRK_S0010 
				SELECT 
					CONCAT('WRK_S0010_', CAST(@P_no AS NVARCHAR(10)))		--exec_user					
				,	0														--company_cd
				,	''														--user_id
				,	''														--employee_cd
				,	''														--password
				,	''														--sso_user
				--,	1														--authority_typ
				,	0														--authority_typ	 edited by viettd 2021/09/14
				,	0														--authority_cd
				,	0														--[1on1_authority_typ]
				,	0														--1on1_authority_cd
				,	0														--[multireview_authority_typ]
				,	0														--multireview_authority_cd
				,	0														--[empinfo_authority_typ]
				,	0														--empinfo_authority_cd
				,	0														--[setting_authority_typ]
				,	0														--setting_authority_cd
				,	0														--[report_authority_typ]
				,	0														--report_authority_cd
				,	SPACE(0)												--remember_token
				,	0														--failed_login_count
				,	NULL													--pass_change_datetime
				,	SPACE(0)												--last_login_ip
				,	NULL													--last_login_datetime
				,	@P_cre_user												--cre_user
				,	@P_cre_ip												--cre_ip
				,	'O0100'													--cre_prg
				,	@w_time													--cre_datetime
				,	SPACE(0)												--upd_user
				,	SPACE(0)												--upd_ip
				,	SPACE(0)												--upd_prg
				,	NULL													--upd_datetime
				,	SPACE(0)												--del_user
				,	SPACE(0)												--del_ip
				,	SPACE(0)												--del_prg
				,	NULL													--del_datetime
			END
			IF NOT EXISTS (SELECT 1 FROM WRK_M0070
			WHERE WRK_M0070.exec_user NOT LIKE '%'+CONCAT('WRK_M0070', CAST(@P_no AS NVARCHAR(10)))+'%')
			BEGIN
				INSERT INTO WRK_M0070 
				SELECT 
					CONCAT('WRK_M0070_', CAST(@P_no AS NVARCHAR(10)))			--exec_user					
				,	0															--company_cd
				,	''															--employee_cd
				,	''															--employee_last_nm
				,	''															--employee_first_nm
				,	''															--employee_nm
				,	''															--furigana
				,	0															--gender
				,	''															--mail
				,	NULL														--birth_date
				,	NULL														--company_in_dt
				,	NULL														--company_out_dt
				,	0															--retirement_reason_typ
				,	''															--retirement_reason
				,	0															--evaluated_typ
				,	0															--1on1_typ
				,	0															--multireview_typ
				,	0															--report_typ
				,	0															--office_cd
				,	''															--belong_cd1
				,	''															--belong_cd2
				,	''															--belong_cd3
				,	''															--belong_cd4
				,	''															--belong_cd5
				,	0															--job_cd
				,	0															--position_cd
				,	0															--employee_typ
				,	0															--grade
				,	0															--salary_grade		
				,	''
				,	''															--company_mobile_number
				,	''															--extension_number
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
			END
			--
			IF NOT EXISTS (SELECT 1 FROM WRK_M0071
			WHERE WRK_M0071.exec_user NOT LIKE '%'+CONCAT('WRK_M0071', CAST(@P_no AS NVARCHAR(10)))+'%')
			BEGIN
				INSERT INTO WRK_M0071 
				SELECT 
					CONCAT('WRK_M0071_', CAST(@P_no AS NVARCHAR(10)))				
				,	0																
				,	''																
				,	NULL															
				,	0																
				,	''														
				,	''	
				,	''	
				,	''	
				,	''																
				,	0																
				,	0																
				,	0																
				,	0																
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
			END
		END																		
		--

		IF (@P_no = @P_count) 
		BEGIN
			--
			IF (EXISTS(SELECT 1 FROM @ERR_TBL) OR EXISTS(SELECT 1 FROM WRK_M0070 WHERE exec_user LIKE '%WRK_M0070%') 
											   OR EXISTS(SELECT 1 FROM WRK_M0071 WHERE exec_user LIKE '%WRK_M0071%')
											   OR EXISTS(SELECT 1 FROM WRK_S0010 WHERE exec_user LIKE '%WRK_S0010%'))
			BEGIN
				DELETE WRK_M0070
				DELETE WRK_M0071
				DELETE WRK_S0010
				--
				GOTO COMPLETE_QUERY
			END
			UPDATE S0010
			SET
				del_user			=	@P_cre_user
			,	del_ip				=	@P_cre_ip
			,	del_prg				=	'O0100'
			,	del_datetime		=	@w_time
			FROM S0010
			INNER JOIN WRK_S0010 ON (
				S0010.company_cd		=		WRK_S0010.company_cd
			AND S0010.employee_cd		=		WRK_S0010.employee_cd
			)
			WHERE
				S0010.authority_typ <> 4
			AND	WRK_S0010.[user_id] <> ''
			AND WRK_S0010.company_cd = @P_company_cd
			UPDATE S0010
			SET
				employee_cd			=	WRK_S0010.employee_cd
			,	failed_login_count	=	CASE WHEN WRK_S0010.password <> S0010.password
											 THEN 0
											 ELSE S0010.failed_login_count
										END
			,	sso_user			=	WRK_S0010.sso_user
			,	upd_user			=	@P_cre_user
			,	upd_ip				=	@P_cre_ip
			,	upd_prg				=	'O0100'
			,	upd_datetime		=	@w_time
			,	del_user			=	SPACE(0)
			,	del_ip				=	SPACE(0)
			,	del_prg				=	SPACE(0)
			,	del_datetime		=	NULL
			FROM S0010
			INNER JOIN WRK_S0010 ON (
				S0010.company_cd	=		WRK_S0010.company_cd
			AND S0010.[user_id]		=		WRK_S0010.[user_id]
			)
			WHERE
				WRK_S0010.[user_id] <> ''
			AND WRK_S0010.company_cd = @P_company_cd

			--INSERT
			INSERT INTO S0010
			SELECT 
				WRK_S0010.company_cd							
			,	WRK_S0010.[user_id]
			,	WRK_S0010.employee_cd
			,	''							AS	password
			,	WRK_S0010.sso_user
			,	WRK_S0010.authority_typ
			,	WRK_S0010.authority_cd
			,	WRK_S0010.[1on1_authority_typ]
			,	WRK_S0010.[1on1_authority_cd]
			,	WRK_S0010.multireview_authority_typ
			,	WRK_S0010.multireview_authority_cd
			,	WRK_S0010.empinfo_authority_typ
			,	WRK_S0010.empinfo_authority_cd
			,	WRK_S0010.report_authority_typ
			,	WRK_S0010.report_authority_cd
			,	WRK_S0010.setting_authority_typ
			,	WRK_S0010.setting_authority_cd
			,	1							--ver1.9
			,	NULL
			,	''
			,	WRK_S0010.remember_token
			,	0							AS failed_login_count
			,	WRK_S0010.pass_change_datetime
			,	WRK_S0010.last_login_ip
			,	WRK_S0010.last_login_datetime
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
			FROM WRK_S0010
			LEFT JOIN S0010 ON (
				WRK_S0010.company_cd		=	S0010.company_cd	
			AND WRK_S0010.[user_id]			=	S0010.[user_id]
			)
			WHERE 
				S0010.[user_id] IS NULL
			AND	WRK_S0010.[user_id] <> ''
			AND WRK_S0010.company_cd = @P_company_cd
			--
			DELETE WRK_S0010
			--
			UPDATE M0070
			SET
				employee_last_nm		=	WRK_M0070.employee_last_nm	
			,	employee_first_nm		=	WRK_M0070.employee_first_nm	
			,	employee_nm				=	WRK_M0070.employee_nm		
			,	furigana				=	WRK_M0070.furigana			
			,	gender					=	WRK_M0070.gender			
			,	mail					=	WRK_M0070.mail				
			,	birth_date				=	WRK_M0070.birth_date		
			,	company_in_dt			=	WRK_M0070.company_in_dt		
			,	company_out_dt			=	WRK_M0070.company_out_dt	
			,	retirement_reason_typ	=	WRK_M0070.retirement_reason_typ
			,	retirement_reason		=	WRK_M0070.retirement_reason
			,	evaluated_typ			=	WRK_M0070.evaluated_typ	
			,	[1on1_typ]				=	WRK_M0070.[1on1_typ]
			,	multireview_typ			=	WRK_M0070.multireview_typ
			,	report_typ				=	WRK_M0070.report_typ
			,	office_cd				=	WRK_M0070.office_cd			
			,	belong_cd1				=	WRK_M0070.belong_cd1		
			,	belong_cd2				=	WRK_M0070.belong_cd2
			,	belong_cd3				=	WRK_M0070.belong_cd3
			,	belong_cd4				=	WRK_M0070.belong_cd4
			,	belong_cd5				=	WRK_M0070.belong_cd5		
			,	job_cd					=	WRK_M0070.job_cd			
			,	position_cd				=	WRK_M0070.position_cd		
			,	employee_typ			=	WRK_M0070.employee_typ		
			,	grade					=	WRK_M0070.grade				
			,	salary_grade			=	WRK_M0070.salary_grade	
			,	company_mobile_number	=	WRK_M0070.company_mobile_number
			,	extension_number		=	WRK_M0070.extension_number
			,	upd_user				=	@P_cre_user		
			,	upd_ip					=	@P_cre_ip	
			,	upd_prg					=	'O0100'	
			,	upd_datetime			=	@w_time	
			,	del_user				=	SPACE(0)
			,	del_ip					=	SPACE(0)
			,	del_prg					=	SPACE(0)
			,	del_datetime			=	NULL
			FROM M0070 
			INNER JOIN WRK_M0070 ON (
				M0070.company_cd		=	WRK_M0070.company_cd
			AND M0070.employee_cd		=	WRK_M0070.employee_cd
			AND WRK_M0070.company_cd    = @P_company_cd
			)
			
			--
			INSERT INTO M0070
			SELECT 
				WRK_M0070.company_cd
			,	WRK_M0070.employee_cd
			,	WRK_M0070.employee_last_nm	
			,	WRK_M0070.employee_first_nm	
			,	WRK_M0070.employee_nm		
			,	WRK_M0070.furigana			
			,	WRK_M0070.gender			
			,	WRK_M0070.mail				
			,	WRK_M0070.birth_date		
			,	WRK_M0070.company_in_dt		
			,	WRK_M0070.company_out_dt	
			,	WRK_M0070.retirement_reason_typ
			,	WRK_M0070.retirement_reason
			,	WRK_M0070.evaluated_typ		
			,	WRK_M0070.[1on1_typ]
			,	WRK_M0070.multireview_typ
			,	WRK_M0070.report_typ
			,	WRK_M0070.office_cd			
			,	WRK_M0070.belong_cd1		
			,	WRK_M0070.belong_cd2
			,	WRK_M0070.belong_cd3
			,	WRK_M0070.belong_cd4
			,	WRK_M0070.belong_cd5		
			,	WRK_M0070.job_cd			
			,	WRK_M0070.position_cd		
			,	WRK_M0070.employee_typ		
			,	WRK_M0070.grade				
			,	WRK_M0070.salary_grade		
			,	WRK_M0070.picture
			,	WRK_M0070.company_mobile_number
			,	WRK_M0070.extension_number
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
			FROM WRK_M0070
			LEFT JOIN M0070 ON (
				WRK_M0070.company_cd		=	M0070.company_cd	
			AND WRK_M0070.employee_cd		=	M0070.employee_cd
			)
			WHERE 
				M0070.employee_cd IS NULL
			AND	WRK_M0070.employee_cd <> ''
			AND WRK_M0070.company_cd    = @P_company_cd
			--
			DELETE WRK_M0070
			--
			UPDATE M0071
			SET
				office_cd			=	WRK_M0071.office_cd		
			,	belong_cd1			=	WRK_M0071.belong_cd1		
			,	belong_cd2			=	WRK_M0071.belong_cd2
			,	belong_cd3			=	WRK_M0071.belong_cd3
			,	belong_cd4			=	WRK_M0071.belong_cd4
			,	belong_cd5			=	WRK_M0071.belong_cd5		
			,	job_cd				=	WRK_M0071.job_cd			
			,	position_cd			=	WRK_M0071.position_cd		
			,	employee_typ		=	WRK_M0071.employee_typ	
			,	grade				=	WRK_M0071.grade				
			,	upd_user			=	@P_cre_user		
			,	upd_ip				=	@P_cre_ip	
			,	upd_prg				=	'O0100'	
			,	upd_datetime		=	@w_time	
			,	del_user			=	SPACE(0)
			,	del_ip				=	SPACE(0)
			,	del_prg				=	SPACE(0)
			,	del_datetime		=	NULL
			FROM M0071 
			INNER JOIN WRK_M0071 ON (
				M0071.company_cd		=	WRK_M0071.company_cd
			AND M0071.employee_cd		=	WRK_M0071.employee_cd
			AND M0071.application_date	=	WRK_M0071.application_date
			AND WRK_M0071.company_cd    = @P_company_cd
			)

			--
			INSERT INTO M0071
			SELECT 
				WRK_M0071.company_cd
			,	WRK_M0071.employee_cd
			,	WRK_M0071.application_date
			,	WRK_M0071.office_cd	
			,	WRK_M0071.belong_cd1		
			,	WRK_M0071.belong_cd2
			,	WRK_M0071.belong_cd3
			,	WRK_M0071.belong_cd4
			,	WRK_M0071.belong_cd5		
			,	WRK_M0071.job_cd			
			,	WRK_M0071.position_cd		
			,	WRK_M0071.employee_typ	
			,	WRK_M0071.grade					
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
			FROM WRK_M0071
			LEFT JOIN M0071 ON (
				WRK_M0071.company_cd		=	M0071.company_cd	
			AND WRK_M0071.employee_cd		=	M0071.employee_cd
			AND WRK_M0071.application_date	=	M0071.application_date		
			)
			WHERE 
				M0071.employee_cd IS NULL
			AND WRK_M0071.employee_cd <>''
			AND WRK_M0071.application_date <>''
			AND WRK_M0071.company_cd    = @P_company_cd
			GROUP BY WRK_M0071.company_cd
			,	WRK_M0071.employee_cd
			,	WRK_M0071.application_date 
			,	WRK_M0071.office_cd	
			,	WRK_M0071.belong_cd1	
			,	WRK_M0071.belong_cd2
			,	WRK_M0071.belong_cd3
			,	WRK_M0071.belong_cd4
			,	WRK_M0071.belong_cd5	
			,	WRK_M0071.job_cd			
			,	WRK_M0071.position_cd		
			,	WRK_M0071.employee_typ	
			,	WRK_M0071.grade			
			--
			--INSERT INTO M0071
			--SELECT 
			--	WRK_M0071.company_cd
			--,	WRK_M0071.employee_cd
			--,	WRK_M0071.application_date
			--,	WRK_M0071.office_cd		
			--,	WRK_M0071.belong_cd1		
			--,	WRK_M0071.belong_cd2
			--,	WRK_M0071.belong_cd3
			--,	WRK_M0071.belong_cd4
			--,	WRK_M0071.belong_cd5		
			--,	WRK_M0071.job_cd			
			--,	WRK_M0071.position_cd		
			--,	WRK_M0071.employee_typ	
			--,	WRK_M0071.grade				
			--,	@P_cre_user			
			--,	@P_cre_ip
			--,	'O0100'				
			--,	@w_time
			--,	SPACE(0)
			--,	SPACE(0)
			--,	SPACE(0)
			--,	NULL	
			--,	SPACE(0)
			--,	SPACE(0)
			--,	SPACE(0)
			--,	NULL	
			--FROM WRK_M0071
			--LEFT JOIN M0071 ON (
			--	WRK_M0071.company_cd		=	M0071.company_cd	
			--AND WRK_M0071.employee_cd		=	M0071.employee_cd
			--AND WRK_M0071.application_date	=	M0071.application_date		
			--)
			--WHERE 
			--	M0071.employee_cd IS NULL
			--AND WRK_M0071.employee_cd = ''
			--AND WRK_M0071.application_date  = ''
			--AND WRK_M0071.company_cd    = @P_company_cd

			--
			DELETE WRK_M0071
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
