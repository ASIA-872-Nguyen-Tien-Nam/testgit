IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_rM0110_LST1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_rM0110_LST1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC [SPC_rM0110_LST1] 782,1
-- EXEC [SPC_rM0110_LST1] 782,2
-- EXEC [SPC_rM0110_LST1] 782,3

--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET Adequacy BY mark_kbn
--*  
--*  作成日/create date			:	2023/05/08						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rM0110_LST1]
	@P_company_cd			SMALLINT		=	0
,	@P_mark_kbn				SMALLINT		=	0
AS
BEGIN
	--[0]
	SELECT 
		ISNULL(M4121.item_no,0)			AS	item_no
	,	ISNULL(M4121.mark_cd,0)			AS	mark_cd
	,	ISNULL(M4121.explanation,'')	AS	explanation
	,	CASE 
			WHEN ISNULL(M4120.mark_type,0)	 = 1	--  天気
			THEN ISNULL(L0010_33.remark1,'')
			WHEN ISNULL(M4120.mark_type,0)	 = 2	--	表情
			THEN ISNULL(L0010_34.remark1,'')
			WHEN ISNULL(M4120.mark_type,0)	 = 3	--  表情2
			THEN ISNULL(L0010_35.remark1,'')
			WHEN ISNULL(M4120.mark_type,0)	 = 4	--  文字
			THEN ISNULL(L0010_51.remark1,'')
			ELSE SPACE(0)
		END								AS	remark1
	,	ISNULL(M4121.point,0)			AS	point
	FROM M4120
	LEFT OUTER JOIN M4121 ON (
		M4120.company_cd		=	M4121.company_cd
	AND M4120.mark_kbn			=	M4121.mark_kbn
	AND M4121.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0010 AS L0010_33 ON (
		33				=	L0010_33.name_typ
	AND M4121.mark_cd	=	L0010_33.number_cd
	AND L0010_33.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0010 AS L0010_34 ON (
		34				=	L0010_34.name_typ
	AND M4121.mark_cd	=	L0010_34.number_cd
	AND L0010_34.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0010 AS L0010_35 ON (
		35				=	L0010_35.name_typ
	AND M4121.mark_cd	=	L0010_35.number_cd
	AND L0010_35.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0010 AS L0010_51 ON (
		51				=	L0010_51.name_typ
	AND M4121.mark_cd	=	L0010_51.number_cd
	AND L0010_51.del_datetime IS NULL
	)
	WHERE 
		M4120.company_cd	=	@P_company_cd
	AND M4120.mark_kbn		=	@P_mark_kbn
	AND M4120.del_datetime IS NULL

END
GO
