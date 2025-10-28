IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_rQ3020_FND1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_rQ3020_FND1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- 
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	rQ3020_分析（充実度）
--*  
--*  作成日/create date			:	2023/05/24						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*   					
--****************************************************************************************
CREATE PROCEDURE [SPC_rQ3020_FND1]
	-- Add the parameters for the stored procedure here
	@P_language					nvarchar(10)		=	'jp'
,	@P_json						nvarchar(max)		=	''	
,	@P_company_cd				smallint			=	0
,	@P_cre_user					nvarchar(50)		=	''	
,	@P_mode						INT					=	0	--0:SEARCH/1:OUTPUT EXCEL/2.CROSS 
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								datetime			=	SYSDATETIME()
	,	@year_month_day						date				=	NULL
	--
	,	@w_fiscal_year						int					=	0
	,	@w_month_from						smallint			=	-1
	,	@w_times_from						smallint			=	-1
	,	@w_month_to							smallint			=	-1
	,	@w_times_to							smallint			=	-1
	,	@w_year_month_from					int					=	0
	,	@w_year_month_to					int					=	0
	,	@w_report_kind						smallint			=	0		
	,	@w_adequacy_type					smallint			=	0	-- 対象
	,	@w_employee_typ						smallint			=	0
	,	@w_position_cd						int					=	0
	,	@w_job_cd							smallint			=	0
	,	@w_report_authority_typ				smallint			=	0
	,	@w_report_authority_cd				smallint			=	0
	,	@use_typ							smallint			=	0	
	,	@arrange_order						int					=	0
	,	@login_position_cd					int					=	0
	,	@w_language							smallint			=	0
	,	@w_approver_cd						nvarchar(10)		=	''
	,	@w_reporter_cd						nvarchar(10)		=	''
	,	@beginning_date						date				=	NULL
	,	@choice_in_screen					tinyint				=	0
	,	@w_sql								nvarchar(max)		=	''
	,	@w_month_str						nvarchar(max)		=	''
	,	@w_i								int					=	1
	,	@w_cnt								int					=	0
	--	M4121
	,	@w_mark_cd							smallint			=	0
	,	@w_point_from						numeric(5,2)		=	0
	,	@w_point_to							numeric(5,2)		=	0
	,	@w_m4121_cnt						int					=	0
	,	@w_mark_type						smallint			=	0
	,	@w_i_minus							int					=	0
	--	
	,	@w_year								int					=	0
	,	@w_month							int					=	0
	,	@w_times							int					=	0
	,	@w_year_month_times					bigint				=	0
	,	@w_target_type						smallint			=	0	-- 0.組織ごとに集計	1.社員ごとに集計
	,	@w_year_footer_adequacy_score		money				=	0	--	提出済件
	,	@w_year_footer_total_report			money				=	0	--	報告書件
	,	@w_year_footer_adequacy_score_avg		money			=	0	--	提出済率　（100%）
	-- add by viettd 2021/06/03
	,	@w_organization_cnt					INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
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
	CREATE TABLE #LIST_GROUP(
		id								int			identity(1,1)
	,	group_cd						smallint	
	)
	--
	CREATE TABLE #LIST_APPROVER(
		id								int			identity(1,1)
	,	company_cd						smallint	
	,	fiscal_year						smallint	
	,	employee_cd						nvarchar(10)	
	,	report_kind						smallint	
	,	report_no						smallint
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
	,	employee_nm						nvarchar(101)
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
	--↓↓↓ rQ3020
	CREATE TABLE #F4200_TABLE (
		id								int		identity(1,1)
	,	company_cd						smallint
	,	fiscal_year						smallint
	,	employee_cd						nvarchar(10)
	,	report_kind						smallint
	,	report_no						smallint
	,	group_cd						smallint
	--
	,	belong_cd1						nvarchar(20)
	,	year_month						date
	,	[year]							smallint
	,	[month]							smallint
	,	year_month_num					int
	,	times							smallint
	,	year_month_times				bigint
	--
	,	point							money
	)
	-- #F4100_TABLE
	CREATE TABLE #F4100_TABLE (
		id								int		identity(1,1)
	,	[year]							smallint
	,	[month]							smallint
	,	year_month_num					int
	,	times							smallint
	,	year_month_times				bigint
	,	title							nvarchar(20)
	)
	--
	CREATE TABLE #MONTH_MASTER (
		id								int		identity(1,1)
	,	[year]							smallint
	,	[month]							smallint
	,	times							smallint
	,	year_month_times				bigint
	,	month_index						smallint
	,	title							nvarchar(20)
	)
	--
	CREATE TABLE #TABLE_RESULT (
		id								int		identity(1,1)
	,	company_cd						smallint
	,	fiscal_year						smallint
	,	year_month_times				bigint
	--
	,	target_cd						nvarchar(50)			
	,	target_nm						nvarchar(200)
	,	adequacy_score					money			--	充実度点数 OR 繁忙度点数
	,	total_report					money			--	報告書件
	,	adequacy_score_avg				money			--	充実度点数の平均 OR 平均
	-- YEAR
	,	year_adequacy_score				money			--	年_充実度点数 OR 年_繁忙度点数
	,	year_total_report				money			--	年_報告書件
	,	year_adequacy_score_avg			money			--	年_充実度点数の平均 OR 年_繁忙度点数の平均
	,	target_order					int				-- order by
	)
	--
	CREATE TABLE #TABLE_CROSS (
		id								int		identity(1,1)
	,	company_cd						smallint
	,	fiscal_year						smallint
	,	employee_cd						nvarchar(10)
	,	adequacy_score					money			--	充実度点数 OR 繁忙度点数
	,	total_report					money			--	報告書件
	,	adequacy_score_avg				money			--	充実度点数の平均 OR 平均
	-- mark M4123
	,	item_no							smallint
	,	mark_cd							smallint
	,	mark_cd_point					numeric(5,2)
	)
	--
	CREATE TABLE #TOTAL (
		id								int			identity(1,1)
	,	year_month_times				bigint	
	,	year_month_times_nm				nvarchar(20)
	,	adequacy_score					money			--	充実度点数 OR 繁忙度点数
	,	total_report					money			--	報告書件
	,	adequacy_score_avg				money			--	充実度点数の平均 OR 平均
	)
	--
	CREATE TABLE #CALENDAR_MASTER(
		id				int		identity(1,1)
	,	month_num		int
	,	month_num_nm	nvarchar(50)
	,	date_from		date
	,	date_to			date
	)
	--
	SELECT 
		@w_report_authority_typ		=	ISNULL(S0010.report_authority_typ,0)
	,	@w_report_authority_cd		=	ISNULL(S0010.report_authority_cd,0)
	,	@login_position_cd			=	ISNULL(M0070.position_cd,0)
	,	@w_language					=	ISNULL(S0010.[language],0)
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
		@use_typ		=	ISNULL(S4020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
	FROM S4020
	WHERE
		S4020.company_cd		=	@P_company_cd
	AND S4020.authority_cd		=	@w_report_authority_cd
	AND S4020.del_datetime IS NULL
	-- get @arrange_order
	SELECT 
		@arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@login_position_cd
	AND M0040.del_datetime IS NULL
	-- COUNT ALL ORGANIZATIONS OF S2022 -- add by viettd 2021/06/03
	SET @w_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_report_authority_cd,5)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_report_authority_cd,5)
	-- GET VALUE FROM JSON
	SET @w_fiscal_year		=	ISNULL(JSON_VALUE(@P_json,'$.fiscal_year'),0)			-- 年度
	SET @w_month_from		=	ISNULL(JSON_VALUE(@P_json,'$.month_from'),-1)			-- 
	SET @w_times_from		=	ISNULL(JSON_VALUE(@P_json,'$.times_from'),-1)			-- 
	SET @w_month_to			=	ISNULL(JSON_VALUE(@P_json,'$.month_to'),-1)				-- 
	SET @w_times_to			=	ISNULL(JSON_VALUE(@P_json,'$.times_to'),-1)				-- 
	SET @w_report_kind		=	ISNULL(JSON_VALUE(@P_json,'$.report_kind'),0)			-- 報告書種類
	SET @w_adequacy_type	=	ISNULL(JSON_VALUE(@P_json,'$.adequacy_type'),0)			-- 対象
	SET @w_employee_typ		=	ISNULL(JSON_VALUE(@P_json,'$.employee_typ'),-1)			-- 社員区分
	SET @w_position_cd		=	ISNULL(JSON_VALUE(@P_json,'$.position_cd'),-1)			-- 役職
	SET @w_reporter_cd		=	ISNULL(JSON_VALUE(@P_json,'$.reporter_cd'),'')			-- 報告者
	SET @w_approver_cd		=	ISNULL(JSON_VALUE(@P_json,'$.approver_cd'),'')			-- 承認者
	SET @w_job_cd			=	ISNULL(JSON_VALUE(@P_json,'$.job_cd'),-1)				-- 職種
	--
	SELECT 
		@beginning_date = M9100.report_beginning_date 
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
		SET @beginning_date = '1900-01-01'
	END
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @year_month_day,'',@P_company_cd
	-- GET #CALENDAR_MASTER
	INSERT INTO #CALENDAR_MASTER
	EXEC [dbo].SPC_WeeklyReport_GET_YEAR_MONTHS_FND1 @w_fiscal_year,@P_company_cd,@P_cre_user
	--
	IF @w_month_from > 0
	BEGIN
		SET @w_year_month_from = (SELECT CAST(CAST(CONVERT(NVARCHAR(10),#CALENDAR_MASTER.date_from,112) AS nvarchar(6)) AS INT) FROM #CALENDAR_MASTER WHERE id = @w_month_from)
	END
	IF @w_month_to > 0
	BEGIN
		SET @w_year_month_to = (SELECT CAST(CAST(CONVERT(NVARCHAR(10),#CALENDAR_MASTER.date_from,112) AS nvarchar(6)) AS INT) FROM #CALENDAR_MASTER WHERE id = @w_month_to)
	END
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
	-- INSERT DATA INTO #LIST_GROUP
	INSERT INTO #LIST_GROUP
	SELECT json_table.group_cd FROM OPENJSON(@P_json,'$.list_group_cd') WITH(
		group_cd	smallint
	)AS json_table
	WHERE
		json_table.group_cd > 0
	-- INSERT DATA INTO #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 @P_json,@P_cre_user,@P_company_cd,5
	
	-- INSERT DATA INTO #LIST_APPROVER
	IF @w_approver_cd IS NOT NULL AND @w_approver_cd <> ''
	BEGIN
		INSERT INTO #LIST_APPROVER
		SELECT 
			F4200.company_cd
		,	F4200.fiscal_year
		,	F4200.employee_cd
		,	F4200.report_kind
		,	F4200.report_no
		FROM F4200 WITH(NOLOCK)
		WHERE
			F4200.company_cd	=	@P_company_cd
		AND F4200.fiscal_year	=	@w_fiscal_year
		AND (
			(@w_report_kind <= 0)
		OR	(@w_report_kind > 0 AND F4200.report_kind = @w_report_kind)
		)
		AND (
			F4200.approver_employee_cd_1	=	@w_approver_cd
		OR	F4200.approver_employee_cd_2	=	@w_approver_cd
		OR	F4200.approver_employee_cd_3	=	@w_approver_cd
		OR	F4200.approver_employee_cd_4	=	@w_approver_cd
		)
		AND F4200.del_datetime IS NULL
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
	,	M0070.employee_nm
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
		ELSE IF NOT (@w_report_authority_typ = 3 AND @w_organization_cnt = 0 AND @w_organization_belong_person_typ = 0) -- edited by viettd 2021/06/03
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
			AND @w_report_authority_typ NOT IN (4,5) --4.会社管理者 5.総合管理者
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
			IF @w_report_authority_typ NOT IN (4,5)
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
	-- FILTER 
	--■■■■■■■■■■■■■ END FILTER DATA ■■■■■■■■■■■■■
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--PROCESS DATA TO rQ3020
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- GET #F4100_TABLE
	IF @w_report_kind IN (1,2,3)
	BEGIN
		-- HAS #LIST_GROUP
		IF EXISTS (SELECT 1 FROM #LIST_GROUP)
		BEGIN
			INSERT INTO #F4100_TABLE
			SELECT 
				F4100.[year]							
			,	F4100.[month]		
			,	CONVERT(INT,CAST(F4100.[year] AS nvarchar(4)) + RIGHT('00' + CAST(F4100.[month] AS nvarchar(2)),2))
			,	F4100.detail_no							
			,	CONVERT(bigint,CAST(F4100.[year] AS nvarchar(4)) + RIGHT('00'+CAST(F4100.[month] AS nvarchar(2)),2) + CAST(F4100.detail_no AS nvarchar(2)))				
			,	SPACE(0)
			FROM F4100
			INNER JOIN #LIST_GROUP ON (
				F4100.group_cd		=	#LIST_GROUP.group_cd
			)
			WHERE
				F4100.company_cd		=	@P_company_cd
			AND F4100.fiscal_year		=	@w_fiscal_year
			AND F4100.report_kind		=	@w_report_kind	
			AND F4100.user_typ			=	1
			AND F4100.del_datetime IS NULL
			GROUP BY
				F4100.[year]							
			,	F4100.[month]							
			,	F4100.detail_no	
		END
		ELSE
		BEGIN
			INSERT INTO #F4100_TABLE
			SELECT 
				F4100.[year]							
			,	F4100.[month]
			,	CONVERT(INT,CAST(F4100.[year] AS nvarchar(4)) + RIGHT('00' + CAST(F4100.[month] AS nvarchar(2)),2))
			,	F4100.detail_no							
			,	CONVERT(bigint,CAST(F4100.[year] AS nvarchar(4)) + RIGHT('00'+CAST(F4100.[month] AS nvarchar(2)),2) + CAST(F4100.detail_no AS nvarchar(2)))				
			,	SPACE(0)
			FROM F4100
			WHERE
				F4100.company_cd		=	@P_company_cd
			AND F4100.fiscal_year		=	@w_fiscal_year
			AND F4100.report_kind		=	@w_report_kind	
			AND F4100.user_typ			=	1
			AND F4100.del_datetime IS NULL
			GROUP BY
				F4100.[year]							
			,	F4100.[month]							
			,	F4100.detail_no	
		END
	END
	ELSE 
	BEGIN
		-- HAS #LIST_GROUP
		IF EXISTS (SELECT 1 FROM #LIST_GROUP)
		BEGIN
			INSERT INTO #F4100_TABLE
			SELECT 
				F4100.[year]							
			,	F4100.[month]		
			,	CONVERT(INT,CAST(F4100.[year] AS nvarchar(4)) + RIGHT('00' + CAST(F4100.[month] AS nvarchar(2)),2))
			,	F4100.detail_no							
			,	CONVERT(bigint,CAST(F4100.[year] AS nvarchar(4)) + RIGHT('00'+CAST(F4100.[month] AS nvarchar(2)),2) + CAST(F4100.detail_no AS nvarchar(2)))				
			,	SPACE(0)
			FROM F4100
			INNER JOIN #LIST_GROUP ON (
				F4100.group_cd		=	#LIST_GROUP.group_cd
			)
			WHERE
				F4100.company_cd		=	@P_company_cd
			AND F4100.fiscal_year		=	@w_fiscal_year
			AND F4100.report_kind		=	@w_report_kind	
			AND F4100.user_typ			=	1
			--AND (
			--	(@w_month_from <= 0)
			--OR	(@w_month_from > 0 AND F4100.[month] >= @w_month_from)
			--)
			AND (
				(@w_times_from <= 0)
			OR	(@w_times_from > 0 AND F4100.detail_no >= @w_times_from)
			)
			--AND (
			--	(@w_month_to <= 0)
			--OR	(@w_month_to > 0 AND F4100.[month] <= @w_month_to)
			--)
			AND (
				(@w_times_to <= 0)
			OR	(@w_times_to > 0 AND F4100.detail_no <= @w_times_to)
			)
			AND F4100.del_datetime IS NULL
			GROUP BY
				F4100.[year]							
			,	F4100.[month]							
			,	F4100.detail_no	
		END
		ELSE
		BEGIN
			INSERT INTO #F4100_TABLE
			SELECT 
				F4100.[year]							
			,	F4100.[month]		
			,	CONVERT(INT,CAST(F4100.[year] AS nvarchar(4)) + RIGHT('00' + CAST(F4100.[month] AS nvarchar(2)),2))
			,	F4100.detail_no							
			,	CONVERT(bigint,CAST(F4100.[year] AS nvarchar(4)) + RIGHT('00'+CAST(F4100.[month] AS nvarchar(2)),2) + CAST(F4100.detail_no AS nvarchar(2)))				
			,	SPACE(0)
			FROM F4100
			WHERE
				F4100.company_cd		=	@P_company_cd
			AND F4100.fiscal_year		=	@w_fiscal_year
			AND F4100.report_kind		=	@w_report_kind	
			AND F4100.user_typ			=	1
			--AND (
			--	(@w_month_from <= 0)
			--OR	(@w_month_from > 0 AND F4100.[month] >= @w_month_from)
			--)
			AND (
				(@w_times_from <= 0)
			OR	(@w_times_from > 0 AND F4100.detail_no >= @w_times_from)
			)
			--AND (
			--	(@w_month_to <= 0)
			--OR	(@w_month_to > 0 AND F4100.[month] <= @w_month_to)
			--)
			AND (
				(@w_times_to <= 0)
			OR	(@w_times_to > 0 AND F4100.detail_no <= @w_times_to)
			)
			AND F4100.del_datetime IS NULL
			GROUP BY
				F4100.[year]							
			,	F4100.[month]							
			,	F4100.detail_no	
			-- FILTER @w_month_from AND @w_month_to
			IF @w_month_from > 0
			BEGIN
				DELETE D FROM #F4100_TABLE AS D
				WHERE 
					D.year_month_num <	@w_year_month_from
			END
			IF @w_month_to > 0
			BEGIN
				DELETE D FROM #F4100_TABLE AS D
				WHERE 
					D.year_month_num >	@w_year_month_to
			END
		END
	END
	-- GET #MONTH_MASTER
	INSERT INTO #MONTH_MASTER
	SELECT 
		[year]		
	,	[month]		
	,	times	
	,	year_month_times
	,	ROW_NUMBER() OVER(PARTITION BY [month] ORDER BY year_month_times)
	,	SPACE(0)
	FROM #F4100_TABLE
	GROUP BY
		[year]		
	,	[month]		
	,	times
	,	year_month_times
	ORDER BY
		year_month_times
	-- UPDATE TITLE
	IF @w_report_kind IN (1,2,3)
	BEGIN
		UPDATE #MONTH_MASTER SET
			title = CASE 
						WHEN @w_language = 2
						THEN 'Times'+SPACE(1) + CAST(#MONTH_MASTER.id AS nvarchar(2))
						ELSE CAST(#MONTH_MASTER.id AS nvarchar(2)) + '回'
					END
		FROM #MONTH_MASTER
		INNER JOIN #CALENDAR_MASTER ON (
			#MONTH_MASTER.month			=	#CALENDAR_MASTER.month_num
		)
	END
	ELSE
	BEGIN
		UPDATE #MONTH_MASTER SET 
			title = CASE 
						WHEN @w_language = 2
						THEN ISNULL(#CALENDAR_MASTER.month_num_nm,'')  + SPACE(1) + 'Times' + CAST(month_index AS nvarchar(2))
						ELSE CAST(month AS nvarchar(2)) + '月' + CAST(month_index AS nvarchar(2)) + '回' 
					END
		FROM #MONTH_MASTER
		INNER JOIN #CALENDAR_MASTER ON (
			#MONTH_MASTER.month			=	#CALENDAR_MASTER.month_num
		)
	END
	-- INSERT DATA INTO #F4200_TABLE
	INSERT INTO #F4200_TABLE
	SELECT 
		F4200.company_cd
	,	F4200.fiscal_year
	,	F4200.employee_cd
	,	F4200.report_kind
	,	F4200.report_no
	,	ISNULL(F4110.group_cd,0)	
	,	#M0070.belong_cd_1
	,	CASE 
			WHEN @w_report_kind IN (4,5)
			THEN CONVERT(DATE,(CAST(ISNULL(F4200.year,0) AS nvarchar(4)) + '-' + RIGHT('00'+CAST(ISNULL(F4200.month,1) AS nvarchar(4)),2) + '-01'))
			ELSE NULL
		END
	,	ISNULL(F4200.[year],0)
	,	ISNULL(F4200.[month],0)
	,	CONVERT(INT,CAST(F4200.[year] AS nvarchar(4)) + RIGHT('00' + CAST(F4200.[month] AS nvarchar(2)),2))
	,	ISNULL(F4200.times,0)
	,	CONVERT(bigint,CAST(F4200.[year] AS nvarchar(4)) + RIGHT('00'+CAST(F4200.[month] AS nvarchar(2)),2) + CAST(F4200.times AS nvarchar(2)))		
	,	CASE 
			WHEN @w_adequacy_type = 1
			THEN ISNULL(M4121_充実度.point,0)
			ELSE ISNULL(M4121_繁忙度.point,0)
		END
	FROM F4200 WITH(NOLOCK)
	INNER JOIN #M0070 ON (
		F4200.company_cd		=	#M0070.company_cd
	AND F4200.fiscal_year		=	@w_fiscal_year
	AND F4200.employee_cd		=	#M0070.employee_cd
	)
	LEFT OUTER JOIN F4110 ON (
		F4200.company_cd		=	F4110.company_cd
	AND F4200.fiscal_year		=	F4110.fiscal_year
	AND F4200.employee_cd		=	F4110.employee_cd
	AND F4200.report_kind		=	F4110.report_kind
	AND F4200.report_no			=	F4110.report_no
	AND F4110.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4201 ON (
		F4200.company_cd		=	F4201.company_cd
	AND F4200.fiscal_year		=	F4201.fiscal_year
	AND F4200.employee_cd		=	F4201.employee_cd
	AND F4200.report_kind		=	F4201.report_kind
	AND F4200.report_no			=	F4201.report_no
	AND F4201.del_datetime IS NULL
	)
	LEFT OUTER JOIN M4121 AS M4121_充実度 ON (
		F4201.company_cd		=	M4121_充実度.company_cd
	AND 1						=	M4121_充実度.mark_kbn
	AND F4201.adequacy_kbn		=	M4121_充実度.mark_cd
	AND M4121_充実度.del_datetime IS NULL
	)
	LEFT OUTER JOIN M4121 AS M4121_繁忙度 ON (
		F4201.company_cd		=	M4121_繁忙度.company_cd
	AND 2						=	M4121_繁忙度.mark_kbn
	AND F4201.busyness_kbn		=	M4121_繁忙度.mark_cd
	AND M4121_繁忙度.del_datetime IS NULL
	)
	WHERE 
		F4200.company_cd		=	@P_company_cd
	AND F4200.fiscal_year		=	@w_fiscal_year
	AND (
			(@w_report_kind <= 0)
		OR	(@w_report_kind > 0 AND F4200.report_kind	=	@w_report_kind)
	)
	AND F4200.del_datetime IS NULL
	AND F4201.submission_datetime IS NOT NULL		-- 提出済み（F4201.submission_datetime IS NOT NULL）のデータが集計対象
	-- FILTER 月回
	IF @w_report_kind = 4 -- 月報
	BEGIN
		-- @w_month_from
		IF @w_month_from > 0
		BEGIN
			DELETE D FROM #F4200_TABLE AS D WHERE D.year_month_num < @w_year_month_from
		END
		-- @w_month_to
		IF @w_month_to > 0
		BEGIN
			DELETE D FROM #F4200_TABLE AS D WHERE D.year_month_num > @w_year_month_to
		END
	END
	IF @w_report_kind = 5 -- 週報
	BEGIN
		-- @w_month_from
		IF @w_month_from > 0
		BEGIN
			DELETE D FROM #F4200_TABLE AS D WHERE D.year_month_num < @w_year_month_from
		END
		-- @w_month_to
		IF @w_month_to > 0
		BEGIN
			DELETE D FROM #F4200_TABLE AS D WHERE D.year_month_num > @w_year_month_to
		END
		-- @w_times_from
		IF @w_times_from > 0
		BEGIN
			DELETE D FROM #F4200_TABLE AS D WHERE D.times < @w_times_from
		END
		-- @w_times_to
		IF @w_times_to > 0
		BEGIN
			DELETE D FROM #F4200_TABLE AS D WHERE D.times > @w_times_to
		END
	END
	-- FITER 承認者
	IF @w_approver_cd IS NOT NULL AND @w_approver_cd <> ''
	BEGIN
		DELETE D FROM #F4200_TABLE AS D
		LEFT OUTER JOIN #LIST_APPROVER AS S ON (
			D.company_cd		=	@P_company_cd
		AND D.fiscal_year		=	S.fiscal_year
		AND D.employee_cd		=	S.employee_cd
		AND D.report_kind		=	S.report_kind
		AND D.report_no			=	S.report_no
		)
		WHERE
			S.employee_cd IS NULL
	END
	-- FITER 報告者
	IF @w_reporter_cd IS NOT NULL AND @w_reporter_cd <> ''
	BEGIN
		DELETE D FROM #F4200_TABLE AS D
		WHERE
			D.employee_cd	<>	@w_reporter_cd
	END
	-- FITER グループ
	IF EXISTS (SELECT 1 FROM #LIST_GROUP)
	BEGIN
		DELETE D FROM #F4200_TABLE AS D
		LEFT OUTER JOIN #LIST_GROUP AS S ON (
			D.company_cd		=	@P_company_cd
		AND D.group_cd			=	S.group_cd
		)
		WHERE
			S.group_cd IS NULL
	END
	-- CHECK #F4200_TABLE IS NOT EXIST 
	IF NOT EXISTS (SELECT 1 FROM #F4200_TABLE)
	BEGIN
		GOTO COMPLETED
	END
	-- 【組織ごとに集計】と【社員ごとに集計】を判明する
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1) 
	BEGIN
		SET @w_target_type = 1
	END
	IF EXISTS (SELECT 1 FROM #LIST_GRADE) 
	BEGIN
		SET @w_target_type = 1
	END
	IF @w_position_cd > 0 OR @w_job_cd > 0 OR @w_employee_typ > 0 
	BEGIN
		SET @w_target_type = 1
	END
	-- 【組織ごとに集計】
	IF @w_target_type = 0
	BEGIN
		INSERT INTO #TABLE_RESULT
		SELECT 
			@P_company_cd
		,	@w_fiscal_year
		,	#MONTH_MASTER.year_month_times
		,	ISNULL(M0020.organization_cd_1,'')			AS	target_cd
		,	ISNULL(M0020.organization_nm,'')			AS	target_nm
		,	0			--	adequacy_score				
		,	0			--	total_report				
		,	0			--	adequacy_score_avg			
		,	0			--	year_adequacy_score			
		,	0			--	year_total_report			
		,	0			--	year_adequacy_score_avg		
		,	M0020.arrange_order	--target_order
		FROM #MONTH_MASTER
		LEFT OUTER JOIN #TABLE_ORGANIZATION WITH(NOLOCK) ON (
			1	=	#TABLE_ORGANIZATION.organization_typ
		)
		INNER JOIN M0020 WITH(NOLOCK) ON (
			@P_company_cd							=	M0020.company_cd
		AND #TABLE_ORGANIZATION.organization_cd_1	=	M0020.organization_cd_1
		AND #TABLE_ORGANIZATION.organization_cd_2	=	M0020.organization_cd_2
		AND #TABLE_ORGANIZATION.organization_cd_3	=	M0020.organization_cd_3
		AND #TABLE_ORGANIZATION.organization_cd_4	=	M0020.organization_cd_4
		AND #TABLE_ORGANIZATION.organization_cd_5	=	M0020.organization_cd_5
		AND #TABLE_ORGANIZATION.organization_typ	=	1
		AND M0020.del_datetime IS NULL
		)
		WHERE 
			#TABLE_ORGANIZATION.organization_typ	=	1
		ORDER BY 
			M0020.arrange_order ASC
		,	RIGHT(SPACE(20)+ISNULL(#TABLE_ORGANIZATION.organization_cd_1,N''),20)
		-- GOTO 
		GOTO CACULATE
	END
	-- 【社員ごとに集計】
	IF @w_target_type = 1
	BEGIN
		INSERT INTO #TABLE_RESULT
		SELECT 
			@P_company_cd
		,	@w_fiscal_year
		,	#MONTH_MASTER.year_month_times
		,	ISNULL(F4200_EMP.employee_cd,'')		AS	target_cd
		,	ISNULL(M0070.employee_nm,'')			AS	target_nm
		,	0			--	adequacy_score				
		,	0			--	total_report				
		,	0			--	adequacy_score_avg			
		,	0			--	year_adequacy_score			
		,	0			--	year_total_report			
		,	0			--	year_adequacy_score_avg		
		,	0	--	target_order
		FROM #MONTH_MASTER
		LEFT OUTER JOIN (
			SELECT 
				#F4200_TABLE.company_cd		AS	company_cd
			,	#F4200_TABLE.fiscal_year	AS	fiscal_year
			,	#F4200_TABLE.employee_cd	AS	employee_cd
			FROM #F4200_TABLE
			GROUP BY
				#F4200_TABLE.company_cd	
			,	#F4200_TABLE.fiscal_year
			,	#F4200_TABLE.employee_cd
		) AS F4200_EMP ON (
			@P_company_cd			=	F4200_EMP.company_cd
		)
		LEFT OUTER JOIN M0070 ON (
			@P_company_cd			=	M0070.company_cd
		AND F4200_EMP.employee_cd	=	M0070.employee_cd
		AND M0070.del_datetime IS NULL
		)
		ORDER BY 
			RIGHT(SPACE(10)+ISNULL(F4200_EMP.employee_cd,N''),10)
		-- GOTO 
		GOTO CACULATE
	END
	-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- CACULATE
	-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
CACULATE:
	-- LOOP #MONTH_MASTER TIMES
	SET @w_cnt = (SELECT COUNT(1) FROM #MONTH_MASTER)
	WHILE @w_i <= @w_cnt
	BEGIN
		SELECT 
			@w_year				=	#MONTH_MASTER.year
		,	@w_month			=	#MONTH_MASTER.month
		,	@w_times			=	#MONTH_MASTER.times
		,	@w_year_month_times	=	#MONTH_MASTER.year_month_times
		FROM #MONTH_MASTER
		WHERE 
			#MONTH_MASTER.id = @w_i
		--【組織ごとに集計】
		IF @w_target_type = 0
		BEGIN
			-- UPDATE total_report
			UPDATE #TABLE_RESULT SET 
				total_report	=	ISNULL(F4200_TOTAL_1.report_no_cnt,0)
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					#F4200_TABLE.belong_cd1			AS	belong_cd1
				,	COUNT(#F4200_TABLE.report_no)	AS	report_no_cnt
				FROM #F4200_TABLE
				WHERE
					#F4200_TABLE.year_month_times	=	@w_year_month_times
				GROUP BY
					#F4200_TABLE.belong_cd1
			) AS F4200_TOTAL_1 ON(
				#TABLE_RESULT.year_month_times	=	@w_year_month_times
			AND #TABLE_RESULT.target_cd			=	F4200_TOTAL_1.belong_cd1
			)
			-- UPDATE adequacy_score
			UPDATE #TABLE_RESULT SET 
				adequacy_score	=	ISNULL(F4200_TOTAL_1.point,0)
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					#F4200_TABLE.belong_cd1			AS	belong_cd1
				,	SUM(#F4200_TABLE.point)			AS	point
				FROM #F4200_TABLE
				WHERE 
					#F4200_TABLE.year_month_times	=	@w_year_month_times
				GROUP BY
					#F4200_TABLE.belong_cd1
			) AS F4200_TOTAL_1 ON(
				#TABLE_RESULT.year_month_times		=	@w_year_month_times
			AND #TABLE_RESULT.target_cd				=	F4200_TOTAL_1.belong_cd1
			)
		END
		--【社員ごとに集計】
		IF @w_target_type = 1
		BEGIN
			-- UPDATE total_report
			UPDATE #TABLE_RESULT SET 
				total_report	=	ISNULL(F4200_TOTAL_1.report_no_cnt,0)
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					#F4200_TABLE.employee_cd			AS	employee_cd
				,	COUNT(#F4200_TABLE.report_no)		AS	report_no_cnt
				FROM #F4200_TABLE
				WHERE 
					#F4200_TABLE.year_month_times = @w_year_month_times
				GROUP BY
					#F4200_TABLE.employee_cd
			) AS F4200_TOTAL_1 ON(
				#TABLE_RESULT.year_month_times		=	@w_year_month_times
			AND #TABLE_RESULT.target_cd				=	F4200_TOTAL_1.employee_cd
			)
			-- UPDATE adequacy_score
			UPDATE #TABLE_RESULT SET 
				adequacy_score		=	ISNULL(F4200_TOTAL_1.point,0)
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					#F4200_TABLE.employee_cd		AS	employee_cd
				,	SUM(#F4200_TABLE.point)			AS	point
				FROM #F4200_TABLE
				WHERE 
					#F4200_TABLE.year_month_times	=	@w_year_month_times
				GROUP BY
					#F4200_TABLE.employee_cd
			) AS F4200_TOTAL_1 ON(
				#TABLE_RESULT.year_month_times		=	@w_year_month_times
			AND #TABLE_RESULT.target_cd				=	F4200_TOTAL_1.employee_cd
			)
		END
		--
		IF @w_i = @w_cnt
		BEGIN
			SET @w_month_str = @w_month_str + '['+ CAST(@w_year_month_times AS nvarchar(20)) + ']'
		END
		ELSE
		BEGIN
			SET @w_month_str = @w_month_str + '['+ CAST(@w_year_month_times AS nvarchar(20)) + '],'
		END
		--
		SET @w_i = @w_i + 1
	END

	-- caculate adequacy_score_avg
	UPDATE #TABLE_RESULT SET 
		adequacy_score_avg	=	CASE 
									WHEN #TABLE_RESULT.total_report <> 0
									THEN ROUND(#TABLE_RESULT.adequacy_score / #TABLE_RESULT.total_report,2)
									ELSE 0
								END
	FROM #TABLE_RESULT
	-- caculate 
	-- year_adequacy_score		
	-- year_total_report		
	-- year_adequacy_score_avg	
	UPDATE #TABLE_RESULT SET 
		year_total_report = ISNULL(TABLE_SUM.total_report,0)
	FROM #TABLE_RESULT
	INNER JOIN (
		SELECT 
			#TABLE_RESULT.target_cd				AS	target_cd
		,	SUM(#TABLE_RESULT.total_report)		AS	total_report
		FROM #TABLE_RESULT
		GROUP BY
			#TABLE_RESULT.target_cd
	) AS TABLE_SUM ON (
		#TABLE_RESULT.target_cd	=	TABLE_SUM.target_cd
	)
	--
	UPDATE #TABLE_RESULT SET 
		year_adequacy_score = ISNULL(TABLE_SUM.adequacy_score,0)
	FROM #TABLE_RESULT
	INNER JOIN (
		SELECT 
			#TABLE_RESULT.target_cd						AS	target_cd
		,	SUM(#TABLE_RESULT.adequacy_score)			AS	adequacy_score
		FROM #TABLE_RESULT
		GROUP BY
			#TABLE_RESULT.target_cd
	) AS TABLE_SUM ON (
		#TABLE_RESULT.target_cd	=	TABLE_SUM.target_cd
	)
	-- AVG FOR YEAR
	UPDATE #TABLE_RESULT SET 
		year_adequacy_score_avg	=	CASE 
										WHEN year_total_report <> 0
										THEN ROUND(year_adequacy_score / year_total_report,2)
										ELSE 0
									END
	FROM #TABLE_RESULT
	-- INERT INTO #TOTAL FOR SHOW LAST ROW
	INSERT INTO #TOTAL
	SELECT 
		#MONTH_MASTER.year_month_times
	,	#MONTH_MASTER.title
	,	ISNULL(TABLE_MONTH_SCORE.adequacy_score,0)
	,	ISNULL(TABLE_MONTH_TOTAL.total_report,0)
	,	0								--	adequacy_score_avg	
	FROM #MONTH_MASTER
	LEFT OUTER JOIN (
		SELECT 
			#TABLE_RESULT.year_month_times			AS	year_month_times
		,	SUM(#TABLE_RESULT.total_report)			AS	total_report
		FROM #TABLE_RESULT
		GROUP BY
			#TABLE_RESULT.year_month_times
	) AS TABLE_MONTH_TOTAL ON (
		#MONTH_MASTER.year_month_times		=	TABLE_MONTH_TOTAL.year_month_times
	)
	LEFT OUTER JOIN (
		SELECT 
			#TABLE_RESULT.year_month_times				AS	year_month_times
		,	SUM(#TABLE_RESULT.adequacy_score)			AS	adequacy_score
		FROM #TABLE_RESULT
		GROUP BY
			#TABLE_RESULT.year_month_times
	) AS TABLE_MONTH_SCORE ON (
		#MONTH_MASTER.year_month_times		=	TABLE_MONTH_SCORE.year_month_times
	)

	-- UPDATE #TOTAL.summited_percent
	UPDATE #TOTAL SET
		adequacy_score_avg	=	CASE 
									WHEN total_report <> 0
									THEN ROUND(adequacy_score / total_report,2)
									ELSE 0
								END
	FROM #TOTAL
	-- GET TOTAL FOOTER 
	SET @w_year_footer_total_report	= (SELECT SUM(#TOTAL.total_report)  FROM #TOTAL)
	SET @w_year_footer_adequacy_score	= (SELECT SUM(#TOTAL.adequacy_score)  FROM #TOTAL)
	IF @w_year_footer_total_report <> 0
	BEGIN
		SET @w_year_footer_adequacy_score_avg	= ROUND(@w_year_footer_adequacy_score / @w_year_footer_total_report,2)
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
COMPLETED:	
	-- SEARCH
	IF @P_mode = 0
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
				,	'+@w_month_str+'
				FROM
				(
					SELECT 
						#TABLE_RESULT.company_cd		AS	company_cd
					,	#TABLE_RESULT.fiscal_year		AS	fiscal_year
					,	#TABLE_RESULT.target_cd			AS	target_cd
					,	#TABLE_RESULT.target_order		AS	target_order
					,	#TABLE_RESULT.target_nm			AS	target_nm
					,	#TABLE_RESULT.year_month_times	AS	year_month_times
					,	''{
							"adequacy_score_avg":"''+CAST(FORMAT(#TABLE_RESULT.adequacy_score_avg,''0.##'') AS nvarchar(20))+''",
							"year_adequacy_score_avg":"''+CAST(FORMAT(#TABLE_RESULT.year_adequacy_score_avg,''0.##'') AS nvarchar(20))+''"
						}''		AS	caculate_result
					FROM #TABLE_RESULT
				) AS P 
				Pivot(MAX(caculate_result) FOR year_month_times IN ('+@w_month_str+')) AS A
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
			CASE 
				WHEN @w_adequacy_type = 1
				THEN IIF(@w_language = 2, 'Adequacy Score', '充実度点数')
				ELSE IIF(@w_language = 2, 'Adequacy Score', '繁忙度点数')
			END														AS	sufficiency_nm 
		,	#TOTAL.year_month_times									AS	year_month_times
		,	#TOTAL.year_month_times_nm								AS	year_month_times_nm
		,	FORMAT(#TOTAL.adequacy_score_avg,'0.##')				AS	adequacy_score_avg
		,	FORMAT(@w_year_footer_adequacy_score_avg,'0.##')		AS	year_footer_adequacy_score_avg
		FROM #TOTAL
	END
	-- OUTPUT EXCEL
	IF @P_mode = 1
	BEGIN
		--[0]
		IF @w_month_str <> ''
		BEGIN
			SET @w_sql = '
				SELECT 
					target_nm
				,	'+@w_month_str+'
				,	year_adequacy_score_avg
				FROM
				(
					SELECT 
						#TABLE_RESULT.company_cd		AS	company_cd
					,	#TABLE_RESULT.fiscal_year		AS	fiscal_year
					,	#TABLE_RESULT.target_cd			AS	target_cd
					,	#TABLE_RESULT.target_order		AS	target_order
					,	#TABLE_RESULT.target_nm			AS	target_nm
					,	#TABLE_RESULT.year_month_times	AS	year_month_times
					,	CAST(FORMAT(#TABLE_RESULT.year_adequacy_score_avg,''0.##'') AS nvarchar(20))	AS	year_adequacy_score_avg
					,	CAST(FORMAT(#TABLE_RESULT.adequacy_score_avg,''0.##'') AS nvarchar(20))			AS	caculate_result
					FROM #TABLE_RESULT
				) AS P 
				Pivot(MAX(caculate_result) FOR year_month_times IN ('+@w_month_str+')) AS A
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
			id				
		,	[year]			
		,	[month]			
		,	times			
		,	year_month_times
		,	month_index		
		,	title			
		,	@P_language as language
		FROM #MONTH_MASTER
		--[2]
		EXEC [dbo].SPC_WeeklyReport_GET_SEARCH_CONDITIONS_INQ1 @P_json , @P_cre_user , @P_company_cd, @w_target_type
		--[3]
		SELECT
			CASE 
				WHEN @w_adequacy_type = 1
				THEN IIF(@w_language = 2, 'Adequacy Score', '充実度点数')
				ELSE IIF(@w_language = 2, 'Adequacy Score', '繁忙度点数')
			END														AS	sufficiency_nm 
		,	#TOTAL.year_month_times									AS	year_month_times
		,	#TOTAL.year_month_times_nm								AS	year_month_times_nm
		,	FORMAT(#TOTAL.adequacy_score_avg,'0.##')				AS	adequacy_score_avg
		,	FORMAT(@w_year_footer_adequacy_score_avg,'0.##')		AS	year_footer_adequacy_score_avg
		FROM #TOTAL
	END
	-- CROSS
	IF @P_mode = 2
	BEGIN
		INSERT INTO #TABLE_CROSS
		SELECT 
			#F4200_TABLE.company_cd
		,	#F4200_TABLE.fiscal_year
		,	#F4200_TABLE.employee_cd
		,	SUM(#F4200_TABLE.point)			--	adequacy_score		
		,	COUNT(#F4200_TABLE.report_no)	--	total_report		
		,	0								--	adequacy_score_avg	
		,	0								--	item_no			
		,	0								--	mark_cd			
		,	0								--	mark_cd_point	
		FROM #F4200_TABLE
		GROUP BY
			#F4200_TABLE.company_cd
		,	#F4200_TABLE.fiscal_year
		,	#F4200_TABLE.employee_cd
		-- UPDATE AVG adequacy_score_avg
		UPDATE #TABLE_CROSS SET 
			adequacy_score_avg = CASE 
									WHEN total_report <> 0
									THEN ROUND((adequacy_score / total_report),2)
									ELSE 0
								END
		FROM #TABLE_CROSS
		-- UPDATE item_no + mark_cd
		SET @w_m4121_cnt = (SELECT COUNT(1) FROM M4121 WHERE company_cd = @P_company_cd AND mark_kbn = @w_adequacy_type AND del_datetime IS NULL)
		-- SET
		SET @w_i = @w_m4121_cnt
		WHILE @w_i >= 1
		BEGIN
			-- RESET @w_point_from & @w_point_to
			SET @w_point_from = 0
			SET @w_point_to = 0
			--
			SELECT
				@w_mark_cd		= ISNULL(M4121.mark_cd,0)
			,	@w_point_from	= ISNULL(M4121.point,0)
			FROM M4121
			WHERE 
				M4121.company_cd	=	@P_company_cd
			AND M4121.mark_kbn		=	@w_adequacy_type
			AND M4121.item_no		=	@w_i
			--
			SET @w_i_minus = @w_i - 1
			--
			SELECT 
				@w_point_to = ISNULL(M4121.point,0) 
			FROM M4121 
			WHERE 
				M4121.company_cd	=	@P_company_cd
			AND M4121.mark_kbn		=	@w_adequacy_type
			AND M4121.item_no		=	@w_i_minus
			--UPDATE #TABLE_CROSS WITH mark_cd + mark_cd_point
			IF @w_point_from = 0
			BEGIN
				UPDATE #TABLE_CROSS SET 
					item_no			= @w_i
				,	mark_cd			= @w_mark_cd
				,	mark_cd_point	= @w_point_from 
				FROM #TABLE_CROSS
				WHERE 
					#TABLE_CROSS.adequacy_score_avg < @w_point_to
			END
			ELSE IF @w_point_to = 0
			BEGIN
				UPDATE #TABLE_CROSS SET
					item_no			= @w_i 
				,	mark_cd			= @w_mark_cd
				,	mark_cd_point	= @w_point_from 
				FROM #TABLE_CROSS
				WHERE 
					#TABLE_CROSS.adequacy_score_avg >= @w_point_from
			END
			ELSE
			BEGIN
				UPDATE #TABLE_CROSS SET 
					item_no			= @w_i
				,	mark_cd			= @w_mark_cd
				,	mark_cd_point	= @w_point_from 
				FROM #TABLE_CROSS
				WHERE 
					#TABLE_CROSS.adequacy_score_avg >= @w_point_from
				AND #TABLE_CROSS.adequacy_score_avg < @w_point_to
			END
			--
			SET @w_i = @w_i - 1
		END
		--[0]
		SELECT
			#TABLE_CROSS.employee_cd			AS	employee_cd
		,	#TABLE_CROSS.item_no				AS	item_no
		,	#TABLE_CROSS.mark_cd				AS	mark_cd
		,	#TABLE_CROSS.mark_cd_point			AS	mark_cd_point
		FROM #TABLE_CROSS
		-- [1] Mark 
		SELECT 
			ISNULL(M4121.item_no,0)		AS	item_no
		,	ISNULL(M4121.mark_cd,0)		AS	mark_cd
		,	ISNULL(M4121.point,0)		AS	point
		FROM M4121 WITH(NOLOCK)
		WHERE 
			M4121.company_cd	=	@P_company_cd
		AND M4121.mark_kbn		=	@w_adequacy_type
		AND M4121.del_datetime IS NULL
		--[2] Mark min infor
		SELECT 
			TOP 1
			ISNULL(M4121.item_no,0)		AS	item_no
		,	ISNULL(M4121.mark_cd,0)		AS	mark_cd
		,	ISNULL(M4121.point,0)		AS	point
		FROM M4121
		WHERE 
			M4121.company_cd	=	@P_company_cd
		AND M4121.mark_kbn		=	@w_adequacy_type
		AND M4121.del_datetime IS NULL
		ORDER BY
			M4121.item_no DESC
	END
	-- DROP
	DROP TABLE #LIST_GRADE
	DROP TABLE #LIST_POSITION
	DROP TABLE #M0070
	DROP TABLE #M0070H
	DROP TABLE #TABLE_ORGANIZATION
	DROP TABLE #MONTH_MASTER
	DROP TABLE #TABLE_RESULT
	DROP TABLE #TABLE_CROSS
	DROP TABLE #F4200_TABLE
	DROP TABLE #LIST_APPROVER
	DROP TABLE #LIST_GROUP
	DROP TABLE #F4100_TABLE
	DROP TABLE #TOTAL
	DROP TABLE #CALENDAR_MASTER
END
GO
