DROP PROCEDURE [SPC_M0020_INQ2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ M0020
-- EXEC SPC_M0020_INQ1 '1','3','1'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	M0100_商品登録
--*  
--*  作成日/create date			:	2018/08/16						
--*　作成者/creater				:	DatNT								
--*   					
--*  更新日/update date			:  
--*　更新者/updater				:　
--*　更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_M0020_INQ2]
	-- Add the parameters for the stored procedure here	
	@P_company_cd					SMALLINT				=	0
AS
BEGIN
	SELECT
		company_cd
	,	organization_typ
	,	use_typ
	,	organization_group_nm
	FROM M0022
	WHERE
		company_cd	=	@P_company_cd
	AND	del_datetime IS NULL
END