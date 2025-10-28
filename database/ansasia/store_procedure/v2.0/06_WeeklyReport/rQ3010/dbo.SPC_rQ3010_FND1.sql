IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_rQ3010_FND1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_rQ3010_FND1]
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
--*  処理概要/process overview	:	rQ3010_分析（提出率）
--*  
--*  作成日/create date			:	2023/05/24						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*   					
--****************************************************************************************
CREATE PROCEDURE [SPC_rQ3010_FND1]
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
	--
	,	@beginning_date						date				=	NULL
	--,	@current_year						int					=	dbo.FNC_GET_YEAR_WEEKLY_REPORT(@P_company_cd,NULL)
	,	@choice_in_screen					tinyint				=	0
	--
	,	@w_sql								nvarchar(max)		=	''
	,	@w_month_str						nvarchar(100)		=	''
	,	@w_i								int					=	1
	,	@w_date_from						date				=	NULL
	,	@w_date_to							date				=	NULL
	,	@w_month_num						int					=	0
	,	@w_target_type						smallint			=	0	-- 0.組織ごとに集計	1.社員ごとに集計
	,	@w_year_footer_summited_report		money				=	0	--	提出済件
	,	@w_year_footer_total_report			money				=	0	--	報告書件
	,	@w_year_footer_summited_percent		money				=	0	--	提出済率　（100%）
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
	CREATE TABLE #LIST_REPORT_KINDS(
		id								int			identity(1,1)
	,	report_kind						smallint	
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
	--↓↓↓ rQ3010
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
	,	submission_datetime				datetime
	)
	--
	CREATE TABLE #MONTH_MASTER (
		id								int		identity(1,1)
	,	month_num						int
	,	month_num_nm					nvarchar(10)
	,	date_from						date
	,	date_to							date
	)
	--
	CREATE TABLE #TABLE_RESULT (
		id								int		identity(1,1)
	,	company_cd						smallint
	,	fiscal_year						smallint
	,	month_num						int
	--
	,	target_cd						nvarchar(50)			
	,	target_nm						nvarchar(200)
	--
	,	summited_report					money		--	提出済件
	,	total_report					money		--	報告書件
	,	summited_percent				money		--	提出済率　（100%）
	-- YEAR
	,	year_summited_report			money		--	提出済件
	,	year_total_report				money		--	報告書件
	,	year_summited_percent			money		--	提出済率　（100%）
	,	target_order					INT			-- order by
	)
	--
	CREATE TABLE #TABLE_CROSS (
		id								int		identity(1,1)
	,	company_cd						smallint
	,	fiscal_year						smallint
	,	employee_cd						nvarchar(10)
	,	summited_report					money		--	提出済件
	,	total_report					money		--	報告書件
	,	summited_percent				money		--	提出済率　（100%）
	)
	--
	CREATE TABLE #DATA (
		status_nm						NVARCHAR(200)
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
	,	row_type						SMALLINT			-- 0.HEADER 1.DETAIL 2.FOOTER
	)
	--
	CREATE TABLE #TOTAL (
		id								int			identity(1,1)
	,	month_num						int		
	,	month_num_nm					nvarchar(10)
	,	summited_report					money		--	提出済件
	,	total_report					money		--	報告書件
	,	summited_percent				money		--	提出済率　（100%）
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
	-- INSERT DATA INTO #LIST_GROUP
	INSERT INTO #LIST_GROUP
	SELECT json_table.group_cd FROM OPENJSON(@P_json,'$.list_group_cd') WITH(
		group_cd	smallint
	)AS json_table
	WHERE
		json_table.group_cd > 0
	-- INSERT DATA INTO #LIST_REPORT_KINDS
	INSERT INTO #LIST_REPORT_KINDS
	SELECT json_table.report_kind FROM OPENJSON(@P_json,'$.list_report_kind') WITH(
		report_kind	smallint
	)AS json_table
	WHERE
		json_table.report_kind > 0
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
	--PROCESS DATA TO rQ3010
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--
	INSERT INTO #MONTH_MASTER
	EXEC [dbo].SPC_WeeklyReport_GET_YEAR_MONTHS_FND1 @w_fiscal_year,@P_company_cd, @P_cre_user
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
			WHEN ISDATE((CAST(ISNULL(F4200.year,0) AS nvarchar(4)) + '-' + RIGHT('00'+CAST(ISNULL(F4200.month,1) AS nvarchar(4)),2) + '-01')) = 1
			THEN CONVERT(DATE,(CAST(ISNULL(F4200.year,0) AS nvarchar(4)) + '-' + RIGHT('00'+CAST(ISNULL(F4200.month,1) AS nvarchar(4)),2) + '-01'))
			ELSE NULL
		END
	,	F4201.submission_datetime
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
	WHERE 
		F4200.company_cd		=	@P_company_cd
	AND F4200.fiscal_year		=	@w_fiscal_year
	AND F4200.del_datetime IS NULL
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
	-- FITER 報告書種類
	IF EXISTS (SELECT 1 FROM #LIST_REPORT_KINDS)
	BEGIN
		DELETE D FROM #F4200_TABLE AS D
		LEFT OUTER JOIN #LIST_REPORT_KINDS AS S ON (
			D.company_cd		=	@P_company_cd
		AND D.report_kind		=	S.report_kind
		)
		WHERE
			S.report_kind IS NULL
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
		,	#MONTH_MASTER.month_num
		,	ISNULL(#TABLE_ORGANIZATION.organization_cd_1,'')			AS	target_cd
		,	ISNULL(M0020.organization_nm,'')							AS	target_nm
		,	0	--	summited_report		
		,	0	--	total_report		
		,	0	--	summited_percent	
		,	0	--	year_summited_report
		,	0	--	year_total_report	
		,	0	--	year_summited_percent
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
		,	#MONTH_MASTER.month_num
		,	ISNULL(F4200_EMP.employee_cd,'')		AS	target_cd
		,	ISNULL(M0070.employee_nm,'')			AS	target_nm
		,	0	--	summited_report		
		,	0	--	total_report		
		,	0	--	summited_percent	
		,	0	--	year_summited_report
		,	0	--	year_total_report	
		,	0	--	year_summited_percent
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
					#F4200_TABLE.year_month	>=	@w_date_from
				AND #F4200_TABLE.year_month	<=	@w_date_to
				GROUP BY
					#F4200_TABLE.belong_cd1
			) AS F4200_TOTAL_1 ON(
				#TABLE_RESULT.month_num		=	@w_month_num
			AND #TABLE_RESULT.target_cd		=	F4200_TOTAL_1.belong_cd1
			)
			-- UPDATE summited_report
			UPDATE #TABLE_RESULT SET 
				summited_report	=	ISNULL(F4200_TOTAL_1.report_no_cnt,0)
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					#F4200_TABLE.belong_cd1			AS	belong_cd1
				,	COUNT(#F4200_TABLE.report_no)	AS	report_no_cnt
				FROM #F4200_TABLE
				WHERE 
					#F4200_TABLE.year_month	>=	@w_date_from
				AND #F4200_TABLE.year_month	<=	@w_date_to
				AND #F4200_TABLE.submission_datetime IS NOT NULL
				GROUP BY
					#F4200_TABLE.belong_cd1
			) AS F4200_TOTAL_1 ON(
				#TABLE_RESULT.month_num		=	@w_month_num
			AND #TABLE_RESULT.target_cd		=	F4200_TOTAL_1.belong_cd1
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
					#F4200_TABLE.year_month	>=	@w_date_from
				AND #F4200_TABLE.year_month	<=	@w_date_to
				GROUP BY
					#F4200_TABLE.employee_cd
			) AS F4200_TOTAL_1 ON(
				#TABLE_RESULT.month_num		=	@w_month_num
			AND #TABLE_RESULT.target_cd		=	F4200_TOTAL_1.employee_cd
			)
			-- UPDATE summited_report
			UPDATE #TABLE_RESULT SET 
				summited_report		=	ISNULL(F4200_TOTAL_1.report_no_cnt,0)
			FROM #TABLE_RESULT
			INNER JOIN (
				SELECT 
					#F4200_TABLE.employee_cd		AS	employee_cd
				,	COUNT(#F4200_TABLE.report_no)	AS	report_no_cnt
				FROM #F4200_TABLE
				WHERE 
					#F4200_TABLE.year_month	>=	@w_date_from
				AND #F4200_TABLE.year_month	<=	@w_date_to
				AND #F4200_TABLE.submission_datetime IS NOT NULL
				GROUP BY
					#F4200_TABLE.employee_cd
			) AS F4200_TOTAL_1 ON(
				#TABLE_RESULT.month_num		=	@w_month_num
			AND #TABLE_RESULT.target_cd		=	F4200_TOTAL_1.employee_cd
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
	-- caculate summited_percent
	UPDATE #TABLE_RESULT SET 
		summited_percent	=	CASE 
									WHEN #TABLE_RESULT.total_report <> 0
									THEN ROUND(#TABLE_RESULT.summited_report / #TABLE_RESULT.total_report,2) * 100
									ELSE 0
								END
	FROM #TABLE_RESULT
	-- caculate 
	-- year_summited_report
	-- year_total_report	
	-- year_summited_percent
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
		year_summited_report = ISNULL(TABLE_SUM.summited_report,0)
	FROM #TABLE_RESULT
	INNER JOIN (
		SELECT 
			#TABLE_RESULT.target_cd						AS	target_cd
		,	SUM(#TABLE_RESULT.summited_report)			AS	summited_report
		FROM #TABLE_RESULT
		GROUP BY
			#TABLE_RESULT.target_cd
	) AS TABLE_SUM ON (
		#TABLE_RESULT.target_cd	=	TABLE_SUM.target_cd
	)
	-- AVG FOR YEAR
	UPDATE #TABLE_RESULT SET 
		year_summited_percent	=	CASE 
										WHEN year_total_report <> 0
										THEN ROUND(year_summited_report / year_total_report,2) * 100
										ELSE 0
									END
	FROM #TABLE_RESULT
	-- INERT INTO #TOTAL FOR SHOW LAST ROW
	INSERT INTO #TOTAL
	SELECT 
		#MONTH_MASTER.month_num
	,	#MONTH_MASTER.month_num_nm
	,	ISNULL(TABLE_MONTH_SUBMITED.summited_report,0)
	,	ISNULL(TABLE_MONTH_TOTAL.total_report,0)
	,	0								-- summited_percent	
	FROM #MONTH_MASTER
	LEFT OUTER JOIN (
		SELECT 
			#TABLE_RESULT.month_num				AS	month_num
		,	SUM(#TABLE_RESULT.total_report)		AS	total_report
		FROM #TABLE_RESULT
		GROUP BY
			#TABLE_RESULT.month_num
	) AS TABLE_MONTH_TOTAL ON (
		#MONTH_MASTER.month_num		=	TABLE_MONTH_TOTAL.month_num
	)
	LEFT OUTER JOIN (
		SELECT 
			#TABLE_RESULT.month_num				AS	month_num
		,	SUM(#TABLE_RESULT.summited_report)	AS	summited_report
		FROM #TABLE_RESULT
		GROUP BY
			#TABLE_RESULT.month_num
	) AS TABLE_MONTH_SUBMITED ON (
		#MONTH_MASTER.month_num		=	TABLE_MONTH_SUBMITED.month_num
	)
	-- UPDATE #TOTAL.summited_percent
	UPDATE #TOTAL SET
		summited_percent	=	CASE 
									WHEN total_report <> 0
									THEN ROUND(summited_report / total_report,2) * 100
									ELSE 0
								END
	FROM #TOTAL
	-- GET TOTAL FOOTER 
	SET @w_year_footer_total_report	= (SELECT SUM(#TOTAL.total_report)  FROM #TOTAL)
	SET @w_year_footer_summited_report	= (SELECT SUM(#TOTAL.summited_report)  FROM #TOTAL)
	IF @w_year_footer_total_report <> 0
	BEGIN
		SET @w_year_footer_summited_percent	= ROUND(@w_year_footer_summited_report / @w_year_footer_total_report,2) * 100
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
					,	#TABLE_RESULT.month_num			AS	month_num
					,	''{
							"summited_percent":"''+CAST(FORMAT(#TABLE_RESULT.summited_percent,''#0.#'') AS nvarchar(20))+''",
							"year_summited_percent":"''+CAST(FORMAT(#TABLE_RESULT.year_summited_percent,''#0.#'') AS nvarchar(20))+''"
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
		,	#TOTAL.month_num_nm									AS	month_num_nm
		,	FORMAT(#TOTAL.summited_percent,'0.##')				AS	summited_percent
		,	FORMAT(@w_year_footer_summited_percent,'0.##')		AS	year_footer_summited_percent
		FROM #TOTAL
	END
	--OUTPUT EXCEL
	IF @P_mode = 1
	BEGIN
		--[0]
		IF @w_language = 2
		BEGIN
			INSERT INTO #DATA VALUES(N'Submission Rate','','','','','','','','','','','','',N'Yearly Average',0);
		END
		ELSE
		BEGIN
			INSERT INTO #DATA VALUES(N'提出率','','','','','','','','','','','','',N'年度平均',0);
		END
		-- 1
		UPDATE #DATA SET 
			month_no1	=	#MONTH_MASTER.month_num_nm
		FROM #MONTH_MASTER
		WHERE id = 1
		-- 2
		UPDATE #DATA SET 
			month_no2	=	#MONTH_MASTER.month_num_nm
		FROM #MONTH_MASTER
		WHERE id = 2
		-- 3
		UPDATE #DATA SET 
			month_no3	=	#MONTH_MASTER.month_num_nm
		FROM #MONTH_MASTER
		WHERE id = 3
		-- 4
		UPDATE #DATA SET 
			month_no4	=	#MONTH_MASTER.month_num_nm
		FROM #MONTH_MASTER
		WHERE id = 4
		-- 5
		UPDATE #DATA SET 
			month_no5	=	#MONTH_MASTER.month_num_nm
		FROM #MONTH_MASTER
		WHERE id = 5
		-- 6
		UPDATE #DATA SET 
			month_no6	=	#MONTH_MASTER.month_num_nm
		FROM #MONTH_MASTER
		WHERE id = 6
		-- 7
		UPDATE #DATA SET 
			month_no7	=	#MONTH_MASTER.month_num_nm
		FROM #MONTH_MASTER
		WHERE id = 7
		-- 8
		UPDATE #DATA SET 
			month_no8	=	#MONTH_MASTER.month_num_nm
		FROM #MONTH_MASTER
		WHERE id = 8
		-- 9
		UPDATE #DATA SET 
			month_no9	=	#MONTH_MASTER.month_num_nm
		FROM #MONTH_MASTER
		WHERE id = 9
		-- 10
		UPDATE #DATA SET 
			month_no10	=	#MONTH_MASTER.month_num_nm
		FROM #MONTH_MASTER
		WHERE id = 10
		-- 11
		UPDATE #DATA SET 
			month_no11	=	#MONTH_MASTER.month_num_nm
		FROM #MONTH_MASTER
		WHERE id = 11
		-- 12
		UPDATE #DATA SET 
			month_no12	=	#MONTH_MASTER.month_num_nm
		FROM #MONTH_MASTER
		WHERE id = 12
		--LINE DETAIL:
		IF @w_month_str <> ''
		BEGIN
			SET @w_sql = '
				SELECT 
					target_nm
				,	'+@w_month_str+'
				,	year_summited_percent
				,	1
				FROM
				(
					SELECT 
						#TABLE_RESULT.company_cd		AS	company_cd
					,	#TABLE_RESULT.fiscal_year		AS	fiscal_year
					,	#TABLE_RESULT.target_cd			AS	target_cd
					,	#TABLE_RESULT.target_order		AS	target_order
					,	#TABLE_RESULT.target_nm			AS	target_nm
					,	#TABLE_RESULT.month_num			AS	month_num
					,	CAST(FORMAT(#TABLE_RESULT.year_summited_percent,''#0.#'') AS nvarchar(20))	AS	year_summited_percent
					,	CAST(FORMAT(#TABLE_RESULT.summited_percent,''#0.#'') AS nvarchar(20))		AS	caculate_result
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
			--LINE DETAIL:
			INSERT INTO #DATA
			EXEC(@w_sql)
			--LINE TOTAL
			IF @w_language = 2
			BEGIN
				INSERT INTO #DATA VALUES(N'Average','','','','','','','','','','','','','',2);
			END
			ELSE
			BEGIN
				INSERT INTO #DATA VALUES(N'平均','','','','','','','','','','','','','',2);
			END
			--1
			UPDATE #DATA SET 
				month_no1	=	FORMAT(#TOTAL.summited_percent,'0')
			FROM #TOTAL
			WHERE #TOTAL.id = 1
			AND #DATA.row_type = 2
			--2
			UPDATE #DATA SET 
				month_no2	=	FORMAT(#TOTAL.summited_percent,'0')
			FROM #TOTAL
			WHERE #TOTAL.id = 2
			AND #DATA.row_type = 2
			--3
			UPDATE #DATA SET 
				month_no3	=	FORMAT(#TOTAL.summited_percent,'0')
			FROM #TOTAL
			WHERE #TOTAL.id = 3
			AND #DATA.row_type = 2
			--4
			UPDATE #DATA SET 
				month_no4	=	FORMAT(#TOTAL.summited_percent,'0')
			FROM #TOTAL
			WHERE #TOTAL.id = 4
			AND #DATA.row_type = 2
			--5
			UPDATE #DATA SET 
				month_no5	=	FORMAT(#TOTAL.summited_percent,'0')
			FROM #TOTAL
			WHERE #TOTAL.id = 5
			AND #DATA.row_type = 2
			--6
			UPDATE #DATA SET 
				month_no6	=	FORMAT(#TOTAL.summited_percent,'0')
			FROM #TOTAL
			WHERE #TOTAL.id = 6
			AND #DATA.row_type = 2
			--7
			UPDATE #DATA SET 
				month_no7	=	FORMAT(#TOTAL.summited_percent,'0')
			FROM #TOTAL
			WHERE #TOTAL.id = 7
			AND #DATA.row_type = 2
			--8
			UPDATE #DATA SET 
				month_no8	=	FORMAT(#TOTAL.summited_percent,'0')
			FROM #TOTAL
			WHERE #TOTAL.id = 8
			AND #DATA.row_type = 2
			--9
			UPDATE #DATA SET 
				month_no9	=	FORMAT(#TOTAL.summited_percent,'0')
			FROM #TOTAL
			WHERE #TOTAL.id = 9
			AND #DATA.row_type = 2
			--10
			UPDATE #DATA SET 
				month_no10	=	FORMAT(#TOTAL.summited_percent,'0')
			FROM #TOTAL
			WHERE #TOTAL.id = 10
			AND #DATA.row_type = 2
			--11
			UPDATE #DATA SET 
				month_no11	=	FORMAT(#TOTAL.summited_percent,'0')
			FROM #TOTAL
			WHERE #TOTAL.id = 11
			AND #DATA.row_type = 2
			--12
			UPDATE #DATA SET 
				month_no12	=	FORMAT(#TOTAL.summited_percent,'0')
			FROM #TOTAL
			WHERE #TOTAL.id = 12
			AND #DATA.row_type = 2
			-- annual_average
			UPDATE #DATA SET
				annual_average	=	FORMAT(@w_year_footer_summited_percent,'0')
			FROM #DATA
			WHERE 
				#DATA.row_type = 2
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
		,	@P_language		as language
		FROM #DATA
		--[1]
		EXEC [dbo].SPC_WeeklyReport_GET_SEARCH_CONDITIONS_INQ1 @P_json , @P_cre_user , @P_company_cd, @w_target_type
	END
	-- CROSS
	IF @P_mode = 2
	BEGIN
		-- GET #TABLE_CROSS
		INSERT INTO #TABLE_CROSS
		SELECT 
			#F4200_TABLE.company_cd
		,	#F4200_TABLE.fiscal_year
		,	#F4200_TABLE.employee_cd
		,	0					--	summited_report
		,	COUNT(#F4200_TABLE.report_no)
		,	0					--	summited_percent
		FROM #F4200_TABLE
		GROUP BY
			#F4200_TABLE.company_cd
		,	#F4200_TABLE.fiscal_year
		,	#F4200_TABLE.employee_cd	
		-- UPDATE summited_report OF #TABLE_CROSS
		UPDATE #TABLE_CROSS SET 
			summited_report	=	ISNULL(F4200_SUMMITED_CNT.report_no_cnt,0)
		FROM #TABLE_CROSS
		INNER JOIN (
			SELECT 
				#F4200_TABLE.company_cd			AS	company_cd
			,	#F4200_TABLE.fiscal_year		AS	fiscal_year
			,	#F4200_TABLE.employee_cd		AS	employee_cd
			,	COUNT(#F4200_TABLE.report_no)	AS	report_no_cnt
			FROM #F4200_TABLE
			WHERE 
				#F4200_TABLE.submission_datetime IS NOT NULL
			GROUP BY
				#F4200_TABLE.company_cd
			,	#F4200_TABLE.fiscal_year
			,	#F4200_TABLE.employee_cd	
		) AS F4200_SUMMITED_CNT ON (
			#TABLE_CROSS.company_cd			=	F4200_SUMMITED_CNT.company_cd
		AND #TABLE_CROSS.fiscal_year		=	F4200_SUMMITED_CNT.fiscal_year
		AND #TABLE_CROSS.employee_cd		=	F4200_SUMMITED_CNT.employee_cd
		)
		-- UPDATE summited_percent OF #TABLE_CROSS
		UPDATE #TABLE_CROSS SET 
			summited_percent	=	CASE 
										WHEN total_report <> 0
										THEN ROUND((summited_report/total_report),2)*100
										ELSE 0
									END
		FROM #TABLE_CROSS

		SELECT
			#TABLE_CROSS.employee_cd
		,	#TABLE_CROSS.summited_percent		AS	finished_percent
		FROM #TABLE_CROSS 
	END
	-- DROP
	DROP TABLE #LIST_GRADE
	DROP TABLE #LIST_POSITION
	DROP TABLE #M0070
	DROP TABLE #M0070H
	DROP TABLE #TABLE_ORGANIZATION
	DROP TABLE #MONTH_MASTER
	DROP TABLE #TABLE_RESULT
	DROP TABLE #DATA
	DROP TABLE #TABLE_CROSS
	DROP TABLE #F4200_TABLE
	DROP TABLE #LIST_APPROVER
	DROP TABLE #LIST_GROUP
	DROP TABLE #LIST_REPORT_KINDS
	DROP TABLE #TOTAL
END
GO
