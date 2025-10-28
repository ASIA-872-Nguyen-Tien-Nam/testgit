BEGIN
    DROP PROCEDURE [dbo].[SPC_rM0100_INQ1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：rM0100 - Refer
 *
 *  作成日  ：2023/04/07
 *  作成者  ：ANS-ASIA quangnd
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_rM0100_INQ1]
	@P_company_cd		SMALLINT		= 0
,	@P_report_kind		SMALLINT		= 0
,	@P_question_no		TINYINT			= 0
,	@P_language			NVARCHAR(2)		= ''
AS
BEGIN
	SET NOCOUNT ON;
	--[0]
	SELECT
		M4125.company_cd
	,	M4125.report_kind
	,	M4125.question_no
	,	ISNULL(M4125.question_title,'')	AS question_title
	,	ISNULL(M4125.arrange_order,0)	AS arrange_order
	,	ISNULL(M4125.question,'')		AS question
	,	ISNULL(M4125.answer_kind,0)		AS answer_kind
	,	ISNULL(M4125.answer_digits,0)	AS answer_digits
	,	ISNULL(M4125.answer_kbn,0)		AS answer_kbn
	FROM M4125
	WHERE
		M4125.company_cd	= @P_company_cd
	AND	M4125.report_kind	= @P_report_kind
	AND	M4125.question_no	= @P_question_no
	AND M4125.del_datetime IS NULL
	--[1]
	SELECT
		ISNULL(M4126.detail_no,0)		AS detail_no
	,	ISNULL(M4126.detail_name,'')	AS detail_name
	FROM  M4126
	WHERE
		M4126.company_cd	= @P_company_cd
	AND	M4126.question_no	= @P_question_no
	AND M4126.del_datetime IS NULL
END
GO
