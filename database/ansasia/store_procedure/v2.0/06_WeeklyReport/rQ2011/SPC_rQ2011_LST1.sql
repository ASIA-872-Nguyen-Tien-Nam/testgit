SET ANSI_NULLS ON
GO
DROP PROCEDURE [dbo].[SPC_rQ2011_LST1]
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	rQ2011
--*  
--*  作成日/create date			:	2023/04/24
--*　作成者/creater				:	quangnd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:　	
--*　更新内容/update content		:	
--*
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_rQ2011_LST1]
	@P_search_key		NVARCHAR(50)	= ''
,	@P_current_page		SMALLINT		= 0
,	@P_page_size		SMALLINT		= 0
,	@P_company_cd		SMALLINT		= 0
,	@P_employee_cd		NVARCHAR(10)	= ''
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
	,	mygroup_cd			SMALLINT
	,	mygroup_nm			NVARCHAR(20)
	)
	--
	INSERT INTO #RESULT
	SELECT
		ISNULL(F4010.mygroup_cd,0)
	,	ISNULL(F4010.mygroup_nm,'')
	FROM F4010
	WHERE
		F4010.company_cd	=	@P_company_cd
	AND	F4010.employee_cd	=	@P_employee_cd
	AND	(	@P_search_key = '' 
		OR	dbo.FNC_COM_REPLACE_SPACE(F4010.mygroup_nm)		LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_search_key) + '%' 
	)
	AND	F4010.del_datetime IS NULL
	ORDER BY 
		mygroup_cd		ASC
	,	arrange_order	ASC
	--[0] get result
	SELECT
		mygroup_cd	
	,	mygroup_nm		
	FROM #RESULT
	ORDER BY 
		mygroup_cd		ASC
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

