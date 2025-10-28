DROP PROCEDURE [SPC_Q9001_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	Q9001_マイパーパス一覧
--*  
--*  作成日/create date			:	2023/03/29						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_Q9001_FND1]
	-- Add the parameters for the stored procedure here
	@P_language					nvarchar(10)		=	'jp'
,	@P_json						nvarchar(max)		=	''	
,	@P_cre_user					nvarchar(50)		=	''		-- login user id
,	@P_company_cd				smallint			=	0
,	@P_mode						tinyint				=	0		-- 0.search 1. print
,	@P_system					tinyint				=	0		-- 1.人事評価 2.1on1 3.マルチレビュー 4.共通設定 5.週報
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
	,	@w_employee_cd						nvarchar(10)		=	''
	,	@w_employee_typ						smallint			=	0
	,	@w_position_cd						int					=	0
	,	@w_grade							smallint			=	0
	,	@w_job_cd							smallint			=	0
	
	,	@w_authority_typ					smallint			=	0
	,	@w_authority_cd						smallint			=	0
	,	@w_1on1_authority_typ				smallint			=	0
	,	@w_1on1_authority_cd				smallint			=	0
	,	@w_multireview_authority_typ		smallint			=	0
	,	@w_multireview_authority_cd			smallint			=	0
	,	@w_report_authority_typ				smallint			=	0
	,	@w_report_authority_cd				smallint			=	0
	,	@w_setting_authority_typ			smallint			=	0
	,	@w_setting_authority_cd				smallint			=	0

	,	@w_use_typ							smallint			=	0	
	,	@w_arrange_order					int					=	0

	,	@w_login_position_cd				int					=	0
	,	@w_login_employee_cd				nvarchar(10)		=	''
	,	@w_choice_in_screen					tinyint				=	0
	,	@w_evaluation_organization_cnt		INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	,	@w_today							date				=	NULL
	,	@beginning_date						DATE				=	NULL
	,	@current_year						int					=	dbo.FNC_GET_YEAR(@P_company_cd,NULL)
	,	@w_system_authority_typ				smallint			=	0
	,	@w_system_authority_cd				smallint			=	0
	,	@w_current_year						int					=	NULL
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
		id					int		identity(1,1)
	,	company_cd			smallint
	,	employee_cd			nvarchar(10)
	,	belong_cd_1			nvarchar(20)
	,	belong_cd_2			nvarchar(20)
	,	belong_cd_3			nvarchar(20)
	,	belong_cd_4			nvarchar(20)
	,	belong_cd_5			nvarchar(20)
	,	position_cd			int
	,	is_approver_viewer	tinyint			--	0.no 1.yes
	)
	-- #TABLE_EMPLOYEE_CAN_VIEW
	CREATE TABLE #TABLE_EMPLOYEE_CAN_VIEW(
		company_cd					smallint
	,	fiscal_year					smallint
	,	employee_cd					nvarchar(10)
	,	employee_nm					nvarchar(200)
	)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--GET INFORMATION 
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	SELECT 
		@w_authority_typ				=	ISNULL(S0010.authority_typ,0)
	,	@w_authority_cd					=	ISNULL(S0010.authority_cd,0)
	,	@w_1on1_authority_typ			=	ISNULL(S0010.[1on1_authority_typ],0)
	,	@w_1on1_authority_cd			=	ISNULL(S0010.[1on1_authority_cd],0)
	,	@w_multireview_authority_typ	=	ISNULL(S0010.multireview_authority_typ,0)
	,	@w_multireview_authority_cd		=	ISNULL(S0010.multireview_authority_cd,0)
	,	@w_report_authority_typ			=	ISNULL(S0010.report_authority_typ,0)
	,	@w_report_authority_cd			=	ISNULL(S0010.report_authority_cd,0)
	,	@w_setting_authority_typ		=	ISNULL(S0010.setting_authority_typ,0)
	,	@w_setting_authority_cd			=	ISNULL(S0010.setting_authority_cd,0)
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
	SELECT
		@beginning_date =	CASE
								WHEN @P_system = 5 THEN M9100.report_beginning_date
								WHEN @P_system = 2 THEN M9100.[1on1_beginning_date]
								ELSE	M9100.beginning_date 
							END
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	--
	IF @P_system = 2
	BEGIN
		SET @current_year =  dbo.FNC_GET_YEAR_1ON1(@P_company_cd,NULL)
	END
	IF @P_system = 5
	BEGIN
		SET @current_year =  dbo.FNC_GET_YEAR_WEEKLY_REPORT(@P_company_cd,NULL)
	END
	--
	IF @beginning_date IS NOT NULL
	BEGIN
		SET @w_today = CAST((CAST(@current_year AS nvarchar(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		SET @w_today = DATEADD(DD,-1,DATEADD(YYYY,1,@w_today))
	END
	ELSE
	BEGIN 
		SET @w_today = CAST((CAST(@current_year AS nvarchar(4)) + '/12/31') AS DATE)
	END
	-- ログインユーザーがS0010.report_authority_typ= 6の場合は、S0010.report_authority_typ=２と同様とする。
	SET @w_authority_typ = IIF(@w_authority_typ = 6,2,@w_authority_typ)
	-- get @use_typ
	IF @P_system = 1
	BEGIN
		SELECT 
			@w_use_typ		=	ISNULL(S0020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
		FROM S0020
		WHERE
			S0020.company_cd		=	@P_company_cd
		AND S0020.authority_cd		=	@w_authority_cd
		AND S0020.del_datetime IS NULL
		--	@w_system_authority_typ
		SET @w_system_authority_typ	=	@w_authority_typ
		SET @w_system_authority_cd	=	@w_authority_cd
		--	@w_current_year
		SET @w_current_year = [dbo].FNC_GET_YEAR(@P_company_cd,NULL)
		-- GET #TABLE_EMPLOYEE_CAN_VIEW
		INSERT INTO #TABLE_EMPLOYEE_CAN_VIEW
		SELECT 
			F0030.company_cd
		,	F0030.fiscal_year
		,	F0030.employee_cd
		,	ISNULL(M0070.employee_nm,'')
		FROM F0030
		LEFT OUTER JOIN M0070 ON (
			F0030.company_cd	=	M0070.company_cd
		AND F0030.employee_cd	=	M0070.employee_cd
		)
		WHERE 
			F0030.company_cd	=	@P_company_cd
		AND F0030.del_datetime IS NULL
		AND (
			F0030.rater_employee_cd_1	=	@w_login_employee_cd
		OR	F0030.rater_employee_cd_2	=	@w_login_employee_cd
		OR	F0030.rater_employee_cd_3	=	@w_login_employee_cd
		OR	F0030.rater_employee_cd_4	=	@w_login_employee_cd
		)
	END
	ELSE IF @P_system = 2
	BEGIN
		SELECT 
			@w_use_typ		=	ISNULL(S2020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
		FROM S2020
		WHERE
			S2020.company_cd		=	@P_company_cd
		AND S2020.authority_cd		=	@w_1on1_authority_cd
		AND S2020.del_datetime IS NULL
		--	@w_system_authority_typ
		SET @w_system_authority_typ	=	@w_1on1_authority_typ
		SET @w_system_authority_cd	=	@w_1on1_authority_cd
		--	@w_current_year
		SET @w_current_year = [dbo].FNC_GET_YEAR_1ON1(@P_company_cd,NULL)
		-- GET #TABLE_EMPLOYEE_CAN_VIEW
		INSERT INTO #TABLE_EMPLOYEE_CAN_VIEW
		EXEC SPC_REFER_MEMBER_1ON1_FND1 @w_current_year,@P_cre_user,@P_company_cd
	END
	ELSE IF @P_system = 3
	BEGIN
		SELECT 
			@w_use_typ		=	ISNULL(S3020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
		FROM S3020
		WHERE
			S3020.company_cd		=	@P_company_cd
		AND S3020.authority_cd		=	@w_multireview_authority_cd
		AND S3020.del_datetime IS NULL
		--	@w_system_authority_typ
		SET @w_system_authority_typ	=	@w_multireview_authority_typ
		SET @w_system_authority_cd	=	@w_multireview_authority_cd
		--	@w_current_year
		SET @w_current_year = [dbo].FNC_GET_YEAR(@P_company_cd,NULL)
		-- GET #TABLE_EMPLOYEE_CAN_VIEW
		INSERT INTO #TABLE_EMPLOYEE_CAN_VIEW
		EXEC REFER_EMPLOYEE_SUPPORTED_MULITIREVIEW_FND1 @w_current_year,@P_cre_user,@P_company_cd
	END
	ELSE IF @P_system = 4
	BEGIN
		SELECT 
			@w_use_typ		=	ISNULL(S9020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
		FROM S9020
		WHERE
			S9020.company_cd		=	@P_company_cd
		AND S9020.authority_cd		=	@w_setting_authority_cd
		AND S9020.del_datetime IS NULL
		--	@w_system_authority_typ
		SET @w_system_authority_typ	=	@w_setting_authority_typ
		SET @w_system_authority_cd	=	@w_setting_authority_cd
	END
	ELSE IF @P_system = 5
	BEGIN
		SELECT 
			@w_use_typ		=	ISNULL(S4020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
		FROM S4020
		WHERE
			S4020.company_cd		=	@P_company_cd
		AND S4020.authority_cd		=	@w_report_authority_cd
		AND S4020.del_datetime IS NULL
		--	@w_system_authority_typ
		SET @w_system_authority_typ	=	@w_report_authority_typ
		SET @w_system_authority_cd	=	@w_report_authority_cd
		SET @w_current_year = [dbo].FNC_GET_YEAR_WEEKLY_REPORT(@P_company_cd,NULL)
		--
		INSERT INTO #TABLE_EMPLOYEE_CAN_VIEW
		EXEC SPC_REFER_REPORTER_FND1 @w_current_year,@P_cre_user,@P_company_cd
	END
	-- get @arrange_order
	SELECT 
		@w_arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@w_login_position_cd
	AND M0040.del_datetime IS NULL
	-- COUNT ALL ORGANIZATIONS
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_system_authority_cd,@P_system)
	-- GET @w_organization_belong_person_typ
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_system_authority_cd,@P_system)
	--
	SET @w_employee_cd		=	JSON_VALUE(@P_json,'$.employee_cd')
	SET @w_employee_typ		=	JSON_VALUE(@P_json,'$.employee_typ')
	SET @w_position_cd		=	JSON_VALUE(@P_json,'$.position_cd')
	SET @w_grade			=	JSON_VALUE(@P_json,'$.grade')
	SET @w_job_cd			=	JSON_VALUE(@P_json,'$.job_cd')
	SET @w_page				=	JSON_VALUE(@P_json,'$.page')
	SET @w_page_size		=	JSON_VALUE(@P_json,'$.page_size')
	-- INSERT DATA INTO #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 @P_json,@P_cre_user,@P_company_cd, @P_system
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
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--GET DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	INSERT #TABLE_RESULT
	SELECT 
		F9000.company_cd
	,	F9000.employee_cd
	,	#M0070H.belong_cd_1	
	,	#M0070H.belong_cd_2	
	,	#M0070H.belong_cd_3	
	,	#M0070H.belong_cd_4	
	,	#M0070H.belong_cd_5	
	,	#M0070H.position_cd	
	,	CASE 
			WHEN @P_system = 5 AND F4200_APP.employee_cd IS NOT NULL
			THEN 1
			WHEN @P_system = 5 AND F4120_VIEW.employee_cd IS NOT NULL
			THEN 1
			WHEN @P_system = 5 AND F4207_SHARE.employee_cd IS NOT NULL
			THEN 1
			ELSE 0
		END
	FROM F9000
	LEFT OUTER JOIN #M0070H ON (
		F9000.company_cd		=	#M0070H.company_cd
	AND F9000.employee_cd		=	#M0070H.employee_cd
	)
	LEFT OUTER JOIN (
		SELECT
			F4200.company_cd		AS	company_cd
		,	F4200.employee_cd		AS	employee_cd
		FROM F4200
		WHERE 
			F4200.company_cd		=	@P_company_cd
		AND F4200.fiscal_year		=	@w_current_year
		AND (
			F4200.approver_employee_cd_1	=	@w_login_employee_cd
		OR	F4200.approver_employee_cd_2	=	@w_login_employee_cd
		OR	F4200.approver_employee_cd_3	=	@w_login_employee_cd
		OR	F4200.approver_employee_cd_4	=	@w_login_employee_cd
		)
		AND F4200.del_datetime IS NULL
		GROUP BY
			F4200.company_cd
		,	F4200.employee_cd
	) AS F4200_APP ON (
		F9000.company_cd		=	F4200_APP.company_cd
	AND F9000.employee_cd		=	F4200_APP.employee_cd
	)
	LEFT OUTER JOIN (
		SELECT
			F4120.company_cd		AS	company_cd
		,	F4120.employee_cd		AS	employee_cd
		FROM F4120
		WHERE 
			F4120.company_cd			=	@P_company_cd
		AND F4120.fiscal_year			=	@w_current_year
		AND F4120.viewer_employee_cd	=	@w_login_employee_cd
		AND F4120.del_datetime IS NULL
		GROUP BY
			F4120.company_cd
		,	F4120.employee_cd
	) AS F4120_VIEW ON (
		F9000.company_cd		=	F4120_VIEW.company_cd
	AND F9000.employee_cd		=	F4120_VIEW.employee_cd
	)
	LEFT OUTER JOIN (
		SELECT
			F4207.company_cd		AS	company_cd
		,	F4207.employee_cd		AS	employee_cd
		FROM F4207
		WHERE 
			F4207.company_cd			=	@P_company_cd
		AND F4207.fiscal_year			=	@w_current_year
		AND F4207.sharewith_employee_cd	=	@w_login_employee_cd
		AND F4207.del_datetime IS NULL
		GROUP BY
			F4207.company_cd
		,	F4207.employee_cd
	) AS F4207_SHARE ON (
		F9000.company_cd		=	F4207_SHARE.company_cd
	AND F9000.employee_cd		=	F4207_SHARE.employee_cd
	)
	WHERE 
		F9000.company_cd	=	@P_company_cd
	AND F9000.del_datetime	IS NULL
	AND (
		@w_employee_cd = ''
	OR	@w_employee_cd <> '' AND F9000.employee_cd	= @w_employee_cd
	)AND (
		@w_employee_typ = -1
	OR	@w_employee_typ <> -1 AND #M0070H.employee_typ = @w_employee_typ	-- 社員区分
	)
	AND (
		@w_grade = -1
	OR	@w_grade <> -1 AND #M0070H.grade = @w_grade							-- 等級
	)
	AND (
		@w_job_cd = -1
	OR	@w_job_cd <> -1 AND #M0070H.job_cd = @w_job_cd						-- 職種
	)
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
			AND @w_system_authority_typ NOT IN(2,4,5)		--4.会社管理者 5.総合管理者
			AND D.is_approver_viewer = 0
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
		IF @w_system_authority_typ NOT IN (2,4,5)
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
			AND D.is_approver_viewer = 0
		END
	END
	-- 社員閲覧 (2.評価者 | 2.コーチ | 2.サポーター | 2.承認者& 閲覧者)
	IF (@w_system_authority_typ = 2 OR @w_report_authority_typ = 0)
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D
		LEFT OUTER JOIN #TABLE_EMPLOYEE_CAN_VIEW AS S ON (
			D.company_cd	=	S.company_cd
		AND D.employee_cd	=	S.employee_cd
		)
		WHERE 
			S.employee_cd IS NULL
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
	-- 1. ■■■■■■■■■■■■■■■■■■ print ■■■■■■■■■■■■■■■■■■
	IF @P_mode = 1			
	BEGIN
		--[0]
		SELECT 
			#TABLE_RESULT.employee_cd				AS	employee_cd
		,	ISNULL(#M0070H.employee_nm,'')			AS	employee_nm
		,	ISNULL(F9000.mypurpose,'')				AS	mypurpose
		,	ISNULL(F9000.comment,'')				AS	comment
		,	@P_language								AS	[language]
		FROM #TABLE_RESULT
		LEFT OUTER JOIN #M0070H ON (
			#TABLE_RESULT.company_cd	=	#M0070H.company_cd
		AND #TABLE_RESULT.employee_cd	=	#M0070H.employee_cd
		)
		LEFT OUTER JOIN F9000 ON (
			#TABLE_RESULT.company_cd	=	F9000.company_cd
		AND #TABLE_RESULT.employee_cd	=	F9000.employee_cd
		)
	END
	-- 0. ■■■■■■■■■■■■■■■■■■ search ■■■■■■■■■■■■■■■■■■
	ELSE 
	BEGIN
		--[0]
		SELECT 
			#TABLE_RESULT.employee_cd				AS	employee_cd
		,	ISNULL(#M0070H.employee_nm,'')			AS	employee_nm
		,	ISNULL(F9000.mypurpose,'')				AS	mypurpose
		,	ISNULL(F9000.comment,'')				AS	comment
		FROM #TABLE_RESULT
		LEFT OUTER JOIN #M0070H ON (
			#TABLE_RESULT.company_cd	=	#M0070H.company_cd
		AND #TABLE_RESULT.employee_cd	=	#M0070H.employee_cd
		)
		LEFT OUTER JOIN F9000 ON (
			#TABLE_RESULT.company_cd	=	F9000.company_cd
		AND #TABLE_RESULT.employee_cd	=	F9000.employee_cd
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
END
GO