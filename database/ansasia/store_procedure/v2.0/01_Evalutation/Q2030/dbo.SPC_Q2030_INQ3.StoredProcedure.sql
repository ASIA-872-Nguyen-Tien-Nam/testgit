DROP PROCEDURE [SPC_Q2030_INQ3]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ M0020
-- EXEC SPC_Q2030_INQ1 '2018',1,1,'1'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	Q2030_評価分析
--*  
--*  作成日/create date			:	2018/10/10						
--*　作成者/creater				:	sondh								
--*   					
--*  更新日/update date			:	2022/08/16
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgrade 1.9
--****************************************************************************************
CREATE PROCEDURE [SPC_Q2030_INQ3]
	-- Add the parameters for the stored procedure here	
	@P_fiscal_year						INT					=	0
,	@P_treatment_applications_no		SMALLINT			=	0
,	@P_evaluation_step					SMALLINT			=	0
,	@P_select_target_1					SMALLINT			=	0
,	@P_organization_cd					NVARCHAR(50)		=	''
,	@P_unit_display						NVARCHAR(20)		=	''
,	@P_rank_cd							SMALLINT			=	0
,	@P_company_cd						SMALLINT			=	0
,	@P_user_id							NVARCHAR(50)		=	''
,	@P_page_size						INT					=   20
,	@P_page								INT					=	1
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								DATE				=	SYSDATETIME()
	,	@ERR_TBL							ERRTABLE
	,	@order_by_min						INT					=	0
	,	@totalRecord						BIGINT				=	0
	,	@pageMax							INT					=	0	
	,	@page_size							INT					=	10
	,	@authority_cd						SMALLINT			=	0
	,	@authority_typ						SMALLINT			=	0
	,	@last_year_month					DATE				=	NULL
	--	2018/12/20
	,	@beginning_date						DATE				=	NULL
	,	@year_month_day						DATE				=	NULL	
	--
	,	@w_evaluation_organization_cnt		INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	,	@arrange_order						INT					=	0
	,	@position_cd						INT					=	0
	,	@choice_in_screen					TINYINT				=	0 
	,	@use_typ							smallint			=	0
	--
	CREATE TABLE #TABLE_ORGANIZATION (
		id						int	identity(1, 1)
	,	organization_typ		tinyint
	,	organization_cd_1		nvarchar(50)
	,	organization_cd_2		nvarchar(50)
	,	organization_cd_3		nvarchar(50)
	,	organization_cd_4		nvarchar(50)
	,	organization_cd_5		nvarchar(50)	
	,	choice_in_screen		tinyint
	)
	--
	CREATE TABLE #LIST_POSITION(
		id								int			identity(1,1)
	,	position_cd						int
	,	mode							smallint	-- 0.choice in screen 1. get from master
	)
	--
	CREATE TABLE #AUTHORITY(
		id								INT		IDENTITY(1,1) 
	,	company_cd						SMALLINT
	,	organization_typ				SMALLINT
	,	organization_cd					NVARCHAR(50)	
	,	employee_cd						NVARCHAR(10)	
	)	

	--
	CREATE TABLE #S0010(
		id								INT		IDENTITY(1,1) 
	,	company_cd						SMALLINT
	,	authority_typ					SMALLINT
	,	employee_cd						NVARCHAR(10)
	,	type_chk						NVARCHAR(10)
	)

	--
	CREATE TABLE #F0030(
		id								INT		IDENTITY(1,1) 
	,	company_cd						SMALLINT
	,	fiscal_year						SMALLINT
	,	rater_employee_cd				NVARCHAR(20)
	,	type_rater						SMALLINT
	,	employee_cd						NVARCHAR(10)
	--
	)

	CREATE TABLE #DATA(
		id								INT		IDENTITY(1,1) 
	,	company_cd						SMALLINT
	,	fiscal_year						SMALLINT
	,	rater_employee_cd				NVARCHAR(20)
	,	type_rater						SMALLINT
	,	employee_cd						NVARCHAR(10)
	,	treatment_applications_no		SMALLINT
	,	evaluation_step					SMALLINT
	,	rank_cd							SMALLINT
	)

	--
	CREATE TABLE #MAIN(
		id								INT		IDENTITY(1,1) 
	,	company_cd						SMALLINT
	,	fiscal_year						SMALLINT
	,	treatment_applications_no		SMALLINT
	,	evaluation_step					SMALLINT
	,	employee_cd						NVARCHAR(10)
	,	rank_cd							SMALLINT
	,	sheet_cd						SMALLINT		-- add by viettd 2022/08/16
	)
	--
	CREATE TABLE #M0071_SHEET(
		company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	fiscal_year						int
	,	sheet_cd						smallint
	,	application_date				date
	,	employee_nm						nvarchar(200)
	,	employee_ab_nm					nvarchar(50)
	,	furigana						nvarchar(50)
	,	office_cd						smallint
	,	office_nm						nvarchar(50)
	,	belong_cd1						nvarchar(20)
	,	belong_cd2						nvarchar(20)
	,	belong_cd3						nvarchar(20)
	,	belong_cd4						nvarchar(20)
	,	belong_cd5						nvarchar(20)
	,	job_cd							smallint
	,	position_cd						int
	,	employee_typ					smallint
	,	grade							smallint
	,	belong_nm1						nvarchar(50)
	,	belong_nm2						nvarchar(50)
	,	belong_nm3						nvarchar(50)
	,	belong_nm4						nvarchar(50)
	,	belong_nm5						nvarchar(50)
	,	job_nm							nvarchar(50)
	,	position_nm						nvarchar(50)
	,	grade_nm						nvarchar(10)
	,	employee_typ_nm					nvarchar(50)
	)
	--
	CREATE TABLE #M0070H(
		application_date				DATE
	,	company_cd						SMALLINT
	,	employee_cd						NVARCHAR(10)
	,	employee_nm						NVARCHAR(200)
	,	employee_ab_nm					NVARCHAR(50)
	,	furigana						NVARCHAR(50)
	,	office_cd						SMALLINT
	,	office_nm						NVARCHAR(50)
	,	belong_cd1						NVARCHAR(50)				--department_cd
	,	belong_cd2						NVARCHAR(50)				--team_cd
	,	belong_cd3						NVARCHAR(50)				--team_cd
	,	belong_cd4						NVARCHAR(50)				--team_cd
	,	belong_cd5						NVARCHAR(50)				--team_cd
	,	job_cd							SMALLINT
	,	position_cd						INT
	,	employee_typ					SMALLINT
	,	grade							SMALLINT
	,	organization_nm1				NVARCHAR(50)
	,	organization_nm2				NVARCHAR(50)
	,	organization_nm3				NVARCHAR(50)
	,	organization_nm4				NVARCHAR(50)
	,	organization_nm5				NVARCHAR(50)
	,	job_nm							NVARCHAR(50)
	,	position_nm						NVARCHAR(50)
	,	grade_nm						NVARCHAR(10)
	,	employee_typ_nm					NVARCHAR(50)
	)
	--
	SELECT
		@authority_cd	=	ISNULL(S0010.authority_cd,0)	
	,	@authority_typ	=	ISNULL(S0010.authority_typ,0)	
	FROM S0010 LEFT JOIN M0070 ON(
		M0070.company_cd		=	S0010.company_cd
	AND M0070.employee_cd		=	S0010.employee_cd
	)
	WHERE 
		S0010.company_cd		=	@P_company_cd
	AND S0010.[user_id]			=	@P_user_id
	--↓↓↓ add by viettd 2022/08/16
	IF @authority_typ = 6
	BEGIN
		SET @authority_typ = 2 -- 評価者
	END
	-- COUNT ALL ORGANIZATIONS OF S0022 -- add by viettd 2021/06/03
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@authority_cd,1)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@authority_cd,1)
	--
	SET @arrange_order	= ISNULL((
		SELECT ISNULL(M0040.arrange_order,0)
		FROM M0040
		WHERE M0040.del_datetime IS NULL AND M0040.position_cd = @position_cd AND M0040.company_cd = @P_company_cd)
	,0)
	-- get @use_typ
	SELECT 
		@use_typ		=	ISNULL(S0020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
	FROM S0020
	WHERE
		S0020.company_cd		=	@P_company_cd
	AND S0020.authority_cd		=	@authority_cd
	AND S0020.del_datetime IS NULL
	--↑↑↑ end add by viettd 2022/08/16
	--START 2018/12/20
	SELECT 
		@beginning_date = M9100.beginning_date 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	--
	IF @beginning_date IS NOT NULL
	BEGIN
		SET @year_month_day = CAST((CAST(@P_fiscal_year AS NVARCHAR(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		SET @year_month_day = DATEADD(DD,-1,DATEADD(YYYY,1,@year_month_day))
	END
	ELSE
	BEGIN 
		SET @year_month_day = CAST((CAST(@P_fiscal_year AS NVARCHAR(4)) + '/12/31') AS DATE)
	END
	--GET DATA EMPLOYEE
	INSERT INTO #M0070H 
	EXECUTE [dbo].[SPC_REFER_M0070H_INQ1] @year_month_day,'',@P_company_cd
	--GET DATA EMPLOYEE
	INSERT INTO #M0071_SHEET
	EXEC [dbo].SPC_REFER_M0071_INQ1 @P_fiscal_year,'',0,@P_company_cd
	-- GET #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 '',@P_user_id,@P_company_cd
	-- GET #LIST_POSITION
	IF NOT EXISTS (SELECT 1 FROM #LIST_POSITION)
	BEGIN
		-- 本人の役職より下位の社員のみ
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
	-- FILTER 
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
	BEGIN
		SET @choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
		-- 1.choice in screen
		IF @choice_in_screen = 1
		BEGIN
			DELETE D FROM #M0070H AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
			    D.belong_cd1			=	S.organization_cd_1
			AND D.belong_cd2			=	S.organization_cd_2
			AND D.belong_cd3			=	S.organization_cd_3
			AND D.belong_cd4			=	S.organization_cd_4
			AND D.belong_cd5			=	S.organization_cd_5
			)
			WHERE 
				D.company_cd IS NULL
			OR	S.organization_typ IS NULL
		END
		ELSE IF NOT (@authority_typ = 3 AND @w_evaluation_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)	-- edited by viettd 2021/06/03
		BEGIN
			DELETE D FROM #M0070H AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.belong_cd1			=	S.organization_cd_1
			AND D.belong_cd2			=	S.organization_cd_2
			AND D.belong_cd3			=	S.organization_cd_3
			AND D.belong_cd4			=	S.organization_cd_4
			AND D.belong_cd5			=	S.organization_cd_5
			)
			WHERE 
				D.company_cd IS NULL
			OR	S.organization_typ IS NULL
			AND @authority_typ NOT IN(4,5) --4.会社管理者 5.総合管理者
		END
	END
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
		IF @authority_typ NOT IN (4,5)
		BEGIN
			DELETE D FROM #M0070H AS D
			LEFT OUTER JOIN #LIST_POSITION AS S ON (
				D.company_cd		=	@P_company_cd
			AND D.position_cd		=	S.position_cd
			)
			WHERE
				S.position_cd IS NULL
		END
	END
	--
	IF @authority_typ IN (3,4,5) -- 管理会社			CR 2018/11/28
	BEGIN
		INSERT INTO #AUTHORITY
		SELECT 
			@P_company_cd	
		,	ISNULL(M0020.organization_typ,0)
		,	ISNULL(M0020.organization_cd_1,0)
		,	ISNULL(#M0070H.employee_cd,'')
		FROM #M0070H WITH(NOLOCK)
		LEFT JOIN M0020 ON (
			#M0070H.company_cd	=	M0020.company_cd		
		AND #M0070H.belong_cd1	=	M0020.organization_cd_1
		AND M0020.organization_typ	=	1
		AND	M0020.del_datetime IS NULL
		)
		WHERE 
			#M0070H.company_cd	= @P_company_cd
	END
	ELSE IF @authority_typ IN (1,2)
	BEGIN
		INSERT INTO #AUTHORITY
		SELECT 
			@P_company_cd	
		,	ISNULL(M0020.organization_typ,0)
		,	ISNULL(M0020.organization_cd_1,0)
		,	ISNULL(#M0070H.employee_cd,'')
		FROM #M0070H
		LEFT OUTER JOIN M0020 ON (
			#M0070H.company_cd			=	M0020.company_cd
		AND 1							=	M0020.organization_typ
		AND #M0070H.belong_cd1			=	M0020.organization_cd_1
		)
		WHERE 
			#M0070H.company_cd			=	@P_company_cd
		AND #M0070H.employee_cd			=	@P_user_id
	END
	-- Danh sach nguoi danh gia
	INSERT INTO #S0010
	SELECT 
		ISNULL(S0010.company_cd,0)
	,	ISNULL(S0010.authority_typ,0)
	,	ISNULL(S0010.employee_cd,'')
	,	IIF(S0010.authority_typ = 2, 'STEP', 'FINAL')
	FROM S0010
	INNER JOIN #AUTHORITY ON (
		S0010.company_cd			=	#AUTHORITY.company_cd
	AND S0010.employee_cd			=	#AUTHORITY.employee_cd
	)
	WHERE 
		S0010.company_cd		=	@P_company_cd
	AND S0010.authority_typ	IN (2,3,4)
	AND S0010.del_datetime IS NULL
	ORDER BY
		S0010.employee_cd
	--F0030
	INSERT INTO #F0030
	SELECT 
		F0030.company_cd
	,	F0030.fiscal_year
	,	F0030.rater_employee_cd_1
	,	1							--rater_employee_cd_1
	,	F0030.employee_cd
	FROM F0030 WITH(NOLOCK)
	WHERE 
		F0030.fiscal_year				=	@P_fiscal_year
	AND F0030.company_cd				=	@P_company_cd
	AND f0030.treatment_applications_no	=	@P_treatment_applications_no
	AND F0030.del_datetime IS NULL
	AND ISNULL(F0030.rater_employee_cd_1,'') <> ''
	--
	INSERT INTO #F0030
	SELECT 
		F0030.company_cd
	,	F0030.fiscal_year
	,	F0030.rater_employee_cd_2
	,	2
	,	F0030.employee_cd
	FROM F0030 WITH(NOLOCK)
	WHERE 
		F0030.fiscal_year = @P_fiscal_year
	AND F0030.company_cd  = @P_company_cd
	AND f0030.treatment_applications_no	=	@P_treatment_applications_no
	AND F0030.del_datetime IS NULL
	AND ISNULL(F0030.rater_employee_cd_2,'') <> ''
	--
	INSERT INTO #F0030
	SELECT 
		F0030.company_cd
	,	F0030.fiscal_year
	,	F0030.rater_employee_cd_3
	,	3
	,	F0030.employee_cd
	FROM F0030 WITH(NOLOCK)
	WHERE 
		F0030.fiscal_year = @P_fiscal_year
	AND F0030.company_cd  = @P_company_cd
	AND f0030.treatment_applications_no	=	@P_treatment_applications_no
	AND F0030.del_datetime IS NULL
	AND ISNULL(F0030.rater_employee_cd_3,'') <> ''
	--
	INSERT INTO #F0030
	SELECT 
		F0030.company_cd
	,	F0030.fiscal_year
	,	F0030.rater_employee_cd_4
	,	4
	,	F0030.employee_cd
	FROM F0030 WITH(NOLOCK)
	WHERE 
		F0030.fiscal_year = @P_fiscal_year
	AND F0030.company_cd  = @P_company_cd
	AND f0030.treatment_applications_no	=	@P_treatment_applications_no
	AND F0030.del_datetime IS NULL
	AND ISNULL(F0030.rater_employee_cd_4,'') <> ''
	--
	IF (@P_evaluation_step = 5)
	BEGIN
		--
		INSERT INTO #DATA
		SELECT 
			#F0030.company_cd
		,	#F0030.fiscal_year
		,	#F0030.rater_employee_cd
		,	#F0030.type_rater
		,	#F0030.employee_cd
		,	F0201.treatment_applications_no	
		,	#F0030.type_rater
		,	F0201.rank_cd						
		FROM #F0030
		INNER JOIN #AUTHORITY ON (
			#F0030.company_cd			=	#AUTHORITY.company_cd
		AND #F0030.employee_cd			=	#AUTHORITY.employee_cd
		)
		LEFT JOIN F0201 ON 
			#F0030.company_cd			=	F0201.company_cd
		AND #F0030.fiscal_year			=	F0201.fiscal_year
		AND #F0030.employee_cd			=	F0201.employee_cd
		AND F0201.del_datetime IS NULL
		WHERE 
			F0201.treatment_applications_no	=	@P_treatment_applications_no
		AND F0201.confirm_datetime IS NOT NULL
		--
		INSERT INTO #DATA
		SELECT 
			#S0010.company_cd
		,	@P_fiscal_year
		,	#S0010.employee_cd
		,	5
		,	F0201.employee_cd
		--
		,	F0201.treatment_applications_no	
		,	5
		,	F0201.rank_cd						
		FROM #S0010
		CROSS JOIN F0201 
		INNER JOIN #AUTHORITY ON (
			F0201.company_cd		=	#AUTHORITY.company_cd
		AND F0201.employee_cd		=	#AUTHORITY.employee_cd
		)
		WHERE 
			F0201.fiscal_year				=	@P_fiscal_year
		AND F0201.del_datetime IS NULL
		AND	F0201.treatment_applications_no	=	@P_treatment_applications_no
		AND F0201.confirm_datetime IS NOT NULL
		AND #S0010.type_chk = 'FINAL'
	END
	ELSE
	BEGIN
		INSERT INTO #DATA
		SELECT 
			#F0030.company_cd
		,	#F0030.fiscal_year
		,	#F0030.rater_employee_cd
		,	#F0030.type_rater
		,	#F0030.employee_cd
		--
		,	F0200.treatment_applications_no	
		,	#F0030.type_rater
		,	F0200.rank_cd						
		FROM #F0030
		INNER JOIN #AUTHORITY ON (
			#F0030.company_cd				=	#AUTHORITY.company_cd
		AND #F0030.employee_cd				=	#AUTHORITY.employee_cd
		)
		LEFT JOIN F0200 ON 
			#F0030.company_cd				=	F0200.company_cd
		AND #F0030.fiscal_year				=	F0200.fiscal_year
		AND #F0030.employee_cd				=	F0200.employee_cd
		AND @P_treatment_applications_no	=	F0200.treatment_applications_no
		AND #F0030.type_rater				=	F0200.evaluation_step
		AND F0200.del_datetime IS NULL
		WHERE 
			#F0030.type_rater = @P_evaluation_step
	END
	--INSERT #MAIN
	INSERT INTO #MAIN
	SELECT 
		#DATA.company_cd
	,	#DATA.fiscal_year
	,	#DATA.treatment_applications_no
	,	#DATA.evaluation_step					
	,	#DATA.employee_cd						
	,	#DATA.rank_cd	
	,	ISNULL(F0032_SHEET_MAX.sheet_cd,0)
	FROM #DATA	
	LEFT OUTER JOIN (
		SELECT 
			ISNULL(F0032.company_cd,0)						AS	company_cd
		,	ISNULL(F0032.fiscal_year,0)						AS	fiscal_year
		,	ISNULL(F0032.employee_cd,0)						AS	employee_cd
		,	ISNULL(F0032.treatment_applications_no,0)		AS	treatment_applications_no
		,	MAX(F0032.sheet_cd)								AS	sheet_cd
		FROM F0032
		WHERE 
			F0032.company_cd		=	@P_company_cd
		AND F0032.fiscal_year		=	@P_fiscal_year
		AND F0032.del_datetime IS NULL
		GROUP BY
			F0032.company_cd
		,	F0032.fiscal_year
		,	F0032.employee_cd
		,	F0032.treatment_applications_no
	) AS F0032_SHEET_MAX ON (
		#DATA.company_cd					=	F0032_SHEET_MAX.company_cd
	AND #DATA.fiscal_year					=	F0032_SHEET_MAX.fiscal_year
	AND #DATA.employee_cd					=	F0032_SHEET_MAX.employee_cd
	AND #DATA.treatment_applications_no		=	F0032_SHEET_MAX.treatment_applications_no
	)
	WHERE 
		#DATA.rater_employee_cd		=	@P_unit_display
	AND #DATA.rank_cd				=	@P_rank_cd

	--[0]
	SELECT 
		#MAIN.employee_cd										AS employee_cd
	,	ISNULL(#M0071_SHEET.employee_nm,'')						AS employee_nm
	,	ISNULL(#M0071_SHEET.employee_typ_nm,'')					AS employee_typ_nm
	,	ISNULL(M1.organization_nm,'')							AS organization_nm_1
	,	ISNULL(M2.organization_nm,'')							AS organization_nm_2
	,	ISNULL(M3.organization_nm,'')							AS organization_nm_3
	,	ISNULL(M4.organization_nm,'')							AS organization_nm_4
	,	ISNULL(M5.organization_nm,'')							AS organization_nm_5
	,	ISNULL(#M0071_SHEET.job_nm,'')							AS job_nm
	,	ISNULL(#M0071_SHEET.grade_nm,'')						AS grade_nm
	,	ISNULL(#MAIN.rank_cd,0)									AS rank_cd
	,	ISNULL(M0130.rank_nm,'')								AS rank_nm
	FROM #MAIN
	LEFT OUTER JOIN #M0071_SHEET ON (
		#MAIN.company_cd		=	#M0071_SHEET.company_cd
	AND #MAIN.fiscal_year		=	#M0071_SHEET.fiscal_year
	AND #MAIN.employee_cd		=	#M0071_SHEET.employee_cd
	AND #MAIN.sheet_cd			=	#M0071_SHEET.sheet_cd
	)
	LEFT JOIN M0020 AS M1 ON (
		M1.company_cd			=	#M0071_SHEET.company_cd
	AND M1.organization_cd_1	=	#M0071_SHEET.belong_cd1
	AND M1.organization_typ		=	1
	--AND M1.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M2 ON (
		M2.company_cd			=	#M0071_SHEET.company_cd
	AND M2.organization_cd_1	=	#M0071_SHEET.belong_cd1
	AND M2.organization_cd_2	=	#M0071_SHEET.belong_cd2
	AND M2.organization_typ		=	2
	--AND M2.del_datetime			IS NULL 
	)
	LEFT JOIN M0020 AS M3 ON (
		M3.company_cd			=	#M0071_SHEET.company_cd
	AND M3.organization_cd_1	=	#M0071_SHEET.belong_cd1
	AND M3.organization_cd_2	=	#M0071_SHEET.belong_cd2
	AND M3.organization_cd_3	=	#M0071_SHEET.belong_cd3
	AND M3.organization_typ		=	3
	--AND M2.del_datetime			IS NULL 
	)
	LEFT JOIN M0020 AS M4 ON (
		M4.company_cd			=	#M0071_SHEET.company_cd
	AND M4.organization_cd_1	=	#M0071_SHEET.belong_cd1
	AND M4.organization_cd_2	=	#M0071_SHEET.belong_cd2
	AND M4.organization_cd_3	=	#M0071_SHEET.belong_cd3
	AND M4.organization_cd_4	=	#M0071_SHEET.belong_cd4
	AND M4.organization_typ		=	4
	--AND M2.del_datetime			IS NULL 
	)
	LEFT JOIN M0020 AS M5 ON (
		M5.company_cd			=	#M0071_SHEET.company_cd
	AND M5.organization_cd_1	=	#M0071_SHEET.belong_cd1
	AND M5.organization_cd_2	=	#M0071_SHEET.belong_cd2
	AND M5.organization_cd_3	=	#M0071_SHEET.belong_cd3
	AND M5.organization_cd_4	=	#M0071_SHEET.belong_cd4
	AND M5.organization_cd_5	=	#M0071_SHEET.belong_cd5
	AND M5.organization_typ		=	5
	--AND M2.del_datetime			IS NULL 
	) 
	LEFT JOIN M0130 ON (
		#MAIN.company_cd				=	M0130.company_cd
	AND #MAIN.rank_cd					=	M0130.rank_cd
	AND M0130.treatment_applications_no	=	@P_treatment_applications_no
	AND M0130.del_datetime IS NULL
	)
	ORDER BY 
		CASE ISNUMERIC(#MAIN.employee_cd) 
		   WHEN 1 
		   THEN CAST(#MAIN.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	#MAIN.employee_cd
	offset (@P_page - 1) * @P_page_size ROWS
	FETCH NEXT @P_page_size ROWS only
	--
	SET @totalRecord	= (SELECT COUNT(1) FROM #MAIN)
	SET @pageMax		= CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	IF @pageMax			= 0
	BEGIN
		SET @pageMax	= 1
	END
	IF @P_page > @pageMax
	BEGIN
		SET @P_page = @pageMax
	END
	
	--[1]
	SELECT	
		@totalRecord	AS totalRecord
	,	@pageMax		AS pageMax
	,	@P_page			AS page
	,	@P_page_size	AS pagesize
	,	((@P_page - 1) * @P_page_size + 1) AS offset

	--CLEAR TABLE TEMP
	DROP TABLE #DATA
	DROP TABLE #AUTHORITY
	DROP TABLE #F0030
	DROP TABLE #S0010
	DROP TABLE #MAIN
	DROP TABLE #M0071_SHEET
	DROP TABLE #LIST_POSITION
	DROP TABLE #M0070H
	DROP TABLE #TABLE_ORGANIZATION
END
GO