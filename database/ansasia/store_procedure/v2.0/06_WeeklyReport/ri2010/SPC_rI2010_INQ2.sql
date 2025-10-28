IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_rI2010_INQ2]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_rI2010_INQ2]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_rI2010_INQ2 782,2023,'890',4,1,'890'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	CHECK PERMISSION  OF LOGIN USE FOR REPORT
--*  
--*  作成日/create date			:	2023/05/08						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2024/03/25
--*　更新者/updater				:	viettd
--*　更新内容/update content		:	add comment options button
--*   					
--*  更新日/update date			:	2024/05/30
--*　更新者/updater				:	viettd
--*　更新内容/update content		:	fix bug of comment options button
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rI2010_INQ2]
	@P_company_cd			smallint		=	0
,	@P_fiscal_year			smallint		=	0
,	@P_employee_cd			nvarchar(10)	=	''
,	@P_report_kind			smallint		=	0
,	@P_report_no			smallint		=	0
,	@P_login_user_type		tinyint			=	0
,	@P_login_employee_cd	nvarchar(10)	=	''	-- LOGIN EMPLOYEE
AS
BEGIN
	DECLARE
		@w_status_cd						smallint		=	0
	,	@w_approver_employee_cd_1			nvarchar(10)	=	''
	,	@w_approver_employee_cd_2			nvarchar(10)	=	''
	,	@w_approver_employee_cd_3			nvarchar(10)	=	''
	,	@w_approver_employee_cd_4			nvarchar(10)	=	''
	,	@w_is_sharewith						smallint		=	0
	,	@w_share_kbn						tinyint			=	0
	,	@w_reaction_done					tinyint			=	0	--0.HAS NOT REACTION | 1. HAS REACTION
	-- login permison
	,	@w_report_authority_typ				smallint		=	0
	,	@w_report_authority_cd				smallint		=	0
	,	@w_authority_ri2010					smallint		=	0
	--	M4100
	,	@w_comment_option_use_typ				tinyint			=	0
	,	@w_comment_option_authorizer_use_typ	tinyint			=	0
	,	@w_comment_option_viewer_use_typ		tinyint			=	0
	-- 
	,	@w_admin_and_is_approver				tinyint			=	0	-- add by viettd 2024/05/30
	,	@w_admin_and_is_viewer					tinyint			=	0	-- add by viettd 2024/05/30
	-- #TABLE_PERMISON
	CREATE TABLE #TABLE_PERMISON (
		company_cd				smallint
	,	status_cd				smallint
	,	login_use_typ			tinyint			--	0.not use 1.報告者 21.一次承認者 22.二次承認者　23.三次承認者 24.四次承認者　3.閲覧者 4。管理者
	--	ヘッダー
	,	btn_temporary_header	tinyint			--	0.hide 1.show	一時保存
	,	btn_submit_header		tinyint			--	0.hide 1.show	提出
	--	入力欄明細
	,	answer					tinyint			--	0.hide 1.disabled 2.enable
	,	approver_comment		tinyint			--	0.hide 1.disabled 2.enable
	--	入力欄フッタ
	,	free_comment			tinyint			--	0.hide 1.disabled 2.enable	自由記入欄
	,	comment					tinyint			--	0.hide 1.disabled 2.enable	コメント欄
	,	reaction				tinyint			--	0.hide 1.disabled 2.enable	リアクション
	--	フッタ
	,	btn_approve_action		tinyint			--	0.hide 1.show	承認する
	,	btn_reject_action		tinyint			--	0.hide 1.show	差戻する
	,	btn_view_action			tinyint			--	0.hide 1.show	確認しました
	,	btn_share_action		tinyint			--	0.hide 1.show	共有する
	,	btn_stick_action		tinyint			--	0.hide 1.show	付箋を貼る
	,	btn_viewer_confirm		tinyint			--	0.hide 1.show	確認者一覧
	,	btn_comment				tinyint			--	0.hide 1.show	コメントする
	,	btn_temporary			tinyint			--	0.hide 1.show	一時保存
	,	btn_temporary_detail	tinyint			--	0.hide 1.show	明細一時保存
	--
	,	btn_comment_option		tinyint			--	0.hide 1.show	comment_option_use_typ	-- add by viettd 2024/03/25
	,	admin_and_is_approver	tinyint			--	0.hide 1.show	-- add by viettd 2024/05/30
	,	admin_and_is_viewer		tinyint			--	0.hide 1.show	-- add by viettd 2024/05/30
	)
	-- GET REPORT INFO
	SELECT 
		@w_status_cd				=	ISNULL(F4200.status_cd,0)
	,	@w_approver_employee_cd_1	=	ISNULL(F4200.approver_employee_cd_1,'')
	,	@w_approver_employee_cd_2	=	ISNULL(F4200.approver_employee_cd_2,'')
	,	@w_approver_employee_cd_3	=	ISNULL(F4200.approver_employee_cd_3,'')
	,	@w_approver_employee_cd_4	=	ISNULL(F4200.approver_employee_cd_4,'')
	FROM F4200
	WHERE 
		F4200.company_cd			=	@P_company_cd
	AND F4200.fiscal_year			=	@P_fiscal_year
	AND F4200.employee_cd			=	@P_employee_cd
	AND F4200.report_kind			=	@P_report_kind
	AND F4200.report_no				=	@P_report_no
	AND F4200.del_datetime IS NULL
	-- GET @w_report_authority_typ
	SELECT 
		@w_report_authority_typ		=	ISNULL(S0010.report_authority_typ,0)
	,	@w_report_authority_cd		=	ISNULL(S0010.report_authority_cd,0)
	FROM S0010
	LEFT OUTER JOIN M0070 ON (
		S0010.company_cd		=	M0070.company_cd
	AND S0010.employee_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	WHERE 
		S0010.company_cd		=	@P_company_cd
	AND S0010.employee_cd		=	@P_login_employee_cd
	AND S0010.del_datetime IS NULL
	-- GET @w_authority_ri2010
	SELECT 
		@w_authority_ri2010 = ISNULL(S4021.authority,0)
	FROM S4021
	WHERE 
		S4021.company_cd		=	@P_company_cd
	AND	S4021.authority_cd		=	@w_report_authority_cd
	AND S4021.function_id		=	'ri2010'
	AND S4021.del_datetime IS NULL
	-- get from M4100
	SELECT 
		@w_comment_option_use_typ					=	ISNULL(M4100.comment_option_use_typ,0)
	,	@w_comment_option_authorizer_use_typ		=	ISNULL(M4100.comment_option_authorizer_use_typ,0)
	,	@w_comment_option_viewer_use_typ			=	ISNULL(M4100.comment_option_viewer_use_typ,0)
	FROM M4100
	WHERE 
		M4100.company_cd	=	@P_company_cd
	AND M4100.del_datetime IS NULL
	
	-- GET @w_is_sharewith & @w_share_kbn
	IF EXISTS (SELECT 1 FROM F4207 
						WHERE 
							company_cd				=	@P_company_cd
						AND fiscal_year				=	@P_fiscal_year
						AND employee_cd				=	@P_employee_cd
						AND report_kind				=	@P_report_kind
						AND report_no				=	@P_report_no
						AND sharewith_employee_cd	=	@P_login_employee_cd
						AND F4207.del_datetime IS NULL
						)
	BEGIN
		SET @w_is_sharewith		= 1
		SELECT 
			@w_share_kbn = ISNULL(F4207.share_kbn,0)
		FROM F4207
		WHERE 
			company_cd				=	@P_company_cd
		AND fiscal_year				=	@P_fiscal_year
		AND employee_cd				=	@P_employee_cd
		AND report_kind				=	@P_report_kind
		AND report_no				=	@P_report_no
		AND sharewith_employee_cd	=	@P_login_employee_cd
		AND F4207.del_datetime IS NULL
	END
	-- CHECK LOGIN USER IS REACTED
	IF EXISTS (SELECT 1 FROM F4204
						WHERE 
							company_cd		=	@P_company_cd
						AND	fiscal_year		=	@P_fiscal_year
						AND employee_cd		=	@P_employee_cd
						AND report_kind		=	@P_report_kind
						AND report_no		=	@P_report_no
						AND reaction_no		=	@P_login_employee_cd
						AND reaction_datetime	IS NOT NULL
						AND del_datetime IS NULL)
	BEGIN
		SET @w_reaction_done	=	1
	END
	-- add by viettd 2024/05/30
	-- CHECK ADMIN IS VIEWER OR APPORVER
	IF @P_login_user_type = 4
	BEGIN
		-- ADMIN IS APPORVER
		IF (
			@P_login_employee_cd = @w_approver_employee_cd_1 
		OR	@P_login_employee_cd = @w_approver_employee_cd_2
		OR	@P_login_employee_cd = @w_approver_employee_cd_3
		OR	@P_login_employee_cd = @w_approver_employee_cd_4
		)
		BEGIN
			SET @w_admin_and_is_approver = 1
		END
		-- ADMIN IS VIEWER
		IF EXISTS (SELECT 1 FROM F4120 
						WHERE 
							company_cd			=	@P_company_cd
						AND fiscal_year			=	@P_fiscal_year
						AND employee_cd			=	@P_employee_cd
						AND report_kind			=	@P_report_kind
						AND report_no			=	@P_report_no
						AND viewer_employee_cd	=	@P_login_employee_cd
						AND F4120.del_datetime IS NULL
						)
		BEGIN
			SET @w_admin_and_is_viewer = 1
		END
	END
	-- INSERT DEFUALT VALUES
	INSERT INTO #TABLE_PERMISON VALUES (@P_company_cd,@w_status_cd,@P_login_user_type,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,@w_admin_and_is_approver,@w_admin_and_is_viewer)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--① status_cd=1（未提出）
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF @w_status_cd = 1
	BEGIN
		-- REPOTER & ADMIN
		IF @P_login_user_type IN(1,4)
		BEGIN
			UPDATE #TABLE_PERMISON SET
			--	ヘッダー
				btn_temporary_header	=	1		--	0.hide 1.show
			,	btn_submit_header		=	1		--	0.hide 1.show
			--	入力欄明細
			,	answer					=	2		--	0.hide 1.disabled 2.enable
			,	approver_comment		=	0		--	0.hide 1.disabled 2.enable
			--	入力欄フッタ
			,	free_comment			=	2		--	0.hide 1.disabled 2.enable
			,	comment					=	0		--	0.hide 1.disabled 2.enable
			,	reaction				=	0		--	0.hide 1.disabled 2.enable
			--	フッタ
			,	btn_approve_action		=	0		--	0.hide 1.show	承認する
			,	btn_reject_action		=	0		--	0.hide 1.show	差戻する
			,	btn_view_action			=	0		--	0.hide 1.show	確認しました
			,	btn_share_action		=	0		--	0.hide 1.show	共有する
			,	btn_stick_action		=	0		--	0.hide 1.show	付箋を貼る
			,	btn_viewer_confirm		=	1		--	0.hide 1.show	確認者一覧
			,	btn_comment				=	0		--	0.hide 1.show	コメントする
			,	btn_temporary			=	0		--	0.hide 1.show	一時保存
			,	btn_temporary_detail	=	0		--	0.hide 1.show	明細一時保存
			--
			,	btn_comment_option		=	0		--	0.hide 1.show	comment_option_use_typ
			FROM #TABLE_PERMISON
		END
		-- VIEWER & APPOVER
		IF @P_login_user_type IN (21,22,23,24,3)
		BEGIN
			UPDATE #TABLE_PERMISON SET
				--	ヘッダー
				btn_temporary_header	=	0		--	0.hide 1.show
			,	btn_submit_header		=	0		--	0.hide 1.show
			--	入力欄明細
			,	answer					=	0		--	0.hide 1.disabled 2.enable
			,	approver_comment		=	0		--	0.hide 1.disabled 2.enable
			--	入力欄フッタ
			,	free_comment			=	0		--	0.hide 1.disabled 2.enable
			,	comment					=	0		--	0.hide 1.disabled 2.enable
			,	reaction				=	0		--	0.hide 1.disabled 2.enable
			--	フッタ
			,	btn_approve_action		=	0		--	0.hide 1.show	承認する
			,	btn_reject_action		=	0		--	0.hide 1.show	差戻する
			,	btn_view_action			=	0		--	0.hide 1.show	確認しました
			,	btn_share_action		=	0		--	0.hide 1.show	共有する
			,	btn_stick_action		=	0		--	0.hide 1.show	付箋を貼る
			,	btn_viewer_confirm		=	0		--	0.hide 1.show	確認者一覧
			,	btn_comment				=	0		--	0.hide 1.show	コメントする
			,	btn_temporary			=	0		--	0.hide 1.show	一時保存
			,	btn_temporary_detail	=	0		--	0.hide 1.show	明細一時保存
			--
			,	btn_comment_option		=	0		--	0.hide 1.show	comment_option_use_typ
			FROM #TABLE_PERMISON
		END
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--② status_cd=２～５（承認中）
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF @w_status_cd IN (2,3,4,5)
	BEGIN
		-- REPOTER
		IF @P_login_user_type = 1
		BEGIN
			UPDATE #TABLE_PERMISON SET
			--	ヘッダー
				btn_temporary_header	=	0		--	0.hide 1.show
			,	btn_submit_header		=	0		--	0.hide 1.show
			--	入力欄明細
			,	answer					=	1		--	0.hide 1.disabled 2.enable
			,	approver_comment		=	0		--	0.hide 1.disabled 2.enable
			--	入力欄フッタ
			,	free_comment			=	1		--	0.hide 1.disabled 2.enable
			,	comment					=	0		--	0.hide 1.disabled 2.enable
			,	reaction				=	0		--	0.hide 1.disabled 2.enable
			--	フッタ
			,	btn_approve_action		=	0		--	0.hide 1.show	承認する
			,	btn_reject_action		=	0		--	0.hide 1.show	差戻する
			,	btn_view_action			=	0		--	0.hide 1.show	確認しました
			,	btn_share_action		=	0		--	0.hide 1.show	共有する
			,	btn_stick_action		=	1		--	0.hide 1.show	付箋を貼る
			,	btn_viewer_confirm		=	1		--	0.hide 1.show	確認者一覧
			,	btn_comment				=	0		--	0.hide 1.show	コメントする
			,	btn_temporary			=	0		--	0.hide 1.show	一時保存
			,	btn_temporary_detail	=	0		--	0.hide 1.show	明細一時保存
			,	btn_comment_option		=	0		--	0.hide 1.show	comment_option_use_typ
			FROM #TABLE_PERMISON
		END
		-- APPOVER & ADMIN
		IF @P_login_user_type IN (21,22,23,24,4)
		BEGIN
			UPDATE #TABLE_PERMISON SET
				--	ヘッダー
				btn_temporary_header	=	0		--	0.hide 1.show
			,	btn_submit_header		=	0		--	0.hide 1.show
			--	入力欄明細
			,	answer					=	1		--	0.hide 1.disabled 2.enable
			,	approver_comment		=	1		--	0.hide 1.disabled 2.enable
			--	入力欄フッタ
			,	free_comment			=	1		--	0.hide 1.disabled 2.enable
			,	comment					=	0		--	0.hide 1.disabled 2.enable
			,	reaction				=	0		--	0.hide 1.disabled 2.enable
			--	フッタ
			,	btn_approve_action		=	0		--	0.hide 1.show	承認する
			,	btn_reject_action		=	0		--	0.hide 1.show	差戻する
			,	btn_view_action			=	0		--	0.hide 1.show	確認しました
			,	btn_share_action		=	0		--	0.hide 1.show	共有する
			,	btn_stick_action		=	0		--	0.hide 1.show	付箋を貼る
			,	btn_viewer_confirm		=	0		--	0.hide 1.show	確認者一覧
			,	btn_comment				=	0		--	0.hide 1.show	コメントする
			,	btn_temporary			=	0		--	0.hide 1.show	一時保存
			,	btn_temporary_detail	=	0		--	0.hide 1.show	明細一時保存
			,	btn_comment_option		=	0		--	0.hide 1.show	comment_option_use_typ
			FROM #TABLE_PERMISON
			-- 2.一次承認中
			-- 3.二次承認中
			-- 4.三次承認中
			-- 5.四次承認中
			IF (
				(@w_status_cd = 2 AND @P_login_user_type IN(21,4))
			OR	(@w_status_cd = 3 AND @P_login_user_type IN(22,4))
			OR	(@w_status_cd = 4 AND @P_login_user_type IN(23,4))
			OR	(@w_status_cd = 5 AND @P_login_user_type IN(24,4))
			)
			BEGIN
				UPDATE #TABLE_PERMISON SET
				--	入力欄明細
					approver_comment		=	2		--	0.hide 1.disabled 2.enable
				--	入力欄フッタ
				,	comment					=	2		--	0.hide 1.disabled 2.enable
				,	reaction				=	2		--	0.hide 1.disabled 2.enable
				--	フッタ
				,	btn_approve_action		=	1		--	0.hide 1.show	承認する
				,	btn_reject_action		=	1		--	0.hide 1.show	差戻する
				,	btn_view_action			=	0		--	0.hide 1.show	確認しました
				,	btn_share_action		=	0		--	0.hide 1.show	共有する
				,	btn_stick_action		=	0		--	0.hide 1.show	付箋を貼る
				,	btn_viewer_confirm		=	1		--	0.hide 1.show	確認者一覧
				,	btn_comment				=	1		--	0.hide 1.show	コメントする
				,	btn_temporary			=	1		--	0.hide 1.show	一時保存
				,	btn_temporary_detail	=	1		--	0.hide 1.show	明細一時保存
				,	btn_comment_option		=	CASE
													WHEN @P_login_user_type IN (21,22,23,24)
													THEN 1
													WHEN @w_admin_and_is_approver = 1
													THEN 1
													WHEN @w_admin_and_is_viewer = 1
													THEN 1
													ELSE 0
												END

				FROM #TABLE_PERMISON
			END
		END
		-- VIEWER & ADMIN
		IF @P_login_user_type  = 3
		BEGIN
			UPDATE #TABLE_PERMISON SET
				--	ヘッダー
				btn_temporary_header	=	0		--	0.hide 1.show
			,	btn_submit_header		=	0		--	0.hide 1.show
			--	入力欄明細
			,	answer					=	0		--	0.hide 1.disabled 2.enable
			,	approver_comment		=	0		--	0.hide 1.disabled 2.enable
			--	入力欄フッタ
			,	free_comment			=	0		--	0.hide 1.disabled 2.enable
			,	comment					=	0		--	0.hide 1.disabled 2.enable
			,	reaction				=	0		--	0.hide 1.disabled 2.enable
			--	フッタ
			,	btn_approve_action		=	0		--	0.hide 1.show	承認する
			,	btn_reject_action		=	0		--	0.hide 1.show	差戻する
			,	btn_view_action			=	0		--	0.hide 1.show	確認しました
			,	btn_share_action		=	0		--	0.hide 1.show	共有する
			,	btn_stick_action		=	0		--	0.hide 1.show	付箋を貼る
			,	btn_viewer_confirm		=	0		--	0.hide 1.show	確認者一覧
			,	btn_comment				=	0		--	0.hide 1.show	コメントする
			,	btn_temporary			=	0		--	0.hide 1.show	一時保存
			,	btn_temporary_detail	=	0		--	0.hide 1.show	明細一時保存
			,	btn_comment_option		=	0		--	0.hide 1.show	comment_option_use_typ
			FROM #TABLE_PERMISON
		END
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--③ status_cd=6（報告済み）
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF @w_status_cd = 6 
	BEGIN
		-- REPOTER
		IF @P_login_user_type  = 1
		BEGIN
			UPDATE #TABLE_PERMISON SET
			--	ヘッダー
				btn_temporary_header	=	0		--	0.hide 1.show
			,	btn_submit_header		=	0		--	0.hide 1.show
			--	入力欄明細
			,	answer					=	1		--	0.hide 1.disabled 2.enable
			,	approver_comment		=	1		--	0.hide 1.disabled 2.enable
			--	入力欄フッタ
			,	free_comment			=	1		--	0.hide 1.disabled 2.enable
			,	comment					=	0		--	0.hide 1.disabled 2.enable
			,	reaction				=	0		--	0.hide 1.disabled 2.enable
			--	フッタ
			,	btn_approve_action		=	0		--	0.hide 1.show	承認する
			,	btn_reject_action		=	0		--	0.hide 1.show	差戻する
			,	btn_view_action			=	0		--	0.hide 1.show	確認しました
			,	btn_share_action		=	0		--	0.hide 1.show	共有する
			,	btn_stick_action		=	1		--	0.hide 1.show	付箋を貼る
			,	btn_viewer_confirm		=	1		--	0.hide 1.show	確認者一覧
			,	btn_comment				=	0		--	0.hide 1.show	コメントする
			,	btn_temporary			=	0		--	0.hide 1.show	一時保存
			,	btn_temporary_detail	=	0		--	0.hide 1.show	明細一時保存
			,	btn_comment_option		=	0		--	0.hide 1.show	comment_option_use_typ
			FROM #TABLE_PERMISON
		END
		-- APPOVER
		IF @P_login_user_type IN (21,22,23,24)
		BEGIN
			UPDATE #TABLE_PERMISON SET
				--	ヘッダー
				btn_temporary_header	=	0		--	0.hide 1.show
			,	btn_submit_header		=	0		--	0.hide 1.show
			--	入力欄明細
			,	answer					=	1		--	0.hide 1.disabled 2.enable
			,	approver_comment		=	1		--	0.hide 1.disabled 2.enable
			--	入力欄フッタ
			,	free_comment			=	1		--	0.hide 1.disabled 2.enable
			,	comment					=	0		--	0.hide 1.disabled 2.enable
			,	reaction				=	0		--	0.hide 1.disabled 2.enable
			--	フッタ
			,	btn_approve_action		=	0		--	0.hide 1.show	承認する
			,	btn_reject_action		=	0		--	0.hide 1.show	差戻する
			,	btn_view_action			=	0		--	0.hide 1.show	確認しました
			,	btn_share_action		=	1		--	0.hide 1.show	共有する
			,	btn_stick_action		=	1		--	0.hide 1.show	付箋を貼る
			,	btn_viewer_confirm		=	1		--	0.hide 1.show	確認者一覧
			,	btn_comment				=	0		--	0.hide 1.show	コメントする
			,	btn_temporary			=	0		--	0.hide 1.show	一時保存
			,	btn_temporary_detail	=	0		--	0.hide 1.show	明細一時保存
			,	btn_comment_option		=	0		--	0.hide 1.show	comment_option_use_typ
			FROM #TABLE_PERMISON
		END
		-- VIEWER & ADMIN
		IF @P_login_user_type  IN(3,4)
		BEGIN
			UPDATE #TABLE_PERMISON SET
			--	ヘッダー
				btn_temporary_header	=	0		--	0.hide 1.show
			,	btn_submit_header		=	0		--	0.hide 1.show
			--	入力欄明細
			,	answer					=	1		--	0.hide 1.disabled 2.enable
			,	approver_comment		=	1		--	0.hide 1.disabled 2.enable
			--	入力欄フッタ
			,	free_comment			=	1		--	0.hide 1.disabled 2.enable

			,	comment					=	CASE 
												-- 共有先社員
												WHEN @P_login_user_type = 3 AND @w_is_sharewith = 1 AND @w_share_kbn = 0
												THEN 0
												WHEN @w_reaction_done = 1	-- リアクション済
												THEN 0
												ELSE 2
											END		--	0.hide 1.disabled 2.enable
			,	reaction				=	CASE
												-- 共有先社員
												WHEN @P_login_user_type = 3 AND @w_is_sharewith = 1 AND @w_share_kbn = 0
												THEN 0
												WHEN @w_reaction_done = 1	-- リアクション済
												THEN 0
												ELSE 2
											END		--	0.hide 1.disabled 2.enable
			
			--	フッタ
			,	btn_approve_action		=	0		--	0.hide 1.show	承認する
			,	btn_reject_action		=	CASE
												WHEN @P_login_user_type = 4
												THEN 1
												ELSE 0
											END						--	0.hide 1.show	差戻する
			,	btn_view_action			=	CASE 
												-- 共有先社員
												WHEN @P_login_user_type = 3 AND @w_is_sharewith = 1 AND @w_share_kbn = 0
												THEN 0
												ELSE 1
											END		--	0.hide 1.show	確認しました

			,	btn_share_action		=	CASE 
												-- 共有先社員
												WHEN @P_login_user_type = 3 AND @w_is_sharewith = 1 AND @w_share_kbn = 0
												THEN 0
												ELSE 1
											END		--	0.hide 1.show	共有する
			,	btn_stick_action		=	1		--	0.hide 1.show	付箋を貼る
			,	btn_viewer_confirm		=	1		--	0.hide 1.show	確認者一覧
			,	btn_comment				=	CASE 
												-- 共有先社員
												WHEN @P_login_user_type = 3 AND @w_is_sharewith = 1 AND @w_share_kbn = 0
												THEN 0
												WHEN @w_reaction_done = 1	-- リアクション済
												THEN 0
												ELSE 1
											END		--	0.hide 1.show	コメントする
			,	btn_temporary			=	CASE 
												-- 共有先社員
												WHEN @P_login_user_type = 3 AND @w_is_sharewith = 1 AND @w_share_kbn = 0
												THEN 0
												WHEN @w_reaction_done = 1	-- リアクション済
												THEN 0
												ELSE 1
											END		--	0.hide 1.show	一時保存
			,	btn_temporary_detail	=	0		--	0.hide 1.show	明細一時保存
			,	btn_comment_option		=	CASE 
												-- 共有先社員
												WHEN @P_login_user_type = 3 AND @w_is_sharewith = 1 AND @w_share_kbn = 0
												THEN 0
												WHEN @P_login_user_type = 4 AND @w_admin_and_is_viewer = 1 AND @w_is_sharewith = 1 AND @w_share_kbn = 0
												THEN 0
												WHEN @w_reaction_done = 1	-- リアクション済
												THEN 0
												WHEN @P_login_user_type = 4  AND @w_admin_and_is_viewer = 0
												THEN 0
												ELSE 1
											END			--	0.hide 1.show	comment_option_use_typ
			FROM #TABLE_PERMISON
			-- 確認済の場合
			IF EXISTS (SELECT 1 FROM F4203 
								WHERE 
									F4203.company_cd			=	@P_company_cd
								AND F4203.fiscal_year			=	@P_fiscal_year
								AND F4203.employee_cd			=	@P_employee_cd
								AND F4203.report_kind			=	@P_report_kind
								AND F4203.report_no				=	@P_report_no
								AND F4203.viewer_employee_cd	=	@P_login_employee_cd
								AND F4203.viewer_datetime IS NOT NULL
								AND F4203.del_datetime IS NULL
			)
			BEGIN
				UPDATE #TABLE_PERMISON SET 
					btn_view_action		=	0
				FROM #TABLE_PERMISON
			END
		END
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--参照可能の場合
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF @P_login_user_type = 4 AND @w_report_authority_typ = 3 AND @w_authority_ri2010 = 1
	BEGIN
		UPDATE #TABLE_PERMISON	SET
		--	ヘッダー
			btn_temporary_header	=	0		--	0.hide 1.show
		,	btn_submit_header		=	0		--	0.hide 1.show
		--	入力欄明細
		,	answer					=	1		--	0.hide 1.disabled 2.enable
		,	approver_comment		=	1		--	0.hide 1.disabled 2.enable
		--	入力欄フッタ
		,	free_comment			=	1		--	0.hide 1.disabled 2.enable
		,	comment					=	0		--	0.hide 1.disabled 2.enable
		,	reaction				=	1		--	0.hide 1.disabled 2.enable
		--	フッタ
		,	btn_approve_action		=	0		--	0.hide 1.show	承認する
		,	btn_reject_action		=	0		--	0.hide 1.show	差戻する
		,	btn_view_action			=	0		--	0.hide 1.show	確認しました
		,	btn_share_action		=	0		--	0.hide 1.show	共有する
		,	btn_stick_action		=	0		--	0.hide 1.show	付箋を貼る
		,	btn_viewer_confirm		=	1		--	0.hide 1.show	確認者一覧
		,	btn_comment				=	0		--	0.hide 1.show	コメントする
		,	btn_temporary			=	0		--	0.hide 1.show	一時保存
		,	btn_temporary_detail	=	0		--	0.hide 1.show	明細一時保存
		,	btn_comment_option		=	0		--	0.hide 1.show	
		FROM #TABLE_PERMISON
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--CHECK リアクションマスタ (M4122.mark_kbn=2)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF NOT EXISTS (SELECT 1 FROM M4122 WHERE company_cd = @P_company_cd AND mark_kbn = 2 AND del_datetime IS NULL)
	BEGIN
		UPDATE #TABLE_PERMISON SET 
			reaction	=	0
		FROM #TABLE_PERMISON
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--CHECK M4100
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- コメントオプション用
	IF @w_comment_option_use_typ = 0
	BEGIN
		UPDATE #TABLE_PERMISON SET 
			btn_comment_option	=	0
		FROM #TABLE_PERMISON
	END
	-- コメントオプション用(承認者)
	IF @w_comment_option_authorizer_use_typ = 0 AND (@P_login_user_type IN (21,22,23,24) OR @w_admin_and_is_approver = 1)
	BEGIN
		UPDATE #TABLE_PERMISON SET 
			btn_comment_option	=	0
		FROM #TABLE_PERMISON
	END
	-- コメントオプション用(閲覧者)
	IF @w_comment_option_viewer_use_typ = 0 AND (@P_login_user_type = 3 OR @w_admin_and_is_viewer = 1)
	BEGIN
		UPDATE #TABLE_PERMISON SET 
			btn_comment_option	=	0
		FROM #TABLE_PERMISON
	END
	-- [0]
	SELECT * FROM #TABLE_PERMISON
	-- DROP
	DROP TABLE #TABLE_PERMISON
END
GO
