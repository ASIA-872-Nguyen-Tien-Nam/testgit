DROP PROCEDURE [SPC_Q0070_RPT2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ [[SPC_Q0070_RPT2]]
-- EXEC [[SPC_Q0070_RPT2]] '','1','807';
--****************************************************************************************
--*  èàóùäTóv/process overview	:	M0100_è§ïiìoò^
--*  
--*  çÏê¨ì˙/create date			:	2017/11/03						
--*Å@çÏê¨é“/creater				:	tannq								
--*   					
--*  çXêVì˙/update date			:	2021/06/03
--*Å@çXêVé“/updater				:Å@ viettdÅ@
--*Å@çXêVì‡óe/update content		:	when 3.ä«óùé“(authority_typ = 3) and not choice organization in S0022 then view all employees
--*   					
--*  çXêVì˙/update date			:	2022/08/22
--*Å@çXêVé“/updater				:	vietdtÅ@
--*Å@çXêVì‡óe/update content		:	Ver 1.9
--****************************************************************************************
CREATE PROCEDURE [SPC_Q0070_RPT2]
	-- Add the parameters for the stored procedure here
	@P_employee_cd								NVARCHAR(20)	=	''        
,	@P_employee_nm								NVARCHAR(101)	=	''  
,	@P_employee_typ             				SMALLINT		=	-1
,	@P_list_org  								NVARCHAR(MAX)	=	''
,	@P_position_cd              				INT				=	-1
,	@P_grade                    				SMALLINT		=	-1
,	@P_company_out_dt_flg                    	SMALLINT		=	0
,	@P_fiscal_year              				SMALLINT		=	0
,	@P_group_cd                 				SMALLINT		=	-1
,	@P_ck_search								SMALLINT		=	0
,	@P_list_item								NVARCHAR(MAX)	=	''
,	@P_company_cd								SMALLINT		=	0
,	@P_user_id									NVARCHAR(50)	=   '' -- S0010
,	@P_language									NVARCHAR(2)		= ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								date				= getdate()
	,	@ERR_TBL							ERRTABLE
	,	@order_by_min						INT					=	0
	,	@authority_typ						SMALLINT			=	0
	,	@employee_cd						NVARCHAR(20)		=	''
	,	@authority_cd						SMALLINT			=	0
	,	@position_cd						INT					=	0
	,	@arrange_order						INT					=	0
	,	@choice_in_screen					INT					=	0
	,	@str_header							NVARCHAR(MAX)		=	''
	,	@str_exce							NVARCHAR(MAX)		=	''
	,	@current_year						INT					=	2000
	,	@str_list_item						NVARCHAR(MAX)		=	''
	-- add by viettd 2021/06/03
	,	@w_evaluation_organization_cnt		INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	,	@w_language							SMALLINT			=	1 --1:jp 2:en
	--v1.7	
	CREATE TABLE #M0072_DETAIL_NAME(
		employee_cd			NVARCHAR(20)
	,	item_cd				smallint
	,	item_value			NVARCHAR(MAX)
	)
	--
	CREATE TABLE #TEMP_M0072(
		employee_cd		NVARCHAR(20)
	)
	-- processing search in M0072 
	INSERT INTO  #TEMP_M0072
	EXEC SPC_ALTERNATIVE_ITEM_FIND1 @P_list_item,@P_company_cd,0

		--end v1.7
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
	SELECT 
		@authority_typ	=	ISNULL(authority_typ,0) 
	,	@employee_cd	=	M0070.employee_cd
	,	@authority_cd	=	ISNULL(S0010.authority_cd,0)
	,	@position_cd	=	ISNULL(M0070.position_cd,0)
	,	@w_language		=	ISNULL(S0010.language,1)
	FROM S0010 LEFT JOIN M0070 ON (
		M0070.company_cd		=	S0010.company_cd
	AND M0070.employee_cd		=	S0010.employee_cd
	AND M0070.del_datetime		IS NULL 
	) 
	WHERE 
		S0010.user_id		= @P_user_id 
	AND S0010.company_cd	= @P_company_cd 
	AND S0010.del_datetime  IS NULL
	--add vietdt 2022/08/22 
	IF	@authority_typ = 6
	BEGIN
		SET @authority_typ = 2
	END
	SET @current_year = YEAR(SYSDATETIME())
	SET @authority_typ = ISNULL(@authority_typ,0)
	SET @arrange_order = ISNULL((SELECT ISNULL(M0040.arrange_order,0) FROM M0040 WHERE M0040.del_datetime IS NULL AND M0040.position_cd		=	@position_cd AND M0040.company_cd = @P_company_cd),0)
	-- COUNT ALL ORGANIZATIONS OF S0022 -- add by viettd 2021/06/03
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@authority_cd,1)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@authority_cd,1)
	--
	SET @str_header = (
		SELECT STUFF((SELECT ',[B' + CAST(organization_typ AS nvarchar(20))+']' FROM M0022 WHERE  company_cd = @P_company_cd AND del_datetime IS NULL and use_typ = 1 FOR XML PATH ('')), 1, 1, '' ) 
	)
	--
	CREATE TABLE #TABLE_ORGANIZATION(
		organization_typ			tinyint
	,	organization_cd_1			nvarchar(20)
	,	organization_cd_2			nvarchar(20)
	,	organization_cd_3			nvarchar(20)
	,	organization_cd_4			nvarchar(20)
	,	organization_cd_5			nvarchar(20)	
	,	choice_in_screen				tinyint		-- 1.choice in screen 0.get from master S0022
	)
	
	INSERT INTO #TABLE_ORGANIZATION
	EXEC SPC_REFER_ORGANIZATION_FND1 @P_list_org,@P_user_id,@P_company_cd
	
	-- M0070
	CREATE TABLE #TMP (
		id				INT IDENTITY(1,1) NOT NULL
	,	employee_key	SMALLINT
	,	employee_cd		NVARCHAR(20)	
	,	employee_nm		NVARCHAR(101)		
	,	employee_typ	SMALLINT	
	,	employee_typ_nm NVARCHAR(100)	
	,	belong_cd1		NVARCHAR(100)	
	,	belong_cd1_nm	NVARCHAR(100)	
	,	belong_cd2		NVARCHAR(100)	
	,	belong_cd2_nm	NVARCHAR(100)
	,	belong_cd3		NVARCHAR(100)	
	,	belong_cd3_nm	NVARCHAR(100)
	,	belong_cd4		NVARCHAR(100)	
	,	belong_cd4_nm	NVARCHAR(100)
	,	belong_cd5		NVARCHAR(100)	
	,	belong_cd5_nm	NVARCHAR(100)	
	,	job_cd			SMALLINT
	,	job_nm			NVARCHAR(100)	
	,	position_cd		INT	
	,	position_nm		NVARCHAR(100)	
	,	grade			SMALLINT
	,	grade_nm		NVARCHAR(100)
	,	company_out_dt	NVARCHAR(10)	
	)
	-- M0070
	CREATE TABLE #TMP2 (
		employee_key	NVARCHAR(40)
	,	employee_cd		NVARCHAR(40)
	,	employee_nm		NVARCHAR(101)		
	,	employee_typ_nm NVARCHAR(100)	
	,	[B1]				NVARCHAR(100)	--belong_cd1_nm
	,	[B2]				NVARCHAR(100)	--belong_cd2_nm
	,	[B3]				NVARCHAR(100)	--belong_cd3_nm
	,	[B4]				NVARCHAR(100)	--belong_cd4_nm
	,	[B5]				NVARCHAR(100)	--belong_cd5_nm
	,	job_nm			NVARCHAR(100)	
	,	position_nm		NVARCHAR(100)	
	,	grade_nm		NVARCHAR(100)
	,	company_out_dt	NVARCHAR(50)	
	)
	-- #TEMP_F0030
	CREATE TABLE #TEMP_F0030 (
		id				INT IDENTITY(1,1) NOT NULL
	,	employee_cd		NVARCHAR(20)	
	)
	--
	--#TEMP_F0030
	INSERT INTO #TEMP_F0030
	SELECT
		F0030.employee_cd 
	FROM F0030
	WHERE
		F0030.company_cd	=	@P_company_cd
	AND ((@P_fiscal_year		= -1  AND @current_year = F0030.fiscal_year) OR F0030.fiscal_year	=	@P_fiscal_year)
	AND (@P_group_cd		= -1 OR F0030.group_cd		=	@P_group_cd) -- dat 2019-12-11
	AND F0030.del_datetime	IS NULL
	AND (
			(F0030.rater_employee_cd_1 =	@employee_cd	AND	@authority_typ	= 2)
		OR	(F0030.rater_employee_cd_2 =	@employee_cd	AND	@authority_typ	= 2)
		OR	(F0030.rater_employee_cd_3 =	@employee_cd	AND	@authority_typ	= 2)
		OR	(F0030.rater_employee_cd_4 =	@employee_cd	AND	@authority_typ	= 2)
		OR @authority_typ  <> 2
	)
	GROUP BY F0030.employee_cd 
	--
	
	INSERT #TMP2
	SELECT
		0								--	employee_key	
	,	IIF(@P_language = 'en', 'Employee Number','é–àıî‘çÜ')						--	employee_cd		
	,	IIF(@P_language = 'en', 'Employee Name','é–àıñº'	)					--	employee_nm		
	,	IIF(@P_language = 'en', 'Employee Classification','é–àıãÊï™')						--	employee_typ_nm 
	,	[1]						--	belong_cd1_nm	
	,	[2]						--	belong_cd2_nm	
	,	[3]						--	belong_cd3_nm	
	,	[4]						--	belong_cd4_nm	
	,	[5]						--	belong_cd5_nm	
	,	IIF(@P_language = 'en', 'Job Title','êEéÌ')							--	job_nm			
	,	IIF(@P_language = 'en', 'Position','ñêE')							--	position_nm		
	,	IIF(@P_language = 'en', 'Rank','ìôãâ')							--	grade_nm		
	,	IIF(@P_language = 'en', 'Classified as Retired','ëﬁêEãÊï™')						--	company_out_dt	
	FROM(
		SELECT 
		[1], [2], [3], [4], [5]  
		FROM  
		(SELECT M0022.organization_typ, M0022.organization_group_nm   
			FROM M0022 WHERE	company_cd = @P_company_cd 
							AND del_datetime IS NULL 
							AND use_typ = 1  
		) AS SourceTable  
		PIVOT  
		(  
		MAX(organization_group_nm)  
		FOR organization_typ IN ([1], [2], [3], [4], [5])  
		) AS PivotTable 
	) AS #M0022
	
	--																				
	INSERT INTO #TMP
	SELECT 
		1																		
	,	M0070.employee_cd		
	,	M0070.employee_nm	
	,	M0060.employee_typ	
	,	M0060.employee_typ_nm
	,	ISNULL(M0070.belong_cd1,0)		AS belong_cd1
	,	M1.organization_nm
	,	ISNULL(M0070.belong_cd2,0)		AS belong_cd2
	,	M2.organization_nm
	,	ISNULL(M0070.belong_cd3,0)		AS belong_cd3
	,	M3.organization_nm
	,	ISNULL(M0070.belong_cd4,0)		AS belong_cd4
	,	M4.organization_nm
	,	ISNULL(M0070.belong_cd5,0)		AS belong_cd5
	,	M5.organization_nm
	,	ISNULL(M0070.job_cd,0)			AS job_cd
	,	M0030.job_nm
	,	ISNULL(M0070.position_cd,0)		AS position_cd
	,	M0040.position_nm	
	,	ISNULL(M0070.grade,0)			AS grade
	,	M0050.grade_nm	
	,	CASE
			WHEN (M0070.company_out_dt IS NOT NULL AND (M0070.company_out_dt <  @w_time))
			THEN IIF(@w_language = 2, 'Retirement', 'ëﬁêE')	
			ELSE	''
		END	AS company_out_dt
	FROM M0070 
	INNER JOIN #TEMP_M0072 ON(
		M0070.company_cd	=	@P_company_cd
	AND	M0070.employee_cd	=	#TEMP_M0072.employee_cd
	)
	LEFT JOIN M0060 ON (
		M0060.company_cd			=	M0070.company_cd
	AND M0060.employee_typ			=	M0070.employee_typ
	--AND M0060.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M1 ON (
		M1.company_cd			=	M0070.company_cd
	AND M1.organization_cd_1	=	M0070.belong_cd1
	AND M1.organization_typ		=	1
	--AND M1.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M2 ON (
		M2.company_cd			=	M0070.company_cd
	AND M2.organization_cd_1		=	M0070.belong_cd1
	AND M2.organization_cd_2		=	M0070.belong_cd2
	AND M2.organization_typ		=	2
	--AND M2.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M3 ON (
		M3.company_cd			=	M0070.company_cd
	AND M3.organization_cd_1		=	M0070.belong_cd1
	AND M3.organization_cd_2		=	M0070.belong_cd2
	AND M3.organization_cd_3		=	M0070.belong_cd3
	AND M3.organization_typ		=	3
	--AND M2.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M4 ON (
		M4.company_cd			=	M0070.company_cd
	AND M4.organization_cd_1		=	M0070.belong_cd1
	AND M4.organization_cd_2		=	M0070.belong_cd2
	AND M4.organization_cd_3		=	M0070.belong_cd3
	AND M4.organization_cd_4		=	M0070.belong_cd4
	AND M4.organization_typ		=	4
	--AND M2.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M5 ON (
		M5.company_cd			=	M0070.company_cd
	AND M5.organization_cd_1		=	M0070.belong_cd1
	AND M5.organization_cd_2		=	M0070.belong_cd2
	AND M5.organization_cd_3		=	M0070.belong_cd3
	AND M5.organization_cd_4		=	M0070.belong_cd4
	AND M5.organization_cd_5		=	M0070.belong_cd5
	AND M5.organization_typ		=	5
	--AND M2.del_datetime			IS NULL 
	) 
	LEFT JOIN M0030 ON (
		M0030.company_cd			=	M0070.company_cd
	AND M0030.job_cd				=	M0070.job_cd
	--AND M0030.del_datetime			IS NULL 
	) 
	LEFT JOIN M0040 ON (
		M0040.company_cd			=	M0070.company_cd
	AND M0040.position_cd			=	M0070.position_cd
	--AND M0040.del_datetime			IS NULL 
	) 
	LEFT JOIN M0050 ON (
		M0050.company_cd			=	M0070.company_cd
	AND M0050.grade					=	M0070.grade
	--AND M0050.del_datetime			IS NULL 
	) 
	LEFT JOIN #TEMP_F0030 ON (
		M0070.employee_cd	=	#TEMP_F0030.employee_cd 
	)
	LEFT OUTER JOIN S0020 ON (
		M0070.company_cd	=	S0020.company_cd
	AND	@authority_cd		=	S0020.authority_cd
	)
	WHERE
		M0070.company_cd				=	@P_company_cd
	AND (@P_employee_cd					= ''	OR	M0070.employee_cd	=	@P_employee_cd)
	AND (@P_employee_typ				= -1	OR	M0070.employee_typ	=	@P_employee_typ)
	AND (@P_position_cd					= -1	OR	M0070.position_cd	=	@P_position_cd)
	AND (@P_grade						= -1	OR	M0070.grade			=	@P_grade)
	AND	(@P_employee_nm = ''	OR (
									dbo.FNC_COM_REPLACE_SPACE(M0070.employee_nm)		LIKE '%' + dbo.FNC_COM_REPLACE_SPACE(@P_employee_nm) + '%' 
								OR	dbo.FNC_COM_REPLACE_SPACE(M0070.furigana)			LIKE '%' + dbo.FNC_COM_REPLACE_SPACE(@P_employee_nm) + '%' 
								)
	)
	AND M0070.del_datetime	IS NULL
	AND (	(@P_ck_search = 0 AND ((#TEMP_F0030.employee_cd IS NOT NULL AND @P_fiscal_year <> - 1) 
										OR (@authority_typ = 2 AND #TEMP_F0030.employee_cd IS NOT NULL) 
										OR (@P_fiscal_year = -1 AND @authority_typ <> 2)) 
					 )    
				OR	( @P_ck_search = 1 AND  #TEMP_F0030.employee_cd IS NULL AND @authority_typ <> 2) 
			)
	AND(
			@authority_typ <> 3
		OR
			(ISNULL(S0020.use_typ,0)	<> 1 OR ( ISNULL(S0020.use_typ,0)  = 1 AND ISNULL(M0040.arrange_order,0) > @arrange_order ))
	)
	AND (
		(@P_company_out_dt_flg	=	1)
	OR	(@P_company_out_dt_flg	=	0	AND (M0070.company_out_dt IS  NULL OR M0070.company_out_dt >=  @w_time))
	)
	ORDER BY 
		CASE ISNUMERIC(M0070.employee_cd) 
		   WHEN 1 
		   THEN CAST(M0070.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	M0070.employee_cd

	--DELETE ORGANIZATION NOT IN #ORG_TEMP
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION ) 
	BEGIN
		SET @choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)

		-- 1.choice in screen 
		-- 0.get from master S0022
		-- Filter organization_typ = 1
		IF @choice_in_screen = 1
		BEGIN
			DELETE D FROM #TMP AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.belong_cd1			=	S.organization_cd_1
			AND D.belong_cd2			=	S.organization_cd_2
			AND D.belong_cd3			=	S.organization_cd_3
			AND D.belong_cd4			=	S.organization_cd_4
			AND D.belong_cd5			=	S.organization_cd_5
			)
			WHERE 
				D.employee_cd IS NULL
			OR	S.organization_typ IS NULL
		END
		ELSE IF NOT (@authority_typ = 3 AND @w_evaluation_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)	-- edited by viettd 2021/06/03
		BEGIN
			DELETE D FROM #TMP AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.belong_cd1			=	S.organization_cd_1
			AND D.belong_cd2			=	S.organization_cd_2
			AND D.belong_cd3			=	S.organization_cd_3
			AND D.belong_cd4			=	S.organization_cd_4
			AND D.belong_cd5			=	S.organization_cd_5
			)
			WHERE 
				D.employee_cd IS NULL
			OR	S.organization_typ IS NULL
			AND @authority_typ NOT IN(4,5) --4.?????????????????h?????? 5.?????????????????h??????
		END
	END
	--
	SET @str_list_item =( SELECT(STUFF((SELECT ',['+CAST(M0080.item_cd AS nvarchar(20))+']'
										  FROM M0080 
										  WHERE company_cd = @P_company_cd
										  AND search_item_kbn = 1
										  AND del_datetime IS NULL
										  ORDER BY item_cd
										  FOR XML PATH (''))
										 , 1, 1, '') ) )
	INSERT INTO #M0072_DETAIL_NAME
	SELECT 
	#TMP.employee_cd
	, M0072.item_cd
	, STUFF((SELECT ',' + M0081.detail_name FROM M0072 AS #M0072
								INNER JOIN M0081 ON(
									#M0072.company_cd	=	M0081.company_cd
								AND	#M0072.item_cd		=	M0081.item_cd
								AND #M0072.number_item	=	M0081.detail_no
								AND M0081.del_datetime IS NULL
								) 
								
							WHERE #M0072.company_cd			=	M0072.company_cd
								AND #M0072.employee_cd		=	#TMP.employee_cd
								AND #M0072.item_cd			=	M0072.item_cd
			FOR XML PATH ('')), 1, 1, '') 
	FROM #TMP 
	INNER JOIN M0072 ON(
		@P_company_cd	=	M0072.company_cd
	AND	#TMP.employee_cd = M0072.employee_cd
	AND M0072.del_datetime IS NULL
	) 
	LEFT JOIN M0080 ON(
		M0072.company_cd	=	M0080.company_cd
	AND M0072.item_cd		=	M0080.item_cd
	AND search_item_kbn = 1
	AND M0080.del_datetime IS NULL
	)
	WHERE M0080.item_kind IN(4,5)
	GROUP BY  M0072.company_cd
			, #TMP.employee_cd
			, M0072.item_cd
			, M0080.item_nm
	--
	INSERT INTO #M0072_DETAIL_NAME
	SELECT 				
		ISNULL(#TMP.employee_cd,'')												AS employee_cd
	,	ISNULL(M0072.item_cd,'')												AS item_cd
	,	CASE WHEN M0080.item_kind = 1 THEN ISNULL(character_item,'')			
				WHEN M0080.item_kind = 2 THEN CAST(number_item AS nvarchar(50))	
				WHEN M0080.item_kind = 3 THEN FORMAT(date_item, 'yyyy/MM/dd')			
				ELSE ''
		END																		AS value_item	
	FROM #TMP 
	LEFT JOIN M0072 ON(
		@P_company_cd	=	M0072.company_cd
	AND	#TMP.employee_cd = M0072.employee_cd
	AND M0072.del_datetime IS NULL
	)
	LEFT JOIN #M0072_DETAIL_NAME ON(
		M0072.employee_cd	=	#M0072_DETAIL_NAME.employee_cd	
	AND	M0072.item_cd		=	#M0072_DETAIL_NAME.item_cd
	)
	LEFT JOIN M0080 ON(
		M0072.company_cd	=	M0080.company_cd
	AND M0072.item_cd		=	M0080.item_cd
	AND M0080.search_item_kbn = 1
	AND M0080.del_datetime IS NULL
	)
	WHERE M0080.item_kind NOT IN (4,5)

	INSERT INTO #M0072_DETAIL_NAME
	SELECT 
		'≈Ω√êÀ?√µ‚Äù√î¬ç‚Ä?'
	,	M0080.item_cd
	,	M0080.item_nm
	FROM  M0080 
	WHERE
		M0080.company_cd		=	@P_company_cd
	AND M0080.search_item_kbn	=	1
	AND M0080.del_datetime IS NULL
	GROUP BY M0080.item_cd
	,	M0080.item_nm	

	INSERT INTO #TMP2
	SELECT --BODY
		--id
		employee_key
	,	employee_cd			
	,	employee_nm			
	,	employee_typ_nm		
	,	belong_cd1_nm		
	,	belong_cd2_nm
	,	belong_cd3_nm
	,	belong_cd4_nm
	,	belong_cd5_nm		
	,	job_nm				
	,	position_nm			
	,	grade_nm
	,	company_out_dt 			
	FROM #TMP

	--
	IF NOT EXISTS (SELECT 1 FROM #TMP WHERE employee_key <> '0')
	BEGIN
		INSERT INTO @ERR_TBL VALUES(
			21
		,	'#employee_cd'
		,	0-- oderby
		,	2-- dialog  
		,	0
		,	0
		,	'employee_cd not found'
		)
	END
	--[0]
	IF @str_list_item IS NOT NULL AND @str_list_item != ''
	BEGIN
		SET @str_exce = 
		'SELECT --BODY
			--id
			company_out_dt 
		,	employee_cd			
		,	employee_nm			
		,	employee_typ_nm		
		,'+@str_header+'	
		,	job_nm				
		,	position_nm			
		,	grade_nm	
		,'+@str_list_item+'
		FROM (
		SELECT 
			#TMP2.employee_key
		,	#TMP2.company_out_dt 
		,	#TMP2.employee_cd			
		,	#TMP2.employee_nm			
		,	#TMP2.employee_typ_nm		
		,'+@str_header+'	
		,	#TMP2.job_nm				
		,	#TMP2.position_nm			
		,	#TMP2.grade_nm	
		,	#M0072_DETAIL_NAME.item_value
		,	#M0072_DETAIL_NAME.item_cd	
		FROM  #TMP2 
		LEFT JOIN #M0072_DETAIL_NAME ON(
		#TMP2.employee_cd	 = #M0072_DETAIL_NAME.employee_cd
		)
		) AS source
		Pivot(MAX(item_value) FOR item_cd IN ('+@str_list_item+')) AS A
		ORDER BY 
			employee_key
		,	CASE ISNUMERIC(employee_cd) 
			   WHEN 1 
			   THEN CAST(employee_cd AS BIGINT) 
			   ELSE 999999999999999 
			END 
	    ,	employee_cd'			
	END
	ELSE
	BEGIN
		SET @str_exce = 
		'SELECT --BODY
			--id
			company_out_dt 
		,	employee_cd			
		,	employee_nm			
		,	employee_typ_nm		
		,'+@str_header+'	
		,	job_nm				
		,	position_nm			
		,	grade_nm	
		,''''
		FROM (
		SELECT 
			#TMP2.employee_key
		,	#TMP2.company_out_dt 
		,	#TMP2.employee_cd			
		,	#TMP2.employee_nm			
		,	#TMP2.employee_typ_nm		
		,'+@str_header+'	
		,	#TMP2.job_nm				
		,	#TMP2.position_nm			
		,	#TMP2.grade_nm	
		,	#M0072_DETAIL_NAME.item_value
		,	#M0072_DETAIL_NAME.item_cd	
		FROM  #TMP2 
		LEFT JOIN #M0072_DETAIL_NAME ON(
		#TMP2.employee_cd	 = #M0072_DETAIL_NAME.employee_cd
		)
		) AS source
																 
		ORDER BY 
			employee_key
		,	CASE ISNUMERIC(employee_cd) 
			   WHEN 1 
			   THEN CAST(employee_cd AS BIGINT) 
			   ELSE 999999999999999 
			END 
	    ,	employee_cd'			
	END
	EXECUTE(@str_exce)
	END TRY
	BEGIN CATCH
	IF (@@TRANCOUNT > 0)
		BEGIN
			ROLLBACK TRANSACTION
		END
		DELETE FROM @ERR_TBL
		INSERT INTO @ERR_TBL
		SELECT	
			0
		,	'EXCEPTION'
		,	0
		,	999 -- exception error
		,	0
		,	0
		,	'Error'                                                          + CHAR(13) + CHAR(10) +
            'Procedure : ' + ISNULL(ERROR_PROCEDURE(), '???')                + CHAR(13) + CHAR(10) +
            'Line : '      + ISNULL(CAST(ERROR_LINE() AS NVARCHAR(10)), '0') + CHAR(13) + CHAR(10) +
            'Message : '   + ISNULL(ERROR_MESSAGE(), 'An unexpected error occurred.')
	END CATCH
	--DELETE FROM @ERR_TBL
	IF(@@TRANCOUNT > 0)
	BEGIN
		COMMIT TRANSACTION
	END
    -- Insert statements for procedure here
	COMPLETE_QUERY:
	-- GET ERROR_TYPE MIN
	SELECT 
		@order_by_min = MIN(order_by)
	FROM @ERR_TBL
	--[0] SELECT ERROR TABLE
	SELECT 
		message_no
	,	item
	,	order_by
	,	error_typ
	,	value1
	,	value2
	,	remark
	FROM @ERR_TBL
	WHERE order_by = @order_by_min
	ORDER BY 
		order_by
	--????DROP TABLE 
	DROP TABLE #TEMP_F0030
	DROP TABLE #TMP
END

GO
