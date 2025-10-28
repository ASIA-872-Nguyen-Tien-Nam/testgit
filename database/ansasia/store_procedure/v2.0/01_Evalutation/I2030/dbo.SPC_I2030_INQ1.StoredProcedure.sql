DROP PROCEDURE [SPC_I2030_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ 
-- EXEC [SPC_I2030_INQ1] '807','2'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	I2030
--*  
--*  作成日/create date			:	2018/09/26				
--*　作成者/creater				:	Longvv								
--*   					
--*  更新日/update date			:	2019/12/10
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgradate ver 1.6
--*   					
--*  更新日/update date			:	2020/03/03
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	期中面談はいつでも入力可能
--*   					
--*  更新日/update date			:	2020/03/16
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	edited evaluation_step
--*   					
--*  更新日/update date			:	2020/03/19
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	change disabled/enabled item + button
--*   					
--*  更新日/update date			:	2020/03/23
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	add (authority_typ=3.管理者) to save
--*   					
--*  更新日/update date			:	2020/03/31
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	when status = 0.未処理
--*   					
--*  更新日/update date			:	2020/04/24
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	fix error when 評価者 = 管理者
--*   					
--*  更新日/update date			:	2020/05/18
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	CHECK PERMISSION OF ROUTER EVALUTATION
--*   					
--*  更新日/update date			:	2020/10/12
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgradate ver 1.7 & 1on1
--*   					
--*  更新日/update date			:	2020/12/03
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	本人コメント（interview_comment_self）項目は制御対象外とする。
--*   					
--*  更新日/update date			:	2021/03/03
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	change control item for new version (制御)
--*   					
--*  更新日/update date			:	2021/12/01
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgradate ver1.8
--*   					
--*  更新日/update date			:	2022/03/31
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	fixbug when authority_typ = 4,5 and is employee
--*   					
--*  更新日/update date			:	2022/08/16
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgradate ver1.9
--* 
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_I2030_INQ1]
	@P_company_cd		SMALLINT		=	0
,	@P_fiscal_year		SMALLINT		=	0	
,	@P_employee_cd		NVARCHAR(10)	=	''
,	@P_sheet_cd			SMALLINT		=	0
,	@P_user_id			NVARCHAR(50)	=	''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@authority_typ					SMALLINT		=	0
	,	@authority_cd					SMALLINT		=	0
	,	@employee_cd_login				NVARCHAR(20)	=	''
	,	@status_cd						SMALLINT		=	0	
	,	@sheet_kbn						TINYINT			=	0	-- 1.目標　2.定性
	,	@w_date							DATE			=	GETDATE()
	,	@evaluation_period				SMALLINT		=	0	
	--
	,	@evaluation_step				SMALLINT		=	0		-- login user typ
	,	@w_評価完了_30日以内				TINYINT			=	0		-- add by viettd 2020/10/12
	,	@w_評価完了_FROM					DATE			=	NULL	-- add by viettd 2020/10/12
	,	@w_評価完了_TO					DATE			=	NULL	-- add by viettd 2020/10/12
	,	@chk							TINYINT			=	0		-- add by viettd 2020/05/18
	,	@w_rater_interview_use_typ		TINYINT			=	0		-- add by viettd 2021/12/01
	,	@w_language						INT				=	1		-- add by vietdt 2022/08/16
	--
	IF object_id('tempdb..#TEMP_F0030', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TEMP_F0030
    END
	--
	IF object_id('tempdb..#BUTTON_TABLE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #BUTTON_TABLE
    END
	--
	IF object_id('tempdb..#RESULT_TABLE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #RESULT_TABLE
    END
	--CREATE TABLE #BUTTON_TABLE
	CREATE	TABLE #BUTTON_TABLE (
		saveButton				SMALLINT		-- 0.disabled 1.enabled 
	)
	--CREATE TABLE #TEMP_F0030
	CREATE	TABLE #TEMP_F0030 (
		ID						BIGINT			IDENTITY (1,1)
	,	company_cd				SMALLINT
	,	employee_cd				NVARCHAR(10)
	,	rater_employee_cd_1		NVARCHAR(10)
	,	rater_employee_cd_2		NVARCHAR(10)
	,	rater_employee_cd_3		NVARCHAR(10)
	,	rater_employee_cd_4		NVARCHAR(10)
	,	evaluation_step			SMALLINT
	)
	-- #RESULT_TABLE add by viettd 2020/03/31
	CREATE TABLE #RESULT_TABLE(
		status_cd									SMALLINT				-- add by viettd 2020/12/03
	,	status_nm									NVARCHAR(100)
	,	period_detail_no							SMALLINT
	,	interview_no								SMALLINT
	,	interview_date								NVARCHAR(10)
	,	interview_comment_self						NVARCHAR(1000)
	,	interview_comment_rater						NVARCHAR(1000)
	,	interview_comment_rater2					NVARCHAR(1000)	-- add by viettd 2021/12/01
	,	interview_comment_rater3					NVARCHAR(1000)	-- add by viettd 2021/12/01
	,	interview_comment_rater4					NVARCHAR(1000)	-- add by viettd 2021/12/01
	,	employee_cd									NVARCHAR(10)
	,	fiscal_year									INT
	,	sheet_cd									SMALLINT
	,	interview_comment_rater_status				TINYINT			-- 一次評価者コメント add by viettd 2020/12/03
	,	interview_comment_rater_status2				TINYINT			-- 二次評価者コメント add by viettd 2021/12/01
	,	interview_comment_rater_status3				TINYINT			-- 三次評価者コメント add by viettd 2021/12/01
	,	interview_comment_rater_status4				TINYINT			-- 四次評価者コメント add by viettd 2021/12/01
	,	rater_employee_cd_1							NVARCHAR(10)	-- 一次評価者 add by viettd 2020/12/01
	,	rater_employee_cd_2							NVARCHAR(10)	-- 二次評価者 add by viettd 2021/12/01
	,	rater_employee_cd_3							NVARCHAR(10)	-- 三次評価者 add by viettd 2021/12/01
	,	rater_employee_cd_4							NVARCHAR(10)	-- 四次評価者 add by viettd 2021/12/01
	,	interview_comment_self_status				TINYINT		-- 本人
	,	interview_date_status						TINYINT		-- 実施日 (0.disabled 1.enabled)
	,	interview_comment_flg						TINYINT		-- 1.自己評価 2.一次評価者 3.管理者
	)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--INSERT DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--SET @evaluation_period
	SELECT
		@evaluation_period	=	M0200.evaluation_period
	,	@sheet_kbn			=	M0200.sheet_kbn
	FROM W_M0200  AS M0200
	WHERE 
		M0200.company_cd	=	@P_company_cd 
	AND M0200.fiscal_year	=	@P_fiscal_year
	AND	M0200.sheet_cd		=	@P_sheet_cd	
	AND M0200.del_datetime IS NULL
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
	-- GET @w_rater_interview_use_typ
	SELECT 
		@w_rater_interview_use_typ = ISNULL(M0100.rater_interview_use_typ,0)
	FROM M0100
	WHERE 
		M0100.company_cd	=	@P_company_cd
	AND M0100.del_datetime IS NULL

	-- ■ #BUTTON_TABLE
	INSERT INTO #BUTTON_TABLE VALUES(0)
	--@status_cd
	SELECT
		@status_cd	=	F0100.status_cd 
	FROM F0100
	WHERE 
		F0100.company_cd	=	@P_company_cd
	AND	F0100.fiscal_year	=	@P_fiscal_year
	AND F0100.employee_cd	=	@P_employee_cd
	AND	F0100.sheet_cd		=	@P_sheet_cd
	AND	F0100.del_datetime	IS NULL
	--↓↓↓ add by viettd 2020/10/12
	SET	@w_評価完了_FROM = (SELECT MAX(F0201.confirm_datetime)	
							FROM F0201
							WHERE 
								F0201.company_cd		=	@P_company_cd
							AND F0201.fiscal_year		=	@P_fiscal_year
							AND F0201.employee_cd		=	@P_employee_cd
							AND F0201.del_datetime IS NULL
							GROUP BY
								F0201.company_cd
							,	F0201.fiscal_year
							,	F0201.employee_cd
							)
	IF @w_評価完了_FROM IS NOT NULL
	BEGIN
		SET @w_評価完了_TO	=	DATEADD(DD,30,@w_評価完了_FROM)
		-- ＦＢ面談は評価完了後30日間は入力可能とする
		IF @w_date >= @w_評価完了_FROM AND @w_date <= @w_評価完了_TO
		BEGIN
			SET @w_評価完了_30日以内		=	1 -- 評価完了_30日以内
		END
	END
	--↑↑↑ end add by viettd 2020/10/12
	INSERT INTO #TEMP_F0030
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
			'I2030'
		,	@sheet_kbn
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
	AND F0100.employee_cd	=	@P_employee_cd
	AND F0100.sheet_cd		=	@P_sheet_cd
	AND	F0100.del_datetime	IS NULL
	-- add by viettd 2021/12/01
	-- 目標：11.本人FB済
	IF @sheet_kbn = 1 AND @status_cd = 11
	BEGIN
		UPDATE #TEMP_F0030 SET 
			evaluation_step = 1
		WHERE 
			#TEMP_F0030.rater_employee_cd_1 = @employee_cd_login
		AND @authority_typ NOT IN (3,4,5)	-- add by viettd 2022/03/31
	END
	-- 定性：9.本人FB済
	IF @sheet_kbn = 2 AND @status_cd = 9
	BEGIN
		UPDATE #TEMP_F0030 SET 
			evaluation_step = 1
		WHERE 
			#TEMP_F0030.rater_employee_cd_1 = @employee_cd_login
		AND @authority_typ NOT IN (3,4,5)	-- add by viettd 2022/03/31
	END
	-- end add by viettd 2021/12/01
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- RESULT 
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--■[0]
	INSERT INTO #RESULT_TABLE
	SELECT 
		ISNULL(M0310.status_cd,0)					AS	status_cd
	,	CASE 
			WHEN ISNULL(M0310.status_nm,'')	<> ''
			THEN ISNULL(M0310.status_nm,'')
			ELSE ISNULL(IIF(@w_language = 2,L0040.status_nm_english,L0040.status_nm),'')	
		END											AS	status_nm
	,	CASE
			WHEN ISNULL(@evaluation_period,0) <> 0
			THEN ISNULL(@evaluation_period,0)
			ELSE F0122.period_detail_no		
		END											AS	period_detail_no
	,	M0310.status_cd								AS	interview_no
	,	IIF(F0122.interview_date IS NOT NULL,CONVERT(NVARCHAR(10),F0122.interview_date,111),NULL)	
													AS	interview_date
	,	ISNULL(F0122.interview_comment_self,'')		AS	interview_comment_self
	,	ISNULL(F0122.interview_comment_rater,'')	AS	interview_comment_rater
	,	ISNULL(F0122.interview_comment_rater2,'')	AS	interview_comment_rater2
	,	ISNULL(F0122.interview_comment_rater3,'')	AS	interview_comment_rater3
	,	ISNULL(F0122.interview_comment_rater4,'')	AS	interview_comment_rater4
	,	TEMP.employee_cd							AS	employee_cd
	,	@P_fiscal_year								AS	fiscal_year
	,	@P_sheet_cd									AS	sheet_cd
	,	0											AS	interview_comment_rater_status
	,	0											AS	interview_comment_rater_status2
	,	0											AS	interview_comment_rater_status3
	,	0											AS	interview_comment_rater_status4
	,	ISNULL(TEMP.rater_employee_cd_1,'')			AS	rater_employee_cd_1
	,	ISNULL(TEMP.rater_employee_cd_2,'')			AS	rater_employee_cd_2
	,	ISNULL(TEMP.rater_employee_cd_3,'')			AS	rater_employee_cd_3
	,	ISNULL(TEMP.rater_employee_cd_4,'')			AS	rater_employee_cd_4
	,	0											AS	interview_comment_self_status
	,	0											AS	interview_date_status
	,	CASE
			WHEN	TEMP.evaluation_step = 0	-- 被評価者
			THEN	1		--自己評価コメント
			WHEN	TEMP.evaluation_step = 1	-- 一次評価者
			THEN	2		--一次評価者コメント
			WHEN	TEMP.evaluation_step = 2	-- 二次評価者
			THEN	22		--二次評価者コメント
			WHEN	TEMP.evaluation_step = 3	-- 三次評価者
			THEN	23		--三次評価者コメント
			WHEN	TEMP.evaluation_step = 4	-- 四次評価者
			THEN	24		--四次評価者コメント
			WHEN	TEMP.evaluation_step = 5	-- 管理者
			THEN	3							-- 両方
			ELSE	0							
		END											AS	interview_comment_flg
	FROM M0310
	INNER JOIN #TEMP_F0030 AS	TEMP ON (
		M0310.company_cd		=	TEMP.company_cd
	)
	LEFT OUTER JOIN L0040 ON(
		3					=	L0040.category
	AND	M0310.status_cd		=	L0040.status_cd
	)
	LEFT OUTER JOIN	 M0200 WITH(NOLOCK)	ON(
		M0310.company_cd	=	M0200.company_cd
	AND	@P_sheet_cd			=	M0200.sheet_cd
	AND	M0200.del_datetime	IS	NULL
	)
	LEFT OUTER JOIN	 M0101 WITH(NOLOCK)	ON(
		M0200.company_cd		=	M0101.company_cd
	AND	M0200.evaluation_period	=	M0101.detail_no
	AND	M0101.del_datetime	IS	NULL
	)
	LEFT OUTER JOIN	 F0122 WITH(NOLOCK)	 ON (
		M0310.company_cd		=	F0122.company_cd
	AND	@P_fiscal_year			=	F0122.fiscal_year
	AND	TEMP.employee_cd		=	F0122.employee_cd
	AND	M0310.status_cd			=	F0122.interview_no
	AND	M0101.detail_no			=	F0122.period_detail_no		
	)
	WHERE 
		M0310.company_cd		=	@P_company_cd
	AND	M0310.category			=	3
	AND	M0310.status_use_typ	=	1
	AND	M0310.del_datetime	IS NULL
	ORDER BY 
		M0310.status_cd
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--screen control process
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- interview_comment_flg = 1.仮評価者 2. 評価者　3.管理者
	-- 未処理
	IF @status_cd = 0
	BEGIN
		UPDATE #RESULT_TABLE SET 
			interview_date_status			=	CASE 
													WHEN status_cd = 1 AND  interview_comment_flg IN(1,2,22,23,24,3)
													THEN 1
													WHEN status_cd = 1 AND rater_employee_cd_2 = @employee_cd_login		-- 二次評価者
													THEN 1
													WHEN status_cd = 1 AND rater_employee_cd_3 = @employee_cd_login		-- 三次評価者
													THEN 1
													WHEN status_cd = 1 AND rater_employee_cd_4 = @employee_cd_login		-- 四次評価者
													THEN 1
													ELSE 0
												END
		,	interview_comment_self_status	=	CASE
													WHEN status_cd = 1 AND interview_comment_flg IN(1,3)
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status	=	CASE
													WHEN status_cd = 1 AND interview_comment_flg IN(2,3)
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status2	=	CASE
													WHEN status_cd = 1 AND interview_comment_flg IN(22,3)
													THEN 1
													WHEN status_cd = 1 AND rater_employee_cd_2 = @employee_cd_login	-- 二次評価者
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status3	=	CASE
													WHEN status_cd = 1 AND interview_comment_flg IN(23,3)
													THEN 1
													WHEN status_cd = 1 AND rater_employee_cd_3 = @employee_cd_login	-- 三次評価者
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status4	=	CASE
													WHEN status_cd = 1 AND interview_comment_flg IN(24,3)
													THEN 1
													WHEN status_cd = 1 AND rater_employee_cd_4 = @employee_cd_login	-- 四次評価者
													THEN 1
													ELSE 0
												END
		FROM #RESULT_TABLE
	END
	-- 期首面談中
	IF @status_cd = 1 AND @sheet_kbn = 1
	BEGIN
		UPDATE #RESULT_TABLE SET 
			interview_date_status			=	CASE 
													WHEN (status_cd >= 1 AND status_cd <= 11) AND interview_comment_flg IN(1,2,22,23,24,3)
													THEN 1
													WHEN (status_cd >= 1 AND status_cd <= 11) AND rater_employee_cd_2 = @employee_cd_login	-- 二次評価者
													THEN 1
													WHEN (status_cd >= 1 AND status_cd <= 11) AND rater_employee_cd_3 = @employee_cd_login	-- 三次評価者
													THEN 1
													WHEN (status_cd >= 1 AND status_cd <= 11) AND rater_employee_cd_4 = @employee_cd_login	-- 四次評価者
													THEN 1
													ELSE 0
												END
		,	interview_comment_self_status	=	CASE
													WHEN (status_cd >= 1 AND status_cd <= 11) AND interview_comment_flg IN(1,3)
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status	=	CASE
													WHEN (status_cd >= 1 AND status_cd <= 11) AND interview_comment_flg IN(2,3)
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status2	=	CASE
													WHEN (status_cd >= 1 AND status_cd <= 11) AND interview_comment_flg IN(22,3)
													THEN 1
													WHEN (status_cd >= 1 AND status_cd <= 11) AND rater_employee_cd_2 = @employee_cd_login	-- 二次評価者
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status3	=	CASE
													WHEN (status_cd >= 1 AND status_cd <= 11) AND interview_comment_flg IN(23,3)
													THEN 1
													WHEN (status_cd >= 1 AND status_cd <= 11) AND rater_employee_cd_3 = @employee_cd_login	-- 三次評価者
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status4	=	CASE
													WHEN (status_cd >= 1 AND status_cd <= 11) AND interview_comment_flg IN(24,3)
													THEN 1
													WHEN (status_cd >= 1 AND status_cd <= 11) AND rater_employee_cd_4 = @employee_cd_login	-- 四次評価者
													THEN 1
													ELSE 0
												END
		FROM #RESULT_TABLE
	END
	-- 目標承認待ち
	IF @status_cd = 2 AND @sheet_kbn = 1
	BEGIN
		UPDATE #RESULT_TABLE SET 
			interview_date_status			=	CASE 
													WHEN (status_cd >= 2 AND status_cd <= 11) AND interview_comment_flg IN(1,2,22,23,24,3)
													THEN 1
													WHEN (status_cd >= 2 AND status_cd <= 11) AND rater_employee_cd_2 = @employee_cd_login	-- 二次評価者
													THEN 1
													WHEN (status_cd >= 2 AND status_cd <= 11) AND rater_employee_cd_3 = @employee_cd_login	-- 三次評価者
													THEN 1
													WHEN (status_cd >= 2 AND status_cd <= 11) AND rater_employee_cd_4 = @employee_cd_login	-- 四次評価者
													THEN 1
													ELSE 0
												END
		,	interview_comment_self_status	=	CASE
													WHEN (status_cd >= 1 AND status_cd <= 11) AND interview_comment_flg IN(1,3)
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status	=	CASE
													WHEN (status_cd >= 2 AND status_cd <= 11) AND interview_comment_flg IN(2,3)
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status2	=	CASE
													WHEN (status_cd >= 1 AND status_cd <= 11) AND interview_comment_flg IN(22,3)
													THEN 1
													WHEN (status_cd >= 1 AND status_cd <= 11) AND rater_employee_cd_2 = @employee_cd_login	-- 二次評価者
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status3	=	CASE
													WHEN (status_cd >= 1 AND status_cd <= 11) AND interview_comment_flg IN(23,3)
													THEN 1
													WHEN (status_cd >= 1 AND status_cd <= 11) AND rater_employee_cd_3 = @employee_cd_login	-- 三次評価者
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status4	=	CASE
													WHEN (status_cd >= 1 AND status_cd <= 11) AND interview_comment_flg IN(24,3)
													THEN 1
													WHEN (status_cd >= 1 AND status_cd <= 11) AND rater_employee_cd_4 = @employee_cd_login	-- 四次評価者
													THEN 1
													ELSE 0
												END
		FROM #RESULT_TABLE
	END
	-- 自己評価中~被評価者ﾌｨｰﾄﾞﾊﾞｯｸ待ち
	IF	
	(
		(@status_cd = 3 AND @sheet_kbn = 1) OR (@status_cd = 1 AND @sheet_kbn = 2)		-- 自己評価中
	OR	(@status_cd = 4 AND @sheet_kbn = 1 ) OR (@status_cd = 2 AND @sheet_kbn = 2)		-- 一次評価中
	OR	(@status_cd = 5 AND @sheet_kbn = 1 ) OR (@status_cd = 3 AND @sheet_kbn = 2)		-- 二次評価中
	OR	(@status_cd = 6 AND @sheet_kbn = 1 ) OR (@status_cd = 4 AND @sheet_kbn = 2)		-- 三次評価中
	OR	(@status_cd = 7 AND @sheet_kbn = 1 ) OR (@status_cd = 5 AND @sheet_kbn = 2)		-- 四次評価中
	OR	(@status_cd = 8 AND @sheet_kbn = 1 ) OR (@status_cd = 6 AND @sheet_kbn = 2)		-- 評価確定待ち
	OR	(@status_cd = 9 AND @sheet_kbn = 1 ) OR (@status_cd = 7 AND @sheet_kbn = 2)		-- 一次評価者ﾌｨｰﾄﾞﾊﾞｯｸ待ち
	OR	(@status_cd = 10 AND @sheet_kbn = 1 ) OR (@status_cd = 8 AND @sheet_kbn = 2)	-- 被評価者ﾌｨｰﾄﾞﾊﾞｯｸ待ち
	)
	BEGIN
		UPDATE #RESULT_TABLE SET 
			interview_date_status			=	CASE 
													WHEN (status_cd >= 2 AND status_cd <= 11) AND interview_comment_flg IN(1,2,22,23,24,3)
													THEN 1
													WHEN (status_cd >= 2 AND status_cd <= 11) AND rater_employee_cd_2 = @employee_cd_login	-- 二次評価者
													THEN 1
													WHEN (status_cd >= 2 AND status_cd <= 11) AND rater_employee_cd_3 = @employee_cd_login	-- 三次評価者
													THEN 1
													WHEN (status_cd >= 2 AND status_cd <= 11) AND rater_employee_cd_4 = @employee_cd_login	-- 四次評価者
													THEN 1
													ELSE 0
												END
		,	interview_comment_self_status	=	CASE
													WHEN (status_cd >= 1 AND status_cd <= 11) AND interview_comment_flg IN(1,3)
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status	=	CASE
													WHEN (status_cd >= 2 AND status_cd <= 11) AND interview_comment_flg IN(2,3)
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status2	=	CASE
													WHEN (status_cd >= 1 AND status_cd <= 11) AND interview_comment_flg IN(22,3)
													THEN 1
													WHEN (status_cd >= 1 AND status_cd <= 11) AND rater_employee_cd_2 = @employee_cd_login	-- 二次評価者
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status3	=	CASE
													WHEN (status_cd >= 1 AND status_cd <= 11) AND interview_comment_flg IN(23,3)
													THEN 1
													WHEN (status_cd >= 1 AND status_cd <= 11) AND rater_employee_cd_3 = @employee_cd_login	-- 三次評価者
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status4	=	CASE
													WHEN (status_cd >= 1 AND status_cd <= 11) AND interview_comment_flg IN(24,3)
													THEN 1
													WHEN (status_cd >= 1 AND status_cd <= 11) AND rater_employee_cd_4 = @employee_cd_login	-- 四次評価者
													THEN 1
													ELSE 0
												END
		FROM #RESULT_TABLE
	END
	-- 評価結果通知待ち
	IF (@status_cd = 11 AND @sheet_kbn = 1) OR (@status_cd = 9 AND @sheet_kbn = 2)
	BEGIN
		UPDATE #RESULT_TABLE SET 
			interview_date_status			=	CASE 
													WHEN (status_cd >= 2 AND status_cd <= 12) AND interview_comment_flg IN(1,2,22,23,24,3)
													THEN 1
													WHEN (status_cd >= 2 AND status_cd <= 12) AND rater_employee_cd_2 = @employee_cd_login	-- 二次評価者
													THEN 1
													WHEN (status_cd >= 2 AND status_cd <= 12) AND rater_employee_cd_3 = @employee_cd_login	-- 三次評価者
													THEN 1
													WHEN (status_cd >= 2 AND status_cd <= 12) AND rater_employee_cd_4 = @employee_cd_login	-- 四次評価者
													THEN 1
													ELSE 0
												END
		,	interview_comment_self_status	=	CASE
													WHEN (status_cd >= 1 AND status_cd <= 12) AND interview_comment_flg IN(1,3)
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status	=	CASE
													WHEN (status_cd >= 2 AND status_cd <= 12) AND interview_comment_flg IN(2,3)
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status2	=	CASE
													WHEN (status_cd >= 1 AND status_cd <= 12) AND interview_comment_flg IN(22,3)
													THEN 1
													WHEN (status_cd >= 1 AND status_cd <= 12) AND rater_employee_cd_2 = @employee_cd_login	-- 二次評価者
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status3	=	CASE
													WHEN (status_cd >= 1 AND status_cd <= 12) AND interview_comment_flg IN(23,3)
													THEN 1
													WHEN (status_cd >= 1 AND status_cd <= 12) AND rater_employee_cd_3 = @employee_cd_login	-- 三次評価者
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status4	=	CASE
													WHEN (status_cd >= 1 AND status_cd <= 12) AND interview_comment_flg IN(24,3)
													THEN 1
													WHEN (status_cd >= 1 AND status_cd <= 12) AND rater_employee_cd_4 = @employee_cd_login	-- 四次評価者
													THEN 1
													ELSE 0
												END
		FROM #RESULT_TABLE
	END
	-- 評価完了(30日以内)
	IF ((@status_cd = 12 AND @sheet_kbn = 1) OR (@status_cd = 10 AND @sheet_kbn = 2)) AND @w_評価完了_30日以内 = 1
	BEGIN
		UPDATE #RESULT_TABLE SET 
			interview_date_status			=	0
		,	interview_comment_self_status	=	CASE
													WHEN interview_comment_flg IN(1,3)
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status	=	0
		,	interview_comment_rater_status2	=	CASE
													WHEN interview_comment_flg IN(22,3)
													THEN 1
													WHEN rater_employee_cd_2 = @employee_cd_login	-- 二次評価者
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status3	=	CASE
													WHEN interview_comment_flg IN(23,3)
													THEN 1
													WHEN rater_employee_cd_3 = @employee_cd_login	-- 三次評価者
													THEN 1
													ELSE 0
												END
		,	interview_comment_rater_status4	=	CASE
													WHEN interview_comment_flg IN(24,3)
													THEN 1
													WHEN rater_employee_cd_4 = @employee_cd_login	-- 四次評価者
													THEN 1
													ELSE 0
												END
		FROM #RESULT_TABLE
	END
	-- 評価完了(30日以降)
	IF ((@status_cd = 12 AND @sheet_kbn = 1) OR (@status_cd = 10 AND @sheet_kbn = 2)) AND @w_評価完了_30日以内 = 0
	BEGIN
		UPDATE #RESULT_TABLE SET 
			interview_date_status			=	0
		,	interview_comment_self_status	=	0
		,	interview_comment_rater_status	=	0
		,	interview_comment_rater_status2	=	0
		,	interview_comment_rater_status3	=	0
		,	interview_comment_rater_status4	=	0
		FROM #RESULT_TABLE
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- ↓↓↓ add by viettd 2020/05/18
	EXEC [dbo].SPC_PERMISSION_CHK1 @P_fiscal_year,@P_employee_cd,@P_sheet_cd,@P_user_id,@P_company_cd,1,@chk OUT
	--	0.参照不可　1.参照可能	2.更新可能
	IF @chk IN (0,1)
	BEGIN
		UPDATE #RESULT_TABLE SET 
			interview_comment_rater_status	=	0
		,	interview_comment_rater_status2	=	0
		,	interview_comment_rater_status3	=	0
		,	interview_comment_rater_status4	=	0
		,	interview_comment_self_status	=	0
		FROM #RESULT_TABLE
	END
	-- ↑↑↑ end add by viettd 2020/05/18
	--[0]
	SELECT * FROM #RESULT_TABLE
	--[1]
	SELECT 
		employee_cd					AS	employee_cd
	,	evaluation_step				AS	evaluation_step
	,	@P_fiscal_year				AS	fiscal_year
	,	@status_cd					AS	status_cd
	,	@w_rater_interview_use_typ	AS	rater_interview_use_typ
	,	@employee_cd_login			AS	employee_cd_login
	,	rater_employee_cd_1			AS	rater_employee_cd_1
	,	rater_employee_cd_2			AS	rater_employee_cd_2
	,	rater_employee_cd_3			AS	rater_employee_cd_3
	,	rater_employee_cd_4			AS	rater_employee_cd_4
	FROM #TEMP_F0030
	--[2]
	IF EXISTS (SELECT 1 FROM #RESULT_TABLE 
						WHERE (
							interview_comment_self_status	= 1 
						OR	interview_comment_rater_status	= 1
						OR	interview_comment_rater_status2 = 1
						OR	interview_comment_rater_status3 = 1
						OR	interview_comment_rater_status4 = 1
						) 
						--AND interview_comment_flg IN (1,2,22,23,24,3)
						)
	BEGIN
		UPDATE #BUTTON_TABLE SET saveButton = 1
	END
	--
	SELECT saveButton FROM #BUTTON_TABLE
END
GO