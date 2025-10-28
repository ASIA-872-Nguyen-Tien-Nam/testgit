DROP PROCEDURE [SPC_I2020_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ [SPC_I2020_INQ1]
-- EXEC SPC_I2020_INQ1 '2018','807','1','807';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	I2020
--*  
--*  作成日/create date			:	2018/09/25				
--*　作成者/creater				:	Longvv								
--*   					
--*  更新日/update date			:	2019/06/05
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	add view 部・課
--*   					
--*  更新日/update date			:	2019/12/10
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgradate ver 1.6
--*   					
--*  更新日/update date			:	2020/02/14  
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	remove condition M0100.interview_use_typ = 1
--*   					
--*  更新日/update date			:	2020/03/04  
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	add condition 汎用コメント
--*   					
--*  更新日/update date			:	2020/03/16  
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	edited item 汎用コメント
--*   					
--*  更新日/update date			:	2020/03/25  
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	評価コメントを制御
--*   					
--*  更新日/update date			:	2020/04/24
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	fix error when 評価者 = 管理者
--*   					
--*  更新日/update date			:	2020/04/29
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	view total when 仮評価者
--*   					
--*  更新日/update date			:	2020/05/15
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	eidted in 汎用コメント
--*   					
--*  更新日/update date			:	2020/05/18
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	CHECK PERMISSION OF ROUTER EVALUTATION
--*   					
--*  更新日/update date			:	2020/06/23
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	change evaluation_comment_detail_flg -> evaluation_comment_detail_flg_1~ 4
--*   					
--*  更新日/update date			:	2020/08/20
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	when refer to F0300 then condition is 
--*								:	・シートの目標又は定性
--*								:	・シートのステータス
--*   					
--*  更新日/update date			:	2020/10/10
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgrade ver 1.7 & 1on1
--*   					
--*  更新日/update date			:	2020/12/07
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	add M0310.detail_no
--*   					
--*  更新日/update date			:	2020/12/08
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	明細進捗コメント + 目標管理の進捗コメント欄と同様の制御とする。一次評価完了までは入力を可能とする。
--*   					
--*  更新日/update date			:	2021/12/01
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgrade ver 1.8
--*   					
--*  更新日/update date			:	2022/03/31
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	WHEN authority_typ = 4,5 and is employee
--*   					
--*  更新日/update date			:	2022/08/16
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgrade ver 1.9
--*   					
--*  更新日/update date			:	2022/12/09 			
--*　更新者/updater				:　	viettd　  　			
--*　更新内容/update content		:	change condition view item 明細評価コメント
--*   					
--*  更新日/update date			:	2025/02/11		
--*　更新者/updater				:　	viettd　  　			
--*　更新内容/update content		:	change upload_file from W_M0200 to M0200 
--*   					
--*  更新日/update date			:	2025/08/05		
--*　更新者/updater				:　	viettd　  　			
--*　更新内容/update content		:	comment out to alaway show data of table 's F0121
--*	
--****************************************************************************************
CREATE PROCEDURE [SPC_I2020_INQ1]
	@P_fiscal_year				SMALLINT		=	0
,	@P_employee_cd				NVARCHAR(20)	=	''
,	@P_sheet_cd					SMALLINT		=	0
,	@P_company_cd				SMALLINT		=	0
,	@P_user_id					NVARCHAR(50)	=	''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@authority_typ									SMALLINT		=	0
	,	@authority_cd									SMALLINT		=	0
	,	@employee_cd_login								NVARCHAR(20)	=	''
	,	@status_cd										SMALLINT		=	0
	,	@status_cd_refer								SMALLINT		=	0
	,	@memoryButton									SMALLINT		=	0	--一時保存
	,	@saveButton										SMALLINT		=	0	--登録
	,	@interviewButton 								SMALLINT		=	1	--面談記録
	,	@listItemFLG0									SMALLINT		=	0	--1.disbaled 2.enabled	自己評価
	,	@point_kinds									SMALLINT		=	0
	,	@generic_comment_cnt							SMALLINT		=	0	
	,	@point_calculation_typ1							SMALLINT		=	0
	,	@point_calculation_typ2							SMALLINT		=	0
	,	@evaluation_comment_detail_flg_1				SMALLINT		=	0	-- 1.disbaled 2.enabled
	,	@evaluation_comment_detail_flg_2				SMALLINT		=	0	-- 1.disbaled 2.enabled
	,	@evaluation_comment_detail_flg_3				SMALLINT		=	0	-- 1.disbaled 2.enabled
	,	@evaluation_comment_detail_flg_4				SMALLINT		=	0	-- 1.disbaled 2.enabled
	,	@detail_progress_comment_display_typ_flg		SMALLINT		=	0	-- 1.disbaled 2.enabled		-- add by viettd 2020/10/09
	,	@detail_self_progress_comment_display_typ_flg	SMALLINT		=	0	-- 1.disbaled 2.enabled		-- add by viettd 2021/12/01
	,	@progress_comment_display_status				SMALLINT		=	0	-- 1.disbaled 2.enabled		-- add by viettd 2021/12/01
	,	@progress_comment_display_status1				SMALLINT		=	0	-- 1.disbaled 2.enabled		-- add by viettd 2021/12/01
	,	@progress_comment_display_status2				SMALLINT		=	0	-- 1.disbaled 2.enabled		-- add by viettd 2021/12/01
	,	@progress_comment_display_status3				SMALLINT		=	0	-- 1.disbaled 2.enabled		-- add by viettd 2021/12/01
	,	@progress_comment_display_status4				SMALLINT		=	0	-- 1.disbaled 2.enabled		-- add by viettd 2021/12/01
	,	@self_progress_comment_display_typ				TINYINT			=	0	-- 0.not use  1.use			-- add by viettd 2021/12/01
	,	@progress_comment_display_typ					TINYINT			=	0	-- 0.not use  1.use			-- add by viettd 2021/12/01

	--
	,	@evaluation_comment_1_flg					SMALLINT		=	0
	,	@evaluation_comment_2_flg					SMALLINT		=	0
	,	@evaluation_comment_3_flg					SMALLINT		=	0
	,	@evaluation_comment_4_flg					SMALLINT		=	0
	,	@evaluation_1_flg							SMALLINT		=	0	
	,	@evaluation_2_flg							SMALLINT		=	0	
	,	@evaluation_3_flg							SMALLINT		=	0	
	,	@evaluation_4_flg							SMALLINT		=	0	
	,	@details_feedback_typ						SMALLINT		=	0
	,	@comments_feedback_typ						SMALLINT		=	0
	,	@evaluation_step							SMALLINT		=	0
	,	@totalcolumn								SMALLINT		=	0
	,	@interview_use_typ							SMALLINT		=	0	--期首面談なし
	,	@evaluation_self_assessment					SMALLINT		=	0	--自己評価なし
	,	@year_month_day								DATE			=	NULL
	,	@beginning_date								DATE			=	NULL
	--
	,	@generic_comment_status1					TINYINT			=	1	-- 1.DISABLED 2.EMABELD	-- 汎用コメント1		
	,	@generic_comment_status2					TINYINT			=	1	-- 1.DISABLED 2.EMABELD	-- 汎用コメント2
	,	@generic_comment_status3					TINYINT			=	1	-- 1.DISABLED 2.EMABELD	-- 汎用コメント3
	,	@generic_comment_status4					TINYINT			=	1	-- 1.DISABLED 2.EMABELD	-- 汎用コメント4
	,	@generic_comment_status5					TINYINT			=	1	-- 1.DISABLED 2.EMABELD	-- 汎用コメント5
	,	@generic_comment_status6					TINYINT			=	1	-- 1.DISABLED 2.EMABELD	-- 汎用コメント6
	,	@generic_comment_status7					TINYINT			=	1	-- 1.DISABLED 2.EMABELD	-- 汎用コメント7
	,	@generic_comment_status8					TINYINT			=	1	-- 1.DISABLED 2.EMABELD	-- 汎用コメント8
	,	@start_date									date			=	NULL	
	,	@w_time										date			=	GETDATE()
	--
	,	@chk										tinyint			=	0	-- add by viettd 2020/05/18
	,	@w_evaluation_self_typ						tinyint			=	0
	,	@w_language									INT				=	1	--1: jp / 2 :en
	--CREATE TEMP TABLE
	IF object_id('tempdb..#TEMP_F0100', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TEMP_F0100
    END
	IF object_id('tempdb..#TEMP_W_M0201', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TEMP_W_M0201
    END
	IF object_id('tempdb..#TEMP_F0121', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TEMP_F0121
    END
	IF object_id('tempdb..#TABLE_M0310', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_M0310
    END
	IF object_id('tempdb..#M0071_SHEET', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0071_SHEET
    END
	------------------
	CREATE TABLE #TABLE_M0310 (
		id						smallint			identity(1,1)
	,	category				smallint
	,	status_cd				smallint
	,	status_nm				nvarchar(100)
	,	status_use_typ			tinyint
	,	detail_no				smallint		-- add 2020/12/07
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
	CREATE	TABLE #TEMP_F0100 (
		ID						BIGINT			IDENTITY (1,1)
	,	company_cd				SMALLINT
	,	employee_cd				NVARCHAR(10)
	,	rater_employee_cd_1		NVARCHAR(10)
	,	rater_employee_cd_2		NVARCHAR(10)
	,	rater_employee_cd_3		NVARCHAR(10)
	,	rater_employee_cd_4		NVARCHAR(10)
	,	evaluation_step			SMALLINT
	)
	--
	CREATE	TABLE #TEMP_F0121 (
		ID						BIGINT			IDENTITY (1,1)
	,	item_no					SMALLINT
	,	evaluation_step			SMALLINT
	)
	--
	CREATE TABLE #TEMP_W_M0201 (
		ID								BIGINT			IDENTITY (1,1)
	,	item_no							SMALLINT
	,	item_detail_1					NVARCHAR(1000) --2018.11.28 fixed by yamazaki 桁数変更
	,	item_detail_2					NVARCHAR(1000) --2019.05.27 fixed by yamazaki 桁数変更 --2018.11.28 fixed by yamazaki 桁数変更
	,	item_detail_3					NVARCHAR(1000) --2019.05.27 fixed by yamazaki 桁数変更 --2018.11.28 fixed by yamazaki 桁数変更
	,	weight							SMALLINT
	,	evaluation_comment				NVARCHAR(1000)
	,	evaluation_comment_detail_1		NVARCHAR(1000)
	,	evaluation_comment_detail_2		NVARCHAR(1000)
	,	evaluation_comment_detail_3		NVARCHAR(1000)
	,	evaluation_comment_detail_4		NVARCHAR(1000)
	,	point_cd_0						SMALLINT
	,	point_cd_1						SMALLINT
	,	point_cd_2						SMALLINT
	,	point_cd_3						SMALLINT
	,	point_cd_4						SMALLINT
	)
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
	--
	INSERT INTO #M0071_SHEET
	EXEC [dbo].SPC_REFER_M0071_INQ1 @P_fiscal_year,'',0,@P_company_cd
	--SET @interview_use_typ
	--IF EXISTS(	SELECT 1 
	--			FROM M0100 
	--			WHERE 
	--				M0100.company_cd			=	@P_company_cd
	--			AND	M0100.interview_use_typ		=	1
	--			AND M0100.del_datetime IS NULL)
	--AND EXISTS(	SELECT 1 
	--			FROM M0310 
	--			WHERE 
	--				M0310.company_cd		=	@P_company_cd
	--			AND	M0310.category			=	3 
	--			AND M0310.status_cd			=	1
	--			AND M0310.status_use_typ	=	1
	--			AND M0310.del_datetime IS NULL)
	--BEGIN
	--	SET @interview_use_typ	=	1						--	期首面談あり
	--END
	-- edited by viettd 2020/02/14
	IF EXISTS(	SELECT 1 
				FROM M0310 
				WHERE 
					M0310.company_cd		=	@P_company_cd
				AND	M0310.category			=	3 
				AND M0310.status_cd			=	1
				AND M0310.status_use_typ	=	1
				AND M0310.del_datetime IS NULL)
	BEGIN
		SET @interview_use_typ	=	1						--	期首面談あり
	END
	--SET @evaluation_self_assessment
	IF EXISTS(	SELECT 1 
				FROM M0100 
				WHERE 
					M0100.company_cd						=	@P_company_cd
				AND	M0100.evaluation_self_assessment_typ	=	1
				AND M0100.del_datetime IS NULL)
	BEGIN
		SET @evaluation_self_assessment	=	1				--	自己評価あり
	END
	--S0010
	SELECT 
		@authority_typ		=	S0010.authority_typ
	,	@authority_cd		=	S0010.authority_cd
	,	@employee_cd_login	=	S0010.employee_cd
	,	@w_language			=	ISNULL(S0010.language,1)
	FROM S0010
	WHERE 
		S0010.company_cd	=	@P_company_cd
	AND	S0010.user_id		=	@P_user_id
	AND S0010.del_datetime IS NULL
	--↓↓↓ add by viettd 2022/08/16
	IF @authority_typ = 6
	BEGIN
		SET @authority_typ = 2 -- 評価者
	END
	--↑↑↑ end add by viettd 2022/08/16
	--
	SELECT TOP 1
		@status_cd	=	F0100.status_cd 
	FROM F0100
	WHERE 
		F0100.company_cd	=	@P_company_cd
	AND	F0100.fiscal_year	=	@P_fiscal_year
	AND F0100.employee_cd	=	@P_employee_cd
	AND	F0100.sheet_cd		=	@P_sheet_cd
	AND	F0100.del_datetime	IS NULL
	--
	IF	@status_cd	=	0	
	BEGIN
		IF	@interview_use_typ	= 1 
		BEGIN	
			SET	@status_cd_refer						=	0
		END
		ELSE
		BEGIN
			IF @evaluation_self_assessment = 1
			BEGIN
				SET	@status_cd_refer					=	1
			END
			ELSE
			BEGIN
				SET	@status_cd_refer					=	2
			END
		END	
	END
	ELSE 
	BEGIN
		SET @status_cd_refer				=	@status_cd
	END
	--INSERT INTO  #TEMP_F0100
	INSERT INTO #TEMP_F0100
	SELECT	
		F0100.company_cd
	,	F0100.employee_cd
	,	F0100.rater_employee_cd_1
	,	F0100.rater_employee_cd_2
	,	F0100.rater_employee_cd_3
	,	F0100.rater_employee_cd_4
	--	add by viettd 2020/04/24
	,	[dbo].FNC_GET_STEP_EVALUATION
		(
			'I2020'
		,	2				-- 2.定性評価シート
		,	@status_cd
		,	@P_employee_cd
		,	@employee_cd_login
		,	@authority_typ
		,	F0100.rater_employee_cd_1
		,	F0100.rater_employee_cd_2
		,	F0100.rater_employee_cd_3
		,	F0100.rater_employee_cd_4
		) AS evaluation_step
	FROM F0100		
	WHERE
		F0100.company_cd	=	@P_company_cd
	AND	F0100.fiscal_year	=	@P_fiscal_year
	AND	F0100.employee_cd	=	@P_employee_cd	
	AND	F0100.sheet_cd		=	@P_sheet_cd	
	AND	F0100.del_datetime	IS NULL
	--SET @point_kinds,@point_calculation_typ
	SELECT
		@point_kinds						=	W_M0200.point_kinds
	,	@point_calculation_typ1				=	W_M0200.point_calculation_typ1
	,	@point_calculation_typ2				=	W_M0200.point_calculation_typ2
	,	@details_feedback_typ				=	W_M0200.details_feedback_typ
	,	@comments_feedback_typ				=	W_M0200.comments_feedback_typ
	,	@w_evaluation_self_typ				=	W_M0200.evaluation_self_typ
	,	@self_progress_comment_display_typ	=	W_M0200.self_progress_comment_display_typ
	,	@progress_comment_display_typ		=	W_M0200.progress_comment_display_typ
	FROM W_M0200  
	WHERE 
		W_M0200.company_cd		=	@P_company_cd 
	AND	W_M0200.fiscal_year		=	@P_fiscal_year
	AND	W_M0200.sheet_cd		=	@P_sheet_cd	
	AND W_M0200.del_datetime IS NULL
	--[0]
	SELECT
		@status_cd_refer							AS	status_cd					
	,	CASE 
			WHEN ISNULL(M0310.status_nm,'')	<> ''
			THEN ISNULL(M0310.status_nm,'')
			ELSE ISNULL(IIF(@w_language= 2,L0040.status_nm_english ,L0040.status_nm),'')	
		END											AS	status_nm
	,	ISNULL(M0070.picture,'')					AS	picture
	,	ISNULL(M0070.employee_cd,'')				AS	employee_cd
	,	ISNULL(M0070.employee_nm,'')				AS	employee_nm
	,	@P_fiscal_year								AS	fiscal_year
	,	ISNULL(F0100.sheet_cd,0)					AS	sheet_cd
	,	ISNULL(W_M0200.sheet_nm,'')					AS	sheet_nm
	,	ISNULL(L0010.name,'')						AS	category_nm
	,	ISNULL(#M0071_SHEET.employee_typ_nm,'')		AS	employee_typ_nm
	,	ISNULL(#M0071_SHEET.job_nm,'')				AS	job_nm
	,	ISNULL(#M0071_SHEET.position_nm,'')			AS	position_nm
	,	ISNULL(#M0071_SHEET.grade_nm,'')			AS	grade_nm
	,	ISNULL(M0070.salary_grade,0)				AS	salary_grade
	,	ISNULL(#M0071_SHEET.belong_nm1,'')			AS	belong_nm1				-- add by viettd 2019/12/10
	,	ISNULL(#M0071_SHEET.belong_nm2,'')			AS	belong_nm2				-- add by viettd 2019/12/10
	,	ISNULL(#M0071_SHEET.belong_nm3,'')			AS	belong_nm3				-- add by viettd 2019/12/10
	,	ISNULL(#M0071_SHEET.belong_nm4,'')			AS	belong_nm4				-- add by viettd 2019/12/10
	,	ISNULL(#M0071_SHEET.belong_nm5,'')			AS	belong_nm5				-- add by viettd 2019/12/10
	,	ISNULL(A.employee_nm,'')					AS	rater_employee_nm_1
	,	ISNULL(B.employee_nm,'')					AS	rater_employee_nm_2
	,	ISNULL(C.employee_nm,'')					AS	rater_employee_nm_3
	,	ISNULL(D.employee_nm,'')					AS	rater_employee_nm_4
	,	ISNULL(TEMP.evaluation_step,0)				AS	evaluation_step
	,	@point_calculation_typ1						AS	point_calculation_typ1
	,	@point_calculation_typ2						AS	point_calculation_typ2
	,	CASE 
			WHEN @point_calculation_typ1 = 1 -- 1.ウェイト
			THEN IIF(@w_language = 2,'Weight',N'ｳｪｲﾄ')
			WHEN @point_calculation_typ1 = 2 -- 2.係数
			THEN IIF(@w_language = 2,'Coefficient',N'係数')
			ELSE ''
		END											AS	weight_display_nm
	--	add by viettd 2021/12/01
	,	ISNULL(F0110.progress_comment_self,'')		AS	progress_comment_self		-- 自己進捗コメント
	,	ISNULL(F0110.progress_comment_rater,'')		AS	progress_comment_rater		-- 一次評価進捗コメント
	,	ISNULL(F0110.progress_comment_rater_2,'')	AS	progress_comment_rater_2	-- 二次評価進捗コメント
	,	ISNULL(F0110.progress_comment_rater_3,'')	AS	progress_comment_rater_3	-- 三次評価進捗コメント
	,	ISNULL(F0110.progress_comment_rater_4,'')	AS	progress_comment_rater_4	-- 四次評価進捗コメント
	FROM F0100
	LEFT OUTER JOIN M0310 ON (
		F0100.company_cd		=	M0310.company_cd
	AND	2						=	M0310.category
	AND	@status_cd_refer		=	M0310.status_cd
	)
	LEFT OUTER JOIN L0040 ON(
		2						=	L0040.category
	AND	@status_cd_refer		=	L0040.status_cd
	)
	INNER JOIN #TEMP_F0100 AS TEMP ON(
		F0100.company_cd		=	TEMP.company_cd
	AND	F0100.employee_cd		=	TEMP.employee_cd
	)
	LEFT OUTER JOIN M0070 ON(
		F0100.company_cd		=	M0070.company_cd
	AND F0100.employee_cd		=	M0070.employee_cd
	)
	LEFT OUTER JOIN #M0071_SHEET ON (
		F0100.company_cd			=	#M0071_SHEET.company_cd
	AND F0100.fiscal_year			=	#M0071_SHEET.fiscal_year
	AND F0100.employee_cd			=	#M0071_SHEET.employee_cd
	AND F0100.sheet_cd				=	#M0071_SHEET.sheet_cd
	)
	LEFT OUTER JOIN W_M0200	 ON(
		F0100.company_cd		=	W_M0200.company_cd
	AND	F0100.fiscal_year		=	W_M0200.fiscal_year
	AND	F0100.sheet_cd			=	W_M0200.sheet_cd
	)
	LEFT OUTER JOIN L0010 ON (
		7						=	L0010.name_typ
	AND	W_M0200.category		=	L0010.number_cd
	)
	LEFT OUTER JOIN M0070	AS A ON(
		@P_company_cd				=	A.company_cd
	AND	TEMP.rater_employee_cd_1	=	A.employee_cd
	)
	LEFT OUTER JOIN M0070	AS B ON(
		@P_company_cd				=	B.company_cd
	AND	TEMP.rater_employee_cd_2	=	B.employee_cd
	)
	LEFT OUTER JOIN M0070	AS C ON(
		@P_company_cd				=	C.company_cd
	AND	TEMP.rater_employee_cd_3	=	C.employee_cd
	)
	LEFT OUTER JOIN M0070	AS D ON(
		@P_company_cd				=	D.company_cd
	AND	TEMP.rater_employee_cd_4	=	D.employee_cd
	)
	LEFT OUTER JOIN F0110 ON (
		F0100.company_cd		=	F0110.company_cd
	AND F0100.fiscal_year		=	F0110.fiscal_year
	AND F0100.employee_cd		=	F0110.employee_cd
	AND F0100.sheet_cd			=	F0110.sheet_cd
	AND F0110.del_datetime IS NULL
	)
	WHERE 
		F0100.company_cd	=	@P_company_cd
	AND	F0100.fiscal_year	=	@P_fiscal_year
	AND	F0100.sheet_cd		=	@P_sheet_cd
	AND	F0100.del_datetime	IS NULL
	--CREATE TABLE #TEMP_F0121
	INSERT INTO #TEMP_F0121
	SELECT 
		F0121.item_no
	,	CASE
			WHEN MAX(F0121.evaluation_step) < 5
			THEN MAX(F0121.evaluation_step)
			ELSE 4
		END
	FROM F0121
	INNER JOIN #TEMP_F0100 AS TEMP ON (
		F0121.employee_cd	=	TEMP.employee_cd
	)
	WHERE 
		F0121.company_cd		=	@P_company_cd
	AND	F0121.fiscal_year		=	@P_fiscal_year
	AND	F0121.sheet_cd			=	@P_sheet_cd	
	AND F0121.evaluation_step	<>	0
	GROUP BY F0121.item_no
	--
	INSERT INTO #TEMP_W_M0201
	SELECT 
		W_M0201.item_no
	,	W_M0201.item_detail_1
	,	W_M0201.item_detail_2
	,	W_M0201.item_detail_3
	,	W_M0201.weight
	,	ISNULL(F0121_0.evaluation_comment,'')		AS evaluation_comment_0

	,	ISNULL(F0121_1.evaluation_comment,'')	AS	evaluation_comment_detail_1
	,	ISNULL(F0121_2.evaluation_comment,'')	AS	evaluation_comment_detail_2
	,	ISNULL(F0121_3.evaluation_comment,'')	AS	evaluation_comment_detail_3
	,	ISNULL(F0121_4.evaluation_comment,'')	AS	evaluation_comment_detail_4
	-- comment out by viettd 2025/08/05
	---- ↓↓↓ edited by viettd 2020/03/25
	--,	CASE 
	--	WHEN (
	--		(TEMP.evaluation_step = 0 AND @status_cd >= 9 AND @comments_feedback_typ = 1) -- 評価コメントの閲覧が可能: TRUE -- 仮評価者
	--	OR	(TEMP.evaluation_step IN(1,2,3,4,5))	-- 一次評価者～管理者
	--	)
	--	THEN ISNULL(F0121_1.evaluation_comment,'')
	--	ELSE ''
	--END												AS	evaluation_comment_detail_1



	--,	CASE 
	--	WHEN (
	--		(TEMP.evaluation_step = 0 AND @status_cd >= 9 AND @comments_feedback_typ = 1) -- 評価コメントの閲覧が可能: TRUE　-- 仮評価者
	--	OR	(TEMP.evaluation_step = 1 AND @status_cd >= 8)
	--	OR  (TEMP.evaluation_step IN(2,3,4,5))
	--	)
	--	THEN ISNULL(F0121_2.evaluation_comment,'')
	--	ELSE ''
	--END												AS	evaluation_comment_detail_2
	--,	CASE 
	--	WHEN (
	--		(TEMP.evaluation_step = 0 AND @status_cd >= 9 AND @comments_feedback_typ = 1) -- 評価コメントの閲覧が可能: TRUE　-- 仮評価者
	--	OR	(TEMP.evaluation_step IN(1,2) AND @status_cd >= 8)
	--	OR  (TEMP.evaluation_step IN(3,4,5))
	--	)
	--	THEN ISNULL(F0121_3.evaluation_comment,'')
	--	ELSE ''
	--END												AS	evaluation_comment_detail_3
	--,	CASE 
	--	WHEN (
	--		(TEMP.evaluation_step = 0 AND @status_cd >= 9 AND @comments_feedback_typ = 1) -- 評価コメントの閲覧が可能: TRUE　-- 仮評価者
	--	OR	(TEMP.evaluation_step IN(1,2,3) AND @status_cd >= 8)
	--	OR  (TEMP.evaluation_step IN(4,5))
	--	)
	--	THEN ISNULL(F0121_4.evaluation_comment,'')
	--	ELSE ''
	--END												AS	evaluation_comment_detail_4
	---- ↑↑↑　end edited by viettd 2020/03/25
	,	F0121_0.point_cd							AS  point_cd_0
	,	F0121_1.point_cd							AS  point_cd_1
	,	F0121_2.point_cd							AS  point_cd_2
	,	F0121_3.point_cd							AS  point_cd_3
	,	F0121_4.point_cd							AS  point_cd_4
	FROM W_M0201
	LEFT OUTER JOIN #TEMP_F0100 AS TEMP ON (
		W_M0201.company_cd	=	TEMP.company_cd
	)
	LEFT OUTER JOIN	#TEMP_F0121 AS A ON (
		W_M0201.item_no		=	A.item_no
	)
	LEFT OUTER JOIN F0121 AS F0121_5 ON (
		W_M0201.company_cd	=	F0121_5.company_cd
	AND	@P_fiscal_year		=	F0121_5.fiscal_year
	AND	TEMP.employee_cd	=	F0121_5.employee_cd
	AND	@P_sheet_cd			=	F0121_5.sheet_cd	
	AND	A.evaluation_step	=	F0121_5.evaluation_step
	AND	W_M0201.item_no		=	F0121_5.item_no
	)
	LEFT OUTER JOIN F0121 AS F0121_0 ON (
		W_M0201.company_cd	=	F0121_0.company_cd
	AND	@P_fiscal_year		=	F0121_0.fiscal_year
	AND	TEMP.employee_cd	=	F0121_0.employee_cd
	AND	@P_sheet_cd			=	F0121_0.sheet_cd	
	AND	0					=	F0121_0.evaluation_step
	AND	W_M0201.item_no		=	F0121_0.item_no
	)		
	LEFT OUTER JOIN F0121 AS F0121_1 ON (
		W_M0201.company_cd			=	F0121_1.company_cd
	AND	@P_fiscal_year				=	F0121_1.fiscal_year
	AND	TEMP.employee_cd			=	F0121_1.employee_cd
	AND	@P_sheet_cd					=	F0121_1.sheet_cd	
	AND	1							=	F0121_1.evaluation_step
	AND	W_M0201.item_no				=	F0121_1.item_no
	)
	LEFT OUTER JOIN F0121 AS F0121_2 ON (
		W_M0201.company_cd			=	F0121_2.company_cd
	AND	@P_fiscal_year				=	F0121_2.fiscal_year
	AND	TEMP.employee_cd			=	F0121_2.employee_cd
	AND	@P_sheet_cd					=	F0121_2.sheet_cd	
	AND	2							=	F0121_2.evaluation_step
	AND	W_M0201.item_no				=	F0121_2.item_no
	)
	LEFT OUTER JOIN F0121 AS F0121_3 ON (
		W_M0201.company_cd			=	F0121_3.company_cd
	AND	@P_fiscal_year				=	F0121_3.fiscal_year
	AND	TEMP.employee_cd			=	F0121_3.employee_cd
	AND	@P_sheet_cd					=	F0121_3.sheet_cd	
	AND	3							=	F0121_3.evaluation_step
	AND	W_M0201.item_no				=	F0121_3.item_no
	)
	LEFT OUTER JOIN F0121 AS F0121_4 ON (
		W_M0201.company_cd			=	F0121_4.company_cd
	AND	@P_fiscal_year				=	F0121_4.fiscal_year
	AND	TEMP.employee_cd			=	F0121_4.employee_cd
	AND	@P_sheet_cd					=	F0121_4.sheet_cd	
	AND	4							=	F0121_4.evaluation_step
	AND	W_M0201.item_no				=	F0121_4.item_no
	)
	WHERE 
		W_M0201.company_cd		=	@P_company_cd
	AND	W_M0201.fiscal_year		=	@P_fiscal_year
	AND	W_M0201.sheet_cd		=	@P_sheet_cd
	AND	W_M0201.del_datetime is null --2018.11.28 add by yamazaki
	--[1]
	SELECT 
		TEMP.item_no				
	,	TEMP.item_detail_1		
	,	TEMP.item_detail_2		
	,	TEMP.item_detail_3		
	,	TEMP.weight				
	,	CASE 
			WHEN ISNULL(W_M0110.betting_rate,0) = 0
			THEN 1
			ELSE ISNULL(W_M0110.betting_rate,0)
		END												AS	betting_rate
	,	ISNULL(F0111.self_progress_comment,'')			AS	self_progress_comment	-- add by viettd 2021/12/01
	,	ISNULL(F0111.progress_comment,'')				AS	progress_comment		-- add by viettd 2020/10/09
	,	TEMP.evaluation_comment	
	--,	evaluation_comment_detail
	,	TEMP.evaluation_comment_detail_1
	,	TEMP.evaluation_comment_detail_2
	,	TEMP.evaluation_comment_detail_3
	,	TEMP.evaluation_comment_detail_4	
	,	TEMP.point_cd_0	
	,	CASE
			WHEN ISNULL(M0121_0.point_nm,'')	<>	''
			THEN ISNULL(M0121_0.point_nm,'')
			ELSE CONVERT(NVARCHAR(10),ISNULL(M0121_0.point,0))				
		END						AS	point_nm_0	
	,	TEMP.point_cd_1	
	,	CASE
			WHEN ISNULL(M0121_1.point_nm,'')	<>	''
			THEN ISNULL(M0121_1.point_nm,'')
			ELSE CONVERT(NVARCHAR(10),ISNULL(M0121_1.point,0))				
		END						AS	point_nm_1			
	,	TEMP.point_cd_2	
	,	CASE
			WHEN ISNULL(M0121_2.point_nm,'')	<>	''
			THEN ISNULL(M0121_2.point_nm,'')
			ELSE CONVERT(NVARCHAR(10),ISNULL(M0121_2.point,0))				
		END						AS	point_nm_2			
	,	TEMP.point_cd_3	
	,	CASE
			WHEN ISNULL(M0121_3.point_nm,'')	<>	''
			THEN ISNULL(M0121_3.point_nm,'')
			ELSE CONVERT(NVARCHAR(10),ISNULL(M0121_3.point,0))				
		END						AS	point_nm_3	
	,	TEMP.point_cd_4	
	,	CASE
			WHEN ISNULL(M0121_4.point_nm,'')	<>	''
			THEN ISNULL(M0121_4.point_nm,'')
			ELSE CONVERT(NVARCHAR(10),ISNULL(M0121_4.point,0))				
		END						AS	point_nm_4		
	FROM #TEMP_W_M0201 AS TEMP
	LEFT OUTER JOIN W_M0121 AS M0121_0 ON (
		@P_company_cd		=	M0121_0.company_cd
	AND	@P_fiscal_year		=	M0121_0.fiscal_year	
	AND	@point_kinds		=	M0121_0.point_kinds	
	AND	TEMP.point_cd_0		=	M0121_0.point_cd
	)
	LEFT OUTER JOIN W_M0121 AS M0121_1 ON (
		TEMP.point_cd_1		=	M0121_1.point_cd
	AND	@P_company_cd		=	M0121_1.company_cd	
	AND	@P_fiscal_year		=	M0121_1.fiscal_year	
	AND	@point_kinds		=	M0121_1.point_kinds	
	)
	LEFT OUTER JOIN W_M0121 AS M0121_2 ON (
		@P_company_cd		=	M0121_2.company_cd	
	AND	@P_fiscal_year		=	M0121_2.fiscal_year	
	AND	@point_kinds		=	M0121_2.point_kinds	
	AND	TEMP.point_cd_2		=	M0121_2.point_cd
	)
	LEFT OUTER JOIN W_M0121 AS M0121_3 ON (
		@P_company_cd		=	M0121_3.company_cd
	AND	@P_fiscal_year		=	M0121_3.fiscal_year		
	AND	@point_kinds		=	M0121_3.point_kinds
	AND	TEMP.point_cd_3		=	M0121_3.point_cd	
	)
	LEFT OUTER JOIN W_M0121 AS M0121_4 ON (
		@P_company_cd		=	M0121_4.company_cd	
	AND	@P_fiscal_year		=	M0121_4.fiscal_year	
	AND	@point_kinds		=	M0121_4.point_kinds	
	AND	TEMP.point_cd_4		=	M0121_4.point_cd
	)
	LEFT OUTER JOIN F0111 ON (
		@P_company_cd					=	F0111.company_cd
	AND @P_fiscal_year					=	F0111.fiscal_year
	AND @P_employee_cd					=	F0111.employee_cd
	AND @P_sheet_cd						=	F0111.sheet_cd
	AND TEMP.item_no					=	F0111.item_no
	AND F0111.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0110 ON (
		F0111.company_cd				=	W_M0110.company_cd
	AND @P_fiscal_year					=	W_M0110.fiscal_year
	AND F0111.challenge_level			=	W_M0110.challenge_level
	)
	--[2] COMBOX
	SELECT 
		ISNULL(point_cd,0)		AS	point_cd
	,	CASE
			WHEN ISNULL(point_nm,'')	<>	''
			THEN ISNULL(point_nm,'')
			ELSE CONVERT(NVARCHAR(10),ISNULL(point,0))				
		END						AS	point_nm
	,	ISNULL(point,0)			AS	point
	FROM W_M0121	
	WHERE
		W_M0121.company_cd	=	@P_company_cd
	AND	W_M0121.fiscal_year	=	@P_fiscal_year
	AND	W_M0121.point_kinds	=	@point_kinds
	AND	W_M0121.del_datetime	IS NULL
	--[3] 合計
	SELECT 
		SUM(ISNULL(F0120_0.point_sum,0))		AS TOTAL_0
	,	SUM(ISNULL(F0120_1.point_sum,0))		AS TOTAL_1
	,	SUM(ISNULL(F0120_2.point_sum,0))		AS TOTAL_2
	,	SUM(ISNULL(F0120_3.point_sum,0))		AS TOTAL_3
	,	SUM(ISNULL(F0120_4.point_sum,0))		AS TOTAL_4
	FROM #TEMP_F0100 AS TEMP
	LEFT OUTER JOIN F0120 AS F0120_0 ON (
		@P_company_cd				=	F0120_0.company_cd
	AND	@P_fiscal_year				=	F0120_0.fiscal_year
	AND	TEMP.employee_cd			=	F0120_0.employee_cd
	AND	@P_sheet_cd					=	F0120_0.sheet_cd
	AND	0							=	F0120_0.evaluation_step	
	)
	LEFT OUTER JOIN F0120 AS F0120_1 ON (
		@P_company_cd				=	F0120_1.company_cd
	AND	@P_fiscal_year				=	F0120_1.fiscal_year
	AND	TEMP.employee_cd			=	F0120_1.employee_cd
	AND	@P_sheet_cd					=	F0120_1.sheet_cd
	AND	1							=	F0120_1.evaluation_step	
	)
	LEFT OUTER JOIN F0120 AS F0120_2 ON (
		@P_company_cd				=	F0120_2.company_cd
	AND	@P_fiscal_year				=	F0120_2.fiscal_year
	AND	TEMP.employee_cd			=	F0120_2.employee_cd
	AND	@P_sheet_cd					=	F0120_2.sheet_cd
	AND	2							=	F0120_2.evaluation_step	
	)
	LEFT OUTER JOIN F0120 AS F0120_3 ON (
		@P_company_cd				=	F0120_3.company_cd
	AND	@P_fiscal_year				=	F0120_3.fiscal_year
	AND	TEMP.employee_cd			=	F0120_3.employee_cd
	AND	@P_sheet_cd					=	F0120_3.sheet_cd
	AND	3							=	F0120_3.evaluation_step	
	)
	LEFT OUTER JOIN F0120 AS F0120_4 ON (
		@P_company_cd				=	F0120_4.company_cd
	AND	@P_fiscal_year				=	F0120_4.fiscal_year
	AND	TEMP.employee_cd			=	F0120_4.employee_cd
	AND	@P_sheet_cd					=	F0120_4.sheet_cd
	AND	4							=	F0120_4.evaluation_step	
	)
	--[4] F0120
	SELECT 
		ISNULL(F0120_0.evaluation_comment,'')	AS	evaluation_comment_0
	,	ISNULL(F0120_1.evaluation_comment,'')	AS	evaluation_comment_1
	,	ISNULL(F0120_2.evaluation_comment,'')	AS	evaluation_comment_2
	,	ISNULL(F0120_3.evaluation_comment,'')	AS	evaluation_comment_3
	,	ISNULL(F0120_4.evaluation_comment,'')	AS	evaluation_comment_4
	FROM #TEMP_F0100 AS TEMP
	LEFT OUTER JOIN F0120 AS F0120_0 ON (
		@P_company_cd				=	F0120_0.company_cd
	AND	@P_fiscal_year				=	F0120_0.fiscal_year
	AND	TEMP.employee_cd			=	F0120_0.employee_cd
	AND	@P_sheet_cd					=	F0120_0.sheet_cd
	AND	0							=	F0120_0.evaluation_step	
	)
	LEFT OUTER JOIN F0120 AS F0120_1 ON (
		@P_company_cd				=	F0120_1.company_cd
	AND	@P_fiscal_year				=	F0120_1.fiscal_year
	AND	TEMP.employee_cd			=	F0120_1.employee_cd
	AND	@P_sheet_cd					=	F0120_1.sheet_cd
	AND	1							=	F0120_1.evaluation_step	
	)
	LEFT OUTER JOIN F0120 AS F0120_2 ON (
		@P_company_cd				=	F0120_2.company_cd
	AND	@P_fiscal_year				=	F0120_2.fiscal_year
	AND	TEMP.employee_cd			=	F0120_2.employee_cd
	AND	@P_sheet_cd					=	F0120_2.sheet_cd
	AND	2							=	F0120_2.evaluation_step	
	)
	LEFT OUTER JOIN F0120 AS F0120_3 ON (
		@P_company_cd				=	F0120_3.company_cd
	AND	@P_fiscal_year				=	F0120_3.fiscal_year
	AND	TEMP.employee_cd			=	F0120_3.employee_cd
	AND	@P_sheet_cd					=	F0120_3.sheet_cd
	AND	3							=	F0120_3.evaluation_step	
	)
	LEFT OUTER JOIN F0120 AS F0120_4 ON (
		@P_company_cd				=	F0120_4.company_cd
	AND	@P_fiscal_year				=	F0120_4.fiscal_year
	AND	TEMP.employee_cd			=	F0120_4.employee_cd
	AND	@P_sheet_cd					=	F0120_4.sheet_cd
	AND	4							=	F0120_4.evaluation_step	
	)
	--[5] M0121
	SELECT	
		CASE
			WHEN ISNULL(point_nm,'')	<>	''
			THEN ISNULL(point_nm,'')
			ELSE CONVERT(NVARCHAR(10),ISNULL(point,0))				
		END	point_nm
	,	point_criteria
	FROM W_M0121
	WHERE 
		W_M0121.company_cd	=	@P_company_cd
	AND	W_M0121.fiscal_year	=	@P_fiscal_year
	AND	W_M0121.point_kinds	=	@point_kinds
	AND	W_M0121.del_datetime	IS NULL
	ORDER BY W_M0121.point_cd 
	-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- GET STATUS 
	-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--■ 被評価者
	IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE evaluation_step	= 0)		
	BEGIN
		-- 初期状態 (BUTTON)
		IF	@status_cd	=	0	
		BEGIN
			--SET
			SET @detail_progress_comment_display_typ_flg		= 0 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09 
			SET @detail_self_progress_comment_display_typ_flg	= 0 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			-- 面談がある
			IF @interview_use_typ	= 1 
			BEGIN	
				SELECT	
					@memoryButton					=	0
				,	@saveButton						=	0
				,	@listItemFLG0					=	0	 -- 0.NOT VIEW 1.DISABLED 2.ENABLED
			END
			ELSE
			BEGIN
				-- 自己評価がある
				IF @evaluation_self_assessment = 1
				BEGIN
					SELECT	
						@memoryButton					=	1
					,	@saveButton						=	1
					,	@listItemFLG0					=	2   -- 0.NOT VIEW 1.DISABLED 2.ENABLED
				END
				ELSE
				BEGIN
					SELECT	
						@memoryButton						=	0
					,	@saveButton							=	0
					,	@listItemFLG0						=	0	-- 0.NOT VIEW 1.DISABLED 2.ENABLED
				END
			END	
		END
		-- １：期首面談済。自己評価中。
		IF	@status_cd	=	1
		BEGIN
			SELECT
				@memoryButton									=	1
			,	@saveButton										=	1		
			,	@listItemFLG0									=	2
			,	@detail_progress_comment_display_typ_flg		=	1 -- 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09		
			,	@detail_self_progress_comment_display_typ_flg	=	2 -- 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01		
		END
		-- ２：自己評価済。一次評価中。 add by viettd 2020/12/08
		IF @status_cd = 2
		BEGIN
			SELECT	
				@listItemFLG0									=	1
			,	@detail_progress_comment_display_typ_flg		=	1 -- 1.DISABLED 2.ENABLED	-- add by viettd 2020/12/08
			,	@detail_self_progress_comment_display_typ_flg	=	2 -- 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		END
		-- 3：一次評価中。~ ８：一次ＦＢ済。本人ＦＢ待ち。
		IF	@status_cd	>	2  AND @status_cd	< 9
		BEGIN
			SELECT	
				@listItemFLG0									=	1
			,	@detail_progress_comment_display_typ_flg		=	1 -- 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	2 -- 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		END	
		-- ９：本人ＦＢ済。ＦＢ面談待ち。~ 10：ＦＢ面談完了＝評価完了
		IF	@status_cd	=	9	OR @status_cd	=	10
		BEGIN
			SELECT
				@listItemFLG0									=	1
			,	@detail_progress_comment_display_typ_flg		=	1 -- 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	2 -- 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			--
			IF @details_feedback_typ	=	1
			BEGIN
				SELECT	
					@evaluation_1_flg					=	1
				,	@evaluation_2_flg					=	1		
				,	@evaluation_3_flg					=	1	
				,	@evaluation_4_flg					=	1	
			END
			IF @comments_feedback_typ	=	1
			BEGIN
				SELECT	
					@evaluation_comment_1_flg		=	1
				,	@evaluation_comment_2_flg		=	1
				,	@evaluation_comment_3_flg		=	1		
				,	@evaluation_comment_4_flg		=	1		
				,	@evaluation_comment_detail_flg_1	=	1	-- add by viettd 2022/12/09
				,	@evaluation_comment_detail_flg_2	=	1	-- add by viettd 2022/12/09
				,	@evaluation_comment_detail_flg_3	=	1	-- add by viettd 2022/12/09
				,	@evaluation_comment_detail_flg_4	=	1	-- add by viettd 2022/12/09

			END
		END
	END
	--■ 一次評価者
	IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE evaluation_step	= 1)		
	BEGIN
		--0.初期状態
		IF	@status_cd = 0 
		BEGIN	
			-- @interview_use_typ = 1.期中面談利用あり
			IF	@interview_use_typ	= 1 
			BEGIN	
				SELECT	
					@memoryButton									=	0
				,	@saveButton										=	0
				,	@listItemFLG0									=	0
				,	@detail_progress_comment_display_typ_flg		=	0	-- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
				,	@detail_self_progress_comment_display_typ_flg	=	0	-- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
				,	@evaluation_comment_detail_flg_1				=	0	-- add by viettd 2019/12/10
				,	@evaluation_comment_detail_flg_2				=	0	-- add by viettd 2019/12/10
				,	@evaluation_comment_detail_flg_3				=	0	-- add by viettd 2019/12/10
				,	@evaluation_comment_detail_flg_4				=	0	-- add by viettd 2019/12/10
				,	@evaluation_1_flg								=	0
				,	@evaluation_comment_1_flg						=	0
			END
			-- @interview_use_typ = 0.期中面談利用なしuk 
			ELSE
			BEGIN
				-- 自己評価がある
				IF @evaluation_self_assessment = 1
				BEGIN
					SELECT	
						@memoryButton									=	0
					,	@saveButton										=	0
					,	@listItemFLG0									=	0
					,	@detail_progress_comment_display_typ_flg		=	0	-- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
					,	@detail_self_progress_comment_display_typ_flg	=	0	-- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
					,	@evaluation_comment_detail_flg_1				=	0	-- add by viettd 2019/12/10
					,	@evaluation_comment_detail_flg_2				=	0	-- add by viettd 2019/12/10
					,	@evaluation_comment_detail_flg_3				=	0	-- add by viettd 2019/12/10
					,	@evaluation_comment_detail_flg_4				=	0	-- add by viettd 2019/12/10
					,	@evaluation_1_flg								=	0
					,	@evaluation_comment_1_flg						=	0
				END
				-- 自己評価がなし
				ELSE
				BEGIN
					SELECT	
						@memoryButton									=	1
					,	@saveButton										=	1
					,	@listItemFLG0									=	1
					,	@detail_progress_comment_display_typ_flg		=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
					,	@detail_self_progress_comment_display_typ_flg	=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
					,	@evaluation_comment_detail_flg_1				=	2 -- add by viettd 2019/12/10
					,	@evaluation_1_flg								=	2
					,	@evaluation_comment_1_flg						=	2
				END
			END
		END
		--１：期首面談済。自己評価中。
		IF @status_cd = 1
		BEGIN
			SELECT 
				@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01	
		END
		-- 2.一次評価中
		IF @status_cd =	2 
		BEGIN
			SELECT
				@memoryButton									=	1
			,	@saveButton										=	1		
			,	@listItemFLG0									=	1
			,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01	
			,	@evaluation_comment_detail_flg_1				=	2	-- add by viettd 2019/12/10
			,	@evaluation_1_flg								=	2
			,	@evaluation_comment_1_flg						=	2	
		END
		-- 3.二次評価中 ~ ７：評価確定済。一次ＦＢ待ち。
		IF	@status_cd	> 2 AND @status_cd < 8
		BEGIN
			SELECT	
				@listItemFLG0									=	1
			,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			--
			,	@evaluation_comment_detail_flg_1				=	1	-- add by viettd 2019/12/10
			,	@evaluation_1_flg								=	1
			,	@evaluation_comment_1_flg						=	1
		END	
		-- ８：一次ＦＢ済。本人ＦＢ待ち。
		IF	@status_cd	>= 8
		BEGIN
			SELECT	
				@listItemFLG0									=	1
			,	@detail_progress_comment_display_typ_flg		=	2	-- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	1	-- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			--
			,	@evaluation_comment_detail_flg_1				=	1	-- add by viettd 2019/12/10
			,	@evaluation_comment_detail_flg_2				=	1	-- add by viettd 2019/12/10
			,	@evaluation_comment_detail_flg_3				=	1	-- add by viettd 2019/12/10
			,	@evaluation_comment_detail_flg_4				=	1	-- add by viettd 2019/12/10
			,	@evaluation_1_flg								=	1
			,	@evaluation_comment_1_flg						=	1
			,	@evaluation_2_flg								=	1
			,	@evaluation_comment_2_flg						=	1
			,	@evaluation_3_flg								=	1
			,	@evaluation_comment_3_flg						=	1	
			,	@evaluation_4_flg								=	1
			,	@evaluation_comment_4_flg						=	1
		END
	END
	--■ 二次評価者
	IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE evaluation_step	= 2)		
	BEGIN
		-- 3.二次評価中
		IF @status_cd	=	3 
		BEGIN
			SELECT
				@memoryButton									=	1
			,	@saveButton										=	1		
			,	@listItemFLG0									=	1
			,	@detail_progress_comment_display_typ_flg		=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			--
			,	@evaluation_comment_detail_flg_1				=	1
			,	@evaluation_comment_detail_flg_2				=	2
			,	@evaluation_1_flg								=	1
			,	@evaluation_comment_1_flg						=	1
			,	@evaluation_2_flg								=	2
			,	@evaluation_comment_2_flg						=	2	
		END
		IF	@status_cd	>	3  AND @status_cd < 8
		BEGIN
			SELECT	
				@listItemFLG0									=	1
			,	@detail_progress_comment_display_typ_flg		=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			--			
			,	@evaluation_comment_detail_flg_1				=	1
			,	@evaluation_comment_detail_flg_2				=	1
			,	@evaluation_1_flg								=	1
			,	@evaluation_comment_1_flg						=	1
			,	@evaluation_2_flg								=	1
			,	@evaluation_comment_2_flg						=	1	
		END	
		IF	@status_cd	>= 8
		BEGIN
			SELECT	
				@listItemFLG0									=	1
			,	@detail_progress_comment_display_typ_flg		=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			--	
			,	@evaluation_comment_detail_flg_1				=	1
			,	@evaluation_comment_detail_flg_2				=	1
			,	@evaluation_comment_detail_flg_3				=	1
			,	@evaluation_comment_detail_flg_4				=	1
			,	@evaluation_1_flg								=	1
			,	@evaluation_comment_1_flg						=	1
			,	@evaluation_2_flg								=	1
			,	@evaluation_comment_2_flg						=	1
			,	@evaluation_3_flg								=	1
			,	@evaluation_comment_3_flg						=	1	
			,	@evaluation_4_flg								=	1
			,	@evaluation_comment_4_flg						=	1
		END
	END
	--■ 三次評価者
	IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE evaluation_step	= 3)		
	BEGIN
		-- ４.三次評価中。
		IF @status_cd	=	4 
		BEGIN
			SELECT
				@memoryButton									=	1
			,	@saveButton										=	1		
			,	@listItemFLG0									=	1
			,	@detail_progress_comment_display_typ_flg		=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			--
			,	@evaluation_comment_detail_flg_1				=	1
			,	@evaluation_comment_detail_flg_2				=	1
			,	@evaluation_comment_detail_flg_3				=	2
			,	@evaluation_1_flg								=	1
			,	@evaluation_comment_1_flg						=	1
			,	@evaluation_2_flg								=	1
			,	@evaluation_comment_2_flg						=	1	
			,	@evaluation_3_flg								=	2
			,	@evaluation_comment_3_flg						=	2
		END
		-- ４.三次評価中。 & 8.一次ＦＢ済。本人ＦＢ待ち。
		IF	@status_cd	>	4  AND @status_cd < 8
		BEGIN
			SELECT	
				@listItemFLG0									=	1
			,	@detail_progress_comment_display_typ_flg		=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			--
			,	@evaluation_comment_detail_flg_1				=	1
			,	@evaluation_comment_detail_flg_2				=	1
			,	@evaluation_comment_detail_flg_3				=	1
			,	@evaluation_1_flg								=	1
			,	@evaluation_comment_1_flg						=	1
			,	@evaluation_2_flg								=	1
			,	@evaluation_comment_2_flg						=	1
			,	@evaluation_3_flg								=	1
			,	@evaluation_comment_3_flg						=	1	
		END	
		-- 8.一次ＦＢ済。本人ＦＢ待ち。
		IF	@status_cd	>= 8
		BEGIN
			SELECT	
				@listItemFLG0									=	1
			,	@detail_progress_comment_display_typ_flg		=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			--
			,	@evaluation_comment_detail_flg_1				=	1
			,	@evaluation_comment_detail_flg_2				=	1
			,	@evaluation_comment_detail_flg_3				=	1
			,	@evaluation_comment_detail_flg_4				=	1
			,	@evaluation_1_flg								=	1
			,	@evaluation_comment_1_flg						=	1
			,	@evaluation_2_flg								=	1
			,	@evaluation_comment_2_flg						=	1
			,	@evaluation_3_flg								=	1
			,	@evaluation_comment_3_flg						=	1	
			,	@evaluation_4_flg								=	1
			,	@evaluation_comment_4_flg						=	1
		END
	END
	--■ 四次評価者
	IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE evaluation_step	= 4)		
	BEGIN
		-- ５.四次評価中。
		IF @status_cd =	5 
		BEGIN
			SELECT
				@memoryButton									=	1
			,	@saveButton										=	1		
			,	@listItemFLG0									=	1
			,	@detail_progress_comment_display_typ_flg		=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			--			
			,	@evaluation_comment_detail_flg_1				=	1
			,	@evaluation_comment_detail_flg_2				=	1
			,	@evaluation_comment_detail_flg_3				=	1
			,	@evaluation_comment_detail_flg_4				=	2
			,	@evaluation_1_flg								=	1
			,	@evaluation_comment_1_flg						=	1
			,	@evaluation_2_flg								=	1
			,	@evaluation_comment_2_flg						=	1	
			,	@evaluation_3_flg								=	1
			,	@evaluation_comment_3_flg						=	1
			,	@evaluation_4_flg								=	2
			,	@evaluation_comment_4_flg						=	2
		END
		IF	@status_cd	>	5 
		BEGIN
			SELECT	
				@listItemFLG0									=	1
			,	@detail_progress_comment_display_typ_flg		=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			--			
			,	@evaluation_comment_detail_flg_1				=	1
			,	@evaluation_comment_detail_flg_2				=	1
			,	@evaluation_comment_detail_flg_3				=	1
			,	@evaluation_comment_detail_flg_4				=	1
			,	@evaluation_1_flg								=	1
			,	@evaluation_comment_1_flg						=	1
			,	@evaluation_2_flg								=	1
			,	@evaluation_comment_2_flg						=	1
			,	@evaluation_3_flg								=	1
			,	@evaluation_comment_3_flg						=	1	
			,	@evaluation_4_flg								=	1
			,	@evaluation_comment_4_flg						=	1
		END	
	END
	--■ 管理者
	IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE evaluation_step	= 5)		
	BEGIN
		-- 0 : 初期状態
		IF	@status_cd	=	0	
		BEGIN
			SELECT
				@detail_progress_comment_display_typ_flg		=	0 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	0 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			--
			IF	@interview_use_typ	= 1 
			BEGIN	
				SELECT	
					@memoryButton									=	0
				,	@saveButton										=	0
				,	@listItemFLG0									=	0
				,	@evaluation_comment_detail_flg_1				=	0
				,	@evaluation_comment_detail_flg_2				=	0
				,	@evaluation_comment_detail_flg_3				=	0
				,	@evaluation_comment_detail_flg_4				=	0
				,	@evaluation_1_flg								=	0
				,	@evaluation_comment_1_flg						=	0
			END
			ELSE
			BEGIN
				IF @evaluation_self_assessment = 1
				BEGIN
					SELECT	
						@memoryButton									=	1
					,	@saveButton										=	1
					,	@listItemFLG0									=	2
					,	@evaluation_comment_detail_flg_1				=	0
					,	@evaluation_comment_detail_flg_2				=	0
					,	@evaluation_comment_detail_flg_3				=	0
					,	@evaluation_comment_detail_flg_4				=	0
					,	@evaluation_1_flg								=	0
					,	@evaluation_comment_1_flg						=	0
				END
				ELSE
				BEGIN
					SELECT	
						@memoryButton									=	1
					,	@saveButton										=	1
					,	@listItemFLG0									=	1
					,	@evaluation_comment_detail_flg_1				=	2
					,	@evaluation_1_flg								=	2
					,	@evaluation_comment_1_flg						=	2
				END
			END
		END
		-- １：期首面談済。自己評価中。
		IF @status_cd	=	1 
		BEGIN
			SELECT
				@memoryButton									=	1
			,	@saveButton										=	1		
			,	@listItemFLG0									=	2
			,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		END
		-- ２：自己評価済。一次評価中。
		IF @status_cd	=	2 
		BEGIN
			SELECT
				@memoryButton									=	1
			,	@saveButton										=	1		
			,	@listItemFLG0									=	2
			,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			,	@evaluation_comment_detail_flg_1				=	2
			,	@evaluation_1_flg								=	2
			,	@evaluation_comment_1_flg						=	2	
		END
		-- ３：一次評価済。二次評価中。
		IF @status_cd	=	3 
		BEGIN
			SELECT
				@memoryButton									=	1
			,	@saveButton										=	1		
			,	@listItemFLG0									=	2
			,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			,	@evaluation_comment_detail_flg_1				=	2
			,	@evaluation_comment_detail_flg_2				=	2
			,	@evaluation_1_flg								=	2
			,	@evaluation_comment_1_flg						=	2
			,	@evaluation_2_flg								=	2
			,	@evaluation_comment_2_flg						=	2	
		END
		-- ４：二次評価済。三次評価中。
		IF @status_cd	=	4 
		BEGIN
			SELECT
				@memoryButton									=	1
			,	@saveButton										=	1
			,	@listItemFLG0									=	2
			,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			,	@evaluation_comment_detail_flg_1				=	2
			,	@evaluation_comment_detail_flg_2				=	2
			,	@evaluation_comment_detail_flg_3				=	2
			,	@evaluation_1_flg								=	2
			,	@evaluation_comment_1_flg						=	2
			,	@evaluation_2_flg								=	2
			,	@evaluation_comment_2_flg						=	2	
			,	@evaluation_3_flg								=	2
			,	@evaluation_comment_3_flg						=	2
		END
		-- ５：三次評価済。四次評価中。
		IF @status_cd	=	5 
		BEGIN
			SELECT
				@memoryButton									=	1
			,	@saveButton										=	1		
			,	@listItemFLG0									=	2
			,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			,	@evaluation_comment_detail_flg_1				=	2
			,	@evaluation_comment_detail_flg_2				=	2
			,	@evaluation_comment_detail_flg_3				=	2
			,	@evaluation_comment_detail_flg_4				=	2
			,	@evaluation_1_flg								=	2
			,	@evaluation_comment_1_flg						=	2
			,	@evaluation_2_flg								=	2
			,	@evaluation_comment_2_flg						=	2	
			,	@evaluation_3_flg								=	2
			,	@evaluation_comment_3_flg						=	2
			,	@evaluation_4_flg								=	2
			,	@evaluation_comment_4_flg						=	2
		END
		-- ６：四次評価済。評価確定待ち。 ~ 10：ＦＢ面談完了＝評価完了
		IF	@status_cd	>= 6
		BEGIN
			SELECT
				@memoryButton									=	0
			,	@saveButton										=	0		
			,	@listItemFLG0									=	1
			,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
			,	@detail_self_progress_comment_display_typ_flg	=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			,	@evaluation_comment_detail_flg_1				=	1
			,	@evaluation_comment_detail_flg_2				=	1
			,	@evaluation_comment_detail_flg_3				=	1
			,	@evaluation_comment_detail_flg_4				=	1
			,	@evaluation_1_flg								=	1
			,	@evaluation_comment_1_flg						=	1
			,	@evaluation_2_flg								=	1
			,	@evaluation_comment_2_flg						=	1
			,	@evaluation_3_flg								=	1
			,	@evaluation_comment_3_flg						=	1
			,	@evaluation_4_flg								=	1
			,	@evaluation_comment_4_flg						=	1
		END
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- add by viettd 2021/12/01
	-- 進捗コメント入力
	-- 1.自己評価中  & 2.一次評価中
	IF @status_cd IN (1,2)
	BEGIN
		SELECT 
			@progress_comment_display_status				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status1				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status2				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status3				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status4				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_self_progress_comment_display_typ_flg	=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_progress_comment_display_typ_flg		=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		-- RATER 1
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_1 = @employee_cd_login)
		BEGIN
			SELECT 
			@progress_comment_display_status1				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01	
		END
		-- RATER 2
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_2 = @employee_cd_login)
		BEGIN
			SELECT 
			@progress_comment_display_status2				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		END
		-- RATER 3
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_3 = @employee_cd_login)
		BEGIN
			SELECT 
			@progress_comment_display_status3				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		END
		-- RATER 4
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_4 = @employee_cd_login)
		BEGIN
			SELECT 
			@progress_comment_display_status4				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		END
		--■ 管理者
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE evaluation_step	= 5)
		BEGIN
			SELECT 
			@progress_comment_display_status				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status1				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status2				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status3				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status4				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_self_progress_comment_display_typ_flg	=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		END
	END
	ELSE IF @status_cd = 3	-- 3.二次評価中
	BEGIN
		SELECT 
			@progress_comment_display_status				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status1				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status2				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status3				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status4				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_progress_comment_display_typ_flg		=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01	
		,	@detail_self_progress_comment_display_typ_flg	=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01	
		-- RATER 1
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_1 = @employee_cd_login)
		BEGIN
			SELECT 
			@progress_comment_display_status1				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		END
		-- RATER 2
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_2 = @employee_cd_login)
		BEGIN
			SELECT 
				@progress_comment_display_status2				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			-- IF 二次評価者は一次評価者と同様
			IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_1 = @employee_cd_login)
			BEGIN
				SELECT 
				@progress_comment_display_status1				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			END
		END
		-- RATER 3
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_3 = @employee_cd_login)
		BEGIN
			SELECT 
			@progress_comment_display_status3				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		END
		-- RATER 4
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_4 = @employee_cd_login)
		BEGIN
			SELECT 
			@progress_comment_display_status4				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		END
		--■ 管理者
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE evaluation_step	= 5)
		BEGIN
			SELECT 
			@progress_comment_display_status				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status1				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status2				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status3				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status4				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_self_progress_comment_display_typ_flg	=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		END
	END
	ELSE IF @status_cd = 4	-- 4.三次評価中
	BEGIN
		SELECT 
			@progress_comment_display_status				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status1				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status2				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status3				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status4				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_self_progress_comment_display_typ_flg	=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_progress_comment_display_typ_flg		=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		-- RATER 1
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_1 = @employee_cd_login)
		BEGIN
			SELECT 
			@progress_comment_display_status1				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		END
		-- RATER 2
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_2 = @employee_cd_login)
		BEGIN
			SELECT 
				@progress_comment_display_status2				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			-- IF 二次評価者は一次評価者と同様
			IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_1 = @employee_cd_login)
			BEGIN
				SELECT 
					@progress_comment_display_status1				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
				,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			END
		END
		-- RATER 3
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_3 = @employee_cd_login)
		BEGIN
			SELECT 
				@progress_comment_display_status3				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			-- IF 三次評価者は一次評価者と同様
			IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_1 = @employee_cd_login)
			BEGIN
				SELECT 
				@progress_comment_display_status1				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			END
			-- IF 三次評価者は二次評価者と同様
			IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_2 = @employee_cd_login)
			BEGIN
				SELECT 
				@progress_comment_display_status2				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			END
		END
		-- RATER 4
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_4 = @employee_cd_login)
		BEGIN
			SELECT 
			@progress_comment_display_status4				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		END
		--■ 管理者
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE evaluation_step	= 5)
		BEGIN
			SELECT 
			@progress_comment_display_status				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status1				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status2				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status3				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status4				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_self_progress_comment_display_typ_flg	=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		END
	END
	ELSE IF @status_cd >= 5	-- 5.四次評価中
	BEGIN
		SELECT 
			@progress_comment_display_status				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status1				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status2				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status3				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status4				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_self_progress_comment_display_typ_flg	=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_progress_comment_display_typ_flg		=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		-- RATER 1
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_1 = @employee_cd_login)
		BEGIN
			SELECT 
			@progress_comment_display_status1				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		END
		-- RATER 2
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_2 = @employee_cd_login)
		BEGIN
			SELECT 
			@progress_comment_display_status2				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			-- IF 二次評価者は一次評価者と同様
			IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_1 = @employee_cd_login)
			BEGIN
				SELECT 
				@progress_comment_display_status1				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			END
		END
		-- RATER 3
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_3 = @employee_cd_login)
		BEGIN
			SELECT 
				@progress_comment_display_status3				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			-- IF 三次評価者は一次評価者と同様
			IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_1 = @employee_cd_login)
			BEGIN
				SELECT 
				@progress_comment_display_status1				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			END
			-- IF 三次評価者は二次評価者と同様
			IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_2 = @employee_cd_login)
			BEGIN
				SELECT 
				@progress_comment_display_status2				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			END
		END
		-- RATER 4
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_4 = @employee_cd_login)
		BEGIN
			SELECT 
				@progress_comment_display_status4				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			-- IF 四次評価者は一次評価者と同様
			IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_1 = @employee_cd_login)
			BEGIN
				SELECT 
				@progress_comment_display_status1				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			END
			-- IF 四次評価者は二次評価者と同様
			IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_2 = @employee_cd_login)
			BEGIN
				SELECT 
				@progress_comment_display_status2				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			END
			-- IF 四次評価者は三次評価者と同様
			IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE rater_employee_cd_3 = @employee_cd_login)
			BEGIN
				SELECT 
				@progress_comment_display_status3				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
			END
		END
		--■ 管理者
		IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE evaluation_step	= 5)
		BEGIN
			SELECT 
			@progress_comment_display_status				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status1				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status2				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status3				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status4				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_self_progress_comment_display_typ_flg	=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_progress_comment_display_typ_flg		=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		END
	END
	--■ 被評価者
	IF EXISTS (SELECT 1 FROM #TEMP_F0100 WHERE employee_cd = @employee_cd_login AND @authority_typ NOT IN (3,4,5))	-- edited by viettd 2022/03/31
	BEGIN
		-- 1.自己評価中
		IF @status_cd >= 1
		BEGIN
			SELECT 
			@progress_comment_display_status				=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status1				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status2				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status3				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status4				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_self_progress_comment_display_typ_flg	=	2 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@detail_progress_comment_display_typ_flg		=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		END
	END
	-- check 自己明細進捗コメント表示区分
	IF @self_progress_comment_display_typ = 0
	BEGIN
		SELECT 
			@progress_comment_display_status	=	0
	END
	-- check 進捗コメント表示区分
	IF @progress_comment_display_typ = 0
	BEGIN
		SELECT 
			@progress_comment_display_status1	=	0
		,	@progress_comment_display_status2	=	0
		,	@progress_comment_display_status3	=	0
		,	@progress_comment_display_status4	=	0
	END
	-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- add by viettd 2020/03/04
	-- 汎用コメント①②⇒会社用は、評価シートマスタで設定をする
	-- 汎用コメント③④⇒評価者用は、一次評価者が入力するときに入力可能
	-- 汎用コメント⑤⑥⑦⇒被評価者用は、被評価者が入力する入力可能
	SET @evaluation_step	=	(SELECT evaluation_step FROM #TEMP_F0100)
	-- save enabled
	--IF @saveButton = 1
	--BEGIN
	--	IF @evaluation_step IN(1,5) -- 一次評価者
	--	BEGIN
	--		SET @generic_comment_status3 = 2 -- ENABLED
	--		SET @generic_comment_status4 = 2 -- ENABLED
	--	END
	--	ELSE IF @evaluation_step IN(0,5)  -- 被評価者
	--	BEGIN
	--		SET @generic_comment_status5 = 2 -- ENABLED
	--		SET @generic_comment_status6 = 2 -- ENABLED
	--		SET @generic_comment_status7 = 2 -- ENABLED
	--	END
	--END
	-- ↓↓↓ edited by viettd 2020/05/15
	-- save enabled
	IF @saveButton = 1
	BEGIN
		-- 一次評価者
		IF @evaluation_step = 1 
		BEGIN
			SET @generic_comment_status3 = 2 -- ENABLED
			SET @generic_comment_status4 = 2 -- ENABLED
		END
		-- 被評価者
		IF @evaluation_step = 0 
		BEGIN
			SET @generic_comment_status5 = 2 -- ENABLED
			SET @generic_comment_status6 = 2 -- ENABLED
			SET @generic_comment_status7 = 2 -- ENABLED
		END
		-- 管理者
		IF @evaluation_step = 5
		BEGIN
			-- １：期首面談済。自己評価中。
			IF @status_cd = 1 
			BEGIN
				SET @generic_comment_status5 = 2 -- ENABLED
				SET @generic_comment_status6 = 2 -- ENABLED
				SET @generic_comment_status7 = 2 -- ENABLED
			END
			-- ２：自己評価済。一次評価中。
			IF @status_cd = 2
			BEGIN
				SET @generic_comment_status3 = 2 -- ENABLED
				SET @generic_comment_status4 = 2 -- ENABLED
			END
		END
	END
	-- ↑↑↑ edited by viettd 2020/05/15
	-- add by viettd 2019/12/10
	-- check in W_M0200
	SELECT 
		@generic_comment_status1	=	CASE 
											WHEN ISNULL(W_M0200.generic_comment_display_typ_1,0) = 1
											THEN @generic_comment_status1
											ELSE 0
										END
	,	@generic_comment_status2	=	CASE 
											WHEN ISNULL(W_M0200.generic_comment_display_typ_2,0) = 1
											THEN @generic_comment_status2
											ELSE 0
										END
	,	@generic_comment_status3	=	CASE 
											WHEN ISNULL(W_M0200.generic_comment_display_typ_3,0) = 1
											THEN @generic_comment_status3
											ELSE 0
										END
	,	@generic_comment_status4	=	CASE 
											WHEN ISNULL(W_M0200.generic_comment_display_typ_4,0) = 1
											THEN @generic_comment_status4
											ELSE 0
										END
	,	@generic_comment_status5	=	CASE 
											WHEN ISNULL(W_M0200.generic_comment_display_typ_5,0) = 1
											THEN @generic_comment_status5
											ELSE 0
										END
	,	@generic_comment_status6	=	CASE 
											WHEN ISNULL(W_M0200.generic_comment_display_typ_6,0) = 1
											THEN @generic_comment_status6
											ELSE 0
										END
	,	@generic_comment_status7	=	CASE 
											WHEN ISNULL(W_M0200.generic_comment_display_typ_7,0) = 1
											THEN @generic_comment_status7
											ELSE 0
										END
	,	@generic_comment_status8	=	CASE 
											WHEN ISNULL(W_M0200.generic_comment_display_typ_8,0) = 1
											THEN @generic_comment_status8
											ELSE 0
										END
	FROM W_M0200 
	WHERE 
		W_M0200.company_cd		=	@P_company_cd
	AND W_M0200.fiscal_year		=	@P_fiscal_year
	AND W_M0200.sheet_cd		=	@P_sheet_cd
	AND W_M0200.del_datetime IS NULL
	--
	SET	@generic_comment_cnt	=	IIF(ISNULL(@generic_comment_status1,0) > 0 , 1 , 0)
								+	IIF(ISNULL(@generic_comment_status2,0) > 0 , 1 , 0)
								+	IIF(ISNULL(@generic_comment_status3,0) > 0 , 1 , 0)
								+	IIF(ISNULL(@generic_comment_status4,0) > 0 , 1 , 0)
								+	IIF(ISNULL(@generic_comment_status5,0) > 0 , 1 , 0)
								+	IIF(ISNULL(@generic_comment_status6,0) > 0 , 1 , 0)
								+	IIF(ISNULL(@generic_comment_status7,0) > 0 , 1 , 0)
								+	IIF(ISNULL(@generic_comment_status8,0) > 0 , 1 , 0)
	-- ↓↓↓ add by viettd 2020/05/18
	EXEC [dbo].SPC_PERMISSION_CHK1 @P_fiscal_year,@P_employee_cd,@P_sheet_cd,@P_user_id,@P_company_cd,1,@chk OUT
	--	0.参照不可　1.参照可能	2.更新可能
	IF @chk IN (0,1)
	BEGIN
		SELECT	
			@memoryButton									=	0
		,	@saveButton										=	0
		,	@listItemFLG0									=	1
		,	@detail_progress_comment_display_typ_flg		=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
		,	@detail_self_progress_comment_display_typ_flg	=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status1				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status2				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status3				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@progress_comment_display_status4				=	1 -- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
		,	@evaluation_comment_detail_flg_1				=	1
		,	@evaluation_comment_detail_flg_2				=	1
		,	@evaluation_comment_detail_flg_3				=	1
		,	@evaluation_comment_detail_flg_4				=	1
		,	@evaluation_1_flg								=	1
		,	@evaluation_comment_1_flg						=	1
		,	@evaluation_2_flg								=	1
		,	@evaluation_comment_2_flg						=	1
		,	@evaluation_3_flg								=	1
		,	@evaluation_comment_3_flg						=	1
		,	@evaluation_4_flg								=	1
		,	@evaluation_comment_4_flg						=	1
		--
		--,	@generic_comment_status1						=	1
		--,	@generic_comment_status2						=	1
		--,	@generic_comment_status3						=	1
		--,	@generic_comment_status4						=	1
		--,	@generic_comment_status5						=	1
		--,	@generic_comment_status6						=	1
		--,	@generic_comment_status7						=	1
		--,	@generic_comment_status8						=	1
	END
	-- ↑↑↑ end add by viettd 2020/05/18
	-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--[6]
	-- add by viettd 2019/12/10
	-- 評価シートの評価開始日以前は処理ボタンは使用不可とする。（戻るボタンのみ使用可能）
	-- 画面.年度=F0300.fiscal_year、M0200.evaluation_period=F0300.period_detail_no で F0300を参照し、本日<MIN(F0300.start_date) の場合は処理ボタンは使用不可。
	SET @start_date = (
		SELECT
			F0300.start_date
		FROM F0300
		INNER JOIN W_M0200 ON (
			F0300.company_cd		=	W_M0200.company_cd
		AND F0300.fiscal_year		=	W_M0200.fiscal_year
		AND @P_sheet_cd				=	W_M0200.sheet_cd
		AND F0300.period_detail_no	=	W_M0200.evaluation_period
		AND W_M0200.del_datetime IS NULL
		)
		WHERE
			F0300.company_cd		=	@P_company_cd
		AND F0300.fiscal_year		=	@P_fiscal_year
		AND F0300.status_cd			=	@status_cd			-- add by viettd 2020/08/20 
		AND F0300.category			=	2					-- add by viettd 2020/08/20 2:定性評価
		AND F0300.del_datetime	IS NULL
	)
	-- apply sau
	IF @start_date IS NOT NULL AND  @w_time	< @start_date
	BEGIN
		SET @memoryButton		=	0
		SET @saveButton			=	0
		--SET @interviewButton	=	0		-- comment out by viettd 2020/10/12
	END
	--[6]
	SELECT
		@memoryButton		AS	memoryButton		
	,	@saveButton			AS	confirmButton2						
	,	@interviewButton 	AS	interviewButton		-- 面談記録は随時ボタン押下可能とする。 2019/12/10
	--[7]
	--CHECK rater_employee_cd (not exists)
	IF EXISTS(SELECT 1  FROM #TEMP_F0100 WHERE ISNULL(rater_employee_cd_1,'') ='')
	BEGIN
	SELECT
		@evaluation_1_flg					=	0				
	,	@evaluation_comment_1_flg			=	0
	,	@evaluation_comment_detail_flg_1	=	0
	,	@progress_comment_display_status1	=	0
	END
	IF EXISTS(SELECT 1  FROM #TEMP_F0100 WHERE ISNULL(rater_employee_cd_2,'') ='')
	BEGIN
	SELECT
		@evaluation_2_flg					=	0				
	,	@evaluation_comment_2_flg			=	0
	,	@evaluation_comment_detail_flg_2	=	0
	,	@progress_comment_display_status2	=	0
	END
	IF EXISTS(SELECT 1  FROM #TEMP_F0100 WHERE ISNULL(rater_employee_cd_3,'') ='')
	BEGIN
	SELECT
		@evaluation_3_flg					=	0				
	,	@evaluation_comment_3_flg			=	0
	,	@evaluation_comment_detail_flg_3	=	0
	,	@progress_comment_display_status3	=	0
	END
	IF EXISTS(SELECT 1  FROM #TEMP_F0100 WHERE ISNULL(rater_employee_cd_4,'') ='')
	BEGIN
	SELECT
		@evaluation_4_flg					=	0				
	,	@evaluation_comment_4_flg			=	0
	,	@evaluation_comment_detail_flg_4	=	0
	,	@progress_comment_display_status4	=	0
	END 
	--
	SELECT 	
		@listItemFLG0									AS	listItemFLG0									-- 2.enabled 1.disabled 0.not view 
	,	@detail_progress_comment_display_typ_flg		AS	detail_progress_comment_display_typ_flg			-- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2020/10/09
	,	@detail_self_progress_comment_display_typ_flg	AS	detail_self_progress_comment_display_typ_flg	-- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
	,	@progress_comment_display_status				AS	progress_comment_display_status					-- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
	,	@progress_comment_display_status1				AS	progress_comment_display_status1				-- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
	,	@progress_comment_display_status2				AS	progress_comment_display_status2				-- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
	,	@progress_comment_display_status3				AS	progress_comment_display_status3				-- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
	,	@progress_comment_display_status4				AS	progress_comment_display_status4				-- 0.NOT VIEW 1.DISABLED 2.ENABLED	-- add by viettd 2021/12/01
	,	@evaluation_comment_detail_flg_1				AS	evaluation_comment_detail_flg_1	
	,	@evaluation_comment_detail_flg_2				AS	evaluation_comment_detail_flg_2	
	,	@evaluation_comment_detail_flg_3				AS	evaluation_comment_detail_flg_3	
	,	@evaluation_comment_detail_flg_4				AS	evaluation_comment_detail_flg_4	
	,	@evaluation_1_flg								AS	evaluation_1_flg				
	,	@evaluation_comment_1_flg						AS	evaluation_comment_1_flg		
	,	@evaluation_2_flg								AS	evaluation_2_flg				
	,	@evaluation_comment_2_flg						AS	evaluation_comment_2_flg		
	,	@evaluation_3_flg								AS	evaluation_3_flg				
	,	@evaluation_comment_3_flg						AS	evaluation_comment_3_flg		
	,	@evaluation_4_flg								AS	evaluation_4_flg				
	,	@evaluation_comment_4_flg						AS	evaluation_comment_4_flg	
	,	CASE 
			WHEN 
			(	@evaluation_1_flg	=	0  
			AND @evaluation_2_flg	=	0  
			AND @evaluation_3_flg	=	0 
			AND @evaluation_4_flg	=	0	
			)
			THEN 0
			ELSe 1
		END	AS TotalFLG
	--[8]
	IF	@evaluation_step	=	5
	BEGIN
		IF	@status_cd	IN	(0,1)
		BEGIN
			SET @evaluation_step	=	0
		END	
		IF	@status_cd	=	2
		BEGIN
			SET @evaluation_step	=	1
		END	
		IF	@status_cd	=	3
		BEGIN
			SET @evaluation_step	=	2
		END	
		IF	@status_cd	=	4
		BEGIN
			SET @evaluation_step	=	3
		END
		IF	@status_cd	=	5
		BEGIN
			SET @evaluation_step	=	4
		END
	END
	--
	SELECT
		ISNULL(W_M0200.detail_progress_comment_display_typ,0)		AS	detail_progress_comment_display_typ			--　進捗コメント
	,	ISNULL(W_M0200.detail_comment_display_typ_0,0)				AS	detail_comment_display_typ_0				--　自己評価コメント
	,	ISNULL(W_M0200.detail_comment_display_typ_1,0)				AS	detail_comment_display_typ_1				--　一次評価コメント
	,	ISNULL(W_M0200.detail_comment_display_typ_2,0)				AS	detail_comment_display_typ_2				--　二次評価コメント
	,	ISNULL(W_M0200.detail_comment_display_typ_3,0)				AS	detail_comment_display_typ_3				--　三次評価コメント
	,	ISNULL(W_M0200.detail_comment_display_typ_4,0)				AS	detail_comment_display_typ_4				--　四次評価コメント	
	,	ISNULL(W_M0200.weight_display_typ,0)						AS	weight_display_typ
	,	ISNULL(W_M0200.point_criteria_display_typ,0)				AS	point_criteria_display_typ
	,	ISNULL(W_M0200.total_score_display_typ,0)					AS	total_score_display_typ
	,	ISNULL(W_M0200.evaluation_comment_display_typ,0)			AS	evaluation_comment_display_typ
	,	ISNULL(W_M0200.self_assessment_comment_display_typ,0)		AS	self_assessment_comment_display_typ
	,	ISNULL(W_M0200.details_feedback_typ,0)						AS	details_feedback_typ
	,	ISNULL(W_M0200.comments_feedback_typ,0)						AS	comments_feedback_typ
	,	ISNULL(W_M0200.item_display_typ_1,0)						AS	item_display_typ_1
	,	ISNULL(W_M0200.item_title_1,'')								AS	item_title_1
	,	ISNULL(W_M0200.item_display_typ_2,0)						AS	item_display_typ_2
	,	ISNULL(W_M0200.item_title_2,'')								AS	item_title_2
	,	ISNULL(W_M0200.item_display_typ_3,0)						AS	item_display_typ_3
	,	ISNULL(W_M0200.item_title_3,'')								AS	item_title_3
	--	
	,	ISNULL(W_M0200.evaluation_self_typ,0)						AS	evaluation_self_typ							-- 自己評価利用区分
	,	ISNULL(W_M0200.detail_self_progress_comment_display_typ,0)	AS	detail_self_progress_comment_display_typ	-- 自己明細進捗コメント
	,	ISNULL(W_M0200.self_progress_comment_display_typ,0)			AS	self_progress_comment_display_typ			-- 自己進捗コメント
	,	ISNULL(W_M0200.progress_comment_display_typ,0)				AS	progress_comment_display_typ				-- 進捗コメント
	,	ISNULL(W_M0200.detail_self_progress_comment_title,'')		AS	detail_self_progress_comment_title			-- 自己明細進捗コメントタイトル
	,	ISNULL(W_M0200.detail_progress_comment_title,'')			AS	detail_progress_comment_title				-- 明細進捗コメントタイトル
	,	ISNULL(W_M0200.self_progress_comment_title,'')				AS	self_progress_comment_title					-- 自己進捗コメントタイトル
	,	ISNULL(W_M0200.progress_comment_title,'')					AS	progress_comment_title						-- 進捗コメントタイトル
	--	add by viettd 2019/12/10
	,	@generic_comment_status1									AS	generic_comment_status1
	,	@generic_comment_status2									AS	generic_comment_status2
	,	@generic_comment_status3									AS	generic_comment_status3
	,	@generic_comment_status4									AS	generic_comment_status4
	,	@generic_comment_status5									AS	generic_comment_status5
	,	@generic_comment_status6									AS	generic_comment_status6
	,	@generic_comment_status7									AS	generic_comment_status7
	,	@generic_comment_status8									AS	generic_comment_status8
	,	CASE
			WHEN @generic_comment_cnt = 0
			THEN 100
			ELSE 100/@generic_comment_cnt
		END															AS	generic_comment_width -- VW
	,	ISNULL(W_M0200.generic_comment_title_1,'')					AS	generic_comment_title_1
	,	ISNULL(W_M0200.generic_comment_title_2,'')					AS	generic_comment_title_2
	,	ISNULL(W_M0200.generic_comment_title_3,'')					AS	generic_comment_title_3
	,	ISNULL(W_M0200.generic_comment_title_4,'')					AS	generic_comment_title_4
	,	ISNULL(W_M0200.generic_comment_title_5,'')					AS	generic_comment_title_5
	,	ISNULL(W_M0200.generic_comment_title_6,'')					AS	generic_comment_title_6
	,	ISNULL(W_M0200.generic_comment_title_7,'')					AS	generic_comment_title_7
	,	ISNULL(W_M0200.generic_comment_title_8,'')					AS	generic_comment_title_8
	,	CASE 
			WHEN F0101.company_cd IS NOT NULL
			THEN ISNULL(F0101.generic_comment_1,'')
			ELSE ISNULL(W_M0200.generic_comment_1,'')
		END															AS	generic_comment_1
	,	CASE 
			WHEN F0101.company_cd IS NOT NULL
			THEN ISNULL(F0101.generic_comment_2,'')
			ELSE ISNULL(W_M0200.generic_comment_2,'')
		END															AS	generic_comment_2
	,	CASE 
			WHEN F0101.company_cd IS NOT NULL
			THEN ISNULL(F0101.generic_comment_8,'')
			ELSE ISNULL(W_M0200.generic_comment_8,'')
		END															AS	generic_comment_8
	,	ISNULL(F0101.generic_comment_3,'')							AS	generic_comment_3
	,	ISNULL(F0101.generic_comment_4,'')							AS	generic_comment_4
	,	ISNULL(F0101.generic_comment_5,'')							AS	generic_comment_5
	,	ISNULL(F0101.generic_comment_6,'')							AS	generic_comment_6
	,	ISNULL(F0101.generic_comment_7,'')							AS	generic_comment_7
	,	ISNULL(M0200.upload_file_nm,'')								AS	upload_file
	,	'/uploads/m0170/'+CONVERT(NVARCHAR(10),@P_company_cd)+'/'+ISNULL(M0200.upload_file,'') AS file_adress
	FROM W_M0200 
	LEFT OUTER JOIN F0101 ON (
		W_M0200.company_cd			=	F0101.company_cd
	AND W_M0200.fiscal_year			=	F0101.fiscal_year
	AND @P_employee_cd				=	F0101.employee_cd
	AND @P_sheet_cd					=	F0101.sheet_cd
	AND F0101.del_datetime IS NULL
	)
	LEFT OUTER JOIN M0100 WITH(NOLOCK) ON(
		W_M0200.company_cd	=	M0100.company_cd
	AND M0100.del_datetime IS NULL	
	)
	LEFT OUTER JOIN M0200 WITH(NOLOCK) ON(
		W_M0200.company_cd	=	M0200.company_cd
	AND W_M0200.sheet_cd	=	M0200.sheet_cd
	AND M0200.del_datetime IS NULL
	) 
	WHERE 
		W_M0200.company_cd		=	@P_company_cd 
	AND	W_M0200.fiscal_year		=	@P_fiscal_year
	AND	W_M0200.sheet_cd		=	@P_sheet_cd	
	AND W_M0200.del_datetime IS NULL
	--[9] M0100
	SELECT 
		M0100.evaluation_self_assessment_typ
	,	M0100.evaluation_typ_1	
	,	M0100.evaluation_typ_2	
	,	M0100.evaluation_typ_3	
	,	M0100.evaluation_typ_4	
	-- ↓↓↓　add by viettd 2020/06/23
	--,	CASE
	--		WHEN	(@evaluation_step	IN	(1,5)	AND M0100.evaluation_typ_1	= 1)
	--			OR	(@evaluation_step	IN	(2,5)	AND M0100.evaluation_typ_2	= 1)	
	--			OR	(@evaluation_step	IN	(3,5)	AND M0100.evaluation_typ_3	= 1)
	--			OR	(@evaluation_step	IN	(4,5)	AND M0100.evaluation_typ_4	= 1)
	--			-- add by viettd 2020/03/25
	--			OR	(
	--				@evaluation_step = 0 AND 
	--					(
	--						M0100.evaluation_typ_1 = 1
	--					OR	M0100.evaluation_typ_2 = 1
	--					OR	M0100.evaluation_typ_3 = 1
	--					OR	M0100.evaluation_typ_4 = 1
	--					)
	--				)
	--		THEN	1	
	--		ELSE	0
	--	END									AS evaluation_comment_detail_flg
	-- ↑↑↑　end add by viettd 2020/06/23
	---- edited by viettd 2020/04/29
	,	(
		ISNULL(M0100.evaluation_typ_1,0)
	+	ISNULL(M0100.evaluation_typ_2,0)
	+	ISNULL(M0100.evaluation_typ_3,0)
	+	ISNULL(M0100.evaluation_typ_4,0)		
		)									AS total_score_display_typ	
	FROM M0100
	WHERE 
		M0100.company_cd		=	@P_company_cd
	AND	M0100.del_datetime		IS NULL	
	--[10]
	SELECT 
		ISNULL(M0022.organization_typ,0)		AS	organization_typ
	,	ISNULL(M0022.organization_group_nm,'')	AS	organization_group_nm
	FROM M0022
	WHERE 
		M0022.company_cd		=	@P_company_cd
	AND M0022.use_typ			=	1	-- 利用可能
	AND M0022.del_datetime IS NULL
	--[11]
	INSERT INTO #TABLE_M0310
	SELECT 
		ISNULL(L0040.category,0)
	,	ISNULL(L0040.status_cd,0)
	,	ISNULL(IIF(@w_language= 2,L0040.status_nm_english ,L0040.status_nm),'')
	,	0	
	,	0							-- detail_no
	FROM L0040
	WHERE 
		L0040.category = 2 -- 2.定性評価
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
			#TABLE_M0310.status_cd = 1 -- 1.自己評価中
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