SET ANSI_NULLS ON
GO
DROP PROCEDURE [dbo].[SPC_WEEKLYREPORT_GET_REPORT_KIND]
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET_REPORT_KIND
--*  
--*  作成日/create date			:	2023/04/06	
--*　作成者/creater				:	quangnd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:　	
--*　更新内容/update content		:	
--*
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_WEEKLYREPORT_GET_REPORT_KIND]
	@P_company_cd		SMALLINT		= 0
,	@P_language			NVARCHAR(2)		= ''
,	@P_order_by			NVARCHAR(10)	= 'asc'	-- add by viettd 2023/06/26
AS
BEGIN
	SET NOCOUNT ON;
    -- do stuff
	DECLARE 
		@w_annualreport_user_typ			TINYINT			= 0	
	,	@w_semi_annualreport_user_typ		TINYINT			= 0	
	,	@w_quarterlyreport_user_typ			TINYINT			= 0	
	,	@w_monthlyreport_user_typ			TINYINT			= 0	
	,	@w_weeklyreport_user_typ			TINYINT			= 0
	,	@w_contract_company_attribute		TINYINT			= 2	
	-- #RESULT
	CREATE TABLE #RESULT (
		id					INT IDENTITY(1, 1)
	,	report_kind			SMALLINT
	,	report_name			NVARCHAR(30)
	)
	--
	SELECT
		@w_contract_company_attribute = ISNULL(M0001.contract_company_attribute,2)
	FROM M0001
	WHERE
		M0001.company_cd = @P_company_cd
	AND M0001.del_datetime IS NULL
		--
	SELECT
		@w_annualreport_user_typ		= ISNULL(M4100.annualreport_user_typ,0)
	,	@w_semi_annualreport_user_typ	= ISNULL(M4100.semi_annualreport_user_typ,0)
	,	@w_quarterlyreport_user_typ		= ISNULL(M4100.quarterlyreport_user_typ,0)
	,	@w_monthlyreport_user_typ		= ISNULL(M4100.monthlyreport_user_typ,0)
	,	@w_weeklyreport_user_typ		= ISNULL(M4100.weeklyreport_user_typ,0)
	FROM M4100
	WHERE
		M4100.company_cd	= @P_company_cd
	AND M4100.del_datetime	IS NULL
	-- insert 1
	INSERT INTO #RESULT
	SELECT
		ISNULL(L0010.number_cd,0)
	,	CASE	
			WHEN @P_language = 'en' 
			THEN ISNULL(L0010.name_english,'')
			ELSE ISNULL(L0010.name,'')
		END	
	FROM L0010
	WHERE
		(@w_contract_company_attribute = 1 OR @w_annualreport_user_typ	= 1)
	AND	L0010.name_typ				= 41	
	AND L0010.number_cd				= 1
	AND L0010.del_datetime IS NULL
	-- insert 2
	INSERT INTO #RESULT
	SELECT
		ISNULL(L0010.number_cd,0)
	,	CASE	
			WHEN @P_language = 'en' 
			THEN ISNULL(L0010.name_english,'')
			ELSE ISNULL(L0010.name,'')
		END	
	FROM L0010
	WHERE
		(@w_contract_company_attribute = 1 OR @w_semi_annualreport_user_typ	= 1)
	AND	L0010.name_typ					= 41	
	AND L0010.number_cd					= 2
	AND L0010.del_datetime IS NULL
	-- insert 3
	INSERT INTO #RESULT
	SELECT
		ISNULL(L0010.number_cd,0)
	,	CASE	
			WHEN @P_language = 'en' 
			THEN ISNULL(L0010.name_english,'')
			ELSE ISNULL(L0010.name,'')
		END	
	FROM L0010
	WHERE
		(@w_contract_company_attribute = 1 OR @w_quarterlyreport_user_typ	= 1)
	AND	L0010.name_typ				= 41	
	AND L0010.number_cd				= 3
	AND L0010.del_datetime IS NULL
	-- insert 4
	INSERT INTO #RESULT
	SELECT
		ISNULL(L0010.number_cd,0)
	,	CASE	
			WHEN @P_language = 'en' 
			THEN ISNULL(L0010.name_english,'')
			ELSE ISNULL(L0010.name,'')
		END	
	FROM L0010
	WHERE
		(@w_contract_company_attribute = 1 OR @w_monthlyreport_user_typ	= 1)
	AND	L0010.name_typ				= 41	
	AND L0010.number_cd				= 4
	AND L0010.del_datetime IS NULL
	-- insert 5
	INSERT INTO #RESULT
	SELECT
		ISNULL(L0010.number_cd,0)
	,	CASE	
			WHEN @P_language = 'en' 
			THEN ISNULL(L0010.name_english,'')
			ELSE ISNULL(L0010.name,'')
		END	
	FROM L0010
	WHERE
		(@w_contract_company_attribute = 1 OR @w_weeklyreport_user_typ	= 1)
	AND	L0010.name_typ				= 41	
	AND L0010.number_cd				= 5
	AND L0010.del_datetime IS NULL
	--[0]
	IF @P_order_by = 'desc'
	BEGIN
		SELECT
			report_kind			AS report_kind
		,	report_name			AS report_name
		FROM #RESULT
		ORDER BY
			#RESULT.id DESC
	END
	ELSE
	BEGIN
		SELECT
			report_kind			AS report_kind
		,	report_name			AS report_name
		FROM #RESULT
		ORDER BY
			#RESULT.id ASC
	END
	--CLEAR
	DROP TABLE #RESULT
END

GO

