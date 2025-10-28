DROP PROCEDURE [SPC_I1010_CHK1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC SPC_M0130_INQ1 '';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	I1010_評価年度マスタ
--*  
--*  作成日/create date			:	2018/09/19					
--*　作成者/creater				:	datnt								
--*   					
--*  更新日/update date			:  
--*　更新者/updater				:　
--*　更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [SPC_I1010_CHK1]
	-- Add the parameters for the stored procedure here
	@P_company_cd				SMALLINT		= 0
,	@P_fiscal_year				INT				= 0
,	@P_user_id					NVARCHAR(50)	=	''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATE				=	SYSDATETIME()
	--[0]
	IF EXISTS(SELECT 1 FROM F0030 WHERE 
										company_cd = @P_company_cd	
									AND	(	(@P_fiscal_year <> 0 AND F0030.fiscal_year = @P_fiscal_year)
										OR	(@P_fiscal_year  = 0 AND F0030.fiscal_year = CAST(FORMAT(@w_time,'yyyy') AS INT))
									)
									AND del_datetime IS NULL)
									
	BEGIN
		SELECT 1 AS chk
	END
	ELSE
	BEGIN
		SELECT 0 AS chk
	END


END


GO
