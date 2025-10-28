IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_OQ2020_INQ1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_OQ2020_INQ1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：OQ2020 - Refer
 *
 *  作成日  ：2020/10/26
 *  作成者  ：ANS-ASIA nghianm
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_OQ2020_INQ1]
	@P_company_cd				SMALLINT		= 0
,	@P_employee_cd				NVARCHAR(10)	= ''
AS
BEGIN
	SET NOCOUNT ON;
	---
	SELECT 
		M0070.employee_cd
	,	ISNULL(M0070.employee_nm,'') AS	employee_nm
	FROM M0070
	WHERE 
		M0070.company_cd			=	@P_company_cd
	AND M0070.employee_cd			=	@P_employee_cd
	AND M0070.del_datetime IS NULL
	--
END
GO
