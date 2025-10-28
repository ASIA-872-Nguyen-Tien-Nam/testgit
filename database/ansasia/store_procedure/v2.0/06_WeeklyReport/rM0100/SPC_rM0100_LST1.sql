SET ANSI_NULLS ON
GO
DROP PROCEDURE [dbo].[SPC_rM0100_LST1]
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	rM0100
--*  
--*  作成日/create date			:	2023/04/06	
--*　作成者/creater				:	quangnd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:　	
--*　更新内容/update content		:	
--*
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_rM0100_LST1]
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
	,	@w_contract_company_attribute	SMALLINT	= 0
	,	@w_company_mc					SMALLINT	= 0

	CREATE TABLE #RESULT_SHOW (
		id					INT IDENTITY(1, 1)
	,	company_cd			SMALLINT
	,	report_kind			SMALLINT
	,	question_no			TINYINT
	,	question_title		NVARCHAR(50)
	,	refer_kbn			TINYINT
	,	refer_question_no	TINYINT	
	,	arrange_order		INT	
	,	child				TINYINT	
	)

	CREATE TABLE #RESULT (
		id					INT IDENTITY(1, 1)
	,	company_cd			SMALLINT
	,	report_kind			SMALLINT
	,	question_no			TINYINT
	,	question_title		NVARCHAR(50)
	,	refer_kbn			TINYINT
	,	refer_question_no	TINYINT	
	,	arrange_order		INT	
	)

	CREATE TABLE #USER_REFER (
		id					INT IDENTITY(1, 1)
	,	company_cd			SMALLINT
	,	report_kind			SMALLINT
	,	question_no			TINYINT
	)

	CREATE TABLE #TABLE_LEVEL (
		id					INT IDENTITY(1, 1)
	,	report_kind			SMALLINT
	,	company_cd			SMALLINT
	)

	CREATE TABLE #TABLE_LEVEL_A (
		id					INT IDENTITY(1, 1)
	,	report_kind			SMALLINT
	,	company_cd			SMALLINT
	)

	CREATE TABLE #TABLE_LEVEL_B (
		id					INT IDENTITY(1, 1)
	,	report_kind			SMALLINT
	,	company_cd			SMALLINT
	)
	--MC LOGIN
	SET @w_contract_company_attribute = (SELECT contract_company_attribute 
											FROM M0001 
											WHERE 
												M0001.company_cd = @P_company_cd
											AND M0001.del_datetime IS NULL
											)
	SELECT  top 1
		@w_company_mc = ISNULL(M0001.company_cd,0)
	FROM M0001 
	WHERE 
		M0001.contract_company_attribute = 1
	AND M0001.del_datetime IS NULL
	--
	INSERT INTO #RESULT
	SELECT
		ISNULL(M4125.company_cd,0)
	,	ISNULL(M4125.report_kind,0)
	,	ISNULL(M4125.question_no,0)
	,	ISNULL(M4125.question_title,'')
	,	ISNULL(M4125.refer_kbn,0)
	,	ISNULL(M4125.refer_question_no,0)
	,	ISNULL(M4125.arrange_order,0)
	FROM M4125
	WHERE
		(
		(	M4125.company_cd    =   @w_company_mc
		AND M4125.refer_kbn		=   0
		)
		OR  M4125.company_cd	=	@P_company_cd
	)
	AND	(	@P_search_key = '' 
		OR	dbo.FNC_COM_REPLACE_SPACE(question_title)		LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_search_key) + '%' 
	)
	AND	M4125.del_datetime IS NULL
	ORDER BY 
		company_cd		ASC
	,	report_kind		ASC
	,	question_no		ASC

	--
	INSERT INTO #USER_REFER
	SELECT 
		@w_company_mc
	,	#RESULT.report_kind
	,	#RESULT.refer_question_no
	FROM #RESULT
	WHERE
		#RESULT.company_cd	= @P_company_cd
	AND #RESULT.refer_kbn	= 1
	--Nhung ban ghi thuoc MC da duoc copy thi se khong hien thi lai nua
	DELETE #RESULT
	FROM #RESULT
	INNER JOIN #USER_REFER ON (
		#RESULT.company_cd			= #USER_REFER.company_cd
	AND	#RESULT.report_kind			= #USER_REFER.report_kind
	AND #RESULT.question_no			= #USER_REFER.question_no
	)
	WHERE	
		#RESULT.company_cd			= @w_company_mc
	--
	INSERT INTO #RESULT_SHOW
	SELECT
		company_cd	
	,	report_kind
	,	question_no
	,	question_title
	,	refer_kbn
	,	refer_question_no
	,	arrange_order
	,	1
	FROM #RESULT
	ORDER BY 
		report_kind		ASC
	,	CASE									--edited by vietdt 2021/04/22
			WHEN	company_cd = @w_company_mc 
			THEN	99999
			ELSE	company_cd
		END				ASC
	,	arrange_order	ASC
	,	CASE									--edited by vietdt 2021/04/22
			WHEN	refer_kbn = 1 
			THEN	99999
			ELSE	refer_kbn
		END				ASC
	,	question_no		ASC	 
	OFFSET (@P_current_page-1) * @P_page_size ROWS
	FETCH NEXT @P_page_size ROWS ONLY
	-- thông tin report_kind của công ty @P_company_cd
	INSERT INTO #TABLE_LEVEL_A
	SELECT 
		report_kind
	,	company_cd  
	FROM #RESULT_SHOW
	WHERE 
		company_cd = @P_company_cd
	GROUP BY
		report_kind
	,	company_cd 
	-- thông tin report_kind của công ty MC
	INSERT INTO #TABLE_LEVEL_B
	SELECT 
		report_kind
	,	company_cd  
	FROM #RESULT_SHOW
	WHERE 
		company_cd = @w_company_mc
	GROUP BY
		report_kind
	,	company_cd 
	-- table
	INSERT INTO #TABLE_LEVEL
	SELECT 
		ISNULL(#TABLE_LEVEL_A.report_kind, #TABLE_LEVEL_B.report_kind)
	,	ISNULL(#TABLE_LEVEL_A.company_cd,#TABLE_LEVEL_B.company_cd)  
	FROM #TABLE_LEVEL_A
	FULL OUTER JOIN #TABLE_LEVEL_B ON (
		#TABLE_LEVEL_A.report_kind = #TABLE_LEVEL_B.report_kind
	)
	--
	INSERT INTO #RESULT_SHOW
	SELECT
		company_cd	
	,	report_kind
	,	0
	,	''
	,	IIF(company_cd = 0, 0, 1)
	,	0
	,	0
	,	0
	FROM #TABLE_LEVEL
	--[0] get result
	SELECT
		company_cd	
	,	report_kind
	,	CASE	
			WHEN @P_language = 'en' 
			THEN ISNULL(L0010.name_english,'Common')
			ELSE ISNULL(L0010.name,'共通')
		END								AS name_kind
	,	refer_kbn
	,	question_no
	,	question_title
	,	refer_question_no
	,	child
	,	@w_contract_company_attribute	AS	contract_company_attribute
	FROM #RESULT_SHOW
	LEFT JOIN L0010 ON (
		41						 = L0010.name_typ
	AND	#RESULT_SHOW.report_kind = L0010.number_cd
	)
	ORDER BY 
		report_kind		ASC
	,	child			ASC
	,	CASE									--edited by vietdt 2021/04/22
			WHEN	company_cd = @w_company_mc
			THEN	99999
			ELSE	company_cd
		END				ASC
	,	#RESULT_SHOW.arrange_order	ASC
	,	CASE									--edited by vietdt 2021/04/22
			WHEN	refer_kbn = 1 
			THEN	99999
			ELSE	refer_kbn
		END				ASC
	,	question_no		ASC	 
	--[1]
	SET @totalRecord = (SELECT COUNT(*) FROM #RESULT)
	SET @pageNumber = CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	SELECT @totalRecord AS totalRecord, @pageNumber AS pageMax, @P_current_page AS [page], @P_page_size AS pagesize
	--[2]
	SELECT @w_company_mc AS company_mc
	-- clean
	DROP TABLE #RESULT
	DROP TABLE #USER_REFER
END

GO

