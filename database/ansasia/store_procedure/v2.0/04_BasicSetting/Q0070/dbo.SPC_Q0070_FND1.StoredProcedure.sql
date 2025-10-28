DROP PROCEDURE [SPC_Q0070_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	M0100_商品登録
--*  
--*  作成日/create date			:	2017/11/03						
--*　作成者/creater				:	tannq								
--*   					
--*  更新日/update date			:	2021/04/01
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	when not data in M0080-> search all : NG
--*   					
--*  更新日/update date			:	2021/06/03
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
--*   					
--*  更新日/update date			:	2022/01/11
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	IS view seach item
--*   					
--*  更新日/update date			:	2022/08/22
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	Ver 1.9
--****************************************************************************************
CREATE PROCEDURE [SPC_Q0070_FND1]
	-- Add the parameters for the stored procedure here
	@P_employee_cd								NVARCHAR(20)	=	''        
,	@P_employee_nm								NVARCHAR(40)	=	''  
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
,	@P_page_size								INT				=  20
,	@P_page										INT				=	1
,	@P_system									INT				=	1
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								date			= getdate()
	,	@ERR_TBL							ERRTABLE
	,	@order_by_min						INT				=	0
	,	@totalRecord						BIGINT			=	0
	,	@pageMax							INT				=	0	
	,	@page_size							INT				=	10
	,	@authority_typ						SMALLINT		=	0
	,	@employee_cd						NVARCHAR(20)	=	''
	,	@authority_cd						SMALLINT		=	0
	,	@position_cd						INT				=	0
	,	@arrange_order						INT				=	0
	,	@choice_in_screen					INT				=	0
	,	@current_year						INT				=	2000
	,	@str_list_item						NVARCHAR(MAX)	=	''
	,	@str_exec							NVARCHAR(MAX)	=	''
	-- add by viettd 2021/06/03
	,	@w_evaluation_organization_cnt		INT				=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT		=	0
	,	@w_language							SMALLINT			=	1 --1:jp 2:en
	SELECT 
		@authority_typ	=	ISNULL(authority_typ,0) 
	,	@employee_cd	=	ISNULL(M0070.employee_cd,'')
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
	SET @current_year = (SELECT dbo.FNC_GET_YEAR(@P_company_cd,SYSDATETIME()))
	SET @authority_typ = ISNULL(@authority_typ,0)
	SET @arrange_order = ISNULL((SELECT ISNULL(M0040.arrange_order,0) FROM M0040 WHERE M0040.del_datetime IS NULL AND M0040.position_cd		=	@position_cd AND M0040.company_cd = @P_company_cd),0)
	-- COUNT ALL ORGANIZATIONS OF S0022 -- add by viettd 2021/06/03
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@authority_cd,1)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@authority_cd,1)
	--add vietdt 2022/01/11
	CREATE TABLE #M0080(
		company_cd	SMALLINT
	,	item_cd		SMALLINT
	,	item_nm		NVARCHAR(50)
	,	item_kind	SMALLINT
	)
	--
	INSERT INTO #M0080
	SELECT	DISTINCT
		M0080.company_cd
	,	M0080.item_cd		
	,	M0080.item_nm		
	,	M0080.item_kind		
	FROM M0080
	LEFT JOIN M0082 ON (
		M0080.company_cd	=	M0082.company_cd
	AND	M0080.item_cd		=	M0082.item_cd
	AND	M0082.del_datetime	IS NULL
	)
	WHERE
		M0080.company_cd		=	@P_company_cd
	AND M0080.item_display_kbn	=	1
	AND M0080.del_datetime		IS NULL
	AND	(
			(@authority_typ = 2 AND M0080.rater_browsing_kbn	= 1)
		OR	(@authority_typ = 3 AND M0082.browsing_kbn	= 1 AND M0082.authority_cd	= @authority_cd)
		OR	(@authority_typ IN (4,5))
		)
	ORDER BY 
		M0080.item_cd	
	--add vietdt 2022/01/11
	--get all ORGANIZATION with authority
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
	EXEC SPC_REFER_ORGANIZATION_FND1 @P_list_org,@P_user_id,@P_company_cd,@P_system
	--
	CREATE TABLE #TEMP_M0072(
		employee_cd		NVARCHAR(20)
	)
	--
	CREATE TABLE #M0072_DETAIL_NAME(
		employee_cd			NVARCHAR(20)
	,	item_cd				smallint
	,	item_nm				NVARCHAR(50)
	,	item_value			NVARCHAR(MAX)
	,	json_item_detail	NVARCHAR(MAX)
	)
	-- processing search in M0072 
	INSERT INTO  #TEMP_M0072
	EXEC SPC_ALTERNATIVE_ITEM_FIND1 @P_list_item,@P_company_cd,0
	CREATE TABLE #TMP (
		id				INT IDENTITY(1,1) NOT NULL
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
	-- #TEMP_F0030
	CREATE TABLE #TEMP_F0030 (
		id				INT IDENTITY(1,1) NOT NULL
	,	employee_cd		NVARCHAR(20)	
	)
	--#TEMP_F0030
	INSERT INTO #TEMP_F0030
	SELECT
		F0030.employee_cd 
	FROM F0030
	WHERE
		F0030.company_cd	=	@P_company_cd
	AND ((@P_fiscal_year	= -1  AND @current_year = F0030.fiscal_year) OR F0030.fiscal_year	=	@P_fiscal_year)
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
	INSERT INTO #TMP 
	SELECT  
		M0070.employee_cd		
	,	M0070.employee_nm		
	,	ISNULL(M0070.employee_typ,0)	
	,	M0060.employee_typ_nm
	,	ISNULL(M0070.belong_cd1,'')		
	,	CASE
			WHEN ISNULL(M1.organization_ab_nm,'') = '' THEN ISNULL(M1.organization_nm,'')		
			ELSE M1.organization_ab_nm
		END	
	,	ISNULL(M0070.belong_cd2,'')		
	,	CASE
			WHEN ISNULL(M2.organization_ab_nm,'') = '' THEN ISNULL(M2.organization_nm,'')		
			ELSE M2.organization_ab_nm
		END
	,	ISNULL(M0070.belong_cd3,'')		
	,	CASE
			WHEN ISNULL(M3.organization_ab_nm,'') = '' THEN ISNULL(M3.organization_nm,'')		
			ELSE M3.organization_ab_nm
		END
	,	ISNULL(M0070.belong_cd4,'')		
	,	CASE
			WHEN ISNULL(M4.organization_ab_nm,'') = '' THEN ISNULL(M4.organization_nm,'')		
			ELSE M4.organization_ab_nm
		END
	,	ISNULL(M0070.belong_cd5,'')		
	,	CASE
			WHEN ISNULL(M5.organization_ab_nm,'') = '' THEN ISNULL(M5.organization_nm,'')		
			ELSE M5.organization_ab_nm
		END
	,	ISNULL(M0070.job_cd,0)			
	,	CASE
			WHEN ISNULL(m0030.job_ab_nm,'') = '' THEN ISNULL(m0030.job_nm,'')		
			ELSE m0030.job_ab_nm
		END
	,	ISNULL(M0070.position_cd,0)	
	,	CASE
			WHEN ISNULL(M0040.position_ab_nm,'') = '' THEN ISNULL(M0040.position_nm,'')		
			ELSE M0040.position_ab_nm
		END	
	,	ISNULL(M0070.grade,0)		
	,	M0050.grade_nm	
	,	CASE
			WHEN (M0070.company_out_dt IS NOT NULL AND (M0070.company_out_dt <  @w_time))
			THEN IIF(@w_language = 2, 'Retirement', '退職')	
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
								--OR	dbo.FNC_COM_REPLACE_SPACE(M0070.employee_ab_nm)		LIKE '%' + dbo.FNC_COM_REPLACE_SPACE(@P_employee_nm) + '%' 
								OR	dbo.FNC_COM_REPLACE_SPACE(M0070.furigana)			LIKE '%' + dbo.FNC_COM_REPLACE_SPACE(@P_employee_nm) + '%' 
								)
	)
	AND (	(@P_ck_search = 0 AND ((#TEMP_F0030.employee_cd IS NOT NULL AND @P_fiscal_year <> - 1) 
										OR (@authority_typ = 2 AND #TEMP_F0030.employee_cd IS NOT NULL) 
										OR (@P_fiscal_year = -1 AND @authority_typ <> 2)) 
					 )    
				OR	( @P_ck_search = 1 AND  #TEMP_F0030.employee_cd IS NULL AND @authority_typ <> 2) 
			)
	AND (
		(@P_company_out_dt_flg	=	1)
	OR	(@P_company_out_dt_flg	=	0	AND (M0070.company_out_dt IS  NULL OR M0070.company_out_dt >=  @w_time))
	)
	AND(
			@authority_typ <> 3
		OR
			(ISNULL(S0020.use_typ,0)	<> 1 OR ( ISNULL(S0020.use_typ,0)  = 1 AND ISNULL(M0040.arrange_order,0) > @arrange_order ))
	)
	AND (@authority_typ <> 2 OR  M0070.employee_cd <> @employee_cd ) -- khong hien thi thawng dang nhap voi authority = 2
	AND M0070.del_datetime IS NULL
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
		ELSE IF NOT (@authority_typ = 3 AND @w_evaluation_organization_cnt = 0 AND @w_organization_belong_person_typ = 0) -- edited by viettd 2021/06/03
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
			AND @authority_typ NOT IN(4,5) --4.会社管理者 5.総合管理者
		END
	END
	--
	SET @str_list_item =( SELECT(STUFF((SELECT ',['+CAST(ISNULL(#M0080.item_cd,'') AS nvarchar(20))+']'
										  FROM #M0080 
										  ORDER BY item_cd
										  FOR XML PATH (''))
										 , 1, 1, '') ) )
	
	INSERT INTO #M0072_DETAIL_NAME
	SELECT 
	#TMP.employee_cd
	, M0072.item_cd
	, #M0080.item_nm
	, STUFF((SELECT ',' + ISNULL(M0081.detail_name,'') FROM M0072 AS #M0072
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
	,	'{"item_cd":"'+CAST(M0072.item_cd AS NVARCHAR(10))+'","item_kind":"","item_value":"","class_item_align":"text-left"}'
	FROM #TMP 
	INNER JOIN M0072 ON(
		@P_company_cd	=	M0072.company_cd
	AND	#TMP.employee_cd = M0072.employee_cd
	AND M0072.del_datetime IS NULL
	) 
	LEFT JOIN #M0080 ON(
		M0072.company_cd	=	#M0080.company_cd
	AND M0072.item_cd		=	#M0080.item_cd
	)
	WHERE #M0080.item_kind IN(4,5)
	GROUP BY  M0072.company_cd
			, #TMP.employee_cd
			, M0072.item_cd
			, #M0080.item_nm
	--
	INSERT INTO #M0072_DETAIL_NAME
	SELECT 				
		ISNULL(#TMP.employee_cd,'')												AS employee_cd
	,	ISNULL(M0072.item_cd,'')												AS item_cd
	,	ISNULL(#M0080.item_nm,'')												AS item_nm	
	,	CASE WHEN #M0080.item_kind = 1 THEN ISNULL(character_item,'')			
				WHEN #M0080.item_kind = 2 THEN CAST(number_item AS nvarchar(50))	
				WHEN #M0080.item_kind = 3 THEN FORMAT(date_item, 'yyyy/MM/dd')			
				ELSE ''
		END																		AS value_item	
	,	'{"item_cd":"'+CAST(M0072.item_cd AS NVARCHAR(10))+'","item_kind":"'+CAST(#M0080.item_kind AS NVARCHAR(10))+'","item_value":"","class_item_align":
			'+CASE	WHEN #M0080.item_kind = 1 THEN '"text-left"'		
					WHEN #M0080.item_kind = 2 THEN '"text-right"'		
					WHEN #M0080.item_kind = 3 THEN '"text-center"'			
					ELSE ''
			  END+'}'
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
	LEFT JOIN #M0080 ON(
		M0072.company_cd	=	#M0080.company_cd
	AND M0072.item_cd		=	#M0080.item_cd
	)
	WHERE #M0080.item_kind NOT IN (4,5)
	UPDATE #M0072_DETAIL_NAME
		SET json_item_detail	=	JSON_MODIFY(json_item_detail,'$.item_value',ISNULL(#M0072_DETAIL_NAME.item_value,''))
	FROM #M0072_DETAIL_NAME

	--
	SET @totalRecord	=	(SELECT COUNT(1) FROM #TMP)
	SET @pageMax		= CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	IF @pageMax			= 0
	BEGIN
		SET @pageMax	= 1
	END
	IF @P_page > @pageMax
	BEGIN
		SET @P_page = @pageMax
	END
	--[0]
	SET @str_exec = '
	SELECT
		id 
	,	employee_cd		
	,	employee_nm		
	,	employee_typ	
	,	employee_typ_nm 
	,	belong_cd1		
	,	belong_cd1_nm	
	,	belong_cd2		
	,	belong_cd2_nm	
	,	belong_cd3		
	,	belong_cd3_nm	
	,	belong_cd4		
	,	belong_cd4_nm	
	,	belong_cd5		
	,	belong_cd5_nm	
	,	job_cd			
	,	job_nm			
	,	position_cd		
	,	position_nm		
	,	grade			
	,	grade_nm	
	,	company_out_dt	
	,	CASE WHEN employee_cd = '''+@employee_cd+'''  AND '+CAST(@authority_typ AS NVARCHAR(20))+' = 4 THEN 1
		ELSE 0 
		END AS is_login_typ4
	,	'+@str_list_item+'
	FROM 
	(
	SELECT 
		#TMP.id 
	,	#TMP.employee_cd		
	,	#TMP.employee_nm		
	,	#TMP.employee_typ	
	,	#TMP.employee_typ_nm 
	,	#TMP.belong_cd1		
	,	#TMP.belong_cd1_nm	
	,	#TMP.belong_cd2		
	,	#TMP.belong_cd2_nm	
	,	#TMP.belong_cd3		
	,	#TMP.belong_cd3_nm	
	,	#TMP.belong_cd4		
	,	#TMP.belong_cd4_nm	
	,	#TMP.belong_cd5		
	,	#TMP.belong_cd5_nm	
	,	#TMP.job_cd			
	,	#TMP.job_nm			
	,	#TMP.position_cd		
	,	#TMP.position_nm		
	,	#TMP.grade			
	,	#TMP.grade_nm	
	,	#TMP.company_out_dt	
	,	#M0072_DETAIL_NAME.item_cd
	,	#M0072_DETAIL_NAME.json_item_detail
	FROM #TMP LEFT JOIN #M0072_DETAIL_NAME ON(
		#TMP.employee_cd	=	#M0072_DETAIL_NAME.employee_cd
	)
	) AS #P
	Pivot(MAX(json_item_detail) FOR item_cd IN ('+@str_list_item+')) AS A
	ORDER BY 
		CASE ISNUMERIC(employee_cd) 
		   WHEN 1 
		   THEN CAST(employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	employee_cd
	offset '+CAST(((@P_page - 1) * @P_page_size) AS nvarchar(20))+' rows
	fetch next '+CAST(@P_page_size as nvarchar(20))+' rows only
	'
	--[0]
	IF @str_exec IS NOT NULL AND @str_exec <> ''
	BEGIN
	execute(@str_exec)
	END
	ELSE
	BEGIN
		SELECT 
			id 
		,	employee_cd		
		,	employee_nm		
		,	employee_typ	
		,	employee_typ_nm 
		,	belong_cd1		
		,	belong_cd1_nm	
		,	belong_cd2		
		,	belong_cd2_nm	
		,	belong_cd3		
		,	belong_cd3_nm	
		,	belong_cd4		
		,	belong_cd4_nm	
		,	belong_cd5		
		,	belong_cd5_nm	
		,	job_cd			
		,	job_nm			
		,	position_cd		
		,	position_nm		
		,	grade			
		,	grade_nm	
		,	company_out_dt	
		,	CASE 
				WHEN employee_cd = @employee_cd  AND CAST(@authority_typ AS NVARCHAR(20)) = 4 
				THEN 1
				ELSE 0 
			END					AS is_login_typ4
		FROM #TMP
		-- add by viettd 2021/04/01
		ORDER BY 
			CASE ISNUMERIC(#TMP.employee_cd) 
			   WHEN 1 
			   THEN CAST(#TMP.employee_cd AS BIGINT) 
			   ELSE 999999999999999 
			END 
		,	#TMP.employee_cd
		offset (@P_page - 1) * @P_page_size rows
		fetch next @P_page_size rows only
	END
	--[1]
	SELECT	
		@totalRecord	AS totalRecord
	,	@pageMax		AS pageMax
	,	@P_page			AS page
	,	@P_page_size	AS pagesize
	,	((@P_page - 1) * @P_page_size + 1) AS offset
	--[2]
	SELECT 
	CASE WHEN	S0010.authority_typ = 3 
			AND S0021.authority = 0 
			THEN 2
		ELSE S0010.authority_typ
		END AS authority_typ
	FROM S0010 LEFT JOIN S0021 ON(
		S0010.company_cd	=	S0021.company_cd
	AND S0010.authority_cd	=	S0021.authority_cd
	AND S0021.function_id = 'M0070' 
	AND S0021.del_datetime	IS NULL
	)
	WHERE S0010.company_cd  = @P_company_cd
	AND S0010.user_id		= @P_user_id
	AND S0010.del_datetime IS NULL
	--[3] 
	SELECT 
		item_cd
	,	item_nm
	FROM #M0080
	ORDER BY item_cd		
	
			
	--笆�DROP TABLE 
	DROP TABLE #TEMP_F0030
	DROP TABLE #TMP
	DROP TABLE #TABLE_ORGANIZATION
END

GO
