DROP PROCEDURE [SPC_EMPLOYEE_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC SPC_EMPLOYEE_FND1 '10002','acc107','','','-1','','-1','-1','0','0','20','1','1';
--EXEC SPC_EMPLOYEE_FND1 '740','721','','','-1','','-1','-1','0','2024','20','1','4';

--****************************************************************************************
--*   		 									
--*  処理概要/process overview	:	
--*  
--*  作成日/create date			:	2018/08/20				
--*　作成者/creater				:	tuantv								
--*   					
--*  更新日/update date			:	2021/01/07
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	add system (1.人事評価 2.1on1 3.マルチレビュー 4.共通設定)
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
--*  更新日/update date			:	2023/03/30
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	upgrade 2.0
--*   					
--*  更新日/update date			:	2024/03/21
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	upgrade 2.1
--*  
--****************************************************************************************
 CREATE PROCEDURE [SPC_EMPLOYEE_FND1] 
 	@P_company_cd			SMALLINT			=	0
,	@P_user_id				NVARCHAR(50)		=	''	-- login user_id
, 	@P_employee_cd			NVARCHAR(10)		=	''	-- 社員番号
,	@P_employee_nm		NVARCHAR(101)		=	''	-- 名前
,	@P_office_cd			SMALLINT			=	-1	-- 事業所
,	@P_list_org				NVARCHAR(MAX)		=	''	-- 組織
,	@P_job_cd				SMALLINT			=	-1	-- 職種
,	@P_position_cd			INT      			=	-1	-- 役職
,	@P_company_out_dt_flg	SMALLINT			=	0	-- 退職した社員を含む
,	@P_fiscal_year			SMALLINT			=	0	-- 年度
,	@P_page_size			INT					=	50	--
,	@P_page					INT					=	1	--
,	@P_system				SMALLINT			=	1	-- 1.人事評価 2.1on1 3.マルチレビュー 4.共通設定 5.週報 6.社員情報（61.社員コミュニケ―ション用）
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@ERR_TBL											ERRTABLE
	,	@w_time												date				= getdate()
	,	@totalRecord										BIGINT				=	0
	,	@pageNumber											INT					=	0
	,	@pageMax											INT					=	0	
	,	@arrange_order										INT					=	0
	,	@position_cd										INT					=	0
	,	@employee_cd										NVARCHAR(10)		=	''
	,	@choice_in_screen									INT					=	0
	--
	,	@w_1on1_authority_typ								SMALLINT			=	0
	,	@w_multireview_authority_typ						SMALLINT			=	0
	,	@w_setting_authority_typ							SMALLINT			=	0
	,	@w_authority_typ									SMALLINT			=	0
	,	@w_report_authority_typ								SMALLINT			=	0
	,	@w_empinfo_authority_typ							SMALLINT			=	0

	--
	,	@w_authority_cd										SMALLINT			=	0
	,	@w_1on1_authority_cd								SMALLINT			=	0
	,	@w_multireview_authority_cd							SMALLINT			=	0
	,	@w_setting_authority_cd								SMALLINT			=	0
	,	@w_report_authority_cd								SMALLINT			=	0
	,	@w_empinfo_authority_cd								SMALLINT			=	0
	--
	,	@use_typ											SMALLINT			=	0
	-- add by viettd 2021/06/03
	,	@w_organization_cnt									INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ					SMALLINT			=	0
	,	@year_month_day										DATE				=	NULL
	,	@beginning_date										DATE				=	NULL
	--
	,	@w_company_attribute								smallint			=	0	-- 1.管理会社 2.ユーザー会社 3.グループ会社　--2023/07/25 add
	,	@w_language											INT					=	1
	--get all ORGANIZATION with authority
	CREATE TABLE #TABLE_ORGANIZATION(
		organization_typ			tinyint
	,	organization_cd_1			nvarchar(20)
	,	organization_cd_2			nvarchar(20)
	,	organization_cd_3			nvarchar(20)
	,	organization_cd_4			nvarchar(20)
	,	organization_cd_5			nvarchar(20)	
	,	choice_in_screen			tinyint		-- 1.choice in screen 0.get from master S0022
	)
	--#LIST_POSITION
	CREATE TABLE #LIST_POSITION(
		id								int			identity(1,1)
	,	position_cd						int
	,	mode							smallint
	)
	--#TABLE_MEMBER_OF_COACH_DB
	CREATE TABLE #TABLE_MEMBER_OF_COACH_DB (
		company_cd					smallint
	,	fiscal_year					smallint
	,	employee_cd					nvarchar(10)
	,	employee_nm					nvarchar(101)
	)
	--#TABLE_MEMBER_OF_COACH_DB
	CREATE TABLE #TABLE_EMPLOYEE_SUPPORTED_DB (
		company_cd					smallint
	,	fiscal_year					smallint
	,	employee_cd					nvarchar(10)
	,	employee_nm					nvarchar(101)
	)
	--#TABLE_REPOTERS_POPUP
	CREATE TABLE #TABLE_REPOTERS_POPUP (
		company_cd					smallint
	,	fiscal_year					smallint
	,	employee_cd					nvarchar(10)
	,	employee_nm					nvarchar(200)
	)
	--#TEMP_F0030
	CREATE TABLE #TEMP_F0030 (
		id				BIGINT IDENTITY(1,1) NOT NULL
	,	employee_cd		NVARCHAR(20)	
	)
	--#EMPLOYEE
	CREATE TABLE #EMPLOYEE(
	 	company_cd			SMALLINT		
	, 	employee_cd			NVARCHAR(10)		
	,	office_nm			NVARCHAR(50)	
	,	organization_cd1	NVARCHAR(50)		
	,	organization_cd2	NVARCHAR(50)	
	,	organization_cd3	NVARCHAR(50)		
	,	organization_cd4	NVARCHAR(50)	
	,	organization_cd5	NVARCHAR(50)		
	,	job_cd				SMALLINT		
	,	position_cd			INT
	,	employee_nm			NVARCHAR(101)	
	,	employee_typ		SMALLINT	
	,	belong_cd1			NVARCHAR(50)		
	,	belong_cd2			NVARCHAR(50)
	,	belong_cd3			NVARCHAR(50)		
	,	belong_cd4			NVARCHAR(50)
	,	belong_cd5			NVARCHAR(50)		
	,	grade				SMALLINT		
	,	office_cd			SMALLINT	
	,	employee_typ_nm		NVARCHAR(50)									
	,	organization_nm1	NVARCHAR(50)										
	,	organization_nm2	NVARCHAR(50)
	,	organization_nm3	NVARCHAR(50)										
	,	organization_nm4	NVARCHAR(50)
	,	organization_nm5	NVARCHAR(50)										
	,	job_nm				NVARCHAR(50)						
	,	position_nm			NVARCHAR(50)							
	,	grade_nm			NVARCHAR(50)
	,	company_out_dt		NVARCHAR(10)
	,	rater_step			SMALLINT			-- add by viettd 2022/03/31		
	,	is_approver_viewer	SMALLINT			-- add by viettd 2023/05/30		
	--,	is_filter_object	tinyint				--	1.filter object | 0.not filter object
	)	
	-- #M0070H
	CREATE TABLE #M0070H(
		application_date				date
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(101)
	,	employee_ab_nm						nvarchar(101)
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
	SELECT 
		@w_authority_typ				=	ISNULL(S0010.authority_typ,0) 
	,	@w_authority_cd					=	ISNULL(S0010.authority_cd,0)
	,	@position_cd					=	ISNULL(M0070.position_cd,0)
	,	@employee_cd					=	ISNULL(M0070.employee_cd,0)
	,	@w_1on1_authority_cd			=	ISNULL(S0010.[1on1_authority_cd],0)
	,	@w_1on1_authority_typ			=	ISNULL(S0010.[1on1_authority_typ],0)
	,	@w_multireview_authority_cd		=	ISNULL(S0010.multireview_authority_cd,0)
	,	@w_multireview_authority_typ	=	ISNULL(S0010.multireview_authority_typ,0)
	,	@w_setting_authority_cd			=	ISNULL(S0010.setting_authority_cd,0)
	,	@w_setting_authority_typ		=	ISNULL(S0010.setting_authority_typ,0)
	,	@w_report_authority_cd			=	ISNULL(S0010.report_authority_cd,0)
	,	@w_report_authority_typ			=	ISNULL(S0010.report_authority_typ,0)
	,	@w_empinfo_authority_typ		=	ISNULL(S0010.empinfo_authority_typ,0)
	,	@w_empinfo_authority_cd			=	ISNULL(S0010.empinfo_authority_cd,0)
	,	@w_language						=	ISNULL(S0010.language,1)
	FROM S0010 LEFT JOIN M0070 ON (
		M0070.company_cd		=	S0010.company_cd
	AND M0070.employee_cd		=	S0010.employee_cd
	AND M0070.del_datetime		IS NULL 
	) 
	WHERE 
		S0010.user_id		= @P_user_id 
	AND S0010.company_cd	= @P_company_cd 
	AND S0010.del_datetime  IS NULL
	--↓ 2023/07/25 add：GET company_attribute 
	SELECT 
		@w_company_attribute =	M0001.contract_company_attribute
	FROM M0001
	WHERE 
		M0001.company_cd	=	@P_company_cd
    --↑ 2023/07/25 add
	--add viettd 2022/08/16
	IF	@w_authority_typ = 6
	BEGIN
		SET @w_authority_typ = 2
	END
	-- get @arrange_order
	SELECT 
		@arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@position_cd
	AND M0040.del_datetime IS NULL
	--
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
	ELSE IF @P_system = 2 -- 2.1ON1
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
	ELSE IF @P_system = 3 -- 3.MULITIREVIEW
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
	ELSE IF @P_system = 4 -- 4. BASIC SETTING
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
	ELSE IF @P_system = 5 -- 5.REPORT
	BEGIN
		SELECT 
			@use_typ = ISNULL(S4020.use_typ,0)
		FROM S4020
		WHERE 
			S4020.company_cd	=	@P_company_cd
		AND S4020.authority_cd	=	@w_report_authority_cd
		AND S4020.del_datetime IS NULL
		-- COUNT ALL ORGANIZATIONS OF S4022 -- add by viettd 2021/06/03
		SET @w_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_report_authority_cd,@P_system)
		-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
		SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_report_authority_cd,@P_system)
	END
	ELSE IF @P_system = 6 -- 6.EMPLOYEE INFORMATION
	BEGIN
		SELECT 
			@use_typ = ISNULL(S5020.use_typ,0)
		FROM S5020
		WHERE 
			S5020.company_cd	=	@P_company_cd
		AND S5020.authority_cd	=	@w_empinfo_authority_cd
		AND S5020.del_datetime IS NULL
		-- COUNT ALL ORGANIZATIONS OF S5022 -- add by viettd 2021/06/03
		SET @w_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_empinfo_authority_cd,@P_system)
		-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
		SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_empinfo_authority_cd,@P_system)
	END

	--#TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC SPC_REFER_ORGANIZATION_FND1 @P_list_org,@P_user_id,@P_company_cd, @P_system
	--
	IF @P_position_cd > 0
	BEGIN
		INSERT INTO #LIST_POSITION
		SELECT @P_position_cd,0
	END
	-- GET #LIST_POSITION
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
				(F0030.rater_employee_cd_1 = @employee_cd)
			OR	(F0030.rater_employee_cd_2 = @employee_cd)
			OR	(F0030.rater_employee_cd_3 = @employee_cd)
			OR	(F0030.rater_employee_cd_4 = @employee_cd)
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
	-- WEEKLYREPORT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF @P_system = 5
	BEGIN
		--#TABLE_REPOTERS_POPUP
		INSERT INTO #TABLE_REPOTERS_POPUP
		EXEC [dbo].SPC_REFER_REPORTER_FND1 @P_fiscal_year,@P_user_id,@P_company_cd

	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- GET ALL EMPLOYEE_CD
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

	INSERT INTO #EMPLOYEE
	SELECT 
		M0070.company_cd
	,	M0070.employee_cd
	,	#M0070H.office_nm
	,	M1.organization_cd_1
	,	M2.organization_cd_2
	,	M3.organization_cd_3
	,	M4.organization_cd_4
	,	M5.organization_cd_5
	,	#M0070H.job_cd
	,	#M0070H.position_cd
	,	#M0070H.employee_nm
	,	#M0070H.employee_typ
	,	#M0070H.belong_cd_1
	,	#M0070H.belong_cd_2
	,	#M0070H.belong_cd_3
	,	#M0070H.belong_cd_4
	,	#M0070H.belong_cd_5
	,	#M0070H.grade
	,	#M0070H.office_cd
	,	#M0070H.employee_typ_nm
	,	#M0070H.belong_nm_1
	,	#M0070H.belong_nm_2
	,	#M0070H.belong_nm_3
	,	#M0070H.belong_nm_4
	,	#M0070H.belong_nm_5
	,	#M0070H.job_nm
	,	#M0070H.position_nm
	,	#M0070H.grade_nm
	,	CASE
			WHEN (M0070.company_out_dt IS NOT NULL AND (M0070.company_out_dt <  @w_time))
			THEN ISNULL(IIF(@w_language = 2,'Retirement','退職'),'')
			ELSE	''
		END	AS company_out_dt
	,	CASE 
			WHEN F0100_MAX.employee_cd IS NOT NULL
			THEN 1	-- LOGIN IS HAS RATER
			ELSE 0
		END						AS	 rater_step
	,	CASE 
			WHEN @employee_cd = M0070.employee_cd THEN 1
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
			F0100.rater_employee_cd_1	=	@employee_cd
		OR	F0100.rater_employee_cd_2	=	@employee_cd
		OR	F0100.rater_employee_cd_3	=	@employee_cd
		OR	F0100.rater_employee_cd_4	=	@employee_cd
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
			F4200.approver_employee_cd_1	=	@employee_cd
		OR	F4200.approver_employee_cd_2	=	@employee_cd
		OR	F4200.approver_employee_cd_3	=	@employee_cd
		OR	F4200.approver_employee_cd_4	=	@employee_cd
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
		AND F4120.viewer_employee_cd	= @employee_cd
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
		AND F4207.sharewith_employee_cd	= @employee_cd
		AND F4207.del_datetime IS NULL
		GROUP BY
			F4207.company_cd
		,	F4207.fiscal_year
		,	F4207.employee_cd
	) F4207_CHECK ON (
		M0070.company_cd		=	F4207_CHECK.company_cd
	AND M0070.employee_cd		=	F4207_CHECK.employee_cd
	)
	LEFT JOIN M0010 ON( 
		M0070.company_cd = M0010.company_cd
	AND M0070.office_cd = M0010.office_cd
	--AND	(M0010.del_datetime IS NULL)
	)
	LEFT JOIN M0020 AS M1 ON (
		M1.company_cd			=	M0070.company_cd
	AND M1.organization_cd_1	=	M0070.belong_cd1
	AND M1.organization_typ		=	1
	--AND M1.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M2 ON (
		M2.company_cd			=	M0070.company_cd
	AND M2.organization_cd_1		=	M0070.belong_cd1
	AND M2.organization_cd_2		=	M0070.belong_cd2
	AND M2.organization_typ		=	2
	--AND M2.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M3 ON (
		M3.company_cd			=	M0070.company_cd
	AND M3.organization_cd_1		=	M0070.belong_cd1
	AND M3.organization_cd_2		=	M0070.belong_cd2
	AND M3.organization_cd_3		=	M0070.belong_cd3
	AND M3.organization_typ		=	3
	--AND M2.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M4 ON (
		M4.company_cd			=	M0070.company_cd
	AND M4.organization_cd_1		=	M0070.belong_cd1
	AND M4.organization_cd_2		=	M0070.belong_cd2
	AND M4.organization_cd_3		=	M0070.belong_cd3
	AND M4.organization_cd_4		=	M0070.belong_cd4
	AND M4.organization_typ		=	4
	--AND M2.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M5 ON (
		M5.company_cd			=	M0070.company_cd
	AND M5.organization_cd_1		=	M0070.belong_cd1
	AND M5.organization_cd_2		=	M0070.belong_cd2
	AND M5.organization_cd_3		=	M0070.belong_cd3
	AND M5.organization_cd_4		=	M0070.belong_cd4
	AND M5.organization_cd_5		=	M0070.belong_cd5
	AND M5.organization_typ		=	5
	--AND M2.del_datetime			IS NULL 
	) 
	LEFT JOIN M0030
	ON M0070.company_cd = M0030.company_cd
	AND M0070.job_cd	= M0030.job_cd
	--AND	(M0030.del_datetime IS NULL)
	LEFT JOIN M0040
	ON M0070.company_cd  = M0040.company_cd
	AND M0070.position_cd	= M0040.position_cd
	--AND	(M0040.del_datetime IS NULL)
	LEFT JOIN M0050
	ON M0070.company_cd = M0050.company_cd
	AND M0070.grade = M0050.grade
	--AND	(M0050.del_datetime IS NULL)
	LEFT JOIN M0060
	ON M0070.company_cd = M0060.company_cd
	AND M0070.employee_typ = M0060.employee_typ
	--AND	(M0060.del_datetime IS NULL)
	WHERE 
		((@P_employee_cd				= '')
		OR	(dbo.FNC_COM_REPLACE_SPACE(M0070.employee_cd)		LIKE '%' +	dbo.FNC_COM_REPLACE_SPACE(@P_employee_cd) + '%'))
	AND ((@P_office_cd					= -1)
		OR	(M0070.office_cd			= @P_office_cd))
	AND ((@P_job_cd						= -1)
		OR	(M0070.job_cd				= @P_job_cd))
	AND M0070.company_cd				= @P_company_cd
	AND M0070.del_datetime IS NULL
	AND (
		(@P_company_out_dt_flg	=	1)
	OR	(@P_company_out_dt_flg	=	0	AND (M0070.company_out_dt IS  NULL OR M0070.company_out_dt >=  @w_time))
	)
	AND	((@P_employee_nm				= '')
	OR	(dbo.FNC_COM_REPLACE_SPACE(M0070.employee_nm)		LIKE '%' +	dbo.FNC_COM_REPLACE_SPACE(@P_employee_nm) + '%')
	OR	(dbo.FNC_COM_REPLACE_SPACE(M0070.furigana)			LIKE '%' +	dbo.FNC_COM_REPLACE_SPACE(@P_employee_nm) + '%')
	)
	-- EPLOYEE CAN VIEW
	--IF @P_system = 1
	--BEGIN
	--	UPDATE #EMPLOYEE SET 
	--		is_filter_object = 0	-- 1.filter object | 0.not filter object
	--	FROM #EMPLOYEE
	--	INNER JOIN #TEMP_F0030 ON (
	--		#EMPLOYEE.company_cd		=	@P_company_cd
	--	AND #EMPLOYEE.employee_cd		=	#TEMP_F0030.employee_cd
	--	)
	--END
	--IF @P_system = 2
	--BEGIN
	--	UPDATE #EMPLOYEE SET 
	--		is_filter_object = 0	-- 1.filter object | 0.not filter object
	--	FROM #EMPLOYEE
	--	INNER JOIN #TABLE_MEMBER_OF_COACH_DB ON (
	--		#EMPLOYEE.company_cd		=	#TABLE_MEMBER_OF_COACH_DB.company_cd
	--	AND #EMPLOYEE.employee_cd		=	#TABLE_MEMBER_OF_COACH_DB.employee_cd
	--	)
	--END
	--IF @P_system = 3
	--BEGIN
	--	UPDATE #EMPLOYEE SET 
	--		is_filter_object = 0	-- 1.filter object | 0.not filter object
	--	FROM #EMPLOYEE
	--	INNER JOIN #TABLE_EMPLOYEE_SUPPORTED_DB ON (
	--		#EMPLOYEE.company_cd		=	#TABLE_EMPLOYEE_SUPPORTED_DB.company_cd
	--	AND #EMPLOYEE.employee_cd		=	#TABLE_EMPLOYEE_SUPPORTED_DB.employee_cd
	--	)
	--END
	---- WHEN  @P_system = 5 HERE
	--IF @P_system = 5
	--BEGIN
	--	UPDATE #EMPLOYEE SET 
	--		is_filter_object = 0	-- 1.filter object | 0.not filter object
	--	FROM #EMPLOYEE
	--	INNER JOIN #TABLE_REPOTERS_POPUP ON (
	--		#EMPLOYEE.company_cd		=	#TABLE_REPOTERS_POPUP.company_cd
	--	AND #EMPLOYEE.employee_cd		=	#TABLE_REPOTERS_POPUP.employee_cd
	--	)
	--END


	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- FILTER
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- #TABLE_ORGANIZATION
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
	BEGIN
		SET @choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
		-- 1.choice in screen
		IF @choice_in_screen = 1
		BEGIN
			DELETE D FROM #EMPLOYEE AS D
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
		END
		ELSE
		BEGIN
			-- 人事評価
			IF @P_system = 1 AND NOT (@w_authority_typ = 3 AND @w_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)	-- edited by viettd 2021/06/03
			BEGIN
				
				DELETE D FROM #EMPLOYEE AS D
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
			ELSE IF @P_system = 2 AND NOT (@w_1on1_authority_typ = 3 AND @w_organization_cnt = 0 AND @w_organization_belong_person_typ = 0) -- edited by viettd 2021/06/03
			BEGIN
				DELETE D FROM #EMPLOYEE AS D
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
				AND @w_1on1_authority_typ NOT IN(1,2,4,5) --1.メンバー 2.コーチ 4.会社管理者 5.総合管理者 edited by viettd 2022/01/20
				--AND D.is_filter_object = 1
			END
			ELSE IF @P_system = 3 AND NOT (@w_multireview_authority_typ = 3 AND @w_organization_cnt = 0 AND @w_organization_belong_person_typ = 0) -- edited by viettd 2021/06/03
			BEGIN
				DELETE D FROM #EMPLOYEE AS D
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
			ELSE IF @P_system = 4 AND NOT (@w_setting_authority_typ = 3 AND @w_organization_cnt = 0 AND @w_organization_belong_person_typ = 0) -- edited by viettd 2021/06/03
			BEGIN
				DELETE D FROM #EMPLOYEE AS D
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
				AND @w_setting_authority_typ NOT IN(4,5) --4.会社管理者 5.総合管理者
				--AND D.is_filter_object = 1
			END
			ELSE IF @P_system = 5 AND NOT (@w_report_authority_typ = 3 AND @w_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)
			BEGIN
				DELETE D FROM #EMPLOYEE AS D
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
			ELSE IF @P_system = 6 AND NOT (@w_empinfo_authority_typ = 3 AND @w_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)
			BEGIN
				DELETE D FROM #EMPLOYEE AS D
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
				AND @w_empinfo_authority_typ NOT IN(4,5) --4.会社管理者 5.総合管理者
			END
		END
	END
	-- FILTER 役職
	IF EXISTS (SELECT 1 FROM #LIST_POSITION)
	BEGIN
		-- choice in screen 
		IF EXISTS (SELECT 1 FROM #LIST_POSITION WHERE mode = 0)
		BEGIN
			DELETE D FROM #EMPLOYEE AS D
			LEFT OUTER JOIN #LIST_POSITION AS S ON (
				D.company_cd		=	@P_company_cd
			AND D.position_cd		=	S.position_cd
			)
			WHERE
				S.position_cd IS NULL
		END
		ELSE -- not choice in screen
		BEGIN
			-- 人事評価
			IF 
			(
				@P_system = 1 AND @w_authority_typ NOT IN (4,5)
			)
			BEGIN
				DELETE D FROM #EMPLOYEE AS D
				LEFT OUTER JOIN #LIST_POSITION AS S ON (
					D.company_cd		=	@P_company_cd
				AND D.position_cd		=	S.position_cd
				)
				WHERE
					S.position_cd IS NULL
				AND D.rater_step = 0 -- add by viettd 2022/03/31
				--AND D.is_filter_object = 1
			END
			-- 1ON1 , MULITIREVIEW , BASIC SETTING
			ELSE IF (
				(@P_system = 2 AND @w_1on1_authority_typ NOT IN (4,5))
			OR	(@P_system = 3 AND @w_multireview_authority_typ NOT IN (4,5))
			OR	(@P_system = 4 AND @w_setting_authority_typ NOT IN (4,5))
			OR	(@P_system = 5 AND @w_report_authority_typ NOT IN (4,5))
			OR	(@P_system = 6 AND @w_empinfo_authority_typ NOT IN (4,5))
			)
			BEGIN
				DELETE D FROM #EMPLOYEE AS D
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
	-- FILTER #TEMP_F0030 (人事評価　：評価者)
	IF @P_system = 1 AND @w_authority_typ = 2
	BEGIN
		DELETE D FROM #EMPLOYEE AS D
		LEFT OUTER JOIN #TEMP_F0030 AS S ON (
			D.company_cd		=	@P_company_cd
		AND D.employee_cd		=	S.employee_cd
		)
		WHERE
			S.employee_cd IS NULL
	END
	-- FILTER #TABLE_MEMBER_OF_COACH_DB (1ON1)
	IF @P_system = 2
	BEGIN
		DELETE D FROM #EMPLOYEE AS D
		LEFT OUTER JOIN #TABLE_MEMBER_OF_COACH_DB AS S ON (
			D.company_cd  = S.company_cd
		AND D.employee_cd = S.employee_cd
		)
		WHERE S.employee_cd IS NULL
	END 
	-- FILTER #TABLE_EMPLOYEE_SUPPORTED_DB (MULITIREVIEW)
	IF @P_system = 3
	BEGIN
		DELETE D FROM #EMPLOYEE AS D
		LEFT OUTER JOIN #TABLE_EMPLOYEE_SUPPORTED_DB AS S ON (
			D.company_cd  = S.company_cd
		AND D.employee_cd = S.employee_cd
		)
		WHERE S.employee_cd IS NULL
	END 
	-- FILTER #TABLE_REPOTERS_POPUP (WEEKLYREPORT)
	IF @P_system = 5
	BEGIN
		DELETE D FROM #EMPLOYEE AS D
		LEFT OUTER JOIN #TABLE_REPOTERS_POPUP AS S ON (
			D.company_cd  = S.company_cd
		AND D.employee_cd = S.employee_cd
		)
		WHERE S.employee_cd IS NULL
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--
	SET @totalRecord = (SELECT COUNT(1) FROM #EMPLOYEE)
	SET @pageMax = CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	IF @pageMax = 0
	BEGIN
		SET @pageMax = 1
	END
	IF @P_page > @pageMax
	BEGIN
		SET @P_page = @pageMax
	END	
	-- [0]
	SELECT 
		#EMPLOYEE.company_cd			
	,	ISNULL(#EMPLOYEE.employee_cd,'')		AS employee_cd			
	,	SPACE(0)								AS employee_ab_nm		
	,	ISNULL(#EMPLOYEE.office_nm,'')			AS office_nm		
	,	ISNULL(#EMPLOYEE.organization_cd1,0)	AS organization_cd1
	,	ISNULL(#EMPLOYEE.organization_cd2,0)	AS organization_cd2	
	,	ISNULL(#EMPLOYEE.organization_cd3,0)	AS organization_cd3
	,	ISNULL(#EMPLOYEE.organization_cd4,0)	AS organization_cd4	
	,	ISNULL(#EMPLOYEE.organization_cd5,0)	AS organization_cd5
	,	ISNULL(#EMPLOYEE.job_cd,0)				AS job_cd				
	,	ISNULL(#EMPLOYEE.position_cd,0)			AS position_cd			
	,	ISNULL(#EMPLOYEE.employee_nm,'')		AS employee_nm			
	,	ISNULL(#EMPLOYEE.employee_typ,0)		AS employee_typ	
	,	ISNULL(#EMPLOYEE.belong_cd1,'')			AS belong_cd1			
	,	ISNULL(#EMPLOYEE.belong_cd2,'')			AS belong_cd2
	,	ISNULL(#EMPLOYEE.belong_cd3,'')			AS belong_cd3			
	,	ISNULL(#EMPLOYEE.belong_cd4,'')			AS belong_cd4
	,	ISNULL(#EMPLOYEE.belong_cd5,'')			AS belong_cd5			
	,	ISNULL(#EMPLOYEE.job_cd,0)				AS job_cd 				
	,	ISNULL(#EMPLOYEE.position_cd,0)			AS position_cd	
	--↓2023/07/25 fixed
	--,	ISNULL(#EMPLOYEE.grade,0)				AS grade				
	,	CASE WHEN @w_company_attribute=3 THEN '' ELSE ISNULL(#EMPLOYEE.grade,0) END AS grade
	--↑2023/07/25 fixed	
	,	ISNULL(#EMPLOYEE.office_cd,0)			AS office_cd			
	,	ISNULL(#EMPLOYEE.employee_typ_nm,'')	AS employee_typ_nm		
	,	ISNULL(#EMPLOYEE.organization_nm1,'')	AS organization_nm1	
	,	ISNULL(#EMPLOYEE.organization_nm2,'')	AS organization_nm2
	,	ISNULL(#EMPLOYEE.organization_nm3,'')	AS organization_nm3	
	,	ISNULL(#EMPLOYEE.organization_nm4,'')	AS organization_nm4
	,	ISNULL(#EMPLOYEE.organization_nm5,'')	AS organization_nm5	
	,	ISNULL(#EMPLOYEE.job_nm,'')				AS job_nm				
	,	ISNULL(#EMPLOYEE.position_nm,'')		AS position_nm			
	--↓2023/07/25 fixed
	--,	ISNULL(#EMPLOYEE.grade_nm,'')			AS grade_nm	
	,	CASE WHEN @w_company_attribute=3 THEN '' ELSE ISNULL(#EMPLOYEE.grade_nm,0) END AS grade_nm
	--↑2023/07/25 fixed	
	,	ISNULL(#EMPLOYEE.company_out_dt,'')		AS company_out_dt		
	FROM #EMPLOYEE
	ORDER BY 
		CASE ISNUMERIC(#EMPLOYEE.employee_cd) 
		   WHEN 1 
		   THEN CAST(#EMPLOYEE.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	#EMPLOYEE.employee_cd
	offset (@P_page - 1) * @P_page_size rows
	fetch next @P_page_size rows only
	--[1]
	SELECT	
		@totalRecord	AS totalRecord
	,	@pageMax		AS pageMax
	,	@P_page			AS page
	,	@P_page_size	AS pagesize
	,	((@P_page - 1) * @P_page_size + 1) AS offset
	--CLEAN
	DROP TABLE #EMPLOYEE
	DROP TABLE #LIST_POSITION
	DROP TABLE #TEMP_F0030
	DROP TABLE #TABLE_ORGANIZATION
	DROP TABLE #TABLE_MEMBER_OF_COACH_DB
	DROP TABLE #TABLE_EMPLOYEE_SUPPORTED_DB
	DROP TABLE #M0070H
	DROP TABLE #TABLE_REPOTERS_POPUP
END
GO
