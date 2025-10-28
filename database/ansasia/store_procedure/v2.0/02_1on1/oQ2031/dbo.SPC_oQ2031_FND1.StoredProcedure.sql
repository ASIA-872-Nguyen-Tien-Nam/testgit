DROP PROCEDURE [SPC_oQ2031_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--EXEC SPC_oQ2031_FND1 '{"fiscal_year":"2020","position_cd":"-1","job_cd":"-1","employee_typ":"-1","coach_nm":"","list_group_1on1":[],"list_organization_step1":[],"list_organization_step2":[],"list_organization_step3":[],"list_organization_step4":[],"list_organization_step5":[],"list_grade":[],"view_unit":"1"}','oanh2_2','2','0';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	oQ2031_分析（分析（1on1結果・充実度）
--*  
--*  作成日/create date			:	2020/12/18						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2021/05/14
--*　更新者/updater				:	viettd
--*　更新内容/update content		:	when 集計単位 = 0.全社 then only show 平均 (process for CSV , search & cross process in frontend)
--*   					
--*  更新日/update date			:	2021/06/03
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
--*   					
--*  更新日/update date			:	2022/08/23
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	update ver 1.9	
--****************************************************************************************
CREATE PROCEDURE [SPC_oQ2031_FND1]
	-- Add the parameters for the stored procedure here
	@P_language					nvarchar(10)		=	'jp'		
,	@P_json						nvarchar(max)		=	''	
,	@P_cre_user					nvarchar(50)		=	''	
,	@P_company_cd				smallint			=	0	
--
,	@P_mode						INT					=	0	--0:SEARCH/1:OUTPUT CSV/2.CROSS
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								datetime			=	SYSDATETIME()
	,	@year_month_day						date				=	NULL
	--
	,	@w_fiscal_year						int					=	0
	,	@w_group_cd_1on1					smallint			=	0
	,	@w_coach_nm							nvarchar(20)		=	''
	,	@w_employee_typ						smallint			=	0
	,	@w_position_cd						int					=	0
	,	@w_job_cd							smallint			=	0
	,	@w_view_unit						smallint			=	0	-- 0.全社、1.組織１ 、2.職種、3.等級、4.年齢
	,	@w_view_unit_nm						nvarchar(20)		=	''
	--

	,	@w_1on1_authority_typ				smallint			=	0
	,	@w_1on1_authority_cd				smallint			=	0
	,	@use_typ							smallint			=	0	
	,	@arrange_order						int					=	0
	,	@login_position_cd					int					=	0
	--
	,	@beginning_date						date				=	NULL
	,	@current_year						int					=	dbo.FNC_GET_YEAR_1ON1(@P_company_cd,NULL)
	,	@choice_in_screen					tinyint				=	0
	--
	,	@w_sql								nvarchar(max)		=	''
	,	@w_month_str						nvarchar(100)		=	''
	,	@w_i								int					=	1
	,	@w_date_from						date				=	NULL
	,	@w_date_to							date				=	NULL
	,	@w_month_num						int					=	0
	,	@w_target_total						int					=	0
	,	@w_averaged_year_cnt				int					=	0
	,	@w_averaged_point_year				money				=	0
	--	M2121
	,	@w_mark_cd							smallint			=	0
	,	@w_point_from						numeric(5,2)		=	0
	,	@w_point_to							numeric(5,2)		=	0
	,	@w_m2121_cnt						int					=	0
	,	@w_mark_type						smallint			=	0
	,	@w_i_minus							int					=	0
	-- add by viettd 2021/06/03
	,	@w_1on1_organization_cnt			INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
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
	--等級
	IF object_id('tempdb..#LIST_GRADE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #LIST_GRADE
    END
	--コーチ
	IF object_id('tempdb..#LIST_COACH', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #LIST_COACH
    END
	--社員
	IF object_id('tempdb..#M0070', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070
    END
	--社員履歴
	IF object_id('tempdb..#M0070H', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070H
    END
	--↓↓↓ oq2031
	--1on1グループ
	IF object_id('tempdb..#LIST_GROUP_1ON1', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #LIST_GROUP_1ON1
    END
	--
	IF object_id('tempdb..#F2200_TABLE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F2200_TABLE
    END
	--
	IF object_id('tempdb..#M0070_OBJECT', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070_OBJECT
    END
	--
	IF object_id('tempdb..#MONTH_MASTER', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #MONTH_MASTER
    END
	--
	IF object_id('tempdb..#TABLE_RESULT', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_RESULT
    END
	--
	IF object_id('tempdb..#TABLE_BIRTHDAY', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_BIRTHDAY
    END
	--
	IF object_id('tempdb..#TABLE_CROSS', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_CROSS
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
	CREATE TABLE #LIST_POSITION(
		id								int			identity(1,1)
	,	position_cd						int
	,	mode							smallint
	)
	--
	CREATE TABLE #LIST_GRADE(
		id								int			identity(1,1)
	,	grade							smallint
	)
	--
	CREATE TABLE #M0070H(
		application_date				date
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(101)
	,	employee_ab_nm					nvarchar(10)
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
	CREATE TABLE #M0070(
		company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	belong_cd_1						nvarchar(20)
	,	belong_cd_2						nvarchar(20)
	,	belong_cd_3						nvarchar(20)
	,	belong_cd_4						nvarchar(20)
	,	belong_cd_5						nvarchar(20)
	,	job_cd							smallint
	,	position_cd						int
	,	employee_typ					smallint
	,	grade							smallint
	,	birth_date						date
	)
	--
	CREATE TABLE #LIST_COACH(
		id								int			identity(1,1)
	,	company_cd						smallint
	,	fiscal_year						smallint
	,	employee_cd						nvarchar(10)
	,	times							smallint
	,	coach_cd						nvarchar(10)
	)
	--↓↓↓ oq2031
	CREATE TABLE #F2200_TABLE (
		id					int		identity(1,1)
	,	company_cd			smallint
	,	employee_cd			nvarchar(10)
	,	times				smallint
	,	interview_cd		smallint
	,	[start_date]		date
	,	[1on1_group_cd]		smallint
	,	fin_datetime_coach	datetime
	,	fullfillment_type	smallint
	,	point				numeric(5,2)
	--
	,	belong_cd1			nvarchar(20)
	,	job_cd				smallint
	,	grade				smallint
	,	year_old			int
	)
	--
	CREATE TABLE #MONTH_MASTER (
		id				int		identity(1,1)
	,	month_num		int
	,	date_from		date
	,	date_to			date
	)
	--
	CREATE TABLE #TABLE_RESULT (
		id							int		identity(1,1)
	,	company_cd					smallint
	,	fiscal_year					smallint
	,	month_num					int
	,	target_cd					nvarchar(50)			
	,	target_nm					nvarchar(50)
	,	target_typ					smallint			-- 0.全社、1.組織１ 、2.職種、3.等級、4.年齢
	,	fullfillment_point_total	money				-- point total
	,	member_total				int					-- member total
	,	averaged_point				money				-- averaged_point
	,	averaged_point_year			money				-- 年度平均
	,	target_order				INT					-- order by
	)
	--
	CREATE TABLE #TABLE_CROSS (
		id							int		identity(1,1)
	,	company_cd					smallint
	,	fiscal_year					smallint
	,	employee_cd					nvarchar(10)
	,	fullfillment_point_total	money				-- point total
	,	member_total				money				-- member total (number of employee appearances)
	,	averaged_point				money				-- averaged_point
	-- mark M2121
	,	item_no						smallint
	,	mark_cd						smallint
	,	mark_cd_point				numeric(5,2)
	)
	--
	CREATE TABLE #TABLE_BIRTHDAY(
		company_cd					smallint
	,	age_cd						int
	,	age_nm						nvarchar(10)
	)
	--
	CREATE TABLE #LIST_GROUP_1ON1 (
		id								int			identity(1,1)
	,	group_cd_1on1					smallint
	)
	--
	CREATE TABLE #TOTAL (
		month_num						int		
	,	averaged_point_year_month		money	
	,	averaged_point_year				money	
	)

	--CSV
	CREATE TABLE #MONTH_HEADER (
		id								int		identity(1,1)
	,	month_no1						INT
	,	month_no2						INT
	,	month_no3						INT
	,	month_no4						INT
	,	month_no5						INT
	,	month_no6						INT
	,	month_no7						INT
	,	month_no8						INT
	,	month_no9						INT
	,	month_no10						INT
	,	month_no11						INT
	,	month_no12						INT
	)

	--
	CREATE TABLE #DATA (
		status_nm						NVARCHAR(100)
	,	month_no1						NVARCHAR(100)
	,	month_no2						NVARCHAR(100)
	,	month_no3						NVARCHAR(100)
	,	month_no4						NVARCHAR(100)
	,	month_no5						NVARCHAR(100)
	,	month_no6						NVARCHAR(100)
	,	month_no7						NVARCHAR(100)
	,	month_no8						NVARCHAR(100)
	,	month_no9						NVARCHAR(100)
	,	month_no10						NVARCHAR(100)
	,	month_no11						NVARCHAR(100)
	,	month_no12						NVARCHAR(100)
	,	annual_average					NVARCHAR(100)
	)
	--
	SELECT 
		@w_1on1_authority_typ	=	ISNULL(S0010.[1on1_authority_typ],0)
	,	@w_1on1_authority_cd	=	ISNULL(S0010.[1on1_authority_cd],0)
	,	@login_position_cd		=	ISNULL(M0070.position_cd,0)
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
		@use_typ		=	ISNULL(S2020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
	FROM S2020
	WHERE
		S2020.company_cd		=	@P_company_cd
	AND S2020.authority_cd		=	@w_1on1_authority_cd
	AND S2020.del_datetime IS NULL
	-- get @arrange_order
	SELECT 
		@arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@login_position_cd
	AND M0040.del_datetime IS NULL
	-- COUNT ALL ORGANIZATIONS OF S2022 -- add by viettd 2021/06/03
	SET @w_1on1_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_1on1_authority_cd,2)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_1on1_authority_cd,2)
	-- get @w_mark_type
	SELECT 
		@w_mark_type	=	ISNULL(M2120.mark_type,0)
	FROM M2120
	WHERE 
		M2120.company_cd		=	@P_company_cd
	AND M2120.del_datetime IS NULL
	-- GET VALUE FROM JSON
	SET @w_fiscal_year		=	JSON_VALUE(@P_json,'$.fiscal_year')	-- 年度
	SET @w_employee_typ		=	JSON_VALUE(@P_json,'$.employee_typ')		-- 社員区分
	SET @w_position_cd		=	JSON_VALUE(@P_json,'$.position_cd')			-- 役職
	SET @w_coach_nm			=	JSON_VALUE(@P_json,'$.coach_nm')			-- コーチ
	SET @w_job_cd			=	JSON_VALUE(@P_json,'$.job_cd')				-- 職種
	SET @w_view_unit		=	JSON_VALUE(@P_json,'$.view_unit')			-- 表示単位
	--
	SELECT 
		@beginning_date = M9100.[1on1_beginning_date] 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	--
	IF @beginning_date IS NOT NULL
	BEGIN
		SET @year_month_day = CAST((CAST(@w_fiscal_year AS nvarchar(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		SET @year_month_day = DATEADD(DD,-1,DATEADD(YYYY,1,@year_month_day))
	END
	ELSE
	BEGIN 
		SET @year_month_day = CAST((CAST(@w_fiscal_year AS nvarchar(4)) + '/12/31') AS DATE)
	END
	--
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @year_month_day,'',@P_company_cd
	-- INSERT DATA INTO #LIST_POSITION
	IF @w_position_cd IS NOT NULL AND @w_position_cd <> -1
	BEGIN
		INSERT INTO #LIST_POSITION SELECT @w_position_cd , 0
	END
	-- INSERT DATA INTO #LIST_GRADE
	INSERT INTO #LIST_GRADE
	SELECT json_table.grade FROM OPENJSON(@P_json,'$.list_grade') WITH(
		grade	smallint
	)AS json_table
	WHERE
		json_table.grade > 0
	-- INSERT DATA INTO #GROUP_1ON1
	INSERT INTO #LIST_GROUP_1ON1
	SELECT json_table.group_cd_1on1 FROM OPENJSON(@P_json,'$.list_group_1on1') WITH(
		group_cd_1on1	smallint
	)AS json_table
	WHERE
		json_table.group_cd_1on1 > 0
	-- INSERT DATA INTO #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 @P_json,@P_cre_user,@P_company_cd,2
	-- INSERT DATA INTO #LIST_COACH
	IF @w_coach_nm IS NOT NULL AND @w_coach_nm <> ''
	BEGIN
		INSERT INTO #LIST_COACH
		SELECT 
			F2001.company_cd				AS	company_cd
		,	F2001.fiscal_year				AS	fiscal_year
		,	F2001.employee_cd				AS	employee_cd
		,	F2001.times						AS	times
		,	F2001.coach_cd					AS	coach_cd
		FROM F2001 WITH(NOLOCK)
		LEFT OUTER JOIN #M0070H AS M0070_COACH ON (
			F2001.company_cd	=	M0070_COACH.company_cd
		AND F2001.coach_cd		=	M0070_COACH.employee_cd
		)
		WHERE
			F2001.company_cd	=	@P_company_cd
		AND F2001.fiscal_year	=	@w_fiscal_year
		AND F2001.del_datetime IS NULL
		AND M0070_COACH.employee_nm LIKE '%'+@w_coach_nm+'%'
	END
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
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--GET DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	INSERT INTO #M0070
	SELECT 
		M0070.company_cd
	,	M0070.employee_cd
	,	#M0070H.belong_cd_1		
	,	#M0070H.belong_cd_2		
	,	#M0070H.belong_cd_3		
	,	#M0070H.belong_cd_4		
	,	#M0070H.belong_cd_5		
	,	#M0070H.job_cd			
	,	#M0070H.position_cd		
	,	#M0070H.employee_typ	
	,	#M0070H.grade		
	,	M0070.birth_date	
	FROM M0070 WITH (NOLOCK)
	LEFT OUTER JOIN #M0070H ON (
		M0070.company_cd		=	#M0070H.company_cd
	AND M0070.employee_cd		=	#M0070H.employee_cd
	)
	WHERE 
		M0070.company_cd	=	@P_company_cd
	AND M0070.del_datetime IS NULL
	AND (
		@w_employee_typ IS NULL
	OR	@w_employee_typ IS NOT NULL AND @w_employee_typ <= 0
	OR	@w_employee_typ IS NOT NULL AND @w_employee_typ > 0 AND #M0070H.employee_typ = @w_employee_typ
	)
	AND (
		@w_job_cd IS NULL 
	OR	@w_job_cd IS NOT NULL AND @w_job_cd <= 0
	OR	@w_job_cd IS NOT NULL AND @w_job_cd > 0 AND #M0070H.job_cd = @w_job_cd
	)
	--■■■■■■■■■■■■■ FILTER DATA ■■■■■■■■■■■■■
	-- FILTER 組織1~5
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
	BEGIN
		SET @choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
		-- 1.choice in screen
		IF @choice_in_screen = 1
		BEGIN
			DELETE D FROM #M0070 AS D
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
		ELSE IF NOT (@w_1on1_authority_typ = 3 AND @w_1on1_organization_cnt = 0 AND @w_organization_belong_person_typ = 0) -- edited by viettd 2021/06/03
		BEGIN
			DELETE D FROM #M0070 AS D
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
			DELETE D FROM #M0070 AS D
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
				DELETE D FROM #M0070 AS D
				LEFT OUTER JOIN #LIST_POSITION AS S ON (
					D.company_cd		=	@P_company_cd
				AND D.position_cd		=	S.position_cd
				)
				WHERE
					S.position_cd IS NULL
			END
		END
	END
	-- FITER 等級
	IF EXISTS (SELECT 1 FROM #LIST_GRADE)
	BEGIN
		DELETE D FROM #M0070 AS D
		LEFT OUTER JOIN #LIST_GRADE AS S ON (
			D.company_cd		=	@P_company_cd
		AND D.grade				=	S.grade
		)
		WHERE
			S.grade IS NULL
	END
	-- FITER コーチ
	IF @w_coach_nm IS NOT NULL AND @w_coach_nm <> ''
	BEGIN
		DELETE D FROM #M0070 AS D
		LEFT OUTER JOIN #LIST_COACH AS S ON (
			D.company_cd		=	@P_company_cd
		AND D.employee_cd		=	S.employee_cd
		)
		WHERE
			S.employee_cd IS NULL
	END
	--■■■■■■■■■■■■■ END FILTER DATA ■■■■■■■■■■■■■
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--PROCESS DATA TO oQ2030
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	INSERT INTO #MONTH_MASTER
	EXEC [dbo].SPC_1on1_GET_YEAR_MONTHS_FND1 @w_fiscal_year,@P_company_cd
	--#F2200_TABLE
	INSERT INTO #F2200_TABLE
	SELECT 
		F2200.company_cd			
	,	F2200.employee_cd			
	,	F2200.times				
	,	F2200.interview_cd		
	,	NULL					AS	[start_date] -- F2200.[start_date]	
	,	ISNULL(F2000.[1on1_group_cd],0)	
	,	F2200.fin_datetime_coach	
	,	F2200.fullfillment_type
	,	ISNULL(M2121.point,0)	AS	point
	,	#M0070.belong_cd_1
	,	#M0070.job_cd
	,	#M0070.grade
	,	[dbo].FNC_GET_BIRTHDAY_AGE (#M0070.birth_date,NULL)		AS	birth_date
	FROM F2200 WITH(NOLOCK)
	INNER JOIN #M0070 ON (
		F2200.company_cd		=	#M0070.company_cd
	AND F2200.fiscal_year		=	@w_fiscal_year
	AND F2200.employee_cd		=	#M0070.employee_cd
	)
	INNER JOIN F2000 WITH(NOLOCK) ON(
		F2200.company_cd		=	F2000.company_cd
	AND F2200.fiscal_year		=	F2000.fiscal_year
	AND F2200.employee_cd		=	F2000.employee_cd
	AND F2200.del_datetime IS NULL
	)
	LEFT OUTER JOIN M2121 WITH(NOLOCK) ON (
		@P_company_cd			=	M2121.company_cd
	AND @w_mark_type			=	M2121.mark_typ
	AND F2200.fullfillment_type	=	M2121.mark_cd
	AND M2121.del_datetime IS NULL
	)
	WHERE
		F2200.company_cd		=	@P_company_cd
	AND F2200.fiscal_year		=	@w_fiscal_year
	AND F2200.fin_datetime_coach IS NOT NULL
	AND F2200.del_datetime IS NULL
	-- UPDATE [start_date] FROM M2620
	UPDATE #F2200_TABLE SET 
		[start_date]	=	M2620.[start_date]
	FROM #F2200_TABLE
	INNER JOIN M2620 ON (
		#F2200_TABLE.company_cd			=	M2620.company_cd
	AND @w_fiscal_year					=	M2620.fiscal_year
	AND #F2200_TABLE.[1on1_group_cd]	=	M2620.[1on1_group_cd]
	AND #F2200_TABLE.times				=	M2620.times
	AND M2620.del_datetime IS NULL
	)
	-- FITER コーチ
	IF EXISTS (SELECT 1 FROM #LIST_COACH)
	BEGIN
		DELETE D FROM #F2200_TABLE AS D
		LEFT OUTER JOIN #LIST_COACH AS S ON (
			D.company_cd		=	@P_company_cd
		AND D.employee_cd		=	S.employee_cd
		AND D.times				=	S.times
		)
		WHERE
			S.employee_cd IS NULL
	END
	-- FITER グループ
	IF EXISTS (SELECT 1 FROM #LIST_GROUP_1ON1)
	BEGIN
		DELETE D FROM #F2200_TABLE AS D
		LEFT OUTER JOIN #LIST_GROUP_1ON1 AS S ON (
			D.company_cd		=	@P_company_cd
		AND D.[1on1_group_cd]	=	S.group_cd_1on1
		)
		WHERE
			S.group_cd_1on1 IS NULL
	END
	-- UPDATE #F2200_TABLE.year_old
	UPDATE #F2200_TABLE SET 
		year_old =	CASE 
						WHEN #F2200_TABLE.year_old <= 20
						THEN 20
						WHEN #F2200_TABLE.year_old <= 30
						THEN 30
						WHEN #F2200_TABLE.year_old <= 40
						THEN 40
						WHEN #F2200_TABLE.year_old <= 50
						THEN 50
						WHEN #F2200_TABLE.year_old <= 60
						THEN 60
						ELSE 61
					END
	FROM #F2200_TABLE
	-- INSERT INTO #TABLE_CROSS
	IF @P_mode = 2
	BEGIN
		-- GET #TABLE_CROSS FROM F2000
		INSERT INTO #TABLE_CROSS
		SELECT 
			#F2200_TABLE.company_cd		AS	company_cd
		,	@w_fiscal_year				AS	fiscal_year	
		,	#F2200_TABLE.employee_cd	AS	employee_cd
		,	0							AS	fullfillment_point_total
		,	0							AS	member_total
		,	0							AS	averaged_point
		,	0							AS	item_no
		,	0							AS	mark_cd
		,	0							AS	mark_cd_point
		FROM #F2200_TABLE
		GROUP BY
			#F2200_TABLE.company_cd
		,	#F2200_TABLE.employee_cd
		-- UPDATE fullfillment_point_total OF EMPLOYEE
		UPDATE #TABLE_CROSS SET 
			fullfillment_point_total = ISNULL(F2200_POINT.fullfillment_point_total,0)
		FROM #TABLE_CROSS
		INNER JOIN (
			SELECT 
				#F2200_TABLE.company_cd			AS	company_cd
			,	@w_fiscal_year					AS	fiscal_year	
			,	#F2200_TABLE.employee_cd		AS	employee_cd
			,	SUM(#F2200_TABLE.point)			AS	fullfillment_point_total
			FROM #F2200_TABLE
			GROUP BY
				#F2200_TABLE.company_cd
			,	#F2200_TABLE.employee_cd
		) AS F2200_POINT ON (
			#TABLE_CROSS.company_cd		=	F2200_POINT.company_cd
		AND #TABLE_CROSS.fiscal_year	=	F2200_POINT.fiscal_year
		AND #TABLE_CROSS.employee_cd	=	F2200_POINT.employee_cd
		)
		-- UPDATE member_total
		UPDATE #TABLE_CROSS SET 
			member_total = ISNULL(F2200_CNT.member_total,0)
		FROM #TABLE_CROSS
		INNER JOIN (
			SELECT 
				#F2200_TABLE.company_cd				AS	company_cd
			,	#F2200_TABLE.employee_cd			AS	employee_cd
			,	COUNT(#F2200_TABLE.interview_cd)	AS	member_total
			FROM #F2200_TABLE
			GROUP BY
				#F2200_TABLE.company_cd	
			,	#F2200_TABLE.employee_cd
		) AS F2200_CNT ON (
			#TABLE_CROSS.company_cd			=	F2200_CNT.company_cd
		AND #TABLE_CROSS.employee_cd		=	F2200_CNT.employee_cd
		)
		-- UPDATE averaged_point
		UPDATE #TABLE_CROSS SET 
			averaged_point =	CASE 
									WHEN member_total > 0
									THEN ROUND((fullfillment_point_total / member_total),2)
									ELSE 0
								END  
		FROM #TABLE_CROSS
		-- UPDATE item_no + mark_cd
		SET @w_m2121_cnt = (SELECT COUNT(M2121.item_no) FROM M2121 
														WHERE 
															M2121.company_cd	= @P_company_cd 
														AND	M2121.mark_typ		= @w_mark_type
														AND M2121.del_datetime IS NULL
		)
		-- 
		SET @w_i = @w_m2121_cnt
		WHILE @w_i >= 1
		BEGIN
			-- RESET @w_point_from & @w_point_to
			SET @w_point_from = 0
			SET @w_point_to = 0
			--
			SELECT
				@w_mark_cd		= ISNULL(M2121.mark_cd,0)
			,	@w_point_from	= ISNULL(M2121.point,0)
			FROM M2121
			WHERE M2121.item_no = @w_i
			--
			SET @w_i_minus = @w_i - 1
			--
			SELECT 
				@w_point_to = ISNULL(M2121.point,0) 
			FROM M2121 
			WHERE 
				M2121.item_no = @w_i_minus
			--UPDATE #TABLE_CROSS WITH mark_cd + mark_cd_point

			IF @w_point_from = 0
			BEGIN
				UPDATE #TABLE_CROSS SET 
					item_no			= @w_i
				,	mark_cd			= @w_mark_cd
				,	mark_cd_point	= @w_point_from 
				FROM #TABLE_CROSS
				WHERE 
					#TABLE_CROSS.averaged_point < @w_point_to
			END
			ELSE IF @w_point_to = 0
			BEGIN
				UPDATE #TABLE_CROSS SET
					item_no			= @w_i 
				,	mark_cd			= @w_mark_cd
				,	mark_cd_point	= @w_point_from 
				FROM #TABLE_CROSS
				WHERE 
					#TABLE_CROSS.averaged_point >= @w_point_from
			END
			ELSE
			BEGIN
				UPDATE #TABLE_CROSS SET 
					item_no			= @w_i
				,	mark_cd			= @w_mark_cd
				,	mark_cd_point	= @w_point_from 
				FROM #TABLE_CROSS
				WHERE 
					#TABLE_CROSS.averaged_point >= @w_point_from
				AND #TABLE_CROSS.averaged_point < @w_point_to
			END
			--
			SET @w_i = @w_i - 1
		END
		-- GOTO COMPLETED
		GOTO COMPLETED
	END
	-- INSERT INTO #TABLE_RESULT
	-- 0.全社
	IF @w_view_unit = 0
	BEGIN
		SET @w_view_unit_nm = '全社'
		--
		INSERT INTO #TABLE_RESULT
		SELECT 
			@P_company_cd
		,	@w_fiscal_year
		,	#MONTH_MASTER.month_num
		,	CAST(@P_company_cd AS nvarchar(50))	AS	target_cd
		,	ISNULL(M0001.company_nm,'')			AS	target_nm
		,	0	-- 0.全社
		,	0	-- fullfillment_point_total
		,	0	-- member_total
		,	0	--	averaged_point		
		,	0	--	averaged_point_year	
		--
		,	0	--target_order
		FROM #MONTH_MASTER
		LEFT OUTER JOIN M0001 WITH(NOLOCK) ON (
			@P_company_cd	=	M0001.company_cd
		)
		GOTO CACULATE
	END
	-- 1.組織１
	IF @w_view_unit = 1
	BEGIN
		SET @w_view_unit_nm = '部署'
		--
		INSERT INTO #TABLE_RESULT
		SELECT 
			@P_company_cd
		,	@w_fiscal_year
		,	#MONTH_MASTER.month_num
		,	ISNULL(M0020.organization_cd_1,'')			AS	target_cd
		,	ISNULL(M0020.organization_nm,'')			AS	target_nm
		,	1	-- 1.組織１
		,	0	-- fullfillment_point_total
		,	0	-- member_total
		,	0	--	averaged_point		
		,	0	--	averaged_point_year	
		--
		,	M0020.arrange_order	--target_order
		FROM #MONTH_MASTER
		LEFT OUTER JOIN M0020 WITH(NOLOCK) ON (
			@P_company_cd	=	M0020.company_cd
		AND 1				=	M0020.organization_typ
		AND M0020.del_datetime IS NULL
		)
		WHERE 
			M0020.company_cd		=	@P_company_cd
		AND M0020.organization_typ	=	1
		AND M0020.del_datetime IS NULL
		ORDER BY 
			M0020.arrange_order ASC
		,	CASE WHEN  M0020.organization_cd_1 NOT LIKE '%[^0-9]%' THEN CAST(M0020.organization_cd_1 AS bigint)
				ELSE 999
			END
		,	M0020.organization_cd_1
		GOTO CACULATE
	END
	-- 2.職種
	IF @w_view_unit = 2
	BEGIN
		SET @w_view_unit_nm = '職種'
		--
		INSERT INTO #TABLE_RESULT
		SELECT 
			@P_company_cd
		,	@w_fiscal_year
		,	#MONTH_MASTER.month_num
		,	CAST(ISNULL(M0030.job_cd,0)	AS nvarchar(50))	AS	target_cd
		,	ISNULL(M0030.job_nm,'')							AS	target_nm
		,	2	-- 2.職種
		,	0	-- fullfillment_point_total
		,	0	-- member_total
		,	0	--	averaged_point		
		,	0	--	averaged_point_year	
		--
		,	M0030.arrange_order	--target_order
		FROM #MONTH_MASTER
		LEFT OUTER JOIN M0030 WITH(NOLOCK) ON (
			@P_company_cd	=	M0030.company_cd
		AND M0030.del_datetime IS NULL
		)
		WHERE 
			M0030.company_cd		=	@P_company_cd
		AND M0030.del_datetime IS NULL
		ORDER BY 
			M0030.arrange_order
		,	M0030.job_cd
		GOTO CACULATE
	END	
	-- 3.等級
	IF @w_view_unit = 3
	BEGIN
		SET @w_view_unit_nm = '等級'
		--
		INSERT INTO #TABLE_RESULT
		SELECT 
			@P_company_cd
		,	@w_fiscal_year
		,	#MONTH_MASTER.month_num
		,	CAST(ISNULL(M0050.grade,0)	AS nvarchar(50))		AS	target_cd
		,	ISNULL(M0050.grade_nm,'')							AS	target_nm
		,	3	-- 3.等級
		,	0	-- fullfillment_point_total
		,	0	-- member_total
		,	0	--	averaged_point		
		,	0	--	averaged_point_year	
		--
		,	M0050.arrange_order	--target_order
		FROM #MONTH_MASTER
		LEFT OUTER JOIN M0050 WITH(NOLOCK) ON (
			@P_company_cd	=	M0050.company_cd
		AND M0050.del_datetime IS NULL
		)
		WHERE 
			M0050.company_cd		=	@P_company_cd
		AND M0050.del_datetime IS NULL
		ORDER BY 
			M0050.arrange_order
		,	M0050.grade
		GOTO CACULATE
	END	
	-- 4.年齢
	IF @w_view_unit = 4
	BEGIN
		SET @w_view_unit_nm = '年齢'
		--
		INSERT INTO #TABLE_BIRTHDAY VALUES(@P_company_cd,20,IIF(@P_language = 'en','20'+''''+'s',N'20代'))
		INSERT INTO #TABLE_BIRTHDAY VALUES(@P_company_cd,30,IIF(@P_language = 'en','30'+''''+'s',N'30代'))
		INSERT INTO #TABLE_BIRTHDAY VALUES(@P_company_cd,40,IIF(@P_language = 'en','40'+''''+'s',N'40代'))
		INSERT INTO #TABLE_BIRTHDAY VALUES(@P_company_cd,50,IIF(@P_language = 'en','50'+''''+'s',N'50代'))
		INSERT INTO #TABLE_BIRTHDAY VALUES(@P_company_cd,60,IIF(@P_language = 'en','60'+''''+'s',N'60代'))
		INSERT INTO #TABLE_BIRTHDAY VALUES(@P_company_cd,61,IIF(@P_language = 'en','60'+''''+'s~',N'60代~'))
		--
		INSERT INTO #TABLE_RESULT
		SELECT 
			@P_company_cd
		,	@w_fiscal_year
		,	#MONTH_MASTER.month_num
		,	CAST(ISNULL(#TABLE_BIRTHDAY.age_cd,0)	AS nvarchar(50))	AS	target_cd
		,	ISNULL(#TABLE_BIRTHDAY.age_nm,'')							AS	target_nm
		,	4	-- 4.年齢
		,	0	-- fullfillment_point_total
		,	0	-- member_total
		,	0	--	averaged_point		
		,	0	--	averaged_point_year	
		--
		,	0	--target_order
		FROM #MONTH_MASTER
		LEFT OUTER JOIN #TABLE_BIRTHDAY WITH(NOLOCK) ON (
			@P_company_cd	=	#TABLE_BIRTHDAY.company_cd
		)
		GOTO CACULATE
	END	
	-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- CACULATE
	-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
CACULATE:
	-- LOOP 12 MONTH
	WHILE @w_i <= 12
	BEGIN
		SELECT 
			@w_date_from	=	#MONTH_MASTER.date_from
		,	@w_date_to		=	#MONTH_MASTER.date_to
		,	@w_month_num	=	#MONTH_MASTER.month_num
		FROM #MONTH_MASTER
		WHERE 
			#MONTH_MASTER.id = @w_i
		-- 0.全社
		IF @w_view_unit = 0
		BEGIN
			-- UPDATE fullfillment_point_total
			UPDATE #TABLE_RESULT SET 
				fullfillment_point_total	=	F2200_TOTAL.point_sum
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					SUM(#F2200_TABLE.point)			AS	point_sum
				FROM #F2200_TABLE
				WHERE 
					#F2200_TABLE.[start_date]	>=	@w_date_from
				AND #F2200_TABLE.[start_date]	<=	@w_date_to
			) AS F2200_TOTAL ON(
				#TABLE_RESULT.month_num		=	@w_month_num
			)
			-- UPDATE member_total
			UPDATE #TABLE_RESULT SET 
				member_total	=	ISNULL(F2200_TOTAL.employee_cd_sum,0)
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					#F2200_TABLE.company_cd				AS	company_cd
				,	COUNT(#F2200_TABLE.employee_cd)		AS	employee_cd_sum
				FROM #F2200_TABLE
				WHERE 
					#F2200_TABLE.[start_date]	>=	@w_date_from
				AND #F2200_TABLE.[start_date]	<=	@w_date_to
				GROUP BY
					#F2200_TABLE.company_cd
			) AS F2200_TOTAL ON(
				#TABLE_RESULT.month_num		=	@w_month_num
			)
		END
		-- 1.組織１
		ELSE IF @w_view_unit = 1
		BEGIN
			-- UPDATE fullfillment_point_total
			UPDATE #TABLE_RESULT SET 
				fullfillment_point_total	=	F2200_TOTAL_1.point_sum
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					#F2200_TABLE.belong_cd1			AS	belong_cd1
				,	SUM(#F2200_TABLE.point)			AS	point_sum
				FROM #F2200_TABLE
				WHERE 
					#F2200_TABLE.[start_date]	>=	@w_date_from
				AND #F2200_TABLE.[start_date]	<=	@w_date_to
				GROUP BY
					#F2200_TABLE.belong_cd1
			) AS F2200_TOTAL_1 ON(
				#TABLE_RESULT.month_num		=	@w_month_num
			AND #TABLE_RESULT.target_cd		=	F2200_TOTAL_1.belong_cd1
			)
			-- UPDATE member_total
			UPDATE #TABLE_RESULT SET 
				member_total	=	ISNULL(F2200_TOTAL_1.employee_cd_sum,0)
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					#F2200_TABLE.belong_cd1				AS	belong_cd1
				,	COUNT(#F2200_TABLE.employee_cd)		AS	employee_cd_sum
				FROM #F2200_TABLE
				WHERE 
					#F2200_TABLE.[start_date]	>=	@w_date_from
				AND #F2200_TABLE.[start_date]	<=	@w_date_to
				GROUP BY
					#F2200_TABLE.belong_cd1
			) AS F2200_TOTAL_1 ON(
				#TABLE_RESULT.month_num		=	@w_month_num
			AND #TABLE_RESULT.target_cd		=	F2200_TOTAL_1.belong_cd1
			)
			--
		END
		-- 2.職種
		ELSE IF @w_view_unit = 2
		BEGIN
			-- UPDATE fullfillment_point_total
			UPDATE #TABLE_RESULT SET 
				fullfillment_point_total	=	F2200_TOTAL_2.point_sum
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					#F2200_TABLE.job_cd				AS	job_cd
				,	SUM(#F2200_TABLE.point)			AS	point_sum
				FROM #F2200_TABLE
				WHERE 
					#F2200_TABLE.[start_date]	>=	@w_date_from
				AND #F2200_TABLE.[start_date]	<=	@w_date_to
				GROUP BY
					#F2200_TABLE.job_cd
			) AS F2200_TOTAL_2 ON(
				#TABLE_RESULT.month_num		=	@w_month_num
			AND #TABLE_RESULT.target_cd		=	F2200_TOTAL_2.job_cd
			)
			-- UPDATE member_total
			UPDATE #TABLE_RESULT SET 
				member_total	=	ISNULL(F2200_TOTAL_2.employee_cd_sum,0)
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					#F2200_TABLE.job_cd					AS	job_cd
				,	COUNT(#F2200_TABLE.employee_cd)		AS	employee_cd_sum
				FROM #F2200_TABLE
				WHERE 
					#F2200_TABLE.[start_date]	>=	@w_date_from
				AND #F2200_TABLE.[start_date]	<=	@w_date_to
				GROUP BY
					#F2200_TABLE.job_cd
			) AS F2200_TOTAL_2 ON(
				#TABLE_RESULT.month_num		=	@w_month_num
			AND #TABLE_RESULT.target_cd		=	F2200_TOTAL_2.job_cd
			)
		END
		-- 3.等級
		ELSE IF @w_view_unit = 3
		BEGIN
			-- UPDATE fullfillment_point_total
			UPDATE #TABLE_RESULT SET 
				fullfillment_point_total	=	F2200_TOTAL_3.point_sum
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					#F2200_TABLE.grade				AS	grade
				,	SUM(#F2200_TABLE.point)			AS	point_sum
				FROM #F2200_TABLE
				WHERE 
					#F2200_TABLE.[start_date]	>=	@w_date_from
				AND #F2200_TABLE.[start_date]	<=	@w_date_to
				GROUP BY
					#F2200_TABLE.grade
			) AS F2200_TOTAL_3 ON(
				#TABLE_RESULT.month_num		=	@w_month_num
			AND #TABLE_RESULT.target_cd		=	F2200_TOTAL_3.grade
			)
			-- UPDATE member_total
			UPDATE #TABLE_RESULT SET 
				member_total	=	ISNULL(F2200_TOTAL_3.employee_cd_sum,0)
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					#F2200_TABLE.grade					AS	grade
				,	COUNT(#F2200_TABLE.employee_cd)		AS	employee_cd_sum
				FROM #F2200_TABLE
				WHERE 
					#F2200_TABLE.[start_date]	>=	@w_date_from
				AND #F2200_TABLE.[start_date]	<=	@w_date_to
				GROUP BY
					#F2200_TABLE.grade
			) AS F2200_TOTAL_3 ON(
				#TABLE_RESULT.month_num		=	@w_month_num
			AND #TABLE_RESULT.target_cd		=	F2200_TOTAL_3.grade
			)
		END
		-- 4.年齢
		ELSE IF @w_view_unit = 4
		BEGIN
			-- UPDATE fullfillment_point_total
			UPDATE #TABLE_RESULT SET 
				fullfillment_point_total	=	F2200_TOTAL_4.point_sum
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					#F2200_TABLE.year_old			AS	year_old
				,	SUM(#F2200_TABLE.point)			AS	point_sum
				FROM #F2200_TABLE
				WHERE 
					#F2200_TABLE.[start_date]	>=	@w_date_from
				AND #F2200_TABLE.[start_date]	<=	@w_date_to
				GROUP BY
					#F2200_TABLE.year_old
			) AS F2200_TOTAL_4 ON(
				#TABLE_RESULT.month_num		=	@w_month_num
			AND #TABLE_RESULT.target_cd		=	F2200_TOTAL_4.year_old
			)
			-- UPDATE member_total
			UPDATE #TABLE_RESULT SET 
				member_total	=	ISNULL(F2200_TOTAL_4.employee_cd_sum,0)
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					#F2200_TABLE.year_old				AS	year_old
				,	COUNT(#F2200_TABLE.employee_cd)		AS	employee_cd_sum
				FROM #F2200_TABLE
				WHERE 
					#F2200_TABLE.[start_date]	>=	@w_date_from
				AND #F2200_TABLE.[start_date]	<=	@w_date_to
				GROUP BY
					#F2200_TABLE.year_old
			) AS F2200_TOTAL_4 ON(
				#TABLE_RESULT.month_num		=	@w_month_num
			AND #TABLE_RESULT.target_cd		=	F2200_TOTAL_4.year_old
			)
		END
		--
		IF @w_i = 12
		BEGIN
			SET @w_month_str = @w_month_str + '['+ CAST(@w_month_num AS nvarchar(2)) + ']'
		END
		ELSE
		BEGIN
			SET @w_month_str = @w_month_str + '['+ CAST(@w_month_num AS nvarchar(2)) + '],'
		END
		--
		SET @w_i = @w_i + 1
	END
	-- caculate averaged_point
	UPDATE #TABLE_RESULT SET 
		averaged_point	=	CASE 
								WHEN member_total <> 0
								THEN ROUND(fullfillment_point_total / member_total,2)
								ELSE 0
							END
	-- caculate averaged_point_year
	-- get all month when has value
	-- sum (averaged_point) 
	UPDATE #TABLE_RESULT SET 
		averaged_point_year = ISNULL(TABLE_SUM.averaged_point,0)
	FROM #TABLE_RESULT
	INNER JOIN (
		SELECT 
			#TABLE_RESULT.target_cd				AS	target_cd
		,	SUM(#TABLE_RESULT.averaged_point)	AS	averaged_point
		FROM #TABLE_RESULT
		GROUP BY
			#TABLE_RESULT.target_cd
	) AS TABLE_SUM ON (
		#TABLE_RESULT.target_cd	=	TABLE_SUM.target_cd
	)
	-- AVG FOR YEAR
	UPDATE #TABLE_RESULT SET 
		averaged_point_year =	CASE 
									WHEN TARGET_MONTH_CNT.target_month_cnt > 0
									THEN ROUND((ISNULL(#TABLE_RESULT.averaged_point_year,0) / TARGET_MONTH_CNT.target_month_cnt),2)
									ELSE 0
								END
	FROM #TABLE_RESULT
	INNER JOIN (
		SELECT 
			#TABLE_RESULT.target_cd				AS	target_cd
		,	COUNT(#TABLE_RESULT.target_cd)		AS	target_month_cnt
		FROM #TABLE_RESULT
		WHERE 
			#TABLE_RESULT.averaged_point	>	0
		GROUP BY
			#TABLE_RESULT.target_cd
	)AS TARGET_MONTH_CNT ON (
		#TABLE_RESULT.target_cd	=	TARGET_MONTH_CNT.target_cd
	)
	-- GET TOTAL OF TARGET
	SELECT 
		@w_target_total  = COUNT(TABLE_TARGET.target_cd)
	FROM 
		(
			SELECT 
				#TABLE_RESULT.target_cd
			FROM #TABLE_RESULT
			WHERE 
				#TABLE_RESULT.member_total > 0
			GROUP BY
				#TABLE_RESULT.target_cd
		) AS TABLE_TARGET
	-- INSRET DATA INTO #TOTAL
	INSERT INTO #TOTAL
	SELECT
		#MONTH_MASTER.month_num					AS	month_num
	,	TABLE_TMP.averaged_point_year_month		AS	averaged_point_year_month
	,	0										AS	averaged_point_year
	FROM #MONTH_MASTER
	LEFT OUTER JOIN (
		SELECT
			#TABLE_RESULT.month_num				AS	month_num
		,	CASE 
				WHEN @w_target_total <> 0
				THEN ROUND((SUM(#TABLE_RESULT.averaged_point)	/	@w_target_total),2)
				ELSE 0
			END									AS	averaged_point_year_month
		FROM #TABLE_RESULT
		GROUP BY
			#TABLE_RESULT.month_num	
	) AS TABLE_TMP ON (
		#MONTH_MASTER.month_num = TABLE_TMP.month_num
	)
	-- UPDATE averaged_point_year
	SET @w_averaged_year_cnt = (SELECT COUNT(#TOTAL.month_num) FROM #TOTAL WHERE #TOTAL.averaged_point_year_month > 0)
	SET @w_averaged_point_year = (SELECT SUM(#TOTAL.averaged_point_year_month) FROM #TOTAL)
	--
	UPDATE #TOTAL SET 
		averaged_point_year	=	CASE 
									WHEN @w_averaged_year_cnt <> 0
									THEN ROUND((@w_averaged_point_year / @w_averaged_year_cnt),2)
									ELSE 0
								END
	FROM #TOTAL
	-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- COMPLETED
	-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
COMPLETED:	
	--SEARCH
	IF (@P_mode = 0)
	BEGIN
		--[0]
		IF @w_month_str <> ''
		BEGIN
			SET @w_sql = '
				SELECT 
					company_cd
				,	fiscal_year
				,	target_cd	
				,	target_nm	
				,	target_typ
				,	'+@w_month_str+'
				FROM
				(
					SELECT 
						#TABLE_RESULT.company_cd		AS	company_cd
					,	#TABLE_RESULT.fiscal_year		AS	fiscal_year
					,	#TABLE_RESULT.target_cd			AS	target_cd
					,	#TABLE_RESULT.target_order		AS	target_order
					,	#TABLE_RESULT.target_nm			AS	target_nm
					,	#TABLE_RESULT.target_typ		AS	target_typ
					,	#TABLE_RESULT.month_num			AS	month_num
					,	''{
							"averaged_point":"''+CAST(FORMAT(#TABLE_RESULT.averaged_point,''0.##'') AS nvarchar(20))+''",
							"averaged_point_year":"''+CAST(FORMAT(#TABLE_RESULT.averaged_point_year,''0.##'') AS nvarchar(20))+''"
						}''		AS	caculate_result
					FROM #TABLE_RESULT
				) AS P 
				Pivot(MAX(caculate_result) FOR month_num IN ('+@w_month_str+')) AS A
				ORDER BY
					target_order ASC
				,	CASE 
						WHEN target_cd NOT LIKE ''%[^0-9]%'' 
						THEN CAST(target_cd AS bigint)
						ELSE 999
					END
				,	target_cd
			'
			EXEC(@w_sql)
		END
		ELSE
		BEGIN
			SELECT * FROM #TABLE_RESULT
		END
		--[1]
		SELECT
			#TOTAL.month_num									AS	month_num
		,	FORMAT(#TOTAL.averaged_point_year,'0.##')			AS	averaged_point_year
		,	FORMAT(#TOTAL.averaged_point_year_month,'0.##')		AS	averaged_point_year_month
		FROM #TOTAL
	END
	--OUTPUT CSV
	IF(@P_mode = 1)
	BEGIN
		--
		CREATE TABLE #MONTH(
			month_no INT
		,	month_name	NVARCHAR(20)
		)
		INSERT INTO #MONTH(month_no,month_name) VALUES (1,IIF(@P_language = 'en','Jan','1月'))
		INSERT INTO #MONTH(month_no,month_name) VALUES (2,IIF(@P_language = 'en','Feb','2月'))
		INSERT INTO #MONTH(month_no,month_name) VALUES (3,IIF(@P_language = 'en','Mar','3月'))
		INSERT INTO #MONTH(month_no,month_name) VALUES (4,IIF(@P_language = 'en','Apr','4月'))
		INSERT INTO #MONTH(month_no,month_name) VALUES (5,IIF(@P_language = 'en','May','5月'))
		INSERT INTO #MONTH(month_no,month_name) VALUES (6,IIF(@P_language = 'en','Jun','6月'))
		INSERT INTO #MONTH(month_no,month_name) VALUES (7,IIF(@P_language = 'en','Jul','7月'))
		INSERT INTO #MONTH(month_no,month_name) VALUES (8,IIF(@P_language = 'en','Aug','8月'))
		INSERT INTO #MONTH(month_no,month_name) VALUES (9,IIF(@P_language = 'en','Sep','9月'))
		INSERT INTO #MONTH(month_no,month_name) VALUES (10,IIF(@P_language = 'en','Oct','10月'))
		INSERT INTO #MONTH(month_no,month_name) VALUES (11,IIF(@P_language = 'en','Nov','11月'))
		INSERT INTO #MONTH(month_no,month_name) VALUES (12,IIF(@P_language = 'en','Dec','12月'))
		--
		INSERT INTO #MONTH_HEADER
		SELECT
			1	
		,	2	
		,	3	
		,	4	
		,	5	
		,	6	
		,	7	
		,	8	
		,	9	
		,	10	
		,	11	
		,	12	
		--
		UPDATE #MONTH_HEADER
		SET
			month_no1		=	#MONTH_1.month_num
		,	month_no2		=	#MONTH_2.month_num
		,	month_no3		=	#MONTH_3.month_num
		,	month_no4		=	#MONTH_4.month_num
		,	month_no5		=	#MONTH_5.month_num
		,	month_no6		=	#MONTH_6.month_num
		,	month_no7		=	#MONTH_7.month_num
		,	month_no8		=	#MONTH_8.month_num
		,	month_no9		=	#MONTH_9.month_num
		,	month_no10		=	#MONTH_10.month_num
		,	month_no11		=	#MONTH_11.month_num
		,	month_no12		=	#MONTH_12.month_num
		FROM #MONTH_HEADER
		LEFT JOIN #MONTH_MASTER AS #MONTH_1 ON (
			#MONTH_1.id				=	1
		)
		LEFT JOIN #MONTH_MASTER AS #MONTH_2 ON (
			 #MONTH_2.id			=	2
		)
		LEFT JOIN #MONTH_MASTER AS #MONTH_3 ON (
			#MONTH_3.id				=	3
		)
		LEFT JOIN #MONTH_MASTER AS #MONTH_4 ON (
			 #MONTH_4.id			=	4
		)
		LEFT JOIN #MONTH_MASTER AS #MONTH_5 ON (
			#MONTH_5.id				=	5
		)
		LEFT JOIN #MONTH_MASTER AS #MONTH_6 ON (
			#MONTH_6.id				=	6
		)
		LEFT JOIN #MONTH_MASTER AS #MONTH_7 ON (
			#MONTH_7.id				=	7
		)
		LEFT JOIN #MONTH_MASTER AS #MONTH_8 ON (
			#MONTH_8.id				=	8
		)
		LEFT JOIN #MONTH_MASTER AS #MONTH_9 ON (
			#MONTH_9.id				=	9
		)
		LEFT JOIN #MONTH_MASTER AS #MONTH_10 ON (
			#MONTH_10.id			=	10
		)
		LEFT JOIN #MONTH_MASTER AS #MONTH_11 ON (
			#MONTH_11.id			=	11
		)
		LEFT JOIN #MONTH_MASTER AS #MONTH_12 ON (
			#MONTH_12.id			=	12
		)
		--
		INSERT INTO #DATA
		SELECT
			CASE
				WHEN	@w_view_unit_nm = '全社'
				THEN	IIF(@P_language = 'en','Whole Company',@w_view_unit_nm)
				WHEN	@w_view_unit_nm = '部署'
				THEN	IIF(@P_language = 'en','Department',@w_view_unit_nm)
				WHEN	@w_view_unit_nm = '職種'
				THEN	IIF(@P_language = 'en','Job',@w_view_unit_nm)
				WHEN	@w_view_unit_nm = '等級'
				THEN	IIF(@P_language = 'en','Grade',@w_view_unit_nm)
				WHEN	@w_view_unit_nm = '年齢'
				THEN	IIF(@P_language = 'en','Age',@w_view_unit_nm)
			END																AS	status_nm					
		,	#MONTH_1.month_name												AS	month_no1						
		,	#MONTH_2.month_name												AS	month_no2		
		,	#MONTH_3.month_name												AS	month_no3		
		,	#MONTH_4.month_name												AS	month_no4		
		,	#MONTH_5.month_name												AS	month_no5		
		,	#MONTH_6.month_name												AS	month_no6		
		,	#MONTH_7.month_name												AS	month_no7		
		,	#MONTH_8.month_name												AS	month_no8		
		,	#MONTH_9.month_name												AS	month_no9		
		,	#MONTH_10.month_name											AS	month_no10		
		,	#MONTH_11.month_name											AS	month_no11		
		,	#MONTH_12.month_name											AS	month_no12		
		,	IIF(@P_language = 'en','Annual Average','年度平均')				AS	annual_average	
		FROM #MONTH_HEADER
		LEFT JOIN #MONTH AS #MONTH_1 ON (
			#MONTH_HEADER.month_no1		=	#MONTH_1.month_no
		)
		LEFT JOIN #MONTH AS #MONTH_2 ON (
			#MONTH_HEADER.month_no2		=	#MONTH_2.month_no
		)
		LEFT JOIN #MONTH AS #MONTH_3 ON (
			#MONTH_HEADER.month_no3		=	#MONTH_3.month_no
		)
		LEFT JOIN #MONTH AS #MONTH_4 ON (
			#MONTH_HEADER.month_no4		=	#MONTH_4.month_no
		)
		LEFT JOIN #MONTH AS #MONTH_5 ON (
			#MONTH_HEADER.month_no5		=	#MONTH_5.month_no
		)
		LEFT JOIN #MONTH AS #MONTH_6 ON (
			#MONTH_HEADER.month_no6		=	#MONTH_6.month_no
		)
		LEFT JOIN #MONTH AS #MONTH_7 ON (
			#MONTH_HEADER.month_no7		=	#MONTH_7.month_no
		)
		LEFT JOIN #MONTH AS #MONTH_8 ON (
			#MONTH_HEADER.month_no8		=	#MONTH_8.month_no
		)
		LEFT JOIN #MONTH AS #MONTH_9 ON (
			#MONTH_HEADER.month_no9		=	#MONTH_9.month_no
		)
		LEFT JOIN #MONTH AS #MONTH_10 ON (
			#MONTH_HEADER.month_no10	=	#MONTH_10.month_no
		)
		LEFT JOIN #MONTH AS #MONTH_11 ON (
			#MONTH_HEADER.month_no11	=	#MONTH_11.month_no
		)
		LEFT JOIN #MONTH AS #MONTH_12 ON (
			#MONTH_HEADER.month_no12	=	#MONTH_12.month_no
		)
		--
		IF @w_month_str <> ''
		BEGIN
			SET @w_sql = '
				SELECT 
					target_nm	
				,	'+@w_month_str+'
				,	averaged_point_year														AS	averaged_point_year
				FROM
				(
					SELECT 
						#TABLE_RESULT.company_cd											AS	company_cd
					,	#TABLE_RESULT.fiscal_year											AS	fiscal_year
					,	#TABLE_RESULT.target_cd												AS	target_cd
					,	#TABLE_RESULT.target_order											AS	target_order
					,	#TABLE_RESULT.target_nm												AS	target_nm
					,	#TABLE_RESULT.target_typ											AS	target_typ
					,	#TABLE_RESULT.month_num												AS	month_num
					,	FORMAT(#TABLE_RESULT.averaged_point_year,''0.##'')					AS	averaged_point_year
					,	CASE
							WHEN #TOTAL.averaged_point_year_month > 0
							THEN CAST(FORMAT(#TABLE_RESULT.averaged_point,''0.##'') AS nvarchar(10))
							ELSE ''''
						END																	AS	caculate_result
					FROM #TABLE_RESULT
					LEFT OUTER JOIN #TOTAL ON(
						#TABLE_RESULT.month_num		=	#TOTAL.month_num
					)
				) AS P 
				Pivot(MAX(caculate_result) FOR month_num IN ('+@w_month_str+')) AS A
				ORDER BY
					target_order ASC
				,	CASE 
						WHEN target_cd NOT LIKE ''%[^0-9]%'' 
						THEN CAST(target_cd AS bigint)
						ELSE 999
					END
				,	target_cd
			'
			--↓↓↓ edited by viettd 2021/05/14
			IF @w_view_unit <> 0 -- 0.全社
			BEGIN
				--LINE DETAIL:
				INSERT INTO #DATA
				EXEC(@w_sql)
			END
			--↑↑↑ end edited by viettd 2021/05/14
			--LINE TOTAL
			INSERT INTO #DATA
			SELECT
				IIF(@P_language = 'en','Average','平均'	)				AS	status_nm		
			,	CASE
					WHEN #TOTAL_M1.averaged_point_year_month > 0
					THEN FORMAT(#TOTAL_M1.averaged_point_year_month,'0.##')
					ELSE ''
				END														AS	month_no1
			,	CASE
					WHEN #TOTAL_M2.averaged_point_year_month > 0
					THEN FORMAT(#TOTAL_M2.averaged_point_year_month,'0.##')
					ELSE ''
				END														AS	month_no2
			,	CASE
					WHEN #TOTAL_M3.averaged_point_year_month > 0
					THEN FORMAT(#TOTAL_M3.averaged_point_year_month,'0.##')
					ELSE ''
				END														AS	month_no3
			,	CASE
					WHEN #TOTAL_M4.averaged_point_year_month > 0
					THEN FORMAT(#TOTAL_M4.averaged_point_year_month,'0.##')
					ELSE ''
				END														AS	month_no4
			,	CASE
					WHEN #TOTAL_M5.averaged_point_year_month > 0
					THEN FORMAT(#TOTAL_M5.averaged_point_year_month,'0.##')
					ELSE ''
				END														AS	month_no5
			,	CASE
					WHEN #TOTAL_M6.averaged_point_year_month > 0
					THEN FORMAT(#TOTAL_M6.averaged_point_year_month,'0.##')
					ELSE ''
				END														AS	month_no6
			,	CASE
					WHEN #TOTAL_M7.averaged_point_year_month > 0
					THEN FORMAT(#TOTAL_M7.averaged_point_year_month,'0.##')
					ELSE ''
				END														AS	month_no7
			,	CASE
					WHEN #TOTAL_M8.averaged_point_year_month > 0
					THEN FORMAT(#TOTAL_M8.averaged_point_year_month,'0.##')
					ELSE ''
				END														AS	month_no8
			,	CASE
					WHEN #TOTAL_M9.averaged_point_year_month > 0
					THEN FORMAT(#TOTAL_M9.averaged_point_year_month,'0.##')
					ELSE ''
				END														AS	month_no9
			,	CASE
					WHEN #TOTAL_M10.averaged_point_year_month > 0
					THEN FORMAT(#TOTAL_M10.averaged_point_year_month,'0.##')
					ELSE ''
				END														AS	month_no10
			,	CASE
					WHEN #TOTAL_M11.averaged_point_year_month > 0
					THEN FORMAT(#TOTAL_M11.averaged_point_year_month,'0.##')
					ELSE ''
				END														AS	month_no11
			,	CASE
					WHEN #TOTAL_M12.averaged_point_year_month > 0
					THEN FORMAT(#TOTAL_M12.averaged_point_year_month,'0.##')
					ELSE ''
				END														AS	month_no12	
			,	FORMAT(#TOTAL_M1.averaged_point_year,'0.##')			AS	annual_average	
			FROM #MONTH_HEADER
			LEFT JOIN #TOTAL AS #TOTAL_M1 ON (
				#MONTH_HEADER.month_no1			=	#TOTAL_M1.month_num
			)
			LEFT JOIN #TOTAL AS #TOTAL_M2 ON (
				#MONTH_HEADER.month_no2			=	#TOTAL_M2.month_num
			)
			LEFT JOIN #TOTAL AS #TOTAL_M3 ON (
				#MONTH_HEADER.month_no3			=	#TOTAL_M3.month_num
			)
			LEFT JOIN #TOTAL AS #TOTAL_M4 ON (
				#MONTH_HEADER.month_no4			=	#TOTAL_M4.month_num
			)
			LEFT JOIN #TOTAL AS #TOTAL_M5 ON (
				#MONTH_HEADER.month_no5			=	#TOTAL_M5.month_num
			)
			LEFT JOIN #TOTAL AS #TOTAL_M6 ON (
				#MONTH_HEADER.month_no6			=	#TOTAL_M6.month_num
			)
			LEFT JOIN #TOTAL AS #TOTAL_M7 ON (
				#MONTH_HEADER.month_no7			=	#TOTAL_M7.month_num
			)
			LEFT JOIN #TOTAL AS #TOTAL_M8 ON (
				#MONTH_HEADER.month_no8			=	#TOTAL_M8.month_num
			)
			LEFT JOIN #TOTAL AS #TOTAL_M9 ON (
				#MONTH_HEADER.month_no9			=	#TOTAL_M9.month_num
			)
			LEFT JOIN #TOTAL AS #TOTAL_M10 ON (
				#MONTH_HEADER.month_no10		=	#TOTAL_M10.month_num
			)
			LEFT JOIN #TOTAL AS #TOTAL_M11 ON (
				#MONTH_HEADER.month_no11		=	#TOTAL_M11.month_num
			)
			LEFT JOIN #TOTAL AS #TOTAL_M12 ON (
				#MONTH_HEADER.month_no12		=	#TOTAL_M12.month_num
			)
		END
		--[0]
		SELECT
			status_nm			
		,	month_no1			
		,	month_no2			
		,	month_no3			
		,	month_no4			
		,	month_no5			
		,	month_no6			
		,	month_no7			
		,	month_no8			
		,	month_no9			
		,	month_no10			
		,	month_no11			
		,	month_no12			
		,	annual_average	
		,	@P_language AS language
		FROM #DATA
		--[1]
		EXEC [dbo].SPC_1on1_GET_SEARCH_CONDITIONS_INQ1 @P_json , @P_cre_user , @P_company_cd
	END
	IF (@P_mode = 2)
	BEGIN
		--[0]
		SELECT
			#TABLE_CROSS.employee_cd			AS	employee_cd
		,	#TABLE_CROSS.item_no				AS	item_no
		,	#TABLE_CROSS.mark_cd				AS	mark_cd
		,	#TABLE_CROSS.mark_cd_point			AS	mark_cd_point
		FROM #TABLE_CROSS
		-- [1] Mark 
		SELECT 
			ISNULL(M2121.item_no,0)		AS	item_no
		,	ISNULL(M2121.mark_cd,0)		AS	mark_cd
		,	ISNULL(M2121.point,0)		AS	point
		FROM M2121 WITH(NOLOCK)
		WHERE 
			M2121.company_cd	=	@P_company_cd
		AND M2121.mark_typ		=	@w_mark_type
		AND M2121.del_datetime IS NULL
		--[2] Mark min infor
		SELECT 
			TOP 1
			ISNULL(M2121.item_no,0)		AS	item_no
		,	ISNULL(M2121.mark_cd,0)		AS	mark_cd
		,	ISNULL(M2121.point,0)		AS	point
		FROM M2121
		WHERE 
			M2121.company_cd	=	@P_company_cd
		AND M2121.mark_typ		=	@w_mark_type
		AND M2121.del_datetime IS NULL
		ORDER BY
			M2121.item_no DESC
	END

	-- DROP
	DROP TABLE #LIST_COACH
	DROP TABLE #LIST_GRADE
	DROP TABLE #LIST_POSITION
	DROP TABLE #M0070
	DROP TABLE #M0070H
	DROP TABLE #TABLE_ORGANIZATION
	DROP TABLE #F2200_TABLE
	DROP TABLE #MONTH_MASTER
	DROP TABLE #TABLE_RESULT
	DROP TABLE #MONTH_HEADER
	DROP TABLE #DATA
	DROP TABLE #LIST_GROUP_1ON1
	DROP TABLE #TABLE_BIRTHDAY
	DROP TABLE #TABLE_CROSS
	DROP TABLE #TOTAL
	
END
GO
