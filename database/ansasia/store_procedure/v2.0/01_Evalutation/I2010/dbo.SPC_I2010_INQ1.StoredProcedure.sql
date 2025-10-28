DROP PROCEDURE [SPC_I2010_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ M0170
-- EXEC [SPC_I2010_INQ1] '2018','ans721','1','999';
-- EXEC SPC_I2010_INQ1 '2019','5','a728','a728','a728','1007';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	REFER DATA
--*  
--*  作成日/create date			:	2018/10/01						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2019/01/28
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	dont show blank row	
--*   					
--*  更新日/update date			:	2019/06/05
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	add view 部・課	
--*   					
--*  更新日/update date			:	2019/06/12
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	move F0111.progress_comment_self,progress_comment_rater to F0110
--*   					
--*  更新日/update date			:	2019/12/10
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgrade version 1.6
--*   					
--*  更新日/update date			:	2020/03/16
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	view 組織 in screen
--*   					
--*  更新日/update date			:	2020/10/09
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgradate ver 1.7 & 1on1
--*   					
--*  更新日/update date			:	2020/12/07
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	show M0310.detail_no
--*   					
--*  更新日/update date			:	2021/02/18
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	remove (目標タイトル) for weight_required_status
--*   					
--*  更新日/update date			:	2021/03/25
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	remove [※F0111.weightが0で登録されている場合は、「1（＝100％）」として計算をする]
--*   					
--*  更新日/update date			:	2021/11/16
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	※W_M0200.weight_display_typ、W_M0200.challenge_level_display_typが「0」で登録されている場合は、「1」として計算をする
--*   					
--*  更新日/update date			:	2021/12/01 			
--*　更新者/updater				:　	viettd　  　			
--*　更新内容/update content		:	upgradate ver 1.8
--*   					
--*  更新日/update date			:	2022/08/16 			
--*　更新者/updater				:　	viettd　  　			
--*　更新内容/update content		:	upgradate ver 1.9
--*   					
--*  更新日/update date			:	2024/02/16 			
--*　更新者/updater				:　	viettd　  　			
--*　更新内容/update content		:	get W_M0200.weight_display_typ 
--*   					
--*  更新日/update date			:	2025/02/11		
--*　更新者/updater				:　	viettd　  　			
--*　更新内容/update content		:	change upload_file from W_M0200 to M0200 
--*   		
--****************************************************************************************
CREATE PROCEDURE [SPC_I2010_INQ1]
	@P_fiscal_year				int				=	0
,	@P_sheet_cd					smallint		=	0
,	@P_employee_cd				nvarchar(10)	=	''
,	@P_login_employee_cd		nvarchar(10)	=	''
,	@P_cre_user					nvarchar(50)	=	''
,	@P_company_cd				smallint		=	0

AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@year_month_day			date			=	NULL
	,	@status_cd				smallint		=	0
	,	@sheet_cd				smallint		=	0
	,	@login_user_typ			smallint		=	1	--	1. 被評価者用 21.一次評価 22.二次評価 23.三次評価 24.四次評価 3.管理者
	,	@goal_number			smallint		=	0
	,	@i						smallint		=	1
	,	@point_kinds			smallint		=	0
	,	@point_calculation_typ1	smallint		=	0	-- add by viettd 2019/12/10
	,	@point_calculation_typ2	smallint		=	0	-- add by viettd 2019/12/10
	,	@generic_comment_cnt	smallint		=	0	-- add by viettd 2019/12/10	
	--
	,	@item_no_count			numeric(8,2)	=	0
	,	@beginning_date			date			=	NULL
	,	@w_evaluation_self_typ	tinyint			=	0
	,	@w_language		SMALLINT				=	1	--add by vietdt	2022/08/31 
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--CREATE TEMP TABLE
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF object_id('tempdb..#BUTTON_TEMP', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #BUTTON_TEMP
    END
	IF object_id('tempdb..#F0111_TEMP', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F0111_TEMP
    END
	IF object_id('tempdb..#M0200_HIDE_SHOW', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0200_HIDE_SHOW
    END
	IF object_id('tempdb..#TABLE_評価コメント入力', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_評価コメント入力
    END
	IF object_id('tempdb..#TABLE_評価シート入力', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_評価シート入力
    END
	IF object_id('tempdb..#TABLE_評価シート入力の合計', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_評価シート入力の合計
    END
	--
	IF object_id('tempdb..#TABLE_M0310', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_M0310
    END
	--
	IF object_id('tempdb..#M0071_SHEET', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0071_SHEET
    END
	--
	CREATE TABLE #TABLE_M0310 (
		id						smallint			identity(1,1)
	,	category				smallint
	,	status_cd				smallint
	,	status_nm				nvarchar(100)
	,	status_use_typ			tinyint
	,	detail_no				smallint	-- add 2020/12/07
	)
	--
	CREATE TABLE #M0022 (
		id						int		identity(1,1)
	,	organization_typ		tinyint
	,	use_typ					smallint
	,	organization_group_nm	nvarchar(50)
	)
	--
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
	,	grade_nm						nvarchar(50)
	,	employee_typ_nm					nvarchar(50)
	)
	--
	CREATE TABLE #M0200_HIDE_SHOW(
		company_cd									smallint
	,	sheet_cd									smallint
	,	details_feedback_typ						tinyint
	,	comments_feedback_typ						tinyint
	--	汎用
	,	generic_comment_title_1						nvarchar(20)
	,	generic_comment_title_2						nvarchar(20)
	,	generic_comment_title_3						nvarchar(20)
	,	generic_comment_title_4						nvarchar(20)
	,	generic_comment_title_5						nvarchar(20)
	,	generic_comment_title_6						nvarchar(20)
	,	generic_comment_title_7						nvarchar(20)
	,	generic_comment_title_8						nvarchar(20)
	,	generic_comment_status1						tinyint
	,	generic_comment_status2						tinyint
	,	generic_comment_status3						tinyint
	,	generic_comment_status4						tinyint
	,	generic_comment_status5						tinyint
	,	generic_comment_status6						tinyint
	,	generic_comment_status7						tinyint
	,	generic_comment_status8						tinyint			-- add by viettd 2020/10/09
	--	評価シート入力
	,	goal_number									smallint
	,	item_title_title							nvarchar(20)	-- add by viettd 2020/10/09
	,	item_title_1								nvarchar(20)
	,	item_title_2								nvarchar(20)
	,	item_title_3								nvarchar(20)
	,	item_title_4								nvarchar(20)
	,	item_title_5								nvarchar(20)
	--
	,	detail_self_progress_comment_title			nvarchar(50)	-- 自己明細進捗コメントタイトル		add by viettd 2021/12/01
	,	detail_progress_comment_title				nvarchar(50)	-- 明細進捗コメントタイトル			add by viettd 2021/12/01
	,	self_progress_comment_title					nvarchar(50)	-- 自己進捗コメントタイトル			add by viettd 2021/12/01
	,	progress_comment_title						nvarchar(50)	-- 進捗コメントタイトル				add by viettd 2021/12/01

	,	item_title_status							tinyint			-- add by viettd 2020/10/09
	,	item_display_status_1						tinyint
	,	item_display_status_2						tinyint
	,	item_display_status_3						tinyint
	,	item_display_status_4						tinyint
	,	item_display_status_5						tinyint
	,	weight_display_status						tinyint	--	ウェイト
	,	weight_display_nm							nvarchar(20)	-- ウェイト名
	,	challenge_level_display_status				tinyint	--	難易度
	,	detail_self_progress_comment_display_status	tinyint	--	明細自己進捗評価コメント	-- add by viettd 2021/12/01
	,	detail_progress_comment_display_status		tinyint	--	明細進捗評価コメント
	,	progress_comment_display_status				tinyint	--	自己進捗コメント
	--
	,	progress_comment_display_status1			tinyint	--	一次評価者進捗コメント
	,	progress_comment_display_status2			tinyint			-- 二次評価者進捗コメント		add by viettd 2021/12/01
	,	progress_comment_display_status3			tinyint			-- 三次評価者進捗コメント		add by viettd 2021/12/01
	,	progress_comment_display_status4			tinyint			-- 四次評価者進捗コメント		add by viettd 2021/12/01
	--
	,	detail_comment_display_status1				tinyint	--	評価コメント1
	,	detail_comment_display_status2				tinyint	--	評価コメント2
	,	detail_comment_display_status3				tinyint	--	評価コメント3
	,	detail_comment_display_status4				tinyint	--	評価コメント4
	--
	,	detail_myself_comment_display_status		tinyint	--	自己評価コメント
	,	evaluation_display_status0					tinyint	--	自己評価
	,	evaluation_display_status1					tinyint	--	一次評価
	,	evaluation_display_status2					tinyint	--	二次評価
	,	evaluation_display_status3					tinyint	--	三次評価
	,	evaluation_display_status4					tinyint	--	四次評価
	,	total_score_display_status					tinyint	--	合計点
	--
	,	evaluation_comment_status0					tinyint	--	自己評価コメント
	,	evaluation_comment_status1					tinyint	--	一次評価コメント
	,	evaluation_comment_status2					tinyint	--	二次評価コメント
	,	evaluation_comment_status3					tinyint	--	三次評価コメント
	,	evaluation_comment_status4					tinyint	--	四次評価コメント
	--
	,	point_criteria_display_status				tinyint	-- 評価基準
	,	challengelevel_criteria_display_status		tinyint	-- 難易度基準
	,	self_assessment_comment_display_status		tinyint	-- 自己評価コメント
	,	evaluation_comment_display_status			tinyint	-- 評価者コメント
	,	login_user_typ								smallint-- ログイン者
	)
	--
	CREATE TABLE #BUTTON_TEMP (
		memoryButton  					int			--	一時保存			
	,	saveButton   					int			--	確定
	,	approveButton  					int			--	承認
	,	sendBackButton  				int			--	差戻
	,	interviewButton  				int			--	面談記録
	)
	--
	CREATE TABLE #TABLE_評価シート入力(
		company_cd					smallint
	,	sheet_cd					smallint
	,	evaluation_step				smallint
	,	item_no						smallint
	,	point_cd					smallint	
	,	point						numeric(8,2)
	,	betting_rate				numeric(8,2)
	,	weight						smallint
	)
	--
	CREATE TABLE #TABLE_評価シート入力の合計(
		company_cd					smallint
	,	sheet_cd					smallint
	,	point_sum0					numeric(8,2)	--	自己評価
	,	point_sum1					numeric(8,2)	--	一次評価
	,	point_sum2					numeric(8,2)	--	二次評価
	,	point_sum3					numeric(8,2)	--	三次評価
	,	point_sum4					numeric(8,2)	--	四次評価
	)
	-- 評価シート入力
	CREATE TABLE #F0111_TEMP (
		company_cd						smallint
	,	fiscal_year						int
	,	employee_cd						nvarchar(10)
	,	sheet_cd						smallint
	,	item_no							smallint
	,	weight_required_status			smallint
	,	item_required_status			smallint
	,	weight							smallint
	)
	--
	--add by vietdt	2022/08/31
	SELECT 
		@w_language			=	ISNULL(S0010.language,1)	
	FROM S0010
	WHERE 
		S0010.company_cd	= @P_company_cd 
	AND S0010.user_id		= @P_cre_user
	AND S0010.del_datetime IS NULL
	--
	-- RUN STORE PROCEDUCE
	INSERT INTO #M0200_HIDE_SHOW
	EXEC [dbo].SPC_I2010_LST1 @P_fiscal_year,@P_sheet_cd,@P_employee_cd,@P_login_employee_cd,@P_cre_user,@P_company_cd
	--
	INSERT INTO #BUTTON_TEMP
	EXEC [dbo].SPC_I2010_LST2 @P_fiscal_year,@P_sheet_cd,@P_employee_cd,@P_login_employee_cd,@P_cre_user,@P_company_cd
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
		IF @P_fiscal_year <> 0
		BEGIN
			SET @year_month_day = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
			SET @year_month_day = DATEADD(DD,-1,DATEADD(YYYY,1,@year_month_day))
		END 
	END
	ELSE
	BEGIN 
		SET @year_month_day = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/12/31') AS DATE)
	END
	
	--INSERT INTO #M0070H
	--EXEC [dbo].SPC_REFER_M0070H_INQ1 @year_month_day,'',@P_company_cd
	INSERT INTO #M0071_SHEET
	EXEC [dbo].SPC_REFER_M0071_INQ1 @P_fiscal_year,'',0,@P_company_cd
	-- GET @status_cd
	SET @status_cd = (SELECT ISNULL(F0100.status_cd,0) FROM F0100 WHERE 
																	F0100.company_cd	= @P_company_cd 
																AND F0100.fiscal_year	= @P_fiscal_year 
																AND F0100.employee_cd	= @P_employee_cd 
																AND F0100.sheet_cd		= @P_sheet_cd 
																AND F0100.del_datetime IS NULL)
	-- GET @point_kinds + @point_calculation_typ
	SELECT 
		@point_kinds				= ISNULL(W_M0200.point_kinds,0) 
	,	@point_calculation_typ1		= ISNULL(W_M0200.point_calculation_typ1,0)
	,	@point_calculation_typ2		= ISNULL(W_M0200.point_calculation_typ2,0)
	,	@goal_number				= ISNULL(W_M0200.goal_number,0)
	,	@w_evaluation_self_typ		= ISNULL(W_M0200.evaluation_self_typ,0) 	
	FROM W_M0200 
	WHERE 
		W_M0200.company_cd		=	@P_company_cd 
	AND W_M0200.fiscal_year		=	@P_fiscal_year
	AND W_M0200.sheet_cd		=	@P_sheet_cd 
	AND W_M0200.del_datetime IS NULL
	-- GET #M0200_HIDE_SHOW
	SELECT 
		@login_user_typ = ISNULL(#M0200_HIDE_SHOW.login_user_typ,0)
	FROM #M0200_HIDE_SHOW
	--	CHECK COUNT HEADER @generic_comment_cnt
	SELECT 
		@generic_comment_cnt	=	IIF(ISNULL(#M0200_HIDE_SHOW.generic_comment_status1,0) > 0 , 1 , 0)
								+	IIF(ISNULL(#M0200_HIDE_SHOW.generic_comment_status2,0) > 0 , 1 , 0)
								+	IIF(ISNULL(#M0200_HIDE_SHOW.generic_comment_status3,0) > 0 , 1 , 0)
								+	IIF(ISNULL(#M0200_HIDE_SHOW.generic_comment_status4,0) > 0 , 1 , 0)
								+	IIF(ISNULL(#M0200_HIDE_SHOW.generic_comment_status5,0) > 0 , 1 , 0)
								+	IIF(ISNULL(#M0200_HIDE_SHOW.generic_comment_status6,0) > 0 , 1 , 0)
								+	IIF(ISNULL(#M0200_HIDE_SHOW.generic_comment_status7,0) > 0 , 1 , 0)
	FROM #M0200_HIDE_SHOW
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--RESULT 
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--[0] button
	SELECT 
		memoryButton  	
	,	saveButton			as	confirmButton2   	
	,	approveButton  	
	,	sendBackButton  
	,	interviewButton 
	FROM #BUTTON_TEMP
	--[1] 社員情報
	SELECT 
		@status_cd									AS	status_cd
	,	CASE 
			WHEN ISNULL(M0310.status_nm,'') <> ''
			THEN ISNULL(M0310.status_nm,'')
			ELSE ISNULL(IIF(@w_language = 2,L0040_1.status_nm_english,L0040_1.status_nm),'')
		END											AS	status_nm			--	ステータス
	,	ISNULL(M0070.employee_cd,'')				AS	employee_cd			--	社員コード
	,	ISNULL(M0070.employee_nm,'')				AS	employee_nm			--	社員名
	,	@P_fiscal_year								AS	fiscal_year
	,	@P_sheet_cd									AS	sheet_cd
	,	ISNULL(W_M0200.sheet_nm,'')					AS	sheet_nm
	,	ISNULL(W_M0200.point_calculation_typ1,0)	AS	point_calculation_typ1	-- add by viettd 2019/12/10
	,	ISNULL(W_M0200.point_calculation_typ2,0)	AS	point_calculation_typ2	-- add by viettd 2019/12/10
	,	ISNULL(W_M0200.weight_display_typ,0)		AS	weight_display_typ		-- add by viettd 2024/02/16
	,	ISNULL(L0010_7.name,'')						AS	category
	,	ISNULL(#M0071_SHEET.employee_typ_nm,'')		AS	employee_typ_nm
	,	ISNULL(#M0071_SHEET.job_nm,'')				AS	job_nm
	,	ISNULL(#M0071_SHEET.position_nm,'')			AS	position_nm
	,	ISNULL(#M0071_SHEET.grade_nm,'')			AS	grade_nm
	,	ISNULL(M0070.salary_grade,0)				AS	salary_grade
	--
	,	ISNULL(#M0071_SHEET.belong_nm1,'')			AS	belong_nm1				-- add by viettd 2019/12/10
	,	ISNULL(#M0071_SHEET.belong_nm2,'')			AS	belong_nm2				-- add by viettd 2019/12/10
	,	ISNULL(#M0071_SHEET.belong_nm3,'')			AS	belong_nm3				-- add by viettd 2019/12/10
	,	ISNULL(#M0071_SHEET.belong_nm4,'')			AS	belong_nm4				-- add by viettd 2019/12/10
	,	ISNULL(#M0071_SHEET.belong_nm5,'')			AS	belong_nm5				-- add by viettd 2019/12/10
	--
	,	ISNULL(M0070_1.employee_nm,'')				AS	rater_employee_cd_1
	,	ISNULL(M0070_2.employee_nm,'')				AS	rater_employee_cd_2
	,	ISNULL(M0070_3.employee_nm,'')				AS	rater_employee_cd_3
	,	ISNULL(M0070_4.employee_nm,'')				AS	rater_employee_cd_4
	,	ISNULL(M0070.picture,'')					AS	picture
	,	ISNULL(M0200.upload_file_nm,'')				AS	upload_file
	,	'/uploads/m0160/'+CONVERT(NVARCHAR(10),@P_company_cd)+'/'+ISNULL(M0200.upload_file,'') 
													AS	file_address
	,	ISNULL(M0070.mail,'')						AS	mail
	FROM M0070
	LEFT JOIN F0100 ON (
		M0070.company_cd			=	F0100.company_cd
	AND @P_fiscal_year				=	F0100.fiscal_year
	AND M0070.employee_cd			=	F0100.employee_cd
	AND @P_sheet_cd					=	F0100.sheet_cd
	AND F0100.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0040 AS L0040_1 ON (
		1					=	L0040_1.category
	AND @status_cd			=	L0040_1.status_cd
	)
	--LEFT OUTER JOIN #M0070H ON (
	--	M0070.company_cd			=	#M0070H.company_cd
	--AND M0070.employee_cd			=	#M0070H.employee_cd
	--)
	LEFT OUTER JOIN #M0071_SHEET ON (
		F0100.company_cd			=	#M0071_SHEET.company_cd
	AND F0100.fiscal_year			=	#M0071_SHEET.fiscal_year
	AND F0100.employee_cd			=	#M0071_SHEET.employee_cd
	AND F0100.sheet_cd				=	#M0071_SHEET.sheet_cd
	)
	LEFT OUTER JOIN W_M0200 ON (
		@P_company_cd				=	W_M0200.company_cd
	AND @P_fiscal_year				=	W_M0200.fiscal_year
	AND @P_sheet_cd					=	W_M0200.sheet_cd
	)
	LEFT OUTER JOIN M0200 ON (
		@P_company_cd				=	M0200.company_cd
	AND @P_sheet_cd					=	M0200.sheet_cd
	AND M0200.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0010 AS L0010_7 ON (
		7							=	L0010_7.name_typ
	AND	W_M0200.category			=	L0010_7.number_cd
	)
	LEFT OUTER JOIN M0310 ON (
		@P_company_cd				=	M0310.company_cd
	AND W_M0200.sheet_kbn			=	M0310.category
	AND @status_cd					=	M0310.status_cd
	)
	LEFT OUTER JOIN M0070 AS M0070_1 ON (
		F0100.company_cd				=	M0070_1.company_cd
	AND F0100.rater_employee_cd_1		=	M0070_1.employee_cd
	)
	LEFT OUTER JOIN M0070 AS M0070_2 ON (
		F0100.company_cd				=	M0070_2.company_cd
	AND F0100.rater_employee_cd_2		=	M0070_2.employee_cd
	)
	LEFT OUTER JOIN M0070 AS M0070_3 ON (
		F0100.company_cd				=	M0070_3.company_cd
	AND F0100.rater_employee_cd_3		=	M0070_3.employee_cd
	)
	LEFT OUTER JOIN M0070 AS M0070_4 ON (
		F0100.company_cd				=	M0070_4.company_cd
	AND F0100.rater_employee_cd_4		=	M0070_4.employee_cd
	)
	WHERE 
		M0070.company_cd			=	@P_company_cd
	AND M0070.employee_cd			=	@P_employee_cd
	AND M0070.del_datetime IS NULL
	--[2] 画面表示
	SELECT
	--	汎用
		#M0200_HIDE_SHOW.generic_comment_title_1			
	,	#M0200_HIDE_SHOW.generic_comment_title_2		
	,	#M0200_HIDE_SHOW.generic_comment_title_3			
	,	#M0200_HIDE_SHOW.generic_comment_title_4			
	,	#M0200_HIDE_SHOW.generic_comment_title_5
	,	#M0200_HIDE_SHOW.generic_comment_title_6
	,	#M0200_HIDE_SHOW.generic_comment_title_7
	,	#M0200_HIDE_SHOW.generic_comment_title_8			
	,	#M0200_HIDE_SHOW.generic_comment_status1			
	,	#M0200_HIDE_SHOW.generic_comment_status2			
	,	#M0200_HIDE_SHOW.generic_comment_status3			
	,	#M0200_HIDE_SHOW.generic_comment_status4			
	,	#M0200_HIDE_SHOW.generic_comment_status5
	,	#M0200_HIDE_SHOW.generic_comment_status6
	,	#M0200_HIDE_SHOW.generic_comment_status7
	,	#M0200_HIDE_SHOW.generic_comment_status8		
	,	CASE 
			WHEN F0101.company_cd IS NULL
			THEN ISNULL(W_M0200.generic_comment_1,'')
			ELSE ISNULL(F0101.generic_comment_1,'')
		END											AS	generic_comment_1
	,	CASE 
			WHEN F0101.company_cd IS NULL
			THEN ISNULL(W_M0200.generic_comment_2,'')
			ELSE ISNULL(F0101.generic_comment_2,'')	
		END											AS	generic_comment_2	
	,	CASE 
			WHEN F0101.company_cd IS NULL
			THEN ISNULL(W_M0200.generic_comment_8,'')
			ELSE ISNULL(F0101.generic_comment_8,'')	
		END											AS	generic_comment_8			-- add by viettd 2020/10/09
	
	,	ISNULL(F0101.generic_comment_3,'')			AS	generic_comment_3			-- edited by viettd 2019/12/10
	,	ISNULL(F0101.generic_comment_4,'')			AS	generic_comment_4			-- edited by viettd 2019/12/10
	,	ISNULL(F0101.generic_comment_5,'')			AS	generic_comment_5			-- edited by viettd 2019/12/10
	,	ISNULL(F0101.generic_comment_6,'')			AS	generic_comment_6			-- edited by viettd 2019/12/10
	,	ISNULL(F0101.generic_comment_7,'')			AS	generic_comment_7			-- edited by viettd 2019/12/10

	,	ISNULL(F0110.progress_comment_self,'')		AS	progress_comment_self		-- add by viettd 2019/06/12
	,	ISNULL(F0110.progress_comment_rater,'')		AS	progress_comment_rater		-- 一次評価者進捗コメント add by viettd 2019/06/12
	,	ISNULL(F0110.progress_comment_rater_2,'')	AS	progress_comment_rater_2	-- 二次評価者進捗コメント
	,	ISNULL(F0110.progress_comment_rater_3,'')	AS	progress_comment_rater_3	-- 三次評価者進捗コメント
	,	ISNULL(F0110.progress_comment_rater_4,'')	AS	progress_comment_rater_4	-- 四次評価者進捗コメント
	--	評価シート入力
	,	#M0200_HIDE_SHOW.goal_number		
	,	#M0200_HIDE_SHOW.item_title_title				
	,	#M0200_HIDE_SHOW.item_title_1					
	,	#M0200_HIDE_SHOW.item_title_2					
	,	#M0200_HIDE_SHOW.item_title_3					
	,	#M0200_HIDE_SHOW.item_title_4					
	,	#M0200_HIDE_SHOW.item_title_5
	--
	,	#M0200_HIDE_SHOW.detail_self_progress_comment_title				-- 明細自己進捗評価コメント	(title)			
	,	#M0200_HIDE_SHOW.detail_progress_comment_title					-- 明細進捗評価コメント		(title)
	,	#M0200_HIDE_SHOW.self_progress_comment_title			
	,	#M0200_HIDE_SHOW.progress_comment_title		
	--		
	,	#M0200_HIDE_SHOW.item_title_status		
	,	#M0200_HIDE_SHOW.item_display_status_1			
	,	#M0200_HIDE_SHOW.item_display_status_2			
	,	#M0200_HIDE_SHOW.item_display_status_3			
	,	#M0200_HIDE_SHOW.item_display_status_4			
	,	#M0200_HIDE_SHOW.item_display_status_5			
	,	#M0200_HIDE_SHOW.weight_display_status	
	,	#M0200_HIDE_SHOW.weight_display_nm											-- add by viettd 2019/12/10									
	,	#M0200_HIDE_SHOW.challenge_level_display_status	
	--
	,	#M0200_HIDE_SHOW.detail_self_progress_comment_display_status	-- 明細自己進捗評価コメント			-- add by viettd 2021/12/01
	,	#M0200_HIDE_SHOW.detail_progress_comment_display_status			-- 明細進捗評価コメント
	--
	,	#M0200_HIDE_SHOW.progress_comment_display_status				-- 自己進捗コメント	
	,	#M0200_HIDE_SHOW.progress_comment_display_status1				-- 一次評価者進捗コメント
	,	#M0200_HIDE_SHOW.progress_comment_display_status2				-- 二次評価者進捗コメント
	,	#M0200_HIDE_SHOW.progress_comment_display_status3				-- 三次評価者進捗コメント
	,	#M0200_HIDE_SHOW.progress_comment_display_status4				-- 四次評価者進捗コメント
	--
	,	#M0200_HIDE_SHOW.detail_comment_display_status1	
	,	#M0200_HIDE_SHOW.detail_comment_display_status2	
	,	#M0200_HIDE_SHOW.detail_comment_display_status3	
	,	#M0200_HIDE_SHOW.detail_comment_display_status4	
	--
	,	#M0200_HIDE_SHOW.detail_myself_comment_display_status
	,	#M0200_HIDE_SHOW.evaluation_display_status0		
	,	#M0200_HIDE_SHOW.evaluation_display_status1		
	,	#M0200_HIDE_SHOW.evaluation_display_status2		
	,	#M0200_HIDE_SHOW.evaluation_display_status3		
	,	#M0200_HIDE_SHOW.evaluation_display_status4		
	,	#M0200_HIDE_SHOW.total_score_display_status	
	,	#M0200_HIDE_SHOW.evaluation_comment_status0
	,	#M0200_HIDE_SHOW.evaluation_comment_status1
	,	#M0200_HIDE_SHOW.evaluation_comment_status2
	,	#M0200_HIDE_SHOW.evaluation_comment_status3
	,	#M0200_HIDE_SHOW.evaluation_comment_status4
	,	#M0200_HIDE_SHOW.point_criteria_display_status				
	,	#M0200_HIDE_SHOW.challengelevel_criteria_display_status		
	,	#M0200_HIDE_SHOW.self_assessment_comment_display_status		
	,	#M0200_HIDE_SHOW.evaluation_comment_display_status
	--
	,	CASE
			WHEN @generic_comment_cnt = 0
			THEN 100
			ELSE 100/@generic_comment_cnt
		END									AS	generic_comment_width -- VW
	FROM #M0200_HIDE_SHOW
	LEFT OUTER JOIN F0110 ON (
		#M0200_HIDE_SHOW.company_cd			=	F0110.company_cd
	AND @P_fiscal_year						=	F0110.fiscal_year
	AND @P_employee_cd						=	F0110.employee_cd
	AND #M0200_HIDE_SHOW.sheet_cd			=	F0110.sheet_cd
	AND F0110.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0101 ON (
		#M0200_HIDE_SHOW.company_cd			=	F0101.company_cd
	AND @P_fiscal_year						=	F0101.fiscal_year
	AND @P_employee_cd						=	F0101.employee_cd
	AND #M0200_HIDE_SHOW.sheet_cd			=	F0101.sheet_cd
	AND F0101.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0200 ON (
		#M0200_HIDE_SHOW.company_cd			=	W_M0200.company_cd
	AND @P_fiscal_year						=	W_M0200.fiscal_year
	AND #M0200_HIDE_SHOW.sheet_cd			=	W_M0200.sheet_cd
	)
	--[3]
	IF NOT EXISTS (SELECT 1 FROM #F0111_TEMP)
	BEGIN
		WHILE @i <= @goal_number
		BEGIN
			INSERT INTO #F0111_TEMP VALUES(@P_company_cd,@P_fiscal_year,@P_employee_cd,@P_sheet_cd,@i,0,0,0)
			SET @i = @i + 1
		END
	END
	-- remove item_title by viettd 2021/02/18
	-- UPDATE weight_required_status
	UPDATE #F0111_TEMP SET 
		weight_required_status	=	CASE
									WHEN ISNULL(F0111.item_1,'') <> '' OR ISNULL(F0111.item_2,'') <> '' OR ISNULL(F0111.item_3,'') <> '' OR ISNULL(F0111.item_4,'') <> '' OR ISNULL(F0111.item_5,'') <> ''
									THEN 1
									ELSE 0
									END
	,	weight					=	ISNULL(F0111.weight,0)
	FROM #F0111_TEMP
	INNER JOIN F0111 ON (
		#F0111_TEMP.company_cd			=	F0111.company_cd
	AND @P_fiscal_year					=	F0111.fiscal_year
	AND @P_employee_cd					=	F0111.employee_cd
	AND @P_sheet_cd						=	F0111.sheet_cd
	AND #F0111_TEMP.item_no				=	F0111.item_no
	AND F0111.del_datetime IS NULL
	)
	-- UPDATE item_required_status
	UPDATE #F0111_TEMP SET 
		item_required_status = ISNULL(F0111_COUNT.weight_count,0)
	FROM #F0111_TEMP
	INNER JOIN (
		SELECT 
			#F0111_TEMP.company_cd						AS	company_cd
		,	COUNT(#F0111_TEMP.weight_required_status)	AS	weight_count
		FROM #F0111_TEMP
		WHERE 
			#F0111_TEMP.weight_required_status <> 0
		GROUP BY
			#F0111_TEMP.company_cd	
	) AS F0111_COUNT ON (
		#F0111_TEMP.company_cd		=	F0111_COUNT.company_cd
	)
	-- add by viettd 2019/01/28
	IF @status_cd > 0
	BEGIN
		DELETE D FROM #F0111_TEMP AS D
		WHERE 
			D.weight_required_status = 0
	END
	-- end add by viettd 2019/01/28
	--[SELECT]
	SELECT 
	-- 被評価
		ISNULL(#F0111_TEMP.item_no,0)					AS	item_no
	,	CASE 
			WHEN F0111.company_cd IS NULL
			THEN ISNULL(W_M0201.item_title,'')
			ELSE ISNULL(F0111.item_title,'')	
		END												AS	item_title
	,	ISNULL(F0111.item_1,'')							AS	item_1
	,	ISNULL(F0111.item_2,'')							AS	item_2
	,	ISNULL(F0111.item_3,'')							AS	item_3
	,	ISNULL(F0111.item_4,'')							AS	item_4
	,	ISNULL(F0111.item_5,'')							AS	item_5
	,	ISNULL(#F0111_TEMP.weight_required_status,0)	AS	weight_required_status
	,	ISNULL(#F0111_TEMP.item_required_status,0)		AS	item_required_status
	-- ↓↓↓ edited by viettd 2021/11/16
	--,	ISNULL(F0111.weight,0)							AS	weight
	,	CASE 
			WHEN ISNULL(W_M0200.weight_display_typ,0) = 0
			THEN 1
			ELSE ISNULL(F0111.weight,0)
		END												AS	[weight]
	-- ↑↑↑ edited by viettd 2021/11/16
	,	ISNULL(F0111.challenge_level,0)					AS	challenge_level
	,	ISNULL(W_M0110.challenge_level_nm,'')			AS	challenge_level_nm
	,	ISNULL(F0111.self_progress_comment,'')			AS	self_progress_comment		-- 明細自己進捗評価コメント
	,	ISNULL(F0111.progress_comment,'')				AS	progress_comment			-- 明細進捗評価コメント
	,	CASE 
			WHEN ISNULL(W_M0110.betting_rate,0) = 0
			THEN 1
			ELSE ISNULL(W_M0110.betting_rate,0)
		END												AS	betting_rate
	,	ISNULL(W_M0200.point_calculation_typ1,0)		AS	point_calculation_typ1
	,	ISNULL(W_M0200.point_calculation_typ2,0)		AS	point_calculation_typ2
	-- 評価用
	,	ISNULL(F0121_0.point_cd,0)						AS	point_cd_0				--自己評価コード
	,	CASE 
			WHEN ISNULL(W_M0121_0.point_nm,'') <> ''
			THEN ISNULL(W_M0121_0.point_nm,'')
			ELSE CAST (ISNULL(W_M0121_0.point,0) AS NVARCHAR(5))
		END												AS	point_nm_0				--自己評価
	,	ISNULL(F0121_0.evaluation_comment,'')			AS	evaluation_comment_0	--自己評価コメント
	,	ISNULL(F0121_1.evaluation_comment,'')			AS	evaluation_comment_1	--評価コメント1
	,	ISNULL(F0121_2.evaluation_comment,'')			AS	evaluation_comment_2	--評価コメント2
	,	ISNULL(F0121_3.evaluation_comment,'')			AS	evaluation_comment_3	--評価コメント3
	,	ISNULL(F0121_4.evaluation_comment,'')			AS	evaluation_comment_4	--評価コメント4	
	,	CASE 
			WHEN ISNULL(W_M0121_1.point_nm,'') <> ''
			THEN ISNULL(W_M0121_1.point_nm,'')
			ELSE CAST (ISNULL(W_M0121_1.point,0) AS NVARCHAR(5))
		END												AS	point_nm_1			--	一次評価
	,	CASE 
			WHEN ISNULL(W_M0121_2.point_nm,'') <> ''
			THEN ISNULL(W_M0121_2.point_nm,'')
			ELSE CAST (ISNULL(W_M0121_2.point,0) AS NVARCHAR(5))
		END												AS	point_nm_2			--	二次評価
	,	CASE 
			WHEN ISNULL(W_M0121_3.point_nm,'') <> ''
			THEN ISNULL(W_M0121_3.point_nm,'')
			ELSE CAST (ISNULL(W_M0121_3.point,0) AS NVARCHAR(5))
		END												AS	point_nm_3			--	三次評価
	,	CASE 
			WHEN ISNULL(W_M0121_4.point_nm,'') <> ''
			THEN ISNULL(W_M0121_4.point_nm,'')
			ELSE CAST (ISNULL(W_M0121_4.point,0) AS NVARCHAR(5))
		END												AS	point_nm_4			--	四次評価
	-- value
	,	ISNULL(F0121_1.point_cd,0)						AS	point_cd_1			--	一次評価コード
	,	ISNULL(F0121_2.point_cd,0)						AS	point_cd_2			--	二次評価コード
	,	ISNULL(F0121_3.point_cd,0)						AS	point_cd_3			--	三次評価コード
	,	ISNULL(F0121_4.point_cd,0)						AS	point_cd_4			--	四次評価コード
	FROM #F0111_TEMP
	LEFT OUTER JOIN W_M0200 ON (
		#F0111_TEMP.company_cd				=	W_M0200.company_cd
	AND @P_fiscal_year						=	W_M0200.fiscal_year
	AND #F0111_TEMP.sheet_cd				=	W_M0200.sheet_cd
	AND W_M0200.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0201 ON (
		#F0111_TEMP.company_cd				=	W_M0201.company_cd
	AND @P_fiscal_year						=	W_M0201.fiscal_year
	AND #F0111_TEMP.sheet_cd				=	W_M0201.sheet_cd
	AND #F0111_TEMP.item_no					=	W_M0201.item_no
	AND W_M0201.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0111 ON (
		#F0111_TEMP.company_cd			=	F0111.company_cd
	AND @P_fiscal_year					=	F0111.fiscal_year
	AND @P_employee_cd					=	F0111.employee_cd
	AND @P_sheet_cd						=	F0111.sheet_cd
	AND #F0111_TEMP.item_no				=	F0111.item_no
	AND F0111.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0110 ON (
		F0111.company_cd				=	W_M0110.company_cd
	AND @P_fiscal_year					=	W_M0110.fiscal_year
	AND F0111.challenge_level			=	W_M0110.challenge_level
	)
	LEFT OUTER JOIN F0121 AS F0121_0 ON (
		#F0111_TEMP.company_cd			=	F0121_0.company_cd
	AND @P_fiscal_year					=	F0121_0.fiscal_year
	AND @P_employee_cd					=	F0121_0.employee_cd
	AND @P_sheet_cd						=	F0121_0.sheet_cd
	AND #F0111_TEMP.item_no				=	F0121_0.item_no
	AND 0								=	F0121_0.evaluation_step	--自己評価
	AND F0121_0.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0121 AS F0121_1 ON (
		#F0111_TEMP.company_cd			=	F0121_1.company_cd
	AND @P_fiscal_year					=	F0121_1.fiscal_year
	AND @P_employee_cd					=	F0121_1.employee_cd
	AND @P_sheet_cd						=	F0121_1.sheet_cd
	AND #F0111_TEMP.item_no				=	F0121_1.item_no
	AND 1								=	F0121_1.evaluation_step	--一次評価
	AND F0121_1.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0121 AS F0121_2 ON (
		#F0111_TEMP.company_cd			=	F0121_2.company_cd
	AND @P_fiscal_year					=	F0121_2.fiscal_year
	AND @P_employee_cd					=	F0121_2.employee_cd
	AND @P_sheet_cd						=	F0121_2.sheet_cd
	AND #F0111_TEMP.item_no				=	F0121_2.item_no
	AND 2								=	F0121_2.evaluation_step	--二次評価
	AND F0121_2.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0121 AS F0121_3 ON (
		#F0111_TEMP.company_cd			=	F0121_3.company_cd
	AND @P_fiscal_year					=	F0121_3.fiscal_year
	AND @P_employee_cd					=	F0121_3.employee_cd
	AND @P_sheet_cd						=	F0121_3.sheet_cd
	AND #F0111_TEMP.item_no				=	F0121_3.item_no
	AND 3								=	F0121_3.evaluation_step	--三次評価
	AND F0121_3.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0121 AS F0121_4 ON (
		#F0111_TEMP.company_cd			=	F0121_4.company_cd
	AND @P_fiscal_year					=	F0121_4.fiscal_year
	AND @P_employee_cd					=	F0121_4.employee_cd
	AND @P_sheet_cd						=	F0121_4.sheet_cd
	AND #F0111_TEMP.item_no				=	F0121_4.item_no
	AND 4								=	F0121_4.evaluation_step	--四次評価
	AND F0121_4.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0121 AS W_M0121_0 ON (
		F0121_0.company_cd			=	W_M0121_0.company_cd
	AND @P_fiscal_year				=	W_M0121_0.fiscal_year
	AND @point_kinds				=	W_M0121_0.point_kinds
	AND F0121_0.point_cd			=	W_M0121_0.point_cd
	AND W_M0121_0.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0121 AS W_M0121_1 ON (
		F0121_1.company_cd			=	W_M0121_1.company_cd
	AND @P_fiscal_year				=	W_M0121_1.fiscal_year
	AND @point_kinds				=	W_M0121_1.point_kinds
	AND F0121_1.point_cd			=	W_M0121_1.point_cd
	AND W_M0121_1.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0121 AS W_M0121_2 ON (
		F0121_2.company_cd			=	W_M0121_2.company_cd
	AND @P_fiscal_year				=	W_M0121_2.fiscal_year
	AND @point_kinds				=	W_M0121_2.point_kinds
	AND F0121_2.point_cd			=	W_M0121_2.point_cd
	AND W_M0121_2.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0121 AS W_M0121_3 ON (
		F0121_3.company_cd			=	W_M0121_3.company_cd
	AND @P_fiscal_year				=	W_M0121_3.fiscal_year
	AND @point_kinds				=	W_M0121_3.point_kinds
	AND F0121_3.point_cd			=	W_M0121_3.point_cd
	AND W_M0121_3.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0121 AS W_M0121_4 ON (
		F0121_4.company_cd			=	W_M0121_4.company_cd
	AND @P_fiscal_year				=	W_M0121_4.fiscal_year
	AND @point_kinds				=	W_M0121_4.point_kinds
	AND F0121_4.point_cd			=	W_M0121_4.point_cd
	AND W_M0121_4.del_datetime IS NULL
	)
	--[4] 評価シート入力の合計
	INSERT INTO #TABLE_評価シート入力
	SELECT 
		ISNULL(F0121.company_cd,0)			
	,	ISNULL(F0121.sheet_cd,0)			
	,	ISNULL(F0121.evaluation_step,0)		
	,	ISNULL(F0121.item_no,0)				
	,	ISNULL(F0121.point_cd,0)	
	,	ISNULL(W_M0121.point,0)														--	point			numeric(5,2)
	,	IIF(ISNULL(W_M0110.betting_rate,1) = 0,1,ISNULL(W_M0110.betting_rate,1))	--	betting_rate	numeric(5,2)
	--,	CASE 
	--		WHEN @point_calculation_typ1 = 1 -- ウェイト
	--		THEN IIF(ISNULL(F0111.weight,0) = 0,100,ISNULL(F0111.weight,0))
	--		WHEN @point_calculation_typ1 = 2 -- 係数
	--		THEN IIF(ISNULL(F0111.weight,0) = 0,1,ISNULL(F0111.weight,0))
	--		ELSE 0
	--	END																			--	weight			smallint
	-- edited by viettd 2021/11/16
	--,	ISNULL(F0111.weight,0)														--	weight			smallint		edited by viettd 2021/03/25
	-- edited by viettd 2024/02/16
	,	CASE 
			WHEN ISNULL(W_M0200.weight_display_typ,0) = 0 AND (@point_calculation_typ2 = 1 AND @point_calculation_typ1 = 1)
			THEN 100
			WHEN ISNULL(W_M0200.weight_display_typ,0) = 0
			THEN 1
			ELSE ISNULL(F0111.[weight],0)	
		END															AS	[weight]
	-- end edited by viettd 2021/11/16
	FROM F0121
	LEFT OUTER JOIN W_M0200 ON (
		F0121.company_cd		=	W_M0200.company_cd
	AND F0121.fiscal_year		=	W_M0200.fiscal_year
	AND F0121.sheet_cd			=	W_M0200.sheet_cd
	AND W_M0200.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0121 ON (
		F0121.company_cd		=	W_M0121.company_cd
	AND @P_fiscal_year			=	W_M0121.fiscal_year
	AND @point_kinds			=	W_M0121.point_kinds
	AND F0121.point_cd			=	W_M0121.point_cd
	AND W_M0121.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0111 ON (
		F0121.company_cd			=	F0111.company_cd
	AND F0121.fiscal_year			=	F0111.fiscal_year
	AND F0121.employee_cd			=	F0111.employee_cd
	AND F0121.sheet_cd				=	F0111.sheet_cd
	AND F0121.item_no				=	F0111.item_no
	AND F0111.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0110 ON (
		F0111.company_cd			=	W_M0110.company_cd
	AND @P_fiscal_year				=	W_M0110.fiscal_year
	AND F0111.challenge_level		=	W_M0110.challenge_level
	AND W_M0110.del_datetime IS NULL
	)
	WHERE
		F0121.company_cd		=	@P_company_cd
	AND F0121.fiscal_year		=	@P_fiscal_year
	AND F0121.employee_cd		=	@P_employee_cd
	AND F0121.sheet_cd			=	@P_sheet_cd
	AND F0121.del_datetime IS NULL
	--↓↓↓ add by viettd 2019/12/10
	-- point_calculation_typ_2(評価点算出方法)＝1【合計】×point_calculation_typ_1(評価点計算方法)＝1【ウェイト】の場合
	-- W_M0121.point * W_M0110.betting_rate * F0111.weight（％）　の合計
	IF (@point_calculation_typ2 = 1 AND @point_calculation_typ1 = 1)
	BEGIN
		UPDATE #TABLE_評価シート入力 SET 
			point = ROUND((point * betting_rate * weight)/100,2)
		FROM #TABLE_評価シート入力
	END
	-- point_calculation_typ_2(評価点算出方法)＝1【合計】×point_calculation_typ_1(評価点計算方法)＝2【係数】の場合
	ELSE IF (@point_calculation_typ2 = 1 AND @point_calculation_typ1 = 2)
	BEGIN
		UPDATE #TABLE_評価シート入力 SET 
			point = ROUND((point * betting_rate * weight),2)
		FROM #TABLE_評価シート入力
	END
	-- point_calculation_typ_2(評価点算出方法)＝2【平均】×point_calculation_typ_1(評価点計算方法)＝2【係数】の場合
	ELSE IF (@point_calculation_typ2 = 2 AND @point_calculation_typ1 = 2)
	BEGIN
		UPDATE #TABLE_評価シート入力 SET 
			point = ROUND((point * betting_rate * weight),2)
		FROM #TABLE_評価シート入力
	END
	--↑↑↑ end add by viettd 2019/12/10
	-- SUM DATA
	INSERT INTO #TABLE_評価シート入力の合計 VALUES(@P_company_cd,@P_sheet_cd,0,0,0,0,0)
	-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- point_calculation_typ_2(評価点算出方法)＝1【合計】×point_calculation_typ_1(評価点計算方法)＝1【ウェイト】の場合
	-- point_calculation_typ_2(評価点算出方法)＝1【合計】×point_calculation_typ_1(評価点計算方法)＝2【係数】の場合
	-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--■自己評価
	UPDATE #TABLE_評価シート入力の合計 SET 
		point_sum0 = ISNULL(TABLE_SUM_0.point_sum,0)
	FROM #TABLE_評価シート入力の合計
	INNER JOIN (
		SELECT 
			ISNULL(#TABLE_評価シート入力.sheet_cd,0)						AS	sheet_cd
		,	ISNULL(SUM(#TABLE_評価シート入力.point),0)					AS	point_sum
		FROM #TABLE_評価シート入力
		WHERE
			#TABLE_評価シート入力.evaluation_step = 0
		GROUP BY
			#TABLE_評価シート入力.sheet_cd
	) AS TABLE_SUM_0 ON(
		#TABLE_評価シート入力の合計.sheet_cd	=	TABLE_SUM_0.sheet_cd
	)
	--■一次評価
	UPDATE #TABLE_評価シート入力の合計 SET 
		point_sum1 = ISNULL(TABLE_SUM_1.point_sum,0)
	FROM #TABLE_評価シート入力の合計
	INNER JOIN (
		SELECT 
			ISNULL(#TABLE_評価シート入力.sheet_cd,0)						AS	sheet_cd
		,	ISNULL(SUM(#TABLE_評価シート入力.point),0)					AS	point_sum
		FROM #TABLE_評価シート入力
		WHERE
			#TABLE_評価シート入力.evaluation_step = 1
		GROUP BY
			#TABLE_評価シート入力.sheet_cd
	) AS TABLE_SUM_1 ON(
		#TABLE_評価シート入力の合計.sheet_cd	=	TABLE_SUM_1.sheet_cd
	)
	--■二次評価
	UPDATE #TABLE_評価シート入力の合計 SET 
		point_sum2 = ISNULL(TABLE_SUM_2.point_sum,0)
	FROM #TABLE_評価シート入力の合計
	INNER JOIN (
		SELECT 
			ISNULL(#TABLE_評価シート入力.sheet_cd,0)						AS	sheet_cd
		,	ISNULL(SUM(#TABLE_評価シート入力.point),0)					AS	point_sum
		FROM #TABLE_評価シート入力
		WHERE
			#TABLE_評価シート入力.evaluation_step = 2
		GROUP BY
			#TABLE_評価シート入力.sheet_cd
	) AS TABLE_SUM_2 ON(
		#TABLE_評価シート入力の合計.sheet_cd	=	TABLE_SUM_2.sheet_cd
	)
	--■三次評価
	UPDATE #TABLE_評価シート入力の合計 SET 
		point_sum3 = ISNULL(TABLE_SUM_3.point_sum,0)
	FROM #TABLE_評価シート入力の合計
	INNER JOIN (
		SELECT 
			ISNULL(#TABLE_評価シート入力.sheet_cd,0)						AS	sheet_cd
		,	ISNULL(SUM(#TABLE_評価シート入力.point),0)					AS	point_sum
		FROM #TABLE_評価シート入力
		WHERE
			#TABLE_評価シート入力.evaluation_step = 3
		GROUP BY
			#TABLE_評価シート入力.sheet_cd
	) AS TABLE_SUM_3 ON(
		#TABLE_評価シート入力の合計.sheet_cd	=	TABLE_SUM_3.sheet_cd
	)
	--■四次評価
	UPDATE #TABLE_評価シート入力の合計 SET 
		point_sum4 = ISNULL(TABLE_SUM_4.point_sum,0)
	FROM #TABLE_評価シート入力の合計
	INNER JOIN (
		SELECT 
			ISNULL(#TABLE_評価シート入力.sheet_cd,0)						AS	sheet_cd
		,	ISNULL(SUM(#TABLE_評価シート入力.point),0)					AS	point_sum
		FROM #TABLE_評価シート入力
		WHERE
			#TABLE_評価シート入力.evaluation_step = 4
		GROUP BY
			#TABLE_評価シート入力.sheet_cd
	) AS TABLE_SUM_4 ON(
		#TABLE_評価シート入力の合計.sheet_cd	=	TABLE_SUM_4.sheet_cd
	)
	-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- point_calculation_typ_2(評価点算出方法)＝2【平均】×point_calculation_typ_1(評価点計算方法)＝2【係数】の場合
	-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF @point_calculation_typ1 = 2 AND @point_calculation_typ2 = 2
	BEGIN
		-- edited by viettd 2021/03/25
		--SET @item_no_count = (SELECT SUM(IIF(ISNULL(F0111.weight,0) = 0,1,F0111.weight)) FROM F0111 WHERE 
		SET @item_no_count = (
			SELECT 
			SUM
			(
				CASE 
					WHEN ISNULL(W_M0200.weight_display_typ,0) = 0
					THEN 1
					ELSE ISNULL(F0111.weight,0)
				END
			)
			FROM F0111 
			LEFT OUTER JOIN W_M0200 ON (
				F0111.company_cd		=	W_M0200.company_cd
			AND F0111.fiscal_year		=	W_M0200.fiscal_year
			AND F0111.sheet_cd			=	W_M0200.sheet_cd
			AND W_M0200.del_datetime IS NULL
			)
			WHERE 
				F0111.company_cd	=	@P_company_cd
			AND F0111.fiscal_year	=	@P_fiscal_year
			AND F0111.employee_cd	=	@P_employee_cd
			AND F0111.sheet_cd		=	@P_sheet_cd
			AND F0111.del_datetime IS NULL
		)
		UPDATE #TABLE_評価シート入力の合計 SET 
			point_sum0	= IIF(@item_no_count <> 0,(point_sum0 / @item_no_count),0)
		,	point_sum1	= IIF(@item_no_count <> 0,(point_sum1 / @item_no_count),0)
		,	point_sum2	= IIF(@item_no_count <> 0,(point_sum2 / @item_no_count),0)
		,	point_sum3	= IIF(@item_no_count <> 0,(point_sum3 / @item_no_count),0)
		,	point_sum4	= IIF(@item_no_count <> 0,(point_sum4 / @item_no_count),0)
		FROM #TABLE_評価シート入力の合計
	END
	--[4] SELECT
	SELECT 
		format(#TABLE_評価シート入力の合計.point_sum0,'#0.##')	AS			point_sum0
	,	format(#TABLE_評価シート入力の合計.point_sum1,'#0.##')	AS			point_sum1
	,	format(#TABLE_評価シート入力の合計.point_sum2,'#0.##')	AS			point_sum2
	,	format(#TABLE_評価シート入力の合計.point_sum3,'#0.##')	AS			point_sum3
	,	format(#TABLE_評価シート入力の合計.point_sum4,'#0.##')	AS			point_sum4
	FROM #TABLE_評価シート入力の合計
	--[5] 評価コメント入力
	CREATE TABLE #TABLE_評価コメント入力(
		id								int			identity(1,1)
	,	company_cd						smallint
	,	fiscal_year						int
	,	employee_cd						nvarchar(10)
	,	sheet_cd						smallint
	,	evaluation_step					smallint
	,	evaluation_comment				nvarchar(1000)
	,	evaluation_comment_status0		tinyint
	,	evaluation_comment_status1		tinyint
	,	evaluation_comment_status2		tinyint
	,	evaluation_comment_status3		tinyint
	,	evaluation_comment_status4		tinyint
	)
	-- evaluation_step = 0
	INSERT INTO #TABLE_評価コメント入力 
	SELECT 
		@P_company_cd
	,	@P_fiscal_year
	,	@P_employee_cd
	,	@P_sheet_cd
	,	0
	,	ISNULL(F0120.evaluation_comment,'')
	,	#M0200_HIDE_SHOW.evaluation_comment_status0
	,	#M0200_HIDE_SHOW.evaluation_comment_status1
	,	#M0200_HIDE_SHOW.evaluation_comment_status2
	,	#M0200_HIDE_SHOW.evaluation_comment_status3
	,	#M0200_HIDE_SHOW.evaluation_comment_status4
	FROM #M0200_HIDE_SHOW
	LEFT OUTER JOIN F0120 ON (
		#M0200_HIDE_SHOW.company_cd			=	F0120.company_cd
	AND @P_fiscal_year						=	F0120.fiscal_year
	AND @P_employee_cd						=	F0120.employee_cd
	AND #M0200_HIDE_SHOW.sheet_cd			=	F0120.sheet_cd
	AND 0									=	F0120.evaluation_step
	AND F0120.del_datetime IS NULL
	)
	-- evaluation_step = 1
	INSERT INTO #TABLE_評価コメント入力 
	SELECT 
		@P_company_cd
	,	@P_fiscal_year
	,	@P_employee_cd
	,	@P_sheet_cd
	,	1
	,	ISNULL(F0120.evaluation_comment,'')
	,	#M0200_HIDE_SHOW.evaluation_comment_status0
	,	#M0200_HIDE_SHOW.evaluation_comment_status1
	,	#M0200_HIDE_SHOW.evaluation_comment_status2
	,	#M0200_HIDE_SHOW.evaluation_comment_status3
	,	#M0200_HIDE_SHOW.evaluation_comment_status4
	FROM #M0200_HIDE_SHOW
	LEFT OUTER JOIN F0120 ON (
		#M0200_HIDE_SHOW.company_cd			=	F0120.company_cd
	AND @P_fiscal_year						=	F0120.fiscal_year
	AND @P_employee_cd						=	F0120.employee_cd
	AND #M0200_HIDE_SHOW.sheet_cd			=	F0120.sheet_cd
	AND 1									=	F0120.evaluation_step
	AND F0120.del_datetime IS NULL
	)
	-- evaluation_step = 2
	INSERT INTO #TABLE_評価コメント入力 
	SELECT 
		@P_company_cd
	,	@P_fiscal_year
	,	@P_employee_cd
	,	@P_sheet_cd
	,	2
	,	ISNULL(F0120.evaluation_comment,'')
	,	#M0200_HIDE_SHOW.evaluation_comment_status0
	,	#M0200_HIDE_SHOW.evaluation_comment_status1
	,	#M0200_HIDE_SHOW.evaluation_comment_status2
	,	#M0200_HIDE_SHOW.evaluation_comment_status3
	,	#M0200_HIDE_SHOW.evaluation_comment_status4
	FROM #M0200_HIDE_SHOW
	LEFT OUTER JOIN F0120 ON (
		#M0200_HIDE_SHOW.company_cd			=	F0120.company_cd
	AND @P_fiscal_year						=	F0120.fiscal_year
	AND @P_employee_cd						=	F0120.employee_cd
	AND #M0200_HIDE_SHOW.sheet_cd			=	F0120.sheet_cd
	AND 2									=	F0120.evaluation_step
	AND F0120.del_datetime IS NULL
	)
	-- evaluation_step = 3
	INSERT INTO #TABLE_評価コメント入力 
	SELECT 
		@P_company_cd
	,	@P_fiscal_year
	,	@P_employee_cd
	,	@P_sheet_cd
	,	3
	,	ISNULL(F0120.evaluation_comment,'')
	,	#M0200_HIDE_SHOW.evaluation_comment_status0
	,	#M0200_HIDE_SHOW.evaluation_comment_status1
	,	#M0200_HIDE_SHOW.evaluation_comment_status2
	,	#M0200_HIDE_SHOW.evaluation_comment_status3
	,	#M0200_HIDE_SHOW.evaluation_comment_status4
	FROM #M0200_HIDE_SHOW
	LEFT OUTER JOIN F0120 ON (
		#M0200_HIDE_SHOW.company_cd			=	F0120.company_cd
	AND @P_fiscal_year						=	F0120.fiscal_year
	AND @P_employee_cd						=	F0120.employee_cd
	AND #M0200_HIDE_SHOW.sheet_cd			=	F0120.sheet_cd
	AND 3									=	F0120.evaluation_step
	AND F0120.del_datetime IS NULL
	)
	-- evaluation_step = 4
	INSERT INTO #TABLE_評価コメント入力 
	SELECT 
		@P_company_cd
	,	@P_fiscal_year
	,	@P_employee_cd
	,	@P_sheet_cd
	,	4
	,	ISNULL(F0120.evaluation_comment,'')
	,	#M0200_HIDE_SHOW.evaluation_comment_status0
	,	#M0200_HIDE_SHOW.evaluation_comment_status1
	,	#M0200_HIDE_SHOW.evaluation_comment_status2
	,	#M0200_HIDE_SHOW.evaluation_comment_status3
	,	#M0200_HIDE_SHOW.evaluation_comment_status4
	FROM #M0200_HIDE_SHOW
	LEFT OUTER JOIN F0120 ON (
		#M0200_HIDE_SHOW.company_cd			=	F0120.company_cd
	AND @P_fiscal_year						=	F0120.fiscal_year
	AND @P_employee_cd						=	F0120.employee_cd
	AND #M0200_HIDE_SHOW.sheet_cd			=	F0120.sheet_cd
	AND 4									=	F0120.evaluation_step
	AND F0120.del_datetime IS NULL
	)
	--[SELECT]
	SELECT 
		ISNULL(TABLE_TEMP.evaluation_comment,'')					AS	evaluation_comment
	,	ISNULL(TABLE_TEMP.evaluation_step,0)						AS	evaluation_step
	,	ISNULL(TABLE_TEMP.evaluation_comment_status0,0)				AS	evaluation_comment_status0
	,	ISNULL(TABLE_TEMP.evaluation_comment_status1,0)				AS	evaluation_comment_status1
	,	ISNULL(TABLE_TEMP.evaluation_comment_status2,0)				AS	evaluation_comment_status2
	,	ISNULL(TABLE_TEMP.evaluation_comment_status3,0)				AS	evaluation_comment_status3
	,	ISNULL(TABLE_TEMP.evaluation_comment_status4,0)				AS	evaluation_comment_status4
	FROM #TABLE_評価コメント入力 AS TABLE_TEMP
	ORDER BY
		TABLE_TEMP.evaluation_step 
	--[6] 難易度
	SELECT 
		ISNULL(W_M0110.challenge_level,0)				AS	challenge_level
	,	ISNULL(W_M0110.challenge_level_nm,'')			AS	challenge_level_nm
	,	FORMAT(ISNULL(W_M0110.betting_rate,0),'#0.##')	AS	betting_rate
	,	ISNULL(W_M0110.explanation,'')					AS	explanation
	--,	ISNULL(W_M0200.point_calculation_typ1,0)	AS	point_calculation_typ1
	--,	ISNULL(W_M0200.point_calculation_typ2,0)	AS	point_calculation_typ2
	FROM W_M0110
	WHERE
		W_M0110.company_cd		=	@P_company_cd
	AND W_M0110.fiscal_year		=	@P_fiscal_year
	AND W_M0110.del_datetime IS NULL
	--[7] 評価基準
	SELECT 
		ISNULL(W_M0121.point_cd,0)					AS	point_cd
	,	CASE 
			WHEN ISNULL(W_M0121.point_nm,'') <> ''
			THEN ISNULL(W_M0121.point_nm,'')
			ELSE CAST(ISNULL(W_M0121.point,0) AS NVARCHAR(5))
		END											AS	point_nm
	,	ISNULL(W_M0121.point_criteria,'')			AS	point_criteria
	,	ISNULL(W_M0121.point,0)						AS	point
	FROM W_M0121
	WHERE 
		W_M0121.company_cd		=	@P_company_cd
	AND W_M0121.fiscal_year		=	@P_fiscal_year
	AND W_M0121.point_kinds		=	@point_kinds
	AND W_M0121.del_datetime IS NULL
	-- [8]
	SELECT 
		ISNULL(M0022.organization_typ,0)		AS	organization_typ
	,	ISNULL(M0022.organization_group_nm,'')	AS	organization_group_nm
	FROM M0022
	WHERE 
		M0022.company_cd		=	@P_company_cd
	AND M0022.use_typ			=	1	-- 利用可能
	AND M0022.del_datetime IS NULL
	--[9]
	INSERT INTO #TABLE_M0310
	SELECT 
		ISNULL(L0040.category,0)
	,	ISNULL(L0040.status_cd,0)
	,	ISNULL(IIF(@w_language = 2,L0040.status_nm_english,L0040.status_nm),'')
	,	0
	,	0			-- detail_no	
	FROM L0040
	WHERE 
		L0040.category = 1 -- 1.目標シート
	AND L0040.status_cd > 0
	AND L0040.del_datetime IS NULL
	-- UPDATE M03010
	UPDATE #TABLE_M0310 SET 
		status_use_typ	=	ISNULL(M0310.status_use_typ,0)
	,	status_nm		=	CASE 
								WHEN ISNULL(M0310.status_nm,'') <> ''
								THEN ISNULL(M0310.status_nm,'')
								ELSE ISNULL(#TABLE_M0310.status_nm,'')
							END
	,	detail_no		=	ISNULL(M0310.detail_no,0)
	FROM #TABLE_M0310
	INNER JOIN M0310 ON (
		@P_company_cd			=	M0310.company_cd
	AND #TABLE_M0310.category	=	M0310.category
	AND #TABLE_M0310.status_cd	=	M0310.status_cd
	)
	WHERE 
		M0310.company_cd		=	@P_company_cd
	AND M0310.del_datetime	IS NULL
	-- WHEN NOT CHOICE 自己評価
	IF @w_evaluation_self_typ = 0
	BEGIN
		UPDATE #TABLE_M0310 SET 
			status_use_typ = 0
		FROM #TABLE_M0310
		WHERE
			#TABLE_M0310.status_cd = 3 -- 0.自己評価中
	END
	--
	SELECT 
		id										AS	id
	,	ISNULL(#TABLE_M0310.status_cd,0)		AS	status_cd
	,	ISNULL(#TABLE_M0310.status_nm,'')		AS	status_nm
	,	ISNULL(#TABLE_M0310.status_use_typ,0)	AS	status_use_typ
	,	 ROW_NUMBER() OVER (PARTITION BY status_use_typ ORDER BY status_cd)	AS	detail_no
	FROM #TABLE_M0310
	WHERE 
		#TABLE_M0310.status_use_typ = 1	
END
GO