DROP PROCEDURE [SPC_eM0100_LST1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	SPC_eM0100_LST1
--*  
--*  作成日/create date			:	2024/03/28
--*　作成者/creater				:	manhnd						
--*  作成内容/create content		:	refer data em0100
--*	 更新日/update date			:  	
--*	 更新者/updater				:　 
--*	 更新内容/update content	:	
--****************************************************************************************
CREATE PROCEDURE [SPC_eM0100_LST1]
	@P_company_cd									SMALLINT
,	@P_language										NVARCHAR(2)
AS
BEGIN
	--CREATE TABLES
	CREATE TABLE #TABLE_TABS (
        id											BIGINT			IDENTITY(1,1)
    ,   tab_id										SMALLINT
    ,   tab_nm										NVARCHAR(40)
	,	settings									NVARCHAR(MAX)
    )
	CREATE TABLE #TABLE_AUTH (
        id											BIGINT			IDENTITY(1,1)
    ,   authority_cd								SMALLINT
    ,   authority_nm								NVARCHAR(50)
    )
	CREATE TABLE #TABLE_SETTINGS (
        id											BIGINT			IDENTITY(1,1)
    ,   tab_id										SMALLINT
    ,   authority_cd								SMALLINT
    ,   use_typ										SMALLINT
    )
	CREATE TABLE #TABLE_COUNT_CHECKED (
        id											BIGINT			IDENTITY(1,1)
    ,   tab_id										SMALLINT
    ,   count_checked								INT
    )
	-- PREPARE DATA
	--[0]
	INSERT INTO #TABLE_TABS
	SELECT 
		ISNULL(L0034.tab_id,0)												AS	tab_id
	,	ISNULL(IIF(@P_language = N'en',L0034.tab_nm_en,L0034.tab_nm),N'')	AS	tab_nm
	,	N''
	FROM L0034 WITH(NOLOCK)
	LEFT OUTER JOIN M9102 WITH(NOLOCK) ON (
		@P_company_cd		=	M9102.company_cd
	AND	L0034.tab_id		=	M9102.tab_id
	)
	WHERE
		M9102.use_typ		=	1
	AND L0034.del_datetime	IS NULL
	AND M9102.del_datetime	IS NULL
	--[1]
	INSERT INTO #TABLE_AUTH
	SELECT
		authority_cd
	,	authority_nm
	FROM S5020 WITH(NOLOCK)
	WHERE
		company_cd		=	@P_company_cd
	AND	del_datetime	IS NULL
	--[2]
	INSERT INTO #TABLE_SETTINGS
	SELECT
		tab_id
	,	authority_cd
	,	use_typ
	FROM M5100
	WHERE
		company_cd	=	@P_company_cd
	--[3]
	INSERT INTO #TABLE_COUNT_CHECKED
	SELECT 
		tab_id				AS	tab_id
	,	COUNT(use_typ)		AS	count_checked
	FROM #TABLE_SETTINGS
	WHERE
		use_typ = 1
	GROUP BY
		tab_id
	ORDER BY
		tab_id
	-- END PREPARE DATA

	--RESULT
	--[0]
	SELECT 
	    #TABLE_TABS.tab_id									AS	tab_id
	,	#TABLE_TABS.tab_nm									AS	tab_nm
	,	(
		SELECT 
		    #TABLE_SETTINGS.tab_id,
		    #TABLE_SETTINGS.authority_cd,
		    #TABLE_SETTINGS.use_typ
		FROM #TABLE_SETTINGS 	        
		WHERE 
		    #TABLE_SETTINGS.tab_id = #TABLE_TABS.tab_id
		FOR JSON PATH
	    )													AS	settings
	,	ISNULL(#TABLE_COUNT_CHECKED.count_checked,0)		AS	count_checked
	FROM #TABLE_TABS
	LEFT JOIN #TABLE_COUNT_CHECKED ON (
		#TABLE_TABS.tab_id	=	#TABLE_COUNT_CHECKED.tab_id
	)

	--[1]
	SELECT 
		authority_cd
	,	authority_nm
	FROM #TABLE_AUTH

	--DROP TABLES
	DROP TABLE #TABLE_TABS
	DROP TABLE #TABLE_SETTINGS
	DROP TABLE #TABLE_AUTH
END
GO
