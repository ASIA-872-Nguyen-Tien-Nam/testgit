DROP PROCEDURE [SPC_Q2010_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_Q2010_FND1 '{"fiscal_year":"2018","evaluation_typ":"1","status_cd":"-1","category_typ":null,"sheet_cd":null,"employee_nm":"","employee_typ":"-1","position_cd":"-1","grade":"-1","list_treatment_applications_no":[{"treatment_applications_no":"16"},{"treatment_applications_no":"17"},{"treatment_applications_no":"18"}],"list_department_cd":[],"list_team_cd":[],"page_size":50,"page":1}','999';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	Q2010_評価シート一覧
--*  
--*  作成日/create date			:	2018/09/27						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2019/03/05
--*　更新者/updater				:	viettd
--*　更新内容/update content		:	filter evalutation when authority_typ = 2
--*   					
--*  更新日/update date			:	2019/03/18
--*　更新者/updater				:	longvv
--*　更新内容/update content		:	社員権限を修正。
--*   					
--*  更新日/update date			:	2019/05/28
--*　更新者/updater				:	viettd
--*　更新内容/update content		:	update ver 1.5
--*   					 
--*  更新日/update date			:	2019/12/12
--*　更新者/updater				:	viettd
--*　更新内容/update content		:	update ver 1.6
--*   					
--*	更新日/update date			:  	2020/03/06				
--*	更新者/updater				:　	viettd 　								     	 
--*	更新内容/update content		:	change table F0032
--*   					
--*	更新日/update date			:  	2020/03/17				
--*	更新者/updater				:　 viettd 　								     	 
--*	更新内容/update content		:	when not exists M0310 then L0040
--*   					
--*	更新日/update date			:  	2020/04/10				
--*	更新者/updater				:　 viettd 　								     	 
--*	更新内容/update content		:	comment code
--*   					
--*	更新日/update date			:  	2020/04/15				
--*	更新者/updater				:　 viettd 　								     	 
--*	更新内容/update content		:	確定した評価を見る。
--*   					
--*	更新日/update date			:  	2020/04/16				
--*	更新者/updater				:　 viettd 　								     	 
--*	更新内容/update content		:	view all when authority = 4.会社管理者
--*   					
--*	更新日/update date			:  	2020/04/24				
--*	更新者/updater				:　 viettd 　								     	 
--*	更新内容/update content		:	view year when export CSV
--*   					
--*  更新日/update date			:	2020/04/27
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	fix error when 評価者 = 管理者
--*   					
--*  更新日/update date			:	2020/05/12
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	view all evalutation when status =  10：一次ＦＢ済。本人ＦＢ待ち。 or ８：一次ＦＢ済。本人ＦＢ待ち。
--*   					
--*  更新日/update date			:	2020/05/15
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	評価段階で閲覧不可・可能などを修正する為。
--*   					
--*  更新日/update date			:	2020/05/18
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	CHECK PERMISSION OF ROUTER EVALUTATION
--*   					
--*  更新日/update date			:	2020/10/09
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgradate ver 1.7 & 1on1
--*   					
--*  更新日/update date			:	2021/05/20
--*　更新者/updater				:　	viettd
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
--*  更新日/update date			:	2022/08/16
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	upgrade 1.9
--*   					
--*  更新日/update date			:	2022/10/19
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	fix bug dont show employee by position
--*   					
--*  更新日/update date			:	2022/10/24
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	In part , login user not view completed sheet when login user is not rater of sheet
--*   					
--*  更新日/update date			:	2023/06/02
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	fix bug rater is not view part data
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_Q2010_FND1]
	-- Add the parameters for the stored procedure here
	@P_language					nvarchar(10)		=	'jp'		
,	@P_json						nvarchar(max)		=	''	
,	@P_login_employee_cd		nvarchar(10)		=	''		
,	@P_cre_user					nvarchar(50)		=	''	
,	@P_company_cd				smallint			=	0
,	@P_mode						tinyint				=	0		-- 0.search 1. print
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
	,	@evaluation_typ						int					=	0
	,	@status_cd							smallint			=	0
	,	@category_typ						smallint			=	0
	,	@sheet_cd							smallint			=	0
	,	@employee_cd						nvarchar(10)		=	''
	,	@employee_typ						smallint			=	0
	,	@position_cd						int			=	0
	,	@grade								smallint			=	0
	,	@authority_typ						smallint			=	0
	,	@authority_cd						smallint			=	0
	,	@use_typ							smallint			=	0	
	,	@arrange_order						int					=	0
	,	@login_position_cd					int			=	0
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
	-- add by viettd 2021/06/03
	,	@w_evaluation_organization_cnt		INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	--
	IF object_id('tempdb..#TABLE_ORGANIZATION', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_ORGANIZATION
    END
	--
	IF object_id('tempdb..#TABLE_M0022', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_M0022
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
	IF object_id('tempdb..#M0071_SHEET', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0071_SHEET
    END
	--
	IF object_id('tempdb..#M0070H', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070H
    END
	--
	IF object_id('tempdb..#TABLE_LOGIN_CURRENT_RATER', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_LOGIN_CURRENT_RATER
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
	CREATE TABLE #TABLE_M0022(
		id								int			identity(1,1)
	,	organization_typ				tinyint
	,	use_typ							smallint	
	,	organization_group_nm			nvarchar(50)
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
	,	mode							smallint	-- 0.choice in screen 1. get from master
	)
	--
	CREATE TABLE #F0100(
		id								int			identity(1,1)
	,	employee_cd						nvarchar(10)
	,	sheet_cd						smallint
	,	status_cd						smallint
	,	login_evaluation_step			smallint
	--	add by viettd 2020/05/15
	,	sheet_kbn						tinyint			
	,	point_sum_status0				tinyint			-- 自己評価		 0.NOT VIEW 1.VIEW
	,	point_sum_status1				tinyint			-- 一次評価		 0.NOT VIEW 1.VIEW
	,	point_sum_status2				tinyint			-- 二次評価		 0.NOT VIEW 1.VIEW
	,	point_sum_status3				tinyint			-- 三次評価		 0.NOT VIEW 1.VIEW
	,	point_sum_status4				tinyint			-- 四次評価		 0.NOT VIEW 1.VIEW
	--
	,	rater_employee_cd_1				nvarchar(10)	-- add by viettd 2022/10/24
	,	rater_employee_cd_2				nvarchar(10)	-- add by viettd 2022/10/24
	,	rater_employee_cd_3				nvarchar(10)	-- add by viettd 2022/10/24
	,	rater_employee_cd_4				nvarchar(10)	-- add by viettd 2022/10/24
	,	current_year_is_rater			tinyint			-- add by viettd 2022/10/24	-- 0. current year is not rater | 1. is rater
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
	,	employee_cd						nvarchar(10)
	,	treatment_applications_no		smallint
	,	group_cd						smallint		-- add by viettd 2020/03/06
	,	sheet_cd						smallint
	--	
	,	belong_cd_1						nvarchar(20)
	,	belong_cd_2						nvarchar(20)
	,	belong_cd_3						nvarchar(20)
	,	belong_cd_4						nvarchar(20)
	,	belong_cd_5						nvarchar(20)
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
	CREATE TABLE #EMPLOYEE_ROUTE(
		id								int			identity(1,1)
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
	,	grade_nm						nvarchar(50)
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
	--
	CREATE TABLE #TABLE_LOGIN_CURRENT_RATER(
		id								INT			IDENTITY(1,1)
	,	fiscal_year						INT
	,	employee_cd						NVARCHAR(10)
	)
	--
	SELECT 
		@authority_typ		=	ISNULL(S0010.authority_typ,0)
	,	@authority_cd		=	ISNULL(S0010.authority_cd,0)
	,	@login_position_cd	=	ISNULL(M0070.position_cd,0)
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
	--↓↓↓ add by viettd 2022/08/16
	IF @authority_typ = 6
	BEGIN
		SET @authority_typ = 2 -- 評価者
	END
	--↑↑↑ end add by viettd 2022/08/16
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
	-- COUNT ALL ORGANIZATIONS OF S0022 -- add by viettd 2021/06/03
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@authority_cd,1)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@authority_cd,1)
	--
	SET @fiscal_year		=	JSON_VALUE(@P_json,'$.fiscal_year')
	SET @evaluation_typ		=	JSON_VALUE(@P_json,'$.evaluation_typ')
	SET @status_cd			=	JSON_VALUE(@P_json,'$.status_cd')
	SET @category_typ		=	JSON_VALUE(@P_json,'$.category_typ')
	SET @sheet_cd			=	JSON_VALUE(@P_json,'$.sheet_cd')
	SET @employee_cd		=	JSON_VALUE(@P_json,'$.employee_cd')
	SET @employee_typ		=	JSON_VALUE(@P_json,'$.employee_typ')
	SET @position_cd		=	JSON_VALUE(@P_json,'$.position_cd')
	SET @grade				=	JSON_VALUE(@P_json,'$.grade')
	SET @page				=	JSON_VALUE(@P_json,'$.page')
	SET @page_size			=	JSON_VALUE(@P_json,'$.page_size')
	--
	INSERT INTO #JSON_LIST_TREATMENT
	SELECT json_table.treatment_applications_no FROM OPENJSON(@P_json,'$.list_treatment_applications_no') WITH(
		treatment_applications_no	smallint
	)AS json_table
	WHERE
		json_table.treatment_applications_no > 0
	-- INSERT DATA INTO #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 @P_json,@P_cre_user,@P_company_cd
	--
	IF @position_cd > 0
	BEGIN
		INSERT INTO #LIST_POSITION
		SELECT @position_cd,0
	END
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
	--
	INSERT INTO #TABLE_M0022 VALUES(1,0,'')
	INSERT INTO #TABLE_M0022 VALUES(2,0,'')
	INSERT INTO #TABLE_M0022 VALUES(3,0,'')
	INSERT INTO #TABLE_M0022 VALUES(4,0,'')
	INSERT INTO #TABLE_M0022 VALUES(5,0,'')
	--
	UPDATE #TABLE_M0022 SET 
		use_typ					=	ISNULL(M0022.use_typ,0)
	,	organization_group_nm	=	ISNULL(M0022.organization_group_nm,'')
	FROM #TABLE_M0022
	INNER JOIN M0022 ON (
		@P_company_cd					=	M0022.company_cd
	AND #TABLE_M0022.organization_typ	=	M0022.organization_typ
	)
	WHERE
		M0022.company_cd		=	@P_company_cd
	AND M0022.del_datetime IS NULL
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- GET #LIST_POSITION
	IF NOT EXISTS (SELECT 1 FROM #LIST_POSITION)
	BEGIN
		-- 本人の役職より下位の社員のみ
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
			ELSE ISNULL(IIF(@P_language = 'en',L0040.status_nm_english,L0040.status_nm),'')
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
		,	IIF(@P_language = 'en',L0040.status_nm_english,L0040.status_nm)
		FROM L0040
	END
	-- end add by viettd 2020/03/17
	-- INSERT INTO #F0032_TABLE
	INSERT INTO #F0032_TABLE
	SELECT 
		ISNULL(F0032.company_cd,0)					
	,	ISNULL(F0032.fiscal_year,0)					
	,	ISNULL(F0032.employee_cd,'')					
	,	ISNULL(F0032.treatment_applications_no,0)	
	,	MAX(F0032.group_cd)
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
	LEFT OUTER JOIN W_M0200 M0200 ON (
		F0032.company_cd			=	M0200.company_cd
	AND @fiscal_year				=	M0200.fiscal_year
	AND F0032.sheet_cd				=	M0200.sheet_cd
	)
	LEFT OUTER JOIN F0030 ON(
		F0032.company_cd					=	F0030.company_cd
	AND F0032.fiscal_year					=	F0030.fiscal_year
	AND F0032.treatment_applications_no		=	F0030.treatment_applications_no
	AND F0032.group_cd						=	F0030.group_cd
	AND F0032.employee_cd					=	F0030.employee_cd
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
	WHERE 
		F0032.company_cd			=	@P_company_cd
	AND F0032.fiscal_year			=	@fiscal_year					--	年度
	AND M0200.sheet_kbn				=	@evaluation_typ					--	評価種類
	AND (
			@category_typ = -1
		OR	@category_typ <> -1 AND M0200.category	=	@category_typ
	)																	-- カテゴリ
	AND (
			@sheet_cd = -1
		OR	@sheet_cd <> -1 AND M0200.sheet_cd	=	@sheet_cd
	)																	-- 評価シート
	AND (
		@employee_typ = -1
	OR	@employee_typ <> -1 AND #M0071_SHEET.employee_typ = @employee_typ	-- 社員区分
	)
	AND (
		@grade = -1
	OR	@grade <> -1 AND #M0071_SHEET.grade = @grade						-- 等級
	)
	AND F0032.del_datetime IS NULL
	GROUP BY
		F0032.company_cd				
	,	F0032.fiscal_year					
	,	F0032.employee_cd					
	,	F0032.treatment_applications_no
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
			AND @authority_typ NOT IN(2,4,5)		--2.評価者 4.会社管理者 5.総合管理者 edited by viettd 2023/06/02
			--AND D.rater_step NOT IN (1,2,3,4)	--一次評価者～四次評価者		 add by viettd 2022/03/31
		END
	END
	--↓↓↓ edited by viettd 2021/05/20
	-- FILTER 役職
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
		IF @authority_typ NOT IN (2,4,5)	-- edited by viettd 2023/06/02
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
	--↑↑↑ end edited by viettd 2021/05/20
	--■■■■■■■■■■■■■ END FILTER DATA ■■■■■■■■■■■■■
	-- INSERT INTO #F0100
	INSERT INTO #F0100
	SELECT 
		ISNULL(F0100.employee_cd,'')				AS	employee_cd
	,	ISNULL(F0100.sheet_cd,0)					AS	sheet_cd
	,	ISNULL(F0100.status_cd,0)					AS	status_cd
	,	[dbo].FNC_GET_STEP_EVALUATION
		(
			'Q2010'
		,	M0200.sheet_kbn
		,	F0100.status_cd
		,	F0100.employee_cd
		,	@P_login_employee_cd
		,	@authority_typ
		,	F0100.rater_employee_cd_1
		,	F0100.rater_employee_cd_2
		,	F0100.rater_employee_cd_3
		,	F0100.rater_employee_cd_4
		) AS login_evaluation_step
	,	ISNULL(M0200.sheet_kbn,0)	AS	sheet_kbn
	,	0	--	point_sum_status0	
	,	0	--	point_sum_status1	
	,	0	--	point_sum_status2	
	,	0	--	point_sum_status3	
	,	0	--	point_sum_status4
	,	F0100.rater_employee_cd_1	-- add by viettd 2022/10/24
	,	F0100.rater_employee_cd_2	-- add by viettd 2022/10/24
	,	F0100.rater_employee_cd_3	-- add by viettd 2022/10/24
	,	F0100.rater_employee_cd_4	-- add by viettd 2022/10/24
	,	CASE 
			WHEN F0030_CURRENT_YEAR.employee_cd IS NOT NULL
			THEN 1
			ELSE 0
		END							-- add by viettd 2022/10/24
	FROM F0100
	LEFT OUTER JOIN W_M0200 AS M0200 ON(
		F0100.company_cd			=	M0200.company_cd
	AND F0100.fiscal_year			=	M0200.fiscal_year
	AND F0100.sheet_cd				=	M0200.sheet_cd
	)
	LEFT OUTER JOIN (
		SELECT 
			F0030.company_cd		AS	company_cd
		,	F0030.employee_cd		AS	employee_cd
		FROM F0030
		WHERE 
			F0030.company_cd		=	@P_company_cd
		AND F0030.fiscal_year		=	@current_year
		AND (
			F0030.rater_employee_cd_1	=	@employee_cd
		OR	F0030.rater_employee_cd_2	=	@employee_cd
		OR	F0030.rater_employee_cd_3	=	@employee_cd
		OR	F0030.rater_employee_cd_4	=	@employee_cd
		)
		AND F0030.del_datetime IS NULL
		GROUP BY
			F0030.company_cd
		,	F0030.employee_cd
	) AS F0030_CURRENT_YEAR ON (
		F0100.company_cd		=	F0030_CURRENT_YEAR.company_cd
	AND F0100.employee_cd		=	F0030_CURRENT_YEAR.employee_cd
	)
	WHERE
		F0100.company_cd			=	@P_company_cd
	AND F0100.fiscal_year			=	@fiscal_year
	AND M0200.sheet_kbn				=	@evaluation_typ
	AND (
		@status_cd	=	-1
	OR	(@status_cd >= 0 AND F0100.status_cd = @status_cd)
	)
	AND F0100.del_datetime IS NULL
	--↓↓↓ add by viettd 2020/05/18
	IF @P_mode = 1			-- 1. print
	BEGIN
		SET @cnt = (SELECT COUNT(id) FROM #F0100)
		WHILE @i <= @cnt
		BEGIN
			SELECT 
				@w_employee_cd	=	ISNULL(#F0100.employee_cd,'')
			,	@w_sheet_cd		=	ISNULL(#F0100.sheet_cd,0)
			FROM #F0100
			WHERE #F0100.id = @i
			--
			EXEC [dbo].SPC_PERMISSION_CHK1 @fiscal_year,@w_employee_cd,@w_sheet_cd,@P_cre_user,@P_company_cd,1,@chk OUT
			-- 0.参照不可　1.参照可能	2.更新可能
			IF @chk IN (0)
			BEGIN
				DELETE D FROM #F0100 AS D WHERE D.id = @i
			END
			-- LOOP @i
			SET @i = @i + 1
		END
	END
	--↑↑↑ end add by viettd 2020/05/18
	--↓↓↓ add by viettd 2022/10/19
	DELETE D FROM #F0100 AS D
	LEFT OUTER JOIN #F0032_TABLE AS S ON (
		@P_company_cd		=	S.company_cd
	AND @fiscal_year		=	S.fiscal_year
	AND D.employee_cd		=	S.employee_cd
	AND D.sheet_cd			=	S.sheet_cd
	)
	WHERE
		S.employee_cd IS NULL
	--  WHEN CURRENT YEAR AND FUTURE YEAR
	IF @fiscal_year >= @current_year
	BEGIN
		IF @employee_cd <> ''
		BEGIN
			DELETE D FROM #F0100 AS D
			WHERE 
				D.current_year_is_rater = 0
			AND	D.rater_employee_cd_1 <> @employee_cd
			AND D.rater_employee_cd_2 <> @employee_cd
			AND D.rater_employee_cd_3 <> @employee_cd
			AND D.rater_employee_cd_4 <> @employee_cd
		END
	END
	-- WHEN PART YEAR
	IF @fiscal_year < @current_year
	BEGIN
		-- WHEN AUTHORITY_TYP = 2,6
		IF @authority_typ IN (2,6)
		BEGIN
			-- REMOVE EMPLOYEE WHEN LOGIN USER IS NOT RATER OF CURRENT YEAR AND NOT RATER OF PART YEAR
			DELETE D FROM #F0100 AS D
			WHERE 
				D.current_year_is_rater = 0
			AND D.rater_employee_cd_1 <> @employee_cd
			AND D.rater_employee_cd_2 <> @employee_cd
			AND D.rater_employee_cd_3 <> @employee_cd
			AND D.rater_employee_cd_4 <> @employee_cd
			-- REMOVE EMPLOYEE WHEN LOGIN USER IS NOT RATER OF CURRENT YEAR AND SHEET DONE (LOGIN IS RATER OF PART YEAR)
			DELETE D FROM #F0100 AS D
			WHERE 
				D.current_year_is_rater = 0
			AND (
				D.rater_employee_cd_1 = @employee_cd
			OR	D.rater_employee_cd_2 = @employee_cd
			OR	D.rater_employee_cd_3 = @employee_cd
			OR	D.rater_employee_cd_4 = @employee_cd
			)
			AND (
				(D.sheet_kbn = 1 AND D.status_cd = 12)
			OR	(D.sheet_kbn = 2 AND D.status_cd = 10)
			)
		END
		-- WHEN AUTHORITY TYP = 3,4,5
		ELSE
		BEGIN
			IF @employee_cd <> ''
			BEGIN
				DELETE D FROM #F0100 AS D
				WHERE 
					D.rater_employee_cd_1 <> @employee_cd
				AND D.rater_employee_cd_2 <> @employee_cd
				AND D.rater_employee_cd_3 <> @employee_cd
				AND D.rater_employee_cd_4 <> @employee_cd
			END
		END
	END
	--↑↑↑ end add by viettd 2022/10/19
	--
	SET @totalRecord = (SELECT COUNT(1) FROM #F0100)
	SET @pageMax = CEILING(CAST(@totalRecord AS FLOAT) / @page_size)
	IF @pageMax = 0
	BEGIN
		SET @pageMax = 1
	END
	IF @page > @pageMax
	BEGIN
		SET @page = @pageMax
	END
	--↓↓↓ add by viettd 2020/05/151
	-- 1. 目標評価
	UPDATE #F0100 SET 
		point_sum_status0	=	CASE 
									-- ３：目標承認済。自己評価中。
									WHEN #F0100.status_cd = 3 AND #F0100.login_evaluation_step IN (0,5)
									THEN 1
									-- ４：自己評価済。一次評価中。
									WHEN #F0100.status_cd = 4 AND #F0100.login_evaluation_step IN (0,1,5)
									THEN 1
									-- ５：一次評価済。二次評価中。
									WHEN #F0100.status_cd = 5 AND #F0100.login_evaluation_step IN (0,1,2,5)
									THEN 1
									-- ６：二次評価済。三次評価中。
									WHEN #F0100.status_cd = 6 AND #F0100.login_evaluation_step IN (0,1,2,3,5)
									THEN 1
									-- ７：三次評価済。四次評価中。
									WHEN #F0100.status_cd IN(7,8,9,10,11,12) AND #F0100.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	,	point_sum_status1	=	CASE 
									-- ４：自己評価済。一次評価中。
									WHEN #F0100.status_cd = 4 AND #F0100.login_evaluation_step IN (1,5)
									THEN 1
									-- ５：一次評価済。二次評価中。
									WHEN #F0100.status_cd = 5 AND #F0100.login_evaluation_step IN (1,2,5)
									THEN 1
									-- ６：二次評価済。三次評価中。
									WHEN #F0100.status_cd = 6 AND #F0100.login_evaluation_step IN (1,2,3,5)
									THEN 1
									-- ７：三次評価済。四次評価中。
									WHEN #F0100.status_cd IN(7,8,9,10) AND #F0100.login_evaluation_step IN (1,2,3,4,5)
									THEN 1
									WHEN #F0100.status_cd IN(11,12) AND  #F0100.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	,	point_sum_status2	=	CASE 
									-- ５：一次評価済。二次評価中。
									WHEN #F0100.status_cd = 5 AND #F0100.login_evaluation_step IN (2,5)
									THEN 1
									-- ６：二次評価済。三次評価中。
									WHEN #F0100.status_cd = 6 AND #F0100.login_evaluation_step IN (2,3,5)
									THEN 1
									-- ７：三次評価済。四次評価中。
									WHEN #F0100.status_cd IN(7,8,9) AND #F0100.login_evaluation_step IN (2,3,4,5)
									THEN 1
									WHEN #F0100.status_cd = 10 AND #F0100.login_evaluation_step IN (1,2,3,4,5)
									THEN 1
									WHEN #F0100.status_cd IN(11,12) AND  #F0100.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	,	point_sum_status3	=	CASE 
									-- ６：二次評価済。三次評価中。
									WHEN #F0100.status_cd = 6 AND #F0100.login_evaluation_step IN (3,5)
									THEN 1
									-- ７：三次評価済。四次評価中。
									WHEN #F0100.status_cd IN(7,8,9) AND #F0100.login_evaluation_step IN (3,4,5)
									THEN 1
									WHEN #F0100.status_cd = 10 AND #F0100.login_evaluation_step IN (1,2,3,4,5)
									THEN 1
									WHEN #F0100.status_cd IN(11,12) AND  #F0100.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	,	point_sum_status4	=	CASE 
									-- ７：三次評価済。四次評価中。
									WHEN #F0100.status_cd IN(7,8,9) AND #F0100.login_evaluation_step IN (4,5)
									THEN 1
									WHEN #F0100.status_cd = 10 AND #F0100.login_evaluation_step IN (1,2,3,4,5)
									THEN 1
									WHEN #F0100.status_cd IN(11,12) AND  #F0100.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	FROM #F0100 
	WHERE 
		#F0100.sheet_kbn = 1
	-- 2. 定性評価
	UPDATE #F0100 SET 
		point_sum_status0	=	CASE
									-- １：期首面談済。自己評価中。
									WHEN #F0100.status_cd = 1 AND #F0100.login_evaluation_step IN (0,5)
									THEN 1
									-- ２：自己評価済。一次評価中。
									WHEN #F0100.status_cd = 2 AND #F0100.login_evaluation_step IN (0,1,5)
									THEN 1
									-- ３：一次評価済。二次評価中。
									WHEN #F0100.status_cd = 3 AND #F0100.login_evaluation_step IN (0,1,2,5)
									THEN 1
									-- ４：二次評価済。三次評価中。
									WHEN #F0100.status_cd = 4 AND #F0100.login_evaluation_step IN (0,1,2,3,5)
									THEN 1
									-- ５：三次評価済。四次評価中。
									WHEN #F0100.status_cd IN(5,6,7,8,9,10) AND #F0100.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	,	point_sum_status1	=	CASE
									-- ２：自己評価済。一次評価中。
									WHEN #F0100.status_cd = 2 AND #F0100.login_evaluation_step IN (1,5)
									THEN 1
									-- ３：一次評価済。二次評価中。
									WHEN #F0100.status_cd = 3 AND #F0100.login_evaluation_step IN (1,2,5)
									THEN 1
									-- ４：二次評価済。三次評価中。
									WHEN #F0100.status_cd = 4 AND #F0100.login_evaluation_step IN (1,2,3,5)
									THEN 1
									-- ５：三次評価済。四次評価中。
									WHEN #F0100.status_cd IN(5,6,7,8) AND #F0100.login_evaluation_step IN (1,2,3,4,5)
									THEN 1
									--
									WHEN #F0100.status_cd IN(9,10) AND #F0100.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	,	point_sum_status2	=	CASE
									-- ３：一次評価済。二次評価中。
									WHEN #F0100.status_cd = 3 AND #F0100.login_evaluation_step IN (2,5)
									THEN 1
									-- ４：二次評価済。三次評価中。
									WHEN #F0100.status_cd = 4 AND #F0100.login_evaluation_step IN (2,3,5)
									THEN 1
									-- ５：三次評価済。四次評価中。
									WHEN #F0100.status_cd IN(5,6,7) AND #F0100.login_evaluation_step IN (2,3,4,5)
									THEN 1
									-- ８：一次ＦＢ済。本人ＦＢ待ち。
									WHEN #F0100.status_cd = 8 AND #F0100.login_evaluation_step IN (1,2,3,4,5)
									THEN 1
									--
									WHEN #F0100.status_cd IN(9,10) AND #F0100.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	,	point_sum_status3	=	CASE
									-- ４：二次評価済。三次評価中。
									WHEN #F0100.status_cd = 4 AND #F0100.login_evaluation_step IN (3,5)
									THEN 1
									-- ５：三次評価済。四次評価中。
									WHEN #F0100.status_cd IN(5,6,7) AND #F0100.login_evaluation_step IN (3,4,5)
									THEN 1
									-- ８：一次ＦＢ済。本人ＦＢ待ち。
									WHEN #F0100.status_cd = 8 AND #F0100.login_evaluation_step IN (1,2,3,4,5)
									THEN 1
									--
									WHEN #F0100.status_cd IN(9,10) AND #F0100.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	,	point_sum_status4	=	CASE
									-- ５：三次評価済。四次評価中。
									WHEN #F0100.status_cd IN(5,6,7) AND #F0100.login_evaluation_step IN (4,5)
									THEN 1
									-- ８：一次ＦＢ済。本人ＦＢ待ち。
									WHEN #F0100.status_cd = 8 AND #F0100.login_evaluation_step IN (1,2,3,4,5)
									THEN 1
									--
									WHEN #F0100.status_cd IN(9,10) AND #F0100.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END									
	FROM #F0100
	WHERE 
		#F0100.sheet_kbn = 2
	--↑↑↑ add by viettd 2020/05/15
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF @P_mode = 1			-- 1. print
	BEGIN
		--[0]
		SELECT
			ROW_NUMBER() OVER(ORDER BY #F0100.id ASC)	AS	id
		,	CAST(@fiscal_year AS nvarchar(4)) + IIF(@P_language = 'en','','年度') 	AS	fiscal_year_nm		-- edited by viettd 2020/04/24
		,	@fiscal_year								AS	fiscal_year			-- edited by viettd 2020/04/24
		,	ISNULL(#F0100.employee_cd,'')				AS	employee_cd
		,	ISNULL(#M0071_SHEET.employee_nm,'')			AS	employee_nm
		,	ISNULL(#M0071_SHEET.employee_typ_nm,'')		AS	employee_typ_nm
		,	ISNULL(#M0071_SHEET.belong_nm1,'')			AS	belong_nm_1
		,	ISNULL(#M0071_SHEET.belong_nm2,'')			AS	belong_nm_2
		,	ISNULL(#M0071_SHEET.belong_nm3,'')			AS	belong_nm_3
		,	ISNULL(#M0071_SHEET.belong_nm4,'')			AS	belong_nm_4
		,	ISNULL(#M0071_SHEET.belong_nm5,'')			AS	belong_nm_5
		,	ISNULL(#M0071_SHEET.job_nm,'')				AS	job_nm
		,	ISNULL(#M0071_SHEET.position_nm,'')			AS	position_nm
		,	ISNULL(#M0071_SHEET.grade_nm,'')			AS	grade_nm
		,	ISNULL(#F0100.sheet_cd,0)					AS	sheet_cd
		,	ISNULL(#F0100.status_cd,0)					AS	status_cd
		,	CASE 
				WHEN ISNULL(W_M0200.sheet_kbn,0)	=	1
				THEN IIF(@P_language = 'en','Objective Management Sheet','目標管理シート')
				WHEN ISNULL(W_M0200.sheet_kbn,0)	=	2
				THEN IIF(@P_language = 'en','Qualitative Evaluation Sheet','定性評価シート')
			ELSE ''
			END											AS	sheet_kbn_nm
		,	ISNULL(W_M0200.sheet_kbn,0)					AS	sheet_kbn
		,	ISNULL(W_M0200.sheet_nm,'')					AS	sheet_nm
		,	ISNULL(M0310.status_nm,'')					AS	status_nm
		-- edited by viettd 2020/05/15
		,	CASE 
				WHEN #F0100.point_sum_status0 = 1
				THEN  FORMAT(ISNULL(F0120_0.point_sum,0),'#0.##')
				ELSE ''
			END											AS	point_sum_0
		,	CASE 
				WHEN #F0100.point_sum_status1 = 1
				THEN  FORMAT(ISNULL(F0120_1.point_sum,0),'#0.##')
				ELSE ''
			END											AS	point_sum_1
		,	CASE 
				WHEN #F0100.point_sum_status2 = 1
				THEN  FORMAT(ISNULL(F0120_2.point_sum,0),'#0.##')
				ELSE ''
			END											AS	point_sum_2
		,	CASE 
				WHEN #F0100.point_sum_status3 = 1
				THEN  FORMAT(ISNULL(F0120_3.point_sum,0),'#0.##')
				ELSE ''
			END											AS	point_sum_3
		,	CASE 
				WHEN #F0100.point_sum_status4 = 1
				THEN  FORMAT(ISNULL(F0120_4.point_sum,0),'#0.##')
				ELSE ''
			END											AS	point_sum_4
		--
		,	@P_cre_user									AS	cre_user
		,	FORMAT (@w_time, 'yyyy/MM/dd HH:mm')		AS	cre_time
		,	@P_language									AS	language	--add vietdt 2022/08/22
		FROM #F0100
		INNER JOIN #M0071_SHEET ON (
			@P_company_cd				=	#M0071_SHEET.company_cd
		AND @fiscal_year				=	#M0071_SHEET.fiscal_year
		AND #F0100.employee_cd			=	#M0071_SHEET.employee_cd
		AND #F0100.sheet_cd				=	#M0071_SHEET.sheet_cd
		)
		LEFT OUTER JOIN W_M0200 ON (
			@P_company_cd				=	W_M0200.company_cd
		AND @fiscal_year				=	W_M0200.fiscal_year
		AND #F0100.sheet_cd				=	W_M0200.sheet_cd
		)
		LEFT OUTER JOIN #M0310 AS M0310 ON (
			@P_company_cd				=	M0310.company_cd
		AND W_M0200.sheet_kbn			=	M0310.category
		AND #F0100.status_cd			=	M0310.status_cd
		)
		LEFT OUTER JOIN F0120 AS F0120_0 ON (
			@P_company_cd				=	F0120_0.company_cd
		AND @fiscal_year				=	F0120_0.fiscal_year
		AND #F0100.employee_cd			=	F0120_0.employee_cd
		AND #F0100.sheet_cd				=	F0120_0.sheet_cd
		AND 0							=	F0120_0.evaluation_step
		AND F0120_0.del_datetime IS NULL
		AND F0120_0.submit_datetime IS NOT NULL -- ADD BY VIETTD 2020/04/15
		)
		LEFT OUTER JOIN F0120 AS F0120_1 ON (
			@P_company_cd				=	F0120_1.company_cd
		AND @fiscal_year				=	F0120_1.fiscal_year
		AND #F0100.employee_cd			=	F0120_1.employee_cd
		AND #F0100.sheet_cd				=	F0120_1.sheet_cd
		AND 1							=	F0120_1.evaluation_step
		AND F0120_1.del_datetime IS NULL
		AND F0120_1.submit_datetime IS NOT NULL -- ADD BY VIETTD 2020/04/15
		)
		LEFT OUTER JOIN F0120 AS F0120_2 ON (
			@P_company_cd				=	F0120_2.company_cd
		AND @fiscal_year				=	F0120_2.fiscal_year
		AND #F0100.employee_cd			=	F0120_2.employee_cd
		AND #F0100.sheet_cd				=	F0120_2.sheet_cd
		AND 2							=	F0120_2.evaluation_step
		AND F0120_2.del_datetime IS NULL
		AND F0120_2.submit_datetime IS NOT NULL -- ADD BY VIETTD 2020/04/15
		)
		LEFT OUTER JOIN F0120 AS F0120_3 ON (
			@P_company_cd				=	F0120_3.company_cd
		AND @fiscal_year				=	F0120_3.fiscal_year
		AND #F0100.employee_cd			=	F0120_3.employee_cd
		AND #F0100.sheet_cd				=	F0120_3.sheet_cd
		AND 3							=	F0120_3.evaluation_step
		AND F0120_3.del_datetime IS NULL
		AND F0120_3.submit_datetime IS NOT NULL -- ADD BY VIETTD 2020/04/15
		)
		LEFT OUTER JOIN F0120 AS F0120_4 ON (
			@P_company_cd				=	F0120_4.company_cd
		AND @fiscal_year				=	F0120_4.fiscal_year
		AND #F0100.employee_cd			=	F0120_4.employee_cd
		AND #F0100.sheet_cd				=	F0120_4.sheet_cd
		AND 4							=	F0120_4.evaluation_step
		AND F0120_4.del_datetime IS NULL
		AND F0120_4.submit_datetime IS NOT NULL -- ADD BY VIETTD 2020/04/15
		)
		ORDER BY 
			--RIGHT('0000000000'+ #F0100.employee_cd,10)
			CASE ISNUMERIC(#F0100.employee_cd) 
			   WHEN 1 
			   THEN CAST(#F0100.employee_cd AS BIGINT) 
			   ELSE 999999999999999 
			END 
		,	#F0100.employee_cd
	END
	ELSE
	BEGIN
		--[0]	-- 0.search 
		SELECT
			ROW_NUMBER() OVER(ORDER BY #F0100.id ASC)	AS	id
		,	@fiscal_year								AS	fiscal_year
		,	ISNULL(#F0100.employee_cd,'')				AS	employee_cd
		,	CASE ISNUMERIC(#F0100.employee_cd) 
				WHEN 1 
				THEN 'A'+ISNULL(#F0100.employee_cd,'')	
				ELSE 'B'+ISNULL(#F0100.employee_cd,'')	
			END											AS	employee_cd_orderby
		,	ISNULL(#M0071_SHEET.employee_nm,'')				AS	employee_nm
		,	ISNULL(#M0071_SHEET.furigana,'')					AS	furigana
		,	ISNULL(#M0071_SHEET.employee_typ_nm,'')			AS	employee_typ_nm
		,	ISNULL(#M0071_SHEET.employee_typ,0)				AS	employee_typ
		,	ISNULL(#M0071_SHEET.belong_cd1,'')				AS	belong_cd_1
		,	ISNULL(#M0071_SHEET.belong_cd2,'')				AS	belong_cd_2
		,	ISNULL(#M0071_SHEET.belong_cd3,'')				AS	belong_cd_3
		,	ISNULL(#M0071_SHEET.belong_cd4,'')				AS	belong_cd_4
		,	ISNULL(#M0071_SHEET.belong_cd5,'')				AS	belong_cd_5
		,	ISNULL(#M0071_SHEET.belong_nm1,'')				AS	belong_nm_1
		,	ISNULL(#M0071_SHEET.belong_nm2,'')				AS	belong_nm_2
		,	ISNULL(#M0071_SHEET.belong_nm3,'')				AS	belong_nm_3
		,	ISNULL(#M0071_SHEET.belong_nm4,'')				AS	belong_nm_4
		,	ISNULL(#M0071_SHEET.belong_nm5,'')				AS	belong_nm_5
		,	ISNULL(#M0071_SHEET.job_nm,'')					AS	job_nm
		,	ISNULL(#M0071_SHEET.job_cd,0)					AS	job_cd
		,	ISNULL(#M0071_SHEET.position_nm,'')				AS	position_nm
		,	ISNULL(#M0071_SHEET.position_cd,0)				AS	position_cd
		,	ISNULL(#M0071_SHEET.grade_nm,'')				AS	grade_nm
		,	ISNULL(#M0071_SHEET.grade,0)					AS	grade
		--
		,	ISNULL(#F0100.sheet_cd,0)						AS	sheet_cd
		,	ISNULL(#F0100.status_cd,0)						AS	status_cd
		,	CASE 
				WHEN ISNULL(W_M0200.sheet_kbn,0)	=	1
				THEN IIF(@P_language = 'en','Objective Management Sheet','目標管理シート')		
				WHEN ISNULL(W_M0200.sheet_kbn,0)	=	2
				THEN IIF(@P_language = 'en','Qualitative Evaluation Sheet','定性評価シート')
			ELSE ''
			END												AS	sheet_kbn_nm
		,	ISNULL(W_M0200.sheet_kbn,0)						AS	sheet_kbn
		,	ISNULL(W_M0200.sheet_nm,'')						AS	sheet_nm
		,	ISNULL(M0310.status_nm,'')						AS	status_nm
		--	edited by viettd 2020/05/15
		,	CASE 
				WHEN #F0100.point_sum_status0 = 1
				THEN  FORMAT(ISNULL(F0120_0.point_sum,0),'#0.##')
				ELSE ''
			END												AS	point_sum_0
		,	CASE 
				WHEN #F0100.point_sum_status1 = 1
				THEN  FORMAT(ISNULL(F0120_1.point_sum,0),'#0.##')
				ELSE ''
			END												AS	point_sum_1
		,	CASE 
				WHEN #F0100.point_sum_status2 = 1
				THEN  FORMAT(ISNULL(F0120_2.point_sum,0),'#0.##')
				ELSE ''
			END												AS	point_sum_2
		,	CASE 
				WHEN #F0100.point_sum_status3 = 1
				THEN  FORMAT(ISNULL(F0120_3.point_sum,0),'#0.##')
				ELSE ''
			END												AS	point_sum_3
		,	CASE 
				WHEN #F0100.point_sum_status4 = 1
				THEN  FORMAT(ISNULL(F0120_4.point_sum,0),'#0.##')
				ELSE ''
			END												AS	point_sum_4
		--
		,	RIGHT('00'+CAST(ISNULL(#F0100.status_cd,0) AS NVARCHAR(2)),2)
																		AS	status_cd_order_by
		,	RIGHT('00000000'+CAST(CAST(ISNULL(F0120_0.point_sum,0)*100 AS BIGINT) AS NVARCHAR(8)),8)
																		AS	point_sum_0_order_by
		,	RIGHT('00000000'+CAST(CAST(ISNULL(F0120_1.point_sum,0)*100 AS BIGINT) AS NVARCHAR(8)),8)
																		AS	point_sum_1_order_by
		,	RIGHT('00000000'+CAST(CAST(ISNULL(F0120_2.point_sum,0)*100 AS BIGINT) AS NVARCHAR(8)),8)
																		AS	point_sum_2_order_by
		,	RIGHT('00000000'+CAST(CAST(ISNULL(F0120_3.point_sum,0)*100 AS BIGINT) AS NVARCHAR(8)),8)
																		AS	point_sum_3_order_by
		,	RIGHT('00000000'+CAST(CAST(ISNULL(F0120_4.point_sum,0)*100 AS BIGINT) AS NVARCHAR(8)),8)
																		AS	point_sum_4_order_by
		FROM #F0100
		INNER JOIN #M0071_SHEET ON (
			@P_company_cd				=	#M0071_SHEET.company_cd
		AND @fiscal_year				=	#M0071_SHEET.fiscal_year
		AND #F0100.employee_cd			=	#M0071_SHEET.employee_cd
		AND #F0100.sheet_cd				=	#M0071_SHEET.sheet_cd
		)
		LEFT OUTER JOIN W_M0200 ON (
			@P_company_cd				=	W_M0200.company_cd
		AND @fiscal_year				=	W_M0200.fiscal_year
		AND #F0100.sheet_cd				=	W_M0200.sheet_cd
		)
		LEFT OUTER JOIN #M0310 AS M0310 ON (
			@P_company_cd				=	M0310.company_cd
		AND W_M0200.sheet_kbn				=	M0310.category
		AND #F0100.status_cd			=	M0310.status_cd
		)
		LEFT OUTER JOIN F0120 AS F0120_0 ON (
			@P_company_cd				=	F0120_0.company_cd
		AND @fiscal_year				=	F0120_0.fiscal_year
		AND #F0100.employee_cd			=	F0120_0.employee_cd
		AND #F0100.sheet_cd				=	F0120_0.sheet_cd
		AND 0							=	F0120_0.evaluation_step
		AND F0120_0.del_datetime IS NULL
		AND F0120_0.submit_datetime IS NOT NULL -- ADD BY VIETTD 2020/04/15
		)
		LEFT OUTER JOIN F0120 AS F0120_1 ON (
			@P_company_cd				=	F0120_1.company_cd
		AND @fiscal_year				=	F0120_1.fiscal_year
		AND #F0100.employee_cd			=	F0120_1.employee_cd
		AND #F0100.sheet_cd				=	F0120_1.sheet_cd
		AND 1							=	F0120_1.evaluation_step
		AND F0120_1.del_datetime IS NULL
		AND F0120_1.submit_datetime IS NOT NULL -- ADD BY VIETTD 2020/04/15
		)
		LEFT OUTER JOIN F0120 AS F0120_2 ON (
			@P_company_cd				=	F0120_2.company_cd
		AND @fiscal_year				=	F0120_2.fiscal_year
		AND #F0100.employee_cd			=	F0120_2.employee_cd
		AND #F0100.sheet_cd				=	F0120_2.sheet_cd
		AND 2							=	F0120_2.evaluation_step
		AND F0120_2.del_datetime IS NULL
		AND F0120_2.submit_datetime IS NOT NULL -- ADD BY VIETTD 2020/04/15
		)
		LEFT OUTER JOIN F0120 AS F0120_3 ON (
			@P_company_cd				=	F0120_3.company_cd
		AND @fiscal_year				=	F0120_3.fiscal_year
		AND #F0100.employee_cd			=	F0120_3.employee_cd
		AND #F0100.sheet_cd				=	F0120_3.sheet_cd
		AND 3							=	F0120_3.evaluation_step
		AND F0120_3.del_datetime IS NULL
		AND F0120_3.submit_datetime IS NOT NULL -- ADD BY VIETTD 2020/04/15
		)
		LEFT OUTER JOIN F0120 AS F0120_4 ON (
			@P_company_cd				=	F0120_4.company_cd
		AND @fiscal_year				=	F0120_4.fiscal_year
		AND #F0100.employee_cd			=	F0120_4.employee_cd
		AND #F0100.sheet_cd				=	F0120_4.sheet_cd
		AND 4							=	F0120_4.evaluation_step
		AND F0120_4.del_datetime IS NULL
		AND F0120_4.submit_datetime IS NOT NULL -- ADD BY VIETTD 2020/04/15
		)
		ORDER BY 
			CASE ISNUMERIC(#F0100.employee_cd) 
			   WHEN 1 
			   THEN CAST(#F0100.employee_cd AS BIGINT) 
			   ELSE 999999999999999 
			END 
		,	#F0100.employee_cd
		offset (@page-1) * @page_size ROWS
		FETCH NEXT @page_size ROWS only
	END
	--[1]
	SELECT	
		@totalRecord					AS totalRecord
	,	@pageMax						AS pageMax
	,	@page							AS page
	,	@page_size						AS pagesize
	,	((@page - 1) * @page_size + 1)	AS offset
	--[2] get router
	SELECT 
		@evaluation_typ									AS	sheet_khn
	,	ISNULL(M0100.target_self_assessment_typ,0)		AS	target_self_assessment_typ
	,	ISNULL(M0100.target_evaluation_typ_1,0)			AS	target_evaluation_typ_1
	,	ISNULL(M0100.target_evaluation_typ_2,0)			AS	target_evaluation_typ_2
	,	ISNULL(M0100.target_evaluation_typ_3,0)			AS	target_evaluation_typ_3
	,	ISNULL(M0100.target_evaluation_typ_4,0)			AS	target_evaluation_typ_4
	,	ISNULL(M0100.evaluation_self_assessment_typ,0)	AS	evaluation_self_assessment_typ
	,	ISNULL(M0100.evaluation_typ_1,0)				AS	evaluation_typ_1
	,	ISNULL(M0100.evaluation_typ_2,0)				AS	evaluation_typ_2
	,	ISNULL(M0100.evaluation_typ_3,0)				AS	evaluation_typ_3
	,	ISNULL(M0100.evaluation_typ_4,0)				AS	evaluation_typ_4
	FROM M0100
	WHERE
		M0100.company_cd		=	@P_company_cd
	AND M0100.del_datetime IS NULL
	--[3]
	SELECT 
		ISNULL(M0022.organization_typ,0)				AS	organization_typ
	,	ISNULL(M0022.organization_group_nm,'')			AS	organization_group_nm
	,	ISNULL(M0022.use_typ,0)							AS	use_typ
	FROM #TABLE_M0022 AS M0022
	ORDER BY
		M0022.organization_typ
END
GO