DROP PROCEDURE [SPC_O0100_RPT23]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+TEST+
-- EXEC [SPC_O0100_RPT23] '{"screen":[{"screen_cd":"1"},{"screen_cd":"10"}],"type":"0","employee":"[]"}','10035','acc005','jp';
-- EXEC [SPC_O0100_RPT23] '{"screen":[],"employee":"[]"}','10035','acc003','jp';
-- EXEC [SPC_O0100_RPT23] '{"screen":[{"screen_cd":"3"},{"screen_cd":"4"}],"employee":"[]"}','740','721','jp';
-- EXEC SPC_O0100_INQ1 '23','{"screen":[],"employee":[],"type":"0"}','10035','hanhntm','jp';
/****************************************************************************************************
 *
 *  処理概要:  export csv file
 *
 *  作成日  ： 2024/04/15
 *  作成者  ： PhuongDT
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *  
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_O0100_RPT23]
	@P_json					NVARCHAR(MAX)		= N''
,	@P_company_cd			SMALLINT			= 0
,	@P_user_id				NVARCHAR(50)		= ''
,	@P_language				NVARCHAR(2)			= ''
,	@P_json_filter			NVARCHAR(MAX)		= N''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 	
		@w_sql				NVARCHAR(MAX)		= ''
	,	@authority_cd		smallint		=	0	--	login user authority_cd
	,	@authority_typ		smallint		=	0	--	1.被評価者 2.評価者 3.管理者 4.管理会社 5.総合管理者
	,	@emp_authority_cd	smallint		=	0	--	employeeinfo authority_cd
	,	@emp_authority_typ	smallint		=	0	--	1.被評価者 2.評価者 3.管理者 4.管理会社 5.総合管理者
	,	@w_tab_id			smallint		=	0
	,	@w_type				smallint		=	0
	,	@w_login_position_cd				int				=	0
	,	@w_empinfo_authority_typ			smallint		=	0
	,	@w_empinfo_authority_cd				smallint		=	0
	,	@w_use_typ							smallint		=	0
	,	@w_arrange_order					int				=	0
	,	@w_evaluation_organization_cnt		int				=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	smallint		=	0
	,	@w_choice_in_screen					tinyint			=	0
	,	@w_today							date			= getdate()
	,	@w_json_employee					nvarchar(max)	=	''

	SET	@w_type				=	JSON_VALUE(@P_json,'$.type')

	SELECT 
		@authority_cd			=	ISNULL(S0010.setting_authority_cd,0)
	,	@authority_typ			=	ISNULL(S0010.setting_authority_typ,0)
	,	@emp_authority_cd		=	ISNULL(S0010.empinfo_authority_cd,0)
	,	@emp_authority_typ		=	ISNULL(S0010.empinfo_authority_typ,0)
	FROM S0010
	WHERE
		S0010.company_cd	=	@P_company_cd
	AND S0010.user_id		=	@P_user_id
	AND S0010.del_datetime IS NULL
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
	--
	CREATE TABLE #TABLE_FILTER(
		employee_cd						nvarchar(10)
	)
	SELECT 
		@w_empinfo_authority_typ	=	ISNULL(S0010.empinfo_authority_typ,0)
	,	@w_empinfo_authority_cd		=	ISNULL(S0010.empinfo_authority_cd,0)
	,	@w_login_position_cd		=	ISNULL(M0070.position_cd,0)
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
	SELECT 
		@w_arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@w_login_position_cd
	AND M0040.del_datetime IS NULL
	---
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
	-- get @w_use_typ
	SELECT 
		@w_use_typ		=	ISNULL(S5020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
	FROM S5020
	WHERE
		S5020.company_cd		=	@P_company_cd
	AND S5020.authority_cd		=	@w_empinfo_authority_cd
	AND S5020.del_datetime IS NULL
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @w_today,'',@P_company_cd
	CREATE TABLE #TEMP_AUTHORITY (
		function_id							NVARCHAR(10)
	)
		
	 EXEC [dbo].SPC_eQ0100_FND1 @P_json_filter,1,@P_user_id, @P_company_cd,  @w_json_employee OUTPUT
	 INSERT INTO #TABLE_FILTER
	 SELECT employee_cd
	 FROM OPENJSON(@w_json_employee) WITH(
		employee_cd			nvarchar(10)
	)

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
	
	IF @w_type = 1
	BEGIN
		INSERT INTO #TEMP_AUTHORITY
		SELECT		
			screen_cd						
		FROM OPENJSON(@P_json,'$.screen') WITH(
			screen_cd		NVARCHAR(50)
		)
	END
	ELSE
	BEGIN
		INSERT INTO #TEMP_AUTHORITY
		SELECT		
			tab_id						
		FROM L0034
	END
	UPDATE #TEMP_AUTHORITY
	SET	function_id = L0034.function_id
	FROM #TEMP_AUTHORITY INNER JOIN L0034 ON(
		#TEMP_AUTHORITY.function_id = L0034.tab_id
	)
	
	CREATE TABLE #TEMP_EMPLOYEE(
		employee_cd					NVARCHAR(50)
	)
	INSERT INTO #TEMP_EMPLOYEE
	SELECT		
		emp_cd						
	FROM OPENJSON(@P_json,'$.employee') WITH(
		emp_cd		NVARCHAR(50)
	)

	
	IF NOT EXISTS (SELECT 1 FROM M9100 WHERE company_cd = @P_company_cd AND empinf_use_typ = 1 AND del_datetime IS NULL)
	BEGIN
		DELETE FROM #TEMP_AUTHORITY
	END
	-- 
	IF NOT EXISTS (SELECT 1 FROM M9101 WHERE company_cd = @P_company_cd AND empsrch_use_typ = 1 AND del_datetime IS NULL)
	BEGIN
		DELETE FROM #TEMP_AUTHORITY
	END
	IF @authority_typ NOT IN(3,4,5) and @w_type = 0
	BEGIN
		DELETE FROM #TEMP_AUTHORITY
	END
	IF @emp_authority_typ NOT IN(3,4,5) and @w_type = 1
	BEGIN
		DELETE FROM #TEMP_AUTHORITY
	END

	DELETE #TEMP_AUTHORITY FROM #TEMP_AUTHORITY
	LEFT JOIN(
		SELECT 
			L0034.function_id
		FROM M9102 
		INNER JOIN L0034 ON(
			M9102.tab_id = L0034.tab_id
		) 
		WHERE 
			company_cd = @P_company_cd 
		AND use_typ <> 0 
		AND M9102.del_datetime IS NULL
	) AS b ON (
		#TEMP_AUTHORITY.function_id = b.function_id
	) 
	WHERE 
		b.function_id IS NULL
	IF @w_type = 1
	BEGIN
		IF @emp_authority_typ = 3
		BEGIN
			DELETE #TEMP_AUTHORITY FROM #TEMP_AUTHORITY
			LEFT JOIN(
					SELECT L0034.*  FROM M5100 INNER JOIN L0034 ON(M5100.tab_id = L0034.tab_id)
				WHERE
					company_cd		=	@P_company_cd
				AND authority_cd	=	@emp_authority_cd
				AND use_typ			=	1
				AND M5100.del_datetime IS NULL
			) AS c ON (
				#TEMP_AUTHORITY.function_id = c.function_id
			) 
			WHERE 
				c.function_id IS NULL
		END
	END
	ELSE
	BEGIN
		IF @authority_typ = 3
	BEGIN
	DELETE #TEMP_AUTHORITY FROM #TEMP_AUTHORITY
	LEFT JOIN(
			SELECT * FROM S9021 WHERE company_cd = @P_company_cd AND authority_cd = @authority_cd AND authority <> 0 AND del_datetime IS NULL
	) AS c ON (
		#TEMP_AUTHORITY.function_id = c.function_id
	) 
	WHERE 
		c.function_id IS NULL
	END
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- INSET TEMP TABLE
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	---------------------------------------------
	CREATE TABLE #RESULT (
		id                          INT
	,	retirement_category			NVARCHAR(200)
	,	employee_cd					NVARCHAR(200)
	,	employee_last_nm			NVARCHAR(200)
	,	employee_first_nm			NVARCHAR(200)
	,	employee_nm					NVARCHAR(200)
	,	furigana					NVARCHAR(200)
	,	gender						NVARCHAR(200)
	,	mail						NVARCHAR(200)
	,	birth_date					NVARCHAR(200)
	,	company_in_dt				NVARCHAR(200)
	,	company_out_dt				NVARCHAR(200)
	,	retirement_reason_typ		nvarchar(200)
	,	retirement_reason			nvarchar(200)
	,	evaluated_typ				NVARCHAR(200)
	,	oneonone_typ				nvarchar(200)
	,	multireview_typ				nvarchar(200)
	,	report_typ					nvarchar(200)
	,	office_cd					NVARCHAR(200)
	,	belong_cd1					NVARCHAR(200)
	,	belong_cd2					NVARCHAR(200)
	,	belong_cd3					NVARCHAR(200)
	,	belong_cd4					NVARCHAR(200)
	,	belong_cd5					NVARCHAR(200)
	,	job_cd						NVARCHAR(200)
	,	position_cd					NVARCHAR(200)
	,	employee_typ				NVARCHAR(200)
	,	grade						NVARCHAR(200)
	,	salary_grade				NVARCHAR(200)
	,	company_mobile_number		NVARCHAR(200)
	,	extension_number			NVARCHAR(200)
	,	sso_user					NVARCHAR(255)
	,	_user_id					NVARCHAR(200)
	,	application_date			NVARCHAR(200)
	,	office_cd_71				NVARCHAR(200)
	,	belong_cd1_71				NVARCHAR(200)
	,	belong_cd2_71				NVARCHAR(200)
	,	belong_cd3_71				NVARCHAR(200)
	,	belong_cd4_71				NVARCHAR(200)
	,	belong_cd5_71				NVARCHAR(200)
	,	job_cd_71					NVARCHAR(200)
	,	position_cd_71				NVARCHAR(200)
	,	employee_typ_71				NVARCHAR(200)
	,	grade_71					NVARCHAR(200)
	,	item_cd						NVARCHAR(200)
	,	item_nm						NVARCHAR(200)
	,	item_no						NVARCHAR(200)
	,	character_item				NVARCHAR(200)
	,	number_item_2				NVARCHAR(200)
	,	date_item					NVARCHAR(200)
	,	number_item_4				NVARCHAR(200)
	,	detail_name_4				NVARCHAR(200)
	,	number_item_5				NVARCHAR(200)
	,	detail_name_5				NVARCHAR(200)
	,	blood_type					NVARCHAR(200)
	,	headquarters_prefectures	NVARCHAR(200)
	,	headquarters_other			NVARCHAR(200)
	,	possibility_transfer		NVARCHAR(200)
	,	nationality					NVARCHAR(200)
	,	residence_card_no			NVARCHAR(200)
	,	status_residence			NVARCHAR(200)
	,	expiry_date					NVARCHAR(200)
	,	permission_activities		NVARCHAR(200)
	,	disability_classification	NVARCHAR(200)
	,	disability_recognition_date	NVARCHAR(200)
	,	disability_content			NVARCHAR(200)
	,	common_name					NVARCHAR(200)
	,	common_name_furigana		NVARCHAR(200)
	,	maiden_name					NVARCHAR(200)
	,	maiden_name_furigana		NVARCHAR(200)
	,	business_name				NVARCHAR(200)
	,	business_name_furigana		NVARCHAR(200)
	,	base_style					NVARCHAR(200)
	,	sub_style					NVARCHAR(200)
	,	driver_point				NVARCHAR(200)
	,	analytical_point			NVARCHAR(200)
	,	expressive_point			NVARCHAR(200)
	,	amiable_point				NVARCHAR(200)
	,	detail_no_75				NVARCHAR(200)
	,	qualification_cd			NVARCHAR(200)
	,	qualification_typ			NVARCHAR(200)
	,	headquarters_other_75		NVARCHAR(200)
	,	possibility_transfer_75		NVARCHAR(200)
	,	remarks						NVARCHAR(100)
	,	detail_no_76				NVARCHAR(200)
	,	training_cd					NVARCHAR(200)
	,	training_nm					NVARCHAR(200)
	,	training_category_cd		NVARCHAR(200)
	,	training_course_format_cd	NVARCHAR(200)
	,	lecturer_name				NVARCHAR(200)
	,	training_date_from			NVARCHAR(200)
	,	training_date_to			NVARCHAR(200)
	,	training_status				NVARCHAR(200)
	,	passing_date				NVARCHAR(200)
	,	report_submission			NVARCHAR(200)
	,	report_submission_date		NVARCHAR(200)
	,	report_storage_location		NVARCHAR(200)
	,	nationality_76				NVARCHAR(100)
	,	work_history_kbn_77			NVARCHAR(200)
	,	detail_no_77				NVARCHAR(200)
	,	item_id_77					NVARCHAR(200)
	,	item_title					NVARCHAR(200)
	,	date_from					NVARCHAR(200)
	,	date_to						NVARCHAR(200)
	,	text_item					NVARCHAR(200)
	,	select_item					NVARCHAR(200)
	,	number_item					NVARCHAR(200)
	,	final_education_kbn					NVARCHAR(200)
	,	final_education_other				NVARCHAR(200)
	,	detail_no_78						NVARCHAR(200)
	,	graduation_year						NVARCHAR(200)
	,	graduation_school_cd				NVARCHAR(200)
	,	graduation_school_other				NVARCHAR(200)
	,	faculty								NVARCHAR(200)
	,	major								NVARCHAR(200)
	,	owning_house_kbn					NVARCHAR(200)
	,	head_household						NVARCHAR(200)
	,	post_code							NVARCHAR(200)
	,	address1							NVARCHAR(200)
	,	address3							NVARCHAR(200)
	,	personal_phone_number				NVARCHAR(200)
	,	personal_email_address				NVARCHAR(100)
	,	emergency_contact_name				NVARCHAR(200)
	,	emergency_contact_relationship		NVARCHAR(200)
	,	emergency_contact_post_code			NVARCHAR(200)
	,	emergency_contact_addres1			NVARCHAR(200)
	,	emergency_contact_addres3			NVARCHAR(200)
	,	emergency_contact_phone_number		NVARCHAR(200)
	,	detail_no_84							NVARCHAR(200)
	,	commuting_method						NVARCHAR(200)
	,	commuting_distance						NVARCHAR(200)
	,	drivinglicense_renewal_deadline			NVARCHAR(200)
	,	commuting_method_detail					NVARCHAR(200)
	,	departure_point							NVARCHAR(200)
	,	arrival_point							NVARCHAR(200)
	,	commuter_ticket_classification			NVARCHAR(200)
	,	commuting_expenses						NVARCHAR(200)
	,	marital_status							NVARCHAR(200)
	,	detail_no_86							NVARCHAR(200)
	,	full_name								NVARCHAR(200)
	,	full_name_furigana						NVARCHAR(200)
	,	relationship							NVARCHAR(200)
	,	gender_86								NVARCHAR(200)
	,	birthday								NVARCHAR(200)
	,	residential_classification				NVARCHAR(200)
	,	profession								NVARCHAR(200)
	,	detail_no_87							NVARCHAR(200)
	,	leave_absence_startdate					NVARCHAR(200)
	,	leave_absence_enddate					NVARCHAR(200)
	,	remarks_87								NVARCHAR(100)
	,	employment_contract_no					NVARCHAR(200)
	,	detail_no_88							NVARCHAR(200)
	,	start_date								NVARCHAR(200)
	,	expiration_date							NVARCHAR(200)
	,	contract_renewal_kbn					NVARCHAR(200)
	,	reason_resignation						NVARCHAR(100)
	,	remarks_88								NVARCHAR(100)
	,	employment_insurance_no					NVARCHAR(200)
	,	basic_pension_no						NVARCHAR(200)
	,	employment_insurance_status				NVARCHAR(200)
	,	health_insurance_status					NVARCHAR(200)
	,	health_insurance_reference_no			NVARCHAR(200)
	,	employees_pension_insurance_status		NVARCHAR(200)
	,	employees_pension_reference_no			NVARCHAR(200)
	,	welfare_pension_status					NVARCHAR(200)
	,	employees_pension_member_no				NVARCHAR(200)
	,	social_insurance_kbn					NVARCHAR(200)
	,	detail_no_91							NVARCHAR(200)
	,	joining_date							NVARCHAR(200)
	,	date_of_loss							NVARCHAR(200)
	,	reason_for_loss_kbn						NVARCHAR(200)
	,	reason_for_loss							NVARCHAR(200)
	,	base_salary								NVARCHAR(200)
	,	basic_annual_income						NVARCHAR(200)
	,	detail_no_93							NVARCHAR(200)
	,	reward_punishment_typ					NVARCHAR(200)
	,	decision_date							NVARCHAR(200)
	,	reason									NVARCHAR(100)
	,	remarks_93								NVARCHAR(100)
	-- eq0100
	,	fiscal_year								NVARCHAR(200)
	,	treatment_applications_no				NVARCHAR(200)
	,	treatment_applications_nm				NVARCHAR(200)
	,	point_sum								NVARCHAR(200)
	,	adjust_point							NVARCHAR(200)
	,	rank_cd									NVARCHAR(200)
	,	rank_nm									NVARCHAR(200)
	,	comment									NVARCHAR(200)
	,	employee_typ_nm							NVARCHAR(200)
	,	organization_nm_1						NVARCHAR(200)
	,	organization_nm_2						NVARCHAR(200)
	,	organization_nm_3						NVARCHAR(200)
	,	organization_nm_4						NVARCHAR(200)
	,	organization_nm_5						NVARCHAR(200)
	,	job_nm									NVARCHAR(200)
	,	position_nm								NVARCHAR(200)
	,	grade_nm								NVARCHAR(200)
	,	blood_type_nm							NVARCHAR(200)
	,	headquarters_prefectures_nm				NVARCHAR(200)
	,	possibility_transfer_nm					NVARCHAR(200)
	,	status_residence_nm						NVARCHAR(200)
	,	permission_activities_nm				NVARCHAR(200)
	,	disability_classification_nm			NVARCHAR(200)
	,	base_style_nm							NVARCHAR(200)
	,	sub_style_nm							NVARCHAR(200)
	,	qualification_nm						NVARCHAR(200)
	,	qualification_typ_nm					NVARCHAR(200)
	,	training_category_nm					NVARCHAR(200)
	,	training_course_format_nm				NVARCHAR(200)
	,	training_status_nm						NVARCHAR(200)
	,	report_submission_nm					NVARCHAR(200)
	,	selected_items_nm						NVARCHAR(200)
	,	final_education_kbn_nm					NVARCHAR(200)
	,	school_name								NVARCHAR(200)
	,	owning_house_kbn_nm						NVARCHAR(200)
	,	address2								NVARCHAR(200)
	,	home_phone_number						NVARCHAR(200)
	,	emergency_contact_birthday				NVARCHAR(200)
	,	emergency_contact_addres2				NVARCHAR(200)
	,	commuting_method_nm						NVARCHAR(200)
	,	commuter_ticket_classification_nm		NVARCHAR(200)
	,	marital_status_nm						NVARCHAR(200)
	,	gender_nm								NVARCHAR(200)
	,	residential_classification_nm			NVARCHAR(200)
	,	reward_punishment_typ_nm				NVARCHAR(200)
	)

	CREATE TABLE #TEMP_M0075 (
		id							INT
	,	retirement_category			NVARCHAR(200)
	,	employee_cd					NVARCHAR(200)
	,	detail_no					NVARCHAR(200)
	,	qualification_cd			NVARCHAR(200)
	,	qualification_nm			NVARCHAR(200)
	,	qualification_typ			NVARCHAR(200)
	,	qualification_typ_nm		NVARCHAR(200)
	,	headquarters_other			NVARCHAR(200)
	,	possibility_transfer		NVARCHAR(200)
	,	remarks						NVARCHAR(100)
	)
	CREATE TABLE #TEMP_M0076 (
		id							INT 
	,	retirement_category			NVARCHAR(200)
	,	employee_cd					NVARCHAR(200)
	,	detail_no					NVARCHAR(200)
	,	training_cd					NVARCHAR(200)
	,	training_nm					NVARCHAR(200)
	,	training_category_cd		NVARCHAR(200)
	,	training_category_nm		NVARCHAR(200)
	,	training_course_format_cd	NVARCHAR(200)
	,	training_course_format_nm	NVARCHAR(200)
	,	lecturer_name				NVARCHAR(200)
	,	training_date_from			NVARCHAR(200)
	,	training_date_to			NVARCHAR(200)
	,	training_status				NVARCHAR(200)
	,	training_status_nm			NVARCHAR(200)
	,	passing_date				NVARCHAR(200)
	,	report_submission			NVARCHAR(200)
	,	report_submission_nm		NVARCHAR(200)
	,	report_submission_date		NVARCHAR(200)
	,	report_storage_location		NVARCHAR(200)
	,	nationality					NVARCHAR(200)
	)
	CREATE TABLE #TEMP_M0077 (
		id							INT
	,	retirement_category			NVARCHAR(200)
	,	employee_cd					NVARCHAR(200)
	,	work_history_kbn			NVARCHAR(200)
	,	detail_no					NVARCHAR(200)
	,	item_id						NVARCHAR(200)
	,	item_title					NVARCHAR(200)
	,	date_from					NVARCHAR(200)
	,	date_to						NVARCHAR(200)
	,	text_item					NVARCHAR(200)
	,	select_item					NVARCHAR(200)
	,	selected_items_nm			NVARCHAR(200)
	,	number_item					NVARCHAR(200)
	)
	CREATE TABLE #TEMP_M0078_79 (
		employee_cd							NVARCHAR(200)
	,	detail_no							SMALLINT
	,	final_education_kbn					NVARCHAR(200)
	,	final_education_other				NVARCHAR(200)
	,	graduation_year						NVARCHAR(200)
	,	graduation_school_cd				NVARCHAR(200)
	,	graduation_school_other				NVARCHAR(200)
	,	faculty								NVARCHAR(200)
	,	major								NVARCHAR(200)
	)
	CREATE TABLE #TEMP_M0078 (
		id									INT
	,	retirement_category			NVARCHAR(200)
	,	employee_cd							NVARCHAR(200)
	,	detail_no							NVARCHAR(200)
	,	final_education_kbn					NVARCHAR(200)
	,	final_education_kbn_nm				NVARCHAR(200)
	,	final_education_other				NVARCHAR(200)
	,	graduation_year						NVARCHAR(200)
	,	graduation_school_cd				NVARCHAR(200)
	,	school_name							NVARCHAR(200)
	,	graduation_school_other				NVARCHAR(200)
	,	faculty								NVARCHAR(200)
	,	major								NVARCHAR(200)
	)

	CREATE TABLE #TEMP_M0084 (
		id										INT
	,	retirement_category						NVARCHAR(200)
	,	employee_cd								NVARCHAR(200)
	,	detail_no								NVARCHAR(200)
	,	commuting_method						NVARCHAR(200)
	,	commuting_method_nm						NVARCHAR(200)
	,	commuting_distance						NVARCHAR(200)
	,	drivinglicense_renewal_deadline			NVARCHAR(200)
	,	commuting_method_detail					NVARCHAR(200)
	,	departure_point							NVARCHAR(200)
	,	arrival_point							NVARCHAR(200)
	,	commuter_ticket_classification			NVARCHAR(200)
	,	commuter_ticket_classification_nm		NVARCHAR(200)
	,	commuting_expenses						NVARCHAR(200)
	)

	CREATE TABLE #TEMP_M0086 (
		id									INT
	,	retirement_category					NVARCHAR(200)
	,	employee_cd							NVARCHAR(200)
	,	marital_status						NVARCHAR(200)
	,	marital_status_nm					NVARCHAR(200)
	,	detail_no							NVARCHAR(200)
	,	full_name							NVARCHAR(200)
	,	full_name_furigana					NVARCHAR(200)
	,	relationship						NVARCHAR(200)
	,	gender								NVARCHAR(200)
	,	gender_nm							NVARCHAR(200)
	,	birthday							NVARCHAR(200)
	,	residential_classification			NVARCHAR(200)
	,	residential_classification_nm		NVARCHAR(200)
	,	profession							NVARCHAR(200)
	)

	CREATE TABLE #TEMP_M0087 (
		id							INT 
	,	retirement_category			NVARCHAR(200)
	,	employee_cd					NVARCHAR(200)
	,	detail_no					NVARCHAR(200)
	,	leave_absence_startdate		NVARCHAR(200)
	,	leave_absence_enddate		NVARCHAR(200)
	,	remarks						NVARCHAR(100)
	)
	CREATE TABLE #TEMP_M0088 (
		id							INT
	,	retirement_category			NVARCHAR(200)
	,	employee_cd					NVARCHAR(200)
	,	employment_contract_no		NVARCHAR(200)
	,	detail_no					NVARCHAR(200)
	,	start_date					NVARCHAR(200)
	,	expiration_date				NVARCHAR(200)
	,	contract_renewal_kbn		NVARCHAR(200)
	,	reason_resignation			NVARCHAR(100)
	,	remarks						NVARCHAR(100)
	)

	CREATE TABLE #TEMP_M0091 (
		id										INT
	,	retirement_category						NVARCHAR(200)
	,	employee_cd								NVARCHAR(200)
	,	employment_insurance_no					NVARCHAR(200)
	,	basic_pension_no						NVARCHAR(200)
	,	employment_insurance_status				NVARCHAR(200)
	,	health_insurance_status					NVARCHAR(200)
	,	health_insurance_reference_no			NVARCHAR(200)
	,	employees_pension_insurance_status		NVARCHAR(200)
	,	employees_pension_reference_no			NVARCHAR(200)
	,	welfare_pension_status					NVARCHAR(200)
	,	employees_pension_member_no				NVARCHAR(200)
	,	social_insurance_kbn					NVARCHAR(200)
    ,	detail_no								NVARCHAR(200)
	,	joining_date							NVARCHAR(200)
	,	date_of_loss							NVARCHAR(200)
	,	reason_for_loss_kbn						NVARCHAR(200)
	,	reason_for_loss							NVARCHAR(200)
	)
	CREATE TABLE #TEMP_M0093 (
		id							INT
	,	retirement_category			NVARCHAR(200)
	,	employee_cd					NVARCHAR(200)
	,	detail_no					NVARCHAR(200)
	,	reward_punishment_typ		NVARCHAR(200)
	,	reward_punishment_typ_nm	NVARCHAR(200)
	,	decision_date				NVARCHAR(200)
	,	reason						NVARCHAR(100)
	,	remarks						NVARCHAR(100)
	)

	CREATE TABLE #TEMP_F0201 (
		id							INT
	,	retirement_category			NVARCHAR(200)
	,	employee_cd					NVARCHAR(200)
	,	fiscal_year					NVARCHAR(200)
	,	treatment_applications_no	NVARCHAR(200)
	,	treatment_applications_nm	NVARCHAR(200)
	,	point_sum					NVARCHAR(200)
	,	adjust_point				NVARCHAR(200)
	,	rank_cd						NVARCHAR(200)
	,	rank_nm						NVARCHAR(200)
	,	comment						NVARCHAR(200)
	)
	---------------------------------------------
	INSERT INTO #TEMP_M0075
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY M0075.employee_cd ORDER BY M0075.detail_no) id
	,	CASE
			WHEN (M0070.company_out_dt IS NOT NULL AND (M0070.company_out_dt <  @w_today)) THEN IIF(@P_language = 'en', 'Retirement', '退職')
			WHEN M0070.company_out_dt IS NULL THEN ''
		END AS retirement_category					
	,	ISNULL(M0075.employee_cd,'')				
	,	ISNULL(M0075.detail_no,0)	
	,	ISNULL(M0075.qualification_cd,0)	
	,	ISNULL(M5010.qualification_nm,'')	
	,	ISNULL(M0075.qualification_typ,0)	
	,	IIF(@P_language = 'en', ISNULL(L0010.name_english,''), ISNULL(L0010.name,'')) 
	,	FORMAT(NULLIF(M0075.headquarters_other,'1900-01-01'), 'yyyy/MM/dd')	
	,	FORMAT(NULLIF(M0075.possibility_transfer,'1900-01-01'), 'yyyy/MM/dd')
	,	ISNULL(M0075.remarks,'')
	FROM M0075
	LEFT JOIN M0070 ON (
		M0075.employee_cd	= M0070.employee_cd
	AND	M0075.company_cd	= M0070.company_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT JOIN M5010 ON (
		M0075.qualification_cd		= M5010.qualification_cd 
	AND M0075.company_cd			= M5010.company_cd
	AND M5010.del_datetime IS NULL
	)
	LEFT JOIN L0010 ON (
		M0075.qualification_typ		= L0010.number_cd 
	AND L0010.name_typ 				= 57
	AND L0010.del_datetime IS NULL
	)
	WHERE 
		M0075.company_cd			=	@P_company_cd
	AND M0075.del_datetime IS NULL
	ORDER BY 
		CASE (SELECT 1 WHERE M0075.employee_cd NOT LIKE '%[^0-9]%')
		   WHEN 1 
		   THEN CAST(M0075.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	M0075.employee_cd
	-- 
	INSERT INTO #TEMP_M0076
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY M0076.employee_cd ORDER BY M0076.detail_no) id
	,	CASE
			WHEN (M0070.company_out_dt IS NOT NULL AND (M0070.company_out_dt <  @w_today)) THEN IIF(@P_language = 'en', 'Retirement', '退職')
			WHEN M0070.company_out_dt IS NULL THEN ''
		END AS retirement_category	
	,	ISNULL(M0076.employee_cd,'')				
	,	ISNULL(M0076.detail_no,0)	
	,	ISNULL(M0076.training_cd,0)	
	,	ISNULL(M0076.training_nm,'')				
	,	ISNULL(M0076.training_category_cd,0)				
	,	ISNULL(M5031.training_category_nm,'')				
	,	ISNULL(M0076.training_course_format_cd,0)	
	,	ISNULL(M5032.training_course_format_nm,'')				
	,	ISNULL(M0076.lecturer_name,'')					
	,	FORMAT(NULLIF(M0076.training_date_from,'1900-01-01'), 'yyyy/MM/dd')	
	,	FORMAT(NULLIF(M0076.training_date_to,'1900-01-01'), 'yyyy/MM/dd')	
	,	ISNULL(M0076.training_status,0)	
	,	IIF(@P_language = 'en', ISNULL(L0010_59.name_english,''), ISNULL(L0010_59.name,'')) 	
	,	FORMAT(NULLIF(M0076.passing_date,'1900-01-01'), 'yyyy/MM/dd')		
	,	ISNULL(M0076.report_submission,0)
	,	IIF(@P_language = 'en', ISNULL(L0010_60.name_english,''), ISNULL(L0010_60.name,'')) 
	,	FORMAT(NULLIF(M0076.report_submission_date,'1900-01-01'), 'yyyy/MM/dd')	
	,	ISNULL(M0076.report_storage_location,'')	
	,	ISNULL(M0076.nationality,'')
	FROM M0076
	LEFT JOIN M0070 ON (
		M0076.employee_cd	= M0070.employee_cd
	AND	M0076.company_cd	= M0070.company_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT JOIN M5031 ON (
		M0076.training_category_cd	= M5031.training_category_cd 
	AND M0076.company_cd			= M5031.company_cd
	AND M5031.del_datetime IS NULL
	)
	LEFT JOIN M5032 ON (
		M0076.training_course_format_cd		= M5032.training_course_format_cd 
	AND M0076.company_cd					= M5032.company_cd
	AND M5032.del_datetime IS NULL
	)
	LEFT JOIN L0010 AS L0010_59 ON (
		M0076.training_status			= L0010_59.number_cd 
	AND L0010_59.name_typ 				= 59
	AND L0010_59.del_datetime IS NULL
	)
	LEFT JOIN L0010 AS L0010_60 ON (
		M0076.report_submission			= L0010_60.number_cd 
	AND L0010_60.name_typ 				= 60
	AND L0010_60.del_datetime IS NULL
	)
	WHERE 
		M0076.company_cd			=	@P_company_cd
	AND M0076.del_datetime IS NULL
	ORDER BY 
		CASE (SELECT 1 WHERE M0076.employee_cd NOT LIKE '%[^0-9]%')
		   WHEN 1 
		   THEN CAST(M0076.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	M0076.employee_cd
	,	M0076.detail_no
	--
	INSERT INTO #TEMP_M0077
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY M0077.employee_cd ORDER BY M0077.work_history_kbn, M0077.detail_no, M0077.item_id) id
	,	CASE
			WHEN (M0070.company_out_dt IS NOT NULL AND (M0070.company_out_dt <  @w_today)) THEN IIF(@P_language = 'en', 'Retirement', '退職')
			WHEN M0070.company_out_dt IS NULL THEN ''
		END AS retirement_category	
	,	ISNULL(M0077.employee_cd,'')				
	,	ISNULL(M0077.work_history_kbn,0)	
	,	ISNULL(M0077.detail_no,0)	
	,	ISNULL(M0077.item_id,0)	
	,	ISNULL(M5020.item_title,'')
	,	FORMAT(NULLIF(M0077.date_from,'1900-01-01'), 'yyyy/MM/dd')	
	,	FORMAT(NULLIF(M0077.date_to,'1900-01-01'), 'yyyy/MM/dd')	
	,	ISNULL(M0077.text_item,'')		
	,	ISNULL(M0077.select_item,0)	
	,	ISNULL(M5021.selected_items_nm,'')	
	,	ISNULL(M0077.number_item,0)
	FROM M0077
	LEFT JOIN M0070 ON (
		M0077.employee_cd	= M0070.employee_cd
	AND	M0077.company_cd	= M0070.company_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT JOIN M5020 ON ( 
		M0077.company_cd			= M5020.company_cd 
	AND M0077.work_history_kbn		= M5020.work_history_kbn 
	AND M0077.item_id				= M5020.item_id 
	AND M5020.del_datetime IS NULL
	)
	LEFT JOIN M5021 ON (
		M0077.item_id				= M5021.item_id 
	AND M0077.select_item			= M5021.selected_items_no 
	AND M0077.company_cd			= M5021.company_cd
	AND M0077.work_history_kbn		= M5021.work_history_kbn
	AND M5021.del_datetime IS NULL
	)
	WHERE 
		M0077.company_cd			=	@P_company_cd
	AND M0077.del_datetime IS NULL
	ORDER BY 
		CASE (SELECT 1 WHERE M0077.employee_cd NOT LIKE '%[^0-9]%')
		   WHEN 1 
		   THEN CAST(M0077.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	M0077.employee_cd
	,	M0077.work_history_kbn
	,	M0077.detail_no
	,	M0077.item_id
	--
	INSERT INTO #TEMP_M0078_79
	SELECT 
		ISNULL(employee_cd,'')				
	,	0
	,	ISNULL(final_education_kbn,0)	
	,	ISNULL(final_education_other,'')		
	,	ISNULL(graduation_year,0)		
	,	ISNULL(graduation_school_cd,'')		
	,	ISNULL(graduation_school_other,'')		
	,	ISNULL(faculty,'')		
	,	ISNULL(major,'')
	FROM M0078
	WHERE 
		M0078.company_cd			=	@P_company_cd
	AND M0078.del_datetime IS NULL
	INSERT INTO #TEMP_M0078_79
	SELECT 
		ISNULL(employee_cd,'')				
	,	ISNULL(detail_no,'')
	,	NULL	
	,	NULL		
	,	ISNULL(graduation_year,0)		
	,	ISNULL(graduation_school_cd,'')		
	,	ISNULL(graduation_school_other,'')		
	,	ISNULL(faculty,'')		
	,	ISNULL(major,'')
	FROM M0079
	WHERE 
		M0079.company_cd			=	@P_company_cd
	AND M0079.del_datetime IS NULL
	--
	INSERT INTO #TEMP_M0078
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY #TEMP_M0078_79.employee_cd ORDER BY #TEMP_M0078_79.detail_no) id
	,	CASE
			WHEN (M0070.company_out_dt IS NOT NULL AND (M0070.company_out_dt <  @w_today)) THEN IIF(@P_language = 'en', 'Retirement', '退職')
			WHEN M0070.company_out_dt IS NULL THEN ''
		END AS retirement_category	
	,	#TEMP_M0078_79.employee_cd				
	,	#TEMP_M0078_79.detail_no
	,	#TEMP_M0078_79.final_education_kbn
	,	IIF(@P_language = 'en', ISNULL(L0010_61.name_english,''), ISNULL(L0010_61.name,'')) 
	,	#TEMP_M0078_79.final_education_other		
	,	#TEMP_M0078_79.graduation_year		
	,	#TEMP_M0078_79.graduation_school_cd
	,	ISNULL(L0013.school_name,'')
	,	#TEMP_M0078_79.graduation_school_other		
	,	#TEMP_M0078_79.faculty	
	,	#TEMP_M0078_79.major
	FROM #TEMP_M0078_79
	LEFT JOIN M0070 ON (
		#TEMP_M0078_79.employee_cd	= M0070.employee_cd
	AND	M0070.company_cd	= @P_company_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT JOIN L0010 AS L0010_61 ON (
		#TEMP_M0078_79.final_education_kbn	= L0010_61.number_cd 
	AND L0010_61.name_typ 					= 61
	AND L0010_61.del_datetime IS NULL
	)
	LEFT JOIN L0013 ON (
		#TEMP_M0078_79.graduation_school_cd		= L0013.school_code 
	AND L0013.del_datetime IS NULL
	)
	ORDER BY 
		CASE (SELECT 1 WHERE #TEMP_M0078_79.employee_cd NOT LIKE '%[^0-9]%')
		   WHEN 1 
		   THEN CAST(#TEMP_M0078_79.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	#TEMP_M0078_79.employee_cd
	,	#TEMP_M0078_79.detail_no
	--
	INSERT INTO #TEMP_M0084
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY M0084.employee_cd ORDER BY M0084.detail_no) id
	,	CASE
			WHEN (M0070.company_out_dt IS NOT NULL AND (M0070.company_out_dt <  @w_today)) THEN IIF(@P_language = 'en', 'Retirement', '退職')
			WHEN M0070.company_out_dt IS NULL THEN ''
		END AS retirement_category	
	,	ISNULL(M0084.employee_cd,N'')				
	,	ISNULL(M0084.detail_no,0)	
	,	ISNULL(M0084.commuting_method,0)
	,	IIF(@P_language = 'en', ISNULL(L0010_64.name_english,''), ISNULL(L0010_64.name,'')) 
	,	ISNULL(M0084.commuting_distance,0)	
	,	FORMAT(NULLIF(M0084.drivinglicense_renewal_deadline,N'1900-01-01'), 'yyyy/MM/dd')
	,	ISNULL(M0084.commuting_method_detail,N'')
	,	ISNULL(M0084.departure_point,N'')
	,	ISNULL(M0084.arrival_point,N'')
	,	ISNULL(M0084.commuter_ticket_classification,0)
	,	CASE
			WHEN M0084.commuting_method = 3 THEN IIF(@P_language = 'en', ISNULL(L0010_65.name_english,''), ISNULL(L0010_65.name,'')) 
			WHEN M0084.commuting_method = 6 THEN IIF(@P_language = 'en', ISNULL(L0010_66.name_english,''), ISNULL(L0010_66.name,'')) 
			ELSE ''
		END
	,	ISNULL(commuting_expenses,0)
	FROM M0084
	LEFT JOIN M0070 ON (
		M0084.employee_cd	= M0070.employee_cd
	AND	M0084.company_cd	= M0070.company_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT JOIN L0010 AS L0010_64 ON (
		M0084.commuting_method		= L0010_64.number_cd 
	AND L0010_64.name_typ 			= 64
	AND L0010_64.del_datetime IS NULL
	)
	LEFT JOIN L0010 AS L0010_65 ON (
		M0084.commuter_ticket_classification	= L0010_65.number_cd 
	AND M0084.commuting_method 					= 3
	AND L0010_65.name_typ 						= 65
	AND L0010_65.del_datetime IS NULL
	)
	LEFT JOIN L0010 AS L0010_66 ON (
		M0084.commuter_ticket_classification	= L0010_66.number_cd 
	AND M0084.commuting_method 					= 6
	AND L0010_66.name_typ 						= 66
	AND L0010_66.del_datetime IS NULL
	)
	WHERE 
		M0084.company_cd			=	@P_company_cd
	AND M0084.del_datetime IS NULL
	ORDER BY 
		CASE (SELECT 1 WHERE M0084.employee_cd NOT LIKE '%[^0-9]%')
		   WHEN 1 
		   THEN CAST(M0084.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	M0084.employee_cd
	,	M0084.detail_no
	--
	INSERT INTO #TEMP_M0086
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY M0085.employee_cd ORDER BY M0086.detail_no) id
	,	CASE
			WHEN (M0070.company_out_dt IS NOT NULL AND (M0070.company_out_dt <  @w_today)) THEN IIF(@P_language = 'en', 'Retirement', '退職')
			WHEN M0070.company_out_dt IS NULL THEN ''
		END AS retirement_category	
	,	ISNULL(M0085.employee_cd,'')				
	,	ISNULL(M0085.marital_status,0)	
	,	IIF(@P_language = 'en', ISNULL(L0010_67.name_english,''), ISNULL(L0010_67.name,''))
	,	ISNULL(M0086.detail_no,0)	
	,	ISNULL(M0086.full_name,'')				
	,	ISNULL(M0086.full_name_furigana,'')				
	,	ISNULL(M0086.relationship,'')				
	,	ISNULL(M0086.gender,0)			
	,	IIF(@P_language = 'en', ISNULL(L0010_68.name_english,''), ISNULL(L0010_68.name,''))
	,	FORMAT(NULLIF(M0086.birthday,'1900-01-01'), 'yyyy/MM/dd')					
	,	ISNULL(M0086.residential_classification,0)	
	,	IIF(@P_language = 'en', ISNULL(L0010_69.name_english,''), ISNULL(L0010_69.name,''))		
	,	ISNULL(M0086.profession,'')	
	FROM M0085
	LEFT JOIN M0070 ON (
		M0085.employee_cd	= M0070.employee_cd
	AND	M0085.company_cd	= M0070.company_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT JOIN L0010 AS L0010_67 ON (
		M0085.marital_status		= L0010_67.number_cd 
	AND L0010_67.name_typ 			= 67
	AND L0010_67.del_datetime IS NULL
	)
	LEFT JOIN M0086 ON(
		M0085.company_cd	= M0086.company_cd
	AND M0085.employee_cd	= M0086.employee_cd
	AND M0086.del_datetime IS NULL
	)
	LEFT JOIN L0010 AS L0010_68 ON (
		M0086.gender				= L0010_68.number_cd 
	AND L0010_68.name_typ 			= 68
	AND L0010_68.del_datetime IS NULL
	)
	LEFT JOIN L0010 AS L0010_69 ON (
		M0086.residential_classification	= L0010_69.number_cd 
	AND L0010_69.name_typ 					= 69
	AND L0010_69.del_datetime IS NULL
	)
	WHERE 
		M0085.company_cd =	@P_company_cd
	AND M0085.del_datetime IS NULL
	ORDER BY 
		CASE (SELECT 1 WHERE M0085.employee_cd NOT LIKE '%[^0-9]%')
		   WHEN 1 
		   THEN CAST(M0085.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	M0085.employee_cd
	,	M0086.detail_no
	--
	INSERT INTO #TEMP_M0087
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY M0087.employee_cd ORDER BY M0087.detail_no) id
	,	CASE
			WHEN (M0070.company_out_dt IS NOT NULL AND (M0070.company_out_dt <  @w_today)) THEN IIF(@P_language = 'en', 'Retirement', '退職')
			WHEN M0070.company_out_dt IS NULL THEN ''
		END AS retirement_category	
	,	ISNULL(M0087.employee_cd,N'')				
	,	ISNULL(M0087.detail_no,0)	
	,	FORMAT(NULLIF(M0087.leave_absence_startdate,N'1900-01-01'), 'yyyy/MM/dd')
	,	FORMAT(NULLIF(M0087.leave_absence_enddate,N'1900-01-01'), 'yyyy/MM/dd')
	,	ISNULL(M0087.remarks,N'')
	FROM M0087
	LEFT JOIN M0070 ON (
		M0087.employee_cd	= M0070.employee_cd
	AND	M0087.company_cd	= M0070.company_cd
	AND M0070.del_datetime IS NULL
	)
	WHERE 
		M0087.company_cd			=	@P_company_cd
	AND M0087.del_datetime IS NULL
	ORDER BY 
		CASE (SELECT 1 WHERE M0087.employee_cd NOT LIKE '%[^0-9]%')
		   WHEN 1 
		   THEN CAST(M0087.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	M0087.employee_cd
	,	M0087.detail_no
	--
	INSERT INTO #TEMP_M0088
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY M0088.employee_cd ORDER BY M0088.employment_contract_no, M0088.detail_no) id
	,	CASE
			WHEN (M0070.company_out_dt IS NOT NULL AND (M0070.company_out_dt <  @w_today)) THEN IIF(@P_language = 'en', 'Retirement', '退職')
			WHEN M0070.company_out_dt IS NULL THEN ''
		END AS retirement_category	
	,	ISNULL(M0088.employee_cd,N'')
	,	ISNULL(M0088.employment_contract_no,0)
	,	ISNULL(M0088.detail_no,0)	
	,	FORMAT(NULLIF(M0088.start_date,N'1900-01-01'), 'yyyy/MM/dd')			AS start_date
	,	FORMAT(NULLIF(M0088.expiration_date,N'1900-01-01'), 'yyyy/MM/dd')		AS expiration_date
	,	ISNULL(M0088.contract_renewal_kbn,0)
	,	ISNULL(M0088.reason_resignation,N'')
	,	ISNULL(M0088.remarks,N'')
	FROM M0088
	LEFT JOIN M0070 ON (
		M0088.employee_cd	= M0070.employee_cd
	AND	M0088.company_cd	= M0070.company_cd
	AND M0070.del_datetime IS NULL
	)
	WHERE 
		M0088.company_cd			=	@P_company_cd
	AND M0088.del_datetime IS NULL
	ORDER BY 
		CASE (SELECT 1 WHERE M0088.employee_cd NOT LIKE '%[^0-9]%')
		   WHEN 1 
		   THEN CAST(M0088.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	M0088.employee_cd
	,	M0088.employment_contract_no
	,	M0088.detail_no
	--
	INSERT INTO #TEMP_M0091
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY M0090.employee_cd ORDER BY M0091.social_insurance_kbn, M0091.detail_no) id
	,	CASE
			WHEN (M0070.company_out_dt IS NOT NULL AND (M0070.company_out_dt <  @w_today)) THEN IIF(@P_language = 'en', 'Retirement', '退職')
			WHEN M0070.company_out_dt IS NULL THEN ''
		END AS retirement_category	
	,	ISNULL(M0090.employee_cd,N'')				
	,	ISNULL(M0090.employment_insurance_no,N'')				
	,	ISNULL(M0090.basic_pension_no,N'')					
	,	ISNULL(M0090.employment_insurance_status,0)				
	,	ISNULL(M0090.health_insurance_status,0)					
	,	ISNULL(M0090.health_insurance_reference_no,0)			
	,	ISNULL(M0090.employees_pension_insurance_status,0)		
	,	ISNULL(M0090.employees_pension_reference_no,0)		
	,	ISNULL(M0090.welfare_pension_status,0)				
	,	ISNULL(M0090.employees_pension_member_no,0)	
	,	ISNULL(M0091.social_insurance_kbn,0)	
	,	ISNULL(M0091.detail_no,0)
	,	FORMAT(NULLIF(M0091.joining_date,N'1900-01-01'), 'yyyy/MM/dd')			
	,	FORMAT(NULLIF(M0091.date_of_loss,N'1900-01-01'), 'yyyy/MM/dd')						
	,	ISNULL(M0091.reason_for_loss_kbn,0)				
	,	ISNULL(M0091.reason_for_loss,0)		
	FROM M0090
	LEFT JOIN M0070 ON (
		M0090.employee_cd	= M0070.employee_cd
	AND	M0090.company_cd	= M0070.company_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT JOIN M0091 ON(
		M0090.company_cd	= M0091.company_cd
	AND M0090.employee_cd	= M0091.employee_cd
	AND M0091.del_datetime IS NULL
	)
	WHERE 
		M0090.company_cd			=	@P_company_cd
	AND M0090.del_datetime IS NULL
	ORDER BY 
		CASE (SELECT 1 WHERE M0090.employee_cd NOT LIKE '%[^0-9]%')
		   WHEN 1 
		   THEN CAST(M0090.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	M0090.employee_cd
	,	M0091.social_insurance_kbn
	,	M0091.detail_no
	--
	INSERT INTO #TEMP_M0093
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY M0093.employee_cd ORDER BY M0093.detail_no) id
	,	CASE
			WHEN (M0070.company_out_dt IS NOT NULL AND (M0070.company_out_dt <  @w_today)) THEN IIF(@P_language = 'en', 'Retirement', '退職')
			WHEN M0070.company_out_dt IS NULL THEN ''
		END AS retirement_category	
	,	ISNULL(M0093.employee_cd,N'')				
	,	ISNULL(M0093.detail_no,0)	
	,	ISNULL(M0093.reward_punishment_typ,0)	
	,	IIF(@P_language = 'en', ISNULL(L0010_75.name_english,''), ISNULL(L0010_75.name,''))
	,	FORMAT(NULLIF(M0093.decision_date,N'1900-01-01'), 'yyyy/MM/dd')	
	,	ISNULL(M0093.reason,N'')
	,	ISNULL(M0093.remarks,N'')
	FROM M0093
	LEFT JOIN M0070 ON (
		M0093.employee_cd	= M0070.employee_cd
	AND	M0093.company_cd	= M0070.company_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT JOIN L0010 AS L0010_75 ON (
		M0093.reward_punishment_typ = L0010_75.number_cd 
	AND L0010_75.name_typ 			= 75
	AND L0010_75.del_datetime IS NULL
	)
	WHERE 
		M0093.company_cd			=	@P_company_cd
	AND M0093.del_datetime IS NULL
	ORDER BY 
		CASE (SELECT 1 WHERE M0093.employee_cd NOT LIKE '%[^0-9]%')
		   WHEN 1 
		   THEN CAST(M0093.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	M0093.employee_cd
	,	M0093.detail_no
	--
	IF @w_type = 1
	BEGIN
		INSERT INTO #TEMP_F0201
		SELECT 
			ROW_NUMBER() OVER (PARTITION BY F0201.employee_cd ORDER BY F0201.fiscal_year) id
		,	CASE
				WHEN (M0070.company_out_dt IS NOT NULL AND (M0070.company_out_dt <  @w_today)) THEN IIF(@P_language = 'en', 'Retirement', '退職')
				WHEN M0070.company_out_dt IS NULL THEN ''
			END AS retirement_category	
		,	ISNULL(F0201.employee_cd,'') as employee_cd
		,	ISNULL(F0201.fiscal_year,0)	
		,	ISNULL(F0201.treatment_applications_no,0)	
		,	ISNULL(M0102.treatment_applications_nm,'')	
		,	ISNULL(F0201.point_sum,0)	
		,	ISNULL(F0201.adjust_point,0)	
		,	ISNULL(F0201.rank_cd,0)	
		,	ISNULL(M0130.rank_nm,'')	
		,	ISNULL(F0201.comment,'')	
		FROM F0201
		LEFT JOIN M0070 ON (
			F0201.employee_cd	= M0070.employee_cd
		AND	F0201.company_cd	= M0070.company_cd
		AND M0070.del_datetime IS NULL
		)
		INNER JOIN M0102 ON (
			F0201.company_cd				= M0102.company_cd
		AND	F0201.treatment_applications_no = M0102.detail_no
		AND M0102.del_datetime IS NULL
		)
		INNER JOIN M0130 ON (
			F0201.company_cd				= M0130.company_cd
		AND	F0201.treatment_applications_no = M0130.treatment_applications_no 
		AND F0201.rank_cd					= M0130.rank_cd
		AND M0130.del_datetime IS NULL
		)
		INNER JOIN (
			SELECT 
				t2.employee_cd
			,	MIN(t2.fiscal_year) as min_fiscal_year
			FROM (
				SELECT 
					t1.employee_cd
				,	t1.fiscal_year
				,	ROW_NUMBER() OVER (PARTITION BY t1.employee_cd ORDER BY t1.fiscal_year DESC) year_id
				FROM (
					SELECT DISTINCT  
						employee_cd
					,	fiscal_year 
					FROM F0201 
					WHERE 
						F0201.company_cd = @P_company_cd 
					AND F0201.fiscal_year <= dbo.FNC_GET_YEAR(@P_company_cd,NULL) 
					AND F0201.evaluatorFB_datetime IS NOT NULL 
					AND F0201.del_datetime IS NULL
				) as t1
			) as t2
			WHERE t2.year_id <= 5
			GROUP BY t2.employee_cd
		) as t3 ON (
			F0201.employee_cd				= t3.employee_cd
		)
		WHERE 
			F0201.company_cd  =	 @P_company_cd
		AND F0201.fiscal_year <= dbo.FNC_GET_YEAR(@P_company_cd,NULL)
		AND F0201.fiscal_year >= t3.min_fiscal_year
		AND F0201.evaluatorFB_datetime IS NOT NULL 
		AND F0201.del_datetime IS NULL
		ORDER BY 
			CASE (SELECT 1 WHERE F0201.employee_cd NOT LIKE '%[^0-9]%')
				WHEN 1 
				THEN CAST(F0201.employee_cd AS BIGINT) 
				ELSE 999999999999999 
			END 
		,	F0201.employee_cd
		,	F0201.fiscal_year
		,	F0201.treatment_applications_no
	END

	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--  insert header
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF (@P_language = 'en')
	BEGIN
		INSERT INTO #RESULT
		SELECT 
			0
		,	'Retirement Category'		AS retirement_category						
		,	'Employee Code'				AS employee_cd						
		,	'Surname'		            AS employee_last_nm
		,	'First Name'		        AS employee_first_nm
		,	'Employee Name'				AS employee_nm			
		,	'Furigana'					AS furigana		
		,	'Gender'					AS gender			
		,	'E-Mail Address'			AS mail
		,	'Date of Birth'				AS birth_date		
		,	'Date of Hire'			    AS company_in_dt
		,	'Termination (Retirement) Date'	AS company_out_dt
		,	'Retirement Reason Type'	AS retirement_reason_typ	
		,	'Retirement Reason'			AS retirement_reason	
		,	'Evaluation Type'			AS evaluated_typ	
		,	'1o1 Type'					AS oneonone_typ	
		,	'Multireview Type'			AS multireview_typ
		,	'Report Type'				AS report_typ
		,	'Office Code'				AS office_cd		
		,	'Department Code 1'			AS belong_cd1		
		,	'Department Code 2'			AS belong_cd2	
		,	'Department Code 3'			AS belong_cd3	
		,	'Department Code 4'			AS belong_cd4	
		,	'Department Code 5'			AS belong_cd5		
		,	'Job Code'					AS job_cd			
		,	'Position Code'				AS position_cd		
		,	'Employee Classification'	AS employee_typ	
		,	'Rank'						AS grade
		,	'Salary Grade'				AS salary_grade
		,	'Company Mobile Number'		AS company_mobile_number
		,	'Extension Number'			AS extension_number
		,	'SSO User'					AS sso_user	
		,	'User ID'					AS _user_id	
		,	'Applied Date'					
		,	'Office Code'				
		,	'Department Code 1'						
		,	'Department Code 2'				
		,	'Department Code 3'				
		,	'Department Code 4'				
		,	'Department Code 5'					
		,	'Job Code'					
		,	'Position Code'					
		,	'Employee Classification'						
		,	'Rank'	
		,	'Item Code'		
		,	'Item Name'		
		,	'No'
		,	'Character Item'		
		,	'Number Item'		
		,	'Date Item'		
		,	'Number Item'		
		,	'Detail Name'		
		,	'Number Item'	
		,	'Detail Name'
        ,	'Blood Type' 				AS blood_type					
		,	'Headquarters Prefectures' 	AS headquarters_prefectures	
		,	'Headquarters Other' 		AS headquarters_other			
		,	'Possibility Transfer' 		AS possibility_transfer		
		,	'Nationality' 				AS nationality					
		,	'Residence Card No' 		AS residence_card_no			
		,	'Status Residence' 			AS status_residence			
		,	'Expiry Date' 				AS expiry_date
		,	'Permission Activities' 	AS permission_activities		
		,	'Disability Classification' AS disability_classification	
		,	'Disability Recognition Date' AS disability_recognition_date
		,	'Disability Content' 		AS disability_content			
		,	'Common Name' 				AS common_name					
		,	'Common Name Furigana' 		AS common_name_furigana		
		,	'Maiden Name' 				AS maiden_name					
		,	'Maiden Name Furigana' 		AS maiden_name_furigana		
		,	'Business Name' 			AS business_name				
		,	'Business Name Furigana' 	AS business_name_furigana		
		,	'Base Style'				AS base_style
		,	'Sub Style'					AS sub_style
		,	'Driver Point'				AS driver_point
		,	'Analytical Point'			AS analytical_point
		,	'Expressive Point'			AS expressive_point
		,	'Amiable Point'				AS amiable_point
        ,	'Detail No' 				AS detail_no					
		,	'Qualification Code' 		AS qualification_cd	
		,	'Qualification Type' 		AS qualification_typ			
		,	'Headquarters Other' 		AS headquarters_other		
		,	'Possibility Transfer' 		AS possibility_transfer					
		,	'Remarks' 					AS remarks
        ,	'Detail No' 					AS detail_no					
		,	'Training Code' 				AS training_cd	
		,	'Training Name' 				AS training_nm			
		,	'Training Category Code' 		AS training_category_cd		
		,	'Training Course Format Code' 	AS training_course_format_cd					
		,	'Lecturer Name' 				AS lecturer_name			
		,	'Training Date From' 			AS training_date_from			
		,	'Training Date To' 				AS training_date_to					
		,	'Training Status' 				AS training_status		
		,	'Passing Date' 					AS passing_date	
		,	'Report Submission'			 	AS report_submission	
		,	'Report Submission Date' 		AS report_submission_date			
		,	'Report Storage Location' 		AS report_storage_location			
		,	'Nationality' 					AS nationality
        ,	'Work History Kbn' 				AS work_history_kbn					
		,	'Detail No' 					AS detail_no	
		,	'Item ID' 						AS item_id		
		,	'Item Title' 						AS item_title	
		,	'Date From' 					AS date_from		
		,	'Date To' 						AS date_to					
		,	'Text Item' 					AS text_item			
		,	'Select Item' 					AS select_item			
		,	'Number Item' 					AS number_item
        ,	'Final Education Kbn' 				AS final_education_kbn	
		,	'Final Education Other' 			AS final_education_other
		,	'Detail No' 						AS detail_no_78				
		,	'Graduation Year' 					AS graduation_year					
		,	'Graduation School Code' 			AS graduation_school_cd					
		,	'Graduation School Other' 			AS graduation_school_other					
		,	'Faculty' 							AS faculty			
		,	'Major' 							AS major
        ,	'Owning House Kbn' 					AS owning_house_kbn					
		,	'Head Household' 					AS head_household	
		,	'Post Code' 						AS post_code			
		,	'Prefectures' 						AS address1					
		,	'Street Address/Building/Room Number' 						AS address3					
		,	'Personal Phone Number' 			AS personal_phone_number			
		,	'Personal Email Address' 			AS personal_email_address			
		,	'Emergency Contact Name' 			AS emergency_contact_name					
		,	'Emergency Contact Relationship' 	AS emergency_contact_relationship
		,	'Emergency Contact Post Code' 		AS emergency_contact_post_code					
		,	'Emergency Contact Addres 1' 		AS emergency_contact_addres1				
		,	'Emergency Contact Addres 3' 		AS emergency_contact_addres3				
		,	'Emergency Contact Phone Number' 	AS emergency_contact_phone_number
        ,	N'Detail No' 								AS detail_no					
		,	N'Commuting Method' 						AS commuting_method						
		,	N'Commuting Distance' 						AS commuting_distance														
		,	N'Drivinglicense Renewal Deadline' 			AS drivinglicense_renewal_deadline	
		,	N'Commuting Method Detail' 					AS commuting_method_detail			
		,	N'Departure Point' 							AS departure_point					
		,	N'Arrival Point' 							AS arrival_point					
		,	N'Commuter Ticket Classification' 			AS commuter_ticket_classification			
		,	N'Commuting Expenses' 						AS commuting_expenses
        ,	'Marital Status' 					AS marital_status					
		,	'Detail No' 						AS detail_no					
		,	'Full Name' 						AS full_name	
		,	'Full Name Furigana' 				AS full_name_furigana			
		,	'Relationship' 						AS relationship					
		,	'Gender' 							AS gender					
		,	'Birthday' 							AS birthday					
		,	'Residential Classification' 		AS residential_classification			
		,	'Profession' 						AS profession
        ,	N'Detail No' 				AS detail_no					
		,	N'Leave Absence Startdate' 	AS leave_absence_startdate				
		,	N'Leave Absence End Date' 	AS leave_absence_enddate												
		,	N'Remarks' 					AS remarks
        ,	N'Employment Contract No'	AS employment_contract_no							
		,	N'Detail No' 				AS detail_no						
		,	N'Start Date'				AS start_date				
		,	N'Expiration Date'			AS expiration_date			
		,	N'Contract Renewal'			AS contract_renewal_kbn	
		,	N'Reason Resignation'		AS reason_resignation		
		,	N'Remarks'					AS remarks
		,	N'Employment Insurance' 				AS employment_insurance_no				
		,	N'Basic Pension No' 					AS basic_pension_no					
		,	N'Employment Insurance Status' 			AS employment_insurance_status				
		,	N'Health Insurance Status' 				AS health_insurance_status					
		,	N'Health Insurance Reference No' 		AS health_insurance_reference_no				
		,	N'Employees Pension Insurance Status'	AS employees_pension_insurance_status				
		,	N'Employees Pension Reference No' 		AS employees_pension_reference_no		
		,	N'Welfare Pension Status' 				AS welfare_pension_status				
		,	N'Employees Pension Member No' 			AS employees_pension_member_no			
		,	N'Social Insurance' 					AS social_insurance_kbn	
        ,	N'Detail No' 							AS detail_no						
		,	N'Joining Date' 						AS joining_date			
		,	N'Date Of Loss' 						AS date_of_loss					
		,	N'Reason For Loss' 						AS reason_for_loss_kbn				
		,	N'Reason For Loss' 						AS reason_for_loss
        ,	N'Base Balary' 				AS base_salary									
		,	N'Basic Annual Income' 		AS basic_annual_income
        ,	N'Detail No' 				AS detail_no					
		,	N'Reward Punishment Type' 	AS reward_punishment_typ			
		,	N'Decision Date' 			AS decision_date				
		,	N'Reason' 					AS reason									
		,	N'Remarks' 					AS remarks
		,	N'Fiscal Year' 						AS fiscal_year									
		,	N'Treatment Applications No' 		AS treatment_applications_no
        ,	N'Treatment Applications name' 		AS treatment_applications_nm					
		,	N'Point Sum' 						AS point_sum			
		,	N'Adjust Point' 					AS adjust_point				
		,	N'Rank Code' 						AS rank_cd									
		,	N'Rank Name' 						AS rank_nm
		,	N'Comment' 							AS comment
		,	N'Employee Type Name' 							AS employee_typ_nm
		,	N'Organization Name 1' 							AS organization_nm_1
		,	N'Organization Name 2' 							AS organization_nm_2
		,	N'Organization Name 3' 							AS organization_nm_3
		,	N'Organization Name 4' 							AS organization_nm_4
		,	N'Organization Name 5' 							AS organization_nm_5
		,	N'Job Name' 									AS job_nm
		,	N'Position Name' 								AS position_nm
		,	N'Grade Name' 									AS grade_nm
		,	N'Blood Type Name' 								AS blood_type_nm
		,	N'Headquarters Prefecture Name' 				AS headquarters_prefectures_nm
		,	N'Possibility Transfer Name' 					AS possibility_transfer_nm
		,	N'Status Resident Name' 						AS status_residence_nm
		,	N'Permission Activities Name' 					AS permission_activities_nm
		,	N'Disability Classification Name' 				AS disability_classification_nm
		,	N'Base Style Name' 								AS base_style_nm
		,	N'Sub Style Name' 								AS sub_style_nm
		,	N'Qualification Name' 							AS qualification_nm
		,	N'Qualification Type Name' 						AS qualification_typ_nm
		,	N'Training Category Name' 						AS training_category_nm
		,	N'Training Course Format Name' 					AS training_course_format_nm
		,	N'Training Status Name' 						AS training_status_nm
		,	N'Report Submission Name' 						AS report_submission_nm
		,	N'Selected Items Name' 							AS selected_items_nm
		,	N'Final Education Kbn Name' 					AS final_education_kbn_nm
		,	N'School Name' 									AS school_name_nm
		,	N'Owning House Kbn Name' 						AS owning_house_kbn_nm
		,	N'Address 2' 									AS address2
		,	N'Home Phone Number' 							AS home_phone_number
		,	N'Emergency Contact Birthday' 					AS emergency_contact_birthday
		,	N'Emergency Contact Address 2' 					AS emergency_contact_addres2
		,	N'Commuting Method Name' 						AS commuting_method_nm
		,	N'Commuter Ticket Classification Name' 			AS commuter_ticket_classification_nm
		,	N'Material Status Name' 						AS marital_status_nm
		,	N'Gender Name' 									AS gender_nm
		,	N'Residential Classification Name' 				AS residential_classification_nm
		,	N'Reward Punishment Type Name' 					AS reward_punishment_typ_nm
    END
	ELSE
	BEGIN
        INSERT INTO #RESULT
		SELECT 
			0
		,	'退職区分'											AS retirement_category						
		,	IIF(@w_type = 0,'社員コード', '社員番号')				AS employee_cd						
		,	'社員姓'												AS employee_last_nm	
		,	'社員名'												AS employee_first_nm	
		,	IIF(@w_type = 0,'社員氏名', '社員名')					AS employee_nm			
		,	'ふりがな'											AS furigana		
		,	'性別'												AS gender			
		,	'メールアドレス'										AS mail			
		,	'生年月日'											AS birth_date		
		,	'入社日'												AS company_in_dt	
		,	'退社日'												AS company_out_dt	
		,	'退職理由区分'										AS retirement_reason_typ	
		,	'退職理由'											AS retirement_reason	
		,	'評価対象区分'										AS evaluated_typ	
		,	'１on１対象区分'										AS oneonone_typ	
		,	'マルチレビュー対象区分'								AS multireview_typ	
		,	'報告書対象区分'										AS report_typ	
		,	'事業所コード'										AS office_cd		
		,	IIF(@w_type = 0,'所属コード１', '組織１')				AS belong_cd1		
		,	IIF(@w_type = 0,'所属コード２', '組織２')				AS belong_cd2	
		,	IIF(@w_type = 0,'所属コード３', '組織３')				AS belong_cd3	
		,	IIF(@w_type = 0,'所属コード４', '組織４')				AS belong_cd4	
		,	IIF(@w_type = 0,'所属コード５', '組織５')				AS belong_cd5		
		,	IIF(@w_type = 0,'職種コード', '職種')					AS job_cd			
		,	IIF(@w_type = 0,'役職コード', '役職')					AS position_cd		
		,	'社員区分'											AS employee_typ	
		,	'等級'												AS grade
		,	'号俸'												AS salary_grade
		,	'社有携帯番号'										AS company_mobile_number
		,	'内線番号'											AS extension_number
		,	'SSOユーザ'											AS sso_user	
		,	'ユーザーID'											AS _user_id
		,	'適用年月日'					
		,	'事業所コード'				
		,	'所属コード１'						
		,	'所属コード２'				
		,	'所属コード３'				
		,	'所属コード４'				
		,	'所属コード５'						
		,	'職種コード'					
		,	'役職コード'					
		,	'社員区分'						
		,	'等級'	
		,	'項目コード'					
		,	'項目名'	
		,	'明細番号'		
		,	'入力項目'		
		,	'入力項目'		
		,	'入力項目'		
		,	'入力項目'		
		,	'項目名称'		
		,	'入力項目'	
		,	'項目名称'
        ,	'血液型' 					AS blood_type					
        ,	'本拠地_都道府県'			    AS headquarters_prefectures
        ,	'本拠地_その他' 			    AS headquarters_other
        ,	'転勤可否' 					AS possibility_transfer		
        ,	'国籍' 						AS nationality					
        ,	'在留カード番号' 			    AS residence_card_no
        ,	'在留資格' 					AS status_residence			
        ,	'在留期限日' 				AS expiry_date
        ,	'資格外活動許可' 			    AS permission_activities
        ,	'障害手帳区分' 				AS disability_classification	
        ,	'障害認定日' 				AS disability_recognition_date
        ,	'障害内容' 					AS disability_content			
        ,	'通称名' 					AS common_name					
        ,	'通称名フリガナ' 			    AS common_name_furigana
        ,	'旧姓' 						AS maiden_name					
        ,	'旧姓フリガナ' 				AS maiden_name_furigana		
        ,	'ビジネスネーム' 			    AS business_name
        ,	'ビジネスネームフリガナ'	    AS business_name_furigana
        ,	'ベーススタイル' 			    AS base_style
        ,	'サブスタイル' 				AS sub_style					
        ,	'ドライバー得点' 			    AS driver_point
        ,	'アナリティカル得点' 		    AS analytical_point
        ,	'エクスプレッシブ得点' 		AS expressive_point
        ,	'エミアブル得点' 			    AS amiable_point
        ,	'明細番号' 					AS detail_no
        ,	'資格コード' 				AS qualification_cd
        ,	'資格種別' 					AS qualification_typ
        ,	'資格取得日' 				AS headquarters_other
        ,	'資格有効期限' 				AS possibility_transfer
        ,	'備考' 						AS remarks
        ,	'明細番号' 					AS detail_no					
        ,	'研修コード' 				AS training_cd
        ,	'研修名' 					AS training_nm			
        ,	'研修カテゴリー' 			    AS training_category_cd
        ,	'受講形式' 					AS training_course_format_cd					
        ,	'講師名' 					AS lecturer_name			
        ,	'受講日FROM' 				AS training_date_from			
        ,	'受講日TO' 					AS training_date_to					
        ,	'受講状況' 					AS training_status		
        ,	'合格日' 					AS passing_date	
        ,	'レポート提出要否'			AS report_submission
        ,	'レポート提出日' 			    AS report_submission_date
        ,	'レポート格納先' 			    AS report_storage_location
        ,	'備考' 						AS nationality
        ,	'業務経歴区分' 					AS work_history_kbn					
        ,	'明細番号' 						AS detail_no	
        ,	'項目ID' 						AS item_id		
        ,	'項目タイトル' 					AS item_title	
        ,	'日付FROM' 						AS date_from		
        ,	'日付TO' 						AS date_to					
        ,	'文字項目' 						AS text_item			
        ,	'選択項目' 						AS select_item			
        ,	'数字項目' 						AS number_item
        ,	'最終学歴区分' 					AS final_education_kbn	
        ,	'最終学歴その他' 					AS final_education_other			
        ,	'明細番号' 						AS detail_no_78			
        ,	'卒業年' 						AS graduation_year
        ,	'卒業学校' 						AS graduation_school_cd					
        ,	'卒業学校その他' 					AS graduation_school_other					
        ,	'学部' 							AS faculty			
        ,	'専攻' 							AS major
        ,	'持ち家区分' 					AS owning_house_kbn
        ,	'世帯主' 						AS head_household	
        ,	'郵便番号' 						AS post_code			
        ,	'都道府県' 						AS address1					
        ,	'番地・建物・部屋番号' 						AS address3					
        ,	'個人携帯電話番号' 				AS personal_phone_number			
        ,	'個人メールアドレス' 				AS personal_email_address					
        ,	'緊急連絡先氏名' 					AS emergency_contact_name					
        ,	'緊急連絡先続柄' 					AS emergency_contact_relationship					
        ,	'緊急連絡先郵便番号' 				AS emergency_contact_post_code					
        ,	'緊急連絡先住所１' 				AS emergency_contact_addres1				
        ,	'緊急連絡先住所３' 				AS emergency_contact_addres3				
        ,	'緊急連絡先電話番号' 				AS emergency_contact_phone_number
        ,	N'明細番号' 						AS detail_no					
        ,	N'通勤手段' 						AS commuting_method						
        ,	N'通勤距離' 						AS commuting_distance														
        ,	N'運転免許証更新期限' 			AS drivinglicense_renewal_deadline	
        ,	N'通勤手段詳細' 					AS commuting_method_detail			
        ,	N'出発地' 						AS departure_point					
        ,	N'到着地' 						AS arrival_point					
        ,	N'定期券区分' 					AS commuter_ticket_classification				
        ,	N'通勤費' 						AS commuting_expenses
        ,	'配偶者有無' 					AS marital_status
        ,	'明細番号' 						AS detail_no					
        ,	'氏名' 							AS full_name	
        ,	'フリガナ' 						AS full_name_furigana			
        ,	'続柄' 							AS relationship					
        ,	'性別' 							AS gender					
        ,	'生年月日' 						AS birthday					
        ,	'居住区分' 						AS residential_classification			
        ,	'職業' 							AS profession
        ,	N'明細番号' 					AS detail_no					
        ,	N'休職開始日' 				AS leave_absence_startdate			
        ,	N'休職終了日' 				AS leave_absence_enddate								
        ,	N'備考' 						AS remarks
        ,	N'雇用契約番号'				AS employment_contract_no							
        ,	N'明細番号' 					AS detail_no						
        ,	N'雇用開始日'				AS start_date				
        ,	N'雇用契約満了日'				AS expiration_date			
        ,	N'契約更新の有無'				AS contract_renewal_kbn	
        ,	N'退職理由'					AS reason_resignation		
        ,	N'備考'						AS remarks
        ,	N'雇用保険番号' 							AS employment_insurance_no				
        ,	N'基礎年金番号' 							AS basic_pension_no					
        ,	N'雇用保険加入状況' 						AS employment_insurance_status				
        ,	N'健康保険加入状況' 						AS health_insurance_status					
        ,	N'健康保険被保険者整理番号' 				AS health_insurance_reference_no				
        ,	N'厚生年金保険加入状況' 					AS employees_pension_insurance_status				
        ,	N'厚生年金保険被保険者整理番号' 			AS employees_pension_reference_no		
        ,	N'厚生年金基金加入状況' 					AS welfare_pension_status				
        ,	N'厚生年金基金加入員番号' 				AS employees_pension_member_no	
        ,	N'区分' 									AS social_insurance_kbn	
        ,	N'明細番号' 								AS detail_no							
        ,	N'加入日' 								AS joining_date			
        ,	N'喪失日' 								AS date_of_loss					
        ,	N'喪失理由区分' 							AS reason_for_loss_kbn				
        ,	N'喪失理由' 								AS reason_for_loss
        ,	N'基本給' 					AS base_salary								
        ,	N'基本年収' 					AS basic_annual_income
        ,	N'明細番号' 					AS detail_no					
        ,	N'賞罰種別' 					AS reward_punishment_typ		
        ,	N'賞罰決定日' 				AS decision_date			
        ,	N'賞罰理由' 					AS reason								
        ,	N'備考' 						AS remarks
		,	N'年度' 						AS fiscal_year									
		,	N'処遇用途コード' 			AS treatment_applications_no
        ,	N'処遇用途名' 				AS treatment_applications_nm					
		,	N'評価ポイント計' 			AS point_sum			
		,	N'加減点' 					AS adjust_point				
		,	N'最終評語' 							AS rank_cd									
		,	N'評語名称' 							AS rank_nm
		,	N'コメント' 							AS comment
		,	N'社員区分名' 						AS employee_typ_nm
		,	N'組織１名' 							AS organization_nm_1
		,	N'組織２名' 							AS organization_nm_2
		,	N'組織３名' 							AS organization_nm_3
		,	N'組織４名' 							AS organization_nm_4
		,	N'組織５名' 							AS organization_nm_5
		,	N'職種名' 							AS job_nm
		,	N'役職名' 							AS position_nm
		,	N'等級名' 							AS grade_nm
		,	N'血液型名' 							AS blood_type_nm
		,	N'本拠地_都道府県名' 					AS headquarters_prefectures_nm
		,	N'転勤可否名' 						AS possibility_transfer_nm
		,	N'在留資格名' 						AS status_residence_nm
		,	N'資格外活動許可名' 					AS permission_activities_nm
		,	N'障害手帳区分名' 					AS disability_classification_nm
		,	N'ベーススタイル名' 					AS base_style_nm
		,	N'サブスタイル名' 					AS sub_style_nm
		,	N'資格名' 							AS qualification_nm
		,	N'資格種別名' 						AS qualification_typ_nm
		,	N'研修カテゴリー名' 					AS training_category_nm
		,	N'受講形式名' 						AS training_course_format_nm
		,	N'受講状況名' 						AS training_status_nm
		,	N'レポート提出要否名' 				AS report_submission_nm
		,	N'選択項目名' 						AS selected_items_nm
		,	N'最終学歴区分名' 					AS final_education_kbn_nm
		,	N'卒業学校名' 						AS school_name_nm
		,	N'持ち家区分名' 						AS owning_house_kbn_nm
		,	N'住所２' 							AS address2
		,	N'自宅電話番号' 						AS home_phone_number
		,	N'緊急連絡先生年月日' 				AS emergency_contact_birthday
		,	N'緊急連絡先住所２' 					AS emergency_contact_addres2
		,	N'通勤手段名' 						AS commuting_method_nm
		,	N'定期券区分名' 						AS commuter_ticket_classification_nm
		,	N'配偶者有無名' 						AS marital_status_nm
		,	N'性別名' 							AS gender_nm
		,	N'居住区分名' 						AS residential_classification_nm
		,	N'賞罰種別名' 						AS reward_punishment_typ_nm
    END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--  insert data
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF @w_type = 0 
	BEGIN
		INSERT INTO #RESULT
		SELECT
			1																		AS id
		,	SPACE(0)																AS retirement_category		
		,	ISNULL(M0070.employee_cd,'')											AS employee_cd		
		,	ISNULL(M0070.employee_last_nm,'')	 									AS employee_last_nm
		,	ISNULL(M0070.employee_first_nm,'')										AS employee_first_nm
		,	ISNULL(M0070.employee_nm,'')											AS employee_nm
		,	ISNULL(M0070.furigana,'')												AS furigana
		,	CAST(ISNULL(M0070.gender,0) AS nvarchar(10))							AS gender		
		,	ISNULL(M0070.mail,'')													AS	mail	
		,	FORMAT(NULLIF(M0070.birth_date,'1900-01-01'), 'yyyy/MM/dd')				AS birth_date
		,	FORMAT(NULLIF(M0070.company_in_dt,'1900-01-01'), 'yyyy/MM/dd')			AS company_in_dt	
		,	FORMAT(NULLIF(M0070.company_out_dt,'1900-01-01'), 'yyyy/MM/dd')			AS company_out_dt
		,	ISNULL(M0070.retirement_reason_typ,0) 									AS retirement_reason_typ
		,	ISNULL(M0070.retirement_reason,'') 										AS retirement_reason
		,	ISNULL(M0070.evaluated_typ,0)											AS evaluated_typ
		,	ISNULL(M0070.[1on1_typ],0)  											AS [1on1_typ]
		,	ISNULL(M0070.multireview_typ,0) 										AS multireview_typ
		,	ISNULL(M0070.report_typ,0)  											AS report_typ
		,	ISNULL(M0070.office_cd,0)												AS office_cd		
		,	ISNULL(M0070.belong_cd1,0)												AS belong_cd1		
		,	ISNULL(M0070.belong_cd2,0) 												AS belong_cd2
		,	ISNULL(M0070.belong_cd3,0)												AS belong_cd3
		,	ISNULL(M0070.belong_cd4,0)												AS belong_cd4
		,	ISNULL(M0070.belong_cd5,0)												AS belong_cd5	
		,	ISNULL(M0070.job_cd,0)													AS job_cd	
		,	ISNULL(M0070.position_cd,0)												AS position_cd	
		,	ISNULL(M0070.employee_typ,0)											AS employee_typ
		,	ISNULL(M0070.grade,0)													AS grade
		,	ISNULL(M0070.salary_grade,0) 											AS salary_grade
		,	ISNULL(M0070.company_mobile_number,'')									AS company_mobile_number
		,	ISNULL(M0070.extension_number,'')	 									AS extension_number
		,	ISNULL(S0010.sso_user,'')	 											AS sso_user
		,	ISNULL(S0010.user_id,'')  												AS user_id
		,	FORMAT(NULLIF(M0071.application_date,'1900-01-01'),'yyyy/MM/dd')		AS application_date
		,	ISNULL(M0071.office_cd,0)												AS office_cd_71
		,	ISNULL(M0071.belong_cd1,0)												AS belong_cd1_71	
		,	ISNULL(M0071.belong_cd2,0)												AS belong_cd2_71
		,	ISNULL(M0071.belong_cd3,0)												AS belong_cd3_71
		,	ISNULL(M0071.belong_cd4,0)												AS belong_cd4_71
		,	ISNULL(M0071.belong_cd5,0)												AS belong_cd5_71	
		,	ISNULL(M0071.job_cd,0)													AS job_cd_71	
		,	ISNULL(M0071.position_cd,0)												AS position_cd_71	
		,	ISNULL(M0071.employee_typ,0)											AS employee_typ_71
		,	ISNULL(M0071.grade,0)													AS grade_71
		,	ISNULL(M0072.item_cd,'') 												AS item_cd
		,	ISNULL(M0080.item_nm,'') 												AS item_nm
		,	ISNULL(M0072.item_no,'') 												AS item_no
		,	IIF(M0080.item_kind = 1, ISNULL(M0072.character_item,''), '') 		AS character_item
		,	IIF(M0080.item_kind = 2, CAST(M0072.number_item AS nvarchar(50)), '') AS number_item_2
		,	IIF(M0080.item_kind = 3, FORMAT(M0072.date_item, 'yyyy/MM/dd'), '') AS date_item
		,	IIF(M0080.item_kind = 4, CAST(M0072.number_item AS nvarchar(50)), '') AS number_item_4
		,	IIF(M0080.item_kind = 4, ISNULL(M0081.detail_name,''), '') 			AS detail_name_4
		,	IIF(M0080.item_kind = 5, CAST(M0072.number_item AS nvarchar(50)), '') AS number_item_5
		,	IIF(M0080.item_kind = 5, ISNULL(M0081.detail_name,''), '') 			AS detail_name_5
		,	ISNULL(M0074.blood_type,0)											AS blood_type
		,	ISNULL(M0074.headquarters_prefectures,0)	 						AS headquarters_prefectures
		,	ISNULL(M0074.headquarters_other,'')									AS headquarters_other
		,	ISNULL(M0074.possibility_transfer,'') 								AS possibility_transfer	
		,	ISNULL(M0074.nationality,'') 										AS nationality
		,	ISNULL(M0074.residence_card_no,'') 									AS residence_card_no
		,	ISNULL(M0074.status_residence,0) 									AS status_residence
		,	FORMAT(NULLIF(M0074.expiry_date,'1900-01-01'), 'yyyy/MM/dd') 		AS	expiry_date
		,	ISNULL(M0074.permission_activities,0) 								AS permission_activities
		,	ISNULL(M0074.disability_classification,0) 							AS disability_classification	
		,	FORMAT(NULLIF(M0074.disability_recognition_date,'1900-01-01'), 'yyyy/MM/dd') AS	disability_recognition_date
		,	ISNULL(M0074.disability_content,'') 								AS disability_content
		,	ISNULL(M0074.common_name,'') 										AS common_name
		,	ISNULL(M0074.common_name_furigana,'') 								AS common_name_furigana
		,	ISNULL(M0074.maiden_name,'') 										AS maiden_name
		,	ISNULL(M0074.maiden_name_furigana,'') 								AS maiden_name_furigana
		,	ISNULL(M0074.business_name,'') 										AS  business_name	
		,	ISNULL(M0074.business_name_furigana,'') 							AS business_name_furigana
		,	ISNULL(M0074.base_style,0) 											AS base_style
		,	ISNULL(M0074.sub_style,0) 											AS sub_style
		,	ISNULL(M0074.driver_point,0) 										AS driver_point
		,	ISNULL(M0074.analytical_point,0) 									AS analytical_point
		,	ISNULL(M0074.expressive_point,0) 									AS expressive_point
		,	ISNULL(M0074.amiable_point,0) 
		,	SPACE(0) -- 75
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- 76
		,	SPACE(0)
		,	SPACE(0)			
		,	SPACE(0)		
		,	SPACE(0)			
		,	SPACE(0)	
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)--77
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) --78
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	ISNULL(M0083.owning_house_kbn,0)									AS owning_house_kbn
		,	ISNULL(M0083.head_household,0)	 									AS head_household
		,	ISNULL(M0083.post_code,'')											AS post_code		
		,	ISNULL(M0083.address1,'')											AS address1	
		,	ISNULL(M0083.address3,'')											AS address3
		,	ISNULL(M0083.personal_phone_number,'')								AS personal_phone_number			
		,	ISNULL(M0083.personal_email_address,'')								AS personal_email_address		
		,	ISNULL(M0083.emergency_contact_name,'')								AS emergency_contact_name		
		,	ISNULL(M0083.emergency_contact_relationship,'')						AS emergency_contact_relationship			
		,	ISNULL(M0083.emergency_contact_post_code,'') 						AS emergency_contact_post_code
		,	ISNULL(M0083.emergency_contact_addres1,'') 							AS emergency_contact_addres1
		,	ISNULL(M0083.emergency_contact_addres3,'') 							AS emergency_contact_addres3
		,	ISNULL(M0083.emergency_contact_phone_number,'')						AS emergency_contact_phone_number
		,	SPACE(0)--84
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) --85
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) --87
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) --88
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) --90
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	REPLACE(RTRIM(LTRIM(ISNULL(M0092.base_salary,0))),'.00','')					AS base_salary
		,	REPLACE(RTRIM(LTRIM(ISNULL(M0092.basic_annual_income,0))),'.00','')			AS basic_annual_income
		,	SPACE(0) --93
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- tab 3
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		FROM M0070
		LEFT JOIN S0010 ON(
			M0070.company_cd	= S0010.company_cd
		AND M0070.employee_cd	= S0010.employee_cd
		AND S0010.del_datetime IS NULL
		)
		LEFT JOIN M0071 ON (
			M0070.employee_cd	= M0071.employee_cd
		AND	M0070.company_cd	= M0071.company_cd
		AND M0071.del_datetime IS NULL
		) 
		LEFT JOIN M0072 ON (
			M0070.employee_cd	= M0072.employee_cd
		AND	M0070.company_cd	= M0072.company_cd
		AND M0072.del_datetime IS NULL
		)
		LEFT JOIN M0080 ON(
			M0072.company_cd	=	M0080.company_cd
		AND M0072.item_cd		=	M0080.item_cd
		AND M0080.del_datetime IS NULL
		AND M0072.company_cd 	= M0070.company_cd
		)
		LEFT JOIN M0081 ON(
			M0072.company_cd	=	M0081.company_cd
		AND M0072.item_cd		=	M0081.item_cd
		AND M0072.number_item	=	M0081.detail_no
		AND M0081.del_datetime IS NULL
		AND M0072.company_cd 	= M0070.company_cd
		)
		LEFT JOIN M0074 ON (
			M0074.employee_cd = M0070.employee_cd 
		AND M0074.company_cd = M0070.company_cd 
		AND M0074.del_datetime IS NULL
		)
		LEFT JOIN M0083 ON (
			M0083.employee_cd = M0070.employee_cd 
		AND M0083.company_cd = M0070.company_cd 
		AND M0083.del_datetime IS NULL
		)
		LEFT JOIN M0092 ON (
			M0092.employee_cd = M0070.employee_cd 
		AND M0092.company_cd = M0070.company_cd 
		AND M0092.del_datetime IS NULL
		)
		WHERE M0070.company_cd = @P_company_cd
		AND M0070.del_datetime IS NULL
	END
	ELSE
	BEGIN
		INSERT INTO #RESULT
		SELECT
			1																		AS id
		,	CASE
				WHEN (M0070.company_out_dt IS NOT NULL AND (M0070.company_out_dt <  @w_today)) THEN IIF(@P_language = 'en', 'Retirement', '退職')
				WHEN M0070.company_out_dt IS NULL THEN ''
			END AS retirement_category		
		,	ISNULL(M0070.employee_cd,'')											AS employee_cd		
		,	SPACE(0) 	 															AS employee_last_nm
		,	SPACE(0) 																AS employee_first_nm
		,	ISNULL(M0070.employee_nm,'')											AS employee_nm
		,	SPACE(0) 																AS furigana
		,	SPACE(0) 																AS gender		
		,	SPACE(0) 																AS	mail	
		,	SPACE(0) 																AS birth_date
		,	SPACE(0) 																AS company_in_dt	
		,	SPACE(0) 																AS company_out_dt
		,	SPACE(0) 																AS retirement_reason_typ
		,	SPACE(0) 																AS retirement_reason
		,	SPACE(0) 																AS evaluated_typ
		,	SPACE(0)  																AS [1on1_typ]
		,	SPACE(0)  																AS multireview_typ
		,	SPACE(0)  																AS report_typ
		,	SPACE(0) 																AS office_cd		
		,	ISNULL(M0070.belong_cd1,0)												AS belong_cd1		
		,	ISNULL(M0070.belong_cd2,0) 												AS belong_cd2
		,	ISNULL(M0070.belong_cd3,0)												AS belong_cd3
		,	ISNULL(M0070.belong_cd4,0)												AS belong_cd4
		,	ISNULL(M0070.belong_cd5,0)												AS belong_cd5	
		,	ISNULL(M0070.job_cd,0)													AS job_cd	
		,	ISNULL(M0070.position_cd,0)												AS position_cd	
		,	ISNULL(M0070.employee_typ,0)											AS employee_typ
		,	ISNULL(M0070.grade,0)													AS grade
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	ISNULL(M0074.blood_type,0)											AS blood_type
		,	ISNULL(M0074.headquarters_prefectures,0)	 						AS headquarters_prefectures
		,	ISNULL(M0074.headquarters_other,'')									AS headquarters_other
		,	ISNULL(M0074.possibility_transfer,'') 								AS possibility_transfer	
		,	ISNULL(M0074.nationality,'') 										AS nationality
		,	ISNULL(M0074.residence_card_no,'') 									AS residence_card_no
		,	ISNULL(M0074.status_residence,0) 									AS status_residence
		,	FORMAT(NULLIF(M0074.expiry_date,'1900-01-01'), 'yyyy/MM/dd') 		AS	expiry_date
		,	ISNULL(M0074.permission_activities,0) 								AS permission_activities
		,	ISNULL(M0074.disability_classification,0) 							AS disability_classification	
		,	FORMAT(NULLIF(M0074.disability_recognition_date,'1900-01-01'), 'yyyy/MM/dd') AS	disability_recognition_date
		,	ISNULL(M0074.disability_content,'') 								AS disability_content
		,	ISNULL(M0074.common_name,'') 										AS common_name
		,	ISNULL(M0074.common_name_furigana,'') 								AS common_name_furigana
		,	ISNULL(M0074.maiden_name,'') 										AS maiden_name
		,	ISNULL(M0074.maiden_name_furigana,'') 								AS maiden_name_furigana
		,	ISNULL(M0074.business_name,'') 										AS  business_name	
		,	ISNULL(M0074.business_name_furigana,'') 							AS business_name_furigana
		,	ISNULL(M0074.base_style,0) 											AS base_style
		,	ISNULL(M0074.sub_style,0) 											AS sub_style
		,	ISNULL(M0074.driver_point,0) 										AS driver_point
		,	ISNULL(M0074.analytical_point,0) 									AS analytical_point
		,	ISNULL(M0074.expressive_point,0) 									AS expressive_point
		,	ISNULL(M0074.amiable_point,0) 
		,	SPACE(0) -- 75
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- 76
		,	SPACE(0)
		,	SPACE(0)			
		,	SPACE(0)		
		,	SPACE(0)			
		,	SPACE(0)	
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)--77
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) --78
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	ISNULL(M0083.owning_house_kbn,0)									AS owning_house_kbn
		,	ISNULL(M0083.head_household,0)	 									AS head_household
		,	ISNULL(M0083.post_code,'')											AS post_code		
		,	ISNULL(M0083.address1,'')											AS address1	
		,	ISNULL(M0083.address3,'')											AS address3
		,	ISNULL(M0083.personal_phone_number,'')								AS personal_phone_number			
		,	ISNULL(M0083.personal_email_address,'')								AS personal_email_address		
		,	ISNULL(M0083.emergency_contact_name,'')								AS emergency_contact_name		
		,	ISNULL(M0083.emergency_contact_relationship,'')						AS emergency_contact_relationship			
		,	ISNULL(M0083.emergency_contact_post_code,'') 						AS emergency_contact_post_code
		,	ISNULL(M0083.emergency_contact_addres1,'') 							AS emergency_contact_addres1
		,	ISNULL(M0083.emergency_contact_addres3,'') 							AS emergency_contact_addres3
		,	ISNULL(M0083.emergency_contact_phone_number,'')						AS emergency_contact_phone_number
		,	SPACE(0)--84
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) --85
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) --87
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) --88
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) --90
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	REPLACE(RTRIM(LTRIM(ISNULL(M0092.base_salary,0))),'.00','')					AS base_salary
		,	REPLACE(RTRIM(LTRIM(ISNULL(M0092.basic_annual_income,0))),'.00','')			AS basic_annual_income
		,	SPACE(0) --93
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- tab 3
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	ISNULL(M0060.employee_typ_nm,'')									AS employee_typ_nm -- eq0100
		,	ISNULL(M0020_01.organization_nm,'')									AS organization_nm_1 
		,	ISNULL(M0020_02.organization_nm,'')									AS organization_nm_2 
		,	ISNULL(M0020_03.organization_nm,'')									AS organization_nm_3 
		,	ISNULL(M0020_04.organization_nm,'')									AS organization_nm_4 
		,	ISNULL(M0020_05.organization_nm,'')									AS organization_nm_5 
		,	ISNULL(M0030.job_nm,'')												AS job_nm
		,	ISNULL(M0040.position_nm,'')										AS position_nm
		,	ISNULL(M0050.grade_nm,'')											AS grade_nm
		,	IIF(@P_language = 'en', ISNULL(L0010_52.name_english,''), ISNULL(L0010_52.name,'')) 										AS blood_type_nm
		,	ISNULL(L0011.name,'')																										AS headquarters_prefectures_nm
		,	IIF(@P_language = 'en', ISNULL(L0010_53.name_english,''), ISNULL(L0010_53.name,''))											AS possibility_transfer_nm
		,	IIF(@P_language = 'en', ISNULL(L0010_54.name_english,''), ISNULL(L0010_54.name,''))											AS status_residence_nm
		,	IIF(@P_language = 'en', ISNULL(L0010_55.name_english,''), ISNULL(L0010_55.name,''))											AS permission_activities_nm
		,	IIF(@P_language = 'en', ISNULL(L0010_56.name_english,''), ISNULL(L0010_56.name,''))											AS disability_classification_nm
		,	IIF(@P_language = 'en', ISNULL(L0010_18_1.name_english,''), ISNULL(L0010_18_1.name,''))										AS base_style_nm
		,	IIF(@P_language = 'en', ISNULL(L0010_18_2.name_english,''), ISNULL(L0010_18_2.name,''))										AS sub_style_nm
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	IIF(@P_language = 'en', ISNULL(L0010_62.name_english,''), ISNULL(L0010_62.name,''))											AS owning_house_kbn_nm
		,	ISNULL(M0083.address2,'') 																									AS address2
		,	ISNULL(M0083.home_phone_number,'') 																							AS home_phone_number
		,	FORMAT(NULLIF(M0083.emergency_contact_birthday,'1900-01-01'), 'yyyy/MM/dd') 												AS emergency_contact_birthday
		,	ISNULL(M0083.emergency_contact_addres2,'') 																					AS emergency_contact_addres2
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		,	SPACE(0) 
		FROM M0070
		LEFT JOIN M0074 ON (
			M0074.employee_cd = M0070.employee_cd 
		AND M0074.company_cd = M0070.company_cd 
		AND M0074.del_datetime IS NULL
		)
		LEFT JOIN M0083 ON (
			M0083.employee_cd = M0070.employee_cd 
		AND M0083.company_cd = M0070.company_cd 
		AND M0083.del_datetime IS NULL
		)
		LEFT JOIN M0092 ON (
			M0092.employee_cd = M0070.employee_cd 
		AND M0092.company_cd = M0070.company_cd 
		AND M0092.del_datetime IS NULL
		)
		--eq0100: 
		LEFT JOIN M0060 ON (
			M0070.employee_typ		= M0060.employee_typ 
		AND M0070.company_cd		= M0060.company_cd
		AND M0060.del_datetime IS NULL
		)
		LEFT JOIN M0030 ON (
			M0070.job_cd			= M0030.job_cd 
		AND M0070.company_cd		= M0030.company_cd
		AND M0030.del_datetime IS NULL
		)
		LEFT JOIN M0040 ON (
			M0070.position_cd			= M0040.position_cd 
		AND M0070.company_cd			= M0040.company_cd
		AND M0040.del_datetime IS NULL
		)
		LEFT JOIN M0050 ON (
			M0070.grade				= M0050.grade 
		AND M0070.company_cd		= M0050.company_cd
		AND M0050.del_datetime IS NULL
		)
		LEFT JOIN M0020 AS M0020_01 ON (
			M0070.belong_cd1		= M0020_01.organization_cd_1 
		AND M0020_01.organization_typ	= 1
		AND M0070.company_cd		= M0020_01.company_cd
		AND M0020_01.del_datetime IS NULL
		)
		LEFT JOIN M0020 AS M0020_02 ON (
			M0070.belong_cd1		= M0020_02.organization_cd_1 
		AND M0070.belong_cd2		= M0020_02.organization_cd_2 
		AND M0020_02.organization_typ	= 2
		AND M0070.company_cd		= M0020_02.company_cd
		AND M0020_02.del_datetime IS NULL
		)
		LEFT JOIN M0020 AS M0020_03 ON (
			M0070.belong_cd1		= M0020_03.organization_cd_1 
		AND M0070.belong_cd2		= M0020_03.organization_cd_2 
		AND M0070.belong_cd3		= M0020_03.organization_cd_3 
		AND M0020_03.organization_typ	= 3
		AND M0070.company_cd		= M0020_03.company_cd
		AND M0020_03.del_datetime IS NULL
		)
		LEFT JOIN M0020 AS M0020_04 ON (
			M0070.belong_cd1		= M0020_04.organization_cd_1 
		AND M0070.belong_cd2		= M0020_04.organization_cd_2 
		AND M0070.belong_cd3		= M0020_04.organization_cd_3 
		AND M0070.belong_cd4		= M0020_04.organization_cd_4 
		AND M0020_04.organization_typ	= 4
		AND M0070.company_cd		= M0020_04.company_cd
		AND M0020_04.del_datetime IS NULL
		)
		LEFT JOIN M0020 AS M0020_05 ON (
			M0070.belong_cd1		= M0020_05.organization_cd_1 
		AND M0070.belong_cd2		= M0020_05.organization_cd_2 
		AND M0070.belong_cd3		= M0020_05.organization_cd_3 
		AND M0070.belong_cd4		= M0020_05.organization_cd_4 
		AND M0070.belong_cd5		= M0020_05.organization_cd_5 
		AND M0020_05.organization_typ	= 5
		AND M0070.company_cd		= M0020_05.company_cd
		AND M0020_05.del_datetime IS NULL
		)
		--eq0100: tab 1
		LEFT JOIN L0010 AS L0010_52 ON (
			M0074.blood_type		= L0010_52.number_cd 
		AND L0010_52.name_typ 		= 52
		AND L0010_52.del_datetime IS NULL
		)
		LEFT JOIN L0011 ON (
			M0074.headquarters_prefectures	= L0011.number_cd 
		AND L0011.del_datetime IS NULL
		)
		LEFT JOIN L0010 AS L0010_53 ON (
			M0074.possibility_transfer		= L0010_53.number_cd 
		AND L0010_53.name_typ 				= 53
		AND L0010_53.del_datetime IS NULL
		)
		LEFT JOIN L0010 AS L0010_54 ON (
			M0074.status_residence		= L0010_54.number_cd 
		AND L0010_54.name_typ 			= 54
		AND L0010_54.del_datetime IS NULL
		)
		LEFT JOIN L0010 AS L0010_55 ON (
			M0074.permission_activities		= L0010_55.number_cd 
		AND L0010_55.name_typ 				= 55
		AND L0010_55.del_datetime IS NULL
		)
		LEFT JOIN L0010 AS L0010_56 ON (
			M0074.disability_classification		= L0010_56.number_cd 
		AND L0010_56.name_typ 					= 56
		AND L0010_56.del_datetime IS NULL
		)
		LEFT JOIN L0010 AS L0010_18_1 ON (
			M0074.base_style		= L0010_18_1.number_cd 
		AND L0010_18_1.name_typ 	= 18
		AND L0010_18_1.del_datetime IS NULL
		)
		LEFT JOIN L0010 AS L0010_18_2 ON (
			M0074.sub_style			= L0010_18_2.number_cd 
		AND L0010_18_2.name_typ 	= 18
		AND L0010_18_2.del_datetime IS NULL
		)
		--eq0100: tab 7
		LEFT JOIN L0010 AS L0010_62 ON (
			M0083.owning_house_kbn		= L0010_62.number_cd 
		AND L0010_62.name_typ 			= 62
		AND L0010_62.del_datetime IS NULL
		)
		WHERE M0070.company_cd = @P_company_cd
		AND M0070.del_datetime IS NULL
	END
	
	DELETE #RESULT FROM #RESULT 
	LEFT OUTER JOIN #M0070H ON(
		#RESULT.employee_cd = #M0070H.employee_cd
	)
	WHERE
		#M0070H.employee_cd IS NULL
	AND #RESULT.id <>0


	-- tab 2: M0075
	-- FUNCTION_ID M0070_02
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_02')
	BEGIN
		UPDATE #RESULT SET 
			detail_no_75                = #TEMP_M0075.detail_no
		,   qualification_cd            = #TEMP_M0075.qualification_cd
		,   qualification_nm            = #TEMP_M0075.qualification_nm
		,   qualification_typ           = #TEMP_M0075.qualification_typ
		,   qualification_typ_nm        = #TEMP_M0075.qualification_typ_nm
		,   headquarters_other_75       = #TEMP_M0075.headquarters_other
		,   possibility_transfer_75     = #TEMP_M0075.possibility_transfer
		,   remarks                     = #TEMP_M0075.remarks
		FROM #RESULT
		INNER JOIN #TEMP_M0075 ON (
			#RESULT.id				=	#TEMP_M0075.id
		AND #RESULT.employee_cd	    =	#TEMP_M0075.employee_cd
		)
		--
		INSERT INTO #RESULT
		SELECT 
			#TEMP_M0075.id
		,	#TEMP_M0075.retirement_category
		,	#TEMP_M0075.employee_cd
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	#TEMP_M0075.detail_no				
		,	#TEMP_M0075.qualification_cd			
		,	#TEMP_M0075.qualification_typ			
		,	#TEMP_M0075.headquarters_other		
		,	#TEMP_M0075.possibility_transfer		
		,	#TEMP_M0075.remarks						
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- tab 3
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- eq0100
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	#TEMP_M0075.qualification_nm
		,	#TEMP_M0075.qualification_typ_nm
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		FROM #TEMP_M0075
		LEFT OUTER JOIN #RESULT on (
			#TEMP_M0075.id				=	#RESULT.id
		AND #TEMP_M0075.employee_cd		=	#RESULT.employee_cd
		)
		WHERE	
			#RESULT.id IS NULL
	END

	-- tab 4: M0076
	-- FUNCTION_ID M0070_03
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_03')
	BEGIN
		UPDATE #RESULT SET 
			detail_no_76                = #TEMP_M0076.detail_no
		,   training_cd            		= #TEMP_M0076.training_cd
		,   training_nm           		= #TEMP_M0076.training_nm
		,   training_category_cd       	= #TEMP_M0076.training_category_cd
		,   training_category_nm       	= #TEMP_M0076.training_category_nm
		,   training_course_format_cd   = #TEMP_M0076.training_course_format_cd
		,   training_course_format_nm   = #TEMP_M0076.training_course_format_nm
		,   lecturer_name               = #TEMP_M0076.lecturer_name
		,   training_date_from          = #TEMP_M0076.training_date_from
		,   training_date_to            = #TEMP_M0076.training_date_to
		,   training_status             = #TEMP_M0076.training_status
		,   training_status_nm          = #TEMP_M0076.training_status_nm
		,   passing_date                = #TEMP_M0076.passing_date
		,   report_submission           = #TEMP_M0076.report_submission
		,   report_submission_nm        = #TEMP_M0076.report_submission_nm
		,   report_submission_date      = #TEMP_M0076.report_submission_date
		,   report_storage_location     = #TEMP_M0076.report_storage_location
		,   nationality_76              = #TEMP_M0076.nationality
		FROM #RESULT
		INNER JOIN #TEMP_M0076 ON (
			#RESULT.id				=	#TEMP_M0076.id
		AND #RESULT.employee_cd	    =	#TEMP_M0076.employee_cd
		)
		--
		INSERT INTO #RESULT
		SELECT 
			#TEMP_M0076.id
		,	#TEMP_M0076.retirement_category	
		,	#TEMP_M0076.employee_cd	
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- 75
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	#TEMP_M0076.detail_no
		,	#TEMP_M0076.training_cd
		,	#TEMP_M0076.training_nm
		,	#TEMP_M0076.training_category_cd
		,	#TEMP_M0076.training_course_format_cd
		,	#TEMP_M0076.lecturer_name
		,	#TEMP_M0076.training_date_from
		,	#TEMP_M0076.training_date_to
		,	#TEMP_M0076.training_status
		,	#TEMP_M0076.passing_date
		,	#TEMP_M0076.report_submission
		,	#TEMP_M0076.report_submission_date
		,	#TEMP_M0076.report_storage_location
		,	#TEMP_M0076.nationality
		,	SPACE(0)--77
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) --78
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)--84
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) --85
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) --87
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) --88
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) --90
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) --93
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- tab 3
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- eq0100
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	#TEMP_M0076.training_category_nm
		,	#TEMP_M0076.training_course_format_nm
		,	#TEMP_M0076.training_status_nm
		,	#TEMP_M0076.report_submission_nm
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		FROM #TEMP_M0076
		LEFT OUTER JOIN #RESULT on (
			#TEMP_M0076.id				=	#RESULT.id
		AND #TEMP_M0076.employee_cd		=	#RESULT.employee_cd
		)
		WHERE	
			#RESULT.id IS NULL
	END
	-- tab 5: M0077
	-- FUNCTION_ID M0070_04
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_04')
	BEGIN
		UPDATE #RESULT SET 
			work_history_kbn_77         = #TEMP_M0077.work_history_kbn
		,   detail_no_77                = #TEMP_M0077.detail_no
		,   item_id_77                  = #TEMP_M0077.item_id
		,   item_title                  = #TEMP_M0077.item_title
		,   date_from                   = #TEMP_M0077.date_from
		,   date_to                     = #TEMP_M0077.date_to
		,   text_item                   = #TEMP_M0077.text_item
		,   select_item                 = #TEMP_M0077.select_item
		,   selected_items_nm           = #TEMP_M0077.selected_items_nm
		,   number_item                 = #TEMP_M0077.number_item
		FROM #RESULT
		INNER JOIN #TEMP_M0077 ON (
			#RESULT.id				=	#TEMP_M0077.id
		AND #RESULT.employee_cd	    =	#TEMP_M0077.employee_cd
		)
		--
		INSERT INTO #RESULT
		SELECT 
			#TEMP_M0077.id
		,	#TEMP_M0077.retirement_category
		,	#TEMP_M0077.employee_cd
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	SPACE(0)			
		,	#TEMP_M0077.work_history_kbn		
		,	#TEMP_M0077.detail_no				
		,	#TEMP_M0077.item_id					
		,	#TEMP_M0077.item_title					
		,	#TEMP_M0077.date_from					
		,	#TEMP_M0077.date_to						
		,	#TEMP_M0077.text_item					
		,	#TEMP_M0077.select_item					
		,	#TEMP_M0077.number_item					
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- tab 3
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- eq0100
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	#TEMP_M0077.selected_items_nm
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		FROM #TEMP_M0077
		LEFT OUTER JOIN #RESULT on (
			#TEMP_M0077.id				=	#RESULT.id
		AND #TEMP_M0077.employee_cd		=	#RESULT.employee_cd
		)
		WHERE	
			#RESULT.id IS NULL
	END

	-- tab 6: M0078
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_05')
	BEGIN
		UPDATE #RESULT SET 
			final_education_kbn         = #TEMP_M0078.final_education_kbn
		,	final_education_kbn_nm      = #TEMP_M0078.final_education_kbn_nm
		,   final_education_other       = #TEMP_M0078.final_education_other
		,   detail_no_78       			= #TEMP_M0078.detail_no
		,   graduation_year             = #TEMP_M0078.graduation_year
		,   graduation_school_cd        = #TEMP_M0078.graduation_school_cd
		,   school_name        			= #TEMP_M0078.school_name
		,   graduation_school_other     = #TEMP_M0078.graduation_school_other
		,   faculty                     = #TEMP_M0078.faculty
		,   major                       = #TEMP_M0078.major
		FROM #RESULT
		INNER JOIN #TEMP_M0078 ON (
			#RESULT.id				=	#TEMP_M0078.id
		AND #RESULT.employee_cd	    =	#TEMP_M0078.employee_cd
		)
		--
		INSERT INTO #RESULT
		SELECT 
			#TEMP_M0078.id
		,	#TEMP_M0078.retirement_category
		,	#TEMP_M0078.employee_cd
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	SPACE(0)				
		,	#TEMP_M0078.final_education_kbn					
		,	#TEMP_M0078.final_education_other				
		,	#TEMP_M0078.detail_no				
		,	#TEMP_M0078.graduation_year						
		,	#TEMP_M0078.graduation_school_cd				
		,	#TEMP_M0078.graduation_school_other				
		,	#TEMP_M0078.faculty								
		,	#TEMP_M0078.major								
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- tab 3
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- eq0100
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	#TEMP_M0078.final_education_kbn_nm
		,	#TEMP_M0078.school_name
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)	
		FROM #TEMP_M0078
		LEFT OUTER JOIN #RESULT on (
			#TEMP_M0078.id				=	#RESULT.id
		AND #TEMP_M0078.employee_cd		=	#RESULT.employee_cd
		)
		WHERE	
			#RESULT.id IS NULL
	END

	-- tab 8: M0084
	-- FUNCTION_ID M0070_07
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_07')
	BEGIN
		UPDATE #RESULT SET 
			detail_no_84                        = #TEMP_M0084.detail_no
		,   commuting_method                    = #TEMP_M0084.commuting_method
		,   commuting_method_nm                 = #TEMP_M0084.commuting_method_nm
		,   commuting_distance                  = #TEMP_M0084.commuting_distance
		,   drivinglicense_renewal_deadline     = #TEMP_M0084.drivinglicense_renewal_deadline
		,   commuting_method_detail             = #TEMP_M0084.commuting_method_detail
		,   departure_point                     = #TEMP_M0084.departure_point
		,   arrival_point                       = #TEMP_M0084.arrival_point
		,   commuter_ticket_classification      = #TEMP_M0084.commuter_ticket_classification
		,   commuter_ticket_classification_nm   = #TEMP_M0084.commuter_ticket_classification_nm
		,   commuting_expenses                  = #TEMP_M0084.commuting_expenses
		FROM #RESULT
		INNER JOIN #TEMP_M0084 ON (
			#RESULT.id				=	#TEMP_M0084.id
		AND #RESULT.employee_cd	    =	#TEMP_M0084.employee_cd
		)
		--
		INSERT INTO #RESULT
		SELECT 
			#TEMP_M0084.id
		,	#TEMP_M0084.retirement_category
		,	#TEMP_M0084.employee_cd
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	#TEMP_M0084.detail_no							
		,	#TEMP_M0084.commuting_method						
		,	#TEMP_M0084.commuting_distance						
		,	#TEMP_M0084.drivinglicense_renewal_deadline			
		,	#TEMP_M0084.commuting_method_detail					
		,	#TEMP_M0084.departure_point							
		,	#TEMP_M0084.arrival_point							
		,	#TEMP_M0084.commuter_ticket_classification			
		,	#TEMP_M0084.commuting_expenses						
		,	SPACE(0)						
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- tab 3
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- eq0100
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	#TEMP_M0084.commuting_method_nm
		,	#TEMP_M0084.commuter_ticket_classification_nm
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		FROM #TEMP_M0084
		LEFT OUTER JOIN #RESULT on (
			#TEMP_M0084.id				=	#RESULT.id
		AND #TEMP_M0084.employee_cd		=	#RESULT.employee_cd
		)
		WHERE	
			#RESULT.id IS NULL
	END

	-- tab 9: M0085 M0086
	-- FUNCTION_ID M0070_08
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_08')
	BEGIN
		UPDATE #RESULT SET 
			marital_status                          = #TEMP_M0086.marital_status
		,	marital_status_nm                       = #TEMP_M0086.marital_status_nm
		,   detail_no_86                            = #TEMP_M0086.detail_no
		,   full_name                               = #TEMP_M0086.full_name
		,   full_name_furigana                      = #TEMP_M0086.full_name_furigana
		,   relationship                            = #TEMP_M0086.relationship
		,   gender_86                               = #TEMP_M0086.gender
		,   gender_nm                               = #TEMP_M0086.gender_nm
		,   birthday                                = #TEMP_M0086.birthday
		,   residential_classification              = #TEMP_M0086.residential_classification
		,   residential_classification_nm           = #TEMP_M0086.residential_classification_nm
		,   profession                              = #TEMP_M0086.profession
		FROM #RESULT
		INNER JOIN #TEMP_M0086 ON (
			#RESULT.id				=	#TEMP_M0086.id
		AND #RESULT.employee_cd	    =	#TEMP_M0086.employee_cd
		)
		--
		INSERT INTO #RESULT
		SELECT 
			#TEMP_M0086.id
		,	#TEMP_M0086.retirement_category
		,	#TEMP_M0086.employee_cd
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	#TEMP_M0086.marital_status							
		,	#TEMP_M0086.detail_no							
		,	#TEMP_M0086.full_name								
		,	#TEMP_M0086.full_name_furigana						
		,	#TEMP_M0086.relationship							
		,	#TEMP_M0086.gender								
		,	#TEMP_M0086.birthday								
		,	#TEMP_M0086.residential_classification				
		,	#TEMP_M0086.profession								
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- tab 3
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- eq0100
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	#TEMP_M0086.marital_status_nm
		,	#TEMP_M0086.gender_nm
		,	#TEMP_M0086.residential_classification_nm
		,	SPACE(0)
		FROM #TEMP_M0086
		LEFT OUTER JOIN #RESULT on (
			#TEMP_M0086.id				=	#RESULT.id
		AND #TEMP_M0086.employee_cd		=	#RESULT.employee_cd
		)
		WHERE	
			#RESULT.id IS NULL
	END

	-- tab 10: M0087
	-- FUNCTION_ID M0070_09
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_09')
	BEGIN
		UPDATE #RESULT SET 
			detail_no_87                            = #TEMP_M0087.detail_no
		,   leave_absence_startdate                 = #TEMP_M0087.leave_absence_startdate
		,   leave_absence_enddate                   = #TEMP_M0087.leave_absence_enddate
		,   remarks_87                              = #TEMP_M0087.remarks
		FROM #RESULT
		INNER JOIN #TEMP_M0087 ON (
			#RESULT.id				=	#TEMP_M0087.id
		AND #RESULT.employee_cd	    =	#TEMP_M0087.employee_cd
		)
		--
		INSERT INTO #RESULT
		SELECT 
			#TEMP_M0087.id
		,	#TEMP_M0087.retirement_category
		,	#TEMP_M0087.employee_cd
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	SPACE(0)								
		,	#TEMP_M0087.detail_no							
		,	#TEMP_M0087.leave_absence_startdate					
		,	#TEMP_M0087.leave_absence_enddate					
		,	#TEMP_M0087.remarks		
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- tab 3
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- eq0100
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		FROM #TEMP_M0087
		LEFT OUTER JOIN #RESULT on (
			#TEMP_M0087.id				=	#RESULT.id
		AND #TEMP_M0087.employee_cd		=	#RESULT.employee_cd
		)
		WHERE	
			#RESULT.id IS NULL
	END

	-- tab 11: M0088
	-- FUNCTION_ID M0070_10
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_10')
	BEGIN
		UPDATE #RESULT SET 
			employment_contract_no       = #TEMP_M0088.employment_contract_no
		,   detail_no_88                 = #TEMP_M0088.detail_no
		,   start_date                   = #TEMP_M0088.start_date
		,   expiration_date              = #TEMP_M0088.expiration_date
		,   contract_renewal_kbn         = #TEMP_M0088.contract_renewal_kbn
		,   reason_resignation           = #TEMP_M0088.reason_resignation
		,   remarks_88                   = #TEMP_M0088.remarks
		FROM #RESULT
		INNER JOIN #TEMP_M0088 ON (
			#RESULT.id				=	#TEMP_M0088.id
		AND #RESULT.employee_cd	    =	#TEMP_M0088.employee_cd
		)
		--
		INSERT INTO #RESULT
		SELECT 
			#TEMP_M0088.id
		,	#TEMP_M0088.retirement_category
		,	#TEMP_M0088.employee_cd
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	#TEMP_M0088.employment_contract_no					
		,	#TEMP_M0088.detail_no							
		,	#TEMP_M0088.start_date								
		,	#TEMP_M0088.expiration_date							
		,	#TEMP_M0088.contract_renewal_kbn					
		,	#TEMP_M0088.reason_resignation						
		,	#TEMP_M0088.remarks								
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- tab 3
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- eq0100
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		FROM #TEMP_M0088
		LEFT OUTER JOIN #RESULT on (
			#TEMP_M0088.id				=	#RESULT.id
		AND #TEMP_M0088.employee_cd		=	#RESULT.employee_cd
		)
		WHERE	
			#RESULT.id IS NULL
	END

	-- tab 12: M0090 M0091
	-- FUNCTION_ID M0070_11
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_11')
	BEGIN
		UPDATE #RESULT SET 
			employment_insurance_no                     = #TEMP_M0091.employment_insurance_no
		,   basic_pension_no                            = #TEMP_M0091.basic_pension_no
		,   employment_insurance_status                 = #TEMP_M0091.employment_insurance_status
		,   health_insurance_status                     = #TEMP_M0091.health_insurance_status
		,   health_insurance_reference_no               = #TEMP_M0091.health_insurance_reference_no
		,   employees_pension_insurance_status          = #TEMP_M0091.employees_pension_insurance_status
		,   employees_pension_reference_no              = #TEMP_M0091.employees_pension_reference_no
		,   welfare_pension_status                      = #TEMP_M0091.welfare_pension_status
		,   employees_pension_member_no                 = #TEMP_M0091.employees_pension_member_no
		,   social_insurance_kbn                        = #TEMP_M0091.social_insurance_kbn
		,   detail_no_91                                = #TEMP_M0091.detail_no
		,   joining_date                                = #TEMP_M0091.joining_date
		,   date_of_loss                                = #TEMP_M0091.date_of_loss
		,   reason_for_loss_kbn                         = #TEMP_M0091.reason_for_loss_kbn
		,   reason_for_loss                             = #TEMP_M0091.reason_for_loss
		FROM #RESULT
		INNER JOIN #TEMP_M0091 ON (
			#RESULT.id				=	#TEMP_M0091.id
		AND #RESULT.employee_cd	    =	#TEMP_M0091.employee_cd
		)
		--
		INSERT INTO #RESULT
		SELECT 
			#TEMP_M0091.id
		,	#TEMP_M0091.retirement_category
		,	#TEMP_M0091.employee_cd
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	SPACE(0)							
		,	#TEMP_M0091.employment_insurance_no					
		,	#TEMP_M0091.basic_pension_no						
		,	#TEMP_M0091.employment_insurance_status				
		,	#TEMP_M0091.health_insurance_status					
		,	#TEMP_M0091.health_insurance_reference_no			
		,	#TEMP_M0091.employees_pension_insurance_status		
		,	#TEMP_M0091.employees_pension_reference_no			
		,	#TEMP_M0091.welfare_pension_status					
		,	#TEMP_M0091.employees_pension_member_no				
		,	#TEMP_M0091.social_insurance_kbn					
		,	#TEMP_M0091.detail_no							
		,	#TEMP_M0091.joining_date							
		,	#TEMP_M0091.date_of_loss							
		,	#TEMP_M0091.reason_for_loss_kbn						
		,	#TEMP_M0091.reason_for_loss							
		,	SPACE(0)								
		,	SPACE(0)						
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- tab 3
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- eq0100
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		FROM #TEMP_M0091
		LEFT OUTER JOIN #RESULT on (
			#TEMP_M0091.id				=	#RESULT.id
		AND #TEMP_M0091.employee_cd		=	#RESULT.employee_cd
		)
		WHERE	
			#RESULT.id IS NULL
	END

	-- tab 14: M0093
	-- FUNCTION_ID M0070_13
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_13')
	BEGIN
		UPDATE #RESULT SET 
			detail_no_93                  = #TEMP_M0093.detail_no
		,   reward_punishment_typ         = #TEMP_M0093.reward_punishment_typ
		,   reward_punishment_typ_nm      = #TEMP_M0093.reward_punishment_typ_nm
		,   decision_date                 = #TEMP_M0093.decision_date
		,   reason                        = #TEMP_M0093.reason
		,   remarks_93                    = #TEMP_M0093.remarks
		FROM #RESULT
		INNER JOIN #TEMP_M0093 ON (
			#RESULT.id				=	#TEMP_M0093.id
		AND #RESULT.employee_cd	    =	#TEMP_M0093.employee_cd
		)
		--
		INSERT INTO #RESULT
		SELECT 
			#TEMP_M0093.id
		,	#TEMP_M0093.retirement_category
		,	#TEMP_M0093.employee_cd
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	#TEMP_M0093.detail_no							
		,	#TEMP_M0093.reward_punishment_typ					
		,	#TEMP_M0093.decision_date							
		,	#TEMP_M0093.reason									
		,	#TEMP_M0093.remarks
		,	SPACE(0) -- tab 3
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0) -- eq0100
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	#TEMP_M0093.reward_punishment_typ_nm
		FROM #TEMP_M0093
		LEFT OUTER JOIN #RESULT on (
			#TEMP_M0093.id				=	#RESULT.id
		AND #TEMP_M0093.employee_cd		=	#RESULT.employee_cd
		)
		WHERE	
			#RESULT.id IS NULL
	END
	-- tab 3: F0201
	-- FUNCTION_ID = blank
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = '' AND @w_type = 1)
	BEGIN
		UPDATE #RESULT SET 
			fiscal_year                  		= #TEMP_F0201.fiscal_year
		,   treatment_applications_no         	= #TEMP_F0201.treatment_applications_no
		,   treatment_applications_nm           = #TEMP_F0201.treatment_applications_nm
		,   point_sum                        	= #TEMP_F0201.point_sum
		,   adjust_point                    	= #TEMP_F0201.adjust_point
		,   rank_cd                    			= #TEMP_F0201.rank_cd
		,   rank_nm                    			= #TEMP_F0201.rank_nm
		,   comment                    			= #TEMP_F0201.comment
		FROM #RESULT
		INNER JOIN #TEMP_F0201 ON (
			#RESULT.id				=	#TEMP_F0201.id
		AND #RESULT.employee_cd	    =	#TEMP_F0201.employee_cd
		)
		--
		INSERT INTO #RESULT
		SELECT 
			#TEMP_F0201.id
		,	#TEMP_F0201.retirement_category
		,	#TEMP_F0201.employee_cd
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)					
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	SPACE(0)		
		,	#TEMP_F0201.fiscal_year -- tab 3
		,	#TEMP_F0201.treatment_applications_no
		,	#TEMP_F0201.treatment_applications_nm
		,	#TEMP_F0201.point_sum
		,	#TEMP_F0201.adjust_point
		,	#TEMP_F0201.rank_cd
		,	#TEMP_F0201.rank_nm
		,	#TEMP_F0201.comment
		,	SPACE(0) -- eq0100
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		FROM #TEMP_F0201
		LEFT OUTER JOIN #RESULT on (
			#TEMP_F0201.id				=	#RESULT.id
		AND #TEMP_F0201.employee_cd		=	#RESULT.employee_cd
		)
		WHERE	
			#RESULT.id IS NULL
	END

	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--  SELECT RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■\
	IF @w_type = 0 
	BEGIN
		SET @w_sql = '
		SELECT
			#RESULT.employee_cd
		,	#RESULT.employee_last_nm			
		,	#RESULT.employee_first_nm			
		,	#RESULT.employee_nm					
		,	#RESULT.furigana					
		,	#RESULT.gender						
		,	#RESULT.mail						
		,	#RESULT.birth_date					
		,	#RESULT.company_in_dt				
		,	#RESULT.company_out_dt				
		,	#RESULT.retirement_reason_typ		
		,	#RESULT.retirement_reason			
		,	#RESULT.evaluated_typ				
		,	#RESULT.oneonone_typ				
		,	#RESULT.multireview_typ				
		,	#RESULT.report_typ					
		,	#RESULT.office_cd					
		,	#RESULT.belong_cd1					
		,	#RESULT.belong_cd2					
		,	#RESULT.belong_cd3					
		,	#RESULT.belong_cd4					
		,	#RESULT.belong_cd5					
		,	#RESULT.job_cd						
		,	#RESULT.position_cd					
		,	#RESULT.employee_typ				
		,	#RESULT.grade						
		,	#RESULT.salary_grade				
		,	#RESULT.company_mobile_number		
		,	#RESULT.extension_number			
		,	#RESULT.sso_user					
		,	#RESULT._user_id					
		,	#RESULT.application_date			
		,	#RESULT.office_cd_71				
		,	#RESULT.belong_cd1_71				
		,	#RESULT.belong_cd2_71				
		,	#RESULT.belong_cd3_71				
		,	#RESULT.belong_cd4_71				
		,	#RESULT.belong_cd5_71				
		,	#RESULT.job_cd_71					
		,	#RESULT.position_cd_71				
		,	#RESULT.employee_typ_71				
		,	#RESULT.grade_71					
		,	#RESULT.item_cd						
		,	#RESULT.item_nm						
		,	#RESULT.item_no						
		,	#RESULT.character_item				
		,	#RESULT.number_item_2				
		,	#RESULT.date_item					
		,	#RESULT.number_item_4				
		,	#RESULT.detail_name_4				
		,	#RESULT.number_item_5				
		,	#RESULT.detail_name_5
		' +  SPACE(1)
	END
	ELSE 
	BEGIN
		SET @w_sql = '
		SELECT
			#RESULT.retirement_category	
		,	#RESULT.employee_cd			
		,	#RESULT.employee_nm					
		,	#RESULT.employee_typ				
		,	#RESULT.employee_typ_nm					
		,	#RESULT.belong_cd1					
		,	#RESULT.organization_nm_1					
		,	#RESULT.belong_cd2	
		,	#RESULT.organization_nm_2				
		,	#RESULT.belong_cd3	
		,	#RESULT.organization_nm_3				
		,	#RESULT.belong_cd4	
		,	#RESULT.organization_nm_4				
		,	#RESULT.belong_cd5	
		,	#RESULT.organization_nm_5				
		,	#RESULT.job_cd	
		,	#RESULT.job_nm						
		,	#RESULT.position_cd		
		,	#RESULT.position_nm				
		,	#RESULT.grade						
		,	#RESULT.grade_nm
		' +  SPACE(1)
	END
	
	-- FUNCTION_ID M0070_01
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_01')
	BEGIN
		IF @w_type = 0 
		BEGIN
			SET @w_sql = @w_sql +
			',	#RESULT.blood_type					
			,	#RESULT.headquarters_prefectures	
			,	#RESULT.headquarters_other			
			,	#RESULT.possibility_transfer		
			,	#RESULT.nationality					
			,	#RESULT.residence_card_no			
			,	#RESULT.status_residence			
			,	#RESULT.expiry_date					
			,	#RESULT.permission_activities		
			,	#RESULT.disability_classification	
			,	#RESULT.disability_recognition_date
			,	#RESULT.disability_content			
			,	#RESULT.common_name					
			,	#RESULT.common_name_furigana		
			,	#RESULT.maiden_name					
			,	#RESULT.maiden_name_furigana		
			,	#RESULT.business_name				
			,	#RESULT.business_name_furigana		
			,	#RESULT.base_style					
			,	#RESULT.sub_style					
			,	#RESULT.driver_point				
			,	#RESULT.analytical_point			
			,	#RESULT.expressive_point			
			,	#RESULT.amiable_point'
		END
		ELSE
		BEGIN
			SET @w_sql = @w_sql +
			',	#RESULT.blood_type					
			,	#RESULT.blood_type_nm	
			,	#RESULT.headquarters_prefectures	
			,	#RESULT.headquarters_prefectures_nm	
			,	#RESULT.headquarters_other			
			,	#RESULT.possibility_transfer		
			,	#RESULT.possibility_transfer_nm		
			,	#RESULT.nationality					
			,	#RESULT.residence_card_no			
			,	#RESULT.status_residence			
			,	#RESULT.status_residence_nm			
			,	#RESULT.expiry_date					
			,	#RESULT.permission_activities		
			,	#RESULT.permission_activities_nm		
			,	#RESULT.disability_classification	
			,	#RESULT.disability_classification_nm	
			,	#RESULT.disability_recognition_date
			,	#RESULT.disability_content			
			,	#RESULT.common_name					
			,	#RESULT.common_name_furigana		
			,	#RESULT.maiden_name					
			,	#RESULT.maiden_name_furigana		
			,	#RESULT.business_name				
			,	#RESULT.business_name_furigana		
			,	#RESULT.base_style					
			,	#RESULT.base_style_nm					
			,	#RESULT.sub_style					
			,	#RESULT.sub_style_nm					
			,	#RESULT.driver_point				
			,	#RESULT.analytical_point			
			,	#RESULT.expressive_point			
			,	#RESULT.amiable_point'
		END
	END
	-- FUNCTION_ID M0070_02
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_02')
	BEGIN
		IF @w_type = 0 
		BEGIN
			SET @w_sql = @w_sql + 
			',	#RESULT.detail_no_75				
			,	#RESULT.qualification_cd			
			,	#RESULT.qualification_typ			
			,	#RESULT.headquarters_other_75		
			,	#RESULT.possibility_transfer_75		
			,	#RESULT.remarks	'
			END
		ELSE
		BEGIN
			SET @w_sql = @w_sql + 
			',	#RESULT.detail_no_75				
			,	#RESULT.qualification_cd			
			,	#RESULT.qualification_nm			
			,	#RESULT.qualification_typ			
			,	#RESULT.qualification_typ_nm			
			,	#RESULT.headquarters_other_75		
			,	#RESULT.possibility_transfer_75		
			,	#RESULT.remarks	'
		END
	END
	-- FUNCTION_ID blank (tab 3)
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = '' AND @w_type = 1)
	BEGIN
		SET @w_sql = @w_sql + 
		',	#RESULT.fiscal_year							
        ,	#RESULT.treatment_applications_no					
        ,	#RESULT.treatment_applications_nm							
        ,	#RESULT.point_sum									
        ,	#RESULT.adjust_point
        ,	#RESULT.rank_cd
        ,	#RESULT.rank_nm
        ,	#RESULT.comment'
	END
	-- FUNCTION_ID M0070_03
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_03')
	BEGIN
		IF @w_type = 0 
		BEGIN
			SET @w_sql = @w_sql + 
			',	#RESULT.detail_no_76				
			,	#RESULT.training_cd					
			,	#RESULT.training_nm					
			,	#RESULT.training_category_cd		
			,	#RESULT.training_course_format_cd	
			,	#RESULT.lecturer_name				
			,	#RESULT.training_date_from			
			,	#RESULT.training_date_to			
			,	#RESULT.training_status				
			,	#RESULT.passing_date				
			,	#RESULT.report_submission			
			,	#RESULT.report_submission_date		
			,	#RESULT.report_storage_location		
			,	#RESULT.nationality_76'
		END
		ELSE
		BEGIN
			SET @w_sql = @w_sql + 
			',	#RESULT.detail_no_76				
			,	#RESULT.training_cd					
			,	#RESULT.training_nm					
			,	#RESULT.training_category_cd		
			,	#RESULT.training_category_nm		
			,	#RESULT.training_course_format_cd	
			,	#RESULT.training_course_format_nm	
			,	#RESULT.lecturer_name				
			,	#RESULT.training_date_from			
			,	#RESULT.training_date_to			
			,	#RESULT.training_status				
			,	#RESULT.training_status_nm				
			,	#RESULT.passing_date				
			,	#RESULT.report_submission			
			,	#RESULT.report_submission_nm			
			,	#RESULT.report_submission_date		
			,	#RESULT.report_storage_location		
			,	#RESULT.nationality_76'
		END
	END

	-- FUNCTION_ID M0070_04
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_04')
	BEGIN
		IF @w_type = 0 
		BEGIN
			SET @w_sql = @w_sql + 
			',	#RESULT.work_history_kbn_77			
			,	#RESULT.detail_no_77				
			,	#RESULT.item_id_77					
			,	#RESULT.item_title					
			,	#RESULT.date_from					
			,	#RESULT.date_to						
			,	#RESULT.text_item					
			,	#RESULT.select_item					
			,	#RESULT.number_item'
		END
		ELSE
		BEGIN
			SET @w_sql = @w_sql + 
			',	#RESULT.work_history_kbn_77			
			,	#RESULT.detail_no_77				
			,	#RESULT.item_id_77					
			,	#RESULT.item_title					
			,	#RESULT.date_from					
			,	#RESULT.date_to						
			,	#RESULT.text_item					
			,	#RESULT.select_item					
			,	#RESULT.selected_items_nm					
			,	#RESULT.number_item'
		END
	END

	-- FUNCTION_ID M0070_05
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_05')
	BEGIN
		IF @w_type = 0 
		BEGIN
			SET @w_sql = @w_sql + 
			',	#RESULT.final_education_kbn					
			,	#RESULT.final_education_other				
			,	#RESULT.graduation_year						
			,	#RESULT.graduation_school_cd				
			,	#RESULT.graduation_school_other				
			,	#RESULT.faculty								
			,	#RESULT.major'
		END
		ELSE
		BEGIN
			SET @w_sql = @w_sql + 
			',	#RESULT.final_education_kbn					
			,	#RESULT.final_education_kbn_nm				
			,	#RESULT.final_education_other				
			,	#RESULT.detail_no_78				
			,	#RESULT.graduation_year						
			,	#RESULT.graduation_school_cd				
			,	#RESULT.school_name				
			,	#RESULT.graduation_school_other				
			,	#RESULT.faculty								
			,	#RESULT.major'
		END
	END 

	-- FUNCTION_ID M0070_06
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_06')
	BEGIN
		IF @w_type = 0 
		BEGIN
				SET @w_sql = @w_sql + 
			',	#RESULT.owning_house_kbn					
			,	#RESULT.head_household						
			,	#RESULT.post_code							
			,	#RESULT.address1							
			,	#RESULT.address3							
			,	#RESULT.personal_phone_number				
			,	#RESULT.personal_email_address				
			,	#RESULT.emergency_contact_name				
			,	#RESULT.emergency_contact_relationship		
			,	#RESULT.emergency_contact_post_code			
			,	#RESULT.emergency_contact_addres1			
			,	#RESULT.emergency_contact_addres3			
			,	#RESULT.emergency_contact_phone_number'
		END
		ELSE
		BEGIN
				SET @w_sql = @w_sql + 
			',	#RESULT.owning_house_kbn					
			,	#RESULT.owning_house_kbn_nm						
			,	#RESULT.head_household						
			,	#RESULT.post_code							
			,	#RESULT.address1							
			,	#RESULT.address2							
			,	#RESULT.address3							
			,	#RESULT.home_phone_number							
			,	#RESULT.personal_phone_number				
			,	#RESULT.personal_email_address				
			,	#RESULT.emergency_contact_name				
			,	#RESULT.emergency_contact_relationship		
			,	#RESULT.emergency_contact_birthday		
			,	#RESULT.emergency_contact_post_code			
			,	#RESULT.emergency_contact_addres1			
			,	#RESULT.emergency_contact_addres2			
			,	#RESULT.emergency_contact_addres3			
			,	#RESULT.emergency_contact_phone_number'
		END
	END
	-- FUNCTION_ID M0070_07
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_07')
	BEGIN
		IF @w_type = 0 
		BEGIN
			SET @w_sql = @w_sql + 
			',	#RESULT.detail_no_84							
			,	#RESULT.commuting_method						
			,	#RESULT.commuting_distance						
			,	#RESULT.drivinglicense_renewal_deadline			
			,	#RESULT.commuting_method_detail					
			,	#RESULT.departure_point							
			,	#RESULT.arrival_point							
			,	#RESULT.commuter_ticket_classification			
			,	#RESULT.commuting_expenses'
		END
		ELSE
		BEGIN
			SET @w_sql = @w_sql + 
			',	#RESULT.detail_no_84							
			,	#RESULT.commuting_method						
			,	#RESULT.commuting_method_nm						
			,	#RESULT.commuting_distance						
			,	#RESULT.drivinglicense_renewal_deadline			
			,	#RESULT.commuting_method_detail					
			,	#RESULT.departure_point							
			,	#RESULT.arrival_point							
			,	#RESULT.commuter_ticket_classification			
			,	#RESULT.commuter_ticket_classification_nm			
			,	#RESULT.commuting_expenses'
		END
	END
	-- FUNCTION_ID M0070_08
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_08')
	BEGIN
		IF @w_type = 0 
		BEGIN
			SET @w_sql = @w_sql + 
			',	#RESULT.marital_status							
			,	#RESULT.detail_no_86							
			,	#RESULT.full_name								
			,	#RESULT.full_name_furigana						
			,	#RESULT.relationship							
			,	#RESULT.gender_86								
			,	#RESULT.birthday								
			,	#RESULT.residential_classification				
			,	#RESULT.profession'
		END
		ELSE
		BEGIN
			SET @w_sql = @w_sql + 
			',	#RESULT.marital_status							
			,	#RESULT.marital_status_nm							
			,	#RESULT.detail_no_86							
			,	#RESULT.full_name								
			,	#RESULT.full_name_furigana						
			,	#RESULT.relationship							
			,	#RESULT.gender_86								
			,	#RESULT.gender_nm								
			,	#RESULT.birthday								
			,	#RESULT.residential_classification				
			,	#RESULT.residential_classification_nm				
			,	#RESULT.profession'
		END
	END
	-- FUNCTION_ID M0070_09
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_09')
	BEGIN
		SET @w_sql = @w_sql + 
		',	#RESULT.detail_no_87							
        ,	#RESULT.leave_absence_startdate					
        ,	#RESULT.leave_absence_enddate					
        ,	#RESULT.remarks_87'
	END
	-- FUNCTION_ID M0070_10
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_10')
	BEGIN
		SET @w_sql = @w_sql + 
		',	#RESULT.employment_contract_no					
        ,	#RESULT.detail_no_88							
        ,	#RESULT.start_date								
        ,	#RESULT.expiration_date							
        ,	#RESULT.contract_renewal_kbn					
        ,	#RESULT.reason_resignation						
        ,	#RESULT.remarks_88	'
	END
	-- FUNCTION_ID M0070_11
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_11')
	BEGIN
		IF @w_type = 0 
		BEGIN
			SET @w_sql = @w_sql + 
			',	#RESULT.employment_insurance_no					
			,	#RESULT.basic_pension_no						
			,	#RESULT.employment_insurance_status				
			,	#RESULT.health_insurance_status					
			,	#RESULT.health_insurance_reference_no			
			,	#RESULT.employees_pension_insurance_status		
			,	#RESULT.employees_pension_reference_no			
			,	#RESULT.welfare_pension_status					
			,	#RESULT.employees_pension_member_no				
			,	#RESULT.social_insurance_kbn					
			,	#RESULT.detail_no_91							
			,	#RESULT.joining_date							
			,	#RESULT.date_of_loss							
			,	#RESULT.reason_for_loss_kbn						
			,	#RESULT.reason_for_loss'
		END
		ELSE
		BEGIN
			SET @w_sql = @w_sql + 
			',	#RESULT.employment_insurance_no					
			,	#RESULT.basic_pension_no						
			,	#RESULT.employment_insurance_status				
			,	#RESULT.health_insurance_status					
			,	#RESULT.health_insurance_reference_no			
			,	#RESULT.employees_pension_insurance_status		
			,	#RESULT.employees_pension_reference_no			
			,	#RESULT.welfare_pension_status					
			,	#RESULT.employees_pension_member_no				
			,	#RESULT.social_insurance_kbn					
			,	#RESULT.detail_no_91							
			,	#RESULT.joining_date							
			,	#RESULT.date_of_loss							
			,	#RESULT.reason_for_loss_kbn						
			,	#RESULT.reason_for_loss'
		END
	END
	-- FUNCTION_ID M0070_12
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_12')
	BEGIN
		SET @w_sql = @w_sql + 
		',	#RESULT.base_salary								
	    ,	#RESULT.basic_annual_income	'
	END
	-- FUNCTION_ID M0070_13
	IF EXISTS (SELECT 1 FROM #TEMP_AUTHORITY WHERE function_id = 'M0070_13')
	BEGIN
		IF @w_type = 0 
		BEGIN
			SET @w_sql = @w_sql + 
			',	#RESULT.detail_no_93							
			,	#RESULT.reward_punishment_typ					
			,	#RESULT.decision_date							
			,	#RESULT.reason									
			,	#RESULT.remarks_93'
		END
		ELSE
		BEGIN
			SET @w_sql = @w_sql + 
			',	#RESULT.detail_no_93							
			,	#RESULT.reward_punishment_typ					
			,	#RESULT.reward_punishment_typ_nm					
			,	#RESULT.decision_date							
			,	#RESULT.reason									
			,	#RESULT.remarks_93'
		END
	END

    SET @w_sql = @w_sql + ' FROM #RESULT' + SPACE(1)
	IF NOT EXISTS (SELECT 1 FROM #TEMP_EMPLOYEE)
	BEGIN
		INSERT #TEMP_EMPLOYEE
		SELECT * FROM #TABLE_FILTER
	END
	ELSE
	BEGIN
		INSERT #TEMP_EMPLOYEE
		SELECT #TEMP_EMPLOYEE.* FROM #TEMP_EMPLOYEE INNER JOIN #TABLE_FILTER ON(#TEMP_EMPLOYEE.employee_cd = #TABLE_FILTER.employee_cd)
	END
	IF EXISTS (SELECT 1 FROM #TEMP_EMPLOYEE) OR NOT EXISTS(SELECT 1 FROM #TABLE_JSON_SCREEN)
	BEGIN
		SET @w_sql = @w_sql + '
		WHERE 
			#RESULT.employee_cd IN (SELECT employee_cd FROM #TEMP_EMPLOYEE)	
		OR	#RESULT.id = 0
		' + SPACE(1)
	END
	-- order
	SET @w_sql = @w_sql + '
	ORDER BY 
		CASE 
		   WHEN #RESULT.id = 0 THEN 1
		   ELSE 2
		END
	,	CASE (SELECT 1 WHERE #RESULT.employee_cd NOT LIKE ''%[^0-9]%'')
		   WHEN 1 
		   THEN CAST(#RESULT.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
	,	#RESULT.employee_cd
	,	#RESULT.id
	,	#RESULT.application_date
	,	#RESULT.item_cd
	,	#RESULT.item_no
	'

	EXEC(@w_sql) 
	--PRINT(@w_sql)
END
GO
