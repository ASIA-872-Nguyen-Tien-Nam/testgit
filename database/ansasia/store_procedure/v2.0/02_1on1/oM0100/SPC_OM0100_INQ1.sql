IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_OM0100_INQ1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_OM0100_INQ1]
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
 *  作成日  ：2020/09/25
 *  作成者  ：ANS-ASIA nghianm
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_OM0100_INQ1]
	@P_company_cd		SMALLINT = 0
,	@P_fiscal_year		SMALLINT = 0
AS
BEGIN
	--[0]
	SELECT 
		ISNULL(M2100.company_cd,0)			AS		company_cd	
	,	ISNULL(M2100.fiscal_year,0)			AS		fiscal_year
	,	ISNULL(M2100.target1_nm,'')			AS		target1_nm
	,	ISNULL(M2100.target1_use_typ,0)		AS		target1_use_typ
	,	ISNULL(M2100.target2_nm,'')			AS		target2_nm
	,	ISNULL(M2100.target2_use_typ,0)		AS		target2_use_typ
	,	ISNULL(M2100.target3_nm,'')			AS		target3_nm
	,	ISNULL(M2100.target3_use_typ,0)		AS		target3_use_typ
	,	ISNULL(M2100.comment_nm,'')			AS		comment_nm
	,	ISNULL(M2100.comment_use_typ,0)		AS		comment_use_typ
	,	ISNULL(M2100.arrange_order,0)		AS		arrange_order
	FROM M2100
	WHERE M2100.company_cd  = @P_company_cd
	AND   M2100.fiscal_year = @P_fiscal_year 
	AND	  M2100.del_datetime IS NULL
	--[1]
	SELECT 
		COUNT(M2100.company_cd) AS count_data
	FROM M2100  
	WHERE M2100.company_cd  = @P_company_cd
	AND	  M2100.fiscal_year = @P_fiscal_year
	AND	  M2100.del_datetime IS NULL
END
GO
