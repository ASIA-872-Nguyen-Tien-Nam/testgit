DROP PROCEDURE [SPC_REFER_TIMES_FROM_GROUP_1ON1_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   											
--* èàóùäTóv/process overview	:	LIST DATA
--*  
--* çÏê¨ì˙/create date			:	2020/11/30											
--*	çÏê¨é“/creater				:	nghianm				
			
--****************************************************************************************
CREATE PROCEDURE [SPC_REFER_TIMES_FROM_GROUP_1ON1_INQ1]
	@P_company_cd			SMALLINT		=	0
,	@P_fiscal_year			SMALLINT		=	0
,	@P_group_cd				SMALLINT	=	0
AS
BEGIN
	SET NOCOUNT ON;
    --[0]
	SELECT 
		company_cd
	,	fiscal_year
	,	[1on1_group_cd]	
	,	times
	,	[1on1_title]
	,	start_date
	,	deadline_date
	,	alert
	,	arrange_order
	FROM M2620
	WHERE M2620.company_cd		= @P_company_cd
	AND M2620.fiscal_year		= @P_fiscal_year
	AND M2620.[1on1_group_cd]	= @P_group_cd
END
GO