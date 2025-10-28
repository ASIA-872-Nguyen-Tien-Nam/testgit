IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_rI2010_LST2]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_rI2010_LST2]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_rI2010_INQ1 782,2023,'890',4,1,'890'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET REACTIONS OR REJECTS FOR rI2010
--*  
--*  作成日/create date			:	2023/05/08						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rI2010_LST2]
	@P_company_cd			SMALLINT		=	0
,	@P_fiscal_year			SMALLINT		=	0
,	@P_employee_cd			NVARCHAR(10)	=	''
,	@P_report_kind			SMALLINT		=	0
,	@P_report_no			SMALLINT		=	0
,	@P_login_employee_cd	NVARCHAR(10)	=	''	-- LOGIN EMPLOYEE
,	@P_mode					SMALLINT		=	0	-- 0. GET REACTIONS & SHARED | 1.GET REJECT 2.共有情報(share with & share by)
AS
BEGIN
	--
	DECLARE 
		@w_login_user_id			nvarchar(50)		=	''
	,	@w_language					smallint			=	0
	,	@w_multilingual_option_use_typ tinyint			=	0
	,	@w_multilingual_use_typ		tinyint				=	0
	CREATE TABLE #TABLE_REACTIONS (
		id						int				identity(1,1)
	,	reaction_no				nvarchar(10)
	,	reply_no				smallint
	,	reaction_type			tinyint				--	0.reaction 1.reply 2.answer reply 3.share
	,	shareby_employee_cd		nvarchar(10)
	,	sharewith_employee_cd	nvarchar(10)
	)
	SELECT 
		@w_login_user_id	= S0010.[user_id]
	,	@w_language			= ISNULL(S0010.[language],1)	
	,	@w_multilingual_use_typ	=	ISNULL(S0010.multilingual_use_typ,0)
	,	@w_multilingual_option_use_typ = ISNULL(multilingual_option_use_typ,0)
	FROM S0010
	LEFT JOIN M9100 ON (
		@P_company_cd = M9100.company_cd
	AND M9100.del_datetime IS NULL
	)
	WHERE 
		S0010.company_cd	=	@P_company_cd
	AND S0010.employee_cd	=	@P_login_employee_cd
	AND S0010.del_datetime IS NULL
	IF @P_mode = 0
	BEGIN
		-- GET REACTIONS
		INSERT INTO #TABLE_REACTIONS
		SELECT 
			ISNULL(F4204.reaction_no,'')
		,	NULL							--	reply_no
		,	0								--	0.reaction 1.reply 2.answer reply
		,	NULL
		,	NULL
		FROM F4204
		LEFT OUTER JOIN F4200 ON (	
			F4204.company_cd			=	F4200.company_cd
		AND F4204.fiscal_year			=	F4200.fiscal_year
		AND F4204.employee_cd			=	F4200.employee_cd
		AND F4204.report_kind			=	F4200.report_kind
		AND F4204.report_no				=	F4200.report_no
		AND F4200.del_datetime IS NULL
		)
		WHERE 
			F4204.company_cd			=	@P_company_cd
		AND F4204.fiscal_year			=	@P_fiscal_year
		AND F4204.employee_cd			=	@P_employee_cd
		AND F4204.report_kind			=	@P_report_kind
		AND F4204.report_no				=	@P_report_no
		AND F4200.status_cd				>	1	-- 1.未処理
		AND F4204.del_datetime IS NULL
		AND (
			(F4204.reaction_no	=	@P_login_employee_cd)
		OR	(F4204.reaction_no	<>	@P_login_employee_cd AND F4204.reaction_datetime IS NOT NULL)
		)
		-- GET REACTIONS answer reply
		INSERT INTO #TABLE_REACTIONS
		SELECT 
			ISNULL(F4204.reaction_no,'')
		,	NULL							--	reply_no
		,	2								--	0.reaction 1.reply 2.answer reply
		,	NULL
		,	NULL
		FROM F4204
		LEFT OUTER JOIN F4200 ON (	
			F4204.company_cd			=	F4200.company_cd
		AND F4204.fiscal_year			=	F4200.fiscal_year
		AND F4204.employee_cd			=	F4200.employee_cd
		AND F4204.report_kind			=	F4200.report_kind
		AND F4204.report_no				=	F4200.report_no
		AND F4200.del_datetime IS NULL
		)
		WHERE 
			F4204.company_cd			=	@P_company_cd
		AND F4204.fiscal_year			=	@P_fiscal_year
		AND F4204.employee_cd			=	@P_employee_cd
		AND F4204.report_kind			=	@P_report_kind
		AND F4204.report_no				=	@P_report_no
		AND F4204.reaction_datetime IS NOT NULL
		AND F4204.del_datetime IS NULL
		AND F4200.status_cd				>	1	-- 1.未処理
		-- GET REPLY
		INSERT INTO #TABLE_REACTIONS
		SELECT 
			ISNULL(F4205.reaction_no,'')		AS	reaction_no
		,	ISNULL(F4205.reply_no,0)			AS	reply_no
		,	1								--	0.reaction 1.reply
		,	NULL
		,	NULL
		FROM #TABLE_REACTIONS
		LEFT OUTER JOIN F4205 ON (
			@P_company_cd					=	F4205.company_cd
		AND @P_fiscal_year					=	F4205.fiscal_year
		AND @P_employee_cd					=	F4205.employee_cd
		AND @P_report_kind					=	F4205.report_kind
		AND @P_report_no					=	F4205.report_no
		AND #TABLE_REACTIONS.reaction_no	=	F4205.reaction_no
		AND F4205.del_datetime IS NULL
		)
		WHERE 
			F4205.company_cd			=	@P_company_cd
		AND F4205.fiscal_year			=	@P_fiscal_year
		AND F4205.employee_cd			=	@P_employee_cd
		AND F4205.report_kind			=	@P_report_kind
		AND F4205.report_no				=	@P_report_no
		AND F4205.del_datetime IS NULL
		AND #TABLE_REACTIONS.reaction_type	=	0
		-- GET 共有情報
		INSERT INTO #TABLE_REACTIONS
		SELECT 
			'zzzzzzzzzz'
		,	NULL
		,	3
		,	ISNULL(F4207.shareby_employee_cd,'')
		,	ISNULL(F4207.sharewith_employee_cd,'')
		FROM F4207
		WHERE 
			F4207.company_cd			=	@P_company_cd
		AND F4207.fiscal_year			=	@P_fiscal_year
		AND F4207.employee_cd			=	@P_employee_cd
		AND F4207.report_kind			=	@P_report_kind
		AND F4207.report_no				=	@P_report_no
		AND F4207.share_kbn				=	1
		AND F4207.del_datetime IS NULL
		-- GOTO COMPLETED
		GOTO COMPLETED
	END
	IF @P_mode = 1
	BEGIN
		-- GET 差戻し情報
		INSERT INTO #TABLE_REACTIONS
		SELECT 
			'zzzzzzzzzz'
		,	NULL
		,	4
		,	ISNULL(F4900.from_employee_cd,'')
		,	ISNULL(F4900.to_employee_cd,'')
		FROM F4900
		WHERE 
			F4900.company_cd			=	@P_company_cd
		AND F4900.infomation_typ		=	5
		AND F4900.fiscal_year			=	@P_fiscal_year
		AND F4900.employee_cd			=	@P_employee_cd
		AND F4900.report_kind			=	@P_report_kind
		AND F4900.report_no				=	@P_report_no
		AND F4900.to_employee_cd		=	@P_login_employee_cd
		AND F4900.del_datetime IS NULL
		AND F4900.confirmation_datetime IS NULL
		-- GOTO COMPLETED
		GOTO COMPLETED
	END
	IF @P_mode = 2
	BEGIN
		-- GET 共有情報
		INSERT INTO #TABLE_REACTIONS
		SELECT 
			'zzzzzzzzzz'
		,	NULL
		,	5
		,	ISNULL(F4207.shareby_employee_cd,'')
		,	ISNULL(F4207.sharewith_employee_cd,'')
		FROM F4207
		WHERE 
			F4207.company_cd			=	@P_company_cd
		AND F4207.fiscal_year			=	@P_fiscal_year
		AND F4207.employee_cd			=	@P_employee_cd
		AND F4207.report_kind			=	@P_report_kind
		AND F4207.report_no				=	@P_report_no
		AND (
			F4207.sharewith_employee_cd	=	@P_login_employee_cd
		OR	F4207.shareby_employee_cd	=	@P_login_employee_cd
		)
		AND F4207.del_datetime IS NULL
		-- GOTO COMPLETED
		GOTO COMPLETED
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- COMPLETED RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
COMPLETED:
	--[0] -- REACTIONS
	SELECT 
		ISNULL(F4204.reaction_no,'')				AS	reaction_no
	,	CASE 
			WHEN #TABLE_REACTIONS.reaction_type = 0
			THEN ISNULL(M0070.employee_nm,'')
			WHEN #TABLE_REACTIONS.reaction_type = 4
			THEN ISNULL(M0070_SHAREBY.employee_nm,'')
			WHEN #TABLE_REACTIONS.reaction_type = 5
			THEN ISNULL(M0070_SHAREBY.employee_nm,'')
			ELSE SPACE(0)
		END											AS	reaction_user
	,	CASE 
			WHEN #TABLE_REACTIONS.reaction_type = 0
			THEN ISNULL(F4204.comment,'')
			ELSE SPACE(0)
		END											AS	comment
	,	ISNULL(F4204.reaction_user,'')					AS	comment_user
	,	ISNULL(L0014_COMMENT.language_name,'日本語')					AS	comment_user_language
	,	CASE 
			WHEN #TABLE_REACTIONS.reaction_type = 0
			THEN iif(ISNULL(F4204_tr.comment,'')='',ISNULL(F4204_trd.comment,''),ISNULL(F4204_tr.comment,''))
			ELSE SPACE(0)
		END											AS	comment_tr
	,	CASE 
			WHEN #TABLE_REACTIONS.reaction_type = 0
			THEN ISNULL(F4204.reaction_cd,0)
			ELSE 0
		END											AS	reaction_cd
	,	CASE 
			WHEN #TABLE_REACTIONS.reaction_type = 0
			THEN FORMAT(F4204.reaction_datetime,'yyyy/MM/dd HH:mm')
			WHEN #TABLE_REACTIONS.reaction_type = 3
			THEN FORMAT(F4207.cre_datetime,'yyyy/MM/dd HH:mm')
			WHEN #TABLE_REACTIONS.reaction_type = 4
			THEN FORMAT(F4900.infomation_date,'yyyy/MM/dd')
			WHEN #TABLE_REACTIONS.reaction_type = 5
			THEN FORMAT(F4207.cre_datetime,'yyyy/MM/dd HH:mm')
			ELSE SPACE(0)
		END											AS	reaction_datetime
	-- reply
	,	ISNULL(F4205.reply_no,0)					AS	reply_no
	,	ISNULL(F4205.reply_cd,0)					AS	reply_cd
	,	ISNULL(F4205.reply_user,'')					AS	reply_user
	--,	ISNULL(F4205.reply_user,'')					AS	reply_comment_user
	,	ISNULL(L0014_REPLY.language_name,'日本語')	AS	reply_user_language
	,	ISNULL(M0070_REPLY.employee_nm,'')			AS	reply_user_nm
	,	FORMAT(F4205.reply_datetime,'yyyy/MM/dd HH:mm')			
													AS	reply_datetime
	,	ISNULL(F4205.comment,'')					AS	reply_comment
	,	iif(ISNULL(F4205_tr.comment,'')='',ISNULL(F4205_trd.comment,''),ISNULL(F4205_tr.comment,''))	AS	reply_comment_tr
	,	ISNULL(#TABLE_REACTIONS.reaction_type,0)	AS	reaction_type
	,	ISNULL(M0070_SHAREBY.employee_nm,'')		AS	shareby_employee_nm
	,	ISNULL(M0070_SHAREWITH.employee_nm,'')		AS	sharewith_employee_nm
	,	CASE 
			-- 共有情報
			WHEN @w_language = 2 AND #TABLE_REACTIONS.reaction_type = 3
			THEN ISNULL(M0070_SHAREBY.employee_nm,'') + SPACE(1) + 'shared with' + SPACE(1) + ISNULL(M0070_SHAREWITH.employee_nm,'')
			WHEN @w_language = 1 AND #TABLE_REACTIONS.reaction_type = 3
			THEN ISNULL(M0070_SHAREBY.employee_nm,'') + 'さんが' + ISNULL(M0070_SHAREWITH.employee_nm,'') + 'さんへ共有しました。'
			-- リアクション欄
			WHEN #TABLE_REACTIONS.reaction_type = 4
			THEN ISNULL(F4900.infomation_message,'')
			-- 共有先社員
			WHEN #TABLE_REACTIONS.reaction_type = 5 AND #TABLE_REACTIONS.sharewith_employee_cd = @P_login_employee_cd
			THEN ISNULL(F4207.share_explanation,'')
			-- 共有元社員
			WHEN #TABLE_REACTIONS.reaction_type = 5 AND #TABLE_REACTIONS.shareby_employee_cd = @P_login_employee_cd
			THEN IIF(@w_language = 2, 'Shared with '+ISNULL(M0070_SHAREWITH.employee_nm,''),ISNULL(M0070_SHAREWITH.employee_nm,'') + 'さんへ共有しました。')
			ELSE SPACE(0)
		END											AS	share_text
	,	CASE 
			WHEN F4200.employee_cd	=	@P_login_employee_cd
			THEN 1	-- reporter
			WHEN (
				F4200.approver_employee_cd_1	=	@P_login_employee_cd
			OR	F4200.approver_employee_cd_2	=	@P_login_employee_cd
			OR	F4200.approver_employee_cd_3	=	@P_login_employee_cd
			OR	F4200.approver_employee_cd_4	=	@P_login_employee_cd
			)
			THEN 2	-- approver
			ELSE 3	-- viewer					
		END									AS	login_use_typ
	,	CASE 
			WHEN ISNULL(M0070_REPLY.employee_cd,'') <> '' AND F4200.employee_cd	= ISNULL(M0070_REPLY.employee_cd,'')
			THEN 1	-- reporter
			WHEN ISNULL(M0070_REPLY.employee_cd,'') <> ''AND (F4200.approver_employee_cd_1	=	ISNULL(M0070_REPLY.employee_cd,''))
			THEN 2	-- approver
			WHEN ISNULL(M0070_REPLY.employee_cd,'') <> ''AND (F4200.approver_employee_cd_2	=	ISNULL(M0070_REPLY.employee_cd,''))
			THEN 2	-- approver
			WHEN ISNULL(M0070_REPLY.employee_cd,'') <> ''AND (F4200.approver_employee_cd_3	=	ISNULL(M0070_REPLY.employee_cd,''))
			THEN 2	-- approver
			WHEN ISNULL(M0070_REPLY.employee_cd,'') <> ''AND (F4200.approver_employee_cd_4	=	ISNULL(M0070_REPLY.employee_cd,''))
			THEN 2	-- approver
			WHEN ISNULL(M0070_REPLY.employee_cd,'') <> ''
			THEN 3	-- viewer
			ELSE 0				
		END									AS	reply_use_typ
	-- 0.HIDE 1.SHOW
	,	CASE 
			--REACTION
			WHEN #TABLE_REACTIONS.reaction_type = 0 AND #TABLE_REACTIONS.reaction_no = @P_login_employee_cd
			THEN 1
			--REPLY
			WHEN #TABLE_REACTIONS.reaction_type = 1 AND F4205.reply_user = @w_login_user_id
			THEN 1
			ELSE 0
		END									AS	btn_edit_status		
	FROM #TABLE_REACTIONS
	LEFT OUTER JOIN F4204 ON (
		@P_company_cd					=	F4204.company_cd
	AND @P_fiscal_year					=	F4204.fiscal_year
	AND @P_employee_cd					=	F4204.employee_cd
	AND @P_report_kind					=	F4204.report_kind
	AND @P_report_no					=	F4204.report_no
	AND #TABLE_REACTIONS.reaction_no	=	F4204.reaction_no
	AND F4204.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4204_tr ON (
		@P_company_cd					=	F4204_tr.company_cd
	AND @P_fiscal_year					=	F4204_tr.fiscal_year
	AND @P_employee_cd					=	F4204_tr.employee_cd
	AND @P_report_kind					=	F4204_tr.report_kind
	AND @P_report_no					=	F4204_tr.report_no
	AND #TABLE_REACTIONS.reaction_no	=	F4204_tr.reaction_no
	AND @w_login_user_id				=	F4204_tr.trans_user
	AND F4204_tr.del_datetime IS NULL
	AND @w_multilingual_option_use_typ  =	1
	AND @w_multilingual_use_typ			=	1
	)
	LEFT OUTER JOIN F4204_tr AS F4204_trd ON (
		@P_company_cd					=	F4204_trd.company_cd
	AND @P_fiscal_year					=	F4204_trd.fiscal_year
	AND @P_employee_cd					=	F4204_trd.employee_cd
	AND @P_report_kind					=	F4204_trd.report_kind
	AND @P_report_no					=	F4204_trd.report_no
	AND #TABLE_REACTIONS.reaction_no	=	F4204_trd.reaction_no
	AND ''								=	F4204_trd.trans_user
	AND F4204_trd.del_datetime IS NULL
	AND @w_multilingual_option_use_typ  =	1
	--AND @w_multilingual_use_typ			=	1
	)
	LEFT OUTER JOIN F4205 ON (
		@P_company_cd					=	F4205.company_cd
	AND @P_fiscal_year					=	F4205.fiscal_year
	AND @P_employee_cd					=	F4205.employee_cd
	AND @P_report_kind					=	F4205.report_kind
	AND @P_report_no					=	F4205.report_no
	AND #TABLE_REACTIONS.reaction_no	=	F4205.reaction_no
	AND #TABLE_REACTIONS.reply_no		=	F4205.reply_no
	AND F4205.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4205_tr ON (
		@P_company_cd					=	F4205_tr.company_cd
	AND @P_fiscal_year					=	F4205_tr.fiscal_year
	AND @P_employee_cd					=	F4205_tr.employee_cd
	AND @P_report_kind					=	F4205_tr.report_kind
	AND @P_report_no					=	F4205_tr.report_no
	AND #TABLE_REACTIONS.reaction_no	=	F4205_tr.reaction_no
	AND #TABLE_REACTIONS.reply_no		=	F4205_tr.reply_no
	AND @w_login_user_id				=	F4205_tr.trans_user
	AND F4205_tr.del_datetime IS NULL
	AND @w_multilingual_option_use_typ  =	1
	AND @w_multilingual_use_typ			=	1
	)
	LEFT OUTER JOIN F4205_tr AS	F4205_trd ON (
		@P_company_cd					=	F4205_trd.company_cd
	AND @P_fiscal_year					=	F4205_trd.fiscal_year
	AND @P_employee_cd					=	F4205_trd.employee_cd
	AND @P_report_kind					=	F4205_trd.report_kind
	AND @P_report_no					=	F4205_trd.report_no
	AND #TABLE_REACTIONS.reaction_no	=	F4205_trd.reaction_no
	AND #TABLE_REACTIONS.reply_no		=	F4205_trd.reply_no
	AND ''				=	F4205_trd.trans_user
	AND F4205_trd.del_datetime IS NULL
	AND @w_multilingual_option_use_typ  =	1
	--AND @w_multilingual_use_typ			=	1
	)
	LEFT OUTER JOIN M0070 ON (
		F4204.company_cd		=	M0070.company_cd
	AND F4204.reaction_no		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT OUTER JOIN S0010 ON (
		F4205.company_cd			=	S0010.company_cd
	AND F4205.reply_user			=	S0010.[user_id]
	AND S0010.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0014 AS L0014_REPLY ON (
		S0010.supported_languages		=	L0014_REPLY.language_cd
	)
	LEFT OUTER JOIN M0070 AS M0070_REPLY ON (
		S0010.company_cd		=	M0070_REPLY.company_cd
	AND S0010.employee_cd		=	M0070_REPLY.employee_cd
	AND M0070_REPLY.del_datetime IS NULL
	)
	--
	LEFT OUTER JOIN S0010 AS S0010_COMMENT ON (
		F4204.company_cd			=	S0010_COMMENT.company_cd
	AND F4204.reaction_user			=	S0010_COMMENT.[user_id]
	AND S0010_COMMENT.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0014 AS L0014_COMMENT ON (
		S0010_COMMENT.supported_languages		=	L0014_COMMENT.language_cd
	)
	LEFT OUTER JOIN F4200 ON (
		@P_company_cd					=	F4200.company_cd
	AND @P_fiscal_year					=	F4200.fiscal_year
	AND @P_employee_cd					=	F4200.employee_cd
	AND @P_report_kind					=	F4200.report_kind
	AND @P_report_no					=	F4200.report_no
	AND F4200.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4207 ON (
		@P_company_cd							=	F4207.company_cd
	AND @P_fiscal_year							=	F4207.fiscal_year
	AND @P_employee_cd							=	F4207.employee_cd
	AND @P_report_kind							=	F4207.report_kind
	AND @P_report_no							=	F4207.report_no
	AND #TABLE_REACTIONS.shareby_employee_cd	=	F4207.shareby_employee_cd
	AND #TABLE_REACTIONS.sharewith_employee_cd	=	F4207.sharewith_employee_cd
	AND F4207.del_datetime IS NULL
	)
	LEFT OUTER JOIN M0070 AS M0070_SHAREBY ON (
		@P_company_cd							=	M0070_SHAREBY.company_cd
	AND #TABLE_REACTIONS.shareby_employee_cd	=	M0070_SHAREBY.employee_cd
	AND M0070_SHAREBY.del_datetime IS NULL
	)
	LEFT OUTER JOIN M0070 AS M0070_SHAREWITH ON (
		@P_company_cd							=	M0070_SHAREWITH.company_cd
	AND #TABLE_REACTIONS.sharewith_employee_cd	=	M0070_SHAREWITH.employee_cd
	AND M0070_SHAREWITH.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4900 ON (
		@P_company_cd								=	F4900.company_cd
	AND 5											=	F4900.infomation_typ
	AND @P_fiscal_year								=	F4900.fiscal_year
	AND @P_employee_cd								=	F4900.employee_cd
	AND @P_report_kind								=	F4900.report_kind
	AND @P_report_no								=	F4900.report_no
	AND #TABLE_REACTIONS.sharewith_employee_cd		=	F4900.to_employee_cd
	AND #TABLE_REACTIONS.shareby_employee_cd		=	F4900.from_employee_cd
	AND F4900.del_datetime IS NULL
	)
	ORDER BY
		#TABLE_REACTIONS.reaction_no
	,	#TABLE_REACTIONS.reaction_type
	-- DROP TABLE
	DROP TABLE #TABLE_REACTIONS
END
GO
