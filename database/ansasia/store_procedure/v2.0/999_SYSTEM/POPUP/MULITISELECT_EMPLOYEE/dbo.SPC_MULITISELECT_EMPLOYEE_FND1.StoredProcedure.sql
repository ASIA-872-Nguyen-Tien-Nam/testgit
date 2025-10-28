DROP PROCEDURE [SPC_MULITISELECT_EMPLOYEE_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************
--*   											
--*  処理概要/process overview	:	
--*  
--*  作成日/create date			:	2021/01/28				
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2021/06/03
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
--*   					
--*	更新日/update date			:	2021/06/16
--*	更新者/updater				:　 viettd　
--*	更新内容/update content		:	when rater_1 then can view & edited employees
--*   					
--*	更新日/update date			:	2022/08/16
--*	更新者/updater				:　 viettd　
--*	更新内容/update content		:	upgrade 1.9
--*   					
--****************************************************************************************
 CREATE PROCEDURE [SPC_MULITISELECT_EMPLOYEE_FND1] 
 	@P_company_cd			SMALLINT			=	0
,	@P_user_id				NVARCHAR(50)		=	''	-- login user_id
, 	@P_employee_cd			NVARCHAR(10)		=	''	-- 社員番号
,	@P_employee_ab_nm		NVARCHAR(10)		=	''	-- 名前
,	@P_office_cd			SMALLINT			=	-1	-- 事業所
,	@P_list_org				NVARCHAR(MAX)		=	''	-- 組織
,	@P_job_cd				SMALLINT			=	-1	-- 職種
,	@P_position_cd			INT      			=	-1	-- 役職
,	@P_company_out_dt_flg	SMALLINT			=	0	-- 退職した社員を含む
,	@P_fiscal_year			SMALLINT			=	0	-- 年度
,	@P_page_size			INT					=	50	--
,	@P_page					INT					=	1	--
,	@P_mulitiselect_mode	SMALLINT			=	1	-- 1.employee 2.suppoter 3.rater 
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@ERR_TBL							ERRTABLE
	,	@w_time								date				= getdate()
	,	@totalRecord						BIGINT				=	0
	,	@pageNumber							INT					=	0
	,	@pageMax							INT					=	0	
	,	@arrange_order						INT					=	0
	,	@position_cd						INT					=	0
	,	@w_employee_cd						NVARCHAR(10)		=	''
	,	@choice_in_screen					INT					=	0
	--
	,	@w_multireview_authority_typ		smallint			=	0
	,	@w_authority_typ					SMALLINT			=	0
	--
	,	@w_multireview_authority_cd			SMALLINT			=	0
	,	@use_typ							smallint			=	0	
	,	@w_fiscal_year_current				smallint			=	dbo.FNC_GET_YEAR(@P_company_cd,NULL)
	,	@w_other_browsing_kbn				smallint			=	0	-- F3020.other_browsing_kbn = 1.他サポーター情報
	-- add by viettd 2021/06/03
	,	@w_mulitireview_organization_cnt	INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	,	@w_user_is_rater_1					TINYINT				=	0	-- 0.IS NOT RATER_1 | 1.IS RATER_1 -- add by viettd 2021/06/16
	,	@w_language							SMALLINT			=	1 --1:jp 2:en
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
	--#LIST_POSITION
	CREATE TABLE #LIST_POSITION(
		id								int			identity(1,1)
	,	position_cd						int
	,	mode							smallint
	)
	--#EMPLOYEE
	CREATE TABLE #EMPLOYEE(
	 	company_cd			SMALLINT		
	, 	employee_cd			NVARCHAR(10)	
	,	employee_ab_nm		NVARCHAR(50)	
	,	office_nm			NVARCHAR(50)	
	,	organization_cd1	NVARCHAR(50)		
	,	organization_cd2	NVARCHAR(50)	
	,	organization_cd3	NVARCHAR(50)		
	,	organization_cd4	NVARCHAR(50)	
	,	organization_cd5	NVARCHAR(50)		
	,	job_cd				SMALLINT		
	,	position_cd			INT
	,	employee_nm			NVARCHAR(101)	
	,	employee_typ		SMALLINT	
	,	belong_cd1			NVARCHAR(50)		
	,	belong_cd2			NVARCHAR(50)
	,	belong_cd3			NVARCHAR(50)		
	,	belong_cd4			NVARCHAR(50)
	,	belong_cd5			NVARCHAR(50)		
	,	grade				SMALLINT		
	,	office_cd			SMALLINT	
	,	employee_typ_nm		NVARCHAR(50)									
	,	organization_nm1	NVARCHAR(50)										
	,	organization_nm2	NVARCHAR(50)
	,	organization_nm3	NVARCHAR(50)										
	,	organization_nm4	NVARCHAR(50)
	,	organization_nm5	NVARCHAR(50)										
	,	job_nm				NVARCHAR(50)						
	,	position_nm			NVARCHAR(50)							
	,	grade_nm			NVARCHAR(50)
	,	company_out_dt		NVARCHAR(10)														
	)	
	-- create #TABLE_EMPLOYEE
	CREATE TABLE #TABLE_EMPLOYEE(
		company_cd						SMALLINT
	,	fiscal_year						SMALLINT
	,	employee_cd						NVARCHAR(40)
	)
	--
	SELECT 
		@w_authority_typ				=	ISNULL(S0010.authority_typ,0) 
	,	@position_cd					=	ISNULL(M0070.position_cd,0)
	,	@w_employee_cd					=	ISNULL(M0070.employee_cd,0)
	,	@w_multireview_authority_cd		=	ISNULL(S0010.multireview_authority_cd,0)
	,	@w_multireview_authority_typ	=	ISNULL(S0010.multireview_authority_typ,0)
	,	@w_language						=	ISNULL(S0010.language,1)
	FROM S0010 LEFT JOIN M0070 ON (
		M0070.company_cd		=	S0010.company_cd
	AND M0070.employee_cd		=	S0010.employee_cd
	AND M0070.del_datetime		IS NULL 
	) 
	WHERE 
		S0010.user_id		= @P_user_id 
	AND S0010.company_cd	= @P_company_cd 
	AND S0010.del_datetime  IS NULL
	-- ↓↓↓　add by viettd 2021/06/16
	IF EXISTS (SELECT 1 FROM F0030 WHERE company_cd = @P_company_cd AND fiscal_year = @P_fiscal_year AND rater_employee_cd_1 = @w_employee_cd AND del_datetime IS NULL)
	BEGIN
		SET @w_user_is_rater_1 = 1 -- USER IS RATER_1
	END
	-- ↑↑↑　end add by viettd 2021/06/16
	-- get @arrange_order
	SELECT 
		@arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@position_cd
	AND M0040.del_datetime IS NULL
	-- get @use_typ
	SELECT 
		@use_typ = ISNULL(S3020.use_typ,0)
	FROM S3020
	WHERE 
		S3020.company_cd	=	@P_company_cd
	AND S3020.authority_cd	=	@w_multireview_authority_cd
	AND S3020.del_datetime IS NULL
	-- COUNT ALL ORGANIZATIONS OF S3022 -- add by viettd 2021/06/03
	SET @w_mulitireview_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_multireview_authority_cd,3)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_multireview_authority_cd,3)
	-- get @w_other_browsing_kbn
	IF EXISTS (SELECT 1 FROM F3020 
						WHERE 
							F3020.company_cd			= @P_company_cd 
						AND F3020.fiscal_year			= @P_fiscal_year 
						AND F3020.supporter_cd			= @w_employee_cd 
						AND F3020.other_browsing_kbn	= 1 
						AND F3020.del_datetime IS NULL)
	BEGIN
		SET @w_other_browsing_kbn = 1 -- 1.他サポーター情報
	END
	--#TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC SPC_REFER_ORGANIZATION_FND1 @P_list_org,@P_user_id,@P_company_cd, 3
	--
	IF @P_position_cd > 0
	BEGIN
		INSERT INTO #LIST_POSITION
		SELECT @P_position_cd,0
	END
	-- GET #LIST_POSITION
	IF NOT EXISTS (SELECT 1 FROM #LIST_POSITION)
	BEGIN
		IF @use_typ = 1
		BEGIN
			INSERT INTO #LIST_POSITION
			SELECT 
				ISNULL(M0040.position_cd,0)				AS	position_cd
			,	1
			FROM M0040
			WHERE 
				M0040.company_cd		=	@P_company_cd
			AND M0040.arrange_order		>	@arrange_order		-- 1. 本人の役職より下位の社員のみ
			AND M0040.del_datetime IS NULL
		END
	END
	-- GET #TABLE_EMPLOYEE
	-- EMPLOYEE
	IF @P_mulitiselect_mode = 1 
	BEGIN
		-- 3.管理者 + 4.会社管理者 + 5.総合管理者
		IF @w_multireview_authority_typ IN (3,4,5)
		BEGIN
			INSERT INTO #TABLE_EMPLOYEE
			SELECT 
				M0070.company_cd
			,	@P_fiscal_year
			,	M0070.employee_cd
			FROM M0070
			WHERE 
				M0070.company_cd	=	@P_company_cd
			AND M0070.del_datetime IS NULL
			--
			GOTO CACULATE
		END
		-- 2.サポーター
		IF @w_multireview_authority_typ = 2 AND @w_user_is_rater_1 = 0 -- ONLY SUPPOTER
		BEGIN	
			-- check @P_fiscal_year_mulitireview < @w_fiscal_year_current
			-- when past
			IF @P_fiscal_year < @w_fiscal_year_current
			BEGIN
				INSERT INTO #TABLE_EMPLOYEE
				SELECT
					F3020.company_cd
				,	F3020.fiscal_year
				,	F3020.employee_cd
				FROM F3020
				WHERE 
					F3020.company_cd	=	@P_company_cd
				AND F3020.fiscal_year	=	@P_fiscal_year
				AND F3020.supporter_cd	=	@w_employee_cd
				AND F3020.del_datetime IS NULL
				-- GET MEMBER OF THIS CURRENT YEAR 
				INSERT INTO #TABLE_EMPLOYEE
				SELECT 
					F3020.company_cd
				,	F3020.fiscal_year
				,	F3020.employee_cd
				FROM F3020
				LEFT OUTER JOIN #TABLE_EMPLOYEE AS S ON(
					F3020.company_cd			=	S.company_cd
				AND F3020.fiscal_year			=	S.fiscal_year
				AND F3020.employee_cd			=	S.employee_cd
				)
				WHERE 
					F3020.company_cd	=	@P_company_cd
				AND F3020.fiscal_year	=	@w_fiscal_year_current -- THIS CURRENT YEAR
				AND F3020.supporter_cd	=	@w_employee_cd
				AND F3020.del_datetime IS NULL
				AND S.employee_cd IS NULL
				--
				GOTO CACULATE
			END
			-- check @P_fiscal_year_mulitireview >= @w_fiscal_year_current
			IF @P_fiscal_year >= @w_fiscal_year_current 
			BEGIN
				INSERT INTO #TABLE_EMPLOYEE
				SELECT
					F3020.company_cd
				,	F3020.fiscal_year
				,	F3020.employee_cd
				FROM F3020
				WHERE 
					F3020.company_cd	=	@P_company_cd
				AND F3020.fiscal_year	=	@P_fiscal_year
				AND F3020.supporter_cd	=	@w_employee_cd
				AND F3020.del_datetime IS NULL
				--
				GOTO CACULATE
			END
		END
		-- 人事評価システムの2.評価者
		IF @w_multireview_authority_typ = 2 AND @w_user_is_rater_1 = 1 -- ONLY SUPPOTER
		BEGIN
			INSERT INTO #TABLE_EMPLOYEE
			SELECT 
				DISTINCT
				F3001.company_cd
			,	@P_fiscal_year
			,	F3001.employee_cd
			FROM F3001
			WHERE 
				F3001.company_cd			=	@P_company_cd
			AND F3001.rater_employee_cd_1	=	@w_employee_cd
			AND F3001.del_datetime IS NULL
			--
			GOTO CACULATE
		END
	END
	-- SUPPOTER
	IF @P_mulitiselect_mode = 2
	BEGIN
		--3.管理者 + 4.会社管理者 + 5.総合管理者
		IF @w_multireview_authority_typ IN (3,4,5)
		BEGIN
			INSERT INTO #TABLE_EMPLOYEE
			SELECT 
				DISTINCT
				F3020.company_cd	AS	company_cd
			,	F3020.fiscal_year	AS	fiscal_year
			,	F3020.supporter_cd	AS	supporter_cd
			FROM F3020
			WHERE 
				F3020.company_cd	=	@P_company_cd
			AND F3020.fiscal_year	=	@P_fiscal_year
			AND F3020.del_datetime IS NULL
			--
			GOTO CACULATE
		END
		-- 2.サポーター
		IF @w_multireview_authority_typ = 2 AND @w_user_is_rater_1 = 0
		BEGIN
			-- CHECK  1.他サポーター情報
			IF @w_other_browsing_kbn = 1
			BEGIN
				INSERT INTO #TABLE_EMPLOYEE
				SELECT 
					DISTINCT
					F3020.company_cd	AS	company_cd
				,	F3020.fiscal_year	AS	fiscal_year
				,	F3020.supporter_cd	AS	supporter_cd
				FROM F3020
				WHERE 
					F3020.company_cd		=	@P_company_cd
				AND F3020.fiscal_year		=	@P_fiscal_year
				AND F3020.del_datetime IS NULL
				-- 
				GOTO CACULATE
			END
			-- DONT CHECK 1.他サポーター情報
			INSERT INTO #TABLE_EMPLOYEE
			SELECT 
				@P_company_cd
			,	@P_fiscal_year
			,	@w_employee_cd
			-- 
			GOTO CACULATE
		END
		-- 2.サポーター & RATER_1
		IF @w_multireview_authority_typ = 2 AND @w_user_is_rater_1 = 1 -- RATER_1
		BEGIN
			INSERT INTO #TABLE_EMPLOYEE
			SELECT 
				DISTINCT
				F3020.company_cd	AS	company_cd
			,	F3020.fiscal_year	AS	fiscal_year
			,	F3020.supporter_cd	AS	supporter_cd
			FROM F3020
			WHERE 
				F3020.company_cd		=	@P_company_cd
			AND F3020.fiscal_year		=	@P_fiscal_year
			AND F3020.del_datetime IS NULL
			-- 
			GOTO CACULATE
		END
	END
	-- RATER (評価者)
	IF @P_mulitiselect_mode = 3
	BEGIN
		IF @w_multireview_authority_typ >= 2
		BEGIN
			INSERT INTO #TABLE_EMPLOYEE
			SELECT 
				DISTINCT
				F0030.company_cd
			,	F0030.fiscal_year
			,	F0030.rater_employee_cd_1
			FROM F0030
			WHERE 
				F0030.company_cd		=	@P_company_cd
			AND F0030.fiscal_year		=	@P_fiscal_year
			AND F0030.del_datetime IS NULL
			-- 
			GOTO CACULATE
		END
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- GET ALL EMPLOYEE_CD
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
CACULATE:
	--
	INSERT INTO #EMPLOYEE
	SELECT 
		M0070.company_cd
	,	M0070.employee_cd
	,	SPACE(0)
	,CASE
		WHEN ISNULL(M0010.office_ab_nm,'') = '' THEN ISNULL(M0010.office_nm,'')	
		ELSE M0010.office_ab_nm
	END	
	,	M1.organization_cd_1
	,	M2.organization_cd_2
	,	M3.organization_cd_3
	,	M4.organization_cd_4
	,	M5.organization_cd_5
	,	M0030.job_cd
	,	M0040.position_cd
	,	M0070.employee_nm
	,	M0070.employee_typ
	,	M0070.belong_cd1
	,	M0070.belong_cd2
	,	M0070.belong_cd3
	,	M0070.belong_cd4
	,	M0070.belong_cd5
	,	M0070.grade
	,	M0070.office_cd
	,	M0060.employee_typ_nm
	,CASE
		WHEN ISNULL(M1.organization_ab_nm,'') = '' THEN ISNULL(M1.organization_nm,'')	
		ELSE M1.organization_ab_nm
	END																						AS belong_cd1_nm
	,CASE
		WHEN ISNULL(M2.organization_ab_nm,'') = '' THEN ISNULL(M2.organization_nm,'')		
		ELSE M2.organization_ab_nm
	END																						AS belong_cd2_nm
	,CASE
		WHEN ISNULL(M3.organization_ab_nm,'') = '' THEN ISNULL(M3.organization_nm,'')		
		ELSE M3.organization_ab_nm
	END																						AS belong_cd3_nm
	,CASE
		WHEN ISNULL(M4.organization_ab_nm,'') = '' THEN ISNULL(M4.organization_nm,'')		
		ELSE M4.organization_ab_nm
	END																						AS belong_cd4_nm
	,CASE
		WHEN ISNULL(M5.organization_ab_nm,'') = '' THEN ISNULL(M5.organization_nm,'')		
		ELSE M5.organization_ab_nm
	END																						AS belong_cd5_nm
	,CASE
		WHEN ISNULL(m0030.job_ab_nm,'') = '' THEN ISNULL(m0030.job_nm,'')		
		ELSE m0030.job_ab_nm
	END																						AS	job_nm
	,CASE
		WHEN ISNULL(M0040.position_ab_nm,'') = '' THEN ISNULL(M0040.position_nm,'')		
		ELSE M0040.position_ab_nm
	END	
	,	M0050.grade_nm
	,	CASE
			WHEN (M0070.company_out_dt IS NOT NULL AND (M0070.company_out_dt <  @w_time))
			THEN IIF(@w_language = 2, 'Retirement', '退職')	
			ELSE	''
		END	AS company_out_dt
	FROM #TABLE_EMPLOYEE
	INNER JOIN M0070 ON(
		#TABLE_EMPLOYEE.company_cd		=	M0070.company_cd
	AND #TABLE_EMPLOYEE.employee_cd		=	M0070.employee_cd
	)
	LEFT JOIN M0010 ON (
		M0070.company_cd	= M0010.company_cd
	AND M0070.office_cd		= M0010.office_cd
	)
	LEFT JOIN M0020 AS M1 ON (
		M1.company_cd			=	M0070.company_cd
	AND M1.organization_cd_1	=	M0070.belong_cd1
	AND M1.organization_typ		=	1
	) 
	LEFT JOIN M0020 AS M2 ON (
		M2.company_cd			=	M0070.company_cd
	AND M2.organization_cd_1		=	M0070.belong_cd1
	AND M2.organization_cd_2		=	M0070.belong_cd2
	AND M2.organization_typ		=	2
	) 
	LEFT JOIN M0020 AS M3 ON (
		M3.company_cd			=	M0070.company_cd
	AND M3.organization_cd_1		=	M0070.belong_cd1
	AND M3.organization_cd_2		=	M0070.belong_cd2
	AND M3.organization_cd_3		=	M0070.belong_cd3
	AND M3.organization_typ		=	3
	) 
	LEFT JOIN M0020 AS M4 ON (
		M4.company_cd			=	M0070.company_cd
	AND M4.organization_cd_1		=	M0070.belong_cd1
	AND M4.organization_cd_2		=	M0070.belong_cd2
	AND M4.organization_cd_3		=	M0070.belong_cd3
	AND M4.organization_cd_4		=	M0070.belong_cd4
	AND M4.organization_typ		=	4
	) 
	LEFT JOIN M0020 AS M5 ON (
		M5.company_cd			=	M0070.company_cd
	AND M5.organization_cd_1		=	M0070.belong_cd1
	AND M5.organization_cd_2		=	M0070.belong_cd2
	AND M5.organization_cd_3		=	M0070.belong_cd3
	AND M5.organization_cd_4		=	M0070.belong_cd4
	AND M5.organization_cd_5		=	M0070.belong_cd5
	AND M5.organization_typ		=	5
	) 
	LEFT JOIN M0030 ON (
		M0070.company_cd	= M0030.company_cd
	AND M0070.job_cd		= M0030.job_cd
	)
	LEFT JOIN M0040 ON (
		M0070.company_cd	= M0040.company_cd
	AND M0070.position_cd	= M0040.position_cd
	)
	LEFT JOIN M0050 ON (
		M0070.company_cd	= M0050.company_cd
	AND M0070.grade			= M0050.grade
	)
	LEFT JOIN M0060 ON (
		M0070.company_cd	= M0060.company_cd
	AND M0070.employee_typ	= M0060.employee_typ
	)
	WHERE 
		((@P_employee_cd				= '')
		OR	(dbo.FNC_COM_REPLACE_SPACE(M0070.employee_cd)		LIKE '%' +	dbo.FNC_COM_REPLACE_SPACE(@P_employee_cd) + '%'))
	AND	((@P_employee_ab_nm				= '')
		OR	(dbo.FNC_COM_REPLACE_SPACE(M0070.employee_nm)		LIKE '%' +	dbo.FNC_COM_REPLACE_SPACE(@P_employee_ab_nm) + '%')
		OR	(dbo.FNC_COM_REPLACE_SPACE(M0070.furigana)			LIKE '%' +	dbo.FNC_COM_REPLACE_SPACE(@P_employee_ab_nm) + '%')
		)
	AND ((@P_office_cd					= -1)
		OR	(M0070.office_cd			= @P_office_cd))
	AND ((@P_job_cd						= -1)
		OR	(M0070.job_cd				= @P_job_cd))
	AND M0070.company_cd				= @P_company_cd
	AND M0070.del_datetime IS NULL
	AND (
		(@P_company_out_dt_flg	=	1)
	OR	(@P_company_out_dt_flg	=	0	AND (M0070.company_out_dt IS  NULL OR M0070.company_out_dt >=  @w_time))
	)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- FILTER
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- #TABLE_ORGANIZATION
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
	BEGIN
		SET @choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
		-- 1.choice in screen
		IF @choice_in_screen = 1
		BEGIN
			DELETE D FROM #EMPLOYEE AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.company_cd			=	@P_company_cd
			AND D.belong_cd1			=	S.organization_cd_1
			AND D.belong_cd2			=	S.organization_cd_2
			AND D.belong_cd3			=	S.organization_cd_3
			AND D.belong_cd4			=	S.organization_cd_4
			AND D.belong_cd5			=	S.organization_cd_5
			)
			WHERE 
				D.company_cd IS NULL
			OR	S.organization_typ IS NULL
		END
		ELSE IF NOT (@w_multireview_authority_typ = 3 AND @w_mulitireview_organization_cnt = 0 AND @w_organization_belong_person_typ = 0) -- edited by viettd 2021/06/03
		BEGIN
			DELETE D FROM #EMPLOYEE AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.company_cd			=	@P_company_cd
			AND D.belong_cd1			=	S.organization_cd_1
			AND D.belong_cd2			=	S.organization_cd_2
			AND D.belong_cd3			=	S.organization_cd_3
			AND D.belong_cd4			=	S.organization_cd_4
			AND D.belong_cd5			=	S.organization_cd_5
			)
			WHERE 
				D.company_cd IS NULL
			OR	S.organization_typ IS NULL
			AND @w_multireview_authority_typ NOT IN(4,5) --4.会社管理者 5.総合管理者
		END
	END
	-- FILTER 役職
	IF EXISTS (SELECT 1 FROM #LIST_POSITION)
	BEGIN
		-- CHOICE IN SCREEN
		IF EXISTS (SELECT 1 FROM #LIST_POSITION WHERE mode = 0)
		BEGIN
			DELETE D FROM #EMPLOYEE AS D
			LEFT OUTER JOIN #LIST_POSITION AS S ON (
				D.company_cd		=	@P_company_cd
			AND D.position_cd		=	S.position_cd
			)
			WHERE
				S.position_cd IS NULL
		END
		ELSE
		-- FILTER MASTER
		BEGIN
			IF @w_multireview_authority_typ NOT IN (4,5)
			BEGIN
				DELETE D FROM #EMPLOYEE AS D
				LEFT OUTER JOIN #LIST_POSITION AS S ON (
					D.company_cd		=	@P_company_cd
				AND D.position_cd		=	S.position_cd
				)
				WHERE
					S.position_cd IS NULL
			END
		END
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--
	SET @totalRecord = (SELECT COUNT(1) FROM #EMPLOYEE)
	SET @pageMax = CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	IF @pageMax = 0
	BEGIN
		SET @pageMax = 1
	END
	IF @P_page > @pageMax
	BEGIN
		SET @P_page = @pageMax
	END	
	-- [0]
	SELECT 
		#EMPLOYEE.company_cd			
	,	ISNULL(#EMPLOYEE.employee_cd,'')		AS employee_cd			
	,	ISNULL(#EMPLOYEE.employee_ab_nm,'')		AS employee_ab_nm		
	,	ISNULL(#EMPLOYEE.office_nm,'')			AS office_nm		
	,	ISNULL(#EMPLOYEE.organization_cd1,0)	AS organization_cd1
	,	ISNULL(#EMPLOYEE.organization_cd2,0)	AS organization_cd2	
	,	ISNULL(#EMPLOYEE.organization_cd3,0)	AS organization_cd3
	,	ISNULL(#EMPLOYEE.organization_cd4,0)	AS organization_cd4	
	,	ISNULL(#EMPLOYEE.organization_cd5,0)	AS organization_cd5
	,	ISNULL(#EMPLOYEE.job_cd,0)				AS job_cd				
	,	ISNULL(#EMPLOYEE.position_cd,0)			AS position_cd			
	,	ISNULL(#EMPLOYEE.employee_nm,'')		AS employee_nm			
	,	ISNULL(#EMPLOYEE.employee_typ,0)		AS employee_typ	
	,	ISNULL(#EMPLOYEE.belong_cd1,'')			AS belong_cd1			
	,	ISNULL(#EMPLOYEE.belong_cd2,'')			AS belong_cd2
	,	ISNULL(#EMPLOYEE.belong_cd3,'')			AS belong_cd3			
	,	ISNULL(#EMPLOYEE.belong_cd4,'')			AS belong_cd4
	,	ISNULL(#EMPLOYEE.belong_cd5,'')			AS belong_cd5			
	,	ISNULL(#EMPLOYEE.job_cd,0)				AS job_cd 				
	,	ISNULL(#EMPLOYEE.position_cd,0)			AS position_cd		
	,	ISNULL(#EMPLOYEE.grade,0)				AS grade				
	,	ISNULL(#EMPLOYEE.office_cd,0)			AS office_cd			
	,	ISNULL(#EMPLOYEE.employee_typ_nm,'')	AS employee_typ_nm		
	,	ISNULL(#EMPLOYEE.organization_nm1,'')	AS organization_nm1	
	,	ISNULL(#EMPLOYEE.organization_nm2,'')	AS organization_nm2
	,	ISNULL(#EMPLOYEE.organization_nm3,'')	AS organization_nm3	
	,	ISNULL(#EMPLOYEE.organization_nm4,'')	AS organization_nm4
	,	ISNULL(#EMPLOYEE.organization_nm5,'')	AS organization_nm5	
	,	ISNULL(#EMPLOYEE.job_nm,'')				AS job_nm				
	,	ISNULL(#EMPLOYEE.position_nm,'')		AS position_nm			
	,	ISNULL(#EMPLOYEE.grade_nm,'')			AS grade_nm	
	,	ISNULL(#EMPLOYEE.company_out_dt,'')		AS company_out_dt		
	FROM #EMPLOYEE
	ORDER BY 
		CASE ISNUMERIC(#EMPLOYEE.employee_cd) 
		   WHEN 1 
		   THEN CAST(#EMPLOYEE.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	#EMPLOYEE.employee_cd
	offset (@P_page - 1) * @P_page_size rows
	fetch next @P_page_size rows only
	--[1]
	SELECT	
		@totalRecord	AS totalRecord
	,	@pageMax		AS pageMax
	,	@P_page			AS page
	,	@P_page_size	AS pagesize
	,	((@P_page - 1) * @P_page_size + 1) AS offset
	--CLEAN
	DROP TABLE #EMPLOYEE
	DROP TABLE #LIST_POSITION
	DROP TABLE #TABLE_EMPLOYEE
	DROP TABLE #TABLE_ORGANIZATION
END
GO