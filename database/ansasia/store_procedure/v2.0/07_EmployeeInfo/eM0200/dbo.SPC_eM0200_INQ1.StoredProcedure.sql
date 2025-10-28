DROP PROCEDURE [SPC_eM0200_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	SPC_eM0200_INQ1
--*  
--*  作成日/create date			:	2024/03/27
--*　作成者/creater				:	manhnd						
--*  作成内容/create content		:	refer data em0200
--*	 更新日/update date			:  	
--*	 更新者/updater				:　 
--*	 更新内容/update content	:	
--****************************************************************************************
CREATE PROCEDURE [SPC_eM0200_INQ1]
	@P_company_cd									SMALLINT
AS
BEGIN
	SET NOCOUNT ON;
	--[0]
	SELECT
		ISNULL(organization_chart_use_typ,0)				AS	organization_chart_use_typ
	,	ISNULL(seating_chart_use_typ,0)						AS	seating_chart_use_typ
	,	ISNULL(search_function_use_typ,0)					AS	search_function_use_typ
	,	ISNULL(initial_display,0)							AS	initial_display
	,	ISNULL(emailaddress_display_kbn,0)					AS	emailaddress_display_kbn
	,	ISNULL(company_mobile_display_kbn,0)				AS	company_mobile_display_kbn
	,	ISNULL(extension_number_display_kbn,0)				AS	extension_number_display_kbn
	FROM M5200 WITH(NOLOCK)
	WHERE
		company_cd				=	@P_company_cd
	--[1]
	SELECT 
		ISNULL(floor_id,0)									AS	floor_id
	,	ISNULL(floor_name,N'')								AS	floor_name
	--,	ISNULL(floor_map_name,N'')							AS	floor_map
	,	ISNULL(floor_map,N'')								AS	floor_map
	,	ISNULL(floor_map_name,N'')							AS	floor_map_name
	,	ISNULL(seating_chart_typ,1)							AS	seating_chart_typ
	FROM M5201 WITH(NOLOCK)
	WHERE
		company_cd				=	@P_company_cd
	AND del_datetime			IS NULL
END
GO
