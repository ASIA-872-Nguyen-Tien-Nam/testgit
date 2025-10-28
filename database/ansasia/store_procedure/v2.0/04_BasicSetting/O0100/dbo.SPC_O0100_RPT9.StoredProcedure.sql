DROP PROCEDURE [SPC_O0100_RPT9]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+TEST+SPC_O0100_RPT9 '740','n';
-- 
/****************************************************************************************************
 *
 *  ˆ—ŠT—v:  export csv file
 *
 *  ì¬“ú  F 2018/10/01
 *  ì¬ŽÒ  F sondh
 *
 *  XV“ú  F
 *  XVŽÒ  F
 *  XV“à—eF
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_O0100_RPT9]
	@P_company_cd			SMALLINT			= 0
,	@P_language				NVARCHAR(2)		= ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@number_of_item		INT = 0
	,	@i					INT	= 1
	,	@item_kind			INT	=	0
	,	@item_title			nvarchar(50)
	--GET ALL ITEM  IN M0072
	CREATE TABLE #ITEMS (
		id						INT IDENTITY(1,1)
	,	item_cd					NVARCHAR(20)
	,	item_kind				INT
	)
	--
	CREATE TABLE #DATA (
		id						INT IDENTITY(1,1)
	,	employee_cd				NVARCHAR(20)
	,	item_cd					NVARCHAR(20)
	,	item_nm					NVARCHAR(50)
	,	item_no					NVARCHAR(10)
	,	item_value				NVARCHAR(1000)
	,	detail_name				NVARCHAR(50)			
	)
	INSERT INTO #ITEMS
	SELECT 
		item_cd
	,	MAX(item_kind)
	FROM M0080
	WHERE company_cd = @P_company_cd
	AND item_display_kbn = 1
	AND del_datetime IS NULL
	GROUP BY item_cd
	-- get number of item
	SET @number_of_item = (SELECT COUNT(1) FROM #ITEMS)
	-- GET TABLE
	--[0]
	SELECT @number_of_item AS number_of_item
	-- EACH KIND WILL EXPORT 1 FILE CSV
	WHILE @i <= @number_of_item
	BEGIN
		SET @item_kind	=	(SELECT TOP 1 item_kind FROM #ITEMS WHERE id	=	@i)
		--INSERT TITLE  #DATA	
		IF (@P_language = 'en')
		BEGIN
			INSERT INTO #DATA
			SELECT 
				'Employee Code'	
			,	'Item Code'		
			,	'Item Name'		
			,	'No'		
			,	'Item Value'	
			,	'Detail Name'	
		
		END
		ELSE
		BEGIN
			INSERT INTO #DATA
			SELECT 
				'社員コード'					
			,	'項目コード'					
			,	'項目名'	
			,	'明細番号'
			,	 '入力項目'
			,	'項目名称'
		END
		-- INSERT VALUE  #DATA	
		INSERT INTO #DATA
		SELECT 				
			ISNULL(employee_cd,'')
		,	ISNULL(#ITEMS.item_cd,'')
		,	ISNULL(M0080.item_nm,'')
		,	ISNULL(M0072.item_no,'')
		,	CASE WHEN @item_kind = 1 THEN ISNULL(character_item,'')		
				WHEN @item_kind IN (2,4,5) THEN CAST(number_item AS nvarchar(50))
				WHEN @item_kind = 3 THEN FORMAT(date_item, 'yyyy/MM/dd')	
				ELSE ''
			END
		,	M0081.detail_name
		FROM #ITEMS LEFT JOIN M0072 ON(
			@P_company_cd	=	M0072.company_cd
		AND #ITEMS.item_cd	=	M0072.item_cd
		AND M0072.del_datetime IS NULL
		)
		LEFT JOIN M0080 ON(
			@P_company_cd		=	M0080.company_cd
		AND #ITEMS.item_cd		=	M0080.item_cd
		AND M0080.del_datetime IS NULL
		)
		LEFT JOIN M0081 ON(
			@P_company_cd		=	M0081.company_cd
		AND #ITEMS.item_cd		=	M0081.item_cd
		AND M0072.number_item	=	M0081.detail_no
		AND M0081.del_datetime IS NULL
		)
		WHERE 
			#ITEMS.id		=	@i
		ORDER BY
			CASE (SELECT 1 WHERE M0072.employee_cd NOT LIKE '%[^0-9]%')
			   WHEN 1 
			   THEN CAST(M0072.employee_cd AS BIGINT) 
			   ELSE 999999999999999 
			END 
		,	M0080.arrange_order
		,	M0080.item_cd
		-- GET DATA
		IF @item_kind = 4
		BEGIN
			SELECT
				#DATA.employee_cd						
			,	#DATA.item_cd
			,	#DATA.item_nm
			,	#DATA.item_no
			,	#DATA.item_value	
			,	CASE WHEN @item_kind IN (4,5) THEN  #DATA.detail_name
				ELSE '' END AS detail_name
			FROM #DATA
			ORDER BY id
		END
		ELSE IF @item_kind = 5
		BEGIN
			SELECT
				#DATA.employee_cd						
			,	#DATA.item_cd
			,	#DATA.item_nm
			,	#DATA.item_no
			,	CASE WHEN @item_kind IN (4,5) THEN  #DATA.detail_name
				ELSE '' END AS detail_name
			,	#DATA.item_value
			FROM #DATA
			ORDER BY id
		END
		ELSE 
		BEGIN
			SELECT
				#DATA.employee_cd						
			,	#DATA.item_cd
			,	#DATA.item_nm
			,	#DATA.item_no
			,	#DATA.item_value	
			FROM #DATA
			ORDER BY id
		END
		-- DELTE TABLE #DATA
		DELETE #DATA
		-- INCREMENT
		SET @i = @i + 1
	END
END
DROP TABLE #DATA
DROP TABLE #ITEMS
GO
