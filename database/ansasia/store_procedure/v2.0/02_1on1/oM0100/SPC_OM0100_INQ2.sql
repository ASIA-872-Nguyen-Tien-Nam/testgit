IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_OM0100_INQ2]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_OM0100_INQ2]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  個人マスタ：OM0100 - Refer
 *
 *  作成日  ：2020/12/04
 *  作成者  ：viettd
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_OM0100_INQ2]
	@P_company_cd		SMALLINT		= 0
,	@P_fiscal_year		SMALLINT		= 0
,	@P_employee_cd		NVARCHAR(10)	= ''
AS
BEGIN
	--[0]
	SELECT 
		ISNULL(M2100.company_cd,0)		AS	company_cd
	,	ISNULL(M2100.fiscal_year,0)		AS	fiscal_year
	,	ISNULL(F2100.employee_cd,'')	AS	employee_cd
	,	ISNULL(F2100.target1,'')		AS	target1
	,	ISNULL(F2100.target2,'')		AS	target2
	,	ISNULL(F2100.target3,'')		AS	target3
	,	ISNULL(F2100.comment,'')			AS	comment

	,	ISNULL(M2100.target1_nm,'')		AS	target1_nm
	,	ISNULL(M2100.target1_use_typ,0)	AS	target1_use_typ
	,	ISNULL(M2100.target2_nm,'')		AS	target2_nm
	,	ISNULL(M2100.target2_use_typ,0)	AS	target2_use_typ
	,	ISNULL(M2100.target3_nm,'')		AS	target3_nm
	,	ISNULL(M2100.target3_use_typ,0)	AS	target3_use_typ
	,	ISNULL(M2100.comment_nm,'')		AS	comment_nm
	,	ISNULL(M2100.comment_use_typ,0)	AS	comment_use_typ
	FROM M2100 WITH(NOLOCK)
	LEFT OUTER JOIN F2100 WITH(NOLOCK) ON (
		M2100.company_cd		=	F2100.company_cd
	AND M2100.fiscal_year		=	F2100.fiscal_year
	AND @P_employee_cd			=	F2100.employee_cd
	AND F2100.del_datetime IS NULL
	)
	WHERE 
		M2100.company_cd	=	@P_company_cd
	AND M2100.fiscal_year	=	@P_fiscal_year
	AND M2100.del_datetime IS NULL
END
GO
