DROP PROCEDURE [SPC_M0020_INQ3]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ M0020
-- EXEC SPC_M0020_INQ1 '1','3','1'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	M0100_商品登録
--*  
--*  作成日/create date			:	2018/08/16						
--*　作成者/creater				:	DatNT								
--*   					
--*  更新日/update date			:  
--*　更新者/updater				:　
--*　更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_M0020_INQ3]
	-- Add the parameters for the stored procedure here	
	@P_search_key		NVARCHAR(200)
,	@P_current_page		SMALLINT
,	@P_page_size		SMALLINT
,	@P_company_cd		SMALLINT	=	0
AS
BEGIN
	DECLARE
		@totalRecord		BIGINT		= 0
	,	@pageNumber			INT			= 0
	--
	CREATE TABLE #SEARCH (
		id [int] identity(1, 1),
		[organization_cd_1] [nvarchar](20),
		[organization_cd_2] [nvarchar](20),
		[organization_cd_3] [nvarchar](20),
		[organization_cd_4] [nvarchar](20),
		[organization_cd_5] [nvarchar](20),
		[organization_nm] [nvarchar](50),
		[organization_ab_nm] [nvarchar](10),
		[organization_typ] [tinyint],
		parent int,
		arrange_order int
	)
	SELECT * INTO #RESULT FROM #SEARCH
	--
	INSERT INTO #SEARCH
	SELECT
		organization_cd_1
	,	organization_cd_2
	,	organization_cd_3
	,	organization_cd_4
	,	organization_cd_5
	,	organization_nm
	,	organization_ab_nm
	,	organization_typ
	,	0 --parent
	,	0 --arrange_order
	FROM M0020
	WHERE
		(@P_search_key = '' OR REPLACE(M0020.organization_nm,'%','/') LIKE '%'+REPLACE(@P_search_key,'%','/')+'%')
	AND	M0020.company_cd = @P_company_cd
	AND	M0020.del_datetime IS NULL
	--
	SELECT * INTO #CD5 FROM #SEARCH WHERE organization_typ = 5 AND @P_search_key <> ''
	SELECT * INTO #CD4 FROM #SEARCH WHERE organization_typ = 4 AND @P_search_key <> ''
	SELECT * INTO #CD3 FROM #SEARCH WHERE organization_typ = 3 AND @P_search_key <> ''
	SELECT * INTO #CD2 FROM #SEARCH WHERE organization_typ = 2 AND @P_search_key <> ''
	SELECT * INTO #CD1 FROM #SEARCH WHERE organization_typ = 1 AND @P_search_key <> ''

	

	-- INSERT PARENT LEVEL
	-- #CD5
	INSERT INTO #SEARCH
	SELECT
		organization_cd_1
	,	organization_cd_2
	,	organization_cd_3
	,	organization_cd_4
	,	''--organization_cd_5
	,	'P5-T4'--organization_nm
	,	organization_ab_nm
	,	4
	,	0 --parent
	,	0 --arrange_order
	FROM #CD5
	--
	INSERT INTO #SEARCH
	SELECT
		organization_cd_1
	,	organization_cd_2
	,	organization_cd_3
	,	''--organization_cd_4
	,	''--organization_cd_5
	,	'P5-T3'--organization_nm
	,	organization_ab_nm
	,	3
	,	0 --parent
	,	0 --arrange_order
	FROM #CD5
	--
	INSERT INTO #SEARCH
	SELECT
		organization_cd_1
	,	organization_cd_2
	,	''--organization_cd_3
	,	''--organization_cd_4
	,	''--organization_cd_5
	,	'P5-T2'--organization_nm
	,	organization_ab_nm
	,	2--organization_typ
	,	0 --parent
	,	0 --arrange_order
	FROM #CD5
	--
	INSERT INTO #SEARCH
	SELECT
		organization_cd_1
	,	''--organization_cd_2
	,	''--organization_cd_3
	,	''--organization_cd_4
	,	''--organization_cd_5
	,	'P5-T1'--organization_nm
	,	organization_ab_nm
	,	1--organization_typ
	,	0 --parent
	,	0 --arrange_order
	FROM #CD5

	-- #CD4
	INSERT INTO #SEARCH
	SELECT
		organization_cd_1
	,	organization_cd_2
	,	organization_cd_3
	,	''--organization_cd_4
	,	''--organization_cd_5
	,	'P4-T3'--organization_nm
	,	organization_ab_nm
	,	3
	,	0 --parent
	,	0 --arrange_order
	FROM #CD4
	--
	INSERT INTO #SEARCH
	SELECT
		organization_cd_1
	,	organization_cd_2
	,	''--organization_cd_3
	,	''--organization_cd_4
	,	''--organization_cd_5
	,	'P4-T2'--organization_nm
	,	organization_ab_nm
	,	2
	,	0 --parent
	,	0 --arrange_order
	FROM #CD4
	--
	INSERT INTO #SEARCH
	SELECT
		organization_cd_1
	,	''--organization_cd_2
	,	''--organization_cd_3
	,	''--organization_cd_4
	,	''--organization_cd_5
	,	'P4-T1'--organization_nm
	,	organization_ab_nm
	,	1
	,	0 --parent
	,	0 --arrange_order
	FROM #CD4

	-- #CD3
	INSERT INTO #SEARCH
	SELECT
		organization_cd_1
	,	organization_cd_2
	,	''--organization_cd_3
	,	''--organization_cd_4
	,	''--organization_cd_5
	,	'P3-T2'--organization_nm
	,	organization_ab_nm
	,	2
	,	0 --parent
	,	0 --arrange_order
	FROM #CD3
	--
	INSERT INTO #SEARCH
	SELECT
		organization_cd_1
	,	''--organization_cd_2
	,	''--organization_cd_3
	,	''--organization_cd_4
	,	''--organization_cd_5
	,	'P3-T1'--organization_nm
	,	organization_ab_nm
	,	1
	,	0 --parent
	,	0 --arrange_order
	FROM #CD3

	-- #CD2
	INSERT INTO #SEARCH
	SELECT
		organization_cd_1
	,	''--organization_cd_2
	,	''--organization_cd_3
	,	''--organization_cd_4
	,	''--organization_cd_5
	,	'P2-T1'--organization_nm
	,	organization_ab_nm
	,	1
	,	0 --parent
	,	0 --arrange_order
	FROM #CD2

	-- INSERT BOTTOM LEVEL
	-- #CD1
	INSERT INTO #SEARCH
	SELECT
		M0020.organization_cd_1
	,	M0020.organization_cd_2
	,	M0020.organization_cd_3
	,	M0020.organization_cd_4
	,	M0020.organization_cd_5
	,	'B1'--M0020.organization_nm
	,	M0020.organization_ab_nm
	,	M0020.organization_typ
	,	0 --parent
	,	0 --arrange_order
	FROM M0020
	INNER JOIN #CD1 ON (
		@P_company_cd			=	M0020.company_cd
	AND	#CD1.organization_cd_1	=	M0020.organization_cd_1
	)
	WHERE
		M0020.del_datetime IS NULL

	-- #CD2
	INSERT INTO #SEARCH
	SELECT
		M0020.organization_cd_1
	,	M0020.organization_cd_2
	,	M0020.organization_cd_3
	,	M0020.organization_cd_4
	,	M0020.organization_cd_5
	,	'B2'
	,	M0020.organization_ab_nm
	,	M0020.organization_typ
	,	0 --parent
	,	0 --arrange_order
	FROM M0020
	INNER JOIN #CD2 ON (
		@P_company_cd			=	M0020.company_cd
	AND	#CD2.organization_cd_1	=	M0020.organization_cd_1
	AND	#CD2.organization_cd_2	=	M0020.organization_cd_2
	)
	-- #CD3
	INSERT INTO #SEARCH
	SELECT
		M0020.organization_cd_1
	,	M0020.organization_cd_2
	,	M0020.organization_cd_3
	,	M0020.organization_cd_4
	,	M0020.organization_cd_5
	,	'B3'
	,	M0020.organization_ab_nm
	,	M0020.organization_typ
	,	0 --parent
	,	0 --arrange_order
	FROM M0020
	INNER JOIN #CD3 ON (
		@P_company_cd			=	M0020.company_cd
	AND	#CD3.organization_cd_1	=	M0020.organization_cd_1
	AND	#CD3.organization_cd_2	=	M0020.organization_cd_2
	AND	#CD3.organization_cd_3	=	M0020.organization_cd_3
	)
	-- #CD4
	INSERT INTO #SEARCH
	SELECT
		M0020.organization_cd_1
	,	M0020.organization_cd_2
	,	M0020.organization_cd_3
	,	M0020.organization_cd_4
	,	M0020.organization_cd_5
	,	'B4'
	,	M0020.organization_ab_nm
	,	M0020.organization_typ
	,	0 --parent
	,	0 --arrange_order
	FROM M0020
	INNER JOIN #CD4 ON (
		@P_company_cd			=	M0020.company_cd
	AND	#CD4.organization_cd_1	=	M0020.organization_cd_1
	AND	#CD4.organization_cd_2	=	M0020.organization_cd_2
	AND	#CD4.organization_cd_3	=	M0020.organization_cd_3
	AND	#CD4.organization_cd_4	=	M0020.organization_cd_4
	)

	-- RESULT
	INSERT INTO #RESULT
	SELECT DISTINCT
		organization_cd_1
	,	organization_cd_2
	,	organization_cd_3
	,	organization_cd_4
	,	organization_cd_5
	,	''
	,	''
	,	organization_typ
	,	0 --parent
	,	0 --arrange_order
	FROM #SEARCH
	ORDER BY
		organization_cd_1
	,	organization_cd_2
	,	organization_cd_3
	,	organization_cd_4
	,	organization_cd_5

	-- update organization_nm
	UPDATE R
	SET
		organization_nm = M0020.organization_nm
	,	arrange_order	= M0020.arrange_order
	,	organization_ab_nm = M0020.organization_ab_nm
	FROM #RESULT AS R
	INNER JOIN M0020 ON (
		M0020.company_cd	=	@P_company_cd
	AND	R.organization_cd_1	=	M0020.organization_cd_1
	AND	R.organization_cd_2	=	M0020.organization_cd_2
	AND	R.organization_cd_3	=	M0020.organization_cd_3
	AND	R.organization_cd_4	=	M0020.organization_cd_4
	AND	R.organization_cd_5	=	M0020.organization_cd_5
	)
	-- find parent_id
	-- type = 5
	UPDATE R
	SET parent = R1.id
	FROM #RESULT AS R
	INNER JOIN #RESULT AS R1 ON (
		R.organization_cd_1	=	R1.organization_cd_1
	AND	R.organization_cd_2	=	R1.organization_cd_2
	AND	R.organization_cd_3	=	R1.organization_cd_3
	AND	R.organization_cd_4	=	R1.organization_cd_4
	)
	WHERE
		R1.organization_typ = 4
	AND	R.organization_typ = 5
	-- type = 4
	UPDATE R
	SET parent = R1.id
	FROM #RESULT AS R
	INNER JOIN #RESULT AS R1 ON (
		R.organization_cd_1	=	R1.organization_cd_1
	AND	R.organization_cd_2	=	R1.organization_cd_2
	AND	R.organization_cd_3	=	R1.organization_cd_3
	)
	WHERE
		R1.organization_typ = 3
	AND	R.organization_typ = 4
	-- type = 3
	UPDATE R
	SET parent = R1.id
	FROM #RESULT AS R
	INNER JOIN #RESULT AS R1 ON (
		R.organization_cd_1	=	R1.organization_cd_1
	AND	R.organization_cd_2	=	R1.organization_cd_2
	)
	WHERE
		R1.organization_typ = 2
	AND	R.organization_typ = 3
	-- type = 2
	UPDATE R
	SET parent = R1.id
	FROM #RESULT AS R
	INNER JOIN #RESULT AS R1 ON (
		R.organization_cd_1	=	R1.organization_cd_1
	)
	WHERE
		R1.organization_typ = 1
	AND	R.organization_typ = 2

	-- OUTPUT
	--[0]
	SELECT * FROM #RESULT
	WHERE organization_typ = 1
	ORDER BY
		arrange_order ASC
	,	CASE WHEN  organization_cd_1 NOT LIKE '%[^0-9]%' THEN CAST(organization_cd_1 AS bigint)
			ELSE 999
		END
	,	organization_cd_1
	OFFSET (@P_current_page-1) * @P_page_size ROWS
	FETCH NEXT @P_page_size ROWS ONLY
	--[1]
	SELECT * FROM #RESULT WHERE organization_typ = 2
	ORDER BY
		CASE WHEN organization_cd_1 NOT LIKE '%[^0-9]%' THEN CAST(organization_cd_1 AS bigint)
			ELSE 999
		END
	,	organization_cd_1
	,	arrange_order ASC
	,	CASE WHEN organization_cd_2 NOT LIKE '%[^0-9]%' THEN CAST(organization_cd_2 AS bigint)
			ELSE 999
		END
	,	organization_cd_2
	--[2]
	SELECT * FROM #RESULT WHERE organization_typ = 3
	ORDER BY
		CASE WHEN organization_cd_1 NOT LIKE '%[^0-9]%' THEN CAST(organization_cd_1 AS bigint)
			ELSE 999
		END
	,	organization_cd_1
	,	CASE WHEN  organization_cd_2 NOT LIKE '%[^0-9]%' THEN CAST(organization_cd_2 AS bigint)
			ELSE 999
		END
	,	organization_cd_2
	,	arrange_order ASC
	,	CASE WHEN  organization_cd_3 NOT LIKE '%[^0-9]%' THEN CAST(organization_cd_3 AS bigint)
			ELSE 999
		END
	,	organization_cd_3
	--[3]


	SELECT * FROM #RESULT WHERE organization_typ = 4
	ORDER BY
		CASE WHEN organization_cd_1 NOT LIKE '%[^0-9]%' THEN CAST(organization_cd_1 AS bigint)
			ELSE 999
		END
	,	organization_cd_1
	,	CASE WHEN  organization_cd_2 NOT LIKE '%[^0-9]%' THEN CAST(organization_cd_2 AS bigint)
			ELSE 999
		END
	,	organization_cd_2
	,	CASE WHEN organization_cd_3 NOT LIKE '%[^0-9]%' THEN CAST(organization_cd_3 AS bigint)
			ELSE 999
		END
	,	organization_cd_3
	,	arrange_order ASC
	,	CASE WHEN organization_cd_4 NOT LIKE '%[^0-9]%' THEN CAST(organization_cd_4 AS bigint)
			ELSE 999
		END
	,	organization_cd_4
	--[4]
	SELECT * FROM #RESULT WHERE organization_typ = 5
	ORDER BY
		CASE WHEN organization_cd_1 NOT LIKE '%[^0-9]%' THEN CAST(organization_cd_1 AS bigint)
			ELSE 999
		END
	,	organization_cd_1
	,	CASE WHEN organization_cd_2 NOT LIKE '%[^0-9]%' THEN CAST(organization_cd_2 AS bigint)
			ELSE 999
		END
	,	organization_cd_2
	,	CASE WHEN  organization_cd_3 NOT LIKE '%[^0-9]%' THEN CAST(organization_cd_3 AS bigint)
			ELSE 999
		END
	,	organization_cd_3
	,	CASE WHEN  organization_cd_4 NOT LIKE '%[^0-9]%' THEN CAST(organization_cd_4 AS bigint)
			ELSE 999
		END
	,	organization_cd_4
	,	arrange_order ASC
	,	CASE WHEN  organization_cd_5 NOT LIKE '%[^0-9]%' THEN CAST(organization_cd_5 AS bigint)
			ELSE 999
		END
	,	organization_cd_5
	--[5]
	SET @totalRecord = (SELECT COUNT(*) FROM #RESULT WHERE organization_typ = 1)
	SET @pageNumber = CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	SELECT @totalRecord AS totalRecord, @pageNumber AS pageMax, @P_current_page AS [page], @P_page_size AS pagesize

	-- drop
	DROP TABLE #SEARCH, #RESULT, #CD5, #CD4, #CD3, #CD2, #CD1
END