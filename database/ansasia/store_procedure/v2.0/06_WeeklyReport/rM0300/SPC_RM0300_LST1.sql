IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_RM0300_LST1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_RM0300_LST1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  [SPC_RM0300_LST1] 
 *

--****************************************************************************************
--*   											
--* èàóùäTóv/process overview	:	REFER DATA
--*		
--* çÏê¨ì˙/create date			:	2023/04/17										
--*	çÏê¨é“/creater				:	namnt			
--*   		
--****************************************************************************************/
CREATE PROCEDURE [SPC_RM0300_LST1]
	@P_search_key		NVARCHAR(20)
,	@P_current_page		SMALLINT	=	1
,	@P_page_size		SMALLINT	=	10
,	@P_company_cd		SMALLINT
AS
BEGIN
	SET NOCOUNT ON;

    --
	DECLARE
		@totalRecord		BIGINT		= 0
	,	@pageNumber			INT			= 0

	--
	CREATE TABLE #RESULT (
		id					INT IDENTITY(1,1)
	,	company_cd			SMALLINT
	,	group_cd			SMALLINT
	,	group_nm			NVARCHAR(20)
	,	arrange_order		INT
	)

	--
	INSERT INTO #RESULT
	SELECT
		company_cd
	,	group_cd
	,	group_nm
	,	arrange_order
	FROM M4600
	WHERE
		company_cd	=	@P_company_cd
	AND	(	@P_search_key = '' 
		OR	dbo.FNC_COM_REPLACE_SPACE(M4600.group_nm)	LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_search_key) + '%' 
	)
	AND	del_datetime IS NULL
	
	--
	SET @totalRecord = (SELECT COUNT(1) FROM #RESULT)
	SET @pageNumber  = CEILING(CAST(@totalRecord AS FLOAT) / IIF(@P_page_size = 0,10,@P_page_size))

	IF(@P_current_page <> 0)
	BEGIN
		SELECT
			company_cd
		,	group_cd
		,	group_nm
		FROM #RESULT
		ORDER BY 
			arrange_order,group_cd
		OFFSET (@P_current_page-1) * @P_page_size ROWS
		FETCH NEXT IIF(@P_page_size = 0,10,@P_page_size) ROWS ONLY
	END
	ELSE
	BEGIN
		SELECT
			company_cd
		,	group_cd
		,	group_nm
		FROM #RESULT
		ORDER BY 
		arrange_order,group_cd
	END
	--[1]
		SELECT 
			@totalRecord		AS totalRecord
		,	@pageNumber			AS pageMax
		,	@P_current_page		AS [page]
		,	@P_page_size		AS pagesize
	
	--[2] select list m0040 position_nm
	SELECT 
		ISNULL(company_cd,0) AS company_cd	
	,	position_cd			AS position_cd		
	,	position_nm			AS position_nm
	FROM M0040
	WHERE M0040.company_cd = @P_company_cd
	AND   M0040.del_datetime IS NULL
	ORDER BY M0040.arrange_order,M0040.position_cd

	----
	--[3] select list m0030 job_nm
	SELECT 
		ISNULL(company_cd,0) AS company_cd	
	,	job_cd				AS job_cd		
	,	job_nm				AS job_nm		
	FROM M0030
	WHERE M0030.company_cd = @P_company_cd
	AND   M0030.del_datetime IS NULL
	ORDER BY M0030.arrange_order,M0030.job_cd

	----
	--[4] select list m0050 grade_nm
	SELECT 
		ISNULL(company_cd,0) AS company_cd	
	,	grade				AS grade		
	,	grade_nm			AS grade_nm		
	FROM M0050
	WHERE M0050.company_cd = @P_company_cd
	AND   M0050.del_datetime IS NULL
	ORDER BY M0050.arrange_order

	----
	--[5] select list m0050 grade_nm
	SELECT 
		ISNULL(company_cd,0)			AS company_cd		
	,	ISNULL(employee_typ,0)			AS employee_typ			
	,	ISNULL(employee_typ_nm,0)		AS employee_typ_nm	
	FROM M0060
	WHERE M0060.company_cd = @P_company_cd
	AND   M0060.del_datetime IS NULL
	ORDER BY M0060.arrange_order,M0060.employee_typ
	SELECT
		ISNULL(M0022.company_cd,0) AS company_cd
	,	M0020.organization_cd_1 AS organization_cd
	,	M0022.organization_typ
	,	IIF(M0022.organization_group_nm = '',M0022.organization_group_nm,M0020.organization_nm) AS name
	FROM M0022
	INNER JOIN M0020 ON(
		M0022.company_cd = M0020.company_cd
	AND M0022.organization_typ = M0020.organization_typ
	)
	WHERE M0022.use_typ = 1
	AND M0020.company_cd = @P_company_cd
	AND M0022.organization_typ = 1
	--[6]
	SELECT
		ISNULL(M0022.company_cd,0) AS company_cd
	,	ISNULL(M0020.organization_cd_2,'') AS organization_cd
	,	ISNULL(M0022.organization_typ,0) AS organization_typ
	,	IIF(M0022.organization_group_nm = '',M0022.organization_group_nm,M0020.organization_nm) AS name
	FROM M0022
	INNER JOIN M0020 ON(
		M0022.company_cd = M0020.company_cd
	AND M0022.organization_typ = M0020.organization_typ
	)
	where M0022.use_typ = 1
	AND M0020.company_cd = @P_company_cd
	AND M0022.organization_typ = 2

	SELECT
		M0022.company_cd
	,	M0020.organization_cd_3 AS organization_cd
	,	M0022.organization_typ
	,	IIF(M0022.organization_group_nm = '',M0022.organization_group_nm,M0020.organization_nm) AS name
	FROM M0022
	INNER JOIN M0020 ON(
		M0022.company_cd = M0020.company_cd
	AND M0022.organization_typ = M0020.organization_typ
	)
	where M0022.use_typ = 1
	AND M0020.company_cd = @P_company_cd
	AND M0022.organization_typ = 3

	SELECT
		ISNULL(M0022.company_cd,0) AS company_cd	
	,	ISNULL(M0020.organization_cd_4,'') AS organization_cd
	,	ISNULL(M0022.organization_typ,0) AS organization_typ
	,	IIF(M0022.organization_group_nm = '',M0022.organization_group_nm,M0020.organization_nm) AS name
	FROM M0022
	INNER JOIN M0020 ON(
		M0022.company_cd = M0020.company_cd
	AND M0022.organization_typ = M0020.organization_typ
	)
	WHERE M0022.use_typ = 1
	AND M0020.company_cd = @P_company_cd
	AND M0022.organization_typ = 4
	SELECT
		ISNULL(M0022.company_cd,0) AS company_cd	
	,	ISNULL(M0020.organization_cd_5,'') AS organization_cd
	,	ISNULL(M0022.organization_typ,0) AS organization_typ
	,	IIF(M0022.organization_group_nm = '',M0022.organization_group_nm,M0020.organization_nm) AS name
	FROM M0022
	INNER JOIN M0020 ON(
		M0022.company_cd = M0020.company_cd
	AND M0022.organization_typ = M0020.organization_typ
	)
	WHERE M0022.use_typ = 1
	AND M0020.company_cd = @P_company_cd
	AND M0022.organization_typ = 5
	-- clean
	DROP TABLE #RESULT
END
GO

