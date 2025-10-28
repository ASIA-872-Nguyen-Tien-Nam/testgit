DROP PROCEDURE [SPC_oQ2032_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_oQ2032_FND1 '{"fiscal_year":"2020","position_cd":"-1","job_cd":"-1","coach_nm":"","list_group_1on1":[],"list_grade":[],"submit":"1","target":"0","view_unit":"0"}','oanh2_2','2','0';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	oQ2031_分析（分析（1on1結果・充実度）
--*  
--*  作成日/create date			:	2020/12/18						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2021/05/10
--*　更新者/updater				:	viettd
--*　更新内容/update content		:	when 回答率 then show %
--*   					
--*  更新日/update date			:	2021/06/11
--*　更新者/updater				:	viettd
--*　更新内容/update content		:	when choice 集計単位 = 全社 then only show 平均
--*   					
--*  更新日/update date			:	2022/08/23
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	update ver 1.9 
--****************************************************************************************
CREATE PROCEDURE [SPC_oQ2032_FND1]
	-- Add the parameters for the stored procedure here
	@P_language					nvarchar(10)		=	'jp'		
,	@P_json						nvarchar(max)		=	''	
,	@P_cre_user					nvarchar(50)		=	''	
,	@P_company_cd				smallint			=	0	
,	@P_mode						INT					=	0	--0:SEARCH/1:OUTPUT CSV/2.CROSS
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								datetime			=	SYSDATETIME()
	,	@year_month_day						date				=	NULL
	--
	,	@w_fiscal_year						int					=	0
	,	@w_coach_nm							nvarchar(101)		=	''
	,	@w_position_cd						int					=	0
	,	@w_job_cd							smallint			=	0
	,	@w_view_unit						smallint			=	0	-- 0.全社、1.組織１ 、2.職種、3.等級、4.年齢
	,	@w_view_unit_nm						nvarchar(50)		=	''
	,	@w_target							smallint			=	0	-- 0.点数 1.回答率
	,	@w_submit							smallint			=	0	-- 1.コーチ 2.メンバー
	--
	,	@w_1on1_authority_typ				smallint			=	0
	,	@w_1on1_authority_cd				smallint			=	0
	,	@use_typ							smallint			=	0	
	,	@arrange_order						int					=	0
	,	@login_position_cd					int					=	0
	,	@beginning_date						date				=	NULL
	--
	,	@w_sql								nvarchar(max)		=	''
	,	@w_month_str						nvarchar(100)		=	''
	,	@w_i								int					=	1
	,	@w_date_from						date				=	NULL
	,	@w_date_to							date				=	NULL
	,	@w_month_num						int					=	0
	,	@w_target_total						int					=	0
	,	@w_month_value_cnt					int					=	0
	,	@w_averaged_point_year_total		money				=	0
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
	IF object_id('tempdb..#F2310_TABLE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F2310_TABLE
    END
	--
	IF object_id('tempdb..#F2301_TABLE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F2301_TABLE
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
	--
	CREATE TABLE #MONTH_MASTER (
		id				int		identity(1,1)
	,	month_num		int
	,	date_from		date
	,	date_to			date
	)
	--↓↓↓ oq2032
	CREATE TABLE #F2310_TABLE (
		id								int		identity(1,1)
	,	company_cd						smallint
	,	fiscal_year						smallint
	,	[1on1_group_cd]					smallint
	,	times							smallint
	,	questionnaire_cd				smallint
	,	answer_no						smallint
	,	employee_cd						nvarchar(10)
	,	cre_user						nvarchar(50)
	,	employee_number_surveys_done	smallint
	,	[start_date]					date
	,	points_answer_sum				money		-- sum total
	,	question_cnt					int
	,	points_answer					money		-- avg point_answer
	,	submit							tinyint		-- 1.coach 2.member	1.コーチ 2.メンバー		
	,	fin_datetime_coach				datetime	-- null : coach not approved | not null : coach is approved	
	--
	,	belong_cd1						nvarchar(20)
	,	job_cd							smallint
	,	grade							smallint
	,	year_old						int
	--	匿名
	,	is_anonymity					tinyint		--	0. no | 1.yes
	)
	-- 
	CREATE TABLE #F2301_TABLE (
		id					int		identity(1,1)
	,	company_cd			smallint
	,	fiscal_year			smallint
	,	[1on1_group_cd]		smallint
	,	times				smallint
	,	employee_cd			nvarchar(10)
	,	[start_date]		date
	,	submit				tinyint		-- 1.coach 2.member	1.コーチ 2.メンバー
	,	fin_datetime_coach	datetime	-- null : coach not approved | not null : coach is approved		
	--
	,	belong_cd1			nvarchar(20)
	,	job_cd				smallint
	,	grade				smallint
	,	year_old			int
	--	匿名
	,	is_anonymity		tinyint		--	0. no | 1.yes
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
	--	点数
	,	points_answer_total			money				-- points_answer_total
	,	member_times_total			int					-- member_times_total
	--　回答率
	,	target_member_total			money				-- target_member_total
	,	answer_total				money				-- answer_total
	--
	,	averaged_point				money				-- averaged_point
	,	averaged_point_year			money				-- 年度平均
	,	target_order				INT					-- order by
	--	匿名
	,	is_anonymity				tinyint				--	0. no | 1.yes
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
	CREATE TABLE #TABLE_CROSS (
		id					int		identity(1,1)
	,	company_cd			smallint
	,	fiscal_year			smallint
	,	employee_cd			nvarchar(10)
	--
	,	questionnaire_cnt	int
	,	points_answer_avg	money		--  points_answer_avg
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
	-- GET VALUE FROM JSON
	SET @w_fiscal_year		=	JSON_VALUE(@P_json,'$.fiscal_year')	-- 年度
	SET @w_submit			=	JSON_VALUE(@P_json,'$.submit')				-- 回答者
	SET @w_target			=	JSON_VALUE(@P_json,'$.target')				-- 対象
	SET @w_view_unit		=	JSON_VALUE(@P_json,'$.view_unit')			-- 集計単位
	SET @w_position_cd		=	JSON_VALUE(@P_json,'$.position_cd')			-- 役職
	SET @w_coach_nm			=	JSON_VALUE(@P_json,'$.coach_nm')			-- コーチ
	SET @w_job_cd			=	JSON_VALUE(@P_json,'$.job_cd')				-- 職種
	--
	SELECT 
		--@beginning_date = M0100.beginning_date 
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
	-- INSERT DATA INTO #LIST_COACH
	IF @w_coach_nm IS NOT NULL AND @w_coach_nm <> ''
	BEGIN
		-- IF 回答者 = 1.コーチ
		IF @w_submit = 1
		BEGIN
			INSERT INTO #LIST_COACH
			SELECT 
				#M0070H.company_cd				AS	company_cd
			,	@w_fiscal_year					AS	fiscal_year
			,	#M0070H.employee_cd				AS	employee_cd
			,	NULL							AS	times
			,	#M0070H.employee_cd				AS	coach_cd
			FROM #M0070H WITH(NOLOCK)
			WHERE
				#M0070H.employee_nm LIKE '%'+@w_coach_nm+'%'
		END
		-- IF 回答者 = 2.メンバー
		IF @w_submit = 2
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
		@w_job_cd IS NULL 
	OR	@w_job_cd IS NOT NULL AND @w_job_cd <= 0
	OR	@w_job_cd IS NOT NULL AND @w_job_cd > 0 AND #M0070H.job_cd = @w_job_cd
	)
	--■■■■■■■■■■■■■ FILTER DATA ■■■■■■■■■■■■■
	-- FILTER 役職
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
	INSERT INTO #MONTH_MASTER
	EXEC [dbo].SPC_1on1_GET_YEAR_MONTHS_FND1 @w_fiscal_year,@P_company_cd
	--#F2310_TABLE
	INSERT INTO #F2310_TABLE
	SELECT 
		F2310.company_cd
	,	F2310.fiscal_year
	,	F2310.[1on1_group_cd]			
	,	F2310.times				
	,	F2310.questionnaire_cd
	,	F2310.answer_no						AS	answer_no
	,	F2310.employee_cd					AS	employee_cd	-- F2310.employee_cd
	,	F2310.cre_user						AS	cre_user
	,	0									AS	employee_number_surveys_done	-- number times of employee (number of surveys done): 
	,	NULL								AS	[start_date]		
	,	0									AS	points_answer_sum	-- sum points of answer
	,	0									AS	question_cnt		-- number of question of questionnaire
	,	0									AS	points_answer		-- avg points of answer employee
	,	ISNULL(M2400.submit,0)				AS	submit
	,	NULL								AS	fin_datetime_coach
	--
	,	NULL --#M0070.belong_cd_1
	,	NULL --#M0070.job_cd
	,	NULL --#M0070.grade
	,	NULL	AS	birth_date
	,	CASE 
			WHEN F2310.employee_cd IS NULL
			THEN 1
			ELSE 0
		END									AS	is_anonymity
	FROM F2310 WITH(NOLOCK)
	INNER JOIN M2400 ON (
		F2310.company_cd		=	M2400.company_cd
	AND F2310.questionnaire_cd	=	M2400.questionnaire_cd
	)
	LEFT OUTER JOIN #M0070 ON (
		F2310.company_cd		=	#M0070.company_cd
	AND F2310.fiscal_year		=	@w_fiscal_year
	AND F2310.employee_cd		=	#M0070.employee_cd
	)
	WHERE
		F2310.company_cd		=	@P_company_cd
	AND F2310.fiscal_year		=	@w_fiscal_year
	AND F2310.del_datetime IS NULL
	AND (
		@P_mode = 2 -- CROSS
	OR	(
		@P_mode <> 2 AND M2400.submit			=	@w_submit	-- 1.COACH 2.MEMBER
		)
	)
	GROUP BY
		F2310.company_cd
	,	F2310.fiscal_year
	,	F2310.[1on1_group_cd]	
	,	F2310.times				
	,	F2310.questionnaire_cd
	,	F2310.answer_no
	,	F2310.employee_cd
	,	F2310.cre_user
	,	M2400.submit
	,	#M0070.belong_cd_1
	,	#M0070.job_cd
	,	#M0070.grade
	,	#M0070.birth_date
	-- UPDATE employee_cd FROM F2301
	UPDATE #F2310_TABLE SET 
		employee_cd = ISNULL(F2301.employee_cd,'')
	FROM #F2310_TABLE
	INNER JOIN F2301 ON(
		#F2310_TABLE.company_cd			=	F2301.company_cd
	AND #F2310_TABLE.fiscal_year		=	F2301.fiscal_year
	AND #F2310_TABLE.[1on1_group_cd]	=	F2301.[1on1_group_cd]
	AND #F2310_TABLE.times				=	F2301.times
	AND #F2310_TABLE.submit				=	F2301.submit
	AND #F2310_TABLE.cre_user			=	F2301.send_user
	)
	WHERE 
		#F2310_TABLE.is_anonymity = 1 -- 匿名
	-- DELETE ALL EMPLOYEE NOT EIXTS IN TABLE #M0070
	DELETE D FROM #F2310_TABLE AS D
	LEFT OUTER JOIN #M0070 ON (
		D.company_cd		=	#M0070.company_cd
	AND D.fiscal_year		=	@w_fiscal_year
	AND D.employee_cd		=	#M0070.employee_cd
	)
	WHERE 
		#M0070.employee_cd IS NULL
	AND D.is_anonymity = 0	-- NOT 匿名
	-- UPDATE EMPLOYEE MASTER FROM #M0070
	UPDATE #F2310_TABLE SET 
		belong_cd1	=	ISNULL(#M0070.belong_cd_1,'')
	,	job_cd		=	ISNULL(#M0070.job_cd,'')
	,	grade		=	ISNULL(#M0070.grade,'')
	,	year_old	=	[dbo].FNC_GET_BIRTHDAY_AGE (#M0070.birth_date,NULL)
	FROM #F2310_TABLE
	INNER JOIN #M0070 ON (
		#F2310_TABLE.company_cd			=	#M0070.company_cd
	AND #F2310_TABLE.fiscal_year		=	@w_fiscal_year
	AND #F2310_TABLE.employee_cd		=	#M0070.employee_cd
	)
	-- UPDATE employee_number_surveys_done
	UPDATE #F2310_TABLE SET 
		employee_number_surveys_done = ISNULL(F2310_EMPLOYEE_SURVEYS_DONE.times,0)
	FROM #F2310_TABLE
	INNER JOIN (
		SELECT 
			#F2310_TABLE.company_cd		AS	company_cd
		,	#F2310_TABLE.fiscal_year	AS	fiscal_year
		,	#F2310_TABLE.employee_cd	AS	employee_cd
		,	COUNT(#F2310_TABLE.times)	AS	times
		FROM #F2310_TABLE
		GROUP BY
			#F2310_TABLE.company_cd		
		,	#F2310_TABLE.fiscal_year		
		,	#F2310_TABLE.employee_cd		
	) AS F2310_EMPLOYEE_SURVEYS_DONE ON (
		#F2310_TABLE.company_cd		=	F2310_EMPLOYEE_SURVEYS_DONE.company_cd
	AND #F2310_TABLE.fiscal_year	=	F2310_EMPLOYEE_SURVEYS_DONE.fiscal_year
	AND #F2310_TABLE.employee_cd	=	F2310_EMPLOYEE_SURVEYS_DONE.employee_cd
	)
	-- UPDATE points_answer_sum + question_cnt FROM F2311
	UPDATE #F2310_TABLE SET 
		question_cnt		= ISNULL(F2311_QUETSION.question_cnt,0)
	,	points_answer_sum	= ISNULL(F2311_QUETSION.points_answer_sum,0)
	FROM #F2310_TABLE
	INNER JOIN (
		SELECT 
			F2311.company_cd					AS	company_cd
		,	F2311.fiscal_year					AS	fiscal_year
		,	F2311.[1on1_group_cd]				AS	[1on1_group_cd]
		,	F2311.times							AS	times
		,	F2311.questionnaire_cd				AS	questionnaire_cd
		,	F2311.answer_no						AS	answer_no
		,	COUNT(F2311.questionnaire_gyono)	AS	question_cnt
		,	SUM(F2311.points_answer)			AS	points_answer_sum
		FROM F2311
		INNER JOIN M2401 ON (
			F2311.company_cd			=	M2401.company_cd
		AND F2311.questionnaire_cd		=	M2401.questionnaire_cd
		AND F2311.questionnaire_gyono	=	M2401.questionnaire_gyono
		AND M2401.del_datetime IS NULL
		)
		WHERE
			F2311.company_cd		=	@P_company_cd
		AND F2311.fiscal_year		=	@w_fiscal_year
		AND F2311.del_datetime IS NULL
		AND M2401.points_use_typ	=	1 -- 点数 (利用する)の対象
		GROUP BY
			F2311.company_cd		
		,	F2311.fiscal_year		
		,	F2311.[1on1_group_cd]	
		,	F2311.times				
		,	F2311.questionnaire_cd	
		,	F2311.answer_no
	) AS F2311_QUETSION ON (
		#F2310_TABLE.company_cd			=	F2311_QUETSION.company_cd
	AND #F2310_TABLE.fiscal_year		=	F2311_QUETSION.fiscal_year
	AND #F2310_TABLE.[1on1_group_cd]	=	F2311_QUETSION.[1on1_group_cd]
	AND #F2310_TABLE.times				=	F2311_QUETSION.times
	AND #F2310_TABLE.questionnaire_cd	=	F2311_QUETSION.questionnaire_cd
	AND #F2310_TABLE.answer_no			=	F2311_QUETSION.answer_no
	)
	-- get avg points_answer
	UPDATE #F2310_TABLE SET 
		points_answer = CASE 
							WHEN ISNULL(#F2310_TABLE.question_cnt,0) <> 0
							THEN ROUND((ISNULL(#F2310_TABLE.points_answer_sum,0) / #F2310_TABLE.question_cnt),2)
							ELSE 0
						END	  
	FROM #F2310_TABLE
	-- UPDATE start_date
	UPDATE #F2310_TABLE SET 
		[start_date] = M2620.[start_date]
	FROM #F2310_TABLE
	INNER JOIN M2620 ON(
		#F2310_TABLE.company_cd			=	M2620.company_cd
	AND #F2310_TABLE.fiscal_year		=	M2620.fiscal_year
	AND #F2310_TABLE.[1on1_group_cd]	=	M2620.[1on1_group_cd]
	AND #F2310_TABLE.times				=	M2620.times
	AND M2620.del_datetime IS NULL
	)
	--------------------------------------
	-- INSERT DATA INTO #F2301_TABLE
	--------------------------------------
	INSERT INTO #F2301_TABLE
	SELECT 
		F2301.company_cd
	,	F2301.fiscal_year
	,	F2301.[1on1_group_cd]
	,	F2301.times
	,	F2301.employee_cd
	,	NULL					-- [start_date]
	,	F2300.submit
	,	NULL				AS	fin_datetime_coach
	--
	,	#M0070.belong_cd_1
	,	#M0070.job_cd
	,	#M0070.grade
	,	[dbo].FNC_GET_BIRTHDAY_AGE (#M0070.birth_date,NULL)		AS	birth_date
	,	0					AS	is_anonymity
	FROM F2301 WITH(NOLOCK)
	INNER JOIN #M0070 ON (
		F2301.company_cd		=	#M0070.company_cd
	AND F2301.employee_cd		=	#M0070.employee_cd
	)
	INNER JOIN F2300 WITH(NOLOCK) ON (
		F2301.company_cd		=	F2300.company_cd
	AND F2301.fiscal_year		=	F2300.fiscal_year
	AND F2301.[1on1_group_cd]	=	F2300.[1on1_group_cd]
	AND F2301.times				=	F2300.times
	AND F2301.submit			=	F2300.submit
	AND F2300.del_datetime IS NULL
	)
	WHERE 
		F2301.company_cd		=	@P_company_cd
	AND F2301.fiscal_year		=	@w_fiscal_year
	AND F2301.del_datetime IS NULL
	AND (
		@P_mode = 2 -- CROSS
	OR	(
		@P_mode <> 2 AND F2301.submit	=	@w_submit
		)
	)
	-- UPDATE start_date
	UPDATE #F2301_TABLE SET 
		[start_date] = M2620.[start_date]
	FROM #F2301_TABLE
	INNER JOIN M2620 ON(
		#F2301_TABLE.company_cd			=	M2620.company_cd
	AND #F2301_TABLE.fiscal_year		=	M2620.fiscal_year
	AND #F2301_TABLE.[1on1_group_cd]	=	M2620.[1on1_group_cd]
	AND #F2301_TABLE.times				=	M2620.times
	AND M2620.del_datetime IS NULL
	)
	-- UPDATE #F2301_TABLE.is_anonymity FROM #F2310_TABLE
	UPDATE #F2301_TABLE SET 
		is_anonymity = 1
	FROM #F2301_TABLE
	INNER JOIN #F2310_TABLE ON (
		#F2301_TABLE.company_cd			=	#F2310_TABLE.company_cd
	AND #F2301_TABLE.fiscal_year		=	#F2310_TABLE.fiscal_year
	AND #F2301_TABLE.[1on1_group_cd]	=	#F2310_TABLE.[1on1_group_cd]
	AND #F2301_TABLE.times				=	#F2310_TABLE.times
	AND #F2301_TABLE.employee_cd		=	#F2310_TABLE.employee_cd
	AND #F2301_TABLE.submit				=	#F2310_TABLE.submit
	)
	WHERE 
		#F2310_TABLE.is_anonymity = 1
	-- UPDATE #F2310_TABLE.year_old
	UPDATE #F2310_TABLE SET 
		year_old =	CASE 
						WHEN #F2310_TABLE.year_old <= 20
						THEN 20
						WHEN #F2310_TABLE.year_old <= 30
						THEN 30
						WHEN #F2310_TABLE.year_old <= 40
						THEN 40
						WHEN #F2310_TABLE.year_old <= 50
						THEN 50
						WHEN #F2310_TABLE.year_old <= 60
						THEN 60
						ELSE 61
					END
	FROM #F2310_TABLE
	-- UPDATE #F2301_TABLE.year_old
	UPDATE #F2301_TABLE SET 
		year_old =	CASE 
						WHEN #F2301_TABLE.year_old <= 20
						THEN 20
						WHEN #F2301_TABLE.year_old <= 30
						THEN 30
						WHEN #F2301_TABLE.year_old <= 40
						THEN 40
						WHEN #F2301_TABLE.year_old <= 50
						THEN 50
						WHEN #F2301_TABLE.year_old <= 60
						THEN 60
						ELSE 61
					END
	FROM #F2301_TABLE
	-- FITER コーチ
	IF  @w_coach_nm IS NOT NULL AND @w_coach_nm <> ''
	BEGIN
		-- IF 回答者 = 1.コーチ
		IF @w_submit = 1
		BEGIN
			-- delete #F2310_TABLE
			DELETE D FROM #F2310_TABLE AS D
			LEFT OUTER JOIN #LIST_COACH AS S ON (
				D.company_cd		=	@P_company_cd
			AND D.employee_cd		=	S.employee_cd
			)
			WHERE
				S.employee_cd IS NULL
			AND D.is_anonymity = 0
			-- delete #F2301_TABLE
			DELETE D FROM #F2301_TABLE AS D
			LEFT OUTER JOIN #LIST_COACH AS S ON (
				D.company_cd		=	@P_company_cd
			AND D.employee_cd		=	S.employee_cd
			)
			WHERE
				S.employee_cd IS NULL
			AND D.is_anonymity = 0
		END
		-- IF 回答者 = 2.メンバー
		IF @w_submit = 2
		BEGIN
			-- delete #F2310_TABLE
			DELETE D FROM #F2310_TABLE AS D
			LEFT OUTER JOIN #LIST_COACH AS S ON (
				D.company_cd		=	@P_company_cd
			AND D.employee_cd		=	S.employee_cd
			AND D.times				=	S.times
			)
			WHERE
				S.employee_cd IS NULL
			AND D.is_anonymity = 0
			-- delete #F2301_TABLE
			DELETE D FROM #F2301_TABLE AS D
			LEFT OUTER JOIN #LIST_COACH AS S ON (
				D.company_cd		=	@P_company_cd
			AND D.employee_cd		=	S.employee_cd
			AND D.times				=	S.times
			)
			WHERE
				S.employee_cd IS NULL
			AND D.is_anonymity = 0
		END
	END
	-- FITER グループ
	IF EXISTS (SELECT 1 FROM #LIST_GROUP_1ON1)
	BEGIN
		DELETE D FROM #F2310_TABLE AS D
		LEFT OUTER JOIN #LIST_GROUP_1ON1 AS S ON (
			D.company_cd		=	@P_company_cd
		AND D.[1on1_group_cd]	=	S.group_cd_1on1
		)
		WHERE
			S.group_cd_1on1 IS NULL
		AND D.is_anonymity = 0
		--
		DELETE D FROM #F2301_TABLE AS D
		LEFT OUTER JOIN #LIST_GROUP_1ON1 AS S ON (
			D.company_cd		=	@P_company_cd
		AND D.[1on1_group_cd]	=	S.group_cd_1on1
		)
		WHERE
			S.group_cd_1on1 IS NULL
		AND D.is_anonymity = 0
	END
	-- IF CROSS
	IF @P_mode = 2
	BEGIN
		-- UPDATE #F2301_TABLE.fin_datetime_coach FROM F2200
		UPDATE #F2301_TABLE SET 
			fin_datetime_coach	=	F2200_MIN.fin_datetime_coach
		FROM #F2301_TABLE
		INNER JOIN
		(
			SELECT 
				F2200.company_cd			AS	company_cd
			,	F2200.fiscal_year			AS	fiscal_year
			,	F2200.employee_cd			AS	employee_cd
			,	F2200.times					AS	times
			,	MIN(F2200.interview_cd)		AS	interview_cd
			,	MIN(F2200.adaption_date)	AS	adaption_date
			,	F2200.fin_datetime_coach	AS	fin_datetime_coach
			FROM F2200
			WHERE 
				F2200.company_cd	=	@P_company_cd
			AND F2200.fiscal_year	=	@w_fiscal_year
			AND F2200.del_datetime IS NULL
			GROUP BY
				F2200.company_cd	
			,	F2200.fiscal_year	
			,	F2200.employee_cd	
			,	F2200.times
			,	F2200.fin_datetime_coach
		) AS F2200_MIN ON (
			#F2301_TABLE.company_cd		=	F2200_MIN.company_cd
		AND #F2301_TABLE.fiscal_year	=	F2200_MIN.fiscal_year
		AND #F2301_TABLE.employee_cd	=	F2200_MIN.employee_cd
		AND #F2301_TABLE.times			=	F2200_MIN.times
		)
		WHERE 
			#F2301_TABLE.submit	=	2	-- MEMBER
		-- UPDATE #F2310_TABLE.fin_datetime_coach FROM F2200
		UPDATE #F2310_TABLE SET 
			fin_datetime_coach	=	F2200_MIN.fin_datetime_coach
		FROM #F2310_TABLE
		INNER JOIN
		(
			SELECT 
				F2200.company_cd			AS	company_cd
			,	F2200.fiscal_year			AS	fiscal_year
			,	F2200.employee_cd			AS	employee_cd
			,	F2200.times					AS	times
			,	MIN(F2200.interview_cd)		AS	interview_cd
			,	MIN(F2200.adaption_date)	AS	adaption_date
			,	F2200.fin_datetime_coach	AS	fin_datetime_coach
			FROM F2200
			WHERE 
				F2200.company_cd	=	@P_company_cd
			AND F2200.fiscal_year	=	@w_fiscal_year
			AND F2200.del_datetime IS NULL
			GROUP BY
				F2200.company_cd	
			,	F2200.fiscal_year	
			,	F2200.employee_cd	
			,	F2200.times
			,	F2200.fin_datetime_coach
		) AS F2200_MIN ON (
			#F2310_TABLE.company_cd		=	F2200_MIN.company_cd
		AND #F2310_TABLE.fiscal_year	=	F2200_MIN.fiscal_year
		AND #F2310_TABLE.employee_cd	=	F2200_MIN.employee_cd
		AND #F2310_TABLE.times			=	F2200_MIN.times
		)
		WHERE 
			#F2310_TABLE.submit	=	2	-- MEMBER
		-- GET #TABLE_CROSS FROM F2000
		INSERT INTO #TABLE_CROSS
		SELECT 
			#F2301_TABLE.company_cd		AS	company_cd
		,	#F2301_TABLE.fiscal_year	AS	fiscal_year	
		,	#F2301_TABLE.employee_cd	AS	employee_cd
		,	0							AS	questionnaire_cnt
		,	0							AS	points_answer_avg
		FROM #F2301_TABLE
		WHERE 
			#F2301_TABLE.submit	=	2 -- MEMBER
		AND #F2301_TABLE.fin_datetime_coach IS NOT NULL
		GROUP BY
			#F2301_TABLE.company_cd
		,	#F2301_TABLE.fiscal_year
		,	#F2301_TABLE.employee_cd
		-- update questionnaire_cnt from #F2301_TABLE
		UPDATE #TABLE_CROSS SET 
			questionnaire_cnt = ISNULL(F2301_QUESTIONNAIRE_CNT.questionnaire_cnt,0)
		FROM #TABLE_CROSS
		INNER JOIN (
			SELECT 
				#F2301_TABLE.company_cd			AS	company_cd
			,	#F2301_TABLE.fiscal_year		AS	fiscal_year
			,	#F2301_TABLE.employee_cd		AS	employee_cd
			,	COUNT(#F2301_TABLE.times)		AS	questionnaire_cnt
			FROM #F2301_TABLE
			WHERE 
				#F2301_TABLE.submit	=	2	-- MEMBER
			AND #F2301_TABLE.fin_datetime_coach IS NOT NULL
			GROUP BY
				#F2301_TABLE.company_cd	
			,	#F2301_TABLE.fiscal_year
			,	#F2301_TABLE.employee_cd
		) AS F2301_QUESTIONNAIRE_CNT ON (
			#TABLE_CROSS.company_cd		=	F2301_QUESTIONNAIRE_CNT.company_cd
		AND #TABLE_CROSS.fiscal_year	=	F2301_QUESTIONNAIRE_CNT.fiscal_year
		AND #TABLE_CROSS.employee_cd	=	F2301_QUESTIONNAIRE_CNT.employee_cd
		)
		-- UPDATE POINT_ANSWER FROM #F2310_TABLE
		UPDATE #TABLE_CROSS SET 
			points_answer_avg = CASE 
									WHEN ISNULL(#TABLE_CROSS.questionnaire_cnt,0) <> 0
									THEN ROUND((ISNULL(F2310_TOTAL.points_answer_total,0) /  #TABLE_CROSS.questionnaire_cnt),2)
									ELSE 0
								END
		FROM #TABLE_CROSS
		INNER JOIN (
			SELECT 
				#F2310_TABLE.company_cd				AS	company_cd
			,	#F2310_TABLE.fiscal_year			AS	fiscal_year
			,	#F2310_TABLE.employee_cd			AS	employee_cd
			,	SUM(#F2310_TABLE.points_answer)		AS	points_answer_total
			FROM #F2310_TABLE
			WHERE 
				#F2310_TABLE.submit	=	2 --MEMBER
			AND #F2310_TABLE.fin_datetime_coach IS NOT NULL
			GROUP BY
				#F2310_TABLE.company_cd	
			,	#F2310_TABLE.fiscal_year
			,	#F2310_TABLE.employee_cd
		) AS F2310_TOTAL ON (
			#TABLE_CROSS.company_cd			=	F2310_TOTAL.company_cd
		AND #TABLE_CROSS.fiscal_year		=	F2310_TOTAL.fiscal_year
		AND #TABLE_CROSS.employee_cd		=	F2310_TOTAL.employee_cd
		)
		--
		GOTO COMPLETED
	END
	-- INSERT INTO #TABLE_RESULT
	-- -1.匿名回答
	IF EXISTS (SELECT 1 FROM #F2310_TABLE WHERE is_anonymity = 1)
	BEGIN
		INSERT INTO #TABLE_RESULT
		SELECT 
			@P_company_cd
		,	@w_fiscal_year
		,	#MONTH_MASTER.month_num
		,	-1									AS	target_cd
		,	'匿名回答'							AS	target_nm
		,	-1	-- -1.匿名
		,	0	-- points_answer_total
		,	0	-- member_times_total
		,	0	-- target_member_total	
		,	0	-- answer_total		
		,	0	-- averaged_point		
		,	0	-- averaged_point_year	
		,	-1	-- target_order
		,	1	-- is_anonymity
		FROM #MONTH_MASTER
		LEFT OUTER JOIN M0001 WITH(NOLOCK) ON (
			@P_company_cd	=	M0001.company_cd
		)
	END
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
		,	0	-- points_answer_total
		,	0	-- member_times_total
		,	0	-- target_member_total	
		,	0	-- answer_total		
		,	0	-- averaged_point		
		,	0	-- averaged_point_year	
		,	0	-- target_order
		,	0	-- is_anonymity
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
		,	0	-- points_answer_total
		,	0	-- member_times_total
		,	0	-- target_member_total	
		,	0	-- answer_total
		,	0	-- averaged_point		
		,	0	-- averaged_point_year	
		,	ISNULL(M0020.arrange_order,0)				AS	arrange_order--target_order
		,	0	-- is_anonymity
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
		,	0	-- points_answer_total
		,	0	-- member_times_total
		,	0	-- target_member_total	
		,	0	-- answer_total
		,	0	-- averaged_point		
		,	0	-- averaged_point_year		
		,	ISNULL(M0030.arrange_order,0)				AS	arrange_order--target_order
		,	0	-- is_anonymity
		FROM #MONTH_MASTER
		LEFT OUTER JOIN M0030 WITH(NOLOCK) ON (
			@P_company_cd	=	M0030.company_cd
		AND M0030.del_datetime IS NULL
		)
		WHERE 
			M0030.company_cd		=	@P_company_cd
		AND M0030.del_datetime IS NULL
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
		,	0	-- points_answer_total
		,	0	-- member_times_total
		,	0	-- target_member_total	
		,	0	-- answer_total
		,	0	-- averaged_point		
		,	0	-- averaged_point_year	
		,	ISNULL(M0050.arrange_order,0)				AS	arrange_order--target_order
		,	0	-- is_anonymity
		FROM #MONTH_MASTER
		LEFT OUTER JOIN M0050 WITH(NOLOCK) ON (
			@P_company_cd	=	M0050.company_cd
		AND M0050.del_datetime IS NULL
		)
		WHERE 
			M0050.company_cd		=	@P_company_cd
		AND M0050.del_datetime IS NULL
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
		,	0	-- points_answer_total
		,	0	-- member_times_total
		,	0	-- target_member_total	
		,	0	-- answer_total
		,	0	-- averaged_point		
		,	0	-- averaged_point_year	
		,	0	-- target_order
		,	0	-- is_anonymity
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
	--■■■■■■■■■■■■■■■■■■■ ↓↓↓LOOP 12 MONTH↓↓↓　■■■■■■■■■■■■■■■■■■■
	WHILE @w_i <= 12
	BEGIN
		SELECT 
			@w_date_from	=	#MONTH_MASTER.date_from
		,	@w_date_to		=	#MONTH_MASTER.date_to
		,	@w_month_num	=	#MONTH_MASTER.month_num
		FROM #MONTH_MASTER
		WHERE 
			#MONTH_MASTER.id = @w_i
		-- -1.匿名
		IF EXISTS (SELECT 1 FROM #F2310_TABLE WHERE is_anonymity = 1)
		BEGIN
			IF @w_target = 1 -- 回答率
			BEGIN
				-- UPDATE target_member_total
				UPDATE #TABLE_RESULT SET 
					target_member_total = ISNULL(F2301_TOTAL.target_member_total,0)
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						COUNT(#F2301_TABLE.times)		AS	target_member_total			-- total number times of all employee in this target
					,	-1								AS	target_cd
					FROM #F2301_TABLE
					WHERE
						#F2301_TABLE.[start_date]	>=	@w_date_from
					AND #F2301_TABLE.[start_date]	<=	@w_date_to
					AND #F2301_TABLE.is_anonymity = 1 -- 匿名
				) AS F2301_TOTAL ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2301_TOTAL.target_cd
				)
				WHERE 
					#TABLE_RESULT.is_anonymity = 1
				-- UPDATE answer_total
				UPDATE #TABLE_RESULT SET 
					answer_total	=	F2310_TOTAL.answer_total
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						COUNT(#F2310_TABLE.answer_no)			AS	answer_total		-- total number answer of all employee in this target
					,	-1										AS	target_cd
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity = 1 -- 匿名
				) AS F2310_TOTAL ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2310_TOTAL.target_cd
				)
				WHERE 
					#TABLE_RESULT.is_anonymity = 1
			END
			ELSE -- 点数
			BEGIN
				-- UPDATE points_answer_total
				UPDATE #TABLE_RESULT SET 
					points_answer_total	=	F2310_TOTAL.points_answer_sum				-- total number answer points of all employee in this target
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						SUM(#F2310_TABLE.points_answer)			AS	points_answer_sum
					,	-1										AS	target_cd
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity	=	1
				) AS F2310_TOTAL ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2310_TOTAL.target_cd
				)
				WHERE 
					#TABLE_RESULT.is_anonymity = 1
				-- UPDATE member_times_total
				UPDATE #TABLE_RESULT SET 
					member_times_total	=	ISNULL(F2310_TOTAL.employee_number_surveys_done,0)		-- total number answer points of all employee in this target
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						-1									AS	target_cd
					,	COUNT(#F2310_TABLE.employee_number_surveys_done)		AS	employee_number_surveys_done
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity	=	1
				) AS F2310_TOTAL ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2310_TOTAL.target_cd
				)
				WHERE 
					#TABLE_RESULT.is_anonymity = 1
			END
		END
		-- 0.全社
		IF @w_view_unit = 0
		BEGIN
			IF @w_target = 1 -- 回答率
			BEGIN
				-- UPDATE target_member_total
				UPDATE #TABLE_RESULT SET 
					target_member_total = ISNULL(F2301_TOTAL.target_member_total,0)
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						COUNT(#F2301_TABLE.times)		AS	target_member_total			-- total number times of all employee in this target
					,	#F2301_TABLE.company_cd			AS	company_cd
					FROM #F2301_TABLE
					WHERE
						#F2301_TABLE.[start_date]	>=	@w_date_from
					AND #F2301_TABLE.[start_date]	<=	@w_date_to
					AND #F2301_TABLE.is_anonymity	= 0
					GROUP BY
						#F2301_TABLE.company_cd
				) AS F2301_TOTAL ON(
					#TABLE_RESULT.target_cd		=	F2301_TOTAL.company_cd
				AND	#TABLE_RESULT.month_num		=	@w_month_num
				)
				WHERE #TABLE_RESULT.is_anonymity = 0
				-- UPDATE answer_total
				UPDATE #TABLE_RESULT SET 
					answer_total	=	F2310_TOTAL.answer_total
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						COUNT(#F2310_TABLE.answer_no)			AS	answer_total		-- total number answer of all employee in this target
					,	#F2310_TABLE.company_cd					AS	company_cd
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity	=	0
					GROUP BY
						#F2310_TABLE.company_cd
				) AS F2310_TOTAL ON(
					#TABLE_RESULT.target_cd		=	F2310_TOTAL.company_cd
				AND	#TABLE_RESULT.month_num		=	@w_month_num
				)
				WHERE #TABLE_RESULT.is_anonymity = 0
			END
			ELSE	-- 点数
			BEGIN
				-- UPDATE points_answer_total
				UPDATE #TABLE_RESULT SET 
					points_answer_total	=	F2310_TOTAL.points_answer_sum				-- total number answer points of all employee in this target
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						SUM(#F2310_TABLE.points_answer)			AS	points_answer_sum
					,	#F2310_TABLE.company_cd					AS	company_cd
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity	=	0
					GROUP BY
						#F2310_TABLE.company_cd
				) AS F2310_TOTAL ON(
					#TABLE_RESULT.target_cd		=	F2310_TOTAL.company_cd
				AND	#TABLE_RESULT.month_num		=	@w_month_num
				)
				WHERE 
					#TABLE_RESULT.is_anonymity = 0
				-- UPDATE member_times_total
				UPDATE #TABLE_RESULT SET 
					member_times_total	=	ISNULL(F2310_TOTAL.employee_number_surveys_done,0)		-- total number answer points of all employee in this target
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						#F2310_TABLE.company_cd									AS	company_cd
					,	COUNT(#F2310_TABLE.employee_number_surveys_done)		AS	employee_number_surveys_done
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity	=	0
					GROUP BY
						#F2310_TABLE.company_cd
				) AS F2310_TOTAL ON(
					#TABLE_RESULT.target_cd		=	F2310_TOTAL.company_cd
				AND	#TABLE_RESULT.month_num		=	@w_month_num
				)
				WHERE 
					#TABLE_RESULT.is_anonymity = 0
			END
		END
		-- 1.組織１
		ELSE IF @w_view_unit = 1
		BEGIN
			IF @w_target = 1 -- 回答率
			BEGIN
				-- UPDATE target_member_total
				UPDATE #TABLE_RESULT SET 
					target_member_total	=	F2301_TOTAL_1.target_member_total
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						#F2301_TABLE.belong_cd1			AS	belong_cd1
					,	COUNT(#F2301_TABLE.times)		AS	target_member_total
					FROM #F2301_TABLE
					WHERE 
						#F2301_TABLE.[start_date]	>=	@w_date_from
					AND #F2301_TABLE.[start_date]	<=	@w_date_to
					AND #F2301_TABLE.is_anonymity	=	0
					GROUP BY
						#F2301_TABLE.belong_cd1
				) AS F2301_TOTAL_1 ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2301_TOTAL_1.belong_cd1
				)
				WHERE 
					#TABLE_RESULT.is_anonymity = 0
				-- UPDATE answer_total
				UPDATE #TABLE_RESULT SET 
					answer_total	=	ISNULL(F2310_TOTAL_1.answer_total,0)
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						#F2310_TABLE.belong_cd1				AS	belong_cd1
					,	COUNT(#F2310_TABLE.answer_no)		AS	answer_total
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity	=	0
					GROUP BY
						#F2310_TABLE.belong_cd1
				) AS F2310_TOTAL_1 ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2310_TOTAL_1.belong_cd1
				)
				WHERE 
					#TABLE_RESULT.is_anonymity = 0
			END
			ELSE	-- 点数
			BEGIN
				-- UPDATE points_answer_total
				UPDATE #TABLE_RESULT SET 
					points_answer_total	=	F2310_TOTAL_1.points_answer_sum
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						#F2310_TABLE.belong_cd1			AS	belong_cd1
					,	SUM(#F2310_TABLE.points_answer)	AS	points_answer_sum
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity	=	0
					GROUP BY
						#F2310_TABLE.belong_cd1
				) AS F2310_TOTAL_1 ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2310_TOTAL_1.belong_cd1
				)
				WHERE
					#TABLE_RESULT.is_anonymity = 0
				-- UPDATE member_times_total
				UPDATE #TABLE_RESULT SET 
					member_times_total	=	ISNULL(F2310_TOTAL_1.employee_number_surveys_done,0)
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						#F2310_TABLE.belong_cd1								AS	belong_cd1
					,	COUNT(#F2310_TABLE.employee_number_surveys_done)	AS	employee_number_surveys_done
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity	=	0
					GROUP BY
						#F2310_TABLE.belong_cd1
				) AS F2310_TOTAL_1 ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2310_TOTAL_1.belong_cd1
				)
				WHERE
					#TABLE_RESULT.is_anonymity = 0
			END			
		END
		-- 2.職種
		ELSE IF @w_view_unit = 2
		BEGIN
			IF @w_target = 1 -- 回答率
			BEGIN
				-- UPDATE target_member_total
				UPDATE #TABLE_RESULT SET 
					target_member_total	=	F2301_TOTAL_2.target_member_total
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						#F2301_TABLE.job_cd				AS	job_cd
					,	COUNT(#F2301_TABLE.times)		AS	target_member_total
					FROM #F2301_TABLE
					WHERE 
						#F2301_TABLE.[start_date]	>=	@w_date_from
					AND #F2301_TABLE.[start_date]	<=	@w_date_to
					AND #F2301_TABLE.is_anonymity	=	0
					GROUP BY
						#F2301_TABLE.job_cd
				) AS F2301_TOTAL_2 ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2301_TOTAL_2.job_cd
				)
				WHERE
					#TABLE_RESULT.is_anonymity = 0
				-- UPDATE answer_total
				UPDATE #TABLE_RESULT SET 
					answer_total	=	ISNULL(F2310_TOTAL_2.answer_total,0)
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						#F2310_TABLE.job_cd					AS	job_cd
					,	COUNT(#F2310_TABLE.answer_no)		AS	answer_total
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity	=	0
					GROUP BY
						#F2310_TABLE.job_cd
				) AS F2310_TOTAL_2 ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2310_TOTAL_2.job_cd
				)
				WHERE
					#TABLE_RESULT.is_anonymity = 0
			END
			ELSE	-- 点数
			BEGIN
				-- UPDATE points_answer_total
				UPDATE #TABLE_RESULT SET 
					points_answer_total	=	F2310_TOTAL_2.points_answer_sum
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						#F2310_TABLE.job_cd				AS	job_cd
					,	SUM(#F2310_TABLE.points_answer)	AS	points_answer_sum
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity	=	0
					GROUP BY
						#F2310_TABLE.job_cd
				) AS F2310_TOTAL_2 ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2310_TOTAL_2.job_cd
				)
				WHERE
					#TABLE_RESULT.is_anonymity = 0
				-- UPDATE member_times_total
				UPDATE #TABLE_RESULT SET 
					member_times_total	=	ISNULL(F2310_TOTAL_2.employee_number_surveys_done,0)
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						#F2310_TABLE.job_cd									AS	job_cd
					,	COUNT(#F2310_TABLE.employee_number_surveys_done)	AS	employee_number_surveys_done
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity	=	0
					GROUP BY
						#F2310_TABLE.job_cd
				) AS F2310_TOTAL_2 ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2310_TOTAL_2.job_cd
				)
				WHERE
					#TABLE_RESULT.is_anonymity = 0
			END
		END
		-- 3.等級
		ELSE IF @w_view_unit = 3
		BEGIN
			IF @w_target = 1 -- 回答率
			BEGIN
				-- UPDATE target_member_total
				UPDATE #TABLE_RESULT SET 
					target_member_total	=	F2301_TOTAL_3.target_member_total
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						#F2301_TABLE.grade				AS	grade
					,	COUNT(#F2301_TABLE.times)		AS	target_member_total
					FROM #F2301_TABLE
					WHERE 
						#F2301_TABLE.[start_date]	>=	@w_date_from
					AND #F2301_TABLE.[start_date]	<=	@w_date_to
					AND #F2301_TABLE.is_anonymity	=	0
					GROUP BY
						#F2301_TABLE.grade
				) AS F2301_TOTAL_3 ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2301_TOTAL_3.grade
				)
				WHERE
					#TABLE_RESULT.is_anonymity = 0
				-- UPDATE answer_total
				UPDATE #TABLE_RESULT SET 
					answer_total	=	ISNULL(F2310_TOTAL_3.answer_total,0)
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						#F2310_TABLE.grade						AS	grade
					,	COUNT(#F2310_TABLE.answer_no)			AS	answer_total
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity	=	0
					GROUP BY
						#F2310_TABLE.grade
				) AS F2310_TOTAL_3 ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2310_TOTAL_3.grade
				)
				WHERE
					#TABLE_RESULT.is_anonymity = 0
			END
			ELSE -- 点数
			BEGIN
				-- UPDATE points_answer_total
				UPDATE #TABLE_RESULT SET 
					points_answer_total	=	F2310_TOTAL_3.points_answer_sum
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						#F2310_TABLE.grade					AS	grade
					,	SUM(#F2310_TABLE.points_answer)		AS	points_answer_sum
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity	=	0
					GROUP BY
						#F2310_TABLE.grade
				) AS F2310_TOTAL_3 ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2310_TOTAL_3.grade
				)
				WHERE
					#TABLE_RESULT.is_anonymity = 0
				-- UPDATE member_times_total
				UPDATE #TABLE_RESULT SET 
					member_times_total	=	ISNULL(F2310_TOTAL_3.employee_number_surveys_done,0)
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						#F2310_TABLE.grade										AS	grade
					,	COUNT(#F2310_TABLE.employee_number_surveys_done)		AS	employee_number_surveys_done
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity	=	0
					GROUP BY
						#F2310_TABLE.grade
				) AS F2310_TOTAL_3 ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2310_TOTAL_3.grade
				)
				WHERE
					#TABLE_RESULT.is_anonymity = 0
			END
		END
		-- 4.年齢
		ELSE IF @w_view_unit = 4
		BEGIN
			IF @w_target = 1 -- 回答率
			BEGIN
				-- UPDATE target_member_total
				UPDATE #TABLE_RESULT SET 
					target_member_total	=	F2301_TOTAL_4.target_member_total
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						#F2301_TABLE.year_old			AS	year_old
					,	COUNT(#F2301_TABLE.times)		AS	target_member_total
					FROM #F2301_TABLE
					WHERE 
						#F2301_TABLE.[start_date]	>=	@w_date_from
					AND #F2301_TABLE.[start_date]	<=	@w_date_to
					AND #F2301_TABLE.is_anonymity	=	0
					GROUP BY
						#F2301_TABLE.year_old
				) AS F2301_TOTAL_4 ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2301_TOTAL_4.year_old
				)
				WHERE
					#TABLE_RESULT.is_anonymity = 0
				-- UPDATE answer_total
				UPDATE #TABLE_RESULT SET 
					answer_total	=	ISNULL(F2310_TOTAL_4.answer_total,0)
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						#F2310_TABLE.year_old				AS	year_old
					,	COUNT(#F2310_TABLE.answer_no)		AS	answer_total
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity	=	0
					GROUP BY
						#F2310_TABLE.year_old
				) AS F2310_TOTAL_4 ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2310_TOTAL_4.year_old
				)
				WHERE
					#TABLE_RESULT.is_anonymity = 0
			END
			ELSE -- 点数
			BEGIN
				-- UPDATE points_answer_total
				UPDATE #TABLE_RESULT SET 
					points_answer_total	=	F2310_TOTAL_4.points_answer_sum
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						#F2310_TABLE.year_old			AS	year_old
					,	SUM(#F2310_TABLE.points_answer)	AS	points_answer_sum
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity	=	0
					GROUP BY
						#F2310_TABLE.year_old
				) AS F2310_TOTAL_4 ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2310_TOTAL_4.year_old
				)
				WHERE
					#TABLE_RESULT.is_anonymity = 0
				-- UPDATE member_times_total
				UPDATE #TABLE_RESULT SET 
					member_times_total	=	ISNULL(F2310_TOTAL_4.employee_number_surveys_done,0)
				FROM #TABLE_RESULT
				INNER JOIN (
					SELECT 
						#F2310_TABLE.year_old								AS	year_old
					,	COUNT(#F2310_TABLE.employee_number_surveys_done)	AS	employee_number_surveys_done
					FROM #F2310_TABLE
					WHERE 
						#F2310_TABLE.[start_date]	>=	@w_date_from
					AND #F2310_TABLE.[start_date]	<=	@w_date_to
					AND #F2310_TABLE.is_anonymity	=	0
					GROUP BY
						#F2310_TABLE.year_old
				) AS F2310_TOTAL_4 ON(
					#TABLE_RESULT.month_num		=	@w_month_num
				AND #TABLE_RESULT.target_cd		=	F2310_TOTAL_4.year_old
				)
				WHERE
					#TABLE_RESULT.is_anonymity = 0
			END
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
	--■■■■■■■■■■■■■■■■■■■ ↑↑↑LOOP 12 MONTH↑↑↑　■■■■■■■■■■■■■■■■■■■
	-- caculate averaged_point
	UPDATE #TABLE_RESULT SET 
		averaged_point	=	CASE 
								WHEN  @w_target = 1 -- 回答率
								THEN
									CASE 
										WHEN target_member_total <> 0
										THEN ROUND(answer_total / target_member_total,2)
										ELSE 0
									END
								ELSE
									CASE 
										WHEN  member_times_total <> 0
										THEN ROUND(points_answer_total / member_times_total,2)
										ELSE 0
									END
							END
	FROM #TABLE_RESULT
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
	--UPDATE #TABLE_RESULT SET 
	IF @w_target = 1 -- 回答率
	BEGIN
		SELECT 
			@w_target_total  = COUNT(TABLE_TARGET.target_cd)
		FROM 
		(
			SELECT 
				#TABLE_RESULT.target_cd
			FROM #TABLE_RESULT
			WHERE 
				#TABLE_RESULT.target_member_total	>	0
			AND #TABLE_RESULT.averaged_point		>	0
			GROUP BY
				#TABLE_RESULT.target_cd
		) AS TABLE_TARGET
	END
	ELSE	-- 点数
	BEGIN
		SELECT 
			@w_target_total  = COUNT(TABLE_TARGET.target_cd)
		FROM 
		(
			SELECT 
				#TABLE_RESULT.target_cd
			FROM #TABLE_RESULT
			WHERE 
				#TABLE_RESULT.member_times_total	>	0
			AND #TABLE_RESULT.averaged_point		>	0
			GROUP BY
				#TABLE_RESULT.target_cd
		) AS TABLE_TARGET
	END
	-- insert into #TOTAL
	INSERT INTO #TOTAL
	SELECT
		#MONTH_MASTER.month_num					AS	month_num
	,	TABLE_TMP.averaged_point_year_month		AS	averaged_point_year_month
	,	0										AS	averaged_point_year
	FROM #MONTH_MASTER
	LEFT OUTER JOIN (
		SELECT
			#TABLE_RESULT.month_num		AS	month_num
		,	CASE 
				WHEN @w_target_total <> 0
				THEN ROUND((SUM(#TABLE_RESULT.averaged_point)	/	@w_target_total),2)
				ELSE 0
			END							AS	averaged_point_year_month
		FROM #TABLE_RESULT
		GROUP BY
			#TABLE_RESULT.month_num	
	) AS TABLE_TMP ON (
		#MONTH_MASTER.month_num = TABLE_TMP.month_num
	)
	-- UPDATE averaged_point_year OF #TOTAL
	SET @w_month_value_cnt = (SELECT COUNT(#TOTAL.month_num) FROM #TOTAL WHERE #TOTAL.averaged_point_year_month > 0)
	SET @w_averaged_point_year_total = (SELECT ISNULL(SUM(#TOTAL.averaged_point_year_month),0) FROM #TOTAL)
	-- 
	UPDATE #TOTAL SET 
		averaged_point_year = CASE 
									WHEN @w_month_value_cnt > 0
									THEN ROUND((@w_averaged_point_year_total / @w_month_value_cnt),2)
									ELSE 0
								END
	FROM #TOTAL
	-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- RESULT
	-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
COMPLETED:	
	-- add by viettd 2021/05/10
	IF @w_target = 1 -- 回答率
	BEGIN
		UPDATE #TABLE_RESULT SET 
			averaged_point		=	averaged_point * 100
		,	averaged_point_year	=	averaged_point_year * 100
		FROM #TABLE_RESULT
		--
		UPDATE #TOTAL SET 
			averaged_point_year_month	=	averaged_point_year_month * 100
		,	averaged_point_year			=	averaged_point_year * 100
		FROM #TOTAL
	END
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
			month_num					
		,	FORMAT(averaged_point_year_month,'0.#,#')	AS 	averaged_point_year_month
		,	FORMAT(averaged_point_year,'0.#,#')			AS	averaged_point_year
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
				,	averaged_point_year										AS	averaged_point_year
				FROM
				(
					SELECT 
						#TABLE_RESULT.company_cd							AS	company_cd
					,	#TABLE_RESULT.fiscal_year							AS	fiscal_year
					,	#TABLE_RESULT.target_cd								AS	target_cd
					,	#TABLE_RESULT.target_order							AS	target_order
					,	#TABLE_RESULT.target_nm								AS	target_nm
					,	#TABLE_RESULT.target_typ							AS	target_typ
					,	#TABLE_RESULT.month_num								AS	month_num
					,	FORMAT(#TABLE_RESULT.averaged_point_year,''0.##'')	AS	averaged_point_year
					,	CASE 
							WHEN #TOTAL.averaged_point_year_month > 0
							THEN CAST(FORMAT(#TABLE_RESULT.averaged_point,''0.##'') AS nvarchar(10))
							ELSE ''''
						END													AS	caculate_result
					FROM #TABLE_RESULT
					LEFT OUTER JOIN #TOTAL ON (
						#TABLE_RESULT.month_num = #TOTAL.month_num
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
			--↓↓↓ edited by viettd 2021/06/11
			IF @w_view_unit <> 0 -- 0.全社
			BEGIN
				--LINE DETAIL:
				INSERT INTO #DATA
				EXEC(@w_sql)
			END
			--↑↑↑ end edited by viettd 2021/06/11
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
			,	FORMAT(#TOTAL_M1.averaged_point_year,'0.#,#')			AS	annual_average	
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
	-- CROSS
	IF (@P_mode = 2)
	BEGIN
		SELECT
			company_cd
		,	fiscal_year
		,	employee_cd
		,	points_answer_avg
		,	CASE 
				WHEN points_answer_avg <= 1
				THEN 1
				WHEN points_answer_avg > 1 AND points_answer_avg <= 2
				THEN 2
				WHEN points_answer_avg > 2 AND points_answer_avg <= 3
				THEN 3
				WHEN points_answer_avg > 3 AND points_answer_avg <= 4
				THEN 4
				WHEN points_answer_avg > 4 AND points_answer_avg <= 5
				THEN 5
				WHEN points_answer_avg > 5 AND points_answer_avg <= 6
				THEN 6
				WHEN points_answer_avg > 6 AND points_answer_avg <= 7
				THEN 7
				WHEN points_answer_avg > 7 AND points_answer_avg <= 8
				THEN 8
				WHEN points_answer_avg > 8 AND points_answer_avg <= 9
				THEN 9
				WHEN points_answer_avg > 9 AND points_answer_avg <= 10
				THEN 10
				ELSE 0  
			END				AS	points_answer
		FROM #TABLE_CROSS
	END
	-- DROP
	DROP TABLE #LIST_COACH
	DROP TABLE #LIST_GRADE
	DROP TABLE #LIST_POSITION
	DROP TABLE #M0070
	DROP TABLE #M0070H
	DROP TABLE #F2301_TABLE
	DROP TABLE #MONTH_MASTER
	DROP TABLE #TABLE_RESULT
	DROP TABLE #MONTH_HEADER
	DROP TABLE #DATA
END
GO
