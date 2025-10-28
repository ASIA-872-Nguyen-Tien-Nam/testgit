DROP PROCEDURE [SPC_EM0020_INQ2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- EXEC SPC_EM0020_INQ2 '1','740';
-- Author:		trinhdt
-- Create date: 2024/03
-- Description:	get list
-- =============================================
CREATE PROCEDURE [SPC_EM0020_INQ2]
	@P_id					smallint
,	@P_work_history_kbn		smallint
,	@P_company_cd			smallint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--[0]
	SELECT
		M5021.arrange_order								AS arrange_order
	,	M5021.selected_items_no							AS selected_items_no
	,	M5021.selected_items_nm							AS selected_items_nm
	FROM M5021
	WHERE
		M5021.company_cd		=	@P_company_cd
	AND	M5021.work_history_kbn	=	@P_work_history_kbn
	AND	M5021.item_id			=	@P_id
	AND M5021.del_datetime	IS NULL
	ORDER BY arrange_order,selected_items_no
	--[1]
	SELECT
		M5020.item_title								AS item_title
	FROM M5020
	WHERE
		M5020.company_cd		=	@P_company_cd
	AND M5020.work_history_kbn	=	@P_work_history_kbn
	AND M5020.item_id			=	@P_id
	AND M5020.del_datetime	IS NULL
	
END

GO
