DROP PROCEDURE [SPC_EM0020_LST1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	M0020_業務経歴マスタ
--*  
--*  作成日/create date			:	2024/03			
--*　作成者/creater				:	trinhdt
--*
--****************************************************************************************
CREATE PROCEDURE [SPC_EM0020_LST1]
	@P_search_key		nvarchar(200)
,	@P_current_page		smallint
,	@P_page_size		smallint
,	@P_company_cd		smallint
,	@P_language			nvarchar(3)
AS
BEGIN
	SET NOCOUNT ON;

    -- do stuff
	DECLARE
		@totalRecord		bigint		= 0
	,	@pageNumber			int			= 0

	CREATE TABLE #RESULT (
		id							int identity(1, 1)
	,	work_history_kbn			smallint
	)

	INSERT INTO #RESULT
	SELECT
		work_history_kbn
	FROM M5020
	WHERE
		company_cd	=	@P_company_cd
	AND	del_datetime IS NULL
	AND	(	@P_search_key = '' 
		OR	dbo.FNC_COM_REPLACE_SPACE(work_history_kbn)		LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_search_key) + '%' 
	)
	GROUP BY 
		work_history_kbn
	ORDER BY 
		work_history_kbn ASC

	--[0] get result
	SELECT
		work_history_kbn
	,	CASE 
			WHEN @P_language = 'en'
			THEN
				IIF(work_history_kbn = 1,'Current Position Infor','Pre-joining Infor')
			ELSE  
				IIF(work_history_kbn = 1,'現職情報','入社前情報')
		END				AS work_history_kb_nm
	FROM #RESULT
	GROUP BY 
		work_history_kbn
	ORDER BY 
		work_history_kbn ASC
				 
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
