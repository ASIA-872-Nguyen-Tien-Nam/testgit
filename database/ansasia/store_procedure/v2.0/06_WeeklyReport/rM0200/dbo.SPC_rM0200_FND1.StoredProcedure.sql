DROP PROCEDURE [SPC_RM0200_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	REFER DATA
--*		
--* 作成日/create date			:	2023/04/11											
--*	作成者/creater				:	namnt			
--*   		
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_RM0200_FND1]
	-- Add the parameters for the stored procedure here	
	@P_company_cd		SMALLINT		=	0
,	@P_report_kind		SMALLINT		=	0
,	@P_sheet_cd			SMALLINT		=	0
,	@P_adaption_date	DATE			=	NULL
,	@P_language			NVARCHAR(5)		=	'jp'
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_report_kind_1	SMALLINT		=	0
	,	@w_report_kind_2	SMALLINT		=	0
	,	@w_report_kind_3	SMALLINT		=	0
	,	@w_report_kind_4	SMALLINT		=	0
	,	@w_report_kind_5	SMALLINT		=	0
	---
	CREATE TABLE #M4100
	(
		option_cd			SMALLINT	
	,	option_nm			NVARCHAR(200)
	,	parent_option_cd_1	SMALLINT
	,	parent_option_cd_2	SMALLINT
	) 
	----get active report kind
	SET @w_report_kind_1 = (SELECT M4100.annualreport_user_typ FROM M4100 WHERE M4100.company_cd = @P_company_cd)
	SET @w_report_kind_2 = (SELECT M4100.semi_annualreport_user_typ FROM M4100 WHERE M4100.company_cd = @P_company_cd)
	SET @w_report_kind_3 = (SELECT M4100.quarterlyreport_user_typ FROM M4100 WHERE M4100.company_cd = @P_company_cd)
	SET @w_report_kind_4 = (SELECT M4100.monthlyreport_user_typ FROM M4100 WHERE M4100.company_cd = @P_company_cd)
	SET @w_report_kind_5 = (SELECT M4100.weeklyreport_user_typ FROM M4100 WHERE M4100.company_cd = @P_company_cd)
	--get menu option lv 1
	IF @w_report_kind_1 = 1
	BEGIN
	INSERT INTO #M4100
	SELECT
		1
	,	IIF(@P_language = 'en', L0010.name_english, L0010.name) 
	,	0
	,	0
	FROM L0010
	WHERE L0010.name_typ = 41
	AND L0010.number_cd = 1
	END
	IF @w_report_kind_2 = 1
	BEGIN
	INSERT INTO #M4100
	SELECT
		2
	,	IIF(@P_language = 'en', L0010.name_english, L0010.name) 
	,	0
	,	0
	FROM L0010
	WHERE L0010.name_typ = 41
	AND L0010.number_cd = 2
	END
	IF @w_report_kind_3 = 1
	BEGIN
	INSERT INTO #M4100
	SELECT
		3
	,	IIF(@P_language = 'en', L0010.name_english, L0010.name) 
	,	0
	,	0
	FROM L0010
	WHERE L0010.name_typ = 41
	AND L0010.number_cd = 3
	END
	--monthly
	IF @w_report_kind_4 = 1
	BEGIN
	INSERT INTO #M4100
	SELECT
		4
	,	IIF(@P_language = 'en', L0010.name_english, L0010.name) 
	,	0
	,	0
	FROM L0010
	WHERE L0010.name_typ = 41
	AND L0010.number_cd = 4
	END
	--weekly
	IF @w_report_kind_5 = 1
	BEGIN
	INSERT INTO #M4100
	SELECT
		5
	,	IIF(@P_language = 'en', L0010.name_english, L0010.name) 
	,	0
	,	0
	FROM L0010
	WHERE L0010.name_typ = 41
	AND L0010.number_cd = 5
	END
	--[0]
	SELECT 
		ISNULL(sheet_cd,0)							AS sheet_cd
	,	REPLACE(adaption_date, '-', '/')			AS adaption_date
	,	ISNULL(sheet_nm,'')							AS sheet_nm
	,	ISNULL(adequacy_use_typ,0)					AS adequacy_use_typ
	,	ISNULL(busyness_use_typ,0)					AS business_use_typ
	,	ISNULL(other_use_typ,0)						AS other_use_typ
	,	ISNULL(comment_use_typ,0)					AS comment_use_typ
	,	ISNULL(report_kind,0)						AS report_kind
	FROM M4200
	WHERE 
		company_cd		= @P_company_cd
	AND report_kind		= @P_report_kind
	AND	sheet_cd		= @P_sheet_cd
	AND	adaption_date	= @P_adaption_date
	AND del_datetime	IS NULL
	--[4]
	SELECT 
		ISNULL(sheet_detail_no, 0)  AS question_id
	,	ISNULL(question,'') AS question
	,	ISNULL(question_no,0) AS question_no
	FROM M4201
	WHERE 
		company_cd		= @P_company_cd
	AND report_kind		= @P_report_kind
	AND	sheet_cd		= @P_sheet_cd
	AND	adaption_date	= @P_adaption_date
	AND del_datetime	IS NULL
	SELECT * FROM #M4100
END
