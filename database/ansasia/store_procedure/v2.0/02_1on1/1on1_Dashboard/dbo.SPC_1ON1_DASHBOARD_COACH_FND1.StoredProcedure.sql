DROP PROCEDURE [SPC_1ON1_DASHBOARD_COACH_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ [SPC_DASHBOARD_INQ1]
-- EXEC SPC_1ON1_DASHBOARD_COACH_FND1 2020,1,740,'721',3
-- EXEC SPC_1ON1_DASHBOARD_COACH_FND1 '0','-1','1','751','721','5';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	1ON1 DASHBOARD COACH
--*  
--*  作成日/create date			:	2020/11/30				
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2021/05/17
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	when login = coach then show all employee + times of coach
--*   					
--*  更新日/update date			:	2021/05/28
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	change permission of coach
--*   					
--*  更新日/update date			:	2021/06/03
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
--*   	
--*  更新日/update date			:	2021/11/26
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	add param screen 
--*   
--*  更新日/update date			:	2022/01/13
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	CR add permission of coach when [1on1_beginning_date] = NULL
--*  
--*  更新日/update date			:	2022/01/13
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	CR add condition F2200.fullfillment_type
--*  
--*  更新日/update date			:	2022/08/15
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	CR V1.9
--* 
--****************************************************************************************
CREATE PROCEDURE [SPC_1ON1_DASHBOARD_COACH_FND1]
	@P_fiscal_year				smallint		=	0	-- 年度
,	@P_1on1_group_cd			smallint		=	0	-- 1on1グループ
,	@P_times_from				smallint		=	0
,	@P_company_cd				smallint		=	0	-- company_cd
,	@P_employee_cd				nvarchar(10)	=	''	-- login employee_cd
,	@P_1on1_authority_typ		smallint		=	0	-- login authority_typ
,	@P_screen					smallint		=	0	-- 0: screen coach ,1 :screen admin
,	@P_language					nvarchar(2)		=	'jp'	--add vietdt 2022/08/15
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_date								date				=	GETDATE()
	,	@w_times_max						int					=	0
	,	@w_times_str						nvarchar(max)		=	''
	,	@w_i								int					=	1
	,	@w_sql_str							nvarchar(max)		=	''
	,	@w_page_max							int					=	0
	--
	,	@w_mark_typ							int					=	0
	,   @w_times_to							smallint			=	0
	,	@w_fiscal_year_current				int					=	[dbo].FNC_GET_YEAR_1ON1(@P_company_cd,NULL) -- add by viettd 2021/05/28
	,	@w_user_id							nvarchar(50)		=	''
	--
	,	@w_1on1_authority_typ				smallint			=	0
	,	@w_1on1_authority_cd				smallint			=	0
	,	@w_use_typ							smallint			=	0	
	,	@w_arrange_order					int					=	0
	,	@w_login_position_cd				int					=	0
	,	@w_beginning_date					date				=	NULL
	,	@w_year_month_day					date				=	NULL
	-- add by viettd 2021/06/03
	,	@w_1on1_organization_cnt			INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	-- create temp table
	IF object_id('tempdb..#F2001_EMPLOYEE_COACH', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F2001_EMPLOYEE_COACH
    END
	--
	IF object_id('tempdb..#F2001_LIST_TABLE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F2001_LIST_TABLE
    END
	--
	IF object_id('tempdb..#F2001_TABLE_MAX', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F2001_TABLE_MAX
    END
	--
	IF object_id('tempdb..#TIMES_TABLE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TIMES_TABLE
    END
	--
	IF object_id('tempdb..#F2200_TABLE_MIN', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F2200_TABLE_MIN
    END
	--
	IF object_id('tempdb..#F2200_TABLE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F2200_TABLE
    END
	--
	IF object_id('tempdb..#F2310_TABLE_MIN', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F2310_TABLE_MIN
    END	
	--
	IF object_id('tempdb..#PAGING_TABLE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #PAGING_TABLE
    END	
	-- 組織1~5
	IF object_id('tempdb..#TABLE_ORGANIZATION', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_ORGANIZATION
    END
	-- 役職
	IF object_id('tempdb..#LIST_POSITION', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #LIST_POSITION
    END
	--社員履歴
	IF object_id('tempdb..#M0070H', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070H
    END
	-- #F2001_EMPLOYEE_COACH	-- add by viettd 2021/05/17
	CREATE TABLE #F2001_EMPLOYEE_COACH (
		id					int			identity(1,1)
	,	company_cd			smallint
	,	employee_cd			nvarchar(10)
	)
	-- F2001_1on1ペア明細設定
	CREATE TABLE #F2001_LIST_TABLE (
		id					int			identity(1,1)
	,	company_cd			smallint
	,	fiscal_year			smallint
	,	employee_cd			nvarchar(10)
	,	employee_nm			nvarchar(200)
	--
	,	belong_cd_1			nvarchar(50)
	,	belong_cd_2			nvarchar(50)
	,	belong_cd_3			nvarchar(50)
	,	belong_cd_4			nvarchar(50)
	,	belong_cd_5			nvarchar(50)
	,	position_cd			int
	--
	,	[1on1_group_cd]		smallint
	,	times				smallint
	,	interview_cd		smallint
	,	adaption_date		date
	,	fullfillment_type	smallint		--	 F2200.fullfillment_type
	,	fullfillment_img	nvarchar(50)	--	 F2200.fullfillment_type

	)
	-- F2001_1on1ペア明細設定
	CREATE TABLE #F2001_TABLE_MAX (
		id					int			identity(1,1)
	,	company_cd			smallint
	,	fiscal_year			smallint
	,	employee_cd			nvarchar(10)
	,	times				smallint
	)
	--
	CREATE TABLE #TIMES_TABLE (
		times				smallint
	,	is_interview		tinyint		-- 0.not exists interview_cd | 1.can show questionaire | 2.exists interview_cd
	,	is_questionnaire	tinyint		-- 0.not exists questionnaire_cd | 1.exists questionnaire_cd
	,	questionnaire_cd	smallint
	)
	-- F2200_1on1シート入力 _MIN
	CREATE TABLE #F2200_TABLE_MIN (
		id					int			identity(1,1)
	,	company_cd			smallint
	,	employee_cd			nvarchar(10)
	,	fiscal_year			smallint
	,	times				smallint
	)
	-- F2200_1on1シート入力
	CREATE TABLE #F2200_TABLE (
		id					int			identity(1,1)
	,	company_cd			smallint
	,	fiscal_year			smallint
	,	employee_cd			nvarchar(10)
	,	times				smallint
	,	interview_cd		smallint
	,	adaption_date		date
	,	fullfillment_type	smallint
	)
	-- F2310_アンケートファイル
	CREATE TABLE #F2310_TABLE_MIN (
		id					int			identity(1,1)
	,	company_cd			smallint
	,	fiscal_year			smallint
	,	times				smallint
	)
	--#PAGING_TABLE
	CREATE TABLE #PAGING_TABLE (
		page_num			int		
	,	index_from			int
	,	index_to			int
	,	index_txt			nvarchar(100)
	)
	--#PAGING_TABLE
	CREATE TABLE #ONEONONE_GROUP (
		group_cd_1on1			int
	,	group_nm_1on1			nvarchar(20)
	)
	-- #TABLE_ORGANIZATION
	CREATE TABLE #TABLE_ORGANIZATION (
		organization_typ				tinyint
	,	organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)	
	,	choice_in_screen				tinyint		-- 1.choice in screen 0.get from master S0022
	)
	-- #LIST_POSITION
	CREATE TABLE #LIST_POSITION(
		id								int			identity(1,1)
	,	position_cd						int
	,	mode							smallint	-- 0.CHOICE SCREEN 1.MASTER
	)
	--#M0070H
	CREATE TABLE #M0070H(
		application_date				date
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(200)
	,	employee_ab_nm					nvarchar(200)
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
	-- GET INFORMATION FROM LOGIN USER
	SELECT 
		@w_1on1_authority_typ		=	ISNULL(S0010.[1on1_authority_typ],0)
	,	@w_1on1_authority_cd		=	ISNULL(S0010.[1on1_authority_cd],0)
	,	@w_login_position_cd		=	ISNULL(M0070.position_cd,0)
	,	@w_user_id					=	ISNULL(S0010.[user_id],'')
	FROM S0010
	LEFT OUTER JOIN M0070 ON (
		S0010.company_cd		=	M0070.company_cd
	AND S0010.employee_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	WHERE 
		S0010.company_cd	= @P_company_cd 
	AND S0010.employee_cd	= @P_employee_cd
	AND S0010.del_datetime IS NULL
	-- get @use_typ
	SELECT 
		@w_use_typ		=	ISNULL(S2020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
	FROM S2020
	WHERE
		S2020.company_cd		=	@P_company_cd
	AND S2020.authority_cd		=	@w_1on1_authority_cd
	AND S2020.del_datetime IS NULL
	-- COUNT ALL ORGANIZATIONS OF S2022 -- add by viettd 2021/06/03
	SET @w_1on1_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_1on1_authority_cd,2)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_1on1_authority_cd,2)
	-- get @arrange_order
	SELECT 
		@w_arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@w_login_position_cd
	AND M0040.del_datetime IS NULL
	-- get @w_beginning_date
	SELECT 
		@w_beginning_date = M9100.[1on1_beginning_date] 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	-- IF @P_fiscal_year THEN SET CURRENT YEAR
	IF @P_fiscal_year = 0
	BEGIN
		SET @P_fiscal_year = @w_fiscal_year_current
	END
	--
	IF @w_beginning_date IS NOT NULL
	BEGIN
		SET @w_year_month_day = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/' + FORMAT(@w_beginning_date,'MM/dd')) AS DATE)
		SET @w_year_month_day = DATEADD(DD,-1,DATEADD(YYYY,1,@w_year_month_day))
	END
	ELSE
	BEGIN
		SET @w_year_month_day = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/12/31') AS DATE)
	END
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @w_year_month_day,'',@P_company_cd
	-- GET ALL TIMES
	SET @w_i		= @P_times_from
	SET @w_times_to = @P_times_from	+ 5
	--
	INSERT INTO #ONEONONE_GROUP
	EXEC [SPC_REFER_GROUP_FROM_YEAR_1ON1_INQ1] @P_fiscal_year,@P_employee_cd,@P_company_cd
	--add by vietdt 2021/11/30 : get a group that belongs only to Coach
	IF @P_1on1_authority_typ = 2 OR @P_screen = 0
	BEGIN
		DELETE G FROM #ONEONONE_GROUP AS G
		LEFT OUTER JOIN  (
			SELECT DISTINCT
				ISNULL(F2000.[1on1_group_cd],0)		AS	[1on1_group_cd]
			FROM F2001 WITH(NOLOCK)
			LEFT OUTER JOIN F2000 WITH(NOLOCK) ON (
				F2001.company_cd		=	F2000.company_cd
			AND F2001.fiscal_year		=	F2000.fiscal_year
			AND F2001.employee_cd		=	F2000.employee_cd
			)
			INNER JOIN F2001 AS F2001_COACH ON(
				F2001.company_cd		=	F2001_COACH.company_cd
			--AND @w_fiscal_year_current	=	F2001_COACH.fiscal_year
			AND @P_fiscal_year	=	F2001_COACH.fiscal_year	 --updated by namnt 20221005
			AND @P_employee_cd			=	F2001_COACH.coach_cd
			AND	F2001.employee_cd		=	F2001_COACH.employee_cd
			AND F2001_COACH.del_datetime IS NULL
			)
			WHERE 
				F2001.company_cd		=	@P_company_cd
			AND F2001.fiscal_year		=	@P_fiscal_year
			AND F2001.del_datetime IS NULL
			AND F2000.del_datetime IS NULL
			)
		AS GROUP_TABLE ON (
			G.group_cd_1on1	=	GROUP_TABLE.[1on1_group_cd]
		)
		WHERE
			GROUP_TABLE.[1on1_group_cd] IS NULL
	END
	--
	IF @P_1on1_group_cd <= 0 
	BEGIN
		SET @P_1on1_group_cd = (SELECT TOP 1 group_cd_1on1 FROM #ONEONONE_GROUP)
	END
	-- INSERT DATA INTO #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 '',@w_user_id,@P_company_cd,2 -- 2.1on1
	-- GET #LIST_POSITION
	IF NOT EXISTS (SELECT 1 FROM #LIST_POSITION)
	BEGIN
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
	END
	-- get @w_mark_typ
	SELECT 
		@w_mark_typ = ISNULL(M2120.mark_type,0) -- 1:天気　2:表情
	FROM M2120
	WHERE 
		M2120.company_cd	=	@P_company_cd
	AND M2120.del_datetime IS NULL
	-- get data from F2000 + F2001
	-- IF @P_1on1_authority_typ = 2  -- COACH
	IF @P_1on1_authority_typ = 2
	BEGIN
		-- add by viettd 2021/05/17
		-- if current year then get list member of coach 
		INSERT INTO #F2001_EMPLOYEE_COACH
		SELECT 
			F2001.company_cd	
		,	F2001.employee_cd
		FROM F2001
		WHERE 
			F2001.company_cd		=	@P_company_cd
		AND F2001.fiscal_year		=	@P_fiscal_year	-- edited by namnt 20221005
		AND F2001.coach_cd			=	@P_employee_cd
		AND F2001.del_datetime IS NULL
		--add vietdt 2022/01/13
		AND @w_beginning_date IS NOT NULL
		--delete vietdt 2022/01/19 change permission of coach 
		-- if part year or futrue year remove all member when this year login is not coach at time
		--IF @P_fiscal_year <> @w_fiscal_year_current
		--BEGIN
		--	DELETE D FROM #F2001_EMPLOYEE_COACH AS D
		--	LEFT OUTER JOIN (
		--		SELECT 
		--			F2001.company_cd		AS	company_cd
		--		,	F2001.employee_cd		AS	employee_cd
		--		FROM F2001
		--		WHERE 
		--			F2001.company_cd		=	@P_company_cd
		--		AND F2001.fiscal_year		=	@P_fiscal_year
		--		AND F2001.coach_cd			=	@P_employee_cd
		--		AND F2001.del_datetime IS NULL
		--		GROUP BY
		--			F2001.company_cd
		--		,	F2001.employee_cd
		--	) AS F2001_COACH ON (
		--		D.company_cd		=	F2001_COACH.company_cd
		--	AND D.employee_cd		=	F2001_COACH.employee_cd
		--	)
		--	WHERE 
		--		F2001_COACH.employee_cd IS NULL
		--END
		-- INSERT INTO #F2001_LIST_TABLE
		INSERT INTO #F2001_LIST_TABLE
		SELECT 
			F2001.company_cd				AS	company_cd
		,	F2001.fiscal_year				AS	fiscal_year
		,	F2001.employee_cd				AS	employee_cd
		,	ISNULL(M0070.employee_nm,'')	AS	employee_nm
		,	ISNULL(M0070.belong_cd_1,'')	AS	belong_cd_1
		,	ISNULL(M0070.belong_cd_2,'')	AS	belong_cd_2
		,	ISNULL(M0070.belong_cd_3,'')	AS	belong_cd_3
		,	ISNULL(M0070.belong_cd_4,'')	AS	belong_cd_4
		,	ISNULL(M0070.belong_cd_5,'')	AS	belong_cd_5
		,	ISNULL(M0070.position_cd,0)		AS	position_cd
		,	F2000.[1on1_group_cd]			AS	[1on1_group_cd]
		,	F2001.times						AS	times
		,	F2001.interview_cd				AS	interview_cd
		,	F2001.adaption_date				AS	adaption_date
		,	0								AS	fullfillment_type
		,	SPACE(0)						AS	fullfillment_img
		FROM F2001 WITH(NOLOCK)
		INNER JOIN #F2001_EMPLOYEE_COACH ON (
			F2001.company_cd		=	#F2001_EMPLOYEE_COACH.company_cd
		AND F2001.employee_cd		=	#F2001_EMPLOYEE_COACH.employee_cd
		)
		INNER JOIN F2000 WITH(NOLOCK) ON(
			F2001.company_cd		=	F2000.company_cd
		AND F2001.fiscal_year		=	F2000.fiscal_year
		AND F2001.employee_cd		=	F2000.employee_cd
		)
		LEFT OUTER JOIN #M0070H AS M0070 WITH(NOLOCK) ON (
			F2001.company_cd		=	M0070.company_cd
		AND F2001.employee_cd		=	M0070.employee_cd
		)
		LEFT JOIN F2300 ON(
			F2001.company_cd		=	F2300.company_cd
		AND f2001.fiscal_year		=	F2300.fiscal_year
		AND F2000.[1on1_group_cd]	=	F2300.[1on1_group_cd]
		AND f2001.times				=	F2300.times
		AND F2300.submit			=	1
		AND f2300.del_datetime IS NULL
		)
		WHERE 
			F2001.company_cd		=	@P_company_cd
		AND F2001.fiscal_year		=	@P_fiscal_year
		AND F2001.del_datetime IS NULL
		AND (
			@P_1on1_group_cd <= 0
		OR	@P_1on1_group_cd > 0 AND F2000.[1on1_group_cd]	=	@P_1on1_group_cd
		)
		AND F2000.del_datetime IS NULL
	END
	ELSE IF @P_1on1_authority_typ IN (3,4,5) -- MAMAGER
	BEGIN
		-- INSERT INTO #F2001_LIST_TABLE
		INSERT INTO #F2001_LIST_TABLE
		SELECT 
			F2001.company_cd				AS	company_cd
		,	F2001.fiscal_year				AS	fiscal_year
		,	F2001.employee_cd				AS	employee_cd
		,	ISNULL(M0070.employee_nm,'')	AS	employee_nm
		,	ISNULL(M0070.belong_cd_1,'')	AS	belong_cd_1
		,	ISNULL(M0070.belong_cd_2,'')	AS	belong_cd_2
		,	ISNULL(M0070.belong_cd_3,'')	AS	belong_cd_3
		,	ISNULL(M0070.belong_cd_4,'')	AS	belong_cd_4
		,	ISNULL(M0070.belong_cd_5,'')	AS	belong_cd_5
		,	ISNULL(M0070.position_cd,0)		AS	position_cd
		,	F2000.[1on1_group_cd]			AS	[1on1_group_cd]
		,	F2001.times						AS	times
		,	F2001.interview_cd				AS	interview_cd
		,	F2001.adaption_date				AS	adaption_date
		,	0								AS	fullfillment_type
		,	SPACE(0)						AS	fullfillment_img
		FROM F2001 WITH(NOLOCK)
		INNER JOIN F2000 WITH(NOLOCK) ON(
			F2001.company_cd		=	F2000.company_cd
		AND F2001.fiscal_year		=	F2000.fiscal_year
		AND F2001.employee_cd		=	F2000.employee_cd
		)
		LEFT OUTER JOIN #M0070H AS M0070 WITH(NOLOCK) ON (
			F2001.company_cd		=	M0070.company_cd
		AND F2001.employee_cd		=	M0070.employee_cd
		)
		LEFT JOIN F2001 AS F2001_COACH ON(
			F2001.company_cd		=	F2001_COACH.company_cd
		AND @w_fiscal_year_current	=	F2001_COACH.fiscal_year	
		AND @P_employee_cd			=	F2001_COACH.coach_cd
		AND	F2001.employee_cd		=	F2001_COACH.employee_cd
		AND F2001_COACH.del_datetime IS NULL
		)
		WHERE 
			F2001.company_cd		=	@P_company_cd
		AND F2001.fiscal_year		=	@P_fiscal_year
		--add vietdt 2022/01/05 
		AND	(	
				@P_screen = 0 AND	F2001_COACH.employee_cd	IS NOT NULL
			OR	@P_screen <> 0
			)
		--add vietdt 2022/01/05 
		AND F2001.del_datetime IS NULL
		AND (
			@P_1on1_group_cd <= 0
		OR	@P_1on1_group_cd > 0 AND F2000.[1on1_group_cd]	=	@P_1on1_group_cd
		)
		AND F2000.del_datetime IS NULL
		--■■■■■■■■■■■■■ FILTER DATA ■■■■■■■■■■■■■
		-- FILTER 組織1~5
		IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
		BEGIN
			IF NOT (@w_1on1_authority_typ = 3 AND @w_1on1_organization_cnt = 0 AND @w_organization_belong_person_typ = 0) -- edited by viettd 2021/06/03
			BEGIN
				DELETE D FROM #F2001_LIST_TABLE AS D
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
				AND @w_1on1_authority_typ NOT IN (4,5) --4.会社管理者 5.総合管理者
			END
		END
		-- FILTER 役職
		IF EXISTS (SELECT 1 FROM #LIST_POSITION)
		BEGIN
			-- choice in screen
			IF EXISTS (SELECT 1 FROM #LIST_POSITION WHERE mode = 0)
			BEGIN
				DELETE D FROM #F2001_LIST_TABLE AS D
				LEFT OUTER JOIN #LIST_POSITION AS S ON (
					D.company_cd		=	@P_company_cd
				AND D.position_cd		=	S.position_cd
				)
				WHERE
					S.position_cd IS NULL
			END
			ELSE -- not choice in screen
			BEGIN
				IF @w_1on1_authority_typ NOT IN (4,5)
				BEGIN
					DELETE D FROM #F2001_LIST_TABLE AS D
					LEFT OUTER JOIN #LIST_POSITION AS S ON (
						D.company_cd		=	@P_company_cd
					AND D.position_cd		=	S.position_cd
					)
					WHERE
						S.position_cd IS NULL
				END
			END
		END
		--■■■■■■■■■■■■■ END FILTER DATA ■■■■■■■■■■■■■
	END
	-- INSERT INTO #F2001_TABLE_MAX
	INSERT INTO #F2001_TABLE_MAX
	SELECT 
		#F2001_LIST_TABLE.company_cd
	,	#F2001_LIST_TABLE.fiscal_year
	,	#F2001_LIST_TABLE.employee_cd
	,	MAX(#F2001_LIST_TABLE.times)
	FROM #F2001_LIST_TABLE
	WHERE #F2001_LIST_TABLE.[1on1_group_cd] = @P_1on1_group_cd
	GROUP BY
		#F2001_LIST_TABLE.company_cd
	,	#F2001_LIST_TABLE.fiscal_year
	,	#F2001_LIST_TABLE.employee_cd
	-- GET F2200 (1on1シート入力)
	INSERT INTO #F2200_TABLE_MIN
	SELECT 
		DISTINCT
		#F2001_LIST_TABLE.company_cd
	,	#F2001_LIST_TABLE.employee_cd
	,	#F2001_LIST_TABLE.fiscal_year
	,	F2200.times							AS	times
	FROM #F2001_LIST_TABLE
	LEFT OUTER JOIN F2200 WITH(NOLOCK) ON (
		#F2001_LIST_TABLE.company_cd		=	F2200.company_cd
	AND #F2001_LIST_TABLE.fiscal_year		=	F2200.fiscal_year
	AND #F2001_LIST_TABLE.employee_cd		=	F2200.employee_cd
	AND #F2001_LIST_TABLE.times		=	F2200.times
	)
	WHERE
		F2200.company_cd IS NOT NULL
	AND F2200.del_datetime IS NULL
	AND F2200.fin_user_coach IS NOT NULL
	--AND F2200.fin_datetime_member IS NOT NULL
	-- GET F2310_アンケートファイル
	INSERT INTO #F2310_TABLE_MIN
	SELECT 
		DISTINCT
		#F2001_LIST_TABLE.company_cd
	,	#F2001_LIST_TABLE.fiscal_year
	,	F2310.times				
	FROM #F2001_LIST_TABLE
	INNER JOIN F2300 ON (
		@P_company_cd			=	F2300.company_cd
	AND @P_fiscal_year			=	F2300.fiscal_year
	AND @P_1on1_group_cd		=	F2300.[1on1_group_cd]
	AND	#F2001_LIST_TABLE.times	=	F2300.times
	AND 1						=	F2300.submit
	AND F2300.del_datetime IS NULL
	)
	INNER JOIN F2310 WITH(NOLOCK) ON(
		#F2001_LIST_TABLE.company_cd			=	F2310.company_cd
	AND #F2001_LIST_TABLE.fiscal_year			=	F2310.fiscal_year
	AND #F2001_LIST_TABLE.[1on1_group_cd]		=	F2310.[1on1_group_cd]
	AND #F2001_LIST_TABLE.times					=	F2310.times
	AND f2300.questionnaire_cd					=	F2310.questionnaire_cd
	AND @P_employee_cd							=	F2310.employee_cd 
	)
	WHERE 
		F2310.company_cd		=	@P_company_cd
	AND F2310.fiscal_year		=	@P_fiscal_year
	AND F2310.del_datetime IS NULL
	-- GET @w_times_max
	SELECT 
		@w_times_max = ISNULL(MAX(#F2001_TABLE_MAX.times),0)
	FROM #F2001_TABLE_MAX
	IF(@w_times_to >@w_times_max)
	BEGIN
		SET	@w_times_to = @w_times_max
	END
	-- check  @w_times_max > 0
	IF @w_times_max > 0
	BEGIN
		-- GET @w_times_str
		WHILE @w_i <= @w_times_to 
		BEGIN
			IF @w_i = @w_times_to
			BEGIN
				SET @w_times_str = @w_times_str + '['+ CAST(@w_i AS nvarchar(10)) + ']' 
			END
			ELSE
			BEGIN
				SET @w_times_str = @w_times_str + '['+ CAST(@w_i AS nvarchar(10)) + '],' 
			END
			--
			INSERT INTO #TIMES_TABLE VALUES (@w_i,0,0,0)
			--
			SET @w_i = @w_i + 1
		END
		-- INSERT INTO @PAGING_TABLE
		SET @w_i = 1
		SET @w_page_max = CEILING(CAST(@w_times_max AS FLOAT) / 6)
		WHILE @w_i <= @w_page_max
		BEGIN
			INSERT INTO #PAGING_TABLE
			SELECT 
				@w_i
			,	(@w_i - 1) * 6  + 1
			,	CASE WHEN @w_i * 6 > @w_times_max THEN @w_times_max
				ELSE @w_i * 6 
				END
			,	''
			--
			SET @w_i = @w_i + 1
		END
		-- update text
		UPDATE #PAGING_TABLE SET 
			--edit vietdt 2022/08/15
			index_txt =		CASE 
								WHEN	@P_language	=	'en'
								THEN	[dbo].[FNC_COM_FORMAT_TIME_EN](index_from)+ N'ー' +  [dbo].[FNC_COM_FORMAT_TIME_EN](index_to)
								ELSE	CAST(index_from AS nvarchar(10)) + N'回目ー'+ CAST(index_to AS nvarchar(10))+ N'回目'
							END
							
		FROM #PAGING_TABLE
	END
	-- UPDATE interview_cd
	UPDATE #TIMES_TABLE SET 
		is_interview = 2	-- 1.exists interview_cd
	FROM #TIMES_TABLE
	INNER JOIN #F2200_TABLE_MIN ON (
		#TIMES_TABLE.times		=	#F2200_TABLE_MIN.times
	)
	INNER JOIN F2301 ON (  -- must be coach 
		@P_company_cd						=	F2301.company_cd
	AND @P_fiscal_year						=	F2301.fiscal_year
	AND @P_1on1_group_cd					=	F2301.[1on1_group_cd]
	AND @P_employee_cd						=	F2301.employee_cd
	AND	#TIMES_TABLE.times					=	F2301.times
	AND 1									=   F2301.submit
	AND F2301.del_datetime IS NULL
	)
		--UPDATE FROM F2300
	UPDATE #TIMES_TABLE SET 
		#TIMES_TABLE.is_interview = CASE WHEN #TIMES_TABLE.is_interview = 2 
									THEN  1	-- 1.exists interview_cd
									ELSE 0
									END
	,	questionnaire_cd	=	F2300.questionnaire_cd
	FROM #TIMES_TABLE
	INNER JOIN #F2001_LIST_TABLE ON(
		#TIMES_TABLE.times	=	#F2001_LIST_TABLE.times
	)
	INNER JOIN F2300 ON (
		@P_company_cd		=	F2300.company_cd
	AND @P_fiscal_year		=	F2300.fiscal_year
	AND @P_1on1_group_cd	=	F2300.[1on1_group_cd]
	AND	#TIMES_TABLE.times	=	F2300.times
	AND 1					=	F2300.submit
	AND F2300.del_datetime IS NULL
	)
	-- UPDATE questionnaire_cd
	UPDATE #TIMES_TABLE SET 
		is_questionnaire =	CASE WHEN send_datetime IS NOT NULL THEN 1
								 ELSE 0
							END
	FROM #TIMES_TABLE
	INNER JOIN F2301 ON (
		@P_company_cd		=	F2301.company_cd
	AND @P_fiscal_year		=	F2301.fiscal_year
	AND @P_1on1_group_cd	=	F2301.[1on1_group_cd]
	AND @P_employee_cd		=	F2301.employee_cd
	AND	#TIMES_TABLE.times	=	F2301.times
	AND 1					=   F2301.submit
	AND F2301.del_datetime IS NULL
	)
	INNER JOIN F2300 ON (
		@P_company_cd		=	F2300.company_cd
	AND @P_fiscal_year		=	F2300.fiscal_year
	AND @P_1on1_group_cd	=	F2300.[1on1_group_cd]
	AND	#TIMES_TABLE.times	=	F2300.times
	AND 1					=	F2300.submit
	AND F2300.del_datetime IS NULL)
	-- UPDATE FROM F2200.fullfillment_type
	UPDATE #F2001_LIST_TABLE SET 
		fullfillment_type	=	CASE 
									WHEN F2200.submit_datetime_member IS NOT NULL --add vietdt 2022/01/13
									THEN ISNULL(F2200.fullfillment_type,0)
									ELSE #F2001_LIST_TABLE.fullfillment_type
								END


	,	fullfillment_img	=	CASE
									WHEN F2200.submit_datetime_member IS NULL	 --add vietdt 2022/01/13
									THEN #F2001_LIST_TABLE.fullfillment_img		 --add vietdt 2022/01/13
									WHEN @w_mark_typ = 1
									THEN ISNULL(L0010_22.remark1,'')
									WHEN @w_mark_typ = 2
									THEN ISNULL(L0010_23.remark1,'')
									ELSE #F2001_LIST_TABLE.fullfillment_img
								END
	FROM #F2001_LIST_TABLE
	INNER JOIN F2200 ON (
		#F2001_LIST_TABLE.company_cd		=	F2200.company_cd
	AND #F2001_LIST_TABLE.fiscal_year		=	F2200.fiscal_year
	AND #F2001_LIST_TABLE.employee_cd		=	F2200.employee_cd
	AND #F2001_LIST_TABLE.times				=	F2200.times
	AND #F2001_LIST_TABLE.interview_cd		=	F2200.interview_cd
	AND #F2001_LIST_TABLE.adaption_date		=	F2200.adaption_date
	)
	LEFT JOIN L0010 AS L0010_22 ON(
		22									=	L0010_22.name_typ
	AND F2200.fullfillment_type	=	L0010_22.number_cd
	)
	LEFT JOIN L0010 AS L0010_23 ON(
		23									=	L0010_23.name_typ
	AND F2200.fullfillment_type	=	L0010_23.number_cd
	)
	WHERE 
		F2200.company_cd		=	@P_company_cd
	AND F2200.fiscal_year		=	@P_fiscal_year
	AND F2200.del_datetime IS NULL
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--[0]
	SELECT 
	  @P_times_from	AS times_from
	, @w_times_to	AS times_to
	--[1]
	SELECT * FROM #PAGING_TABLE
	--[2]
	SELECT
		#TIMES_TABLE.times
	,	#TIMES_TABLE.is_interview
	,	#TIMES_TABLE.is_questionnaire
	,	#TIMES_TABLE.questionnaire_cd
	from #TIMES_TABLE
	--[3]
	SELECT 
		group_cd_1on1
	,	group_nm_1on1
	FROM #ONEONONE_GROUP
	--[4]
	SELECT @P_1on1_group_cd AS group_cd_1on1
	--[5]
	IF @w_times_max > 0
	BEGIN
		SET @w_sql_str = '
		SELECT
			company_cd
		,	fiscal_year
		,	employee_cd
		,	[1on1_group_cd]		as	group_cd_1on1
		,	employee_nm
		,	'+@w_times_str+'
		FROM 
		(
			SELECT 
				#F2001_LIST_TABLE.company_cd		
			,	#F2001_LIST_TABLE.fiscal_year		
			,	#F2001_LIST_TABLE.employee_cd
			,	#F2001_LIST_TABLE.[1on1_group_cd]	
			,	#F2001_LIST_TABLE.employee_nm
			,	#F2001_LIST_TABLE.times		
			,	''
				[{
					"interview_cd":"''+CAST(ISNULL(#F2001_LIST_TABLE.interview_cd,'''') AS NVARCHAR(10))+''",
					"adaption_date":"''+CAST(ISNULL(#F2001_LIST_TABLE.adaption_date,'''') AS NVARCHAR(10))+''",
					"fullfillment_type":"''+CAST(ISNULL(#F2001_LIST_TABLE.fullfillment_type,'''') AS NVARCHAR(10))+''",
					"fullfillment_img":"''+CAST(ISNULL(#F2001_LIST_TABLE.fullfillment_img,'''') AS NVARCHAR(50))+''"
				}]
				''					AS	times_info
			FROM #F2001_LIST_TABLE
		) AS P
		PIVOT (MAX(times_info) FOR times IN ('+@w_times_str+')) AS A
		'
		--exec
		EXEC(@w_sql_str)
	END
	--DROP TABLE 
	DROP TABLE #F2001_EMPLOYEE_COACH
	DROP TABLE #F2001_LIST_TABLE
	DROP TABLE #F2001_TABLE_MAX
	DROP TABLE #F2200_TABLE
	DROP TABLE #F2200_TABLE_MIN
	DROP TABLE #F2310_TABLE_MIN
	DROP TABLE #ONEONONE_GROUP
	DROP TABLE #PAGING_TABLE
	DROP TABLE #TIMES_TABLE
END	
GO
