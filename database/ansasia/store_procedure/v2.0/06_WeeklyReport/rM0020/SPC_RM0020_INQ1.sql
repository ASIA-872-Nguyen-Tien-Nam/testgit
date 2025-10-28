IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_RM0020_INQ1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_RM0020_INQ1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  個人マスタ：rM0020 - Refer
 *
 *  作成日  ：2023/04/05
 *  作成者  ：ANS-ASIA quangnd
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_RM0020_INQ1]
	@P_company_cd		SMALLINT = 0
,	@P_fiscal_year		SMALLINT = 0
AS
BEGIN
	-- Declare the return variable here
	DECLARE 
		@w_date					date		= GETDATE()
	,	@w_fiscal_year			smallint	= 0
	IF (@P_fiscal_year = 0)
	BEGIN
		SET @w_fiscal_year = dbo.[FNC_GET_YEAR_WEEKLY_REPORT](@P_company_cd, @w_date)
	END
	ELSE
	BEGIN
		SET @w_fiscal_year = @P_fiscal_year
	END
	--[0]
	SELECT 
		ISNULL(M4000.company_cd,0)			AS		company_cd	
	,	ISNULL(M4000.fiscal_year,0)			AS		fiscal_year
	,	ISNULL(M4000.target1_nm,'')			AS		target1_nm
	,	ISNULL(M4000.target1_use_typ,0)		AS		target1_use_typ
	,	ISNULL(M4000.target2_nm,'')			AS		target2_nm
	,	ISNULL(M4000.target2_use_typ,0)		AS		target2_use_typ
	,	ISNULL(M4000.target3_nm,'')			AS		target3_nm
	,	ISNULL(M4000.target3_use_typ,0)		AS		target3_use_typ
	,	ISNULL(M4000.target4_nm,'')			AS		target4_nm
	,	ISNULL(M4000.target4_use_typ,0)		AS		target4_use_typ
	,	ISNULL(M4000.target5_nm,'')			AS		target5_nm
	,	ISNULL(M4000.target5_use_typ,0)		AS		target5_use_typ
	,	ISNULL(M4000.arrange_order,0)		AS		arrange_order
	FROM M4000
	WHERE M4000.company_cd  = @P_company_cd
	AND   M4000.fiscal_year = @w_fiscal_year 
	AND	  M4000.del_datetime IS NULL
	--[1]
	SELECT 
		COUNT(M4000.company_cd) AS count_data
	FROM M4000  
	WHERE M4000.company_cd  = @P_company_cd
	AND	  M4000.fiscal_year = @w_fiscal_year
	AND	  M4000.del_datetime IS NULL
	--[2]
	SELECT 
		 @w_fiscal_year		AS fiscal_year
END
GO
