DROP PROCEDURE [SPC_oQ2030_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_oQ2030_FND1 '{"fiscal_year":"2020","group_cd_1on1":"3","position_cd":"-1","job_cd":"-1","employee_typ":"-1","coach_nm":"","list_organization_step1":[],"list_organization_step2":[],"list_organization_step3":[],"list_organization_step4":[],"list_organization_step5":[],"list_grade":[]}','oanh2_2','2','0';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	oQ2030_分析（1on1実施状況）
--*  
--*  作成日/create date			:	2020/12/18						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2021/06/03
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
--*   					
--*  更新日/update date			:	2022/08/23
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	update ver 1.9	
--****************************************************************************************
CREATE PROCEDURE [SPC_oQ2030_FND1]
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
	,	@w_coach_nm							nvarchar(20)		=	''
	,	@w_employee_typ						smallint			=	0
	,	@w_position_cd						int					=	0
	,	@w_job_cd							smallint			=	0
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
	,	@w_finsihed_averaged_number			money				=	0
	,	@w_finsihed_averaged_percent		money				=	0
	,	@w_unfinsihed_averaged_number		money				=	0
	,	@w_unfinsihed_averaged_percent		money				=	0
	,	@w_month_value_cnt					int					=	0
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
	--1on1グループ
	IF object_id('tempdb..#LIST_GROUP_1ON1', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #LIST_GROUP_1ON1
    END
	--↓↓↓ oq2030
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
	--↓↓↓ oq2030
	CREATE TABLE #F2200_TABLE (
		id								int		identity(1,1)
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	times							smallint
	,	interview_cd					smallint
	,	[start_date]					date
	,	fin_datetime_coach				datetime
	,	[1on1_group_cd]					smallint
	)
	--
	CREATE TABLE #MONTH_MASTER (
		id								int		identity(1,1)
	,	month_num						int
	,	date_from						date
	,	date_to							date
	)
	--
	CREATE TABLE #TABLE_RESULT (
		id								int		identity(1,1)
	,	company_cd						smallint
	,	fiscal_year						smallint
	,	month_num						int
	,	finished_number					int		--	完了
	,	unfinished_number				int		--	未完了
	,	total_number					int		--	合計
	,	finished_percent				money	--	完了 (%)
	,	unfinished_percent				money	--	未完了(%)
	)
	--
	CREATE TABLE #TABLE_CROSS (
		id								int		identity(1,1)
	,	company_cd						smallint
	,	fiscal_year						smallint
	,	employee_cd						nvarchar(10)
	,	year_employee_times_cnt			money		--	employee's times total
	,	finished_number					money		--	完了
	,	unfinished_number				money		--	未完了
	,	finished_percent				money		--	完了 (%)
	)
	--
	CREATE TABLE #LIST_GROUP_1ON1 (
		id								int			identity(1,1)
	,	group_cd_1on1					smallint
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
		@w_1on1_authority_typ		=	ISNULL(S0010.[1on1_authority_typ],0)
	,	@w_1on1_authority_cd		=	ISNULL(S0010.[1on1_authority_cd],0)
	,	@login_position_cd			=	ISNULL(M0070.position_cd,0)
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
	-- GET VALUE FROM JSON
	SET @w_fiscal_year		=	JSON_VALUE(@P_json,'$.fiscal_year')			-- 年度
	SET @w_employee_typ		=	JSON_VALUE(@P_json,'$.employee_typ')		-- 社員区分
	SET @w_position_cd		=	JSON_VALUE(@P_json,'$.position_cd')			-- 役職
	SET @w_coach_nm			=	JSON_VALUE(@P_json,'$.coach_nm')			-- コーチ
	SET @w_job_cd			=	JSON_VALUE(@P_json,'$.job_cd')				-- 職種
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
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @year_month_day,'',@P_company_cd
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

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
	--■■■■■■■■■■■■■ END FILTER DATA ■■■■■■■■■■■■■
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--PROCESS DATA TO oQ2030
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--
	INSERT INTO #MONTH_MASTER
	EXEC [dbo].SPC_1on1_GET_YEAR_MONTHS_FND1 @w_fiscal_year,@P_company_cd
	-- INSERT DATA INTO #F2200_TABLE
	INSERT INTO #F2200_TABLE
	SELECT 
		F2001.company_cd			
	,	F2001.employee_cd			
	,	F2001.times				
	,	F2001.interview_cd		
	,	NULL								AS	[start_date]
	,	F2200.fin_datetime_coach			AS	fin_datetime_coach
	,	ISNULL(F2000.[1on1_group_cd],0)		AS	[1on1_group_cd]
	FROM F2001 WITH(NOLOCK)
	LEFT OUTER JOIN F2000 WITH(NOLOCK) ON (
		F2001.company_cd		=	F2000.company_cd
	AND F2001.fiscal_year		=	F2000.fiscal_year
	AND F2001.employee_cd		=	F2000.employee_cd
	AND F2000.del_datetime IS NULL
	)
	LEFT OUTER JOIN F2200 WITH(NOLOCK) ON (
		F2001.company_cd		=	F2200.company_cd
	AND F2001.fiscal_year		=	F2200.fiscal_year
	AND F2001.employee_cd		=	F2200.employee_cd
	AND F2001.times				=	F2200.times
	AND F2001.interview_cd		=	F2200.interview_cd
	AND F2001.adaption_date		=	F2200.adaption_date
	AND F2200.del_datetime IS NULL
	)
	WHERE 
		F2001.company_cd		=	@P_company_cd
	AND F2001.fiscal_year		=	@w_fiscal_year
	AND F2001.del_datetime IS NULL
	-- UPDATE [start_date] FROM M2620.start_date
	UPDATE #F2200_TABLE SET 
		[start_date] = M2620.[start_date]
	FROM #F2200_TABLE
	INNER JOIN M2620 ON (
		#F2200_TABLE.company_cd			=	M2620.company_cd
	AND @w_fiscal_year					=	M2620.fiscal_year
	AND #F2200_TABLE.[1on1_group_cd]	=	M2620.[1on1_group_cd]
	AND #F2200_TABLE.times				=	M2620.times
	AND M2620.del_datetime IS NULL
	)
	-- FITER コーチ
	IF @w_coach_nm IS NOT NULL AND @w_coach_nm <> ''
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
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--CACULATE
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- SEARCH + CSV
	IF @P_mode IN(0,1)
	BEGIN
		INSERT INTO #TABLE_RESULT
		SELECT 
			@P_company_cd
		,	@w_fiscal_year
		,	#MONTH_MASTER.month_num
		,	0	--	完了
		,	0	--	未完了
		,	0	--	合計
		,	0	--	完了 (%)
		,	0	--	未完了(%)
		FROM #MONTH_MASTER
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
			-- count FINISHED
			UPDATE #TABLE_RESULT SET 
				finished_number	=	F2200_FINISHED.cnt
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					COUNT(#F2200_TABLE.id)			AS	cnt
				FROM #F2200_TABLE
				WHERE 
					#F2200_TABLE.[start_date]	>=	@w_date_from
				AND #F2200_TABLE.[start_date]	<=	@w_date_to
				AND #F2200_TABLE.fin_datetime_coach IS NOT NULL
			) AS F2200_FINISHED ON(
				#TABLE_RESULT.month_num		=	@w_month_num
			)
			WHERE 
				#TABLE_RESULT.id = @w_i
			-- count UNFINISHED
			UPDATE #TABLE_RESULT SET 
				unfinished_number	=	F2200_UNFINISHED.cnt
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					COUNT(#F2200_TABLE.id)			AS	cnt
				FROM #F2200_TABLE
				WHERE 
					#F2200_TABLE.[start_date]	>=	@w_date_from
				AND #F2200_TABLE.[start_date]	<=	@w_date_to
				AND #F2200_TABLE.fin_datetime_coach IS NULL
			) AS F2200_UNFINISHED ON(
				#TABLE_RESULT.month_num		=	@w_month_num
			)
			WHERE 
				#TABLE_RESULT.id = @w_i
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
		-- total + percent
		UPDATE #TABLE_RESULT SET 
			total_number		=	finished_number + unfinished_number
		,	finished_percent	=	CASE 
										WHEN (finished_number + unfinished_number) > 0
										THEN ROUND(((CAST(finished_number AS MONEY) / (finished_number + unfinished_number))*100),1)
										ELSE 0
									END
		,	unfinished_percent	=	CASE 
										WHEN (finished_number + unfinished_number) > 0
										THEN ROUND(((CAST(unfinished_number AS MONEY) / (finished_number + unfinished_number))*100),1)
										ELSE 0
									END
		FROM #TABLE_RESULT
		-- get all month when has value
		SET @w_month_value_cnt = (SELECT COUNT(#TABLE_RESULT.id) FROM #TABLE_RESULT WHERE #TABLE_RESULT.finished_number > 0 OR #TABLE_RESULT.unfinished_number > 0)
		--
		IF @w_month_value_cnt > 0
		BEGIN
			SELECT 
				@w_finsihed_averaged_number		= ROUND((CAST(SUM(#TABLE_RESULT.finished_number)AS MONEY) / @w_month_value_cnt),1)
			,	@w_finsihed_averaged_percent	= ROUND((SUM(#TABLE_RESULT.finished_percent) / @w_month_value_cnt),1)
			,	@w_unfinsihed_averaged_percent	= ROUND((SUM(#TABLE_RESULT.unfinished_percent) / @w_month_value_cnt),1)
			,	@w_unfinsihed_averaged_number	= ROUND((CAST(SUM(#TABLE_RESULT.unfinished_number)AS MONEY) / @w_month_value_cnt),1)
			FROM #TABLE_RESULT
		END
		GOTO COMPLETED
	END
	-- CROSS
	IF @P_mode = 2
	BEGIN
		INSERT INTO #TABLE_CROSS
		SELECT 
			#F2200_TABLE.company_cd
		,	@w_fiscal_year
		,	#F2200_TABLE.employee_cd
		,	0	--	ISNULL(F2001_EMPLOYEE_TIMES.employee_times,0)	--	year_employee_times_cnt
		,	0												--	finished_number
		,	0												--	unfinished_number
		,	0												--	finished_percent
		FROM #F2200_TABLE
		WHERE 
			#F2200_TABLE.fin_datetime_coach IS NOT NULL 
		GROUP BY
			#F2200_TABLE.company_cd
		,	#F2200_TABLE.employee_cd
		-- UPDATE year_employee_times_cnt 
		UPDATE #TABLE_CROSS SET 
			year_employee_times_cnt = ISNULL(F2001_EMPLOYEE_TIMES.employee_times,0)
		FROM #TABLE_CROSS
		INNER JOIN (
			SELECT 
				ISNULL(F2001.company_cd,0)		AS	company_cd
			,	ISNULL(F2001.fiscal_year,0)		AS	fiscal_year
			,	ISNULL(F2001.employee_cd,'')	AS	employee_cd
			,	COUNT(F2001.times)				AS	employee_times
			FROM F2001
			WHERE 
				F2001.company_cd	=	@P_company_cd
			AND F2001.fiscal_year	=	@w_fiscal_year
			AND F2001.del_datetime IS NULL
			GROUP BY
				F2001.company_cd
			,	F2001.fiscal_year
			,	F2001.employee_cd
		) AS F2001_EMPLOYEE_TIMES ON (
			#TABLE_CROSS.company_cd			=	F2001_EMPLOYEE_TIMES.company_cd
		AND #TABLE_CROSS.fiscal_year		=	F2001_EMPLOYEE_TIMES.fiscal_year
		AND #TABLE_CROSS.employee_cd		=	F2001_EMPLOYEE_TIMES.employee_cd
		)
		-- UPDATE FINISHED
		UPDATE #TABLE_CROSS SET 
			finished_number = ISNULL(F2200_FINISHED.finished_number,0)
		FROM #TABLE_CROSS
		INNER JOIN (
			SELECT 
				#F2200_TABLE.company_cd		AS	company_cd
			,	@w_fiscal_year				AS	fiscal_year
			,	#F2200_TABLE.employee_cd	AS	employee_cd
			,	COUNT(#F2200_TABLE.id)		AS	finished_number
			FROM #F2200_TABLE
			WHERE 
				#F2200_TABLE.fin_datetime_coach IS NOT NULL
			GROUP BY
				#F2200_TABLE.company_cd
			,	#F2200_TABLE.employee_cd
		) AS F2200_FINISHED ON (
			#TABLE_CROSS.company_cd		=	F2200_FINISHED.company_cd
		AND #TABLE_CROSS.fiscal_year	=	F2200_FINISHED.fiscal_year
		AND #TABLE_CROSS.employee_cd	=	F2200_FINISHED.employee_cd
		)
		-- UPDATE UNFINISHED
		UPDATE #TABLE_CROSS SET 
			unfinished_number = ISNULL(#TABLE_CROSS.year_employee_times_cnt,0) - ISNULL(#TABLE_CROSS.finished_number,0)
		FROM #TABLE_CROSS
		-- UPDATE finished_percent
		UPDATE #TABLE_CROSS SET 
			finished_percent =	CASE 
									WHEN (finished_number + unfinished_number) > 0
									THEN ROUND(((finished_number / (finished_number + unfinished_number))*100),1)
									ELSE 0
								END
		FROM #TABLE_CROSS
		-- GO TO COMPLETED
		GOTO COMPLETED
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- GET STRING TO EXEC
COMPLETED:
	IF (@P_mode = 0)
	BEGIN
		--[0]
		IF @w_month_str <> ''
		BEGIN
			SET @w_sql = '
				SELECT 
					company_cd
				,	fiscal_year
				,	'+@w_month_str+'
				,	FORMAT(finsihed_averaged_number,''#0.#'')		AS	finsihed_averaged_number
				,	FORMAT(finsihed_averaged_percent,''#0.#'')		AS	finsihed_averaged_percent
				,	FORMAT(unfinsihed_averaged_percent,''#0.#'')		AS	unfinsihed_averaged_percent
				,	FORMAT(unfinsihed_averaged_number,''#0.#'')		AS	unfinsihed_averaged_number
				FROM
				(
					SELECT 
						#TABLE_RESULT.company_cd		AS	company_cd
					,	#TABLE_RESULT.fiscal_year		AS	fiscal_year
					,	#TABLE_RESULT.month_num			AS	month_num
					,	'+CAST(@w_finsihed_averaged_number	AS nvarchar(10))+'		AS	finsihed_averaged_number
					,	'+CAST(@w_finsihed_averaged_percent AS nvarchar(10))+'		AS	finsihed_averaged_percent
					,	'+CAST(@w_unfinsihed_averaged_percent AS nvarchar(10))+'		AS	unfinsihed_averaged_percent
					,	'+CAST(@w_unfinsihed_averaged_number AS nvarchar(10))+'		AS	unfinsihed_averaged_number
					,	''{
							"finished_number":"''+CAST(#TABLE_RESULT.finished_number AS nvarchar(10))+''",
							"unfinished_number":"''+CAST(#TABLE_RESULT.unfinished_number AS nvarchar(10))+''",
							"total_number":"''+CAST(#TABLE_RESULT.total_number AS nvarchar(10))+''",
							"finished_percent":"''+CAST(FORMAT(#TABLE_RESULT.finished_percent,''#0.#'') AS nvarchar(10))+''",
							"unfinished_percent":"''+CAST(FORMAT(#TABLE_RESULT.unfinished_percent,''#0.#'') AS nvarchar(10))+''"
						}''		AS	caculate_result
					FROM #TABLE_RESULT
				) AS P 
				Pivot(MAX(caculate_result) FOR month_num IN ('+@w_month_str+')) AS A
			'
			EXEC(@w_sql)
		END
		ELSE
		BEGIN
			SELECT * FROM #TABLE_RESULT
		END
		--[1]
		SELECT
			#MONTH_MASTER.month_num		AS	month_num
		FROM #MONTH_MASTER
	END
	--OUTPUT CSV
	IF (@P_mode = 1)
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
			IIF(@P_language = 'en','Implementation Status','実施状況')		AS	status_nm		
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
					''完了''	
				,	'+@w_month_str+'
				,	FORMAT(finsihed_averaged_number,''#0.#'')						AS	finsihed_averaged_number
				FROM
				(
					SELECT 
						#TABLE_RESULT.month_num										AS	month_num
					,	'+CAST(@w_finsihed_averaged_number AS nvarchar(10))+'		AS	finsihed_averaged_number
					,	CASE
							WHEN 
								((#TABLE_RESULT.finished_number > 0 OR #TABLE_RESULT.unfinished_number > 0) AND #TABLE_RESULT.finished_number = 0)
							THEN ''0''
							WHEN 
								((#TABLE_RESULT.finished_number > 0 OR #TABLE_RESULT.unfinished_number > 0) AND #TABLE_RESULT.finished_number > 0)
							THEN CAST(FORMAT(finished_number,''#.#'') AS nvarchar(10))
							ELSE ''''
						END															AS	caculate_result
					FROM #TABLE_RESULT
				) AS P 
				Pivot(MAX(caculate_result) FOR month_num IN ('+@w_month_str+')) AS A
			'
			--LINE 1: finished_number
			INSERT INTO #DATA
			EXEC(@w_sql)
			--
			SET @w_sql = '
				SELECT 
					''完了''	
				,	'+@w_month_str+'
				,	CASE
					WHEN finsihed_averaged_percent > 0
						THEN CONCAT(CAST(FORMAT(finsihed_averaged_percent,''#0.#'') AS nvarchar(10)),''%'')
						ELSE FORMAT(finsihed_averaged_percent,''#.#'')						
					END																AS	finsihed_averaged_percent
				FROM
				(
					SELECT 
						#TABLE_RESULT.month_num										AS	month_num
					,	'+CAST(@w_finsihed_averaged_percent AS nvarchar(10))+'		AS	finsihed_averaged_percent
					,	CASE
							WHEN 
								((#TABLE_RESULT.finished_number > 0 OR #TABLE_RESULT.unfinished_number > 0) AND #TABLE_RESULT.finished_number = 0)
							THEN ''0%''
							WHEN 
								((#TABLE_RESULT.finished_number > 0 OR #TABLE_RESULT.unfinished_number > 0) AND #TABLE_RESULT.finished_number > 0)
							THEN CONCAT(CAST(FORMAT(#TABLE_RESULT.finished_percent,''#0.#'') AS nvarchar(10)),''%'')
							ELSE ''''
						END															AS	caculate_result
					FROM #TABLE_RESULT
				) AS P 
				Pivot(MAX(caculate_result) FOR month_num IN ('+@w_month_str+')) AS A
			'
			--LINE 2: finished_percent
			INSERT INTO #DATA
			EXEC(@w_sql)
			--
			SET @w_sql = '
				SELECT 
					''未完了''	
				,	'+@w_month_str+'
				,	FORMAT(unfinsihed_averaged_number,''#0.#'')						AS	unfinsihed_averaged_number
				FROM
				(
					SELECT 
						#TABLE_RESULT.month_num										AS	month_num
					,	'+CAST(@w_unfinsihed_averaged_number AS nvarchar(10))+'		AS	unfinsihed_averaged_number
					,	CASE
							WHEN 
								((#TABLE_RESULT.finished_number > 0 OR #TABLE_RESULT.unfinished_number > 0) AND #TABLE_RESULT.unfinished_number = 0)
							THEN ''0''
							WHEN 
								((#TABLE_RESULT.finished_number > 0 OR #TABLE_RESULT.unfinished_number > 0) AND #TABLE_RESULT.unfinished_number > 0)
							THEN CAST(FORMAT(#TABLE_RESULT.unfinished_number,''#.#'') AS nvarchar(10))
							ELSE ''''
						END															AS	caculate_result
					FROM #TABLE_RESULT
				) AS P 
				Pivot(MAX(caculate_result) FOR month_num IN ('+@w_month_str+')) AS A
			'
			--LINE 3: unfinished_number
			INSERT INTO #DATA
			EXEC(@w_sql)
			--
			SET @w_sql = '
				SELECT 
					''未完了''	
				,	'+@w_month_str+'
				,	CASE
					WHEN unfinsihed_averaged_percent > 0
						THEN CONCAT(CAST(FORMAT(unfinsihed_averaged_percent,''#0.#'') AS nvarchar(10)),''%'')
						ELSE FORMAT(unfinsihed_averaged_percent,''#.#'')						
					END																AS	unfinsihed_averaged_percent
				FROM
				(
					SELECT 
						#TABLE_RESULT.month_num										AS	month_num
					,	'+CAST(@w_unfinsihed_averaged_percent AS nvarchar(10))+'	AS	unfinsihed_averaged_percent
					,	CASE
							WHEN 
								((#TABLE_RESULT.finished_number > 0 OR #TABLE_RESULT.unfinished_number > 0) AND #TABLE_RESULT.unfinished_number = 0)
							THEN ''0%''
							WHEN 
								((#TABLE_RESULT.finished_number > 0 OR #TABLE_RESULT.unfinished_number > 0) AND #TABLE_RESULT.unfinished_number > 0)
							THEN CONCAT(CAST(FORMAT(#TABLE_RESULT.unfinished_percent,''#0.#'') AS nvarchar(10)),''%'')
							ELSE ''''
						END															AS	caculate_result
					FROM #TABLE_RESULT
				) AS P 
				Pivot(MAX(caculate_result) FOR month_num IN ('+@w_month_str+')) AS A
			'
			--LINE 4: unfinished_percent
			INSERT INTO #DATA
			EXEC(@w_sql)
			--
			SET @w_sql = '
				SELECT 
					''合計''	
				,	'+@w_month_str+'
				,	''''
				FROM
				(
					SELECT 
						#TABLE_RESULT.month_num										AS	month_num
					,	CAST(FORMAT(#TABLE_RESULT.total_number,''#.#'') AS nvarchar(10))			AS	caculate_result
					FROM #TABLE_RESULT
				) AS P 
				Pivot(MAX(caculate_result) FOR month_num IN ('+@w_month_str+')) AS A
			'
			--LINE 5: total
			INSERT INTO #DATA
			EXEC(@w_sql)
		END
		--[0]
		SELECT 
			CASE
				WHEN	@P_language = 'en'
				THEN
					CASE
						WHEN	status_nm = '完了'
						THEN	'Completion'
						WHEN	status_nm = '未完了'
						THEN	'Incomplete'
						WHEN	status_nm = '合計'
						THEN	'Total'
						ELSE	status_nm
					END
				ELSE	status_nm
			END			AS	status_nm
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
	-- CROSS
	IF (@P_mode = 2)
	BEGIN
		--[0]
		SELECT
			#TABLE_CROSS.employee_cd		AS	employee_cd
		,	#TABLE_CROSS.finished_percent	AS	finished_percent
		FROM #TABLE_CROSS
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
	DROP TABLE #TABLE_CROSS
END
GO
