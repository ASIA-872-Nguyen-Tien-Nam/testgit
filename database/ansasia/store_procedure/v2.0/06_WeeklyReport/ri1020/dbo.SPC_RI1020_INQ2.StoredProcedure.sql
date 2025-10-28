DROP PROCEDURE [SPC_RI1020_INQ2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--	
--****************************************************************************************
--*  --*  処理概要/process overview	:	rI1020-add_row
--*  作成日/create date			:	2023/06/13					
--*　作成者/creater				:	namnt								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:
--*　更新内容/update content		:	
--*   EXEC SPC_RI1020_FND1 '{"fiscal_year":"2023","group_cd":"1","report_kinds":"5","month":"-1","time":"-1","employee_typ":-1,"employee_cdX":"","ck_search":0,"employee_cd":"","employee_nm":"","list_organization_step1":[{"organization_cd_1":"1","organization_cd_2":"","organization_cd_3":"","organization_cd_4":"","organization_cd_5":""}],"list_organization_step2":[{"organization_cd_1":""}],"list_organization_step3":[{"organization_cd_1":""}],"list_organization_step4":[],"list_organization_step5":[],"page":1,"page_size":20}','721','740','0';
--****************************************************************************************
CREATE PROCEDURE [SPC_RI1020_INQ2]
	-- Add the parameters for the stored procedure here
	@P_json						NVARCHAR(max)		=	''	
,	@P_cre_user					NVARCHAR(50)		=	''		-- login user id
,	@P_company_cd				SMALLINT			=	0
,	@P_mode						SMALLINT			=	0
,	@P_json_approval			NVARCHAR(max)		=	''	
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								datetime			=	SYSDATETIME()
	,	@w_totalRecord						bigint				=	0
	,	@w_pageMax							int					=	0	
	,	@w_page_size						int					=	50
	,	@w_page								int					=	0
	--
	,	@w_report_authority_typ				smallint			=	0
	,	@w_report_authority_cd				smallint			=	0

	,	@w_arrange_order					int					=	0
	,	@w_login_position_cd				int					=	0
	,	@w_login_employee_cd				nvarchar(10)		=	''
	,	@w_choice_in_screen					tinyint				=	0
	,	@w_report_organization_cnt			INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	,	@w_today							date				=	NULL
	,	@w_system_authority_typ				smallint			=	0
	,	@w_current_year						int					=	NULL
	--
	,	@w_report_kinds						smallint			=	0
	,	@P_fiscal_year						smallint			=	0
	,	@P_group_cd							smallint			=	0
	,	@w_employee_cdX						nvarchar(10)		=	''
	,	@w_month							smallint			=	0
	,	@w_times							smallint			=	0
	,	@w_deadline_date					date				=	NULL
	,	@w_start_date						date				=	NULL
	,	@w_end_date							date				=	NULL
	,	@w_beginning_date					date				=	NULL
	,	@w_language							smallint			=	1
	,	@P_authority_cd						SMALLINT			=	0
	,	@P_authority_typ					SMALLINT			=	0
	,	@w_position_cd						INT					=	0
	,	@w_use_typ							INT					=	0
	,	@w_date_refer						DATETIME			=	NULL
	,	@w_approver_position_1				SMALLINT			=	0
	,	@w_approver_position_2				SMALLINT			=	0
	,	@w_approver_position_3				SMALLINT			=	0
	,	@w_approver_position_4				SMALLINT			=	0
	,	@w_belong_cd1						NVARCHAR(10)		=	''
	,	@w_belong_cd2						NVARCHAR(10)		=	''
	,	@w_belong_cd3						NVARCHAR(10)		=	''
	,	@w_belong_cd4						NVARCHAR(10)		=	''
	,	@w_belong_cd5						NVARCHAR(10)		=	''
	,	@w_ck_search						SMALLINT			=	0   --0 unchecked  1 checked					
	--
	IF object_id('tempdb..#TABLE_ORGANIZATION', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_ORGANIZATION
    END
	--
	IF object_id('tempdb..#M0070H', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070H
    END
	--#TABLE_ORGANIZATION
	CREATE TABLE #TABLE_ORGANIZATION (
		organization_typ				tinyint
	,	organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)	
	,	choice_in_screen				tinyint	
	)
	CREATE TABLE #TABLE_ORGANIZATION_IN_GROUP (
		organization_typ				tinyint
	,	organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)	
	,	choice_in_screen				tinyint	
	)
	--#LIST_POSITION
	CREATE TABLE #LIST_POSITION(
		id								int			identity(1,1)
	,	position_cd						int
	,	mode							smallint	-- 0.choice in screen 1. get from master
	)
	--#M0070H
	CREATE TABLE #M0070H(
		application_date				date
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(200)
	,	employee_ab_nm					nvarchar(50)
	,	furigana						nvarchar(50)
	,	office_cd						smallint
	,	office_nm						nvarchar(50)
	,	belong_cd_1						nvarchar(20)
	,	belong_cd_2						nvarchar(20)
	,	belong_cd_3						nvarchar(20)
	,	belong_cd_4						nvarchar(20)
	,	belong_cd_5						nvarchar(20)
	,	job_cd							smallint
	,	position_cd						int
	,	employee_typ					smallint
	,	grade							smallint
	,	belong_nm_1						nvarchar(50)
	,	belong_nm_2						nvarchar(50)
	,	belong_nm_3						nvarchar(50)
	,	belong_nm_4						nvarchar(50)
	,	belong_nm_5						nvarchar(50)
	,	job_nm							nvarchar(50)
	,	position_nm						nvarchar(50)
	,	grade_nm						nvarchar(50)
	,	employee_typ_nm					nvarchar(50)
	)
	--
	CREATE TABLE #M4602 (
		company_cd				SMALLINT
	,	group_cd				SMALLINT
	,	attribute				SMALLINT
	,	code					SMALLINT	
	)	
	--
	CREATE TABLE #M0060
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	employee_typ			SMALLINT
	,	group_cd				SMALLINT
	)	
	--
	CREATE TABLE #M0050
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	grade					SMALLINT
	,	group_cd				SMALLINT
	)
	--
	CREATE TABLE #M0040
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	position_cd				INT
	,	group_cd				SMALLINT
	)
	--
	CREATE TABLE #M0030
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	job_cd					SMALLINT
	,	group_cd				SMALLINT
	)
	CREATE TABLE #APPROVAL_CD
	(
		employee_cd					NVARCHAR(10)
	,	approver_cd_1				NVARCHAR(10)
	,	approver_cd_2				NVARCHAR(10)
	,	approver_cd_3				NVARCHAR(10)
	,	approver_cd_4				NVARCHAR(10)
	,	approver_nm_1				NVARCHAR(101)
	,	approver_nm_2				NVARCHAR(101)
	,	approver_nm_3				NVARCHAR(101)
	,	approver_nm_4				NVARCHAR(101)
	)
	--
	CREATE TABLE #M0070_EMPLOYEE_CD
	(
		id							BIGINT	IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	employee_typ				SMALLINT
	,	job_cd						SMALLINT
	,	position_cd					INT
	,	grade						SMALLINT
	,	belong_cd_1		nvarchar(20)
	,	belong_cd_2		nvarchar(20)
	,	belong_cd_3		nvarchar(20)
	,	belong_cd_4		nvarchar(20)
	,	belong_cd_5		nvarchar(20)
	)
	--
	CREATE TABLE #F4110
	(
		company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	report_kind					SMALLINT
	,	report_no					SMALLINT
	,	approver_employee_cd_1		NVARCHAR(10)
	,	approver_employee_cd_2		NVARCHAR(10)
	,	approver_employee_cd_3		NVARCHAR(10)
	,	approver_employee_cd_4		NVARCHAR(10)
	,	sheet_cd					SMALLINT
	,	adaption_date				DATE
	,	group_cd					SMALLINT
	,	group_nm					NVARCHAR(20)
	)	
	-- get list sheet_cd
	CREATE TABLE #TABLE_SHEET (
		id				int			identity(1,1)
	,	sheet_cd		smallint
	,	adaption_date	date
	)
	CREATE TABLE #HEADER(
		group_cd							NVARCHAR(50)
	,	group_nm							NVARCHAR(50)
	,	employee_cd					   		NVARCHAR(50)
	,	employee_nm					   		NVARCHAR(200)
	,	approver_employee_cd_1			   	NVARCHAR(50)
	,	approver_employee_nm_1			   	NVARCHAR(200)
	,	approver_employee_cd_2			   	NVARCHAR(50)
	,	approver_employee_nm_2			   	NVARCHAR(200)
	,	approver_employee_cd_3			   	NVARCHAR(50)
	,	approver_employee_nm_3			   	NVARCHAR(200)
	,	approver_employee_cd_4			   	NVARCHAR(50)
	,	approver_employee_nm_4			   	NVARCHAR(200)
	)
	CREATE TABLE #DATA_CSV(
		id									INT IDENTITY(1,1) 
	,	group_cd							NVARCHAR(50)
	,	group_nm							NVARCHAR(200)
	,	employee_cd					   		NVARCHAR(50)
	,	employee_nm					   		NVARCHAR(200)
	,	approver_employee_cd_1			   	NVARCHAR(50)
	,	approver_employee_nm_1			   	NVARCHAR(200)
	,	approver_employee_cd_2			   	NVARCHAR(50)
	,	approver_employee_nm_2			   	NVARCHAR(200)
	,	approver_employee_cd_3			   	NVARCHAR(50)
	,	approver_employee_nm_3			   	NVARCHAR(200)
	,	approver_employee_cd_4			   	NVARCHAR(50)
	,	approver_employee_nm_4			   	NVARCHAR(200)
	)
	CREATE TABLE #TEMP_TIME(
		detail_no					SMALLINT
	,	month						SMALLINT
	,	normal_month				SMALLINT
	,	start_date					DATETIME
	,	deadline_date				DATETIME
	)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--GET INFORMATION 
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	
	SELECT 
		@P_authority_cd			=	S0010.report_authority_cd
	,	@P_authority_typ		=	S0010.report_authority_typ
	,	@w_position_cd			=	ISNULL(M0070.position_cd,0)
	,	@w_language				=	ISNULL(S0010.language,1)
	,	@w_login_employee_cd	=	ISNULL(M0070.employee_cd,'')
	FROM S0010 
	LEFT JOIN M0070 ON (
		M0070.company_cd		=	S0010.company_cd
	AND M0070.employee_cd		=	S0010.employee_cd
	AND M0070.del_datetime		IS NULL 
	) 
	WHERE
		S0010.company_cd		=	@P_company_cd
	AND S0010.user_id			=	@P_cre_user
	AND S0010.del_datetime IS NULL
	SELECT
		@w_language	= ISNULL(S0010.language,1)
	FROM S0010
	WHERE
		S0010.company_cd			=	@P_company_cd
	AND S0010.user_id				=	@P_cre_user
	AND S0010.del_datetime IS NULL
	SELECT 
		@w_use_typ		=	ISNULL(S4020.use_typ,0)	
	FROM S4020
	WHERE
		S4020.company_cd		=	@P_company_cd
	AND S4020.authority_cd		=	@P_authority_cd
	AND S4020.del_datetime IS NULL
	SET @w_arrange_order	= ISNULL((SELECT ISNULL(M0040.arrange_order,0) FROM M0040 WHERE M0040.del_datetime IS NULL AND M0040.position_cd = @w_position_cd AND M0040.company_cd = @P_company_cd),0)

	SET @w_report_authority_typ = IIF(@w_report_authority_typ = 6,2,@w_report_authority_typ)

	SET @w_current_year = [dbo].FNC_GET_YEAR_WEEKLY_REPORT(@P_company_cd,NULL)
	-- COUNT ALL ORGANIZATIONS
	SET @w_report_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@P_authority_cd, 5)
	-- GET @w_organization_belong_person_typ
	SET @w_organization_belong_person_typ = ISNULL([dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@P_authority_cd, 5),0)
	--
	SET @w_page				=	JSON_VALUE(@P_json,'$.page')
	SET @w_page_size		=	JSON_VALUE(@P_json,'$.page_size')
	--
	SET	@w_report_kinds		=	JSON_VALUE(@P_json,'$.report_kinds')
	SET	@P_fiscal_year		=	JSON_VALUE(@P_json,'$.fiscal_year')
	SET	@P_group_cd			=	JSON_VALUE(@P_json,'$.group_cd')
	SET	@w_employee_cdX		=	JSON_VALUE(@P_json,'$.employee_cdX')
	SET	@w_month			=	IIF(JSON_VALUE(@P_json,'$.month')=-1,0,JSON_VALUE(@P_json,'$.month'))
	SET	@w_times			=	IIF(JSON_VALUE(@P_json,'$.time')=-1,0,JSON_VALUE(@P_json,'$.time'))
	SET	@w_ck_search		=	IIF(JSON_VALUE(@P_json,'$.ck_search')=-1,0,JSON_VALUE(@P_json,'$.ck_search'))
	INSERT INTO #TEMP_TIME
	EXEC [dbo].SPC_WEEKLYREPORT_GET_WEEKLY @P_company_cd,@P_fiscal_year,@w_month
	IF @P_group_cd = -1 
	BEGIN
	SET @P_group_cd = 0
	END
	IF @w_month <> 0
	BEGIN
	SELECT TOP 1 @w_month = normal_month FROM #TEMP_TIME
	END
	-- INSERT DATA INTO #TABLE_ORGANIZATION
	SELECT
		@w_date_refer = MAX(F4100.deadline_date) FROM F4100
	WHERE
		F4100.company_cd = @P_company_cd
	AND F4100.fiscal_year = @P_fiscal_year
	AND F4100.report_kind	= @w_report_kinds
	AND(
		@w_month = 0
	OR	(@w_month <> 0 AND F4100.month = @w_month)
	)
	AND(
		@w_times = 0
	OR	(@w_times <> 0 AND F4100.detail_no = @w_times)
	)
	AND(
		@P_group_cd = 0
	OR	(@P_group_cd <> 0 AND F4100.group_cd = @P_group_cd)
	)
	AND F4100.user_typ = 1
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 @P_json,@P_cre_user,@P_company_cd, 5
	INSERT INTO #TABLE_ORGANIZATION_IN_GROUP
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 '{}',@P_cre_user,@P_company_cd, 5
		-- #M0070H
	IF NOT EXISTS (SELECT 1 FROM #LIST_POSITION)
	BEGIN
		-- 本人の役職より下位の社員のみ
		IF @w_use_typ = 1
		BEGIN
			INSERT INTO #LIST_POSITION
			SELECT 
				ISNULL(M0040.position_cd,0)				AS	position_cd
			,	1
			FROM M0040
			WHERE 
				M0040.company_cd		=	@P_company_cd
			AND M0040.arrange_order		>	@w_arrange_order		-- 1. 本人の役職より下位の社員のみ
			AND M0040.del_datetime IS NULL
		END
		ELSE
		BEGIN
			INSERT INTO #LIST_POSITION
			SELECT 
				ISNULL(M0040.position_cd,0)				AS	position_cd
			,	1
			FROM M0040
			WHERE 
				M0040.company_cd		=	@P_company_cd
			AND M0040.del_datetime IS NULL
		END
	END
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @w_date_refer,'',@P_company_cd
	-- get schedule deadline date
	SELECT 
		@w_deadline_date = MAX(F4100.deadline_date)	
	FROM F4100
	WHERE 
		F4100.company_cd		=	@P_company_cd
	AND F4100.fiscal_year		=	@P_fiscal_year
	AND F4100.group_cd			=	@P_group_cd
	AND F4100.report_kind		=	@w_report_kinds
	AND (
		(@w_month = 0)
	OR	(@w_month <> 0 AND F4100.month = @w_month)
	)
	AND (
		(@w_times = 0)
	OR	(@w_times <> 0 AND F4100.detail_no = @w_times)
	)
	AND F4100.del_datetime IS NULL
	
	SELECT 
		@w_beginning_date = M9100.report_beginning_date 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	IF @w_beginning_date IS NOT NULL
	BEGIN
		SET @w_start_date	=	CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/' + FORMAT(@w_beginning_date,'MM/dd')) AS DATE)
	END
	ELSE
	BEGIN
		SET @w_start_date	=	CAST((CAST(YEAR(@P_fiscal_year) AS nvarchar(4)) + '/01/01') AS DATE)
	END
	SET @w_end_date = DATEADD(year, 1, @w_start_date)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--GET DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--
	INSERT INTO #M4602
	SELECT
		M4602.company_cd			
	,	M4602.group_cd			
	,	M4602.attribute					
	,	M4602.code						
	FROM M4600
	LEFT JOIN M4602 ON (
		M4600.company_cd = M4602.company_cd
	AND M4600.group_cd	= M4602.group_cd
	)	
	WHERE
		M4602.company_cd	=	@P_company_cd
	AND M4602.group_cd		=	@P_group_cd
	AND M4602.del_datetime	IS NULL
	GROUP BY 
		M4602.company_cd
	,	M4602.group_cd	
	,	M4602.attribute	
	,	M4602.code	
	--
	INSERT INTO #M0060
	SELECT 
		M0060.company_cd		
	,	M0060.employee_typ
	,	#M4602.group_cd
	FROM M0060
	INNER JOIN #M4602 ON (
		M0060.company_cd	= #M4602.company_cd
	AND	M0060.employee_typ	= #M4602.code
	)
	WHERE 
		 M0060.company_cd = @P_company_cd
	 AND M0060.del_datetime IS NULL
	 AND #M4602.attribute = 4
	--
	INSERT INTO #M0050
	SELECT 
		M0050.company_cd		
	,	M0050.grade
	,	#M4602.group_cd
	FROM M0050
	INNER JOIN #M4602 ON (
		M0050.company_cd	= #M4602.company_cd
	AND	M0050.grade			= #M4602.code
	)
	WHERE 
		 M0050.company_cd = @P_company_cd
	 AND M0050.del_datetime IS NULL
	 AND #M4602.attribute = 3
	--
	INSERT INTO #M0040
	SELECT 
		M0040.company_cd
	,	M0040.position_cd
	,	#M4602.group_cd
	FROM M0040
	INNER JOIN #M4602 ON (
		M0040.company_cd	= #M4602.company_cd
	AND	M0040.position_cd	= #M4602.code
	)
	WHERE 
		 M0040.company_cd = @P_company_cd
	 AND M0040.del_datetime IS NULL
	 AND #M4602.attribute = 1
	--
	INSERT INTO #M0030
	SELECT 
		M0030.company_cd
	,	M0030.job_cd
	,	#M4602.group_cd
	FROM M0030
	INNER JOIN #M4602 ON (
		M0030.company_cd	= #M4602.company_cd
	AND	M0030.job_cd		= #M4602.code
	)
	WHERE 
		 M0030.company_cd = @P_company_cd
	 AND M0030.del_datetime IS NULL
	 AND #M4602.attribute = 2
	 --
	INSERT INTO #M0070_EMPLOYEE_CD
	SELECT 
		#M0070H.company_cd
	,	-1						
	,	#M0070H.employee_cd
	,	#M0070H.employee_typ
	,	#M0070H.job_cd
	,	#M0070H.position_cd
	,	#M0070H.grade
	,	#M0070H.belong_cd_1	
	,	#M0070H.belong_cd_2	
	,	#M0070H.belong_cd_3	
	,	#M0070H.belong_cd_4	
	,	#M0070H.belong_cd_5
	FROM M0070
	INNER JOIN #M0070H ON (
		M0070.company_cd	= #M0070H.company_cd
	AND M0070.employee_cd	= #M0070H.employee_cd
	)
	WHERE 
		M0070.company_cd	= @P_company_cd
	AND M0070.report_typ	<> 0
	AND M0070.del_datetime	IS NULL
	AND (
		@w_employee_cdX = ''
	OR	@w_employee_cdX <> '' AND #M0070H.employee_cd = @w_employee_cdX
	)
	AND M0070.company_in_dt < @w_end_date
	AND (
		M0070.company_out_dt IS NULL
	OR(M0070.company_out_dt IS NOT NULL AND M0070.company_out_dt > @w_start_date)
	)
	--
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--FILTER DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- FILTER 組織
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
	BEGIN
		SET @w_choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
		-- 1.choice in screen
		IF @w_choice_in_screen = 1
		BEGIN
			DELETE D  FROM #M0070_EMPLOYEE_CD AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION_IN_GROUP AS S ON (
				D.company_cd			=	@P_company_cd
			AND D.belong_cd_1			=	S.organization_cd_1
			AND D.belong_cd_2			=	S.organization_cd_2
			AND D.belong_cd_3			=	S.organization_cd_3
			AND D.belong_cd_4			=	S.organization_cd_4
			AND D.belong_cd_5			=	S.organization_cd_5
			)
			WHERE 
				(D.company_cd IS NULL
			OR	S.organization_typ IS NULL)
			AND D.group_cd = -1
		END
		ELSE IF NOT (@P_authority_typ = 3 AND @w_report_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)
		BEGIN
			DELETE D FROM #M0070_EMPLOYEE_CD AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION_IN_GROUP AS S ON (
				D.company_cd			=	@P_company_cd
			AND D.belong_cd_1			=	S.organization_cd_1
			AND D.belong_cd_2			=	S.organization_cd_2
			AND D.belong_cd_3			=	S.organization_cd_3
			AND D.belong_cd_4			=	S.organization_cd_4
			AND D.belong_cd_5			=	S.organization_cd_5
			)
			WHERE 
				D.company_cd IS NULL
			OR	S.organization_typ IS NULL
			AND @P_authority_typ NOT IN(4,5)		--4.会社管理者 5.総合管理者
			AND D.group_cd = -1
		END

		IF NOT (@P_authority_typ = 3 AND @w_report_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)
		BEGIN
			DELETE D FROM #M0070_EMPLOYEE_CD AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION_IN_GROUP AS S ON (
				D.company_cd			=	@P_company_cd
			AND D.belong_cd_1			=	S.organization_cd_1
			AND D.belong_cd_2			=	S.organization_cd_2
			AND D.belong_cd_3			=	S.organization_cd_3
			AND D.belong_cd_4			=	S.organization_cd_4
			AND D.belong_cd_5			=	S.organization_cd_5
			)
			WHERE 
				D.company_cd IS NULL
			OR	S.organization_typ IS NULL
			AND @P_authority_typ NOT IN(4,5)		--4.会社管理者 5.総合管理者
			AND D.group_cd > 0
		END
	END
	

	IF @w_use_typ = 1
	BEGIN
		DELETE D FROM #M0070_EMPLOYEE_CD AS D
		LEFT OUTER JOIN M0040 ON (
			D.company_cd		=	M0040.company_cd
		AND D.position_cd		=	M0040.position_cd
		)
		WHERE
			M0040.arrange_order <=	@w_arrange_order
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	INSERT INTO #F4110
	SELECT 
		#M0070_EMPLOYEE_CD.company_cd
	,	@P_fiscal_year
	,	#M0070_EMPLOYEE_CD.employee_cd
	,	@w_report_kinds
	,	ISNULL(F4110_TMP.report_no,0)			AS	report_no
	,	ISNULL(F4200.approver_employee_cd_1,'')	AS	approver_employee_cd_1
	,	ISNULL(F4200.approver_employee_cd_2,'')	AS	approver_employee_cd_2
	,	ISNULL(F4200.approver_employee_cd_3,'')	AS	approver_employee_cd_3
	,	ISNULL(F4200.approver_employee_cd_4,'')	AS	approver_employee_cd_4
	,	ISNULL(F4200.sheet_cd,0)				AS	sheet_cd
	,	F4200.adaption_date						AS	adaption_date
	,	F4110_TMP.group_cd						AS	group_cd
	,	F4110_TMP.group_nm						AS	group_nm
	FROM #M0070_EMPLOYEE_CD
	LEFT JOIN (
		SELECT 
			F4110.company_cd		AS	company_cd
		,	F4110.fiscal_year		AS	fiscal_year
		,	F4110.employee_cd		AS	employee_cd
		,	F4110.report_kind		AS	report_kind
		,	MAX(F4110.report_no)	AS	report_no
		,	ISNULL(F4110.group_cd,0)AS	group_cd
		,	M4600.group_nm			AS	group_nm
		FROM F4110 INNER JOIN M4600 ON(
			F4110.company_cd	=	M4600.company_cd
		AND F4110.group_cd		=	M4600.group_cd
		)
		WHERE 
			F4110.company_cd	=	@P_company_cd
		AND F4110.fiscal_year	=	@P_fiscal_year
		AND F4110.report_kind	=	@w_report_kinds
		AND F4110.del_datetime	IS NULL
		--AND F4110.group_cd		=	@P_group_cd
		AND (
			(@P_group_cd <= 0)
		OR	(@P_group_cd > 0 AND F4110.group_cd = @P_group_cd)
		)
		AND (
			(@w_month = 0)
		OR	(@w_month <> 0 AND F4110.[month]	=	@w_month)
		)
		AND (
			(@w_times = 0)
		OR  (@w_times <> 0 AND F4110.times	=	@w_times)
		)
		GROUP BY
			F4110.company_cd	
		,	F4110.fiscal_year	
		,	F4110.employee_cd	
		,	F4110.report_kind	
		,	F4110.group_cd	
		,	M4600.group_nm
	) AS F4110_TMP ON(
		#M0070_EMPLOYEE_CD.company_cd	=	F4110_TMP.company_cd
	AND @P_fiscal_year					=	F4110_TMP.fiscal_year
	AND #M0070_EMPLOYEE_CD.employee_cd	=	F4110_TMP.employee_cd
	AND @w_report_kinds					=	F4110_TMP.report_kind
	)
	LEFT OUTER JOIN F4200 ON (
		F4110_TMP.company_cd		=	F4200.company_cd
	AND F4110_TMP.fiscal_year		=	F4200.fiscal_year
	AND F4110_TMP.employee_cd		=	F4200.employee_cd
	AND F4110_TMP.report_kind		=	F4200.report_kind
	AND F4110_TMP.report_no			=	F4200.report_no
	AND F4200.del_datetime IS NULL
	)

	IF @w_ck_search = 1 
	BEGIN
		DELETE D FROM #F4110 AS D
		WHERE
			D.group_cd IS NOT NULL
	END

	SET @w_totalRecord = (SELECT COUNT(1) FROM #F4110)
	SET @w_pageMax = CEILING(CAST(@w_totalRecord AS FLOAT) / @w_page_size)
	IF @w_pageMax = 0
	BEGIN
		SET @w_pageMax = 1
	END
	IF @w_page > @w_pageMax
	BEGIN
		SET @w_page = @w_pageMax
	END
	-- 0. ■■■■■■■■■■■■■■■■■■ search
		--[0]
		SELECT 
			ROW_NUMBER() OVER(ORDER BY #M0070_EMPLOYEE_CD.employee_cd) 
															AS	[row_number]
		,	#M0070_EMPLOYEE_CD.employee_cd					AS	employee_cd
		,	ISNULL(#M0070H.employee_nm,'')					AS	employee_nm
		,	ISNULL(#M0070H.employee_typ,'')					AS	employee_typ
		,	ISNULL(#M0070H.employee_typ_nm,'')				AS	employee_typ_nm
		,	ISNULL(#M0070H.belong_nm_1,'')					AS	belong_nm1
		,	ISNULL(#M0070H.belong_nm_2,'')					AS	belong_nm2
		,	ISNULL(#M0070H.belong_nm_3,'')					AS	belong_nm3
		,	ISNULL(#M0070H.belong_nm_4,'')					AS	belong_nm4
		,	ISNULL(#M0070H.belong_nm_5,'')					AS	belong_nm5
		,	ISNULL(#M0070H.belong_cd_1,'')					AS	belong_cd1
		,	ISNULL(#M0070H.belong_cd_2,'')					AS	belong_cd2
		,	ISNULL(#M0070H.belong_cd_3,'')					AS	belong_cd3
		,	ISNULL(#M0070H.belong_cd_4,'')					AS	belong_cd4
		,	ISNULL(#M0070H.belong_cd_5,'')					AS	belong_cd5
		,	ISNULL(#M0070H.position_nm,'')					AS	position_nm
		,	ISNULL(#M0070H.position_cd,'')					AS	position_cd
		,	ISNULL(#M0070H.job_nm,'')						AS	job_nm
		,	ISNULL(#M0070H.job_cd,'')						AS	job_cd
		,	ISNULL(#M0070H.grade,'')						AS	grade
		,	ISNULL(#M0070H.grade_nm,'')						AS	grade_nm
		,	ISNULL(#F4110.approver_employee_cd_1,'')		AS	approver_employee_cd_1			   	
		,	ISNULL(approver_1.employee_nm, '')				AS	approver_employee_nm_1			   	
		,	ISNULL(#F4110.approver_employee_cd_2, '')		AS	approver_employee_cd_2			   	
		,	ISNULL(approver_2.employee_nm, '')				AS	approver_employee_nm_2			   	
		,	ISNULL(#F4110.approver_employee_cd_3, '')		AS	approver_employee_cd_3			   	
		,	ISNULL(approver_3.employee_nm, '')				AS	approver_employee_nm_3			   	
		,	ISNULL(#F4110.approver_employee_cd_4, '')		AS	approver_employee_cd_4			   	
		,	ISNULL(approver_4.employee_nm, '')				AS	approver_employee_nm_4	
		--	SCHEDULE SHEET
		,	ISNULL(M4610.sheet_cd,0)						AS	schedule_sheet_cd
		,	ISNULL(M4200_MAX.sheet_nm,'')					AS	schedule_sheet_nm
		,	M4200_MAX.adaption_date							AS	schedule_adaption_date
		--	F4111 SHEET
		,	ISNULL(#F4110.sheet_cd, 0)						AS	sheet_cd
		,	#F4110.adaption_date							AS	adaption_date
		--	F4200.report_no
		,	ISNULL(#F4110.report_no,0)						AS	report_no
		FROM #F4110
		LEFT OUTER JOIN #M0070_EMPLOYEE_CD ON(
			#F4110.company_cd	=	#M0070_EMPLOYEE_CD.company_cd	
		AND #F4110.fiscal_year	=	@P_fiscal_year					
		AND #F4110.employee_cd	=	#M0070_EMPLOYEE_CD.employee_cd	
		AND #F4110.report_kind	=	@w_report_kinds					
		)
		LEFT OUTER JOIN #M0070H ON (
			#M0070_EMPLOYEE_CD.company_cd	=	#M0070H.company_cd
		AND #M0070_EMPLOYEE_CD.employee_cd	=	#M0070H.employee_cd
		)
		LEFT OUTER JOIN M0071 ON (
			#M0070H.company_cd			= M0071.company_cd
		AND #M0070H.employee_cd			= M0071.employee_cd
		AND #M0070H.application_date	= M0071.application_date
		)
		LEFT JOIN M0070 AS approver_1 ON (
			#F4110.company_cd				=	approver_1.company_cd
		AND #F4110.approver_employee_cd_1	=	approver_1.employee_cd
		)
		LEFT JOIN M0070 AS approver_2 ON (
			#F4110.company_cd				=	approver_2.company_cd
		AND #F4110.approver_employee_cd_2	=	approver_2.employee_cd
		)
		LEFT JOIN M0070 AS approver_3 ON (
			#F4110.company_cd				=	approver_3.company_cd
		AND #F4110.approver_employee_cd_3	=	approver_3.employee_cd
		)
		LEFT JOIN M0070 AS approver_4 ON (
			#F4110.company_cd				=	approver_4.company_cd
		AND #F4110.approver_employee_cd_4	=	approver_4.employee_cd
		)
		LEFT OUTER JOIN M4610 ON (
			@P_company_cd					=	M4610.company_cd
		AND @w_report_kinds					=	M4610.report_kind
		AND @P_group_cd						=	M4610.group_cd
		AND M4610.del_datetime IS NULL
		)
		LEFT OUTER JOIN (
			SELECT 
				M4200.company_cd			AS	company_cd
			,	M4200.report_kind			AS	report_kind
			,	M4200.sheet_cd				AS	sheet_cd
			,	M4200.sheet_nm				AS	sheet_nm
			,	MAX(M4200.adaption_date)	AS	adaption_date
			FROM M4200
			WHERE 
				M4200.company_cd		=	@P_company_cd
			AND M4200.report_kind		=	@w_report_kinds
			AND M4200.adaption_date		<=	@w_deadline_date
			AND M4200.del_datetime IS NULL
			GROUP BY
				M4200.company_cd	
			,	M4200.report_kind	
			,	M4200.sheet_cd		
			,	M4200.sheet_nm		
		) AS M4200_MAX ON(
			@P_company_cd		=	M4200_MAX.company_cd
		AND @w_report_kinds		=	M4200_MAX.report_kind
		AND M4610.sheet_cd		=	M4200_MAX.sheet_cd
		)
		ORDER BY 
			CASE ISNUMERIC(#M0070_EMPLOYEE_CD.employee_cd) 
				WHEN 1 
				THEN CAST(#M0070_EMPLOYEE_CD.employee_cd AS BIGINT) 
				ELSE 999999999999999 
			END 
		,	#M0070_EMPLOYEE_CD.employee_cd
		offset (@w_page-1) * @w_page_size ROWS
		FETCH NEXT @w_page_size ROWS only
		--[1]
		SELECT	
			@w_totalRecord						AS totalRecord
		,	@w_pageMax							AS pageMax
		,	@w_page								AS page
		,	@w_page_size						AS pagesize
		,	((@w_page - 1) * @w_page_size + 1)	AS offset
		--[2]
		INSERT INTO #TABLE_SHEET
		SELECT 
			M4200.sheet_cd				AS	sheet_cd
		,	MAX(M4200.adaption_date)	AS	adaption_date
		FROM M4200
		WHERE
			M4200.company_cd	=	@P_company_cd
		AND M4200.report_kind	=	@w_report_kinds
		AND M4200.adaption_date	<=	@w_deadline_date
		AND M4200.del_datetime IS NULL
		GROUP BY
			M4200.sheet_cd
		-- INSERT FROM SCHEDULE (M4610) 
		INSERT INTO #TABLE_SHEET
		SELECT 
			M4610.sheet_cd
		,	M4200_MAX.adaption_date
		FROM M4610
		LEFT OUTER JOIN #TABLE_SHEET ON (
			M4610.sheet_cd	=	#TABLE_SHEET.sheet_cd
		)
		LEFT OUTER JOIN (
			SELECT 
				M4200.company_cd			AS	company_cd
			,	M4200.report_kind			AS	report_kind
			,	M4200.sheet_cd				AS	sheet_cd
			,	MAX(M4200.adaption_date)	AS	adaption_date
			FROM M4200
			WHERE
				M4200.company_cd	=	@P_company_cd
			AND M4200.report_kind	=	@w_report_kinds
			AND M4200.adaption_date	<=	@w_deadline_date
			AND M4200.del_datetime IS NULL
			GROUP BY
				M4200.company_cd		
			,	M4200.report_kind		
			,	M4200.sheet_cd			

		) AS M4200_MAX ON (
			M4610.company_cd	=	M4200_MAX.company_cd
		AND M4610.report_kind	=	M4200_MAX.report_kind
		AND	M4610.sheet_cd		=	M4200_MAX.sheet_cd
		)
		WHERE 
			M4610.company_cd	=	@P_company_cd
		AND M4610.report_kind	=	@w_report_kinds
		AND M4610.group_cd		=	@P_group_cd
		AND M4610.del_datetime IS NULL
		AND #TABLE_SHEET.sheet_cd IS NULL

		SELECT 
			M4200.sheet_cd
		,	M4200.sheet_nm
		,	M4200.adaption_date
		FROM #TABLE_SHEET
		LEFT OUTER JOIN M4200 ON (
			@P_company_cd				=	M4200.company_cd
		AND @w_report_kinds				=	M4200.report_kind
		AND #TABLE_SHEET.sheet_cd		=	M4200.sheet_cd
		AND #TABLE_SHEET.adaption_date	=	M4200.adaption_date
		AND M4200.del_datetime IS NULL
		)
		ORDER BY
			M4200.adaption_date DESC

		--[3]
		IF @w_report_kinds = 1
		SELECT
			M4100.annualreport_first_approval	AS first_col
		,	M4100.annualreport_second_approval	AS second_col
		,	M4100.annualreport_third_approval	AS third_col
		,	M4100.annualreport_fourth_approval	AS fourth_col
		FROM M4100 
		WHERE 
			M4100.company_cd = @P_company_cd
		AND M4100.annualreport_user_typ = 1
		---
		IF @w_report_kinds = 2
		SELECT
			M4100.semi_annualreport_first_approval	AS first_col
		,	M4100.semi_annualreport_second_approval	AS second_col
		,	M4100.semi_annualreport_third_approval	AS third_col
		,	M4100.semi_annualreport_fourth_approval	AS fourth_col
		FROM M4100 
		WHERE 
			M4100.company_cd = @P_company_cd
		AND M4100.semi_annualreport_user_typ = 1
		IF @w_report_kinds = 3
		SELECT
			M4100.quarterlyreport_first_approval	AS first_col
		,	M4100.quarterlyreport_second_approval	AS second_col
		,	M4100.quarterlyreport_third_approval	AS third_col
		,	M4100.quarterlyreport_fourth_approval	AS fourth_col
		FROM M4100 
		WHERE 
			M4100.company_cd = @P_company_cd
		AND M4100.quarterlyreport_user_typ = 1
		IF @w_report_kinds = 4
		SELECT
			M4100.monthlyreport_first_approval	AS first_col
		,	M4100.monthlyreport_second_approval	AS second_col
		,	M4100.monthlyreport_third_approval	AS third_col
		,	M4100.monthlyreport_fourth_approval	AS fourth_col
		FROM M4100 
		WHERE 
			M4100.company_cd = @P_company_cd
		AND M4100.monthlyreport_user_typ = 1
		--
		IF @w_report_kinds = 5
		SELECT
			M4100.weeklyreport_first_approval	AS first_col
		,	M4100.weeklyreport_second_approval	AS second_col
		,	M4100.weeklyreport_third_approval	AS third_col
		,	M4100.weeklyreport_fourth_approval	AS fourth_col
		FROM M4100 
		WHERE 
			M4100.company_cd = @P_company_cd
		AND M4100.weeklyreport_user_typ = 1
	END

GO
