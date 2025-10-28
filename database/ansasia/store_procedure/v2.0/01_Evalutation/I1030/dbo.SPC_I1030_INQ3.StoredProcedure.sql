DROP PROCEDURE [SPC_I1030_INQ3]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [SPC_I1030_INQ3]
/****************************************************************************************************
 *
 *  処理概要: refer employee
 *
 *  作成日  ： 2018/11/28
 *  作成者  ： Tuantv
 *
 *  更新日  ： 2019/05/14
 *  更新者  ： Longvv
 *  更新内容： 修正依頼「20190513」を修正。	
 *
 *  更新日  ： 2020/01/07
 *  更新者  ： viettd
 *  更新内容： upgradate ver1.6	
 *
 *  更新日  ： 2020/04/16
 *  更新者  ： viettd
 *  更新内容： view all when authority = 4.会社管理者
 *
 *  更新日  ： 2021/06/03
 *  更新者  ： viettd
 *  更新内容： when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
 *
 *  更新日  ： 2021/09/17
 *  更新者  ： viettd
 *  更新内容： fix get #F0021_TEMP & #F0032_TEMP
 *
 *  更新日  ： 2022/08/16
 *  更新者  ： viettd　
 *  更新内容： upgrade ver1.9
 *
 ****************************************************************************************************/
	@P_company_cd			SMALLINT		=	0
,	@P_fiscal_year			INT				=	0
,	@P_group_cd				SMALLINT		=	0
,	@P_employee_cd			NVARCHAR(10)	=	''		-- refer employee_cd
,	@P_user_id				NVARCHAR(50)	=	''		-- login user
,	@P_json					NVARCHAR(MAX)	=	''		-- list_treatment_applications_no
AS
BEGIN
	DECLARE 
		@w_status	NVARCHAR(10)	= ''
	,	@w_check	INT				= 0
	,	@w_rowspan	INT = 0
	SET NOCOUNT ON; 
	--
	DECLARE 
		@ERR_TBL							ERRTABLE
	,	@totalRecord						decimal(18,0)	=	0
	,	@pageMax							int				=	0
	,	@pageNumber							int				=	0
	,	@w_item								nvarchar(100)	=	''
	,	@w_month_date						nvarchar(10)	=	''
	,	@w_year								nvarchar(10)	=	''
	,	@w_year_value						nvarchar(10)	=	'' 
	,	@year_month_day						date			=	NULL	 
	,	@w_retired_employee					int				=	0	
	,	@w_evaluated_typ					int				=	0	
	,	@w_check_msg87						int				=	0			
	--	add by viettd 2019/01/07
	,	@use_typ							smallint		=	0			
	,	@authority_cd						smallint		=	0
	,	@position_cd						int				=	0
	,	@arrange_order						int				=	0
	,	@authority_typ						smallint		=	0	-- add by viettd 2020/04/16
	-- add by viettd 2021/06/03
	,	@w_evaluation_organization_cnt		INT				=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT		=	0
	-- add by viettd 2021/09/17
	,	@i									int				=	1
	,	@cnt								int				=	0
	-- 
	SET @w_year_value = (SELECT M9100.beginning_date FROM M9100 WHERE M9100.company_cd = @P_company_cd)
	IF(@w_year_value IS NOT NULL)
	BEGIN
		SET @w_month_date =(SELECT FORMAT(M9100.beginning_date,'MM-dd') FROM M9100 WHERE M9100.company_cd = @P_company_cd)
	END
	ELSE 
	BEGIN
		SET @w_month_date = '01-01'
	END
	SET @w_year =  CONVERT(NVARCHAR(10),@P_fiscal_year) +'-'+ @w_month_date
	SET @year_month_day = DATEADD(DAY,-1,DATEADD(YEAR,1,(CONVERT(DATE,@w_year))))
	--
	SELECT 
		@authority_cd			=	S0010.authority_cd
	,	@position_cd			=	ISNULL(M0070.position_cd,0)
	,	@authority_typ			=	ISNULL(S0010.authority_typ,0)
	FROM S0010 
	LEFT JOIN M0070 ON (
		M0070.company_cd		=	S0010.company_cd
	AND M0070.employee_cd		=	S0010.employee_cd
	AND M0070.del_datetime		IS NULL 
	) 
	WHERE
		S0010.company_cd		=	@P_company_cd
	AND S0010.user_id			=	@P_user_id
	AND S0010.del_datetime IS NULL
	--
	SET @arrange_order	= ISNULL((SELECT ISNULL(M0040.arrange_order,0) FROM M0040 WHERE M0040.del_datetime IS NULL AND M0040.position_cd = @position_cd AND M0040.company_cd = @P_company_cd),0)
	-- COUNT ALL ORGANIZATIONS OF S0022 -- add by viettd 2021/06/03
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@authority_cd,1)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@authority_cd,1)
	--
	CREATE TABLE #TABLE_ORGANIZATION (
		organization_typ				tinyint
	,	organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)	
	,	choice_in_screen				tinyint		-- 1.choice in screen 0.get from master S0022
	)
	--
	CREATE TABLE #JSON_LIST_TREATMENT(
		id								int			identity(1,1)
	,	company_cd						smallint
	,	treatment_applications_no		smallint
	)
	--
	CREATE TABLE #TEMP_ROWSPAN(
		id							BIGINT	IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	group_cd					SMALLINT
	,	row_span					SMALLINT
	)
	--
	CREATE TABLE #TEMP_ROWSPAN_TABLE(
		id							BIGINT	IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	row_span					SMALLINT
	)
	--
	CREATE TABLE #M0070_TEMP(
		company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	employee_nm					NVARCHAR(200)
	,	employee_typ				SMALLINT
	,	job_cd						SMALLINT
	,	grade						SMALLINT
	,	position_cd					int
	,	rater_position_cd_1			int
	,	rater_position_cd_2			int
	,	rater_position_cd_3			int
	,	rater_position_cd_4			int
	,	belong_cd1					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd2					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd3					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd4					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd5					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_nm1					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm2					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm3					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm4					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm5					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	employee_typ_nm				NVARCHAR(50)
	,	job_nm						NVARCHAR(50)
	,	position_nm					NVARCHAR(50)
	,	grade_nm					NVARCHAR(10)
	,	treatment_applications_no	SMALLINT
	,	sheet_cd_f0021				SMALLINT
	,	sheet_nm_f0021				NVARCHAR(50)
	,	detail_no					SMALLINT			-- add by viettd 2020/01/07
	)	
	--
	CREATE TABLE #M0070(
		company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	employee_nm					NVARCHAR(200)
	,	employee_typ				SMALLINT
	,	job_cd						SMALLINT
	,	grade						SMALLINT
	,	position_cd					int
	,	rater_position_cd_1			int
	,	rater_position_cd_2			int
	,	rater_position_cd_3			int
	,	rater_position_cd_4			int
	,	rater_employee_cd_1			NVARCHAR(10)
	,	rater_employee_cd_2			NVARCHAR(10)
	,	rater_employee_cd_3			NVARCHAR(10)
	,	rater_employee_cd_4			NVARCHAR(10)
	,	belong_cd1					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd2					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd3					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd4					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd5					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_nm1					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm2					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm3					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm4					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm5					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	employee_typ_nm				NVARCHAR(50)
	,	job_nm						NVARCHAR(50)
	,	position_nm					NVARCHAR(50)
	,	grade_nm					NVARCHAR(10)
	,	treatment_applications_no	SMALLINT
	,	sheet_cd_f0021				SMALLINT
	,	sheet_nm_f0021				NVARCHAR(50)
	,	detail_no					SMALLINT			-- add by viettd 2020/01/07
	)	
	--
	CREATE TABLE #F0021_TEMP (
		id							INT IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	group_cd					SMALLINT
	,	treatment_applications_no	SMALLINT
	,	detail_no					SMALLINT
	,	sheet_cd					SMALLINT
	,	sheet_nm					NVARCHAR(50)
	)
	--
	CREATE TABLE #F0032_TEMP (
		id							INT IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	treatment_applications_no	SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	detail_no					SMALLINT
	,	sheet_cd					SMALLINT
	,	sheet_nm					NVARCHAR(50)
	)
	-- #F0021
	CREATE TABLE #F0021 (
		id							INT IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	group_cd					SMALLINT
	,	treatment_applications_no	SMALLINT
	,	detail_no					SMALLINT
	,	sheet_cd					SMALLINT
	)
	--
	CREATE TABLE #F0032 (
		id							INT IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	treatment_applications_no	SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	detail_no					SMALLINT
	,	sheet_cd					SMALLINT
	)
	--
	CREATE TABLE #EVALUATIVE (
		id							INT IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	treatment_applications_no	SMALLINT
	,	sheet_cd_f0021				SMALLINT
	,	sheet_nm_f0021				NVARCHAR(50)
	,	sheet_cd_f0032				SMALLINT
	,	sheet_nm_f0032				NVARCHAR(50)
	,	detail_no					SMALLINT				-- add by viettd 2020/01/07
	,	group_cd					SMALLINT				-- add by viettd 2020/01/07
	)
	--
	CREATE TABLE #DATA(
		company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	employee_nm					NVARCHAR(200)
	,	employee_typ				SMALLINT
	,	job_cd						SMALLINT
	,	grade						SMALLINT
	,	position_cd					int
	,	rater_position_cd_1			int
	,	rater_position_cd_2			int
	,	rater_position_cd_3			int
	,	rater_position_cd_4			int
	,	rater_employee_cd_1			NVARCHAR(10)
	,	rater_employee_cd_2			NVARCHAR(10)
	,	rater_employee_cd_3			NVARCHAR(10)
	,	rater_employee_cd_4			NVARCHAR(10)
	,	belong_cd1					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd2					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd3					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd4					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd5					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_nm1					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm2					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm3					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm4					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm5					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	employee_typ_nm				NVARCHAR(50)
	,	job_nm						NVARCHAR(50)
	,	position_nm					NVARCHAR(50)
	,	grade_nm					NVARCHAR(10)
	,	treatment_applications_no	SMALLINT	
	,	sheet_cd_f0021				SMALLINT
	,	sheet_nm_f0021				NVARCHAR(50)
	,	sheet_cd_f0032				SMALLINT
	,	sheet_nm_f0032				NVARCHAR(50)
	,	detail_no					SMALLINT			-- add by viettd 2020/01/07
	)
	--
	CREATE TABLE #RESULT(
		row_number					INT
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	employee_nm					NVARCHAR(200)
	,	employee_typ				SMALLINT
	,	job_cd						SMALLINT
	,	grade						SMALLINT
	,	position_cd					int
	,	rater_position_cd_1			int
	,	rater_position_cd_2			int
	,	rater_position_cd_3			int
	,	rater_position_cd_4			int
	,	rater_employee_cd_1			NVARCHAR(10)
	,	rater_employee_cd_2			NVARCHAR(10)
	,	rater_employee_cd_3			NVARCHAR(10)
	,	rater_employee_cd_4			NVARCHAR(10)
	,	belong_cd1					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd2					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd3					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd4					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd5					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_nm1					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm2					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm3					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm4					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm5					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	employee_typ_nm				NVARCHAR(50)
	,	job_nm						NVARCHAR(50)
	,	position_nm					NVARCHAR(50)
	,	grade_nm					NVARCHAR(10)
	,	treatment_applications_no	SMALLINT
	,	sheet_cd1					SMALLINT
	,	sheet_nm1					NVARCHAR(50)
	,	sheet_cd2					SMALLINT
	,	sheet_nm2					NVARCHAR(50)
	,	row							INT	
	,	key_number					INT		
	,	detail_no					SMALLINT			-- add by viettd 2020/01/07
	)
	--
	CREATE TABLE #ROWSPAN(
		company_cd				SMALLINT
	,	fiscal_year				SMALLINT
	,	group_cd				SMALLINT
	,	employee_cd				NVARCHAR(10)
	,	row						INT
	)	
	--
	CREATE TABLE #M0070_EMPLOYEE_CD(
		id							BIGINT	IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	employee_typ				SMALLINT
	,	job_cd						SMALLINT
	,	position_cd					int
	,	grade						SMALLINT
	)
	--
	CREATE TABLE #EMPLOYEE_COMMON(
		id							BIGINT	IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	)
	--
	CREATE TABLE #M0060(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	employee_typ			SMALLINT
	,	group_cd				SMALLINT
	)	
	--
	CREATE TABLE #M0050(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	grade					SMALLINT
	,	group_cd				SMALLINT
	)
	--
	CREATE TABLE #M0040(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	position_cd				int
	,	group_cd				SMALLINT
	)
	--
	CREATE TABLE #M0030(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	job_cd					SMALLINT
	,	group_cd				SMALLINT
	)
	--
	CREATE TABLE #M0070H(
		application_date				date
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
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
	--#F0200
	CREATE TABLE #F0200 (
		id							int identity(1,1)
	,	company_cd					smallint
	,	fiscal_year					int
	,	employee_cd					nvarchar(10)
	,	treatment_applications_no	smallint
	,	num							int
	)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- INSERT DATA INTO TEMP TABLE
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--#JSON_LIST_TREATMENT
	INSERT INTO #JSON_LIST_TREATMENT
	SELECT 
		@P_company_cd
	,	json_table.treatment_applications_no 
	FROM OPENJSON(@P_json,'$') WITH(
		treatment_applications_no	smallint
	)AS json_table
	WHERE
		json_table.treatment_applications_no > 0
	-- INSERT DATA INTO #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 '',@P_user_id,@P_company_cd
	-- add by viettd 2021/09/17
	INSERT INTO #F0021
	SELECT 
		F0021.company_cd
	,	F0021.fiscal_year
	,	F0021.group_cd
	,	F0021.treatment_applications_no
	,	F0021.detail_no
	,	F0021.sheet_cd
	FROM F0021
	INNER JOIN #JSON_LIST_TREATMENT AS S ON (
		F0021.treatment_applications_no		=	S.treatment_applications_no
	)
	WHERE 
		F0021.company_cd	= @P_company_cd
	AND F0021.fiscal_year	= @P_fiscal_year
	AND F0021.group_cd		= @P_group_cd
	AND F0021.del_datetime IS NULL
	--
	SET @cnt = (SELECT COUNT(#F0021.sheet_cd) FROM #F0021)
	WHILE @i <= @cnt
	BEGIN
		INSERT INTO #F0021_TEMP
		SELECT 
			#F0021.company_cd
		,	#F0021.fiscal_year
		,	#F0021.group_cd
		,	#F0021.treatment_applications_no
		,	#F0021.detail_no
		,	#F0021.sheet_cd
		,	ISNULL(W_M0200.sheet_nm,'')
		FROM #F0021
		LEFT OUTER JOIN #F0021_TEMP ON (
			#F0021.company_cd		=	#F0021_TEMP.company_cd
		AND #F0021.fiscal_year		=	#F0021_TEMP.fiscal_year
		AND #F0021.group_cd			=	#F0021_TEMP.group_cd
		AND #F0021.sheet_cd			=	#F0021_TEMP.sheet_cd
		)
		LEFT OUTER JOIN W_M0200 ON (
			#F0021.company_cd		=	W_M0200.company_cd
		AND #F0021.fiscal_year		=	W_M0200.fiscal_year
		AND #F0021.sheet_cd			=	W_M0200.sheet_cd
		AND W_M0200.del_datetime IS NULL
		)
		WHERE 
			#F0021.id = @i
		AND #F0021_TEMP.sheet_cd IS NULL
		--
		SET @i = @i + 1
	END
	--
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @year_month_day,'',@P_company_cd
	-- #M0070_EMPLOYEE_CD
	INSERT INTO #M0070_EMPLOYEE_CD
	SELECT 
		M0070.company_cd
	,	-1						-- group_cd
	,	M0070.employee_cd
	,	M0070.employee_typ
	,	M0070.job_cd
	,	M0070.position_cd
	,	M0070.grade
	FROM M0070
	WHERE 
		M0070.company_cd	= @P_company_cd
	AND M0070.employee_cd	= @P_employee_cd
	AND M0070.del_datetime IS NULL
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- if don't choice group in screen (画面上にグループを選択なし)
	IF @P_group_cd = -1
	BEGIN
		-- UPDATE ANY GROUP IN F0030
		UPDATE #M0070_EMPLOYEE_CD SET 
			group_cd = ISNULL(F0030_GROUPED.group_cd,-1)
		FROM #M0070_EMPLOYEE_CD
		INNER JOIN (
			SELECT 
				ISNULL(F0030.company_cd,0)				AS	company_cd
			,	ISNULL(F0030.employee_cd,'')			AS	employee_cd
			,	ISNULL(F0030.group_cd,0)				AS	group_cd
			,	MIN(F0030.treatment_applications_no)	AS	treatment_applications_no
			FROM F0030
			WHERE
				F0030.company_cd		=	@P_company_cd
			AND F0030.fiscal_year		=	@P_fiscal_year
			AND F0030.del_datetime IS NULL
			GROUP BY
				F0030.company_cd
			,	F0030.employee_cd
			,	F0030.group_cd
		) AS F0030_GROUPED ON(
			#M0070_EMPLOYEE_CD.company_cd		=	F0030_GROUPED.company_cd
		AND #M0070_EMPLOYEE_CD.employee_cd		=	F0030_GROUPED.employee_cd
		)
	END
	-- if choice group in screen (画面上にグループを選択あり)
	IF @P_group_cd <> -1
	BEGIN
		-- UPDATE @P_group_cd + TREATMENT_APPLICATIONS_NO
		UPDATE #M0070_EMPLOYEE_CD SET 
			group_cd	=	@P_group_cd
		FROM #M0070_EMPLOYEE_CD
	END
	-- add by viettd 2021/09/17
	INSERT INTO #F0032
	SELECT 
		F0032.company_cd
	,	F0032.fiscal_year
	,	F0032.treatment_applications_no
	,	F0032.group_cd
	,	F0032.employee_cd
	,	F0032.detail_no
	,	F0032.sheet_cd
	FROM F0032
	INNER JOIN #JSON_LIST_TREATMENT AS S ON (
		F0032.treatment_applications_no		=	S.treatment_applications_no
	)
	INNER JOIN #M0070_EMPLOYEE_CD ON (
		F0032.company_cd		=	#M0070_EMPLOYEE_CD.company_cd
	AND F0032.employee_cd		=	#M0070_EMPLOYEE_CD.employee_cd
	)
	WHERE 
		F0032.company_cd	= @P_company_cd
	AND F0032.fiscal_year	= @P_fiscal_year
	AND (F0032.group_cd		= @P_group_cd
		OR @P_group_cd = -1
		)
	AND F0032.del_datetime IS NULL
	------------------
	SET @i = 1
	SET @cnt = (SELECT COUNT(#F0032.sheet_cd) FROM #F0032)
	WHILE @i <= @cnt
	BEGIN
		INSERT INTO #F0032_TEMP
		SELECT 
			#F0032.company_cd
		,	#F0032.fiscal_year
		,	#F0032.treatment_applications_no
		,	#F0032.group_cd
		,	#F0032.employee_cd
		,	#F0032.detail_no
		,	#F0032.sheet_cd
		,	ISNULL(W_M0200.sheet_nm,'')
		FROM #F0032
		LEFT OUTER JOIN #F0032_TEMP ON (
			#F0032.company_cd		=	#F0032_TEMP.company_cd
		AND #F0032.fiscal_year		=	#F0032_TEMP.fiscal_year
		AND #F0032.group_cd			=	#F0032_TEMP.group_cd
		AND #F0032.employee_cd		=	#F0032_TEMP.employee_cd
		AND #F0032.sheet_cd			=	#F0032_TEMP.sheet_cd
		)
		LEFT OUTER JOIN W_M0200 ON (
			#F0032.company_cd		=	W_M0200.company_cd
		AND #F0032.fiscal_year		=	W_M0200.fiscal_year
		AND #F0032.sheet_cd			=	W_M0200.sheet_cd
		AND W_M0200.del_datetime IS NULL
		)
		WHERE 
			#F0032.id = @i
		AND #F0032_TEMP.sheet_cd IS NULL
		--
		SET @i = @i + 1
	END
	--if eixts in #F0021_TEMP
	IF EXISTS (SELECT 1 FROM #F0021_TEMP)
	BEGIN
		INSERT INTO #M0070_TEMP
		SELECT 
			M0070.company_cd						
		,	@P_fiscal_year							
		,	#M0070_EMPLOYEE_CD.group_cd				
		,	M0070.employee_cd						
		,	M0070.employee_nm						
		,	#M0070H.employee_typ					
		,	#M0070H.job_cd							
		,	#M0070H.grade							
		,	M0070.position_cd						
		,	M0300.rater_position_cd_1				
		,	M0300.rater_position_cd_2				
		,	M0300.rater_position_cd_3				
		,	M0300.rater_position_cd_4				
		,	#M0070H.belong_cd1						
		,	#M0070H.belong_cd2						
		,	#M0070H.belong_cd3						
		,	#M0070H.belong_cd4						
		,	#M0070H.belong_cd5						
		,	#M0070H.belong_nm1						
		,	#M0070H.belong_nm2						
		,	#M0070H.belong_nm3						
		,	#M0070H.belong_nm4						
		,	#M0070H.belong_nm5						
		,	#M0070H.employee_typ_nm					
		,	#M0070H.job_nm							
		,	#M0070H.position_nm						
		,	#M0070H.grade_nm						
		,	#F0021_TEMP.treatment_applications_no	
		,	#F0021_TEMP.sheet_cd					
		,	M0200.sheet_nm							
		,	#F0021_TEMP.detail_no					
		FROM M0070
		INNER JOIN #M0070_EMPLOYEE_CD ON (
			M0070.company_cd	=	#M0070_EMPLOYEE_CD.company_cd
		AND	M0070.employee_cd	=	#M0070_EMPLOYEE_CD.employee_cd
		)
		LEFT OUTER JOIN #M0070H ON (
			M0070.company_cd		=	#M0070H.company_cd
		AND M0070.employee_cd		=	#M0070H.employee_cd
		)
		LEFT JOIN M0300 ON (
			M0070.company_cd		= M0300.company_cd
		AND M0070.belong_cd1		= M0300.organization_cd
		AND M0070.position_cd		= M0300.position_cd
		AND M0300.del_datetime IS NULL
		)
		LEFT OUTER JOIN #F0021_TEMP ON (
			M0070.company_cd			=	#F0021_TEMP.company_cd
		AND	@P_group_cd					=	#F0021_TEMP.group_cd
		)
		LEFT JOIN M0200 ON (
			#F0021_TEMP.company_cd		= M0200.company_cd
		AND #F0021_TEMP.sheet_cd		= M0200.sheet_cd
		)
		WHERE 
			M0070.company_cd		= @P_company_cd
		AND M0070.evaluated_typ		= 1
		AND M0070.del_datetime IS NULL 
	END
	ELSE
	BEGIN
		INSERT INTO #M0070_TEMP
		SELECT 
			M0070.company_cd
		,	@P_fiscal_year
		,	#M0070_EMPLOYEE_CD.group_cd
		,	M0070.employee_cd
		,	M0070.employee_nm
		,	#M0070H.employee_typ
		,	#M0070H.job_cd		
		,	#M0070H.grade						
		,	M0070.position_cd	
		,	M0300.rater_position_cd_1
		,	M0300.rater_position_cd_2
		,	M0300.rater_position_cd_3
		,	M0300.rater_position_cd_4	
		,	#M0070H.belong_cd1
		,	#M0070H.belong_cd2
		,	#M0070H.belong_cd3
		,	#M0070H.belong_cd4
		,	#M0070H.belong_cd5
		,	#M0070H.belong_nm1
		,	#M0070H.belong_nm2
		,	#M0070H.belong_nm3
		,	#M0070H.belong_nm4
		,	#M0070H.belong_nm5
		,	#M0070H.employee_typ_nm	
		,	#M0070H.job_nm			
		,	#M0070H.position_nm		
		,	#M0070H.grade_nm	
		,	#F0032_TEMP.treatment_applications_no
		,	NULL
		,	NULL
		,	#F0032_TEMP.detail_no
		FROM M0070
		INNER JOIN #M0070_EMPLOYEE_CD ON (
			M0070.company_cd	=	#M0070_EMPLOYEE_CD.company_cd
		AND	M0070.employee_cd	=	#M0070_EMPLOYEE_CD.employee_cd
		)
		LEFT OUTER JOIN #M0070H ON (
			M0070.company_cd		=	#M0070H.company_cd
		AND M0070.employee_cd		=	#M0070H.employee_cd
		)
		LEFT JOIN M0300 ON (
			M0070.company_cd		= M0300.company_cd
		AND M0070.belong_cd1		= M0300.organization_cd
		AND M0070.position_cd		= M0300.position_cd
		AND M0300.del_datetime IS NULL
		)
		LEFT OUTER JOIN #F0032_TEMP ON (
			#M0070_EMPLOYEE_CD.company_cd		=	#F0032_TEMP.company_cd
		AND #M0070_EMPLOYEE_CD.employee_cd		=	#F0032_TEMP.employee_cd
		AND	#M0070_EMPLOYEE_CD.group_cd			=	#F0032_TEMP.group_cd
		)
		LEFT JOIN M0200 ON (
			#F0032_TEMP.company_cd		= M0200.company_cd
		AND #F0032_TEMP.sheet_cd		= M0200.sheet_cd
		)
		WHERE 
			M0070.company_cd		= @P_company_cd
		AND M0070.evaluated_typ		= 1
		AND M0070.del_datetime IS NULL 
	END
	--
	INSERT INTO #M0070
	SELECT 
		#M0070_TEMP.company_cd			
	,	#M0070_TEMP.fiscal_year			
	,	#M0070_TEMP.group_cd			
	,	#M0070_TEMP.employee_cd			
	,	#M0070_TEMP.employee_nm			
	,	#M0070_TEMP.employee_typ		
	,	#M0070_TEMP.job_cd				
	,	#M0070_TEMP.grade				
	,	#M0070_TEMP.position_cd			
	,	#M0070_TEMP.rater_position_cd_1	
	,	#M0070_TEMP.rater_position_cd_2	
	,	#M0070_TEMP.rater_position_cd_3	
	,	#M0070_TEMP.rater_position_cd_4	
	,	F0030.rater_employee_cd_1	
	,	F0030.rater_employee_cd_2	
	,	F0030.rater_employee_cd_3	
	,	F0030.rater_employee_cd_4	
	,	#M0070_TEMP.belong_cd1
	,	#M0070_TEMP.belong_cd2
	,	#M0070_TEMP.belong_cd3
	,	#M0070_TEMP.belong_cd4
	,	#M0070_TEMP.belong_cd5
	,	#M0070_TEMP.belong_nm1
	,	#M0070_TEMP.belong_nm2
	,	#M0070_TEMP.belong_nm3
	,	#M0070_TEMP.belong_nm4
	,	#M0070_TEMP.belong_nm5
	,	#M0070_TEMP.employee_typ_nm		
	,	#M0070_TEMP.job_nm				
	,	#M0070_TEMP.position_nm			
	,	#M0070_TEMP.grade_nm	
	,	#M0070_TEMP.treatment_applications_no			
	,	#M0070_TEMP.sheet_cd_f0021		
	,	#M0070_TEMP.sheet_nm_f0021
	,	#M0070_TEMP.detail_no
	FROM #M0070_TEMP
	LEFT JOIN F0030 ON (
		#M0070_TEMP.company_cd					= F0030.company_cd
	AND #M0070_TEMP.fiscal_year					= F0030.fiscal_year
	AND #M0070_TEMP.treatment_applications_no	= F0030.treatment_applications_no
	AND #M0070_TEMP.group_cd					= F0030.group_cd
	AND #M0070_TEMP.employee_cd					= F0030.employee_cd
	AND F0030.del_datetime IS NULL
	)
	WHERE 
		#M0070_TEMP.company_cd	=	@P_company_cd
	AND #M0070_TEMP.fiscal_year	=	@P_fiscal_year
	--■■■■■■■■■■■■■■■■■■ FILTER  ■■■■■■■■■■■■■■■■■■
	-- ORGANIZATION
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
	BEGIN
		IF NOT (@authority_typ = 3 AND @w_evaluation_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)	-- edited by viettd 2021/06/03
		BEGIN
			DELETE D FROM #M0070 AS D
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
			AND @authority_typ NOT IN(4,5) --4.会社管理者 5.総合管理者
		END
	END
	-- 本人の役職より下位の社員のみ
	IF @use_typ = 1
	BEGIN
		DELETE D FROM #M0070 AS D
		LEFT OUTER JOIN M0040 ON (
			D.company_cd		=	M0040.company_cd
		AND D.position_cd		=	M0040.position_cd
		)
		WHERE
			M0040.arrange_order <=	@arrange_order
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- #EVALUATIVE
	INSERT INTO #EVALUATIVE
	SELECT 
		#M0070.company_cd			
	,	#M0070.fiscal_year					
	,	#M0070.employee_cd					
	,	#M0070.treatment_applications_no	
	,	#M0070.sheet_cd_f0021
	,	#M0070.sheet_nm_f0021
	,	NULL							--	#F0032_TEMP.sheet_cd	
	,	NULL							--	#F0032_TEMP.sheet_nm
	,	#M0070.detail_no
	,	#M0070.group_cd
	FROM #M0070
	-- UPDATE NAME
	UPDATE #EVALUATIVE SET 
		sheet_cd_f0032	=	ISNULL(#F0032_TEMP.sheet_cd,0)
	,	sheet_nm_f0032	=	ISNULL(#F0032_TEMP.sheet_nm,'')
	FROM #EVALUATIVE
	INNER JOIN #F0032_TEMP ON (
		#EVALUATIVE.company_cd						=	#F0032_TEMP.company_cd
	AND #EVALUATIVE.fiscal_year						=	#F0032_TEMP.fiscal_year
	AND #EVALUATIVE.treatment_applications_no		=	#F0032_TEMP.treatment_applications_no
	AND #EVALUATIVE.group_cd						=	#F0032_TEMP.group_cd
	AND #EVALUATIVE.employee_cd						=	#F0032_TEMP.employee_cd
	AND #EVALUATIVE.detail_no						=	#F0032_TEMP.detail_no
	)
	--
	INSERT INTO #TEMP_ROWSPAN
	SELECT
		TEMP.company_cd
	,	TEMP.fiscal_year
	,	TEMP.group_cd
	,	COUNT(detail_no)
	FROM #F0021_TEMP AS TEMP
	GROUP BY 		
		TEMP.company_cd
	,	TEMP.fiscal_year
	,	TEMP.group_cd
	--
	INSERT INTO #TEMP_ROWSPAN_TABLE
	SELECT 
		DISTINCT
		#M0070.company_cd
	,	#M0070.fiscal_year
	,	#M0070.group_cd
	,	#M0070.employee_cd
	,	#TEMP_ROWSPAN.row_span
	FROM #M0070
	LEFT OUTER JOIN #TEMP_ROWSPAN ON (
		#M0070.company_cd			=	#TEMP_ROWSPAN.company_cd
	AND #M0070.fiscal_year			=	#TEMP_ROWSPAN.fiscal_year
	AND #M0070.group_cd				=	#TEMP_ROWSPAN.group_cd
	)
	--
	UPDATE #TEMP_ROWSPAN_TABLE SET 
		row_span	=	CASE 
							WHEN ISNULL(EVAL.row_span,0) > ISNULL(#TEMP_ROWSPAN_TABLE.row_span,0)
							THEN ISNULL(EVAL.row_span,0)
							ELSE ISNULL(#TEMP_ROWSPAN_TABLE.row_span,0)
						END
	FROM #TEMP_ROWSPAN_TABLE
	INNER JOIN (
		SELECT 
			#EVALUATIVE.company_cd				AS	company_cd
		,	#EVALUATIVE.fiscal_year				AS	fiscal_year
		,	#EVALUATIVE.group_cd				AS	group_cd
		,	#EVALUATIVE.employee_cd				AS	employee_cd
		,	COUNT(#EVALUATIVE.company_cd)		AS	row_span
		FROM #EVALUATIVE
		GROUP BY
			#EVALUATIVE.company_cd
		,	#EVALUATIVE.fiscal_year
		,	#EVALUATIVE.group_cd
		,	#EVALUATIVE.employee_cd
	) AS EVAL ON (
		#TEMP_ROWSPAN_TABLE.company_cd			=	EVAL.company_cd
	AND #TEMP_ROWSPAN_TABLE.fiscal_year			=	EVAL.fiscal_year
	AND #TEMP_ROWSPAN_TABLE.group_cd			=	EVAL.group_cd
	AND #TEMP_ROWSPAN_TABLE.employee_cd			=	EVAL.employee_cd
	)
	--	INSERT INTO #DATA FROM #M0070
	INSERT INTO #DATA
	SELECT 
		#M0070.company_cd			
	,	#M0070.fiscal_year			
	,	#M0070.group_cd			
	,	#M0070.employee_cd	
	,	#M0070.employee_nm	
	,	#M0070.employee_typ	
	,	#M0070.job_cd
	,	#M0070.grade	
	,	#M0070.position_cd			
	,	#M0070.rater_position_cd_1	
	,	#M0070.rater_position_cd_2	
	,	#M0070.rater_position_cd_3	
	,	#M0070.rater_position_cd_4	
	,	#M0070.rater_employee_cd_1	
	,	#M0070.rater_employee_cd_2	
	,	#M0070.rater_employee_cd_3	
	,	#M0070.rater_employee_cd_4
	,	#M0070.belong_cd1
	,	#M0070.belong_cd2
	,	#M0070.belong_cd3
	,	#M0070.belong_cd4
	,	#M0070.belong_cd5
	,	#M0070.belong_nm1
	,	#M0070.belong_nm2
	,	#M0070.belong_nm3
	,	#M0070.belong_nm4
	,	#M0070.belong_nm5
	,	#M0070.employee_typ_nm		
	,	#M0070.job_nm				
	,	#M0070.position_nm			
	,	#M0070.grade_nm	
	,	#M0070.treatment_applications_no
	,	#M0070.sheet_cd_f0021
	,	#M0070.sheet_nm_f0021		
	,	NULL
	,	NULL
	,	#M0070.detail_no
	FROM #M0070
	-- UPDATE sheet_cd_f0032 + sheet_nm_f0032
	UPDATE #DATA SET 
		sheet_cd_f0032	=	EVAL.sheet_cd_f0032
	,	sheet_nm_f0032	=	EVAL.sheet_nm_f0032
	FROM #DATA
	LEFT OUTER JOIN #EVALUATIVE AS EVAL ON (
		#DATA.company_cd					= EVAL.company_cd
	AND #DATA.fiscal_year					= EVAL.fiscal_year
	AND #DATA.treatment_applications_no		= EVAL.treatment_applications_no
	AND #DATA.group_cd						= EVAL.group_cd
	AND #DATA.employee_cd					= EVAL.employee_cd
	AND #DATA.detail_no						= EVAL.detail_no
	)
	-- INSERT TO #DATA RECORD NOT EXISTS IN #M0070 (F0021) BUT EXISTS IN #EVALUATIVE (F0032)
	INSERT INTO #DATA
	SELECT 
		#EVALUATIVE.company_cd			
	,	#EVALUATIVE.fiscal_year			
	,	#EVALUATIVE.group_cd			
	,	#EVALUATIVE.employee_cd	
	,	#M0070H.employee_nm	
	,	#M0070H.employee_typ	
	,	#M0070H.job_cd
	,	#M0070H.grade	
	,	#M0070H.position_cd			
	,	NULL
	,	NULL
	,	NULL
	,	NULL
	,	NULL
	,	NULL
	,	NULL
	,	NULL
	,	#M0070H.belong_cd1
	,	#M0070H.belong_cd2
	,	#M0070H.belong_cd3
	,	#M0070H.belong_cd4
	,	#M0070H.belong_cd5
	,	#M0070H.belong_nm1
	,	#M0070H.belong_nm2
	,	#M0070H.belong_nm3
	,	#M0070H.belong_nm4
	,	#M0070H.belong_nm5
	,	#M0070H.employee_typ_nm		
	,	#M0070H.job_nm				
	,	#M0070H.position_nm			
	,	#M0070H.grade_nm	
	,	#EVALUATIVE.treatment_applications_no
	,	#EVALUATIVE.sheet_cd_f0021
	,	#EVALUATIVE.sheet_nm_f0021
	,	#EVALUATIVE.sheet_cd_f0032
	,	#EVALUATIVE.sheet_nm_f0032
	,	#EVALUATIVE.detail_no
	FROM #EVALUATIVE
	INNER JOIN #M0070H ON(
		#EVALUATIVE.company_cd			=	#M0070H.company_cd
	AND #EVALUATIVE.employee_cd			=	#M0070H.employee_cd
	)
	LEFT OUTER JOIN #DATA ON(
		#EVALUATIVE.company_cd					=	#DATA.company_cd
	AND #EVALUATIVE.fiscal_year					=	#DATA.fiscal_year
	AND #EVALUATIVE.employee_cd					=	#DATA.employee_cd
	AND #EVALUATIVE.group_cd					=	#DATA.group_cd
	AND #EVALUATIVE.treatment_applications_no	=	#DATA.treatment_applications_no
	AND #EVALUATIVE.detail_no					=	#DATA.detail_no
	)
	WHERE
		#DATA.employee_cd IS NULL
	-- UPDATE INFORMATION OF rater1~rater4
	UPDATE #DATA SET 
		rater_employee_cd_1			=	M0070_MAX.rater_employee_cd_1	
	,	rater_employee_cd_2			=	M0070_MAX.rater_employee_cd_2	
	,	rater_employee_cd_3			=	M0070_MAX.rater_employee_cd_3	
	,	rater_employee_cd_4			=	M0070_MAX.rater_employee_cd_4	
	FROM #DATA
	INNER JOIN (
		SELECT 
			#M0070.company_cd			AS	company_cd
		,	#M0070.fiscal_year			AS	fiscal_year
		,	#M0070.employee_cd			AS	employee_cd
		,	#M0070.rater_employee_cd_1	AS	rater_employee_cd_1
		,	#M0070.rater_employee_cd_2	AS	rater_employee_cd_2
		,	#M0070.rater_employee_cd_3	AS	rater_employee_cd_3
		,	#M0070.rater_employee_cd_4	AS	rater_employee_cd_4
		,	MAX(#M0070.detail_no)		AS	detail_no
		FROM #M0070
		WHERE 
			#M0070.rater_employee_cd_1 IS NOT NULL
		OR	#M0070.rater_employee_cd_2 IS NOT NULL
		OR	#M0070.rater_employee_cd_3 IS NOT NULL
		OR	#M0070.rater_employee_cd_4 IS NOT NULL
		GROUP BY
			#M0070.company_cd	
		,	#M0070.fiscal_year	
		,	#M0070.employee_cd	
		,	#M0070.rater_employee_cd_1
		,	#M0070.rater_employee_cd_2
		,	#M0070.rater_employee_cd_3
		,	#M0070.rater_employee_cd_4
	) AS M0070_MAX ON (
		#DATA.company_cd			=	M0070_MAX.company_cd
	AND #DATA.fiscal_year			=	M0070_MAX.fiscal_year
	AND #DATA.employee_cd			=	M0070_MAX.employee_cd
	)
	--#RESULT
	INSERT INTO #RESULT
	SELECT 
		ROW_NUMBER() OVER(PARTITION BY #DATA.company_cd,#DATA.fiscal_year,#DATA.group_cd,#DATA.employee_cd ORDER BY #DATA.employee_cd ASC) AS row_number 
	,	#DATA.company_cd			
	,	#DATA.fiscal_year			
	,	#DATA.group_cd			
	,	#DATA.employee_cd	
	,	#DATA.employee_nm
	,	#DATA.employee_typ	
	,	#DATA.job_cd
	,	#DATA.grade
	,	#DATA.position_cd			
	,	#DATA.rater_position_cd_1	
	,	#DATA.rater_position_cd_2	
	,	#DATA.rater_position_cd_3	
	,	#DATA.rater_position_cd_4	
	,	#DATA.rater_employee_cd_1	
	,	#DATA.rater_employee_cd_2	
	,	#DATA.rater_employee_cd_3	
	,	#DATA.rater_employee_cd_4	
	,	#DATA.belong_cd1
	,	#DATA.belong_cd2
	,	#DATA.belong_cd3
	,	#DATA.belong_cd4
	,	#DATA.belong_cd5
	,	#DATA.belong_nm1
	,	#DATA.belong_nm2
	,	#DATA.belong_nm3
	,	#DATA.belong_nm4
	,	#DATA.belong_nm5
	,	#DATA.employee_typ_nm		
	,	#DATA.job_nm				
	,	#DATA.position_nm			
	,	#DATA.grade_nm	
	,	#DATA.treatment_applications_no
	,	#DATA.sheet_cd_f0021
	,	#DATA.sheet_nm_f0021
	,	#DATA.sheet_cd_f0032
	,	#DATA.sheet_nm_f0032	
	,	TEMP.row_span
	,	DENSE_RANK () OVER(ORDER BY  
								#DATA.company_cd
							,	CASE ISNUMERIC(#DATA.employee_cd) 
								   WHEN 1 
								   THEN CAST(#DATA.employee_cd AS BIGINT) 
								   ELSE 999999999999999 
								END 
							,	#DATA.employee_cd
							,	#DATA.group_cd ASC)  
	,	#DATA.detail_no
	FROM #DATA
	LEFT OUTER JOIN #TEMP_ROWSPAN_TABLE AS TEMP ON(
		#DATA.company_cd	=	TEMP.company_cd
	AND	#DATA.fiscal_year	=	TEMP.fiscal_year
	AND	#DATA.group_cd		=	TEMP.group_cd
	AND #DATA.employee_cd	=	TEMP.employee_cd
	)
	WHERE
		#DATA.company_cd		=	@P_company_cd
	ORDER BY 
		#DATA.company_cd
	,	CASE ISNUMERIC(#DATA.employee_cd) 
			WHEN 1 
			THEN CAST(#DATA.employee_cd AS BIGINT) 
			ELSE 999999999999999 
		END 
	,	#DATA.group_cd
	,	#DATA.treatment_applications_no
	,	#DATA.detail_no
	--
	SET @w_retired_employee = (
		SELECT COUNT(1)
		FROM M0070
		WHERE 
			M0070.company_cd	= @P_company_cd
		AND M0070.employee_cd	= @P_employee_cd
		AND (	
			(
				M0070.company_out_dt IS NULL
				AND DATEADD(DAY,-1,DATEADD(YEAR,1,(CONVERT(DATE,@w_year)))) >= M0070.company_in_dt
			)	
			OR (
					M0070.company_out_dt IS NOT NULL 
				AND CONVERT(DATE,@w_year) <= M0070.company_out_dt 
				AND DATEADD(DAY,-1,DATEADD(YEAR,1,(CONVERT(DATE,@w_year)))) >= M0070.company_in_dt
			)
		)
	)

	SET @w_evaluated_typ = (
		SELECT COUNT(1)
		FROM M0070
		WHERE 
			M0070.company_cd	= @P_company_cd
		AND M0070.employee_cd	= @P_employee_cd
		AND M0070.evaluated_typ = 1
	)
	-- =1 is true
	--= 0 is false
	SET @w_check_msg87 = (
		CASE
			WHEN @w_retired_employee  = 0	AND @w_evaluated_typ = 0  THEN 0
			WHEN @w_retired_employee  = 0	AND @w_evaluated_typ > 0  THEN 0
			WHEN @w_retired_employee  > 0	AND @w_evaluated_typ = 0  THEN 0
			WHEN @w_retired_employee  >	0	AND @w_evaluated_typ > 0  THEN 1
		ELSE ''
		END 
	) 
	-- INSERT DATA INTO #F0200
	INSERT INTO #F0200
	SELECT
		R.company_cd
	,	R.fiscal_year
	,	R.employee_cd
	,	R.treatment_applications_no
	,	COUNT(R.company_cd)
	FROM #RESULT AS R
	LEFT JOIN F0200 ON (
		R.company_cd				=	F0200.company_cd
	AND	R.fiscal_year				=	F0200.fiscal_year
	AND	R.employee_cd				=	F0200.employee_cd
	AND	R.treatment_applications_no	=	F0200.treatment_applications_no
	)
	WHERE
		F0200.confirm_datetime IS NOT NULL
	GROUP BY
		R.company_cd
	,	R.fiscal_year
	,	R.employee_cd
	,	R.treatment_applications_no
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--[0]
	SELECT 
		#RESULT.row_number			
	,	#RESULT.company_cd			
	,	#RESULT.fiscal_year			
	,	#RESULT.group_cd			
	,	#RESULT.employee_cd			
	,	ISNULL(#RESULT.employee_nm,'')								AS employee_nm	
	,	#RESULT.employee_typ	
	,	#RESULT.job_cd	
	,	#RESULT.grade
	,	#RESULT.position_cd			
	,	#RESULT.rater_position_cd_1	
	,	#RESULT.rater_position_cd_2	
	,	#RESULT.rater_position_cd_3	
	,	#RESULT.rater_position_cd_4	
	,	ISNULL(#RESULT.rater_employee_cd_1,'')						AS rater_employee_cd_1
	,	ISNULL(#RESULT.rater_employee_cd_2,'')						AS rater_employee_cd_2
	,	ISNULL(#RESULT.rater_employee_cd_3,'')						AS rater_employee_cd_3
	,	ISNULL(#RESULT.rater_employee_cd_4,'')						AS rater_employee_cd_4 
	,	ISNULL(M0070_A.employee_nm,'')								AS rater_employee_nm_1
	,	ISNULL(M0070_B.employee_nm,'')								AS rater_employee_nm_2
	,	ISNULL(M0070_C.employee_nm,'')								AS rater_employee_nm_3
	,	ISNULL(M0070_D.employee_nm,'')								AS rater_employee_nm_4
	,	ISNULL(#RESULT.belong_cd1,'')								AS belong_cd1
	,	ISNULL(#RESULT.belong_cd2,'')								AS belong_cd2
	,	ISNULL(#RESULT.belong_cd3,'')								AS belong_cd3
	,	ISNULL(#RESULT.belong_cd4,'')								AS belong_cd4
	,	ISNULL(#RESULT.belong_cd5,'')								AS belong_cd5
	,	ISNULL(#RESULT.belong_nm1,'')								AS belong_nm1
	,	ISNULL(#RESULT.belong_nm2,'')								AS belong_nm2
	,	ISNULL(#RESULT.belong_nm3,'')								AS belong_nm3
	,	ISNULL(#RESULT.belong_nm4,'')								AS belong_nm4
	,	ISNULL(#RESULT.belong_nm5,'')								AS belong_nm5
	,	ISNULL(#RESULT.employee_typ_nm,'')							AS employee_typ_nm
	,	ISNULL(#RESULT.job_nm,'')									AS job_nm
	,	ISNULL(#RESULT.position_nm,'')								AS position_nm
	,	ISNULL(#RESULT.grade_nm,'')									AS grade_nm
	,	#RESULT.treatment_applications_no							AS treatment_applications_no
	,	#RESULT.detail_no											AS detail_no						-- add by viettd 2020/01/07
	,	#RESULT.sheet_cd1											AS sheet_cd_f0021		
	,	ISNULL(#RESULT.sheet_nm1,'')								AS sheet_nm1
	,	#RESULT.sheet_cd2											AS sheet_cd_f0032 
	,	ISNULL(#RESULT.sheet_nm2,'')								AS sheet_nm2 
	,	#RESULT.row					
    ,   IIF(#RESULT.row_number = 1 ,  'tr_first' , 'tr_second' )+' '+IIF(key_number%2 = 0 ,  '' , 'tr-odd' ) AS classTr
	,	IIF(#RESULT.row_number = 1 ,  ''        , 'hidden' )		AS classCheckFirstHidden
    ,   IIF(#RESULT.row_number = 1 ,  ''  , '' )					AS classCheckSecondHidden
	,	CONCAT('ckb0' , #RESULT.employee_cd	)						AS checkemployee_cd
	,	CONCAT(#RESULT.group_cd		 , #RESULT.employee_cd)			AS row_emp
	,	''															AS detail_no_f0021	--Longvv add 2018/12/11
	,	@w_check_msg87												AS check_msg87
	,	ISNULL(#F0200.num,0)										AS hasConfirm
	FROM #RESULT													
	LEFT JOIN M0070 AS M0070_A ON (
		#RESULT.company_cd			= M0070_A.company_cd
	AND #RESULT.rater_employee_cd_1	= M0070_A.employee_cd
	)
	LEFT JOIN M0070 AS M0070_B ON (
		#RESULT.company_cd			= M0070_B.company_cd
	AND #RESULT.rater_employee_cd_2	= M0070_B.employee_cd
	)
	LEFT JOIN M0070 AS M0070_C ON (
		#RESULT.company_cd			= M0070_C.company_cd
	AND #RESULT.rater_employee_cd_3	= M0070_C.employee_cd
	)
	LEFT JOIN M0070 AS M0070_D ON (
		#RESULT.company_cd			= M0070_D.company_cd
	AND #RESULT.rater_employee_cd_4	= M0070_D.employee_cd
	)
	LEFT JOIN M0070 AS M0070_E ON (
		#RESULT.company_cd			= M0070_E.company_cd
	AND #RESULT.employee_cd			= M0070_E.employee_cd
	)
	LEFT JOIN #F0200 ON (
		#RESULT.company_cd					= #F0200.company_cd
	AND #RESULT.employee_cd					= #F0200.employee_cd
	AND #RESULT.treatment_applications_no	= #F0200.treatment_applications_no
	)
	ORDER BY 
		#RESULT.company_cd
	,	CASE ISNUMERIC(#RESULT.employee_cd) 
		   WHEN 1 
		   THEN CAST(#RESULT.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	#RESULT.employee_cd
	,	#RESULT.group_cd
	--[1]
	 SET @w_status = 'OK'
	 SELECT @w_status as status
	 --[2]
	 SELECT 
		F0021.company_cd
	,	F0021.fiscal_year
	,	F0021.group_cd
	,	F0021.sheet_cd
	,	F0021.treatment_applications_no
	 FROM F0021
	 WHERE 
		F0021.company_cd	= @P_company_cd
	AND F0021.fiscal_year	= @P_fiscal_year
	AND F0021.group_cd		= @P_group_cd
	ORDER BY F0021.sheet_cd
	--[3]
	DECLARE 
		@Count_Rater	SMALLINT	= 0
	SELECT 
	@Count_Rater =(	CASE
						WHEN
							SUM(ISNULL(M0100.target_evaluation_typ_1,0)+ISNULL(M0100.target_evaluation_typ_2,0)+ISNULL(M0100.target_evaluation_typ_3,0)+ISNULL(M0100.target_evaluation_typ_4,0)) 
						>	SUM(ISNULL(M0100.evaluation_typ_1,0)+ISNULL(M0100.evaluation_typ_2,0)+ISNULL(M0100.evaluation_typ_3,0)+ISNULL(M0100.evaluation_typ_4,0)) 
						THEN SUM(ISNULL(M0100.target_evaluation_typ_1,0)+ISNULL(M0100.target_evaluation_typ_2,0)+ISNULL(M0100.target_evaluation_typ_3,0)+ISNULL(M0100.target_evaluation_typ_4,0)) 
						ELSE SUM(ISNULL(M0100.evaluation_typ_1,0)+ISNULL(M0100.evaluation_typ_2,0)+ISNULL(M0100.evaluation_typ_3,0)+ISNULL(M0100.evaluation_typ_4,0)) 
					END)
	FROM M0100
	WHERE 
		M0100.company_cd	=	@P_company_cd
	AND	M0100.del_datetime	IS NULL
	SELECT
		CASE
			WHEN	@Count_Rater >= 1
			THEN	''
			ELSE	'hidden'
		END						AS	Rater1
	,	CASE
			WHEN	@Count_Rater >= 2
			THEN	''
			ELSE	'hidden'
		END						AS	Rater2
	,	CASE
			WHEN	@Count_Rater >= 3
			THEN	''
			ELSE	'hidden'
		END						AS	Rater3
	,	CASE
			WHEN	@Count_Rater = 4
			THEN	''
			ELSE	'hidden'
		END						AS	Rater4
	--[4]
	--DROP TABLE
	DROP TABLE #DATA
	DROP TABLE #EVALUATIVE
	DROP TABLE #F0021_TEMP
	DROP TABLE #F0032_TEMP
	DROP TABLE #M0070
	DROP TABLE #M0070_EMPLOYEE_CD
	DROP TABLE #M0070_TEMP
	DROP TABLE #TEMP_ROWSPAN
	DROP TABLE #RESULT
	DROP TABLE #ROWSPAN
	DROP TABLE #EMPLOYEE_COMMON
	DROP TABLE #M0030
	DROP TABLE #M0040
	DROP TABLE #M0050
	DROP TABLE #M0060
	DROP TABLE #M0070H
	DROP TABLE #JSON_LIST_TREATMENT
	DROP TABLE #TABLE_ORGANIZATION
	DROP TABLE #F0021
	DROP TABLE #F0032
	DROP TABLE #TEMP_ROWSPAN_TABLE
	DROP TABLE #F0200
END
GO