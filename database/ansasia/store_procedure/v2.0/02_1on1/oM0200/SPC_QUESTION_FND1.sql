IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_QUESTION_FND1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_QUESTION_FND1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：QUESTION - search
 *
 *  作成日  ：2020/11/05
 *  作成者  ：ANS-ASIA DUONGNTT
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_QUESTION_FND1]
	@P_category1_cd		SMALLINT = 0
,	@P_category2_cd		SMALLINT = 0
,	@P_category3_cd		SMALLINT = 0
,	@P_refer_kbn		TINYINT = 0
,	@P_company_cd		SMALLINT = 0
,	@P_page_size		INT		=  20
,	@P_page				INT		=	1
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@order_by_min			INT					=	0
	,	@totalRecord			BIGINT				=	0
	,	@pageMax				INT					=	0	
	,	@page_size				INT					=	10
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
	,	row_span_cate1		INT
	,	row_span_cate2		INT
	,	row_span_cate3		INT
	,	num_cate1			INT
	,	num_cate2			INT
	,	num_cate3			INT
	)
	CREATE TABLE #USER_REFER (
		category1_cd		SMALLINT
	,	refer_kbn			TINYINT
	)
	CREATE TABLE #CATEGORY1(
		id					INT IDENTITY(1,1)
	,	refer_kbn			TINYINT
	,	category1_cd		SMALLINT
	,	category1_nm		NVARCHAR(50)
	)

	CREATE TABLE #CATEGORY2(
		id					INT IDENTITY(1,1)
	,	category2_cd		SMALLINT
	,	category2_nm		NVARCHAR(50)
	)

	CREATE TABLE #CATEGORY3(
		id					INT IDENTITY(1,1)
	,	category3_cd		SMALLINT
	,	category3_nm		NVARCHAR(50)
	)
	--
	INSERT INTO #CATEGORY1
	SELECT 
		M2110.refer_kbn
	,	M2110.category1_cd
	,	M2110.category1_nm
	FROM M2110
	WHERE
		M2110.company_cd	=	@P_company_cd
	AND	M2110.del_datetime IS NULL
	GROUP BY 
		M2110.refer_kbn
	,	M2110.category1_cd
	,	M2110.category1_nm

	--
	INSERT INTO #CATEGORY2
	SELECT
		M2111.category2_cd
	,	M2111.category2_nm
	FROM M2110
	LEFT JOIN M2111 ON (
		M2110.company_cd	=	M2111.company_cd
	AND M2110.category1_cd	=	M2111.category1_cd
	AND M2110.refer_kbn		=	M2111.refer_kbn
	)
	WHERE
		M2110.company_cd	=	@P_company_cd
	AND  M2110.category1_cd	=	@P_category1_cd
	AND 	
		(
		@P_refer_kbn		=   0
	OR  M2110.refer_kbn	=	@P_refer_kbn
	)
	AND	M2110.del_datetime IS NULL
	AND M2111.del_datetime	IS NULL
	GROUP BY 
		M2111.category2_cd
	,	M2111.category2_nm
	--
	INSERT INTO #CATEGORY3
	SELECT
		M2112.category3_cd
	,	M2112.category3_nm
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
	WHERE
		M2110.company_cd	=	@P_company_cd
	AND M2110.category1_cd	=	@P_category1_cd
	AND M2111.category2_cd	=	@P_category2_cd
	
	AND 	
		(
		@P_refer_kbn		=   0
	OR  M2110.refer_kbn	=	@P_refer_kbn
	)
	AND	M2110.del_datetime IS NULL
	AND M2111.del_datetime	IS NULL
	AND M2112.del_datetime	IS NULL
	GROUP BY 
		M2112.category3_cd
	,	M2112.category3_nm

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
	,	COUNT(1)  OVER(PARTITION BY M2110.company_cd, M2110.refer_kbn, M2110.category1_cd ORDER BY M2110.company_cd ASC, M2110.refer_kbn ASC, M2110.category1_cd ASC)	--number of category1_cd
	,	COUNT(1)  OVER(PARTITION BY M2110.company_cd, M2110.refer_kbn, M2110.category1_cd, M2111.category2_cd ORDER BY M2110.company_cd ASC, M2110.refer_kbn ASC, M2110.category1_cd ASC, M2111.category2_cd ASC)	--number of category2_cd
	,	COUNT(1)  OVER(PARTITION BY M2110.company_cd, M2110.refer_kbn, M2110.category1_cd, M2111.category2_cd, M2112.category3_cd ORDER BY M2110.company_cd ASC, M2110.refer_kbn ASC, M2110.category1_cd, M2111.category2_cd ASC, M2112.category3_cd ASC)	--number of category3_cd
	,	ROW_NUMBER()  OVER(PARTITION BY M2110.company_cd, M2110.refer_kbn, M2110.category1_cd ORDER BY M2110.company_cd ASC, M2110.refer_kbn ASC, M2110.category1_cd ASC)	--number of category1_cd
	,	ROW_NUMBER() OVER(PARTITION BY M2110.company_cd, M2110.refer_kbn, M2110.category1_cd, M2111.category2_cd ORDER BY M2110.company_cd ASC, M2110.refer_kbn ASC, M2110.category1_cd ASC, M2111.category2_cd ASC)	--number of category2_cd
	,	ROW_NUMBER() OVER(PARTITION BY M2110.company_cd, M2110.refer_kbn, M2110.category1_cd, M2111.category2_cd, M2112.category3_cd ORDER BY M2110.company_cd ASC, M2110.refer_kbn ASC, M2110.category1_cd, M2111.category2_cd ASC, M2112.category3_cd ASC)	--number of category3_cd
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
	AND 	
		(
		@P_category1_cd		=   0
	OR  M2110.category1_cd	=	@P_category1_cd
	)
	AND 	
		(
		@P_category2_cd		=   0
	OR  M2111.category2_cd	=	@P_category2_cd
	)
	AND 	
		(
		@P_category3_cd		=   0
	OR  M2112.category3_cd	=	@P_category3_cd
	)
	AND 	
		(
		@P_refer_kbn		=   0
	OR  M2110.refer_kbn	=	@P_refer_kbn
	)
	AND	M2110.del_datetime IS NULL
	AND M2111.del_datetime	IS NULL
	AND M2112.del_datetime	IS NULL
	AND M2113.del_datetime	IS NULL
	ORDER BY 
		M2110.company_cd
	,	M2110.refer_kbn
	,	M2110.category1_cd		
	,	M2111.category2_cd		
	,	M2112.category3_cd		
	,	M2113.question_cd	
	--caculate page
	SET @totalRecord	=	(SELECT COUNT(1) FROM (
		SELECT 
		#RESULT.category1_cd
	,	#RESULT.refer_kbn
	FROM #RESULT
	GROUP BY 
		#RESULT.category1_cd 
	,	#RESULT.refer_kbn 
	) AS #A)
	SET @pageMax		= CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	IF @pageMax			= 0
	BEGIN
		SET @pageMax	= 1
	END
	IF @P_page > @pageMax
	BEGIN
		SET @P_page = @pageMax
	END
	--
	INSERT INTO #USER_REFER
	SELECT 
		#RESULT.category1_cd
	,	#RESULT.refer_kbn
	FROM #RESULT
	GROUP BY 
		#RESULT.category1_cd 
	,	#RESULT.refer_kbn 
	ORDER BY	#RESULT.category1_cd
			,	#RESULT.refer_kbn
	offset (@P_page - 1) * @P_page_size rows
	fetch next @P_page_size rows only
	--[0]
	SELECT
		refer_kbn
	,	category1_cd
	,	category1_nm
	FROM  #CATEGORY1
	ORDER BY 
		refer_kbn
	,	category1_cd

	--[1]
	SELECT
		category2_cd
	,	category2_nm
	FROM  #CATEGORY2
	ORDER BY 
		category2_cd

	--[2]
	SELECT
		category3_cd
	,	category3_nm
	FROM  #CATEGORY3
	ORDER BY 
		category3_cd

	--[3]
	SELECT
		id				
	,	company_cd			
	,	#RESULT.category1_cd
	,	#RESULT.refer_kbn		
	,	category1_nm		
	,	category2_cd		
	,	category2_nm		
	,	category3_cd		
	,	category3_nm		
	,	question_cd			
	,	question	
	,	row_span_cate1	
	,	row_span_cate2	
	,	row_span_cate3	
	,	num_cate1		
	,	num_cate2		
	,	num_cate3		
	FROM #USER_REFER 
	INNER JOIN #RESULT ON(
		#USER_REFER.category1_cd	=	#RESULT.category1_cd
	AND #USER_REFER.refer_kbn		=	#RESULT.refer_kbn
	)
	
	--[4]
	SELECT	
		@totalRecord	AS totalRecord
	,	@pageMax		AS pageMax
	,	@P_page			AS page
	,	@P_page_size	AS pagesize
	,	((@P_page - 1) * @P_page_size + 1) AS offset
	-- clean
	DROP TABLE #RESULT
END

GO
