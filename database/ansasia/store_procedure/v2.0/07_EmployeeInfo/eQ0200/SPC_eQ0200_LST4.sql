DROP PROCEDURE [SPC_eQ0200_LST4]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--* EXEC SPC_eQ0200_LST4 '','1','20','740';	

--*  処理概要/process overview	:	eQ0200
--*  							
--*   					
--*  更新日/update date			:	2018/11/20
--*　更新者/updater				:　	
--*　更新内容/update content		:	半角のアンダーバー「_」で検索
--*
--****************************************************************************************
CREATE PROCEDURE [SPC_eQ0200_LST4]
	@P_search_key		nvarchar(200)
,	@P_current_page		smallint
,	@P_page_size		smallint
,	@P_company_cd		smallint
AS
BEGIN
	SET NOCOUNT ON;

    -- do stuff
	DECLARE
		@totalRecord		bigint		= 0
	,	@pageNumber			int			= 0
	,	@w_today			date			= getdate()

	CREATE TABLE #TABLE_EMPLOYEES(
		id								int				identity(1,1)
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(101)
	)

	-- seat employee_cd not in F5100
	INSERT INTO #TABLE_EMPLOYEES
	SELECT
		M0070.employee_cd
	,	M0070.employee_nm
	FROM M0070
	LEFT JOIN F5100 ON (
		M0070.company_cd	= F5100.company_cd
	AND M0070.employee_cd	= F5100.employee_cd
	)
	WHERE
		M0070.company_cd	=	@P_company_cd
	AND	M0070.del_datetime IS NULL
	AND	F5100.company_cd IS NULL
	AND	F5100.employee_cd IS NULL
	AND	(	@P_search_key = '' 
		OR	dbo.FNC_COM_REPLACE_SPACE(M0070.employee_cd)	LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_search_key) + '%' 
		OR	dbo.FNC_COM_REPLACE_SPACE(M0070.employee_nm)	LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_search_key) + '%' 
	)
	AND	((@w_today <= M0070.company_out_dt
	AND M0070.company_out_dt IS NOT NULL)
	OR M0070.company_out_dt IS NULL)
	AND (@w_today >= M0070.company_in_dt
	AND M0070.company_in_dt IS NOT NULL)
	ORDER BY 
		M0070.employee_cd ASC

	-- seat employee_cd in F5100 but has del
	INSERT INTO #TABLE_EMPLOYEES
	SELECT
		M0070.employee_cd
	,	M0070.employee_nm
	FROM M0070
	INNER JOIN F5100 ON (
		M0070.company_cd	= F5100.company_cd
	AND M0070.employee_cd	= F5100.employee_cd
	)
	WHERE
		M0070.company_cd	=	@P_company_cd
	AND	M0070.del_datetime IS NULL
	AND	F5100.del_datetime IS NOT NULL
	AND	(	@P_search_key = '' 
		OR	dbo.FNC_COM_REPLACE_SPACE(M0070.employee_cd)	LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_search_key) + '%' 
		OR	dbo.FNC_COM_REPLACE_SPACE(M0070.employee_nm)	LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_search_key) + '%' 
	)
	AND	((@w_today <= M0070.company_out_dt
	AND M0070.company_out_dt IS NOT NULL)
	OR M0070.company_out_dt IS NULL)
	AND (@w_today >= M0070.company_in_dt
	AND M0070.company_in_dt IS NOT NULL)
	ORDER BY 
		M0070.employee_cd ASC

	-- seat employee_cd in F5100 but has del layout master
	INSERT INTO #TABLE_EMPLOYEES
	SELECT
		M0070.employee_cd
	,	M0070.employee_nm
	FROM M0070
	INNER JOIN F5100 ON (
		M0070.company_cd	= F5100.company_cd
	AND M0070.employee_cd	= F5100.employee_cd
	)
	INNER JOIN M5201 ON (
		M0070.company_cd	= M5201.company_cd
	AND F5100.floor_id		= M5201.floor_id
	)
	WHERE
		M0070.company_cd	=	@P_company_cd
	AND	M0070.del_datetime IS NULL
	AND	M5201.del_datetime IS NOT NULL
	AND	(	@P_search_key = '' 
		OR	dbo.FNC_COM_REPLACE_SPACE(M0070.employee_cd)	LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_search_key) + '%' 
		OR	dbo.FNC_COM_REPLACE_SPACE(M0070.employee_nm)	LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_search_key) + '%' 
	)
	AND	((@w_today <= M0070.company_out_dt
	AND M0070.company_out_dt IS NOT NULL)
	OR M0070.company_out_dt IS NULL)
	AND (@w_today >= M0070.company_in_dt
	AND M0070.company_in_dt IS NOT NULL)
	ORDER BY 
		M0070.employee_cd ASC
	
	--[0] get result
	SELECT
		#TABLE_EMPLOYEES.employee_cd
	,	#TABLE_EMPLOYEES.employee_nm
	FROM #TABLE_EMPLOYEES
	ORDER BY 
		#TABLE_EMPLOYEES.employee_cd ASC
	
				 
	OFFSET (@P_current_page-1) * @P_page_size ROWS
	FETCH NEXT @P_page_size ROWS ONLY

	--[1]
	SET @totalRecord = (SELECT COUNT(*) FROM #TABLE_EMPLOYEES)
	SET @pageNumber = CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	SELECT @totalRecord AS totalRecord, @pageNumber AS pageMax, @P_current_page AS [page], @P_page_size AS pagesize

	-- clean
	DROP TABLE #TABLE_EMPLOYEES
END


GO
