SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		matsumoto
-- Create date: 2024/04/4
-- Description:	get right content
-- =============================================
CREATE PROCEDURE [SPC_EM0201_INQ1]
	@P_field_cd		smallint
,	@P_company_cd		smallint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		field_cd
	,	field_nm
	,	arrange_order
	,   search_kbn
	FROM M5202
	WHERE
		company_cd		=	@P_company_cd
	AND	field_cd	    =	@P_field_cd
	AND	del_datetime IS NULL
END
GO
