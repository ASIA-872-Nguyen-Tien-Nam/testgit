IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_OM0300_LST1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_OM0300_LST1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要						：	OM0300 
 *
 *  作成日						：	2020/10/06
 *  作成者						：	ANS-ASIA nghianm
 *   					
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_OM0300_LST1]
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
	,	[1on1_group_cd]		SMALLINT
	,	[1on1_group_nm]		NVARCHAR(20)
	,	arrange_order		INT
	)

	--
	INSERT INTO #RESULT
	SELECT
		company_cd
	,	[1on1_group_cd]
	,	[1on1_group_nm]
	,	arrange_order
	FROM M2600
	WHERE
		company_cd	=	@P_company_cd
	AND	(	@P_search_key = '' 
		OR	dbo.FNC_COM_REPLACE_SPACE(M2600.[1on1_group_nm])		LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_search_key) + '%' 
	)
	AND	del_datetime IS NULL
	
	--
	SET @totalRecord = (SELECT COUNT(1) FROM #RESULT)
	SET @pageNumber  = CEILING(CAST(@totalRecord AS FLOAT) / IIF(@P_page_size = 0,10,@P_page_size))


	--[0]
	IF(@P_current_page <> 0)
	BEGIN
		SELECT
			company_cd
		,	[1on1_group_cd]
		,	[1on1_group_nm]
		FROM #RESULT
		ORDER BY 
			arrange_order,[1on1_group_cd]
		OFFSET (@P_current_page-1) * @P_page_size ROWS
		FETCH NEXT IIF(@P_page_size = 0,10,@P_page_size) ROWS ONLY
	END
	ELSE
	BEGIN
		SELECT
			company_cd
		,	[1on1_group_cd]
		,	[1on1_group_nm]
		FROM #RESULT
		ORDER BY 
		arrange_order,[1on1_group_cd]
	END

	
	--[1]
	
		SELECT 
			@totalRecord		AS totalRecord
		,	@pageNumber			AS pageMax
		,	@P_current_page		AS [page]
		,	@P_page_size		AS pagesize
	
	--[2] select list m0040 position_nm
	SELECT 
		company_cd			AS company_cd		
	,	position_cd			AS position_cd		
	,	position_nm			AS position_nm
	FROM M0040
	WHERE M0040.company_cd = @P_company_cd
	AND   M0040.del_datetime IS NULL
	ORDER BY M0040.arrange_order,M0040.position_cd

	----
	--[3] select list m0030 job_nm
	SELECT 
		company_cd			AS company_cd		
	,	job_cd				AS job_cd		
	,	job_nm				AS job_nm		
	FROM M0030
	WHERE M0030.company_cd = @P_company_cd
	AND   M0030.del_datetime IS NULL
	ORDER BY M0030.arrange_order,M0030.job_cd

	----
	--[4] select list m0050 grade_nm
	SELECT 
		company_cd			AS company_cd		
	,	grade				AS grade		
	,	grade_nm			AS grade_nm		
	FROM M0050
	WHERE M0050.company_cd = @P_company_cd
	AND   M0050.del_datetime IS NULL
	ORDER BY M0050.arrange_order

	----
	--[5] select list m0050 grade_nm
	SELECT 
		company_cd			AS company_cd		
	,	employee_typ		AS employee_typ		
	,	employee_typ_nm		AS employee_typ_nm	
	FROM M0060
	WHERE M0060.company_cd = @P_company_cd
	AND   M0060.del_datetime IS NULL
	ORDER BY M0060.arrange_order,M0060.employee_typ

	-- clean
	DROP TABLE #RESULT
END
GO
