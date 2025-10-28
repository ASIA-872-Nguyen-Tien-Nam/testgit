IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_oM0110_INQ1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_oM0110_INQ1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：oM0110 - Refer
 *
 *  作成日  ：2020/10/23
 *  作成者  ：ANS-ASIA DUONGNTT
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_oM0110_INQ1]
	@P_category1_cd		SMALLINT = 0
,	@P_company_cd		SMALLINT = 0
,	@P_refer_kbn		TINYINT  = 0
AS
BEGIN
	SET NOCOUNT ON;

	CREATE TABLE #RESULT(
		id					INT IDENTITY(1,1)
	,	company_cd			SMALLINT
	,	category1_cd		SMALLINT
	,	refer_kbn			TINYINT
	,	category1_nm		NVARCHAR(50)
	,	category2_cd		SMALLINT
	,	category2_nm		NVARCHAR(50)
	,	category3_cd		SMALLINT
	,	category3_nm		NVARCHAR(50)
	,	question_cd			INT
	,	question			NVARCHAR(200)
	--
	,	row_span_cate2		INT
	,	row_span_cate3		INT
	,	num_cate2			INT
	,	num_cate3			INT
	)

	--
	INSERT INTO #RESULT
	SELECT
		M2110.company_cd			
	,	M2110.category1_cd	
	,	M2110.refer_kbn	
	,	M2110.category1_nm		
	,	M2111.category2_cd		
	,	M2111.category2_nm		
	,	M2112.category3_cd		
	,	M2112.category3_nm		
	,	M2113.question_cd			
	,	M2113.question		
	--
	,	COUNT(1)  OVER(PARTITION BY M2110.category1_cd, M2111.category2_cd ORDER BY M2110.category1_cd ASC, M2111.category2_cd ASC)	--number of category2_cd
	,	COUNT(1)  OVER(PARTITION BY M2110.category1_cd, M2111.category2_cd, M2112.category3_cd ORDER BY M2110.category1_cd, M2111.category2_cd ASC, M2112.category3_cd ASC)	--number of category3_cd
	,	ROW_NUMBER() OVER(PARTITION BY M2110.category1_cd, M2111.category2_cd ORDER BY M2110.category1_cd ASC, M2111.category2_cd ASC)	--number of category2_cd
	,	ROW_NUMBER() OVER(PARTITION BY M2110.category1_cd, M2111.category2_cd, M2112.category3_cd ORDER BY M2110.category1_cd, M2111.category2_cd ASC, M2112.category3_cd ASC)	--number of category3_cd
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
	ORDER BY 
		M2110.category1_cd		
	,	M2111.category2_cd		
	,	M2112.category3_cd		
	,	M2113.question_cd	

	--[0]
	SELECT
		id				
	,	company_cd			
	,	category1_cd
	,	refer_kbn		
	,	category1_nm		
	,	category2_cd		
	,	category2_nm		
	,	category3_cd		
	,	category3_nm		
	,	question_cd			
	,	question	
	,	row_span_cate2	
	,	row_span_cate3	
	,	num_cate2	
	,	num_cate3				
	FROM #RESULT

	-- clean
	DROP TABLE #RESULT
END

GO
