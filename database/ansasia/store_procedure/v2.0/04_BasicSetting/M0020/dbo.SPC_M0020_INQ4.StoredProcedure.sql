DROP PROCEDURE [SPC_M0020_INQ4]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ M0020
-- EXEC SPC_M0020_INQ4 '2','22','1','','','','740'
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
CREATE PROCEDURE [dbo].[SPC_M0020_INQ4]
	-- Add the parameters for the stored procedure here
	@P_organization_typ				SMALLINT				=	0
,	@P_organization_cd_1			NVARCHAR(20)			=	''
,	@P_organization_cd_2			NVARCHAR(20)			=	''
,	@P_organization_cd_3			NVARCHAR(20)			=	''
,	@P_organization_cd_4			NVARCHAR(20)			=	''
,	@P_organization_cd_5			NVARCHAR(20)			=	''
,	@P_company_cd					SMALLINT				=	0
AS
BEGIN
	--
	DECLARE
		@text1 nvarchar(50)
	,	@text2 nvarchar(50)
	,	@text3 nvarchar(50)
	,	@text4 nvarchar(50)
	,	@text5 nvarchar(50)
	--
	SET @text1 = (
		SELECT 
			CASE
				 WHEN organization_ab_nm = NULL OR organization_ab_nm = ''
				 THEN organization_nm
				 ELSE organization_ab_nm
			END 
		FROM M0020
		WHERE
			company_cd			=	@P_company_cd
		AND	organization_cd_1	=	@P_organization_cd_1
		AND	organization_typ	=	1
		AND	del_datetime IS NULL
	)
	--
	SET @text2 = (
		SELECT 
			CASE
				 WHEN organization_ab_nm = NULL OR organization_ab_nm = ''
				 THEN organization_nm
				 ELSE organization_ab_nm
			END 
		FROM M0020
		WHERE
			company_cd			=	@P_company_cd
		AND	organization_cd_1	=	@P_organization_cd_1
		AND	organization_cd_2	=	@P_organization_cd_2
		AND	organization_typ	=	2
		AND	del_datetime IS NULL
	)
	--
	SET @text3 = (
		SELECT 
			CASE
				 WHEN organization_ab_nm = NULL OR organization_ab_nm = ''
				 THEN organization_nm
				 ELSE organization_ab_nm
			END 
		FROM M0020
		WHERE
			company_cd			=	@P_company_cd
		AND	organization_cd_1	=	@P_organization_cd_1
		AND	organization_cd_2	=	@P_organization_cd_2
		AND	organization_cd_3	=	@P_organization_cd_3
		AND	organization_typ	=	3
		AND	del_datetime IS NULL
	)
	--
	SET @text4 = (
		SELECT 
			CASE
				 WHEN organization_ab_nm = NULL OR organization_ab_nm = ''
				 THEN organization_nm
				 ELSE organization_ab_nm
			END 
		FROM M0020
		WHERE
			company_cd			=	@P_company_cd
		AND	organization_cd_1	=	@P_organization_cd_1
		AND	organization_cd_2	=	@P_organization_cd_2
		AND	organization_cd_3	=	@P_organization_cd_3
		AND	organization_cd_4	=	@P_organization_cd_4
		AND	organization_typ	=	4
		AND	del_datetime IS NULL
	)
	--
	SET @text5 = (
		SELECT
			CASE
				 WHEN organization_ab_nm = NULL OR organization_ab_nm = ''
				 THEN organization_nm
				 ELSE organization_ab_nm
			END 
		FROM M0020
		WHERE
			company_cd			=	@P_company_cd
		AND	organization_cd_1	=	@P_organization_cd_1
		AND	organization_cd_2	=	@P_organization_cd_2
		AND	organization_cd_3	=	@P_organization_cd_3
		AND	organization_cd_4	=	@P_organization_cd_4
		AND	organization_cd_5	=	@P_organization_cd_5
		AND	organization_typ	=	5
		AND	del_datetime IS NULL
	)
	--
	SELECT
		M0020.organization_typ
	,	M0020.organization_cd_1
	,	M0020.organization_cd_2
	,	M0020.organization_cd_3
	,	M0020.organization_cd_4
	,	M0020.organization_cd_5
	,	M0020.organization_nm
	,	M0020.organization_ab_nm
	,	M0020.responsible_cd
	,	M0020.arrange_order
	,	M0070.employee_nm
	,	@text1 AS text1
	,	@text2 AS text2
	,	@text3 AS text3
	,	@text4 AS text4
	,	@text5 AS text5
	,	CASE
			WHEN @P_organization_typ = 1 THEN M0020.organization_cd_1
			WHEN @P_organization_typ = 2 THEN M0020.organization_cd_2
			WHEN @P_organization_typ = 3 THEN M0020.organization_cd_3
			WHEN @P_organization_typ = 4 THEN M0020.organization_cd_4
			WHEN @P_organization_typ = 5 THEN M0020.organization_cd_5
			ELSE ''
		END	AS organization_cd
	,	M0020.import_cd
	FROM M0020
	LEFT OUTER JOIN M0070 ON (
		M0020.company_cd		=	M0070.company_cd
	AND	M0020.responsible_cd	=	M0070.employee_cd
	)
	WHERE
		M0020.company_cd		=	@P_company_cd
	AND	M0020.organization_typ	=	@P_organization_typ
	AND	M0020.organization_cd_1	=	@P_organization_cd_1
	AND	M0020.organization_cd_2	=	@P_organization_cd_2
	AND	M0020.organization_cd_3	=	@P_organization_cd_3
	AND	M0020.organization_cd_4	=	@P_organization_cd_4
	AND	M0020.organization_cd_5	=	@P_organization_cd_5
	AND	M0020.del_datetime IS NULL
END