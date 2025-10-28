DROP PROCEDURE [SPC_OQ3010_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   											

--*  
--*  作成日/create date			:	2020/12/04						
--*　作成者/creater				:	NGHIANM								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--* 
--****************************************************************************************
CREATE PROCEDURE [SPC_OQ3010_INQ1]
	-- Add the parameters for the stored procedure here
	@P_company_cd		SMALLINT	=	0
,	@P_fiscal_year		SMALLINT	=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@sql_str	NVARCHAR(MAX)	= ''
	,	@group_count	int = 0
	,	@i		int = 0
	CREATE TABLE #F2300 (
		company_cd			SMALLINT
	,	fiscal_year			SMALLINT
	,	[1on1_group_cd]		SMALLINT
	,	times				SMALLINT
	,	submit				TINYINT
	,	questionnaire_cd	SMALLINT
	,	[1on1_group_nm]		NVARCHAR(20)
	,	arrange_order		INT
	)
	CREATE TABLE #TEMP_F2300 (
		company_cd			SMALLINT
	,	fiscal_year			SMALLINT
	,	[1on1_group_cd]		SMALLINT
	,	times				SMALLINT
	,	submit				TINYINT
	,	questionnaire_cd	SMALLINT
	,	[1on1_group_nm]		NVARCHAR(20)
	,	json_str			NVARCHAR(MAX)
	)
	--
	INSERT INTO #F2300
	SELECT
		M2620.company_cd
	,	M2620.fiscal_year
	,	M2620.[1on1_group_cd]
	,	M2620.times
	,	F2300.submit
	,	F2300.questionnaire_cd
	,	M2600.[1on1_group_nm]
	,	M2600.arrange_order
	FROM M2620
	LEFT JOIN F2300 ON (
		M2620.company_cd		= F2300.company_cd
	AND M2620.fiscal_year		= F2300.fiscal_year
	AND M2620.[1on1_group_cd]	= F2300.[1on1_group_cd]
	AND M2620.times				= F2300.times
	AND F2300.del_datetime IS NULL
	)
	INNER JOIN M2600 ON (
		M2620.company_cd		= M2600.company_cd
	AND M2620.[1on1_group_cd]	= M2600.[1on1_group_cd]
	AND M2600.del_datetime IS NULL
	)
	WHERE M2620.company_cd = @P_company_cd
	AND M2620.fiscal_year = @P_fiscal_year
	AND M2620.del_datetime IS NULL
	ORDER BY 
			M2600.arrange_order,M2600.[1on1_group_cd]
	
	--[0]
	SELECT DISTINCT
		#F2300.company_cd			AS company_cd	
	,	#F2300.[1on1_group_cd]		AS group_cd
	,	#F2300.[1on1_group_nm]		AS group_nm
	,	#F2300.arrange_order		AS arrange_order
	FROM #F2300

	--[1]
	SELECT DISTINCT
		#F2300.company_cd			AS company_cd	
	,	#F2300.[1on1_group_cd]		AS group_cd
	,	count(#F2300.company_cd)	AS total_times
	FROM #F2300
	INNER JOIN M2620 ON (
		#F2300.company_cd		= M2620.company_cd
	AND #F2300.fiscal_year		= M2620.fiscal_year
	AND #F2300.[1on1_group_cd]	= M2620.[1on1_group_cd]
	AND #F2300.times			= M2620.times
	AND M2620.del_datetime IS NULL
	)
	GROUP BY #F2300.company_cd,#F2300.[1on1_group_cd]


	INSERT INTO #TEMP_F2300
	SELECT
			#F2300.company_cd		
		,	#F2300.fiscal_year		
		,	#F2300.[1on1_group_cd]	
		,	#F2300.times			
		,	#F2300.submit			
		,	#F2300.questionnaire_cd
		,	#F2300.[1on1_group_nm]	
		,	'[{
					"submit_coach" : "'+cast(ISNULL(#F2300.submit,'0') as nvarchar(10))+'",
					"questionnaire_cd_coach" : "'+cast(ISNULL(#F2300.questionnaire_cd,'') as nvarchar(10))+'",
					"times_coach" : "'+cast(ISNULL(#F2300.times,'') as nvarchar(10))+'"
				},
				{
					"submit_member" : "'+cast(ISNULL(#F2300_A.submit,'') as nvarchar(10))+'",
					"questionnaire_cd_member" : "'+cast(ISNULL(#F2300_A.questionnaire_cd,'') as nvarchar(10))+'",
					"times_member" : "'+cast(ISNULL(#F2300_A.times,'') as nvarchar(10))+'"
				}]'
	FROM #F2300 
	INNER JOIN #F2300 AS #F2300_A
	ON(
			#F2300.company_cd		= #F2300_A.company_cd
		AND #F2300.fiscal_year		= #F2300_A.fiscal_year
		AND #F2300.[1on1_group_cd]	= #F2300_A.[1on1_group_cd]
		AND	#F2300.times			= #F2300_A.times
	)
	WHERE	(( #F2300_A.submit = 2
				AND #F2300.submit = 1 )
			OR (ISNULL(#F2300_A.submit,0) = 0
				AND ISNULL(#F2300.submit,0) = 0 
			))
	--
	DECLARE @group_str AS NVARCHAR(MAX), @query  AS NVARCHAR(MAX),@cols_l AS NVARCHAR(MAX)
		SELECT @group_str = STUFF(( SELECT DISTINCT ','  +'['+CAST([1on1_group_cd] as nvarchar(10))+']'  
		FROM #F2300  
		FOR XML PATH('') ), 1, 1, '' )

		--IF @cols IS NULL
		--BEGIN
		--	SET @cols = '['+CAST(MONTH(@W_month_search_next) AS NVARCHAR(2))+'],'+'['+CAST(MONTH(@W_month_search_next)+1 AS NVARCHAR(2))+'],'+'['+CAST(MONTH(@W_month_search_next)+2 AS NVARCHAR(2))+'],'+'['+CAST(MONTH(@W_month_search_next)+3 AS NVARCHAR(2))+']'
		--END
	IF EXISTS (SELECT 1 FROM F2300 WHERE F2300.company_cd = @P_company_cd AND F2300.fiscal_year = @P_fiscal_year)
	BEGIN
		SET @sql_str = '

		SELECT 
			times		as	times
		,'+@group_str+'
		FROM
		(
			SELECT 
				#TEMP_F2300.times
			,	#TEMP_F2300.[1on1_group_cd]
			,	#TEMP_F2300.json_str	AS	times_info
			FROM #TEMP_F2300
		)  AS P
		PIVOT (MAX(times_info) FOR [1on1_group_cd] IN ('+@group_str+')) AS A
		'
	END
	ELSE
	BEGIN
		SET @sql_str = '

		SELECT 
			times		as	times
		,'+@group_str+'
		FROM
		(
			SELECT 
				#F2300.times
			,	#F2300.[1on1_group_cd]
			,	''
				{
					"submit" : "''+cast(ISNULL(#F2300.submit,'''') as nvarchar(10))+''",
					"questionnaire_cd" : "''+cast(ISNULL(#F2300.questionnaire_cd,'''') as nvarchar(10))+''",
					"times" : "''+cast(ISNULL(#F2300.times,'''') as nvarchar(10))+''",
				}
			''		AS	times_info
			FROM #F2300
		
		)  AS P
		PIVOT (MAX(times_info) FOR [1on1_group_cd] IN ('+@group_str+')) AS A
		'
	END
	--
	EXEC(@sql_str)
	DROP TABLE #F2300
	END
	GO
