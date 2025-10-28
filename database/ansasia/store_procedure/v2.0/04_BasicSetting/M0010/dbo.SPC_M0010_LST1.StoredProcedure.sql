
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_M0010_LST1]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[SPC_M0010_LST1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************
--*   											
--*  処理概要/process overview	:	M0010_営業所マスタ
--*  
--*  作成日/create date			:	2018/08/20				
--*　作成者/creater				:	Tuantv								
--*   					
--*  更新日/update date			:	2018/11/20
--*　更新者/updater				:　	Longvv-longvv@ans-asia.com
--*　更新内容/update content		:	半角のアンダーバー「_」で検索
--*
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_M0010_LST1]
	@P_office_nm			NVARCHAR(50)		= ''
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

	CREATE TABLE #M0010
	(
		company_cd			SMALLINT
	,	office_cd			SMALLINT
	,	office_nm			NVARCHAR(50)
	,	office_ab_nm		NVARCHAR(20)
	,	arrange_order		INT	
	)

	INSERT INTO #M0010
	SELECT 
		@P_company_cd
	,	M0010.office_cd			
	,	M0010.office_nm	
	,	M0010.office_ab_nm	 
	,	M0010.arrange_order  
	FROM M0010 
	WHERE 
		(	@P_office_nm = '' 
		OR	dbo.FNC_COM_REPLACE_SPACE(M0010.office_nm)		LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_office_nm) + '%' 
		OR	dbo.FNC_COM_REPLACE_SPACE(M0010.office_ab_nm)	LIKE '%' +  dbo.FNC_COM_REPLACE_SPACE(@P_office_nm) + '%' 
	)
	AND M0010.company_cd	= @P_company_cd
	AND M0010.del_datetime IS NULL
	--[0]
	SELECT 
		#M0010.company_cd				AS	company_cd
	,	#M0010.office_cd				AS  office_cd
	,	ISNULL(#M0010.office_nm,'')		AS	office_nm
	,	ISNULL(#M0010.office_ab_nm,'')	AS  office_ab_nm
	,	ISNULL(#M0010.arrange_order,'')	AS	arrange_order 
	FROM #M0010
	ORDER BY 
		arrange_order ASC
	,	office_cd
	OFFSET (@P_current_page-1) * @P_page_size ROWS
	FETCH NEXT @P_page_size ROWS ONLY

	--[1]
	SET @totalRecord = (SELECT COUNT(*) FROM #M0010)
	SET @pageNumber = CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	SELECT @totalRecord AS totalRecord, @pageNumber AS pageMax, @P_current_page AS [page], @P_page_size AS pagesize

END
GO
