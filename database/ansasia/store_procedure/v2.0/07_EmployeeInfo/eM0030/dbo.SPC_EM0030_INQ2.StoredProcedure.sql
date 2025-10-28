DROP PROCEDURE [SPC_EM0030_INQ2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- EXEC SPC_EM0030_INQ2 '1','740';
-- Author:		trinhdt
-- Create date: 2024/03
-- Description:	get list
-- =============================================
CREATE PROCEDURE [SPC_EM0030_INQ2]
	@P_mode			smallint
,	@P_company_cd	smallint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF (@P_mode = 1)
	BEGIN
		SELECT
			arrange_order								AS arrange_order
		,	training_category_cd						AS training_cd
		,	training_category_nm						AS training_nm
		FROM M5031
		WHERE
			company_cd		=	@P_company_cd
		AND del_datetime	IS NULL
		ORDER BY arrange_order,training_category_cd
	END
	ELSE
	BEGIN
		SELECT
			arrange_order									AS arrange_order
		,	training_course_format_cd						AS training_cd
		,	training_course_format_nm						AS training_nm
		FROM M5032
		WHERE
			company_cd		=	@P_company_cd
		AND del_datetime	IS NULL
		ORDER BY arrange_order,training_course_format_cd
	END

END

GO
