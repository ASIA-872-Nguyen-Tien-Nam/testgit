IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_rM0120_LST2]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_rM0120_LST2]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC [SPC_rM0120_LST2] 782,1
-- EXEC [SPC_rM0120_LST2] 782,2
-- EXEC [SPC_rM0120_LST2] 782,3

--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET Adequacy BY mark_kbn FROM M4122
--*  
--*  作成日/create date			:	2023/05/08						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rM0120_LST2]
	@P_company_cd			SMALLINT		=	0
,	@P_mark_kbn				SMALLINT		=	0
,	@P_user_id				NVARCHAR(50)	=	''
AS
BEGIN
	DECLARE 
		@w_language			smallint		=	0	-- 1.JP 2.EN
	SELECT 
		@w_language =	ISNULL(S0010.[language],1)
	FROM S0010
	WHERE 
		S0010.company_cd	=	@P_company_cd
	AND S0010.user_id		=	@P_user_id
	AND S0010.del_datetime IS NULL
	--[0]
	SELECT 
		ISNULL(M4123.item_no,0)			AS	item_no
	,	ISNULL(M4123.mark_cd,0)			AS	mark_cd
	,	CASE 
			WHEN ISNULL(M4122.mark_type,0)	 = 1	--  天気
			THEN ISNULL(L0010_33.remark1,'')
			WHEN ISNULL(M4122.mark_type,0)	 = 2	--	表情
			THEN ISNULL(L0010_34.remark1,'')
			WHEN ISNULL(M4122.mark_type,0)	 = 3	--  表情2
			THEN ISNULL(L0010_35.remark1,'')
			WHEN ISNULL(M4122.mark_type,0)   = 4	--  文字
			THEN 
				CASE 
					WHEN ISNULL(M4122.mark_kbn,0) = 1	-- リアクション
					THEN ISNULL(L0010_48.remark1,'')
					WHEN ISNULL(M4122.mark_kbn,0) = 2	-- 承認・閲覧者リプライ
					THEN ISNULL(L0010_49.remark1,'')
					WHEN ISNULL(M4122.mark_kbn,0) = 3	-- 報告者リプライ
					THEN ISNULL(L0010_50.remark1,'')
					ELSE SPACE(0)
				END
			ELSE SPACE(0)
		END								AS	remark1
	,	ISNULL(M4123.point,0)			AS	point
	,	CASE 
			WHEN ISNULL(M4122.mark_kbn,0) = 1	-- リアクション
			THEN IIF(@w_language = 2,ISNULL(L0010_48.name_english,''),ISNULL(L0010_48.name,''))
			WHEN ISNULL(M4122.mark_kbn,0) = 2	-- 承認・閲覧者リプライ
			THEN IIF(@w_language = 2,ISNULL(L0010_49.name_english,''),ISNULL(L0010_49.name,''))
			WHEN ISNULL(M4122.mark_kbn,0) = 3	-- 報告者リプライ
			THEN IIF(@w_language = 2,ISNULL(L0010_50.name_english,''),ISNULL(L0010_50.name,''))
			ELSE SPACE(0)
		END								AS	explanation
	FROM M4123
	LEFT OUTER JOIN M4122 ON (
		M4123.company_cd		=	M4122.company_cd
	AND M4123.mark_kbn			=	M4122.mark_kbn
	AND M4122.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0010 AS L0010_33 ON (
		33				=	L0010_33.name_typ
	AND M4123.mark_cd	=	L0010_33.number_cd
	AND L0010_33.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0010 AS L0010_34 ON (
		34				=	L0010_34.name_typ
	AND M4123.mark_cd	=	L0010_34.number_cd
	AND L0010_34.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0010 AS L0010_35 ON (
		35				=	L0010_35.name_typ
	AND M4123.mark_cd	=	L0010_35.number_cd
	AND L0010_35.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0010 AS L0010_48 ON (
		48				=	L0010_48.name_typ
	AND M4123.mark_cd	=	L0010_48.number_cd
	AND L0010_48.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0010 AS L0010_49 ON (
		49				=	L0010_49.name_typ
	AND M4123.mark_cd	=	L0010_49.number_cd
	AND L0010_49.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0010 AS L0010_50 ON (
		50				=	L0010_50.name_typ
	AND M4123.mark_cd	=	L0010_50.number_cd
	AND L0010_50.del_datetime IS NULL
	)
	WHERE 
		M4122.company_cd	=	@P_company_cd
	AND M4122.mark_kbn		=	@P_mark_kbn
	AND M4122.del_datetime IS NULL

END
GO
