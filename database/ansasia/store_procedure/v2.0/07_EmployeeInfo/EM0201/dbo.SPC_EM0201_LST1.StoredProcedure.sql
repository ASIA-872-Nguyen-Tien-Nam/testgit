SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--*  処理概要/process overview	:（ eM0201）コミュニケーション項目登録マスタ
--*  
--*  作成日/create date			:	2024/04/05				
--*　作成者/creater				:	matsumoto
--*
--****************************************************************************************
CREATE PROCEDURE [SPC_EM0201_LST1]
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
		id						int identity(1, 1)
	,	field_cd				smallint
	,	field_nm				nvarchar(50)
	,	arrange_order			int
	,   search_kbn              smallint
	)

	INSERT INTO #RESULT
	SELECT
		field_cd
	,	field_nm
	,	arrange_order
	,   search_kbn
	FROM M5202
	WHERE
		company_cd	=	@P_company_cd
	AND	del_datetime IS NULL
	AND	(	@P_search_key = '' 
		OR	dbo.FNC_COM_REPLACE_SPACE(field_nm)		LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_search_key) + '%' 
	)
	ORDER BY 
		arrange_order ASC
	,	field_cd
	--[0] get result
	SELECT
		field_cd
	,	field_nm
	,	arrange_order
	,   search_kbn
	FROM #RESULT
	ORDER BY 
		arrange_order ASC
	,	field_cd
				 
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
