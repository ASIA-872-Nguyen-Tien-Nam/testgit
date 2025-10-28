DROP PROCEDURE [SPC_rQ2011_FND1]
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
--****************************************************************************************
CREATE PROCEDURE [SPC_rQ2011_FND1]
	-- Add the parameters for the stored procedure here	
	@P_json						nvarchar(max)		=	''	
,	@P_cre_user					nvarchar(50)		=	''		-- login user id
,	@P_company_cd				smallint			=	0
,	@P_employee_cd				nvarchar(10)		=	''
AS
BEGIN 
	SET NOCOUNT ON;
	DECLARE 
		@w_time								datetime			=	SYSDATETIME()
	,	@w_totalRecord						bigint				=	0
	,	@w_pageMax							int					=	0	
	,	@w_page_size						int					=	50
	,	@w_page								int					=	0
	,	@w_mode								tinyint				=	0		-- 0.search 1. print
	--
	,	@w_employee_cd						nvarchar(10)		=	''
	,	@w_employee_nm						nvarchar(101)		=	''
	,	@w_employee_typ						smallint			=	0
	,	@w_position_cd						int					=	0
	,	@w_grade							smallint			=	0
	,	@w_mygroup_cd						smallint			=	-1
	
	,	@w_report_authority_typ				smallint			=	0
	,	@w_report_authority_cd				smallint			=	0

	,	@w_use_typ							smallint			=	0	
	,	@w_arrange_order					int					=	0

	,	@w_login_position_cd				int					=	0
	,	@w_login_employee_cd				nvarchar(10)		=	''
	,	@w_choice_in_screen					tinyint				=	0
	,	@w_evaluation_organization_cnt		INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	,	@w_today							date				=	SYSDATETIME()
	,	@w_system_authority_typ				smallint			=	0
	,	@w_current_year						int					=	NULL
	--
	,	@w_company_attribute	smallint		=	0	-- 1.管理会社 2.ユーザー会社 3.グループ会社　--2023/07/25 add
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
	--#TABLE_RESULT
	CREATE TABLE #TABLE_RESULT(
		id				int		identity(1,1)
	,	company_cd		smallint
	,	employee_cd		nvarchar(10)
	,	belong_cd_1		nvarchar(20)
	,	belong_cd_2		nvarchar(20)
	,	belong_cd_3		nvarchar(20)
	,	belong_cd_4		nvarchar(20)
	,	belong_cd_5		nvarchar(20)
	,	position_cd		int
	)
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
	--↓ 2023/07/25 add：GET company_attribute 
	SELECT 
		@w_company_attribute =	M0001.contract_company_attribute
	FROM M0001
	WHERE 
		M0001.company_cd	=	@P_company_cd
    --↑ 2023/07/25 add
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
	SET @w_current_year = [dbo].FNC_GET_YEAR_WEEKLY_REPORT(@P_company_cd,NULL)
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
	SET @w_employee_cd		=	JSON_VALUE(@P_json,'$.employee_cd')
	SET @w_employee_nm		=	JSON_VALUE(@P_json,'$.employee_name')
	SET @w_mygroup_cd		=	JSON_VALUE(@P_json,'$.mygroup_cd')
	SET @w_employee_typ		=	JSON_VALUE(@P_json,'$.employee_typ')
	SET @w_position_cd		=	JSON_VALUE(@P_json,'$.position_cd')
	SET @w_grade			=	JSON_VALUE(@P_json,'$.grade')
	SET @w_page				=	JSON_VALUE(@P_json,'$.page')
	SET @w_page_size		=	JSON_VALUE(@P_json,'$.page_size')
	SET @w_mode				=	JSON_VALUE(@P_json,'$.mode')
	-- INSERT DATA INTO #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 @P_json,@P_cre_user,@P_company_cd, 5
	-- INSERT DATA INTO #LIST_POSITION
	IF @w_position_cd > 0
	BEGIN
		INSERT INTO #LIST_POSITION
		SELECT @w_position_cd,0
	END
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
	-- #M0070H
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @w_today,'',@P_company_cd
	IF @w_mode = 1			
	BEGIN
		INSERT #TABLE_RESULT
		SELECT 
			@P_company_cd
		,	F4011.mygroup_member_cd
		,	#M0070H.belong_cd_1	
		,	#M0070H.belong_cd_2	
		,	#M0070H.belong_cd_3	
		,	#M0070H.belong_cd_4	
		,	#M0070H.belong_cd_5	
		,	#M0070H.position_cd	
		FROM F4011 
		LEFT JOIN #M0070H ON (
			F4011.company_cd		=	#M0070H.company_cd
		AND F4011.employee_cd		=   @P_employee_cd
		AND	F4011.mygroup_cd		=   @w_mygroup_cd
		AND F4011.mygroup_member_cd	=	#M0070H.employee_cd
		)
		WHERE
			F4011.company_cd		= @P_company_cd
		AND F4011.employee_cd		= @P_employee_cd
		AND	F4011.mygroup_cd		= @w_mygroup_cd
		AND F4011.del_datetime  IS NULL
		--
		GOTO COMPLETE_RESULT
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--GET DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	INSERT #TABLE_RESULT
	SELECT 
		M0070.company_cd
	,	M0070.employee_cd
	,	#M0070H.belong_cd_1	
	,	#M0070H.belong_cd_2	
	,	#M0070H.belong_cd_3	
	,	#M0070H.belong_cd_4	
	,	#M0070H.belong_cd_5	
	,	#M0070H.position_cd	
	FROM M0070 
	LEFT JOIN #M0070H ON (
		M0070.company_cd		=	#M0070H.company_cd
	AND M0070.employee_cd		=	#M0070H.employee_cd
	)
	WHERE 
		M0070.company_cd	=	@P_company_cd
	AND (
		@w_employee_cd = ''
	OR	M0070.employee_cd	= @w_employee_cd
	)
	AND(
			@w_employee_nm				=	''
		OR	(dbo.FNC_COM_REPLACE_SPACE(#M0070H.employee_nm)		LIKE	'%' +	dbo.FNC_COM_REPLACE_SPACE(@w_employee_nm)		+ '%')
		OR	(dbo.FNC_COM_REPLACE_SPACE(#M0070H.employee_ab_nm)	LIKE	'%' +	dbo.FNC_COM_REPLACE_SPACE(@w_employee_nm)		+ '%')
		OR	(dbo.FNC_COM_REPLACE_SPACE(#M0070H.furigana)		LIKE	'%' +	dbo.FNC_COM_REPLACE_SPACE(@w_employee_nm)		+ '%')
	)
	AND (
		@w_employee_typ = -1
	OR	@w_employee_typ <> -1 AND #M0070H.employee_typ = @w_employee_typ	-- 社員区分
	)
	-- ↓2023/07/25 fixed
	/*
	AND (
		@w_grade = -1
	OR	@w_grade <> -1 AND #M0070H.grade = @w_grade							-- 等級
	)
	*/
	AND (
	        (@w_company_attribute=3)
	    OR 
	        (@w_company_attribute!=3
		     AND (    @w_grade <=	0
		          OR @w_grade	>	0 AND #M0070H.grade = @w_grade
		         )
	        )
	)	-- ↑2023/07/25 fixed
	AND	((@w_today <= M0070.company_out_dt
	AND M0070.company_out_dt IS NOT NULL)
	OR M0070.company_out_dt IS NULL)
	AND (@w_today >= M0070.company_in_dt
	AND M0070.company_in_dt IS NOT NULL)

	AND M0070.del_datetime IS NULL
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
	-- FILTER 役職
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
	COMPLETE_RESULT:
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
		IIF(ISNULL(F4011.employee_cd,'') = '',0,1)		AS  check_box
	,	#TABLE_RESULT.employee_cd						AS	employee_cd
	,	ISNULL(#M0070H.employee_nm,'')					AS	employee_nm
	,	ISNULL(#M0070H.employee_typ_nm,'')				AS	employee_typ_nm
	,	ISNULL(#M0070H.belong_nm_1,'')					AS	organization_nm_1
	,	ISNULL(#M0070H.belong_nm_2,'')					AS	organization_nm_2
	,	ISNULL(#M0070H.belong_nm_3,'')					AS	organization_nm_3
	,	ISNULL(#M0070H.belong_nm_4,'')					AS	organization_nm_4
	,	ISNULL(#M0070H.belong_nm_5,'')					AS	organization_nm_5
	,	ISNULL(#M0070H.job_nm,'')						AS	job_nm
	,	ISNULL(#M0070H.position_nm,'')					AS	position_nm
	--↓2023/07/25 fixed
	--,	ISNULL(#M0070H.grade_nm,'')						AS	grade_nm
	,	CASE WHEN @w_company_attribute=3 THEN '' ELSE ISNULL(#M0070H.grade_nm,'') END AS grade_nm
	--↑2023/07/25 fixed
	FROM #TABLE_RESULT
	LEFT OUTER JOIN #M0070H ON (
		#TABLE_RESULT.company_cd	=	#M0070H.company_cd
	AND #TABLE_RESULT.employee_cd	=	#M0070H.employee_cd
	)
	LEFT JOIN F4011 ON (
		#TABLE_RESULT.company_cd  = F4011.company_cd
	AND	@P_employee_cd			  = F4011.employee_cd
	AND	@w_mygroup_cd			  = F4011.mygroup_cd
	AND	#TABLE_RESULT.employee_cd = F4011.mygroup_member_cd
	AND	F4011.del_datetime IS NULL
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
