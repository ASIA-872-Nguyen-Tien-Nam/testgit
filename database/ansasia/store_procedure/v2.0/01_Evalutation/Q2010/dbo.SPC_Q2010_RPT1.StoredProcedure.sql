DROP PROCEDURE [SPC_Q2010_RPT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_Q2010_FND1 '{"fiscal_year":"2018","evaluation_typ":"1","status_cd":"-1","category_typ":null,"sheet_cd":null,"employee_nm":"","employee_typ":"-1","position_cd":"-1","grade":"-1","list_treatment_applications_no":[{"treatment_applications_no":"16"},{"treatment_applications_no":"17"},{"treatment_applications_no":"18"}],"list_department_cd":[],"list_team_cd":[],"page_size":50,"page":1}','999';
-- EXEC SPC_Q2010_RPT1 'en','{"list":[{"employee_cd":"100","sheet_cd":"1"},{"employee_cd":"101","sheet_cd":"1"},{"employee_cd":"102","sheet_cd":"1"},{"employee_cd":"103","sheet_cd":"1"},{"employee_cd":"113","sheet_cd":"1"},{"employee_cd":"115","sheet_cd":"1"},{"employee_cd":"116","sheet_cd":"1"},{"employee_cd":"117","sheet_cd":"1"},{"employee_cd":"128","sheet_cd":"3"},{"employee_cd":"132","sheet_cd":"3"}],"fiscal_year":"2021","list_treatment_applications_no":[{"treatment_applications_no":"16"},{"treatment_applications_no":"17"},{"treatment_applications_no":"18"}]}','0','hanhntm','750'

--****************************************************************************************
--*  処理概要/process overview	:	Q2010_評価表出力
--*   
--*  作成日/create date			:	2018/11/01						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2019/06/12
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	Move F0111.progress_comment_self,progress_comment_rater to F0110
--*   					
--*  更新日/update date			:	2019/12/10
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgradate ver1.6
--*   					
--*  更新日/update date			:	2020/03/03
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	show - when not display rater1~rater4
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
--*  更新日/update date			:	2020/05/25
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	view 汎用コメント + fix　ウエイト・係数
--*   					
--*  更新日/update date			:	2020/10/09
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgrade ver1.7 & 1on1
--*   					
--*  更新日/update date			:	2020/12/16
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	評価表出力の条件を変更する
--*   					
--*  更新日/update date			:	2021/01/19
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	評価確定済のみ : change condition from table F0200 -> F0201
--*  
--*  更新日/update date			:	2021/12/07
--*　更新者/updater				:　	vietdt
--*　更新内容/update content		:	upgrade ver1.8
--*   					
--*  更新日/update date			:	2022/08/16
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	upgrade 1.9
--*   					
--*  更新日/update date			:	2022/11/17
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	add evaluation label
--* 
--****************************************************************************************
CREATE PROCEDURE [SPC_Q2010_RPT1]
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
		@w_time					date				=	SYSDATETIME()
	,	@authority_typ			smallint			=	0
	,	@fiscal_year			int					=	0
	,	@treatment_applications_no	nvarchar(max)		=	''	
	,	@chk					tinyint				=	0	-- add by viettd 2020/05/18
	,	@i						int					=	1
	,	@cnt					int					=	0
	,	@w_employee_cd			nvarchar(10)		=	''
	,	@w_sheet_cd				smallint			=	0
	--
	IF object_id('tempdb..#TABLE_JSON', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #TABLE_JSON
	END
	--
	IF object_id('tempdb..#TABLE_EMPLOYEE', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #TABLE_EMPLOYEE
	END
	--
	IF object_id('tempdb..#M0071_SHEET', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #M0071_SHEET
	END
	--
	IF object_id('tempdb..#TABLE_HEADER', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #TABLE_HEADER
	END
	--
	IF object_id('tempdb..#F0121_MAX', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #F0121_MAX
	END
	--
	IF object_id('tempdb..#TABLE_DETAIL', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #TABLE_DETAIL
	END
	--
	IF object_id('tempdb..#TABLE_評価基準', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #TABLE_評価基準
	END
	--
	IF object_id('tempdb..#TABLE_評価面談', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #TABLE_評価面談
	END
	--
	IF object_id('tempdb..#F0122', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #F0122
	END
	--
	IF object_id('tempdb..#HANYO_TABLE', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #HANYO_TABLE
	END
	--
	IF object_id('tempdb..#ITEM_TABLE', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #ITEM_TABLE
	END
	--
	IF object_id('tempdb..#TABLE_SHEET_CD', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #TABLE_SHEET_CD
	END
	--
	CREATE TABLE #TABLE_SHEET_CD (
		id								int			identity(1,1)
	,	sheet_cd						smallint
	)
	--
	CREATE TABLE #TABLE_JSON(
		id								int			identity(1,1)
	,	employee_cd						nvarchar(10)
	,	sheet_cd						smallint
	)
	--
	CREATE TABLE #TABLE_EMPLOYEE(
		id								int			identity(1,1)
	,	employee_cd						nvarchar(10)
	)
	--
	CREATE TABLE #TABLE_HEADER(
		company_cd									smallint
	,	sheet_cd									smallint
	,	sheet_kbn									tinyint
	,	point_kinds									smallint
	,	sheet_nm									nvarchar(200)
	,	point_calculation_typ1						smallint
	,	point_calculation_typ2						smallint
	--	汎用
	,	generic_comment_title_1						nvarchar(20)
	,	generic_comment_title_2						nvarchar(20)
	,	generic_comment_title_3						nvarchar(20)
	,	generic_comment_title_4						nvarchar(20)
	,	generic_comment_title_5						nvarchar(20)
	,	generic_comment_title_6						nvarchar(20)
	,	generic_comment_title_7						nvarchar(20)
	,	generic_comment_title_8						nvarchar(20)		-- add by viettd 2020/10/09
	,	generic_comment_display_typ_1				tinyint				--	汎用コメント1
	,	generic_comment_display_typ_2				tinyint				--	汎用コメント2
	,	generic_comment_display_typ_3				tinyint				--	汎用コメント3
	,	generic_comment_display_typ_4				tinyint				--	汎用コメント4
	,	generic_comment_display_typ_5				tinyint				--	汎用コメント5
	,	generic_comment_display_typ_6				tinyint				--	汎用コメント6
	,	generic_comment_display_typ_7				tinyint				--	汎用コメント7
	,	generic_comment_display_typ_8				tinyint				--	汎用コメント8
	--	評価シート入力
	,	item_title_title							nvarchar(20)		-- add by viettd 2020/10/09
	,	item_title_1								nvarchar(20)
	,	item_title_2								nvarchar(20)
	,	item_title_3								nvarchar(20)
	,	item_title_4								nvarchar(20)
	,	item_title_5								nvarchar(20)
	,	item_title_display_typ						tinyint				--	目標表題 add by viettd 2020/10/09
	,	item_display_typ_1							tinyint				--	タイトル1
	,	item_display_typ_2							tinyint				--	タイトル2
	,	item_display_typ_3							tinyint				--	タイトル3
	,	item_display_typ_4							tinyint				--	タイトル4
	,	item_display_typ_5							tinyint				--	タイトル5
	,	weight_display_typ							tinyint				--	ウェイト
	,	challenge_level_display_typ					tinyint				--	難易度
	,	progress_comment_display_typ				tinyint				--	進捗コメント
	,	detail_comment_display_typ_0				tinyint				--	自己評価コメント＿明細
	,	detail_comment_display_typ_1				tinyint				--	一次評価コメント＿明細
	,	point_criteria_display_typ					tinyint				--	評価基準
	,	challengelevel_criteria_display_typ			tinyint				--	難易度基準
	--
	,	target_self_assessment_typ					tinyint
	,	target_evaluation_typ_1						tinyint
	,	target_evaluation_typ_2						tinyint
	,	target_evaluation_typ_3						tinyint
	,	target_evaluation_typ_4						tinyint
	,	evaluation_self_assessment_typ				tinyint
	,	evaluation_typ_1							tinyint
	,	evaluation_typ_2							tinyint
	,	evaluation_typ_3							tinyint
	,	evaluation_typ_4							tinyint
	,	rater_interview_use_typ						tinyint				--add by vietd 2021/12/07
	)
	-- CREATE TABLE #F0121
	CREATE TABLE #F0121_MAX(
		id						int			identity(1,1)
	,	company_cd				smallint
	,	fiscal_year				int
	,	employee_cd				nvarchar(10)
	,	sheet_cd				smallint
	,	evaluation_step			smallint
	,	item_no					smallint
	,	count_item_no			smallint
	--
	,	rater_employee_cd_1		nvarchar(10)
	,	rater_employee_cd_2		nvarchar(10)
	,	rater_employee_cd_3		nvarchar(10)
	,	rater_employee_cd_4		nvarchar(10)
	,	confirm_status			nvarchar(20)			-- add by viettd 2019/03/08
	)
	--CREATE TABLE #TABLE_DETAIL
	CREATE TABLE #TABLE_DETAIL (
		id							int			identity(1,1)
	,	company_cd					smallint
	,	fiscal_year					int
	,	employee_cd					nvarchar(10)
	,	sheet_cd					smallint
	,	point_calculation_typ1		smallint
	,	point_calculation_typ2		smallint
	,	rater_employee_cd_1			nvarchar(10)
	,	rater_employee_cd_2			nvarchar(10)
	,	rater_employee_cd_3			nvarchar(10)
	,	rater_employee_cd_4			nvarchar(10)
	,	login_evaluation_step		smallint
	--
	,	item_no						smallint
	,	item_title					nvarchar(1000)		--	目標表題 -- add by viettd 2020/10/09
	,	item_1						nvarchar(1000)		--	タイトル１
	,	item_2						nvarchar(1000)		--	タイトル２
	,	item_3						nvarchar(1000)		--	タイトル３
	,	item_4						nvarchar(1000)		--	タイトル４
	,	item_5						nvarchar(1000)		--	タイトル５
	,	weight						smallint			--	ウェイト
	,	challenge_level				smallint			--	難易度コード
	,	challenge_level_nm			nvarchar(50)		--	難易度
	,	evaluation_comment_0		nvarchar(1000)		--	本人評価コメント
	,	evaluation_comment_1		nvarchar(1000)		--	一次評価者コメント
	,	point_nm_0					nvarchar(50)			--	自己評価
	,	point_0						numeric(5,2)		--	自己評価点数
	,	point_nm_1					nvarchar(50)			--	一次評価
	,	point_1						numeric(5,2)		--	一次評価点数
	,	point_nm_2					nvarchar(50)			--	二次評価
	,	point_2						numeric(5,2)		--	二次評価点数
	,	point_nm_3					nvarchar(50)			--	三次評価
	,	point_3						numeric(5,2)		--	三次評価点数
	,	point_nm_4					nvarchar(50)			--	四次評価
	,	point_4						numeric(5,2)		--	四次評価点数
	,	point_sum0					numeric(8,2)		--	自己評価合計
	,	point_sum1					numeric(8,2)		--	一次評価合計
	,	point_sum2					numeric(8,2)		--	二次評価合計
	,	point_sum3					numeric(8,2)		--	三次評価合計
	,	point_sum4					numeric(8,2)		--	四次評価合計
	--
	,	row_item_count				smallint			--	row count item_no
	,	count_item_no				smallint			--	count item row of sheet_cd
	,	last_page					smallint			
	,	RH							nvarchar(50)		--	RH
	,	confirm_status				nvarchar(20)		--	confirm_status		add by viettd 2019/03/08
	,	status_cd					smallint			--	status_cd			add by viettd 2020/05/12
	--	add by viettd 2020/05/15
	,	sheet_kbn					tinyint
	,	point_sum_status0			tinyint				-- 自己評価		 0.NOT VIEW 1.VIEW
	,	point_sum_status1			tinyint				-- 一次評価		 0.NOT VIEW 1.VIEW
	,	point_sum_status2			tinyint				-- 二次評価		 0.NOT VIEW 1.VIEW
	,	point_sum_status3			tinyint				-- 三次評価		 0.NOT VIEW 1.VIEW
	,	point_sum_status4			tinyint				-- 四次評価		 0.NOT VIEW 1.VIEW
	)
	--
	CREATE TABLE #TABLE_TREATMENT_APPLICATIONS_NO (
		id						int		identity(1,1)
	,	treatment_applications_no				smallint
	)
	CREATE TABLE #TABLE_評価基準 (
		id						int		identity(1,1)
	,	sheet_cd				smallint
	,	point_kinds_text		nvarchar(max)
	)
	--
	CREATE TABLE #TABLE_評価面談 (
		id						int		identity(1,1)
	,	employee_cd				nvarchar(10)
	,	sheet_cd				smallint
	,	interview_text			nvarchar(max)
	)
	--
	CREATE TABLE #F0122 (
		id						int		identity(1,1)
	,	sheet_cd				smallint
	,	period_detail_no		smallint
	,	employee_cd				nvarchar(10)
	)
	--
	CREATE TABLE #HANYO_TABLE(
		company_cd						smallint
	,	sheet_cd						smallint
	,	generic_step					smallint
	,	generic_comment_num				smallint		
	)
	--
	CREATE TABLE #ITEM_TABLE(
		company_cd						smallint
	,	sheet_cd						smallint
	,	item_step						smallint
	,	item_num						smallint		
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
	,	grade_nm						nvarchar(10)
	,	employee_typ_nm					nvarchar(50)
	)
	--
	SET @authority_typ = (SELECT ISNULL(S0010.authority_typ,0) FROM S0010 WHERE S0010.company_cd = @P_company_cd AND S0010.user_id = @P_cre_user)
	--
	SET @fiscal_year	=	JSON_VALUE(@P_json,'$.fiscal_year')
	INSERT INTO #TABLE_TREATMENT_APPLICATIONS_NO
	SELECT treatment_applications_no FROM OPENJSON(@P_json,'$.list_treatment_applications_no') WITH(
		treatment_applications_no						smallint
	)AS json_table
	INSERT INTO #TABLE_JSON
	SELECT json_table.employee_cd,json_table.sheet_cd FROM OPENJSON(@P_json,'$.list') WITH(
		employee_cd						nvarchar(10)
	,	sheet_cd						smallint
	)AS json_table
	--
	INSERT INTO #M0071_SHEET
	EXEC [dbo].SPC_REFER_M0071_INQ1 @fiscal_year,'',0,@P_company_cd
	--↓↓↓ add by viettd 2020/05/18
	SET @cnt = (SELECT COUNT(id) FROM #TABLE_JSON)
	WHILE @i <= @cnt
	BEGIN
		SELECT 
			@w_employee_cd	=	ISNULL(#TABLE_JSON.employee_cd,'')
		,	@w_sheet_cd		=	ISNULL(#TABLE_JSON.sheet_cd,0)
		FROM #TABLE_JSON
		WHERE #TABLE_JSON.id = @i
		--
		EXEC [dbo].SPC_PERMISSION_CHK1 @fiscal_year,@w_employee_cd,@w_sheet_cd,@P_cre_user,@P_company_cd,1,@chk OUT
		-- 0.参照不可　1.参照可能	2.更新可能
		IF @chk IN (0)
		BEGIN
			DELETE D FROM #TABLE_JSON AS D WHERE D.id = @i
		END
		-- LOOP @i
		SET @i = @i + 1
	END
	--↑↑↑ end add by viettd 2020/05/18
	INSERT INTO #TABLE_EMPLOYEE
	SELECT 
		DISTINCT 
			#TABLE_JSON.employee_cd
	FROM #TABLE_JSON
	--
	INSERT INTO #TABLE_SHEET_CD
	SELECT 
		DISTINCT 
			#TABLE_JSON.sheet_cd
	FROM #TABLE_JSON
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--GET DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	INSERT INTO #TABLE_HEADER
	SELECT 
		@P_company_cd
	,	#TABLE_SHEET_CD.sheet_cd
	,	ISNULL(W_M0200.sheet_kbn,0)
	,	ISNULL(W_M0200.point_kinds,0)
	,	ISNULL(W_M0200.sheet_nm,'')
	,	ISNULL(W_M0200.point_calculation_typ1,0)
	,	ISNULL(W_M0200.point_calculation_typ2,0)
	--	汎用
	,	ISNULL(W_M0200.generic_comment_title_1,'')			
	,	ISNULL(W_M0200.generic_comment_title_2,'')				
	,	ISNULL(W_M0200.generic_comment_title_3,'')				
	,	ISNULL(W_M0200.generic_comment_title_4,'')				
	,	ISNULL(W_M0200.generic_comment_title_5,'')
	,	ISNULL(W_M0200.generic_comment_title_6,'')
	,	ISNULL(W_M0200.generic_comment_title_7,'')
	,	ISNULL(W_M0200.generic_comment_title_8,'')				
	,	ISNULL(W_M0200.generic_comment_display_typ_1,0)	
	,	ISNULL(W_M0200.generic_comment_display_typ_2,0)		
	,	ISNULL(W_M0200.generic_comment_display_typ_3,0)		
	,	ISNULL(W_M0200.generic_comment_display_typ_4,0)		
	,	ISNULL(W_M0200.generic_comment_display_typ_5,0)
	,	ISNULL(W_M0200.generic_comment_display_typ_6,0)
	,	ISNULL(W_M0200.generic_comment_display_typ_7,0)
	,	ISNULL(W_M0200.generic_comment_display_typ_8,0)		
	--	評価シート入力
	,	ISNULL(W_M0200.item_title_title,'')				
	,	ISNULL(W_M0200.item_title_1,'')						
	,	ISNULL(W_M0200.item_title_2,'')						
	,	ISNULL(W_M0200.item_title_3,'')						
	,	ISNULL(W_M0200.item_title_4,'')						
	,	ISNULL(W_M0200.item_title_5,'')						
	,	ISNULL(W_M0200.item_title_display_typ,0)
	,	ISNULL(W_M0200.item_display_typ_1,0)					
	,	ISNULL(W_M0200.item_display_typ_2,0)					
	,	ISNULL(W_M0200.item_display_typ_3,0)					
	,	ISNULL(W_M0200.item_display_typ_4,0)					
	,	ISNULL(W_M0200.item_display_typ_5,0)					
	,	ISNULL(weight_display_typ,0)					
	,	ISNULL(challenge_level_display_typ,0)			
	,	ISNULL(progress_comment_display_typ,0)		
	,	ISNULL(detail_comment_display_typ_0,0)		--	自己評価コメント＿明細
	,	ISNULL(detail_comment_display_typ_1,0)		--	一次評価コメント＿明細	
	,	ISNULL(point_criteria_display_typ,0)			
	,	ISNULL(challengelevel_criteria_display_typ,0)
	--
	,	ISNULL(M0100.target_self_assessment_typ,0)				
	,	ISNULL(M0100.target_evaluation_typ_1,0)					
	,	ISNULL(M0100.target_evaluation_typ_2,0)					
	,	ISNULL(M0100.target_evaluation_typ_3,0)					
	,	ISNULL(M0100.target_evaluation_typ_4,0)					
	,	ISNULL(M0100.evaluation_self_assessment_typ,0)			
	,	ISNULL(M0100.evaluation_typ_1,0)						
	,	ISNULL(M0100.evaluation_typ_2,0)						
	,	ISNULL(M0100.evaluation_typ_3,0)						
	,	ISNULL(M0100.evaluation_typ_4,0)
	,	ISNULL(M0100.rater_interview_use_typ,0)
	FROM W_M0200
	INNER JOIN #TABLE_SHEET_CD ON (
		W_M0200.company_cd			=	@P_company_cd
	AND W_M0200.fiscal_year			=	@fiscal_year
	AND W_M0200.sheet_cd			=	#TABLE_SHEET_CD.sheet_cd
	)
	LEFT OUTER JOIN M0100 ON (
		W_M0200.company_cd			=	M0100.company_cd
	AND M0100.del_datetime IS NULL
	)
	WHERE
		W_M0200.company_cd		=	@P_company_cd
	AND W_M0200.fiscal_year		=	@fiscal_year
	AND W_M0200.del_datetime IS NULL
	-- GET #F0121_MAX

	INSERT INTO #F0121_MAX
	SELECT 
		ISNULL(F0121.company_cd,0)		
	,	ISNULL(F0121.fiscal_year,0)		
	,	ISNULL(F0121.employee_cd,'')		
	,	ISNULL(F0121.sheet_cd,0)		
	,	ISNULL(MAX(F0121.evaluation_step),0)	
	,	ISNULL(F0121.item_no,0)
	,	0											--	count_item_no	
	,	''											--	rater_employee_cd_1	
	,	''											--	rater_employee_cd_2	
	,	''											--	rater_employee_cd_3	
	,	''											--	rater_employee_cd_4	
	,	''											--	confirm_status
	FROM F0121
	INNER JOIN #TABLE_JSON ON(
		F0121.company_cd			=	@P_company_cd
	AND F0121.fiscal_year			=	@fiscal_year
	AND F0121.employee_cd			=	#TABLE_JSON.employee_cd
	AND F0121.sheet_cd				=	#TABLE_JSON.sheet_cd
	)
	WHERE
		F0121.company_cd			=	@P_company_cd
	AND F0121.fiscal_year			=	@fiscal_year
	AND F0121.del_datetime IS NULL
	GROUP BY
		F0121.company_cd
	,	F0121.fiscal_year		
	,	F0121.employee_cd	
	,	F0121.sheet_cd		
	,	F0121.item_no
	-- ADD BY VIETTD 2019/03/08
	-- comment out by viettd 2020/12/16
	--INSERT INTO #F0121_MAX
	--SELECT 
	--	ISNULL(F0111.company_cd,0)		
	--,	ISNULL(F0111.fiscal_year,0)		
	--,	ISNULL(F0111.employee_cd,'')		
	--,	ISNULL(F0111.sheet_cd,0)		
	--,	0	
	--,	ISNULL(F0111.item_no,0)
	--,	0											--	count_item_no	
	--,	''											--	rater_employee_cd_1	
	--,	''											--	rater_employee_cd_2	
	--,	''											--	rater_employee_cd_3	
	--,	''											--	rater_employee_cd_4	
	--,	'暫定版'										--	confirm_status
	--FROM F0111
	--INNER JOIN #TABLE_JSON ON(
	--	F0111.company_cd			=	@P_company_cd
	--AND F0111.fiscal_year			=	@fiscal_year
	--AND F0111.employee_cd			=	#TABLE_JSON.employee_cd
	--AND F0111.sheet_cd				=	#TABLE_JSON.sheet_cd
	--)
	--INNER JOIN F0110 ON (
	--	F0111.company_cd			=	F0110.company_cd
	--AND F0111.fiscal_year			=	F0110.fiscal_year
	--AND F0111.employee_cd			=	F0110.employee_cd
	--AND F0111.sheet_cd				=	F0110.sheet_cd
	--)
	--INNER JOIN F0100 ON (
	--	F0111.company_cd			=	F0100.company_cd
	--AND F0111.fiscal_year			=	F0100.fiscal_year
	--AND F0111.employee_cd			=	F0100.employee_cd
	--AND F0111.sheet_cd				=	F0100.sheet_cd
	--)
	--INNER JOIN W_M0200 AS M0200 ON(
	--	F0111.company_cd			=	M0200.company_cd
	--AND F0111.fiscal_year			=	M0200.fiscal_year
	--AND F0111.sheet_cd				=	M0200.sheet_cd
	--AND M0200.del_datetime IS NULL
	--)
	--WHERE
	--	F0111.company_cd			=	@P_company_cd
	--AND F0111.fiscal_year			=	@fiscal_year
	--AND F0111.del_datetime IS NULL
	--AND M0200.sheet_kbn				=	1
	--AND F0110.submit_datetime	IS NOT NULL
	--AND F0110.approval_datetime IS NULL

	--↓↓↓ add by viettd 2020/12/16
	-- 目標管理：目標設定~自己評価前まで（M0200.sheet_kbn=1(目標)の（F0100.status_cd=1 and F0110.submit_datetime is not null）OR（F0100.status_cd=2）OR（F0100.status_cd=3）
	-- 定性評価：自己評価前（M0200.sheet_kbn=2(定性評価)の　F0100.status_cd<２
	-- または、
	-- 評価確定済み（F0031.fiscal_year=画面.年度、F0031.employee_cd=画面.社員番号 でF0200(総合評価)を参照し、F0200.confirm_daetime is not null　）のデータが出力対象となる
	-- 1.目標管理
	INSERT INTO #F0121_MAX
	SELECT 
		ISNULL(F0111.company_cd,0)		
	,	ISNULL(F0111.fiscal_year,0)		
	,	ISNULL(F0111.employee_cd,'')		
	,	ISNULL(F0111.sheet_cd,0)		
	,	0	
	,	ISNULL(F0111.item_no,0)
	,	0											--	count_item_no	
	,	''											--	rater_employee_cd_1	
	,	''											--	rater_employee_cd_2	
	,	''											--	rater_employee_cd_3	
	,	''											--	rater_employee_cd_4	
	,	'暫定版'										--	confirm_status
	FROM F0111
	INNER JOIN #TABLE_JSON ON(
		F0111.company_cd			=	@P_company_cd
	AND F0111.fiscal_year			=	@fiscal_year
	AND F0111.employee_cd			=	#TABLE_JSON.employee_cd
	AND F0111.sheet_cd				=	#TABLE_JSON.sheet_cd
	)
	INNER JOIN F0110 ON (
		F0111.company_cd			=	F0110.company_cd
	AND F0111.fiscal_year			=	F0110.fiscal_year
	AND F0111.employee_cd			=	F0110.employee_cd
	AND F0111.sheet_cd				=	F0110.sheet_cd
	)
	INNER JOIN F0100 ON (
		F0111.company_cd			=	F0100.company_cd
	AND F0111.fiscal_year			=	F0100.fiscal_year
	AND F0111.employee_cd			=	F0100.employee_cd
	AND F0111.sheet_cd				=	F0100.sheet_cd
	)
	INNER JOIN W_M0200 AS M0200 ON(
		F0111.company_cd			=	M0200.company_cd
	AND F0111.fiscal_year			=	M0200.fiscal_year
	AND F0111.sheet_cd				=	M0200.sheet_cd
	AND M0200.del_datetime IS NULL
	)
	WHERE
		F0111.company_cd			=	@P_company_cd
	AND F0111.fiscal_year			=	@fiscal_year
	AND F0111.del_datetime IS NULL
	AND M0200.sheet_kbn				=	1	-- 目標管理
	AND (
		(F0100.status_cd = 1 AND F0110.submit_datetime IS NOT NULL)
	OR	(F0100.status_cd = 2)
	OR	(F0100.status_cd = 3)
	)
	--2.定性評価
	INSERT INTO #F0121_MAX
	SELECT 
		ISNULL(W_M0201.company_cd,0)		
	,	ISNULL(W_M0201.fiscal_year,0)		
	,	ISNULL(#TABLE_JSON.employee_cd,'')		
	,	ISNULL(#TABLE_JSON.sheet_cd,0)		
	,	0	
	,	ISNULL(W_M0201.item_no,0)
	,	0											--	count_item_no	
	,	''											--	rater_employee_cd_1	
	,	''											--	rater_employee_cd_2	
	,	''											--	rater_employee_cd_3	
	,	''											--	rater_employee_cd_4	
	,	'暫定版'										--	confirm_status
	FROM W_M0201
	INNER JOIN #TABLE_JSON ON(
		W_M0201.company_cd			=	@P_company_cd
	AND W_M0201.fiscal_year			=	@fiscal_year
	AND W_M0201.sheet_cd			=	#TABLE_JSON.sheet_cd
	)
	INNER JOIN F0100 ON (
		@P_company_cd				=	F0100.company_cd
	AND @fiscal_year				=	F0100.fiscal_year
	AND #TABLE_JSON.employee_cd		=	F0100.employee_cd
	AND #TABLE_JSON.sheet_cd		=	F0100.sheet_cd
	)
	INNER JOIN W_M0200 AS M0200 ON(
		@P_company_cd				=	M0200.company_cd
	AND @fiscal_year				=	M0200.fiscal_year
	AND #TABLE_JSON.sheet_cd		=	M0200.sheet_cd
	AND M0200.del_datetime IS NULL
	)
	WHERE
		W_M0201.company_cd			=	@P_company_cd
	AND W_M0201.fiscal_year			=	@fiscal_year
	AND W_M0201.del_datetime IS NULL
	AND M0200.sheet_kbn				=	2	-- 定性評価
	AND F0100.status_cd				<	2	-- 自己評価
	-- ↑↑↑ end add by viettd 2020/12/16
	--
	UPDATE #F0121_MAX SET 
		rater_employee_cd_1			=	ISNULL(F0100.rater_employee_cd_1,'')
	,	rater_employee_cd_2			=	ISNULL(F0100.rater_employee_cd_2,'')
	,	rater_employee_cd_3			=	ISNULL(F0100.rater_employee_cd_3,'')
	,	rater_employee_cd_4			=	ISNULL(F0100.rater_employee_cd_4,'')
	FROM #F0121_MAX
	INNER JOIN F0100 ON (
		#F0121_MAX.company_cd		=	F0100.company_cd
	AND #F0121_MAX.fiscal_year		=	F0100.fiscal_year
	AND #F0121_MAX.employee_cd		=	F0100.employee_cd
	AND #F0121_MAX.sheet_cd			=	F0100.sheet_cd
	AND F0100.del_datetime IS NULL
	)
	-- UPDATE count_item_no
	UPDATE #F0121_MAX SET 
		count_item_no	=	ISNULL(F0121_COUNT.count_item_no,0)
	FROM #F0121_MAX
	INNER JOIN (
		SELECT
			#F0121_MAX.company_cd				AS	company_cd
		,	#F0121_MAX.fiscal_year				AS	fiscal_year
		,	#F0121_MAX.employee_cd				AS	employee_cd
		,	#F0121_MAX.sheet_cd					AS	sheet_cd
		,	#F0121_MAX.evaluation_step			AS	evaluation_step
		,	COUNT(#F0121_MAX.item_no)			AS	count_item_no
		FROM #F0121_MAX
		GROUP BY
			#F0121_MAX.company_cd	
		,	#F0121_MAX.fiscal_year	
		,	#F0121_MAX.employee_cd	
		,	#F0121_MAX.sheet_cd		
		,	#F0121_MAX.evaluation_step
	) AS F0121_COUNT ON (
		#F0121_MAX.company_cd				=	F0121_COUNT.company_cd
	AND #F0121_MAX.fiscal_year				=	F0121_COUNT.fiscal_year
	AND #F0121_MAX.employee_cd				=	F0121_COUNT.employee_cd
	AND #F0121_MAX.sheet_cd					=	F0121_COUNT.sheet_cd
	AND #F0121_MAX.evaluation_step			=	F0121_COUNT.evaluation_step
	)
	--	F0031.fiscal_year=画面.年度、F0031.employee_cd=画面.社員番号 でF0200(総合評価)を参照し、F0200.confirm_daetime is not null　のデータが出力対象となる
	--	但し、M0200.sheet_kbn=1(目標)の評価シートに限り、F0100.status_cd=1 and F0110.submit_datetime is not null　のデータも出力対象とする。
	--	edited by viettd 2021/01/19 : change F0200 -> F0201

	DELETE D FROM #F0121_MAX AS D
	LEFT JOIN F0032 ON (
		D.company_cd = F0032.company_cd
	AND D.employee_cd = F0032.employee_cd
	AND D.fiscal_year = F0032.fiscal_year
	AND D.sheet_cd = F0032.sheet_cd
	)
	LEFT OUTER JOIN (
		SELECT 
			DISTINCT 
				ISNULL(F0201.company_cd,0)			AS	company_cd
			,	ISNULL(F0201.fiscal_year,0)			AS	fiscal_year
			,	ISNULL(F0201.employee_cd,'')		AS	employee_cd
			,	ISNULL(F0201.treatment_applications_no,'')		AS	treatment_applications_no
		FROM F0201
		WHERE 
			F0201.company_cd		=	@P_company_cd
		AND F0201.fiscal_year		=	@fiscal_year
		AND F0201.confirm_datetime IS NOT NULL
		AND F0201.del_datetime IS NULL
	) AS F0201_MAX ON(
		D.company_cd				=	F0201_MAX.company_cd
	AND D.fiscal_year				=	F0201_MAX.fiscal_year
	AND D.employee_cd				=	F0201_MAX.employee_cd
	AND F0032.treatment_applications_no = F0201_MAX.treatment_applications_no
	)
	
	LEFT OUTER JOIN #TABLE_TREATMENT_APPLICATIONS_NO ON(
		F0032.treatment_applications_no = #TABLE_TREATMENT_APPLICATIONS_NO.treatment_applications_no
	)
	WHERE 
		(F0201_MAX.company_cd IS NULL
	OR #TABLE_TREATMENT_APPLICATIONS_NO.treatment_applications_no IS NULL)
	AND D.confirm_status <> '暫定版'
	-- INSERT DATA INTO #TABLE_評価基準

	INSERT INTO #TABLE_評価基準
	SELECT 
		#TABLE_HEADER.sheet_cd
	,	(SELECT 
			TOP 15
			CASE 
				WHEN ISNULL(W_M0121.point_nm,'') <> ''
				THEN ISNULL(W_M0121.point_nm,'')
				ELSE CAST (ISNULL(W_M0121.point,0) AS NVARCHAR(5))
			END											AS	"point_nm"			--	一次評価
		,	point_criteria								AS "point_criteria"
		FROM W_M0121
		WHERE 
			W_M0121.company_cd			=	@P_company_cd
		AND @fiscal_year				=	W_M0121.fiscal_year
		AND #TABLE_HEADER.point_kinds	=	W_M0121.point_kinds
		AND W_M0121.del_datetime IS NULL
		FOR JSON PATH
		)					AS	point_kinds_text
	FROM #TABLE_HEADER
	WHERE 
		#TABLE_HEADER.company_cd = @P_company_cd
	AND #TABLE_HEADER.sheet_cd > 0
	-- INSERT DATA INTO #TABLE_評価面談
	INSERT INTO #F0122
	SELECT 
		ISNULL(W_M0200.sheet_cd,0)
	,	ISNULL(W_M0200.evaluation_period,0)
	,	ISNULL(#TABLE_JSON.employee_cd,'')
	FROM #TABLE_JSON
	LEFT OUTER JOIN W_M0200 ON (
		@P_company_cd				=	W_M0200.company_cd
	AND @fiscal_year				=	W_M0200.fiscal_year
	AND #TABLE_JSON.sheet_cd		=	W_M0200.sheet_cd
	AND W_M0200.del_datetime IS NULL
	)
	--
	INSERT INTO #TABLE_評価面談
	SELECT 
		ISNULL(#F0122.employee_cd,'')		AS	employee_cd
	,	ISNULL(#F0122.sheet_cd,0)			AS	sheet_cd
	,	(
		SELECT
			CASE 
				WHEN ISNULL(M0310.status_nm,'') <> ''
				THEN ISNULL(M0310.status_nm,'')
				ELSE ISNULL(IIF(@P_language = 'en',L0040.status_nm_english,L0040.status_nm),'')
			END														AS	"interview_nm"
		,	CASE 
				WHEN F0122.interview_date IS NULL
				THEN ''
				ELSE CONVERT(NVARCHAR(10),F0122.interview_date,111)
			END														AS	"interview_date"
		,	F0122.interview_comment_self							AS	"interview_comment_self"
		,	F0122.interview_comment_rater							AS	"interview_comment_rater"
		--add vietdt 2021/12/07
		,	ISNULL(F0122.interview_comment_rater2,'')				AS	"interview_comment_rater2"
		,	ISNULL(F0122.interview_comment_rater3,'')				AS	"interview_comment_rater3"
		,	ISNULL(F0122.interview_comment_rater4,'')				AS	"interview_comment_rater4"
		FROM F0122
		LEFT OUTER JOIN M0310 ON (
			F0122.company_cd			=	M0310.company_cd
		AND 3							=	M0310.category
		AND F0122.interview_no			=	M0310.status_cd
		AND M0310.del_datetime IS NULL
		)
		LEFT OUTER JOIN L0040 ON (
			3							=	L0040.category
		AND F0122.interview_no			=	L0040.status_cd
		AND L0040.del_datetime IS NULL
		)
		WHERE
			F0122.company_cd		=	@P_company_cd
		AND F0122.fiscal_year		=	@fiscal_year
		AND F0122.employee_cd		=	#F0122.employee_cd
		AND F0122.period_detail_no	=	#F0122.period_detail_no
		AND F0122.del_datetime IS NULL
		FOR JSON PATH
	)											AS	interview_text
	FROM #F0122
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--RESULT 
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--[0]
	INSERT INTO #TABLE_DETAIL
	SELECT 
		@P_company_cd									AS	company_cd
	,	@fiscal_year									AS	fiscal_year
	,	ISNULL(#F0121_MAX.employee_cd,'')				AS	employee_cd
	,	ISNULL(#F0121_MAX.sheet_cd,0)					AS	sheet_cd
	,	ISNULL(#TABLE_HEADER.point_calculation_typ1,0)	AS	point_calculation_typ1
	,	ISNULL(#TABLE_HEADER.point_calculation_typ2,0)	AS	point_calculation_typ2
	,	ISNULL(#F0121_MAX.rater_employee_cd_1,'')		AS	rater_employee_cd_1
	,	ISNULL(#F0121_MAX.rater_employee_cd_2,'')		AS	rater_employee_cd_2
	,	ISNULL(#F0121_MAX.rater_employee_cd_3,'')		AS	rater_employee_cd_3
	,	ISNULL(#F0121_MAX.rater_employee_cd_4,'')		AS	rater_employee_cd_4
	--	add by viettd 2020/04/27
	,	[dbo].FNC_GET_STEP_EVALUATION
		(
			'Q2010'
		,	M0200.sheet_kbn
		,	F0100.status_cd
		,	#F0121_MAX.employee_cd
		,	@P_login_employee_cd
		,	@authority_typ
		,	#F0121_MAX.rater_employee_cd_1
		,	#F0121_MAX.rater_employee_cd_2
		,	#F0121_MAX.rater_employee_cd_3
		,	#F0121_MAX.rater_employee_cd_4
		)												AS login_evaluation_step
	,	ISNULL(#F0121_MAX.item_no,0)					AS	item_no
	,	CASE 
			WHEN ISNULL(#TABLE_HEADER.sheet_kbn,0)	= 1
			THEN ISNULL(F0111.item_title,'')
			WHEN ISNULL(#TABLE_HEADER.sheet_kbn,0)	= 2
			THEN ISNULL(W_M0201.item_title,'')
			ELSE ''
		END												AS	item_title		-- 目標表題
	,	CASE 
			WHEN ISNULL(#TABLE_HEADER.sheet_kbn,0)	= 1
			THEN ISNULL(F0111.item_1,'')
			WHEN ISNULL(#TABLE_HEADER.sheet_kbn,0)	= 2
			THEN ISNULL(W_M0201.item_detail_1,'')
			ELSE ''
		END												AS	item_1			-- タイトル１
	
	,	CASE 
			WHEN ISNULL(#TABLE_HEADER.sheet_kbn,0)	= 1
			THEN ISNULL(F0111.item_2,'')
			WHEN ISNULL(#TABLE_HEADER.sheet_kbn,0)	= 2
			THEN ISNULL(W_M0201.item_detail_2,'')
			ELSE ''
		END												AS	item_2			-- タイトル２
	,	CASE 
			WHEN ISNULL(#TABLE_HEADER.sheet_kbn,0)	= 1
			THEN ISNULL(F0111.item_3,'')
			WHEN ISNULL(#TABLE_HEADER.sheet_kbn,0)	= 2
			THEN ISNULL(W_M0201.item_detail_3,'')
			ELSE ''
		END												AS	item_3			-- タイトル３
	,	CASE 
			WHEN ISNULL(#TABLE_HEADER.sheet_kbn,0)	= 1
			THEN ISNULL(F0111.item_4,'')
			ELSE ''
		END												AS	item_4			-- タイトル４
	,	CASE 
			WHEN ISNULL(#TABLE_HEADER.sheet_kbn,0)	= 1
			THEN ISNULL(F0111.item_5,'')
			ELSE ''
		END												AS	item_5			-- タイトル５
	,	CASE 
			WHEN ISNULL(#TABLE_HEADER.sheet_kbn,0)	= 1
			THEN ISNULL(F0111.weight,0)
			WHEN ISNULL(#TABLE_HEADER.sheet_kbn,0)	= 2
			THEN ISNULL(W_M0201.weight,0)
			ELSE 0
		END												AS	[weight]			-- ウェイト
	,	CASE 
			WHEN ISNULL(#TABLE_HEADER.sheet_kbn,0)	= 1
			THEN ISNULL(W_M0110.challenge_level,0)
			ELSE ''
		END												AS	challenge_level			-- 難易度コード
	,	CASE 
			WHEN ISNULL(#TABLE_HEADER.sheet_kbn,0)	= 1
			THEN ISNULL(W_M0110.challenge_level_nm,'')
			ELSE ''
		END												AS	challenge_level_nm		-- 難易度
	,	ISNULL(F0121_0.evaluation_comment,'')			AS	本人評価コメント
	,	ISNULL(F0121_1.evaluation_comment,'')			AS	一次評価者コメント
	,	CASE 
			WHEN ISNULL(W_M0121_0.point_nm,'') <> ''
			THEN ISNULL(W_M0121_0.point_nm,'')
			ELSE CAST (ISNULL(W_M0121_0.point,0) AS NVARCHAR(5))
		END												AS	自己評価
			
	,	ISNULL(W_M0121_0.point,0)						AS	自己評価点数
	,	CASE 
			WHEN ISNULL(W_M0121_1.point_nm,'') <> ''
			THEN ISNULL(W_M0121_1.point_nm,'')
			ELSE CAST (ISNULL(W_M0121_1.point,0) AS NVARCHAR(5))
		END												AS	一次評価
	,	ISNULL(W_M0121_1.point,0)						AS	一次評価点数
	,	CASE 
			WHEN ISNULL(W_M0121_2.point_nm,'') <> ''
			THEN ISNULL(W_M0121_2.point_nm,'')
			ELSE CAST (ISNULL(W_M0121_2.point,0) AS NVARCHAR(5))
		END												AS	二次評価
	,	ISNULL(W_M0121_2.point,0)						AS	二次評価点数
	,	CASE 
			WHEN ISNULL(W_M0121_3.point_nm,'') <> ''
			THEN ISNULL(W_M0121_3.point_nm,'')
			ELSE CAST (ISNULL(W_M0121_3.point,0) AS NVARCHAR(5))
		END												AS	三次評価
	,	ISNULL(W_M0121_3.point,0)						AS	三次評価点数
	,	CASE 
			WHEN ISNULL(W_M0121_4.point_nm,'') <> ''
			THEN ISNULL(W_M0121_4.point_nm,'')
			ELSE CAST (ISNULL(W_M0121_4.point,0) AS NVARCHAR(5))
		END												AS	四次評価
	,	ISNULL(W_M0121_4.point,0)						AS	四次評価点数	
	--
	,	ISNULL(F0120_0.point_sum,0)						AS	自己評価合計
	,	ISNULL(F0120_1.point_sum,0)						AS	一次評価合計
	,	ISNULL(F0120_2.point_sum,0)						AS	二次評価合計
	,	ISNULL(F0120_3.point_sum,0)						AS	三次評価合計
	,	ISNULL(F0120_4.point_sum,0)						AS	四次評価合計
	--
	,	ROW_NUMBER() OVER(PARTITION BY #F0121_MAX.employee_cd,#F0121_MAX.sheet_cd ORDER BY #F0121_MAX.item_no)	
														AS	row_item_count
	,	ISNULL(#F0121_MAX.count_item_no,0)				AS	count_item_no			--	count_item_no
	,	0												AS	last_page				--	last_page
	,	''												AS	RH						--	PAGING
	,	#F0121_MAX.confirm_status						AS	confirm_status			--	confirm_status
	,	ISNULL(F0100.status_cd,0)						AS	status_cd				--	status_cd
	--	add by viettd 2020/05/15
	,	ISNULL(M0200.sheet_kbn,0)						AS	sheet_kbn				--	sheet_kbn
	,	0												AS	point_sum_status0		--	point_sum_status0
	,	0												AS	point_sum_status1		--	point_sum_status1
	,	0												AS	point_sum_status2		--	point_sum_status2
	,	0												AS	point_sum_status3		--	point_sum_status3
	,	0												AS	point_sum_status4		--	point_sum_status4
	FROM #F0121_MAX
	LEFT OUTER JOIN #TABLE_HEADER ON (
		#F0121_MAX.company_cd			=	#TABLE_HEADER.company_cd
	AND #F0121_MAX.sheet_cd				=	#TABLE_HEADER.sheet_cd
	)
	LEFT OUTER JOIN F0100 ON (
		#F0121_MAX.company_cd			=	F0100.company_cd
	AND #F0121_MAX.fiscal_year			=	F0100.fiscal_year
	AND #F0121_MAX.employee_cd			=	F0100.employee_cd
	AND #F0121_MAX.sheet_cd				=	F0100.sheet_cd
	AND F0100.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0111 ON (
		#F0121_MAX.company_cd			=	F0111.company_cd
	AND #F0121_MAX.fiscal_year			=	F0111.fiscal_year
	AND #F0121_MAX.employee_cd			=	F0111.employee_cd
	AND #F0121_MAX.sheet_cd				=	F0111.sheet_cd
	AND #F0121_MAX.item_no				=	F0111.item_no
	AND F0111.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0200 AS M0200 ON (
		#F0121_MAX.company_cd			=	M0200.company_cd
	AND #F0121_MAX.fiscal_year			=	M0200.fiscal_year
	AND #F0121_MAX.sheet_cd				=	M0200.sheet_cd
	)
	LEFT OUTER JOIN W_M0201 ON (
		#F0121_MAX.company_cd			=	W_M0201.company_cd
	AND #F0121_MAX.fiscal_year			=	W_M0201.fiscal_year
	AND #F0121_MAX.sheet_cd				=	W_M0201.sheet_cd
	AND #F0121_MAX.item_no				=	W_M0201.item_no
	AND W_M0201.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0110 ON (
		F0111.company_cd				=	W_M0110.company_cd
	AND F0111.fiscal_year				=	W_M0110.fiscal_year
	AND F0111.challenge_level			=	W_M0110.challenge_level
	AND W_M0110.del_datetime IS NULL
	)
	--↓↓↓ GET FROM F0120
	LEFT OUTER JOIN F0120 AS F0120_0 ON (
		#F0121_MAX.company_cd			=	F0120_0.company_cd
	AND #F0121_MAX.fiscal_year			=	F0120_0.fiscal_year
	AND #F0121_MAX.employee_cd			=	F0120_0.employee_cd
	AND #F0121_MAX.sheet_cd				=	F0120_0.sheet_cd
	AND 0								=	F0120_0.evaluation_step
	AND F0120_0.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0120 AS F0120_1 ON (
		#F0121_MAX.company_cd			=	F0120_1.company_cd
	AND #F0121_MAX.fiscal_year			=	F0120_1.fiscal_year
	AND #F0121_MAX.employee_cd			=	F0120_1.employee_cd
	AND #F0121_MAX.sheet_cd				=	F0120_1.sheet_cd
	AND 1								=	F0120_1.evaluation_step
	AND F0120_1.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0120 AS F0120_2 ON (
		#F0121_MAX.company_cd			=	F0120_2.company_cd
	AND #F0121_MAX.fiscal_year			=	F0120_2.fiscal_year
	AND #F0121_MAX.employee_cd			=	F0120_2.employee_cd
	AND #F0121_MAX.sheet_cd				=	F0120_2.sheet_cd
	AND 2								=	F0120_2.evaluation_step
	AND F0120_2.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0120 AS F0120_3 ON (
		#F0121_MAX.company_cd			=	F0120_3.company_cd
	AND #F0121_MAX.fiscal_year			=	F0120_3.fiscal_year
	AND #F0121_MAX.employee_cd			=	F0120_3.employee_cd
	AND #F0121_MAX.sheet_cd				=	F0120_3.sheet_cd
	AND 3								=	F0120_3.evaluation_step
	AND F0120_3.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0120 AS F0120_4 ON (
		#F0121_MAX.company_cd			=	F0120_4.company_cd
	AND #F0121_MAX.fiscal_year			=	F0120_4.fiscal_year
	AND #F0121_MAX.employee_cd			=	F0120_4.employee_cd
	AND #F0121_MAX.sheet_cd				=	F0120_4.sheet_cd
	AND 4								=	F0120_4.evaluation_step
	AND F0120_4.del_datetime IS NULL
	)
	--↑↑↑ GET FROM F0120
	LEFT OUTER JOIN F0121 AS F0121_0 ON (
		#F0121_MAX.company_cd			=	F0121_0.company_cd
	AND #F0121_MAX.fiscal_year			=	F0121_0.fiscal_year
	AND #F0121_MAX.employee_cd			=	F0121_0.employee_cd
	AND #F0121_MAX.sheet_cd				=	F0121_0.sheet_cd
	AND 0								=	F0121_0.evaluation_step
	AND #F0121_MAX.item_no				=	F0121_0.item_no
	AND F0121_0.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0121 AS F0121_1 ON (
		#F0121_MAX.company_cd			=	F0121_1.company_cd
	AND #F0121_MAX.fiscal_year			=	F0121_1.fiscal_year
	AND #F0121_MAX.employee_cd			=	F0121_1.employee_cd
	AND #F0121_MAX.sheet_cd				=	F0121_1.sheet_cd
	AND 1								=	F0121_1.evaluation_step
	AND #F0121_MAX.item_no				=	F0121_1.item_no
	AND F0121_1.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0121 AS F0121_2 ON (
		#F0121_MAX.company_cd			=	F0121_2.company_cd
	AND #F0121_MAX.fiscal_year			=	F0121_2.fiscal_year
	AND #F0121_MAX.employee_cd			=	F0121_2.employee_cd
	AND #F0121_MAX.sheet_cd				=	F0121_2.sheet_cd
	AND 2								=	F0121_2.evaluation_step
	AND #F0121_MAX.item_no				=	F0121_2.item_no
	AND F0121_2.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0121 AS F0121_3 ON (
		#F0121_MAX.company_cd			=	F0121_3.company_cd
	AND #F0121_MAX.fiscal_year			=	F0121_3.fiscal_year
	AND #F0121_MAX.employee_cd			=	F0121_3.employee_cd
	AND #F0121_MAX.sheet_cd				=	F0121_3.sheet_cd
	AND 3								=	F0121_3.evaluation_step
	AND #F0121_MAX.item_no				=	F0121_3.item_no
	AND F0121_3.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0121 AS F0121_4 ON (
		#F0121_MAX.company_cd			=	F0121_4.company_cd
	AND #F0121_MAX.fiscal_year			=	F0121_4.fiscal_year
	AND #F0121_MAX.employee_cd			=	F0121_4.employee_cd
	AND #F0121_MAX.sheet_cd				=	F0121_4.sheet_cd
	AND 4								=	F0121_4.evaluation_step
	AND #F0121_MAX.item_no				=	F0121_4.item_no
	AND F0121_4.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0121 AS W_M0121_0 ON(
		F0121_0.company_cd				=	W_M0121_0.company_cd
	AND F0121_0.fiscal_year				=	W_M0121_0.fiscal_year
	AND #TABLE_HEADER.point_kinds		=	W_M0121_0.point_kinds
	AND F0121_0.point_cd				=	W_M0121_0.point_cd
	AND W_M0121_0.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0121 AS W_M0121_1 ON(
		F0121_1.company_cd				=	W_M0121_1.company_cd
	AND F0121_1.fiscal_year				=	W_M0121_1.fiscal_year
	AND #TABLE_HEADER.point_kinds		=	W_M0121_1.point_kinds
	AND F0121_1.point_cd				=	W_M0121_1.point_cd
	AND W_M0121_1.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0121 AS W_M0121_2 ON(
		F0121_2.company_cd				=	W_M0121_2.company_cd
	AND F0121_2.fiscal_year				=	W_M0121_2.fiscal_year
	AND #TABLE_HEADER.point_kinds		=	W_M0121_2.point_kinds
	AND F0121_2.point_cd				=	W_M0121_2.point_cd
	AND W_M0121_2.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0121 AS W_M0121_3 ON(
		F0121_3.company_cd				=	W_M0121_3.company_cd
	AND F0121_3.fiscal_year				=	W_M0121_3.fiscal_year
	AND #TABLE_HEADER.point_kinds		=	W_M0121_3.point_kinds
	AND F0121_3.point_cd				=	W_M0121_3.point_cd
	AND W_M0121_3.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0121 AS W_M0121_4 ON(
		F0121_4.company_cd				=	W_M0121_4.company_cd
	AND F0121_4.fiscal_year				=	W_M0121_4.fiscal_year
	AND #TABLE_HEADER.point_kinds		=	W_M0121_4.point_kinds
	AND F0121_4.point_cd				=	W_M0121_4.point_cd
	AND W_M0121_4.del_datetime IS NULL
	)
	WHERE 
		#F0121_MAX.company_cd		=	@P_company_cd
	AND #F0121_MAX.fiscal_year		=	@fiscal_year
	--■■■■■■■■■■■■■ update total ■■■■■■■■■■■■■
	--update row_item_no count
	UPDATE #TABLE_DETAIL SET
		RH			=	CASE 
							WHEN row_item_count <= 6
							THEN #TABLE_DETAIL.employee_cd + CAST(#TABLE_DETAIL.sheet_cd AS NVARCHAR(10)) + CAST((1) AS nvarchar(3)) 
							WHEN row_item_count > 6 AND row_item_count % 6 = 0
							THEN #TABLE_DETAIL.employee_cd + CAST(#TABLE_DETAIL.sheet_cd AS NVARCHAR(10)) + CAST((row_item_count / 6) AS nvarchar(3))
							ELSE #TABLE_DETAIL.employee_cd + CAST(#TABLE_DETAIL.sheet_cd AS NVARCHAR(10)) + CAST((row_item_count / 6 + 1) AS nvarchar(3))
						END
	,	last_page	=	CASE
							WHEN row_item_count <= 6 AND count_item_no <= 6
							THEN 1
							WHEN count_item_no > 6 AND row_item_count > 6 AND (count_item_no / 6 + 1) = (row_item_count / 6 + 1)
							THEN 1
							ELSE 0
						END 
	FROM #TABLE_DETAIL
	--↓↓↓ add by viettd 2020/05/151
	-- 1. 目標評価
	UPDATE #TABLE_DETAIL SET 
		point_sum_status0	=	CASE 
									-- ３：目標承認済。自己評価中。
									WHEN #TABLE_DETAIL.status_cd = 3 AND #TABLE_DETAIL.login_evaluation_step IN (0,5)
									THEN 1
									-- ４：自己評価済。一次評価中。
									WHEN #TABLE_DETAIL.status_cd = 4 AND #TABLE_DETAIL.login_evaluation_step IN (0,1,5)
									THEN 1
									-- ５：一次評価済。二次評価中。
									WHEN #TABLE_DETAIL.status_cd = 5 AND #TABLE_DETAIL.login_evaluation_step IN (0,1,2,5)
									THEN 1
									-- ６：二次評価済。三次評価中。
									WHEN #TABLE_DETAIL.status_cd = 6 AND #TABLE_DETAIL.login_evaluation_step IN (0,1,2,3,5)
									THEN 1
									-- ７：三次評価済。四次評価中。
									WHEN #TABLE_DETAIL.status_cd IN(7,8,9,10,11,12) AND #TABLE_DETAIL.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	,	point_sum_status1	=	CASE 
									-- ４：自己評価済。一次評価中。
									WHEN #TABLE_DETAIL.status_cd = 4 AND #TABLE_DETAIL.login_evaluation_step IN (1,5)
									THEN 1
									-- ５：一次評価済。二次評価中。
									WHEN #TABLE_DETAIL.status_cd = 5 AND #TABLE_DETAIL.login_evaluation_step IN (1,2,5)
									THEN 1
									-- ６：二次評価済。三次評価中。
									WHEN #TABLE_DETAIL.status_cd = 6 AND #TABLE_DETAIL.login_evaluation_step IN (1,2,3,5)
									THEN 1
									-- ７：三次評価済。四次評価中。
									WHEN #TABLE_DETAIL.status_cd IN(7,8,9,10) AND #TABLE_DETAIL.login_evaluation_step IN (1,2,3,4,5)
									THEN 1
									WHEN #TABLE_DETAIL.status_cd IN(11,12) AND  #TABLE_DETAIL.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	,	point_sum_status2	=	CASE 
									-- ５：一次評価済。二次評価中。
									WHEN #TABLE_DETAIL.status_cd = 5 AND #TABLE_DETAIL.login_evaluation_step IN (2,5)
									THEN 1
									-- ６：二次評価済。三次評価中。
									WHEN #TABLE_DETAIL.status_cd = 6 AND #TABLE_DETAIL.login_evaluation_step IN (2,3,5)
									THEN 1
									-- ７：三次評価済。四次評価中。
									WHEN #TABLE_DETAIL.status_cd IN(7,8,9) AND #TABLE_DETAIL.login_evaluation_step IN (2,3,4,5)
									THEN 1
									WHEN #TABLE_DETAIL.status_cd = 10 AND #TABLE_DETAIL.login_evaluation_step IN (1,2,3,4,5)
									THEN 1
									WHEN #TABLE_DETAIL.status_cd IN(11,12) AND  #TABLE_DETAIL.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	,	point_sum_status3	=	CASE 
									-- ６：二次評価済。三次評価中。
									WHEN #TABLE_DETAIL.status_cd = 6 AND #TABLE_DETAIL.login_evaluation_step IN (3,5)
									THEN 1
									-- ７：三次評価済。四次評価中。
									WHEN #TABLE_DETAIL.status_cd IN(7,8,9) AND #TABLE_DETAIL.login_evaluation_step IN (3,4,5)
									THEN 1
									WHEN #TABLE_DETAIL.status_cd = 10 AND #TABLE_DETAIL.login_evaluation_step IN (1,2,3,4,5)
									THEN 1
									WHEN #TABLE_DETAIL.status_cd IN(11,12) AND  #TABLE_DETAIL.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	,	point_sum_status4	=	CASE 
									-- ７：三次評価済。四次評価中。
									WHEN #TABLE_DETAIL.status_cd IN(7,8,9) AND #TABLE_DETAIL.login_evaluation_step IN (4,5)
									THEN 1
									WHEN #TABLE_DETAIL.status_cd = 10 AND #TABLE_DETAIL.login_evaluation_step IN (1,2,3,4,5)
									THEN 1
									WHEN #TABLE_DETAIL.status_cd IN(11,12) AND  #TABLE_DETAIL.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	FROM #TABLE_DETAIL 
	WHERE 
		#TABLE_DETAIL.sheet_kbn = 1
	-- 2. 定性評価
	UPDATE #TABLE_DETAIL SET 
		point_sum_status0	=	CASE
									-- １：期首面談済。自己評価中。
									WHEN #TABLE_DETAIL.status_cd = 1 AND #TABLE_DETAIL.login_evaluation_step IN (0,5)
									THEN 1
									-- ２：自己評価済。一次評価中。
									WHEN #TABLE_DETAIL.status_cd = 2 AND #TABLE_DETAIL.login_evaluation_step IN (0,1,5)
									THEN 1
									-- ３：一次評価済。二次評価中。
									WHEN #TABLE_DETAIL.status_cd = 3 AND #TABLE_DETAIL.login_evaluation_step IN (0,1,2,5)
									THEN 1
									-- ４：二次評価済。三次評価中。
									WHEN #TABLE_DETAIL.status_cd = 4 AND #TABLE_DETAIL.login_evaluation_step IN (0,1,2,3,5)
									THEN 1
									-- ５：三次評価済。四次評価中。
									WHEN #TABLE_DETAIL.status_cd IN(5,6,7,8,9,10) AND #TABLE_DETAIL.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	,	point_sum_status1	=	CASE
									-- ２：自己評価済。一次評価中。
									WHEN #TABLE_DETAIL.status_cd = 2 AND #TABLE_DETAIL.login_evaluation_step IN (1,5)
									THEN 1
									-- ３：一次評価済。二次評価中。
									WHEN #TABLE_DETAIL.status_cd = 3 AND #TABLE_DETAIL.login_evaluation_step IN (1,2,5)
									THEN 1
									-- ４：二次評価済。三次評価中。
									WHEN #TABLE_DETAIL.status_cd = 4 AND #TABLE_DETAIL.login_evaluation_step IN (1,2,3,5)
									THEN 1
									-- ５：三次評価済。四次評価中。
									WHEN #TABLE_DETAIL.status_cd IN(5,6,7,8) AND #TABLE_DETAIL.login_evaluation_step IN (1,2,3,4,5)
									THEN 1
									--
									WHEN #TABLE_DETAIL.status_cd IN(9,10) AND #TABLE_DETAIL.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	,	point_sum_status2	=	CASE
									-- ３：一次評価済。二次評価中。
									WHEN #TABLE_DETAIL.status_cd = 3 AND #TABLE_DETAIL.login_evaluation_step IN (2,5)
									THEN 1
									-- ４：二次評価済。三次評価中。
									WHEN #TABLE_DETAIL.status_cd = 4 AND #TABLE_DETAIL.login_evaluation_step IN (2,3,5)
									THEN 1
									-- ５：三次評価済。四次評価中。
									WHEN #TABLE_DETAIL.status_cd IN(5,6,7) AND #TABLE_DETAIL.login_evaluation_step IN (2,3,4,5)
									THEN 1
									-- ８：一次ＦＢ済。本人ＦＢ待ち。
									WHEN #TABLE_DETAIL.status_cd = 8 AND #TABLE_DETAIL.login_evaluation_step IN (1,2,3,4,5)
									THEN 1
									--
									WHEN #TABLE_DETAIL.status_cd IN(9,10) AND #TABLE_DETAIL.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	,	point_sum_status3	=	CASE
									-- ４：二次評価済。三次評価中。
									WHEN #TABLE_DETAIL.status_cd = 4 AND #TABLE_DETAIL.login_evaluation_step IN (3,5)
									THEN 1
									-- ５：三次評価済。四次評価中。
									WHEN #TABLE_DETAIL.status_cd IN(5,6,7) AND #TABLE_DETAIL.login_evaluation_step IN (3,4,5)
									THEN 1
									-- ８：一次ＦＢ済。本人ＦＢ待ち。
									WHEN #TABLE_DETAIL.status_cd = 8 AND #TABLE_DETAIL.login_evaluation_step IN (1,2,3,4,5)
									THEN 1
									--
									WHEN #TABLE_DETAIL.status_cd IN(9,10) AND #TABLE_DETAIL.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END
	,	point_sum_status4	=	CASE
									-- ５：三次評価済。四次評価中。
									WHEN #TABLE_DETAIL.status_cd IN(5,6,7) AND #TABLE_DETAIL.login_evaluation_step IN (4,5)
									THEN 1
									-- ８：一次ＦＢ済。本人ＦＢ待ち。
									WHEN #TABLE_DETAIL.status_cd = 8 AND #TABLE_DETAIL.login_evaluation_step IN (1,2,3,4,5)
									THEN 1
									--
									WHEN #TABLE_DETAIL.status_cd IN(9,10) AND #TABLE_DETAIL.login_evaluation_step IN (0,1,2,3,4,5)
									THEN 1
									ELSE 0
								END									
	FROM #TABLE_DETAIL
	WHERE 
		#TABLE_DETAIL.sheet_kbn = 2
	--↑↑↑ add by viettd 2020/05/15
	--
	INSERT INTO #HANYO_TABLE 
	SELECT 
		company_cd
	,	sheet_cd
	,	1		-- generic_step
	,	1		-- generic_comment_num
	FROM #TABLE_HEADER
	WHERE 
		#TABLE_HEADER.generic_comment_display_typ_1	= 1
	--
	INSERT INTO #HANYO_TABLE 
	SELECT 
		#TABLE_HEADER.company_cd
	,	#TABLE_HEADER.sheet_cd
	,	ISNULL(TABLE_2.generic_step,0) + 1
	,	2
	FROM #TABLE_HEADER
	LEFT OUTER JOIN (
		SELECT 
			#HANYO_TABLE.company_cd
		,	#HANYO_TABLE.sheet_cd
		,	ISNULL(MAX(#HANYO_TABLE.generic_step),0) AS	generic_step
		FROM #HANYO_TABLE
		GROUP BY
			#HANYO_TABLE.company_cd
		,	#HANYO_TABLE.sheet_cd
	) AS TABLE_2 ON (
		#TABLE_HEADER.company_cd		=	TABLE_2.company_cd
	AND #TABLE_HEADER.sheet_cd			=	TABLE_2.sheet_cd
	)
	WHERE 
		#TABLE_HEADER.generic_comment_display_typ_2	= 1
	--
	INSERT INTO #HANYO_TABLE 
	SELECT 
		#TABLE_HEADER.company_cd
	,	#TABLE_HEADER.sheet_cd
	,	ISNULL(TABLE_3.generic_step,0) + 1
	,	3
	FROM #TABLE_HEADER
	LEFT OUTER JOIN (
		SELECT 
			#HANYO_TABLE.company_cd
		,	#HANYO_TABLE.sheet_cd
		,	ISNULL(MAX(#HANYO_TABLE.generic_step),0) AS	generic_step
		FROM #HANYO_TABLE
		GROUP BY
			#HANYO_TABLE.company_cd
		,	#HANYO_TABLE.sheet_cd
	) AS TABLE_3 ON (
		#TABLE_HEADER.company_cd		=	TABLE_3.company_cd
	AND #TABLE_HEADER.sheet_cd			=	TABLE_3.sheet_cd
	)
	WHERE 
		#TABLE_HEADER.generic_comment_display_typ_8	= 1
	--
	INSERT INTO #HANYO_TABLE 
	SELECT 
		#TABLE_HEADER.company_cd
	,	#TABLE_HEADER.sheet_cd
	,	ISNULL(TABLE_4.generic_step,0) + 1
	,	4
	FROM #TABLE_HEADER
	LEFT OUTER JOIN (
		SELECT 
			#HANYO_TABLE.company_cd
		,	#HANYO_TABLE.sheet_cd
		,	ISNULL(MAX(#HANYO_TABLE.generic_step),0) AS	generic_step
		FROM #HANYO_TABLE
		GROUP BY
			#HANYO_TABLE.company_cd
		,	#HANYO_TABLE.sheet_cd
	) AS TABLE_4 ON (
		#TABLE_HEADER.company_cd		=	TABLE_4.company_cd
	AND #TABLE_HEADER.sheet_cd			=	TABLE_4.sheet_cd
	)
	WHERE 
		#TABLE_HEADER.generic_comment_display_typ_3	= 1
	--
	INSERT INTO #HANYO_TABLE 
	SELECT 
		#TABLE_HEADER.company_cd
	,	#TABLE_HEADER.sheet_cd
	,	ISNULL(TABLE_5.generic_step,0) + 1
	,	5
	FROM #TABLE_HEADER
	LEFT OUTER JOIN (
		SELECT 
			#HANYO_TABLE.company_cd
		,	#HANYO_TABLE.sheet_cd
		,	ISNULL(MAX(#HANYO_TABLE.generic_step),0) AS	generic_step
		FROM #HANYO_TABLE
		GROUP BY
			#HANYO_TABLE.company_cd
		,	#HANYO_TABLE.sheet_cd
	) AS TABLE_5 ON (
		#TABLE_HEADER.company_cd		=	TABLE_5.company_cd
	AND #TABLE_HEADER.sheet_cd			=	TABLE_5.sheet_cd
	)
	WHERE 
		#TABLE_HEADER.generic_comment_display_typ_4	= 1
	--
	INSERT INTO #HANYO_TABLE 
	SELECT 
		#TABLE_HEADER.company_cd
	,	#TABLE_HEADER.sheet_cd
	,	ISNULL(TABLE_6.generic_step,0) + 1
	,	6
	FROM #TABLE_HEADER
	LEFT OUTER JOIN (
		SELECT 
			#HANYO_TABLE.company_cd
		,	#HANYO_TABLE.sheet_cd
		,	ISNULL(MAX(#HANYO_TABLE.generic_step),0) AS	generic_step
		FROM #HANYO_TABLE
		GROUP BY
			#HANYO_TABLE.company_cd
		,	#HANYO_TABLE.sheet_cd
	) AS TABLE_6 ON (
		#TABLE_HEADER.company_cd		=	TABLE_6.company_cd
	AND #TABLE_HEADER.sheet_cd			=	TABLE_6.sheet_cd
	)
	WHERE 
		#TABLE_HEADER.generic_comment_display_typ_5	= 1
	--
	INSERT INTO #HANYO_TABLE 
	SELECT 
		#TABLE_HEADER.company_cd
	,	#TABLE_HEADER.sheet_cd
	,	ISNULL(TABLE_7.generic_step,0) + 1
	,	7
	FROM #TABLE_HEADER
	LEFT OUTER JOIN (
		SELECT 
			#HANYO_TABLE.company_cd
		,	#HANYO_TABLE.sheet_cd
		,	ISNULL(MAX(#HANYO_TABLE.generic_step),0) AS	generic_step
		FROM #HANYO_TABLE
		GROUP BY
			#HANYO_TABLE.company_cd
		,	#HANYO_TABLE.sheet_cd
	) AS TABLE_7 ON (
		#TABLE_HEADER.company_cd		=	TABLE_7.company_cd
	AND #TABLE_HEADER.sheet_cd			=	TABLE_7.sheet_cd
	)
	WHERE 
		#TABLE_HEADER.generic_comment_display_typ_6	= 1
	--
	INSERT INTO #HANYO_TABLE 
	SELECT 
		#TABLE_HEADER.company_cd
	,	#TABLE_HEADER.sheet_cd
	,	ISNULL(TABLE_8.generic_step,0) + 1
	,	8
	FROM #TABLE_HEADER
	LEFT OUTER JOIN (
		SELECT 
			#HANYO_TABLE.company_cd
		,	#HANYO_TABLE.sheet_cd
		,	ISNULL(MAX(#HANYO_TABLE.generic_step),0) AS	generic_step
		FROM #HANYO_TABLE
		GROUP BY
			#HANYO_TABLE.company_cd
		,	#HANYO_TABLE.sheet_cd
	) AS TABLE_8 ON (
		#TABLE_HEADER.company_cd		=	TABLE_8.company_cd
	AND #TABLE_HEADER.sheet_cd			=	TABLE_8.sheet_cd
	)
	WHERE 
		#TABLE_HEADER.generic_comment_display_typ_7	= 1
	--↓↓↓ add by viettd 2020/10/09
	-- 目標表題
	INSERT INTO #ITEM_TABLE
	SELECT 
		company_cd
	,	sheet_cd
	,	1		-- item_step
	,	1		-- item_num
	FROM #TABLE_HEADER
	WHERE 
		#TABLE_HEADER.item_title_display_typ	= 1
	--目標タイトル1
	INSERT INTO #ITEM_TABLE 
	SELECT 
		#TABLE_HEADER.company_cd
	,	#TABLE_HEADER.sheet_cd
	,	ISNULL(TABLE_2.item_step,0) + 1		-- item_step
	,	2									-- item_num
	FROM #TABLE_HEADER
	LEFT OUTER JOIN (
		SELECT 
			#ITEM_TABLE.company_cd
		,	#ITEM_TABLE.sheet_cd
		,	ISNULL(MAX(#ITEM_TABLE.item_step),0) AS	item_step
		FROM #ITEM_TABLE
		GROUP BY
			#ITEM_TABLE.company_cd
		,	#ITEM_TABLE.sheet_cd
	) AS TABLE_2 ON (
		#TABLE_HEADER.company_cd		=	TABLE_2.company_cd
	AND #TABLE_HEADER.sheet_cd			=	TABLE_2.sheet_cd
	)
	WHERE 
		#TABLE_HEADER.item_display_typ_1 = 1
	--目標タイトル2
	INSERT INTO #ITEM_TABLE 
	SELECT 
		#TABLE_HEADER.company_cd
	,	#TABLE_HEADER.sheet_cd
	,	ISNULL(TABLE_3.item_step,0) + 1		-- item_step
	,	3									-- item_num
	FROM #TABLE_HEADER
	LEFT OUTER JOIN (
		SELECT 
			#ITEM_TABLE.company_cd
		,	#ITEM_TABLE.sheet_cd
		,	ISNULL(MAX(#ITEM_TABLE.item_step),0) AS	item_step
		FROM #ITEM_TABLE
		GROUP BY
			#ITEM_TABLE.company_cd
		,	#ITEM_TABLE.sheet_cd
	) AS TABLE_3 ON (
		#TABLE_HEADER.company_cd		=	TABLE_3.company_cd
	AND #TABLE_HEADER.sheet_cd			=	TABLE_3.sheet_cd
	)
	WHERE 
		#TABLE_HEADER.item_display_typ_2 = 1
	--目標タイトル3
	INSERT INTO #ITEM_TABLE 
	SELECT 
		#TABLE_HEADER.company_cd
	,	#TABLE_HEADER.sheet_cd
	,	ISNULL(TABLE_4.item_step,0) + 1		-- item_step
	,	4									-- item_num
	FROM #TABLE_HEADER
	LEFT OUTER JOIN (
		SELECT 
			#ITEM_TABLE.company_cd
		,	#ITEM_TABLE.sheet_cd
		,	ISNULL(MAX(#ITEM_TABLE.item_step),0) AS	item_step
		FROM #ITEM_TABLE
		GROUP BY
			#ITEM_TABLE.company_cd
		,	#ITEM_TABLE.sheet_cd
	) AS TABLE_4 ON (
		#TABLE_HEADER.company_cd		=	TABLE_4.company_cd
	AND #TABLE_HEADER.sheet_cd			=	TABLE_4.sheet_cd
	)
	WHERE 
		#TABLE_HEADER.item_display_typ_3 = 1
	--目標タイトル4
	INSERT INTO #ITEM_TABLE 
	SELECT 
		#TABLE_HEADER.company_cd
	,	#TABLE_HEADER.sheet_cd
	,	ISNULL(TABLE_5.item_step,0) + 1		-- item_step
	,	5									-- item_num
	FROM #TABLE_HEADER
	LEFT OUTER JOIN (
		SELECT 
			#ITEM_TABLE.company_cd
		,	#ITEM_TABLE.sheet_cd
		,	ISNULL(MAX(#ITEM_TABLE.item_step),0) AS	item_step
		FROM #ITEM_TABLE
		GROUP BY
			#ITEM_TABLE.company_cd
		,	#ITEM_TABLE.sheet_cd
	) AS TABLE_5 ON (
		#TABLE_HEADER.company_cd		=	TABLE_5.company_cd
	AND #TABLE_HEADER.sheet_cd			=	TABLE_5.sheet_cd
	)
	WHERE 
		#TABLE_HEADER.item_display_typ_4 = 1
	--目標タイトル5
	INSERT INTO #ITEM_TABLE 
	SELECT 
		#TABLE_HEADER.company_cd
	,	#TABLE_HEADER.sheet_cd
	,	ISNULL(TABLE_6.item_step,0) + 1		-- item_step
	,	6									-- item_num
	FROM #TABLE_HEADER
	LEFT OUTER JOIN (
		SELECT 
			#ITEM_TABLE.company_cd
		,	#ITEM_TABLE.sheet_cd
		,	ISNULL(MAX(#ITEM_TABLE.item_step),0) AS	item_step
		FROM #ITEM_TABLE
		GROUP BY
			#ITEM_TABLE.company_cd
		,	#ITEM_TABLE.sheet_cd
	) AS TABLE_6 ON (
		#TABLE_HEADER.company_cd		=	TABLE_6.company_cd
	AND #TABLE_HEADER.sheet_cd			=	TABLE_6.sheet_cd
	)
	WHERE 
		#TABLE_HEADER.item_display_typ_5 = 1
	--↑↑↑ end add by viettd 2020/10/09
	-- [0]
	SELECT 
	--	ヘッダー項目
		RH												AS	RH						--	RH
	,	row_item_count									AS	row_item_count			--	row_item_count
	,	count_item_no									AS	count_item_no			--	count row item of sheet_cd
	,	last_page										AS	last_page 
	,	@fiscal_year									AS	fiscal_year
	,	#TABLE_DETAIL.employee_cd						AS	employee_cd
	,	ISNULL(#M0071_SHEET.employee_nm,'')				AS	employee_nm
	,	ISNULL(#M0071_SHEET.grade_nm,'')				AS	grade_nm
	,	ISNULL(#M0071_SHEET.position_nm,'')				AS	position_nm
	,	ISNULL(#M0071_SHEET.job_nm,'')					AS	job_nm
	,	ISNULL(M0070H_1.employee_nm,'')					AS	rater_employee_cd_1
	,	ISNULL(M0070H_2.employee_nm,'')					AS	rater_employee_cd_2
	,	ISNULL(M0070H_3.employee_nm,'')					AS	rater_employee_cd_3
	,	ISNULL(M0070H_4.employee_nm,'')					AS	rater_employee_cd_4
	,	ISNULL(#TABLE_HEADER.sheet_nm,'')				AS	sheet_nm
	,	ISNULL(#TABLE_HEADER.sheet_cd,'')				AS	sheet_cd
	,	ISNULL(#TABLE_HEADER.sheet_kbn,0)				AS	sheet_kbn
	--	↓↓↓ add by viettd 2022/11/17
	,	CASE
			WHEN @P_language = 'en' AND ISNULL(#TABLE_HEADER.sheet_kbn,0) = 1
			THEN '■Objective Management'
			WHEN @P_language = 'en' AND ISNULL(#TABLE_HEADER.sheet_kbn,0) = 2
			THEN '■Qualitative Evaluation'
			WHEN @P_language = 'jp' AND ISNULL(#TABLE_HEADER.sheet_kbn,0) = 1
			THEN '■目標管理'
			WHEN @P_language = 'jp' AND ISNULL(#TABLE_HEADER.sheet_kbn,0) = 2
			THEN '■定性評価'
			ELSE ''
		END												AS	evalutation_label
	--	↑↑↑ add by viettd 2022/11/17
	--	汎用コメント
	,	CASE
			--WHEN #TABLE_HEADER.sheet_kbn = 2
			--THEN '-'
			WHEN ISNULL(HANYOU_TABLE_1.generic_comment_num,0) = 1
			THEN ISNULL(F0101.generic_comment_1,'')
			WHEN ISNULL(HANYOU_TABLE_1.generic_comment_num,0) = 2
			THEN ISNULL(F0101.generic_comment_2,'')
			WHEN ISNULL(HANYOU_TABLE_1.generic_comment_num,0) = 3
			THEN ISNULL(F0101.generic_comment_8,'')
			WHEN ISNULL(HANYOU_TABLE_1.generic_comment_num,0) = 4
			THEN ISNULL(F0101.generic_comment_3,'')
			WHEN ISNULL(HANYOU_TABLE_1.generic_comment_num,0) = 5
			THEN ISNULL(F0101.generic_comment_4,'')
			WHEN ISNULL(HANYOU_TABLE_1.generic_comment_num,0) = 6
			THEN ISNULL(F0101.generic_comment_5,'')
			WHEN ISNULL(HANYOU_TABLE_1.generic_comment_num,0) = 7
			THEN ISNULL(F0101.generic_comment_6,'')
			WHEN ISNULL(HANYOU_TABLE_1.generic_comment_num,0) = 8
			THEN ISNULL(F0101.generic_comment_7,'')
			ELSE '-'
		END																AS	generic_comment_1
	,	CASE
			--WHEN #TABLE_HEADER.sheet_kbn = 2
			--THEN '-'
			WHEN ISNULL(HANYOU_TABLE_2.generic_comment_num,0) = 1
			THEN ISNULL(F0101.generic_comment_1,'')
			WHEN ISNULL(HANYOU_TABLE_2.generic_comment_num,0) = 2
			THEN ISNULL(F0101.generic_comment_2,'')
			WHEN ISNULL(HANYOU_TABLE_2.generic_comment_num,0) = 3
			THEN ISNULL(F0101.generic_comment_8,'')
			WHEN ISNULL(HANYOU_TABLE_2.generic_comment_num,0) = 4
			THEN ISNULL(F0101.generic_comment_3,'')
			WHEN ISNULL(HANYOU_TABLE_2.generic_comment_num,0) = 5
			THEN ISNULL(F0101.generic_comment_4,'')
			WHEN ISNULL(HANYOU_TABLE_2.generic_comment_num,0) = 6
			THEN ISNULL(F0101.generic_comment_5,'')
			WHEN ISNULL(HANYOU_TABLE_2.generic_comment_num,0) = 7
			THEN ISNULL(F0101.generic_comment_6,'')
			WHEN ISNULL(HANYOU_TABLE_2.generic_comment_num,0) = 8
			THEN ISNULL(F0101.generic_comment_7,'')
			ELSE '-'
		END																AS	generic_comment_2
	
	,	CASE
			--WHEN #TABLE_HEADER.sheet_kbn = 2
			--THEN '-'
			WHEN ISNULL(HANYOU_TABLE_3.generic_comment_num,0) = 1
			THEN ISNULL(F0101.generic_comment_1,'')
			WHEN ISNULL(HANYOU_TABLE_3.generic_comment_num,0) = 2
			THEN ISNULL(F0101.generic_comment_2,'')
			WHEN ISNULL(HANYOU_TABLE_3.generic_comment_num,0) = 3
			THEN ISNULL(F0101.generic_comment_8,'')
			WHEN ISNULL(HANYOU_TABLE_3.generic_comment_num,0) = 4
			THEN ISNULL(F0101.generic_comment_3,'')
			WHEN ISNULL(HANYOU_TABLE_3.generic_comment_num,0) = 5
			THEN ISNULL(F0101.generic_comment_4,'')
			WHEN ISNULL(HANYOU_TABLE_3.generic_comment_num,0) = 6
			THEN ISNULL(F0101.generic_comment_5,'')
			WHEN ISNULL(HANYOU_TABLE_3.generic_comment_num,0) = 7
			THEN ISNULL(F0101.generic_comment_6,'')
			WHEN ISNULL(HANYOU_TABLE_3.generic_comment_num,0) = 8
			THEN ISNULL(F0101.generic_comment_7,'')
			ELSE '-'
		END																AS	generic_comment_3
	
	,	CASE
			--WHEN #TABLE_HEADER.sheet_kbn = 2
			--THEN '-'
			WHEN ISNULL(HANYOU_TABLE_4.generic_comment_num,0) = 1
			THEN ISNULL(F0101.generic_comment_1,'')
			WHEN ISNULL(HANYOU_TABLE_4.generic_comment_num,0) = 2
			THEN ISNULL(F0101.generic_comment_2,'')
			WHEN ISNULL(HANYOU_TABLE_4.generic_comment_num,0) = 3
			THEN ISNULL(F0101.generic_comment_8,'')
			WHEN ISNULL(HANYOU_TABLE_4.generic_comment_num,0) = 4
			THEN ISNULL(F0101.generic_comment_3,'')
			WHEN ISNULL(HANYOU_TABLE_4.generic_comment_num,0) = 5
			THEN ISNULL(F0101.generic_comment_4,'')
			WHEN ISNULL(HANYOU_TABLE_4.generic_comment_num,0) = 6
			THEN ISNULL(F0101.generic_comment_5,'')
			WHEN ISNULL(HANYOU_TABLE_4.generic_comment_num,0) = 7
			THEN ISNULL(F0101.generic_comment_6,'')
			WHEN ISNULL(HANYOU_TABLE_4.generic_comment_num,0) = 8
			THEN ISNULL(F0101.generic_comment_7,'')
			ELSE '-'
		END																AS	generic_comment_4
	,	CASE
			--WHEN #TABLE_HEADER.sheet_kbn = 2
			--THEN '-'
			WHEN ISNULL(HANYOU_TABLE_5.generic_comment_num,0) = 1
			THEN ISNULL(F0101.generic_comment_1,'')
			WHEN ISNULL(HANYOU_TABLE_5.generic_comment_num,0) = 2
			THEN ISNULL(F0101.generic_comment_2,'')
			WHEN ISNULL(HANYOU_TABLE_5.generic_comment_num,0) = 3
			THEN ISNULL(F0101.generic_comment_8,'')
			WHEN ISNULL(HANYOU_TABLE_5.generic_comment_num,0) = 4
			THEN ISNULL(F0101.generic_comment_3,'')
			WHEN ISNULL(HANYOU_TABLE_5.generic_comment_num,0) = 5
			THEN ISNULL(F0101.generic_comment_4,'')
			WHEN ISNULL(HANYOU_TABLE_5.generic_comment_num,0) = 6
			THEN ISNULL(F0101.generic_comment_5,'')
			WHEN ISNULL(HANYOU_TABLE_5.generic_comment_num,0) = 7
			THEN ISNULL(F0101.generic_comment_6,'')
			WHEN ISNULL(HANYOU_TABLE_5.generic_comment_num,0) = 8
			THEN ISNULL(F0101.generic_comment_7,'')
			ELSE '-'
		END																AS	generic_comment_5
	,	CASE
			--WHEN #TABLE_HEADER.sheet_kbn = 2
			--THEN '-'
			WHEN ISNULL(HANYOU_TABLE_6.generic_comment_num,0) = 1
			THEN ISNULL(F0101.generic_comment_1,'')
			WHEN ISNULL(HANYOU_TABLE_6.generic_comment_num,0) = 2
			THEN ISNULL(F0101.generic_comment_2,'')
			WHEN ISNULL(HANYOU_TABLE_6.generic_comment_num,0) = 3
			THEN ISNULL(F0101.generic_comment_8,'')
			WHEN ISNULL(HANYOU_TABLE_6.generic_comment_num,0) = 4
			THEN ISNULL(F0101.generic_comment_3,'')
			WHEN ISNULL(HANYOU_TABLE_6.generic_comment_num,0) = 5
			THEN ISNULL(F0101.generic_comment_4,'')
			WHEN ISNULL(HANYOU_TABLE_6.generic_comment_num,0) = 6
			THEN ISNULL(F0101.generic_comment_5,'')
			WHEN ISNULL(HANYOU_TABLE_6.generic_comment_num,0) = 7
			THEN ISNULL(F0101.generic_comment_6,'')
			WHEN ISNULL(HANYOU_TABLE_6.generic_comment_num,0) = 8
			THEN ISNULL(F0101.generic_comment_7,'')
			ELSE '-'
		END																AS	generic_comment_6
	,	CASE
			--WHEN #TABLE_HEADER.sheet_kbn = 2
			--THEN '-'
			WHEN ISNULL(HANYOU_TABLE_7.generic_comment_num,0) = 1
			THEN ISNULL(F0101.generic_comment_1,'')
			WHEN ISNULL(HANYOU_TABLE_7.generic_comment_num,0) = 2
			THEN ISNULL(F0101.generic_comment_2,'')
			WHEN ISNULL(HANYOU_TABLE_7.generic_comment_num,0) = 3
			THEN ISNULL(F0101.generic_comment_8,'')
			WHEN ISNULL(HANYOU_TABLE_7.generic_comment_num,0) = 4
			THEN ISNULL(F0101.generic_comment_3,'')
			WHEN ISNULL(HANYOU_TABLE_7.generic_comment_num,0) = 5
			THEN ISNULL(F0101.generic_comment_4,'')
			WHEN ISNULL(HANYOU_TABLE_7.generic_comment_num,0) = 6
			THEN ISNULL(F0101.generic_comment_5,'')
			WHEN ISNULL(HANYOU_TABLE_7.generic_comment_num,0) = 7
			THEN ISNULL(F0101.generic_comment_6,'')
			WHEN ISNULL(HANYOU_TABLE_7.generic_comment_num,0) = 8
			THEN ISNULL(F0101.generic_comment_7,'')
			ELSE '-'
		END																AS	generic_comment_7
	,	CASE
			--WHEN #TABLE_HEADER.sheet_kbn = 2
			--THEN '-'
			WHEN ISNULL(HANYOU_TABLE_8.generic_comment_num,0) = 1
			THEN ISNULL(F0101.generic_comment_1,'')
			WHEN ISNULL(HANYOU_TABLE_8.generic_comment_num,0) = 2
			THEN ISNULL(F0101.generic_comment_2,'')
			WHEN ISNULL(HANYOU_TABLE_8.generic_comment_num,0) = 3
			THEN ISNULL(F0101.generic_comment_8,'')
			WHEN ISNULL(HANYOU_TABLE_8.generic_comment_num,0) = 4
			THEN ISNULL(F0101.generic_comment_3,'')
			WHEN ISNULL(HANYOU_TABLE_8.generic_comment_num,0) = 5
			THEN ISNULL(F0101.generic_comment_4,'')
			WHEN ISNULL(HANYOU_TABLE_8.generic_comment_num,0) = 6
			THEN ISNULL(F0101.generic_comment_5,'')
			WHEN ISNULL(HANYOU_TABLE_8.generic_comment_num,0) = 7
			THEN ISNULL(F0101.generic_comment_6,'')
			WHEN ISNULL(HANYOU_TABLE_8.generic_comment_num,0) = 8
			THEN ISNULL(F0101.generic_comment_7,'')
			ELSE '-'
		END																AS	generic_comment_8
	--	明細項目
	,	CASE 
			WHEN ISNULL(ITEM_TABLE_1.item_num,0) = 1
			THEN ISNULL(#TABLE_DETAIL.item_title,'')
			WHEN ISNULL(ITEM_TABLE_1.item_num,0) = 2
			THEN ISNULL(#TABLE_DETAIL.item_1,'')
			WHEN ISNULL(ITEM_TABLE_1.item_num,0) = 3
			THEN ISNULL(#TABLE_DETAIL.item_2,'')
			WHEN ISNULL(ITEM_TABLE_1.item_num,0) = 4
			THEN ISNULL(#TABLE_DETAIL.item_3,'')
			WHEN ISNULL(ITEM_TABLE_1.item_num,0) = 5
			THEN ISNULL(#TABLE_DETAIL.item_4,'')
			WHEN ISNULL(ITEM_TABLE_1.item_num,0) = 6
			THEN ISNULL(#TABLE_DETAIL.item_5,'')
			ELSE '-'
		END																AS	item_title
	,	CASE 
			WHEN ISNULL(ITEM_TABLE_2.item_num,0) = 1
			THEN ISNULL(#TABLE_DETAIL.item_title,'')
			WHEN ISNULL(ITEM_TABLE_2.item_num,0) = 2
			THEN ISNULL(#TABLE_DETAIL.item_1,'')
			WHEN ISNULL(ITEM_TABLE_2.item_num,0) = 3
			THEN ISNULL(#TABLE_DETAIL.item_2,'')
			WHEN ISNULL(ITEM_TABLE_2.item_num,0) = 4
			THEN ISNULL(#TABLE_DETAIL.item_3,'')
			WHEN ISNULL(ITEM_TABLE_2.item_num,0) = 5
			THEN ISNULL(#TABLE_DETAIL.item_4,'')
			WHEN ISNULL(ITEM_TABLE_2.item_num,0) = 6
			THEN ISNULL(#TABLE_DETAIL.item_5,'')
			ELSE '-'
		END																AS	item_1
	,	CASE 
			WHEN ISNULL(ITEM_TABLE_3.item_num,0) = 1
			THEN ISNULL(#TABLE_DETAIL.item_title,'')
			WHEN ISNULL(ITEM_TABLE_3.item_num,0) = 2
			THEN ISNULL(#TABLE_DETAIL.item_1,'')
			WHEN ISNULL(ITEM_TABLE_3.item_num,0) = 3
			THEN ISNULL(#TABLE_DETAIL.item_2,'')
			WHEN ISNULL(ITEM_TABLE_3.item_num,0) = 4
			THEN ISNULL(#TABLE_DETAIL.item_3,'')
			WHEN ISNULL(ITEM_TABLE_3.item_num,0) = 5
			THEN ISNULL(#TABLE_DETAIL.item_4,'')
			WHEN ISNULL(ITEM_TABLE_3.item_num,0) = 6
			THEN ISNULL(#TABLE_DETAIL.item_5,'')
			ELSE '-'
		END																AS	item_2
	,	CASE 
			WHEN ISNULL(ITEM_TABLE_4.item_num,0) = 1
			THEN ISNULL(#TABLE_DETAIL.item_title,'')
			WHEN ISNULL(ITEM_TABLE_4.item_num,0) = 2
			THEN ISNULL(#TABLE_DETAIL.item_1,'')
			WHEN ISNULL(ITEM_TABLE_4.item_num,0) = 3
			THEN ISNULL(#TABLE_DETAIL.item_2,'')
			WHEN ISNULL(ITEM_TABLE_4.item_num,0) = 4
			THEN ISNULL(#TABLE_DETAIL.item_3,'')
			WHEN ISNULL(ITEM_TABLE_4.item_num,0) = 5
			THEN ISNULL(#TABLE_DETAIL.item_4,'')
			WHEN ISNULL(ITEM_TABLE_4.item_num,0) = 6
			THEN ISNULL(#TABLE_DETAIL.item_5,'')
			ELSE '-'
		END																AS	item_3
	,	CASE 
			WHEN ISNULL(ITEM_TABLE_5.item_num,0) = 1
			THEN ISNULL(#TABLE_DETAIL.item_title,'')
			WHEN ISNULL(ITEM_TABLE_5.item_num,0) = 2
			THEN ISNULL(#TABLE_DETAIL.item_1,'')
			WHEN ISNULL(ITEM_TABLE_5.item_num,0) = 3
			THEN ISNULL(#TABLE_DETAIL.item_2,'')
			WHEN ISNULL(ITEM_TABLE_5.item_num,0) = 4
			THEN ISNULL(#TABLE_DETAIL.item_3,'')
			WHEN ISNULL(ITEM_TABLE_5.item_num,0) = 5
			THEN ISNULL(#TABLE_DETAIL.item_4,'')
			WHEN ISNULL(ITEM_TABLE_5.item_num,0) = 6
			THEN ISNULL(#TABLE_DETAIL.item_5,'')
			ELSE '-'
		END																AS	item_4
	,	CASE 
			WHEN ISNULL(ITEM_TABLE_6.item_num,0) = 1
			THEN ISNULL(#TABLE_DETAIL.item_title,'')
			WHEN ISNULL(ITEM_TABLE_6.item_num,0) = 2
			THEN ISNULL(#TABLE_DETAIL.item_1,'')
			WHEN ISNULL(ITEM_TABLE_6.item_num,0) = 3
			THEN ISNULL(#TABLE_DETAIL.item_2,'')
			WHEN ISNULL(ITEM_TABLE_6.item_num,0) = 4
			THEN ISNULL(#TABLE_DETAIL.item_3,'')
			WHEN ISNULL(ITEM_TABLE_6.item_num,0) = 5
			THEN ISNULL(#TABLE_DETAIL.item_4,'')
			WHEN ISNULL(ITEM_TABLE_6.item_num,0) = 6
			THEN ISNULL(#TABLE_DETAIL.item_5,'')
			ELSE '-'
		END																AS	item_5
	-- add by viettd 2020/05/25
	,	CASE 
			WHEN ISNULL(#TABLE_HEADER.point_calculation_typ1,0) = 1 -- 1.ウェイト
			THEN IIF(@P_language = 'en','Weight','ウェイト')
			WHEN ISNULL(#TABLE_HEADER.point_calculation_typ1,0) = 2 -- 2.係数
			THEN IIF(@P_language = 'en','Degree','係数')
			ELSE ''
		END																AS	weight_title	-- ウェイト名
	-- end add by viettd 2020/05/25
	,	CASE
			WHEN ISNULL(#TABLE_HEADER.weight_display_typ,0) = 1 AND ISNULL(#TABLE_HEADER.point_calculation_typ1,0) = 1 -- 1.ウェイト
			THEN CAST(ISNULL(#TABLE_DETAIL.weight,0) AS nvarchar(10)) + '%'
			WHEN ISNULL(#TABLE_HEADER.weight_display_typ,0) = 1 AND ISNULL(#TABLE_HEADER.point_calculation_typ1,0) = 2 -- 2.係数
			THEN CAST(ISNULL(#TABLE_DETAIL.weight,0) AS nvarchar(10))
			ELSE '-'
		END																AS	[weight]
	,	CASE
			WHEN ISNULL(#TABLE_HEADER.challenge_level_display_typ,0) = 1
			THEN ISNULL(#TABLE_DETAIL.challenge_level_nm,'')		
			ELSE '-'
		END																AS	challenge_level_nm
	,	''		as	progress_comment_self
	,	''		as	progress_comment_rater
	,	ISNULL(#TABLE_DETAIL.evaluation_comment_0,'')					AS	evaluation_comment_detail_0
	,	ISNULL(#TABLE_DETAIL.evaluation_comment_1,'')					AS	evaluation_comment_detail_1
	,	CASE
			WHEN (#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_self_assessment_typ = 1 ) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_self_assessment_typ = 1)
			THEN IIF(ISNULL(#TABLE_DETAIL.point_nm_0,'') = '0','-',ISNULL(#TABLE_DETAIL.point_nm_0,''))	
			ELSE '-'
		END																AS	point_nm_0
	,	CASE
			WHEN (#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_self_assessment_typ = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_self_assessment_typ = 1) 
			THEN ISNULL(#TABLE_DETAIL.point_0,0)	
			ELSE 0
		END																AS	point_0
	-- edited by viettd 2020/05/12
	,	CASE 
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 1 AND #TABLE_DETAIL.status_cd >= 10) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_1 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_1 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_nm_1,'') = '0','-',ISNULL(#TABLE_DETAIL.point_nm_1,''))
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 2 AND #TABLE_DETAIL.status_cd >= 8) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_1 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_1 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_nm_1,'') = '0','-',ISNULL(#TABLE_DETAIL.point_nm_1,''))
			WHEN #TABLE_DETAIL.login_evaluation_step >= 1 AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_1 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_1 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_nm_1,'') = '0','-',ISNULL(#TABLE_DETAIL.point_nm_1,''))	
			ELSE '-'
		END																AS	point_nm_1
	,	CASE
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 1 AND #TABLE_DETAIL.status_cd >= 10) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_1 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_1 = 1))
			THEN ISNULL(#TABLE_DETAIL.point_1,0)
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 2 AND #TABLE_DETAIL.status_cd >= 8) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_1 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_1 = 1))
			THEN ISNULL(#TABLE_DETAIL.point_1,0)
			WHEN #TABLE_DETAIL.login_evaluation_step >= 1 AND  ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_1 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_1 = 1))
			THEN ISNULL(#TABLE_DETAIL.point_1,0)	
			ELSE 0
		END																AS	point_1
	,	CASE
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 1 AND #TABLE_DETAIL.status_cd >= 10) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_2 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_2 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_nm_2,'') = '0','-',ISNULL(#TABLE_DETAIL.point_nm_2,''))	
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 2 AND #TABLE_DETAIL.status_cd >= 8) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_2 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_2 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_nm_2,'') = '0','-',ISNULL(#TABLE_DETAIL.point_nm_2,''))	
			WHEN #TABLE_DETAIL.login_evaluation_step >= 2 AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_2 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_2 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_nm_2,'') = '0','-',ISNULL(#TABLE_DETAIL.point_nm_2,''))	
			ELSE '-'
		END																AS	point_nm_2
	,	CASE
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 1 AND #TABLE_DETAIL.status_cd >= 10) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_2 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_2 = 1))
			THEN ISNULL(#TABLE_DETAIL.point_2,0)
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 2 AND #TABLE_DETAIL.status_cd >= 8) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_2 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_2 = 1))
			THEN ISNULL(#TABLE_DETAIL.point_2,0)
			WHEN #TABLE_DETAIL.login_evaluation_step >= 2 AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_2 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_2 = 1))
			THEN ISNULL(#TABLE_DETAIL.point_2,0)	
			ELSE 0
		END																AS	point_2
	,	CASE
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 1 AND #TABLE_DETAIL.status_cd >= 10) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_3 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_3 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_nm_3,'') = '0','-',ISNULL(#TABLE_DETAIL.point_nm_3,''))	
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 2 AND #TABLE_DETAIL.status_cd >= 8) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_3 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_3 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_nm_3,'') = '0','-',ISNULL(#TABLE_DETAIL.point_nm_3,''))	
			WHEN #TABLE_DETAIL.login_evaluation_step >= 3 AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_3 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_3 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_nm_3,'') = '0','-',ISNULL(#TABLE_DETAIL.point_nm_3,''))	
			ELSE '-'
		END																AS	point_nm_3
	,	CASE
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 1 AND #TABLE_DETAIL.status_cd >= 10) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_3 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_3 = 1))
			THEN ISNULL(#TABLE_DETAIL.point_3,0)
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 2 AND #TABLE_DETAIL.status_cd >= 8) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_3 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_3 = 1))
			THEN ISNULL(#TABLE_DETAIL.point_3,0)	
			WHEN #TABLE_DETAIL.login_evaluation_step >= 3 AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_3 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_3 = 1))
			THEN ISNULL(#TABLE_DETAIL.point_3,0)	
			ELSE 0
		END																AS	point_3
	,	CASE
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 1 AND #TABLE_DETAIL.status_cd >= 10) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_4 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_4 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_nm_4,'') = '0','-',ISNULL(#TABLE_DETAIL.point_nm_4,''))
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 2 AND #TABLE_DETAIL.status_cd >= 8) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_4 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_4 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_nm_4,'') = '0','-',ISNULL(#TABLE_DETAIL.point_nm_4,''))	
			WHEN #TABLE_DETAIL.login_evaluation_step >= 4 AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_4 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_4 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_nm_4,'') = '0','-',ISNULL(#TABLE_DETAIL.point_nm_4,''))	
			ELSE '-'
		END																AS	point_nm_4
	,	CASE
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 1 AND #TABLE_DETAIL.status_cd >= 10) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_4 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_4 = 1))
			THEN ISNULL(#TABLE_DETAIL.point_4,0)
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 2 AND #TABLE_DETAIL.status_cd >= 8) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_4 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_4 = 1))
			THEN ISNULL(#TABLE_DETAIL.point_4,0)
			WHEN #TABLE_DETAIL.login_evaluation_step >= 4 AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_4 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_4 = 1))
			THEN ISNULL(#TABLE_DETAIL.point_4,0)	
			ELSE 0
		END																AS	point_4
	--	合計項目
	,	CASE
			WHEN (#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_self_assessment_typ = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_self_assessment_typ = 1)
			THEN IIF(ISNULL(#TABLE_DETAIL.point_sum0,0) = 0,NULL,ISNULL(#TABLE_DETAIL.point_sum0,0))		
			ELSE NULL
		END																AS	point_sum0
	,	CASE
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 1 AND #TABLE_DETAIL.status_cd >= 10) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_1 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_1 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_sum1,0) = 0,NULL,ISNULL(#TABLE_DETAIL.point_sum1,0))
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 2 AND #TABLE_DETAIL.status_cd >= 8) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_1 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_1 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_sum1,0) = 0,NULL,ISNULL(#TABLE_DETAIL.point_sum1,0))
			WHEN #TABLE_DETAIL.login_evaluation_step >= 1 AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_1 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_1 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_sum1,0) = 0,NULL,ISNULL(#TABLE_DETAIL.point_sum1,0))	
			ELSE NULL
		END																AS	point_sum1
	,	CASE
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 1 AND #TABLE_DETAIL.status_cd >= 10) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_2 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_2 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_sum2,0) = 0,NULL,ISNULL(#TABLE_DETAIL.point_sum2,0))
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 2 AND #TABLE_DETAIL.status_cd >= 8) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_2 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_2 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_sum2,0) = 0,NULL,ISNULL(#TABLE_DETAIL.point_sum2,0))
			WHEN #TABLE_DETAIL.login_evaluation_step >= 2 AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_2 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_2 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_sum2,0) = 0,NULL,ISNULL(#TABLE_DETAIL.point_sum2,0))
			ELSE NULL
		END																AS	point_sum2
	,	CASE
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 1 AND #TABLE_DETAIL.status_cd >= 10) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_3 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_3 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_sum3,0) = 0,NULL,ISNULL(#TABLE_DETAIL.point_sum3,0))
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 2 AND #TABLE_DETAIL.status_cd >= 8) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_3 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_3 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_sum3,0) = 0,NULL,ISNULL(#TABLE_DETAIL.point_sum3,0))
			WHEN #TABLE_DETAIL.login_evaluation_step >= 3 AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_3 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_3 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_sum3,0) = 0,NULL,ISNULL(#TABLE_DETAIL.point_sum3,0))
			ELSE NULL
		END																AS	point_sum3
	,	CASE
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 1 AND #TABLE_DETAIL.status_cd >= 10) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_4 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_4 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_sum4,0) = 0,NULL,ISNULL(#TABLE_DETAIL.point_sum4,0))
			WHEN (ISNULL(#TABLE_HEADER.sheet_kbn,0) = 2 AND #TABLE_DETAIL.status_cd >= 8) AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_4 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_4 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_sum4,0) = 0,NULL,ISNULL(#TABLE_DETAIL.point_sum4,0))
			WHEN #TABLE_DETAIL.login_evaluation_step >= 4 AND ((#TABLE_HEADER.sheet_kbn = 1 AND #TABLE_HEADER.target_evaluation_typ_4 = 1) OR (#TABLE_HEADER.sheet_kbn = 2 AND #TABLE_HEADER.evaluation_typ_4 = 1))
			THEN IIF(ISNULL(#TABLE_DETAIL.point_sum4,0) = 0,NULL,ISNULL(#TABLE_DETAIL.point_sum4,0))
			ELSE NULL
		END																AS	point_sum4
	--	フッター項目
	,	ISNULL(F0120_0.evaluation_comment,'')							AS	evaluation_comment_0	--	自己評価コメント
	,	ISNULL(F0120_1.evaluation_comment,'')							AS	evaluation_comment_1	--	一次評価コメント
	,	ISNULL(F0120_2.evaluation_comment,'')							AS	evaluation_comment_2	--	二次評価コメント
	,	ISNULL(F0120_3.evaluation_comment,'')							AS	evaluation_comment_3	--	三次評価コメント
	,	ISNULL(F0120_4.evaluation_comment,'')							AS	evaluation_comment_4	--	四次評価コメント
	-- 評価基準
	,	ISNULL(#TABLE_評価基準.point_kinds_text,'')						AS	point_kinds_text		--	評価基準
	-- 評価面談
	--add vietdt 2021/12/07
	,	CASE	
			WHEN #TABLE_HEADER.rater_interview_use_typ = 0 OR #TABLE_DETAIL.rater_employee_cd_2 =''
			THEN '-'
			ELSE IIF(@P_language = 'en','2nd Rater'+''''+'s Comment','二次評価者コメント')									
		END																AS	header_interview_2
	,	CASE	
			WHEN #TABLE_HEADER.rater_interview_use_typ = 0 OR #TABLE_DETAIL.rater_employee_cd_3 =''
			THEN '-'
			ELSE IIF(@P_language = 'en','3rd Rater'+''''+'s Comment','三次評価者コメント')											
		END																AS	header_interview_3
	,	CASE	
			WHEN #TABLE_HEADER.rater_interview_use_typ = 0 OR #TABLE_DETAIL.rater_employee_cd_4 =''
			THEN '-'
			ELSE IIF(@P_language = 'en','4th Rater'+''''+'s Comment','四次評価者コメント')							
		END																AS	header_interview_4
	,	ISNULL(#TABLE_評価面談.interview_text,'')						AS	interview_text			--	評価面談
	-- header
	,	ISNULL(#TABLE_HEADER.generic_comment_display_typ_1,0)			AS	generic_comment_display_typ_1
	,	ISNULL(#TABLE_HEADER.generic_comment_display_typ_2,0)			AS	generic_comment_display_typ_2
	,	ISNULL(#TABLE_HEADER.generic_comment_display_typ_3,0)			AS	generic_comment_display_typ_3
	,	ISNULL(#TABLE_HEADER.generic_comment_display_typ_4,0)			AS	generic_comment_display_typ_4
	,	ISNULL(#TABLE_HEADER.generic_comment_display_typ_5,0)			AS	generic_comment_display_typ_5
	,	ISNULL(#TABLE_HEADER.generic_comment_display_typ_6,0)			AS	generic_comment_display_typ_6
	,	ISNULL(#TABLE_HEADER.generic_comment_display_typ_7,0)			AS	generic_comment_display_typ_7
	,	ISNULL(#TABLE_HEADER.generic_comment_display_typ_8,0)			AS	generic_comment_display_typ_8
	,	CASE
			--WHEN #TABLE_HEADER.sheet_kbn = 2
			--THEN '-'
			WHEN ISNULL(HANYOU_TABLE_1.generic_comment_num,0) = 1
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_1,'')
			WHEN ISNULL(HANYOU_TABLE_1.generic_comment_num,0) = 2
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_2,'')
			WHEN ISNULL(HANYOU_TABLE_1.generic_comment_num,0) = 3
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_8,'')
			WHEN ISNULL(HANYOU_TABLE_1.generic_comment_num,0) = 4
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_3,'')
			WHEN ISNULL(HANYOU_TABLE_1.generic_comment_num,0) = 5
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_4,'')
			WHEN ISNULL(HANYOU_TABLE_1.generic_comment_num,0) = 6
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_5,'')
			WHEN ISNULL(HANYOU_TABLE_1.generic_comment_num,0) = 7
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_6,'')
			WHEN ISNULL(HANYOU_TABLE_1.generic_comment_num,0) = 8
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_7,'')
			ELSE '-'
		END																AS	generic_comment_title_1
	,	CASE
			--WHEN #TABLE_HEADER.sheet_kbn = 2
			--THEN '-'
			WHEN ISNULL(HANYOU_TABLE_2.generic_comment_num,0) = 1
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_1,'')
			WHEN ISNULL(HANYOU_TABLE_2.generic_comment_num,0) = 2
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_2,'')
			WHEN ISNULL(HANYOU_TABLE_2.generic_comment_num,0) = 3
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_8,'')
			WHEN ISNULL(HANYOU_TABLE_2.generic_comment_num,0) = 4
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_3,'')
			WHEN ISNULL(HANYOU_TABLE_2.generic_comment_num,0) = 5
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_4,'')
			WHEN ISNULL(HANYOU_TABLE_2.generic_comment_num,0) = 6
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_5,'')
			WHEN ISNULL(HANYOU_TABLE_2.generic_comment_num,0) = 7
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_6,'')
			WHEN ISNULL(HANYOU_TABLE_2.generic_comment_num,0) = 8
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_7,'')
			ELSE '-'
		END																AS	generic_comment_title_2
	,	CASE
			--WHEN #TABLE_HEADER.sheet_kbn = 2
			--THEN '-'
			WHEN ISNULL(HANYOU_TABLE_3.generic_comment_num,0) = 1
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_1,'')
			WHEN ISNULL(HANYOU_TABLE_3.generic_comment_num,0) = 2
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_2,'')
			WHEN ISNULL(HANYOU_TABLE_3.generic_comment_num,0) = 3
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_8,'')
			WHEN ISNULL(HANYOU_TABLE_3.generic_comment_num,0) = 4
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_3,'')
			WHEN ISNULL(HANYOU_TABLE_3.generic_comment_num,0) = 5
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_4,'')
			WHEN ISNULL(HANYOU_TABLE_3.generic_comment_num,0) = 6
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_5,'')
			WHEN ISNULL(HANYOU_TABLE_3.generic_comment_num,0) = 7
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_6,'')
			WHEN ISNULL(HANYOU_TABLE_3.generic_comment_num,0) = 8
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_7,'')
			ELSE '-'
		END																AS	generic_comment_title_3
	,	CASE
			--WHEN #TABLE_HEADER.sheet_kbn = 2
			--THEN '-'
			WHEN ISNULL(HANYOU_TABLE_4.generic_comment_num,0) = 1
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_1,'')
			WHEN ISNULL(HANYOU_TABLE_4.generic_comment_num,0) = 2
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_2,'')
			WHEN ISNULL(HANYOU_TABLE_4.generic_comment_num,0) = 3
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_8,'')
			WHEN ISNULL(HANYOU_TABLE_4.generic_comment_num,0) = 4
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_3,'')
			WHEN ISNULL(HANYOU_TABLE_4.generic_comment_num,0) = 5
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_4,'')
			WHEN ISNULL(HANYOU_TABLE_4.generic_comment_num,0) = 6
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_5,'')
			WHEN ISNULL(HANYOU_TABLE_4.generic_comment_num,0) = 7
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_6,'')
			WHEN ISNULL(HANYOU_TABLE_4.generic_comment_num,0) = 8
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_7,'')
			ELSE '-'
		END																AS	generic_comment_title_4
	,	CASE
			--WHEN #TABLE_HEADER.sheet_kbn = 2
			--THEN '-'
			WHEN ISNULL(HANYOU_TABLE_5.generic_comment_num,0) = 1
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_1,'')
			WHEN ISNULL(HANYOU_TABLE_5.generic_comment_num,0) = 2
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_2,'')
			WHEN ISNULL(HANYOU_TABLE_5.generic_comment_num,0) = 3
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_8,'')
			WHEN ISNULL(HANYOU_TABLE_5.generic_comment_num,0) = 4
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_3,'')
			WHEN ISNULL(HANYOU_TABLE_5.generic_comment_num,0) = 5
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_4,'')
			WHEN ISNULL(HANYOU_TABLE_5.generic_comment_num,0) = 6
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_5,'')
			WHEN ISNULL(HANYOU_TABLE_5.generic_comment_num,0) = 7
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_6,'')
			WHEN ISNULL(HANYOU_TABLE_5.generic_comment_num,0) = 8
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_7,'')
			ELSE '-'
		END																AS	generic_comment_title_5
	,	CASE
			--WHEN #TABLE_HEADER.sheet_kbn = 2
			--THEN '-'
			WHEN ISNULL(HANYOU_TABLE_6.generic_comment_num,0) = 1
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_1,'')
			WHEN ISNULL(HANYOU_TABLE_6.generic_comment_num,0) = 2
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_2,'')
			WHEN ISNULL(HANYOU_TABLE_6.generic_comment_num,0) = 3
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_8,'')
			WHEN ISNULL(HANYOU_TABLE_6.generic_comment_num,0) = 4
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_3,'')
			WHEN ISNULL(HANYOU_TABLE_6.generic_comment_num,0) = 5
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_4,'')
			WHEN ISNULL(HANYOU_TABLE_6.generic_comment_num,0) = 6
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_5,'')
			WHEN ISNULL(HANYOU_TABLE_6.generic_comment_num,0) = 7
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_6,'')
			WHEN ISNULL(HANYOU_TABLE_6.generic_comment_num,0) = 8
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_7,'')
			ELSE '-'
		END																AS	generic_comment_title_6
	,	CASE
			--WHEN #TABLE_HEADER.sheet_kbn = 2
			--THEN '-'
			WHEN ISNULL(HANYOU_TABLE_7.generic_comment_num,0) = 1
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_1,'')
			WHEN ISNULL(HANYOU_TABLE_7.generic_comment_num,0) = 2
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_2,'')
			WHEN ISNULL(HANYOU_TABLE_7.generic_comment_num,0) = 3
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_8,'')
			WHEN ISNULL(HANYOU_TABLE_7.generic_comment_num,0) = 4
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_3,'')
			WHEN ISNULL(HANYOU_TABLE_7.generic_comment_num,0) = 5
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_4,'')
			WHEN ISNULL(HANYOU_TABLE_7.generic_comment_num,0) = 6
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_5,'')
			WHEN ISNULL(HANYOU_TABLE_7.generic_comment_num,0) = 7
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_6,'')
			WHEN ISNULL(HANYOU_TABLE_7.generic_comment_num,0) = 8
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_7,'')
			ELSE '-'
		END																AS	generic_comment_title_7
	,	CASE
			--WHEN #TABLE_HEADER.sheet_kbn = 2
			--THEN '-'
			WHEN ISNULL(HANYOU_TABLE_8.generic_comment_num,0) = 1
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_1,'')
			WHEN ISNULL(HANYOU_TABLE_8.generic_comment_num,0) = 2
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_2,'')
			WHEN ISNULL(HANYOU_TABLE_8.generic_comment_num,0) = 3
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_8,'')
			WHEN ISNULL(HANYOU_TABLE_8.generic_comment_num,0) = 4
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_3,'')
			WHEN ISNULL(HANYOU_TABLE_8.generic_comment_num,0) = 5
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_4,'')
			WHEN ISNULL(HANYOU_TABLE_8.generic_comment_num,0) = 6
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_5,'')
			WHEN ISNULL(HANYOU_TABLE_8.generic_comment_num,0) = 7
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_6,'')
			WHEN ISNULL(HANYOU_TABLE_8.generic_comment_num,0) = 8
			THEN ISNULL(#TABLE_HEADER.generic_comment_title_7,'')
			ELSE '-'
		END																AS	generic_comment_title_8

	,	ISNULL(#TABLE_HEADER.item_title_display_typ,0)					AS	item_title_display_typ
	,	ISNULL(#TABLE_HEADER.item_display_typ_1,0)						AS	item_display_typ_1
	,	ISNULL(#TABLE_HEADER.item_display_typ_2,0)						AS	item_display_typ_2
	,	ISNULL(#TABLE_HEADER.item_display_typ_3,0)						AS	item_display_typ_3
	,	ISNULL(#TABLE_HEADER.item_display_typ_4,0)						AS	item_display_typ_4
	,	ISNULL(#TABLE_HEADER.item_display_typ_5,0)						AS	item_display_typ_5
	--
	,	CASE 
			WHEN ISNULL(ITEM_TABLE_1.item_num,0) = 1
			THEN ISNULL(#TABLE_HEADER.item_title_title,'')
			WHEN ISNULL(ITEM_TABLE_1.item_num,0) = 2
			THEN ISNULL(#TABLE_HEADER.item_title_1,'')
			WHEN ISNULL(ITEM_TABLE_1.item_num,0) = 3
			THEN ISNULL(#TABLE_HEADER.item_title_2,'')
			WHEN ISNULL(ITEM_TABLE_1.item_num,0) = 4
			THEN ISNULL(#TABLE_HEADER.item_title_3,'')
			WHEN ISNULL(ITEM_TABLE_1.item_num,0) = 5
			THEN ISNULL(#TABLE_HEADER.item_title_4,'')
			WHEN ISNULL(ITEM_TABLE_1.item_num,0) = 6
			THEN ISNULL(#TABLE_HEADER.item_title_5,'')
			ELSE '-'
		END																AS	item_title_title
	,	CASE 
			WHEN ISNULL(ITEM_TABLE_2.item_num,0) = 1
			THEN ISNULL(#TABLE_HEADER.item_title_title,'')
			WHEN ISNULL(ITEM_TABLE_2.item_num,0) = 2
			THEN ISNULL(#TABLE_HEADER.item_title_1,'')
			WHEN ISNULL(ITEM_TABLE_2.item_num,0) = 3
			THEN ISNULL(#TABLE_HEADER.item_title_2,'')
			WHEN ISNULL(ITEM_TABLE_2.item_num,0) = 4
			THEN ISNULL(#TABLE_HEADER.item_title_3,'')
			WHEN ISNULL(ITEM_TABLE_2.item_num,0) = 5
			THEN ISNULL(#TABLE_HEADER.item_title_4,'')
			WHEN ISNULL(ITEM_TABLE_2.item_num,0) = 6
			THEN ISNULL(#TABLE_HEADER.item_title_5,'')
			ELSE '-'
		END																AS	item_title_1
	,	CASE 
			WHEN ISNULL(ITEM_TABLE_3.item_num,0) = 1
			THEN ISNULL(#TABLE_HEADER.item_title_title,'')
			WHEN ISNULL(ITEM_TABLE_3.item_num,0) = 2
			THEN ISNULL(#TABLE_HEADER.item_title_1,'')
			WHEN ISNULL(ITEM_TABLE_3.item_num,0) = 3
			THEN ISNULL(#TABLE_HEADER.item_title_2,'')
			WHEN ISNULL(ITEM_TABLE_3.item_num,0) = 4
			THEN ISNULL(#TABLE_HEADER.item_title_3,'')
			WHEN ISNULL(ITEM_TABLE_3.item_num,0) = 5
			THEN ISNULL(#TABLE_HEADER.item_title_4,'')
			WHEN ISNULL(ITEM_TABLE_3.item_num,0) = 6
			THEN ISNULL(#TABLE_HEADER.item_title_5,'')
			ELSE '-'
		END																AS	item_title_2
	,	CASE 
			WHEN ISNULL(ITEM_TABLE_4.item_num,0) = 1
			THEN ISNULL(#TABLE_HEADER.item_title_title,'')
			WHEN ISNULL(ITEM_TABLE_4.item_num,0) = 2
			THEN ISNULL(#TABLE_HEADER.item_title_1,'')
			WHEN ISNULL(ITEM_TABLE_4.item_num,0) = 3
			THEN ISNULL(#TABLE_HEADER.item_title_2,'')
			WHEN ISNULL(ITEM_TABLE_4.item_num,0) = 4
			THEN ISNULL(#TABLE_HEADER.item_title_3,'')
			WHEN ISNULL(ITEM_TABLE_4.item_num,0) = 5
			THEN ISNULL(#TABLE_HEADER.item_title_4,'')
			WHEN ISNULL(ITEM_TABLE_4.item_num,0) = 6
			THEN ISNULL(#TABLE_HEADER.item_title_5,'')
			ELSE '-'
		END																AS	item_title_3
	,	CASE 
			WHEN ISNULL(ITEM_TABLE_5.item_num,0) = 1
			THEN ISNULL(#TABLE_HEADER.item_title_title,'')
			WHEN ISNULL(ITEM_TABLE_5.item_num,0) = 2
			THEN ISNULL(#TABLE_HEADER.item_title_1,'')
			WHEN ISNULL(ITEM_TABLE_5.item_num,0) = 3
			THEN ISNULL(#TABLE_HEADER.item_title_2,'')
			WHEN ISNULL(ITEM_TABLE_5.item_num,0) = 4
			THEN ISNULL(#TABLE_HEADER.item_title_3,'')
			WHEN ISNULL(ITEM_TABLE_5.item_num,0) = 5
			THEN ISNULL(#TABLE_HEADER.item_title_4,'')
			WHEN ISNULL(ITEM_TABLE_5.item_num,0) = 6
			THEN ISNULL(#TABLE_HEADER.item_title_5,'')
			ELSE '-'
		END																AS	item_title_4
	,	CASE 
			WHEN ISNULL(ITEM_TABLE_6.item_num,0) = 1
			THEN ISNULL(#TABLE_HEADER.item_title_title,'')
			WHEN ISNULL(ITEM_TABLE_6.item_num,0) = 2
			THEN ISNULL(#TABLE_HEADER.item_title_1,'')
			WHEN ISNULL(ITEM_TABLE_6.item_num,0) = 3
			THEN ISNULL(#TABLE_HEADER.item_title_2,'')
			WHEN ISNULL(ITEM_TABLE_6.item_num,0) = 4
			THEN ISNULL(#TABLE_HEADER.item_title_3,'')
			WHEN ISNULL(ITEM_TABLE_6.item_num,0) = 5
			THEN ISNULL(#TABLE_HEADER.item_title_4,'')
			WHEN ISNULL(ITEM_TABLE_6.item_num,0) = 6
			THEN ISNULL(#TABLE_HEADER.item_title_5,'')
			ELSE '-'
		END																AS	item_title_5
	,	ISNULL(#TABLE_HEADER.weight_display_typ,0)						AS	weight_display_typ
	,	CASE 
			WHEN ISNULL(#TABLE_HEADER.sheet_kbn,0)	= 1
			THEN ISNULL(#TABLE_HEADER.challenge_level_display_typ,0)
			ELSE 0
		END																AS	challenge_level_display_typ
	,	CASE 
			WHEN ISNULL(#TABLE_HEADER.sheet_kbn,0)	= 1
			THEN ISNULL(#TABLE_HEADER.progress_comment_display_typ,0)
			ELSE 0
		END																AS	progress_comment_display_typ
	,	ISNULL(#TABLE_HEADER.detail_comment_display_typ_0,0)			AS	detail_comment_display_typ_0
	,	ISNULL(#TABLE_HEADER.detail_comment_display_typ_1,0)			AS	detail_comment_display_typ_1
	,	ISNULL(#TABLE_HEADER.point_criteria_display_typ,0)				AS	point_criteria_display_typ
	,	ISNULL(#TABLE_HEADER.challengelevel_criteria_display_typ,0)		AS	challengelevel_criteria_display_typ	
	,	CASE	
			WHEN	ISNULL(#TABLE_DETAIL.confirm_status,'')	 <> ''
			THEN	IIF(@P_language = 'en','Preliminary Version',#TABLE_DETAIL.confirm_status)
			ELSE	ISNULL(#TABLE_DETAIL.confirm_status,'')
		END																AS	confirm_status
	,	@P_language														AS	language	--add vietdt 2022/08/22
	--
	FROM #TABLE_DETAIL
	LEFT OUTER JOIN #M0071_SHEET ON (
		#TABLE_DETAIL.company_cd			=	#M0071_SHEET.company_cd
	AND #TABLE_DETAIL.fiscal_year			=	#M0071_SHEET.fiscal_year
	AND #TABLE_DETAIL.employee_cd			=	#M0071_SHEET.employee_cd
	AND #TABLE_DETAIL.sheet_cd				=	#M0071_SHEET.sheet_cd
	)
	LEFT OUTER JOIN M0070 AS M0070H_1 ON (
		#TABLE_DETAIL.company_cd				=	M0070H_1.company_cd
	AND	#TABLE_DETAIL.rater_employee_cd_1		=	M0070H_1.employee_cd
	)
	LEFT OUTER JOIN M0070 AS M0070H_2 ON (
		#TABLE_DETAIL.company_cd				=	M0070H_2.company_cd
	AND	#TABLE_DETAIL.rater_employee_cd_2		=	M0070H_2.employee_cd
	)
	LEFT OUTER JOIN M0070 AS M0070H_3 ON (
		#TABLE_DETAIL.company_cd				=	M0070H_3.company_cd
	AND	#TABLE_DETAIL.rater_employee_cd_3		=	M0070H_3.employee_cd
	)
	LEFT OUTER JOIN M0070 AS M0070H_4 ON (
		#TABLE_DETAIL.company_cd				=	M0070H_4.company_cd
	AND	#TABLE_DETAIL.rater_employee_cd_4		=	M0070H_4.employee_cd
	)
	LEFT OUTER JOIN #TABLE_HEADER ON (
		#TABLE_DETAIL.sheet_cd			=	#TABLE_HEADER.sheet_cd
	)
	--↓↓↓ add by viettd 2020/05/25
	LEFT OUTER JOIN #HANYO_TABLE AS HANYOU_TABLE_1 ON (
		#TABLE_HEADER.company_cd		=	HANYOU_TABLE_1.company_cd
	AND #TABLE_HEADER.sheet_cd			=	HANYOU_TABLE_1.sheet_cd
	AND 1								=	HANYOU_TABLE_1.generic_step
	)
	LEFT OUTER JOIN #HANYO_TABLE AS HANYOU_TABLE_2 ON (
		#TABLE_HEADER.company_cd		=	HANYOU_TABLE_2.company_cd
	AND #TABLE_HEADER.sheet_cd			=	HANYOU_TABLE_2.sheet_cd
	AND 2								=	HANYOU_TABLE_2.generic_step
	)
	LEFT OUTER JOIN #HANYO_TABLE AS HANYOU_TABLE_3 ON (
		#TABLE_HEADER.company_cd		=	HANYOU_TABLE_3.company_cd
	AND #TABLE_HEADER.sheet_cd			=	HANYOU_TABLE_3.sheet_cd
	AND 3								=	HANYOU_TABLE_3.generic_step
	)
	LEFT OUTER JOIN #HANYO_TABLE AS HANYOU_TABLE_4 ON (
		#TABLE_HEADER.company_cd		=	HANYOU_TABLE_4.company_cd
	AND #TABLE_HEADER.sheet_cd			=	HANYOU_TABLE_4.sheet_cd
	AND 4								=	HANYOU_TABLE_4.generic_step
	)
	LEFT OUTER JOIN #HANYO_TABLE AS HANYOU_TABLE_5 ON (
		#TABLE_HEADER.company_cd		=	HANYOU_TABLE_5.company_cd
	AND #TABLE_HEADER.sheet_cd			=	HANYOU_TABLE_5.sheet_cd
	AND 5								=	HANYOU_TABLE_5.generic_step
	)
	LEFT OUTER JOIN #HANYO_TABLE AS HANYOU_TABLE_6 ON (
		#TABLE_HEADER.company_cd		=	HANYOU_TABLE_6.company_cd
	AND #TABLE_HEADER.sheet_cd			=	HANYOU_TABLE_6.sheet_cd
	AND 6								=	HANYOU_TABLE_6.generic_step
	)
	LEFT OUTER JOIN #HANYO_TABLE AS HANYOU_TABLE_7 ON (
		#TABLE_HEADER.company_cd		=	HANYOU_TABLE_7.company_cd
	AND #TABLE_HEADER.sheet_cd			=	HANYOU_TABLE_7.sheet_cd
	AND 7								=	HANYOU_TABLE_7.generic_step
	)
	LEFT OUTER JOIN #HANYO_TABLE AS HANYOU_TABLE_8 ON (
		#TABLE_HEADER.company_cd		=	HANYOU_TABLE_8.company_cd
	AND #TABLE_HEADER.sheet_cd			=	HANYOU_TABLE_8.sheet_cd
	AND 8								=	HANYOU_TABLE_8.generic_step
	)
	--↑↑↑ end add by viettd 2020/05/25
	--↓↓↓ add by viettd 2020/10/09
	LEFT OUTER JOIN #ITEM_TABLE AS ITEM_TABLE_1 ON (
		#TABLE_HEADER.company_cd		=	ITEM_TABLE_1.company_cd
	AND #TABLE_HEADER.sheet_cd			=	ITEM_TABLE_1.sheet_cd
	AND 1								=	ITEM_TABLE_1.item_step
	)
	LEFT OUTER JOIN #ITEM_TABLE AS ITEM_TABLE_2 ON (
		#TABLE_HEADER.company_cd		=	ITEM_TABLE_2.company_cd
	AND #TABLE_HEADER.sheet_cd			=	ITEM_TABLE_2.sheet_cd
	AND 2								=	ITEM_TABLE_2.item_step
	)
	LEFT OUTER JOIN #ITEM_TABLE AS ITEM_TABLE_3 ON (
		#TABLE_HEADER.company_cd		=	ITEM_TABLE_3.company_cd
	AND #TABLE_HEADER.sheet_cd			=	ITEM_TABLE_3.sheet_cd
	AND 3								=	ITEM_TABLE_3.item_step
	)
	LEFT OUTER JOIN #ITEM_TABLE AS ITEM_TABLE_4 ON (
		#TABLE_HEADER.company_cd		=	ITEM_TABLE_4.company_cd
	AND #TABLE_HEADER.sheet_cd			=	ITEM_TABLE_4.sheet_cd
	AND 4								=	ITEM_TABLE_4.item_step
	)
	LEFT OUTER JOIN #ITEM_TABLE AS ITEM_TABLE_5 ON (
		#TABLE_HEADER.company_cd		=	ITEM_TABLE_5.company_cd
	AND #TABLE_HEADER.sheet_cd			=	ITEM_TABLE_5.sheet_cd
	AND 5								=	ITEM_TABLE_5.item_step
	)
	LEFT OUTER JOIN #ITEM_TABLE AS ITEM_TABLE_6 ON (
		#TABLE_HEADER.company_cd		=	ITEM_TABLE_6.company_cd
	AND #TABLE_HEADER.sheet_cd			=	ITEM_TABLE_6.sheet_cd
	AND 6								=	ITEM_TABLE_6.item_step
	)
	--↑↑↑ end add by viettd 2020/10/09
	LEFT OUTER JOIN F0101 ON (
		@P_company_cd					=	F0101.company_cd
	AND @fiscal_year					=	F0101.fiscal_year
	AND #TABLE_DETAIL.employee_cd		=	F0101.employee_cd
	AND #TABLE_DETAIL.sheet_cd			=	F0101.sheet_cd
	AND F0101.del_datetime IS NULL
	)
	-- フッター項目
	LEFT OUTER JOIN F0120 AS F0120_0 ON (
		@P_company_cd					=	F0120_0.company_cd
	AND @fiscal_year					=	F0120_0.fiscal_year
	AND #TABLE_DETAIL.employee_cd		=	F0120_0.employee_cd
	AND #TABLE_DETAIL.sheet_cd			=	F0120_0.sheet_cd
	AND 0								=	F0120_0.evaluation_step
	AND F0120_0.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0120 AS F0120_1 ON (
		@P_company_cd					=	F0120_1.company_cd
	AND @fiscal_year					=	F0120_1.fiscal_year
	AND #TABLE_DETAIL.employee_cd		=	F0120_1.employee_cd
	AND #TABLE_DETAIL.sheet_cd			=	F0120_1.sheet_cd
	AND 1								=	F0120_1.evaluation_step
	AND F0120_1.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0120 AS F0120_2 ON (
		@P_company_cd					=	F0120_2.company_cd
	AND @fiscal_year					=	F0120_2.fiscal_year
	AND #TABLE_DETAIL.employee_cd		=	F0120_2.employee_cd
	AND #TABLE_DETAIL.sheet_cd			=	F0120_2.sheet_cd
	AND 2								=	F0120_2.evaluation_step
	AND F0120_2.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0120 AS F0120_3 ON (
		@P_company_cd					=	F0120_3.company_cd
	AND @fiscal_year					=	F0120_3.fiscal_year
	AND #TABLE_DETAIL.employee_cd		=	F0120_3.employee_cd
	AND #TABLE_DETAIL.sheet_cd			=	F0120_3.sheet_cd
	AND 3								=	F0120_3.evaluation_step
	AND F0120_3.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0120 AS F0120_4 ON (
		@P_company_cd					=	F0120_4.company_cd
	AND @fiscal_year					=	F0120_4.fiscal_year
	AND #TABLE_DETAIL.employee_cd		=	F0120_4.employee_cd
	AND #TABLE_DETAIL.sheet_cd			=	F0120_4.sheet_cd
	AND 4								=	F0120_4.evaluation_step
	AND F0120_4.del_datetime IS NULL
	)
	--評価基準
	LEFT OUTER JOIN #TABLE_評価基準 ON (
		#TABLE_DETAIL.sheet_cd			=	#TABLE_評価基準.sheet_cd
	) 
	-- 評価面談
	LEFT OUTER JOIN #TABLE_評価面談 ON (
		#TABLE_DETAIL.employee_cd		=	#TABLE_評価面談.employee_cd
	AND #TABLE_DETAIL.sheet_cd			=	#TABLE_評価面談.sheet_cd
	)
	WHERE 
		#TABLE_DETAIL.company_cd		=	@P_company_cd
	AND #TABLE_DETAIL.fiscal_year		=	@fiscal_year
	ORDER BY
		--RIGHT('0000000000' + #TABLE_DETAIL.employee_cd, 10)
		CASE ISNUMERIC(#TABLE_DETAIL.employee_cd) 
		   WHEN 1 
		   THEN CAST(#TABLE_DETAIL.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
	,	#TABLE_DETAIL.employee_cd
	,	#TABLE_DETAIL.sheet_cd
	,	#TABLE_DETAIL.item_no
	--[1]	難易度基準
	SELECT  
		TOP 16
		ISNULL(W_M0110.challenge_level,0)				AS	challenge_level
	,	ISNULL(W_M0110.challenge_level_nm,'')			AS	challenge_level_nm
	,	FORMAT(W_M0110.betting_rate,'##0.##')			AS	betting_rate
	FROM W_M0110
	WHERE 
		W_M0110.company_cd		=	@P_company_cd
	AND W_M0110.fiscal_year		=	@fiscal_year
	AND W_M0110.del_datetime IS NULL
END
GO
