DROP PROCEDURE [SPC_1ON1_FIND_GROUP_FOR_MEMBER_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ [SPC_DASHBOARD_INQ1]
-- EXEC SPC_1ON1_FIND_GROUP_FOR_MEMBER_FND1 2020,1,740,'721',3
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	1ON1 GET GROUP OF MEMBER
--*  
--*  作成日/create date			:	2020/11/30				
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:　	
--*　更新内容/update content		:	
--*   					
--****************************************************************************************
CREATE PROCEDURE [SPC_1ON1_FIND_GROUP_FOR_MEMBER_FND1]
	@P_company_cd				smallint		=	0	-- company_cd
,	@P_fiscal_year				smallint		=	0	-- 年度
,	@P_employee_cd				nvarchar(10)	=	''	-- MEMBER
AS
BEGIN
	SET NOCOUNT ON;
	--
	SELECT 
		ISNULL(F2000.[1on1_group_cd],0)		AS	[w_1on1_group_cd]
	,	ISNULL(M2600.[1on1_group_nm],'')	AS	[w_1on1_group_nm]
	FROM F2000 WITH(NOLOCK)
	LEFT OUTER JOIN M2600 WITH(NOLOCK) ON (
		F2000.company_cd		=	M2600.company_cd
	AND F2000.[1on1_group_cd]	=	M2600.[1on1_group_cd]
	AND M2600.del_datetime IS NULL
	)
	WHERE
		F2000.company_cd	=	@P_company_cd
	AND F2000.fiscal_year	=	@P_fiscal_year
	AND F2000.del_datetime IS NULL
END	
GO
