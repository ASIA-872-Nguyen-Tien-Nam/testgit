DROP PROCEDURE [SPC_rS0030_INQ2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- +--TEST--+ [SPC_oS0030_INQ2]
-- EXEC [SPC_oS0030_INQ2]'','';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	
--*  
--*  作成日/create date			:	2020/10/22				
--*　作成者/creater				:	nghianm								
--*   					

--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_rS0030_INQ2]
	@P_company_cd	SMALLINT	 = 0
,	@P_employee_cd	NVARCHAR(10) = ''
AS
BEGIN
	 --[0]
	 IF EXISTS(
		SELECT COUNT(1)
		FROM M0070 WITH(NOLOCK)
		WHERE (M0070.company_cd	= @P_company_cd)
		AND (M0070.employee_cd		= @P_employee_cd)
		AND  (M0070.del_datetime IS NULL)
		HAVING COUNT(1) > 0
	 )
	 BEGIN
		SELECT 
			M0070.employee_cd					AS employee_cd
		,	M0070.employee_nm					AS employee_nm
		FROM M0070 WITH(NOLOCK)
		WHERE (M0070.company_cd	= @P_company_cd)
		AND (M0070.employee_cd	= @P_employee_cd)
		AND (M0070.del_datetime IS NULL)
	 END
	 ELSE 
	 BEGIN
			SELECT 1
	 END
	-- [1]
	--SELECT @w_check AS check_employee_cd
END
GO


