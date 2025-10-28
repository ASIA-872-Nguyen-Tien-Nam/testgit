DROP PROCEDURE [SPC_M0040_LST1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	M0040_役職マスタ
--*  
--* 作成日/create date			:	2018/08/20											
--*	作成者/creater				:	longvv				
--*   					
--*   					
--*  更新日/update date			:	2018/11/20
--*　更新者/updater				:　	Longvv-longvv@ans-asia.com
--*　更新内容/update content		:	半角のアンダーバー「_」で検索
--*　	
--****************************************************************************************
CREATE PROCEDURE [SPC_M0040_LST1]
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

	CREATE TABLE #RESULT (
		id				int identity(1, 1)
	,	position_cd		int
	,	position_nm		nvarchar(50)
	,	position_ab_nm	nvarchar(10)
	,	arrange_order	int
	)

	INSERT INTO #RESULT
	SELECT
		position_cd
	,	position_nm
	,	position_ab_nm
	,	arrange_order
	FROM M0040
	WHERE
		company_cd	=	@P_company_cd
	AND	del_datetime IS NULL
	AND	(	@P_search_key = '' 
		OR	dbo.FNC_COM_REPLACE_SPACE(position_nm)		LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_search_key) + '%' 
		OR	dbo.FNC_COM_REPLACE_SPACE(position_ab_nm)	LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_search_key) + '%' 
	)
	--[0] get result
	SELECT
		position_cd
	,	position_nm
	,	position_ab_nm
	,	arrange_order
	FROM #RESULT
	ORDER BY 
		arrange_order
	,	position_cd
				 
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
