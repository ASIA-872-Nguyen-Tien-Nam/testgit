IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_M0170_LST1]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SPC_M0170_LST1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	M0170_評価シートマスタ
--*  
--*  作成日/create date			:	2018/09/14				
--*　作成者/creater				:	Tuantv								
--*   					
--*  更新日/update date			:	2018/11/20
--*　更新者/updater				:　	Longvv-longvv@ans-asia.com
--*　更新内容/update content		:	半角のアンダーバー「_」で検索
--*
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_M0170_LST1]
	@P_sheet_nm				NVARCHAR(50)		= ''
,	@P_current_page			SMALLINT			= 0
,	@P_page_size			SMALLINT			= 0
,	@P_company_cd			SMALLINT			= 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@ERR_TBL				ERRTABLE
	,	@totalRecord			DECIMAL(18,0)	=	0
	,	@pageMax				INT				=	0
	,	@pageNumber				INT				=	0

	CREATE TABLE #M0200
	(
		company_cd			SMALLINT
	,	sheet_cd			SMALLINT
	,	sheet_nm			NVARCHAR(50)
	,	sheet_ab_nm			NVARCHAR(20)
	,	arrange_order		INT	
	)

	INSERT INTO #M0200
	SELECT 
		@P_company_cd
	,	M0200.sheet_cd			
	,	M0200.sheet_nm	
	,	M0200.sheet_ab_nm	 
	,	M0200.arrange_order  
	FROM M0200 
	WHERE 
		(
			(@P_sheet_nm				=	'')
		OR	(dbo.FNC_COM_REPLACE_SPACE(M0200.sheet_nm)		LIKE	'%' +	dbo.FNC_COM_REPLACE_SPACE(@P_sheet_nm)		+ '%')
		)
	AND M0200.company_cd	= @P_company_cd
	AND M0200.sheet_kbn		= 2
	AND M0200.del_datetime IS NULL
	ORDER BY 
		M0200.arrange_order
	,	M0200.sheet_cd
	--[0]
	SELECT 
		#M0200.company_cd				AS	company_cd
	,	#M0200.sheet_cd					AS  sheet_cd
	,	ISNULL(#M0200.sheet_nm,'')		AS	sheet_nm
	,	ISNULL(#M0200.sheet_ab_nm,'')	AS  sheet_ab_nm
	,	ISNULL(#M0200.arrange_order,'')	AS	arrange_order 
	FROM #M0200
	ORDER BY 
		arrange_order ASC
	,	#M0200.sheet_cd
	OFFSET (@P_current_page-1) * @P_page_size ROWS
	FETCH NEXT @P_page_size ROWS ONLY

	--[1]
	SET @totalRecord = (SELECT COUNT(*) FROM #M0200)
	SET @pageNumber = CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	SELECT @totalRecord AS totalRecord, @pageNumber AS pageMax, @P_current_page AS [page], @P_page_size AS pagesize

END
GO
