IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_OM0400_LST1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_OM0400_LST1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/****************************************************************************************************
--*   											
--*  処理概要/process overview	:	OM0400 - アンケートマスタ
--*  
--*  作成日/create date			:	2020/10/26		
--*　作成者/creater				:	ANS-ASIA nghianm							
--*   					
--*  更新日/update date			:	2021/04/22
--*　更新者/updater				:　	vietdt
--*　更新内容/update content		:	edit order by list data , company_cd = 0 is shown later
--*
-- ****************************************************************************************************/
CREATE PROCEDURE [SPC_OM0400_LST1]
	@P_search_key		NVARCHAR(20)
,	@P_current_page		SMALLINT	=	1
,	@P_page_size		SMALLINT	=	10
,	@P_company_cd		SMALLINT    =   0
,	@P_submit			TINYINT     =   0
,	@P_mode				TINYINT		=	0		-- 0: SEARCH COMPANY_CD = 0 AND COMPANY_CD = @P_company_cd ; 1:SEARCH COMPANY_CD = @P_company_cd 
AS
BEGIN
	SET NOCOUNT ON;

    --
	DECLARE
		@totalRecord		BIGINT		= 0
	,	@pageNumber			INT			= 0
	,	@count				SMALLINT	= 0

	--
	CREATE TABLE #RESULT (
		id					INT IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	refer_kbn					TINYINT
	,	refer_questionnaire_cd		SMALLINT
	,	questionnaire_cd			SMALLINT
	,	questionnaire_nm			NVARCHAR(50)
	,	check_status				TINYINT
	,	arrange_order				INT
	,	del_datetime				DATETIME
	)
	CREATE TABLE #DOUBLE_KEY (
		refer_kbn					TINYINT
	,	refer_questionnaire_cd		SMALLINT
	)
	--
	IF @P_mode = 0
	BEGIN
		INSERT INTO #RESULT
		SELECT
			M2400.company_cd
		,	M2400.refer_kbn
		,	M2400.refer_questionnaire_cd
		,	M2400.questionnaire_cd
		,	M2400.questionnaire_nm
		,	0
		,	M2400.arrange_order
		,	M2400.del_datetime
		FROM M2400
		WHERE
			(
				M2400.company_cd	=	@P_company_cd
			OR  M2400.company_cd    =   0
		 )
		AND	(	@P_search_key = '' 
			OR	M2400.questionnaire_nm	LIKE '%' +  @P_search_key + '%' 
		)
		AND
		(	@P_submit = 0 
			OR	M2400.submit = @P_submit 
		)
		AND	M2400.del_datetime IS NULL
	END
	ELSE
	BEGIN
		INSERT INTO #RESULT
		SELECT
			M2400.company_cd
		,	M2400.refer_kbn
		,	M2400.refer_questionnaire_cd
		,	M2400.questionnaire_cd
		,	M2400.questionnaire_nm
		,	0
		,	M2400.arrange_order
		,	M2400.del_datetime
		FROM M2400
		WHERE M2400.company_cd	=	@P_company_cd
		AND	(	@P_search_key = '' 
			OR	M2400.questionnaire_nm		LIKE '%' +  @P_search_key + '%' 
		)
		AND
		(	@P_submit = 0 
			OR	M2400.submit = @P_submit 
		)
		AND	M2400.del_datetime IS NULL
	END


	--INSERT INTO #DOUBLE_KEY
	INSERT INTO #DOUBLE_KEY
	SELECT 
		#RESULT_A.refer_kbn
	,	#RESULT_A.refer_questionnaire_cd
	FROM #RESULT
	LEFT JOIN #RESULT AS #RESULT_A ON (
		#RESULT.refer_kbn = #RESULT_A.refer_kbn
	AND #RESULT.questionnaire_cd = #RESULT_A.refer_questionnaire_cd
	AND #RESULT_A.company_cd = @P_company_cd
	)
	WHERE #RESULT.refer_kbn = 1
	AND #RESULT.del_datetime IS NULL
	GROUP BY #RESULT_A.refer_kbn , #RESULT_A.refer_questionnaire_cd
	--UPDATE #RESULT
	DELETE #RESULT
	FROM #RESULT
	INNER JOIN #DOUBLE_KEY ON (
		#RESULT.refer_kbn				= #DOUBLE_KEY.refer_kbn
	AND #RESULT.questionnaire_cd		= #DOUBLE_KEY.refer_questionnaire_cd
	AND	#RESULT.company_cd				= 0
	)
	--
	SET @totalRecord = (SELECT COUNT(1) FROM #RESULT)
	SET @pageNumber  = CEILING(CAST(@totalRecord AS FLOAT) / IIF(@P_page_size = 0,10,@P_page_size))

	--[0]
	IF(@P_current_page <> 0)
	BEGIN
		SELECT
			company_cd
		,	refer_kbn
		,	refer_questionnaire_cd
		,	questionnaire_cd
		,	questionnaire_nm
		,	check_status
		FROM #RESULT
		ORDER BY 
			CASE									--edited by vietdt 2021/04/22
				WHEN	company_cd = 0 
				THEN	99999
				ELSE	company_cd
			END				ASC
		,	CASE									--edited by vietdt 2021/04/22
				WHEN	refer_kbn = 1 
				THEN	99999
				ELSE	refer_kbn
			END				ASC
		,	questionnaire_cd
		OFFSET (@P_current_page-1) * @P_page_size ROWS
		FETCH NEXT IIF(@P_page_size = 0,10,@P_page_size) ROWS ONLY
	END
	ELSE
	BEGIN
		SELECT
			company_cd
		,	refer_kbn
		,	questionnaire_cd
		,	questionnaire_nm
		FROM #RESULT
		ORDER BY 
		arrange_order,questionnaire_cd
	END
	--[1]
		SELECT 
			@totalRecord		AS totalRecord
		,	@pageNumber			AS pageMax
		,	@P_current_page		AS [page]
		,	@P_page_size		AS pagesize
	-- clean
	DROP TABLE #RESULT
	DROP TABLE #DOUBLE_KEY

END
GO
