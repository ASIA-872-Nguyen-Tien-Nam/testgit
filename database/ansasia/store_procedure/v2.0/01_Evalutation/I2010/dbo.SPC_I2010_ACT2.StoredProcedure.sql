DROP PROCEDURE [SPC_I2010_ACT2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC XXX '{}','','::1';

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	APPROVE DATA　（承認・差戻）
--*  
--* 作成日/create date			:	2018/10/09											
--*	作成者/creater				:	viettd						
--*   					
--*	更新日/update date			:	2019/03/01  						
--*	更新者/updater				:	viettd　  　								     	 
--*	更新内容/update content		:	差戻ボタンを押すと定性評価シートのステータスも戻る	　	
--*   					
--*	更新日/update date			:	2019/12/10  						
--*	更新者/updater				:	viettd　  　								     	 
--*	更新内容/update content		:	upgradate ver1.6
--*   					
--*	更新日/update date			:	2020/03/16  						
--*	更新者/updater				:	viettd　  　								     	 
--*	更新内容/update content		:	add item generic_comment_3 + generic_comment_4
--*   					
--*	更新日/update date			:	2020/03/26 						
--*	更新者/updater				:	viettd　  　								     	 
--*	更新内容/update content		:	Fix update employee_cd in table F0900 + F0901
--*   					
--*  更新日/update date			:	2020/04/24
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	fix error when 評価者 = 管理者
--*   					
--*	更新日/update date			:	2020/08/25 						
--*	更新者/updater				:	yamazaki　  　								     	 
--*	更新内容/update content		:	F0901の処理をコメント
--*   					
--*	更新日/update date			:	2021/12/01 						
--*	更新者/updater				:	viettd　  　								     	 
--*	更新内容/update content		:	upgradate ver 1.8
--*   					
--*  更新日/update date			:	2022/09/12			
--*　更新者/updater				:　	vietdt　  　			
--*　更新内容/update content		:	upgradate ver 1.9
--*   					
--*  更新日/update date			:	2025/09/17	
--*　更新者/updater				:　	viettd　  　			
--*　更新内容/update content		:	when reject then update F0110
--*   	
--****************************************************************************************
CREATE PROCEDURE [SPC_I2010_ACT2] 
	-- Add the parameters for the stored procedure here
	@P_fiscal_year				int						=	0
,	@P_employee_cd				nvarchar(10)			=	''
,	@P_sheet_cd					smallint				=	0
,	@P_mode						tinyint					=	0		-- 1.approve 2.reject
,	@P_generic_comment_3		nvarchar(400)			=	''		-- add by viettd 2020/03/16
,	@P_generic_comment_4		nvarchar(400)			=	''		-- add by viettd 2020/03/16
	-- common
,	@P_login_employee_cd		nvarchar(10)			=	''
,	@P_cre_user					nvarchar(50)			=	''
,	@P_cre_ip					nvarchar(50)			=	''
,	@P_company_cd				smallint				=	''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			int					=	0
	,	@screen_id				nvarchar(20)		=	'I2010'
	--
	,	@status_cd					tinyint				=	0
	,	@authority_typ				smallint			=	0
	,	@evaluation_step			smallint			=	0		--	評価段階
	,	@login_user_typ				smallint			=	0
	,	@w_提出済状況				tinyint				=	0	--	0.未提出　1.提出済
	--,	@w_承認済状況				tinyint				=	0	--	0.未承認　1.承認済
	,	@status_自己評価中			tinyint				=	0	--	3.自己評価
	,	@status_cd_target			tinyint				=	0
	--
	,	@w_rater_employee_cd_1		nvarchar(10)		=	''
	,	@w_rater_employee_cd_2		nvarchar(10)		=	''
	,	@w_rater_employee_cd_3		nvarchar(10)		=	''
	,	@w_rater_employee_cd_4		nvarchar(10)		=	''
	--	INFORMATION
	,	@infomationn_typ			tinyint				=	0
	,	@infomation_title			nvarchar(30)		=	''
	,	@infomation_message			nvarchar(500)		=	''
	,	@system_date				date				=	getdate()
	,	@send_mailaddress			nvarchar(60)		=	0
	--
	,	@evaluation_period			smallint			=	0	-- add by viettd 2019/03/01
	,	@w_language					SMALLINT			=	1	-- add by viettd 2022/09/12
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--CREATE TEMP TABLE
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
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
	,	generic_comment_status8						tinyint
	--	評価シート入力
	,	goal_number									smallint
	,	item_title_title							nvarchar(20)
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
	,	weight_display_status						tinyint	-- ウェイト
	,	weight_display_nm							nvarchar(20)	-- ウェイト名
	,	challenge_level_display_status				tinyint	-- 難易度
	,	detail_self_progress_comment_display_status	tinyint	-- 明細自己進捗評価コメント	-- add by viettd 2021/12/01
	,	detail_progress_comment_display_status		tinyint	--	明細進捗評価コメント
	,	progress_comment_display_status				tinyint	-- 自己進捗コメント
	--
	,	progress_comment_display_status1			tinyint	-- 一次評価者進捗コメント
	,	progress_comment_display_status2			tinyint			-- 二次評価者進捗コメント		add by viettd 2021/12/01
	,	progress_comment_display_status3			tinyint			-- 三次評価者進捗コメント		add by viettd 2021/12/01
	,	progress_comment_display_status4			tinyint			-- 四次評価者進捗コメント		add by viettd 2021/12/01
	--
	,	detail_comment_display_status1				tinyint	-- 評価コメント1
	,	detail_comment_display_status2				tinyint	-- 評価コメント2
	,	detail_comment_display_status3				tinyint	-- 評価コメント3
	,	detail_comment_display_startus4				tinyint	-- 評価コメント4
	,	detail_myself_comment_display_status		tinyint	-- 自己評価コメント
	,	evaluation_display_status0					tinyint	-- 自己評価
	,	evaluation_display_status1					tinyint	-- 一次評価
	,	evaluation_display_status2					tinyint	-- 二次評価
	,	evaluation_display_status3					tinyint	-- 三次評価
	,	evaluation_display_status4					tinyint	-- 四次評価
	,	total_score_display_status					tinyint	-- 合計点
	--
	,	evaluation_comment_status0					tinyint	-- 自己評価コメント
	,	evaluation_comment_status1					tinyint	-- 一次評価コメント
	,	evaluation_comment_status2					tinyint	-- 二次評価コメント
	,	evaluation_comment_status3					tinyint	-- 三次評価コメント
	,	evaluation_comment_status4					tinyint	-- 四次評価コメント
		--
	,	point_criteria_display_status				tinyint	-- 評価基準
	,	challengelevel_criteria_display_status		tinyint	-- 難易度基準
	,	self_assessment_comment_display_status		tinyint	-- 自己評価コメント
	,	evaluation_comment_display_status			tinyint	-- 評価者コメント
	,	login_user_typ								smallint-- ログイン者
	)
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		--VALIDATE
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		--
		-- RUN STORE PROCEDUCE
		INSERT INTO #M0200_HIDE_SHOW
		EXEC [dbo].SPC_I2010_LST1 @P_fiscal_year,@P_sheet_cd,@P_employee_cd,@P_login_employee_cd,@P_cre_user,@P_company_cd
		--
		-- GET @status_cd
		SELECT 
			@status_cd					=	ISNULL(F0100.status_cd,0)
		,	@w_rater_employee_cd_1		=	ISNULL(F0100.rater_employee_cd_1,'')
		,	@w_rater_employee_cd_2		=	ISNULL(F0100.rater_employee_cd_2,'')
		,	@w_rater_employee_cd_3		=	ISNULL(F0100.rater_employee_cd_3,'')
		,	@w_rater_employee_cd_4		=	ISNULL(F0100.rater_employee_cd_4,'')
		FROM F0100
		WHERE 
			F0100.company_cd			=	@P_company_cd
		AND F0100.fiscal_year			=	@P_fiscal_year
		AND F0100.employee_cd			=	@P_employee_cd
		AND F0100.sheet_cd				=	@P_sheet_cd
		AND F0100.del_datetime IS NULL
		--
		-- GET @authority_typ
		SET @authority_typ = (
			SELECT ISNULL(S0010.authority_typ,0) 
			FROM S0010 
			WHERE 
				S0010.company_cd = @P_company_cd 
			AND S0010.user_id = @P_cre_user
		)
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
		---- 承認済状況
		--IF EXISTS (SELECT 1 FROM F0110 WHERE
		--								F0110.company_cd			=	@P_company_cd
		--							AND F0110.fiscal_year			=	@P_fiscal_year
		--							AND F0110.employee_cd			=	@P_employee_cd
		--							AND F0110.sheet_cd				=	@P_sheet_cd
		--							AND F0110.approval_datetime IS NOT NULL
		--							AND F0110.del_datetime IS NULL)
		--BEGIN
		--	SET @w_承認済状況 = 1 -- 1.承認済
		--END
		-- GET @infomationn_typ
		IF @P_mode = 2
		BEGIN
			-- add by viettd 2022/09/12
			SELECT 
				@w_language			=	ISNULL(S0010.language,1)	
			FROM S0010
			WHERE 
				S0010.company_cd	= @P_company_cd 
			AND S0010.employee_cd	= @P_employee_cd
			AND S0010.del_datetime IS NULL
			--
			SELECT 
				@infomationn_typ	=	ISNULL(L0050.infomationn_typ,0)
			,	@infomation_title	=	IIF(@w_language = 2,ISNULL(L0050.infomation_title_english,''),ISNULL(L0050.infomation_title,''))
			,	@infomation_message	=	IIF(@w_language = 2,ISNULL(L0050.infomation_message_english,''),ISNULL(L0050.infomation_message,''))
			FROM L0050
			WHERE
				L0050.information_cd	=	5
			AND L0050.del_datetime IS NULL
			-- GET @send_mailaddress
			SELECT 
				@send_mailaddress = ISNULL(M0070.mail,'')
			FROM M0070
			WHERE 
				M0070.company_cd	=	@P_company_cd
			AND M0070.employee_cd	=	@P_employee_cd
			AND M0070.del_datetime IS NULL
		END
		-- add by viettd 2019/03/01
		SELECT 
			@evaluation_period		=	ISNULL(M0200.evaluation_period,0)
		FROM M0200
		WHERE 
			M0200.company_cd	=	@P_company_cd
		AND M0200.sheet_cd		=	@P_sheet_cd
		AND M0200.del_datetime IS NULL
		-- end add by viettd 2019/03/01
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		--PROCESS
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			-- ２：期首面談 ３：目標承認済 ４：自己評価済
			IF @status_cd IN (2,3,4) AND @w_提出済状況 = 1 AND @login_user_typ IN(21,3) -- 21.一次評価者 ３．管理者
			BEGIN
				--■■■■■■■■■■■■■■■■■■ F0101 ■■■■■■■■■■■■■■■■■■
				UPDATE F0101 SET
					generic_comment_3		=	@P_generic_comment_3
				,	generic_comment_4		=	@P_generic_comment_4
				,	upd_user				=	@P_cre_user
				,	upd_ip					=	@P_cre_ip
				,	upd_prg					=	@screen_id
				,	upd_datetime			=	@w_time
				FROM F0101
				WHERE
					F0101.company_cd		=	@P_company_cd
				AND F0101.fiscal_year		=	@P_fiscal_year
				AND F0101.employee_cd		=	@P_employee_cd
				AND F0101.sheet_cd			=	@P_sheet_cd
				--■■■■■■■■■■■■■■■■■■ F0110 ■■■■■■■■■■■■■■■■■■



				UPDATE F0110 SET 
					approval_user		=	CASE 
												WHEN @P_mode = 1	-- 1.approve
												THEN @P_cre_user
												ELSE SPACE(0)
											END
				,	approval_ip			=	CASE 
												WHEN @P_mode = 1	-- 1.approve
												THEN @P_cre_ip
												ELSE SPACE(0)
											END
				,	approval_datetime	=	CASE 
												WHEN @P_mode = 1	-- 1.approve
												THEN @w_time
												ELSE NULL
											END
				
				,	submit_user			=	CASE
												WHEN @P_mode = 2 AND @status_cd IN(2,3)
												THEN SPACE(0)
												ELSE F0110.submit_user
											END
				,	submit_ip			=	CASE
												WHEN @P_mode = 2 AND @status_cd IN(2,3)
												THEN SPACE(0)
												ELSE F0110.submit_ip
											END
				,	submit_datetime			=	CASE
												WHEN @P_mode = 2 AND @status_cd IN(2,3)
												THEN NULL
												ELSE F0110.submit_datetime
											END
				,	upd_user			=	@P_cre_user
				,	upd_ip				=	@P_cre_ip
				,	upd_prg				=	@screen_id
				,	upd_datetime		=	@w_time
				FROM F0110
				WHERE
					F0110.company_cd		=	@P_company_cd
				AND F0110.fiscal_year		=	@P_fiscal_year
				AND F0110.employee_cd		=	@P_employee_cd
				AND F0110.sheet_cd			=	@P_sheet_cd
				AND F0110.del_datetime IS NULL
				AND F0110.submit_datetime IS NOT NULL



				--■■■■■■■■■■■■■■■■■■ F0100 ■■■■■■■■■■■■■■■■■■
				-- GET @status_自己評価中
				IF EXISTS (SELECT 1 FROM M0310
									WHERE 
										M0310.company_cd			=	@P_company_cd
									AND M0310.category				=	1
									AND M0310.status_cd				=	3
									AND M0310.status_use_typ		=	1
									AND M0310.del_datetime IS NULL
				)
				BEGIN
					SET @status_自己評価中	=	1
				END
				-- add by viettd 2021/12/01
				-- IF NOT CHOICE 自己評価 THEN SET @status_自己評価中 = 0
				IF EXISTS (SELECT 1 FROM W_M0200 
												WHERE 
													W_M0200.company_cd			=	@P_company_cd
												AND W_M0200.fiscal_year			=	@P_fiscal_year
												AND W_M0200.sheet_cd			=	@P_sheet_cd
												AND W_M0200.evaluation_self_typ	=	0	-- 0.利用なし
												AND W_M0200.del_datetime IS NULL
												)
				BEGIN
					SET @status_自己評価中	=	0
				END
				-- GET @status_cd_target
				-- ■MODE 1.承認 (APPROVED)
				IF @P_mode = 1
				BEGIN
					-- WHEN HAS 自己評価中
					IF @status_自己評価中 = 1
					BEGIN
						SET @status_cd_target	=	3		-- 3.自己評価中
					END
					ELSE
					BEGIN
						SET @status_cd_target	=	4		-- 4.一次評価中
					END
				END
				-- ■MODE 2.差戻 (REJECTED)
				IF @P_mode = 2
				BEGIN
					IF @status_cd <	4 -- 一次評価中
					BEGIN
						SET @status_cd_target = 0	-- 0.未提出
					END 
					ELSE 
					BEGIN
						-- IF NOT CHOICE 自己評価 THEN SET @status_cd_target = 0
						IF @status_自己評価中 = 0
						BEGIN
							SET @status_cd_target = 0
						END
						ELSE
						BEGIN
							SET @status_cd_target = @status_cd - 1
						END
					END
					--■■■■■■■■■■■■■■■■■■ F0900 ■■■■■■■■■■■■■■■■■■
					IF EXISTS (SELECT 1 FROM F0900
										WHERE 
											F0900.company_cd			=	@P_company_cd
										AND F0900.category				=	0
										AND F0900.status_cd				=	1
										AND F0900.infomationn_typ		=	@infomationn_typ
										AND F0900.infomation_date		=	@system_date
										AND F0900.target_employee_cd	=	@P_employee_cd
										AND F0900.fiscal_year			=	@P_fiscal_year
										AND F0900.sheet_cd				=	@P_sheet_cd
										--AND F0900.employee_cd			=	@w_rater_employee_cd_1
										AND F0900.employee_cd			=	@P_employee_cd				-- edited by viettd 2020/03/26
					)
					BEGIN
						UPDATE F0900 SET 
							infomation_title		=	@infomation_title
						,	infomation_message		=	@infomation_message
						,	confirmation_datetime	=	NULL
						,	upd_user				=	@P_cre_user
						,	upd_ip					=	@P_cre_ip
						,	upd_prg					=	@screen_id
						,	upd_datetime			=	@w_time
						,	del_user				=	SPACE(0)
						,	del_ip					=	SPACE(0)
						,	del_prg					=	SPACE(0)
						,	del_datetime			=	NULL
						WHERE 
							F0900.company_cd			=	@P_company_cd
						AND F0900.category				=	0
						AND F0900.status_cd				=	1
						AND F0900.infomationn_typ		=	@infomationn_typ
						AND F0900.infomation_date		=	@system_date
						AND F0900.target_employee_cd	=	@P_employee_cd
						AND F0900.fiscal_year			=	@P_fiscal_year
						AND F0900.sheet_cd				=	@P_sheet_cd
						--AND F0900.employee_cd			=	@w_rater_employee_cd_1
						AND F0900.employee_cd			=	@P_employee_cd				-- edited by viettd 2020/03/26
					END
					ELSE
					BEGIN
						INSERT INTO F0900
						SELECT 
							@P_company_cd
						,	0
						,	1
						,	@infomationn_typ
						,	@system_date
						,	@P_employee_cd
						,	@P_fiscal_year
						,	@P_sheet_cd
						--,	@w_rater_employee_cd_1
						,	@P_employee_cd				-- edited by viettd 2020/03/26
						,	@infomation_title
						,	@infomation_message
						,	NULL
						,	@P_cre_user
						,	@P_cre_ip
						,	@screen_id
						,	@w_time
						,	SPACE(0)
						,	SPACE(0)
						,	SPACE(0)
						,	NULL
						,	SPACE(0)
						,	SPACE(0)
						,	SPACE(0)
						,	NULL
					END
				END
				-- UPDATE F0100
				UPDATE F0100 SET 
					status_cd		=	@status_cd_target
				,	upd_user		=	@P_cre_user
				,	upd_ip			=	@P_cre_ip
				,	upd_prg			=	@screen_id
				,	upd_datetime	=	@w_time
				FROM F0100
				WHERE 
					F0100.company_cd		=	@P_company_cd
				AND F0100.fiscal_year		=	@P_fiscal_year
				AND F0100.employee_cd		=	@P_employee_cd
				AND F0100.sheet_cd			=	@P_sheet_cd
				AND F0100.del_datetime IS NULL
				-- IF @status_cd_target = 0 then sync all sheet
				IF @status_cd_target = 0
				BEGIN
					--目標評価シート・定性評価シート
					UPDATE F0100 SET 
						status_cd		=	0		
					,	upd_user		=	@P_cre_user
					,	upd_ip			=	@P_cre_ip
					,	upd_prg			=	@screen_id
					,	upd_datetime	=	@w_time
					FROM F0100
					INNER JOIN M0200 ON (
						F0100.company_cd			=	M0200.company_cd
					AND F0100.sheet_cd				=	M0200.sheet_cd
					AND M0200.del_datetime IS NULL
					)
					WHERE 
						F0100.company_cd			=	@P_company_cd 
					AND	F0100.fiscal_year			=	@P_fiscal_year
					AND	F0100.employee_cd			=	@P_employee_cd
					AND	M0200.evaluation_period		=	@evaluation_period
					--AND M0200.sheet_kbn				=	2
				END
			END
		END
	END TRY
	BEGIN CATCH
	IF (@@TRANCOUNT > 0)
		BEGIN
			ROLLBACK TRANSACTION
		END
		DELETE FROM @ERR_TBL
		INSERT INTO @ERR_TBL
		SELECT	
			0
		,	'EXCEPTION'
		,	0
		,	999 -- exception error
		,	0
		,	0
		,	'Error'                                                          + CHAR(13) + CHAR(10) +
            'Procedure : ' + ISNULL(ERROR_PROCEDURE(), '???')                + CHAR(13) + CHAR(10) +
            'Line : '      + ISNULL(CAST(ERROR_LINE() AS NVARCHAR(10)), '0') + CHAR(13) + CHAR(10) +
            'Message : '   + ISNULL(ERROR_MESSAGE(), 'An unexpected error occurred.')
	END CATCH
	--DELETE FROM @ERR_TBL
	IF(@@TRANCOUNT > 0)
	BEGIN
		COMMIT TRANSACTION
	END
    -- Insert statements for procedure here
	COMPLETE_QUERY:
	-- GET ERROR_TYPE MIN
	SELECT 
		@order_by_min = MIN(order_by)
	FROM @ERR_TBL
	--[0] SELECT ERROR TABLE
	SELECT 
		message_no
	,	item
	,	order_by
	,	error_typ
	,	value1
	,	value2
	,	remark
	FROM @ERR_TBL
	WHERE order_by = @order_by_min
	ORDER BY 
		order_by
END
GO
