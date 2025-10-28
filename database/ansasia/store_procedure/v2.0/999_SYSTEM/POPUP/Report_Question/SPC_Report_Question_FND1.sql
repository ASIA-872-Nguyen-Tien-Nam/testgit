SET ANSI_NULLS ON
GO
DROP PROCEDURE [dbo].[SPC_Report_Question_FND1]
SET QUOTED_IDENTIFIER ON
GO
--EXEC SPC_Report_Question_FND1 '2','1','20','10035','en';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	reportQuestion
--*  
--*  作成日/create date			:	2023/04/06	
--*　作成者/creater				:	quangnd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:　	
--*　更新内容/update content		:	
--*
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_Report_Question_FND1]
	@P_report_kind		SMALLINT		= 0
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
	--
	CREATE TABLE #RESULT (
		id					INT IDENTITY(1, 1)
	,	company_cd			SMALLINT
	,	report_kind			SMALLINT
	,	question_no			TINYINT
	,	question_title		NVARCHAR(50)
	,	question			NVARCHAR(200)
	,	answer_kind			SMALLINT
	,	answer_type			NVARCHAR(30)
	,	arrange_order		INT
	,	refer_kbn			TINYINT
	)
	--
	INSERT INTO #RESULT
	SELECT
		@P_company_cd	
	,	ISNULL(report_kind,0)
	,	ISNULL(question_no,0)
	,	ISNULL(question_title,'')
	,	ISNULL(question,'')
	,	ISNULL(answer_kind,0)
	,	CASE	
		WHEN @P_language = 'en' 
		THEN ISNULL(L0010.name_english,'')
		ELSE ISNULL(L0010.name,'')
	END		
	,	ISNULL(M4125.arrange_order,0)
	,	ISNULL(refer_kbn,0)			
	FROM M4125
	LEFT JOIN L0010 ON (
		42				  = L0010.name_typ
	AND	M4125.answer_kind = L0010.number_cd
	)
	WHERE
		M4125.company_cd	= @P_company_cd
	AND	(M4125.report_kind	= 0 
		OR M4125.report_kind	= @P_report_kind)
	AND	M4125.del_datetime IS NULL
	AND L0010.del_datetime IS NULL
	ORDER BY 
		answer_kind		ASC
	--[0] get result
	SELECT
		company_cd		
	,	report_kind		
	,	question_no		
	,	question_title	
	,	question		
	,	answer_kind		
	,	answer_type		
	FROM #RESULT
	ORDER BY 
		answer_kind		ASC
	,	report_kind		ASC
	,	arrange_order	ASC
	,	CASE									--edited by vietdt 2021/04/22
			WHEN	refer_kbn = 1 
			THEN	99999
			ELSE	refer_kbn
		END				ASC
	,	question_no		ASC	 
	OFFSET (@P_current_page-1) * @P_page_size ROWS
	FETCH NEXT @P_page_size ROWS ONLY

	--[1]
	SET @totalRecord = (SELECT COUNT(*) FROM #RESULT)
	SET @pageNumber = CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	SELECT 
		@totalRecord			AS totalRecord
	,	@pageNumber				AS pageMax
	,	@P_current_page			AS [page]
	,	@P_page_size			AS pagesize
	,	((@P_current_page - 1) * @P_page_size + 1) AS offset
	
	-- clean
	DROP TABLE #RESULT
END

GO

