SET ANSI_NULLS ON
GO
DROP PROCEDURE [dbo].[SPC_rM0120_LST1]
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	rM0120
--*  
--*  作成日/create date			:	2023/04/06	
--*　作成者/creater				:	quangnd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:　	
--*　更新内容/update content		:	
--*
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_rM0120_LST1]
	@P_search_key		NVARCHAR(50)	= ''
,	@P_current_page		SMALLINT		= 0
,	@P_page_size		SMALLINT		= 0
,	@P_company_cd		SMALLINT		= 0
,	@P_language			NVARCHAR(2)		= ''
AS
BEGIN
	SET NOCOUNT ON;
    -- do stuff
	DECLARE
		@totalRecord					BIGINT		= 0
	,	@pageNumber						INT			= 0
	,	@count							INT			= 0

	CREATE TABLE #RESULT (
		id					INT IDENTITY(1, 1)
	,	company_cd			SMALLINT
	,	mark_kbn			SMALLINT
	,	[name]				NVARCHAR(20)
	,	mark_type			SMALLINT
	)

	--
	INSERT INTO #RESULT
	SELECT
		ISNULL(M4122.company_cd,0)
	,	ISNULL(M4122.mark_kbn,0)
	,	ISNULL(M4122.[name],'')
	,	ISNULL(M4122.mark_type,0)
	FROM M4122
	WHERE
		M4122.company_cd	=	@P_company_cd
	AND	(	@P_search_key = '' 
		OR	dbo.FNC_COM_REPLACE_SPACE(M4122.[name])		LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_search_key) + '%' 
	)
	AND	M4122.del_datetime IS NULL
	ORDER BY 
		company_cd		ASC
	,	mark_kbn		ASC
	--[0] get result
	SELECT
		company_cd	
	,	mark_kbn	
	,	[name]		
	,	mark_type	
	FROM #RESULT
	ORDER BY 
		company_cd		ASC
	OFFSET (@P_current_page-1) * @P_page_size ROWS
	FETCH NEXT @P_page_size ROWS ONLY
	--[1]
	SET @totalRecord = (SELECT COUNT(*) FROM #RESULT)
	SET @pageNumber = CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	SELECT @totalRecord AS totalRecord, @pageNumber AS pageMax, @P_current_page AS [page], @P_page_size AS pagesize

	-- clean
	DROP TABLE #RESULT
END

GO

