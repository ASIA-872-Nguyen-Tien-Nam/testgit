DROP PROCEDURE [SPC_1ON1_USED_TO_COACH_OR_MEMBER_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ [SPC_DASHBOARD_INQ1]
-- EXEC SPC_1ON1_USED_TO_COACH_OR_MEMBER_FND1 740,'721'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	1ON1 GET GROUP OF MEMBER
--*  
--*  作成日/create date			:	2022/01/07				
--*　作成者/creater				:	vietdt								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:　	
--*　更新内容/update content		:	
--*   					
--****************************************************************************************
CREATE PROCEDURE [SPC_1ON1_USED_TO_COACH_OR_MEMBER_FND1]
	@P_company_cd				smallint		=	0	-- company_cd
,	@P_employee_cd				nvarchar(10)	=	''	
AS
BEGIN
	SET NOCOUNT ON;
	--
	DECLARE
		@w_is_member		TINYINT = 0		--0 : Not is member, 1: is member
	,	@w_is_coach			TINYINT = 0		--0 : Not is coach, 1: is coach
	--
	IF EXISTS (SELECT 1 FROM F2001 
						WHERE
							F2001.company_cd	=	@P_company_cd
						AND F2001.employee_cd	=	@P_employee_cd
						AND	F2001.del_datetime	IS NULL
						)
	BEGIN
		SET @w_is_member = 1
	END
	--
	IF EXISTS (SELECT 1 FROM F2001 
						WHERE
							F2001.company_cd	=	@P_company_cd
						AND F2001.coach_cd		=	@P_employee_cd
						AND	F2001.del_datetime	IS NULL
						)
	BEGIN
		SET @w_is_coach = 1
	END
	--[0]
	SELECT 
		@w_is_member	AS	[is_member]
	,	@w_is_coach		AS	is_coach
END	
GO
