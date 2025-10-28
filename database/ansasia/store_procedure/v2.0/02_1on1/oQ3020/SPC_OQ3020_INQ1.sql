DROP PROCEDURE [SPC_OQ3020_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   											

--*  
--*  作成日/create date			:	2020/12/04						
--*　作成者/creater				:	NGHIANM								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--* 
--****************************************************************************************
CREATE PROCEDURE [SPC_OQ3020_INQ1]
	-- Add the parameters for the stored procedure here
	@P_company_cd		SMALLINT	=	0
AS
BEGIN
	SET NOCOUNT ON;
	SELECT	DISTINCT
		M2620.company_cd
	,	M2620.times	
	FROM M2620
	WHERE M2620.company_cd = @P_company_cd
	AND	M2620.del_datetime IS NULL
END
GO
