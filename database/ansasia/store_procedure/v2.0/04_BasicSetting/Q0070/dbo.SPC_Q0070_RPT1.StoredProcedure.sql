DROP PROCEDURE [SPC_Q0070_RPT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ M0020
-- EXEC SPC_Q0070_RPT1 '','','-1','-1','-1','-1','-1','','-1','1','600','tuan'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	M0100_商品登録
--*  
--*  作成日/create date			:	2018/08/16						
--*　作成者/creater				:									
--*   					
--*  更新日/update date			:	2021/06/03
--*　更新者/updater				:　 viettd　
--*　更新内容/update content		:	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
--*   					
--*  更新日/update date			:	2022/08/22
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	Ver 1.9
--****************************************************************************************
CREATE PROCEDURE [SPC_Q0070_RPT1]
	-- Add the parameters for the stored procedure here	
	@P_employee_cd								NVARCHAR(20)	=	''        
,	@P_employee_nm								NVARCHAR(40)	=	''  
,	@P_employee_typ             				NVARCHAR(40)	=	-1
,	@P_list_org  								NVARCHAR(MAX)	=	''
,	@P_position_cd              				INT				=	-1
,	@P_grade                    				SMALLINT		=	-1
,	@P_company_out_dt_flg                    	SMALLINT		=	0
,	@P_fiscal_year              				SMALLINT		=	-1
,	@P_group_cd                 				SMALLINT		=	-1
,	@P_ck_search								SMALLINT		=	0
,	@P_list_item								NVARCHAR(MAX)	=	''
,	@P_company_cd								SMALLINT		=	0
,	@P_user_id									NVARCHAR(50)	=   '' -- S0010
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
	,	@string_column						nvarchar(max)		=	''
	,	@string_sql							nvarchar(max)		=	''
	,	@choice_in_screen					INT					=	0
	,	@current_year						INT					=	2000
	,	@count_item							INT					=	0
	-- add by viettd 2021/06/03
	,	@w_evaluation_organization_cnt		INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	,	@w_language							SMALLINT			=	1 --1:jp 2:en
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
	EXEC SPC_REFER_ORGANIZATION_FND1 @P_list_org,@P_user_id,@P_company_cd
	-- #TEMP_F0030
	CREATE TABLE #TEMP_F0030 (
		id				INT IDENTITY(1,1) NOT NULL
	,	employee_cd		NVARCHAR(20)	
	)
	-- M0070
	CREATE TABLE #TMP_M0070 (
		id								INT IDENTITY(1,1) NOT NULL
	,	employee_cd						NVARCHAR(20)	
	,	employee_nm						NVARCHAR(101)
	,	belong_cd1						NVARCHAR(40)
	,	belong_cd2						NVARCHAR(40)
	,	belong_cd3						NVARCHAR(40)
	,	belong_cd4						NVARCHAR(40)
	,	belong_cd5						NVARCHAR(40)		
	)
	--
	CREATE TABLE #TABLE_F0031(
		id							int			identity(1,1)
	,	company_cd					smallint
	,	fiscal_year					int
	,	employee_cd					nvarchar(20)
	,	treatment_applications_no	smallint
	,	treatment_applications_nm	nvarchar(50)
	,	rank_cd						smallint
	,	rank_nm						nvarchar(50)
	,	sheet_cd					smallint
	,	sheet_nm					nvarchar(50)
	,	evaluation_step				smallint
	,	point_sum					numeric(8,2)
	,	RANK_COUNT					smallint
	,	employee_nm					nvarchar(101)
	)
	CREATE TABLE #TEM_TREATMENT(
		company_cd					smallint
	,	fiscal_year					int
	,	employee_cd					nvarchar(20)
	,	treatment_applications_no	smallint
	)
	--
	CREATE TABLE #TABLE_F0030(
		id							int			identity(1,1)
	,	company_cd					smallint
	,	fiscal_year					int
	,	treatment_applications_no	smallint
	,	employee_cd					nvarchar(20)
	,	rater_employee_cd_1			smallint
	,	rater_employee_cd_2			smallint
	,	rater_employee_cd_3			smallint
	,	rater_employee_cd_4			smallint
	)
	--
	CREATE TABLE #TABLE_RANK(
		id							bigint			identity(1,1)
	,	RANK_COUNT					smallint
	)
	--
	CREATE TABLE #TEMP_RESULT(
		id							int			identity(1,1)
	,	key_orderBy					int
	,	employee_cd					nvarchar(50)
	,	employee_nm					nvarchar(101)
	,	fiscal_year					nvarchar(50)
	,	treatment_applications_nm	nvarchar(50)
	,	treatment_applications_no	nvarchar(50)	
	,	rank_nm						nvarchar(50)	
	,	col_nm						nvarchar(50)
	,	col_order					nvarchar(10)
	)																					
	CREATE TABLE #F0032(
		company_cd					INT
	,	fiscal_year					INT
	,	treatment_applications_no	INT
	,	group_cd					INT
	,	employee_cd					NVARCHAR(50)
	,	sheet_cd					INT
	,	weight						INT
	)
	INSERT INTO  #F0032
	SELECT
		company_cd
	,	fiscal_year
	,	treatment_applications_no
	,	MAX(group_cd)
	,	employee_cd
	,	sheet_cd
	,	weight
	FROM F0032
	WHERE company_cd	=	@P_company_cd
	AND (fiscal_year		=	@P_fiscal_year OR @P_fiscal_year = -1) 
	AND del_datetime IS NULL
	GROUP BY	company_cd
			,	fiscal_year
			,	treatment_applications_no
			,	employee_cd
			,	detail_no
			,	sheet_cd
			,	weight
	INSERT INTO #TEM_TREATMENT
	SELECT 
		company_cd				
	,	fiscal_year				
	,	employee_cd				
	,	treatment_applications_no
	FROM #F0032
	WHERE 
		company_cd	=	@P_company_cd
	AND (@P_fiscal_year = -1 OR fiscal_year =	@P_fiscal_year)
	GROUP BY company_cd,fiscal_year,employee_cd,treatment_applications_no
	--
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
	INSERT INTO #TMP_M0070 
	SELECT 
		M0070.employee_cd	
	,	M0070.employee_nm
	,	M0070.belong_cd1
	,	M0070.belong_cd2
	,	M0070.belong_cd3
	,	M0070.belong_cd4
	,	M0070.belong_cd5			
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
	OR	(@P_company_out_dt_flg	=	0 AND (M0070.company_out_dt IS  NULL OR M0070.company_out_dt >=  @w_time))
	)
	GROUP BY 
		M0070.employee_cd
	,	M0070.employee_nm
	,	M0070.belong_cd1
	,	M0070.belong_cd2
	,	M0070.belong_cd3
	,	M0070.belong_cd4
	,	M0070.belong_cd5	
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
			DELETE D FROM #TMP_M0070 AS D
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
			DELETE D FROM #TMP_M0070 AS D
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
	INSERT INTO #TABLE_F0030
	SELECT
		ISNULL(F0030.company_cd,0)
	,	ISNULL(F0030.fiscal_year,0)	
	,	F0030.treatment_applications_no	
	,	ISNULL(F0030.employee_cd,'')
	,	IIF(ISNULL(F0030.rater_employee_cd_1,'') <> '',1,0)
	,	IIF(ISNULL(F0030.rater_employee_cd_2,'') <> '',1,0)
	,	IIF(ISNULL(F0030.rater_employee_cd_3,'') <> '',1,0)
	,	IIF(ISNULL(F0030.rater_employee_cd_4,'') <> '',1,0)
	FROM F0030
	--INNER JOIN #TMP_M0070 AS TEMP ON (
	--	F0030.company_cd	=	@P_company_cd
	--AND F0030.employee_cd	=	TEMP.employee_cd
	--)
	--LEFT JOIN F0020 ON(
	--	F0030.company_cd				= F0020.company_cd
	--AND F0030.fiscal_year				= F0020.fiscal_year
	--AND F0030.treatment_applications_no = F0020.treatment_applications_no
	--) 
	--LEFT JOIN #M0070_EMPLOYEE_CD ON (
	--	F0030.company_cd	=	#M0070_EMPLOYEE_CD.company_cd
	--AND F0030.fiscal_year	=	@P_fiscal_year
	--AND F0030.employee_cd	=	#M0070_EMPLOYEE_CD.employee_cd
	--AND F0020.group_cd		=	#M0070_EMPLOYEE_CD.group_cd
	--)
	WHERE
		F0030.company_cd	=	@P_company_cd
	AND (@P_fiscal_year		= -1 OR F0030.fiscal_year	=	@P_fiscal_year)
	AND (@P_group_cd		= -1 OR F0030.group_cd		=	@P_group_cd)-- dat 2019-12-11
	--AND (@P_group_cd		= -1 OR #M0070_EMPLOYEE_CD.employee_cd IS NOT NULL) -- dat 2019-12-11
	AND	F0030.del_datetime IS NULL
	--
	INSERT INTO #TABLE_F0031
	SELECT 
		ISNULL(#F0032.company_cd,0)				
	,	ISNULL(#F0032.fiscal_year,0)					
	,	ISNULL(#F0032.employee_cd,'')					
	,	ISNULL(#F0032.treatment_applications_no,0)
	,	ISNULL(M0102.treatment_applications_nm,'')		
	,	ISNULL(F0201.rank_cd,0)
	,	ISNULL(M0130.rank_nm,'')	
	,	ISNULL(#F0032.sheet_cd,0)		
	,	ISNULL(M0200.sheet_nm,'')				
	,	ISNULL(TABLE_F0030.evaluation_step,0)
	,	0
	,	ROW_NUMBER() OVER(PARTITION BY #F0032.fiscal_year,#F0032.employee_cd,#F0032.treatment_applications_no,M0130.rank_nm ORDER BY #F0032.fiscal_year,#F0032.employee_cd,#F0032.treatment_applications_no,M0130.rank_nm) 
	,	TEMP.employee_nm	
	FROM #F0032
	INNER JOIN #TMP_M0070 AS TEMP ON (
		#F0032.company_cd	=	@P_company_cd
	AND #F0032.employee_cd	=	TEMP.employee_cd
	)
	--LEFT OUTER JOIN #F0032 ON (
	--	#TABLE_F0030.company_cd							=	#F0032.company_cd
	--AND #TABLE_F0030.fiscal_year						=	#F0032.fiscal_year
	--AND #TABLE_F0030.employee_cd						=	#F0032.employee_cd
	--AND #TABLE_F0030.treatment_applications_no			=	#F0032.treatment_applications_no	
	--)
	LEFT OUTER JOIN M0102 ON (
		#F0032.company_cd						=	M0102.company_cd
	AND #F0032.treatment_applications_no			=	M0102.detail_no	
	)
	LEFT OUTER JOIN F0201 ON (
		#F0032.company_cd						=	F0201.company_cd
	AND #F0032.fiscal_year						=	F0201.fiscal_year
	AND #F0032.employee_cd						=	F0201.employee_cd
	AND #F0032.treatment_applications_no			=	F0201.treatment_applications_no	
	AND F0201.del_datetime IS NULL
	AND F0201.evaluatorFB_datetime IS NOT NULL
	)
	LEFT OUTER JOIN W_M0130 AS M0130 ON (
		F0201.company_cd						=	M0130.company_cd
	AND F0201.fiscal_year						=	M0130.fiscal_year
	AND F0201.rank_cd							=	M0130.rank_cd
	AND M0130.treatment_applications_no			=	#F0032.treatment_applications_no	
	AND	M0130.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0200 AS M0200 ON (
		#F0032.company_cd						=	M0200.company_cd
	AND #F0032.fiscal_year						=	M0200.fiscal_year
	AND #F0032.sheet_cd							=	M0200.sheet_cd
	AND	M0200.del_datetime IS NULL
	)
	LEFT OUTER JOIN (
		SELECT 
			#TABLE_F0030.company_cd					AS	company_cd
		,	#TABLE_F0030.fiscal_year				AS	fiscal_year
		,	#TABLE_F0030.employee_cd				AS	employee_cd
		,	#TABLE_F0030.treatment_applications_no	AS treatment_applications_no
		,	SUM(#TABLE_F0030.rater_employee_cd_1+#TABLE_F0030.rater_employee_cd_2+#TABLE_F0030.rater_employee_cd_3+#TABLE_F0030.rater_employee_cd_4)
													AS	evaluation_step
		FROM #TABLE_F0030
		GROUP BY
			#TABLE_F0030.company_cd	
		,	#TABLE_F0030.fiscal_year
		,	#TABLE_F0030.employee_cd
		,	#TABLE_F0030.treatment_applications_no	
	) AS TABLE_F0030 ON (
		#F0032.company_cd							=	TABLE_F0030.company_cd
	AND #F0032.fiscal_year						=	TABLE_F0030.fiscal_year
	AND #F0032.employee_cd						=	TABLE_F0030.employee_cd
	AND #F0032.treatment_applications_no			=	TABLE_F0030.treatment_applications_no	
	)
	WHERE 
		#F0032.company_cd			=	@P_company_cd
	--AND F0031.employee_cd			=	@P_employee_cd
	AND (@P_fiscal_year		= -1 OR #F0032.fiscal_year	=	@P_fiscal_year)
	ORDER BY 
		CASE ISNUMERIC(#F0032.employee_cd) 
		   WHEN 1 
		   THEN CAST(#F0032.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	#F0032.employee_cd
	--

	UPDATE #TABLE_F0031 SET 
		point_sum = ISNULL(F0120.point_sum,0)
	FROM F0120
	LEFT OUTER JOIN (
		SELECT 
			F0120.company_cd							AS	company_cd
		,	F0120.fiscal_year							AS	fiscal_year
		,	F0120.employee_cd							AS	employee_cd
		,	F0120.sheet_cd								AS	sheet_cd
		,	MAX(ISNULL(F0120.evaluation_step,0))		AS	evaluation_step
		FROM F0120
		INNER JOIN #TABLE_F0031  AS TEMP ON (
			F0120.company_cd			=	TEMP.company_cd
		AND F0120.fiscal_year			=	TEMP.fiscal_year
		AND F0120.employee_cd			=	TEMP.employee_cd
		AND F0120.sheet_cd				=	TEMP.sheet_cd
		)
		GROUP BY
			F0120.company_cd							
		,	F0120.fiscal_year							
		,	F0120.employee_cd							
		,	F0120.sheet_cd
										
	) AS TABLE_F0120 ON (
		F0120.company_cd					=	TABLE_F0120.company_cd
	AND F0120.fiscal_year					=	TABLE_F0120.fiscal_year
	AND F0120.employee_cd					=	TABLE_F0120.employee_cd
	AND F0120.sheet_cd						=	TABLE_F0120.sheet_cd
	--AND F0120.evaluation_step				=	TABLE_F0120.evaluation_step
	)
	WHERE
		#TABLE_F0031.company_cd				=	F0120.company_cd
	AND #TABLE_F0031.fiscal_year			=	F0120.fiscal_year
	AND #TABLE_F0031.employee_cd			=	F0120.employee_cd
	AND #TABLE_F0031.sheet_cd				=	F0120.sheet_cd
	AND	(
		(#TABLE_F0031.evaluation_step		>	TABLE_F0120.evaluation_step
	AND	F0120.evaluation_step				=	TABLE_F0120.evaluation_step)
	OR	(#TABLE_F0031.evaluation_step		<=	TABLE_F0120.evaluation_step
	AND	F0120.evaluation_step				=	#TABLE_F0031.evaluation_step)
	)
	AND	F0120.company_cd					=	@P_company_cd
	--AND F0120.employee_cd					=	@P_employee_cd
	AND	F0120.del_datetime IS NULL

	--#TABLE_RANK
	DECLARE
		@max_rank	INT		=	0
	,	@i			INT		=	1
	SELECT @max_rank	=	MAX(RANK_COUNT) FROM #TABLE_F0031
	WHILE (@i <= @max_rank)
	BEGIN
		INSERT INTO #TABLE_RANK
		SELECT @i
		SET @i = @i+1
	END
	--
	SELECT @string_column = stuff((select ', ['+ cast((#TABLE_RANK.RANK_COUNT) as nvarchar(10))+'] ,'+ '['+ cast((#TABLE_RANK.RANK_COUNT) as nvarchar(10))+'A]'
								 from #TABLE_RANK
								 for xml path('')),1,1,'')
	INSERT #TEMP_RESULT
	SELECT 
		0
	,	IIF(@w_language = 2,'Employee Code','社員コード')
	,	IIF(@w_language = 2,'Employee Name','社員名')
	,	IIF(@w_language = 2,'Yearly','年度')
	,	IIF(@w_language = 2,'Treatment Use Code','処遇用途コード')
	,	IIF(@w_language = 2,'Treatment Use Code','処遇用途コード')
	,	IIF(@w_language = 2,'Evaluation Remarks','評語')
	,	IIF(@w_language = 2,'Evaluation Element ','評価要素')+CAST((TEMP.id) AS NVARCHAR(2))
	,	 cast((TEMP.RANK_COUNT) as nvarchar(10))
	FROM #TABLE_RANK AS TEMP
	INSERT #TEMP_RESULT
	SELECT 
		0
	,	IIF(@w_language = 2,'Employee Code','社員コード')
	,	IIF(@w_language = 2,'Employee Name','社員名')
	,	IIF(@w_language = 2,'Yearly','年度')
	,	IIF(@w_language = 2,'Treatment Use Code','処遇用途コード')
	,	IIF(@w_language = 2,'Treatment Use Code','処遇用途コード')
	,	IIF(@w_language = 2,'Evaluation Remarks','評語')
	,	IIF(@w_language = 2,'Evaluation Pts','評価点')
	,	cast((TEMP.RANK_COUNT) as nvarchar(10))+'A'
	FROM #TABLE_RANK AS TEMP
	INSERT #TEMP_RESULT
	SELECT 
		1
	,	employee_cd
	,	employee_nm
	,	CAST(fiscal_year AS NVARCHAR(50))
	,	treatment_applications_nm
	,	treatment_applications_no
	,	rank_nm
	,	CAST(point_sum AS NVARCHAR(50))
	,	cast((#TABLE_F0031.RANK_COUNT) as nvarchar(10))+'A'
	FROM #TABLE_F0031  
	INSERT #TEMP_RESULT
	SELECT 
		1
	,	employee_cd
	,	employee_nm
	,	CAST(fiscal_year AS NVARCHAR(50))
	,	treatment_applications_nm
	,	treatment_applications_no
	,	rank_nm
	,	sheet_nm
	,	cast((#TABLE_F0031.RANK_COUNT) as nvarchar(10))
	FROM #TABLE_F0031
	--
	SET @string_sql = 
	'
	SELECT
		employee_cd,
		employee_nm,
		fiscal_year,
		treatment_applications_nm,
		rank_nm,
		'+@string_column+'
	FROM
	(
	SELECT 
		key_orderBy
	,	employee_cd
	,	employee_nm
	,	fiscal_year						
	,	treatment_applications_nm
	,	treatment_applications_no
	,	rank_nm
	,	col_order
	,	col_nm
	FROM #TEMP_RESULT
	) AS P
	Pivot(MAX(col_nm) FOR col_order IN ('+@string_column+')) AS A
	ORDER BY 
		key_orderBy
	,	CASE ISNUMERIC(employee_cd) 
		   WHEN 1 
		   THEN CAST(employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	employee_cd
	,	fiscal_year DESC 
	,	treatment_applications_no
	'
	--print @string_sql
	EXECUTE (@string_sql) 
	IF NOT EXISTS (SELECT 1 FROM #TABLE_F0031)
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
END
GO
