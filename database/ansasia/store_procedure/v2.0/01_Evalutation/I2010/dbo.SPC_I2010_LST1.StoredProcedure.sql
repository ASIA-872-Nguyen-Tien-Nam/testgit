DROP PROCEDURE [SPC_I2010_LST1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ M0170
-- EXEC [SPC_I2010_LST1] '2018','6','a300','999';
-- EXEC SPC_I2010_LST1 '2018','6','ans1000','ans900','a900','999';
-- EXEC SPC_I2010_LST1 '2019','5','a726','a726','a726','1007';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	SHOW/HIDE ITEM 
--*  
--*  作成日/create date			:	2018/10/08						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2019/12/10
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgrade ver 1.6
--*   					
--*  更新日/update date			:	2020/03/16
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	add condition to item 汎用コメント
--*   					
--*  更新日/update date			:	2020/04/24
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	fix error when 評価者 = 管理者
--*   					
--*  更新日/update date			:	2020/05/18
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	CHECK PERMISSION OF ROUTER EVALUTATION
--*   					
--*  更新日/update date			:	2020/05/29
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	check condition of item 自己評価コメント
--*   					
--*  更新日/update date			:	2020/10/09
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgradate ver 1.7 & 1on1
--*   					
--*  更新日/update date			:	2021/12/01
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgradate ver 1.8
--*   					
--*  更新日/update date			:	2021/12/01
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgradate ver 1.8
--*   					
--*  更新日/update date			:	2022/03/11
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	進捗コメントの制御を外す
--*   					
--*  更新日/update date			:	2022/08/16 			
--*　更新者/updater				:　	vietdt　  　			
--*　更新内容/update content		:	upgradate ver 1.9
--*   					
--*  更新日/update date			:	2022/12/09 			
--*　更新者/updater				:　	viettd　  　			
--*　更新内容/update content		:	change condition view item 明細評価コメント
--*
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_I2010_LST1]
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
		@status_cd				smallint		=	0
	,	@authority_typ			smallint		=	0
	,	@login_user_typ			smallint		=	1	--	1. 被評価者用 2.評価者用	3.管理者用
	,	@w_提出済状況			tinyint			=	0	--	0.未提出　1.提出済
	,	@w_承認済状況			tinyint			=	0	--	0.未承認　1.承認済
	--
	,	@w_rater_employee_cd_1	nvarchar(10)	=	''
	,	@w_rater_employee_cd_2	nvarchar(10)	=	''
	,	@w_rater_employee_cd_3	nvarchar(10)	=	''
	,	@w_rater_employee_cd_4	nvarchar(10)	=	''
	--
	,	@chk					tinyint			=	0	-- add by viettd 2020/05/18
	,	@w_language				SMALLINT		=	1	--add by vietdt	2022/08/31
	--
	CREATE TABLE #TABLE_RESULT(
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
	,	generic_comment_title_6						nvarchar(20)	-- add by viettd 2019/12/10
	,	generic_comment_title_7						nvarchar(20)	-- add by viettd 2019/12/10
	,	generic_comment_title_8						nvarchar(20)	-- add by viettd 2020/10/09
	,	generic_comment_status1						tinyint
	,	generic_comment_status2						tinyint
	,	generic_comment_status3						tinyint
	,	generic_comment_status4						tinyint
	,	generic_comment_status5						tinyint
	,	generic_comment_status6						tinyint			-- add by viettd 2019/12/10
	,	generic_comment_status7						tinyint			-- add by viettd 2019/12/10
	,	generic_comment_status8						tinyint			-- add by viettd 2020/10/09
	--	評価シート入力
	,	goal_number									smallint
	--
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

	--
	,	item_title_status							tinyint			-- add by viettd 2020/10/09
	,	item_display_status_1						tinyint
	,	item_display_status_2						tinyint
	,	item_display_status_3						tinyint
	,	item_display_status_4						tinyint
	,	item_display_status_5						tinyint
	,	weight_display_status						tinyint			-- ウェイト
	,	weight_display_nm							nvarchar(20)	-- ウェイト名
	,	challenge_level_display_status				tinyint			-- 難易度
	--
	,	detail_self_progress_comment_display_status	tinyint			-- 明細自己進捗評価コメント	-- add by viettd 2021/12/01
	,	detail_progress_comment_display_status		tinyint			-- 明細進捗評価コメント		-- add by viettd 2020/10/09
	,	progress_comment_display_status				tinyint			-- 自己進捗コメント
	,	progress_comment_display_status1			tinyint			-- 一次評価者進捗コメント
	,	progress_comment_display_status2			tinyint			-- 二次評価者進捗コメント		add by viettd 2021/12/01
	,	progress_comment_display_status3			tinyint			-- 三次評価者進捗コメント		add by viettd 2021/12/01
	,	progress_comment_display_status4			tinyint			-- 四次評価者進捗コメント		add by viettd 2021/12/01
	--
	,	detail_comment_display_status1				tinyint			-- 評価コメント1		-- add by viettd 2019/12/10
	,	detail_comment_display_status2				tinyint			-- 評価コメント2		-- add by viettd 2019/12/10
	,	detail_comment_display_status3				tinyint			-- 評価コメント3		-- add by viettd 2019/12/10
	,	detail_comment_display_status4				tinyint			-- 評価コメント4		-- add by viettd 2019/12/10
	--
	,	detail_myself_comment_display_status		tinyint			-- 自己評価コメント
	,	evaluation_display_status0					tinyint			-- 自己評価
	,	evaluation_display_status1					tinyint			-- 一次評価
	,	evaluation_display_status2					tinyint			-- 二次評価
	,	evaluation_display_status3					tinyint			-- 三次評価
	,	evaluation_display_status4					tinyint			-- 四次評価
	,	total_score_display_status					tinyint			-- 合計点
	--
	,	evaluation_comment_status0					tinyint			-- 自己評価コメント
	,	evaluation_comment_status1					tinyint			-- 一次評価コメント
	,	evaluation_comment_status2					tinyint			-- 二次評価コメント
	,	evaluation_comment_status3					tinyint			-- 三次評価コメント
	,	evaluation_comment_status4					tinyint			-- 四次評価コメント
	--
	,	point_criteria_display_status				tinyint			-- 評価基準
	,	challengelevel_criteria_display_status		tinyint			-- 難易度基準
	,	self_assessment_comment_display_status		tinyint			-- 自己評価コメント
	,	evaluation_comment_display_status			tinyint			-- 評価者コメント
	--
	,	login_user_typ								smallint-- ログイン者
	)
	--add by vietdt	2022/08/31
	SELECT 
		@w_language			=	ISNULL(S0010.language,1)	
	FROM S0010
	WHERE 
		S0010.company_cd	= @P_company_cd 
	AND S0010.user_id		= @P_cre_user
	AND S0010.del_datetime IS NULL
	-- GET @status_cd
	SELECT 
		@status_cd					=	ISNULL(F0100.status_cd,0) 
	,	@w_rater_employee_cd_1		=	ISNULL(F0100.rater_employee_cd_1,'')
	,	@w_rater_employee_cd_2		=	ISNULL(F0100.rater_employee_cd_2,'')
	,	@w_rater_employee_cd_3		=	ISNULL(F0100.rater_employee_cd_3,'')
	,	@w_rater_employee_cd_4		=	ISNULL(F0100.rater_employee_cd_4,'')
	FROM F0100 
	WHERE 
		F0100.company_cd	= @P_company_cd 
	AND F0100.fiscal_year	= @P_fiscal_year 
	AND F0100.employee_cd	= @P_employee_cd 
	AND F0100.sheet_cd		= @P_sheet_cd 
	AND F0100.del_datetime IS NULL															
	-- GET @authority_typ
	SET @authority_typ = (SELECT ISNULL(S0010.authority_typ,0) FROM S0010 WHERE S0010.company_cd = @P_company_cd AND S0010.user_id = @P_cre_user)
	--↓↓↓ add by viettd 2022/08/16
	IF @authority_typ = 6
	BEGIN
		SET @authority_typ = 2 -- 評価者
	END
	--↑↑↑ end add by viettd 2022/08/16
	-- GET 評価者 add by viettd 2020/04/24
	SET @login_user_typ = [dbo].FNC_GET_STEP_EVALUATION
	(
		'I2010'
	,	1				-- 目標シート
	,	@status_cd
	,	@P_employee_cd
	,	@P_login_employee_cd
	,	@authority_typ
	,	@w_rater_employee_cd_1
	,	@w_rater_employee_cd_2
	,	@w_rater_employee_cd_3
	,	@w_rater_employee_cd_4
	)
	-- 提出済
	IF EXISTS (SELECT 1 FROM F0110 WHERE
									F0110.company_cd			=	@P_company_cd
								AND F0110.fiscal_year			=	@P_fiscal_year
								AND F0110.employee_cd			=	@P_employee_cd
								AND F0110.sheet_cd				=	@P_sheet_cd
								AND F0110.submit_datetime IS NOT NULL
								AND F0110.del_datetime IS NULL)
	BEGIN
		SET @w_提出済状況 = 1 -- 1.提出済
	END
	-- 承認済状況
	IF EXISTS (SELECT 1 FROM F0110 WHERE
									F0110.company_cd			=	@P_company_cd
								AND F0110.fiscal_year			=	@P_fiscal_year
								AND F0110.employee_cd			=	@P_employee_cd
								AND F0110.sheet_cd				=	@P_sheet_cd
								AND F0110.approval_datetime IS NOT NULL
								AND F0110.del_datetime IS NULL)
	BEGIN
		SET @w_承認済状況 = 1 -- 1.承認済
	END
	-- INSERT DATA INTO TEMP TABLE
	INSERT INTO #TABLE_RESULT
	SELECT 
		ISNULL(W_M0200.company_cd,0)						AS	company_cd
	,	ISNULL(W_M0200.sheet_cd,0)							AS	sheet_cd
	,	ISNULL(W_M0200.details_feedback_typ,0)				AS	details_feedback_typ
	,	ISNULL(W_M0200.comments_feedback_typ,0)				AS	comments_feedback_typ
	--	汎用
	,	ISNULL(W_M0200.generic_comment_title_1,'')			AS	generic_comment_title_1	
	,	ISNULL(W_M0200.generic_comment_title_2,'')			AS	generic_comment_title_2	
	,	ISNULL(W_M0200.generic_comment_title_3,'')			AS	generic_comment_title_3	
	,	ISNULL(W_M0200.generic_comment_title_4,'')			AS	generic_comment_title_4	
	,	ISNULL(W_M0200.generic_comment_title_5,'')			AS	generic_comment_title_5	
	,	ISNULL(W_M0200.generic_comment_title_6,'')			AS	generic_comment_title_6	
	,	ISNULL(W_M0200.generic_comment_title_7,'')			AS	generic_comment_title_7	
	,	ISNULL(W_M0200.generic_comment_title_8,'')			AS	generic_comment_title_8	
	,	2													AS	generic_comment_status1					-- 汎用コメント１
	,	2													AS	generic_comment_status2					-- 汎用コメント２
	,	2													AS	generic_comment_status3					-- 汎用コメント３
	,	2													AS	generic_comment_status4					-- 汎用コメント４
	,	2													AS	generic_comment_status5					-- 汎用コメント５
	,	2													AS	generic_comment_status6					-- 汎用コメント６
	,	2													AS	generic_comment_status7					-- 汎用コメント７
	,	2													AS	generic_comment_status8					-- 汎用コメント８
	--	評価シート入力
	,	ISNULL(W_M0200.goal_number,0)						AS	goal_number								-- 目標設定数
	,	ISNULL(W_M0200.item_title_title,'')					AS	item_title_title
	,	ISNULL(W_M0200.item_title_1,'')						AS	item_title_1
	,	ISNULL(W_M0200.item_title_2,'')						AS	item_title_2
	,	ISNULL(W_M0200.item_title_3,'')						AS	item_title_3
	,	ISNULL(W_M0200.item_title_4,'')						AS	item_title_4
	,	ISNULL(W_M0200.item_title_5,'')						AS	item_title_5
	--
	,	ISNULL(W_M0200.detail_self_progress_comment_title,'')	AS	detail_self_progress_comment_title	
	,	ISNULL(W_M0200.detail_progress_comment_title,'')		AS	detail_progress_comment_title		
	,	ISNULL(W_M0200.self_progress_comment_title,'')			AS	self_progress_comment_title			
	,	ISNULL(W_M0200.progress_comment_title,'')				AS	progress_comment_title				
	--
	,	2													AS	item_title_status
	,	2													AS	item_display_status_1					-- 目標タイトル１
	,	2													AS	item_display_status_2					-- 目標タイトル２
	,	2													AS	item_display_status_3					-- 目標タイトル３
	,	2													AS	item_display_status_4					-- 目標タイトル４
	,	2													AS	item_display_status_5					-- 目標タイトル５
	,	2													AS	weight_display_status					--ウェイト

	,	CASE 
			WHEN ISNULL(W_M0200.point_calculation_typ1,0) = 1 -- 1.ウェイト
			THEN IIF(@w_language = 2,'Weight','ｳｪｲﾄ')
			WHEN ISNULL(W_M0200.point_calculation_typ1,0) = 2 -- 2.係数
			THEN IIF(@w_language = 2,'Coefficient','係数')
			ELSE ''
		END													AS	weight_display_nm						-- ウェイト名
	,	2													AS	challenge_level_display_status			-- 難易度
	,	2													AS	detail_self_progress_comment_display_status	-- 明細自己進捗評価コメント -- add by viettd 2021/12/01
	,	2													AS	detail_progress_comment_display_status	-- 明細進捗評価コメント -- add by viettd 2020/10/09
	--
	,	2													AS	progress_comment_display_status			-- 自己進捗コメント
	,	2													AS	progress_comment_display_status1		--一次評価者進捗コメント
	,	2													AS	progress_comment_display_status2		--二次評価者進捗コメント
	,	2													AS	progress_comment_display_status3		--三次評価者進捗コメント
	,	2													AS	progress_comment_display_status4		--四次評価者進捗コメント
	--
	,	2													AS	detail_comment_display_status1			-- 評価コメント1		-- add by viettd 2019/12/10
	,	2													AS	detail_comment_display_status2			-- 評価コメント2		-- add by viettd 2019/12/10
	,	2													AS	detail_comment_display_status3			-- 評価コメント3		-- add by viettd 2019/12/10
	,	2													AS	detail_comment_display_status4			-- 評価コメント4		-- add by viettd 2019/12/10
	-- 
	,	2													AS	detail_myself_comment_display_status	-- 自己評価コメント
	,	2													AS	evaluation_display_status0				-- 自己評価
	,	2													AS	evaluation_display_status1				-- 一次評価
	,	2													AS	evaluation_display_status2				-- 二次評価
	,	2													AS	evaluation_display_status3				-- 三次評価
	,	2													AS	evaluation_display_status4				-- 四次評価
	,	2													AS	total_score_display_status				-- 合計点
	,	2													AS	evaluation_comment_status0				-- 自己評価コメント
	,	2													AS	evaluation_comment_status1				-- 一次評価コメント
	,	2													AS	evaluation_comment_status2				-- 二次評価コメント
	,	2													AS	evaluation_comment_status3				-- 三次評価コメント
	,	2													AS	evaluation_comment_status4				-- 四次評価コメント
	,	CASE
			WHEN point_criteria_display_typ = 0
			THEN 0
			ELSE 2											-- DISABLED
		END													AS	point_criteria_display_status			--	評価基準
	,	CASE
			WHEN challengelevel_criteria_display_typ = 0
			THEN 0
			ELSE 2											-- DISABLED
		END													AS	challengelevel_criteria_display_status	--	難易度基準
	,	2													AS	self_assessment_comment_display_status	--	自己評価コメント
	,	2													AS	evaluation_comment_display_status		--	評価者コメント
	,	@login_user_typ										AS	login_user_typ							--	ログイン者
	FROM W_M0200
	WHERE
		W_M0200.company_cd			=	@P_company_cd
	AND W_M0200.sheet_cd			=	@P_sheet_cd
	AND W_M0200.fiscal_year			=	@P_fiscal_year
	AND W_M0200.del_datetime IS NULL
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- 0: HIDE  1: ENABLED  2:DISBALE
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- ↓↓↓ add by viettd 2020/05/18
	EXEC [dbo].SPC_PERMISSION_CHK1 @P_fiscal_year,@P_employee_cd,@P_sheet_cd,@P_cre_user,@P_company_cd,1,@chk OUT
	--	0.参照不可　1.参照可能	2.更新可能
	IF @chk IN (0,1)
	BEGIN
		GOTO COMPLETED
	END
	-- ↑↑↑ end add by viettd 2020/05/18
	-- STATUS = 0 : 初期状態
	IF @status_cd = 0
	BEGIN
		UPDATE #TABLE_RESULT SET 
			generic_comment_status1							=	CASE WHEN @login_user_typ IN(1,3) THEN 2 ELSE 0 END		-- 汎用コメント１			■ 目標項目
		,	generic_comment_status2							=	CASE WHEN @login_user_typ IN(1,3) THEN 2 ELSE 0 END		-- 汎用コメント２			■ 目標項目
		,	generic_comment_status8							=	CASE WHEN @login_user_typ IN(1,3) THEN 2 ELSE 0 END		-- 汎用コメント８			■ 目標項目
		,	generic_comment_status3							=	CASE WHEN @login_user_typ IN(1,3) THEN 2 ELSE 0 END		-- 汎用コメント３			■ 目標項目
		,	generic_comment_status4							=	CASE WHEN @login_user_typ IN(1,3) THEN 2 ELSE 0 END		-- 汎用コメント４			■ 目標項目
		,	generic_comment_status5							=	CASE WHEN @login_user_typ IN(1,3) THEN 1 ELSE 0 END		-- 汎用コメント５			■ 目標項目
		,	generic_comment_status6							=	CASE WHEN @login_user_typ IN(1,3) THEN 1 ELSE 0 END		-- 汎用コメント６			■ 目標項目
		,	generic_comment_status7							=	CASE WHEN @login_user_typ IN(1,3) THEN 1 ELSE 0 END		-- 汎用コメント７			■ 目標項目
		--
		,	item_title_status								=	CASE WHEN @login_user_typ IN(1,3) THEN 1 ELSE 0 END		-- 目標表題	
		,	item_display_status_1							=	CASE WHEN @login_user_typ IN(1,3) THEN 1 ELSE 0 END		-- 目標タイトル１			■ 目標項目
		,	item_display_status_2							=	CASE WHEN @login_user_typ IN(1,3) THEN 1 ELSE 0 END		-- 目標タイトル２			■ 目標項目
		,	item_display_status_3							=	CASE WHEN @login_user_typ IN(1,3) THEN 1 ELSE 0 END		-- 目標タイトル３			■ 目標項目
		,	item_display_status_4							=	CASE WHEN @login_user_typ IN(1,3) THEN 1 ELSE 0 END		-- 目標タイトル４			■ 目標項目
		,	item_display_status_5							=	CASE WHEN @login_user_typ IN(1,3) THEN 1 ELSE 0 END		-- 目標タイトル５			■ 目標項目
		,	weight_display_status							=	CASE WHEN @login_user_typ IN(1,3) THEN 1 ELSE 0 END		--ウェイト				■ 目標項目
		,	challenge_level_display_status					=	CASE WHEN @login_user_typ IN(1,3) THEN 1 ELSE 0 END		-- 難易度				■ 目標項目
		--
		,	detail_self_progress_comment_display_status		=	0														-- 明細自己進捗評価コメント 	■ 進捗コメント
		,	detail_progress_comment_display_status			=	0														-- 明細進捗評価コメント 		■ 進捗コメント
		,	progress_comment_display_status					=	0														-- 自己進捗コメント			■ 進捗コメント
		,	progress_comment_display_status1				=	0														-- 一次評価者進捗コメント		■ 進捗コメント
		,	progress_comment_display_status2				=	0														-- 二次評価者進捗コメント		■ 進捗コメント
		,	progress_comment_display_status3				=	0														-- 三次評価者進捗コメント		■ 進捗コメント
		,	progress_comment_display_status4				=	0														-- 四次評価者進捗コメント		■ 進捗コメント
		--
		,	detail_comment_display_status1					=	0														-- 評価コメント1			■ 評価項目
		,	detail_comment_display_status2					=	0														-- 評価コメント2			■ 評価項目
		,	detail_comment_display_status3					=	0														-- 評価コメント3			■ 評価項目
		,	detail_comment_display_status4					=	0														-- 評価コメント4			■ 評価項目
		--
		,	detail_myself_comment_display_status			=	0														-- 自己評価コメント		■ 評価項目
		,	evaluation_display_status0						=	0														-- 自己評価				■ 評価項目
		,	evaluation_display_status1						=	0														-- 一次評価				■ 評価項目
		,	evaluation_display_status2						=	0														-- 二次評価				■ 評価項目
		,	evaluation_display_status3						=	0														-- 三次評価				■ 評価項目
		,	evaluation_display_status4						=	0														-- 四次評価				■ 評価項目
		,	total_score_display_status						=	0														-- 合計点				■ 評価項目
		,	evaluation_comment_status0						=	0														-- 自己評価コメント		■ 評価項目
		,	evaluation_comment_status1						=	0														-- 一次評価コメント		■ 評価項目
		,	evaluation_comment_status2						=	0														-- 二次評価コメント		■ 評価項目
		,	evaluation_comment_status3						=	0														-- 三次評価コメント		■ 評価項目
		,	evaluation_comment_status4						=	0														-- 四次評価コメント		■ 評価項目
	END
	-- STATUS = １：目標提出
	IF @status_cd = 1
	BEGIN
		UPDATE #TABLE_RESULT SET 
			generic_comment_status1			=	CASE 
													WHEN @login_user_typ IN(1,21,3) 
													THEN 2
													ELSE 0 
												END													-- 汎用コメント１			■ 目標項目
		,	generic_comment_status2			=	CASE 
													WHEN @login_user_typ IN(1,21,3) 
													THEN 2
													ELSE 0 
												END													-- 汎用コメント２			■ 目標項目
		,	generic_comment_status8			=	CASE 
													WHEN @login_user_typ IN(1,21,3) 
													THEN 2
													ELSE 0 
												END													-- 汎用コメント８			■ 目標項目
		,	generic_comment_status3			=	CASE 
													WHEN @login_user_typ IN(1,21,3) 
													THEN 2
													ELSE 0 
												END													-- 汎用コメント３			■ 目標項目
		,	generic_comment_status4			=	CASE 
													WHEN @login_user_typ IN(1,21,3) 
													THEN 2
													ELSE 0 
												END													-- 汎用コメント４			■ 目標項目
		,	generic_comment_status5			=	CASE 
													WHEN @login_user_typ IN(1,21,3) 
													THEN 2
													ELSE 0 
												END													-- 汎用コメント５			■ 目標項目
		,	generic_comment_status6			=	CASE 
													WHEN @login_user_typ IN(1,21,3) 
													THEN 2
													ELSE 0 
												END													-- 汎用コメント６			■ 目標項目
		,	generic_comment_status7			=	CASE 
													WHEN @login_user_typ IN(1,21,3) 
													THEN 2
													ELSE 0 
												END													-- 汎用コメント７			■ 目標項目
		,	item_title_status				=	CASE 
													WHEN @login_user_typ IN(1,21,3) 
													THEN 2
													ELSE 0 
												END													-- 目標表題				■ 目標項目
		,	item_display_status_1			=	CASE 
													WHEN @login_user_typ IN(1,21,3) 
													THEN 2
													ELSE 0 
												END													-- 目標タイトル１			■ 目標項目		
		,	item_display_status_2			=	CASE 
													WHEN @login_user_typ IN(1,21,3) 
													THEN 2
													ELSE 0 
												END													-- 目標タイトル２			■ 目標項目
		,	item_display_status_3			=	CASE 
													WHEN @login_user_typ IN(1,21,3) 
													THEN 2
													ELSE 0 
												END													-- 目標タイトル３			■ 目標項目
		,	item_display_status_4			=	CASE 
													WHEN @login_user_typ IN(1,21,3) 
													THEN 2
													ELSE 0 
												END													-- 目標タイトル４			■ 目標項目
		,	item_display_status_5			=	CASE 
													WHEN @login_user_typ IN(1,21,3) 
													THEN 2
													ELSE 0 
												END													-- 目標タイトル５			■ 目標項目
		,	weight_display_status			=	CASE 
													WHEN @login_user_typ IN(1,21,3) 
													THEN 2
													ELSE 0 
												END													--ウェイト				■ 目標項目
		,	challenge_level_display_status	=	CASE 
													WHEN @login_user_typ IN(1,21,3) 
													THEN 2
													ELSE 0 
												END															-- 難易度					■ 目標項目
		--
		,	detail_self_progress_comment_display_status		=	0											-- 明細自己進捗評価コメント 	■ 進捗コメント
		,	detail_progress_comment_display_status			=	0											-- 明細進捗評価コメント 		■ 進捗コメント
		,	progress_comment_display_status					=	0											-- 自己進捗コメント			■ 進捗コメント
		,	progress_comment_display_status1				=	0											-- 一次評価者進捗コメント		■ 進捗コメント
		,	progress_comment_display_status2				=	0											-- 二次評価者進捗コメント		■ 進捗コメント
		,	progress_comment_display_status3				=	0											-- 三次評価者進捗コメント		■ 進捗コメント
		,	progress_comment_display_status4				=	0											-- 四次評価者進捗コメント		■ 進捗コメント
		--
		,	detail_comment_display_status1					=	0											-- 評価コメント1				■ 評価項目
		,	detail_comment_display_status2					=	0											-- 評価コメント2				■ 評価項目	
		,	detail_comment_display_status3					=	0											-- 評価コメント3				■ 評価項目	
		,	detail_comment_display_status4					=	0											-- 評価コメント4				■ 評価項目	
		
		,	detail_myself_comment_display_status			=	0											-- 自己評価コメント			■ 評価項目
		,	evaluation_display_status0						=	0											-- 自己評価					■ 評価項目
		,	evaluation_display_status1						=	0											-- 一次評価					■ 評価項目
		,	evaluation_display_status2						=	0											-- 二次評価					■ 評価項目
		,	evaluation_display_status3						=	0											-- 三次評価					■ 評価項目
		,	evaluation_display_status4						=	0											-- 四次評価					■ 評価項目
		,	total_score_display_status						=	0											-- 合計点					■ 評価項目
		,	evaluation_comment_status0						=	0											-- 自己評価コメント			■ 評価項目
		,	evaluation_comment_status1						=	0											-- 一次評価コメント			■ 評価項目
		,	evaluation_comment_status2						=	0											-- 二次評価コメント			■ 評価項目
		,	evaluation_comment_status3						=	0											-- 三次評価コメント			■ 評価項目
		,	evaluation_comment_status4						=	0											-- 四次評価コメント			■ 評価項目
	END
	-- STATUS = ２：期首面談
	IF @status_cd = 2
	BEGIN
		UPDATE #TABLE_RESULT SET 
			generic_comment_status1					=	2													-- 汎用コメント１			■ 目標項目
		,	generic_comment_status2					=	2													-- 汎用コメント２			■ 目標項目
		,	generic_comment_status8					=	2													-- 汎用コメント８			■ 目標項目
		--  edited by viettd 2020/03/16
		,	generic_comment_status3					=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1
															ELSE 2 
														END													-- 汎用コメント３			■ 目標項目
		,	generic_comment_status4					=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1
															ELSE 2 
														END													-- 汎用コメント４			■ 目標項目
		-- end  edited by viettd 2020/03/16
		,	generic_comment_status5					=	2													-- 汎用コメント５			■ 目標項目
		,	generic_comment_status6					=	2													-- 汎用コメント６			■ 目標項目
		,	generic_comment_status7					=	2													-- 汎用コメント７			■ 目標項目
		,	item_title_status						=	2													-- 目標表題				■ 目標項目
		,	item_display_status_1					=	2													-- 目標タイトル１			■ 目標項目
		,	item_display_status_2					=	2													-- 目標タイトル２			■ 目標項目
		,	item_display_status_3					=	2													-- 目標タイトル３			■ 目標項目
		,	item_display_status_4					=	2													-- 目標タイトル４			■ 目標項目
		,	item_display_status_5					=	2													-- 目標タイトル５			■ 目標項目
		,	weight_display_status					=	2													-- ウェイト				■ 目標項目
		,	challenge_level_display_status			=	2													-- 難易度				■ 目標項目
		--
		,	detail_self_progress_comment_display_status		=	0													-- 明細自己進捗評価コメント 	■ 進捗コメント
		,	detail_progress_comment_display_status			=	0													-- 明細進捗評価コメント 		■ 進捗コメント
		,	progress_comment_display_status					=	0													-- 自己進捗コメント			■ 進捗コメント
		,	progress_comment_display_status1				=	0													-- 一次評価者進捗コメント		■ 進捗コメント
		,	progress_comment_display_status2				=	0													-- 二次評価者進捗コメント		■ 進捗コメント
		,	progress_comment_display_status3				=	0													-- 三次評価者進捗コメント		■ 進捗コメント
		,	progress_comment_display_status4				=	0													-- 四次評価者進捗コメント		■ 進捗コメント
		--
		,	detail_comment_display_status1					=	0													-- 評価コメント1				■ 評価項目	
		,	detail_comment_display_status2					=	0													-- 評価コメント2				■ 評価項目	
		,	detail_comment_display_status3					=	0													-- 評価コメント3				■ 評価項目	
		,	detail_comment_display_status4					=	0													-- 評価コメント4				■ 評価項目	
		--
		,	detail_myself_comment_display_status			=	0													-- 自己評価コメント			■ 評価項目
		,	evaluation_display_status0						=	0													-- 自己評価					■ 評価項目
		,	evaluation_display_status1						=	0													-- 一次評価					■ 評価項目
		,	evaluation_display_status2						=	0													-- 二次評価					■ 評価項目
		,	evaluation_display_status3						=	0													-- 三次評価					■ 評価項目
		,	evaluation_display_status4						=	0													-- 四次評価					■ 評価項目
		,	total_score_display_status						=	0													-- 合計点					■ 評価項目
		,	evaluation_comment_status0						=	0													-- 自己評価コメント			■ 評価項目
		,	evaluation_comment_status1						=	0													-- 一次評価コメント			■ 評価項目
		,	evaluation_comment_status2						=	0													-- 二次評価コメント			■ 評価項目
		,	evaluation_comment_status3						=	0													-- 三次評価コメント			■ 評価項目
		,	evaluation_comment_status4						=	0													-- 四次評価コメント			■ 評価項目
	END
	-- STATUS = ３：目標承認済。自己評価中。
	IF @status_cd = 3
	BEGIN
		UPDATE #TABLE_RESULT SET 
			generic_comment_status1					=	2													-- 汎用コメント１			■ 目標項目
		,	generic_comment_status2					=	2													-- 汎用コメント２			■ 目標項目
		,	generic_comment_status8					=	2													-- 汎用コメント８			■ 目標項目
		,	generic_comment_status3					=	2													-- 汎用コメント３			■ 目標項目
		,	generic_comment_status4					=	2													-- 汎用コメント４			■ 目標項目
		,	generic_comment_status5					=	CASE 
															WHEN @login_user_typ IN(1,3) 
															THEN 1
															ELSE 2 
														END													-- 汎用コメント５			■ 目標項目
		,	generic_comment_status6					=	CASE 
															WHEN @login_user_typ IN(1,3) 
															THEN 1
															ELSE 2 
														END													-- 汎用コメント６			■ 目標項目
		,	generic_comment_status7					=	CASE 
															WHEN @login_user_typ IN(1,3) 
															THEN 1
															ELSE 2 
														END													-- 汎用コメント７			■ 目標項目	
		
		-- end eddited by viettd 2020/03/16
		,	item_title_status						=	2													-- 目標表題				■ 目標項目
		,	item_display_status_1					=	2													-- 目標タイトル１			■ 目標項目
		,	item_display_status_2					=	2													-- 目標タイトル２			■ 目標項目
		,	item_display_status_3					=	2													-- 目標タイトル３			■ 目標項目
		,	item_display_status_4					=	2													-- 目標タイトル４			■ 目標項目
		,	item_display_status_5					=	2													-- 目標タイトル５			■ 目標項目
		,	weight_display_status					=	2													--ウェイト				■ 目標項目
		,	challenge_level_display_status			=	2													-- 難易度				■ 目標項目
		,	detail_self_progress_comment_display_status	=	CASE 
															WHEN @login_user_typ IN(1,3) 
															THEN 1
															ELSE 2 
															--WHEN @login_user_typ = 21
															--THEN 2
															--ELSE 0 
														END													-- 明細自己進捗評価コメント	■ 進捗コメント
		,	detail_progress_comment_display_status	=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1
															ELSE 2 
															--WHEN @login_user_typ = 1
															--THEN 2
															--ELSE 0 
														END													-- 明細進捗評価コメント	■ 進捗コメント
		,	progress_comment_display_status			=	CASE 
															WHEN @login_user_typ IN(1,3) 
															THEN 1
															ELSE 2
															--WHEN @login_user_typ = 21
															--THEN 2
															--ELSE 0 
														END													-- 自己進捗コメント		■ 進捗コメント
		,	progress_comment_display_status1		=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1
															ELSE 2 
															--WHEN @login_user_typ = 1 
															--THEN 2
															--ELSE 0 
														END													-- 一次評価者進捗コメント	■ 進捗コメント
		,	progress_comment_display_status2		=	CASE 
															WHEN @login_user_typ IN(22,3) 
															THEN 1
															WHEN @P_login_employee_cd = @w_rater_employee_cd_2	--  二次評価者
															THEN 1
															ELSE 2 
															--WHEN @login_user_typ IN(1,21) 
															--THEN 2 
															--ELSE 0 
														END													-- 二次評価者進捗コメント	■ 進捗コメント
		,	progress_comment_display_status3		=	CASE 
															WHEN @login_user_typ IN(23,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_3	--  三次評価者
															THEN 1
															ELSE 2 
															--WHEN @login_user_typ IN(1,21) 
															--THEN 2
															--ELSE 0 
														END													-- 三次評価者進捗コメント	■ 進捗コメント
		,	progress_comment_display_status4		=	CASE 
															WHEN @login_user_typ IN(24,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_4	--  四次評価者
															THEN 1 
															ELSE 2
															--WHEN @login_user_typ IN(1,21) 
															--THEN 2 
															--ELSE 0 
														END													-- 四次評価者進捗コメント	■ 進捗コメント	
		,	evaluation_display_status0				=	CASE WHEN @login_user_typ IN(1,3) THEN 1 ELSE 0 END	-- 自己評価				■ 評価項目
		,	detail_myself_comment_display_status	=	CASE WHEN @login_user_typ IN(1,3) THEN 1 ELSE 0 END	-- 自己評価コメント		■ 評価項目
		,	detail_comment_display_status1			=	0													-- 評価コメント1			■ 評価項目
		,	detail_comment_display_status2			=	0													-- 評価コメント2			■ 評価項目
		,	detail_comment_display_status3			=	0													-- 評価コメント3			■ 評価項目
		,	detail_comment_display_status4			=	0													-- 評価コメント4			■ 評価項目
		--
		,	evaluation_display_status1				=	0													-- 一次評価				■ 評価項目
		,	evaluation_display_status2				=	0													-- 二次評価				■ 評価項目
		,	evaluation_display_status3				=	0													-- 三次評価				■ 評価項目
		,	evaluation_display_status4				=	0													-- 四次評価				■ 評価項目
		,	total_score_display_status				=	0													-- 合計点				■ 評価項目
		,	evaluation_comment_status0				=	CASE WHEN @login_user_typ IN(1,3) THEN 1 ELSE 0 END	-- 自己評価コメント		■ 評価項目
		,	evaluation_comment_status1				=	0													-- 一次評価コメント		■ 評価項目
		,	evaluation_comment_status2				=	0													-- 二次評価コメント		■ 評価項目
		,	evaluation_comment_status3				=	0													-- 三次評価コメント		■ 評価項目
		,	evaluation_comment_status4				=	0													-- 四次評価コメント		■ 評価項目
	END
	-- STATUS = ４：自己評価済。一次評価中。
	IF @status_cd = 4
	BEGIN
		UPDATE #TABLE_RESULT SET 
			generic_comment_status1					=	2													-- 汎用コメント１			■ 目標項目
		,	generic_comment_status2					=	2													-- 汎用コメント２			■ 目標項目
		,	generic_comment_status8					=	2													-- 汎用コメント８			■ 目標項目
		,	generic_comment_status3					=	2													-- 汎用コメント３			■ 目標項目
		,	generic_comment_status4					=	2													-- 汎用コメント４			■ 目標項目
		,	generic_comment_status5					=	2													-- 汎用コメント５			■ 目標項目
		,	generic_comment_status6					=	2													-- 汎用コメント6			■ 目標項目
		,	generic_comment_status7					=	2													-- 汎用コメント7			■ 目標項目
		,	item_title_status						=	2													-- 目標表題				■ 目標項目
		,	item_display_status_1					=	2													-- 目標タイトル１			■ 目標項目
		,	item_display_status_2					=	2													-- 目標タイトル２			■ 目標項目
		,	item_display_status_3					=	2													-- 目標タイトル３			■ 目標項目
		,	item_display_status_4					=	2													-- 目標タイトル４			■ 目標項目
		,	item_display_status_5					=	2													-- 目標タイトル５			■ 目標項目
		,	weight_display_status					=	2													--ウェイト				■ 目標項目
		,	challenge_level_display_status			=	2													-- 難易度				■ 目標項目
		,	detail_self_progress_comment_display_status	=	CASE 
															WHEN @login_user_typ IN(1,3) 
															THEN 1 
															ELSE 2
															--WHEN @login_user_typ = 21
															--THEN 2
															--ELSE 0 
														END													-- 明細自己進捗評価コメント		■ 進捗コメント
		,	detail_progress_comment_display_status	=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1
															ELSE 2 
															--WHEN @login_user_typ = 1
															--THEN 2
															--ELSE 0 
														END													-- 明細進捗評価コメント		■ 進捗コメント
		,	progress_comment_display_status			=	CASE 
															WHEN @login_user_typ IN(1,3) 
															THEN 1
															ELSE 2 
															--WHEN @login_user_typ = 21
															--THEN 2
															--ELSE 0 
														END													-- 自己進捗コメント		■ 進捗コメント
		,	progress_comment_display_status1		=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1
															ELSE 2 
															--WHEN @login_user_typ = 1
															--THEN 2
															--ELSE 0 
														END													-- 一次評価者進捗コメント	■ 進捗コメント
		,	progress_comment_display_status2		=	CASE 
															WHEN @login_user_typ IN(22,3) 
															THEN 1
															WHEN @P_login_employee_cd = @w_rater_employee_cd_2	--  二次評価者
															THEN 1
															ELSE 2 
															--WHEN @login_user_typ IN(1,21) 
															--THEN 2 
															--ELSE 0 
														END													-- 二次評価者進捗コメント	■ 進捗コメント
		,	progress_comment_display_status3		=	CASE 
															WHEN @login_user_typ IN(23,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_3	--  三次評価者
															THEN 1
															ELSE 2 
															--WHEN @login_user_typ IN(1,21) 
															--THEN 2 
															--ELSE 0 
														END													-- 三次評価者進捗コメント	■ 進捗コメント
		,	progress_comment_display_status4		=	CASE 
															WHEN @login_user_typ IN(24,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_4	--  四次評価者
															THEN 1
															ELSE 2 
															--WHEN @login_user_typ IN(1,21) 
															--THEN 2 
															--ELSE 0 
														END													-- 四次評価者進捗コメント	■ 進捗コメント
		,	evaluation_display_status0				=	CASE 
															WHEN @login_user_typ = 3
															THEN 1
															WHEN @login_user_typ IN(1,21)
															THEN 2
															ELSE 0 
														END													-- 自己評価				■ 評価項目
		,	detail_myself_comment_display_status	=	CASE 
															WHEN @login_user_typ = 3
															THEN 1
															WHEN @login_user_typ IN(1,21)
															THEN 2
															ELSE 0 
														END													-- 自己評価コメント		■ 評価項目
		,	detail_comment_display_status1			=	CASE 
															WHEN @login_user_typ IN(3,21)
															THEN 1
															ELSE 0 
														END													-- 評価コメント1			■ 評価項目
		,	detail_comment_display_status2			=	0													-- 評価コメント2			■ 評価項目
		,	detail_comment_display_status3			=	0													-- 評価コメント3			■ 評価項目
		,	detail_comment_display_status4			=	0													-- 評価コメント4			■ 評価項目	
		,	evaluation_display_status1				=	CASE 
															WHEN @login_user_typ IN(3,21)
															THEN 1 
															ELSE 0 
														END													-- 一次評価				■ 評価項目
		,	evaluation_display_status2				=	0													-- 二次評価				■ 評価項目
		,	evaluation_display_status3				=	0													-- 三次評価				■ 評価項目
		,	evaluation_display_status4				=	0													-- 四次評価				■ 評価項目
		,	total_score_display_status				=	CASE 
															WHEN @login_user_typ IN(1,21,3) 
															THEN 2 
															ELSE 0 
														END													-- 合計点				■ 評価項目
		,	evaluation_comment_status0				=	CASE 
															WHEN @login_user_typ = 3
															THEN 1
															WHEN @login_user_typ IN(1,21)
															THEN 2
															ELSE 0 
														END													-- 自己評価コメント		■ 評価項目
		,	evaluation_comment_status1				=	CASE 
															WHEN @login_user_typ IN(3,21)
															THEN 1 
															ELSE 0 
														END													-- 一次評価コメント		■ 評価項目
		,	evaluation_comment_status2				=	0													-- 二次評価コメント		■ 評価項目
		,	evaluation_comment_status3				=	0													-- 三次評価コメント		■ 評価項目
		,	evaluation_comment_status4				=	0													-- 四次評価コメント		■ 評価項目
	END
	-- STATUS = ５：一次評価済。二次評価中。
	IF @status_cd = 5
	BEGIN
		UPDATE #TABLE_RESULT SET 
			generic_comment_status1					=	2													-- 汎用コメント１			■ 目標項目
		,	generic_comment_status2					=	2													-- 汎用コメント２			■ 目標項目
		,	generic_comment_status8					=	2													-- 汎用コメント８			■ 目標項目
		,	generic_comment_status3					=	2													-- 汎用コメント３			■ 目標項目
		,	generic_comment_status4					=	2													-- 汎用コメント４			■ 目標項目
		,	generic_comment_status5					=	2													-- 汎用コメント５			■ 目標項目
		,	generic_comment_status6					=	2													-- 汎用コメント6			■ 目標項目
		,	generic_comment_status7					=	2													-- 汎用コメント7			■ 目標項目
		,	item_title_status						=	2													-- 目標表題				■ 目標項目
		,	item_display_status_1					=	2													-- 目標タイトル１			■ 目標項目
		,	item_display_status_2					=	2													-- 目標タイトル２			■ 目標項目
		,	item_display_status_3					=	2													-- 目標タイトル３			■ 目標項目
		,	item_display_status_4					=	2													-- 目標タイトル４			■ 目標項目
		,	item_display_status_5					=	2													-- 目標タイトル５			■ 目標項目
		,	weight_display_status					=	2													--ウェイト				■ 目標項目
		,	challenge_level_display_status			=	2													-- 難易度				■ 目標項目
		,	detail_self_progress_comment_display_status	=	CASE 
																WHEN @login_user_typ IN(1,3) 
																THEN 1
																ELSE 2 
																--WHEN @login_user_typ IN(21,22) 
																--THEN 2
																--ELSE 0 
															END													-- 明細自己進捗評価コメント	■ 進捗コメント
		,	detail_progress_comment_display_status	=	CASE
															WHEN @login_user_typ IN(21,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_1	--  一次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,22) 
															--THEN 2
															--ELSE 0 
														END													-- 明細進捗評価コメント	■ 進捗コメント
		,	progress_comment_display_status			=	CASE
															WHEN @login_user_typ IN(1,3) 
															THEN 1
															ELSE 2 
															--WHEN @login_user_typ IN(21,22) 
															--THEN 2
															--ELSE 0 
														END													-- 自己進捗コメント		■ 進捗コメント
		,	progress_comment_display_status1		=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_1	--  一次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,22)
															--THEN 2
															--ELSE 0 
														END													-- 一次評価者進捗コメント	■ 進捗コメント
		,	progress_comment_display_status2		=	CASE
															WHEN @login_user_typ IN(22,3) 
															THEN 1
															WHEN @P_login_employee_cd = @w_rater_employee_cd_2	--  二次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21)
															--THEN 2
															--ELSE 0 
														END													-- 二次評価者進捗コメント	■ 進捗コメント
		,	progress_comment_display_status3		=	CASE 
															WHEN @login_user_typ IN(23,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_3	--  三次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,22)
															--THEN 2
															--ELSE 0 
														END													-- 三次評価者進捗コメント	■ 進捗コメント
		,	progress_comment_display_status4		=	CASE 
															WHEN @login_user_typ IN(24,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_4	--  四次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,22)
															--THEN 2
															--ELSE 0 
														END													-- 四次評価者進捗コメント	■ 進捗コメント
		,	evaluation_display_status0				=	CASE 
															WHEN @login_user_typ = 3
															THEN 1
															WHEN @login_user_typ IN(1,21,22)
															THEN 2
															ELSE 0 
														END													-- 自己評価				■ 評価項目
		,	detail_myself_comment_display_status	=	CASE 
															WHEN @login_user_typ = 3
															THEN 1
															WHEN @login_user_typ IN(1,21,22)
															THEN 2
															ELSE 0 
														END													-- 自己評価コメント		■ 評価項目
		,	detail_comment_display_status1			=	CASE 
															WHEN @login_user_typ = 3
															THEN 1 
															WHEN @login_user_typ IN(21,22) 
															THEN 2
															ELSE 0
														END													-- 評価コメント1			■ 評価項目		
		,	detail_comment_display_status2			=	CASE 
															WHEN @login_user_typ IN(22,3) 
															THEN 1
															ELSE 0
														END													-- 評価コメント2			■ 評価項目
		,	detail_comment_display_status3			=	0													-- 評価コメント3			■ 評価項目
		,	detail_comment_display_status4			=	0													-- 評価コメント4			■ 評価項目
		,	evaluation_display_status1				=	CASE 
															WHEN @login_user_typ = 3
															THEN 1 
															WHEN @login_user_typ IN(21,22)
															THEN 2
															ELSE 0 
														END													-- 一次評価				■ 評価項目
		,	evaluation_display_status2				=	CASE 
															WHEN @login_user_typ IN(22,3) 
															THEN 1
															ELSE 0 
														END													-- 二次評価				■ 評価項目		
		,	evaluation_display_status3				=	0 													-- 三次評価				■ 評価項目
		,	evaluation_display_status4				=	0 													-- 四次評価				■ 評価項目
		,	total_score_display_status				=	CASE 
															WHEN @login_user_typ IN(1,21,22,3) 
															THEN 2 
															ELSE 0 
														END													-- 合計点				■ 評価項目
		,	evaluation_comment_status0				=	CASE 
															WHEN @login_user_typ = 3 
															THEN 1 
															WHEN @login_user_typ IN(1,21,22)
															THEN 2
															ELSE 0 
														END													-- 自己評価コメント		■ 評価項目
		,	evaluation_comment_status1				=	CASE 
															WHEN @login_user_typ = 3 
															THEN 1 
															WHEN @login_user_typ IN(21,22)
															THEN 2
															ELSE 0 
														END													-- 一次評価コメント		■ 評価項目
		,	evaluation_comment_status2				=	CASE 
															WHEN @login_user_typ IN(22,3) 
															THEN 1 
															ELSE 0 
														END													-- 二次評価コメント		■ 評価項目
		,	evaluation_comment_status3				=	0 													-- 三次評価コメント		■ 評価項目
		,	evaluation_comment_status4				=	0 													-- 四次評価コメント		■ 評価項目
	END
	-- STATUS = ６：二次評価済。三次評価中。
	IF @status_cd = 6
	BEGIN
		UPDATE #TABLE_RESULT SET 
			generic_comment_status1					=	2													-- 汎用コメント１			■ 目標項目
		,	generic_comment_status2					=	2													-- 汎用コメント２			■ 目標項目
		,	generic_comment_status8					=	2													-- 汎用コメント８			■ 目標項目
		,	generic_comment_status3					=	2													-- 汎用コメント３			■ 目標項目
		,	generic_comment_status4					=	2													-- 汎用コメント４			■ 目標項目
		,	generic_comment_status5					=	2													-- 汎用コメント５			■ 目標項目
		,	generic_comment_status6					=	2													-- 汎用コメント6			■ 目標項目
		,	generic_comment_status7					=	2													-- 汎用コメント7			■ 目標項目
		,	item_title_status						=	2													-- 目標表題				■ 目標項目
		,	item_display_status_1					=	2													-- 目標タイトル１			■ 目標項目
		,	item_display_status_2					=	2													-- 目標タイトル２			■ 目標項目
		,	item_display_status_3					=	2													-- 目標タイトル３			■ 目標項目
		,	item_display_status_4					=	2													-- 目標タイトル４			■ 目標項目
		,	item_display_status_5					=	2													-- 目標タイトル５			■ 目標項目
		,	weight_display_status					=	2													--ウェイト				■ 目標項目
		,	challenge_level_display_status			=	2													-- 難易度				■ 目標項目
		,	detail_self_progress_comment_display_status	=	CASE
															WHEN @login_user_typ IN(1,3) 
															THEN 1 
															ELSE 2
															--WHEN @login_user_typ IN(21,22,23) 
															--THEN 2
															--ELSE 0 
														END													-- 明細自己進捗評価コメント	■ 進捗コメント
		,	detail_progress_comment_display_status	=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1
															WHEN @P_login_employee_cd = @w_rater_employee_cd_1	--  一次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,22,23) 
															--THEN 2
															--ELSE 0 
														END													-- 明細進捗評価コメント	■ 進捗コメント
		,	progress_comment_display_status			=	CASE
															WHEN @login_user_typ IN(1,3) 
															THEN 1 
															ELSE 2
															--WHEN @login_user_typ IN(21,22,23) 
															--THEN 2
															--ELSE 0 
														END													-- 自己進捗コメント		■ 進捗コメント		
		,	progress_comment_display_status1		=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1
															WHEN @P_login_employee_cd = @w_rater_employee_cd_1	--  一次評価者
															THEN 1
															ELSE 2 
															--WHEN @login_user_typ IN(1,22,23)
															--THEN 2
															--ELSE 0 
														END													-- 一次評価者進捗コメント	■ 進捗コメント
		,	progress_comment_display_status2		=	CASE 
															WHEN @login_user_typ IN(22,3) 
															THEN 1
															WHEN @P_login_employee_cd = @w_rater_employee_cd_2	--  二次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,23)
															--THEN 2
															--ELSE 0 
														END													-- 二次評価者進捗コメント	■ 進捗コメント
		,	progress_comment_display_status3		=	CASE
															WHEN @login_user_typ IN(23,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_3	--  三次評価者
															THEN 1
															ELSE 2 
															--WHEN @login_user_typ IN(1,21,22)
															--THEN 2
															--ELSE 0 
														END													-- 三次評価者進捗コメント	■ 進捗コメント
		,	progress_comment_display_status4		=	CASE 
															WHEN @login_user_typ IN(24,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_4	--  四次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,22,23)
															--THEN 2
															--ELSE 0 
														END													-- 四次評価者進捗コメント	■ 進捗コメント		
		,	evaluation_display_status0				=	CASE 
															WHEN @login_user_typ = 3 
															THEN 1 
															WHEN @login_user_typ IN(1,21,22,23)
															THEN 2
															ELSE 0 
														END													-- 自己評価				■ 評価項目
		,	detail_comment_display_status1			=	CASE 
															WHEN @login_user_typ = 3
															THEN 1 
															WHEN @login_user_typ IN(21,22,23)
															THEN 2
															ELSE 0 
														END													-- 評価コメント1			■ 評価項目
		,	detail_comment_display_status2			=	CASE 
															WHEN @login_user_typ = 3 
															THEN 1 
															WHEN @login_user_typ IN(22,23)
															THEN 2
															ELSE 0 
														END													-- 評価コメント2			■ 評価項目
		,	detail_comment_display_status3			=	CASE 
															WHEN @login_user_typ IN(23,3) 
															THEN 1
															ELSE 0 
														END													-- 評価コメント3			■ 評価項目
		,	detail_comment_display_status4			=	0													-- 評価コメント4			■ 評価項目
		,	detail_myself_comment_display_status	=	CASE 
															WHEN @login_user_typ = 3
															THEN 1
															WHEN @login_user_typ IN(1,21,22,23)
															THEN 2
															ELSE 0 
														END													-- 自己評価コメント		■ 評価項目
		,	evaluation_display_status1				=	CASE 
															WHEN @login_user_typ = 3
															THEN 1 
															WHEN @login_user_typ IN(21,22,23)
															THEN 2
															ELSE 0 
														END													-- 一次評価				■ 評価項目
		,	evaluation_display_status2				=	CASE 
															WHEN @login_user_typ = 3 
															THEN 1 
															WHEN @login_user_typ IN(22,23)
															THEN 2
															ELSE 0 
														END													-- 二次評価				■ 評価項目
		,	evaluation_display_status3				=	CASE 
															WHEN @login_user_typ IN(23,3) 
															THEN 1
															ELSE 0 
														END													-- 三次評価				■ 評価項目
		,	evaluation_display_status4				=	0													-- 四次評価				■ 評価項目
		,	total_score_display_status				=	CASE 
															WHEN @login_user_typ IN(1,21,22,23,3) 
															THEN 2 
															ELSE 0 
														END													-- 合計点				■ 評価項目
		,	evaluation_comment_status0				=	CASE 
															WHEN @login_user_typ = 3 
															THEN 1 
															WHEN @login_user_typ IN(1,21,22,23)
															THEN 2
															ELSE 0 
														END													-- 自己評価コメント		■ 評価項目
		,	evaluation_comment_status1				=	CASE 
															WHEN @login_user_typ = 3 
															THEN 1 
															WHEN @login_user_typ IN(21,22,23)
															THEN 2
															ELSE 0 
														END													-- 一次評価コメント		■ 評価項目
		,	evaluation_comment_status2				=	CASE 
															WHEN @login_user_typ = 3 
															THEN 1 
															WHEN @login_user_typ IN(22,23)
															THEN 2
															ELSE 0 
														END													-- 二次評価コメント		■ 評価項目
		,	evaluation_comment_status3				=	CASE 
															WHEN @login_user_typ IN(23,3) 
															THEN 1 
															ELSE 0 
														END													-- 三次評価コメント		■ 評価項目
		,	evaluation_comment_status4				=	0													-- 四次評価コメント		■ 評価項目
	END
	-- STATUS = ７：三次評価済。四次評価中。
	IF @status_cd = 7
	BEGIN
		UPDATE #TABLE_RESULT SET 
			generic_comment_status1					=	2													-- 汎用コメント１			■ 目標項目
		,	generic_comment_status2					=	2													-- 汎用コメント２			■ 目標項目
		,	generic_comment_status8					=	2													-- 汎用コメント８			■ 目標項目
		,	generic_comment_status3					=	2													-- 汎用コメント３			■ 目標項目
		,	generic_comment_status4					=	2													-- 汎用コメント４			■ 目標項目
		,	generic_comment_status5					=	2													-- 汎用コメント５			■ 目標項目
		,	generic_comment_status6					=	2													-- 汎用コメント6			■ 目標項目
		,	generic_comment_status7					=	2													-- 汎用コメント7			■ 目標項目
		,	item_title_status						=	2													-- 目標表題				■ 目標項目
		,	item_display_status_1					=	2													-- 目標タイトル１			■ 目標項目
		,	item_display_status_2					=	2													-- 目標タイトル２			■ 目標項目
		,	item_display_status_3					=	2													-- 目標タイトル３			■ 目標項目
		,	item_display_status_4					=	2													-- 目標タイトル４			■ 目標項目
		,	item_display_status_5					=	2													-- 目標タイトル５			■ 目標項目
		,	weight_display_status					=	2													--ウェイト				■ 目標項目
		,	challenge_level_display_status			=	2													-- 難易度				■ 目標項目
		,	detail_self_progress_comment_display_status	=	CASE
															WHEN @login_user_typ IN(1,3) 
															THEN 1 
															ELSE 2
															--WHEN @login_user_typ IN(21,22,23,24) 
															--THEN 2
															--ELSE 0 
														END													-- 明細自己進捗評価コメント	■ 進捗コメント
		,	detail_progress_comment_display_status	=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1
															WHEN @P_login_employee_cd = @w_rater_employee_cd_1	--  一次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,22,23,24) 
															--THEN 2
															--ELSE 0 
														END													-- 明細進捗評価コメント	■ 進捗コメント
		,	progress_comment_display_status			=	CASE 
															WHEN @login_user_typ IN(1,3) 
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(21,22,23,24) 
															--THEN 2
															--ELSE 0 
														END													-- 自己進捗コメント		■ 進捗コメント		
		,	progress_comment_display_status1		=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_1	--  一次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,22,23,24)
															--THEN 2
															--ELSE 0 
														END													-- 一次評価者進捗コメント	■ 進捗コメント
		,	progress_comment_display_status2		=	CASE 
															WHEN @login_user_typ IN(22,3) 
															THEN 1
															WHEN @P_login_employee_cd = @w_rater_employee_cd_2	--  二次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,23,24)
															--THEN 2
															--ELSE 0 
														END													-- 二次評価者進捗コメント	■ 進捗コメント
		,	progress_comment_display_status3		=	CASE 
															WHEN @login_user_typ IN(23,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_3	--  三次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,22,24)
															--THEN 2
															--ELSE 0 
														END													-- 三次評価者進捗コメント	■ 進捗コメント
		,	progress_comment_display_status4		=	CASE 
															WHEN @login_user_typ IN(24,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_4	--  四次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,22,23)
															--THEN 2
															--ELSE 0 
														END													-- 四次評価者進捗コメント	■ 進捗コメント	
		,	evaluation_display_status0				=	CASE 
															WHEN @login_user_typ = 3 
															THEN 1 
															WHEN @login_user_typ IN(1,21,22,23,24)
															THEN 2
															ELSE 0 
														END													-- 自己評価				■ 評価項目		
		,	detail_comment_display_status1			=	CASE 
															WHEN @login_user_typ = 3
															THEN 1 
															WHEN @login_user_typ IN(21,22,23,24)
															THEN 2
															ELSE 0 
														END													-- 評価コメント1			■ 評価項目
		,	detail_comment_display_status2			=	CASE 
															WHEN @login_user_typ = 3 
															THEN 1 
															WHEN @login_user_typ IN(22,23,24)
															THEN 2
															ELSE 0 
														END													-- 評価コメント2			■ 評価項目
		,	detail_comment_display_status3			=	CASE 
															WHEN @login_user_typ = 3
															THEN 1 
															WHEN @login_user_typ IN(23,24)
															THEN 2
															ELSE 0 
														END													-- 評価コメント3			■ 評価項目
		,	detail_comment_display_status4			=	CASE 
															WHEN @login_user_typ IN(3,24)
															THEN 1
															ELSE 0 
														END													-- 評価コメント4			■ 評価項目		
		,	detail_myself_comment_display_status	=	CASE 
															WHEN @login_user_typ = 3
															THEN 1
															WHEN @login_user_typ IN(1,21,22,23,24)
															THEN 2
															ELSE 0 
														END													-- 自己評価コメント		■ 評価項目
		,	evaluation_display_status1				=	CASE 
															WHEN @login_user_typ = 3
															THEN 1 
															WHEN @login_user_typ IN(21,22,23,24)
															THEN 2
															ELSE 0 
														END													-- 一次評価				■ 評価項目
		,	evaluation_display_status2				=	CASE 
															WHEN @login_user_typ = 3 
															THEN 1 
															WHEN @login_user_typ IN(22,23,24)
															THEN 2
															ELSE 0 
														END													-- 二次評価				■ 評価項目
		,	evaluation_display_status3				=	CASE 
															WHEN @login_user_typ = 3
															THEN 1 
															WHEN @login_user_typ IN(23,24)
															THEN 2
															ELSE 0 
														END													-- 三次評価				■ 評価項目
		,	evaluation_display_status4				=	CASE 
															WHEN @login_user_typ IN(3,24)
															THEN 1
															ELSE 0 
														END													-- 四次評価				■ 評価項目
		,	total_score_display_status				=	CASE 
															WHEN @login_user_typ IN(1,21,22,23,24,3) 
															THEN 2 
															ELSE 0 
														END													-- 合計点				■ 評価項目
		,	evaluation_comment_status0				=	CASE 
															WHEN @login_user_typ = 3 
															THEN 1 
															WHEN @login_user_typ IN(1,21,22,23,24)
															THEN 2
															ELSE 0 
														END													-- 自己評価コメント		■ 評価項目
		,	evaluation_comment_status1				=	CASE 
															WHEN @login_user_typ = 3 
															THEN 1 
															WHEN @login_user_typ IN(21,22,23,24)
															THEN 2
															ELSE 0 
														END													-- 一次評価コメント		■ 評価項目
		,	evaluation_comment_status2				=	CASE 
															WHEN @login_user_typ = 3 
															THEN 1 
															WHEN @login_user_typ IN(22,23,24)
															THEN 2
															ELSE 0 
														END													-- 二次評価コメント		■ 評価項目
		,	evaluation_comment_status3				=	CASE 
															WHEN @login_user_typ = 3
															THEN 1 
															WHEN @login_user_typ IN(23,24)
															THEN 2
															ELSE 0 
														END													-- 三次評価コメント		■ 評価項目
		,	evaluation_comment_status4				=	CASE 
															WHEN @login_user_typ IN(3,24)
															THEN 1
															ELSE 0 
														END													-- 四次評価コメント		■ 評価項目
	END
	-- STATUS = ８：四次評価 ９：評価確定
	IF @status_cd IN(8,9)
	BEGIN
		UPDATE #TABLE_RESULT SET 
			generic_comment_status1					=	2													-- 汎用コメント１			■ 目標項目
		,	generic_comment_status2					=	2													-- 汎用コメント２			■ 目標項目
		,	generic_comment_status8					=	2													-- 汎用コメント８			■ 目標項目
		,	generic_comment_status3					=	2													-- 汎用コメント３			■ 目標項目
		,	generic_comment_status4					=	2													-- 汎用コメント４			■ 目標項目
		,	generic_comment_status5					=	2													-- 汎用コメント５			■ 目標項目
		,	generic_comment_status6					=	2													-- 汎用コメント6			■ 目標項目
		,	generic_comment_status7					=	2													-- 汎用コメント7			■ 目標項目
		,	item_title_status						=	2													-- 目標表題				■ 目標項目
		,	item_display_status_1					=	2													-- 目標タイトル１			■ 目標項目
		,	item_display_status_2					=	2													-- 目標タイトル２			■ 目標項目
		,	item_display_status_3					=	2													-- 目標タイトル３			■ 目標項目
		,	item_display_status_4					=	2													-- 目標タイトル４			■ 目標項目
		,	item_display_status_5					=	2													-- 目標タイトル５			■ 目標項目
		,	weight_display_status					=	2													--ウェイト				■ 目標項目
		,	challenge_level_display_status			=	2													-- 難易度				■ 目標項目
		,	detail_self_progress_comment_display_status	=	CASE
																WHEN @login_user_typ IN(1,3) 
																THEN 1 
																ELSE 2
																--WHEN @login_user_typ IN(21,22,23,24) 
																--THEN 2
																--ELSE 0 
															END													-- 明細自己進捗評価コメント	■ 進捗コメント
		
		,	detail_progress_comment_display_status	=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1
															WHEN @P_login_employee_cd = @w_rater_employee_cd_1	--  一次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,22,23,24) 
															--THEN 2
															--ELSE 0 
														END													-- 明細進捗評価コメント	■ 進捗コメント
		,	progress_comment_display_status			=	CASE 
															WHEN @login_user_typ IN(1,3) 
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(21,22,23,24) 
															--THEN 2
															--ELSE 0 
														END													-- 自己進捗コメント		■ 進捗コメント
		,	progress_comment_display_status1		=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_1	--  一次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,22,23,24)
															--THEN 2
															--ELSE 0 
														END													-- 一次評価者進捗コメント	■ 進捗コメント		
		,	progress_comment_display_status2		=	CASE 
															WHEN @login_user_typ IN(22,3) 
															THEN 1
															WHEN @P_login_employee_cd = @w_rater_employee_cd_2	--  二次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,23,24)
															--THEN 2
															--ELSE 0 
														END													-- 二次評価者進捗コメント	■ 進捗コメント		
		,	progress_comment_display_status3		=	CASE 
															WHEN @login_user_typ IN(23,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_3	--  三次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,22,24)
															--THEN 2
															--ELSE 0 
														END													-- 三次評価者進捗コメント	■ 進捗コメント		
		,	progress_comment_display_status4		=	CASE 
															WHEN @login_user_typ IN(24,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_4	--  四次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,22,23)
															--THEN 2
															--ELSE 0 
														END													-- 四次評価者進捗コメント	■ 進捗コメント		
		,	evaluation_display_status0				=	2													-- 自己評価				■ 評価項目
		,	detail_myself_comment_display_status	=	2													-- 自己評価コメント		■ 評価項目
		,	detail_comment_display_status1			=	CASE 
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 評価コメント1			■ 評価項目
		,	detail_comment_display_status2			=	CASE 
															WHEN @login_user_typ IN(22,23,24,3)
															THEN 2
															ELSE 0
														END													-- 評価コメント2			■ 評価項目
		,	detail_comment_display_status3			=	CASE 
															WHEN @login_user_typ IN(23,24,3)
															THEN 2
															ELSE 0 
														END													-- 評価コメント3			■ 評価項目
		,	detail_comment_display_status4			=	CASE 
															WHEN @login_user_typ IN(24,3)
															THEN 2
															ELSE 0
														END													-- 評価コメント4			■ 評価項目		
		,	evaluation_display_status1				=	CASE 
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 一次評価				■ 評価項目
		,	evaluation_display_status2				=	CASE 
															WHEN @login_user_typ IN(22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 二次評価				■ 評価項目
		,	evaluation_display_status3				=	CASE 
															WHEN @login_user_typ IN(23,24,3)
															THEN 2
															ELSE 0 
														END													-- 三次評価				■ 評価項目
		,	evaluation_display_status4				=	CASE 
															WHEN @login_user_typ IN(24,3)
															THEN 2
															ELSE 0 
														END													-- 三次評価				■ 評価項目
		,	total_score_display_status				=	CASE 
															WHEN @login_user_typ IN(1,21,22,23,24,3) 
															THEN 2 
															ELSE 0 
														END													-- 合計点				■ 評価項目
		,	evaluation_comment_status0				=	CASE 
															WHEN @login_user_typ IN(1,21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 自己評価コメント		■ 評価項目
		,	evaluation_comment_status1				=	CASE 
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 一次評価コメント		■ 評価項目
		,	evaluation_comment_status2				=	CASE 
															WHEN @login_user_typ IN(22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 二次評価コメント		■ 評価項目
		,	evaluation_comment_status3				=	CASE 
															WHEN @login_user_typ IN(23,24,3)
															THEN 2
															ELSE 0 
														END													-- 三次評価コメント		■ 評価項目
		,	evaluation_comment_status4				=	CASE
															WHEN @login_user_typ IN(24,3)
															THEN 2
															ELSE 0 
														END													-- 四次評価コメント		■ 評価項目
	END
	-- STATUS = 10：一次評価者ﾌｨｰﾄﾞﾊﾞｯｸ
	IF @status_cd = 10
	BEGIN
		UPDATE #TABLE_RESULT SET 
			generic_comment_status1					=	2													-- 汎用コメント１			■ 目標項目
		,	generic_comment_status2					=	2													-- 汎用コメント２			■ 目標項目
		,	generic_comment_status8					=	2													-- 汎用コメント８			■ 目標項目
		,	generic_comment_status3					=	2													-- 汎用コメント３			■ 目標項目
		,	generic_comment_status4					=	2													-- 汎用コメント４			■ 目標項目
		,	generic_comment_status5					=	2													-- 汎用コメント５			■ 目標項目
		,	generic_comment_status6					=	2													-- 汎用コメント6			■ 目標項目
		,	generic_comment_status7					=	2													-- 汎用コメント7			■ 目標項目
		,	item_title_status						=	2													-- 目標表題				■ 目標項目
		,	item_display_status_1					=	2													-- 目標タイトル１			■ 目標項目
		,	item_display_status_2					=	2													-- 目標タイトル２			■ 目標項目
		,	item_display_status_3					=	2													-- 目標タイトル３			■ 目標項目
		,	item_display_status_4					=	2													-- 目標タイトル４			■ 目標項目
		,	item_display_status_5					=	2													-- 目標タイトル５			■ 目標項目
		,	weight_display_status					=	2													--ウェイト				■ 目標項目
		,	challenge_level_display_status			=	2													-- 難易度				■ 目標項目
		,	detail_self_progress_comment_display_status	=	CASE
																WHEN @login_user_typ IN(1,3) 
																THEN 1 
																ELSE 2
																--WHEN @login_user_typ IN(21,22,23,24) 
																--THEN 2
																--ELSE 0 
															END													-- 明細自己進捗評価コメント	■ 進捗コメント
		,	detail_progress_comment_display_status	=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1
															WHEN @P_login_employee_cd = @w_rater_employee_cd_1	--  一次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,22,23,24) 
															--THEN 2
															--ELSE 0 
														END													-- 明細進捗評価コメント	■ 進捗コメント
		,	progress_comment_display_status			=	CASE 
															WHEN @login_user_typ IN(1,3) 
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(21,22,23,24) 
															--THEN 2
															--ELSE 0 
														END													-- 自己進捗コメント		■ 進捗コメント
		,	progress_comment_display_status1		=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_1	--  一次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,22,23,24)
															--THEN 2
															--ELSE 0 
														END													-- 一次評価者進捗コメント	■ 進捗コメント		
		,	progress_comment_display_status2		=	CASE 
															WHEN @login_user_typ IN(22,3) 
															THEN 1
															WHEN @P_login_employee_cd = @w_rater_employee_cd_2	--  二次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,23,24)
															--THEN 2
															--ELSE 0 
														END													-- 二次評価者進捗コメント	■ 進捗コメント		
		,	progress_comment_display_status3		=	CASE 
															WHEN @login_user_typ IN(23,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_3	--  三次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,22,24)
															--THEN 2
															--ELSE 0 
														END													-- 三次評価者進捗コメント	■ 進捗コメント		
		,	progress_comment_display_status4		=	CASE 
															WHEN @login_user_typ IN(24,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_4	--  四次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,22,23)
															--THEN 2
															--ELSE 0 
														END													-- 四次評価者進捗コメント	■ 進捗コメント		
		,	evaluation_display_status0				=	2													-- 自己評価				■ 評価項目
		,	detail_myself_comment_display_status	=	2													-- 自己評価コメント		■ 評価項目
		,	detail_comment_display_status1			=	CASE 
															WHEN @login_user_typ IN(21,22,23,24,3) 
															THEN 2
															ELSE 0
														END													-- 評価コメント1			■ 評価項目
		,	detail_comment_display_status2			=	CASE 
															WHEN @login_user_typ IN(21,22,23,24,3) 
															THEN 2
															ELSE 0
														END													-- 評価コメント2			■ 評価項目
		,	detail_comment_display_status3			=	CASE 
															WHEN @login_user_typ IN(21,22,23,24,3) 
															THEN 2
															ELSE 0
														END													-- 評価コメント3			■ 評価項目
		,	detail_comment_display_status4			=	CASE 
															WHEN @login_user_typ IN(21,22,23,24,3) 
															THEN 2
															ELSE 0
														END													-- 評価コメント4			■ 評価項目		
		,	evaluation_display_status1				=	CASE 
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 一次評価				■ 評価項目
		,	evaluation_display_status2				=	CASE 
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 二次評価				■ 評価項目
		,	evaluation_display_status3				=	CASE
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 三次評価				■ 評価項目
		,	evaluation_display_status4				=	CASE 
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 三次評価				■ 評価項目
		,	total_score_display_status				=	CASE 
															WHEN @login_user_typ IN(21,22,23,24,3) 
															THEN 2 
															ELSE 0 
														END													-- 合計点				■ 評価項目
		,	evaluation_comment_status0				=	CASE 
															WHEN @login_user_typ IN(1,21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 自己評価コメント		■ 評価項目
		,	evaluation_comment_status1				=	CASE 
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 一次評価コメント		■ 評価項目
		,	evaluation_comment_status2				=	CASE 
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 二次評価コメント		■ 評価項目
		,	evaluation_comment_status3				=	CASE 
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 三次評価コメント		■ 評価項目
		,	evaluation_comment_status4				=	CASE 
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 四次評価コメント		■ 評価項目
	END
	-- STATUS = 11：評価ﾌｨｰﾄﾞﾊﾞｯｸ
	IF @status_cd = 11
	BEGIN
		UPDATE #TABLE_RESULT SET 
			generic_comment_status1					=	2													-- 汎用コメント１			■ 目標項目
		,	generic_comment_status2					=	2													-- 汎用コメント２			■ 目標項目
		,	generic_comment_status8					=	2													-- 汎用コメント８			■ 目標項目
		,	generic_comment_status3					=	2													-- 汎用コメント３			■ 目標項目
		,	generic_comment_status4					=	2													-- 汎用コメント４			■ 目標項目
		,	generic_comment_status5					=	2													-- 汎用コメント５			■ 目標項目
		,	generic_comment_status6					=	2													-- 汎用コメント6			■ 目標項目
		,	generic_comment_status7					=	2													-- 汎用コメント7			■ 目標項目
		,	item_title_status						=	2													-- 目標表題				■ 目標項目
		,	item_display_status_1					=	2													-- 目標タイトル１			■ 目標項目
		,	item_display_status_2					=	2													-- 目標タイトル２			■ 目標項目
		,	item_display_status_3					=	2													-- 目標タイトル３			■ 目標項目
		,	item_display_status_4					=	2													-- 目標タイトル４			■ 目標項目
		,	item_display_status_5					=	2													-- 目標タイトル５			■ 目標項目
		,	weight_display_status					=	2													--ウェイト				■ 目標項目
		,	challenge_level_display_status			=	2													-- 難易度				■ 目標項目
		,	detail_self_progress_comment_display_status	=	CASE
																WHEN @login_user_typ IN(1,3) 
																THEN 1 
																ELSE 2
																--WHEN @login_user_typ IN(21,22,23,24) 
																--THEN 2
																--ELSE 0 
															END													-- 明細自己進捗評価コメント	■ 進捗コメント
		,	detail_progress_comment_display_status	=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1
															WHEN @P_login_employee_cd = @w_rater_employee_cd_1	--  一次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,22,23,24) 
															--THEN 2
															--ELSE 0 
														END													-- 明細進捗評価コメント	■ 進捗コメント
		,	progress_comment_display_status			=	CASE 
															WHEN @login_user_typ IN(1,3) 
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(21,22,23,24) 
															--THEN 2
															--ELSE 0 
														END													-- 自己進捗コメント		■ 進捗コメント
		,	progress_comment_display_status1		=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_1	--  一次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,22,23,24)
															--THEN 2
															--ELSE 0 
														END													-- 一次評価者進捗コメント	■ 進捗コメント		
		,	progress_comment_display_status2		=	CASE 
															WHEN @login_user_typ IN(22,3) 
															THEN 1
															WHEN @P_login_employee_cd = @w_rater_employee_cd_2	--  二次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,23,24)
															--THEN 2
															--ELSE 0 
														END													-- 二次評価者進捗コメント	■ 進捗コメント		
		,	progress_comment_display_status3		=	CASE 
															WHEN @login_user_typ IN(23,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_3	--  三次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,22,24)
															--THEN 2
															--ELSE 0 
														END													-- 三次評価者進捗コメント	■ 進捗コメント		
		,	progress_comment_display_status4		=	CASE 
															WHEN @login_user_typ IN(24,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_4	--  四次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,22,23)
															--THEN 2
															--ELSE 0 
														END													-- 四次評価者進捗コメント	■ 進捗コメント	
		,	evaluation_display_status0				=	2													-- 自己評価				■ 評価項目
		,	detail_myself_comment_display_status	=	2													-- 自己評価コメント		■ 評価項目
		,	detail_comment_display_status1			=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.comments_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN(21,22,23,24,3) 
															THEN 2
															ELSE 0
														END													-- 評価コメント1			■ 評価項目
		,	detail_comment_display_status2			=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.comments_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN(21,22,23,24,3) 
															THEN 2
															ELSE 0
														END													-- 評価コメント2			■ 評価項目
		,	detail_comment_display_status3			=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.comments_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN(21,22,23,24,3) 
															THEN 2
															ELSE 0
														END													-- 評価コメント3			■ 評価項目
		,	detail_comment_display_status4			=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.comments_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN(21,22,23,24,3) 
															THEN 2
															ELSE 0
														END													-- 評価コメント4			■ 評価項目
		
		,	evaluation_display_status1				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.details_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 一次評価				■ 評価項目
		,	evaluation_display_status2				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.details_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 二次評価				■ 評価項目
		,	evaluation_display_status3				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.details_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 三次評価				■ 評価項目
		,	evaluation_display_status4				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.details_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 三次評価				■ 評価項目
		,	total_score_display_status				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.details_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN(21,22,23,24,3) 
															THEN 2 
															ELSE 0 
														END													-- 合計点				■ 評価項目
		,	evaluation_comment_status0				=	CASE 
															WHEN @login_user_typ IN(1,21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 自己評価コメント		■ 評価項目
		,	evaluation_comment_status1				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.comments_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 一次評価コメント		■ 評価項目
		,	evaluation_comment_status2				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.comments_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 二次評価コメント		■ 評価項目
		,	evaluation_comment_status3				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.comments_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 三次評価コメント		■ 評価項目
		,	evaluation_comment_status4				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.comments_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN(21,22,23,24,3)
															THEN 2
															ELSE 0 
														END													-- 四次評価コメント		■ 評価項目
	END
	-- STATUS = 12：評価完了
	IF @status_cd = 12
	BEGIN
		UPDATE #TABLE_RESULT SET 
			generic_comment_status1					=	2	-- 汎用コメント１			■ 目標項目
		,	generic_comment_status2					=	2	-- 汎用コメント２			■ 目標項目
		,	generic_comment_status8					=	2	-- 汎用コメント８			■ 目標項目
		,	generic_comment_status3					=	2	-- 汎用コメント３			■ 目標項目
		,	generic_comment_status4					=	2	-- 汎用コメント４			■ 目標項目
		,	generic_comment_status5					=	2	-- 汎用コメント５			■ 目標項目
		,	generic_comment_status6					=	2	-- 汎用コメント6			■ 目標項目
		,	generic_comment_status7					=	2	-- 汎用コメント7			■ 目標項目
		,	item_title_status						=	2	-- 目標表題				■ 目標項目
		,	item_display_status_1					=	2	-- 目標タイトル１			■ 目標項目
		,	item_display_status_2					=	2	-- 目標タイトル２			■ 目標項目
		,	item_display_status_3					=	2	-- 目標タイトル３			■ 目標項目
		,	item_display_status_4					=	2	-- 目標タイトル４			■ 目標項目
		,	item_display_status_5					=	2	-- 目標タイトル５			■ 目標項目
		,	weight_display_status					=	2	--ウェイト				■ 目標項目
		,	challenge_level_display_status			=	2	-- 難易度				■ 目標項目
		,	detail_self_progress_comment_display_status	=	CASE
																WHEN @login_user_typ IN(1,3) 
																THEN 1 
																ELSE 2
																--WHEN @login_user_typ IN(21,22,23,24) 
																--THEN 2
																--ELSE 0 
															END		-- 明細自己進捗評価コメント	■ 進捗コメント
		,	detail_progress_comment_display_status	=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1
															WHEN @P_login_employee_cd = @w_rater_employee_cd_1	--  一次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,22,23,24) 
															--THEN 2
															--ELSE 0 
														END	-- 明細進捗評価コメント	■ 進捗コメント
		,	progress_comment_display_status			=	CASE 
															WHEN @login_user_typ IN(1,3) 
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(21,22,23,24) 
															--THEN 2
															--ELSE 0 
														END	-- 自己進捗コメント		■ 進捗コメント
		,	progress_comment_display_status1		=	CASE 
															WHEN @login_user_typ IN(21,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_1	--  一次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,22,23,24)
															--THEN 2
															--ELSE 0 
														END	--一次評価者進捗コメント	■ 進捗コメント
		,	progress_comment_display_status2		=	CASE 
															WHEN @login_user_typ IN(22,3) 
															THEN 1
															WHEN @P_login_employee_cd = @w_rater_employee_cd_2	--  二次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,23,24)
															--THEN 2
															--ELSE 0 
														END	-- 二次評価者進捗コメント	■ 進捗コメント		
		,	progress_comment_display_status3		=	CASE 
															WHEN @login_user_typ IN(23,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_3	--  三次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,22,24)
															--THEN 2
															--ELSE 0 
														END	-- 三次評価者進捗コメント	■ 進捗コメント		
		,	progress_comment_display_status4		=	CASE 
															WHEN @login_user_typ IN(24,3) 
															THEN 1 
															WHEN @P_login_employee_cd = @w_rater_employee_cd_4	--  四次評価者
															THEN 1
															ELSE 2
															--WHEN @login_user_typ IN(1,21,22,23)
															--THEN 2
															--ELSE 0 
														END	-- 四次評価者進捗コメント	■ 進捗コメント
		,	detail_comment_display_status1			=	CASE 
														WHEN @login_user_typ = 1 AND #TABLE_RESULT.comments_feedback_typ <> 0
														THEN 2
														WHEN @login_user_typ IN (21,22,23,24,3)
														THEN 2
														ELSE 0
													END														-- 評価コメント1			■ 評価項目	
		,	detail_comment_display_status2			=	CASE 
														WHEN @login_user_typ = 1 AND #TABLE_RESULT.comments_feedback_typ <> 0
														THEN 2
														WHEN @login_user_typ IN (21,22,23,24,3)
														THEN 2
														ELSE 0
													END														-- 評価コメント2			■ 評価項目	
		,	detail_comment_display_status3			=	CASE 
														WHEN @login_user_typ = 1 AND #TABLE_RESULT.comments_feedback_typ <> 0
														THEN 2
														WHEN @login_user_typ IN (21,22,23,24,3)
														THEN 2
														ELSE 0
													END														-- 評価コメント3			■ 評価項目	
		,	detail_comment_display_status4			=	CASE 
														WHEN @login_user_typ = 1 AND #TABLE_RESULT.comments_feedback_typ <> 0
														THEN 2
														WHEN @login_user_typ IN (21,22,23,24,3)
														THEN 2
														ELSE 0
													END														-- 評価コメント4			■ 評価項目			
		,	evaluation_display_status0				=	2													-- 自己評価				■ 評価項目
		,	detail_myself_comment_display_status	=	2													-- 自己評価コメント		■ 評価項目
		,	evaluation_display_status1				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.details_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN (21,22,23,24,3)
															THEN 2
															ELSE 0
														END													-- 一次評価				■ 評価項目	
		,	evaluation_display_status2				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.details_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN (21,22,23,24,3)
															THEN 2
															ELSE 0
														END													-- 二次評価				■ 評価項目	
		,	evaluation_display_status3				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.details_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN (21,22,23,24,3)
															THEN 2
															ELSE 0
														END													-- 三次評価				■ 評価項目	
		,	evaluation_display_status4				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.details_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN (21,22,23,24,3)
															THEN 2
															ELSE 0
														END													-- 四次評価				■ 評価項目	
		,	total_score_display_status				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.details_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN (21,22,23,24,3)
															THEN 2
															ELSE 0
														END													-- 合計点				■ 評価項目	
		,	evaluation_comment_status0				=	2	-- 自己評価コメント		■ 評価項目
		,	evaluation_comment_status1				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.comments_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN (21,22,23,24,3)
															THEN 2
															ELSE 0
														END													-- 一次評価コメント		■ 評価項目	
		,	evaluation_comment_status2				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.comments_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN (21,22,23,24,3)
															THEN 2
															ELSE 0
														END													-- 二次評価コメント		■ 評価項目	
		,	evaluation_comment_status3				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.comments_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN (21,22,23,24,3)
															THEN 2
															ELSE 0
														END													-- 三次評価コメント		■ 評価項目	
		,	evaluation_comment_status4				=	CASE 
															WHEN @login_user_typ = 1 AND #TABLE_RESULT.comments_feedback_typ <> 0
															THEN 2
															WHEN @login_user_typ IN (21,22,23,24,3)
															THEN 2
															ELSE 0
														END													-- 四次評価コメント		■ 評価項目	
	END
COMPLETED:
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- UPDATE SHOW/HIDE
	UPDATE #TABLE_RESULT SET	
		generic_comment_status1						=	CASE WHEN ISNULL(W_M0200.generic_comment_display_typ_1,0) = 0 THEN 0 ELSE #TABLE_RESULT.generic_comment_status1								END	-- 汎用コメント１
	,	generic_comment_status2						=	CASE WHEN ISNULL(W_M0200.generic_comment_display_typ_2,0) = 0 THEN 0 ELSE #TABLE_RESULT.generic_comment_status2								END	-- 汎用コメント２
	,	generic_comment_status8						=	CASE WHEN ISNULL(W_M0200.generic_comment_display_typ_8,0) = 0 THEN 0 ELSE #TABLE_RESULT.generic_comment_status8								END	-- 汎用コメント８
	,	generic_comment_status3						=	CASE WHEN ISNULL(W_M0200.generic_comment_display_typ_3,0) = 0 THEN 0 ELSE #TABLE_RESULT.generic_comment_status3								END	-- 汎用コメント３
	,	generic_comment_status4						=	CASE WHEN ISNULL(W_M0200.generic_comment_display_typ_4,0) = 0 THEN 0 ELSE #TABLE_RESULT.generic_comment_status4								END	-- 汎用コメント４
	,	generic_comment_status5						=	CASE WHEN ISNULL(W_M0200.generic_comment_display_typ_5,0) = 0 THEN 0 ELSE #TABLE_RESULT.generic_comment_status5								END	-- 汎用コメント５
	,	generic_comment_status6						=	CASE WHEN ISNULL(W_M0200.generic_comment_display_typ_6,0) = 0 THEN 0 ELSE #TABLE_RESULT.generic_comment_status6								END	-- 汎用コメント５
	,	generic_comment_status7						=	CASE WHEN ISNULL(W_M0200.generic_comment_display_typ_7,0) = 0 THEN 0 ELSE #TABLE_RESULT.generic_comment_status7								END	-- 汎用コメント５
	--
	,	item_title_status							=	CASE WHEN ISNULL(W_M0200.item_title_display_typ,0) = 0 THEN 0 ELSE #TABLE_RESULT.item_title_status											END	-- 目標表題
	,	item_display_status_1						=	CASE WHEN ISNULL(W_M0200.item_display_typ_1,0) = 0 THEN 0 ELSE #TABLE_RESULT.item_display_status_1											END	-- 目標タイトル１
	,	item_display_status_2						=	CASE WHEN ISNULL(W_M0200.item_display_typ_2,0) = 0 THEN 0 ELSE #TABLE_RESULT.item_display_status_2											END	-- 目標タイトル２
	,	item_display_status_3						=	CASE WHEN ISNULL(W_M0200.item_display_typ_3,0) = 0 THEN 0 ELSE #TABLE_RESULT.item_display_status_3											END	-- 目標タイトル３
	,	item_display_status_4						=	CASE WHEN ISNULL(W_M0200.item_display_typ_4,0) = 0 THEN 0 ELSE #TABLE_RESULT.item_display_status_4											END	-- 目標タイトル４
	,	item_display_status_5						=	CASE WHEN ISNULL(W_M0200.item_display_typ_5,0) = 0 THEN 0 ELSE #TABLE_RESULT.item_display_status_5											END	-- 目標タイトル５
	,	weight_display_status						=	CASE WHEN ISNULL(W_M0200.weight_display_typ,0) = 0 THEN 0 ELSE #TABLE_RESULT.weight_display_status											END	-- ウェイト
	,	challenge_level_display_status				=	CASE WHEN ISNULL(W_M0200.challenge_level_display_typ,0) = 0 THEN 0 ELSE #TABLE_RESULT.challenge_level_display_status						END	-- 難易度
	,	detail_self_progress_comment_display_status	=	CASE WHEN ISNULL(W_M0200.detail_self_progress_comment_display_typ,0) = 0 THEN 0 ELSE #TABLE_RESULT.detail_self_progress_comment_display_status		END	-- 明細自己進捗評価コメント
	,	detail_progress_comment_display_status		=	CASE WHEN ISNULL(W_M0200.detail_progress_comment_display_typ,0) = 0 THEN 0 ELSE #TABLE_RESULT.detail_progress_comment_display_status		END	-- 明細進捗評価コメント
	--
	,	progress_comment_display_status				=	CASE WHEN ISNULL(W_M0200.self_progress_comment_display_typ,0) = 0 THEN 0 ELSE #TABLE_RESULT.progress_comment_display_status										END	-- 自己進捗コメント
	,	progress_comment_display_status1			=	CASE WHEN (ISNULL(W_M0200.progress_comment_display_typ,0) = 0 OR @w_rater_employee_cd_1 = '') THEN 0 ELSE #TABLE_RESULT.progress_comment_display_status1		END	-- 一次評価者進捗コメント
	,	progress_comment_display_status2			=	CASE WHEN (ISNULL(W_M0200.progress_comment_display_typ,0) = 0 OR @w_rater_employee_cd_2 = '') THEN 0 ELSE #TABLE_RESULT.progress_comment_display_status2		END	-- 二次評価者進捗コメント
	,	progress_comment_display_status3			=	CASE WHEN (ISNULL(W_M0200.progress_comment_display_typ,0) = 0 OR @w_rater_employee_cd_3 = '') THEN 0 ELSE #TABLE_RESULT.progress_comment_display_status3		END	-- 三次評価者進捗コメント
	,	progress_comment_display_status4			=	CASE WHEN (ISNULL(W_M0200.progress_comment_display_typ,0) = 0 OR @w_rater_employee_cd_4 = '') THEN 0 ELSE #TABLE_RESULT.progress_comment_display_status4		END	-- 四次評価者進捗コメント
	--
	,	detail_myself_comment_display_status		=	CASE WHEN ISNULL(W_M0200.detail_comment_display_typ_0,0) = 0 THEN 0 ELSE #TABLE_RESULT.detail_myself_comment_display_status					END	-- 自己評価コメント	-- edited by viettd 2020/05/29
	,	detail_comment_display_status1				=	CASE WHEN ISNULL(W_M0200.detail_comment_display_typ_1,0) = 0 THEN 0 ELSE #TABLE_RESULT.detail_comment_display_status1						END	-- 評価コメント
	,	detail_comment_display_status2				=	CASE WHEN ISNULL(W_M0200.detail_comment_display_typ_2,0) = 0 THEN 0 ELSE #TABLE_RESULT.detail_comment_display_status2						END	-- 評価コメント
	,	detail_comment_display_status3				=	CASE WHEN ISNULL(W_M0200.detail_comment_display_typ_3,0) = 0 THEN 0 ELSE #TABLE_RESULT.detail_comment_display_status3						END	-- 評価コメント
	,	detail_comment_display_status4				=	CASE WHEN ISNULL(W_M0200.detail_comment_display_typ_4,0) = 0 THEN 0 ELSE #TABLE_RESULT.detail_comment_display_status4						END	-- 評価コメント
	,	total_score_display_status					=	CASE WHEN ISNULL(W_M0200.total_score_display_typ,0) = 0 THEN 0 ELSE #TABLE_RESULT.total_score_display_status								END	-- 合計点
	--
	,	evaluation_comment_status0					=	CASE WHEN ISNULL(W_M0200.self_assessment_comment_display_typ,0) = 0 THEN 0 ELSE #TABLE_RESULT.evaluation_comment_status0					END	-- 自己評価コメント(明細)
	,	evaluation_comment_status1					=	CASE WHEN ISNULL(W_M0200.evaluation_comment_display_typ,0) = 0 THEN 0 ELSE #TABLE_RESULT.evaluation_comment_status1							END	-- 一次評価コメント
	,	evaluation_comment_status2					=	CASE WHEN ISNULL(W_M0200.evaluation_comment_display_typ,0) = 0 THEN 0 ELSE #TABLE_RESULT.evaluation_comment_status2							END	-- 二次評価コメント
	,	evaluation_comment_status3					=	CASE WHEN ISNULL(W_M0200.evaluation_comment_display_typ,0) = 0 THEN 0 ELSE #TABLE_RESULT.evaluation_comment_status3							END	-- 三次評価コメント
	,	evaluation_comment_status4					=	CASE WHEN ISNULL(W_M0200.evaluation_comment_display_typ,0) = 0 THEN 0 ELSE #TABLE_RESULT.evaluation_comment_status4							END	-- 四次評価コメント
	--
	,	point_criteria_display_status				=	CASE WHEN ISNULL(W_M0200.point_criteria_display_typ,0) = 0 THEN 0 ELSE #TABLE_RESULT.point_criteria_display_status							END	-- 評価基準
	,	challengelevel_criteria_display_status		=	CASE WHEN ISNULL(W_M0200.challengelevel_criteria_display_typ,0) = 0 THEN 0 ELSE #TABLE_RESULT.challengelevel_criteria_display_status		END	-- 難易度基準
	,	self_assessment_comment_display_status		=	CASE WHEN ISNULL(W_M0200.self_assessment_comment_display_typ,0) = 0 THEN 0 ELSE #TABLE_RESULT.self_assessment_comment_display_status		END	-- 自己評価コメント
	,	evaluation_comment_display_status			=	CASE WHEN ISNULL(W_M0200.evaluation_comment_display_typ,0) = 0 THEN 0 ELSE #TABLE_RESULT.evaluation_comment_display_status					END	-- 評価者コメント
	FROM #TABLE_RESULT
	INNER JOIN W_M0200 ON (
		#TABLE_RESULT.company_cd		=	W_M0200.company_cd
	AND #TABLE_RESULT.sheet_cd			=	W_M0200.sheet_cd
	AND @P_fiscal_year					=	W_M0200.fiscal_year
	)
	WHERE 
		W_M0200.company_cd			=	@P_company_cd
	AND W_M0200.fiscal_year			=	@P_fiscal_year
	AND W_M0200.sheet_cd			=	@P_sheet_cd
	AND	W_M0200.del_datetime IS NULL
	--	UPDATE FROM M0310
	UPDATE #TABLE_RESULT SET 
		evaluation_display_status0				=	0							-- 自己評価				■ 評価項目
	,	detail_myself_comment_display_status	=	0							-- 自己評価コメント		■ 評価項目
	,	evaluation_comment_status0				=	0							-- 自己評価コメント		■ 評価項目
	FROM #TABLE_RESULT
	INNER JOIN W_M0200 ON (
		#TABLE_RESULT.company_cd		=	W_M0200.company_cd
	AND @P_fiscal_year					=	W_M0200.fiscal_year
	AND #TABLE_RESULT.sheet_cd			=	W_M0200.sheet_cd
	)
	INNER JOIN M0310 ON (
		W_M0200.company_cd				=	M0310.company_cd
	AND W_M0200.sheet_kbn				=	M0310.category
	AND 3								=	M0310.status_cd	
	)
	WHERE 
		M0310.company_cd				=	@P_company_cd
	AND M0310.del_datetime IS NULL
	AND M0310.status_cd					=	3 -- 自己評価中
	AND M0310.status_use_typ			=	0 -- 0.利用不可
	-- add by viettd 2021/12/01
	-- when W_M0200.evaluation_self_typ=1 then not use 自己評価
	UPDATE #TABLE_RESULT SET 
		evaluation_display_status0				=	0							-- 自己評価				■ 評価項目
	,	detail_myself_comment_display_status	=	0							-- 自己評価コメント		■ 評価項目
	,	evaluation_comment_status0				=	0							-- 自己評価コメント		■ 評価項目
	FROM #TABLE_RESULT
	INNER JOIN W_M0200 ON (
		#TABLE_RESULT.company_cd		=	W_M0200.company_cd
	AND @P_fiscal_year					=	W_M0200.fiscal_year
	AND #TABLE_RESULT.sheet_cd			=	W_M0200.sheet_cd
	)
	WHERE 
		W_M0200.company_cd				=	@P_company_cd
	AND W_M0200.evaluation_self_typ		=	0	-- 0.利用不可
	AND W_M0200.del_datetime IS NULL
	-- UPDATE EVALUATION STEP
	UPDATE #TABLE_RESULT SET 
		evaluation_display_status1			=	IIF(@w_rater_employee_cd_1 = '',0,#TABLE_RESULT.evaluation_display_status1)
	,	evaluation_display_status2			=	IIF(@w_rater_employee_cd_2 = '',0,#TABLE_RESULT.evaluation_display_status2)
	,	evaluation_display_status3			=	IIF(@w_rater_employee_cd_3 = '',0,#TABLE_RESULT.evaluation_display_status3)
	,	evaluation_display_status4			=	IIF(@w_rater_employee_cd_4 = '',0,#TABLE_RESULT.evaluation_display_status4)
	,	detail_comment_display_status1		=	IIF(@w_rater_employee_cd_1 = '',0,#TABLE_RESULT.detail_comment_display_status1)
	,	detail_comment_display_status2		=	IIF(@w_rater_employee_cd_2 = '',0,#TABLE_RESULT.detail_comment_display_status2)
	,	detail_comment_display_status3		=	IIF(@w_rater_employee_cd_3 = '',0,#TABLE_RESULT.detail_comment_display_status3)
	,	detail_comment_display_status4		=	IIF(@w_rater_employee_cd_4 = '',0,#TABLE_RESULT.detail_comment_display_status4)
	,	evaluation_comment_status1			=	IIF(@w_rater_employee_cd_1 = '',0,#TABLE_RESULT.evaluation_comment_status1)
	,	evaluation_comment_status2			=	IIF(@w_rater_employee_cd_2 = '',0,#TABLE_RESULT.evaluation_comment_status2)
	,	evaluation_comment_status3			=	IIF(@w_rater_employee_cd_3 = '',0,#TABLE_RESULT.evaluation_comment_status3)
	,	evaluation_comment_status4			=	IIF(@w_rater_employee_cd_4 = '',0,#TABLE_RESULT.evaluation_comment_status4)
	--
	,	progress_comment_display_status1	=	IIF(@w_rater_employee_cd_1 = '',0,#TABLE_RESULT.progress_comment_display_status1)
	,	progress_comment_display_status2	=	IIF(@w_rater_employee_cd_2 = '',0,#TABLE_RESULT.progress_comment_display_status2)
	,	progress_comment_display_status3	=	IIF(@w_rater_employee_cd_3 = '',0,#TABLE_RESULT.progress_comment_display_status3)
	,	progress_comment_display_status4	=	IIF(@w_rater_employee_cd_4 = '',0,#TABLE_RESULT.progress_comment_display_status4)
	FROM #TABLE_RESULT
	-- UPDATE FROM M0100
	UPDATE #TABLE_RESULT SET 
		evaluation_display_status1			=	IIF(ISNULL(M0100.target_evaluation_typ_1,0) = 0,0,#TABLE_RESULT.evaluation_display_status1)
	,	evaluation_display_status2			=	IIF(ISNULL(M0100.target_evaluation_typ_2,0) = 0,0,#TABLE_RESULT.evaluation_display_status2)
	,	evaluation_display_status3			=	IIF(ISNULL(M0100.target_evaluation_typ_3,0) = 0,0,#TABLE_RESULT.evaluation_display_status3)
	,	evaluation_display_status4			=	IIF(ISNULL(M0100.target_evaluation_typ_4,0) = 0,0,#TABLE_RESULT.evaluation_display_status4)
	,	detail_comment_display_status1		=	IIF(ISNULL(M0100.target_evaluation_typ_1,0) = 0,0,#TABLE_RESULT.detail_comment_display_status1)
	,	detail_comment_display_status2		=	IIF(ISNULL(M0100.target_evaluation_typ_2,0) = 0,0,#TABLE_RESULT.detail_comment_display_status2)
	,	detail_comment_display_status3		=	IIF(ISNULL(M0100.target_evaluation_typ_3,0) = 0,0,#TABLE_RESULT.detail_comment_display_status3)
	,	detail_comment_display_status4		=	IIF(ISNULL(M0100.target_evaluation_typ_4,0) = 0,0,#TABLE_RESULT.detail_comment_display_status4)
	,	evaluation_comment_status1			=	IIF(ISNULL(M0100.target_evaluation_typ_1,0) = 0,0,#TABLE_RESULT.evaluation_comment_status1)
	,	evaluation_comment_status2			=	IIF(ISNULL(M0100.target_evaluation_typ_2,0) = 0,0,#TABLE_RESULT.evaluation_comment_status2)
	,	evaluation_comment_status3			=	IIF(ISNULL(M0100.target_evaluation_typ_3,0) = 0,0,#TABLE_RESULT.evaluation_comment_status3)
	,	evaluation_comment_status4			=	IIF(ISNULL(M0100.target_evaluation_typ_4,0) = 0,0,#TABLE_RESULT.evaluation_comment_status4)
	,	progress_comment_display_status1	=	IIF(ISNULL(M0100.target_evaluation_typ_1,0) = 0,0,#TABLE_RESULT.progress_comment_display_status1)
	,	progress_comment_display_status2	=	IIF(ISNULL(M0100.target_evaluation_typ_2,0) = 0,0,#TABLE_RESULT.progress_comment_display_status2)
	,	progress_comment_display_status3	=	IIF(ISNULL(M0100.target_evaluation_typ_3,0) = 0,0,#TABLE_RESULT.progress_comment_display_status3)
	,	progress_comment_display_status4	=	IIF(ISNULL(M0100.target_evaluation_typ_4,0) = 0,0,#TABLE_RESULT.progress_comment_display_status4)	
	FROM #TABLE_RESULT
	INNER JOIN M0100 ON (
		#TABLE_RESULT.company_cd	=	M0100.company_cd
	)
	WHERE
		M0100.company_cd	=	@P_company_cd
	AND M0100.del_datetime IS NULL
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	SELECT * FROM #TABLE_RESULT
	--
	DROP TABLE #TABLE_RESULT
END
GO