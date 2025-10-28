DROP PROCEDURE [SPC_I2050_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_I2050_FND1 '{"fiscal_year":"2020","employee_nm":"","rater_employee_nm":"","employee_typ":"-1","evaluation_step":"-1","list_treatment_applications_no":[{"treatment_applications_no":"1"},{"treatment_applications_no":"2"},{"treatment_applications_no":"3"}],"list_organization_step1":[{"organization_cd_1":"","organization_cd_2":"","organization_cd_3":"","organization_cd_4":"","organization_cd_5":""},{"organization_cd_1":"","organization_cd_2":"","organization_cd_3":"","organization_cd_4":"","organization_cd_5":""}],"list_organization_step2":[{"organization_cd_1":"","organization_cd_2":"","organization_cd_3":"","organization_cd_4":"","organization_cd_5":""},{"organization_cd_1":"","organization_cd_2":"","organization_cd_3":"","organization_cd_4":"","organization_cd_5":""}],"list_organization_step3":[{"organization_cd_1":"","organization_cd_2":"","organization_cd_3":"","organization_cd_4":"","organization_cd_5":""},{"organization_cd_1":"","organization_cd_2":"","organization_cd_3":"","organization_cd_4":"","organization_cd_5":""}],"list_organization_step4":[],"list_organization_step5":[],"list_position_cd":[{"position_cd":""},{"position_cd":""},{"position_cd":""}],"list_grade":[{"grade":""},{"grade":""},{"grade":""}],"page_size":20,"page":1}','721','721','740';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	I2050_ステータス管理
--*  
--*  作成日/create date			:	2020/10/01						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2021/05/20
--*　更新者/updater				:	viettd
--*　更新内容/update content		:	when position is null then show with admin
--*   					
--*  更新日/update date			:	2021/06/03
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
--*   					
--*  更新日/update date			:	2022/03/31
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when admin is rater then show all employees who you evalutate
--* 
--*  更新日/update date			:	2022/04/19
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	is 20220418 search 評価ステップで
--* 
--*  更新日/update date			:	2022/08/16
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	upgrade 1.9
--*   					
--*  更新日/update date			:	2022/10/19
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	fix bug dont show employee by position
--* 
--****************************************************************************************
CREATE PROCEDURE [SPC_I2050_FND1]
	-- Add the parameters for the stored procedure here
	@P_json						nvarchar(max)		=	''	
,	@P_login_employee_cd		nvarchar(10)		=	''		-- login user
,	@P_cre_user					nvarchar(50)		=	''	
,	@P_company_cd				smallint			=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								datetime			=	SYSDATETIME()
	,	@totalRecord						bigint				=	0
	,	@pageMax							int					=	0	
	,	@page_size							int					=	50
	,	@page								int					=	0
	,	@year_month_day						date				=	NULL
	--
	,	@fiscal_year						int					=	0
	,	@employee_nm						nvarchar(101)		=	''
	,	@rater_employee_nm					nvarchar(101)		=	''
	,	@employee_typ						smallint			=	0
	,	@evaluation_step					smallint			=	0
	--

	,	@authority_typ						smallint			=	0
	,	@countAuthority						smallint			=	0
	,	@authority_cd						smallint			=	0
	,	@use_typ							smallint			=	0	
	,	@arrange_order						int					=	0
	,	@login_position_cd					int					=	0
	--
	,	@beginning_date						date				=	NULL
	,	@current_year						int					=	dbo.FNC_GET_YEAR(@P_company_cd,NULL)
	,	@choice_in_screen					tinyint				=	0
	--
	,	@chk								tinyint				=	0	-- add by viettd 2020/05/18
	,	@i									int					=	1
	,	@cnt								int					=	0
	,	@w_employee_cd						nvarchar(10)		=	''
	,	@w_sheet_cd							smallint			=	0
	--
	,	@sheet_cd_sql						NVARCHAR(MAX)		= ''
	,	@sql								NVARCHAR(MAX)		= ''
	,	@max_sheet_cd_num					INT					=	0
	,	@sheet_cd_i							INT					=	1
	-- add by viettd 2021/06/03
	,	@w_evaluation_organization_cnt		INT					=	0	-- 0.view all 1.only view organization choiced.
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	,	@w_language							INT					=	1
	--
	IF object_id('tempdb..#TABLE_ORGANIZATION', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_ORGANIZATION
    END
	--
	IF object_id('tempdb..#JSON_LIST_TREATMENT', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #JSON_LIST_TREATMENT
    END
	--
	IF object_id('tempdb..#LIST_POSITION', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #LIST_POSITION
    END
	--
	IF object_id('tempdb..#LIST_GRADE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #LIST_GRADE
    END
	--
	IF object_id('tempdb..#F0100', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F0100
    END
	--
	IF object_id('tempdb..#M0310', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0310
    END
	--
	IF object_id('tempdb..#F0032_TABLE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F0032_TABLE
    END
	--
	IF object_id('tempdb..#M0071_SHEET', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0071_SHEET
    END
	--
	IF object_id('tempdb..#EMPLOYEE_TOTAL', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #EMPLOYEE_TOTAL
    END
	--
	IF object_id('tempdb..#EMPLOYEE_PAGE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #EMPLOYEE_PAGE
    END
	--
	IF object_id('tempdb..#M0070H', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070H
    END
	--
	CREATE TABLE #TABLE_ORGANIZATION (
		organization_typ				tinyint
	,	organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)	
	,	choice_in_screen				tinyint		-- 1.choice in screen 0.get from master S0022
	)
	--
	CREATE TABLE #JSON_LIST_TREATMENT(
		id								int			identity(1,1)
	,	treatment_applications_no		smallint
	)
	--
	CREATE TABLE #LIST_POSITION(
		id								int			identity(1,1)
	,	position_cd						int
	,	mode							smallint	-- 0.choice in screen 1.get from master 
	)
	--
	CREATE TABLE #LIST_GRADE(
		id								int			identity(1,1)
	,	grade							smallint
	)
	--
	CREATE TABLE #F0100(
		id								int			identity(1,1)
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(101)
	,	sheet_cd						smallint
	,	sheet_nm						nvarchar(50)
	,	status_cd						smallint
	,	status_nm						nvarchar(50)
	,	sheet_kbn						tinyint			
	--
	,	belong_nm_1						nvarchar(50)
	,	belong_nm_2						nvarchar(50)
	,	belong_nm_3						nvarchar(50)
	,	belong_nm_4						nvarchar(50)
	,	belong_nm_5						nvarchar(50)
	,	job_nm							nvarchar(50)
	,	position_nm						nvarchar(50)
	,	employee_typ_nm					nvarchar(50)
	,	grade_nm						nvarchar(10)
	--
	,	number_order					int
	)
	--
	CREATE TABLE #M0310(
		id								int			identity(1,1)
	,	company_cd						smallint
	,	category						smallint
	,	status_cd						smallint
	,	status_nm						nvarchar(100)
	)
	--
	CREATE TABLE #F0032_TABLE(
		id								int			identity(1,1)
	,	company_cd						smallint
	,	fiscal_year						int
	,	treatment_applications_no		smallint
	,	group_cd						smallint
	,	employee_cd						nvarchar(10)
	,	detail_no						smallint
	,	sheet_cd						smallint
	--	
	,	belong_cd_1						nvarchar(50)
	,	belong_cd_2						nvarchar(50)
	,	belong_cd_3						nvarchar(50)
	,	belong_cd_4						nvarchar(50)
	,	belong_cd_5						nvarchar(50)
	,	job_cd							smallint
	,	position_cd						int
	,	employee_typ					smallint
	,	grade							smallint
	,	rater_step						smallint			-- add by viettd 2022/03/31
	--	add by viettd 2022/08/16
	,	sheet_belong_cd_1				nvarchar(20)
	,	sheet_belong_cd_2				nvarchar(20)
	,	sheet_belong_cd_3				nvarchar(20)
	,	sheet_belong_cd_4				nvarchar(20)
	,	sheet_belong_cd_5				nvarchar(20)
	,	sheet_job_cd					smallint
	,	sheet_position_cd				int
	,	sheet_employee_typ				smallint
	,	sheet_grade						smallint
	)
	--
	CREATE TABLE #EMPLOYEE_DATA(
		id								bigint			identity(1,1)
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	)
	--
	CREATE TABLE #EMPLOYEE_PAGE(
		id								bigint			identity(1,1)
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	)
	--
	CREATE TABLE #M0071_SHEET(
		company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	fiscal_year						int
	,	sheet_cd						smallint
	,	application_date				date
	,	employee_nm						nvarchar(101)
	,	employee_ab_nm					nvarchar(50)
	,	furigana						nvarchar(50)
	,	office_cd						smallint
	,	office_nm						nvarchar(50)
	,	belong_cd1						nvarchar(20)
	,	belong_cd2						nvarchar(20)
	,	belong_cd3						nvarchar(20)
	,	belong_cd4						nvarchar(20)
	,	belong_cd5						nvarchar(20)
	,	job_cd							smallint
	,	position_cd						int
	,	employee_typ					smallint
	,	grade							smallint
	,	belong_nm1						nvarchar(50)
	,	belong_nm2						nvarchar(50)
	,	belong_nm3						nvarchar(50)
	,	belong_nm4						nvarchar(50)
	,	belong_nm5						nvarchar(50)
	,	job_nm							nvarchar(50)
	,	position_nm						nvarchar(50)
	,	grade_nm						nvarchar(10)
	,	employee_typ_nm					nvarchar(50)
	)
	--
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
	--add vietdt 2022/04/19
	CREATE TABLE #F0100_W_M0200(
		company_cd						smallint
	,	fiscal_year						int
	,	employee_cd						nvarchar(10)
	,	sheet_cd						smallint
	)
	--end add vietdt 2022/04/19
	--
	SELECT 
		@authority_typ		=	ISNULL(S0010.authority_typ,0)
	,	@authority_cd		=	ISNULL(S0010.authority_cd,0)
	,	@login_position_cd	=	ISNULL(M0070.position_cd,0)
	,	@w_language			=	ISNULL(S0010.language,1)
	FROM S0010
	LEFT OUTER JOIN M0070 ON (
		S0010.company_cd		=	M0070.company_cd
	AND S0010.employee_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	WHERE 
		S0010.company_cd	= @P_company_cd 
	AND S0010.user_id		= @P_cre_user
	AND S0010.del_datetime IS NULL
	-- get @use_typ
	SELECT 
		@use_typ		=	ISNULL(S0020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
	FROM S0020
	WHERE
		S0020.company_cd		=	@P_company_cd
	AND S0020.authority_cd		=	@authority_cd
	AND S0020.del_datetime IS NULL
	-- get @arrange_order
	SELECT 
		@arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@login_position_cd
	AND M0040.del_datetime IS NULL
	--↓↓↓ add by viettd 2022/08/16
	IF @authority_typ = 6
	BEGIN
		SET @authority_typ = 2 -- 評価者
	END
	--↑↑↑ end add by viettd 2022/08/16
	-- COUNT ALL ORGANIZATIONS OF S0022 -- add by viettd 2021/06/03
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@authority_cd,1)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@authority_cd,1)
	--
	SET @fiscal_year		=	JSON_VALUE(@P_json,'$.fiscal_year')
	SET @employee_typ		=	JSON_VALUE(@P_json,'$.employee_typ')
	SET @employee_nm		=	JSON_VALUE(@P_json,'$.employee_nm')
	SET @rater_employee_nm	=	JSON_VALUE(@P_json,'$.rater_employee_nm')
	SET @evaluation_step	=	JSON_VALUE(@P_json,'$.evaluation_step')
	SET @page				=	JSON_VALUE(@P_json,'$.page')
	SET @page_size			=	JSON_VALUE(@P_json,'$.page_size')
	--
	INSERT INTO #JSON_LIST_TREATMENT
	SELECT json_table.treatment_applications_no FROM OPENJSON(@P_json,'$.list_treatment_applications_no') WITH(
		treatment_applications_no	smallint
	)AS json_table
	WHERE
		json_table.treatment_applications_no > 0
	--
	INSERT INTO #LIST_POSITION
	SELECT json_table.position_cd,0 FROM OPENJSON(@P_json,'$.list_position_cd') WITH(
		position_cd	int
	)AS json_table
	WHERE
		json_table.position_cd > 0
	--
	INSERT INTO #LIST_GRADE
	SELECT json_table.grade FROM OPENJSON(@P_json,'$.list_grade') WITH(
		grade	smallint
	)AS json_table
	WHERE
		json_table.grade > 0
	-- INSERT DATA INTO #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 @P_json,@P_cre_user,@P_company_cd
	--
	SELECT 
		@beginning_date = M9100.beginning_date 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	--
	IF @beginning_date IS NOT NULL
	BEGIN
		SET @year_month_day = CAST((CAST(@fiscal_year AS nvarchar(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		SET @year_month_day = DATEADD(DD,-1,DATEADD(YYYY,1,@year_month_day))
	END
	ELSE
	BEGIN 
		SET @year_month_day = CAST((CAST(@fiscal_year AS nvarchar(4)) + '/12/31') AS DATE)
	END
	--
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @year_month_day,'',@P_company_cd
	--
	INSERT INTO #M0071_SHEET
	EXEC [dbo].SPC_REFER_M0071_INQ1 @fiscal_year,'',0,@P_company_cd
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- GET #LIST_POSITION
	IF NOT EXISTS (SELECT 1 FROM #LIST_POSITION)
	BEGIN
		IF @use_typ = 1
		BEGIN
			INSERT INTO #LIST_POSITION
			SELECT 
				ISNULL(M0040.position_cd,0)				AS	position_cd
			,	1
			FROM M0040
			WHERE 
				M0040.company_cd		=	@P_company_cd
			AND M0040.arrange_order		>	@arrange_order		-- 1. 本人の役職より下位の社員のみ
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
	--
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--GET DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- INSERT INTO #M0310
	INSERT INTO #M0310
	SELECT 
		@P_company_cd
	,	M0310.category
	,	M0310.status_cd
	,	CASE 
			WHEN ISNULL(M0310.status_nm,'') <> ''
			THEN ISNULL(M0310.status_nm,'')
			ELSE ISNULL(IIF(@w_language = 2,L0040.status_nm_english,L0040.status_nm),'')
		END
	FROM M0310
	LEFT OUTER JOIN L0040 ON (
		M0310.company_cd					=	@P_company_cd
	AND M0310.category						=	L0040.category
	AND M0310.status_cd						=	L0040.status_cd
	AND L0040.del_datetime IS NULL
	)
	WHERE 
		M0310.company_cd		=	@P_company_cd
	AND M0310.status_use_typ	=	1
	AND M0310.del_datetime IS NULL
	-- add by viettd 2020/03/17
	IF NOT EXISTS (SELECT 1 FROM #M0310)
	BEGIN
		INSERT INTO #M0310
		SELECT 
			@P_company_cd
		,	L0040.category
		,	L0040.status_cd
		,	IIF(@w_language = 2,L0040.status_nm_english,L0040.status_nm)
		FROM L0040
	END
	-- end add by viettd 2020/03/17
	-----------------------------------------------------------------------------------
	-- when @authority_typ = 2 and part data
	-----------------------------------------------------------------------------------
	--↓↓↓ add by viettd 2019/05/28
	IF @authority_typ = 2 AND @fiscal_year < @current_year
	BEGIN
		-- INSERT INTO #F0032_TABLE
		INSERT INTO #F0032_TABLE
		SELECT 
			ISNULL(F0032.company_cd,0)					
		,	ISNULL(F0032.fiscal_year,0)						
		,	MAX(F0032.treatment_applications_no)
		,	MAX(F0032.group_cd)				
		,	ISNULL(F0032.employee_cd,'')	
		,	MAX(F0032.detail_no)
		,	ISNULL(F0032.sheet_cd,0)
		,	#M0070H.belong_cd_1
		,	#M0070H.belong_cd_2
		,	#M0070H.belong_cd_3
		,	#M0070H.belong_cd_4
		,	#M0070H.belong_cd_5
		,	#M0070H.job_cd			
		,	#M0070H.position_cd		
		,	#M0070H.employee_typ	
		,	#M0070H.grade	
		,	CASE 
				WHEN ISNULL(F0030.rater_employee_cd_4,'')	=	@P_login_employee_cd
				THEN 4
				WHEN ISNULL(F0030.rater_employee_cd_3,'')	=	@P_login_employee_cd
				THEN 3
				WHEN ISNULL(F0030.rater_employee_cd_2,'')	=	@P_login_employee_cd
				THEN 2
				WHEN ISNULL(F0030.rater_employee_cd_1,'')	=	@P_login_employee_cd
				THEN 1
				ELSE 0
			END						AS	rater_step
		,	#M0071_SHEET.belong_cd1
		,	#M0071_SHEET.belong_cd2
		,	#M0071_SHEET.belong_cd3
		,	#M0071_SHEET.belong_cd4
		,	#M0071_SHEET.belong_cd5
		,	#M0071_SHEET.job_cd			
		,	#M0071_SHEET.position_cd		
		,	#M0071_SHEET.employee_typ	
		,	#M0071_SHEET.grade	
		FROM F0032
		INNER JOIN #JSON_LIST_TREATMENT ON (
			F0032.company_cd					=	@P_company_cd
		AND F0032.treatment_applications_no		=	#JSON_LIST_TREATMENT.treatment_applications_no
		)
		LEFT OUTER JOIN F0011 ON (
			@P_company_cd									=	F0011.company_cd
		AND @fiscal_year									=	F0011.fiscal_year
		AND #JSON_LIST_TREATMENT.treatment_applications_no	=	F0011.treatment_applications_no
		)
		LEFT OUTER JOIN F0030 ON(
			F0032.company_cd				=	F0030.company_cd
		AND F0032.fiscal_year				=	F0030.fiscal_year
		AND F0032.treatment_applications_no	=	F0030.treatment_applications_no
		AND F0032.group_cd					=	F0030.group_cd
		AND F0032.employee_cd				=	F0030.employee_cd
		)
		LEFT OUTER JOIN #M0071_SHEET ON (
			F0032.company_cd				=	#M0071_SHEET.company_cd
		AND F0032.fiscal_year				=	#M0071_SHEET.fiscal_year
		AND F0032.employee_cd				=	#M0071_SHEET.employee_cd
		AND F0032.sheet_cd					=	#M0071_SHEET.sheet_cd
		)
		LEFT OUTER JOIN #M0070H ON (
			F0032.company_cd				=	#M0070H.company_cd
		AND F0032.employee_cd				=	#M0070H.employee_cd
		)
		WHERE 
			F0032.company_cd					=	@P_company_cd
		AND F0011.sheet_use_typ	= 1
		AND (
			@employee_typ = -1
		OR	@employee_typ <> -1 AND #M0071_SHEET.employee_typ = @employee_typ	-- 社員区分
		)
		AND (
				(ISNULL(F0030.rater_employee_cd_1,'')	=	@P_login_employee_cd)
			OR	(ISNULL(F0030.rater_employee_cd_2,'')	=	@P_login_employee_cd)
			OR	(ISNULL(F0030.rater_employee_cd_3,'')	=	@P_login_employee_cd)
			OR	(ISNULL(F0030.rater_employee_cd_4,'')	=	@P_login_employee_cd)
		)																	--	評価者
		AND #M0071_SHEET.employee_nm LIKE '%'+@employee_nm+'%'				--	彼評価者
		AND F0032.del_datetime IS NULL
		GROUP BY
			F0032.company_cd				
		,	F0032.fiscal_year				
		,	F0032.employee_cd
		,	F0032.sheet_cd	
		,	#M0070H.belong_cd_1
		,	#M0070H.belong_cd_2
		,	#M0070H.belong_cd_3
		,	#M0070H.belong_cd_4
		,	#M0070H.belong_cd_5
		,	#M0070H.job_cd			
		,	#M0070H.position_cd		
		,	#M0070H.employee_typ	
		,	#M0070H.grade	
		,	F0030.rater_employee_cd_1
		,	F0030.rater_employee_cd_2
		,	F0030.rater_employee_cd_3
		,	F0030.rater_employee_cd_4
		,	#M0071_SHEET.belong_cd1
		,	#M0071_SHEET.belong_cd2
		,	#M0071_SHEET.belong_cd3
		,	#M0071_SHEET.belong_cd4
		,	#M0071_SHEET.belong_cd5
		,	#M0071_SHEET.job_cd			
		,	#M0071_SHEET.position_cd		
		,	#M0071_SHEET.employee_typ	
		,	#M0071_SHEET.grade	
	END
	ELSE
	BEGIN
		-- INSERT INTO #F0032_TABLE
		INSERT INTO #F0032_TABLE
		SELECT 
			ISNULL(F0032.company_cd,0)					
		,	ISNULL(F0032.fiscal_year,0)					
		,	MAX(F0032.treatment_applications_no)	
		,	MAX(F0032.group_cd)
		,	ISNULL(F0032.employee_cd,'')
		,	MAX(F0032.detail_no)
		,	ISNULL(F0032.sheet_cd,0)
		,	#M0070H.belong_cd_1
		,	#M0070H.belong_cd_2
		,	#M0070H.belong_cd_3
		,	#M0070H.belong_cd_4
		,	#M0070H.belong_cd_5
		,	#M0070H.job_cd			
		,	#M0070H.position_cd		
		,	#M0070H.employee_typ	
		,	#M0070H.grade	
		,	CASE 
				WHEN ISNULL(F0030.rater_employee_cd_4,'')	=	@P_login_employee_cd
				THEN 4
				WHEN ISNULL(F0030.rater_employee_cd_3,'')	=	@P_login_employee_cd
				THEN 3
				WHEN ISNULL(F0030.rater_employee_cd_2,'')	=	@P_login_employee_cd
				THEN 2
				WHEN ISNULL(F0030.rater_employee_cd_1,'')	=	@P_login_employee_cd
				THEN 1
				ELSE 0
			END						AS	rater_step		
		,	#M0071_SHEET.belong_cd1
		,	#M0071_SHEET.belong_cd2
		,	#M0071_SHEET.belong_cd3
		,	#M0071_SHEET.belong_cd4
		,	#M0071_SHEET.belong_cd5
		,	#M0071_SHEET.job_cd			
		,	#M0071_SHEET.position_cd		
		,	#M0071_SHEET.employee_typ	
		,	#M0071_SHEET.grade
		FROM F0032
		INNER JOIN #JSON_LIST_TREATMENT ON (
			F0032.company_cd					=	@P_company_cd
		AND F0032.treatment_applications_no		=	#JSON_LIST_TREATMENT.treatment_applications_no
		)
		LEFT OUTER JOIN F0011 ON (
			@P_company_cd									=	F0011.company_cd
		AND @fiscal_year									=	F0011.fiscal_year
		AND #JSON_LIST_TREATMENT.treatment_applications_no	=	F0011.treatment_applications_no
		)
		LEFT OUTER JOIN F0030 ON(
			F0032.company_cd				=	F0030.company_cd
		AND F0032.fiscal_year				=	F0030.fiscal_year
		AND F0032.treatment_applications_no	=	F0030.treatment_applications_no
		AND F0032.group_cd					=	F0030.group_cd
		AND F0032.employee_cd				=	F0030.employee_cd
		)
		LEFT OUTER JOIN #M0070H ON (
			F0032.company_cd				=	#M0070H.company_cd
		AND F0032.employee_cd				=	#M0070H.employee_cd
		)
		LEFT OUTER JOIN #M0071_SHEET ON (
			F0032.company_cd				=	#M0071_SHEET.company_cd
		AND F0032.fiscal_year				=	#M0071_SHEET.fiscal_year
		AND F0032.employee_cd				=	#M0071_SHEET.employee_cd
		AND F0032.sheet_cd					=	#M0071_SHEET.sheet_cd
		)
		LEFT OUTER JOIN M0070 AS M0070H_1 ON (
			F0030.company_cd				=	M0070H_1.company_cd
		AND F0030.rater_employee_cd_1		=	M0070H_1.employee_cd
		)
		LEFT OUTER JOIN M0070 AS M0070H_2 ON (
			F0030.company_cd				=	M0070H_2.company_cd
		AND F0030.rater_employee_cd_2		=	M0070H_2.employee_cd
		)
		LEFT OUTER JOIN M0070 AS M0070H_3 ON (
			F0030.company_cd				=	M0070H_3.company_cd
		AND F0030.rater_employee_cd_3		=	M0070H_3.employee_cd
		)
		LEFT OUTER JOIN M0070 AS M0070H_4 ON (
			F0030.company_cd				=	M0070H_4.company_cd
		AND F0030.rater_employee_cd_4		=	M0070H_4.employee_cd
		)
		WHERE 
			F0032.company_cd			=	@P_company_cd
		AND F0032.fiscal_year			=	@fiscal_year						--	年度
		AND F0011.sheet_use_typ			=	1
		AND (
			@employee_typ = -1
		OR	@employee_typ <> -1 AND #M0071_SHEET.employee_typ = @employee_typ	-- 社員区分
		)
		AND (
			@rater_employee_nm	=	''
		OR	(
				@authority_typ >= 2
			AND (
						(M0070H_1.employee_nm LIKE '%'+@rater_employee_nm+'%')
					OR	(M0070H_2.employee_nm LIKE '%'+@rater_employee_nm+'%')
					OR	(M0070H_3.employee_nm LIKE '%'+@rater_employee_nm+'%')
					OR	(M0070H_4.employee_nm LIKE '%'+@rater_employee_nm+'%')
				)
			)
		)																		--	評価者
		AND #M0071_SHEET.employee_nm LIKE '%'+@employee_nm+'%'					--	彼評価者
		AND F0030.del_datetime IS NULL
		GROUP BY
			F0032.company_cd				
		,	F0032.fiscal_year				
		,	F0032.employee_cd		
		,	F0032.sheet_cd		
		,	#M0070H.belong_cd_1
		,	#M0070H.belong_cd_2
		,	#M0070H.belong_cd_3
		,	#M0070H.belong_cd_4
		,	#M0070H.belong_cd_5
		,	#M0070H.job_cd			
		,	#M0070H.position_cd		
		,	#M0070H.employee_typ	
		,	#M0070H.grade	
		,	F0030.rater_employee_cd_1
		,	F0030.rater_employee_cd_2
		,	F0030.rater_employee_cd_3
		,	F0030.rater_employee_cd_4
		,	#M0071_SHEET.belong_cd1
		,	#M0071_SHEET.belong_cd2
		,	#M0071_SHEET.belong_cd3
		,	#M0071_SHEET.belong_cd4
		,	#M0071_SHEET.belong_cd5
		,	#M0071_SHEET.job_cd			
		,	#M0071_SHEET.position_cd		
		,	#M0071_SHEET.employee_typ	
		,	#M0071_SHEET.grade
	END
	--■■■■■■■■■■■■■ FILTER DATA ■■■■■■■■■■■■■
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
	BEGIN
		SET @choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
		-- 1.choice in screen
		IF @choice_in_screen = 1
		BEGIN
			DELETE D FROM #F0032_TABLE AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.company_cd				=	@P_company_cd
			AND D.sheet_belong_cd_1			=	S.organization_cd_1
			AND D.sheet_belong_cd_2			=	S.organization_cd_2
			AND D.sheet_belong_cd_3			=	S.organization_cd_3
			AND D.sheet_belong_cd_4			=	S.organization_cd_4
			AND D.sheet_belong_cd_5			=	S.organization_cd_5
			)
			WHERE 
				D.company_cd IS NULL
			OR	S.organization_typ IS NULL
		END
		ELSE IF NOT (@authority_typ = 3 AND @w_evaluation_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)	-- edited by viettd 2021/06/03
		BEGIN
			DELETE D FROM #F0032_TABLE AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
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
			AND @authority_typ NOT IN (4,5) --4.会社管理者 5.総合管理者
			--AND D.rater_step NOT IN (1,2,3,4)	--一次評価者～四次評価者		 add by viettd 2022/03/31
		END
	END
	--↓↓↓ edited by viettd 2021/05/20
	-- FILTER 役職
	IF EXISTS (SELECT 1 FROM #LIST_POSITION)
	BEGIN
		-- choice in screen
		IF EXISTS (SELECT 1 FROM #LIST_POSITION WHERE mode = 0)
		BEGIN
			DELETE D FROM #F0032_TABLE AS D
			LEFT OUTER JOIN #LIST_POSITION AS S ON (
				D.company_cd			=	@P_company_cd
			AND D.sheet_position_cd		=	S.position_cd
			)
			WHERE
				S.position_cd IS NULL
		END
		ELSE -- not choice in screen
		BEGIN
			IF @authority_typ NOT IN (4,5)
			BEGIN
				DELETE D FROM #F0032_TABLE AS D
				LEFT OUTER JOIN #LIST_POSITION AS S ON (
					D.company_cd		=	@P_company_cd
				AND D.position_cd		=	S.position_cd
				)
				WHERE
					S.position_cd IS NULL
				-- add by viettd 2022/10/19
				AND (
					@use_typ = 1
				OR	@use_typ = 0 AND D.position_cd > 0
				)
				--AND D.rater_step NOT IN (1,2,3,4)	--一次評価者～四次評価者		 add by viettd 2022/03/31
			END
		END
	END
	--↑↑↑ end edited by viettd 2021/05/20
	-- FITER 等級
	IF EXISTS (SELECT 1 FROM #LIST_GRADE)
	BEGIN
		DELETE D FROM #F0032_TABLE AS D
		LEFT OUTER JOIN #LIST_GRADE AS S ON (
			D.company_cd		=	@P_company_cd
		AND D.sheet_grade		=	S.grade
		)
		WHERE
			S.grade IS NULL
	END
	-- FILTER 評価ステップ
	IF @evaluation_step > 0
	BEGIN
		IF @evaluation_step = 5 -- 最終評価
		BEGIN
			DELETE D FROM #F0032_TABLE AS D
			LEFT OUTER JOIN F0201 ON (
				D.company_cd					=	F0201.company_cd
			AND D.fiscal_year					=	F0201.fiscal_year
			AND D.employee_cd					=	F0201.employee_cd
			AND D.treatment_applications_no		=	F0201.treatment_applications_no
			AND F0201.del_datetime IS NULL
			)
			WHERE 
				F0201.company_cd IS NULL
		END
		ELSE
		BEGIN
			--add vietdt 2022/04/19
			INSERT INTO #F0100_W_M0200
			SELECT 
				F0100.company_cd
			,	F0100.fiscal_year
			,	F0100.employee_cd
			,	F0100.sheet_cd
			FROM F0100
			LEFT OUTER JOIN W_M0200 ON (
				F0100.company_cd				=	W_M0200.company_cd
			AND @fiscal_year					=	W_M0200.fiscal_year
			AND F0100.sheet_cd					=	W_M0200.sheet_cd
			)
			WHERE
			(
				--一次評価
				(@evaluation_step = 1 AND	W_M0200.sheet_kbn = 1 AND F0100.status_cd = 4)
			OR	(@evaluation_step = 1 AND	W_M0200.sheet_kbn = 2 AND F0100.status_cd = 2)
				--二次評価
			OR	(@evaluation_step = 2 AND	W_M0200.sheet_kbn = 1 AND F0100.status_cd = 5)
			OR	(@evaluation_step = 2 AND	W_M0200.sheet_kbn = 2 AND F0100.status_cd = 3)
				--三次評価
			OR	(@evaluation_step = 3 AND	W_M0200.sheet_kbn = 1 AND F0100.status_cd = 6)
			OR	(@evaluation_step = 3 AND	W_M0200.sheet_kbn = 2 AND F0100.status_cd = 4)
				--四次評価
			OR	(@evaluation_step = 4 AND	W_M0200.sheet_kbn = 1 AND F0100.status_cd = 7)
			OR	(@evaluation_step = 4 AND	W_M0200.sheet_kbn = 2 AND F0100.status_cd = 5)				
			)
			AND F0100.del_datetime IS NULL

			DELETE D FROM #F0032_TABLE AS D
			LEFT JOIN #F0100_W_M0200 ON (
				D.company_cd		=	#F0100_W_M0200.company_cd
			AND D.fiscal_year		=	#F0100_W_M0200.fiscal_year
			AND D.employee_cd		=	#F0100_W_M0200.employee_cd
			AND D.sheet_cd			=	#F0100_W_M0200.sheet_cd
			)
			WHERE
				#F0100_W_M0200.company_cd IS NULL
			--end add vietdt 2022/04/19
		END
	END
	--■■■■■■■■■■■■■ END FILTER DATA ■■■■■■■■■■■■■
	
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--PROCESS DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	INSERT INTO #EMPLOYEE_DATA
	SELECT 
		DISTINCT
		#F0032_TABLE.company_cd
	,	#F0032_TABLE.employee_cd
	FROM #F0032_TABLE
	--
	SET @totalRecord = (SELECT COUNT(1) FROM #EMPLOYEE_DATA)
	SET @pageMax = CEILING(CAST(@totalRecord AS FLOAT) / @page_size)
	IF @pageMax = 0
	BEGIN
		SET @pageMax = 1
	END
	IF @page > @pageMax
	BEGIN
		SET @page = @pageMax
	END
	--
	INSERT INTO #EMPLOYEE_PAGE
	SELECT 
		#EMPLOYEE_DATA.company_cd
	,	#EMPLOYEE_DATA.employee_cd
	FROM #EMPLOYEE_DATA
	ORDER BY 
		CASE ISNUMERIC(#EMPLOYEE_DATA.employee_cd) 
			WHEN 1 
			THEN CAST(#EMPLOYEE_DATA.employee_cd AS BIGINT) 
			ELSE 999999999999999 
		END 
	,	#EMPLOYEE_DATA.employee_cd
	offset (@page-1) * @page_size ROWS
	FETCH NEXT @page_size ROWS only
	-- GET DATA INTO #F0100
	INSERT INTO #F0100
	SELECT 
		#F0032_TABLE.company_cd						AS	company_cd
	,	#F0032_TABLE.employee_cd					AS	employee_cd
	,	ISNULL(#M0071_SHEET.employee_nm,'')			AS	employee_nm
	,	ISNULL(F0100.sheet_cd,0)					AS	sheet_cd
	,	ISNULL(W_M0200.sheet_nm,'')					AS	sheet_nm
	,	ISNULL(F0100.status_cd,0)					AS	status_cd
	,	CASE 
			WHEN M0310.status_nm IS NOT NULL
			THEN M0310.status_nm
			ELSE IIF(@w_language = 2,L0040.status_nm_english,L0040.status_nm)
		END											AS	status_nm
	,	ISNULL(W_M0200.sheet_kbn,0)					AS	sheet_kbn
	,	ISNULL(#M0071_SHEET.belong_nm1,'')			AS	belong_nm_1
	,	ISNULL(#M0071_SHEET.belong_nm2,'')			AS	belong_nm_2
	,	ISNULL(#M0071_SHEET.belong_nm3,'')			AS	belong_nm_3
	,	ISNULL(#M0071_SHEET.belong_nm4,'')			AS	belong_nm_4
	,	ISNULL(#M0071_SHEET.belong_nm5,'')			AS	belong_nm_5
	,	ISNULL(#M0071_SHEET.job_nm,'')				AS	job_nm
	,	ISNULL(#M0071_SHEET.position_nm,'')			AS	position_nm
	,	ISNULL(#M0071_SHEET.employee_typ_nm,'')		AS	employee_typ_nm
	,	ISNULL(#M0071_SHEET.grade_nm,'')			AS	grade_nm
	,	ROW_NUMBER() OVER (PARTITION BY #F0032_TABLE.company_cd,#F0032_TABLE.employee_cd ORDER BY #F0032_TABLE.employee_cd,F0100.sheet_cd)
													AS	number_order
	FROM #F0032_TABLE
	INNER JOIN #EMPLOYEE_PAGE ON (
		#F0032_TABLE.company_cd			=	#EMPLOYEE_PAGE.company_cd
	AND #F0032_TABLE.employee_cd		=	#EMPLOYEE_PAGE.employee_cd
	)
	INNER JOIN F0100 ON (
		#F0032_TABLE.company_cd			=	F0100.company_cd
	AND #F0032_TABLE.fiscal_year		=	F0100.fiscal_year
	AND #F0032_TABLE.employee_cd		=	F0100.employee_cd
	AND #F0032_TABLE.sheet_cd			=	F0100.sheet_cd
	AND F0100.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0200 ON (
		F0100.company_cd				=	W_M0200.company_cd
	AND @fiscal_year					=	W_M0200.fiscal_year
	AND F0100.sheet_cd					=	W_M0200.sheet_cd
	)
	LEFT OUTER JOIN #M0310 AS M0310 ON (
		F0100.company_cd				=	M0310.company_cd
	AND W_M0200.sheet_kbn				=	M0310.category
	AND F0100.status_cd					=	M0310.status_cd
	)
	LEFT OUTER JOIN L0040 ON (
		W_M0200.sheet_kbn				=	L0040.category
	AND F0100.status_cd					=	L0040.status_cd
	)
	LEFT OUTER JOIN #M0071_SHEET ON (
		#F0032_TABLE.company_cd			=	#M0071_SHEET.company_cd
	AND #F0032_TABLE.fiscal_year		=	#M0071_SHEET.fiscal_year
	AND #F0032_TABLE.employee_cd		=	#M0071_SHEET.employee_cd
	AND #F0032_TABLE.sheet_cd			=	#M0071_SHEET.sheet_cd
	)
	WHERE 
		F0100.company_cd		=	@P_company_cd
	AND F0100.fiscal_year		=	@fiscal_year
	AND F0100.del_datetime IS NULL
	-- GET @max_sheet_cd_num
	SELECT @max_sheet_cd_num = ISNULL(MAX(F0100_MAX.sheet_cd_num),0)
	FROM 
	(
		SELECT 
			company_cd
		,	employee_cd
		,	COUNT(#F0100.sheet_cd)		AS	sheet_cd_num
		FROM #F0100
		GROUP BY
			#F0100.company_cd
		,	#F0100.employee_cd
	) AS F0100_MAX
	--
	WHILE @sheet_cd_i <= @max_sheet_cd_num
	BEGIN
		IF @sheet_cd_i = @max_sheet_cd_num
		BEGIN
			SET @sheet_cd_sql = @sheet_cd_sql + '['+CAST(@sheet_cd_i AS nvarchar(10))+']'
		END
		ELSE
		BEGIN
			SET @sheet_cd_sql = @sheet_cd_sql + '['+CAST(@sheet_cd_i AS nvarchar(10))+'],'
		END
		--
		SET @sheet_cd_i = @sheet_cd_i + 1
	END
	--
	IF @sheet_cd_sql <> ''
	BEGIN
	SET @sql = '
	SELECT 
		company_cd			AS	company_cd		
	,	employee_cd			AS	employee_cd
	,	employee_nm			AS	employee_nm
	,	belong_nm_1			AS	belong_nm_1
	,	belong_nm_2			AS	belong_nm_2
	,	belong_nm_3			AS	belong_nm_3
	,	belong_nm_4			AS	belong_nm_4
	,	belong_nm_5			AS	belong_nm_5
	,	job_nm				AS	job_nm
	,	position_nm			AS	position_nm
	,	grade_nm			AS	grade_nm
	,	employee_typ_nm		AS  employee_typ_nm
	,	'+@sheet_cd_sql+'
	FROM 
	(
		SELECT 
			#F0100.company_cd				AS	company_cd
		,	#F0100.employee_cd				AS	employee_cd
		,	#F0100.employee_nm				AS	employee_nm
		,	#F0100.belong_nm_1				AS	belong_nm_1
		,	#F0100.belong_nm_2				AS	belong_nm_2
		,	#F0100.belong_nm_3				AS	belong_nm_3
		,	#F0100.belong_nm_4				AS	belong_nm_4
		,	#F0100.belong_nm_5				AS	belong_nm_5
		,	#F0100.job_nm					AS	job_nm
		,	#F0100.position_nm				AS	position_nm
		,	#F0100.grade_nm					AS	grade_nm
		,	#F0100.employee_typ_nm			AS	employee_typ_nm
		,	#F0100.number_order				AS	number_order
 		,	''{
			"sheet_cd":"''+CAST(#F0100.sheet_cd AS nvarchar(10))+''",
			"sheet_nm":"''+REPLACE(REPLACE(CAST(#F0100.sheet_nm AS nvarchar(50)), ''\\'', ''\\\\''), ''"'', ''\\\"'')+''",
			"sheet_kbn":"''+CAST(#F0100.sheet_kbn AS nvarchar(1))+''",
			"status_cd":"''+CAST(#F0100.status_cd AS nvarchar(10))+''",
			"status_nm":"''+REPLACE(REPLACE(CAST(#F0100.status_nm AS nvarchar(50)), ''\\'', ''\\\\''), ''"'', ''\\\"'')+''"
			}''								AS	sheet_info

		--,	CAST(#F0100.sheet_cd AS nvarchar(10)) + ''|''+
		--	CAST(#F0100.sheet_nm AS nvarchar(50)) + ''|''+
		--	CAST(#F0100.sheet_kbn AS nvarchar(1)) + ''|''+
		--	CAST(#F0100.status_cd AS nvarchar(10)) + ''|''+
		--	CAST(#F0100.status_nm AS nvarchar(50))
		--									AS		sheet_info
		FROM #F0100
	) AS P 
	Pivot(MAX(sheet_info) FOR number_order IN ('+@sheet_cd_sql+')) AS A
	ORDER BY 
		CASE ISNUMERIC(A.employee_cd) 
			WHEN 1 
			THEN CAST(A.employee_cd AS BIGINT) 
			ELSE 999999999999999 
		END 
	,	A.employee_cd
	'
	END
	ELSE
	BEGIN
		SELECT * 
		FROM #F0100
		ORDER BY 
			CASE ISNUMERIC(#F0100.employee_cd) 
			   WHEN 1 
			   THEN CAST(#F0100.employee_cd AS BIGINT) 
			   ELSE 999999999999999 
			END 
		,	#F0100.employee_cd
	END
	--[0]
	EXEC(@sql)


	--[1]
	SELECT	
		@totalRecord					AS	totalRecord
	,	@pageMax						AS	pageMax
	,	@page							AS	page
	,	@page_size						AS	pagesize
	,	((@page - 1) * @page_size + 1)	AS	offset
	--[2]
	SELECT @max_sheet_cd_num			AS	max_sheet_cd_num
	

	-- DROP TABLE
	DROP TABLE #EMPLOYEE_DATA
	DROP TABLE #EMPLOYEE_PAGE
	DROP TABLE #F0032_TABLE
	DROP TABLE #F0100
	DROP TABLE #JSON_LIST_TREATMENT
	DROP TABLE #LIST_GRADE
	DROP TABLE #LIST_POSITION
	DROP TABLE #M0071_SHEET
	DROP TABLE #M0310
	DROP TABLE #TABLE_ORGANIZATION
	DROP TABLE #F0100_W_M0200
	DROP TABLE #M0070H
END
GO