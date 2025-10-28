DROP PROCEDURE [SPC_rI1021_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--EXEC SPC_rI1021_FND1 '{"report_kinds":"1","fiscal_year":"2023","report_group":"1","employee_typ":"-1","employee_cdX":"","page":"1","page_size":"20","list_organization_step1":[],"list_organization_step2":[],"list_organization_step3":[],"list_organization_step4":[],"list_organization_step5":[],"list_position_cd":[],"list_employee_cd":[{"employee_cd":"2"}]}','721','740','2';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	rI1021-search
--*  
--*  作成日/create date			:	2023/04/27					
--*　作成者/creater				:	quangnd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rI1021_FND1]
	-- Add the parameters for the stored procedure here
	@P_json						nvarchar(max)		=	''	
,	@P_cre_user					nvarchar(50)		=	''		-- login user id
,	@P_company_cd				smallint			=	0
,	@P_mode						INT					=	0 -- 0.search | 1.export csv |2.approval
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								datetime			=	SYSDATETIME()
	,	@w_totalRecord						bigint				=	0
	,	@w_pageMax							int					=	0	
	,	@w_page_size						int					=	50
	,	@w_page								int					=	0
	--
	,	@w_report_authority_typ				smallint			=	0
	,	@w_report_authority_cd				smallint			=	0
	,	@w_setting_authority_typ			smallint			=	0
	,	@w_setting_authority_cd				smallint			=	0

	,	@w_use_typ							smallint			=	0	
	,	@w_arrange_order					int					=	0

	,	@w_login_position_cd				int					=	0
	,	@w_choice_in_screen					tinyint				=	0
	,	@w_evaluation_organization_cnt		INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	,	@w_today							date				=	NULL
	,	@w_system_authority_typ				smallint			=	0
	--
	,	@w_report_kinds						smallint			=	0
	,	@P_fiscal_year						smallint			=	0
	,	@P_group_cd							smallint			=	0
	,	@w_employee_typ						smallint			=	0
	,	@w_employee_cdX						nvarchar(10)		=	''
	,	@w_language							SMALLINT			=	1	--1 jp / 2 en
	--phục vụ check mode 2
	,	@i									smallint			=	1
	,	@w_employee_approval				nvarchar(10)		=	''
	--nghi viec
	,	@beginning_date						datetime			=	null
	,	@start_date							datetime			=	null
	,	@end_date							datetime			=	null
	,	@w_company_out_dt					datetime			=	null
	,	@w_company_in_dt					datetime			=	null
	,	@w_browse_position_typ				smallint			=	0
	,	@w_browse_department_typ			smallint			=	0
	,	@w_arrange_order_2					int					=	0
	,	@w_position_cd_2					int					=	0
	--
	IF object_id('tempdb..#TABLE_ORGANIZATION', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_ORGANIZATION
    END
	--
	IF object_id('tempdb..#LIST_POSITION', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #LIST_POSITION
    END
	--
	IF object_id('tempdb..#M0070H', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070H
    END
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
	--#TABLE_ORGANIZATION
	CREATE TABLE #TABLE_ORGANIZATION_2 (
		organization_typ				tinyint
	,	organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)	
	,	choice_in_screen				tinyint		-- 1.choice in screen 0.get from master S0022
	)
	--#LIST_POSITION
	CREATE TABLE #LIST_POSITION_2(
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
	--#M0070H
	CREATE TABLE #M0070H_VIEW(
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
	--#LIST_VIEW
	CREATE TABLE #LIST_VIEW(
		company_cd						smallint
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
	)
	--#TABLE_RESULT
	CREATE TABLE #TABLE_RESULT(
		id				int		identity(1,1)
	,	company_cd		smallint
	,	employee_cd		nvarchar(10)
	,	group_cd		smallint
	,	employee_typ	smallint
	,	position_cd		int
	,	belong_cd_1		nvarchar(20)
	,	belong_cd_2		nvarchar(20)
	,	belong_cd_3		nvarchar(20)
	,	belong_cd_4		nvarchar(20)
	,	belong_cd_5		nvarchar(20)
	,	list_viewer		nvarchar(max)
	)
	CREATE TABLE #HEADER(
		employee_cd						nvarchar(50)
	,	viewer_employee_cd				nvarchar(50)
	)
	--
	CREATE TABLE #F4121 (
		id					int		identity(1,1)
	,	company_cd			smallint
	,	employee_cd			nvarchar(10)
	,	viewer_employee_cd	nvarchar(10)
	,	viewer_employee_nm	nvarchar(101)
	)
	CREATE TABLE #F4121_JSON (
		company_cd			smallint
	,	employee_cd			nvarchar(10)
	,	list_viewer			nvarchar(max)
	)
	--
	CREATE TABLE #EMP_APPROVAL (
		id					int		identity(1,1)
	,	employee_cd			nvarchar(10)
	)
	-- MODE = 2
	CREATE TABLE #EMP_ACTIVE (
		id					int		identity(1,1)
	,	employee_cd			nvarchar(10)
	)
	--
	CREATE TABLE #M4603 (
		company_cd				SMALLINT
	,	group_cd				SMALLINT
	,	organization_cd_1		NVARCHAR(20)
	,	organization_cd_2		NVARCHAR(20)
	,	organization_cd_3		NVARCHAR(20)
	,	organization_cd_4		NVARCHAR(20)
	,	organization_cd_5		NVARCHAR(20)	
	)
	--
	CREATE TABLE #M4604 (
		company_cd				SMALLINT
	,	group_cd				SMALLINT
	,	attribute				SMALLINT
	,	code					SMALLINT	
	)	
	--
	CREATE TABLE #M0060
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	employee_typ			SMALLINT
	,	group_cd				SMALLINT
	)	
	--
	CREATE TABLE #M0050
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	grade					SMALLINT
	,	group_cd				SMALLINT
	)
	--
	CREATE TABLE #M0040
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	position_cd				INT
	,	group_cd				SMALLINT
	)
	--
	CREATE TABLE #M0030
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	job_cd					SMALLINT
	,	group_cd				SMALLINT
	)
	CREATE TABLE #LIST_VIEW_GROUP(
		company_cd						smallint
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
	)
	--
	CREATE TABLE #M0040_EMP
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	position_cd				INT
	)
	--#INFO_EMP
	CREATE TABLE #INFO_EMP(
		company_cd						smallint
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
	)
	--
	CREATE TABLE #F4121_FAKE (
		id					int		identity(1,1)
	,	company_cd			smallint
	,	employee_cd			nvarchar(10)
	,	viewer_employee_cd	nvarchar(10)
	,	viewer_employee_nm	nvarchar(101)
	)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--GET INFORMATION 
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	SELECT 
		@w_report_authority_typ			=	ISNULL(S0010.report_authority_typ,0)
	,	@w_report_authority_cd			=	ISNULL(S0010.report_authority_cd,0)
	,	@w_login_position_cd			=	ISNULL(M0070.position_cd,0)
	,	@w_language						=	ISNULL(S0010.language,1)
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
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_report_authority_cd, 5)
	-- GET @w_organization_belong_person_typ
	SET @w_organization_belong_person_typ = ISNULL([dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_report_authority_cd, 5),0)
	--
	SET @w_employee_typ		=	JSON_VALUE(@P_json,'$.employee_typ')
	SET @w_page				=	JSON_VALUE(@P_json,'$.page')
	SET @w_page_size		=	JSON_VALUE(@P_json,'$.page_size')
	SET	@w_report_kinds		=	JSON_VALUE(@P_json,'$.report_kinds')
	SET	@P_fiscal_year		=	JSON_VALUE(@P_json,'$.fiscal_year')
	SET	@P_group_cd			=	JSON_VALUE(@P_json,'$.report_group')
	SET	@w_employee_cdX		=	JSON_VALUE(@P_json,'$.employee_cdX')
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
		SET @start_date = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		SET @end_date = DATEADD(DD,-1,DATEADD(YYYY,1,@start_date))
	END
	ELSE
	BEGIN 
		SET @start_date		= CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/01/01') AS DATE)
		SET @end_date		= CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/12/31') AS DATE)
	END
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
	--
	IF(@P_mode =2)
	BEGIN
		-- INSERT DATA INTO##EMP_APPROVAL
		INSERT INTO #EMP_APPROVAL
		SELECT 
			json_table.employee_cd
		FROM OPENJSON(@P_json,'$.list_employee_cd') WITH(
			employee_cd	nvarchar(10)
		)AS json_table
	END
	--get deadline f4100
	set @w_today = @end_date
	SELECT
		@w_today = MAX(deadline_date)
	FROM F4100
	WHERE
		company_cd = @P_company_cd
	AND fiscal_year = @P_fiscal_year
	AND	group_cd	= @P_group_cd
	AND	report_kind	= @w_report_kinds
	AND user_typ	= 1
	AND del_datetime IS NULL
	-- INSERT DATA INTO #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 @P_json,@P_cre_user,@P_company_cd, 5
	-- INSERT DATA INTO #TABLE_ORGANIZATION_2
	INSERT INTO #TABLE_ORGANIZATION_2
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 '',@P_cre_user,@P_company_cd, 5
	-- INSERT DATA INTO #LIST_POSITION
	INSERT INTO #LIST_POSITION
	SELECT json_table.position_cd,0 FROM OPENJSON(@P_json,'$.list_position_cd') WITH(
		position_cd	int
	)AS json_table
	WHERE
		json_table.position_cd > 0
	--
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
	--
	IF NOT EXISTS (SELECT 1 FROM #LIST_POSITION_2)
	BEGIN
		-- 本人の役職より下位の社員のみ
		IF @w_use_typ = 1
		BEGIN
			INSERT INTO #LIST_POSITION_2
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
			INSERT INTO #LIST_POSITION_2
			SELECT 
				ISNULL(M0040.position_cd,0)				AS	position_cd
			,	1
			FROM M0040
			WHERE 
				M0040.company_cd		=	@P_company_cd
			AND M0040.del_datetime IS NULL
		END
	END
	-- #M0070H
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @w_today,'',@P_company_cd
	--
	INSERT INTO #M0070H_VIEW
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @w_today,'',@P_company_cd
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
	-- INSERT
	INSERT INTO #LIST_VIEW
	SELECT
		company_cd			
	,	employee_cd			
	,	employee_nm			
	,	employee_ab_nm		
	,	furigana			
	,	office_cd			
	,	office_nm			
	,	belong_cd_1			
	,	belong_cd_2			
	,	belong_cd_3			
	,	belong_cd_4			
	,	belong_cd_5			
	,	job_cd				
	,	position_cd			
	,	employee_typ		
	,	grade					
	FROM #M0070H
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--FILTER DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
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
		ELSE IF NOT (@w_system_authority_typ = 3 AND @w_evaluation_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)
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
			AND @w_system_authority_typ NOT IN(4,5)		--4.会社管理者 5.総合管理者
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
		IF @w_system_authority_typ NOT IN (4,5)
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

		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--GET DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	INSERT #TABLE_RESULT
	SELECT 
		@P_company_cd
	,	F4110.employee_cd
	,	MAX(F4110.group_cd)	
	,	#M0070H.employee_typ
	,	#M0070H.position_cd	
	,	#M0070H.belong_cd_1	
	,	#M0070H.belong_cd_2	
	,	#M0070H.belong_cd_3	
	,	#M0070H.belong_cd_4	
	,	#M0070H.belong_cd_5	
	,	SPACE(0)
	FROM F4110 
	INNER JOIN #M0070H ON (
		F4110.company_cd		=   #M0070H.company_cd
	AND	F4110.employee_cd		=	#M0070H.employee_cd
	)
	WHERE 
		F4110.company_cd	=	@P_company_cd
	AND F4110.fiscal_year = @P_fiscal_year
	AND (
		@w_employee_cdX = ''
	OR	@w_employee_cdX <> '' AND F4110.employee_cd = @w_employee_cdX
	)
	AND	F4110.report_kind	= @w_report_kinds
	AND (
		@P_group_cd = -1
	OR	@P_group_cd <> -1 AND F4110.group_cd = @P_group_cd	
	)
	AND F4110.del_datetime IS NULL
	AND (
		@w_employee_typ = -1
	OR	@w_employee_typ <> -1 AND #M0070H.employee_typ = @w_employee_typ	-- 社員区分
	)
	GROUP BY
		F4110.employee_cd
	,	#M0070H.employee_typ
	,	#M0070H.position_cd	
	,	#M0070H.belong_cd_1	
	,	#M0070H.belong_cd_2	
	,	#M0070H.belong_cd_3	
	,	#M0070H.belong_cd_4	
	,	#M0070H.belong_cd_5	
	-- get data for #F4120
	INSERT INTO #F4121
	SELECT 
		F4121_TMP.company_cd
	,	F4121_TMP.employee_cd
	,	F4121_TMP.viewer_employee_cd
	,	ISNULL(#M0070H_VIEW.employee_nm,'')
	FROM #TABLE_RESULT
	INNER JOIN (
		SELECT 
			F4121.company_cd			AS	company_cd
		,	F4121.employee_cd			AS	employee_cd
		,	F4121.viewer_employee_cd	AS	viewer_employee_cd
		FROM F4121
		WHERE 
			F4121.company_cd	=	@P_company_cd
		AND F4121.fiscal_year	=	@P_fiscal_year
		AND F4121.report_kind	=	@w_report_kinds
		AND F4121.del_datetime IS NULL
		GROUP BY
			F4121.company_cd		
		,	F4121.employee_cd		
		,	F4121.viewer_employee_cd
	) AS F4121_TMP ON (
		#TABLE_RESULT.company_cd	=	F4121_TMP.company_cd
	AND #TABLE_RESULT.employee_cd	=	F4121_TMP.employee_cd
	)
	LEFT OUTER JOIN #M0070H_VIEW ON (
		F4121_TMP.company_cd			=	#M0070H_VIEW.company_cd
	AND F4121_TMP.viewer_employee_cd	=	#M0070H_VIEW.employee_cd
	)
	ORDER BY 
		CASE ISNUMERIC(#TABLE_RESULT.employee_cd) 
			WHEN 1 
			THEN CAST(#TABLE_RESULT.employee_cd AS BIGINT) 
			ELSE 999999999999
		END 
	--
	INSERT INTO #F4121_JSON
	SELECT 
		#TABLE_RESULT.company_cd
	,	#TABLE_RESULT.employee_cd
	,	(
		SELECT 
			#F4121.viewer_employee_cd	AS	"viewer_employee_cd"
		,	#F4121.viewer_employee_nm	AS	"viewer_employee_nm"
		FROM #F4121
		WHERE 
			#F4121.company_cd	=	#TABLE_RESULT.company_cd
		AND #F4121.employee_cd	=	#TABLE_RESULT.employee_cd
		FOR JSON PATH
		)
	FROM #TABLE_RESULT
	--
	IF @P_mode = 1
	BEGIN
		INSERT INTO #HEADER VALUES(		
			IIF(@w_language= 2,'Employee Code',N'社員番号')		
		,	IIF(@w_language= 2,'Viewer Employee Code',N'閲覧者番号')
		)
		-- export CSV
		SELECT
			employee_cd						as employee_cd
		,	viewer_employee_cd				as viewer_employee_cd
		FROM #HEADER
		UNION ALL
		SELECT 
			employee_cd						as employee_cd	
		,	viewer_employee_cd				as viewer_employee_cd
		FROM #F4121
	RETURN
	END
	--
	IF @P_mode = 2
	BEGIN
		--REMOVE EMPLOYEE CHECKED IN SCREEN
		DELETE D FROM #F4121_JSON AS D
		INNER JOIN #EMP_APPROVAL AS S ON (
			D.company_cd		=	@P_company_cd
		AND D.employee_cd		=	S.employee_cd
		)	
		-- mode 2
		IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION_2)
		BEGIN
			SET @w_choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION_2 WHERE choice_in_screen = 1)
			-- 1.choice in screen
			IF @w_choice_in_screen = 1
			BEGIN
				DELETE D FROM #LIST_VIEW AS D
				FULL OUTER JOIN #TABLE_ORGANIZATION_2 AS S ON (
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
				DELETE D FROM #LIST_VIEW AS D
				FULL OUTER JOIN #TABLE_ORGANIZATION_2 AS S ON (
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
		-- FILTER 役職
		-- choice in screen
		IF EXISTS (SELECT 1 FROM #LIST_POSITION_2 WHERE mode = 0)
		BEGIN
			DELETE D FROM #LIST_VIEW AS D
			LEFT OUTER JOIN #LIST_POSITION_2 AS S ON (
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
				DELETE D FROM #LIST_VIEW AS D
				LEFT OUTER JOIN #LIST_POSITION_2 AS S ON (
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
		--
		SELECT 
			@w_browse_position_typ		= ISNULL(browse_position_typ,0)
		,	@w_browse_department_typ	= ISNULL(browse_department_typ,0)
		FROM M4600
		WHERE
			company_cd  = @P_company_cd
		AND	group_cd	= @P_group_cd
		AND del_datetime IS NULL
		--
		INSERT INTO #M4604
		SELECT
			M4604.company_cd			
		,	M4604.group_cd			
		,	M4604.attribute					
		,	M4604.code						
		FROM M4604
		WHERE
			M4604.company_cd	=	@P_company_cd
		AND M4604.group_cd		=	@P_group_cd
		AND M4604.del_datetime IS NULL
		--
		INSERT INTO #M4603
		SELECT
			M4603.company_cd			
		,	M4603.group_cd			
		,	M4603.organization_cd_1
		,	M4603.organization_cd_2					
		,	M4603.organization_cd_3					
		,	M4603.organization_cd_4					
		,	M4603.organization_cd_5										
		FROM M4603
		WHERE
			M4603.company_cd	=	@P_company_cd
		AND M4603.group_cd		=	@P_group_cd
		AND M4603.del_datetime IS NULL
		--
		INSERT INTO #M0060
		SELECT 
			M0060.company_cd		
		,	M0060.employee_typ
		,	#M4604.group_cd
		FROM M0060
		INNER JOIN #M4604 ON (
			M0060.company_cd	= #M4604.company_cd
		AND	M0060.employee_typ	= #M4604.code
		)
		WHERE 
			 M0060.company_cd = @P_company_cd
		 AND M0060.del_datetime IS NULL
		 AND #M4604.attribute = 4
		--
		INSERT INTO #M0050
		SELECT 
			M0050.company_cd		
		,	M0050.grade
		,	#M4604.group_cd
		FROM M0050
		INNER JOIN #M4604 ON (
			M0050.company_cd	= #M4604.company_cd
		AND	M0050.grade			= #M4604.code
		)
		WHERE 
			 M0050.company_cd = @P_company_cd
		 AND M0050.del_datetime IS NULL
		 AND #M4604.attribute = 3
		--
		INSERT INTO #M0040
		SELECT 
			M0040.company_cd
		,	M0040.position_cd
		,	#M4604.group_cd
		FROM M0040
		INNER JOIN #M4604 ON (
			M0040.company_cd	= #M4604.company_cd
		AND	M0040.position_cd	= #M4604.code
		)
		WHERE 
			 M0040.company_cd = @P_company_cd
		 AND M0040.del_datetime IS NULL
		 AND #M4604.attribute = 1
		--
		INSERT INTO #M0030
		SELECT 
			M0030.company_cd
		,	M0030.job_cd
		,	#M4604.group_cd
		FROM M0030
		INNER JOIN #M4604 ON (
			M0030.company_cd	= #M4604.company_cd
		AND	M0030.job_cd		= #M4604.code
		)
		WHERE 
			M0030.company_cd = @P_company_cd
		AND M0030.del_datetime IS NULL
		AND #M4604.attribute = 2
		
		--FILLTER
		-- #M0060
		IF EXISTS ( SELECT 1 FROM #M0060)
		BEGIN
			DELETE D FROM #LIST_VIEW AS D
			LEFT OUTER JOIN #M0060 ON (
				D.company_cd	= #M0060.company_cd
			AND	D.employee_typ	= #M0060.employee_typ
			)
			WHERE 
				#M0060.employee_typ IS NULL
		END 
		-- #M0030
		IF EXISTS ( SELECT 1 FROM #M0030)
		BEGIN
			DELETE D FROM #LIST_VIEW AS D
			LEFT OUTER JOIN #M0030 ON (
				D.company_cd	= #M0030.company_cd
			AND	D.job_cd		= #M0030.job_cd
			)
			WHERE 
				#M0030.job_cd IS NULL
		END
			
		-- #M0040
		IF EXISTS ( SELECT 1 FROM #M0040)
		BEGIN
			DELETE D FROM #LIST_VIEW AS D
			LEFT OUTER JOIN #M0040 ON (
				D.company_cd	= #M0040.company_cd
			AND	D.position_cd	= #M0040.position_cd
			)
			WHERE 
				#M0040.position_cd IS NULL
		END
		-- #M0050
		IF EXISTS ( SELECT 1 FROM #M0050)
		BEGIN
			DELETE D FROM #LIST_VIEW AS D
			LEFT OUTER JOIN #M0050 ON (
				D.company_cd	= #M0050.company_cd
			AND	D.grade			= #M0050.grade
			)
			WHERE 
				#M0050.grade IS NULL
		END
		
		--
		WHILE EXISTS (SELECT 1 FROM #EMP_APPROVAL WHERE id = @i)
		BEGIN
		
			SET @w_employee_approval = 	(SELECT employee_cd FROM #EMP_APPROVAL WHERE id = @i)
			--INSERT
			INSERT INTO #LIST_VIEW_GROUP
			SELECT  
				company_cd			
			,	employee_cd			
			,	employee_nm			
			,	employee_ab_nm		
			,	furigana			
			,	office_cd			
			,	office_nm			
			,	belong_cd_1			
			,	belong_cd_2			
			,	belong_cd_3			
			,	belong_cd_4			
			,	belong_cd_5			
			,	job_cd				
			,	position_cd			
			,	employee_typ		
			,	grade				
			FROM #LIST_VIEW
			--INSERT

			INSERT INTO #INFO_EMP
			SELECT  
				company_cd			
			,	employee_cd			
			,	employee_nm			
			,	employee_ab_nm		
			,	furigana			
			,	office_cd			
			,	office_nm			
			,	belong_cd_1			
			,	belong_cd_2			
			,	belong_cd_3			
			,	belong_cd_4			
			,	belong_cd_5							
			FROM #M0070H
			WHERE
				#M0070H.employee_cd = @w_employee_approval
			--
			IF(@w_browse_position_typ = 1)
			BEGIN
				SET @w_position_cd_2	= (SELECT position_cd FROM #M0070H WHERE employee_cd = @w_employee_approval)
				-- get @arrange_order
				SELECT 
					@w_arrange_order	=	ISNULL(M0040.arrange_order,0)
				FROM M0040
				WHERE 
					M0040.company_cd		=	@P_company_cd
				AND M0040.position_cd		=	@w_position_cd_2
				AND M0040.del_datetime IS NULL
				--
				INSERT INTO #M0040_EMP
				SELECT 
					@P_company_cd
				,	ISNULL(M0040.position_cd,0)			
				FROM M0040
				WHERE 
					M0040.company_cd		=	@P_company_cd
				AND M0040.arrange_order		>=	@w_arrange_order
				AND M0040.del_datetime IS NULL
				--DELETE
				IF EXISTS ( SELECT 1 FROM #M0040_EMP)
				BEGIN
					DELETE D FROM #LIST_VIEW_GROUP AS D
					INNER JOIN #M0040_EMP ON (
						D.company_cd	= #M0040_EMP.company_cd
					AND	D.position_cd	= #M0040_EMP.position_cd
					)
				END
			END
			--
			DELETE D FROM #LIST_VIEW_GROUP AS D
			WHERE 
				D.employee_cd = @w_employee_approval
			--

			
			IF(@w_browse_department_typ = 1)
			BEGIN
				DELETE D FROM #LIST_VIEW_GROUP AS D
				LEFT OUTER JOIN #INFO_EMP ON (
					D.company_cd			=	@P_company_cd
				AND D.belong_cd_1			=	#INFO_EMP.belong_cd_1
				AND D.belong_cd_2			=	#INFO_EMP.belong_cd_2
				AND D.belong_cd_3			=	#INFO_EMP.belong_cd_3
				AND D.belong_cd_4			=	#INFO_EMP.belong_cd_4
				AND D.belong_cd_5			=	#INFO_EMP.belong_cd_5
				)
				WHERE 
					#INFO_EMP.company_cd IS NULL
			END
			ELSE
			BEGIN
				IF EXISTS ( SELECT 1 FROM #M4603 WHERE organization_cd_1 <> '')
				BEGIN
					DELETE D FROM #LIST_VIEW_GROUP AS D
					LEFT OUTER JOIN #M4603 ON (
						D.company_cd			=	@P_company_cd
					AND D.belong_cd_1			=	#M4603.organization_cd_1
					--AND D.belong_cd_2			=	#M4603.organization_cd_2
					--AND D.belong_cd_3			=	#M4603.organization_cd_3
					--AND D.belong_cd_4			=	#M4603.organization_cd_4
					--AND D.belong_cd_5			=	#M4603.organization_cd_5
					)
					WHERE 
						#M4603.group_cd IS NULL
				END
				IF EXISTS ( SELECT 1 FROM #M4603 WHERE organization_cd_1 <> ''and organization_cd_2 <> '')
				BEGIN
					DELETE D FROM #LIST_VIEW_GROUP AS D
					LEFT OUTER JOIN #M4603 ON (
						D.company_cd			=	@P_company_cd
					AND D.belong_cd_1			=	#M4603.organization_cd_1
					AND D.belong_cd_2			=	#M4603.organization_cd_2
					--AND D.belong_cd_3			=	#M4603.organization_cd_3
					--AND D.belong_cd_4			=	#M4603.organization_cd_4
					--AND D.belong_cd_5			=	#M4603.organization_cd_5
					)
					WHERE 
						#M4603.group_cd IS NULL
				END
				IF EXISTS ( SELECT 1 FROM #M4603 WHERE organization_cd_1 <> ''and organization_cd_2 <> '' and organization_cd_3 <> '')
				BEGIN
					DELETE D FROM #LIST_VIEW_GROUP AS D
					LEFT OUTER JOIN #M4603 ON (
						D.company_cd			=	@P_company_cd
					AND D.belong_cd_1			=	#M4603.organization_cd_1
					AND D.belong_cd_2			=	#M4603.organization_cd_2
					AND D.belong_cd_3			=	#M4603.organization_cd_3
					--AND D.belong_cd_4			=	#M4603.organization_cd_4
					--AND D.belong_cd_5			=	#M4603.organization_cd_5
					)
					WHERE 
						#M4603.group_cd IS NULL
				END
				IF EXISTS ( SELECT 1 FROM #M4603 WHERE organization_cd_1 <> ''and organization_cd_2 <> '' and organization_cd_3 <> '' and organization_cd_4 <> '')
				BEGIN
					DELETE D FROM #LIST_VIEW_GROUP AS D
					LEFT OUTER JOIN #M4603 ON (
						D.company_cd			=	@P_company_cd
					AND D.belong_cd_1			=	#M4603.organization_cd_1
					AND D.belong_cd_2			=	#M4603.organization_cd_2
					AND D.belong_cd_3			=	#M4603.organization_cd_3
					AND D.belong_cd_4			=	#M4603.organization_cd_4
					--AND D.belong_cd_5			=	#M4603.organization_cd_5
					)
					WHERE 
						#M4603.group_cd IS NULL
				END
				IF EXISTS ( SELECT 1 FROM #M4603 WHERE organization_cd_1 <> ''and organization_cd_2 <> '' and organization_cd_3 <> '' and organization_cd_4 <> '' and organization_cd_5 <> '')
				BEGIN
					DELETE D FROM #LIST_VIEW_GROUP AS D
					LEFT OUTER JOIN #M4603 ON (
						D.company_cd			=	@P_company_cd
					AND D.belong_cd_1			=	#M4603.organization_cd_1
					AND D.belong_cd_2			=	#M4603.organization_cd_2
					AND D.belong_cd_3			=	#M4603.organization_cd_3
					AND D.belong_cd_4			=	#M4603.organization_cd_4
					AND D.belong_cd_5			=	#M4603.organization_cd_5
					)
					WHERE 
						#M4603.group_cd IS NULL
				END
			END
			
			--
			--ĐÃ LỌC XONG NHÂN VIÊN
			--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
			--GET DATA
			--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
			INSERT INTO #F4121_FAKE
			SELECT
				@P_company_cd
			,	@w_employee_approval
			,	#LIST_VIEW_GROUP.employee_cd
			,	#LIST_VIEW_GROUP.employee_nm
			FROM #LIST_VIEW_GROUP
			ORDER BY 
				CASE ISNUMERIC(#LIST_VIEW_GROUP.employee_cd) 
					WHEN 1 
					THEN CAST(#LIST_VIEW_GROUP.employee_cd AS BIGINT) 
					ELSE 999999999999999 
				END
			-- JSON
			INSERT INTO #F4121_JSON
			SELECT 
				#F4121_FAKE.company_cd
			,	#F4121_FAKE.employee_cd
			,	(
				SELECT 
					#F4121_FAKE.viewer_employee_cd	AS	"viewer_employee_cd"
				,	#F4121_FAKE.viewer_employee_nm	AS	"viewer_employee_nm"
				FROM #F4121_FAKE
				FOR JSON PATH
				)
			FROM #F4121_FAKE
			WHERE 
				#F4121_FAKE.employee_cd = @w_employee_approval
			GROUP BY 
				#F4121_FAKE.company_cd
			,	#F4121_FAKE.employee_cd	
			--
			DELETE FROM #LIST_VIEW_GROUP
			DELETE FROM #INFO_EMP
			DELETE FROM #M0040_EMP
			DELETE FROM #F4121_FAKE
			--
			SET @i = @i + 1
		END
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	SET @w_totalRecord = (SELECT COUNT(1) FROM #TABLE_RESULT)
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
	SELECT 
		ISNULL(#EMP_APPROVAL.employee_cd,'')			AS	check_box
	,	#TABLE_RESULT.employee_cd						AS	employee_cd
	,	ISNULL(#M0070H.employee_nm,'')					AS	employee_nm
	,	ISNULL(#M0070H.employee_typ_nm,'')				AS	employee_typ_nm
	,	ISNULL(#M0070H.belong_nm_1,'')					AS	organization_nm_1
	,	ISNULL(#M0070H.belong_nm_2,'')					AS	organization_nm_2
	,	ISNULL(#M0070H.belong_nm_3,'')					AS	organization_nm_3
	,	ISNULL(#M0070H.belong_nm_4,'')					AS	organization_nm_4
	,	ISNULL(#M0070H.belong_nm_5,'')					AS	organization_nm_5
	,	ISNULL(#M0070H.position_nm,'')					AS	position_nm
	,	ISNULL(#F4121_JSON.list_viewer,'')				AS	list_viewer

	FROM #TABLE_RESULT
	LEFT OUTER JOIN #M0070H ON (
		#TABLE_RESULT.company_cd	=	#M0070H.company_cd
	AND #TABLE_RESULT.employee_cd	=	#M0070H.employee_cd
	)
	LEFT OUTER JOIN #EMP_APPROVAL ON (
		#TABLE_RESULT.employee_cd	=	#EMP_APPROVAL.employee_cd
	)
	LEFT OUTER JOIN #F4121_JSON ON (
		#TABLE_RESULT.company_cd	=	#F4121_JSON.company_cd
	AND #TABLE_RESULT.employee_cd	=	#F4121_JSON.employee_cd
	)
	ORDER BY 
		CASE ISNUMERIC(#TABLE_RESULT.employee_cd) 
			WHEN 1 
			THEN CAST(#TABLE_RESULT.employee_cd AS BIGINT) 
			ELSE 999999999999999 
		END 
	,	#TABLE_RESULT.employee_cd
	offset (@w_page-1) * @w_page_size ROWS
	FETCH NEXT @w_page_size ROWS only
	--[1]
	SELECT	
		@w_totalRecord						AS totalRecord
	,	@w_pageMax							AS pageMax
	,	@w_page								AS page
	,	@w_page_size						AS pagesize
	,	((@w_page - 1) * @w_page_size + 1)	AS offset
END
GO
