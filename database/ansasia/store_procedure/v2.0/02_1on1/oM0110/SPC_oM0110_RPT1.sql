IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_oM0110_RPT1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_oM0110_RPT1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  ˆ—ŠT—vFoM0110 - Report
 *
 *  ì¬“ú  F2020/10/23
 *  ì¬ŽÒ  FANS-ASIA DUONGNTT
 *
 *  XV“ú  F
 *  XVŽÒ  F
 *  XV“à—eF
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_oM0110_RPT1]
	@P_category1_cd		SMALLINT = 0
,	@P_company_cd		SMALLINT = 0
,	@P_refer_kbn		TINYINT  = 0
,	@P_language			NVARCHAR(2)		= ''
AS
BEGIN
	SET NOCOUNT ON;
	--
	CREATE TABLE #HEADER 
	(
		category1_cd		NVARCHAR(20)
	,	category1_nm		NVARCHAR(50)
	,	category2_cd		NVARCHAR(20)
	,	category2_nm		NVARCHAR(50)
	,	category3_cd		NVARCHAR(20)
	,	category3_nm		NVARCHAR(50)
	,	question_cd			NVARCHAR(20)
	,	question			NVARCHAR(200)

	)

	IF (@P_language = 'en')
	BEGIN
		INSERT INTO #HEADER
		SELECT 
			'Large Category Code'					AS	category1_cd		
		,	'Large Category Name'						AS	category1_nm
		,	'Medium Category Code'					AS	category2_cd
		,	'Middle Category Name'						AS	category2_nm
		,	'Minor Category Code'					AS	category3_cd			
		,	'Minor Category Name'						AS	category3_nm	
		,	'Question Code'							AS	question_cd	
		,	'Question'								AS	question	
	END
	ELSE
	BEGIN
		INSERT INTO #HEADER
		SELECT 
			'大カテゴリーコード'					AS	category1_cd		
		,	'大カテゴリー名'						AS	category1_nm
		,	'中カテゴリーコード'					AS	category2_cd
		,	'中カテゴリー名'						AS	category2_nm
		,	'小カテゴリーコード'					AS	category3_cd			
		,	'小カテゴリー名'						AS	category3_nm	
		,	'質問コード'							AS	question_cd	
		,	'質問'								AS	question	
	END
	--[0]
	SELECT
		#HEADER.category1_cd
	,	#HEADER.category1_nm
	,	#HEADER.category2_cd
	,	#HEADER.category2_nm
	,	#HEADER.category3_cd
	,	#HEADER.category3_nm
	,	#HEADER.question_cd	
	,	#HEADER.question	
	FROM #HEADER
	UNION ALL
	SELECT
		CONVERT(NVARCHAR(20),M2110.category1_cd)
	,	ISNULL(M2110.category1_nm,'')	
	,	CONVERT(NVARCHAR(20),M2111.category2_cd)		
	,	ISNULL(M2111.category2_nm,'')		
	,	CONVERT(NVARCHAR(20),M2112.category3_cd)		
	,	ISNULL(M2112.category3_nm,'')		
	,	CONVERT(NVARCHAR(20),M2113.question_cd)			
	,	ISNULL(M2113.question,'')		
	FROM M2110
	LEFT JOIN M2111 ON (
		M2110.company_cd	=	M2111.company_cd
	AND M2110.category1_cd	=	M2111.category1_cd
	AND M2110.refer_kbn		=	M2111.refer_kbn
	)
	LEFT JOIN M2112 ON (
		M2110.company_cd	=	M2112.company_cd
	AND M2110.category1_cd	=	M2112.category1_cd
	AND M2110.refer_kbn		=	M2112.refer_kbn
	AND M2111.category2_cd	=	M2112.category2_cd
	)
	LEFT JOIN M2113 ON (
		M2110.company_cd	=	M2113.company_cd
	AND M2110.category1_cd	=	M2113.category1_cd
	AND M2110.refer_kbn		=	M2113.refer_kbn
	AND M2111.category2_cd	=	M2113.category2_cd
	AND M2112.category3_cd	=	M2113.category3_cd
	)
	WHERE
		M2110.company_cd	=	@P_company_cd
	AND	M2110.category1_cd	=	@P_category1_cd
	AND M2110.refer_kbn		=	@P_refer_kbn
	AND	M2110.del_datetime IS NULL
	AND M2111.del_datetime	IS NULL
	AND M2112.del_datetime	IS NULL
	AND M2113.del_datetime	IS NULL

	-- clean
	DROP TABLE #HEADER
END

GO
