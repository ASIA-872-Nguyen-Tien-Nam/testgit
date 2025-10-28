/****** Object:  StoredProcedure [dbo].[SPC_oM0110_LST1]    Script Date: 2018/08/27 13:08:59 ******/
SET ANSI_NULLS ON
GO
DROP PROCEDURE [dbo].[SPC_oM0110_LST1]
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	oM0110
--*  
--*  作成日/create date			:	2020/10/23		
--*　作成者/creater				:	duongntt								
--*   					
--*  更新日/update date			:	2021/04/22
--*　更新者/updater				:　	vietdt
--*　更新内容/update content		:	edit order by list data , company_cd = 0 is shown later
--*
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_oM0110_LST1]
	@P_search_key		NVARCHAR(50)	= ''
,	@P_current_page		SMALLINT		= 0
,	@P_page_size		SMALLINT		= 0
,	@P_company_cd		SMALLINT		= 0
AS
BEGIN
	SET NOCOUNT ON;
    -- do stuff
	DECLARE
		@totalRecord					BIGINT		= 0
	,	@pageNumber						INT			= 0
	,	@count							INT			= 0
	,	@w_contract_company_attribute	SMALLINT	= 0

	CREATE TABLE #RESULT (
		id					INT IDENTITY(1, 1)
	,	company_cd			SMALLINT
	,	category1_cd		SMALLINT
	,	refer_kbn			TINYINT
	,	category1_nm		NVARCHAR(50)
	,	arrange_order		INT	
	)

	CREATE TABLE #USER_REFER (
		id					INT IDENTITY(1, 1)
	,	company_cd			SMALLINT
	,	category1_cd		SMALLINT
	,	refer_kbn			TINYINT
	)
	--MC LOGIN
	SET @w_contract_company_attribute = (SELECT contract_company_attribute 
											FROM M0001 
											WHERE 
												M0001.company_cd = @P_company_cd
											AND M0001.del_datetime IS NULL
											)
	--
	INSERT INTO #RESULT
	SELECT
		ISNULL(M2110.company_cd,0)
	,	ISNULL(M2110.category1_cd,0)
	,	ISNULL(M2110.refer_kbn,0)
	,	ISNULL(category1_nm,'')
	,	ISNULL(arrange_order,0)
	FROM M2110
	WHERE
		(
			M2110.company_cd    =   0
		OR  M2110.company_cd	=	@P_company_cd
	 )
	AND	(	@P_search_key = '' 
		OR	dbo.FNC_COM_REPLACE_SPACE(category1_nm)		LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_search_key) + '%' 
	)
	AND	M2110.del_datetime IS NULL
	ORDER BY 
		company_cd		ASC
	,	refer_kbn		ASC
	,	category1_cd	ASC

	--
	INSERT INTO #USER_REFER
	SELECT 
		0
	,	#RESULT.category1_cd
	,	#RESULT.refer_kbn
	FROM #RESULT
	GROUP BY 
		#RESULT.category1_cd 
	,	#RESULT.refer_kbn 
	HAVING COUNT(#RESULT.company_cd) = 2

	--Nhung ban ghi thuoc MC da duoc copy thi se khong hien thi lai nua
	DELETE #RESULT
	FROM #RESULT
	INNER JOIN #USER_REFER ON (
		#RESULT.company_cd			= #USER_REFER.company_cd
	AND #RESULT.category1_cd		= #USER_REFER.category1_cd
	AND	#RESULT.refer_kbn			= #USER_REFER.refer_kbn
	)

	--[0] get result
	IF (@P_current_page > 0)
	BEGIN
		SELECT
			id
		,	company_cd	
		,	category1_cd
		,	refer_kbn
		,	category1_nm
		,	@w_contract_company_attribute	AS	contract_company_attribute
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
		,	category1_cd	ASC	 
		OFFSET (@P_current_page-1) * @P_page_size ROWS
		FETCH NEXT @P_page_size ROWS ONLY
	END
	ELSE --page = 0 -> find all
	BEGIN
		SELECT
			id
		,	company_cd	
		,	category1_cd
		,	refer_kbn
		,	category1_nm
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
		,	category1_cd	ASC
	END
	--[1]
	SET @totalRecord = (SELECT COUNT(*) FROM #RESULT)
	SET @pageNumber = CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	SELECT @totalRecord AS totalRecord, @pageNumber AS pageMax, @P_current_page AS [page], @P_page_size AS pagesize

	-- clean
	DROP TABLE #RESULT
	DROP TABLE #USER_REFER
END

GO

