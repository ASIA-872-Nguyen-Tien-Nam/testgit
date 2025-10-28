IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_mI1010_INQ2]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_mI1010_INQ2]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
 *
 *  処理概要：mi1010 - Refer M3000
 *
 *  作成日  ：2020/12/28
 *  作成者  ：ANS-ASIA DUONGNTT
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_mI1010_INQ2]
	@P_company_cd		SMALLINT		=	0
,	@P_language			NVARCHAR(5)		=	'jp'
AS
BEGIN
	SET NOCOUNT ON;
	--
	CREATE TABLE #LEVEL1(
		id								INT IDENTITY(1,1)
	,	position_cd						INT
	,	browsing_kbn_nm					NVARCHAR(50)
	,	flg_check						SMALLINT	--0:UNCHECK/1:CHECKED			
	)

	--
	CREATE TABLE #M0040(
		id								INT IDENTITY(1,1)
	,	company_cd						SMALLINT
	,	position_cd						INT
	,	position_nm						NVARCHAR(50)
	,	flg_check						SMALLINT	--0:UNCHECK/1:CHECKED
	)
	IF @P_language = 'en'
	BEGIN
	--
	INSERT INTO #LEVEL1
	VALUES	
		(-1,'All are allowed',0)	
	,	(-1,'Not All',0)	
	,	(-1,'By Title',0)
	END
	ELSE
	BEGIN
	--
	INSERT INTO #LEVEL1
	VALUES	
		(-1,'全員可',0)	
	,	(-1,'全員不可',0)	
	,	(-1,'役職によって',0)
	END
	--
	UPDATE #LEVEL1
	SET 
		flg_check			=	ISNULL(M3000.browsing_all_y_kbn,0)
	FROM #LEVEL1
	LEFT JOIN M3000 AS M3000 ON (
		M3000.company_cd	=	@P_company_cd
	AND	M3000.del_datetime IS NULL
	)
	WHERE 
		#LEVEL1.id			=	1

	--
	UPDATE #LEVEL1
	SET 
		flg_check			=	ISNULL(M3000.browsing_all_n_kbn,0)
	FROM #LEVEL1
	LEFT JOIN M3000 AS M3000 ON (
		M3000.company_cd	=	@P_company_cd
	AND	M3000.del_datetime IS NULL
	)
	WHERE 
		#LEVEL1.id			=	2

	--
	UPDATE #LEVEL1
	SET 
		flg_check			=	ISNULL(M3000.browsing_position_kbn,0)
	FROM #LEVEL1
	LEFT JOIN M3000 AS M3000 ON (
		M3000.company_cd	=	@P_company_cd
	AND	M3000.del_datetime IS NULL
	)
	WHERE 
		#LEVEL1.id			=	3

	--
	INSERT INTO #M0040
	SELECT 
		M0040.company_cd			
	,	M0040.position_cd			
	,	M0040.position_nm	
	,	IIF(M3001.browsing_position_cd IS NULL,0,1)		
	FROM M0040
	LEFT JOIN M3000 ON (
		M0040.company_cd			=	M3000.company_cd
	AND M3000.browsing_position_kbn	=	1
	AND M3000.del_datetime IS NULL
	)
	LEFT JOIN M3001 ON (
		M3000.company_cd			=	M3001.company_cd
	AND M0040.position_cd			=	M3001.browsing_position_cd
	AND M3001.del_datetime IS NULL
	)
	WHERE 
		M0040.company_cd			=	@P_company_cd
	AND	M0040.del_datetime IS NULL
	ORDER BY
		M0040.arrange_order	ASC

	--[0]
	SELECT
		#LEVEL1.id					AS	id
	,	position_cd					AS	position_cd
	,	#LEVEL1.browsing_kbn_nm		AS	nm
	,	#LEVEL1.flg_check			AS	flg_check
	FROM #LEVEL1

	--[1]
	SELECT
		id							AS	id
	,	position_cd					AS	position_cd
	,	position_nm					AS	nm
	,	flg_check					AS	flg_check
	,	'3'							AS	parent_id
	FROM #M0040
	ORDER BY id

	-- clean
	DROP TABLE #LEVEL1
	DROP TABLE #M0040
END

GO
