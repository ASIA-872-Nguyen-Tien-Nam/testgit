IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_OI3010_INQ1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_OI3010_INQ1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：M0080 - Refer
 *
 *  作成日  ：2020/09/25
 *  作成者  ：ANS-ASIA nghianm
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_OI3010_INQ1]
	@P_company_cd		SMALLINT		= 0
,	@P_fiscal_year		SMALLINT		= 0
,	@P_1on1_group_cd	SMALLINT		= 0
,	@P_times			SMALLINT		= 0
,	@P_questionnaire_cd	SMALLINT		= 0
,	@P_employee_cd		NVARCHAR(10)	= 0
,	@P_coach_cd_cd		NVARCHAR(10)	= 0

AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@check_status TINYINT = 0
	--[0]
	SELECT 
		ISNULL(comment,'')		AS comment
	,	ISNULL(answer_no,0)		AS answer_no
	FROM F2310
	WHERE 
		F2310.company_cd		= @P_company_cd
	AND F2310.fiscal_year		= @P_fiscal_year
	AND F2310.[1on1_group_cd]	= @P_1on1_group_cd
	AND F2310.times				= @P_times
	AND F2310.questionnaire_cd	= @P_questionnaire_cd
	AND	F2310.employee_cd			=	@P_employee_cd
	AND F2310.del_datetime IS NULL
	--[1]
	SELECT 
		ISNULL(M2401.question,'')				AS	question
	,	ISNULL(M2401.questionnaire_cd,0)		AS	questionnaire_cd
	,	ISNULL(M2401.questionnaire_gyono,0)		AS	questionnaire_gyono
	,	ISNULL(M2401.question_typ,0)			AS	question_typ
	,	ISNULL(M2401.sentence_use_typ,0)		AS	sentence_use_typ
	,	ISNULL(M2401.points_use_typ,0)			AS	points_use_typ
	,	ISNULL(M2401.guideline_10point,'')		AS	guideline_10point
	,	ISNULL(M2401.guideline_5point,'')		AS	guideline_5point
	,	ISNULL(M2401.guideline_0point,'')		AS	guideline_0point
	,	ISNULL(M2401.arrange_order,0)			AS	arrange_order
	,	ISNULL(F2311.sentence_answer,'')		AS	sentence_answer
	,	ISNULL(F2311.points_answer,0)			AS	points_answer
	FROM M2401
	LEFT JOIN F2310 ON (
		M2401.company_cd			=	F2310.company_cd
	AND @P_fiscal_year				=	F2310.fiscal_year	
	AND @P_1on1_group_cd			=	F2310.[1on1_group_cd]
	AND @P_times					=	F2310.times	
	AND M2401.questionnaire_cd		=	F2310.questionnaire_cd
	AND	@P_employee_cd				=	F2310.employee_cd
	AND F2310.del_datetime IS NULL
	)
	LEFT JOIN F2311 ON (
		M2401.company_cd			= F2311.company_cd
	AND F2310.fiscal_year			= F2311.fiscal_year	
	AND F2310.[1on1_group_cd]		= F2311.[1on1_group_cd]
	AND F2310.times					= F2311.times			
	AND	F2310.questionnaire_cd		= F2311.questionnaire_cd
	AND	M2401.questionnaire_gyono	= F2311.questionnaire_gyono
	AND F2310.answer_no				= F2311.answer_no
	AND F2311.del_datetime IS NULL
	)
	WHERE 
		M2401.company_cd		= @P_company_cd
	AND M2401.questionnaire_cd	= @P_questionnaire_cd
	AND	M2401.del_datetime		IS NULL
	ORDER BY
		M2401.questionnaire_cd,M2401.questionnaire_gyono
	-----
	IF EXISTS (SELECT 1 FROM F2310 WHERE F2310.company_cd				= @P_company_cd
											AND	F2310.fiscal_year		= @P_fiscal_year
											AND	F2310.[1on1_group_cd]	= @P_1on1_group_cd
											AND F2310.times				= @P_times
											AND F2310.questionnaire_cd	= @P_questionnaire_cd
											AND	F2310.employee_cd		= @P_employee_cd)
	BEGIN
		SET @check_status = 1 -- 1:CHECKED ; 0:UN CHECKED
	END
	--[2]
	SELECT @check_status AS check_status 

END
GO
