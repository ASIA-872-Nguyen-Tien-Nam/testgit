IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_eQ0100_FND1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_eQ0100_FND1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- 

 --EXEC SPC_eQ0100_FND1 '{"items":[{"group_cd":"1","field_cd":"7","field_val":"0000000001","field_val_json":"","field_and_or":""}],"page_size":20,"page":1}','0','721','782','';

--****************************************************************************************
--*   											
--*  処理概要/process overview	:	社員情報検索 FOR eQ0100
--*  
--*  作成日/create date			:	2024/04/10					
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_eQ0100_FND1]
	@P_json					NVARCHAR(max)	=	''	-- json
,	@P_mode					SMALLINT		=	0   -- 0: page 1:all
,	@P_user_id				NVARCHAR(50)	=	''	-- LOGIN USER_ID
,	@P_company_cd			SMALLINT		=	0
,	@w_json_employee		NVARCHAR(max) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@w_today							date			= GETDATE()
	,	@ERR_TBL							ERRTABLE
	,	@w_login_position_cd				int				=	0
	,	@w_empinfo_authority_typ			smallint		=	0
	,	@w_empinfo_authority_cd				smallint		=	0
	,	@w_use_typ							smallint		=	0	
	,	@w_arrange_order					int				=	0
	,	@w_evaluation_organization_cnt		int				=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	smallint		=	0
	,	@w_choice_in_screen					tinyint			=	0
	--	SCREEN PARAMS
	,	@w_i								int				=	1
	,	@w_i_err_date_4						int				=	0
	,	@w_i_err_number_5					int				=	0
	,	@w_i_err_date_32					int				=	0
	,	@w_i_err_number_31					int				=	0
	,	@w_cnt								int				=	0
	,	@w_group_cd							smallint		=	0
	,	@w_group_cnt						smallint		=	0
	,	@w_group_index						int				=	0
	,	@w_group_total						int				=	0
	,	@w_field_cd							smallint		=	0
	,	@w_field_val						nvarchar(200)	=	''
	,	@w_field_val_json					nvarchar(max)	=	''
	,	@w_field_and_or						nvarchar(3)		=	''
	,	@w_date_from						NVARCHAR(10)	=	''
	,	@w_date_to							NVARCHAR(10)	=	''
	,	@w_number_from						INT				=	0
	,	@w_number_to						INT				=	0
	,	@w_organization_cd_1				NVARCHAR(20)	=	''
	,	@w_organization_cd_2				NVARCHAR(20)	=	''
	,	@w_organization_cd_3				NVARCHAR(20)	=	''
	,	@w_organization_cd_4				NVARCHAR(20)	=	''
	,	@w_organization_cd_5				NVARCHAR(20)	=	''
	--
	,	@totalRecord						bigint			=	0
	,	@pageMax							int				=	0	
	,	@page_size							int				=	50
	,	@page								int				=	0
	--
	,	@w_sql								nvarchar(max)	=	''
	,	@w_space_zero						nvarchar(10)	=	'0000000000'
	,	@w_loop_val							nvarchar(10)	=	''
	,	@w_loop_val_20						nvarchar(20)	=	''
	,	@w_loop_i							int				=	1
	,	@w_loop_cnt							int				=	0
	,	@w_fiscal_year_5_ago				int				=	dbo.FNC_GET_YEAR(@P_company_cd,NULL)
	,	@fiscal_year_max					INT				=  0
	,	@fiscal_year_min					INT				=  0
	,	@w_language							INT				=	1
	--#LIST_POSITION

	CREATE TABLE #LIST_POSITION(
		id								int			identity(1,1)
	,	position_cd						int
	,	mode							smallint	-- 0.choice in screen 1. get from master
	)
	--#TABLE_ORGANIZATION
	CREATE TABLE #TABLE_ORGANIZATION (
		organization_typ				tinyint
	,	organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)	
	,	choice_in_screen				tinyint		-- 1.choice in screen 0.get from master S0022
	)
	-- #TABLE_JSON_SCREEN
	CREATE TABLE #TABLE_JSON_SCREEN (
		id					int			identity(1,1)	
	,	group_cd			smallint
	,	field_cd			smallint
	,	field_val			nvarchar(200)
	,	field_val_json		nvarchar(max)
	,	field_and_or		nvarchar(3)
	)
	-- #TABLE_JSON
	CREATE TABLE #TABLE_JSON (
		id					int			identity(1,1)	
	,	group_cd			smallint
	,	field_cd			smallint
	,	field_val			nvarchar(200)
	,	field_val_json		nvarchar(max)
	,	field_and_or		nvarchar(3)
	,	group_index			int			
	,	group_total			int

	)
	-- 資格
	CREATE TABLE #TABLE_M0075 (
		id					int			identity(1,1)	
	,	company_cd			smallint
	,	employee_cd			nvarchar(10)
	,	qualification_cd	smallint
	)
	-- #M0070_SEARCH
	CREATE TABLE #M0070_SEARCH (
		id					int			identity(1,1)	
	,	company_cd			SMALLINT
	,	employee_cd			nvarchar(10)
	,	age					int
	)
	-- #TABLE_RESULT
	CREATE TABLE #TABLE_RESULT (
		id					int			identity(1,1)	
	,	employee_cd			nvarchar(10)
	)
	-- #TABLE_F0201
	CREATE TABLE #TABLE_F0201 (
		id					int			identity(1,1)		
	,	company_cd			smallint
	,	employee_cd			nvarchar(10)
	,	rank_cd				smallint
	,	treatment_applications_no				smallint
	)

	CREATE TABLE #TABLE_F0201_YEAR(
		company_cd						smallint
	,	fiscal_year						INT
	,	employee_cd						nvarchar(10)
	,	treatment_applications_no		SMALLINT
	)
	-- 最終学歴区分 #TABLE_M0078
	CREATE TABLE #TABLE_M0078 (
		id						int			identity(1,1)	
	,	company_cd				smallint
	,	employee_cd				nvarchar(10)
	,	final_education_kbn		smallint
	,	graduation_school_cd	nvarchar(20)
	,	school_name				nvarchar(50)
	,	graduation_school_other	nvarchar(50)
	,	faculty					nvarchar(50)
	)
	-- 契約更新回数 #TABLE_M0088
	CREATE TABLE #TABLE_M0088 (
		id						int			identity(1,1)	
	,	company_cd				smallint
	,	employee_cd				nvarchar(10)
	,	employment_contract_no	smallint
	,	detail_no				smallint
	,	expiration_date			date
	)
	-- 契約更新回数 #TABLE_M0088_CNT
	CREATE TABLE #TABLE_M0088_CNT (
		id								int			identity(1,1)	
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	employment_contract_no			smallint
	,	total							smallint
	)
	-- 賞罰種別 #TABLE_M0093
	CREATE TABLE #TABLE_M0093 (
		id						int			identity(1,1)	
	,	company_cd				smallint
	,	employee_cd				nvarchar(10)
	,	reward_punishment_typ	smallint
	)
	-- 研修コード #TABLE_M0076
	CREATE TABLE #TABLE_M0076 (
		id						int			identity(1,1)	
	,	company_cd				smallint
	,	employee_cd				nvarchar(10)
	,	training_cd				smallint
	)
	-- 業務経歴 #TABLE_M0077
	CREATE TABLE #TABLE_M0077 (
		id						int			identity(1,1)	
	,	company_cd				smallint
	,	employee_cd				nvarchar(10)
	,	text_item				nvarchar(150)
	,	item_title				nvarchar(50)
	)
	-- 組織 #TABLE_M0020
	CREATE TABLE #TABLE_M0020 (
		id						int		
	,	organization_cd_1		nvarchar(20)
	,	organization_cd_2		nvarchar(20)
	,	organization_cd_3		nvarchar(20)
	,	organization_cd_4		nvarchar(20)
	,	organization_cd_5		nvarchar(20)
	)
	--#M0070H
	CREATE TABLE #M0070H(
		application_date				date
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(200)
	,	employee_ab_nm					nvarchar(50)
	,	furigana						nvarchar(50)
	,	office_cd						smallint
	,	office_nm						nvarchar(50)
	,	belong_cd_1						nvarchar(20)
	,	belong_cd_2						nvarchar(20)
	,	belong_cd_3						nvarchar(20)
	,	belong_cd_4						nvarchar(20)
	,	belong_cd_5						nvarchar(20)
	,	job_cd							smallint
	,	position_cd						int
	,	employee_typ					smallint
	,	grade							smallint
	,	belong_nm_1						nvarchar(50)
	,	belong_nm_2						nvarchar(50)
	,	belong_nm_3						nvarchar(50)
	,	belong_nm_4						nvarchar(50)
	,	belong_nm_5						nvarchar(50)
	,	job_nm							nvarchar(50)
	,	position_nm						nvarchar(50)
	,	grade_nm						nvarchar(50)
	,	employee_typ_nm					nvarchar(50)
	)

	--組織 #TABLE_M0073
	CREATE TABLE #TABLE_M0073(
		company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	application_date				date
	)
	CREATE TABLE #TABLE_M0073_8(
		company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	application_date				date
	,	belong_cd1						nvarchar(20)
	,	belong_cd2						nvarchar(20)
	,	belong_cd3						nvarchar(20)
	,	belong_cd4						nvarchar(20)
	,	belong_cd5						nvarchar(20)
	)
	CREATE TABLE #TABLE_M0073_9(
		company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	application_date				date
	,	position_cd						int
	)
	--
	SELECT 
		@w_empinfo_authority_typ	=	ISNULL(S0010.empinfo_authority_typ,0)
	,	@w_empinfo_authority_cd		=	ISNULL(S0010.empinfo_authority_cd,0)
	,	@w_login_position_cd		=	ISNULL(M0070.position_cd,0)
	,	@w_language					=	ISNULL(S0010.language,1)
	FROM S0010
	LEFT OUTER JOIN M0070 ON (
		S0010.company_cd		=	M0070.company_cd
	AND S0010.employee_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	WHERE 
		S0010.company_cd	=	@P_company_cd
	AND S0010.user_id		=	@P_user_id
	AND S0010.del_datetime IS NULL
	-- get @w_use_typ
	SELECT 
		@w_use_typ		=	ISNULL(S5020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
	FROM S5020
	WHERE
		S5020.company_cd		=	@P_company_cd
	AND S5020.authority_cd		=	@w_empinfo_authority_cd
	AND S5020.del_datetime IS NULL
	-- get @arrange_order
	SELECT 
		@w_arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@w_login_position_cd
	AND M0040.del_datetime IS NULL
	-- GET PARAM FROM JSON
	SET @page_size			=	JSON_VALUE(@P_json,'$.page_size')
	SET @page				=	JSON_VALUE(@P_json,'$.page')
	--
	INSERT INTO #TABLE_JSON_SCREEN
	SELECT 
		group_cd
	,	field_cd
	,	field_val
	,	field_val_json
	,	field_and_or
	FROM OPENJSON(@P_json,'$.items') WITH(
		group_cd			smallint
	,	field_cd			smallint
	,	field_val			nvarchar(200)
	,	field_val_json		nvarchar(max) as json
	,	field_and_or		nvarchar(3)
	)
	--
	INSERT INTO #TABLE_JSON
	SELECT 
		#TABLE_JSON_SCREEN.group_cd		
	,	#TABLE_JSON_SCREEN.field_cd		
	,	#TABLE_JSON_SCREEN.field_val	
	,	#TABLE_JSON_SCREEN.field_val_json
	,	#TABLE_JSON_SCREEN.field_and_or	
	,	ROW_NUMBER() OVER(PARTITION BY #TABLE_JSON_SCREEN.group_cd ORDER BY #TABLE_JSON_SCREEN.id)			
	,	ISNULL(GROUP_TABLE.group_total,0)
	FROM #TABLE_JSON_SCREEN
	LEFT OUTER JOIN (
		SELECT 
			S.group_cd		AS	group_cd
		,	COUNT(S.id)		AS	group_total
		FROM #TABLE_JSON_SCREEN AS S
		GROUP BY
			S.group_cd
	) AS GROUP_TABLE ON (
		#TABLE_JSON_SCREEN.group_cd	=	GROUP_TABLE.group_cd
	)
	-- WHEN GROUP HAS ONE ITEM THEN UPDATE field_and_or = SPACE(0)
	UPDATE #TABLE_JSON SET 
		field_and_or = SPACE(0)
	FROM #TABLE_JSON
	WHERE 
		group_total = 1
	-- GET #M0070H
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @w_today,'',@P_company_cd

	-- COUNT ALL ORGANIZATIONS
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_empinfo_authority_cd,6)
	-- GET @w_organization_belong_person_typ
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_empinfo_authority_cd,6)
	-- INSERT DATA INTO #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 '',@P_user_id,@P_company_cd, 6
	-- INSERT DATA INTO #LIST_POSITION
	-- GET #LIST_POSITION
	IF NOT EXISTS (SELECT 1 FROM #LIST_POSITION)
	BEGIN
		-- 本人の役職より下位の社員のみ
		IF @w_use_typ = 1
		BEGIN
			INSERT INTO #LIST_POSITION
			SELECT 
				ISNULL(M0040.position_cd,0)				AS	position_cd
			,	1
			FROM M0040
			WHERE 
				M0040.company_cd		=	@P_company_cd
			AND M0040.arrange_order		>	@w_arrange_order		-- 1. 本人の役職より下位の社員のみ
			AND M0040.del_datetime IS NULL
		END
		ELSE
		BEGIN
			INSERT INTO #LIST_POSITION
			SELECT 
				ISNULL(M0040.position_cd,0)				AS	position_cd
			,	1
			FROM M0040
			WHERE 
				M0040.company_cd		=	@P_company_cd
			AND M0040.del_datetime IS NULL
		END
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--FILTER
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- FILTER BY #TABLE_ORGANIZATION
	-- FILTER 組織
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
	BEGIN
		SET @w_choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
		-- 1.choice in screen
		IF @w_choice_in_screen = 1
		BEGIN
			DELETE D FROM #M0070H AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.company_cd			=	@P_company_cd
			AND D.belong_cd_1			=	S.organization_cd_1
			AND D.belong_cd_2			=	S.organization_cd_2
			AND D.belong_cd_3			=	S.organization_cd_3
			AND D.belong_cd_4			=	S.organization_cd_4
			AND D.belong_cd_5			=	S.organization_cd_5
			)
			WHERE 
				D.company_cd IS NULL
			OR	S.organization_typ IS NULL
		END
		ELSE IF NOT (@w_empinfo_authority_typ = 3 AND @w_evaluation_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)
		BEGIN
			DELETE D FROM #M0070H AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.company_cd			=	@P_company_cd
			AND D.belong_cd_1			=	S.organization_cd_1
			AND D.belong_cd_2			=	S.organization_cd_2
			AND D.belong_cd_3			=	S.organization_cd_3
			AND D.belong_cd_4			=	S.organization_cd_4
			AND D.belong_cd_5			=	S.organization_cd_5
			)
			WHERE 
				D.company_cd IS NULL
			OR	S.organization_typ IS NULL
			AND @w_empinfo_authority_typ NOT IN(4,5)		--4.会社管理者 5.総合管理者
		END
	END
	-- FILTER 役職
	-- choice in screen
	IF EXISTS (SELECT 1 FROM #LIST_POSITION WHERE mode = 0)
	BEGIN
		DELETE D FROM #M0070H AS D
		LEFT OUTER JOIN #LIST_POSITION AS S ON (
			D.company_cd			=	@P_company_cd
		AND D.position_cd			=	S.position_cd
		)
		WHERE
			S.position_cd IS NULL
	END
	ELSE -- not choice in screen
	BEGIN
		IF @w_empinfo_authority_typ NOT IN (4,5)
		BEGIN
			DELETE D FROM #M0070H AS D
			LEFT OUTER JOIN #LIST_POSITION AS S ON (
				D.company_cd		=	@P_company_cd
			AND D.position_cd		=	S.position_cd
			)
			WHERE
				S.position_cd IS NULL
			AND (
				@w_use_typ = 1
			OR	@w_use_typ = 0 AND D.position_cd > 0
			)
		END
	END
	-- INSERT INTO #M0070_SEARCH
	INSERT INTO #M0070_SEARCH
	SELECT 
		@P_company_cd
	,	#M0070H.employee_cd
	,	[dbo].FNC_GET_BIRTHDAY_AGE(M0070.birth_date,NULL)
	FROM #M0070H
	LEFT OUTER JOIN M0070 ON (
		#M0070H.company_cd = M0070.company_cd
	AND #M0070H.employee_cd = M0070.employee_cd
	)

		-- INSERT #TABLE_M0073 (資格)
	IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd IN(8))
	BEGIN
		TRUNCATE TABLE #TABLE_M0073
		INSERT INTO #TABLE_M0073
		SELECT 
			ISNULL(M0073.company_cd,0)				AS	company_cd
		,	ISNULL(M0073.employee_cd,'')			AS	employee_cd
		,	MAX(M0073.application_date)				AS	application_date
		FROM M0073
		WHERE 
			M0073.company_cd			=	@P_company_cd
		AND M0073.application_date	<=	GETDATE()
		AND M0073.del_datetime IS NULL
		GROUP BY
			M0073.company_cd
		,	M0073.employee_cd

		
		INSERT INTO #TABLE_M0073_8
		SELECT 
			ISNULL(M0073.company_cd,0)				AS	company_cd
		,	ISNULL(M0073.employee_cd,'')			AS	employee_cd
		,	M0073.application_date					AS	application_date
		,	M0073.belong_cd1						AS	belong_cd1
		,	M0073.belong_cd2						AS	belong_cd2
		,	M0073.belong_cd3						AS	belong_cd3
		,	M0073.belong_cd4						AS	belong_cd4
		,	M0073.belong_cd5						AS	belong_cd5
		FROM M0073
		INNER JOIN #TABLE_M0073 ON (
			M0073.company_cd = #TABLE_M0073.company_cd
		AND M0073.employee_cd = #TABLE_M0073.employee_cd
		AND M0073.application_date = #TABLE_M0073.application_date
		)
		WHERE 
			M0073.company_cd	=	@P_company_cd
		AND M0073.del_datetime IS NULL

		INSERT INTO #TABLE_M0073_8
		SELECT 
			ISNULL(#M0070H.company_cd,0)			AS	company_cd
		,	ISNULL(#M0070H.employee_cd,'')			AS	employee_cd
		,	#M0070H.application_date				AS	application_date
		,	#M0070H.belong_cd_1						AS	belong_cd2
		,	#M0070H.belong_cd_2						AS	belong_cd2
		,	#M0070H.belong_cd_3						AS	belong_cd3
		,	#M0070H.belong_cd_4						AS	belong_cd4
		,	#M0070H.belong_cd_5						AS	belong_cd5
		FROM #M0070H
		
	END

	IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd IN(9))
	BEGIN
		TRUNCATE TABLE #TABLE_M0073
		INSERT INTO #TABLE_M0073
		SELECT 
			ISNULL(M0073.company_cd,0)				AS	company_cd
		,	ISNULL(M0073.employee_cd,'')			AS	employee_cd
		,	MAX(M0073.application_date)				AS	application_date
		FROM M0073
		WHERE 
			M0073.company_cd			=	@P_company_cd
		AND M0073.application_date	<=	GETDATE()
		AND M0073.del_datetime IS NULL
		GROUP BY
			M0073.company_cd
		,	M0073.employee_cd
		
		INSERT INTO #TABLE_M0073_9
		SELECT 
			ISNULL(M0073.company_cd,0)				AS	company_cd
		,	ISNULL(M0073.employee_cd,'')			AS	employee_cd
		,	M0073.application_date					AS	application_date
		,	M0073.position_cd						AS	position_cd
		FROM M0073
		INNER JOIN #TABLE_M0073 ON (
			M0073.company_cd = #TABLE_M0073.company_cd
		AND M0073.employee_cd = #TABLE_M0073.employee_cd
		AND M0073.application_date = #TABLE_M0073.application_date
		)
		WHERE 
			M0073.company_cd	=	@P_company_cd
		AND M0073.del_datetime IS NULL

		INSERT INTO #TABLE_M0073_9
		SELECT 
			ISNULL(#M0070H.company_cd,0)			AS	company_cd
		,	ISNULL(#M0070H.employee_cd,'')			AS	employee_cd
		,	#M0070H.application_date				AS	application_date
		,	#M0070H.position_cd						AS	position_cd
		FROM #M0070H
	END

	-- INSERT #TABLE_M0075 (資格)
	IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd = 21)
	BEGIN
		INSERT INTO #TABLE_M0075
		SELECT 
			M0075.company_cd
		,	M0075.employee_cd
		,	M0075.qualification_cd
		FROM M0075
		INNER JOIN #M0070_SEARCH ON (
			M0075.company_cd		=	#M0070_SEARCH.company_cd
		AND M0075.employee_cd		=	#M0070_SEARCH.employee_cd
		)
		WHERE 
			M0075.company_cd	=	@P_company_cd
		AND M0075.del_datetime IS NULL
	END
	-- #TABLE_F0201 (人事評価結果)
	IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd = 22)
	BEGIN
		INSERT INTO #TABLE_F0201_YEAR
		SELECT 
			F0201.company_cd
		,	F0201.fiscal_year
		,	F0201.employee_cd
		,	F0201.treatment_applications_no
		FROM F0201
		INNER JOIN #M0070_SEARCH ON (
			F0201.company_cd		=	#M0070_SEARCH.company_cd
		AND F0201.employee_cd		=	#M0070_SEARCH.employee_cd
		)
		WHERE 
			F0201.company_cd	=	@P_company_cd
		AND F0201.fiscal_year	<=	@w_fiscal_year_5_ago
		AND F0201.evaluatorFB_datetime IS NOT NULL
		AND F0201.del_datetime IS NULL
		GROUP BY
			F0201.company_cd
		,	F0201.employee_cd
		,	F0201.fiscal_year
		,	F0201.treatment_applications_no

		SET @fiscal_year_max = (Select Max(A.fiscal_year) FROM ((SELECT TOP 5 fiscal_year FROM #TABLE_F0201_YEAR GROUP BY fiscal_year ORDER BY fiscal_year DESC)) AS A)

		SET @fiscal_year_min = (Select Min(A.fiscal_year) FROM ((SELECT TOP 5 fiscal_year FROM #TABLE_F0201_YEAR GROUP BY fiscal_year ORDER BY fiscal_year DESC)) AS A)

		INSERT INTO #TABLE_F0201
		SELECT 
			F0201.company_cd
		,	F0201.employee_cd
		,	F0201.rank_cd
		,	F0201.treatment_applications_no
		FROM F0201
		INNER JOIN #M0070_SEARCH ON (
			F0201.company_cd		=	#M0070_SEARCH.company_cd
		AND F0201.employee_cd		=	#M0070_SEARCH.employee_cd
		)
		WHERE 
			F0201.company_cd	=	@P_company_cd
		AND F0201.fiscal_year <= @fiscal_year_max
		AND F0201.fiscal_year >= @fiscal_year_min
		AND F0201.evaluatorFB_datetime IS NOT NULL
		AND F0201.del_datetime IS NULL
		GROUP BY
			F0201.company_cd
		,	F0201.employee_cd
		,	F0201.rank_cd
		,	F0201.treatment_applications_no

	END
	-- #TABLE_M0078 最終学歴 + 学校名 + 学部名
	IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd IN(23,24,25))
	BEGIN
		INSERT INTO #TABLE_M0078
		SELECT 
			M0078.company_cd			
		,	M0078.employee_cd			
		,	M0078.final_education_kbn	
		,	M0078.graduation_school_cd
		,	L0013.school_name				
		,	M0078.graduation_school_other
		,	M0078.faculty				
		FROM M0078
		INNER JOIN #M0070_SEARCH ON (
			M0078.company_cd		=	#M0070_SEARCH.company_cd
		AND M0078.employee_cd		=	#M0070_SEARCH.employee_cd
		)
		LEFT JOIN L0013	ON (
			M0078.graduation_school_cd	=	l0013.school_code
		AND	L0013.del_datetime IS NULL
		)
		WHERE 
			M0078.company_cd	=	@P_company_cd
		AND M0078.del_datetime IS NULL

		INSERT INTO #TABLE_M0078
		SELECT 
			M0079.company_cd			
		,	M0079.employee_cd			
		,	0	
		,	M0079.graduation_school_cd
		,	L0013.school_name				
		,	M0079.graduation_school_other
		,	M0079.faculty				
		FROM M0079
		INNER JOIN #M0070_SEARCH ON (
			M0079.company_cd		=	#M0070_SEARCH.company_cd
		AND M0079.employee_cd		=	#M0070_SEARCH.employee_cd
		)
		LEFT JOIN L0013	ON (
			M0079.graduation_school_cd	=	l0013.school_code
		AND	L0013.del_datetime IS NULL
		)
		WHERE 
			M0079.company_cd	=	@P_company_cd
		AND M0079.del_datetime IS NULL
	END
	-- #TABLE_M0088_CNT 契約更新回数
	IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd = 31)
	BEGIN
		INSERT INTO #TABLE_M0088_CNT
		SELECT 
			M0088.company_cd					
		,	M0088.employee_cd					
		,	M0088.employment_contract_no		
		,	COUNT(M0088.detail_no)
		FROM M0088
		INNER JOIN #M0070_SEARCH ON (
			M0088.company_cd		=	#M0070_SEARCH.company_cd
		AND M0088.employee_cd		=	#M0070_SEARCH.employee_cd
		)
		WHERE 
			M0088.company_cd	=	@P_company_cd
		AND M0088.del_datetime IS NULL
		GROUP BY
			M0088.company_cd					
		,	M0088.employee_cd					
		,	M0088.employment_contract_no
	END
	-- #TABLE_M0088 雇用契約満了日
	IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd = 32)
	BEGIN
		INSERT INTO #TABLE_M0088
		SELECT 
			M0088.company_cd					
		,	M0088.employee_cd					
		,	M0088.employment_contract_no		
		,	M0088.detail_no		
		,	M0088.expiration_date		
		FROM M0088
		INNER JOIN #M0070_SEARCH ON (
			M0088.company_cd		=	#M0070_SEARCH.company_cd
		AND M0088.employee_cd		=	#M0070_SEARCH.employee_cd
		)
		WHERE 
			M0088.company_cd	=	@P_company_cd
		AND M0088.del_datetime IS NULL
	END
	-- 賞罰種別 #TABLE_M0093
	IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd = 33)
	BEGIN
		INSERT INTO #TABLE_M0093
		SELECT 
			M0093.company_cd
		,	M0093.employee_cd
		,	M0093.reward_punishment_typ
		FROM M0093
		INNER JOIN #M0070_SEARCH ON (
			M0093.company_cd		=	#M0070_SEARCH.company_cd
		AND M0093.employee_cd		=	#M0070_SEARCH.employee_cd
		)
		WHERE 
			M0093.company_cd	=	@P_company_cd
		AND M0093.del_datetime IS NULL
	END
	-- 賞罰種別 #TABLE_M0076
	IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd = 34)
	BEGIN
		INSERT INTO #TABLE_M0076
		SELECT 
			M0076.company_cd
		,	M0076.employee_cd
		,	M0076.training_cd
		FROM M0076
		INNER JOIN #M0070_SEARCH ON (
			M0076.company_cd		=	#M0070_SEARCH.company_cd
		AND M0076.employee_cd		=	#M0070_SEARCH.employee_cd
		)
		WHERE 
			M0076.company_cd	=	@P_company_cd
		AND M0076.del_datetime IS NULL
	END
	-- 業務経歴 #TABLE_M0077
	IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd = 35)
	BEGIN
		INSERT INTO #TABLE_M0077
		SELECT 
			M0077.company_cd					AS company_cd
		,	M0077.employee_cd					AS employee_cd
		,	M0077.text_item						AS text_item
		,	M5020.item_title					AS item_title
		FROM M0077
		INNER JOIN #M0070_SEARCH ON (
			M0077.company_cd		=	#M0070_SEARCH.company_cd
		AND M0077.employee_cd		=	#M0070_SEARCH.employee_cd
		)
		LEFT JOIN M5020 ON (
			M0077.company_cd = M5020.company_cd
		AND M0077.work_history_kbn = M5020.work_history_kbn
		AND M0077.item_id = M5020.item_id
		AND M5020.del_datetime IS NULL
		)
		INNER JOIN L0010 ON(
			M0077.item_id	=	L0010.number_cd
		AND	78				=	L0010.name_typ
		AND L0010.numeric_value1 IN (2,3,4)
		AND L0010.del_datetime IS NULL
		)
		WHERE
			M0077.company_cd		=	@P_company_cd
		AND	M0077.work_history_kbn	=	1
		AND M0077.del_datetime IS NULL
	END
	--
	IF NOT EXISTS (SELECT 1 FROM @ERR_TBL)
	BEGIN
	IF EXISTS(SELECT 1 FROM #TABLE_JSON)
	BEGIN
		-- SET @w_sql
		SET @w_sql = '
		INSERT INTO #TABLE_RESULT
		SELECT 
			#M0070_SEARCH.employee_cd
		FROM #M0070_SEARCH
		LEFT OUTER JOIN #M0070H ON (
			#M0070_SEARCH.company_cd = #M0070H.company_cd
		AND #M0070_SEARCH.employee_cd = #M0070H.employee_cd
		)
		LEFT OUTER JOIN M0070 ON (
			#M0070_SEARCH.company_cd = M0070.company_cd
		AND #M0070_SEARCH.employee_cd = M0070.employee_cd
		)
		LEFT OUTER JOIN M0074 ON (
			#M0070_SEARCH.company_cd = M0074.company_cd
		AND #M0070_SEARCH.employee_cd = M0074.employee_cd
		AND M0074.del_datetime IS NULL
		)
		LEFT OUTER JOIN M0083 ON (
			#M0070_SEARCH.company_cd = M0083.company_cd
		AND #M0070_SEARCH.employee_cd = M0083.employee_cd
		AND M0083.del_datetime IS NULL
		)
		LEFT OUTER JOIN M0085 ON (
			#M0070_SEARCH.company_cd = M0085.company_cd
		AND #M0070_SEARCH.employee_cd = M0085.employee_cd
		AND M0085.del_datetime IS NULL
		)
		'
		-- HAS M0075
		IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd = 21)
		BEGIN
			SET @w_sql = @w_sql + 'INNER JOIN #TABLE_M0075 ON (#M0070_SEARCH.company_cd = #TABLE_M0075.company_cd AND #M0070_SEARCH.employee_cd = #TABLE_M0075.employee_cd)' + SPACE(1)
		END
		-- HAS F0201
		IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd = 22)
		BEGIN
			SET @w_sql = @w_sql + 'INNER JOIN #TABLE_F0201 ON (#M0070_SEARCH.company_cd = #TABLE_F0201.company_cd AND #M0070_SEARCH.employee_cd = #TABLE_F0201.employee_cd)' + SPACE(1)
		END
		-- HAS F0201
		IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd IN(23,24,25))
		BEGIN
			SET @w_sql = @w_sql + 'INNER JOIN #TABLE_M0078 ON (#M0070_SEARCH.company_cd = #TABLE_M0078.company_cd AND #M0070_SEARCH.employee_cd = #TABLE_M0078.employee_cd)' + SPACE(1)
		END
		-- has M0088 cnt
		IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd = 31)
		BEGIN
			SET @w_sql = @w_sql + 'LEFT JOIN #TABLE_M0088_CNT ON (#M0070_SEARCH.company_cd = #TABLE_M0088_CNT.company_cd AND #M0070_SEARCH.employee_cd = #TABLE_M0088_CNT.employee_cd)' + SPACE(1)
		END
		-- has M0088
		IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd = 32)
		BEGIN
			SET @w_sql = @w_sql + 'LEFT JOIN #TABLE_M0088 ON (#M0070_SEARCH.company_cd = #TABLE_M0088.company_cd AND #M0070_SEARCH.employee_cd = #TABLE_M0088.employee_cd)' + SPACE(1)
		END
		-- has M0093
		IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd = 33)
		BEGIN
			SET @w_sql = @w_sql + 'INNER JOIN #TABLE_M0093 ON (#M0070_SEARCH.company_cd = #TABLE_M0093.company_cd AND #M0070_SEARCH.employee_cd = #TABLE_M0093.employee_cd)' + SPACE(1)
		END
		-- has M0073
		IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd IN(8))
		BEGIN
			SET @w_sql = @w_sql + 'INNER JOIN #TABLE_M0073_8 ON (#M0070_SEARCH.company_cd = #TABLE_M0073_8.company_cd AND #M0070_SEARCH.employee_cd = #TABLE_M0073_8.employee_cd)' + SPACE(1)
		END
		IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd IN(9))
		BEGIN
			SET @w_sql = @w_sql + 'INNER JOIN #TABLE_M0073_9 ON (#M0070_SEARCH.company_cd = #TABLE_M0073_9.company_cd AND #M0070_SEARCH.employee_cd = #TABLE_M0073_9.employee_cd)' + SPACE(1)
		END
		IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd = 34)
		BEGIN
			SET @w_sql = @w_sql + 'INNER JOIN #TABLE_M0076 ON (#M0070_SEARCH.company_cd = #TABLE_M0076.company_cd AND #M0070_SEARCH.employee_cd = #TABLE_M0076.employee_cd)' + SPACE(1)
		END
		IF EXISTS (SELECT 1 FROM #TABLE_JSON WHERE field_cd = 35)
		BEGIN
			SET @w_sql = @w_sql + 'INNER JOIN #TABLE_M0077 ON (#M0070_SEARCH.company_cd = #TABLE_M0077.company_cd AND #M0070_SEARCH.employee_cd = #TABLE_M0077.employee_cd)' + SPACE(1)
		END
		SET @w_sql = @w_sql + '
		WHERE 
			#M0070_SEARCH.company_cd = '+ CAST(@P_company_cd AS NVARCHAR(10)) + SPACE(1)
		--
		SET @w_group_cnt = (SELECT MAX(group_cd) FROM #TABLE_JSON)
		SET @w_cnt = (SELECT COUNT(1) FROM #TABLE_JSON)
		WHILE @w_i <= @w_cnt
		BEGIN
			-- GET @w_group_cd, @w_field_cd, @w_field_val, @w_field_and_or
			SELECT 
				@w_group_cd			=	#TABLE_JSON.group_cd
			,	@w_field_cd			=	#TABLE_JSON.field_cd
			,	@w_field_val		=	#TABLE_JSON.field_val
			,	@w_field_val_json	=	#TABLE_JSON.field_val_json
			,	@w_field_and_or		=	#TABLE_JSON.field_and_or
			,	@w_group_index		=	#TABLE_JSON.group_index
			,	@w_group_total		=	#TABLE_JSON.group_total
			FROM #TABLE_JSON
			WHERE 
				#TABLE_JSON.id = @w_i
			--■ START GROUP
			IF @w_group_index = 1
			BEGIN
				SET @w_sql = @w_sql + 'AND('
			END
			-- 1.社員番号
			IF @w_field_cd = 1
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					SET @w_sql = @w_sql + '#M0070H.employee_cd LIKE N''%'+@w_field_val+'%'''
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 2.氏名
			IF @w_field_cd = 2
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					SET @w_sql = @w_sql + '#M0070H.employee_nm LIKE N''%'+@w_field_val+'%'''
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 3.フリガナ
			IF @w_field_cd = 3
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					SET @w_sql = @w_sql + '#M0070H.furigana LIKE N''%'+@w_field_val+'%'''
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 4.入社日
			IF @w_field_cd = 4
			BEGIN
				SET @w_i_err_date_4 = @w_i_err_date_4 + 1
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_date_from = SPACE(0)
					SET @w_date_to = SPACE(0)
					SET @w_sql = @w_sql + @w_field_and_or + '('
					-- CHECK DATE ITEM
					IF ISDATE(SUBSTRING(@w_field_val,1,10)) = 1
					BEGIN
						SET @w_date_from = SUBSTRING(@w_field_val,1,10)
					END
					IF ISDATE(SUBSTRING(@w_field_val,11,10)) = 1
					BEGIN
						SET @w_date_to = SUBSTRING(@w_field_val,11,10)
					END

					IF  @w_date_from <> SPACE(0) AND @w_date_to <> SPACE(0) AND @w_date_from > @w_date_to
					BEGIN
					INSERT INTO @ERR_TBL
					SELECT
						24
					,	N'.date_from_4' 
					,	0-- oderby
					,	0-- dialog  
					,	@w_i_err_date_4
					,	0
					,	N'error date_from'

					INSERT INTO @ERR_TBL
					SELECT
						24
					,	N'.date_to_4' 
					,	0-- oderby
					,	0-- dialog  
					,	@w_i_err_date_4
					,	0
					,	N'error date_to'
					END

					-- HAS FROM~TO
					IF @w_date_from <> SPACE(0) AND @w_date_to <> SPACE(0)
					BEGIN
						SET @w_sql = @w_sql + 'M0070.company_in_dt >=　'''+ @w_date_from + '''　AND M0070.company_in_dt <= '''+@w_date_to+''''
					END
					ELSE IF @w_date_from <> SPACE(0) AND @w_date_to = SPACE(0)
					BEGIN
						SET @w_sql = @w_sql + 'M0070.company_in_dt >= '''+ @w_date_from+''''
					END
					ELSE IF @w_date_from = SPACE(0) AND @w_date_to <> SPACE(0)
					BEGIN
						SET @w_sql = @w_sql　+ 'M0070.company_in_dt <= '''+ @w_date_to+''''
					END
					ELSE
					BEGIN
						SET @w_sql = @w_sql　+ 'M0070.company_in_dt >= '''+ @w_date_to+''' OR M0070.company_in_dt IS NULL'
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 5.年齢
			IF @w_field_cd = 5
			BEGIN
				SET @w_i_err_number_5 = @w_i_err_number_5 + 1
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_number_from = CAST(SUBSTRING(@w_field_val,1,10) AS int)
					SET @w_number_to = CAST(SUBSTRING(@w_field_val,11,10) AS int)
					--
					IF @w_number_from <> @w_space_zero AND @w_number_to <> @w_space_zero AND @w_number_from > @w_number_to
					BEGIN
					INSERT INTO @ERR_TBL
					SELECT
						166
					,	N'.numeric_from_5' 
					,	0-- oderby
					,	0-- dialog  
					,	@w_i_err_number_5
					,	0
					,	N'error numeric_from_5'

					INSERT INTO @ERR_TBL
					SELECT
						166
					,	N'.numeric_to_5' 
					,	0-- oderby
					,	0-- dialog  
					,	@w_i_err_number_5
					,	0
					,	N'error numeric_to_5'
					END

					IF @w_number_from <> @w_space_zero AND @w_number_to <> @w_space_zero
					BEGIN
						SET @w_sql = @w_sql + '#M0070_SEARCH.age >= '+CONVERT(NVARCHAR(10),@w_number_from)+' AND #M0070_SEARCH.age <= '+ CONVERT(NVARCHAR(10),@w_number_to)
					END
					IF @w_number_from = @w_space_zero AND @w_number_to <> @w_space_zero
					BEGIN
						SET @w_sql = @w_sql + '#M0070_SEARCH.age <= '+ CONVERT(NVARCHAR(10),@w_number_to)
					END
					IF @w_number_from <> @w_space_zero AND @w_number_to = @w_space_zero
					BEGIN
						SET @w_sql = @w_sql + '#M0070_SEARCH.age >= '+ CONVERT(NVARCHAR(10),@w_number_from)
					END
					IF @w_number_from = @w_space_zero AND @w_number_to = @w_space_zero
					BEGIN
						SET @w_sql = @w_sql + '#M0070_SEARCH.age >= '+ CONVERT(NVARCHAR(10),@w_number_from) + ' OR #M0070_SEARCH.age IS NULL'
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 6.性別
			IF @w_field_cd = 6
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(M0070.gender = '+@w_loop_val+')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (M0070.gender = '+@w_loop_val+')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END

			-- 7.退職
			IF @w_field_cd = 7
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							IF CAST(@w_loop_val AS INT) = 1
							BEGIN
								SET @w_sql = @w_sql + ' M0070.company_out_dt <'''+ CONVERT(NVARCHAR(10), GETDATE(), 120) +''''
							END
							ELSE
							BEGIN
								SET @w_sql = @w_sql + ' M0070.company_out_dt IS NULL OR M0070.company_out_dt >='''+ CONVERT(NVARCHAR(10), GETDATE(), 120) +''''
							END
						END
						ELSE
						BEGIN
							IF CAST(@w_loop_val AS INT) = 1
							BEGIN
								SET @w_sql = @w_sql + ' OR M0070.company_out_dt <'''+ CONVERT(NVARCHAR(10), GETDATE(), 120) +''''
							END
							ELSE
							BEGIN
								SET @w_sql = @w_sql + ' OR M0070.company_out_dt IS NULL OR M0070.company_out_dt >='''+ CONVERT(NVARCHAR(10), GETDATE(), 120) +''''
							END
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 8.組織
			IF @w_field_cd = 8
			BEGIN
				IF ISJSON(@w_field_val_json) = 1
				BEGIN
					DELETE D FROM #TABLE_M0020 AS D
					INSERT INTO #TABLE_M0020
					SELECT 
						ROW_NUMBER() OVER(ORDER BY organization_cd_1,organization_cd_2,organization_cd_3,organization_cd_4,organization_cd_5)
					,	json_table.organization_cd_1
					,	json_table.organization_cd_2
					,	json_table.organization_cd_3
					,	json_table.organization_cd_4
					,	json_table.organization_cd_5
					FROM OPENJSON(@w_field_val_json,'$') WITH(
						organization_cd_1		nvarchar(20)
					,	organization_cd_2		nvarchar(20)
					,	organization_cd_3		nvarchar(20)
					,	organization_cd_4		nvarchar(20)
					,	organization_cd_5		nvarchar(20)
					)AS json_table
					--
					IF EXISTS (SELECT 1 FROM #TABLE_M0020)
					BEGIN
						SET @w_sql = @w_sql + @w_field_and_or + '('
						--
						SET @w_loop_i = 1
						SET @w_loop_cnt = (SELECT COUNT(1) FROM #TABLE_M0020)
						WHILE @w_loop_i <= @w_loop_cnt
						BEGIN
							SELECT 
								@w_organization_cd_1 = #TABLE_M0020.organization_cd_1
							,	@w_organization_cd_2 = #TABLE_M0020.organization_cd_2
							,	@w_organization_cd_3 = #TABLE_M0020.organization_cd_3
							,	@w_organization_cd_4 = #TABLE_M0020.organization_cd_4
							,	@w_organization_cd_5 = #TABLE_M0020.organization_cd_5
							FROM #TABLE_M0020
							WHERE 
								#TABLE_M0020.id = @w_loop_i
							-- 
							IF @w_loop_i = 1
							BEGIN
								IF @w_organization_cd_1 <> SPACE(0)
								BEGIN
									SET @w_sql = @w_sql + '(#TABLE_M0073_8.belong_cd1 = '''+@w_organization_cd_1+''''
								END
								IF @w_organization_cd_2 <> SPACE(0)
								BEGIN
									SET @w_sql = @w_sql + ' AND #TABLE_M0073_8.belong_cd2 ='''+@w_organization_cd_2 +''''
								END
								IF @w_organization_cd_3 <> SPACE(0)
								BEGIN
									SET @w_sql = @w_sql + ' AND #TABLE_M0073_8.belong_cd3 ='''+@w_organization_cd_3 +''''
								END
								IF @w_organization_cd_4 <> SPACE(0)
								BEGIN
									SET @w_sql = @w_sql + ' AND #TABLE_M0073_8.belong_cd4 ='''+@w_organization_cd_4 +''''
								END
								IF @w_organization_cd_5 <> SPACE(0)
								BEGIN
									SET @w_sql = @w_sql + ' AND #TABLE_M0073_8.belong_cd5 ='''+@w_organization_cd_5 +''''
								END
								SET @w_sql = @w_sql + ')'
							END
							ELSE
							BEGIN
								IF @w_organization_cd_1 <> SPACE(0)
								BEGIN
									SET @w_sql = @w_sql + 'OR (#TABLE_M0073_8.belong_cd1 = '''+@w_organization_cd_1+''''
								END
								IF @w_organization_cd_2 <> SPACE(0)
								BEGIN
									SET @w_sql = @w_sql + ' AND #TABLE_M0073_8.belong_cd2 ='''+@w_organization_cd_2 +''''
								END
								IF @w_organization_cd_3 <> SPACE(0)
								BEGIN
									SET @w_sql = @w_sql + ' AND #TABLE_M0073_8.belong_cd3 ='''+@w_organization_cd_3 +''''
								END
								IF @w_organization_cd_4 <> SPACE(0)
								BEGIN
									SET @w_sql = @w_sql + ' AND #TABLE_M0073_8.belong_cd4 ='''+@w_organization_cd_4 +''''
								END
								IF @w_organization_cd_5 <> SPACE(0)
								BEGIN
									SET @w_sql = @w_sql + ' AND #TABLE_M0073_8.belong_cd5 ='''+@w_organization_cd_5 +''''
								END
								SET @w_sql = @w_sql + ')'
							END
							--
							SET @w_loop_i = @w_loop_i + 1
						END
						--
						SET @w_sql = @w_sql + ')' + SPACE(1)
					END
				END
			END
			-- 9.役職
			IF @w_field_cd = 9
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(#TABLE_M0073_9.position_cd = '+@w_loop_val+')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (#TABLE_M0073_9.position_cd = '+@w_loop_val+')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 10.職種
			IF @w_field_cd = 10
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(#M0070H.job_cd = '+@w_loop_val+')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (#M0070H.job_cd = '+@w_loop_val+')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 11.事業所
			IF @w_field_cd = 11
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(#M0070H.office_cd = '+@w_loop_val+')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (#M0070H.office_cd = '+@w_loop_val+')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 12.社員区分
			IF @w_field_cd = 12
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(#M0070H.employee_typ = '+@w_loop_val+')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (#M0070H.employee_typ = '+@w_loop_val+')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)	
				END
			END
			-- 13.等級
			IF @w_field_cd = 13
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(#M0070H.grade = '+@w_loop_val+')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (#M0070H.grade = '+@w_loop_val+')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 14.本拠地（都道府県）
			IF @w_field_cd = 14
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(M0074.headquarters_prefectures = '+@w_loop_val+')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (M0074.headquarters_prefectures = '+@w_loop_val+')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 15.本拠地（その他）
			IF @w_field_cd = 15
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					SET @w_sql = @w_sql + @w_field_and_or + 'M0074.headquarters_other LIKE N''%'+@w_field_val+'%'''
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 16.転勤可否
			IF @w_field_cd = 16
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(M0074.possibility_transfer = '+@w_loop_val+')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (M0074.possibility_transfer = '+@w_loop_val+')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 17.国籍
			IF @w_field_cd = 17
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(M0074.nationality = '''+SUBSTRING(@w_loop_val,8,3)+''')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (M0074.nationality = '''+SUBSTRING(@w_loop_val,8,3)+''')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 18.障害手帳区分
			IF @w_field_cd = 18
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(M0074.disability_classification = '+@w_loop_val+')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (M0074.disability_classification = '+@w_loop_val+')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 19.MARCO POLO ベーススタイル
			IF @w_field_cd = 19
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(M0074.base_style = '+@w_loop_val+')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (M0074.base_style = '+@w_loop_val+')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 20.MARCO POLO サブスタイル
			IF @w_field_cd = 20
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(M0074.sub_style = '+@w_loop_val+')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (M0074.sub_style = '+@w_loop_val+')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 21.資格
			IF @w_field_cd = 21
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(#TABLE_M0075.qualification_cd = '+@w_loop_val+')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql + 'OR (#TABLE_M0075.qualification_cd = '+@w_loop_val+')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 22.人事評価結果
			IF @w_field_cd = 22
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(#TABLE_F0201.rank_cd = ' +SUBSTRING(@w_loop_val,1,CHARINDEX('_', @w_loop_val) - 1)+ ' AND #TABLE_F0201.treatment_applications_no = ' +SUBSTRING(@w_loop_val,CHARINDEX('_', @w_loop_val) + 1,10) + ')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (#TABLE_F0201.rank_cd = '+SUBSTRING(@w_loop_val,1,CHARINDEX('_', @w_loop_val) - 1)+ ' AND #TABLE_F0201.treatment_applications_no = ' +SUBSTRING(@w_loop_val,CHARINDEX('_', @w_loop_val) + 1,10) + ')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 23.最終学歴
			IF @w_field_cd = 23
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(#TABLE_M0078.final_education_kbn = '+@w_loop_val+')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (#TABLE_M0078.final_education_kbn = '+@w_loop_val+')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 24.学校名
			--IF @w_field_cd = 24
			--BEGIN
			--	IF @w_field_val <> SPACE(0)
			--	BEGIN
			--		SET @w_sql = @w_sql + @w_field_and_or + '('
			--		--
			--		SET @w_loop_i = 0
			--		WHILE (@w_loop_i * 20) < LEN(@w_field_val)
			--		BEGIN
			--			SET @w_loop_val_20 = SUBSTRING(@w_field_val,@w_loop_i * 20 + 1,20)
			--			-- first item
			--			IF (@w_loop_i = 0)
			--			BEGIN
			--				SET @w_sql = @w_sql + '(#TABLE_M0078.gschool_cd = '''+REPLACE(LTRIM(REPLACE(@w_loop_val_20, '0', ' ')),' ', '0')+''')'
			--			END
			--			ELSE
			--			BEGIN
			--				SET @w_sql = @w_sql+ 'OR (#TABLE_M0078.graduation_school_cd = '''+REPLACE(LTRIM(REPLACE(@w_loop_val_20, '0', ' ')),' ', '0')+''')'
			--			END
			--			--
			--			SET @w_loop_i = @w_loop_i + 1
			--		END
			--		--
			--		SET @w_sql = @w_sql + ')' + SPACE(1)
			--	END
			--END
			IF @w_field_cd = 24
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					SET @w_sql = @w_sql + '#TABLE_M0078.school_name LIKE N''%'+@w_field_val+'%'' OR #TABLE_M0078.graduation_school_other LIKE N''%' + +@w_field_val+'%'''
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END

			-- 25.学部名
			IF @w_field_cd = 25
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					SET @w_sql = @w_sql + '#TABLE_M0078.faculty LIKE N''%'+@w_field_val+'%'''
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 26.持家区分
			IF @w_field_cd = 26
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(M0083.owning_house_kbn = '+@w_loop_val+')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (M0083.owning_house_kbn = '+@w_loop_val+')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 27.世帯主
			IF @w_field_cd = 27
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = CAST(SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10) AS INT) 
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							IF @w_loop_val = 2
							BEGIN
								SET @w_sql = @w_sql + '(M0083.head_household = 0)'
							END
							ELSE
							BEGIN
								SET @w_sql = @w_sql + '(M0083.head_household = '+@w_loop_val+')'
							END
						END
						ELSE
						BEGIN
							IF @w_loop_val = 2
							BEGIN
								SET @w_sql = @w_sql + 'OR (M0083.head_household = 0)'
							END
							ELSE
							BEGIN
								SET @w_sql = @w_sql + 'OR (M0083.head_household = '+@w_loop_val+')'
							END
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 28.住所１
			IF @w_field_cd = 28
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					SET @w_sql = @w_sql + 'M0083.address1 LIKE N''%'+@w_field_val+'%'''
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 29.住所２
			IF @w_field_cd = 29
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					SET @w_sql = @w_sql + 'M0083.address2 LIKE N''%'+@w_field_val+'%'''
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 30.配偶者の有無
			IF @w_field_cd = 30
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(M0085.marital_status = '+@w_loop_val+')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (M0085.marital_status = '+@w_loop_val+')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 31.契約更新回数
			IF @w_field_cd = 31
			BEGIN
				SET @w_i_err_number_31 = @w_i_err_number_31 + 1
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_number_from = CAST(SUBSTRING(@w_field_val,1,10) AS INT)
					SET @w_number_to = CAST(SUBSTRING(@w_field_val,11,10) AS INT)
					--
					IF @w_number_from <> @w_space_zero AND @w_number_to <> @w_space_zero AND @w_number_from > @w_number_to
					BEGIN
					INSERT INTO @ERR_TBL
					SELECT
						166
					,	N'.numeric_from_31' 
					,	0-- oderby
					,	0-- dialog  
					,	@w_i_err_number_31
					,	0
					,	N'error numeric_from_31'

					INSERT INTO @ERR_TBL
					SELECT
						166
					,	N'.numeric_to_31' 
					,	0-- oderby
					,	0-- dialog  
					,	@w_i_err_number_31
					,	0
					,	N'error numeric_to_31'
					END

					IF @w_number_from <> @w_space_zero AND @w_number_to <> @w_space_zero
					BEGIN
						SET @w_sql = @w_sql + '#TABLE_M0088_CNT.total >= '+ CONVERT(NVARCHAR(10),@w_number_from)+' AND #TABLE_M0088_CNT.total <= '+ CONVERT(NVARCHAR(10),@w_number_to)
					END
					IF @w_number_from = @w_space_zero AND @w_number_to <> @w_space_zero
					BEGIN
						SET @w_sql = @w_sql + '#TABLE_M0088_CNT.total <= '+ CONVERT(NVARCHAR(10),@w_number_to)
					END
					IF @w_number_from <> @w_space_zero AND @w_number_to = @w_space_zero
					BEGIN
						SET @w_sql = @w_sql + '#TABLE_M0088_CNT.total >= '+ CONVERT(NVARCHAR(10),@w_number_from)
					END
					IF @w_number_from = @w_space_zero AND @w_number_to = @w_space_zero
					BEGIN
						SET @w_sql = @w_sql + '#TABLE_M0088_CNT.total >= '+ CONVERT(NVARCHAR(10),@w_number_from) +' OR #TABLE_M0088_CNT.total IS NULL'
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 32.雇用契約満了日
			IF @w_field_cd = 32
			BEGIN
				SET @w_i_err_date_32 = @w_i_err_date_32 + 1
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_date_from = SPACE(0)
					SET @w_date_to = SPACE(0)
					SET @w_sql = @w_sql + @w_field_and_or + '('
					-- CHECK DATE ITEM
					IF ISDATE(SUBSTRING(@w_field_val,1,10)) = 1
					BEGIN
						SET @w_date_from = SUBSTRING(@w_field_val,1,10)
					END
					IF ISDATE(SUBSTRING(@w_field_val,11,10)) = 1
					BEGIN
						SET @w_date_to = SUBSTRING(@w_field_val,11,10)
					END
					IF  @w_date_from <> SPACE(0) AND @w_date_to <> SPACE(0) AND @w_date_from > @w_date_to
					BEGIN
					INSERT INTO @ERR_TBL
					SELECT
						24
					,	N'.date_from_32' 
					,	0-- oderby
					,	0-- dialog  
					,	@w_i_err_date_32
					,	0
					,	N'error date_from'

					INSERT INTO @ERR_TBL
					SELECT
						24
					,	N'.date_to_32' 
					,	0-- oderby
					,	0-- dialog  
					,	@w_i_err_date_32
					,	0
					,	N'error date_to'
					END

					-- HAS FROM~TO
					IF @w_date_from <> SPACE(0) AND @w_date_to <> SPACE(0)
					BEGIN
						SET @w_sql = @w_sql + '#TABLE_M0088.expiration_date >= '''+ @w_date_from + ''' AND #TABLE_M0088.expiration_date <= '''+@w_date_to + ''''
					END
					ELSE IF @w_date_from <> SPACE(0) AND @w_date_to = SPACE(0)
					BEGIN
						SET @w_sql = @w_sql + '#TABLE_M0088.expiration_date >= '''+ @w_date_from + ''''
					END
					ELSE IF @w_date_from = SPACE(0) AND @w_date_to <> SPACE(0)
					BEGIN
						SET @w_sql = @w_sql + '#TABLE_M0088.expiration_date <= '''+ @w_date_to + ''''
					END
					ELSE
					BEGIN
						SET @w_sql = @w_sql　+ '#TABLE_M0088.expiration_date >= '''+ @w_date_to+''' OR #TABLE_M0088.expiration_date IS NULL'
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 33.賞罰種別
			IF @w_field_cd = 33
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(#TABLE_M0093.reward_punishment_typ = '+@w_loop_val+')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (#TABLE_M0093.reward_punishment_typ = '+@w_loop_val+')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 34.研修コード
			IF @w_field_cd = 34
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					--
					SET @w_loop_i = 0
					WHILE (@w_loop_i * 10) < LEN(@w_field_val)
					BEGIN
						SET @w_loop_val = SUBSTRING(@w_field_val,@w_loop_i * 10 + 1,10)
						-- first item
						IF (@w_loop_i = 0)
						BEGIN
							SET @w_sql = @w_sql + '(#TABLE_M0076.training_cd = '+@w_loop_val+')'
						END
						ELSE
						BEGIN
							SET @w_sql = @w_sql+ 'OR (#TABLE_M0076.training_cd = '+@w_loop_val+')'
						END
						--
						SET @w_loop_i = @w_loop_i + 1
					END
					--
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			-- 35.業務経歴
			IF @w_field_cd = 35
			BEGIN
				IF @w_field_val <> SPACE(0)
				BEGIN
					SET @w_sql = @w_sql + @w_field_and_or + '('
					SET @w_sql = @w_sql + '#TABLE_M0077.text_item LIKE N''%'+@w_field_val+'%'''
					SET @w_sql = @w_sql + 'OR #TABLE_M0077.item_title LIKE N''%'+@w_field_val+'%'''
					SET @w_sql = @w_sql + ')' + SPACE(1)
				END
			END
			--■ CLOSE GROUP
			IF @w_group_index = @w_group_total
			BEGIN
				SET @w_sql = @w_sql + ')' 
			END
			-- LOOP @w_i
			SET @w_i = @w_i + 1
		END
		-- group by
		SET @w_sql = @w_sql + ' GROUP BY #M0070_SEARCH.employee_cd'
		-- EXEC
		--PRINT(@w_sql)
		--return

		EXEC(@w_sql)
	END
	ELSE
	BEGIN
		INSERT INTO #TABLE_RESULT
		SELECT 
			#M0070_SEARCH.employee_cd
		FROM #M0070_SEARCH
	END
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--result 
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF @P_mode = 0
	BEGIN
	SET @totalRecord = (SELECT COUNT(1) FROM #TABLE_RESULT)
	SET @pageMax = CEILING(CAST(@totalRecord AS FLOAT) / @page_size)
	IF @pageMax = 0
	BEGIN
		SET @pageMax = 1
	END
	IF @page > @pageMax
	BEGIN
		SET @page = @pageMax
	END
	--[0]
	SELECT 
		#TABLE_RESULT.employee_cd				AS	employee_cd
	,	CASE
		WHEN (M0070.company_out_dt IS NOT NULL AND (M0070.company_out_dt <  @w_today))
		THEN ISNULL(IIF(@w_language = 2,'Retirement','退職'),'')
		ELSE ISNULL(IIF(@w_language = 2,L0010.name_english,L0010.name),'')	
		END																	AS	retirement_reason_typ_nm
	,	ISNULL(#M0070H.employee_nm,'')			AS	employee_nm
	,	ISNULL(#M0070H.employee_typ_nm,'')		AS	employee_typ_nm
	,	ISNULL(#M0070H.belong_nm_1,'')			AS	belong_nm_1
	,	ISNULL(#M0070H.belong_nm_2,'')			AS	belong_nm_2
	,	ISNULL(#M0070H.belong_nm_3,'')			AS	belong_nm_3
	,	ISNULL(#M0070H.belong_nm_4,'')			AS	belong_nm_4
	,	ISNULL(#M0070H.belong_nm_5,'')			AS	belong_nm_5
	,	ISNULL(#M0070H.job_nm,'')				AS	job_nm
	,	ISNULL(#M0070H.position_nm,'')			AS	position_nm
	,	ISNULL(#M0070H.grade_nm,'')				AS	grade_nm
	FROM #TABLE_RESULT
	LEFT OUTER JOIN #M0070H ON (
		@P_company_cd				=	#M0070H.company_cd
	AND	#TABLE_RESULT.employee_cd	=	#M0070H.employee_cd
	)
	LEFT OUTER JOIN M0070 ON (
		@P_company_cd				=	M0070.company_cd
	AND	#TABLE_RESULT.employee_cd	=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT JOIN L0010 ON(
		17							=	L0010.name_typ
	AND M0070.retirement_reason_typ	=	L0010.number_cd
	AND L0010.del_datetime IS NULL
	)
	ORDER BY 
		CASE ISNUMERIC(#TABLE_RESULT.employee_cd) 
			WHEN 1 
			THEN CAST(#TABLE_RESULT.employee_cd AS BIGINT) 
			ELSE 999999999999999 
		END 
	,	#TABLE_RESULT.employee_cd
	offset (@page-1) * @page_size ROWS
	FETCH NEXT @page_size ROWS only
	--[1]
	SELECT	
		@totalRecord					AS totalRecord
	,	@pageMax						AS pageMax
	,	@page							AS page
	,	@page_size						AS pagesize
	,	((@page - 1) * @page_size + 1)	AS offset
	END
	ELSE
	BEGIN
		SET 
		@w_json_employee =	(SELECT #TABLE_RESULT.employee_cd		
		FROM #TABLE_RESULT
		LEFT OUTER JOIN #M0070H ON (
			@P_company_cd				=	#M0070H.company_cd
		AND	#TABLE_RESULT.employee_cd	=	#M0070H.employee_cd
		)
		LEFT OUTER JOIN M0070 ON (
			@P_company_cd				=	M0070.company_cd
		AND	#TABLE_RESULT.employee_cd	=	M0070.employee_cd
		AND M0070.del_datetime IS NULL
		)
		LEFT JOIN L0010 ON(
			17							=	L0010.name_typ
		AND M0070.retirement_reason_typ	=	L0010.number_cd
		AND L0010.del_datetime IS NULL
		)
		ORDER BY 
			CASE ISNUMERIC(#TABLE_RESULT.employee_cd) 
				WHEN 1 
				THEN CAST(#TABLE_RESULT.employee_cd AS BIGINT) 
				ELSE 999999999999999 
			END 
		,	#TABLE_RESULT.employee_cd
		FOR JSON AUTO)
	END
	IF @P_mode = 0
	BEGIN
	SELECT 
		message_no
	,	item
	,	order_by
	,	error_typ
	,	value1
	,	value2
	,	remark
	FROM @ERR_TBL
	END
	

	-- DROP
	DROP TABLE #LIST_POSITION
	DROP TABLE #M0070H
	DROP TABLE #TABLE_ORGANIZATION
	DROP TABLE #M0070_SEARCH
	DROP TABLE #TABLE_F0201
	DROP TABLE #TABLE_JSON
	DROP TABLE #TABLE_JSON_SCREEN
	DROP TABLE #TABLE_M0075
	DROP TABLE #TABLE_M0078
	DROP TABLE #TABLE_M0088
	DROP TABLE #TABLE_M0088_CNT
	DROP TABLE #TABLE_M0093
	DROP TABLE #TABLE_RESULT
	DROP TABLE #TABLE_M0073
	DROP TABLE #TABLE_M0073_8
	DROP TABLE #TABLE_M0073_9
	DROP TABLE #TABLE_M0076
	DROP TABLE #TABLE_M0077
END
GO
