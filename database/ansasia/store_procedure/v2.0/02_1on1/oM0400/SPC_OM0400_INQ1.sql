IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_OM0400_INQ1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_OM0400_INQ1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：OM0400 - Refer
 *
 *  作成日  ：2020/10/26
 *  作成者  ：ANS-ASIA nghianm
 *
 *  更新日  ：2021/05/14
 *  更新者  ：VIETDT
 *  更新内容：CR guideline point varchar(10) ->varchar(20)
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_OM0400_INQ1]
	@P_questionnaire_cd			SMALLINT		= 0
,	@P_company_cd				SMALLINT		= 0
,	@P_employee_cd				NVARCHAR(10)	= ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2	 = SYSDATETIME()
	---
	CREATE TABLE #RESULT (
		id					  INT IDENTITY(1,1)
	,	company_cd			  SMALLINT
	,	questionnaire_cd	  SMALLINT
	,	questionnaire_gyono	  SMALLINT
	,	question			  NVARCHAR(200)
	,	question_typ		  TINYINT
	,	sentence_use_typ	  TINYINT
	,	points_use_typ		  TINYINT
	,	guideline_10point	  NVARCHAR(20)
	,	guideline_5point	  NVARCHAR(20)
	,	guideline_0point	  NVARCHAR(20)
	,	arrange_order		  INT
	,	check_status		  TINYINT


	)
	CREATE TABLE #DOUBLE_KEY (
		company_cd			SMALLINT
	,	questionnaire_cd	SMALLINT
	,	questionnaire_gyono SMALLINT
	,	
	)
	--[0]
	SELECT 
		ISNULL(company_cd,0)				AS  company_cd		
	,	ISNULL(refer_kbn,0)					AS  refer_kbn
	,	ISNULL(refer_questionnaire_cd,0)	AS  refer_questionnaire_cd
	,	ISNULL(questionnaire_cd,0)			AS  questionnaire_cd
	,	ISNULL(questionnaire_nm,'')			AS  questionnaire_nm
	,	ISNULL(submit,0)					AS  submit			
	,	ISNULL(comment_use_typ,0)			AS  comment_use_typ	
	,	ISNULL(purpose,'')					AS  purpose			
	,	ISNULL(purpose_use_typ,0)			AS  purpose_use_typ	
	,	ISNULL(complement,'')				AS  complement		
	,	ISNULL(complement_use_typ,0)		AS  complement_use_typ	
	,	ISNULL(arrange_order,0)				AS  arrange_order	
	FROM M2400
	WHERE M2400.company_cd				= @P_company_cd
	AND M2400.questionnaire_cd			= @P_questionnaire_cd
	AND M2400.del_datetime IS NULL

	--INSERT INTO #RESULT
	INSERT INTO #RESULT
	SELECT 
		company_cd	
	,	questionnaire_cd	
	,	questionnaire_gyono
	,	question			
	,	question_typ		
	,	sentence_use_typ	
	,	points_use_typ	
	,	guideline_10point
	,	guideline_5point	
	,	guideline_0point	
	,	arrange_order		
	,	0
	FROM M2401
	WHERE M2401.company_cd		= @P_company_cd
	AND M2401.questionnaire_cd	= @P_questionnaire_cd
	AND M2401.del_datetime IS NULL

	--INSERT INTO #DOUBLE_KEY
	INSERT INTO #DOUBLE_KEY
	SELECT 
		2
	,	questionnaire_cd
	,	questionnaire_gyono
	FROM M2401
	WHERE M2401.questionnaire_cd = @P_questionnaire_cd 
	GROUP BY  M2401.questionnaire_cd,M2401.questionnaire_gyono HAVING count(company_cd) = 2

	----
	--UPDATE #RESULT
	UPDATE #RESULT
	SET
		#RESULT.check_status = 1
	FROM #RESULT
	INNER JOIN #DOUBLE_KEY ON (
		#RESULT.questionnaire_cd	= #DOUBLE_KEY.questionnaire_cd
	AND	#RESULT.company_cd			= #DOUBLE_KEY.company_cd
	AND #RESULT.questionnaire_gyono = #DOUBLE_KEY.questionnaire_gyono
	)
	WHERE #RESULT.question_typ = 1
	--[1]
	SELECT 
		ISNULL(company_cd,0)			AS	company_cd
	,	ISNULL(questionnaire_cd,0)		AS	questionnaire_cd
	,	ISNULL(questionnaire_gyono,0)	AS	questionnaire_gyono
	,	ISNULL(question,'')				AS	question
	,	ISNULL(question_typ,0)			AS	question_typ
	,	ISNULL(sentence_use_typ,0)		AS	sentence_use_typ
	,	ISNULL(points_use_typ,0)		AS	points_use_typ
	,	ISNULL(guideline_10point,'')	AS	guideline_10point
	,	ISNULL(guideline_5point,'')		AS	guideline_5point
	,	ISNULL(guideline_0point,'')		AS	guideline_0point
	,	ISNULL(arrange_order,0)			AS	arrange_order
	,	ISNULL(check_status,0)			AS	check_status
	FROM #RESULT
	--[2]
	SELECT FORMAT (@w_time,'yyyy/MM/dd HH:mm') AS current_times
	-- clean
	DROP TABLE #RESULT
	DROP TABLE #DOUBLE_KEY
END
GO
