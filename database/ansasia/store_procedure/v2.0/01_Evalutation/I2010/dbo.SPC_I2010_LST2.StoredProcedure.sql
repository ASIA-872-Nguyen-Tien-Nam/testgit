DROP PROCEDURE [SPC_I2010_LST2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ M0170
-- EXEC SPC_I2010_LST2 '2020','1','738','905','905','102';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	ENABLED/DISABLED BUTTON 
--*  
--*  作成日/create date			:	2018/10/08						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2019/12/10
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgradate ver1.6
--*   					
--*  更新日/update date			:	2020/04/24
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	fix error when 評価者 = 管理者
--*   					
--*  更新日/update date			:	2020/05/18
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	CHECK PERMISSION OF ROUTER EVALUTATION
--*   					
--*  更新日/update date			:	2020/08/20
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	when refer to F0300 then condition is 
--*								:	・シートの目標又は定性
--*								:	・シートのステータス
--*   					
--*  更新日/update date			:	2020/10/09
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgradate ver1.7 & 1on1
--*   					
--*  更新日/update date			:	2022/08/16 			
--*　更新者/updater				:　	vietdt　  　			
--*　更新内容/update content		:	upgradate ver 1.9
--*   					
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_I2010_LST2]
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
	,	@evaluation_step		smallint		=	0
	,	@login_user_typ			smallint		=	1	--	1. 被評価者用 2.評価者用
	,	@w_提出済状況			tinyint			=	0	--	0.未提出　1.提出済
	,	@w_承認済状況			tinyint			=	0	--	0.未承認　1.承認済
	--
	,	@w_rater_employee_cd_1	nvarchar(10)	=	''
	,	@w_rater_employee_cd_2	nvarchar(10)	=	''
	,	@w_rater_employee_cd_3	nvarchar(10)	=	''
	,	@w_rater_employee_cd_4	nvarchar(10)	=	''
	,	@start_date				date			=	NULL
	,	@w_time					date			=	GETDATE()
	,	@chk					tinyint			=	0	-- add by viettd 2020/05/18
	--
	CREATE TABLE #BUTTON_TEMP (
		memoryButton  					int			--	一時保存			
	,	saveButton   					int			--	登録
	,	approveButton  					int			--	承認
	,	sendBackButton  				int			--	差戻
	,	interviewButton  				int			--	面談記録
	)
	-- INSERT DATA INTO TEMP TABLE
	INSERT INTO #BUTTON_TEMP VALUES(1,1,1,1,1)
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
	-- ボタン制御（スケジュールの開始日を参照）
	--
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
		AND F0300.category			=	1					-- add by viettd 2020/08/20 1:目標管理
		AND F0300.del_datetime	IS NULL
	)
	-- apply sau 評価シートの評価開始日以前は処理ボタンは使用不可とする。
	IF (@start_date IS NOT NULL AND  @w_time < @start_date)
	BEGIN
		UPDATE #BUTTON_TEMP SET
			memoryButton  		=	0
		,	saveButton  		=	0
		,	approveButton  		=	0
		,	sendBackButton		=	0
		--,	interviewButton		=	0		-- comment out by viettd 2020/10/09
		GOTO COMPLETE
	END
	-- ↓↓↓ add by viettd 2020/05/18
	EXEC [dbo].SPC_PERMISSION_CHK1 @P_fiscal_year,@P_employee_cd,@P_sheet_cd,@P_cre_user,@P_company_cd,1,@chk OUT
	--	0.参照不可　1.参照可能	2.更新可能
	IF @chk IN (0,1)
	BEGIN
		UPDATE #BUTTON_TEMP SET
			memoryButton  		=	0
		,	saveButton  		=	0
		,	approveButton  		=	0
		,	sendBackButton		=	0
		,	interviewButton		=	1
		GOTO COMPLETE
	END
	-- ↑↑↑ end add by viettd 2020/05/18
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
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- STATUS = 0 : 初期状態
	IF @status_cd = 0
	BEGIN
		UPDATE #BUTTON_TEMP SET 
			memoryButton  		=	CASE 
										WHEN @login_user_typ IN(1,3)  -- 1. 被評価者用  3.管理者
										THEN 1
										ELSE 0
									END
		,	saveButton  		=	CASE 
										WHEN @login_user_typ IN(1,3)  -- 1. 被評価者用  3.管理者
										THEN 1
										ELSE 0
									END
		,	approveButton  		= 0
		,	sendBackButton  	= 0
		--,	interviewButton  	= 0
		FROM #BUTTON_TEMP
	END
	-- STATUS = １：目標提出
	IF @status_cd = 1
	BEGIN
		UPDATE #BUTTON_TEMP SET 
			memoryButton  		=	CASE 
										WHEN @w_提出済状況  = 0	-- 0. 未提出
										THEN 1
										ELSE 0
									END
		,	saveButton  		=	CASE 
										WHEN @w_提出済状況  = 0	-- 0. 未提出
										THEN 1
										ELSE 0
									END
		,	approveButton  		= 0
		,	sendBackButton  	= 0
		--,	interviewButton  	=	CASE 
		--								WHEN @login_user_typ IN(1,3)	-- 1. 被評価者用  3.管理者
		--								THEN 1
		--								WHEN @login_user_typ = 21		-- 21.一次評価者
		--								THEN 1
		--								ELSE 0
		--							END
		FROM #BUTTON_TEMP
	END
	-- STATUS = ２：期首面談
	IF @status_cd = 2
	BEGIN
		UPDATE #BUTTON_TEMP SET 
			memoryButton  	=	0
		,	saveButton  	=	0
		,	approveButton  	=	CASE 
									WHEN @login_user_typ IN(21,3)	-- 21.一次評価者 3.管理者
									THEN 1
									ELSE 0
								END
		,	sendBackButton  =	CASE 
									WHEN @login_user_typ IN(21,3)	-- 21.一次評価者 3.管理者
									THEN 1
									ELSE 0
								END
		--,	interviewButton  =	0
		FROM #BUTTON_TEMP
	END
	-- STATUS = ３：目標承認
	IF @status_cd = 3
	BEGIN
		UPDATE #BUTTON_TEMP SET 
			memoryButton  	=	CASE 
									WHEN @login_user_typ IN(1,3)	-- 1. 被評価者用  3.管理者
									THEN 1
									WHEN @login_user_typ = 1 AND @w_承認済状況 = 0 -- 1.被評価者 & 未承認
									THEN 1
									ELSE 0
								END
		,	saveButton  	=	CASE 
									WHEN @login_user_typ IN(1,3)	-- 1. 被評価者用  3.管理者
									THEN 1
									WHEN @login_user_typ = 21		-- 21.一次評価者
									THEN 0
									ELSE 0
								END
		,	approveButton  	=	0
		,	sendBackButton  =	CASE 
									WHEN @login_user_typ IN (21,3)		-- 21.一次評価者 3.管理者
									THEN 1
									ELSE 0
								END
		--,	interviewButton  =	CASE 
		--							WHEN @login_user_typ IN(1,3)	-- 1. 被評価者用  3.管理者
		--							THEN 1
		--							WHEN @login_user_typ = 21		-- 21.一次評価者
		--							THEN 1
		--							ELSE 0
		--						END
		FROM #BUTTON_TEMP
	END
	-- STATUS = ４：自己評価
	IF @status_cd = 4
	BEGIN
		UPDATE #BUTTON_TEMP SET 
			memoryButton  	=	CASE 
									WHEN @login_user_typ = 3	-- 3.管理者
									THEN 1
									WHEN @login_user_typ = 21	-- 21.一次評価者
									THEN 1
									ELSE 0
								END
		,	saveButton  	=	CASE 
									WHEN @login_user_typ = 3	-- 3.管理者
									THEN 1
									WHEN @login_user_typ = 21	-- 21.一次評価者
									THEN 1
									ELSE 0
								END
		,	approveButton  	=	0
		,	sendBackButton  =	CASE 
									WHEN @login_user_typ IN (21,3)		-- 21.一次評価者 3.管理者
									THEN 1
									ELSE 0
								END
		--,	interviewButton  =	0
		FROM #BUTTON_TEMP
	END
	-- STATUS = ５：一次評価
	IF @status_cd = 5
	BEGIN
		UPDATE #BUTTON_TEMP SET 
			memoryButton  	=	CASE 
									WHEN @login_user_typ IN(22,3)	-- 22.二次評価者 3.管理者
									THEN 1
									ELSE 0
								END
		,	saveButton  	=	CASE 
									WHEN @login_user_typ IN(22,3)	-- 22.二次評価者 3.管理者
									THEN 1
									ELSE 0
								END
		,	approveButton  	=	0
		,	sendBackButton  =	0
		--,	interviewButton  =	0
		FROM #BUTTON_TEMP
	END
	-- STATUS = ６：二次評価
	IF @status_cd = 6
	BEGIN
		UPDATE #BUTTON_TEMP SET 
			memoryButton  	=	CASE 
									WHEN @login_user_typ = 3	-- 3.管理者
									THEN 1
									WHEN @login_user_typ = 23	-- 3.三次評価者
									THEN 1
									ELSE 0
								END
		,	saveButton  	=	CASE 
									WHEN @login_user_typ = 3 -- 3.管理者
									THEN 1
									WHEN @login_user_typ = 23	-- 3.三次評価者
									THEN 1
									ELSE 0
								END
		,	approveButton  	=	0
		,	sendBackButton  =	0
		--,	interviewButton  =	0
		FROM #BUTTON_TEMP
	END
	-- STATUS = ７：三次評価
	IF @status_cd = 7
	BEGIN
		UPDATE #BUTTON_TEMP SET 
			memoryButton  	=	CASE 
									WHEN @login_user_typ = 3	-- 3.管理者
									THEN 1
									WHEN @login_user_typ = 24	-- 4.四次評価者
									THEN 1
									ELSE 0
								END
		,	saveButton  	=	CASE 
									WHEN @login_user_typ = 3 -- 3.管理者
									THEN 1
									WHEN @login_user_typ = 24	-- 4.四次評価者
									THEN 1
									ELSE 0
								END
		,	approveButton  	=	0
		,	sendBackButton  =	0
		--,	interviewButton  =	0
		FROM #BUTTON_TEMP
	END
	-- STATUS = ８：四次評価
	IF @status_cd = 8
	BEGIN
		UPDATE #BUTTON_TEMP SET 
			memoryButton  	=	0
		,	saveButton  	=	0
		,	approveButton  	=	0
		,	sendBackButton  =	0
		--,	interviewButton  =	0
		FROM #BUTTON_TEMP
	END
	-- STATUS = ９：評価確定
	IF @status_cd = 9
	BEGIN
		UPDATE #BUTTON_TEMP SET 
			memoryButton  	=	0
		,	saveButton  	=	0
		,	approveButton  	=	0
		,	sendBackButton  =	0
		--,	interviewButton  =	0
		FROM #BUTTON_TEMP
	END
	-- STATUS = 10：一次評価者ﾌｨｰﾄﾞﾊﾞｯｸ
	IF @status_cd = 10
	BEGIN
		UPDATE #BUTTON_TEMP SET 
			memoryButton  	=	0
		,	saveButton  	=	0
		,	approveButton  	=	0
		,	sendBackButton  =	0
		--,	interviewButton  =	0
		FROM #BUTTON_TEMP
	END
	-- STATUS = 11：評価ﾌｨｰﾄﾞﾊﾞｯｸ
	IF @status_cd = 11
	BEGIN
		UPDATE #BUTTON_TEMP SET 
			memoryButton  	=	0
		,	saveButton  	=	0
		,	approveButton  	=	0
		,	sendBackButton  =	0
		--,	interviewButton  =	CASE 
		--							WHEN @login_user_typ IN(1,21,3)	-- 1. 被評価者用 21.一次評価者 3.管理者
		--							THEN 1
		--							ELSE 0
		--						END
		FROM #BUTTON_TEMP
	END
	-- STATUS = 12：評価完了
	IF @status_cd = 12
	BEGIN
		UPDATE #BUTTON_TEMP SET 
			memoryButton  		=	0
		,	saveButton  		=	0
		,	approveButton  		=	0
		,	sendBackButton		=	0
		--,	interviewButton		=	0
		FROM #BUTTON_TEMP
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
COMPLETE:	
	--[0]
	SELECT 
		memoryButton  	
	,	saveButton   	
	,	approveButton  	
	,	sendBackButton  	
	,	interviewButton
	FROM #BUTTON_TEMP
	-- DROP TABLE
	DROP TABLE #BUTTON_TEMP
END
GO