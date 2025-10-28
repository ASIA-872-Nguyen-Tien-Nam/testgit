IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_MQ2000_FND1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_MQ2000_FND1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*  
--*  作成日/create date			:	2020/11/30						
--*　作成者/creater				:	NGHIANM								
--*   					
--*  更新日/update date			:	2021/04/07	
--*　更新者/updater				:	ANS-ASIA vietdt
--*　更新内容/update content		:	add permission and search data by fiscal_year
--*   					
--*  更新日/update date			:	2021/04/26	
--*　更新者/updater				:	viettd
--*　更新内容/update content		:	when admin then can edited eval
--*   					
--*  更新日/update date			:	2021/06/03
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
--*   					
--*  更新日/update date			:	2021/06/16
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when rater_1 then can view & edited employees
--*
--*  更新日/update date			:	2022/08/19
--*　更新者/updater				:	namnt　
--*　更新内容/update content		:	change number digit
--*EXEC SPC_MQ2000_FND1 '{"fiscal_year":"2022","review_date_from":null,"review_date_to":null,"project_title":"","list_position_cd":[],"list_grade":[],"list_job_cd":[],"list_employee_typ":[],"list_organization_step1":[],"list_organization_step2":[],"list_organization_step3":[],"list_organization_step4":[],"list_organization_step5":[],"list_employee_cd":[],"list_supporter_cd":[],"list_rater_employee_cd":[],"page_size":20,"page":1}','721','721','740','0';
--****************************************************************************************
CREATE PROCEDURE [SPC_MQ2000_FND1]
	-- Add the parameters for the stored procedure here
	@P_language					nvarchar(10)		=	'jp'		
,	@P_json						nvarchar(max)		=	''	
,	@P_login_employee_cd		nvarchar(10)		=	''		-- login user
,	@P_cre_user					nvarchar(50)		=	''	
,	@P_company_cd				smallint			=	0
,	@P_mode						smallint			=	0		--0: search , 1:excel
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
	,	@review_date_from					date				=	NULL	
	,	@review_date_to						date				=	NULL
	,	@project_title						nvarchar(50)		=	''
	,	@rater_employee_nm					nvarchar(20)		=	''
	,	@employee_typ						smallint			=	0
	,	@employee_role						smallint			=	0
	,	@group_cd							smallint			=	0
	,	@position_cd						smallint			=	0
	,	@grade								smallint			=	0
	,	@job_cd								smallint			=	0
	,	@coach_cd							nvarchar(10)		=	''
	,	@multireview_authority_typ			smallint			=	0
	,	@multireview_authority_cd			smallint			=	0
	,	@date_from							date				=	NULL
	,	@date_to							date				=	NULL
	--
	,	@authority_typ						smallint			=	0
	,	@authority_cd						smallint			=	0
	,	@use_typ							smallint			=	0	
	,	@arrange_order						int					=	0
	,	@login_position_cd					int					=	0
	--
	,	@beginning_date						date				=	NULL
	,	@choice_in_screen					tinyint				=	0
	,	@count								money				=	0
	,	@check								int					=	YEAR(GETDATE())-3
	,	@w_avg_point						money				=	0
	,	@w_authority_mQ2000					SMALLINT			=	0	--add by vietdt 2021/04/07
	-- add by viettd 2021/06/03
	,	@w_mulitireview_organization_cnt	INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	--
	IF object_id('tempdb..#TABLE_ORGANIZATION', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_ORGANIZATION
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
	IF object_id('tempdb..#LIST_JOB', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #LIST_JOB
    END
	--
	IF object_id('tempdb..#LIST_EMPLOYEE_TYP', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #LIST_EMPLOYEE_TYP
    END
	--
	IF object_id('tempdb..#LIST_EMPLOYEE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #LIST_EMPLOYEE
    END
	--
	IF object_id('tempdb..#LIST_SUPPORTER', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #LIST_SUPPORTER
    END
	--
	IF object_id('tempdb..#LIST_RATER_EMPLOYEE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #LIST_RATER_EMPLOYEE
    END
	--
	IF object_id('tempdb..#M0070H', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070H
    END
	--
	IF object_id('tempdb..#TABLE_EMPLOYEE_SUPPORTED_DB', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_EMPLOYEE_SUPPORTED_DB
    END
	--
	IF object_id('tempdb..#TABLE_F3000', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_F3000
    END
	--
	IF object_id('tempdb..#TABLE_RESULT', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_RESULT
    END
	--
	IF object_id('tempdb..#TABLE_F3001', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_F3001
    END
	-- GET ALL EMPLOYEE OF RATER_1 
	IF object_id('tempdb..#TABLE_F0030', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_F0030
    END
	-- add by viettd 2021/06/16
	CREATE TABLE #TABLE_F0030 (
		company_cd					smallint
	,	fiscal_year					int
	,	employee_cd					nvarchar(10)
	,	rater_employee_cd_1			nvarchar(50)
	)
	--
	CREATE TABLE #TABLE_F3001 (
		employee_cd					nvarchar(10)
	,	employee_nm					nvarchar(200)
	,	evaluation_point			money				-- AVG point
	,	times_of_evaluation			int
	)
	--
	CREATE TABLE #TABLE_EMPLOYEE_SUPPORTED_DB (
		company_cd					smallint
	,	fiscal_year					smallint
	,	employee_cd					nvarchar(10)
	,	employee_nm					nvarchar(200)

	)
	--
	CREATE TABLE #TABLE_ORGANIZATION (
		organization_typ				tinyint
	,	organization_cd_1				nvarchar(50)
	,	organization_cd_2				nvarchar(50)
	,	organization_cd_3				nvarchar(50)
	,	organization_cd_4				nvarchar(50)
	,	organization_cd_5				nvarchar(50)	
	,	choice_in_screen				tinyint		-- 1.choice in screen 0.get from master S0022
	)
	--
	CREATE TABLE #LIST_POSITION(
		id								int			identity(1,1)
	,	position_cd						int
	,	choice_in_screen				tinyint		-- 1.choice in screen 0.get from master M0040
	)
	--
	CREATE TABLE #LIST_GRADE(
		id								int			identity(1,1)
	,	grade							smallint
	)
	--
	CREATE TABLE #LIST_JOB(
		id								int			identity(1,1)
	,	job_cd							smallint
	)
	--
	CREATE TABLE #LIST_EMPLOYEE_TYP(
		id								int			identity(1,1)
	,	employee_typ					smallint
	)
	--
	CREATE TABLE #LIST_EMPLOYEE(
		id								int			identity(1,1)
	,	employee_cd						nvarchar(10)
	)
	--
	CREATE TABLE #LIST_SUPPORTER(
		id								int			identity(1,1)
	,	employee_cd						nvarchar(10)
	)
	--
	CREATE TABLE #LIST_RATER_EMPLOYEE(
		id								int			identity(1,1)
	,	employee_cd						nvarchar(10)
	)
	--
	CREATE TABLE #M0070H(
		application_date				date
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(101)
	,	employee_ab_nm					nvarchar(50)
	,	furigana						nvarchar(50)
	,	office_cd						smallint
	,	office_nm						nvarchar(50)
	,	belong_cd_1						nvarchar(50)
	,	belong_cd_2						nvarchar(50)
	,	belong_cd_3						nvarchar(50)
	,	belong_cd_4						nvarchar(50)
	,	belong_cd_5						nvarchar(50)
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
	CREATE TABLE #TABLE_F3000 (
		company_cd							SMALLINT
	,	employee_cd							NVARCHAR(10)
	,	detail_no							SMALLINT
	,	supporter_cd						NVARCHAR(10)
	,	other_browsing_kbn					SMALLINT
	-- master info
	,	belong_cd_1							NVARCHAR(50)
	,	belong_cd_2							NVARCHAR(50)
	,	belong_cd_3							NVARCHAR(50)
	,	belong_cd_4							NVARCHAR(50)
	,	belong_cd_5							NVARCHAR(50)
	,	job_cd								SMALLINT
	,	position_cd							INT
	,	employee_typ						SMALLINT
	,	grade								SMALLINT
	)
	--
	CREATE TABLE #TABLE_RESULT(
		company_cd							SMALLINT
	,	employee_cd							NVARCHAR(10)
	,	detail_no							SMALLINT
	,	supporter_cd						NVARCHAR(10)
	,	rater_employee_cd_1					NVARCHAR(10)
	,	point								NUMERIC(2,1)	
	,	authority_row_typ					SMALLINT	-- 0.not view | 1.can view | 2.edited
	)
	-- get login user info
	SELECT 
		@authority_typ				=	ISNULL(S0010.authority_typ,0)
	,	@authority_cd				=	ISNULL(S0010.authority_cd,0)
	,	@multireview_authority_typ	=	ISNULL(S0010.multireview_authority_typ,0)
	,	@multireview_authority_cd	=	ISNULL(S0010.multireview_authority_cd,0)
	,	@login_position_cd			=	ISNULL(M0070.position_cd,0)
	,	@w_authority_mQ2000			=	ISNULL(S3021.authority,0)
	FROM S0010
	LEFT OUTER JOIN M0070 ON (
		S0010.company_cd		=	M0070.company_cd
	AND S0010.employee_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT JOIN S3021 ON (
		S0010.company_cd				=	S3021.company_cd
	AND	S0010.multireview_authority_cd	=	S3021.authority_cd
	AND	'mQ2000'						=	S3021.function_id
	AND	S3021.del_datetime	IS NULL
	)
	WHERE 
		S0010.company_cd	= @P_company_cd 
	AND S0010.user_id		= @P_cre_user
	AND S0010.del_datetime IS NULL
	-- add by vietdt 2021/04/07
	-- if @multireview_authority_typ = 3 and @w_authority_mQ2020 = 0 -- not view then set @multireview_authority_typ = 2.suppoter
	IF @multireview_authority_typ = 3 AND @w_authority_mQ2000 = 0
	BEGIN
		SET @multireview_authority_typ = 2 -- SUPPOTER
	END
	-- add by vietdt 2021/04/07
	-- get @use_typ
	SELECT 
		@use_typ		=	ISNULL(S3020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
	FROM S3020
	WHERE
		S3020.company_cd		=	@P_company_cd
	AND S3020.authority_cd		=	@multireview_authority_cd
	AND S3020.del_datetime IS NULL
	-- get @arrange_order
	SELECT 
		@arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@login_position_cd
	AND M0040.del_datetime IS NULL
	-- COUNT ALL ORGANIZATIONS OF S3022 -- add by viettd 2021/06/03
	SET @w_mulitireview_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@multireview_authority_cd,3)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@multireview_authority_cd,3)
	--
	SET @fiscal_year		=	JSON_VALUE(@P_json,'$.fiscal_year')
	SET @review_date_from	=	JSON_VALUE(@P_json,'$.review_date_from')
	SET @review_date_to		=	JSON_VALUE(@P_json,'$.review_date_to')
	SET @project_title		=	JSON_VALUE(@P_json,'$.project_title')
	SET @page				=	JSON_VALUE(@P_json,'$.page')
	SET @page_size			=	JSON_VALUE(@P_json,'$.page_size')
	--
	INSERT INTO #LIST_POSITION
	SELECT json_table.position_cd, 1 FROM OPENJSON(@P_json,'$.list_position_cd') WITH(
		position_cd	int
	)AS json_table
	WHERE json_table.position_cd >= 0
	--
	INSERT INTO #LIST_GRADE
	SELECT json_table.grade FROM OPENJSON(@P_json,'$.list_grade') WITH(
		grade	smallint
	)AS json_table
	--
	INSERT INTO #LIST_JOB
	SELECT json_table.job_cd FROM OPENJSON(@P_json,'$.list_job_cd') WITH(
		job_cd	smallint
	)AS json_table
	--
	INSERT INTO #LIST_EMPLOYEE_TYP
	SELECT json_table.employee_typ FROM OPENJSON(@P_json,'$.list_employee_typ') WITH(
		employee_typ	smallint
	)AS json_table
	--
	INSERT INTO #LIST_EMPLOYEE
	SELECT json_table.detail_no FROM OPENJSON(@P_json,'$.list_employee_cd') WITH(
		detail_no	nvarchar(10)
	)AS json_table
	--
	INSERT INTO #LIST_SUPPORTER
	SELECT json_table.detail_no FROM OPENJSON(@P_json,'$.list_supporter_cd') WITH(
		detail_no	nvarchar(10)
	)AS json_table
	--
	INSERT INTO #LIST_RATER_EMPLOYEE
	SELECT json_table.detail_no FROM OPENJSON(@P_json,'$.list_rater_employee_cd') WITH(
		detail_no	nvarchar(10)
	)AS json_table
	-- INSERT DATA INTO #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 @P_json,@P_cre_user,@P_company_cd,3
	-- get @beginning_date
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
		SET @date_from = CAST((CAST(@fiscal_year AS nvarchar(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		SET @date_to = DATEADD(DD,-1,DATEADD(YYYY,1,@date_from))
	END
	ELSE
	BEGIN 
		SET @year_month_day = CAST((CAST(@fiscal_year AS nvarchar(4)) + '/12/31') AS DATE)
		SET @date_from = CAST((CAST(@fiscal_year AS nvarchar(4)) + '/01/01') AS DATE)
		SET @date_to = CAST((CAST(@fiscal_year AS nvarchar(4)) + '/12/31') AS DATE)
	END
	--
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @year_month_day,'',@P_company_cd
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- GET #LIST_POSITION
	IF NOT EXISTS (SELECT 1 FROM #LIST_POSITION)
	BEGIN
		IF @use_typ = 1
		BEGIN
			INSERT INTO #LIST_POSITION
			SELECT 
				ISNULL(M0040.position_cd,0)				AS	position_cd
			,	0
			FROM M0040
			WHERE 
				M0040.company_cd		=	@P_company_cd
			AND M0040.arrange_order		>	@arrange_order		-- 1. 本人の役職より下位の社員のみ
			AND M0040.del_datetime IS NULL
		END
	END
	--
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--GET DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	INSERT INTO #TABLE_F3000
	SELECT 
		F3000.company_cd			
	,	F3000.employee_cd			
	,	F3000.detail_no			
	,	F3000.supporter_cd	
	,	ISNULL(F3020.other_browsing_kbn,0)		-- 1. can view others suppoter
	,	#M0070H.belong_cd_1
	,	#M0070H.belong_cd_2
	,	#M0070H.belong_cd_3
	,	#M0070H.belong_cd_4
	,	#M0070H.belong_cd_5
	,	#M0070H.job_cd					
	,	#M0070H.position_cd						
	,	#M0070H.employee_typ					
	,	#M0070H.grade
	FROM F3000
	LEFT JOIN #M0070H ON (
		F3000.company_cd  = #M0070H.company_cd
	AND F3000.employee_cd = #M0070H.employee_cd
	)
	LEFT OUTER JOIN F3020 ON(
		F3000.company_cd		=	F3020.company_cd
	AND @fiscal_year			=	F3020.fiscal_year
	AND F3000.employee_cd		=	F3020.employee_cd
	AND F3000.supporter_cd		=	F3020.supporter_cd
	AND F3020.del_datetime IS NULL
	)
	WHERE 
		F3000.company_cd		= @P_company_cd
	AND ( 
		@review_date_from IS NULL
	OR	@review_date_from = ''
	OR	(@review_date_from IS NOT NULL AND @review_date_from <> '' AND F3000.review_date >= @review_date_from)
	)
	AND ( 
		@review_date_to IS NULL
	OR	@review_date_to = ''
	OR	(@review_date_to IS NOT NULL AND @review_date_to <> '' AND F3000.review_date <= @review_date_to )
	)
	AND	F3000.review_date >= @date_from		--add by vietdt 2021/04/07
	AND	F3000.review_date <= @date_to		--add by vietdt 2021/04/07
	AND (@project_title = '' OR F3000.project_title LIKE '%'+@project_title+'%')
	AND F3000.del_datetime IS NULL
	-- add by viettd 2021/06/16
	IF EXISTS(SELECT 1 FROM #LIST_EMPLOYEE)
	BEGIN
		INSERT INTO #TABLE_F0030
		SELECT 
			DISTINCT 
			F0030.company_cd
		,	F0030.fiscal_year
		,	F0030.employee_cd
		,	F0030.rater_employee_cd_1
		FROM F0030
		LEFT JOIN #LIST_EMPLOYEE ON(
			F0030.employee_cd = #LIST_EMPLOYEE.employee_cd
		)
		WHERE 
			F0030.company_cd			=	@P_company_cd
		AND F0030.fiscal_year			=	@fiscal_year
		AND F0030.rater_employee_cd_1	=	@P_login_employee_cd
		AND #LIST_EMPLOYEE.employee_cd IS NOT NULL
		AND F0030.del_datetime IS NULL
	END
	ELSE
	BEGIN
		INSERT INTO #TABLE_F0030
		SELECT 
			DISTINCT 
			F0030.company_cd
		,	F0030.fiscal_year
		,	F0030.employee_cd
		,	F0030.rater_employee_cd_1
		FROM F0030
		WHERE 
			F0030.company_cd			=	@P_company_cd
		AND F0030.fiscal_year			=	@fiscal_year
		AND F0030.rater_employee_cd_1	=	@P_login_employee_cd
		AND F0030.del_datetime IS NULL
	END
	--■■■■■■■■■■■■■ FILTER DATA ■■■■■■■■■■■■■
	-- GET SUPPORTER_OF_EMPLOYEE
	INSERT INTO #TABLE_EMPLOYEE_SUPPORTED_DB
	EXEC REFER_EMPLOYEE_SUPPORTED_MULITIREVIEW_FND1 @fiscal_year,@P_cre_user,@P_company_cd
	--DELETE SUPPORTER_OF_EMPLOYEE
	IF EXISTS (SELECT 1 FROM #TABLE_EMPLOYEE_SUPPORTED_DB ) 
	BEGIN
		DELETE D
		FROM #TABLE_F3000 AS D
		LEFT OUTER JOIN #TABLE_EMPLOYEE_SUPPORTED_DB AS S ON (
			D.company_cd		=	S.company_cd
		AND D.employee_cd		=	S.employee_cd
		)
		WHERE 
			S.employee_cd IS NULL
	END
	-- FILTER 組織
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
	BEGIN
		SET @choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
		-- 1.choice in screen
		IF @choice_in_screen = 1
		BEGIN
			DELETE D FROM #TABLE_F3000 AS D
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
		END
		ELSE IF NOT (@multireview_authority_typ = 3 AND @w_mulitireview_organization_cnt = 0 AND @w_organization_belong_person_typ = 0) -- edited by viettd 2021/06/03
		BEGIN
			DELETE D FROM #TABLE_F3000 AS D
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
			AND @multireview_authority_typ NOT IN (4,5) --4.会社管理者 5.総合管理者
			-- add for mulitireview
			AND D.other_browsing_kbn <> 1
			AND D.supporter_cd	<>	@P_login_employee_cd
		END
	END
	-- FILTER 役職
	IF EXISTS (SELECT 1 FROM #LIST_POSITION)
	BEGIN
		SET @choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #LIST_POSITION WHERE choice_in_screen = 1)
		-- 1.choice in screen
		IF @choice_in_screen = 1
		BEGIN
			DELETE D FROM #TABLE_F3000 AS D
			LEFT OUTER JOIN #LIST_POSITION AS S ON (
				D.company_cd		=	@P_company_cd
			AND D.position_cd		=	S.position_cd
			)
			WHERE
				S.position_cd IS NULL
		END
		ELSE
		BEGIN
			DELETE D FROM #TABLE_F3000 AS D
			LEFT OUTER JOIN #LIST_POSITION AS S ON (
				D.company_cd		=	@P_company_cd
			AND D.position_cd		=	S.position_cd
			)
			WHERE
				S.position_cd IS NULL
			AND D.other_browsing_kbn <> 1
			AND D.supporter_cd	<>	@P_login_employee_cd
		END
	END
	-- FILTER 等級
	IF EXISTS (SELECT 1 FROM #LIST_GRADE)
	BEGIN
		DELETE D FROM #TABLE_F3000 AS D
		LEFT OUTER JOIN #LIST_GRADE AS S ON (
			D.company_cd		=	@P_company_cd
		AND D.grade				=	S.grade
		)
		WHERE
			S.grade IS NULL
	END
	-- FILTER 職種
	IF EXISTS (SELECT 1 FROM #LIST_JOB)
	BEGIN
		DELETE D FROM #TABLE_F3000 AS D
		LEFT OUTER JOIN #LIST_JOB AS S ON (
			D.company_cd		=	@P_company_cd
		AND D.job_cd			=	S.job_cd
		)
		WHERE
			S.job_cd IS NULL
	END
	-- FILTER 社員区分
	IF EXISTS (SELECT 1 FROM #LIST_EMPLOYEE_TYP)
	BEGIN
		DELETE D FROM #TABLE_F3000 AS D
		LEFT OUTER JOIN #LIST_EMPLOYEE_TYP AS S ON (
			D.company_cd		=	@P_company_cd
		AND D.employee_typ		=	S.employee_typ
		)
		WHERE
			S.employee_typ IS NULL
	END
	-- FILTER employee
	IF EXISTS (SELECT 1 FROM #LIST_EMPLOYEE)
	BEGIN
		DELETE D FROM #TABLE_F3000 AS D
		LEFT OUTER JOIN #LIST_EMPLOYEE AS S ON (
			D.company_cd		=	@P_company_cd
		AND D.employee_cd		=	S.employee_cd
		)
		WHERE
			S.employee_cd IS NULL
	END
	-- FILTER supporter
	IF EXISTS (SELECT 1 FROM #LIST_SUPPORTER)
	BEGIN
		DELETE D FROM #TABLE_F3000 AS D
		LEFT OUTER JOIN #LIST_SUPPORTER AS S ON (
			D.company_cd		=	@P_company_cd
		AND D.supporter_cd		=	S.employee_cd
		)
		WHERE
			S.employee_cd IS NULL
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--PROCESS DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- add by viettd 2021/04/26
	-- when user is 4.システム管理者　5.総合管理者
	IF @multireview_authority_typ IN (4,5)
	BEGIN
		INSERT INTO #TABLE_RESULT
		SELECT 
			#TABLE_F3000.company_cd			
		,	#TABLE_F3000.employee_cd			
		,	#TABLE_F3000.detail_no			
		,	#TABLE_F3000.supporter_cd		
		,	F3001.rater_employee_cd_1
		,	F3001.point		
		,	CASE 
				WHEN ISNULL(F3001.rater_employee_cd_1,'') <> ''
				THEN 2	-- edited
				ELSE 0	-- not view
			END					AS	authority_row_typ
		FROM #TABLE_F3000
		LEFT OUTER JOIN F3001 ON (
			#TABLE_F3000.company_cd		=	F3001.company_cd
		AND #TABLE_F3000.employee_cd	=	F3001.employee_cd
		AND #TABLE_F3000.detail_no		=	F3001.detail_no
		AND F3001.del_datetime IS NULL
		)
	END
	-- when 3.管理者
	IF @multireview_authority_typ = 3
	BEGIN
		INSERT INTO #TABLE_RESULT
		SELECT 
			#TABLE_F3000.company_cd			
		,	#TABLE_F3000.employee_cd			
		,	#TABLE_F3000.detail_no			
		,	#TABLE_F3000.supporter_cd		
		,	F3001.rater_employee_cd_1
		,	F3001.point		
		,	CASE 
				WHEN ISNULL(F3001.rater_employee_cd_1,'') <> '' AND @w_authority_mQ2000 = 2 -- EDITED
				THEN 2	-- edited
				WHEN ISNULL(F3001.rater_employee_cd_1,'') <> '' AND @w_authority_mQ2000 = 1 -- VIEW
				THEN 1	-- view
				ELSE 0	-- not view
			END					AS	authority_row_typ
		FROM #TABLE_F3000
		LEFT OUTER JOIN F3001 ON (
			#TABLE_F3000.company_cd		=	F3001.company_cd
		AND #TABLE_F3000.employee_cd	=	F3001.employee_cd
		AND #TABLE_F3000.detail_no		=	F3001.detail_no
		AND F3001.del_datetime IS NULL
		)
		--	UPDATE FROM RATER  : ADMIN  @w_authority_mQ2020 = 1 but is rater --add by vietdt 2021/04/07
		UPDATE #TABLE_RESULT SET 
			authority_row_typ	=	2 -- edited
		FROM #TABLE_RESULT
		WHERE
			#TABLE_RESULT.rater_employee_cd_1 =  @P_login_employee_cd
	END
	-- SUPPORTER & RATER
	IF @multireview_authority_typ = 2
	BEGIN
		-- GET ONLY SUPPOTER WITH other_browsing_kbn = 0
		INSERT INTO #TABLE_RESULT
		SELECT 
			#TABLE_F3000.company_cd			
		,	#TABLE_F3000.employee_cd			
		,	#TABLE_F3000.detail_no			
		,	#TABLE_F3000.supporter_cd		
		,	NULL
		,	NULL
		,	0			
		FROM #TABLE_F3000
		WHERE 
			#TABLE_F3000.supporter_cd			=	@P_login_employee_cd
		AND #TABLE_F3000.other_browsing_kbn		=	0
		-- GET ALL other_browsing_kbn = 1
		INSERT INTO #TABLE_RESULT
		SELECT 
			#TABLE_F3000.company_cd			
		,	#TABLE_F3000.employee_cd			
		,	#TABLE_F3000.detail_no			
		,	#TABLE_F3000.supporter_cd		
		,	NULL
		,	NULL
		,	0			
		FROM #TABLE_F3000
		INNER JOIN (
			SELECT 
				F3020.company_cd
			,	F3020.employee_cd
			FROM F3020
			WHERE 
				F3020.company_cd				=	@P_company_cd 
			AND F3020.fiscal_year				=	@fiscal_year
			AND	F3020.supporter_cd				=	@P_login_employee_cd
			AND F3020.other_browsing_kbn		=	1
			GROUP BY
				F3020.company_cd
			,	F3020.employee_cd
		) AS F3000_EMPLOYEE ON (
			#TABLE_F3000.company_cd		=	F3000_EMPLOYEE.company_cd
		AND #TABLE_F3000.employee_cd	=	F3000_EMPLOYEE.employee_cd
		)
		-- add by viettd 2021/06/16
		INSERT INTO #TABLE_RESULT
		SELECT 
			#TABLE_F0030.company_cd
		,	#TABLE_F0030.employee_cd
		,	#TABLE_F3000.detail_no
		,	#TABLE_F3000.supporter_cd
		,	#TABLE_F0030.rater_employee_cd_1
		,	NULL		AS	point
		,	2 			AS	authority_row_typ	-- 2.edited
		FROM #TABLE_F0030
		LEFT OUTER JOIN #TABLE_F3000 ON (
			#TABLE_F0030.company_cd		=	#TABLE_F3000.company_cd
		AND #TABLE_F0030.employee_cd	=	#TABLE_F3000.employee_cd
		)
		--	UPDATE FROM RATER 
		UPDATE #TABLE_RESULT SET 
			rater_employee_cd_1 =	F3001.rater_employee_cd_1
		,	point				=	F3001.point
		,	authority_row_typ	=	2 -- edited
		FROM #TABLE_RESULT
		INNER JOIN F3001 ON(
			#TABLE_RESULT.company_cd		=	F3001.company_cd
		AND #TABLE_RESULT.employee_cd		=	F3001.employee_cd
		AND #TABLE_RESULT.detail_no			=	F3001.detail_no
		AND @P_login_employee_cd			=	F3001.rater_employee_cd_1
		)
	END
	-- FILTER rater
	IF EXISTS (SELECT 1 FROM #LIST_RATER_EMPLOYEE)
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D
		LEFT OUTER JOIN #LIST_RATER_EMPLOYEE AS S ON (
			D.company_cd			=	@P_company_cd
		AND D.rater_employee_cd_1	=	S.employee_cd
		)
		WHERE
			S.employee_cd IS NULL
	END
	-- CACULATE POINT AVG
	SET @count = (SELECT COUNT(#TABLE_RESULT.company_cd) FROM #TABLE_RESULT WHERE authority_row_typ >= 1)
	IF @count <> 0
	BEGIN
		SET @w_avg_point = (
							SELECT 
								ROUND((SUM(ISNULL(#TABLE_RESULT.point,0))/@count),2) 
							FROM #TABLE_RESULT 
							WHERE #TABLE_RESULT.authority_row_typ >= 1
							)
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF @P_mode = 0 -- search 
	BEGIN
		SET @totalRecord = (SELECT COUNT(1) FROM #TABLE_RESULT)
		SET @pageMax = CEILING(CAST(@totalRecord AS FLOAT) / @page_size)
		IF @pageMax = 0
		BEGIN
			SET @pageMax = 1
		END
		IF @page > @pageMax
		BEGIN
			SET @page = @pageMax
		END
		--[0]
		SELECT 
			#TABLE_RESULT.company_cd						AS	company_cd
		,	#TABLE_RESULT.employee_cd						AS	employee_cd
		,	#M0070H_EMPLOYEE.employee_nm					AS	employee_nm
		,	#TABLE_RESULT.detail_no							AS	detail_no
		,	FORMAT(F3000.review_date,'yyyy/MM/dd')			AS	review_date
		,	#TABLE_RESULT.supporter_cd						AS	supporter_cd
		,	#M0070H_SUPPORTER.employee_nm					AS	supporter_nm
		,	#M0070H_RATER.employee_nm						AS	rater_employee_nm_1
		,	F3000.project_title								AS	project_title
		,	F3000.comment									AS	comment
		,	F3000.evaluation_point							AS	evaluation_point			-- 評価①
		,	#TABLE_RESULT.rater_employee_cd_1				AS  rater_employee_cd_1
		,	F3001.rater_employee_comment_1					AS  rater_employee_comment_1	-- 一次評価者
		,	FORMAT(F3001.importance_point,'##0.0')			AS	importance_point			-- 評価②
		,	F3001.point										AS	point						-- 点数
		,	#TABLE_RESULT.authority_row_typ					AS	authority_row_typ			-- 0.not view | 1.can view | 2.edited
		FROM #TABLE_RESULT
		LEFT JOIN F3000 ON (
			#TABLE_RESULT.company_cd		= F3000.company_cd
		AND #TABLE_RESULT.employee_cd		= F3000.employee_cd
		AND #TABLE_RESULT.detail_no			= F3000.detail_no
		)
		LEFT JOIN F3001 ON (
			#TABLE_RESULT.company_cd			= F3001.company_cd
		AND #TABLE_RESULT.employee_cd			= F3001.employee_cd
		AND #TABLE_RESULT.detail_no				= F3001.detail_no
		AND #TABLE_RESULT.rater_employee_cd_1	= F3001.rater_employee_cd_1
		)
		LEFT JOIN #M0070H AS #M0070H_EMPLOYEE ON (
			#TABLE_RESULT.company_cd		= #M0070H_EMPLOYEE.company_cd
		AND #TABLE_RESULT.employee_cd		= #M0070H_EMPLOYEE.employee_cd
		)
		LEFT JOIN #M0070H AS #M0070H_SUPPORTER ON (
			#TABLE_RESULT.company_cd		= #M0070H_SUPPORTER.company_cd
		AND #TABLE_RESULT.supporter_cd		= #M0070H_SUPPORTER.employee_cd
		)
		LEFT JOIN #M0070H AS #M0070H_RATER ON (
			#TABLE_RESULT.company_cd			= #M0070H_RATER.company_cd
		AND #TABLE_RESULT.rater_employee_cd_1	= #M0070H_RATER.employee_cd
		)
		ORDER BY 
			company_cd
		,	CASE ISNUMERIC(#TABLE_RESULT.employee_cd) 
				WHEN 1 
				THEN CAST(#TABLE_RESULT.employee_cd AS BIGINT) 
				ELSE 999999999 
			END
		,	#TABLE_RESULT.detail_no
		--[1]
		SELECT	
			@totalRecord					AS	totalRecord
		,	@pageMax						AS	pageMax
		,	@page							AS	page
		,	@page_size						AS	pagesize
		,	((@page - 1) * @page_size + 1)	AS	offset
		--[2]
		SELECT 
			FORMAT(ROUND(@w_avg_point, 2),'##0.00')	AS	sum_total
	END
	IF @P_mode = 1 -- excel 個別詳細ダウンロード
	BEGIN
		--[0]	
		SELECT 
			#TABLE_RESULT.employee_cd						AS	employee_cd
		,	#M0070H_A.employee_nm							AS	employee_nm
		,	FORMAT(F3000.review_date,'yyyy/MM/dd')			AS	review_date
		,	#TABLE_RESULT.supporter_cd						AS	supporter_cd
		,	#M0070H_B.employee_nm							AS	supporter_nm
		,	F3000.project_title								AS	project_title
		,	F3000.comment									AS	comment
		,	FORMAT(F3000.comment_date,'yyyy/MM/dd')			AS	comment_date
		,	#TABLE_RESULT.rater_employee_cd_1				AS	rater_employee_cd_1
		,	#M0070H_C.employee_nm							AS	rater_employee_nm_1
		,	ISNULL(F3000.evaluation_point,0)				AS	evaluation_point
		,	ISNULL(F3001.importance_point,0)				AS	importance_point
		,	ISNULL(F3001.rater_employee_comment_1,'')		AS	rater_employee_comment_1
		,	CASE 
				WHEN #TABLE_RESULT.authority_row_typ >= 1
				THEN #TABLE_RESULT.point
				ELSE NULL
			END												AS	point
		,	FORMAT(@w_avg_point,'F2')						AS	avg_point

		,	#TABLE_RESULT.authority_row_typ					AS	authority_row_typ
		,	@P_language										AS	language
		FROM #TABLE_RESULT
		LEFT JOIN F3000 ON (
			#TABLE_RESULT.company_cd		= F3000.company_cd
		AND #TABLE_RESULT.employee_cd		= F3000.employee_cd
		AND #TABLE_RESULT.detail_no			= F3000.detail_no
		)
		LEFT JOIN F3001 ON (
			#TABLE_RESULT.company_cd			= F3001.company_cd
		AND #TABLE_RESULT.employee_cd			= F3001.employee_cd
		AND #TABLE_RESULT.detail_no				= F3001.detail_no
		AND #TABLE_RESULT.rater_employee_cd_1	= F3001.rater_employee_cd_1
		)

		LEFT JOIN #M0070H AS #M0070H_A ON (
			#TABLE_RESULT.company_cd		= #M0070H_A.company_cd
		AND #TABLE_RESULT.employee_cd		= #M0070H_A.employee_cd
		)
		LEFT JOIN #M0070H AS #M0070H_B ON (
			#TABLE_RESULT.company_cd		= #M0070H_B.company_cd
		AND #TABLE_RESULT.supporter_cd		= #M0070H_B.employee_cd
		)
		LEFT JOIN #M0070H AS #M0070H_C ON (
			#TABLE_RESULT.company_cd			= #M0070H_C.company_cd
		AND #TABLE_RESULT.rater_employee_cd_1	= #M0070H_C.employee_cd
		)
		ORDER BY 
			#TABLE_RESULT.company_cd
		,	CASE ISNUMERIC(#TABLE_RESULT.employee_cd) 
				WHEN 1 
				THEN CAST(#TABLE_RESULT.employee_cd AS BIGINT) 
				ELSE 999999999 
			END
		,	#TABLE_RESULT.detail_no
		--[1]
		SELECT 
			COUNT(#TABLE_RESULT.authority_row_typ)	AS	is_rater_admin  -- 0. not > 0 : rater or admin 
		,	@multireview_authority_typ				AS	multireview_authority_typ
		FROM #TABLE_RESULT
		WHERE 
			#TABLE_RESULT.authority_row_typ >= 1
	END
	--
	IF @P_mode = 2 -- excel 平均点一覧ダウンロード
	BEGIN
		INSERT INTO #TABLE_F3001
		SELECT 
			#TABLE_RESULT.employee_cd
		,	ISNULL(#M0070H.employee_nm,'')				AS	employee_nm
		,	0	--			SUM(#TABLE_RESULT.point)					AS	evaluation_point
		,	0	--			COUNT(#TABLE_RESULT.detail_no)				AS	times_of_evaluation
		FROM #TABLE_RESULT
		LEFT OUTER JOIN #M0070H ON (
			@P_company_cd				=	#M0070H.company_cd
		AND #TABLE_RESULT.employee_cd	=	#M0070H.employee_cd
		)
		GROUP BY
			#TABLE_RESULT.employee_cd
		,	#M0070H.employee_nm
		-- UPDATE times_of_evaluation
		UPDATE #TABLE_F3001 SET 
			times_of_evaluation =	ISNULL(TABLE_TIMES.times_of_evaluation,0)
		,	evaluation_point	=	ISNULL(TABLE_TIMES.evaluation_point,0)
		FROM #TABLE_F3001
		INNER JOIN (
			SELECT 
				#TABLE_RESULT.employee_cd				AS	employee_cd
			,	COUNT(#TABLE_RESULT.detail_no)			AS	times_of_evaluation
			,	SUM(#TABLE_RESULT.point)				AS	evaluation_point
			FROM #TABLE_RESULT
			WHERE 
				#TABLE_RESULT.rater_employee_cd_1 <> ''
			GROUP BY
				employee_cd
		) AS TABLE_TIMES ON (
			#TABLE_F3001.employee_cd	=	TABLE_TIMES.employee_cd
		)
		-- CACULATE AVG
		UPDATE #TABLE_F3001 SET 
			evaluation_point = CASE
									WHEN times_of_evaluation <> 0
									THEN ROUND(evaluation_point / times_of_evaluation,2)
									ELSE 0
								END
		FROM #TABLE_F3001
		--[0]
		SELECT
			#TABLE_F3001.employee_cd			AS	employee_cd		
		,	#TABLE_F3001.employee_nm			AS	employee_nm
		,	#TABLE_F3001.evaluation_point		AS	evaluation_point
		,	#TABLE_F3001.times_of_evaluation	AS	times_of_evaluation
		,	@P_language							AS	language
		FROM #TABLE_F3001
		ORDER BY 
			CASE ISNUMERIC(#TABLE_F3001.employee_cd) 
				WHEN 1 
				THEN CAST(#TABLE_F3001.employee_cd AS BIGINT) 
				ELSE 999999999 
			END
	END
END
GO
