IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_rI2010_LST1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_rI2010_LST1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_rI2010_LST1 782,2023,'890',4,1,'890'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET REPORTS FOR rI2010
--*  
--*  作成日/create date			:	2023/05/08						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2024/03/26
--*　更新者/updater				:	viettd
--*　更新内容/update content		:	add set_defualt
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rI2010_LST1]
	@P_company_cd			SMALLINT		=	0
,	@P_fiscal_year			SMALLINT		=	0
,	@P_employee_cd			NVARCHAR(10)	=	''
,	@P_report_kind			SMALLINT		=	0
,	@P_report_no			SMALLINT		=	0
,	@P_reaction_typ			SMALLINT		=	0	-- add 2024/03/26
,	@P_login_employee_cd	NVARCHAR(10)	=	''	-- LOGIN EMPLOYEE
AS
BEGIN
	--[0]
	DECLARE 
		@w_language			smallint		=	0	-- 1.JP 2.EN
	,	@w_user_id			nvarchar(50)	=	''
	,	@w_multilingual_option_use_typ	tinyint			=	0
	,	@w_multilingual_use_typ			tinyint			=	0
	--
	CREATE TABLE #TABLE_QUESTION (
		company_cd			smallint
	,	question_no			tinyint
	)

	CREATE TABLE #TABLE_QUESTION_JSON (
		company_cd			smallint
	,	question_no			tinyint
	,	answer_json			nvarchar(max)
	)
	--
	SELECT 
		@w_language =	ISNULL(S0010.[language],1)
	,	@w_user_id	=	ISNULL(S0010.[user_id],'')
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
	--
	INSERT INTO #TABLE_QUESTION
	SELECT 
		ISNULL(F4200.company_cd,0)		AS	company_cd
	,	ISNULL(M4201.question_no,0)		AS	question_no
	FROM F4200
	LEFT OUTER JOIN M4201 ON (
		F4200.company_cd		=	M4201.company_cd
	AND F4200.report_kind		=	M4201.report_kind
	AND F4200.sheet_cd			=	M4201.sheet_cd
	AND F4200.adaption_date		=	M4201.adaption_date
	AND M4201.del_datetime IS NULL
	)
	WHERE 
		F4200.company_cd			=	@P_company_cd
	AND F4200.fiscal_year			=	@P_fiscal_year
	AND F4200.employee_cd			=	@P_employee_cd
	AND F4200.report_kind			=	@P_report_kind
	AND F4200.report_no				=	@P_report_no
	AND F4200.del_datetime IS NULL
	--
	INSERT INTO #TABLE_QUESTION_JSON
	SELECT 
		#TABLE_QUESTION.company_cd
	,	#TABLE_QUESTION.question_no
	,	(
		SELECT 
			ISNULL(M4126.detail_no,0)		AS	"detail_no"
		,	ISNULL(M4126.detail_name,'')	AS	"detail_name"
		FROM M4126
		WHERE 
			M4126.company_cd	=	@P_company_cd
		AND M4126.question_no	=	#TABLE_QUESTION.question_no
		AND M4126.del_datetime IS NULL
		FOR JSON PATH
	)									AS	answer_json
	FROM #TABLE_QUESTION
	--[0]
	SELECT 
		ISNULL(F4200.status_cd,0)		AS	status_cd
	,	CASE 
			WHEN @w_language = 2
			THEN ISNULL(L0041.status_nm2,'')
			ELSE ISNULL(L0041.status_nm,'')
		END								AS	status_nm
	,	CASE 
			WHEN ISNULL(F4200.title,'') <> ''
			THEN ISNULL(F4200.title,'')
			ELSE IIF(@w_language = 2,CAST(ISNULL(F4200.times,0) AS NVARCHAR(10)) + SPACE(1) + 'Times',CAST(ISNULL(F4200.times,0) AS NVARCHAR(10))+'回')
		END								AS	title
	,	CASE 
			WHEN F4201_temp.company_cd IS NOT NULL
			THEN FORMAT(F4201_temp.report_date,'yyyy/MM/dd')
			WHEN F4201.company_cd IS NOT NULL
			THEN FORMAT(F4201.report_date,'yyyy/MM/dd')
			ELSE ''
		END									AS	report_date
	,	CASE
			WHEN F4100.[start_date] IS NOT NULL AND F4100.deadline_date IS NOT NULL
			THEN FORMAT(F4100.[start_date],'yyyy/MM/dd') + '～' + FORMAT(F4100.deadline_date,'yyyy/MM/dd')
			WHEN F4100.[start_date] IS NULL AND F4100.deadline_date IS NOT NULL
			THEN '～' + FORMAT(F4100.deadline_date,'yyyy/MM/dd')
			WHEN F4100.[start_date] IS NOT NULL AND F4100.deadline_date IS NULL
			THEN FORMAT(F4100.[start_date],'yyyy/MM/dd') + '～'
			ELSE SPACE(0)
		END									AS	target_period
	,	ISNULL(M0070.employee_nm,'')		AS	employee_nm
	,	ISNULL(M4200.adequacy_use_typ,0)	AS	adequacy_use_typ
	,	ISNULL(M4200.busyness_use_typ,0)	AS	busyness_use_typ
	,	ISNULL(M4200.other_use_typ,0)		AS	other_use_typ
	,	ISNULL(M4200.comment_use_typ,0)		AS	comment_use_typ
	,	CASE 
			WHEN F4201_temp.company_cd IS NOT NULL
			THEN ISNULL(F4201_temp.adequacy_kbn,0)
			ELSE ISNULL(F4201.adequacy_kbn,0)
		END							AS	adequacy_kbn
	,	CASE 
			WHEN F4201_temp.company_cd IS NOT NULL
			THEN ISNULL(F4201_temp.busyness_kbn,0)
			ELSE ISNULL(F4201.busyness_kbn,0)
		END							AS	busyness_kbn
	,	CASE 
			WHEN F4201_temp.company_cd IS NOT NULL
			THEN ISNULL(F4201_temp.other_kbn,0)
			ELSE ISNULL(F4201.other_kbn,0)
		END							AS	other_kbn
	,	CASE 
			WHEN F4201_temp.company_cd IS NOT NULL
			THEN ISNULL(F4201_temp.free_comment,'')
			ELSE ISNULL(F4201.free_comment,'')
		END							AS	free_comment
	,	ISNULL(F4201.submission_user,'') AS	free_comment_user
	,	ISNULL(L0014.language_name,'日本語') AS	free_comment_user_language
	,	iif(ISNULL(F4201_tr.free_comment,'')='',ISNULL(F4201_trd.free_comment,''),ISNULL(F4201_tr.free_comment,'')) AS	free_comment_tr
	,	CASE 
			WHEN F4204_temp.company_cd IS NOT NULL
			THEN ISNULL(F4204_temp.comment,'')
			ELSE ISNULL(F4204.comment,'')
		END								AS	comment				-- コメント欄 (footer)
	,	iif(ISNULL(F4204_tr.comment,'')='',ISNULL(F4204_trd.comment,''),ISNULL(F4204_tr.comment,''))		AS	comment_tr
	,	CASE 
			WHEN F4204_temp.company_cd IS NOT NULL
			THEN ISNULL(F4204_temp.reaction_cd,0)
			WHEN F4204.company_cd IS NOT NULL
			THEN ISNULL(F4204.reaction_cd,0)
			ELSE ISNULL(F4301.reaction_cd,0)
		END									AS	reaction_cd			-- リアクション (footer)
	,	CASE 
			WHEN @P_login_employee_cd = F4200.employee_cd
			THEN 2
			ELSE 1
		END									AS	note_kind		-- ※ログインユーザー=報告者の場合は「2」、報告者以外の場合は「1」
	,	ISNULL(F4206.note_no,0)				AS	note_no
	,	ISNULL(F4206.note_explanation,'')	AS	note_explanation
	,	ISNULL(M4101.note_color,'')			AS	note_color
	,	ISNULL(M4101.note_name,'')			AS	note_name
	,	ISNULL(L0010_47.[name],'')			AS	note_color_code
	,	ISNULL(M0070_1.employee_nm,'')		AS	approver_employee_nm_1
	,	ISNULL(M0070_2.employee_nm,'')		AS	approver_employee_nm_2
	,	ISNULL(M0070_3.employee_nm,'')		AS	approver_employee_nm_3
	,	ISNULL(M0070_4.employee_nm,'')		AS	approver_employee_nm_4
	,	IIF(F4301.reaction_cd IS NULL,0,1)	AS	checked_default			-- リアクション (footer)
	FROM F4200
	LEFT OUTER JOIN M0070 ON (
		F4200.company_cd		=	M0070.company_cd
	AND F4200.employee_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4201 ON (
		F4200.company_cd		=	F4201.company_cd
	AND F4200.fiscal_year		=	F4201.fiscal_year
	AND F4200.employee_cd		=	F4201.employee_cd
	AND F4200.report_kind		=	F4201.report_kind
	AND F4200.report_no			=	F4201.report_no
	AND F4201.del_datetime IS NULL
	)
	--
	LEFT OUTER JOIN S0010 ON (
		F4201.company_cd			=	S0010.company_cd
	AND F4201.submission_user		=	S0010.[user_id]
	AND S0010.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0014 AS L0014 ON (
		S0010.supported_languages		=	L0014.language_cd
	)
	LEFT OUTER JOIN F4201_tr ON (
		F4200.company_cd		=	F4201_tr.company_cd
	AND F4200.fiscal_year		=	F4201_tr.fiscal_year
	AND F4200.employee_cd		=	F4201_tr.employee_cd
	AND F4200.report_kind		=	F4201_tr.report_kind
	AND F4200.report_no			=	F4201_tr.report_no
	AND @w_user_id				=	F4201_tr.trans_user
	AND F4201_tr.del_datetime IS NULL
	AND @w_multilingual_option_use_typ  =	1
	AND @w_multilingual_use_typ			=	1
	)
	LEFT OUTER JOIN F4201_tr AS F4201_trd ON (
		F4200.company_cd		=	F4201_trd.company_cd
	AND F4200.fiscal_year		=	F4201_trd.fiscal_year
	AND F4200.employee_cd		=	F4201_trd.employee_cd
	AND F4200.report_kind		=	F4201_trd.report_kind
	AND F4200.report_no			=	F4201_trd.report_no
	AND ''						=	F4201_trd.trans_user
	AND F4201_trd.del_datetime IS NULL
	AND @w_multilingual_option_use_typ  =	1
	--AND @w_multilingual_use_typ			=	1
	)
	LEFT OUTER JOIN F4201_temp ON (
		F4200.company_cd		=	F4201_temp.company_cd
	AND F4200.fiscal_year		=	F4201_temp.fiscal_year
	AND F4200.employee_cd		=	F4201_temp.employee_cd
	AND F4200.report_kind		=	F4201_temp.report_kind
	AND F4200.report_no			=	F4201_temp.report_no
	AND @w_user_id				=	F4201_temp.keep_user
	AND F4201_temp.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0041 ON (
		F4200.status_cd	=	L0041.status_cd
	AND L0041.del_datetime IS NULL
	)
	LEFT OUTER JOIN M4200 ON (
		F4200.company_cd		=	M4200.company_cd
	AND F4200.report_kind		=	M4200.report_kind
	AND F4200.sheet_cd			=	M4200.sheet_cd
	AND F4200.adaption_date		=	M4200.adaption_date
	AND M4200.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4204_temp ON(
		@P_company_cd			=	F4204_temp.company_cd
	AND @P_fiscal_year			=	F4204_temp.fiscal_year
	AND @P_employee_cd			=	F4204_temp.employee_cd
	AND @P_report_kind			=	F4204_temp.report_kind
	AND @P_report_no			=	F4204_temp.report_no
	AND @P_login_employee_cd	=	F4204_temp.reaction_no
	AND F4204_temp.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4204 ON(
		@P_company_cd			=	F4204.company_cd
	AND @P_fiscal_year			=	F4204.fiscal_year
	AND @P_employee_cd			=	F4204.employee_cd
	AND @P_report_kind			=	F4204.report_kind
	AND @P_report_no			=	F4204.report_no
	AND @P_login_employee_cd	=	F4204.reaction_no   -- hơi ảo ma <quang ko sửa chỗ này>
	AND F4204.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4204_tr ON(
		@P_company_cd			=	F4204_tr.company_cd
	AND @P_fiscal_year			=	F4204_tr.fiscal_year
	AND @P_employee_cd			=	F4204_tr.employee_cd
	AND @P_report_kind			=	F4204_tr.report_kind
	AND @P_report_no			=	F4204_tr.report_no
	AND F4204.reaction_no		=	F4204_tr.reaction_no
	AND @w_user_id				=	F4204_tr.trans_user
	AND F4204_tr.del_datetime IS NULL
	AND @w_multilingual_option_use_typ  =	1
	AND @w_multilingual_use_typ			=	1
	)
	LEFT OUTER JOIN F4204_tr AS F4204_trd ON(
		@P_company_cd			=	F4204_trd.company_cd
	AND @P_fiscal_year			=	F4204_trd.fiscal_year
	AND @P_employee_cd			=	F4204_trd.employee_cd
	AND @P_report_kind			=	F4204_trd.report_kind
	AND @P_report_no			=	F4204_trd.report_no
	AND F4204.reaction_no		=	F4204_trd.reaction_no
	AND ''						=	F4204_trd.trans_user
	AND F4204_trd.del_datetime IS NULL
	AND @w_multilingual_option_use_typ  =	1
	--AND @w_multilingual_use_typ			=	1
	)
	LEFT OUTER JOIN F4301 ON (
		@P_company_cd				=	F4301.company_cd
	AND @P_login_employee_cd		=	F4301.employee_cd
	AND @P_reaction_typ				=	F4301.reaction_typ
	AND F4301.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4206 ON(
		@P_company_cd			=	F4206.company_cd
	AND @P_fiscal_year			=	F4206.fiscal_year
	AND @P_employee_cd			=	F4206.employee_cd
	AND @P_report_kind			=	F4206.report_kind
	AND @P_report_no			=	F4206.report_no
	AND @P_login_employee_cd	=	F4206.note_employee_cd
	AND F4206.del_datetime IS NULL
	)
	LEFT OUTER JOIN M4101 ON (
		F4206.company_cd		=	M4101.company_cd
	AND F4206.note_kind			=	M4101.note_kind
	AND F4206.note_no			=	M4101.detail_no
	AND M4101.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0010 AS L0010_47 ON(
		47						=	L0010_47.name_typ
	AND M4101.note_color		=	L0010_47.number_cd
	AND L0010_47.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4110 ON (
		F4200.company_cd		=	F4110.company_cd
	AND F4200.fiscal_year		=	F4110.fiscal_year
	AND F4200.employee_cd		=	F4110.employee_cd
	AND F4200.report_kind		=	F4110.report_kind
	AND F4200.report_no			=	F4110.report_no
	AND F4110.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4100 ON (
		F4110.company_cd		=	F4100.company_cd
	AND F4110.fiscal_year		=	F4100.fiscal_year
	AND F4110.group_cd			=	F4100.group_cd
	AND F4110.report_kind		=	F4100.report_kind
	AND F4110.times				=	F4100.detail_no
	AND F4100.del_datetime IS NULL
	)
	LEFT OUTER JOIN M0070 AS M0070_1 ON (
		F4200.company_cd				=	M0070_1.company_cd
	AND F4200.approver_employee_cd_1	=	M0070_1.employee_cd
	AND M0070_1.del_datetime IS NULL
	)
	LEFT OUTER JOIN M0070 AS M0070_2 ON (
		F4200.company_cd				=	M0070_2.company_cd
	AND F4200.approver_employee_cd_2	=	M0070_2.employee_cd
	AND M0070_2.del_datetime IS NULL
	)
	LEFT OUTER JOIN M0070 AS M0070_3 ON (
		F4200.company_cd				=	M0070_3.company_cd
	AND F4200.approver_employee_cd_3	=	M0070_3.employee_cd
	AND M0070_3.del_datetime IS NULL
	)
	LEFT OUTER JOIN M0070 AS M0070_4 ON (
		F4200.company_cd				=	M0070_4.company_cd
	AND F4200.approver_employee_cd_4	=	M0070_4.employee_cd
	AND M0070_4.del_datetime IS NULL
	)
	WHERE 
		F4200.company_cd			=	@P_company_cd
	AND F4200.fiscal_year			=	@P_fiscal_year
	AND F4200.employee_cd			=	@P_employee_cd
	AND F4200.report_kind			=	@P_report_kind
	AND F4200.report_no				=	@P_report_no
	AND F4200.del_datetime IS NULL
	-- [1] 質問明細
	SELECT 
		--質問
		ISNULL(M4201.question_no,0)		AS	question_no
	,	ISNULL(M4201.question,'')		AS	question
	,	ISNULL(M4125.answer_kind,0)		AS	answer_kind
	,	CASE 
			WHEN ISNULL(M4125.answer_digits,0) > 1200
			THEN 1200
			ELSE ISNULL(M4125.answer_digits,0)
		END								AS	answer_digits
	,	ISNULL(M4125.answer_kbn,0)		AS	answer_kbn
	--	回答
	,	CASE 
			WHEN F4200.status_cd = 1 AND F4202_temp.company_cd IS NOT NULL
			THEN ISNULL(F4202_temp.answer_sentence,'')
			ELSE ISNULL(F4202.answer_sentence,'')
		END								AS	answer_sentence
	,  ISNULL(S0010.user_id,'')				AS	answer_user
	,  ISNULL(L0014.language_name,'日本語')				AS	answer_user_language
	,	CASE 
			WHEN ISNULL(M4125.answer_kind,0) = 1
			THEN iif(ISNULL(F4202_tr.answer_sentence,'')='',ISNULL(F4202_trd.answer_sentence,''),ISNULL(F4202_tr.answer_sentence,''))
			ELSE ''
		END								AS	answer_sentence_tr
	,	CASE 
			WHEN F4200.status_cd = 1 AND F4202_temp.company_cd IS NOT NULL
			THEN ISNULL(F4202_temp.answer_number,0)
			ELSE ISNULL(F4202.answer_number,0)
		END								AS	answer_number
	,	CASE 
			WHEN F4200.status_cd = 1 AND F4202_temp.company_cd IS NOT NULL
			THEN ISNULL(F4202_temp.answer_select,0)
			ELSE ISNULL(F4202.answer_select,0)
		END								AS	answer_select
	,	ISNULL(#TABLE_QUESTION_JSON.answer_json,'')
										AS	answer_json
	,	CASE 
			WHEN F4202_temp.company_cd IS NOT NULL
			THEN ISNULL(F4202_temp.approver_comment,'')
			ELSE 
				CASE
					WHEN F4200.approver_employee_cd_1 = @P_login_employee_cd
					THEN ISNULL(F4202.approver_comment_1,'')
					WHEN F4200.approver_employee_cd_2 = @P_login_employee_cd
					THEN ISNULL(F4202.approver_comment_2,'')
					WHEN F4200.approver_employee_cd_3 = @P_login_employee_cd
					THEN ISNULL(F4202.approver_comment_3,'')
					WHEN F4200.approver_employee_cd_4 = @P_login_employee_cd
					THEN ISNULL(F4202.approver_comment_4,'')
					WHEN (
						F4200.status_cd = 6 
					AND	F4200.approver_employee_cd_1 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_2 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_3 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_4 <> @P_login_employee_cd
					)
					THEN ISNULL(F4202.approver_comment_1,'') + CHAR(10) + ISNULL(F4202.approver_comment_2,'')+ CHAR(10) + ISNULL(F4202.approver_comment_3,'')+ CHAR(10) + ISNULL(F4202.approver_comment_4,'')
					ELSE SPACE(0)
				END
		END								AS	approver_comment
	,	ISNULL(F4202.approver_comment_1,'')			AS	approver_comment_1
	,	ISNULL(F4202.approver_comment_2,'')			AS	approver_comment_2
	,	ISNULL(F4202.approver_comment_3,'')			AS	approver_comment_3
	,	ISNULL(F4202.approver_comment_4,'')			AS	approver_comment_4
	,	ISNULL(F4200.approver_user_1,'')			AS	approver_user_1
	,	ISNULL(F4200.approver_user_2,'')			AS	approver_user_2
	,	ISNULL(F4200.approver_user_3,'')			AS	approver_user_3
	,	ISNULL(F4200.approver_user_4,'')			AS	approver_user_4
	,	ISNULL(L0014_1.language_name,'日本語')		AS	approver_user_1_language
	,	ISNULL(L0014_2.language_name,'日本語')		AS	approver_user_2_language
	,	ISNULL(L0014_3.language_name,'日本語')		AS	approver_user_3_language
	,	ISNULL(L0014_4.language_name,'日本語')		AS	approver_user_4_language
	,	CASE 
			WHEN F4202_temp.company_cd IS NOT NULL
			THEN ''
			ELSE 
				CASE
					WHEN F4200.approver_employee_cd_1 = @P_login_employee_cd
					THEN iif(ISNULL(F4202_tr.approver_comment_1,'')='',ISNULL(F4202_trd.approver_comment_1,''),ISNULL(F4202_tr.approver_comment_1,''))
					WHEN F4200.approver_employee_cd_2 = @P_login_employee_cd
					THEN iif(ISNULL(F4202_tr.approver_comment_2,'')='',ISNULL(F4202_trd.approver_comment_2,''),ISNULL(F4202_tr.approver_comment_2,''))
					WHEN F4200.approver_employee_cd_3 = @P_login_employee_cd
					THEN iif(ISNULL(F4202_tr.approver_comment_3,'')='',ISNULL(F4202_trd.approver_comment_3,''),ISNULL(F4202_tr.approver_comment_3,''))
					WHEN F4200.approver_employee_cd_4 = @P_login_employee_cd
					THEN iif(ISNULL(F4202_tr.approver_comment_4,'')='',ISNULL(F4202_trd.approver_comment_4,''),ISNULL(F4202_tr.approver_comment_4,''))
					WHEN (
						F4200.status_cd = 6 
					AND	F4200.approver_employee_cd_1 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_2 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_3 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_4 <> @P_login_employee_cd
					)
					THEN iif(ISNULL(F4202_tr.approver_comment_1,'')='',ISNULL(F4202_trd.approver_comment_1,''),ISNULL(F4202_tr.approver_comment_1,'')) + CHAR(10) + iif(ISNULL(F4202_tr.approver_comment_2,'')='',ISNULL(F4202_trd.approver_comment_2,''),ISNULL(F4202_tr.approver_comment_2,''))+ CHAR(10) + iif(ISNULL(F4202_tr.approver_comment_3,'')='',ISNULL(F4202_trd.approver_comment_3,''),ISNULL(F4202_tr.approver_comment_3,''))+ CHAR(10) + iif(ISNULL(F4202_tr.approver_comment_4,'')='',ISNULL(F4202_trd.approver_comment_4,''),ISNULL(F4202_tr.approver_comment_4,''))
					ELSE SPACE(0)
				END
		END								AS	approver_comment_tr
	,	CASE 
			WHEN F4202_temp.company_cd IS NOT NULL
			THEN ISNULL(F4202_temp.approver_comment,'')
			ELSE 
				CASE
					WHEN F4200.approver_employee_cd_1 = @P_login_employee_cd
					THEN ISNULL(F4202.approver_comment_1,'')
					WHEN (
						F4200.status_cd = 6 
					AND	F4200.approver_employee_cd_1 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_2 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_3 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_4 <> @P_login_employee_cd
					)
					THEN ISNULL(F4202.approver_comment_1,'')
					ELSE SPACE(0)
				END
		END								AS	approver_comment_1_show
	,	CASE 
			WHEN F4202_temp.company_cd IS NOT NULL
			THEN ''
			ELSE 
				CASE
					WHEN F4200.approver_employee_cd_1 = @P_login_employee_cd
					THEN iif(ISNULL(F4202_tr.approver_comment_1,'')='',ISNULL(F4202_trd.approver_comment_1,''),ISNULL(F4202_tr.approver_comment_1,''))
				
					WHEN (
						F4200.status_cd = 6 
					AND	F4200.approver_employee_cd_1 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_2 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_3 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_4 <> @P_login_employee_cd
					)
					THEN iif(ISNULL(F4202_tr.approver_comment_1,'')='',ISNULL(F4202_trd.approver_comment_1,''),ISNULL(F4202_tr.approver_comment_1,''))
					ELSE SPACE(0)
				END
		END								AS	approver_comment_1_show_tr
		,	CASE 
			WHEN F4202_temp.company_cd IS NOT NULL
			THEN ISNULL(F4202_temp.approver_comment,'')
			ELSE 
				CASE
					WHEN F4200.approver_employee_cd_2 = @P_login_employee_cd
					THEN ISNULL(F4202.approver_comment_2,'')
					WHEN (
						F4200.status_cd = 6 
					AND	F4200.approver_employee_cd_1 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_2 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_3 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_4 <> @P_login_employee_cd
					)
					THEN ISNULL(F4202.approver_comment_2,'')
					ELSE SPACE(0)
				END
		END								AS	approver_comment_2_show
	,	CASE 
			WHEN F4202_temp.company_cd IS NOT NULL
			THEN ''
			ELSE 
				CASE
					WHEN F4200.approver_employee_cd_2 = @P_login_employee_cd
					THEN iif(ISNULL(F4202_tr.approver_comment_2,'')='',ISNULL(F4202_trd.approver_comment_2,''),ISNULL(F4202_tr.approver_comment_2,''))
				
					WHEN (
						F4200.status_cd = 6 
					AND	F4200.approver_employee_cd_1 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_2 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_3 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_4 <> @P_login_employee_cd
					)
					THEN iif(ISNULL(F4202_tr.approver_comment_2,'')='',ISNULL(F4202_trd.approver_comment_2,''),ISNULL(F4202_tr.approver_comment_2,''))
					ELSE SPACE(0)
				END
		END								AS	approver_comment_2_show_tr
		,	CASE 
			WHEN F4202_temp.company_cd IS NOT NULL
			THEN ISNULL(F4202_temp.approver_comment,'')
			ELSE 
				CASE
					WHEN F4200.approver_employee_cd_3 = @P_login_employee_cd
					THEN ISNULL(F4202.approver_comment_3,'')
					WHEN (
						F4200.status_cd = 6 
					AND	F4200.approver_employee_cd_1 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_2 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_3 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_4 <> @P_login_employee_cd
					)
					THEN ISNULL(F4202.approver_comment_3,'')
					ELSE SPACE(0)
				END
		END								AS	approver_comment_3_show
	,	CASE 
			WHEN F4202_temp.company_cd IS NOT NULL
			THEN ''
			ELSE 
				CASE
					WHEN F4200.approver_employee_cd_3 = @P_login_employee_cd
					THEN iif(ISNULL(F4202_tr.approver_comment_3,'')='',ISNULL(F4202_trd.approver_comment_3,''),ISNULL(F4202_tr.approver_comment_3,''))
				
					WHEN (
						F4200.status_cd = 6 
					AND	F4200.approver_employee_cd_1 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_2 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_3 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_4 <> @P_login_employee_cd
					)
					THEN iif(ISNULL(F4202_tr.approver_comment_3,'')='',ISNULL(F4202_trd.approver_comment_3,''),ISNULL(F4202_tr.approver_comment_3,''))
					ELSE SPACE(0)
				END
		END								AS	approver_comment_3_show_tr
	,	CASE 
			WHEN F4202_temp.company_cd IS NOT NULL
			THEN ISNULL(F4202_temp.approver_comment,'')
			ELSE 
				CASE
					WHEN F4200.approver_employee_cd_4 = @P_login_employee_cd
					THEN ISNULL(F4202.approver_comment_4,'')
					WHEN (
						F4200.status_cd = 6 
					AND	F4200.approver_employee_cd_1 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_2 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_3 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_4 <> @P_login_employee_cd
					)
					THEN ISNULL(F4202.approver_comment_4,'')
					ELSE SPACE(0)
				END
		END								AS	approver_comment_4_show
	,	CASE 
			WHEN F4202_temp.company_cd IS NOT NULL
			THEN ''
			ELSE 
				CASE
					WHEN F4200.approver_employee_cd_4 = @P_login_employee_cd
					THEN iif(ISNULL(F4202_tr.approver_comment_4,'')='',ISNULL(F4202_trd.approver_comment_4,''),ISNULL(F4202_tr.approver_comment_4,''))
				
					WHEN (
						F4200.status_cd = 6 
					AND	F4200.approver_employee_cd_1 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_2 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_3 <> @P_login_employee_cd
					AND	F4200.approver_employee_cd_4 <> @P_login_employee_cd
					)
					THEN iif(ISNULL(F4202_tr.approver_comment_4,'')='',ISNULL(F4202_trd.approver_comment_4,''),ISNULL(F4202_tr.approver_comment_4,''))
					ELSE SPACE(0)
				END
		END								AS	approver_comment_4_show_tr
	FROM F4200
	LEFT OUTER JOIN M4201 ON (
		F4200.company_cd		=	M4201.company_cd
	AND F4200.report_kind		=	M4201.report_kind
	AND F4200.sheet_cd			=	M4201.sheet_cd
	AND F4200.adaption_date		=	M4201.adaption_date
	AND M4201.del_datetime IS NULL
	)
	LEFT OUTER JOIN M4125 ON (
		M4201.company_cd		=	M4125.company_cd
	AND M4201.question_no		=	M4125.question_no
	AND M4125.del_datetime IS NULL
	)
	LEFT OUTER JOIN #TABLE_QUESTION_JSON ON (
		M4125.company_cd		=	#TABLE_QUESTION_JSON.company_cd
	AND M4125.question_no		=	#TABLE_QUESTION_JSON.question_no
	)
	LEFT OUTER JOIN F4202_temp ON (
		@P_company_cd			=	F4202_temp.company_cd
	AND	@P_fiscal_year			=	F4202_temp.fiscal_year
	AND	@P_employee_cd			=	F4202_temp.employee_cd
	AND @P_report_kind			=	F4202_temp.report_kind
	AND @P_report_no			=	F4202_temp.report_no
	AND M4201.question_no		=	F4202_temp.question_no
	AND @w_user_id				=	F4202_temp.keep_user
	AND F4202_temp.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4202 ON (
		@P_company_cd			=	F4202.company_cd
	AND	@P_fiscal_year			=	F4202.fiscal_year
	AND	@P_employee_cd			=	F4202.employee_cd
	AND @P_report_kind			=	F4202.report_kind
	AND @P_report_no			=	F4202.report_no
	AND M4201.question_no		=	F4202.question_no
	AND F4202.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4202_tr ON (
		@P_company_cd			=	F4202_tr.company_cd
	AND	@P_fiscal_year			=	F4202_tr.fiscal_year
	AND	@P_employee_cd			=	F4202_tr.employee_cd
	AND @P_report_kind			=	F4202_tr.report_kind
	AND @P_report_no			=	F4202_tr.report_no
	AND M4201.question_no		=	F4202_tr.question_no
	AND @w_user_id				=	F4202_tr.trans_user
	AND F4202_tr.del_datetime IS NULL
	AND @w_multilingual_option_use_typ  =	1
	AND @w_multilingual_use_typ			=	1
	)
	LEFT OUTER JOIN F4202_tr AS F4202_trd ON (
		@P_company_cd			=	F4202_trd.company_cd
	AND	@P_fiscal_year			=	F4202_trd.fiscal_year
	AND	@P_employee_cd			=	F4202_trd.employee_cd
	AND @P_report_kind			=	F4202_trd.report_kind
	AND @P_report_no			=	F4202_trd.report_no
	AND M4201.question_no		=	F4202_trd.question_no
	AND ''						=	F4202_trd.trans_user
	AND F4202_trd.del_datetime IS NULL
	AND @w_multilingual_option_use_typ  =	1
	--AND @w_multilingual_use_typ			=	1
	)
	LEFT OUTER JOIN S0010 ON (
		@P_company_cd			=	S0010.company_cd
	AND	F4202.employee_cd		=	S0010.employee_cd
	AND S0010.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0014 AS L0014 ON (
		S0010.supported_languages		=	L0014.language_cd
	)
	LEFT OUTER JOIN S0010 AS S0010_1 ON (
		@P_company_cd			=	S0010_1.company_cd
	AND	F4200.approver_user_1	=	S0010_1.user_id
	AND S0010_1.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0014 AS L0014_1 ON (
		S0010_1.supported_languages		=	L0014_1.language_cd
	)
	LEFT OUTER JOIN S0010 AS S0010_2 ON (
		@P_company_cd			=	S0010_2.company_cd
	AND	F4200.approver_user_2	=	S0010_2.user_id
	AND S0010_2.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0014 AS L0014_2 ON (
		S0010_2.supported_languages		=	L0014_2.language_cd
	)
	LEFT OUTER JOIN S0010 AS S0010_3 ON (
		@P_company_cd			=	S0010_3.company_cd
	AND	F4200.approver_user_3	=	S0010_3.user_id
	AND S0010_3.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0014 AS L0014_3 ON (
		S0010_3.supported_languages		=	L0014_3.language_cd
	)
	LEFT OUTER JOIN S0010 AS S0010_4 ON (
		@P_company_cd			=	S0010_4.company_cd
	AND	F4200.approver_user_4	=	S0010_4.user_id
	AND S0010_4.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0014 AS L0014_4 ON (
		S0010_4.supported_languages		=	L0014_4.language_cd
	)

	WHERE 
		F4200.company_cd			=	@P_company_cd
	AND F4200.fiscal_year			=	@P_fiscal_year
	AND F4200.employee_cd			=	@P_employee_cd
	AND F4200.report_kind			=	@P_report_kind
	AND F4200.report_no				=	@P_report_no
	AND F4200.del_datetime IS NULL

	-- drop table
	DROP TABLE #TABLE_QUESTION
	DROP TABLE #TABLE_QUESTION_JSON
END
GO