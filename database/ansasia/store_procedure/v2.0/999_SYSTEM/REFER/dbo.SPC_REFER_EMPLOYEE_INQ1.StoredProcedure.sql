DROP PROCEDURE [SPC_REFER_EMPLOYEE_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	LIST DATA
--*  
--* 作成日/create date			:	2018/08/20											
--*	作成者/creater				:	longvv				
--*   					
--*	更新日/update date			:  	2021/01/20
--*	更新者/updater				:　 viettd					     	 
--*	更新内容/update content		:	add ver1.7 & 1on1
--*   					
--*  更新日/update date			:	2021/06/03
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees		
--*   					
--*  更新日/update date			:	2022/01/20
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when member or coach then not filter with organization
--*   					
--*  更新日/update date			:	2022/03/31
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when admin is rater then show all employees who you evalutate
--*   					
--*  更新日/update date			:	2022/08/16
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	upgrade 1.9
--* 
--****************************************************************************************
CREATE PROCEDURE [SPC_REFER_EMPLOYEE_INQ1]
    @P_search_key       NVARCHAR(200)   =   ''
,	@P_company_cd		SMALLINT		=	0
,	@P_user_id			NVARCHAR(200)   =   ''
,	@P_fiscal_year		SMALLINT		=	0		-- 年度　add 2021/01/20
,	@P_system			SMALLINT		=	1		-- 1.人事評価 2.1on1 3.マルチレビュー 4.共通設定 5.週報
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								date				=	GETDATE()
	,	@arrange_order						INT					=	0
	,	@w_position_cd						INT					=	0
	,	@w_authority_cd						SMALLINT			=	0
	,	@w_authority_typ					SMALLINT			=	0
	,	@w_employee_cd						NVARCHAR(10)		=	''
	,	@use_typ							INT					=	0
	,	@w_1on1_authority_typ				SMALLINT			=	0
	,	@w_1on1_authority_cd				SMALLINT			=	0
	,	@w_multireview_authority_cd			SMALLINT			=	0
	,	@w_multireview_authority_typ		SMALLINT			=	0
	,	@w_setting_authority_cd				SMALLINT			=	0
	,	@w_setting_authority_typ			SMALLINT			=	0
	,	@w_report_authority_cd				SMALLINT			=	0
	,	@w_report_authority_typ				SMALLINT			=	0
	-- add by viettd 2021/06/03
	,	@w_organization_cnt					INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	,	@year_month_day						DATE				=	NULL
	,	@beginning_date						DATE				=	NULL
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
	,	employee_nm						NVARCHAR(200)
	,	employee_cd						NVARCHAR(40)
	,	label							NVARCHAR(300)
	,	belong_cd1						NVARCHAR(40)
	,	belong_cd2						NVARCHAR(40)
	,	belong_cd3						NVARCHAR(40)
	,	belong_cd4						NVARCHAR(40)
	,	belong_cd5						NVARCHAR(40)
	,	position_cd						INT
	,	rater_step						SMALLINT			-- add by viettd 2022/03/31
	,	is_approver_viewer				SMALLINT			-- add by viettd 2023/05/30		
	--,	is_filter_object				TINYINT				--	1.filter object | 0.not filter object
	)
	--#TEMP_F0030
	CREATE TABLE #TEMP_F0030 (
		id				BIGINT IDENTITY(1,1) NOT NULL
	,	employee_cd		NVARCHAR(20)	
	)
	--#TABLE_MEMBER_OF_COACH_DB
	CREATE TABLE #TABLE_MEMBER_OF_COACH_DB (
		company_cd					smallint
	,	fiscal_year					smallint
	,	employee_cd					nvarchar(10)
	,	employee_nm					nvarchar(200)
	)
	--#TABLE_MEMBER_OF_COACH_DB
	CREATE TABLE #TABLE_EMPLOYEE_SUPPORTED_DB (
		company_cd					smallint
	,	fiscal_year					smallint
	,	employee_cd					nvarchar(10)
	,	employee_nm					nvarchar(200)
	)
	--#TABLE_REPOTERS_AUTO
	CREATE TABLE #TABLE_REPOTERS_AUTO (
		company_cd					smallint
	,	fiscal_year					smallint
	,	employee_cd					nvarchar(10)
	,	employee_nm					nvarchar(200)
	)

	--#LIST_POSITION
	CREATE TABLE #LIST_POSITION(
		id								int			identity(1,1)
	,	position_cd						int
	,	mode							smallint
	)
	-- #M0070H
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
	,	grade_nm						nvarchar(20)
	,	employee_typ_nm					nvarchar(50)
	)
	-- GET VALUE
	SELECT 
		@w_authority_typ				=	ISNULL(S0010.authority_typ,0) 
	,	@w_authority_cd					=	ISNULL(S0010.authority_cd,0)
	,	@w_position_cd					=	ISNULL(M0070.position_cd,0)
	,	@w_employee_cd					=	ISNULL(S0010.employee_cd,'')
	,	@w_1on1_authority_typ			=	ISNULL(S0010.[1on1_authority_typ],0)
	,	@w_1on1_authority_cd			=	ISNULL(S0010.[1on1_authority_cd],0)
	,	@w_multireview_authority_typ	=	ISNULL(S0010.multireview_authority_typ,0)
	,	@w_multireview_authority_cd		=	ISNULL(S0010.multireview_authority_cd,0)
	,	@w_setting_authority_typ		=	ISNULL(S0010.setting_authority_typ,0)
	,	@w_setting_authority_cd			=	ISNULL(S0010.setting_authority_cd,0)
	,	@w_report_authority_typ			=	ISNULL(S0010.report_authority_typ,0)
	,	@w_report_authority_cd			=	ISNULL(S0010.report_authority_cd,0)
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
	--add viettd 2022/08/16
	IF	@w_authority_typ = 6
	BEGIN
		SET @w_authority_typ = 2
	END
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
		@beginning_date = CASE
								WHEN @P_system = 5 THEN M9100.report_beginning_date
								WHEN @P_system = 2 THEN M9100.[1on1_beginning_date]
								ELSE	M9100.beginning_date 
							END
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	--
	IF @beginning_date IS NOT NULL
	BEGIN
		SET @year_month_day = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		SET @year_month_day = DATEADD(DD,-1,DATEADD(YYYY,1,@year_month_day))
	END
	ELSE
	BEGIN 
		SET @year_month_day = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/12/31') AS DATE)
	END
	--
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @year_month_day,'',@P_company_cd
	--
	IF @P_system = 1
	BEGIN
		SELECT 
			@use_typ = ISNULL(S0020.use_typ,0)
		FROM S0020
		WHERE 
			S0020.company_cd	=	@P_company_cd
		AND S0020.authority_cd	=	@w_authority_cd
		AND S0020.del_datetime IS NULL
		-- COUNT ALL ORGANIZATIONS OF S0022 -- add by viettd 2021/06/03
		SET @w_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_authority_cd,@P_system)
		-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
		SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_authority_cd,@P_system)
	END
	ELSE IF @P_system = 2
	BEGIN
		SELECT 
			@use_typ = ISNULL(S2020.use_typ,0)
		FROM S2020
		WHERE 
			S2020.company_cd	=	@P_company_cd
		AND S2020.authority_cd	=	@w_1on1_authority_cd
		AND S2020.del_datetime IS NULL
		-- COUNT ALL ORGANIZATIONS OF S2022 -- add by viettd 2021/06/03
		SET @w_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_1on1_authority_cd,@P_system)
		-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
		SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_1on1_authority_cd,@P_system)
	END
	ELSE IF @P_system = 3
	BEGIN
		SELECT 
			@use_typ = ISNULL(S3020.use_typ,0)
		FROM S3020
		WHERE 
			S3020.company_cd	=	@P_company_cd
		AND S3020.authority_cd	=	@w_multireview_authority_cd
		AND S3020.del_datetime IS NULL
		-- COUNT ALL ORGANIZATIONS OF S3022 -- add by viettd 2021/06/03
		SET @w_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_multireview_authority_cd,@P_system)
		-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
		SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_multireview_authority_cd,@P_system)
	END
	ELSE IF @P_system = 4
	BEGIN
		SELECT 
			@use_typ = ISNULL(S9020.use_typ,0)
		FROM S9020
		WHERE 
			S9020.company_cd	=	@P_company_cd
		AND S9020.authority_cd	=	@w_setting_authority_cd
		AND S9020.del_datetime IS NULL
		-- COUNT ALL ORGANIZATIONS OF S9022 -- add by viettd 2021/06/03
		SET @w_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_setting_authority_cd,@P_system)
		-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
		SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_setting_authority_cd,@P_system)
	END
	ELSE IF @P_system = 5
	BEGIN
		SELECT 
			@use_typ = ISNULL(S4020.use_typ,0)
		FROM S4020
		WHERE 
			S4020.company_cd	=	@P_company_cd
		AND S4020.authority_cd	=	@w_report_authority_cd
		AND S4020.del_datetime IS NULL
		-- COUNT ALL ORGANIZATIONS OF S9022 -- add by viettd 2021/06/03
		SET @w_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_report_authority_cd,@P_system)
		-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
		SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_report_authority_cd,@P_system)
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
	EXEC SPC_REFER_ORGANIZATION_FND1 '',@P_user_id,@P_company_cd,@P_system
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- 人事評価
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF @P_system = 1 AND @w_authority_typ = 2
	BEGIN
		INSERT INTO #TEMP_F0030
		SELECT
			F0030.employee_cd 
		FROM F0030
		WHERE
			F0030.company_cd	=	@P_company_cd
		AND F0030.del_datetime	IS NULL
		AND (
				(F0030.rater_employee_cd_1 = @w_employee_cd)
			OR	(F0030.rater_employee_cd_2 = @w_employee_cd)
			OR	(F0030.rater_employee_cd_3 = @w_employee_cd)
			OR	(F0030.rater_employee_cd_4 = @w_employee_cd)
		)
		GROUP BY 
			F0030.employee_cd
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- 1on1
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF @P_system = 2
	BEGIN
		--#TABLE_MEMBER_OF_COACH_DB
		INSERT INTO #TABLE_MEMBER_OF_COACH_DB
		EXEC [dbo].SPC_REFER_MEMBER_1ON1_FND1 @P_fiscal_year,@P_user_id,@P_company_cd
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- mulitireview
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF @P_system = 3
	BEGIN
		--#TABLE_EMPLOYEE_SUPPORTED_DB
		INSERT INTO #TABLE_EMPLOYEE_SUPPORTED_DB
		EXEC [dbo].REFER_EMPLOYEE_SUPPORTED_MULITIREVIEW_FND1 @P_fiscal_year,@P_user_id,@P_company_cd
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- weeklyreport
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF @P_system = 5
	BEGIN
		--#TABLE_REPOTERS_AUTO
		INSERT INTO #TABLE_REPOTERS_AUTO
		EXEC [dbo].SPC_REFER_REPORTER_FND1 @P_fiscal_year,@P_user_id,@P_company_cd
	END
	--
	INSERT INTO #TEMP_EMP
	SELECT  
		M0070.company_cd							AS	company_cd
	,	M0070.employee_nm							AS	[value]
	,	M0070.employee_cd							AS	id
	,	M0070.employee_cd+': ' + M0070.employee_nm	AS	label
	,	#M0070H.belong_cd_1
	,	#M0070H.belong_cd_2
	,	#M0070H.belong_cd_3
	,	#M0070H.belong_cd_4
	,	#M0070H.belong_cd_5
	,	#M0070H.position_cd
	,	CASE 
			WHEN F0100_MAX.employee_cd IS NOT NULL
			THEN 1	-- LOGIN IS HAS RATER
			ELSE 0
		END						AS	 rater_step
	,	CASE 
			WHEN @w_employee_cd = M0070.employee_cd THEN 1
			WHEN F4200_CHECK.company_cd IS NOT NULL THEN 1	-- LOGIN IS HAS APPROVER 
			WHEN F4120_CHECK.company_cd IS NOT NULL THEN 1	-- LOGIN IS HAS VIEWER 
			WHEN F4207_CHECK.company_cd IS NOT NULL THEN 1	-- LOGIN IS HAS SHARE
			ELSE 0
		END
	--,	1						--	is_filter_object 1.filter object | 0.not filter object
    FROM M0070
	INNER JOIN #M0070H ON (
		M0070.company_cd		=	#M0070H.company_cd
	AND M0070.employee_cd		=	#M0070H.employee_cd
	)
	LEFT OUTER JOIN (
		SELECT 
			F0100.company_cd		AS	company_cd
		,	F0100.employee_cd		AS	employee_cd
		,	MAX(F0100.sheet_cd)		AS	sheet_cd
		FROM F0100
		WHERE
			F0100.company_cd			=	@P_company_cd
		AND F0100.fiscal_year			=	@P_fiscal_year
		AND (
			F0100.rater_employee_cd_1	=	@w_employee_cd
		OR	F0100.rater_employee_cd_2	=	@w_employee_cd
		OR	F0100.rater_employee_cd_3	=	@w_employee_cd
		OR	F0100.rater_employee_cd_4	=	@w_employee_cd
		)
		GROUP BY
			F0100.company_cd
		,	F0100.employee_cd
	) AS F0100_MAX ON (
		M0070.company_cd		=	F0100_MAX.company_cd
	AND M0070.employee_cd		=	F0100_MAX.employee_cd
	)
	LEFT JOIN (
		SELECT
			F4200.company_cd
		,	F4200.fiscal_year
		,	F4200.employee_cd
		FROM F4200
		WHERE
			F4200.company_cd  = @P_company_cd
		AND	F4200.fiscal_year = @P_fiscal_year
		AND (
			F4200.approver_employee_cd_1	=	@w_employee_cd
		OR	F4200.approver_employee_cd_2	=	@w_employee_cd
		OR	F4200.approver_employee_cd_3	=	@w_employee_cd
		OR	F4200.approver_employee_cd_4	=	@w_employee_cd
		)
		AND F4200.del_datetime IS NULL
		GROUP BY
			F4200.company_cd
		,	F4200.fiscal_year
		,	F4200.employee_cd
	) F4200_CHECK ON (
		M0070.company_cd		=	F4200_CHECK.company_cd
	AND M0070.employee_cd		=	F4200_CHECK.employee_cd
	)
	LEFT JOIN (
		SELECT
			F4120.company_cd
		,	F4120.fiscal_year
		,	F4120.employee_cd
		FROM F4120
		WHERE
			F4120.company_cd			= @P_company_cd
		AND	F4120.fiscal_year			= @P_fiscal_year
		AND F4120.viewer_employee_cd	= @w_employee_cd
		AND F4120.del_datetime IS NULL
		GROUP BY
			F4120.company_cd
		,	F4120.fiscal_year
		,	F4120.employee_cd
	) F4120_CHECK ON (
		M0070.company_cd		=	F4120_CHECK.company_cd
	AND M0070.employee_cd		=	F4120_CHECK.employee_cd
	)
	LEFT JOIN (
		SELECT
			F4207.company_cd
		,	F4207.fiscal_year
		,	F4207.employee_cd
		FROM F4207
		WHERE
			F4207.company_cd			= @P_company_cd
		AND	F4207.fiscal_year			= @P_fiscal_year
		AND F4207.sharewith_employee_cd	= @w_employee_cd
		AND F4207.del_datetime IS NULL
		GROUP BY
			F4207.company_cd
		,	F4207.fiscal_year
		,	F4207.employee_cd
	) F4207_CHECK ON (
		M0070.company_cd		=	F4207_CHECK.company_cd
	AND M0070.employee_cd		=	F4207_CHECK.employee_cd
	)
	LEFT JOIN M0030 ON (
		M0070.company_cd	= M0030.company_cd
	AND M0070.job_cd		= M0030.job_cd
	)
	LEFT JOIN M0040 ON(
		M0070.company_cd	= M0040.company_cd
	AND M0070.position_cd	= M0040.position_cd
	)
	LEFT OUTER JOIN S0020 ON (
		M0070.company_cd	=	S0020.company_cd
	AND	@w_authority_cd		=	S0020.authority_cd
	)
    WHERE 
	(
		M0070.employee_nm		LIKE '%'+@P_search_key+'%'  
	OR	M0070.furigana			LIKE '%'+@P_search_key+'%'
	OR	M0070.employee_cd		LIKE '%'+@P_search_key+'%'
	)
	AND (M0070.company_out_dt IS  NULL OR M0070.company_out_dt >=  @w_time)
	--AND (
	--	(@use_typ = 1 AND (M0040.arrange_order > @arrange_order))
	--	OR @use_typ <> 1
	--)
	AND	M0070.company_cd		=	@P_company_cd
	AND M0070.del_datetime		IS NULL  --2020.05.14 add by Yamazaki
	-- EPLOYEE CAN VIEW
	--IF @P_system = 1
	--BEGIN
	--	UPDATE #TEMP_EMP SET 
	--		is_filter_object = 0	-- 1.filter object | 0.not filter object
	--	FROM #TEMP_EMP
	--	INNER JOIN #TEMP_F0030 ON (
	--		#TEMP_EMP.company_cd		=	@P_company_cd
	--	AND #TEMP_EMP.employee_cd		=	#TEMP_F0030.employee_cd
	--	)
	--END
	--IF @P_system = 2
	--BEGIN
	--	UPDATE #TEMP_EMP SET 
	--		is_filter_object = 0	-- 1.filter object | 0.not filter object
	--	FROM #TEMP_EMP
	--	INNER JOIN #TABLE_MEMBER_OF_COACH_DB ON (
	--		#TEMP_EMP.company_cd		=	#TABLE_MEMBER_OF_COACH_DB.company_cd
	--	AND #TEMP_EMP.employee_cd		=	#TABLE_MEMBER_OF_COACH_DB.employee_cd
	--	)
	--END
	--IF @P_system = 3
	--BEGIN
	--	UPDATE #TEMP_EMP SET 
	--		is_filter_object = 0	-- 1.filter object | 0.not filter object
	--	FROM #TEMP_EMP
	--	INNER JOIN #TABLE_EMPLOYEE_SUPPORTED_DB ON (
	--		#TEMP_EMP.company_cd		=	#TABLE_EMPLOYEE_SUPPORTED_DB.company_cd
	--	AND #TEMP_EMP.employee_cd		=	#TABLE_EMPLOYEE_SUPPORTED_DB.employee_cd
	--	)
	--END
	---- WHEN  @P_system = 5 HERE
	--IF @P_system = 5
	--BEGIN
	--	UPDATE #TEMP_EMP SET 
	--		is_filter_object = 0	-- 1.filter object | 0.not filter object
	--	FROM #TEMP_EMP
	--	INNER JOIN #TABLE_REPOTERS_AUTO ON (
	--		#TEMP_EMP.company_cd		=	#TABLE_REPOTERS_AUTO.company_cd
	--	AND #TEMP_EMP.employee_cd		=	#TABLE_REPOTERS_AUTO.employee_cd
	--	)
	--END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--FILTER
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- filter #TABLE_ORGANIZATION
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION ) 
	BEGIN
		-- 人事評価
		IF @P_system = 1 AND NOT (@w_authority_typ = 3 AND @w_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)	-- edited by viettd 2021/06/03
		BEGIN
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
			AND @w_authority_typ NOT IN(4,5) --4.会社管理者 5.総合管理者
			AND D.rater_step = 0		-- add by viettd 2022/03/31
			--AND D.is_filter_object = 1
		END
		-- 1ON1
		ELSE IF @P_system = 2 AND NOT (@w_1on1_authority_typ = 3 AND @w_organization_cnt = 0 AND @w_organization_belong_person_typ = 0) -- edited by viettd 2021/06/03
		BEGIN
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
			AND @w_1on1_authority_typ NOT IN(1,2,4,5) --　1.メンバー 2.コーチ 4.会社管理者 5.総合管理者 edited by viettd 2022/01/20
			--AND D.is_filter_object = 1
		END
		--MULITIREVIEW
		ELSE IF @P_system = 3 AND NOT (@w_multireview_authority_typ = 3 AND @w_organization_cnt = 0 AND @w_organization_belong_person_typ = 0) -- edited by viettd 2021/06/03
		BEGIN
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
			--AND D.is_filter_object = 1
		END
		--BASIC SETTING
		ELSE IF @P_system = 4 AND NOT (@w_setting_authority_typ = 3 AND @w_organization_cnt = 0 AND @w_organization_belong_person_typ = 0) -- edited by viettd 2021/06/03
		BEGIN
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
			--AND D.is_filter_object = 1
		END
		--WEEKLY REPORT
		ELSE IF @P_system = 5 AND NOT (@w_report_authority_typ = 3 AND @w_organization_cnt = 0 AND @w_organization_belong_person_typ = 0) -- edited by viettd 2021/06/03
		BEGIN
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
			AND @w_report_authority_typ NOT IN(4,5) --4.会社管理者 5.総合管理者
			AND D.is_approver_viewer = 0
			--AND D.is_filter_object = 1
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
			--人事評価
			IF 
			(
				(@P_system = 1 AND @w_authority_typ NOT IN (4,5))
			)
			BEGIN
				DELETE D FROM #TEMP_EMP AS D
				LEFT OUTER JOIN #LIST_POSITION AS S ON (
					D.company_cd		=	@P_company_cd
				AND D.position_cd		=	S.position_cd
				)
				WHERE
					S.position_cd IS NULL
				AND D.rater_step = 0		-- add by viettd 2022/03/31
				--AND D.is_filter_object = 1
			END
			-- 1ON1 , MULITIREVIEW , basic SETTING , WEEKLY REPORT
			ELSE IF (
				(@P_system = 2 AND @w_1on1_authority_typ NOT IN (4,5))
			OR	(@P_system = 3 AND @w_multireview_authority_typ NOT IN (4,5))
			OR	(@P_system = 4 AND @w_setting_authority_typ NOT IN (4,5))
			OR	(@P_system = 5 AND @w_report_authority_typ NOT IN (4,5))
			)
			BEGIN
				DELETE D FROM #TEMP_EMP AS D
				LEFT OUTER JOIN #LIST_POSITION AS S ON (
					D.company_cd		=	@P_company_cd
				AND D.position_cd		=	S.position_cd
				)
				WHERE
					S.position_cd IS NULL
				AND (@P_system <> 5
					OR (@P_system = 5 AND D.is_approver_viewer = 0)			
					)
				--AND D.is_filter_object = 1
			END
		END
	END
	-- FILTER #TABLE_MEMBER_OF_COACH_DB (1ON1)
	IF @P_system = 2
	BEGIN
		DELETE D FROM #TEMP_EMP AS D
		LEFT OUTER JOIN #TABLE_MEMBER_OF_COACH_DB AS S ON (
			D.company_cd  = S.company_cd
		AND D.employee_cd = S.employee_cd
		)
		WHERE S.employee_cd IS NULL
	END 
	-- FILTER #TABLE_EMPLOYEE_SUPPORTED_DB (MULITIREVIEW)
	IF @P_system = 3
	BEGIN
		DELETE D FROM #TEMP_EMP AS D
		LEFT OUTER JOIN #TABLE_EMPLOYEE_SUPPORTED_DB AS S ON (
			D.company_cd  = S.company_cd
		AND D.employee_cd = S.employee_cd
		)
		WHERE S.employee_cd IS NULL
	END 
	-- FILTER #TABLE_REPOTERS_AUTO (WEEKLYREPORT)
	IF @P_system = 5
	BEGIN
		DELETE D FROM #TEMP_EMP AS D
		LEFT OUTER JOIN #TABLE_REPOTERS_AUTO AS S ON (
			D.company_cd  = S.company_cd
		AND D.employee_cd = S.employee_cd
		)
		WHERE S.employee_cd IS NULL
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
	DROP TABLE #TABLE_EMPLOYEE_SUPPORTED_DB
	DROP TABLE #TABLE_MEMBER_OF_COACH_DB
	DROP TABLE #TABLE_ORGANIZATION
	DROP TABLE #TEMP_EMP
	DROP TABLE #LIST_POSITION
	DROP TABLE #M0070H
	DROP TABLE #TABLE_REPOTERS_AUTO
	DROP TABLE #TEMP_F0030
END
GO
