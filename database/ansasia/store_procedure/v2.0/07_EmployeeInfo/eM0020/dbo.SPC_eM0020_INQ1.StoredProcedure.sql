DROP PROCEDURE [SPC_EM0020_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		trinhdt
-- Create date: 2024/03
-- Description:	get right content
-- =============================================
CREATE PROCEDURE [SPC_EM0020_INQ1]
	@P_work_history_kbn  smallint
,	@P_company_cd		 smallint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--
	CREATE TABLE #TBL_JSON(
		work_history_kbn			SMALLINT
	,	item_id						SMALLINT
	,	numeric_value1				INT
	,	numeric_value2				INT
	,	item_title					NVARCHAR(50)
	,	item_display_kbn			SMALLINT
	,	item_arrangement_column		SMALLINT
	,	item_arrangement_line		SMALLINT
	)

	--
	INSERT INTO #TBL_JSON
	SELECT
		M5020.work_history_kbn					AS work_history_kbn
	,	M5020.item_id							AS item_id
	,	L0010.numeric_value1					AS numeric_value1
	,	L0010.numeric_value2					AS numeric_value2
	,	M5020.item_title						AS item_title
	,	M5020.item_display_kbn					AS item_display_kbn
	,	M5020.item_arrangement_column			AS item_arrangement_column
	,	M5020.item_arrangement_line				AS item_arrangement_line
	FROM M5020
	INNER JOIN L0010 ON(
		M5020.item_id	=	L0010.number_cd
	AND	78				=	L0010.name_typ
	AND L0010.del_datetime IS NULL
	)
	WHERE
		M5020.company_cd		=	@P_company_cd
	AND	work_history_kbn		=	@P_work_history_kbn
	AND M5020.del_datetime IS NULL

    -- select statements for procedure here
	SELECT * FROM #TBL_JSON
	ORDER BY
		item_display_kbn			DESC
	,	item_arrangement_line		ASC
	,	item_arrangement_column	ASC
	,	numeric_value1	ASC
	,	item_id	ASC

END
GO
