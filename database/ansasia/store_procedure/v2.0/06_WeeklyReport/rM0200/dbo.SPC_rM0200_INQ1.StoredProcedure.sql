USE [MIRAI_V2_0_STAG]
GO
DROP PROCEDURE [SPC_rM0200_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 * EXEC SPC_rM0200_INQ1 '', '10039','1','1','2023-04-03','1','2','en'


 *  [SPC_rM0200_INQ1] - SEARCH
 *
--* 作成日/create date			:	2023/04/11											
--*	作成者/creater				:	namnt	
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_rM0200_INQ1]
	-- Add the parameters for the stored procedure here	
	@P_key_search			NVARCHAR(50)	= ''
,	@P_company_cd			SMALLINT		= 0
,	@P_report_kind			SMALLINT		= 0
,	@P_sheet_cd				SMALLINT		= 0
,	@P_application_date		DATE			= NULL
,	@P_current_page			SMALLINT		= 0
,	@P_page_size			SMALLINT		= 0
,	@P_language				NVARCHAR(5)		= 'jp'
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@pageMax			INT				=	0
	,	@totalRecord		DECIMAL(18,0)	=	0
	,	@pageNumber			INT				=	0
	,	@w_report_kind_1	SMALLINT		=	0
	,	@w_report_kind_2	SMALLINT		=	0
	,	@w_report_kind_3	SMALLINT		=	0
	,	@w_report_kind_4	SMALLINT		=	0
	,	@w_report_kind_5	SMALLINT		=	0
	---
	CREATE TABLE #M4100
	(
		option_cd			SMALLINT	
	,	option_nm			NVARCHAR(200)
	,	parent_option_cd_1	SMALLINT
	,	parent_option_cd_2	SMALLINT
	) 
	CREATE TABLE #TEMP_PAGE
	(
		option_cd			SMALLINT	
	,	option_nm			NVARCHAR(200)
	,	parent_option_cd_1	SMALLINT
	,	parent_option_cd_2	SMALLINT
	) 


	CREATE TABLE #M4100_report_kind
	(
		option_cd			SMALLINT	
	,	option_nm			NVARCHAR(200)
	,	parent_option_cd_1	SMALLINT
	,	parent_option_cd_2	SMALLINT
	) 
	---
	----get active report kind
	SET @w_report_kind_1 = (SELECT M4100.annualreport_user_typ FROM M4100 WHERE M4100.company_cd = @P_company_cd)
	SET @w_report_kind_2 = (SELECT M4100.semi_annualreport_user_typ FROM M4100 WHERE M4100.company_cd = @P_company_cd)
	SET @w_report_kind_3 = (SELECT M4100.quarterlyreport_user_typ FROM M4100 WHERE M4100.company_cd = @P_company_cd)
	SET @w_report_kind_4 = (SELECT M4100.monthlyreport_user_typ FROM M4100 WHERE M4100.company_cd = @P_company_cd)
	SET @w_report_kind_5 = (SELECT M4100.weeklyreport_user_typ FROM M4100 WHERE M4100.company_cd = @P_company_cd)
	--get menu option lv 1
	IF @w_report_kind_1 <> 2
	BEGIN
	INSERT INTO #M4100
	SELECT
		1
	,	IIF(@P_language = 'en', L0010.name_english, L0010.name) 
	,	0
	,	0
	FROM L0010
	WHERE L0010.name_typ = 41
	AND L0010.number_cd = 1
	END
	IF @w_report_kind_2  <> 2
	BEGIN
	INSERT INTO #M4100
	SELECT
		2
	,	IIF(@P_language = 'en', L0010.name_english, L0010.name) 
	,	0
	,	0
	FROM L0010
	WHERE L0010.name_typ = 41
	AND L0010.number_cd = 2
	END
	IF @w_report_kind_3  <> 2
	BEGIN
	INSERT INTO #M4100
	SELECT
		3
	,	IIF(@P_language = 'en', L0010.name_english, L0010.name) 
	,	0
	,	0
	FROM L0010
	WHERE L0010.name_typ = 41
	AND L0010.number_cd = 3
	END
	--monthly
	IF @w_report_kind_4  <> 2
	BEGIN
	INSERT INTO #M4100
	SELECT
		4
	,	IIF(@P_language = 'en', L0010.name_english, L0010.name) 
	,	0
	,	0
	FROM L0010
	WHERE L0010.name_typ = 41
	AND L0010.number_cd = 4
	END
	--weekly
	IF @w_report_kind_5  <> 2
	BEGIN
	INSERT INTO #M4100
	SELECT
		5
	,	IIF(@P_language = 'en', L0010.name_english, L0010.name) 
	,	0
	,	0
	FROM L0010
	WHERE L0010.name_typ = 41
	AND L0010.number_cd = 5
	END
	--get menu option lv2
	INSERT INTO #M4100_report_kind
	SELECT 
		#M4100.option_cd
	,	#M4100.option_nm
	,	#M4100.parent_option_cd_1
	,	#M4100.parent_option_cd_2
	FROM #M4100
	INSERT INTO #M4100
	SELECT 
		M4200.sheet_cd
	,	M4200.sheet_nm
	,	M4200.report_kind
	,	0
	FROM M4200
	WHERE 
		M4200.company_cd = @P_company_cd
	AND (	@P_key_search = '' 
		OR  M4200.sheet_nm LIKE '%'+@P_key_search+'%' 
		OR  M4200.sheet_cd LIKE '%'+@P_key_search+'%')
	AND M4200.del_datetime IS NULL
	GROUP BY
		M4200.sheet_cd
	,	M4200.sheet_nm
	,	M4200.report_kind
	--delete menu lv 1 if not exist child option
	DELETE w
	FROM 
		#M4100 w LEFT JOIN #M4100 ON(
			w.option_cd = #M4100.parent_option_cd_1
		) 
	WHERE 
		w.parent_option_cd_1 = 0 
	AND #M4100.option_cd IS NULL
	---get menu option lv3
	INSERT INTO #M4100
	SELECT 
		M4200.sheet_cd
	,	CAST(M4200.adaption_date	AS nvarchar)
	,	M4200.report_kind
	,	M4200.sheet_cd
	FROM M4200
	WHERE M4200.company_cd = @P_company_cd
	AND M4200.del_datetime IS NULL
	---delete menu lv2 if not exist child option
	DELETE b FROM
	(SELECT * FROM #M4100 WHERE #M4100.parent_option_cd_1 = 0) AS a 
	FULL JOIN 
	(SELECT * FROM #M4100 WHERE #M4100.parent_option_cd_2 != 0 AND #M4100.parent_option_cd_1 != 0) AS b 
	ON(a.option_cd = b.parent_option_cd_1) where a.option_cd IS NULL
	DELETE b FROM 
	(SELECT * FROM #M4100 WHERE #M4100.parent_option_cd_1 != 0 and #M4100.parent_option_cd_2 = 0) AS a 
	FULL JOIN 
	(SELECT * FROM #M4100 WHERE #M4100.parent_option_cd_1 != 0 and #M4100.parent_option_cd_2 != 0) AS b 
	ON(a.parent_option_cd_1 = b.parent_option_cd_1 and a.option_cd = b.parent_option_cd_2) 
	WHERE a.option_cd IS NULL
	INSERT INTO #TEMP_PAGE
	SELECT
		option_cd
	,	REPLACE(option_nm,'-','/') AS option_nm
	,	parent_option_cd_1
	,	parent_option_cd_2
	FROM #M4100 WHERE parent_option_cd_1 != 0 and parent_option_cd_2 != 0 
	ORDER BY
		parent_option_cd_1
	OFFSET (@P_current_page-1) * @P_page_size ROWS
	FETCH NEXT @P_page_size ROWS ONLY
	---[0]
	SELECT
		a.option_cd
	,	a.option_nm
	,	a.parent_option_cd_1
	,	a.parent_option_cd_2
	FROM #M4100 AS a INNER JOIN #TEMP_PAGE AS b
	ON(a.option_cd = b.parent_option_cd_1)
	WHERE a.parent_option_cd_1 = 0
	GROUP BY
		a.option_cd
	,	a.option_nm
	,	a.parent_option_cd_1
	,	a.parent_option_cd_2
	--[1]
	SELECT 
		a.option_cd
	,	a.option_nm
	,	a.parent_option_cd_1
	,	a.parent_option_cd_2
	FROM #M4100 AS a INNER JOIN #TEMP_PAGE AS b
	ON(a.option_cd = b.parent_option_cd_2 AND a.parent_option_cd_1 = b.parent_option_cd_1)
	WHERE a.parent_option_cd_1 != 0 and a.parent_option_cd_2 = 0 
	GROUP BY 
		a.option_cd
	,	a.option_nm
	,	a.parent_option_cd_1
	,	a.parent_option_cd_2
	--[2]
	SELECT
		#M4100.option_cd
	,	REPLACE(#M4100.option_nm,'-','/') AS option_nm
	,	#M4100.parent_option_cd_1
	,	#M4100.parent_option_cd_2
	,	C.sheet_nm
	FROM #M4100 LEFT JOIN M4200 AS C ON(
		#M4100.parent_option_cd_1 = C.report_kind
	AND #M4100.option_nm = C.adaption_date
	AND #M4100.parent_option_cd_2 = C.sheet_cd
	AND @P_company_cd = C.company_cd
	)
	WHERE 
		#M4100.parent_option_cd_1 != 0 
	AND #M4100.parent_option_cd_2 != 0 
	ORDER BY
		parent_option_cd_1
	OFFSET (@P_current_page-1) * @P_page_size ROWS
	FETCH NEXT @P_page_size ROWS ONLY
	SET @totalRecord = (SELECT COUNT(1) FROM (SELECT 1 AS num FROM #M4100 WHERE parent_option_cd_1 != 0 and parent_option_cd_2 != 0 ) AS #A)
	SET @pageNumber = CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	SELECT 
		@totalRecord AS totalRecord
	,	@pageNumber AS pageMax
	,	@P_current_page AS [page]
	,	@P_page_size AS pagesize
	,	@P_key_search as search_key


END
GO
