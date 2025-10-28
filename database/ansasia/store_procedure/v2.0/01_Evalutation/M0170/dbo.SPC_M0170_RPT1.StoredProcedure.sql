IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_M0170_LST1]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SPC_M0170_RPT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+TEST+
-- 
/****************************************************************************************************
 *
 *  ˆ—ŠT—v:  export csv file
 *
 *  ì¬“ú  F	2018/09/20
 *  ì¬ŽÒ  F	viettd
 *
 *  XV“ú  F	2021/06/22
 *  XVŽÒ  F	viettd
 *  XV“à—eF	change position of ‘å•ª—Þ and ’†•ª—Þ
 *
 ****************************************************************************************************/
CREATE PROCEDURE [dbo].[SPC_M0170_RPT1]
 	@P_sheet_cd				SMALLINT			= 0
,	@P_company_cd			SMALLINT			= 0
,	@P_language				NVARCHAR(2)			= ''   -- add tuyendn 22/08/23
AS
BEGIN
	SET NOCOUNT ON;
	CREATE TABLE #HEADER (
		sheet_cd			 NVARCHAR(20)
	,	sheet_nm			 NVARCHAR(50)
	,	item_no				 NVARCHAR(20)
	,	item_detail_1		 NVARCHAR(1000)
	,	item_detail_2		 NVARCHAR(1000)
	,	item_detail_3		 NVARCHAR(1000)
	,	weight				 NVARCHAR(20)
	)
	IF(@P_language = 'en')
	BEGIN
		-- insert data into header
		INSERT INTO #HEADER
		SELECT 
			'Sheet Code'					AS	sheet_cd	
		,	'Sheet Name'					AS	sheet_nm
		,	'Evaluation Item Code'			AS	item_no	
		,	ISNULL(M0200.item_title_1,'')	AS item_detail_1
		,	ISNULL(M0200.item_title_2,'')	AS item_detail_2
		,	ISNULL(M0200.item_title_3,'')	AS item_detail_3
		,	'Weight'						AS weight
		FROM M0200
		WHERE
			M0200.company_cd			=	@P_company_cd
		AND M0200.sheet_cd				=	@P_sheet_cd
		AND M0200.del_datetime IS NULL
	END
	ELSE
	BEGIN
		-- insert data into header
		INSERT INTO #HEADER
		SELECT 
			'シートコード'					AS	sheet_cd	
		,	'シート名'						AS	sheet_nm
		,	'評価項目コード'					AS	item_no	
		,	ISNULL(M0200.item_title_1,'')	AS item_detail_1
		,	ISNULL(M0200.item_title_2,'')	AS item_detail_2
		,	ISNULL(M0200.item_title_3,'')	AS item_detail_3
		,	'ウェイト'						AS weight
		FROM M0200
		WHERE
			M0200.company_cd			=	@P_company_cd
		AND M0200.sheet_cd				=	@P_sheet_cd
		AND M0200.del_datetime IS NULL
	END
	
	
	--[0]
	SELECT
		#HEADER.sheet_cd
	,	#HEADER.sheet_nm
	,	#HEADER.item_no
	,	#HEADER.item_detail_1
	,	#HEADER.item_detail_2
	,	#HEADER.item_detail_3
	,	#HEADER.weight
	FROM #HEADER
	UNION ALL
	SELECT 
		CONVERT(NVARCHAR(20),ISNULL(M0200.sheet_cd,0))	AS	sheet_cd
	,	ISNULL(M0200.sheet_nm,'')						AS	sheet_nm
	,	CONVERT(NVARCHAR(20),ISNULL(M0201.item_no,0))	AS	item_no
	,	REPLACE(REPLACE(ISNULL(M0201.item_detail_1,''),CHAR(13), ''),CHAR(10),'')					AS	item_detail_1	-- edited by viettd 2021/06/22
	,	REPLACE(REPLACE(ISNULL(M0201.item_detail_2,''),CHAR(13), ''),CHAR(10),'')					AS	item_detail_2
	,	REPLACE(REPLACE(ISNULL(M0201.item_detail_3,''),CHAR(13), ''),CHAR(10),'')					AS	item_detail_3
	,	CONVERT(NVARCHAR(20),ISNULL(M0201.weight,0))	AS	weight
	FROM M0200
	LEFT OUTER JOIN M0201 ON(
		M0200.company_cd			=	M0201.company_cd
	AND M0200.sheet_cd				=	M0201.sheet_cd
	)
	WHERE
		M0200.company_cd			=	@P_company_cd
	AND M0200.sheet_cd				=	@P_sheet_cd
	AND M0200.del_datetime IS NULL
	AND M0201.del_datetime IS NULL
	-- DROP TABLE 
	DROP TABLE #HEADER
END
GO
