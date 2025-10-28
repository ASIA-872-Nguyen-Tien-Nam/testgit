DROP PROCEDURE [SPC_VIEWER_SETTING_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*  処理概要/process overview	:	SERACH DATA
--*  作成日/create date			:	2023/04/24						
--*　作成者/creater				:	quangnd								
--*   	
--*  更新日/update date			:  2023/07/12
--*　更新者/updater				:　namnt
--*　更新内容/update content	:				
--****************************************************************************************
  --EXEC SPC_VIEWER_SETTING_FND1 '2023','0','1','-1','1','20','','-1','-1','-1','-1','-1','-1','-1','-1','6','-1','10035','hanhntm','1';

CREATE PROCEDURE [SPC_VIEWER_SETTING_FND1]
	-- Add the parameters for the stored procedure here
	@P_fiscal_year			SMALLINT		=	0
,	@P_employee_cd			NVARCHAR(10)	=	''
,	@P_report_kind			SMALLINT		=	0
,	@P_report_no			SMALLINT		=	0
,	@P_page					INT				=	1
,	@P_page_size			INT				=	20
--
,	@P_employee_cd_key		NVARCHAR(10)	=	''
,	@P_employee_nm_key		NVARCHAR(50)	=	''
,	@P_employee_typ			SMALLINT		=	-1
,	@P_belong_cd1			NVARCHAR(20)	=	'-1'
,	@P_belong_cd2			NVARCHAR(20)	=	'-1'
,	@P_belong_cd3			NVARCHAR(20)	=	'-1'
,	@P_belong_cd4			NVARCHAR(20)	=	'-1'
,	@P_belong_cd5			NVARCHAR(20)	=	'-1'
,	@P_job_cd				SMALLINT		=	-1
,	@P_position_cd			INT				=	-1
,	@P_screen_group_cd		SMALLINT		=	-1
,	@P_company_cd			SMALLINT		=	0
,	@P_cre_user				NVARCHAR(50)	=	''	-- LOGIN EMPLOYEE
,	@P_mode					SMALLINT		=	0	
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								DATE			=	SYSDATETIME()
	,	@w_totalRecord						bigint				=	0
	,	@w_pageMax							int					=	0	
	,	@w_page_size						int					=	50
	,	@w_page								int					=	0
	
	,	@w_report_authority_typ				smallint			=	0
	,	@w_report_authority_cd				smallint			=	0

	,	@w_use_typ							smallint			=	0	
	,	@w_arrange_order					int					=	0

	,	@w_login_position_cd				int					=	0
	,	@w_login_employee_cd				nvarchar(10)		=	''
	,	@w_choice_in_screen					tinyint				=	0
	,	@w_evaluation_organization_cnt		INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	,	@w_today							date				=	GETDATE()
	,	@w_deadline_date					date				=	NULL
	,	@w_system_authority_typ				smallint			=	0
	--
	,	@beginning_date						datetime			=	null
	,	@start_date							datetime			=	null
	,	@end_date							datetime			=	null
	,	@w_company_out_dt					datetime			=	null
	,	@w_company_in_dt					datetime			=	null
	--
	CREATE TABLE #EMP_ACTIVE (
		id					int		identity(1,1)
	,	employee_cd			nvarchar(10)
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
	--#LIST_POSITION
	CREATE TABLE #LIST_POSITION(
		id								int			identity(1,1)
	,	position_cd						int
	,	mode							smallint	-- 0.choice in screen 1. get from master
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
	--
	CREATE TABLE #M0070H_LIST(
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
	--#TABLE_RESULT
	CREATE TABLE #TABLE_RESULT(
		id				int		identity(1,1)
	,	check_box		smallint
	,	company_cd		smallint
	,	employee_cd		nvarchar(10)
	,	belong_cd_1		nvarchar(20)
	,	belong_cd_2		nvarchar(20)
	,	belong_cd_3		nvarchar(20)
	,	belong_cd_4		nvarchar(20)
	,	belong_cd_5		nvarchar(20)
	,	position_cd		int
	)
	--
	CREATE TABLE #F4121(
		id							INT	IDENTITY(1,1)
	,	viewer_employee_cd			NVARCHAR(10)
	)
	--get deadline f4100
	SELECT
		@w_deadline_date = MAX(deadline_date)
	FROM F4100
	WHERE
		company_cd	= @P_company_cd
	AND fiscal_year = @P_fiscal_year
	AND
	(
		@P_screen_group_cd = -1
	OR	@P_screen_group_cd > 0 AND group_cd	= @P_screen_group_cd
	)
	AND
	(
		@P_report_kind = -1
	OR	@P_report_kind > 0 AND report_kind	= @P_report_kind
	)
	AND user_typ = 1
	AND del_datetime IS NULL
	--
	SELECT 
		@beginning_date = M9100.[report_beginning_date]		-- edited by viettd 2021/04/22 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	-- CACULATE BEGIN AND END OF DATE
	IF @beginning_date IS NOT NULL
	BEGIN
		SET @start_date	=	CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
	END
	ELSE
	BEGIN
		SET @start_date	=	CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/01/01') AS DATE)
	END
	SET @end_date = DATEADD(year, 1, @start_date)
	--
	INSERT INTO #EMP_ACTIVE
	SELECT
		employee_cd
	FROM M0070
	WHERE
		company_cd = @P_company_cd
	AND company_in_dt <= @end_date
	AND (company_out_dt IS NULL
		OR company_out_dt IS NOT NULL AND company_out_dt >= @start_date)
	AND	del_datetime IS NULL
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--GET INFORMATION 
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	SELECT 
		@w_report_authority_typ			=	ISNULL(S0010.report_authority_typ,0)
	,	@w_report_authority_cd			=	ISNULL(S0010.report_authority_cd,0)
	,	@w_login_position_cd			=	ISNULL(M0070.position_cd,0)
	,	@w_login_employee_cd			=	ISNULL(M0070.employee_cd,0)
	FROM S0010
	LEFT OUTER JOIN M0070 ON (
		S0010.company_cd		=	M0070.company_cd
	AND S0010.employee_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	WHERE 
		S0010.company_cd	= @P_company_cd 
	AND S0010.user_id		= @P_cre_user
	AND S0010.del_datetime IS NULL
	-- get @use_typ
	SELECT 
		@w_use_typ		=	ISNULL(S4020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
	FROM S4020
	WHERE
		S4020.company_cd		=	@P_company_cd
	AND S4020.authority_cd		=	@w_report_authority_cd
	AND S4020.del_datetime IS NULL
	--	@w_system_authority_typ
	SET @w_system_authority_typ	=	@w_report_authority_typ
	-- get @arrange_order
	SELECT 
		@w_arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@w_login_position_cd
	AND M0040.del_datetime IS NULL
	-- COUNT ALL ORGANIZATIONS
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_report_authority_cd,5)
	-- GET @w_organization_belong_person_typ
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_report_authority_cd,5)
	--
	SET @w_page				=	@P_page
	SET @w_page_size		=	@P_page_size
	-- INSERT DATA INTO #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 '',@P_cre_user,@P_company_cd, 5
	--
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
	-- #M0070H
	-- CHECK @w_report_authority_typ = 4,5 THEN NOT APPLY THIS CONDITION (MAX(F4100.deadline_date))
	IF @w_report_authority_typ IN (4,5)
	BEGIN
		INSERT INTO #M0070H
		EXEC [dbo].SPC_REFER_M0070H_INQ1 @w_today,'',@P_company_cd
	END
	ELSE
	BEGIN
		INSERT INTO #M0070H
		EXEC [dbo].SPC_REFER_M0070H_INQ1 @w_deadline_date,'',@P_company_cd
	END
	-- EMP COMPANY OUT
	IF EXISTS ( SELECT 1 FROM #EMP_ACTIVE)
	BEGIN
		DELETE D FROM #M0070H AS D
		LEFT OUTER JOIN #EMP_ACTIVE ON (
			D.employee_cd	= #EMP_ACTIVE.employee_cd
		)
		WHERE 
			#EMP_ACTIVE.employee_cd IS NULL
	END 

	--
	INSERT INTO #M0070H_LIST
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @w_today,'',@P_company_cd
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--GET DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	INSERT INTO #F4121
	SELECT 	
		F4121.viewer_employee_cd												
	FROM F4121
	WHERE
		F4121.company_cd	=	@P_company_cd
	AND F4121.fiscal_year	=	@P_fiscal_year
	AND F4121.employee_cd	=	@P_employee_cd
	AND F4121.report_kind	=	@P_report_kind
	AND F4121.del_datetime IS NULL
	GROUP BY
		F4121.viewer_employee_cd
	--
	IF EXISTS ( SELECT 1 FROM #F4121) AND @P_mode = 1
	BEGIN
		INSERT #TABLE_RESULT
		SELECT 
			1
		,	#M0070H_LIST.company_cd
		,	#F4121.viewer_employee_cd
		,	#M0070H_LIST.belong_cd_1	
		,	#M0070H_LIST.belong_cd_2	
		,	#M0070H_LIST.belong_cd_3	
		,	#M0070H_LIST.belong_cd_4	
		,	#M0070H_LIST.belong_cd_5	
		,	#M0070H_LIST.position_cd	
		FROM #F4121 
		INNER JOIN #M0070H_LIST ON (
			#F4121.viewer_employee_cd		=	#M0070H_LIST.employee_cd
		)
		GOTO VIEW_COMPLETE
	END
	ELSE IF @P_mode = 0
	BEGIN
		INSERT #TABLE_RESULT
		SELECT 
			0
		,	M0070.company_cd
		,	M0070.employee_cd
		,	#M0070H.belong_cd_1	
		,	#M0070H.belong_cd_2	
		,	#M0070H.belong_cd_3	
		,	#M0070H.belong_cd_4	
		,	#M0070H.belong_cd_5	
		,	#M0070H.position_cd	
		FROM M0070 
		INNER JOIN #M0070H ON (
			M0070.company_cd		=	#M0070H.company_cd
		AND M0070.employee_cd		=	#M0070H.employee_cd
		)
		WHERE 
			M0070.company_cd	=	@P_company_cd
		AND M0070.del_datetime IS NULL
	END
	-- FILTER @P_group_cd
	
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--FILTER DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- FILTER 役職
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
	BEGIN
		SET @w_choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
		-- 1.choice in screen
		IF @w_choice_in_screen = 1
		BEGIN
			DELETE D FROM #TABLE_RESULT AS D
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
		ELSE IF NOT (@w_system_authority_typ = 3 AND @w_evaluation_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)
		BEGIN
			DELETE D FROM #TABLE_RESULT AS D
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
			AND @w_system_authority_typ NOT IN(4,5)		--4.会社管理者 5.総合管理者
		END
	END
	-- choice in screen
	IF EXISTS (SELECT 1 FROM #LIST_POSITION WHERE mode = 0)
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D
		LEFT OUTER JOIN #LIST_POSITION AS S ON (
			D.company_cd			=	@P_company_cd
		AND D.position_cd			=	S.position_cd
		)
		WHERE
			S.position_cd IS NULL
	END
	ELSE -- not choice in screen
	BEGIN
		IF @w_system_authority_typ NOT IN (4,5)
		BEGIN
			DELETE D FROM #TABLE_RESULT AS D
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
	VIEW_COMPLETE:
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	SET @w_totalRecord = (
		SELECT COUNT(1) 
		FROM #TABLE_RESULT
	LEFT OUTER JOIN #M0070H ON (
		#TABLE_RESULT.company_cd	=	#M0070H.company_cd
	AND #TABLE_RESULT.employee_cd	=	#M0070H.employee_cd
	) 
	WHERE 
		(
		#M0070H.employee_nm LIKE '%'+@P_employee_nm_key+'%'
	OR	#M0070H.employee_ab_nm LIKE '%'+@P_employee_nm_key+'%'
	OR	#M0070H.furigana LIKE '%'+@P_employee_nm_key+'%'
	)
	AND
	(
		#M0070H.employee_cd LIKE '%'+@P_employee_cd_key+'%'
	)
	AND (
		@P_employee_typ = -1
	OR	@P_employee_typ > 0 AND #M0070H.employee_typ = @P_employee_typ
	)
	AND (
		@P_position_cd = -1
	OR	@P_position_cd > 0 AND #M0070H.position_cd = @P_position_cd
	)
	AND (
		@P_job_cd = -1
	OR	@P_job_cd > 0 AND #M0070H.job_cd = @P_job_cd
	)
	AND (
		@P_belong_cd1 = '-1'
	OR	@P_belong_cd1 <> '-1' AND #M0070H.belong_cd_1 = @P_belong_cd1
	)
	AND (
		@P_belong_cd2 = '-1'
	OR	@P_belong_cd2 <> '-1' AND #M0070H.belong_cd_2 = @P_belong_cd2
	)
	AND (
		@P_belong_cd3 = '-1'
	OR	@P_belong_cd3 <> '-1' AND #M0070H.belong_cd_3 = @P_belong_cd3
	)
	AND (
		@P_belong_cd4 = '-1'
	OR	@P_belong_cd4 <> '-1' AND #M0070H.belong_cd_4 = @P_belong_cd4
	)
	AND (
		@P_belong_cd5 = '-1'
	OR	@P_belong_cd5 <> '-1' AND #M0070H.belong_cd_5 = @P_belong_cd5
	)
	
	)
	SET @w_pageMax = CEILING(CAST(@w_totalRecord AS FLOAT) / @w_page_size)
	IF @w_pageMax = 0
	BEGIN
		SET @w_pageMax = 1
	END
	IF @w_page > @w_pageMax
	BEGIN
		SET @w_page = @w_pageMax
	END
	-- 0. ■■■■■■■■■■■■■■■■■■ search ■■■■■■■■■■■■■■■■■■
	--[0]

	IF @P_mode = 1
	BEGIN
	SELECT 
		#TABLE_RESULT.check_box							AS  check_box
	,	#TABLE_RESULT.employee_cd						AS	employee_cd
	,	ISNULL(#M0070H.employee_nm,'')					AS	employee_nm
	,	ISNULL(#M0070H.employee_typ_nm,'')				AS	employee_typ_nm
	,	ISNULL(#M0070H.belong_nm_1,'')					AS	organization_nm1
	,	ISNULL(#M0070H.belong_nm_2,'')					AS	organization_nm2
	,	ISNULL(#M0070H.belong_nm_3,'')					AS	organization_nm3
	,	ISNULL(#M0070H.belong_nm_4,'')					AS	organization_nm4
	,	ISNULL(#M0070H.belong_nm_5,'')					AS	organization_nm5
	,	ISNULL(#M0070H.position_nm,'')					AS	position_nm
	,	ISNULL(#M0070H.job_nm,'')						AS	job_nm
	FROM #TABLE_RESULT
	LEFT OUTER JOIN #M0070H ON (
		#TABLE_RESULT.company_cd	=	#M0070H.company_cd
	AND #TABLE_RESULT.employee_cd	=	#M0070H.employee_cd
	) 
	LEFT OUTER JOIN M0070 ON (
		#TABLE_RESULT.company_cd	=	M0070.company_cd
	AND #TABLE_RESULT.employee_cd	=	M0070.employee_cd
	) 
	WHERE 
		(
		#M0070H.employee_nm LIKE '%'+@P_employee_nm_key+'%'
	OR	#M0070H.employee_ab_nm LIKE '%'+@P_employee_nm_key+'%'
	OR	#M0070H.furigana LIKE '%'+@P_employee_nm_key+'%'
	)
	AND
	(
		#M0070H.employee_cd LIKE '%'+@P_employee_cd_key+'%'
	)
	AND (
		@P_employee_typ = -1
	OR	@P_employee_typ > 0 AND #M0070H.employee_typ = @P_employee_typ
	)
	AND (
		@P_position_cd = -1
	OR	@P_position_cd > 0 AND #M0070H.position_cd = @P_position_cd
	)
	AND (
		@P_job_cd = -1
	OR	@P_job_cd > 0 AND #M0070H.job_cd = @P_job_cd
	)
	AND (
		@P_belong_cd1 = '-1'
	OR	@P_belong_cd1 <> '-1' AND #M0070H.belong_cd_1 = @P_belong_cd1
	)
	AND (
		@P_belong_cd2 = '-1'
	OR	@P_belong_cd2 <> '-1' AND #M0070H.belong_cd_2 = @P_belong_cd2
	)
	AND (
		@P_belong_cd3 = '-1'
	OR	@P_belong_cd3 <> '-1' AND #M0070H.belong_cd_3 = @P_belong_cd3
	)
	AND (
		@P_belong_cd4 = '-1'
	OR	@P_belong_cd4 <> '-1' AND #M0070H.belong_cd_4 = @P_belong_cd4
	)
	AND (
		@P_belong_cd5 = '-1'
	OR	@P_belong_cd5 <> '-1' AND #M0070H.belong_cd_5 = @P_belong_cd5
	)
	AND M0070.company_out_dt IS  NULL OR M0070.company_out_dt >=  @w_time
	END
	ELSE
	BEGIN
	SELECT 
		#TABLE_RESULT.check_box							AS  check_box
	,	#TABLE_RESULT.employee_cd						AS	employee_cd
	,	ISNULL(#M0070H.employee_nm,'')					AS	employee_nm
	,	ISNULL(#M0070H.employee_typ_nm,'')				AS	employee_typ_nm
	,	ISNULL(#M0070H.belong_nm_1,'')					AS	organization_nm1
	,	ISNULL(#M0070H.belong_nm_2,'')					AS	organization_nm2
	,	ISNULL(#M0070H.belong_nm_3,'')					AS	organization_nm3
	,	ISNULL(#M0070H.belong_nm_4,'')					AS	organization_nm4
	,	ISNULL(#M0070H.belong_nm_5,'')					AS	organization_nm5
	,	ISNULL(#M0070H.position_nm,'')					AS	position_nm
	,	ISNULL(#M0070H.job_nm,'')						AS	job_nm
	FROM #TABLE_RESULT
	LEFT OUTER JOIN #M0070H ON (
		#TABLE_RESULT.company_cd	=	#M0070H.company_cd
	AND #TABLE_RESULT.employee_cd	=	#M0070H.employee_cd
	) 
	LEFT OUTER JOIN M0070 ON (
		#TABLE_RESULT.company_cd	=	M0070.company_cd
	AND #TABLE_RESULT.employee_cd	=	M0070.employee_cd
	) 
	WHERE 
		(
		#M0070H.employee_nm LIKE '%'+@P_employee_nm_key+'%'
	OR	#M0070H.employee_ab_nm LIKE '%'+@P_employee_nm_key+'%'
	OR	#M0070H.furigana LIKE '%'+@P_employee_nm_key+'%'
	)
	AND
	(
		#M0070H.employee_cd LIKE '%'+@P_employee_cd_key+'%'
	)
	AND (
		@P_employee_typ = -1
	OR	@P_employee_typ > 0 AND #M0070H.employee_typ = @P_employee_typ
	)
	AND (
		@P_position_cd = -1
	OR	@P_position_cd > 0 AND #M0070H.position_cd = @P_position_cd
	)
	AND (
		@P_job_cd = -1
	OR	@P_job_cd > 0 AND #M0070H.job_cd = @P_job_cd
	)
	AND (
		@P_belong_cd1 = '-1'
	OR	@P_belong_cd1 <> '-1' AND #M0070H.belong_cd_1 = @P_belong_cd1
	)
	AND (
		@P_belong_cd2 = '-1'
	OR	@P_belong_cd2 <> '-1' AND #M0070H.belong_cd_2 = @P_belong_cd2
	)
	AND (
		@P_belong_cd3 = '-1'
	OR	@P_belong_cd3 <> '-1' AND #M0070H.belong_cd_3 = @P_belong_cd3
	)
	AND (
		@P_belong_cd4 = '-1'
	OR	@P_belong_cd4 <> '-1' AND #M0070H.belong_cd_4 = @P_belong_cd4
	)
	AND (
		@P_belong_cd5 = '-1'
	OR	@P_belong_cd5 <> '-1' AND #M0070H.belong_cd_5 = @P_belong_cd5
	)
	AND (M0070.company_out_dt IS  NULL OR M0070.company_out_dt >=  @w_time)
	ORDER BY 
		CASE ISNUMERIC(#TABLE_RESULT.employee_cd) 
			WHEN 1 
			THEN CAST(#TABLE_RESULT.employee_cd AS BIGINT) 
			ELSE 999999999999999 
		END 
	,	#TABLE_RESULT.employee_cd
	offset (@w_page-1) * @w_page_size ROWS
	FETCH NEXT @w_page_size ROWS only
	END

	--[1]
	SELECT	
		@w_totalRecord						AS totalRecord
	,	@w_pageMax							AS pageMax
	,	@w_page								AS page
	,	@w_page_size						AS pagesize
	,	((@w_page - 1) * @w_page_size + 1)	AS offset
	--[2]
	SELECT
		ISNULL(#M0070H.employee_nm,'')  AS employee_nm
	,	@P_employee_cd					AS employee_cd
	,	@P_fiscal_year					AS fiscal_year
	,	@P_report_kind					AS report_kind
	FROM #M0070H
	WHERE
	#M0070H.employee_cd = @P_employee_cd
END

