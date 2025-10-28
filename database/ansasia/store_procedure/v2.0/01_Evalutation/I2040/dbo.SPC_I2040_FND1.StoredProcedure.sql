DROP PROCEDURE [SPC_I2040_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ 
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	SHOW/HIDE ITEM 
--*  
--*  作成日/create date			:	2018/10/08						
--*　作成者/creater				:	dattnt								
--*   					
--*  更新日/update date			:	2021/04/01
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	F0201データが存在しない、または、F0201.confirm_datetime IS NULL の時は 
--*								:	M0100.target_evaluation_typ＝１の一番大きい数字＝最終評価者として、F0200を参照する。       F0200.point_sum + F0200.adjust_point
--*								:	F0201.confirm_datetime IS NOT NULL の時は、F0201.point_sumを表示する。
--*
--*  更新日/update date			:	2021/04/02
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	when authority_typ = 3 (admin) & authority=0,1(I2040) -> set authority_typ = 2 (rater)
--*   					
--*  更新日/update date			:	2021/06/03
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
--*   					
--*  更新日/update date			:	2021/07/28
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when ５.総合管理者(authority_typ = 5) then set rater_step = 5
--*   					
--*  更新日/update date			:	2021/09/01
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	fix show rank_json when only 最終評価
--*   					
--*  更新日/update date			:	2022/03/31
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when admin is rater then show all employees who you evalutate
--*   					
--*  更新日/update date			:	2022/08/08
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	change 評価ステップ to mulitiselect
--*   					
--*  更新日/update date			:	2022/08/16
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	upgrade 1.9
--*   					
--*  更新日/update date			:	2022/10/24
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	In part , login user not view completed sheet when login user is not rater of sheet
--*   					
--*  更新日/update date			:	2023/04/10
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	FIX BUG
--*   					
--*  更新日/update date			:	2023/04/24
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	F0011.use_typ=1 AND F0011.sheet_use_typ = 0 の処遇用途の場合は、
--*									M0070.evaluated_typ=1の社員の年度の最終日時点の属性情報を表示する（年度最終日時点に退職している社員は表示対象外とする）
--*   					
--*  更新日/update date			:	2023/06/02
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	fix bug rater is not view part data
--*   					
--*  更新日/update date			:	2023/11/20
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	FIX BUG WHEN LAST EVAL NOT SHOW TEMPORARY SAVE
--*   					
--*  更新日/update date			:	2024/02/22
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	総合評価の詳細設計書「特記事項」シートの「※２評価点の算出」21行目、
--*									※F0200データが存在する場合、F0200.point_sum=0の場合は上記ロジックで算出する。
--*									の仕様を、F0201でも同様にしてほしいです。
--*   					
--*  更新日/update date			:	2024/06/10
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	fix bug treat
--*   					
--*  更新日/update date			:	2025/10/27
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	fix point_sum5 not equals point_sum + adjust_point
--*   		
--****************************************************************************************
CREATE PROCEDURE [SPC_I2040_FND1]
	@P_json						nvarchar(max)	=	''
,	@P_company_cd				smallint		=	0
,	@P_user_id					nvarchar(50)	=	''
,	@P_current_page				smallint		=	0
,	@P_page_size				smallint		=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@w_time								DATETIME2		=	SYSDATETIME()
	,	@status_cd							smallint		=	0
	,	@authority_typ						SMALLINT		=	0
	,	@employee_cd						NVARCHAR(20)	=	''
	,	@authority_cd						SMALLINT		=	0
	,	@authority							SMALLINT		=	0
	,	@login_user_typ						smallint		=	1	--	1. 被評価者用 2.評価者用
	,	@w_提出済状況						tinyint			=	0	--	0.未提出　1.提出済
	,	@w_承認済状況						tinyint			=	0	--	0.未承認　1.承認済
	--
	,	@string_column						nvarchar(max)	=	''
	,	@string_sql							nvarchar(max)	=	''
	,	@step								int				=	0
	,	@fiscal_year						int				=	0
	,	@employee_typ						int				=	0
	,	@totalRecord						bigint			=	0
	,	@pageNumber							int				=	0
	,	@year_month_day						date			=	NULL
	,	@login_position_cd					INT				=	0
	,	@arrange_order						int				=	0
	,	@use_typ							INT				=	0
	,	@beginning_date						date			=	NULL
	,	@start_date							date			=	NULL
	,	@current_year						int				=	DATEPART(YYYY,GETDATE())
	,	@screen_employee					nvarchar(20)	=	''
	,	@screen_rater						nvarchar(20)	=	''
	,	@screen_evalute_step_1				int				=	0	-- add by viettd 2022/08/08
	,	@screen_evalute_step_2				int				=	0	-- add by viettd 2022/08/08
	,	@screen_evalute_step_3				int				=	0	-- add by viettd 2022/08/08
	,	@screen_evalute_step_4				int				=	0	-- add by viettd 2022/08/08
	,	@screen_evalute_step_5				int				=	0	-- add by viettd 2022/08/08
	,	@screen_rank						int				=	0
	,	@temp_year							INT				=	0
	,	@search_emp_auth					INT				=	0
	,	@search_emp_user					NVARCHAR(50)	=	''
	,	@YEAR								smallint		=	0  --2020.01.09 add
	,	@treat1								INT				=	0
	,	@treat2								INT				=	0
	,	@treat3								INT				=	0
	,	@choice_in_screen					INT				=	0
	,	@adjust_point						INT				=	0
	,	@i									INT				=	0
	,	@max_rater_status_1					INT				=	0
	-- add by viettd 2021/06/03
	,	@w_evaluation_organization_cnt		INT				=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT		=	0
	--
	CREATE TABLE #TREATMENT_NO(
		id				INT IDENTITY(1,1)
	,	treatment_no	INT
	)
	CREATE TABLE #POSITION_CD(
		id				INT IDENTITY(1,1)
	,	position_cd		INT
	)
	CREATE TABLE #GRADE(
		id				INT IDENTITY(1,1)
	,	grade			INT
	)
	CREATE TABLE #TEMP_F0120(
		id							int		identity(1,1)
	,	company_cd					int
	,	fiscal_year					int
	,	employee_cd					nvarchar(20)
	,	sheet_cd					int
	,	treatment_applications_no	int
	,	group_point_sum				NVARCHAR(200)
	,	sheet_nm					NVARCHAR(50)
	,	rank_sheet					INT
	)
	CREATE TABLE #F0120_SHEET_CD(
		sheet_cd		int
	,	sheet_nm		nvarchar(50)
	)
	CREATE TABLE #TMP_POINT_SUM(
		id							int		identity(1,1)
	,	company_cd					int
	,	fiscal_year					int
	,	employee_cd					nvarchar(20)
	,	evaluation_step				int
	,	treatment_applications_no	int
	,	point_sum					numeric(8,2)
	,	adjust_point				numeric(8,2)
	,	rank_kinds					int
	,	rank_nm						nvarchar(20)
	)
	CREATE TABLE #TMP_POINT_SUM_FINAL_最終(
		id							int		identity(1,1)
	,	company_cd					int
	,	fiscal_year					int
	,	employee_cd					nvarchar(20)
	,	evaluation_step				int
	,	treatment_applications_no	int
	,	point_sum					numeric(8,2)
	,	adjust_point				numeric(8,2)
	,	rank_kinds					int
	,	rank_nm						nvarchar(20)
	,	confirm_datetime			datetime			-- add by viettd 2021/04/01
	)
	CREATE TABLE #SCREEN_EMPLOYEE(
		employee			nvarchar(20)
	,	evaluation_step		int
	)
	CREATE TABLE #STEP_LOGIN(
		employee_cd						nvarchar(20)
	,	treatment_applications_no		smallint
	,	evaluation_step					int
	,	max_step						int
	)
	--#M0071_SHEET
	CREATE TABLE #M0071_SHEET(
		company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	fiscal_year						int
	,	sheet_cd						smallint
	,	application_date				date
	,	employee_nm						nvarchar(200)
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
	--F0100 m0070 m0060 m0020 m0030 m0040 m0050 f0200 m0102
	CREATE TABLE #TABLE_RESULT(
		id								INT			IDENTITY(1,1)
	,	company_cd						SMALLINT
	,	employee_cd						NVARCHAR(20)
	,	employee_cd_order_by			NVARCHAR(22)
	,	furigana						NVARCHAR(50)
	,	fiscal_year						INT
	,	sheet_cd						INT
	,	employee_nm						NVARCHAR(200)
	,	employee_typ_nm					NVARCHAR(50)
	,	employee_typ					INT
	,	belong1_nm						NVARCHAR(50)
	,	belong_cd1						NVARCHAR(20)
	,	belong2_nm						NVARCHAR(50)
	,	belong_cd2						NVARCHAR(20)
	,	belong3_nm						NVARCHAR(50)
	,	belong_cd3						NVARCHAR(20)
	,	belong4_nm						NVARCHAR(50)
	,	belong_cd4						NVARCHAR(20)
	,	belong5_nm						NVARCHAR(50)
	,	belong_cd5						NVARCHAR(20)
	,	job_nm							NVARCHAR(50)
	,	job_cd							INT
	,	position_nm						NVARCHAR(50)
	,	position_cd						INT
	,	grade_nm						NVARCHAR(10)
	,	grade							INT
	--	add by viettd 2022/08/16
	,	sheet_employee_typ_nm			NVARCHAR(50)
	,	sheet_employee_typ				INT
	,	sheet_belong1_nm				NVARCHAR(50)
	,	sheet_belong_cd1				NVARCHAR(20)
	,	sheet_belong2_nm				NVARCHAR(50)
	,	sheet_belong_cd2				NVARCHAR(20)
	,	sheet_belong3_nm				NVARCHAR(50)
	,	sheet_belong_cd3				NVARCHAR(20)
	,	sheet_belong4_nm				NVARCHAR(50)
	,	sheet_belong_cd4				NVARCHAR(20)
	,	sheet_belong5_nm				NVARCHAR(50)
	,	sheet_belong_cd5				NVARCHAR(20)
	,	sheet_job_nm					NVARCHAR(50)
	,	sheet_job_cd					INT
	,	sheet_position_nm				NVARCHAR(50)
	,	sheet_position_cd				INT
	,	sheet_grade_nm					NVARCHAR(10)
	,	sheet_grade						INT
	--
	,	point_sum1						NUMERIC(8,2)
	,	adjust_point1					NUMERIC(8,2)
	,	rank_kinds1						SMALLINT
	,	rank_nm1						NVARCHAR(20)
	,	adjustpoint_input_1				INT
	,	rank_change_1					INT
	,	adjustpoint_from_1				NUMERIC(8,2)
	,	adjustpoint_to_1				NUMERIC(8,2)
	,	point_sum2						NUMERIC(8,2)
	,	adjust_point2					NUMERIC(8,2)
	,	rank_kinds2						SMALLINT
	,	rank_nm2						NVARCHAR(20)
	,	adjustpoint_input_2				INT
	,	rank_change_2					INT
	,	adjustpoint_from_2				NUMERIC(8,2)
	,	adjustpoint_to_2				NUMERIC(8,2)
	,	point_sum3						NUMERIC(8,2)
	,	adjust_point3					NUMERIC(8,2)
	,	rank_kinds3						SMALLINT
	,	rank_nm3						NVARCHAR(20)
	,	adjustpoint_input_3				INT
	,	rank_change_3					INT
	,	adjustpoint_from_3				NUMERIC(8,2)
	,	adjustpoint_to_3				NUMERIC(8,2)
	,	point_sum4						NUMERIC(8,2)
	,	adjust_point4					NUMERIC(8,2)
	,	rank_kinds4						SMALLINT
	,	rank_nm4						NVARCHAR(20)
	,	adjustpoint_input_4				INT
	,	rank_change_4					INT
	,	adjustpoint_from_4				NUMERIC(8,2)
	,	adjustpoint_to_4				NUMERIC(8,2)
	,	point_sum5						NUMERIC(8,2)
	,	adjust_point5					NUMERIC(8,2)
	,	rank_kinds5						SMALLINT
	,	rank_nm5						NVARCHAR(20)
	,	final_evaluation_can_edited		TINYINT				-- 0.not view 1.view  2.can edited
	,	comment							NVARCHAR(800)
	,	treatment_applications_no		TINYINT
	,	treatment_applications_nm		NVARCHAR(50)
	,	rater_status					INT
	,	final_rater_status				INT					-- 5.最終評価者
	,	rater_step						INT
	,	confirm_typ						INT					-- 0.未確定| 1.確定（F0200 + F0201）
	,	max_rate_status					INT
	,	confirm_last_step				INT
	,	m0100_step						INT
	,	feed_back_status				INT
	,	max_feedback_status				INT
	,	part_status						INT
	,	last_comment					NVARCHAR(800)
	,	data_f0201_status				INT					-- 0.not exists F0201 | 1.exists in F0201  when confirm_datetime is null | 2.exist in F0201 when confirm_datetime is not null
	,	max_last_confirm				INT
	,	rank_prev_1_nm					NVARCHAR(20)
	,	rank_prev_2_nm					NVARCHAR(20)
	,	rank_prev_3_nm					NVARCHAR(20)
	,	sheet_use_typ					INT
	,	accept_input					INT
	,	confirm_last_step_final			INT	
	,	current_rater_step				INT
	,	confirm_at_step					INT
	--
	,	sheet_kbn						TINYINT			-- add by viettd 2022/10/24
	,	status_cd						SMALLINT		-- add by viettd 2022/10/24
	,	rater_employee_cd_1				NVARCHAR(10)	-- add by viettd 2022/10/24
	,	rater_employee_cd_2				NVARCHAR(10)	-- add by viettd 2022/10/24
	,	rater_employee_cd_3				NVARCHAR(10)	-- add by viettd 2022/10/24
	,	rater_employee_cd_4				NVARCHAR(10)	-- add by viettd 2022/10/24
	,	current_year_is_rater			TINYINT			-- add by viettd 2022/10/24
	)
	CREATE TABLE #TEMP_RANK (
		treatment_applications_no	INT
	,	rank_json					NVARCHAR(MAX)

	)
	CREATE TABLE #F0032(
		company_cd					INT
	,	fiscal_year					INT
	,	treatment_applications_no	INT
	,	group_cd					INT
	,	employee_cd					NVARCHAR(50)
	,	sheet_cd					INT
	,	weight						INT
	)
	
	CREATE TABLE #TABLE_ORGANIZATION(
		organization_typ			tinyint
	,	organization_cd_1			nvarchar(20)
	,	organization_cd_2			nvarchar(20)
	,	organization_cd_3			nvarchar(20)
	,	organization_cd_4			nvarchar(20)
	,	organization_cd_5			nvarchar(20)	 
	,	choice_in_screen			tinyint		-- 1.choice in screen 0.get from master S0022
	)
	--↓↓↓ add by viettd 2022/08/08
	CREATE TABLE #TABLE_EVALUATION_STEP (
		id					int			identity(1,1)
	,	evaluation_step		smallint
	)
	--
	INSERT INTO #TABLE_ORGANIZATION
	EXEC SPC_REFER_ORGANIZATION_FND1 @P_json,@P_user_id,@P_company_cd

	--
	CREATE TABLE #TEMP_M0072(
		employee_cd		NVARCHAR(20)
	)
	-- processing search in M0072 
	INSERT INTO  #TEMP_M0072
	EXEC SPC_ALTERNATIVE_ITEM_FIND1 @P_json,@P_company_cd,0
	--
	SET @treat1 = JSON_VALUE(@P_json,'$.treat1')
	SET @treat2 = JSON_VALUE(@P_json,'$.treat2')
	SET @treat3 = JSON_VALUE(@P_json,'$.treat3')
	SET @fiscal_year			=	JSON_VALUE(@P_json,'$.fiscal_year')
	SET @employee_typ			=	JSON_VALUE(@P_json,'$.employee_typ')
	SET	@screen_employee		=	JSON_VALUE(@P_json,'$.employee_cd')
	SET	@screen_rater			=	JSON_VALUE(@P_json,'$.rater')
	--SET	@screen_evalute_step	=	JSON_VALUE(@P_json,'$.evalute_step'
	SET	@screen_rank			=	JSON_VALUE(@P_json,'$.rank')
	--
	SELECT 
		@search_emp_auth = s0010.authority_typ
	,	@search_emp_user = user_id
	FROM S0010
	WHERE s0010.employee_cd = @screen_rater
	AND s0010.company_cd = @P_company_cd
	AND del_datetime IS NULL
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
		SET @start_date = CAST((CAST(@fiscal_year AS nvarchar(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		SET @year_month_day = CAST((CAST(@fiscal_year AS nvarchar(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		SET @year_month_day = DATEADD(DD,-1,DATEADD(YYYY,1,@year_month_day))
	END
	ELSE
	BEGIN 
		SET @year_month_day = CAST((CAST(@fiscal_year AS nvarchar(4)) + '/12/31') AS DATE)
		SET @start_date		= CAST((CAST(@fiscal_year AS nvarchar(4)) + '/01/01') AS DATE)
	END
	--↓2020.01.09 add
	SET @YEAR =  YEAR(@w_time) 
	IF (CAST(CONVERT(NVARCHAR(4),(@YEAR))+'-'+FORMAT(@beginning_date,'MM-dd') AS DATE) <= @w_time) OR @beginning_date IS NULL
	BEGIN
      SET @current_year = @YEAR
	END
	ELSE
	BEGIN
      SET @current_year = @YEAR-1 
	END
	--
	INSERT INTO #TABLE_EVALUATION_STEP
	SELECT
		[row].evalute_step												
	FROM OPENJSON(@P_json,'$.list_evalute_step') WITH(			
		evalute_step				smallint
	) AS [row] 
	--
	INSERT INTO #TREATMENT_NO
		SELECT
			[row].treatment_applications_no												
		FROM OPENJSON(@P_json,'$.list_treatment_applications_no') WITH(			
			treatment_applications_no				INT
		) AS [row] 
	--↑2020.01.09 add
	--
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @year_month_day,'',@P_company_cd
	--GET HISTORY OF M0070
	INSERT INTO #M0071_SHEET
	EXEC [dbo].SPC_REFER_M0071_INQ1 @fiscal_year,'',0,@P_company_cd
	--
	INSERT INTO #F0032
	SELECT
		M0070.company_cd
	,	ISNULL(F0032.fiscal_year,@fiscal_year)
	,	#TREATMENT_NO.treatment_no
	,	MAX(group_cd)
	,	M0070.employee_cd
	,	F0032.sheet_cd
	,	F0032.[weight]
	FROM M0070 
	CROSS JOIN #TREATMENT_NO
	LEFT JOIN F0032 ON(
		@P_company_cd				=	F0032.company_cd			
	AND @fiscal_year				=	F0032.fiscal_year
	AND M0070.employee_cd			=	F0032.employee_cd
	AND #TREATMENT_NO.treatment_no	=	F0032.treatment_applications_no
	AND F0032.del_datetime IS NULL
	)
	WHERE 
		M0070.company_cd	=	@P_company_cd
	AND M0070.del_datetime IS NULL
	GROUP BY	
		M0070.company_cd
	,	F0032.fiscal_year
	,	#TREATMENT_NO.treatment_no
	,	M0070.employee_cd
	,	F0032.detail_no
	,	F0032.sheet_cd
	,	F0032.[weight]
	--
	SELECT 
		@authority_typ		=	ISNULL(authority_typ,0) 
	,	@employee_cd		=	ISNULL(M0070.employee_cd,-1)
	,	@authority_cd		=	ISNULL(S0010.authority_cd,0)
	,	@login_position_cd	=	ISNULL(M0070.position_cd,0)
	FROM S0010 
	LEFT JOIN M0070 ON (
		M0070.company_cd		=	S0010.company_cd
	AND M0070.employee_cd		=	S0010.employee_cd
	AND M0070.del_datetime		IS NULL 
	) 
	WHERE 
		S0010.user_id		= @P_user_id 
	AND S0010.company_cd	= @P_company_cd 
	AND S0010.del_datetime  IS NULL
	-- 
	SELECT 
		@authority = ISNULL(authority,0)
	FROM S0021
	WHERE 
		S0021.company_cd	= @P_company_cd
	AND S0021.authority_cd	= @authority_cd
	AND S0021.function_id	= 'I2040'
	AND S0021.del_datetime IS NULL
	-- ↓↓↓　add by viettd 2021/04/02
	-- 0.NOT VIEW 1.ONLY VIEW 2.EDITED
	IF @authority_typ = 3 AND @authority = 0 
	BEGIN
		SET @authority_typ = 2	-- RATER
	END
	-- ↑↑↑　end add by viettd 2021/04/02
	-- ↓↓↓　add by viettd 2022/08/16
	-- WHEN 6.管理者（評価者権限）THEN SET @authority_typ = 2.評価者
	IF @authority_typ = 6 
	BEGIN
		SET @authority_typ = 2	-- RATER
	END
	-- ↑↑↑　end add by viettd 2022/08/16
	--GET arrange_oder
	SELECT 
		@arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@login_position_cd
	AND M0040.del_datetime IS NULL
	--GET use_type
	SELECT 
		@use_typ		=	ISNULL(S0020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
	FROM S0020
	WHERE
		S0020.company_cd		=	@P_company_cd
	AND S0020.authority_cd		=	@authority_cd
	AND S0020.del_datetime IS NULL
	-- COUNT ALL ORGANIZATIONS OF S0022 -- add by viettd 2021/06/03
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@authority_cd,1)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@authority_cd,1)
	---
	INSERT INTO #POSITION_CD
	SELECT
		[row].position_cd												
	FROM OPENJSON(@P_json,'$.list_position_cd') WITH(			
		position_cd					INT
	) AS [row]
	--
	INSERT INTO #GRADE
	SELECT
		[row].grade												
	FROM OPENJSON(@P_json,'$.list_grade') WITH(			
		grade						INT
	) AS [row]
	--	GET STEP OF M0100
	IF EXISTS(SELECT 1 FROM M0100 WHERE company_cd	= @P_company_cd AND (target_evaluation_typ_1	=	1 OR evaluation_typ_1 = 1))
	BEGIN
		SET @step	=	1
	END
	IF EXISTS(SELECT 1 FROM M0100 WHERE company_cd	= @P_company_cd AND (target_evaluation_typ_2	=	1 OR evaluation_typ_2 = 1))
	BEGIN
		SET @step	=	2
	END
	IF EXISTS(SELECT 1 FROM M0100 WHERE company_cd	= @P_company_cd AND (target_evaluation_typ_3	=	1 OR evaluation_typ_3 = 1))
	BEGIN
		SET @step	=	3
	END
	IF EXISTS(SELECT 1 FROM M0100 WHERE company_cd	= @P_company_cd AND (target_evaluation_typ_4	=	1 OR evaluation_typ_4 = 1))
	BEGIN
		SET @step	=	4
	END
	-- add by viettd 2022/08/08
	SELECT @screen_evalute_step_1	=	ISNULL(#TABLE_EVALUATION_STEP.evaluation_step,0) FROM #TABLE_EVALUATION_STEP WHERE evaluation_step = 1
	SELECT @screen_evalute_step_2	=	ISNULL(#TABLE_EVALUATION_STEP.evaluation_step,0) FROM #TABLE_EVALUATION_STEP WHERE evaluation_step = 2
	SELECT @screen_evalute_step_3	=	ISNULL(#TABLE_EVALUATION_STEP.evaluation_step,0) FROM #TABLE_EVALUATION_STEP WHERE evaluation_step = 3
	SELECT @screen_evalute_step_4	=	ISNULL(#TABLE_EVALUATION_STEP.evaluation_step,0) FROM #TABLE_EVALUATION_STEP WHERE evaluation_step = 4
	SELECT @screen_evalute_step_5	=	ISNULL(#TABLE_EVALUATION_STEP.evaluation_step,0) FROM #TABLE_EVALUATION_STEP WHERE evaluation_step = 5
	-- INSERT DATA INTO TEMP TABLE
	INSERT INTO #TABLE_RESULT
	SELECT
		M0070.company_cd																				
	,	M0070.employee_cd
	,	CASE ISNUMERIC(M0070.employee_cd) 
		   WHEN 1 
		   THEN 'A'+ISNULL(M0070.employee_cd,'')	
		   ELSE 'B'+ISNULL(M0070.employee_cd,'')	
		END			
	,	#M0070H.furigana																								
	,	@fiscal_year																				
	,	F0100.sheet_cd																								
	,	#M0070H.employee_nm																				
	,	#M0070H.employee_typ_nm	
	,	#M0070H.employee_typ																						
	,	CASE WHEN ISNULL(M1.organization_ab_nm,'') <> ''
			 THEN  M1.organization_ab_nm
			 ELSE  M1.organization_nm	
		END	
	,	#M0070H.belong_cd_1	
	,	CASE WHEN ISNULL(M2.organization_ab_nm,'') <> ''
			 THEN  M2.organization_ab_nm
			 ELSE  M2.organization_nm	
		END																		
	,	#M0070H.belong_cd_2	
	,	CASE WHEN ISNULL(M3.organization_ab_nm,'') <> ''
			 THEN  M3.organization_ab_nm
			 ELSE  M3.organization_nm	
		END																		
	,	#M0070H.belong_cd_3	
	,	CASE WHEN ISNULL(M4.organization_ab_nm,'') <> ''
			 THEN  M4.organization_ab_nm
			 ELSE  M4.organization_nm	
		END																		
	,	#M0070H.belong_cd_4	
	,	CASE WHEN ISNULL(M5.organization_ab_nm,'') <> ''
			 THEN  M5.organization_ab_nm
			 ELSE  M5.organization_nm	
		END																		
	,	#M0070H.belong_cd_5	
	,	CASE WHEN ISNULL(M0030.job_ab_nm,'') <> ''
			 THEN  M0030.job_ab_nm
			 ELSE  M0030.job_nm	
		END																					
	,	#M0070H.job_cd
	,	CASE WHEN ISNULL(M0040.position_ab_nm,'') <> ''
			 THEN  M0040.position_ab_nm
			 ELSE  M0040.position_nm	
		END																					
	,	#M0070H.position_cd																			
	,	#M0070H.grade_nm		
	,	#M0070H.grade																			
	--
	,	#M0071_SHEET.employee_typ_nm	
	,	#M0071_SHEET.employee_typ																						
	,	CASE WHEN ISNULL(M1_SHEET.organization_ab_nm,'') <> ''
			 THEN  M1_SHEET.organization_ab_nm
			 ELSE  M1_SHEET.organization_nm	
		END	
	,	#M0071_SHEET.belong_cd1	
	,	CASE WHEN ISNULL(M2_SHEET.organization_ab_nm,'') <> ''
			 THEN  M2_SHEET.organization_ab_nm
			 ELSE  M2_SHEET.organization_nm	
		END																		
	,	#M0071_SHEET.belong_cd2	
	,	CASE WHEN ISNULL(M3_SHEET.organization_ab_nm,'') <> ''
			 THEN  M3_SHEET.organization_ab_nm
			 ELSE  M3_SHEET.organization_nm	
		END																		
	,	#M0071_SHEET.belong_cd3	
	,	CASE WHEN ISNULL(M4_SHEET.organization_ab_nm,'') <> ''
			 THEN  M4_SHEET.organization_ab_nm
			 ELSE  M4_SHEET.organization_nm	
		END																		
	,	#M0071_SHEET.belong_cd4	
	,	CASE WHEN ISNULL(M5_SHEET.organization_ab_nm,'') <> ''
			 THEN  M5_SHEET.organization_ab_nm
			 ELSE  M5_SHEET.organization_nm	
		END																		
	,	#M0071_SHEET.belong_cd5	

	,	CASE WHEN ISNULL(M0030_SHEET.job_ab_nm,'') <> ''
			 THEN  M0030_SHEET.job_ab_nm
			 ELSE  M0030_SHEET.job_nm	
		END																					
	,	#M0071_SHEET.job_cd
	,	CASE WHEN ISNULL(M0040_SHEET.position_ab_nm,'') <> ''
			 THEN  M0040_SHEET.position_ab_nm
			 ELSE  M0040_SHEET.position_nm	
		END																					
	,	#M0071_SHEET.position_cd																			
	,	#M0071_SHEET.grade_nm		
	,	#M0071_SHEET.grade															
	--
	,	0																	--point_sum1					
	,	0																	--adjust_point1				
	,	0																	--rank_kinds1	
	,	''			
	,	M0100.adjustpoint_input_1																		
	,	M0100.rank_change_1																				
	,	M0100.adjustpoint_from_1																		
	,	M0100.adjustpoint_to_1																			
	,	0																	--point_sum2					
	,	0																	--adjust_point2				
	,	0																	--rank_kinds2
	,	''				
	,	M0100.adjustpoint_input_2																		
	,	M0100.rank_change_2																				
	,	M0100.adjustpoint_from_2																		
	,	M0100.adjustpoint_to_2																			
	,	0																	--point_sum3					
	,	0																	--adjust_point3				
	,	0																	--rank_kinds3	
	,	''			
	,	M0100.adjustpoint_input_3																		
	,	M0100.rank_change_3																				
	,	M0100.adjustpoint_from_3																		
	,	M0100.adjustpoint_to_3																			
	,	0																	--point_sum4					
	,	0																	--adjust_point4				
	,	0																	--rank_kinds4
	,	''				
	,	M0100.adjustpoint_input_4																		
	,	M0100.rank_change_4																				
	,	M0100.adjustpoint_from_4																		
	,	M0100.adjustpoint_to_4																			
	,	0																	--point_sum5					
	,	0																	--adjust_point5				
	,	0																	--rank_kinds5	
	,	''																	--rank_nm5
	,	0																	--final_evaluation_can_edited	add by viettd 2021/04/02				
	,	''																	--comment
	,	#F0032.treatment_applications_no																	
	,	M0102.treatment_applications_nm										--treatment_applications_no																	
	,	CASE
			WHEN @authority_typ = 5 THEN 0 -- edited by viettd 2021/07/28
			WHEN @authority_typ IN (3,4) THEN 0	-- add by viettd 2022/08/16

			WHEN F0100.rater_employee_cd_1 = @employee_cd AND (@screen_evalute_step_1 = 1 OR (F0200_1.confirm_datetime IS NULL)) THEN 1
			WHEN F0100.rater_employee_cd_2 = @employee_cd AND (@screen_evalute_step_2 = 2 OR (F0200_2.confirm_datetime IS NULL)) THEN 2
			WHEN F0100.rater_employee_cd_3 = @employee_cd AND (@screen_evalute_step_3 = 3 OR (F0200_3.confirm_datetime IS NULL)) THEN 3
			WHEN F0100.rater_employee_cd_4 = @employee_cd AND (@screen_evalute_step_4 = 4 OR (F0200_4.confirm_datetime IS NULL)) THEN 4
			ELSE 0 
		END												AS	rater_status
	,	CASE 
			WHEN @authority_typ IN (3,4,5)	-- 会社管理者と総合管理者 
			THEN 5
			--WHEN (@authority_typ = 3)
			--	 AND										-- NOT　評価者
			--	 (
			--	 	(
			--			F0100.rater_employee_cd_1 <> @employee_cd	
			--		AND F0100.rater_employee_cd_2 <> @employee_cd 
			--		AND F0100.rater_employee_cd_3 <> @employee_cd 
			--		AND F0100.rater_employee_cd_4 <> @employee_cd 
			--	 	)
			--	 OR F0011.sheet_use_typ <> 1				-- NOT USE SHEET
			--	 ) 
			--	 AND M0070.employee_cd <> @employee_cd	-- NOT　被評価者
			--THEN 5
			ELSE 0
		END												AS	final_rater_status
	,	CASE 
		WHEN @authority_typ IN(3,4,5) THEN 0
		WHEN F0100.rater_employee_cd_4 = @employee_cd AND @authority_typ <> 5 THEN 4
		WHEN F0100.rater_employee_cd_3 = @employee_cd AND @authority_typ <> 5 THEN 3
		WHEN F0100.rater_employee_cd_2 = @employee_cd AND @authority_typ <> 5 THEN 2
		WHEN F0100.rater_employee_cd_1 = @employee_cd AND @authority_typ <> 5 THEN 1
		ELSE 0 
		END												AS	rater_step
	--↑↑↑ end edited by viettd 2021/07/28
	,	0
	,	0				--	maxratestatus
	,	0
	,	@step
	,	0
	,	0
	,	0
	,	''
	,	0
	,	0
	,	W_M0130_3.rank_nm
	,	W_M0130_2.rank_nm
	,	W_M0130_1.rank_nm
	,	F0011.sheet_use_typ
	,	0						AS	accept_input
	,	0						AS	confirm_last_step_final
	,	CASE 
			WHEN F0200_1.confirm_datetime IS NULL AND @step >= 1 AND F0100.rater_employee_cd_1 <> '' THEN 1
			WHEN F0200_2.confirm_datetime IS NULL AND @step >= 2 AND F0100.rater_employee_cd_2 <> '' THEN 2
			WHEN F0200_3.confirm_datetime IS NULL AND @step >= 3 AND F0100.rater_employee_cd_3 <> '' THEN 3
			WHEN F0200_4.confirm_datetime IS NULL AND @step >= 4 AND F0100.rater_employee_cd_4 <> '' THEN 4
			ELSE 5
		END						AS	current_rater_step
	,	CASE 
			WHEN F0200_4.confirm_datetime IS NOT NULL THEN 4
			WHEN F0200_3.confirm_datetime IS NOT NULL THEN 3
			WHEN F0200_2.confirm_datetime IS NOT NULL THEN 2
			WHEN F0200_1.confirm_datetime IS NOT NULL THEN 1
			ELSE 0
		END						AS	confirm_at_step
	,	ISNULL(M0200.sheet_kbn,0)				AS	sheet_kbn				-- add by viettd 2022/10/24
	,	ISNULL(F0100.status_cd,0)				AS	status_cd				-- add by viettd 2022/10/24
	,	ISNULL(F0100.rater_employee_cd_1,'')	AS	rater_employee_cd_1		-- add by viettd 2022/10/24
	,	ISNULL(F0100.rater_employee_cd_2,'')	AS	rater_employee_cd_2		-- add by viettd 2022/10/24
	,	ISNULL(F0100.rater_employee_cd_3,'')	AS	rater_employee_cd_3		-- add by viettd 2022/10/24
	,	ISNULL(F0100.rater_employee_cd_4,'')	AS	rater_employee_cd_4		-- add by viettd 2022/10/24
	,	CASE 
			WHEN F0030_CURRENT_YEAR.employee_cd IS NOT NULL
			THEN 1
			ELSE 0
		END							-- add by viettd 2022/10/24
	FROM M0070 
	CROSS JOIN #TREATMENT_NO
	INNER JOIN #TEMP_M0072 ON(
		M0070.employee_cd			=	#TEMP_M0072.employee_cd
	)
	LEFT JOIN #F0032 ON(
		@P_company_cd				=	#F0032.company_cd
	AND	@fiscal_year				=	#F0032.fiscal_year
	AND	M0070.employee_cd			=	#F0032.employee_cd
	AND #TREATMENT_NO.treatment_no	=	#F0032.treatment_applications_no
	)
	LEFT JOIN F0100  ON (
		F0100.company_cd			=	M0070.company_cd
	AND	F0100.employee_cd			=	M0070.employee_cd
	AND F0100.fiscal_year			=	@fiscal_year 
	AND #F0032.sheet_cd				=	F0100.sheet_cd
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
	LEFT OUTER JOIN #M0071_SHEET ON (
		F0100.company_cd			=	#M0071_SHEET.company_cd
	AND F0100.fiscal_year			=	#M0071_SHEET.fiscal_year
	AND F0100.employee_cd			=	#M0071_SHEET.employee_cd
	AND F0100.sheet_cd				=	#M0071_SHEET.sheet_cd
	)
	LEFT OUTER JOIN #M0070H ON (
		M0070.company_cd			=	#M0070H.company_cd
	AND M0070.employee_cd			=	#M0070H.employee_cd
	)
	LEFT JOIN M0030 ON (
		#M0070H.company_cd			=	M0030.company_cd
	AND	#M0070H.job_cd				=	M0030.job_cd
	AND	M0030.del_datetime IS NULL
	)
	LEFT JOIN M0040 ON (
		#M0070H.company_cd			=	M0040.company_cd
	AND	#M0070H.position_cd			=	M0040.position_cd
	AND	M0040.del_datetime IS NULL
	)
	LEFT JOIN M0030 AS M0030_SHEET ON (
		#M0071_SHEET.company_cd		=	M0030_SHEET.company_cd
	AND	#M0071_SHEET.job_cd			=	M0030_SHEET.job_cd
	AND	M0030_SHEET.del_datetime IS NULL
	)
	LEFT JOIN M0040 AS M0040_SHEET ON (
		#M0071_SHEET.company_cd		=	M0040_SHEET.company_cd
	AND	#M0071_SHEET.position_cd	=	M0040_SHEET.position_cd
	AND	M0040_SHEET.del_datetime IS NULL
	)
	LEFT JOIN M0100 ON(
		M0070.company_cd			=	M0100.company_cd
	)
	LEFT JOIN M0020 AS M1 ON (
		M1.company_cd			=	#M0070H.company_cd
	AND M1.organization_cd_1	=	#M0070H.belong_cd_1
	AND M1.organization_typ		=	1
	) 
	LEFT JOIN M0020 AS M2 ON (
		M2.company_cd			=	#M0070H.company_cd
	AND M2.organization_cd_1	=	#M0070H.belong_cd_1
	AND M2.organization_cd_2	=	#M0070H.belong_cd_2
	AND M2.organization_typ		=	2
	)
	LEFT JOIN M0020 AS M3 ON (
		M3.company_cd			=	#M0070H.company_cd
	AND M3.organization_cd_1	=	#M0070H.belong_cd_1
	AND M3.organization_cd_2	=	#M0070H.belong_cd_2
	AND M3.organization_cd_3	=	#M0070H.belong_cd_3
	AND M3.organization_typ		=	3
	)
	LEFT JOIN M0020 AS M4 ON (
		M4.company_cd			=	#M0070H.company_cd
	AND M4.organization_cd_1	=	#M0070H.belong_cd_1
	AND M4.organization_cd_2	=	#M0070H.belong_cd_2
	AND M4.organization_cd_3	=	#M0070H.belong_cd_3
	AND M4.organization_cd_4	=	#M0070H.belong_cd_4
	AND M4.organization_typ		=	4
	)
	LEFT JOIN M0020 AS M5 ON (
		M5.company_cd			=	#M0070H.company_cd
	AND M5.organization_cd_1	=	#M0070H.belong_cd_1
	AND M5.organization_cd_2	=	#M0070H.belong_cd_2
	AND M5.organization_cd_3	=	#M0070H.belong_cd_3
	AND M5.organization_cd_4	=	#M0070H.belong_cd_4
	AND M5.organization_cd_5	=	#M0070H.belong_cd_5
	AND M5.organization_typ		=	5
	) 
	LEFT JOIN M0020 AS M1_SHEET ON (
		M1_SHEET.company_cd			=	#M0071_SHEET.company_cd
	AND M1_SHEET.organization_cd_1	=	#M0071_SHEET.belong_cd1
	AND M1_SHEET.organization_typ	=	1
	) 
	LEFT JOIN M0020 AS M2_SHEET ON (
		M2_SHEET.company_cd			=	#M0071_SHEET.company_cd
	AND M2_SHEET.organization_cd_1	=	#M0071_SHEET.belong_cd1
	AND M2_SHEET.organization_cd_2	=	#M0071_SHEET.belong_cd2
	AND M2_SHEET.organization_typ	=	2
	)
	LEFT JOIN M0020 AS M3_SHEET ON (
		M3_SHEET.company_cd			=	#M0071_SHEET.company_cd
	AND M3_SHEET.organization_cd_1	=	#M0071_SHEET.belong_cd1
	AND M3_SHEET.organization_cd_2	=	#M0071_SHEET.belong_cd2
	AND M3_SHEET.organization_cd_3	=	#M0071_SHEET.belong_cd3
	AND M3_SHEET.organization_typ	=	3
	)
	LEFT JOIN M0020 AS M4_SHEET ON (
		M4_SHEET.company_cd			=	#M0071_SHEET.company_cd
	AND M4_SHEET.organization_cd_1	=	#M0071_SHEET.belong_cd1
	AND M4_SHEET.organization_cd_2	=	#M0071_SHEET.belong_cd2
	AND M4_SHEET.organization_cd_3	=	#M0071_SHEET.belong_cd3
	AND M4_SHEET.organization_cd_4	=	#M0071_SHEET.belong_cd4
	AND M4_SHEET.organization_typ	=	4
	)
	LEFT JOIN M0020 AS M5_SHEET ON (
		M5_SHEET.company_cd			=	#M0071_SHEET.company_cd
	AND M5_SHEET.organization_cd_1	=	#M0071_SHEET.belong_cd1
	AND M5_SHEET.organization_cd_2	=	#M0071_SHEET.belong_cd2
	AND M5_SHEET.organization_cd_3	=	#M0071_SHEET.belong_cd3
	AND M5_SHEET.organization_cd_4	=	#M0071_SHEET.belong_cd4
	AND M5_SHEET.organization_cd_5	=	#M0071_SHEET.belong_cd5
	AND M5_SHEET.organization_typ	=	5
	) 
	LEFT JOIN M0102 ON(
		M0070.company_cd						=	M0102.company_cd
	AND	#F0032.treatment_applications_no		=	M0102.detail_no
	AND	M0102.del_datetime	IS NULL
	 )
	-- get rank cd and rank name of  last year
	LEFT JOIN F0201 AS F0201_3 ON (
		M0070.company_cd						=	F0201_3.company_cd
	AND @fiscal_year -3							=	F0201_3.fiscal_year
	AND M0070.employee_cd						=	F0201_3.employee_cd
	AND	F0201_3.treatment_applications_no		=	@treat3
	AND	F0201_3.del_datetime IS NULL
	)
	LEFT JOIN W_M0130 AS W_M0130_3 ON (
		M0070.company_cd						=	W_M0130_3.company_cd
	AND @fiscal_year -3							=	W_M0130_3.fiscal_year
	AND F0201_3.rank_cd							=	W_M0130_3.rank_cd
	AND	W_M0130_3.treatment_applications_no		=	@treat3
	AND	W_M0130_3.del_datetime IS NULL
	)
	-- get rank cd and rank name of  2 years ago
	LEFT JOIN F0201 AS F0201_2 ON (
		M0070.company_cd						=	F0201_2.company_cd
	AND @fiscal_year -2							=	F0201_2.fiscal_year
	AND M0070.employee_cd						=	F0201_2.employee_cd
	AND	F0201_2.treatment_applications_no		=	@treat2
	AND	F0201_2.del_datetime IS NULL
	)
	LEFT JOIN W_M0130 AS W_M0130_2 ON (
		M0070.company_cd						=	W_M0130_2.company_cd
	AND @fiscal_year -2							=	W_M0130_2.fiscal_year
	AND F0201_2.rank_cd							=	W_M0130_2.rank_cd
	AND	W_M0130_2.treatment_applications_no		=	@treat2
	AND	W_M0130_2.del_datetime IS NULL
	)
	-- get rank cd and rank name of  3 years ago
	LEFT JOIN F0201 AS F0201_1 ON (
		M0070.company_cd						=	F0201_1.company_cd
	AND @fiscal_year -1							=	F0201_1.fiscal_year
	AND M0070.employee_cd						=	F0201_1.employee_cd
	AND	F0201_1.treatment_applications_no		=	@treat1
	AND	F0201_1.del_datetime IS NULL
	)
	LEFT JOIN W_M0130 AS W_M0130_1 ON (
		M0070.company_cd						=	W_M0130_1.company_cd
	AND @fiscal_year - 1						=	W_M0130_1.fiscal_year
	AND F0201_1.rank_cd							=	W_M0130_1.rank_cd
	AND	W_M0130_1.treatment_applications_no		=	@treat1
	AND	W_M0130_1.del_datetime IS NULL
	)
	LEFT JOIN F0011 ON (
		F0011.company_cd						=	@P_company_cd
	AND F0011.fiscal_year						=	@fiscal_year
	AND F0011.treatment_applications_no			=	#F0032.treatment_applications_no
	AND F0011.del_datetime IS NULL
	)
	LEFT JOIN M0200 ON(
		M0070.company_cd						=	M0200.company_cd
	AND F0100.sheet_cd							=	M0200.sheet_cd
	AND M0200.del_datetime	IS NULL
	)
	LEFT JOIN F0200 AS F0200_1 ON(
		@P_company_cd							=	F0200_1.company_cd
	AND	@fiscal_year							=	F0200_1.fiscal_year
	AND	M0070.employee_cd						=	F0200_1.employee_cd
	AND	#F0032.treatment_applications_no		=	F0200_1.treatment_applications_no
	AND 1										=	F0200_1.evaluation_step
	)
	LEFT JOIN F0200  AS F0200_2 ON(
		@P_company_cd							=	F0200_2.company_cd
	AND	@fiscal_year							=	F0200_2.fiscal_year
	AND	M0070.employee_cd						=	F0200_2.employee_cd
	AND	#F0032.treatment_applications_no		=	F0200_2.treatment_applications_no
	AND 2										=	F0200_2.evaluation_step
	)
	LEFT JOIN F0200  AS F0200_3 ON(
		@P_company_cd							=	F0200_3.company_cd
	AND	@fiscal_year							=	F0200_3.fiscal_year
	AND	M0070.employee_cd						=	F0200_3.employee_cd
	AND	#F0032.treatment_applications_no		=	F0200_3.treatment_applications_no
	AND 3										=	F0200_3.evaluation_step
	)
	LEFT JOIN F0200  AS F0200_4 ON(
		@P_company_cd							=	F0200_4.company_cd
	AND	@fiscal_year							=	F0200_4.fiscal_year
	AND	M0070.employee_cd						=	F0200_4.employee_cd
	AND	#F0032.treatment_applications_no		=	F0200_4.treatment_applications_no
	AND 4										=	F0200_4.evaluation_step
	)
	WHERE 
		M0070.company_cd	=	@P_company_cd
	AND (@screen_employee = '' OR @screen_employee = M0070.employee_cd)
	--AND	(#M0071_SHEET.employee_typ	=	@employee_typ OR @employee_typ = -1)	
	-- edited by viettd 2022/03/31
	AND (
		-- WHEN RATER THEN NOT CHECK POSITION
		(
			F0100.rater_employee_cd_1	=	@employee_cd 
		OR	F0100.rater_employee_cd_2	=	@employee_cd	
		OR	F0100.rater_employee_cd_3	=	@employee_cd
		OR	F0100.rater_employee_cd_4	=	@employee_cd
		)
		OR
		(
			@use_typ = 0
		)
		OR
		(
			(@use_typ = 1 AND (M0040.arrange_order > @arrange_order))
		)
	)
	AND (
		@fiscal_year <> @current_year
	OR	@authority_typ IN (3,4,5)
	OR	(
			@fiscal_year	=	@current_year
		AND @authority_typ	=	2
		AND (
					F0100.rater_employee_cd_1	=	@employee_cd 
				OR	F0100.rater_employee_cd_2	=	@employee_cd	
				OR	F0100.rater_employee_cd_3	=	@employee_cd
				OR	F0100.rater_employee_cd_4	=	@employee_cd
			)
		)
	)
	-- edited by viettd 2023/04/24
	AND (
		(F0011.sheet_use_typ = 0 AND M0070.evaluated_typ = 1 AND 
			(
				M0070.company_out_dt IS NULL
			OR	(M0070.company_out_dt IS NOT NULL AND M0070.company_out_dt > @year_month_day)
			)
		)	
	OR	(F0011.sheet_use_typ = 1 AND #F0032.group_cd IS NOT NULL)
	)
	ORDER BY	
		M0070.company_cd					
	,	M0070.employee_cd
	,	#F0032.treatment_applications_no
	--↓↓↓ add by viettd 2023/04/10
	IF EXISTS (SELECT 1 FROM #TREATMENT_NO
						INNER JOIN F0011 ON (
							@P_company_cd				=	F0011.company_cd
						AND @fiscal_year				=	F0011.fiscal_year
						AND #TREATMENT_NO.treatment_no	=	F0011.treatment_applications_no
						)
						WHERE 
							F0011.use_typ		=	1
						AND F0011.sheet_use_typ	=	0
						AND F0011.del_datetime IS NULL
	)
	BEGIN
		UPDATE #TABLE_RESULT SET
			sheet_employee_typ_nm	=	ISNULL(#M0070H.employee_typ_nm,'')	
		,	sheet_employee_typ		=	ISNULL(#M0070H.employee_typ,0)		
		,	sheet_belong1_nm		=	ISNULL(#M0070H.belong_nm_1,'')		
		,	sheet_belong_cd1		=	ISNULL(#M0070H.belong_cd_1,'')		
		,	sheet_belong2_nm		=	ISNULL(#M0070H.belong_nm_2,'')		
		,	sheet_belong_cd2		=	ISNULL(#M0070H.belong_cd_2,'')		
		,	sheet_belong3_nm		=	ISNULL(#M0070H.belong_nm_3,'')		
		,	sheet_belong_cd3		=	ISNULL(#M0070H.belong_cd_3,'')		
		,	sheet_belong4_nm		=	ISNULL(#M0070H.belong_nm_4,'')		
		,	sheet_belong_cd4		=	ISNULL(#M0070H.belong_cd_4,'')		
		,	sheet_belong5_nm		=	ISNULL(#M0070H.belong_nm_5,'')		
		,	sheet_belong_cd5		=	ISNULL(#M0070H.belong_cd_5,'')		
		,	sheet_job_nm			=	ISNULL(#M0070H.job_nm,'')			
		,	sheet_job_cd			=	ISNULL(#M0070H.job_cd,0)			
		,	sheet_position_nm		=	ISNULL(#M0070H.position_nm,'')		
		,	sheet_position_cd		=	ISNULL(#M0070H.position_cd,0)		
		,	sheet_grade_nm			=	ISNULL(#M0070H.grade_nm,'')			
		,	sheet_grade				=	ISNULL(#M0070H.grade,0)					
		FROM #TABLE_RESULT
		INNER JOIN #M0070H ON (
			#TABLE_RESULT.company_cd		=	#M0070H.company_cd
		AND #TABLE_RESULT.employee_cd		=	#M0070H.employee_cd
		)
		WHERE 
			#TABLE_RESULT.sheet_cd IS NULL
	END
	-- FILTER employee_typ
	IF @employee_typ > 0
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D
		WHERE 
			D.sheet_employee_typ	<>	@employee_typ
	END

	--↑↑↑ end add by viettd 2023/04/10
	--fix loi khi f0100 co 2 sheet voi 2 buoc danh gia khac nhau trong cung 1 treatment
	UPDATE #TABLE_RESULT SET 
		rater_status = CASE 
										WHEN #TABLE_RESULT.rater_status = 0 AND #TABLE_RESULT.rater_step <> 0 
										THEN rater_step 
										ELSE #TMP_RATER.rater_status 
									END
	FROM #TABLE_RESULT 
	LEFT JOIN (
		SELECT 
			#TABLE_RESULT.employee_cd
		,	#TABLE_RESULT.treatment_applications_no
		,	MAX(rater_status) AS rater_status
		FROM #TABLE_RESULT
		GROUP BY
			#TABLE_RESULT.company_cd
		,	#TABLE_RESULT.fiscal_year
		,	#TABLE_RESULT.employee_cd
		,	#TABLE_RESULT.treatment_applications_no
	) AS #TMP_RATER ON(
		#TABLE_RESULT.employee_cd				=	#TMP_RATER.employee_cd
	AND #TABLE_RESULT.treatment_applications_no =   #TMP_RATER.treatment_applications_no
	)
	-- WHEN current_rater_step = 5 (最終評価)　then set final_rater_status = 5
	UPDATE #TABLE_RESULT SET 
		final_rater_status		=	CASE 
										WHEN @authority_typ	IN (4,5)  AND current_rater_step = 5
										THEN 5
										WHEN @authority_typ	= 3 AND rater_step NOT IN (1,2,3,4) AND current_rater_step = 5
										THEN 5
										ELSE final_rater_status
									END
	FROM #TABLE_RESULT
	--DELETE ORGANIZATION NOT IN #ORG_TEMP
	--
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION ) 
	BEGIN
		SET @choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
		-- 1.choice in screen 
		-- 0.get from master S0022
		-- Filter organization_typ = 1
		IF @choice_in_screen = 1
		BEGIN
			DELETE D FROM #TABLE_RESULT AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.sheet_belong_cd1			=	S.organization_cd_1
			AND D.sheet_belong_cd2			=	S.organization_cd_2
			AND D.sheet_belong_cd3			=	S.organization_cd_3
			AND D.sheet_belong_cd4			=	S.organization_cd_4
			AND D.sheet_belong_cd5			=	S.organization_cd_5
			)
			WHERE 
				D.employee_cd IS NULL
			OR	S.organization_typ IS NULL
		END
		ELSE IF NOT (@authority_typ = 3 AND @w_evaluation_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)	-- edited by viettd 2021/06/03
		BEGIN
			DELETE D FROM #TABLE_RESULT AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.belong_cd1			=	S.organization_cd_1
			AND D.belong_cd2			=	S.organization_cd_2
			AND D.belong_cd3			=	S.organization_cd_3
			AND D.belong_cd4			=	S.organization_cd_4
			AND D.belong_cd5			=	S.organization_cd_5
			)
			WHERE 
				D.employee_cd IS NULL
			OR	S.organization_typ IS NULL
			AND @authority_typ NOT IN(2,4,5)		--4.会社管理者 5.総合管理者
			--AND D.rater_step NOT IN (1,2,3,4)	--一次評価者～四次評価者		 add by viettd 2022/03/31
		END
	END
	--
	IF NOT EXISTS(SELECT 1 FROM #TREATMENT_NO)
	BEGIN
		DELETE #TABLE_RESULT
	END ELSE
	BEGIN
		--DROP TABLE #TABLE_RESULT
		DELETE R FROM #TABLE_RESULT R LEFT JOIN #TREATMENT_NO T ON	R.company_cd				=	@P_company_cd 
																		AND	R.treatment_applications_no	=	T.treatment_no 
																	WHERE  T.treatment_no IS NULL
	END
	IF EXISTS(SELECT 1 FROM #POSITION_CD)
	BEGIN 
		DELETE R FROM #TABLE_RESULT R LEFT JOIN #POSITION_CD T ON	R.company_cd				=	@P_company_cd 
																		AND	R.sheet_position_cd	=	T.position_cd 
																	WHERE  T.position_cd IS NULL
	END
	IF EXISTS(SELECT 1 FROM #GRADE)
	BEGIN 
		DELETE R FROM #TABLE_RESULT R LEFT JOIN #GRADE T ON	R.company_cd					=	@P_company_cd 
																		AND	R.sheet_grade	=	T.grade 
																	WHERE  T.grade IS NULL
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ FIND ALL EMPLOYEE IN F0100 WITH SEARCH CONDITION  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--IF @screen_evalute_step <> 5
	IF EXISTS (SELECT 1 FROM #TABLE_EVALUATION_STEP)
	BEGIN
		-- change F0100 -> F0030 viettd 2024/06/10
		-- GET ALL EMPLOYEE OF 評価者 WHEN CHOICE IN SCREEN AT RATER1~RATER4
		INSERT INTO #SCREEN_EMPLOYEE
		SELECT 
			employee_cd 
		,	CASE WHEN F0030.rater_employee_cd_4 =  @screen_rater
				 THEN 4
				 WHEN F0030.rater_employee_cd_3 =  @screen_rater
				 THEN 3
				 WHEN F0030.rater_employee_cd_2 =  @screen_rater
				 THEN 2
				 WHEN F0030.rater_employee_cd_1 =  @screen_rater
				 THEN 1
			ELSE 0
			END
		FROM F0030 
		INNER JOIN #TREATMENT_NO ON (
			F0030.company_cd					=	@P_company_cd
		AND F0030.treatment_applications_no		=	#TREATMENT_NO.treatment_no
		)
		WHERE 
			F0030.company_cd =  @P_company_cd
		AND (
			F0030.fiscal_year = @current_year  
		OR	F0030.fiscal_year = @fiscal_year
		)
		AND (	(@screen_rater = '' )
			OR  (
				@screen_rater <> ''
					AND (
							(@screen_evalute_step_1  = 1 AND rater_employee_cd_1 = @screen_rater)
						OR	(@screen_evalute_step_2  = 2 AND rater_employee_cd_2 = @screen_rater)
						OR	(@screen_evalute_step_3  = 3 AND rater_employee_cd_3 = @screen_rater)
						OR	(@screen_evalute_step_4  = 4 AND rater_employee_cd_4 = @screen_rater)	
					)	
				)
			)
		AND	F0030.del_datetime IS NULL
		GROUP BY
			F0030.employee_cd
		,	F0030.rater_employee_cd_1
		,	F0030.rater_employee_cd_2
		,	F0030.rater_employee_cd_3
		,	F0030.rater_employee_cd_4
		-- GET ALL EMPLOYEE OF 評価者 WHEN CHOICE IN SCREEN AT 5.最終評価
		IF @screen_evalute_step_5 <> 0
		BEGIN
			INSERT INTO #SCREEN_EMPLOYEE
			SELECT 
				F0201_EMP.employee_cd
			,	F0201_EMP.evalutation_step
			FROM #SCREEN_EMPLOYEE
			RIGHT JOIN (
				SELECT
					DISTINCT
					F0201.employee_cd				AS	employee_cd
				,	5								AS	evalutation_step
				FROM F0201
				INNER JOIN #TREATMENT_NO ON (
					F0201.company_cd				=	@P_company_cd
				AND F0201.treatment_applications_no	=	#TREATMENT_NO.treatment_no
				)
				WHERE 
					F0201.company_cd		=	@P_company_cd
				AND (
					F0201.fiscal_year		=	@current_year
				OR	F0201.fiscal_year		=	@fiscal_year
				)
				AND F0201.confirm_user		= @search_emp_user
				AND F0201.del_datetime IS NULL
			) AS F0201_EMP ON (
				#SCREEN_EMPLOYEE.employee	=	F0201_EMP.employee_cd
			)
			WHERE 
				#SCREEN_EMPLOYEE.employee IS NULL
		END
		-- REMOVE ALL EMPLOYEE NOT MATCH WHEN CHOICE 評価者 IN SCREEN
		DELETE R FROM #TABLE_RESULT R 
		LEFT JOIN #SCREEN_EMPLOYEE T ON	(
			R.company_cd	=	@P_company_cd 
		AND	R.employee_cd	=	T.employee 
		)
		WHERE T.employee IS NULL
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■delete row not match search condition ■■■■■■■■■■■■■■■■■■
	--IF @screen_rater <> '' AND @screen_evalute_step <> 5
	--IF @screen_rater <> '' AND NOT EXISTS (SELECT 1 FROM #TABLE_EVALUATION_STEP WHERE evaluation_step = 5)
	--BEGIN
	--	DELETE R FROM #TABLE_RESULT R 
	--	LEFT JOIN #SCREEN_EMPLOYEE T ON	(
	--		R.company_cd	=	@P_company_cd 
	--	AND	R.employee_cd	=	T.employee 
	--	)
	--	WHERE T.employee IS NULL
	--END
	-- get only employee past data of present employee 
	-- check da hoan thanh danh gia sheet hay chua
	UPDATE #TABLE_RESULT SET
		accept_input =	CASE 
							WHEN  (#F0120.employee_cd IS  NULL  AND #TABLE_RESULT.sheet_use_typ = 1) OR M0100_rater_check_typ = 0 
							THEN 1
							ELSE 0
						END	 
	FROM #TABLE_RESULT
	LEFT JOIN(
		SELECT
			#F0032.employee_cd
		,	#F0032. treatment_applications_no
		,	f0120.evaluation_step
		,	#F0032.sheet_cd
		,	F0120.submit_datetime
		,	W_M0200.sheet_kbn
		,	CASE 
				-- 目標
				WHEN W_M0200.sheet_kbn = 1 AND  (	
								(#TABLE_RESULT.final_rater_status = 5	AND #TABLE_RESULT.current_rater_step= 1)	
							OR	(#TABLE_RESULT.final_rater_status <> 5  AND #TABLE_RESULT.rater_status	= 1)	
							OR	(@screen_evalute_step_1 > 0 AND @screen_evalute_step_1 = 1)
							) 
				THEN M0100.target_evaluation_typ_1
				WHEN  W_M0200.sheet_kbn = 1 AND  (	
								(#TABLE_RESULT.final_rater_status = 5	AND #TABLE_RESULT.current_rater_step= 2)	
							OR	(#TABLE_RESULT.final_rater_status <> 5  AND #TABLE_RESULT.rater_status	= 2)	
							OR	(@screen_evalute_step_2 > 0 AND @screen_evalute_step_2 = 2)
							) 
				THEN M0100.target_evaluation_typ_2
				WHEN W_M0200.sheet_kbn = 1 AND  (	
								(#TABLE_RESULT.final_rater_status = 5	AND #TABLE_RESULT.current_rater_step= 3)	
							OR	(#TABLE_RESULT.final_rater_status <> 5  AND #TABLE_RESULT.rater_status	= 3)	
							OR	(@screen_evalute_step_3 > 0 AND @screen_evalute_step_3 = 3)
							) 
				THEN M0100.target_evaluation_typ_3
				WHEN W_M0200.sheet_kbn = 1 AND  (	
								(#TABLE_RESULT.final_rater_status = 5	AND #TABLE_RESULT.current_rater_step= 4)	
							OR	(#TABLE_RESULT.final_rater_status <> 5  AND #TABLE_RESULT.rater_status	= 4)	
							OR	(@screen_evalute_step_4 > 0 AND @screen_evalute_step_4 = 4)
							) 
				THEN M0100.target_evaluation_typ_4
				-- 定性
				WHEN W_M0200.sheet_kbn = 2 AND  (	
								(#TABLE_RESULT.final_rater_status = 5	AND #TABLE_RESULT.current_rater_step= 1)	
							OR	(#TABLE_RESULT.final_rater_status <> 5  AND #TABLE_RESULT.rater_status	= 1)	
							OR	(@screen_evalute_step_1 > 0 AND @screen_evalute_step_1 = 1)
							) 
				THEN M0100.evaluation_typ_1
				WHEN W_M0200.sheet_kbn = 2 AND  (	
								(#TABLE_RESULT.final_rater_status = 5	AND #TABLE_RESULT.current_rater_step= 2)	
							OR	(#TABLE_RESULT.final_rater_status <> 5  AND #TABLE_RESULT.rater_status	= 2)	
							OR	(@screen_evalute_step_2 > 0 AND @screen_evalute_step_2 = 2)
							)
				THEN M0100.evaluation_typ_2
				WHEN W_M0200.sheet_kbn = 2 AND  (	
								(#TABLE_RESULT.final_rater_status = 5	AND #TABLE_RESULT.current_rater_step= 3)	
							OR	(#TABLE_RESULT.final_rater_status <> 5  AND #TABLE_RESULT.rater_status	= 3)	
							OR	(@screen_evalute_step_3 > 0 AND @screen_evalute_step_3 = 3)
							)
				THEN M0100.evaluation_typ_3
				WHEN W_M0200.sheet_kbn = 2 AND  (	
								(#TABLE_RESULT.final_rater_status = 5	AND #TABLE_RESULT.current_rater_step= 4)	
							OR	(#TABLE_RESULT.final_rater_status <> 5  AND #TABLE_RESULT.rater_status	= 4)	
							OR	(@screen_evalute_step_4 > 0 AND @screen_evalute_step_4 = 4)
							)
				THEN M0100.evaluation_typ_4
			END AS M0100_rater_check_typ
		FROM #TABLE_RESULT 
		LEFT JOIN #F0032 ON(
			#TABLE_RESULT.employee_cd				= #F0032.employee_cd
		AND @P_company_cd							= #F0032.company_cd
		AND #TABLE_RESULT.treatment_applications_no	= #F0032.treatment_applications_no
		AND #TABLE_RESULT.sheet_cd					= #F0032.sheet_cd
		)
		LEFT JOIN F0120 ON(
			F0120.company_cd	=	#F0032.company_cd
		AND F0120.fiscal_year	=	#F0032.fiscal_year
		AND F0120.sheet_cd		=	#F0032.sheet_cd
		AND F0120.employee_cd	=	#F0032.employee_cd
		AND (	
				(#TABLE_RESULT.final_rater_status = 5	AND #TABLE_RESULT.current_rater_step	=	F0120.evaluation_step)	
			OR	(#TABLE_RESULT.final_rater_status <> 5  AND #TABLE_RESULT.rater_status			=	F0120.evaluation_step)	
			--OR	(@screen_evalute_step > 0 AND @screen_evalute_step = F0120.evaluation_step)
			OR (
				@screen_evalute_step_1 > 0 AND @screen_evalute_step_1 = F0120.evaluation_step
			OR	@screen_evalute_step_2 > 0 AND @screen_evalute_step_2 = F0120.evaluation_step
			OR	@screen_evalute_step_3 > 0 AND @screen_evalute_step_3 = F0120.evaluation_step
			OR	@screen_evalute_step_4 > 0 AND @screen_evalute_step_4 = F0120.evaluation_step
			)
			)
		)
		LEFT JOIN W_M0200 ON(
			@P_company_cd		=	W_M0200.company_cd
		AND #F0032.fiscal_year	=	W_M0200.fiscal_year
		AND #F0032.sheet_cd		=	W_M0200.sheet_cd
		)
		LEFT JOIN M0100 ON(
			@P_company_cd = M0100.company_cd
		)
		WHERE 
			@P_company_cd				=	#F0032.company_cd
		AND @fiscal_year				=	#F0032.fiscal_year
		AND F0120.submit_datetime IS NULL
	)AS #F0120 ON(
		#TABLE_RESULT.employee_cd				=	#F0120.employee_cd
	AND #TABLE_RESULT.treatment_applications_no	=	#F0120.treatment_applications_no
	)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ CACULATE STEP ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	INSERT INTO #STEP_LOGIN
	SELECT 
		#TABLE_RESULT.employee_cd
	,	#F0032.treatment_applications_no
	,	#TABLE_RESULT.rater_status			AS	evaluation_step
	,	CASE 
			WHEN F0100.rater_employee_cd_4 <> '' 	
			THEN 4
			WHEN  F0100.rater_employee_cd_4 = '' AND  F0100.rater_employee_cd_3 <> ''	
			THEN 3
			WHEN  F0100.rater_employee_cd_4 = '' AND  F0100.rater_employee_cd_3 = '' AND  F0100.rater_employee_cd_2 <> ''	
			THEN 2
			WHEN  F0100.rater_employee_cd_4 = '' AND  F0100.rater_employee_cd_3 = '' AND  F0100.rater_employee_cd_2 = '' AND 	F0100.rater_employee_cd_1 <> ''
			THEN 1  
			ELSE 0
		END									AS	max_step
	FROM #TABLE_RESULT 
	LEFT JOIN #F0032 ON (
		@P_company_cd							=	#F0032.company_cd
	AND	#TABLE_RESULT.employee_cd				=   #F0032.employee_cd
	AND	@fiscal_year							=	#F0032.fiscal_year
	AND #TABLE_RESULT.treatment_applications_no	=	#F0032.treatment_applications_no
	) 
	LEFT JOIN F0100 ON (
		#TABLE_RESULT.company_cd	=	F0100.company_cd
	AND	#TABLE_RESULT.employee_cd	=	F0100.employee_cd
	AND #F0032.sheet_cd				=   F0100.sheet_cd
	AND	@fiscal_year				=	F0100.fiscal_year
	AND	F0100.del_datetime	IS NULL
	)
	--
	SET @adjust_point = (SELECT TOP 1 evaluation_step FROM #STEP_LOGIN ORDER BY evaluation_step DESC)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■get distinct sheet cd over employee■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	INSERT INTO #TEMP_F0120
	SELECT 
		#F0032.company_cd
	,	#F0032.fiscal_year
	,	#F0032.employee_cd
	,	#F0032.sheet_cd
	,	#F0032.treatment_applications_no
	,	''
	,	M0200.sheet_nm
	,	ROW_NUMBER() OVER(PARTITION BY #F0032.company_cd,#F0032.fiscal_year,#F0032.employee_cd,#F0032.treatment_applications_no
		ORDER BY #F0032.fiscal_year,#F0032.employee_cd,#F0032.treatment_applications_no) 
	FROM #TREATMENT_NO INNER JOIN 
	#F0032 ON (
		#F0032.company_cd				= @P_company_cd
	AND #F0032.treatment_applications_no = #TREATMENT_NO.treatment_no
	AND	#F0032.fiscal_year				= @fiscal_year 
	)
	INNER JOIN #TABLE_RESULT ON(
		#F0032.company_cd						=	@P_company_cd
	AND	#F0032.employee_cd						=	#TABLE_RESULT.employee_cd
	AND	#F0032.fiscal_year						=	 @fiscal_year
	AND	#TABLE_RESULT.treatment_applications_no	=	#F0032.treatment_applications_no
	)
	LEFT JOIN M0200 ON (
		#F0032.company_cd	=	M0200.company_cd
	AND	#F0032.sheet_cd		=	M0200.sheet_cd
	)
	LEFT JOIN F0120 on(
		F0120.company_cd			=	#F0032.company_cd
	AND	F0120.fiscal_year			=	#F0032.fiscal_year
	AND	F0120.employee_cd			=	#F0032.employee_cd
	AND	F0120.sheet_cd				=	#F0032.sheet_cd
	)
	WHERE 
		#F0032.company_cd	=	@P_company_cd
	AND	#F0032.fiscal_year	=	@fiscal_year
	GROUP BY 
		#F0032.company_cd
	,	#F0032.fiscal_year
	,	#F0032.employee_cd
	,	#F0032.treatment_applications_no
	,	#F0032.sheet_cd
	,	M0200.sheet_nm
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■CACULATE POINT SUM ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--- CHIA RA 2 TH 1.NEU CO BAN GHI TRONG F0201 THI LAY DATA TU F0201
	---ELSE SE LAY TU F0200 JOIN VS F0201
	UPDATE #TABLE_RESULT SET
		data_f0201_status = 1			-- IF EIXTS DATA F0201 IS 1
	FROM F0201 
	LEFT JOIN #TABLE_RESULT ON(
		F0201.company_cd				=	@P_company_cd
	AND	F0201.fiscal_year				=	@fiscal_year
	AND F0201.employee_cd				=	#TABLE_RESULT.employee_cd
	AND	F0201.treatment_applications_no	=	#TABLE_RESULT.treatment_applications_no
	)
	WHERE 
		F0201.company_cd				=	@P_company_cd
	AND	F0201.fiscal_year				=	@fiscal_year	
	AND	F0201.treatment_applications_no	=	#TABLE_RESULT.treatment_applications_no
	AND	F0201.del_datetime	IS NULL
	--INSERT DATA INTO #TMP_POINT_SUM_FINAL_最終 WITH EXISTS F0201 (DA CHOT)
	INSERT INTO #TMP_POINT_SUM_FINAL_最終
	SELECT 
		F0201.company_cd		
	,	F0201.fiscal_year		
	,	F0201.employee_cd		
	,	0								AS	evaluation_step	
	,	F0201.treatment_applications_no	AS	treatment_applications_no
	,	MAX(F0201.point_sum)			AS	point_sum
	,	MAX(F0201.adjust_point)			AS	adjust_point
	,	MAX(F0201.rank_cd)				AS	rank_cd
	,	MAX(W_M0130.rank_nm)			AS	rank_nm
	,	MAX(F0201.confirm_datetime)		AS	confirm_datetime			-- add by viettd 2021/04/01
	FROM F0201
	LEFT JOIN #TABLE_RESULT ON(
		F0201.company_cd				=	@P_company_cd
	AND	F0201.fiscal_year				=	@fiscal_year
	AND F0201.employee_cd				=	#TABLE_RESULT.employee_cd
	AND	F0201.treatment_applications_no	=	#TABLE_RESULT.treatment_applications_no
	)  
	LEFT JOIN M0130  ON(
		F0201.company_cd	=	M0130.company_cd
	AND	F0201.rank_cd		=	M0130.rank_cd
	AND M0130.del_datetime	IS NULL
	)
	LEFT JOIN W_M0130  ON(
		F0201.company_cd					=	W_M0130.company_cd
	AND	F0201.rank_cd						=	W_M0130.rank_cd
	AND W_M0130.fiscal_year					=	@fiscal_year
	AND	W_M0130.treatment_applications_no	=	#TABLE_RESULT.treatment_applications_no
	AND W_M0130.del_datetime	IS NULL
	)
	WHERE 
		F0201.del_datetime IS NULL
	AND F0201.company_cd				= @P_company_cd
	AND F0201.fiscal_year				= @fiscal_year
	AND	F0201.treatment_applications_no	= #TABLE_RESULT.treatment_applications_no
	AND #TABLE_RESULT.data_f0201_status = 1
	GROUP BY 
		F0201.company_cd	
	,	F0201.fiscal_year	
	,	F0201.employee_cd	
	,	F0201.treatment_applications_no
	-- INSERT DATA INTO #TMP_POINT_SUM_FINAL_最終
	INSERT INTO #TMP_POINT_SUM_FINAL_最終
	SELECT 
		F0200.company_cd		
	,	F0200.fiscal_year		
	,	F0200.employee_cd		
	,	F0200.evaluation_step	
	,	F0200.treatment_applications_no
	,	MAX(f0200.point_sum)				AS point_sum
	,	MAX(F0200.adjust_point)				AS adjust_point
	,	MAX(F0200.rank_cd)					AS rank_cd
	,	MAX(W_M0130.rank_nm)				AS rank_nm
	,	NULL								AS confirm_datetime			-- add by viettd 2021/04/01
	FROM F0200
	LEFT JOIN #STEP_LOGIN ON(
		F0200.company_cd				=	@P_company_cd
	AND	F0200.fiscal_year				=	@fiscal_year
	AND	F0200.employee_cd				=	#STEP_LOGIN.employee_cd
	AND F0200.treatment_applications_no	=	#STEP_LOGIN.treatment_applications_no
	AND	F0200.evaluation_step			=	#STEP_LOGIN.max_step
	)
	LEFT JOIN #TABLE_RESULT ON(
		F0200.company_cd				=	@P_company_cd
	AND	F0200.fiscal_year				=	@fiscal_year
	AND F0200.employee_cd				=	#TABLE_RESULT.employee_cd
	AND	F0200.treatment_applications_no	=	#TABLE_RESULT.treatment_applications_no
	AND #TABLE_RESULT.data_f0201_status = 0
	)  
	LEFT JOIN M0130  ON(
		F0200.company_cd					=	M0130.company_cd
	AND	F0200.rank_cd						=	M0130.rank_cd
	AND F0200.treatment_applications_no		=   M0130.treatment_applications_no
	)
	LEFT JOIN W_M0130  ON(
		F0200.company_cd					=	W_M0130.company_cd
	AND	F0200.rank_cd						=	W_M0130.rank_cd
	AND W_M0130.fiscal_year					=	@fiscal_year
	AND F0200.treatment_applications_no		=   W_M0130.treatment_applications_no
		AND W_M0130.del_datetime	IS NULL
	)
	WHERE 
		F0200.company_cd		=	@P_company_cd
	AND	F0200.fiscal_year		=	@fiscal_year
	AND	F0200.evaluation_step	=	#STEP_LOGIN.max_step
	AND	@start_date    <= @w_time AND  @w_time <= @year_month_day
	AND #TABLE_RESULT.data_f0201_status = 0
	AND F0200.del_datetime IS NULL
	GROUP BY 
		F0200.company_cd	
	,	F0200.fiscal_year	
	,	F0200.employee_cd	
	,	F0200.evaluation_step
	,	F0200.treatment_applications_no
	--add by viettd 2021/09/01
	UPDATE #TMP_POINT_SUM_FINAL_最終 SET
		rank_nm	=	ISNULL(M0130.rank_nm,'')
	FROM #TMP_POINT_SUM_FINAL_最終
	INNER JOIN F0011 ON (
		#TMP_POINT_SUM_FINAL_最終.company_cd						=	F0011.company_cd
	AND #TMP_POINT_SUM_FINAL_最終.fiscal_year					=	F0011.fiscal_year
	AND #TMP_POINT_SUM_FINAL_最終.treatment_applications_no		=	F0011.treatment_applications_no
	AND F0011.del_datetime IS NULL
	)
	INNER JOIN M0130 ON (
		#TMP_POINT_SUM_FINAL_最終.company_cd						=	M0130.company_cd
	AND #TMP_POINT_SUM_FINAL_最終.treatment_applications_no		=	M0130.treatment_applications_no
	AND #TMP_POINT_SUM_FINAL_最終.rank_kinds						=	M0130.rank_cd
	AND M0130.del_datetime IS NULL
	)
	WHERE
		F0011.sheet_use_typ = 0 -- DONT USE SHEET_CD
	--end add by viettd 2021/09/01
	--*** CACULATE TMP_POINT_SUM***--
	INSERT INTO #TMP_POINT_SUM
	SELECT 
		F0120.company_cd		
	,	F0120.fiscal_year		
	,	F0120.employee_cd		
	,	F0120.evaluation_step	
	,	#TEMP_F0120.treatment_applications_no
	,	CAST((SUM(F0120.point_sum * IIF(ISNULL(#F0032.weight,0) = 0,0,#F0032.weight))/100) AS money)	AS point_sum
	,	MAX(F0200.adjust_point)																			AS adjust_point
	,	MAX(F0200.rank_cd)																				AS rank_cd
	,	MAX(W_M0130.rank_nm)																			AS rank_nm
	FROM  #TEMP_F0120 
	INNER JOIN F0120 ON(
		#TEMP_F0120.company_cd	= F0120.company_cd
	AND #TEMP_F0120.fiscal_year = F0120.fiscal_year
	AND #TEMP_F0120.employee_cd = F0120.employee_cd
	AND #TEMP_F0120.sheet_cd	= F0120.sheet_cd
	)
	LEFT JOIN F0200 ON(
		F0120.company_cd						=	F0200.company_cd
	AND	F0120.fiscal_year						=	F0200.fiscal_year
	AND	F0120.employee_cd						=	F0200.employee_cd
	AND F0120.evaluation_step					=	F0200.evaluation_step
	AND	#TEMP_F0120.treatment_applications_no	=	F0200.treatment_applications_no
	AND F0200.del_datetime IS NULL
	AND F0200.rank_cd							<>	0		-- add by viettd 2021/04/01
	)
	LEFT JOIN #F0032 on(
		F0120.company_cd						=	#F0032.company_cd
	AND	F0120.fiscal_year						=	#F0032.fiscal_year
	AND	F0120.employee_cd						=	#F0032.employee_cd
	AND	F0120.sheet_cd							=	#F0032.sheet_cd
	AND	#TEMP_F0120.treatment_applications_no	=	#F0032.treatment_applications_no
	)
	LEFT JOIN M0130 ON(
		F0200.company_cd						=	M0130.company_cd
	AND #TEMP_F0120.treatment_applications_no	=   M0130.treatment_applications_no
	AND	F0200.rank_cd							=	M0130.rank_cd
	)
	LEFT JOIN W_M0130  ON(
		F0200.company_cd						=	W_M0130.company_cd
	AND	F0200.rank_cd							=	W_M0130.rank_cd
	AND #TEMP_F0120.treatment_applications_no	=   W_M0130.treatment_applications_no
	AND W_M0130.fiscal_year						=	@fiscal_year
	AND W_M0130.del_datetime　IS NULL
	)
	WHERE 
		F0120.company_cd		=	@P_company_cd
	AND	F0120.fiscal_year		=	@fiscal_year
	AND	F0120.evaluation_step	IN(1,2,3,4)
	AND F0120.del_datetime IS NULL
	GROUP BY 
		F0120.company_cd	
	,	F0120.fiscal_year	
	,	F0120.employee_cd	
	,	#TEMP_F0120.treatment_applications_no
	,	F0120.evaluation_step
	-- UPDATE rank_kinds AND rank_nm OF #TMP_POINT_SUM
	UPDATE #TMP_POINT_SUM SET 
		rank_kinds	=	CASE 
							WHEN rank_kinds IS NULL 
							THEN W_M0130.rank_cd
							ELSE #TMP_POINT_SUM.rank_kinds
						END
	,	rank_nm		=	CASE 
							WHEN ( rank_kinds IS NULL  AND #TMP_POINT_SUM.rank_nm IS NULL) OR #TMP_POINT_SUM.rank_nm = ''
							THEN W_M0130.rank_nm
							ELSE #TMP_POINT_SUM.rank_nm
						END
	FROM #TMP_POINT_SUM 
	LEFT JOIN W_M0130 ON(
		#TMP_POINT_SUM.company_cd			=	W_M0130.company_cd
	AND W_M0130.fiscal_year					=	@fiscal_year
	AND W_M0130.treatment_applications_no	=	#TMP_POINT_SUM.treatment_applications_no
	AND W_M0130.del_datetime IS NULL
	AND	(ISNULL(#TMP_POINT_SUM.point_sum,0) >= W_M0130.points_from OR W_M0130.points_from IS NULL) 
	AND (ISNULL(#TMP_POINT_SUM.point_sum,0) < W_M0130.points_to OR W_M0130.points_to IS NULL)
	)
    LEFT JOIN #STEP_LOGIN ON(
		#TMP_POINT_SUM.employee_cd					= #STEP_LOGIN.employee_cd
	AND #TMP_POINT_SUM.treatment_applications_no	= #STEP_LOGIN.treatment_applications_no
	AND	(
		#TMP_POINT_SUM.evaluation_step				= #STEP_LOGIN.evaluation_step 
	OR	@authority_typ IN(3,4,5))
	)
	WHERE #STEP_LOGIN.employee_cd IS NOT NULL
	--***END CACULATE TMP_POINT_SUM***--
	UPDATE #TMP_POINT_SUM_FINAL_最終 SET 
		rank_kinds	=	CASE 
							WHEN rank_kinds IS NULL 
							THEN W_M0130.rank_cd
							ELSE #TMP_POINT_SUM_FINAL_最終.rank_kinds
						END
	,	rank_nm		=	CASE 
							WHEN ( rank_kinds IS NULL  AND #TMP_POINT_SUM_FINAL_最終.rank_nm IS NULL) OR #TMP_POINT_SUM_FINAL_最終.rank_nm = ''
							THEN W_M0130.rank_nm
							ELSE #TMP_POINT_SUM_FINAL_最終.rank_nm
						END
	FROM #TMP_POINT_SUM_FINAL_最終 
	LEFT JOIN W_M0130 ON(
		#TMP_POINT_SUM_FINAL_最終.company_cd	=	W_M0130.company_cd
	AND	(ISNULL(#TMP_POINT_SUM_FINAL_最終.point_sum,0) >= W_M0130.points_from OR W_M0130.points_from IS NULL) 
	AND (ISNULL(#TMP_POINT_SUM_FINAL_最終.point_sum,0) < W_M0130.points_to OR W_M0130.points_to IS NULL)
	AND W_M0130.fiscal_year = @fiscal_year
	AND W_m0130.treatment_applications_no = #TMP_POINT_SUM_FINAL_最終.treatment_applications_no
	AND W_M0130.del_datetime IS NULL
	)

	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■END CACULATE POINT SUM ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	UPDATE #TABLE_RESULT SET 
		point_sum1			=	CASE WHEN #TABLE_RESULT.rater_status <= current_rater_step OR #TABLE_RESULT.final_rater_status = 5 THEN STEP1.point_sum		END
	,	adjust_point1		=	CASE WHEN #TABLE_RESULT.rater_status <= current_rater_step OR #TABLE_RESULT.final_rater_status = 5 THEN STEP1.adjust_point	END
	,	rank_kinds1			=	CASE WHEN #TABLE_RESULT.rater_status <= current_rater_step OR #TABLE_RESULT.final_rater_status = 5 THEN STEP1.rank_kinds	END
	,	rank_nm1			=	CASE WHEN #TABLE_RESULT.rater_status <= current_rater_step OR #TABLE_RESULT.final_rater_status = 5 THEN STEP1.rank_nm		END

	,	point_sum2			=	CASE WHEN #TABLE_RESULT.rater_status <= current_rater_step OR #TABLE_RESULT.final_rater_status = 5 THEN STEP2.point_sum		END
	,	adjust_point2		=	CASE WHEN #TABLE_RESULT.rater_status <= current_rater_step OR #TABLE_RESULT.final_rater_status = 5 THEN STEP2.adjust_point	END
	,	rank_kinds2			=	CASE WHEN #TABLE_RESULT.rater_status <= current_rater_step OR #TABLE_RESULT.final_rater_status = 5 THEN STEP2.rank_kinds	END
	,	rank_nm2			=	CASE WHEN #TABLE_RESULT.rater_status <= current_rater_step OR #TABLE_RESULT.final_rater_status = 5 THEN STEP2.rank_nm		END
	,	point_sum3			=	CASE WHEN #TABLE_RESULT.rater_status <= current_rater_step OR #TABLE_RESULT.final_rater_status = 5 THEN STEP3.point_sum		END
	,	adjust_point3		=	CASE WHEN #TABLE_RESULT.rater_status <= current_rater_step OR #TABLE_RESULT.final_rater_status = 5 THEN STEP3.adjust_point	END
	,	rank_kinds3			=	CASE WHEN #TABLE_RESULT.rater_status <= current_rater_step OR #TABLE_RESULT.final_rater_status = 5 THEN STEP3.rank_kinds	END
	,	rank_nm3			=	CASE WHEN #TABLE_RESULT.rater_status <= current_rater_step OR #TABLE_RESULT.final_rater_status = 5 THEN STEP3.rank_nm		END
	,	point_sum4			=	CASE WHEN #TABLE_RESULT.rater_status <= current_rater_step OR #TABLE_RESULT.final_rater_status = 5 THEN STEP4.point_sum		END
	,	adjust_point4		=	CASE WHEN #TABLE_RESULT.rater_status <= current_rater_step OR #TABLE_RESULT.final_rater_status = 5 THEN STEP4.adjust_point	END
	,	rank_kinds4			=	CASE WHEN #TABLE_RESULT.rater_status <= current_rater_step OR #TABLE_RESULT.final_rater_status = 5 THEN STEP4.rank_kinds	END
	,	rank_nm4			=	CASE WHEN #TABLE_RESULT.rater_status <= current_rater_step OR #TABLE_RESULT.final_rater_status = 5 THEN STEP4.rank_nm		END	
	--,	point_sum5			=	ISNULL(STEP5.point_sum,STEP5_1.point_sum) + ISNULL(STEP5.adjust_point,STEP5_1.adjust_point)
	--	↓↓↓ add by viettd 2021/04/01
	,	point_sum5			=	CASE 
									WHEN STEP5_確定.confirm_datetime IS NOT NULL
									THEN STEP5_確定.point_sum
									WHEN STEP5.company_cd IS NOT NULL
									THEN ISNULL(STEP5.point_sum,0) + ISNULL(STEP5.adjust_point,0) -- fixed by viettd 2025/10/27
									ELSE ISNULL(STEP5_1.point_sum,0) + ISNULL(STEP5_1.adjust_point,0)
								END		
	,	adjust_point5		=	CASE
									WHEN STEP5_確定.confirm_datetime IS NOT NULL
									THEN STEP5_確定.adjust_point
									WHEN STEP5.company_cd IS NOT NULL
									THEN ISNULL(STEP5.adjust_point,0)
									ELSE ISNULL(STEP5_1.adjust_point,0)
								END
	,	rank_kinds5			=	CASE
									WHEN STEP5_確定.confirm_datetime IS NOT NULL
									THEN STEP5_確定.rank_kinds
									WHEN STEP5.company_cd IS NOT NULL
									THEN ISNULL(STEP5.rank_kinds,0)
									ELSE ISNULL(STEP5_1.rank_kinds,0)
								END
	,	rank_nm5			=	CASE
									WHEN STEP5_確定.confirm_datetime IS NOT NULL
									THEN STEP5_確定.rank_nm
									WHEN STEP5.company_cd IS NOT NULL
									THEN ISNULL(STEP5.rank_nm,'')
									ELSE ISNULL(STEP5_1.rank_nm,'')
								END
	--	↑↑↑ end add by viettd 2021/04/01
	--,	adjust_point5		=	ISNULL(STEP5.adjust_point,STEP5_1.adjust_point)
	--,	rank_kinds5			=	ISNULL(STEP5.rank_kinds,STEP5_1.rank_kinds)
	--,	rank_nm5			=	ISNULL(STEP5.rank_nm,STEP5_1.rank_nm)
	FROM #TABLE_RESULT
	LEFT JOIN #STEP_LOGIN ON(
		#TABLE_RESULT.employee_cd				=	#STEP_LOGIN.employee_cd
	AND #TABLE_RESULT.treatment_applications_no	=	#STEP_LOGIN.treatment_applications_no
	)
	LEFT JOIN #TMP_POINT_SUM AS STEP1 ON(
		#TABLE_RESULT.employee_cd				=	STEP1.employee_cd
	AND	#TABLE_RESULT.fiscal_year				=	STEP1.fiscal_year
	AND	1										=	STEP1.evaluation_step
	AND #TABLE_RESULT.treatment_applications_no	=	STEP1.treatment_applications_no
	)
	LEFT JOIN #TMP_POINT_SUM AS STEP2 ON(
		#TABLE_RESULT.employee_cd				=	STEP2.employee_cd
	AND	#TABLE_RESULT.fiscal_year				=	STEP2.fiscal_year
	AND	2										=	STEP2.evaluation_step
	AND #TABLE_RESULT.treatment_applications_no	=	STEP2.treatment_applications_no
	)
	LEFT JOIN #TMP_POINT_SUM AS STEP3 ON(
		#TABLE_RESULT.employee_cd				=	STEP3.employee_cd
	AND	#TABLE_RESULT.fiscal_year				=	STEP3.fiscal_year
	AND	3										=	STEP3.evaluation_step
	AND #TABLE_RESULT.treatment_applications_no	=	STEP3.treatment_applications_no
	)
	LEFT JOIN #TMP_POINT_SUM AS STEP4 ON(
		#TABLE_RESULT.employee_cd				=	STEP4.employee_cd
	AND	#TABLE_RESULT.fiscal_year				=	STEP4.fiscal_year
	AND	4										=	STEP4.evaluation_step
	AND #TABLE_RESULT.treatment_applications_no	=	STEP4.treatment_applications_no
	)
	LEFT JOIN #TMP_POINT_SUM AS STEP5_1 ON( -- GET FROM F0120 MAX
		#TABLE_RESULT.employee_cd				=	STEP5_1.employee_cd
	AND	#TABLE_RESULT.fiscal_year				=	STEP5_1.fiscal_year
	AND	#STEP_LOGIN.max_step					=	STEP5_1.evaluation_step
	AND #TABLE_RESULT.treatment_applications_no	=	STEP5_1.treatment_applications_no
	)
	LEFT JOIN #TMP_POINT_SUM_FINAL_最終 AS STEP5 ON(	-- GET FROM F0201 OR MAX (F0200)
		#TABLE_RESULT.employee_cd				=	STEP5.employee_cd
	AND	#TABLE_RESULT.fiscal_year				=	STEP5.fiscal_year
	-- edited by viettd 2023/11/20
	AND (
		(#TABLE_RESULT.data_f0201_status <> 0 AND 0	=  STEP5.evaluation_step)
	OR	(#TABLE_RESULT.data_f0201_status = 0 AND #STEP_LOGIN.max_step = STEP5.evaluation_step)
	)
	--AND #STEP_LOGIN.max_step					=	STEP5.evaluation_step
	--OR 0	=	STEP5.evaluation_step
	AND #TABLE_RESULT.treatment_applications_no	=	STEP5.treatment_applications_no
	)
	-- add by viettd 2021/04/01
	LEFT JOIN #TMP_POINT_SUM_FINAL_最終 AS STEP5_確定 ON(	-- GET FROM F0201
		#TABLE_RESULT.employee_cd				=	STEP5_確定.employee_cd
	AND	#TABLE_RESULT.fiscal_year				=	STEP5_確定.fiscal_year
	AND 0										=	STEP5_確定.evaluation_step
	AND #TABLE_RESULT.treatment_applications_no	=	STEP5_確定.treatment_applications_no
	)
	-- WHEN PART
	IF @fiscal_year < @current_year and @authority_typ IN (2,6)
	BEGIN
		-- REMOVE EMPLOYEE WHEN LOGIN USER IS NOT RATER OF CURRENT YEAR AND NOT RATER OF PART YEAR
		DELETE D FROM #TABLE_RESULT AS D
		WHERE 
			D.current_year_is_rater = 0
		AND D.rater_employee_cd_1 <> @employee_cd
		AND D.rater_employee_cd_2 <> @employee_cd
		AND D.rater_employee_cd_3 <> @employee_cd
		AND D.rater_employee_cd_4 <> @employee_cd
		-- REMOVE EMPLOYEE WHEN LOGIN USER IS NOT RATER OF CURRENT YEAR AND SHEET DONE (LOGIN IS RATER OF PART YEAR)
		DELETE D FROM #TABLE_RESULT AS D
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
	--↓↓↓ add by viettd 2022/08/08
	-- FILTER 評語
	IF @screen_rank <> - 1
	BEGIN
		-- REMOVE ALL RECORD NOT EXISTS rank_kinds
		DELETE D 
		FROM #TABLE_RESULT AS D 
		WHERE
			D.company_cd	=	@P_company_cd
		AND ISNULL(D.rank_kinds1,'')	<>	@screen_rank
		AND ISNULL(D.rank_kinds2,'')	<>	@screen_rank
		AND ISNULL(D.rank_kinds3,'')	<>	@screen_rank
		AND ISNULL(D.rank_kinds4,'')	<>	@screen_rank
		AND ISNULL(D.rank_kinds5,'')	<>	@screen_rank			
	END
	--↑↑↑ end end by viettd 2022/08/08
	IF EXISTS (SELECT 1 FROM #TABLE_RESULT WHERE  final_rater_status = 5)
	BEGIN 
		UPDATE #TABLE_RESULT SET
			rater_step = 5
	END
	--
	UPDATE #TABLE_RESULT SET
		confirm_last_step = CASE 
								WHEN F0200.confirm_datetime	IS NOT NULL 
								THEN 1
								ELSE 0	
							END
	FROM #TABLE_RESULT 
	LEFT JOIN #STEP_LOGIN ON(
		#TABLE_RESULT.employee_cd				=	#STEP_LOGIN.employee_cd
	AND #TABLE_RESULT.treatment_applications_no	=	#STEP_LOGIN.treatment_applications_no
	)
	LEFT JOIN F0200 ON(
		@P_company_cd							=	F0200.company_cd
	AND	@fiscal_year							=	F0200.fiscal_year
	AND	#TABLE_RESULT.employee_cd				=	F0200.employee_cd
	AND	#TABLE_RESULT.treatment_applications_no	=	F0200.treatment_applications_no
	AND	((		#STEP_LOGIN.evaluation_step		=	F0200.evaluation_step
		  AND	#STEP_LOGIN.evaluation_step		<= @step
		 )
		OR
			(#STEP_LOGIN.max_step					=	F0200.evaluation_step)
		)
	)
	WHERE 
		#TABLE_RESULT.employee_cd				=	F0200.employee_cd
	AND @P_company_cd							=	F0200.company_cd
	AND	#TABLE_RESULT.fiscal_year				=	F0200.fiscal_year
	AND	#TABLE_RESULT.treatment_applications_no	=	F0200.treatment_applications_no
	-- update confirm_last_step_final
	UPDATE #TABLE_RESULT SET
		confirm_last_step_final	= CASE 
									WHEN F0200.confirm_datetime	IS NOT NULL 
									THEN 1
									ELSE 0	
								END
	FROM #TABLE_RESULT 
	LEFT JOIN #STEP_LOGIN ON(
		#TABLE_RESULT.employee_cd				=	#STEP_LOGIN.employee_cd
	AND #TABLE_RESULT.treatment_applications_no	=	#STEP_LOGIN.treatment_applications_no
	)
	LEFT JOIN F0200 ON(
		@P_company_cd							=	F0200.company_cd
	AND	@fiscal_year							=	F0200.fiscal_year
	AND	#TABLE_RESULT.employee_cd				=	F0200.employee_cd
	AND	#TABLE_RESULT.treatment_applications_no	=	F0200.treatment_applications_no
	AND	#STEP_LOGIN.max_step					=	F0200.evaluation_step
	)
	WHERE 
		#TABLE_RESULT.employee_cd				=	F0200.employee_cd
	AND @P_company_cd							=	F0200.company_cd
	AND	#TABLE_RESULT.fiscal_year				=	F0200.fiscal_year
	AND	#TABLE_RESULT.treatment_applications_no	=	F0200.treatment_applications_no
	--NEW COMMENT
	UPDATE #TABLE_RESULT SET
		comment = ISNULL(F0200.comment,F0201.comment)
	FROM #TABLE_RESULT
	LEFT JOIN #STEP_LOGIN ON(
		#TABLE_RESULT.employee_cd				=	#STEP_LOGIN.employee_cd
	AND #TABLE_RESULT.treatment_applications_no	=	#STEP_LOGIN.treatment_applications_no
	)
	LEFT JOIN F0200 ON (
		#TABLE_RESULT.company_cd				=	F0200.company_cd
	AND	#TABLE_RESULT.fiscal_year				=	F0200.fiscal_year
	AND	#TABLE_RESULT.employee_cd				=	F0200.employee_cd
	AND	#TABLE_RESULT.treatment_applications_no	=	F0200.treatment_applications_no
	AND	(
		(	#TABLE_RESULT.rater_status 			=	F0200.evaluation_step 
		AND (#TABLE_RESULT.current_rater_step	<> 5	OR (@authority_typ NOT IN (3,4,5)))
		)
		OR
		(
			#TABLE_RESULT.current_rater_step 	=	F0200.evaluation_step -- nguoi quan ly se lay comment theo buoc hien tai
		)
	)
	AND	F0200.del_datetime IS NULL 
	)
	LEFT JOIN F0201 ON(       --- lay comment nguoi quan ly
		#TABLE_RESULT.company_cd				=	F0201.company_cd
	AND	#TABLE_RESULT.fiscal_year				=	F0201.fiscal_year
	AND	#TABLE_RESULT.employee_cd				=	F0201.employee_cd
	AND	#TABLE_RESULT.treatment_applications_no	=	F0201.treatment_applications_no
	AND	F0201.del_datetime IS NULL 
	)
	WHERE 
		(#TABLE_RESULT.company_cd	=	@P_company_cd)
	AND	(#TABLE_RESULT.fiscal_year	=	@fiscal_year)
	-- UPDATE confirm_typ
	IF(@authority_typ IN (3,4,5))
	BEGIN
		--check confirm of @authority_typ =3,4,5 but in router 1->4 (confirmed->>0)
		UPDATE #TABLE_RESULT SET
			confirm_typ =	CASE 
								WHEN F0200.confirm_datetime	IS NOT NULL
								THEN 1	-- 確定
								ELSE 0	-- 未確定
							END
		FROM #TABLE_RESULT
		LEFT JOIN #STEP_LOGIN ON(
			#TABLE_RESULT.employee_cd				=	#STEP_LOGIN.employee_cd
		AND #TABLE_RESULT.treatment_applications_no	=	#STEP_LOGIN.treatment_applications_no
		)
		LEFT JOIN F0200 ON (
			#TABLE_RESULT.company_cd				=	F0200.company_cd
		AND	#TABLE_RESULT.fiscal_year				=	F0200.fiscal_year
		AND	#TABLE_RESULT.employee_cd				=	F0200.employee_cd
		AND	#TABLE_RESULT.treatment_applications_no	=	F0200.treatment_applications_no
		AND	#TABLE_RESULT.current_rater_step		=	F0200.evaluation_step   
		)
		WHERE 
			F0200.company_cd			=	@P_company_cd
		AND	F0200.fiscal_year			=	@fiscal_year
		AND #STEP_LOGIN.evaluation_step <>	0
		AND	F0200.del_datetime IS NULL
		--check confirm of final step (confirmed->>0)
		UPDATE #TABLE_RESULT SET
			confirm_typ	 =	CASE 
								WHEN F0201.confirm_datetime	IS NOT NULL 
								THEN 1  -- 確定
								ELSE 0　-- 未確定
							END
		FROM #TABLE_RESULT
		LEFT JOIN #STEP_LOGIN ON(
			#TABLE_RESULT.employee_cd				= #STEP_LOGIN.employee_cd
		AND #TABLE_RESULT.treatment_applications_no	=	#STEP_LOGIN.treatment_applications_no
		)
		LEFT JOIN F0201 ON (
			#TABLE_RESULT.company_cd				=	F0201.company_cd
		AND	#TABLE_RESULT.fiscal_year				=	F0201.fiscal_year
		AND	#TABLE_RESULT.employee_cd				=	F0201.employee_cd
		AND	#TABLE_RESULT.treatment_applications_no	=	F0201.treatment_applications_no
		)
		WHERE 
			F0201.company_cd						=	@P_company_cd
		AND	F0201.fiscal_year						=	@fiscal_year
		AND	#TABLE_RESULT.employee_cd				=	F0201.employee_cd
		AND	#TABLE_RESULT.treatment_applications_no	=	F0201.treatment_applications_no
		AND	F0201.del_datetime IS NULL
	END 
	ELSE
	BEGIN
		-- check when rater
		UPDATE #TABLE_RESULT SET
			confirm_typ	=	CASE 
								WHEN F0200.confirm_datetime	IS NOT NULL 
								THEN 1 -- 確定
								ELSE 0 -- 未確定
							END
		FROM #TABLE_RESULT
		LEFT JOIN F0200 ON (
			#TABLE_RESULT.company_cd				=	F0200.company_cd
		AND	#TABLE_RESULT.fiscal_year				=	F0200.fiscal_year
		AND	#TABLE_RESULT.employee_cd				=	F0200.employee_cd
		AND	#TABLE_RESULT.treatment_applications_no	=	F0200.treatment_applications_no
		AND	#TABLE_RESULT.current_rater_step		=	F0200.evaluation_step  
		)
		WHERE 
			F0200.company_cd	=	@P_company_cd
		AND	F0200.fiscal_year	=	@fiscal_year
		AND	F0200.del_datetime IS NULL
	END
	-- ↓↓↓ add by viettd 2021/04/02
	-- WHEN current_rater_step = 5 (最終評価)　then set final_evaluation_can_edited
	UPDATE #TABLE_RESULT SET 
		final_evaluation_can_edited	=	CASE
											-- 4.会社管理者　5.総合管理者
											WHEN @authority_typ	IN (4,5)  AND current_rater_step = 5 AND confirm_typ = 0 -- 未確定
											THEN 2 -- can edited
											WHEN @authority_typ	IN (4,5)  AND current_rater_step = 5 AND confirm_typ = 1 -- 確定
											THEN 1 -- can view
											--3.管理者
											---- add by viettd 2022/03/31
											--WHEN @authority_typ = 3 AND employee_cd = @employee_cd AND confirm_typ = 0 -- 未確定
											--THEN 0 -- not view
											--WHEN @authority_typ = 3 AND employee_cd = @employee_cd AND confirm_typ = 1 -- 確定
											--THEN 1 -- can view
											--WHEN @authority_typ = 3 AND rater_step IN (1,2,3,4) AND confirm_typ = 0 -- 未確定
											--THEN 0 -- not view
											--WHEN @authority_typ = 3 AND rater_step IN (1,2,3,4) AND confirm_typ = 1 -- 確定
											--THEN 1 -- can view
											--
											WHEN @authority_typ	= 3 AND @authority = 2 AND current_rater_step = 5  AND confirm_typ = 0 -- 未確定
											THEN 2 -- can edited
											WHEN @authority_typ	= 3 AND @authority = 2 AND current_rater_step = 5  AND confirm_typ = 1 -- 確定
											THEN 1 -- can view
											WHEN @authority_typ	= 3 AND @authority = 1 AND current_rater_step = 5 AND confirm_typ = 1 -- 確定
											THEN 1 -- can view
											WHEN @authority_typ	= 3 AND @authority = 1 AND current_rater_step = 5 AND confirm_typ = 0 -- 未確定
											THEN 0 -- not view
											WHEN @authority_typ	= 3 AND @authority = 0 AND current_rater_step = 5
											THEN 0 -- not view
											ELSE final_evaluation_can_edited
										END
	FROM #TABLE_RESULT
	-- ↑↑↑ end add by viettd 2021/04/02
	-- UPDATE feed_back_status
	UPDATE #TABLE_RESULT SET 
		feed_back_status =	CASE 
								WHEN (F0201.raterFB_datetime IS NOT NULL  )
								THEN 1
								ELSE 0 
							END
	FROM #TABLE_RESULT
	LEFT JOIN F0100 ON (
		@P_company_cd				=	F0100.company_cd
	AND @fiscal_year				=	F0100.fiscal_year
	AND #TABLE_RESULT.employee_cd	=	F0100.employee_cd
	AND F0100.del_datetime IS NULL
	)
	LEFT JOIN F0201 ON(
		@P_company_cd							=	F0201.company_cd
	AND	@fiscal_year							=	F0201.fiscal_year
	AND	#TABLE_RESULT.employee_cd				=	F0201.employee_cd
	AND	#TABLE_RESULT.treatment_applications_no	=	F0201.treatment_applications_no
	AND	F0201.del_datetime IS NULL
	)
	-- update max_feedback_status
	UPDATE #TABLE_RESULT SET 
		max_feedback_status = ( SELECT MAX(feed_back_status) FROM #TABLE_RESULT )
	--UPDATE max_last_confirm
	UPDATE #TABLE_RESULT SET 
		max_last_confirm	=	(SELECT MAX(confirm_last_step) FROM #TABLE_RESULT )
	--UPDATE MAX RATE STATUS
	UPDATE #TABLE_RESULT SET
		max_rate_status	=	CASE 
								WHEN #STEP.max_step <= @step AND #STEP.max_step <> 0 AND final_rater_status <> 5
								THEN #STEP.max_step
								ELSE @step
							END 
	FROM 
	(
		SELECT 
			MAX(#STEP_LOGIN.evaluation_step) AS max_step
		FROM #TABLE_RESULT 
		INNER JOIN #STEP_LOGIN ON(
			#TABLE_RESULT.employee_cd				=	#STEP_LOGIN.employee_cd
		AND #TABLE_RESULT.treatment_applications_no	=	#STEP_LOGIN.treatment_applications_no
		)
	) AS #STEP
	-- GET @max_rater_status_1
	SET @max_rater_status_1 = ( SELECT MAX(max_rate_status) FROM #TABLE_RESULT)
	-- ADMIN BUT NOT EDITED
	IF (@authority < 2 AND @authority_typ = 3)
	BEGIN
		UPDATE #TABLE_RESULT SET 
			--confirm_last_step_final = 0
			confirm_last_step_final =	CASE												-- edited by viettd 2021/04/02 
											WHEN @authority = 1	-- 1.only view
											THEN #TABLE_RESULT.confirm_last_step_final
											ELSE 0
										END					
		,	accept_input			=	0
		FROM #TABLE_RESULT 
		LEFT JOIN F0100  ON (
			#TABLE_RESULT.company_cd	= F0100.company_cd 
		AND #TABLE_RESULT.employee_cd	= F0100.employee_cd
		AND @fiscal_year				= F0100.fiscal_year
		)
		WHERE 
			F0100.rater_employee_cd_1 <> @employee_cd
		AND F0100.rater_employee_cd_2 <> @employee_cd
		AND F0100.rater_employee_cd_3 <> @employee_cd
		AND F0100.rater_employee_cd_4 <> @employee_cd													
	END
	--select * from #TEMP_F0120 
	UPDATE #TEMP_F0120 SET
		group_point_sum	=	CASE 
							WHEN #TABLE_RESULT.rater_status <= #TABLE_RESULT.current_rater_step OR #TABLE_RESULT.final_rater_status = 5 
							THEN CAST(ISNULL(STEP1.point_sum,0) AS NVARCHAR(10))+'/'+CAST(ISNULL(STEP2.point_sum,0) AS nvarchar(10))
								+'/'+CAST(ISNULL(STEP3.point_sum,0) AS nvarchar(10))+'/'+CAST(ISNULL(STEP4.point_sum,0) AS NVARCHAR(10))
								+'/'+ISNULL(CAST(#F0032.weight AS nvarchar(10)),'')+'/'+REPLACE(W_M0200.sheet_nm,'/','-')+'/'
								+CAST(M0200.sheet_cd AS nvarchar(10))+'/'+CAST(M0200.sheet_kbn AS nvarchar(10)) 
								+'/'+IIF(#SHEET_DISPLAY.submit_datetime IS NULL,'0','1')
							ELSE '////'+ISNULL(CAST(#F0032.weight AS nvarchar(10)),'')+'/'+REPLACE(W_M0200.sheet_nm,'/','-')+'/'
								+CAST(M0200.sheet_cd AS nvarchar(10))+'/'+CAST(M0200.sheet_kbn AS nvarchar(10))
								+'/'+IIF(#SHEET_DISPLAY.submit_datetime IS NULL,'0','1')
						END
	FROM  #TEMP_F0120
	LEFT JOIN #TABLE_RESULT ON (
		#TEMP_F0120.employee_cd					=	#TABLE_RESULT.employee_cd
	AND #TEMP_F0120.treatment_applications_no	=	#TABLE_RESULT.treatment_applications_no
	)
	LEFT JOIN #F0032 ON(
		#TEMP_F0120.company_cd			=	#F0032.company_cd
	AND	#TEMP_F0120.fiscal_year			=	#F0032.fiscal_year
	AND	#TEMP_F0120.employee_cd			=	#F0032.employee_cd
	AND	#TEMP_F0120.sheet_cd			=	#F0032.sheet_cd
	)
	LEFT JOIN F0120 AS #SHEET_DISPLAY ON(
		#TEMP_F0120.company_cd				=	#SHEET_DISPLAY.company_cd
	AND	#TEMP_F0120.fiscal_year				=	#SHEET_DISPLAY.fiscal_year
	AND	#TEMP_F0120.employee_cd				=	#SHEET_DISPLAY.employee_cd
	AND	#TEMP_F0120.sheet_cd				=	#SHEET_DISPLAY.sheet_cd
	AND	#TABLE_RESULT.current_rater_step	=	#SHEET_DISPLAY.evaluation_step
	AND #SHEET_DISPLAY.del_datetime IS NULL
	)
	LEFT JOIN F0120 AS STEP1 ON(
		#TEMP_F0120.company_cd	=	STEP1.company_cd
	AND	#TEMP_F0120.fiscal_year	=	STEP1.fiscal_year
	AND	#TEMP_F0120.employee_cd	=	STEP1.employee_cd
	AND	#TEMP_F0120.sheet_cd	=	STEP1.sheet_cd
	AND	1						=	STEP1.evaluation_step
	AND STEP1.del_datetime IS NULL
	)
	LEFT JOIN F0120 AS STEP2 ON(
		#TEMP_F0120.company_cd	=	STEP2.company_cd
	AND	#TEMP_F0120.fiscal_year	=	STEP2.fiscal_year
	AND	#TEMP_F0120.employee_cd	=	STEP2.employee_cd
	AND	#TEMP_F0120.sheet_cd	=	STEP2.sheet_cd
	AND 2						=	STEP2.evaluation_step
	AND STEP2.del_datetime IS NULL
	)
	LEFT JOIN F0120 AS STEP3 ON(
		#TEMP_F0120.company_cd	=	STEP3.company_cd
	AND	#TEMP_F0120.fiscal_year	=	STEP3.fiscal_year
	AND	#TEMP_F0120.employee_cd	=	STEP3.employee_cd
	AND	#TEMP_F0120.sheet_cd	=	STEP3.sheet_cd
	AND	3						=	STEP3.evaluation_step
	AND STEP3.del_datetime IS NULL
	)
	LEFT JOIN F0120 AS STEP4 ON(
		#TEMP_F0120.company_cd	=	STEP4.company_cd
	AND	#TEMP_F0120.fiscal_year	=	STEP4.fiscal_year
	AND	#TEMP_F0120.employee_cd	=	STEP4.employee_cd
	AND	#TEMP_F0120.sheet_cd	=	STEP4.sheet_cd
	AND	4						=	STEP4.evaluation_step
	AND STEP4.del_datetime IS NULL
	)
	LEFT JOIN M0200  ON (
		#TEMP_F0120.company_cd		=	M0200.company_cd
	AND	#TEMP_F0120.sheet_cd		=	M0200.sheet_cd
	AND	M0200.del_datetime IS NULL
	)
	LEFT JOIN W_M0200 ON(
		#TEMP_F0120.company_cd		=	W_M0200.company_cd
	AND	#TEMP_F0120.sheet_cd		=	W_M0200.sheet_cd
	AND	W_M0200.fiscal_year			=	@fiscal_year
	AND M0200.del_datetime IS NULL
	)

	WHERE #TEMP_F0120.company_cd				=	@P_company_cd
	AND	#TEMP_F0120.employee_cd					=	#F0032.employee_cd
	AND	#TEMP_F0120.fiscal_year					=	@fiscal_year
	AND	#TEMP_F0120.sheet_cd					=	#F0032.sheet_cd
	AND	#TEMP_F0120.treatment_applications_no	=	#F0032.treatment_applications_no
	INSERT INTO #F0120_SHEET_CD
	SELECT DISTINCT
		#TEMP_F0120.sheet_cd		AS	sheet_cd
	,	#TEMP_F0120.sheet_nm		AS	sheet_nm
	FROM #TEMP_F0120 
	LEFT JOIN #TABLE_RESULT ON(
		#TEMP_F0120.company_cd					=	@P_company_cd
	AND	#TEMP_F0120.fiscal_year					=	@fiscal_year
	AND	#TEMP_F0120.employee_cd					=	#TABLE_RESULT.employee_cd
	AND	#TEMP_F0120.treatment_applications_no	=	#TABLE_RESULT.treatment_applications_no
	)
	WHERE #TEMP_F0120.company_cd					=	@P_company_cd
	AND	#TEMP_F0120.fiscal_year					=	@fiscal_year
	AND	#TEMP_F0120.employee_cd					=	#TABLE_RESULT.employee_cd
	AND	#TEMP_F0120.treatment_applications_no	=	#TABLE_RESULT.treatment_applications_no
	--GET @string_column
	SELECT @string_column = stuff((select ',['+ cast((A.rank_sheet) as nvarchar(10))+'] '
								 from
								 (
									SELECT DISTINCT rank_sheet FROM #TEMP_F0120
								 ) AS A
								 for xml path('')),1,1,'')
								 --select @string_column


	-- get rank table
	INSERT INTO #TEMP_RANK
		SELECT 
		A.treatment_no
	,	(
		SELECT		
			W_M0130.rank_cd
		,	W_M0130.rank_nm
		,	ISNULL(CONVERT(nvarchar(20),W_M0130.points_from),'') AS points_from
		,	ISNULL(CONVERT(nvarchar(20),W_M0130.points_to),'') AS points_to
		FROM W_M0130
		INNER JOIN #TREATMENT_NO ON(
			W_M0130.company_cd					=	@P_company_cd
		AND W_M0130.fiscal_year					=	@fiscal_year
		AND W_M0130.treatment_applications_no	=	#TREATMENT_NO.treatment_no
		)
		WHERE 
			W_M0130.company_cd			=	@P_company_cd
		AND	W_M0130.fiscal_year			=	@fiscal_year
		AND #TREATMENT_NO.treatment_no	=	A.treatment_no
		AND	W_M0130.del_datetime IS NULL
		FOR JSON PATH
	) 
	FROM #TREATMENT_NO AS A
	INNER JOIN F0011 ON (
		@P_company_cd		=	F0011.company_cd
	AND @fiscal_year		=	F0011.fiscal_year
	AND A.treatment_no		=	F0011.treatment_applications_no
	AND F0011.del_datetime IS NULL
	)
	WHERE 
		F0011.sheet_use_typ = 1 -- USE SHEET
	-- add by viettd 2021/09/01
	INSERT INTO #TEMP_RANK
		SELECT 
		A.treatment_no
	,	(
		SELECT		
			M0130.rank_cd
		,	M0130.rank_nm
		,	ISNULL(CONVERT(nvarchar(20),M0130.points_from),'') AS points_from
		,	ISNULL(CONVERT(nvarchar(20),M0130.points_to),'') AS points_to
		FROM M0130
		INNER JOIN #TREATMENT_NO ON(
			M0130.company_cd					=	@P_company_cd
		AND M0130.treatment_applications_no		=	#TREATMENT_NO.treatment_no
		)
		WHERE 
			M0130.company_cd			=	@P_company_cd
		AND #TREATMENT_NO.treatment_no	=	A.treatment_no
		AND	M0130.del_datetime IS NULL
		FOR JSON PATH
	) 
	FROM #TREATMENT_NO AS A
	INNER JOIN F0011 ON (
		@P_company_cd		=	F0011.company_cd
	AND @fiscal_year		=	F0011.fiscal_year
	AND A.treatment_no		=	F0011.treatment_applications_no
	AND F0011.del_datetime IS NULL
	)
	WHERE 
		F0011.sheet_use_typ = 0 -- DONT USE SHEET
	-- end add by viettd 2021/09/01
	-- GET DATA FROM F0120 OF EACH SHEET_CD	
	SET @string_sql = 
	'
	SELECT
		company_cd					
	,	employee_cd	
	,	employee_cd_order_by
	,	furigana				
	,	fiscal_year									
	,	employee_nm					
	,	employee_typ_nm	
	,	employee_typ
	,	belong1_nm		
	,	belong_cd1		
	,	belong2_nm		
	,	belong_cd2	
	,	belong3_nm		
	,	belong_cd3	
	,	belong4_nm		
	,	belong_cd4	
	,	belong5_nm		
	,	belong_cd5		
	,	job_nm			
	,	job_cd			
	,	position_nm		
	,	position_cd		
	,	grade_nm		
	,	grade											
	,	IIF(point_sum1 = 0 ,NULL,	point_sum1)		AS			point_sum1	
	,	adjust_point1				
	,	rank_kinds1	
	,	rank_nm1					
	,	adjustpoint_input_1			
	,	rank_change_1				
	,	adjustpoint_from_1			
	,	adjustpoint_to_1			
	,	IIF(point_sum2 = 0 ,NULL,	point_sum2)		AS			point_sum2					
	,	adjust_point2				
	,	rank_kinds2	
	,	rank_nm2					
	,	adjustpoint_input_2			
	,	rank_change_2				
	,	adjustpoint_from_2			
	,	adjustpoint_to_2			
	,	IIF(point_sum3 = 0 ,NULL,	point_sum3)		AS			point_sum3					
	,	adjust_point3				
	,	rank_kinds3	
	,	rank_nm3					
	,	adjustpoint_input_3			
	,	rank_change_3				
	,	adjustpoint_from_3			
	,	adjustpoint_to_3			
	,	IIF(point_sum4 = 0 ,NULL,	point_sum4)		AS			point_sum4					
	,	adjust_point4				
	,	rank_kinds4	
	,	rank_nm4					
	,	adjustpoint_input_4			
	,	rank_change_4				
	,	adjustpoint_from_4			
	,	adjustpoint_to_4			
	,	IIF(point_sum5 = 0 ,NULL,	point_sum5)		AS			point_sum5				
	,	adjust_point5				
	,	rank_kinds5	
	,	rank_nm5					
	,	comment				
	,	treatment_applications_no	
	,	treatment_applications_nm	
	,	rater_status	
	,	final_rater_status
	,	rater_step					
	,	'+@string_column+'
	,	confirm_typ
	,	max_rate_status
	,	'+CONVERT(NVARCHAR(10),@max_rater_status_1)+' AS max_rate_status_1
	,	confirm_last_step
	,	confirm_last_step_final
	,	m0100_step
	,	feed_back_status
	,	max_feedback_status
	,	last_comment
	,	max_last_confirm
	,	rank_prev_1_nm
	,	rank_prev_2_nm
	,	rank_prev_3_nm
	,	sheet_use_typ
	,	'+CAST(@adjust_point AS NVARCHAR(10))+' AS adjust_point
	,	CASE WHEN '+CAST(@authority AS NVARCHAR(10))+' < 1 AND '+CAST(@authority_typ AS NVARCHAR(10))+' = 3 THEN 1 ELSE 0 END AS authority
	,	rank_json
	,	accept_input
	,	current_rater_step
	,	confirm_at_step
	,	final_evaluation_can_edited
	FROM

	(
	SELECT 
		#TABLE_RESULT.company_cd					
	,	#TABLE_RESULT.employee_cd
	,	#TABLE_RESULT.employee_cd_order_by
	,	#TABLE_RESULT.furigana					
	,	#TABLE_RESULT.fiscal_year								
	,	#TABLE_RESULT.employee_nm					
	,	#TABLE_RESULT.sheet_employee_typ_nm		AS	employee_typ_nm	
	,	#TABLE_RESULT.sheet_employee_typ		AS	employee_typ	
	,	#TABLE_RESULT.sheet_belong1_nm			AS	belong1_nm		
	,	#TABLE_RESULT.sheet_belong_cd1			AS	belong_cd1		
	,	#TABLE_RESULT.sheet_belong2_nm			AS	belong2_nm		
	,	#TABLE_RESULT.sheet_belong_cd2			AS	belong_cd2
	,	#TABLE_RESULT.sheet_belong3_nm			AS	belong3_nm
	,	#TABLE_RESULT.sheet_belong_cd3			AS	belong_cd3
	,	#TABLE_RESULT.sheet_belong4_nm			AS	belong4_nm
	,	#TABLE_RESULT.sheet_belong_cd4			AS	belong_cd4
	,	#TABLE_RESULT.sheet_belong5_nm			AS	belong5_nm
	,	#TABLE_RESULT.sheet_belong_cd5			AS	belong_cd5		
	,	#TABLE_RESULT.sheet_job_nm				AS	job_nm			
	,	#TABLE_RESULT.sheet_job_cd				AS	job_cd			
	,	#TABLE_RESULT.sheet_position_nm			AS	position_nm		
	,	#TABLE_RESULT.sheet_position_cd			AS	position_cd		
	,	#TABLE_RESULT.sheet_grade_nm			AS	grade_nm		
	,	#TABLE_RESULT.sheet_grade				AS	grade					
	,	#TABLE_RESULT.point_sum1					
	,	#TABLE_RESULT.adjust_point1				
	,	#TABLE_RESULT.rank_kinds1
	,	#TABLE_RESULT.rank_nm1					
	,	#TABLE_RESULT.adjustpoint_input_1			
	,	#TABLE_RESULT.rank_change_1				
	,	#TABLE_RESULT.adjustpoint_from_1			
	,	#TABLE_RESULT.adjustpoint_to_1			
	,	#TABLE_RESULT.point_sum2					
	,	#TABLE_RESULT.adjust_point2				
	,	#TABLE_RESULT.rank_kinds2	
	,	#TABLE_RESULT.rank_nm2					
	,	#TABLE_RESULT.adjustpoint_input_2			
	,	#TABLE_RESULT.rank_change_2				
	,	#TABLE_RESULT.adjustpoint_from_2			
	,	#TABLE_RESULT.adjustpoint_to_2			
	,	#TABLE_RESULT.point_sum3					
	,	#TABLE_RESULT.adjust_point3				
	,	#TABLE_RESULT.rank_kinds3	
	,	#TABLE_RESULT.rank_nm3					
	,	#TABLE_RESULT.adjustpoint_input_3			
	,	#TABLE_RESULT.rank_change_3				
	,	#TABLE_RESULT.adjustpoint_from_3			
	,	#TABLE_RESULT.adjustpoint_to_3			
	,	#TABLE_RESULT.point_sum4					
	,	#TABLE_RESULT.adjust_point4				
	,	#TABLE_RESULT.rank_kinds4
	,	#TABLE_RESULT.rank_nm4					
	,	#TABLE_RESULT.adjustpoint_input_4			
	,	#TABLE_RESULT.rank_change_4				
	,	#TABLE_RESULT.adjustpoint_from_4			
	,	#TABLE_RESULT.adjustpoint_to_4			
	,	#TABLE_RESULT.point_sum5					
	,	#TABLE_RESULT.adjust_point5				
	,	#TABLE_RESULT.rank_kinds5
	,	#TABLE_RESULT.rank_nm5					
	,	#TABLE_RESULT.comment						
	,	#TABLE_RESULT.treatment_applications_no	
	,	#TABLE_RESULT.treatment_applications_nm	
	,	#TABLE_RESULT.rater_status
	,	#TABLE_RESULT.rater_step													
	,	#TABLE_RESULT.final_rater_status			
	,	#TABLE_RESULT.confirm_typ	
	,	#TABLE_RESULT.max_rate_status										
	,	#TEMP_F0120.group_point_sum as group_point_sum		
	,	#TEMP_F0120.rank_sheet
	,	#TABLE_RESULT.confirm_last_step
	,	#TABLE_RESULT.confirm_last_step_final
	,	#TABLE_RESULT.max_last_confirm
	,	#TABLE_RESULT.m0100_step
	,	#TABLE_RESULT.feed_back_status
	,	#TABLE_RESULT.max_feedback_status
	,	#TABLE_RESULT.last_comment
	,	#TABLE_RESULT.rank_prev_1_nm
	,	#TABLE_RESULT.rank_prev_2_nm
	,	#TABLE_RESULT.rank_prev_3_nm
	,	#TABLE_RESULT.sheet_use_typ
	,	#TEMP_RANK.rank_json
	,	#TABLE_RESULT.accept_input
	,	#TABLE_RESULT.current_rater_step
	,	#TABLE_RESULT.confirm_at_step
	,	#TABLE_RESULT.final_evaluation_can_edited
	FROM #TABLE_RESULT
	LEFT JOIN #TEMP_RANK ON(
		#TABLE_RESULT.treatment_applications_no = #TEMP_RANK.treatment_applications_no
	)
	LEFT OUTER JOIN #TEMP_F0120 ON (
		#TABLE_RESULT.employee_cd				= 	#TEMP_F0120.employee_cd
	AND	#TABLE_RESULT.fiscal_year				= 	#TEMP_F0120.fiscal_year
	AND	#TABLE_RESULT.treatment_applications_no	=	#TEMP_F0120.treatment_applications_no	
	)
	
	) AS P
	Pivot(MAX(group_point_sum) FOR rank_sheet IN ('+@string_column+')) AS A
	ORDER BY	
		CASE ISNUMERIC(employee_cd) 
		   WHEN 1 
		   THEN CAST(employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	employee_cd
	,		treatment_applications_no
	OFFSET '+CAST(((@P_current_page-1) * @P_page_size)AS NVARCHAR(20))+' ROWS
	FETCH NEXT '+CAST(@P_page_size AS NVARCHAR)+' ROWS ONLY
	'
	--[0]
	IF(@string_sql <> '')
	BEGIN
		EXECUTE (@string_sql) 
	END
	ELSE
	BEGIN
		SELECT 
			company_cd									
		,	employee_cd									
		,	employee_cd_order_by						
		,	furigana									
		,	fiscal_year									
		,	sheet_cd									
		,	employee_nm									
		,	sheet_employee_typ_nm	AS	employee_typ_nm								
		,	sheet_employee_typ		AS	employee_typ							
		,	sheet_belong1_nm		AS	belong1_nm								
		,	sheet_belong_cd1		AS	belong_cd1								
		,	sheet_belong2_nm		AS	belong2_nm								
		,	sheet_belong_cd2		AS	belong_cd2								
		,	sheet_belong3_nm		AS	belong3_nm								
		,	sheet_belong_cd3		AS	belong_cd3								
		,	sheet_belong4_nm		AS	belong4_nm								
		,	sheet_belong_cd4		AS	belong_cd4								
		,	sheet_belong5_nm		AS	belong5_nm								
		,	sheet_belong_cd5		AS	belong_cd5								
		,	sheet_job_nm			AS	job_nm									
		,	sheet_job_cd			AS	job_cd									
		,	sheet_position_nm		AS	position_nm								
		,	sheet_position_cd		AS	position_cd								
		,	sheet_grade_nm			AS	grade_nm								
		,	sheet_grade				AS	grade									
		,	point_sum1									
		,	adjust_point1								
		,	rank_kinds1									
		,	rank_nm1									
		,	adjustpoint_input_1							
		,	rank_change_1								
		,	adjustpoint_from_1							
		,	adjustpoint_to_1							
		,	point_sum2									
		,	adjust_point2								
		,	rank_kinds2									
		,	rank_nm2									
		,	adjustpoint_input_2							
		,	rank_change_2								
		,	adjustpoint_from_2							
		,	adjustpoint_to_2							
		,	point_sum3									
		,	adjust_point3								
		,	rank_kinds3									
		,	rank_nm3									
		,	adjustpoint_input_3							
		,	rank_change_3								
		,	adjustpoint_from_3							
		,	adjustpoint_to_3							
		,	point_sum4									
		,	adjust_point4								
		,	rank_kinds4									
		,	rank_nm4									
		,	adjustpoint_input_4							
		,	rank_change_4								
		,	adjustpoint_from_4							
		,	adjustpoint_to_4							
		,	point_sum5									
		,	adjust_point5								
		,	rank_kinds5									
		,	rank_nm5									
		,	comment										
		,	treatment_applications_no					
		,	treatment_applications_nm					
		,	rater_status								
		,	final_rater_status							
		,	rater_step									
		,	confirm_typ									
		,	max_rate_status								
		,	confirm_last_step		
		,	0 AS confirm_last_step_final
		,	m0100_step									
		,	feed_back_status							
		,	max_feedback_status							
		,	part_status									
		,	last_comment								
		,	data_f0201_status							
		,	0	AS 	max_rate_status_1					
		,	rank_prev_1_nm								
		,	rank_prev_2_nm								
		,	rank_prev_3_nm								
		,	sheet_use_typ	
		,	accept_input		
		,	0 AS current_rater_step
		,	0 AS confirm_at_step
		,	@authority AS authority
		,	final_evaluation_can_edited
		FROM #TABLE_RESULT
	END
	--[1]
	SELECT 
		#F0120_SHEET_CD.sheet_cd		AS	sheet_cd
	,	#F0120_SHEET_CD.sheet_nm		AS	sheet_nm
	,	M0200.sheet_kbn
	FROM #F0120_SHEET_CD 
	LEFT JOIN M0200 ON(
		@P_company_cd				=	M0200.company_cd
	AND	#F0120_SHEET_CD.sheet_cd	=	M0200.sheet_cd
	)
	ORDER BY #F0120_SHEET_CD.sheet_cd asc
	--[2]
	SELECT @fiscal_year AS fiscal_year
	--[3]
	SET @totalRecord = (SELECT COUNT(1) FROM 
								(SELECT DISTINCT 
									company_cd
								,	fiscal_year
								,	treatment_applications_no
								,	employee_cd  
								FROM #TABLE_RESULT ) AS A
						)

	SET @pageNumber = CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	SELECT @totalRecord AS totalRecord
	,	 @pageNumber AS pageMax
	,	 @P_current_page AS [page]
	,	 @P_page_size AS pagesize
	,	((@P_current_page - 1) * @P_page_size + 1) AS offset
	--[4]
	SELECT MAX(rank_sheet) AS max_sheet
	FROM #TEMP_F0120
	--[5]
	SELECT MAX(A.f0100_step) AS f0100_step
	FROM
	(
	SELECT 
		CASE WHEN F0100.rater_employee_cd_4 <> '' 
			 THEN 4
			 WHEN F0100.rater_employee_cd_4 = '' AND  F0100.rater_employee_cd_3 <> ''
			 THEN 3
			 WHEN F0100.rater_employee_cd_4 = '' AND  F0100.rater_employee_cd_3 = '' AND F0100.rater_employee_cd_2 <> ''
			 THEN 2
			 ELSE 1 
		END AS f0100_step
	FROM F0100 
	WHERE company_cd = @P_company_cd
	AND del_datetime IS NULL
	) AS A
	--[6]
	SELECT 
		MAX(ISNULL(sheet_use_typ,0)) AS sheet_use_typ
	FROM F0011 INNER JOIN #TREATMENT_NO ON(
		#TREATMENT_NO.treatment_no = F0011.treatment_applications_no
	)
	WHERE 
		F0011.company_cd				= @P_company_cd
	AND F0011.fiscal_year				= @fiscal_year
	AND F0011.del_datetime IS NULL
	--
	DROP TABLE #F0032
	DROP TABLE #F0120_SHEET_CD
	DROP TABLE #GRADE
	DROP TABLE #POSITION_CD
	DROP TABLE #SCREEN_EMPLOYEE
	DROP TABLE #STEP_LOGIN
	DROP TABLE #TABLE_ORGANIZATION
	DROP TABLE #TABLE_RESULT
	DROP TABLE #TEMP_F0120
	DROP TABLE #TEMP_M0072
	DROP TABLE #TEMP_RANK
	DROP TABLE #TMP_POINT_SUM
	DROP TABLE #TMP_POINT_SUM_FINAL_最終
	DROP TABLE #TREATMENT_NO
	DROP TABLE #M0070H
	DROP TABLE #M0071_SHEET
	DROP TABLE #TABLE_EVALUATION_STEP
END
GO