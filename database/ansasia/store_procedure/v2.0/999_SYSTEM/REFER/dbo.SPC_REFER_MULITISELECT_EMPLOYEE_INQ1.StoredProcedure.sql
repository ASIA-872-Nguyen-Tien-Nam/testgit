DROP PROCEDURE [SPC_REFER_MULITISELECT_EMPLOYEE_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- +--TEST--+
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	GET EMPLOYEE FOR MULITISELECT EMPLOYEE ITEM (module MULIREVIEW)
--*  
--* 作成日/create date			:	2021/01/20										
--*	作成者/creater				:	viettd				
--*   					
--*	更新日/update date			:  	2021/06/03
--*	更新者/updater				:　 	viettd　     	 
--*	更新内容/update content		:	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees	
--*   					
--*	更新日/update date			:	2021/06/16
--*	更新者/updater				:　 viettd　
--*	更新内容/update content		:	when rater_1 then can view & edited employees	
--*   					
--*  更新日/update date			:	2022/08/16
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	upgrade 1.9
--****************************************************************************************
CREATE PROCEDURE [SPC_REFER_MULITISELECT_EMPLOYEE_INQ1]
    @P_search_key			NVARCHAR(200)   =   ''
,	@P_company_cd			SMALLINT		=	0
,	@P_user_id				NVARCHAR(200)   =   ''
,	@P_fiscal_year			SMALLINT		=	0		-- 年度　add 2021/01/20
,	@P_mulitiselect_mode	SMALLINT		=	1		-- 1.社員名 2.サポーター 3.一次評価者 
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@arrange_order						INT					=	0
	,	@w_position_cd						INT					=	0
	,	@w_authority_typ					SMALLINT			=	0
	,	@w_employee_cd						NVARCHAR(10)		=	''
	,	@use_typ							INT					=	0
	,	@w_multireview_authority_cd			SMALLINT			=	0
	,	@w_multireview_authority_typ		SMALLINT			=	0
	,	@w_fiscal_year_current				smallint			=	dbo.FNC_GET_YEAR(@P_company_cd,NULL)
	,	@w_other_browsing_kbn				smallint			=	0	-- F3020.other_browsing_kbn = 1.他サポーター情報
	-- add by viettd 2021/06/03
	,	@w_mulitireview_organization_cnt	INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	,	@w_user_is_rater_1					TINYINT				=	0	-- 0.IS NOT RATER_1 | 1.IS RATER_1 -- add by viettd 2021/06/16
	,	@w_time								DATE				=	SYSDATETIME()
	-- CREATE TEMP TABLE
	CREATE TABLE #TABLE_ORGANIZATION(
		organization_typ			tinyint
	,	organization_cd_1			nvarchar(20)
	,	organization_cd_2			nvarchar(20)
	,	organization_cd_3			nvarchar(20)
	,	organization_cd_4			nvarchar(20)
	,	organization_cd_5			nvarchar(20)	 
	,	choice_in_screen			tinyint		-- 1.choice in screen 0.get from master S0022
	)
	--
	CREATE TABLE #TEMP_EMP(
		company_cd						SMALLINT
	,	employee_nm						NVARCHAR(101)
	,	employee_cd						NVARCHAR(40)
	,	label							NVARCHAR(200)
	,	belong_cd1						NVARCHAR(40)
	,	belong_cd2						NVARCHAR(40)
	,	belong_cd3						NVARCHAR(40)
	,	belong_cd4						NVARCHAR(40)
	,	belong_cd5						NVARCHAR(40)
	,	position_cd						INT
	)
	--
	CREATE TABLE #TABLE_EMPLOYEE(
		company_cd						SMALLINT
	,	fiscal_year						SMALLINT
	,	employee_cd						NVARCHAR(40)
	)
	--#LIST_POSITION
	CREATE TABLE #LIST_POSITION(
		id								int			identity(1,1)
	,	position_cd						int
	,	mode							smallint
	)
	-- GET VALUE
	SELECT 
		@w_authority_typ				=	ISNULL(S0010.authority_typ,0) 
	,	@w_position_cd					=	ISNULL(M0070.position_cd,0)
	,	@w_employee_cd					=	ISNULL(S0010.employee_cd,'')
	,	@w_multireview_authority_typ	=	ISNULL(S0010.multireview_authority_typ,0)
	,	@w_multireview_authority_cd		=	ISNULL(S0010.multireview_authority_cd,0)
	FROM S0010 
	LEFT JOIN M0070 ON (
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
	--
    SELECT 
		@arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@w_position_cd
	AND M0040.del_datetime IS NULL
	--
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
	--  INSERT INTO #LIST_POSITION
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
	-- INSERT INTO #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC SPC_REFER_ORGANIZATION_FND1 '',@P_user_id,@P_company_cd
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--INSERT DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
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
		IF @w_multireview_authority_typ = 2  AND @w_user_is_rater_1 = 0 -- ONLY SUPPOTER
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
		--管理者
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
		IF @w_multireview_authority_typ = 2 AND @w_user_is_rater_1 = 0 -- ONLY SUPPORTER
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
		IF @w_multireview_authority_typ IN(2,3,4,5)	OR @w_authority_typ = 2
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
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--CACULATE:
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
CACULATE:
	INSERT INTO #TEMP_EMP
	SELECT  
		M0070.company_cd							AS	company_cd
	,	M0070.employee_nm							AS	[value]
	,	M0070.employee_cd							AS	id
	,	M0070.employee_cd+': ' + M0070.employee_nm	AS	label
	,	M0070.belong_cd1
	,	M0070.belong_cd2
	,	M0070.belong_cd3
	,	M0070.belong_cd4
	,	M0070.belong_cd5
	,	M0070.position_cd
    FROM #TABLE_EMPLOYEE
	INNER JOIN M0070 ON(
		#TABLE_EMPLOYEE.company_cd		=	M0070.company_cd
	AND #TABLE_EMPLOYEE.employee_cd		=	M0070.employee_cd
	)
    WHERE 
	(
		M0070.employee_nm		LIKE '%'+@P_search_key+'%' 
	OR	M0070.furigana			LIKE '%'+@P_search_key+'%'
	OR	M0070.employee_cd		LIKE '%'+@P_search_key+'%'
	)
	AND	M0070.company_cd		=	@P_company_cd
	AND (M0070.company_out_dt IS  NULL OR M0070.company_out_dt >=  @w_time)
	AND M0070.del_datetime		IS NULL  --2020.05.14 add by Yamazaki
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--FILTER
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- filter #TABLE_ORGANIZATION
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION ) 
	BEGIN
		IF NOT (@w_multireview_authority_typ = 3 AND @w_mulitireview_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)  -- add by viettd 2021/06/03
		BEGIN
			--MULITIREVIEW
			DELETE D FROM #TEMP_EMP AS D
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
			DELETE D FROM #TEMP_EMP AS D
			LEFT OUTER JOIN #LIST_POSITION AS S ON (
				D.company_cd		=	@P_company_cd
			AND D.position_cd		=	S.position_cd
			)
			WHERE
				S.position_cd IS NULL
		END
		ELSE -- not choice in screen
		BEGIN
			IF @w_multireview_authority_typ NOT IN (4,5)
			BEGIN
				DELETE D FROM #TEMP_EMP AS D
				LEFT OUTER JOIN #LIST_POSITION AS S ON (
					D.company_cd		=	@P_company_cd
				AND D.position_cd		=	S.position_cd
				)
				WHERE
					S.position_cd IS NULL
			END
		END
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--[0]
	SELECT 
		employee_nm		AS value
	,	employee_cd		AS id
	,	label			
	FROM #TEMP_EMP
	ORDER BY 
		CASE ISNUMERIC(employee_cd) 
		   WHEN 1 
		   THEN CAST(employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	employee_cd
	-- DROP TABLE
	DROP TABLE #TABLE_ORGANIZATION
	DROP TABLE #TEMP_EMP
	DROP TABLE #LIST_POSITION
	DROP TABLE #TABLE_EMPLOYEE
END
GO
