DROP PROCEDURE [SPC_rQ2010_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--	EXEC SPC_rQ2010_FND1 '2023-01-01', '2023-12-01',4,-1,-1,-1,-1,'',0,0,0,0,-1,-1,-1,-1,'','',1,20,0,782,721,721
--	EXEC SPC_rQ2010_FND1 '2023-01-01', '2023-12-01',4,-1,-1,-1,-1,'',0,0,0,0,-1,-1,-1,-1,'','',1,20,1,782,721,721
--  EXEC SPC_rQ2010_FND1 '2023/01/1','2024/02/30','2','-1','-1','-1','','0','0','0','0','-1','-1','-1','-1','','{"list_organization_step1":[],"list_organization_step2":[],"list_organization_step3":[],"list_organization_step4":[],"list_organization_step5":[],"status":[]}','1','20','0','2023','10035','a028','acc028';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET REPORTS FOR rQ2010_週報一覧
--*  
--*  作成日/create date			:	2023/05/08						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content	:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rQ2010_FND1]
	@P_year_month_from		DATE			=	NULL	--	年月 from	required
,	@P_year_month_to		DATE			=	NULL	--	年月 to		required
,	@P_report_kind			SMALLINT		=	-1		--	報告書種類	required
,	@P_group_cd				SMALLINT		=	-1		--	グループ
,	@P_mygroup_cd			SMALLINT		=	-1		--	マイグループ
,	@P_reporter_cd			NVARCHAR(10)	=	''		--	namnt add 2024/07/14
,	@P_note_kind			SMALLINT		=	-1		--  付箋
,	@P_key_search			NVARCHAR(100)	=	''		--  フリーワード
,	@P_adequacy_kbn			SMALLINT		=	0		--  充実度
,	@P_busyness_kbn			SMALLINT		=	0		--  繁忙度
,	@P_other_kbn			SMALLINT		=	0		--  その他	
,	@P_is_shared			SMALLINT		=	0		--  0|1 共有された報告書
,	@P_position_cd			INT				=	-1		--  役職
,	@P_job_cd				SMALLINT		=	-1		--  職種
,	@P_grade				SMALLINT		=	-1		--  等級
,	@P_employee_typ			SMALLINT		=	-1		--  社員区分
,	@P_approver_cd			NVARCHAR(10)	=	''		--  承認者
,	@P_json					NVARCHAR(max)	=	''		--  組織１ ~ 組織５
,	@P_page					INT				=	1
,	@P_page_size			INT				=	20
,	@P_mode					SMALLINT		=	0		--	0.SEARCH 1.CSV
,	@P_fiscal_year			SMALLINT		=	0	
--
,	@P_company_cd			SMALLINT		=	0
,	@P_login_employee_cd	NVARCHAR(10)	=	''		-- LOGIN EMPLOYEE_CD
,	@P_cre_user				NVARCHAR(50)	=	''		-- LOGIN USER_CD
,	@P_count_org			SMALLINT		=	0
AS
BEGIN
	DECLARE 
		@w_language							smallint		=	0	-- 1.JP 2.EN
	,	@w_totalRecord						bigint			=	0
	,	@w_pageMax							int				=	0	
	--	
	,	@w_login_position_cd				int				=	0
	,	@w_report_authority_typ				smallint		=	0
	,	@w_report_authority_cd				smallint		=	0
	,	@w_use_typ							smallint		=	0	
	,	@w_arrange_order					int				=	0
	,	@w_evaluation_organization_cnt		int				=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	smallint		=	0
	,	@w_choice_in_screen					tinyint			=	0
	,	@w_current_fiscal_year				INT				=	[dbo].FNC_GET_YEAR_WEEKLY_REPORT (@P_company_cd,NULL)
	,	@w_beginning_date					DATE			=	NULL
	,	@w_year_month_day					DATE			=	NULL
	,	@w_begin_fiscal_year				SMALLINT		=	0
	--
	,	@w_company_attribute	smallint		=	0	-- 1.管理会社 2.ユーザー会社 3.グループ会社　--2023/07/25 add
	--#TABLE_RESULT
	CREATE TABLE #TABLE_RESULT(
		id						int		identity(1,1)
	,	company_cd				smallint
	,	fiscal_year				smallint
	,	employee_cd				nvarchar(10)
	,	report_kind				smallint
	,	report_no				smallint
	,	[year]					smallint
	,	belong_cd_1				nvarchar(20)
	,	belong_cd_2				nvarchar(20)
	,	belong_cd_3				nvarchar(20)
	,	belong_cd_4				nvarchar(20)
	,	belong_cd_5				nvarchar(20)
	,	position_cd				int
	,	status_cd				smallint
	,	sharewith_status		smallint	--	0. NOT SHARE 1.SHARE DONE
	,	year_month				date
	,	can_linked				tinyint		--	0.not view link 1. can linked (can view)
	,	checkbox_is_show		tinyint		--	0.not show checkbox 1. show checkbox
	,	is_approver_viewer		tinyint
	,	sheet_cd				SMALLINT
	,	adaption_date			DATE
	)
	CREATE TABLE #TABLE_QUESTION_ANSWER(
		id						int		identity(1,1)
	,	company_cd				smallint
	,	fiscal_year				smallint
	,	employee_cd				nvarchar(10)
	,	report_kind				smallint
	,	report_no				smallint
	,	sheet_detail_no			SMALLINT
	,	question_no				tinyint
	,	question_content		nvarchar(200)
	,	question_answer			nvarchar(1200)
	)
	CREATE TABLE #TABLE_QUESTION(
		id						int		identity(1,1)
	,	company_cd				smallint
	,	fiscal_year				smallint
	,	employee_cd				nvarchar(10)
	,	report_kind				smallint
	,	report_no				smallint
	,	question_no_1			tinyint
	,	question_content_1		nvarchar(200)
	,	question_answer_1		nvarchar(1200)
	,	question_no_2			tinyint
	,	question_content_2		nvarchar(200)
	,	question_answer_2		nvarchar(1200)
	,	question_no_3			tinyint
	,	question_content_3		nvarchar(200)
	,	question_answer_3		nvarchar(1200)
	,	question_no_4			tinyint
	,	question_content_4		nvarchar(200)
	,	question_answer_4		nvarchar(1200)
	,	question_no_5			tinyint
	,	question_content_5		nvarchar(200)
	,	question_answer_5		nvarchar(1200)
	,	question_no_6			tinyint
	,	question_content_6		nvarchar(200)
	,	question_answer_6		nvarchar(1200)
	,	question_no_7			tinyint
	,	question_content_7		nvarchar(200)
	,	question_answer_7		nvarchar(1200)
	,	question_no_8			tinyint
	,	question_content_8		nvarchar(200)
	,	question_answer_8		nvarchar(1200)
	,	question_no_9			tinyint
	,	question_content_9		nvarchar(200)
	,	question_answer_9		nvarchar(1200)
	,	question_no_10			tinyint
	,	question_content_10		nvarchar(200)
	,	question_answer_10		nvarchar(1200)
	)
	-- #TABLE_F4206_TEMP 
	CREATE TABLE #TABLE_F4206_TEMP(
		id					int		identity(1,1)
	,	company_cd			smallint
	,	fiscal_year			smallint
	,	employee_cd			nvarchar(10)
	,	report_kind			smallint
	,	report_no			smallint
	,	note_employee_cd	nvarchar(10)
	,	note_employee_nm	nvarchar(200)
	,	note_kind			smallint
	,	note_no				smallint
	,	note_color			smallint
	,	note_color_nm		nvarchar(50)
	,	note_name			nvarchar(10)
	)
	-- #TABLE_F4206_TEMP 
	CREATE TABLE #TABLE_F4206_TEMP_JSON(
		id					int		identity(1,1)
	,	company_cd			smallint
	,	fiscal_year			smallint
	,	employee_cd			nvarchar(10)
	,	report_kind			smallint
	,	report_no			smallint
	,	note_json			nvarchar(max)
	)
	-- #TABLE_F4202_TEMP 
	CREATE TABLE #TABLE_F4202_TEMP(
		id					int		identity(1,1)
	,	company_cd			smallint
	,	fiscal_year			smallint
	,	employee_cd			nvarchar(10)
	,	report_kind			smallint
	,	report_no			smallint
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
	--#LIST_STATUS
	CREATE TABLE #LIST_STATUS(
		id								int			identity(1,1)
	,	status_cd						smallint
	)
	CREATE TABLE #TEMP_FISCAL_BEGIN_DATE (
		fiscal_year						SMALLINT 
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
	CREATE TABLE #TABLE_REPOTERS_RQ2010 (
		company_cd					smallint
	,	fiscal_year					smallint
	,	employee_cd					nvarchar(10)
	,	employee_nm					nvarchar(200)
	)
	INSERT #LIST_STATUS
	SELECT 
		b.value
	FROM OPENJSON (@P_json,'$') WITH(
		[status]	NVARCHAR(MAX) '$.status' AS JSON
	)
	a
	CROSS APPLY OPENJSON(a.status,'$') b
	SELECT 
		@w_language					=	ISNULL(S0010.[language],1)
	,	@w_report_authority_typ		=	ISNULL(S0010.report_authority_typ,0)
	,	@w_report_authority_cd		=	ISNULL(S0010.report_authority_cd,0)
	,	@w_login_position_cd		=	ISNULL(M0070.position_cd,0)
	FROM S0010
	LEFT OUTER JOIN M0070 ON (
		S0010.company_cd		=	M0070.company_cd
	AND S0010.employee_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	WHERE 
		S0010.company_cd	=	@P_company_cd
	AND S0010.employee_cd	=	@P_login_employee_cd
	AND S0010.del_datetime IS NULL
	--↓ 2023/07/25 add：GET company_attribute 
	SELECT 
		@w_company_attribute =	M0001.contract_company_attribute
	FROM M0001
	WHERE 
		M0001.company_cd	=	@P_company_cd
    --↑ 2023/07/25 add
	--
	SELECT 
		@w_use_typ		=	ISNULL(S4020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
	FROM S4020
	WHERE
		S4020.company_cd		=	@P_company_cd
	AND S4020.authority_cd		=	@w_report_authority_cd
	AND S4020.del_datetime IS NULL
	-- get @arrange_order
	SELECT 
		@w_arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@w_login_position_cd
	AND M0040.del_datetime IS NULL
	--
	SET @P_year_month_to	=	EOMONTH(@P_year_month_to)
	------
	SELECT 
		@w_beginning_date = M9100.report_beginning_date 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	--
	IF @w_beginning_date IS NOT NULL
	BEGIN
		SET @w_year_month_day = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/' + FORMAT(@w_beginning_date,'MM/dd')) AS DATE)
		SET @w_year_month_day = DATEADD(DD,-1,DATEADD(YYYY,1,@w_year_month_day))
	END
	ELSE
	BEGIN 
		SET @w_year_month_day = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/12/31') AS DATE)
	END
	--
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1  @w_year_month_day,'',@P_company_cd
	-- COUNT ALL ORGANIZATIONS
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_report_authority_cd,5)
	-- GET @w_organization_belong_person_typ
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_report_authority_cd,5)
	-- INSERT DATA INTO #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 @P_json,@P_cre_user,@P_company_cd, 5
	-- INSERT DATA INTO #LIST_POSITION
	IF @P_position_cd > 0
	BEGIN
		INSERT INTO #LIST_POSITION
		SELECT @P_position_cd,0
	END
	-- GET #TABLE_REPOTERS_CAN_VIEW
	INSERT INTO #TEMP_FISCAL_BEGIN_DATE
	EXEC SPC_GET_FISCAL_YEAR @P_company_cd, 5, @P_year_month_from
	SELECT 
	@w_begin_fiscal_year = MIN(fiscal_year)
	FROM #TEMP_FISCAL_BEGIN_DATE
	INSERT INTO #TABLE_REPOTERS_RQ2010 
	EXEC [dbo].SPC_REFER_REPORTER_FND1 @P_fiscal_year,@P_cre_user,@P_company_cd,@w_begin_fiscal_year
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
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--PREPARE DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	INSERT INTO #TABLE_RESULT
	SELECT 
		F4200.company_cd	
	,	F4200.fiscal_year	
	,	F4200.employee_cd	
	,	F4200.report_kind	
	,	F4200.report_no	
	,	ISNULL(F4200.year, 0)
	,	ISNULL(#M0070H.belong_cd_1,'')	
	,	ISNULL(#M0070H.belong_cd_2,'')	
	,	ISNULL(#M0070H.belong_cd_3,'')	
	,	ISNULL(#M0070H.belong_cd_4,'')	
	,	ISNULL(#M0070H.belong_cd_5,'')	
	,	ISNULL(#M0070H.position_cd,0)
	,	ISNULL(F4200.status_cd,0)
	,	CASE 
			WHEN F4207_TMP.employee_cd IS NOT NULL
			THEN 1
			ELSE 0
		END								AS	sharewith_status
	,	CASE
		WHEN @P_report_kind IN (4,5)
		THEN
		CONVERT(DATE,( CAST(ISNULL(F4200.year,1900) AS nvarchar(4)) + '-' + RIGHT('00'+CAST(ISNULL(F4200.month,1) AS nvarchar(2)),2) + '-01'))
		ELSE
		NULL
		END	AS	year_month
	,	CASE 
			WHEN F4200.employee_cd = @P_login_employee_cd	-- LOGIN IS REPOTER
			THEN 1
			WHEN F4200.approver_employee_cd_1 = @P_login_employee_cd AND F4200.status_cd >= 2	-- LOGIN IS APPROVER 1 CAN VIEW
			THEN 1
			WHEN F4200.approver_employee_cd_2 = @P_login_employee_cd AND F4200.status_cd >= 3	-- LOGIN IS APPROVER 2 CAN VIEW
			THEN 1
			WHEN F4200.approver_employee_cd_3 = @P_login_employee_cd AND F4200.status_cd >= 4	-- LOGIN IS APPROVER 3 CAN VIEW
			THEN 1
			WHEN F4200.approver_employee_cd_4 = @P_login_employee_cd AND F4200.status_cd >= 5	-- LOGIN IS APPROVER 4 CAN VIEW
			THEN 1		
			WHEN F4120.viewer_employee_cd IS NOT NULL AND F4200.status_cd = 6					-- LOGIN IS VIEWER CAN VIEW
			THEN 1
			WHEN F4207_TMP.company_cd IS NOT NULL AND F4200.status_cd = 6						-- LOGIN IS SHARED CAN VIEW
			THEN 1
			WHEN @w_report_authority_typ IN (4,5)
			THEN 1
			ELSE 0
		END								AS	can_linked
	,	CASE 
			WHEN F4201.submission_datetime IS NULL AND @w_report_authority_typ IN (3,4,5)
			THEN 1
			ELSE 0
		END								AS	checkbox_is_show
	,	CASE 
			WHEN @P_login_employee_cd = F4200.employee_cd THEN 1
			WHEN F4200_CHECK.company_cd IS NOT NULL THEN 1	-- LOGIN IS HAS APPROVER 
			WHEN F4120_CHECK.company_cd IS NOT NULL THEN 1	-- LOGIN IS HAS VIEWER 
			WHEN F4207_CHECK.company_cd IS NOT NULL THEN 1	-- LOGIN IS HAS SHARE
			ELSE 0
		END
	,	F4200.sheet_cd
	,	F4200.adaption_date
	FROM F4200
	LEFT JOIN #M0070H ON (
		F4200.company_cd		=	#M0070H.company_cd
	AND F4200.employee_cd		=	#M0070H.employee_cd
	)
	LEFT OUTER JOIN F4110 ON (
		F4200.company_cd		=	F4110.company_cd
	AND F4200.fiscal_year		=	F4110.fiscal_year
	AND F4200.employee_cd		=	F4110.employee_cd
	AND F4200.report_kind		=	F4110.report_kind
	AND F4200.report_no			=	F4110.report_no
	AND F4110.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4111 ON (
		F4200.company_cd		=	F4111.company_cd
	AND F4200.fiscal_year		=	F4111.fiscal_year
	AND F4200.employee_cd		=	F4111.employee_cd
	AND F4200.report_kind		=	F4111.report_kind
	AND F4200.report_no			=	F4111.report_no
	AND F4111.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4201 ON (
		F4200.company_cd		=	F4201.company_cd
	AND F4200.fiscal_year		=	F4201.fiscal_year
	AND F4200.employee_cd		=	F4201.employee_cd
	AND F4200.report_kind		=	F4201.report_kind
	AND F4200.report_no			=	F4201.report_no
	AND F4201.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4120 ON (
		F4200.company_cd		=	F4120.company_cd
	AND F4200.fiscal_year		=	F4120.fiscal_year
	AND F4200.employee_cd		=	F4120.employee_cd
	AND F4200.report_kind		=	F4120.report_kind
	AND F4200.report_no			=	F4120.report_no
	AND @P_login_employee_cd	=	F4120.viewer_employee_cd
	AND F4120.del_datetime IS NULL
	)
	LEFT OUTER JOIN (
		SELECT 
			F4207.company_cd
		,	F4207.fiscal_year
		,	F4207.employee_cd
		,	F4207.report_kind
		,	F4207.report_no
		FROM F4207
		WHERE 
			F4207.company_cd			=	@P_company_cd
		AND F4207.report_kind			=	@P_report_kind
		AND F4207.sharewith_employee_cd	=	@P_login_employee_cd
		AND F4207.del_datetime IS NULL
		GROUP BY
			F4207.company_cd
		,	F4207.fiscal_year
		,	F4207.employee_cd
		,	F4207.report_kind
		,	F4207.report_no
	) AS F4207_TMP ON (
		F4200.company_cd		=	F4207_TMP.company_cd
	AND F4200.fiscal_year		=	F4207_TMP.fiscal_year
	AND F4200.employee_cd		=	F4207_TMP.employee_cd
	AND F4200.report_kind		=	F4207_TMP.report_kind
	AND F4200.report_no			=	F4207_TMP.report_no
	) 
	LEFT OUTER JOIN (
		SELECT
			F4200.company_cd
		,	F4200.fiscal_year
		,	F4200.employee_cd
		FROM F4200
		WHERE
			F4200.company_cd	= @P_company_cd
		AND F4200.report_kind	= @P_report_kind
		AND (
			(F4200.approver_employee_cd_1	=	@P_login_employee_cd AND F4200.status_cd >= 2)
		OR	(F4200.approver_employee_cd_2	=	@P_login_employee_cd AND F4200.status_cd >= 3)
		OR	(F4200.approver_employee_cd_3	=	@P_login_employee_cd AND F4200.status_cd >= 4)
		OR	(F4200.approver_employee_cd_4	=	@P_login_employee_cd AND F4200.status_cd >= 5)
		)
		AND F4200.del_datetime IS NULL
		GROUP BY
			F4200.company_cd
		,	F4200.fiscal_year
		,	F4200.employee_cd
	) AS F4200_CHECK ON (
		F4200.company_cd		=	F4200_CHECK.company_cd
	AND F4200.employee_cd		=	F4200_CHECK.employee_cd
	AND F4200.fiscal_year		=	F4200_CHECK.fiscal_year
	)
	LEFT OUTER JOIN (
		SELECT
			F4120.company_cd
		,	F4120.fiscal_year
		,	F4120.employee_cd
		FROM F4120
		WHERE
			F4120.company_cd			=	@P_company_cd
		AND F4120.report_kind			=	@P_report_kind
		AND F4120.viewer_employee_cd	=	@P_login_employee_cd
		AND F4120.del_datetime IS NULL
		GROUP BY
			F4120.company_cd
		,	F4120.fiscal_year
		,	F4120.employee_cd
	) AS F4120_CHECK ON (
		F4200.company_cd		=	F4120_CHECK.company_cd
	AND F4200.employee_cd		=	F4120_CHECK.employee_cd
	AND F4200.fiscal_year		=	F4120_CHECK.fiscal_year
	AND F4200.status_cd			=	6
	)
	LEFT OUTER JOIN (
		SELECT
			F4207.company_cd
		,	F4207.fiscal_year
		,	F4207.employee_cd
		FROM F4207
		WHERE
			F4207.company_cd			=	@P_company_cd
		AND F4207.report_kind			=	@P_report_kind
		AND F4207.sharewith_employee_cd	=	@P_login_employee_cd
		AND F4207.del_datetime IS NULL
		GROUP BY
			F4207.company_cd
		,	F4207.fiscal_year
		,	F4207.employee_cd
	) AS F4207_CHECK ON (
		F4200.company_cd		=	F4207_CHECK.company_cd
	AND F4200.employee_cd		=	F4207_CHECK.employee_cd
	AND F4200.fiscal_year		=	F4207_CHECK.fiscal_year
	AND F4200.status_cd			=	6
	)
	WHERE
		F4200.company_cd		=	@P_company_cd
	AND F4200.report_kind		=	@P_report_kind
	AND (
		@P_report_kind = -1
	OR	@P_report_kind <> -1 AND F4200.report_kind	= @P_report_kind
	)
	AND (
		@P_group_cd = -1
	OR	@P_group_cd <> -1 AND F4110.group_cd = @P_group_cd
	)
	AND (
		@P_adequacy_kbn <=	0
	OR	@P_adequacy_kbn	>	0 AND F4201.adequacy_kbn = @P_adequacy_kbn
	)
	AND (
		@P_busyness_kbn <=	0
	OR	@P_busyness_kbn	>	0 AND F4201.busyness_kbn = @P_busyness_kbn
	)
	AND (
		@P_other_kbn <=	0
	OR	@P_other_kbn	>	0 AND F4201.other_kbn = @P_other_kbn
	)
	AND (
		@P_position_cd <=	0
	OR	@P_position_cd	>	0 AND #M0070H.position_cd = @P_position_cd
	)
	AND (
		@P_job_cd <=	0
	OR	@P_job_cd	>	0 AND #M0070H.job_cd = @P_job_cd
	)
	-- ↓2023/07/25 fixed
	/*
	AND (
		@P_grade <=	0
	OR	@P_grade	>	0 AND #M0070H.grade = @P_grade
	)
	*/
	AND (
	        (@w_company_attribute=3)
	    OR 
	        (@w_company_attribute!=3
		     AND (    @P_grade <=	0
		          OR @P_grade	>	0 AND #M0070H.grade = @P_grade
		         )
	        )
	)
	-- ↑2023/07/25 fixed
	AND (
		@P_employee_typ <=	0
	OR	@P_employee_typ	>	0 AND #M0070H.employee_typ = @P_employee_typ
	)
	AND (
		(@P_approver_cd	= '')
	OR	(@P_approver_cd	<>	'' AND (
									F4111.approver_employee_cd_1 = @P_approver_cd
								OR	F4111.approver_employee_cd_2 = @P_approver_cd
								OR	F4111.approver_employee_cd_3 = @P_approver_cd
								OR	F4111.approver_employee_cd_4 = @P_approver_cd
									)
		)
	)
	AND F4200.del_datetime IS NULL
	AND (@P_year_month_from = ''
		OR ( @P_year_month_from <> '' AND (F4200.[year]*100 + F4200.[month])  >=  YEAR(@P_year_month_from)*100 + MONTH(@P_year_month_from) ))
	AND	(@P_year_month_to =''
		OR (@P_year_month_to <> ''AND	(F4200.[year]*100 + F4200.[month])  <=  YEAR(@P_year_month_to)*100 + MONTH(@P_year_month_to) ))
	AND (@P_reporter_cd = ''
	OR 
	(	@P_reporter_cd <> ''
	AND	F4200.employee_cd LIKE @P_reporter_cd
	))

	IF(@w_report_authority_typ = 3)
	BEGIN
		UPDATE #TABLE_RESULT SET 
			can_linked = 1
		FROM #TABLE_RESULT 
		WHERE is_approver_viewer = 0
	END
	-- ADD BY VIETTD 2023/06/15
	-- SHOW ONLY RECORED WHEN CAN LINKED
	DELETE D FROM #TABLE_RESULT AS D WHERE D.can_linked = 0
	--■ FILTER BY MY_GROUP_CD
	IF @P_mygroup_cd > 0
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D
		LEFT OUTER JOIN F4011 ON (
			D.company_cd				=	F4011.company_cd
		AND	@P_login_employee_cd		=	F4011.employee_cd
		AND @P_mygroup_cd				=	F4011.mygroup_cd
		AND D.employee_cd	=	F4011.mygroup_member_cd
		AND F4011.del_datetime IS NULL
		)
		WHERE 
			F4011.company_cd IS NULL
	END
	-- FILTER 状況
	IF EXISTS (SELECT 1 FROM #LIST_STATUS)
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D
		LEFT OUTER JOIN #LIST_STATUS ON (
			D.status_cd		=	#LIST_STATUS.status_cd
		)
		WHERE 
			#LIST_STATUS.status_cd IS NULL
	END
	
	-- FILTER 付箋 (CHUA CHECK DEN QUYEN NGUOI LOGIN LA GI)
	IF @P_note_kind > 0
	BEGIN
		IF @w_report_authority_typ IN(3,4,5) --user login is manager
		BEGIN
			DELETE D FROM #TABLE_RESULT AS D
			LEFT OUTER JOIN F4206 ON (
				D.company_cd				=	F4206.company_cd
			AND D.fiscal_year				=	F4206.fiscal_year
			AND	D.employee_cd				=	F4206.employee_cd
			AND D.report_kind				=	F4206.report_kind
			AND D.report_no					=	F4206.report_no
			AND @P_note_kind				=	F4206.note_no
			AND F4206.del_datetime IS NULL
			)
			WHERE 
				F4206.company_cd IS NULL
		END
		--user login is not manager
		IF @w_report_authority_typ NOT IN(3,4,5)
		BEGIN
			DELETE D FROM #TABLE_RESULT AS D
			LEFT OUTER JOIN F4206 ON (
				D.company_cd				=	F4206.company_cd
			AND D.fiscal_year				=	F4206.fiscal_year
			AND	D.employee_cd				=	F4206.employee_cd
			AND D.report_kind				=	F4206.report_kind
			AND D.report_no					=	F4206.report_no
			AND @P_note_kind				=	F4206.note_no
			AND @P_login_employee_cd		=	F4206.note_employee_cd
			AND F4206.del_datetime IS NULL
			)
			WHERE 
				F4206.company_cd IS NULL
		END
	END
	
	-- フリーワード
	IF @P_key_search <> ''
	BEGIN
		-- #TABLE_F4202_TEMP
		INSERT INTO #TABLE_F4202_TEMP
		SELECT 
			F4202.company_cd	
		,	F4202.fiscal_year	
		,	F4202.employee_cd	
		,	F4202.report_kind	
		,	F4202.report_no	
		FROM F4202
		INNER JOIN #TABLE_RESULT AS S ON (
			F4202.company_cd		=	S.company_cd
		AND F4202.fiscal_year		=	S.fiscal_year
		AND F4202.employee_cd		=	S.employee_cd
		AND F4202.report_kind		=	S.report_kind
		AND F4202.report_no			=	S.report_no		
		)
		LEFT OUTER JOIN M4126 ON (
			F4202.company_cd		=	M4126.company_cd
		AND F4202.question_no		=	M4126.question_no
		AND F4202.answer_select		=	M4126.detail_no
		AND M4126.del_datetime IS NULL
		)
		WHERE 
			F4202.company_cd		=	@P_company_cd
		AND F4202.del_datetime IS NULL
		AND (F4202.answer_sentence LIKE '%'+@P_key_search+'%' OR M4126.detail_name LIKE '%'+@P_key_search+'%')
		GROUP BY
			F4202.company_cd
		,	F4202.fiscal_year
		,	F4202.employee_cd
		,	F4202.report_kind
		,	F4202.report_no
		--if @P_key_search is number

		IF ISNUMERIC(@P_key_search) = 1
		BEGIN
		INSERT INTO #TABLE_F4202_TEMP
		SELECT 
			F4202.company_cd	
		,	F4202.fiscal_year	
		,	F4202.employee_cd	
		,	F4202.report_kind	
		,	F4202.report_no	
		FROM F4202
		INNER JOIN #TABLE_RESULT AS S ON (
			F4202.company_cd		=	S.company_cd
		AND F4202.fiscal_year		=	S.fiscal_year
		AND F4202.employee_cd		=	S.employee_cd
		AND F4202.report_kind		=	S.report_kind
		AND F4202.report_no			=	S.report_no		
		)
		LEFT OUTER JOIN M4126 ON (
			F4202.company_cd		=	M4126.company_cd
		AND F4202.question_no		=	M4126.question_no
		AND M4126.del_datetime IS NULL
		) LEFT OUTER JOIN #TABLE_F4202_TEMP ON(
			F4202.company_cd	=	#TABLE_F4202_TEMP.company_cd
		AND F4202.fiscal_year	=	#TABLE_F4202_TEMP.fiscal_year
		AND F4202.employee_cd	=	#TABLE_F4202_TEMP.employee_cd
		AND F4202.report_kind	=	#TABLE_F4202_TEMP.report_kind
		AND F4202.report_no		=	#TABLE_F4202_TEMP.report_no
		)
		WHERE 
			F4202.company_cd				=	@P_company_cd
		AND F4202.del_datetime				IS NULL
		AND F4202.answer_number				= CONVERT(numeric(3,1),LEFT(@P_key_search,2))
		AND #TABLE_F4202_TEMP.company_cd	IS NULL
		GROUP BY
			F4202.company_cd
		,	F4202.fiscal_year
		,	F4202.employee_cd
		,	F4202.report_kind
		,	F4202.report_no
		END
		
		-------
		INSERT INTO #TABLE_F4202_TEMP
		SELECT 
			F4202.company_cd	
		,	F4202.fiscal_year	
		,	F4202.employee_cd	
		,	F4202.report_kind	
		,	F4202.report_no	
		FROM F4202
		INNER JOIN #TABLE_RESULT AS S ON (
			F4202.company_cd		=	S.company_cd
		AND F4202.fiscal_year		=	S.fiscal_year
		AND F4202.employee_cd		=	S.employee_cd
		AND F4202.report_kind		=	S.report_kind
		AND F4202.report_no			=	S.report_no		
		)
		LEFT OUTER JOIN M4126 ON (
			F4202.company_cd		=	M4126.company_cd
		AND F4202.question_no		=	M4126.question_no
		AND M4126.del_datetime IS NULL
		)
		LEFT OUTER JOIN (
			SELECT 
				F4204.company_cd			AS	company_cd	
			,	F4204.fiscal_year			AS	fiscal_year	
			,	F4204.employee_cd			AS	employee_cd	
			,	F4204.report_kind			AS	report_kind	
			,	F4204.report_no				AS	report_no	
			,	ISNULL(F4204.comment,'')	AS	comment
			FROM F4204
			WHERE 
				F4204.company_cd		=	@P_company_cd
			AND F4204.del_datetime IS NULL
			AND F4204.comment LIKE '%'+ @P_key_search +'%'
			GROUP BY
				F4204.company_cd	
			,	F4204.fiscal_year	
			,	F4204.employee_cd	
			,	F4204.report_kind	
			,	F4204.report_no		
			,	F4204.comment
		) AS F4204_TMP ON (
			F4202.company_cd		=	F4204_TMP.company_cd
		AND F4202.fiscal_year		=	F4204_TMP.fiscal_year
		AND F4202.employee_cd		=	F4204_TMP.employee_cd
		AND F4202.report_kind		=	F4204_TMP.report_kind
		AND F4202.report_no			=	F4204_TMP.report_no
		) LEFT OUTER JOIN #TABLE_F4202_TEMP ON(
			F4202.company_cd	=	#TABLE_F4202_TEMP.company_cd
		AND F4202.fiscal_year	=	#TABLE_F4202_TEMP.fiscal_year
		AND F4202.employee_cd	=	#TABLE_F4202_TEMP.employee_cd
		AND F4202.report_kind	=	#TABLE_F4202_TEMP.report_kind
		AND F4202.report_no		=	#TABLE_F4202_TEMP.report_no
		)
		WHERE 
			F4202.company_cd		=	@P_company_cd
		AND	ISNULL(F4204_TMP.comment,'') LIKE '%'+ @P_key_search+'%'
		AND #TABLE_F4202_TEMP.company_cd IS NULL
		AND F4202.del_datetime IS NULL
		GROUP BY
			F4202.company_cd
		,	F4202.fiscal_year
		,	F4202.employee_cd
		,	F4202.report_kind
		,	F4202.report_no
		
		-- DELETE #TABLE_RESULT
		DELETE D FROM #TABLE_RESULT AS D
		LEFT OUTER JOIN #TABLE_F4202_TEMP AS S ON (
			D.company_cd				=	S.company_cd
		AND D.fiscal_year				=	S.fiscal_year
		AND	D.employee_cd				=	S.employee_cd
		AND D.report_kind				=	S.report_kind
		AND D.report_no					=	S.report_no
		)
		WHERE 
			S.company_cd IS NULL
	END
		
	-- FILTER @P_is_shared
	IF @P_is_shared > 0
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D
		WHERE 
			D.sharewith_status = 0
	END
	-- FILTER BY #TABLE_ORGANIZATION
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
		ELSE IF NOT (@w_report_authority_typ = 3 AND @w_evaluation_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)
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
			AND @w_report_authority_typ NOT IN(4,5)		--4.会社管理者 5.総合管理者
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
		IF @w_report_authority_typ NOT IN (4,5)
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
	
	-- FILTER #TABLE_REPOTERS_CAN_VIEW
	IF @w_report_authority_typ NOT IN (3,4,5)
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D
		LEFT OUTER JOIN #TABLE_REPOTERS_RQ2010 AS S ON (
			D.company_cd	=	S.company_cd
		AND D.fiscal_year	=	S.fiscal_year
		AND D.employee_cd	=	S.employee_cd
		)
		WHERE 
			S.employee_cd IS NULL
	END
	
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- GET #TABLE_F4206_TEMP
	IF @w_report_authority_typ IN (3,4,5)
	BEGIN
		INSERT INTO #TABLE_F4206_TEMP
		SELECT 
			F4206.company_cd		
		,	F4206.fiscal_year		
		,	F4206.employee_cd	
		,	F4206.report_kind		
		,	F4206.report_no		
		,	F4206.note_employee_cd
		,	ISNULL(M0070.employee_nm,'')
		,	F4206.note_kind		
		,	F4206.note_no	
		,	ISNULL(M4101.note_color,0)	AS	note_color
		,	ISNULL(L0010_47.name,'')	AS	note_color_nm
		,	ISNULL(M4101.note_name,'')	AS	note_name
		FROM #TABLE_RESULT
		LEFT OUTER JOIN F4206 ON (
			#TABLE_RESULT.company_cd			=	F4206.company_cd
		AND #TABLE_RESULT.fiscal_year			=	F4206.fiscal_year
		AND #TABLE_RESULT.employee_cd			=	F4206.employee_cd
		AND #TABLE_RESULT.report_kind			=	F4206.report_kind
		AND #TABLE_RESULT.report_no				=	F4206.report_no
		AND F4206.del_datetime IS NULL	
		)
		LEFT OUTER JOIN M0070 ON (
			F4206.company_cd			=	M0070.company_cd
		AND F4206.note_employee_cd		=	M0070.employee_cd
		AND M0070.del_datetime IS NULL
		)
		LEFT OUTER JOIN M4101 ON (
			F4206.company_cd			=	M4101.company_cd
		AND F4206.note_kind				=	M4101.note_kind
		AND F4206.note_no				=	M4101.detail_no
		AND M4101.del_datetime IS NULL
		)
		LEFT OUTER JOIN L0010 AS L0010_47 ON (
			47						=	L0010_47.name_typ
		AND	M4101.note_color		=	L0010_47.number_cd
		AND L0010_47.del_datetime IS NULL
		)
		WHERE 
			F4206.company_cd		=	@P_company_cd
		AND F4206.note_kind			=	1		-- ログインユーザー=報告者以外の場合は、M4101.note_kind=1の付箋を表示する
	END
	ELSE 
	BEGIN
		INSERT INTO #TABLE_F4206_TEMP
		SELECT 
			F4206.company_cd		
		,	F4206.fiscal_year		
		,	F4206.employee_cd		
		,	F4206.report_kind		
		,	F4206.report_no		
		,	F4206.note_employee_cd
		,	ISNULL(M0070.employee_nm,'')
		,	F4206.note_kind		
		,	F4206.note_no			
		,	ISNULL(M4101.note_color,0)	AS	note_color
		,	ISNULL(L0010_47.name,'')	AS	note_color_nm
		,	ISNULL(M4101.note_name,'')	AS	note_name
		FROM #TABLE_RESULT
		LEFT OUTER JOIN F4206 ON (
			#TABLE_RESULT.company_cd			=	F4206.company_cd
		AND #TABLE_RESULT.fiscal_year			=	F4206.fiscal_year
		AND #TABLE_RESULT.employee_cd			=	F4206.employee_cd
		AND #TABLE_RESULT.report_kind			=	F4206.report_kind
		AND #TABLE_RESULT.report_no				=	F4206.report_no
		AND F4206.del_datetime IS NULL	
		)
		LEFT OUTER JOIN M0070 ON (
			F4206.company_cd			=	M0070.company_cd
		AND F4206.note_employee_cd		=	M0070.employee_cd
		AND M0070.del_datetime IS NULL
		)
		LEFT OUTER JOIN M4101 ON (
			F4206.company_cd			=	M4101.company_cd
		AND F4206.note_kind				=	M4101.note_kind
		AND F4206.note_no				=	M4101.detail_no
		AND M4101.del_datetime IS NULL
		)
		LEFT OUTER JOIN L0010 AS L0010_47 ON (
			47						=	L0010_47.name_typ
		AND	M4101.note_color		=	L0010_47.number_cd
		AND L0010_47.del_datetime IS NULL
		)
		WHERE 
			F4206.company_cd		=	@P_company_cd
		AND F4206.note_employee_cd	=	@P_login_employee_cd
		AND F4206.del_datetime IS NULL
	END

	-- GET #TABLE_F4206_TEMP_JSON
	INSERT INTO #TABLE_F4206_TEMP_JSON
	SELECT 
		#TABLE_RESULT.company_cd		
	,	#TABLE_RESULT.fiscal_year		
	,	#TABLE_RESULT.employee_cd		
	,	#TABLE_RESULT.report_kind		
	,	#TABLE_RESULT.report_no		
	,	(
		SELECT 
			#TABLE_F4206_TEMP.note_employee_cd	AS	"note_employee_cd"
		,	#TABLE_F4206_TEMP.note_employee_nm	AS	"note_employee_nm"
		,	#TABLE_F4206_TEMP.note_no			AS	"note_no"
		,	#TABLE_F4206_TEMP.note_kind			AS	"note_kind"
		,	#TABLE_F4206_TEMP.note_color		AS	"note_color"
		,	#TABLE_F4206_TEMP.note_color_nm		AS	"note_color_nm"
		,	#TABLE_F4206_TEMP.note_name			AS	"note_name"
		FROM #TABLE_F4206_TEMP
		WHERE 
			#TABLE_F4206_TEMP.company_cd	=	#TABLE_RESULT.company_cd
		AND #TABLE_F4206_TEMP.fiscal_year	=	#TABLE_RESULT.fiscal_year
		AND #TABLE_F4206_TEMP.employee_cd	=	#TABLE_RESULT.employee_cd
		AND #TABLE_F4206_TEMP.report_kind	=	#TABLE_RESULT.report_kind
		AND #TABLE_F4206_TEMP.report_no		=	#TABLE_RESULT.report_no
		FOR JSON PATH
	)
	FROM #TABLE_RESULT
	--
	IF @P_mode = 0 -- SEARCH 
	BEGIN
		SET @w_totalRecord = (SELECT COUNT(1) FROM #TABLE_RESULT)
		SET @w_pageMax = CEILING(CAST(@w_totalRecord AS FLOAT) / @P_page_size)
		IF @w_pageMax = 0
		BEGIN
			SET @w_pageMax = 1
		END
		IF @P_page > @w_pageMax
		BEGIN
			SET @P_page = @w_pageMax
		END
		--[0]
		SELECT 
			#TABLE_RESULT.id								AS	id_checkbox
		,	ISNULL(#TABLE_RESULT.company_cd,0)				AS	company_cd
		,	ISNULL(#TABLE_RESULT.fiscal_year,0)				AS	fiscal_year
		,	ISNULL(#TABLE_RESULT.employee_cd,'')			AS	employee_cd
		,	ISNULL(#TABLE_RESULT.report_kind,0)				AS	report_kind
		,	ISNULL(#TABLE_RESULT.report_no,0)				AS	report_no
		,	ISNULL(#M0070H.employee_nm,'')					AS	employee_nm
		,	ISNULL(#M0070H.belong_nm_1,'')					AS	organization_nm1
		,	ISNULL(#M0070H.belong_nm_2,'')					AS	organization_nm2
		,	ISNULL(#M0070H.belong_nm_3,'')					AS	organization_nm3
		,	ISNULL(#M0070H.belong_nm_4,'')					AS	organization_nm4
		,	ISNULL(#M0070H.belong_nm_5,'')					AS	organization_nm5
		,	ISNULL(#M0070H.position_nm,'')					AS	position_nm
		,	ISNULL(#M0070H.job_nm,'')						AS	job_nm
		--↓2023/07/25 fixed
		--,	ISNULL(#M0070H.grade_nm,'')						AS	grade_nm
		,	CASE WHEN @w_company_attribute=3 THEN '' ELSE ISNULL(#M0070H.grade_nm,'') END AS grade_nm
		--↑2023/07/25 fixed
		,	ISNULL(#M0070H.employee_typ_nm,'')				AS	employee_typ_nm
		,	CASE 
				WHEN ISNULL(F4200.title,'') <> ''
				THEN ISNULL(F4200.title,'')			
				ELSE CAST(ISNULL(F4200.times,0) AS NVARCHAR(2)) + IIF(@w_language = 2, 'Times', '回')
			END												AS	title	-- タイトル
		,	ISNULL(F4200.status_cd,0)						AS	status_cd
		,	CASE 
				WHEN @w_language = 2
				THEN ISNULL(L0041.status_nm2,'')
				ELSE ISNULL(L0041.status_nm,'')
			END												AS	status_nm
		,	ISNULL(F4201.adequacy_kbn,0)					AS	adequacy_kbn
		,	ISNULL(F4201.busyness_kbn,0)					AS	busyness_kbn
		,	ISNULL(F4201.other_kbn,0)						AS	other_kbn
		--,	CASE 
		--		WHEN F4201_tr.free_comment IS NOT NULL		
		--		THEN ISNULL(F4201_tr.free_comment,'')
		--		ELSE ISNULL(F4201.free_comment,'')
		--	END												AS	free_comment
		,	ISNULL(F4201.free_comment,'')					AS	free_comment
		,	ISNULL(#TABLE_RESULT.can_linked,0)				AS	can_linked
		,	ISNULL(#TABLE_F4206_TEMP_JSON.note_json,'')		AS	note_json
		,	#TABLE_RESULT.checkbox_is_show					AS	checkbox_is_show
		FROM #TABLE_RESULT
		LEFT OUTER JOIN #M0070H ON (
			@P_company_cd						=	#M0070H.company_cd
		AND #TABLE_RESULT.employee_cd			=	#M0070H.employee_cd
		)
		LEFT OUTER JOIN F4200 ON (
			#TABLE_RESULT.company_cd			=	F4200.company_cd
		AND #TABLE_RESULT.fiscal_year			=	F4200.fiscal_year
		AND #TABLE_RESULT.employee_cd			=	F4200.employee_cd
		AND #TABLE_RESULT.report_kind			=	F4200.report_kind
		AND #TABLE_RESULT.report_no				=	F4200.report_no
		AND F4200.del_datetime IS NULL
		)
		LEFT OUTER JOIN F4201 ON (
			#TABLE_RESULT.company_cd			=	F4201.company_cd
		AND #TABLE_RESULT.fiscal_year			=	F4201.fiscal_year
		AND #TABLE_RESULT.employee_cd			=	F4201.employee_cd
		AND #TABLE_RESULT.report_kind			=	F4201.report_kind
		AND #TABLE_RESULT.report_no				=	F4201.report_no
		AND F4201.del_datetime IS NULL
		)
		--LEFT OUTER JOIN F4201_tr ON (
		--	#TABLE_RESULT.company_cd			=	F4201_tr.company_cd
		--AND #TABLE_RESULT.fiscal_year			=	F4201_tr.fiscal_year
		--AND #TABLE_RESULT.employee_cd			=	F4201_tr.employee_cd
		--AND #TABLE_RESULT.report_kind			=	F4201_tr.report_kind
		--AND #TABLE_RESULT.report_no				=	F4201_tr.report_no
		--AND @P_cre_user							=	F4201_tr.trans_user
		--AND F4201_tr.del_datetime IS NULL
		--)
		LEFT OUTER JOIN L0041 ON (
			F4200.status_cd					=	L0041.status_cd
		AND L0041.del_datetime IS NULL
		)
		LEFT OUTER JOIN #TABLE_F4206_TEMP_JSON ON (
			#TABLE_RESULT.company_cd			=	#TABLE_F4206_TEMP_JSON.company_cd
		AND #TABLE_RESULT.fiscal_year			=	#TABLE_F4206_TEMP_JSON.fiscal_year
		AND #TABLE_RESULT.employee_cd			=	#TABLE_F4206_TEMP_JSON.employee_cd
		AND #TABLE_RESULT.report_kind			=	#TABLE_F4206_TEMP_JSON.report_kind
		AND #TABLE_RESULT.report_no				=	#TABLE_F4206_TEMP_JSON.report_no
		)
		WHERE
			#TABLE_RESULT.employee_cd LIKE '%'+@P_reporter_cd+'%'
		ORDER BY 
			RIGHT(SPACE(10)+#TABLE_RESULT.employee_cd,10)	
		,	F4200.fiscal_year
		,	F4200.year
		,	F4200.month
		,	F4200.times
		offset (@P_page-1) * @P_page_size ROWS
		FETCH NEXT @P_page_size ROWS only

		--[1]
		SELECT	
			@w_totalRecord						AS totalRecord
		,	@w_pageMax							AS pageMax
		,	@P_page								AS [page]
		,	@P_page_size						AS pagesize
		,	((@P_page - 1) * @P_page_size + 1)	AS offset
	END
	-- MODE CSV
	IF @P_mode = 1
	BEGIN
		INSERT INTO  #TABLE_QUESTION_ANSWER
		SELECT
			#TABLE_RESULT.company_cd				
		,	#TABLE_RESULT.fiscal_year				
		,	#TABLE_RESULT.employee_cd				
		,	#TABLE_RESULT.report_kind				
		,	#TABLE_RESULT.report_no				
		,	ISNULL(M4201.sheet_detail_no,0)			
		,	ISNULL(M4125.question_no,0)				
		,	ISNULL(M4201.question,'')		
		,	CASE 
				WHEN M4125.answer_kind = 1 THEN
					CASE 
						WHEN F4202_tr.answer_sentence IS NOT NULL THEN ISNULL(F4202_tr.answer_sentence,'')
						WHEN F4202_tr_blank.answer_sentence IS NOT NULL  THEN ISNULL(F4202_tr_blank.answer_sentence,'')
						ELSE ISNULL(F4202.answer_sentence,'')
					END
				WHEN M4125.answer_kind = 2  THEN CAST(ISNULL(F4202.answer_number,0) AS NVARCHAR(400))
				ELSE ISNULL(M4126.detail_name,'')	
			END
		FROM #TABLE_RESULT 
		LEFT JOIN M4201 ON(
			#TABLE_RESULT.company_cd		= M4201.company_cd									
		AND	#TABLE_RESULT.report_kind		= M4201.report_kind		
		AND	#TABLE_RESULT.sheet_cd			= M4201.sheet_cd
		AND	#TABLE_RESULT.adaption_date		= M4201.adaption_date
		AND M4201.del_datetime IS NULL
		) 
		
		LEFT JOIN F4202 ON(
			#TABLE_RESULT.company_cd		= F4202.company_cd		
		AND	#TABLE_RESULT.fiscal_year		= F4202.fiscal_year		
		AND	#TABLE_RESULT.employee_cd		= F4202.employee_cd		
		AND	#TABLE_RESULT.report_kind		= F4202.report_kind		
		AND	#TABLE_RESULT.report_no			= F4202.report_no		
		AND	M4201.question_no				= F4202.question_no
		) 
		LEFT JOIN F4202_tr ON(
			#TABLE_RESULT.company_cd		= F4202_tr.company_cd		
		AND	#TABLE_RESULT.fiscal_year		= F4202_tr.fiscal_year		
		AND	#TABLE_RESULT.employee_cd		= F4202_tr.employee_cd		
		AND	#TABLE_RESULT.report_kind		= F4202_tr.report_kind		
		AND	#TABLE_RESULT.report_no			= F4202_tr.report_no		
		AND	M4201.question_no				= F4202_tr.question_no
		AND @P_cre_user						= F4202_tr.trans_user
		) 
		LEFT JOIN F4202_tr AS F4202_tr_blank ON(
			#TABLE_RESULT.company_cd		= F4202_tr_blank.company_cd		
		AND	#TABLE_RESULT.fiscal_year		= F4202_tr_blank.fiscal_year		
		AND	#TABLE_RESULT.employee_cd		= F4202_tr_blank.employee_cd		
		AND	#TABLE_RESULT.report_kind		= F4202_tr_blank.report_kind		
		AND	#TABLE_RESULT.report_no			= F4202_tr_blank.report_no		
		AND	M4201.question_no				= F4202_tr_blank.question_no
		AND ''								= F4202_tr_blank.trans_user
		) 
		LEFT JOIN M4125 ON(
			F4202.company_cd		= M4125.company_cd										
		AND	F4202.question_no			= M4125.question_no
		AND M4125.del_datetime IS NULL
		) 
		LEFT JOIN M4126 ON(
			F4202.company_cd				= M4126.company_cd		
		AND	F4202.question_no				= M4126.question_no
		AND	F4202.answer_select				= M4126.detail_no
		AND M4126.del_datetime				IS NULL
		)
	
		INSERT INTO #TABLE_QUESTION
		SELECT
			A.company_cd				
		,	A.fiscal_year				
		,	A.employee_cd				
		,	A.report_kind				
		,	Q_1.report_no
		,	Q_1.question_no
		,	Q_1.question_content
		,	Q_1.question_answer
		,	Q_2.question_no
		,	Q_2.question_content
		,	Q_2.question_answer
		,	Q_3.question_no
		,	Q_3.question_content
		,	Q_3.question_answer
		,	Q_4.question_no
		,	Q_4.question_content
		,	Q_4.question_answer
		,	Q_5.question_no
		,	Q_5.question_content
		,	Q_5.question_answer
		,	Q_6.question_no
		,	Q_6.question_content
		,	Q_6.question_answer
		,	Q_7.question_no
		,	Q_7.question_content
		,	Q_7.question_answer
		,	Q_8.question_no
		,	Q_8.question_content
		,	Q_8.question_answer
		,	Q_9.question_no
		,	Q_9.question_content
		,	Q_9.question_answer
		,	Q_10.question_no
		,	Q_10.question_content
		,	Q_10.question_answer
		FROM #TABLE_RESULT AS A
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_1 ON(
			A.company_cd	= Q_1.company_cd
		AND A.fiscal_year	= Q_1.fiscal_year
		AND A.employee_cd	= Q_1.employee_cd
		AND A.report_kind	= Q_1.report_kind
		AND A.report_no		= Q_1.report_no
		AND Q_1.sheet_detail_no	= 1
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_2 ON(
			A.company_cd	= Q_2.company_cd
		AND A.fiscal_year	= Q_2.fiscal_year
		AND A.employee_cd	= Q_2.employee_cd
		AND A.report_kind	= Q_2.report_kind
		AND A.report_no		= Q_2.report_no
		AND Q_2.sheet_detail_no	= 2
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_3 ON(
			A.company_cd	= Q_3.company_cd
		AND A.fiscal_year	= Q_3.fiscal_year
		AND A.employee_cd	= Q_3.employee_cd
		AND A.report_kind	= Q_3.report_kind
		AND A.report_no		= Q_3.report_no
		AND Q_3.sheet_detail_no	= 3
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_4 ON(
			A.company_cd	= Q_4.company_cd
		AND A.fiscal_year	= Q_4.fiscal_year
		AND A.employee_cd	= Q_4.employee_cd
		AND A.report_kind	= Q_4.report_kind
		AND A.report_no		= Q_4.report_no
		AND Q_4.sheet_detail_no	= 4
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_5 ON(
			A.company_cd	= Q_5.company_cd
		AND A.fiscal_year	= Q_5.fiscal_year
		AND A.employee_cd	= Q_5.employee_cd
		AND A.report_kind	= Q_5.report_kind
		AND A.report_no		= Q_5.report_no
		AND Q_5.sheet_detail_no	= 5
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_6 ON(
			A.company_cd	= Q_6.company_cd
		AND A.fiscal_year	= Q_6.fiscal_year
		AND A.employee_cd	= Q_6.employee_cd
		AND A.report_kind	= Q_6.report_kind
		AND A.report_no		= Q_6.report_no
		AND Q_6.sheet_detail_no	= 6
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_7 ON(
			A.company_cd	= Q_7.company_cd
		AND A.fiscal_year	= Q_7.fiscal_year
		AND A.employee_cd	= Q_7.employee_cd
		AND A.report_kind	= Q_7.report_kind
		AND A.report_no		= Q_7.report_no
		AND Q_7.sheet_detail_no	= 7
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_8 ON(
			A.company_cd	= Q_8.company_cd
		AND A.fiscal_year	= Q_8.fiscal_year
		AND A.employee_cd	= Q_8.employee_cd
		AND A.report_kind	= Q_8.report_kind
		AND A.report_no		= Q_8.report_no
		AND Q_8.sheet_detail_no	= 8
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_9 ON(
			A.company_cd	= Q_9.company_cd
		AND A.fiscal_year	= Q_9.fiscal_year
		AND A.employee_cd	= Q_9.employee_cd
		AND A.report_kind	= Q_9.report_kind
		AND A.report_no		= Q_9.report_no
		AND Q_9.sheet_detail_no	= 9
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_10 ON(
			A.company_cd	= Q_10.company_cd
		AND A.fiscal_year	= Q_10.fiscal_year
		AND A.employee_cd	= Q_10.employee_cd
		AND A.report_kind	= Q_10.report_kind
		AND A.report_no		= Q_10.report_no
		AND Q_10.sheet_detail_no	= 10
		)

		IF @P_count_org <= 1
		BEGIN
			SELECT 
				ISNULL(#TABLE_RESULT.fiscal_year,0)				AS	fiscal_year			-- 年度
			,	ISNULL(#TABLE_RESULT.report_kind,0)				AS	report_kind			-- 報告書種類
			,	ISNULL(#TABLE_RESULT.report_no,0)				AS	report_no			-- 報告番号
			,	ISNULL(#TABLE_RESULT.employee_cd,'')			AS	employee_cd			-- 社員番号
			,	ISNULL(#M0070H.employee_nm,'')					AS	employee_nm			-- 社員名
			,	ISNULL(#M0070H.belong_nm_1,'')					AS	organization_nm1	-- 組織1
			,	ISNULL(#M0070H.position_nm,'')					AS	position_nm			-- 役職
			,	ISNULL(#M0070H.job_nm,'')						AS	job_nm				-- 職種
			--↓2023/07/25 fixed
			--,	ISNULL(#M0070H.grade_nm,'')						AS	grade_nm			-- 等級
			,	CASE WHEN @w_company_attribute=3 THEN '' ELSE ISNULL(#M0070H.grade_nm,'') END AS grade_nm
			--↑2023/07/25 fixed
			,	ISNULL(#M0070H.employee_typ_nm,'')				AS	employee_typ_nm		-- 社員区分
			,	CASE 
					WHEN ISNULL(F4200.title,'') <> ''
					THEN ISNULL(F4200.title,'')			
					ELSE CAST(ISNULL(F4200.times,0) AS NVARCHAR(2)) + IIF(@w_language = 2, 'Times', '回')
				END												AS	title	-- タイトル
			,	CASE 
					WHEN @w_language = 2
					THEN ISNULL(L0041.status_nm2,'')
					ELSE ISNULL(L0041.status_nm,'')
				END																	AS	status_nm			-- 状態
			,	ISNULL(F4201.adequacy_kbn,0)										AS	adequacy_kbn		-- 充実度
			,	ISNULL(F4201.busyness_kbn,0)										AS	busyness_kbn		-- 繁忙度
			,	ISNULL(F4201.other_kbn,0)											AS	other_kbn			-- その他
			,	replace(replace(#TABLE_QUESTION.question_content_1, char(13), ' '), char(10), ' ') AS question_content_1  
			,	replace(replace(#TABLE_QUESTION.question_answer_1, char(13), ' '), char(10), ' ')  AS question_answer_1 	
			,	replace(replace(#TABLE_QUESTION.question_content_2, char(13), ' '), char(10), ' ') AS question_content_2	
			,	replace(replace(#TABLE_QUESTION.question_answer_2, char(13), ' '), char(10), ' ')  AS question_answer_2	
			,	replace(replace(#TABLE_QUESTION.question_content_3, char(13), ' '), char(10), ' ') AS question_content_3	
			,	replace(replace(#TABLE_QUESTION.question_answer_3, char(13), ' '), char(10), ' ')  AS question_answer_3	
			,	replace(replace(#TABLE_QUESTION.question_content_4, char(13), ' '), char(10), ' ') AS question_content_4	
			,	replace(replace(#TABLE_QUESTION.question_answer_4, char(13), ' '), char(10), ' ')  AS question_answer_4	
			,	replace(replace(#TABLE_QUESTION.question_content_5, char(13), ' '), char(10), ' ') AS question_content_5	
			,	replace(replace(#TABLE_QUESTION.question_answer_5, char(13), ' '), char(10), ' ')  AS question_answer_5	
			,	replace(replace(#TABLE_QUESTION.question_content_6, char(13), ' '), char(10), ' ') AS question_content_6	
			,	replace(replace(#TABLE_QUESTION.question_answer_6, char(13), ' '), char(10), ' ')  AS question_answer_6	
			,	replace(replace(#TABLE_QUESTION.question_content_7, char(13), ' '), char(10), ' ') AS question_content_7	
			,	replace(replace(#TABLE_QUESTION.question_answer_7, char(13), ' '), char(10), ' ')  AS question_answer_7	
			,	replace(replace(#TABLE_QUESTION.question_content_8, char(13), ' '), char(10), ' ') AS question_content_8	
			,	replace(replace(#TABLE_QUESTION.question_answer_8, char(13), ' '), char(10), ' ')  AS question_answer_8	
			,	replace(replace(#TABLE_QUESTION.question_content_9, char(13), ' '), char(10), ' ') AS question_content_9	
			,	replace(replace(#TABLE_QUESTION.question_answer_9, char(13), ' '), char(10), ' ')  AS question_answer_9	
			,	replace(replace(#TABLE_QUESTION.question_content_10, char(13), ' '), char(10), ' ') AS question_content_10	
			,	replace(replace(#TABLE_QUESTION.question_answer_10, char(13), ' '), char(10), ' ') AS question_answer_10
			,	CASE 
					WHEN F4201_tr.free_comment IS NOT NULL		
					THEN replace(replace(F4201_tr.free_comment, char(13), ' '), char(10), ' ')
					WHEN F4201_tr_blank.free_comment IS NOT NULL		
					THEN replace(replace(F4201_tr_blank.free_comment, char(13), ' '), char(10), ' ')
					ELSE replace(replace(F4201.free_comment, char(13), ' '), char(10), ' ')
				END																	AS	free_comment		-- 自由記入欄
			,	ISNULL(#TABLE_F4206_TEMP_JSON.note_json,'')							AS	note_json			-- 付箋
			
			FROM #TABLE_RESULT
			LEFT OUTER JOIN #M0070H ON (
				@P_company_cd						=	#M0070H.company_cd
			AND #TABLE_RESULT.employee_cd			=	#M0070H.employee_cd
			)
			LEFT OUTER JOIN F4200 ON (
				#TABLE_RESULT.company_cd			=	F4200.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4200.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4200.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4200.report_kind
			AND #TABLE_RESULT.report_no				=	F4200.report_no
			AND F4200.del_datetime IS NULL
			)
			LEFT OUTER JOIN F4201 ON (
				#TABLE_RESULT.company_cd			=	F4201.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4201.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4201.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4201.report_kind
			AND #TABLE_RESULT.report_no				=	F4201.report_no
			AND F4201.del_datetime IS NULL
			)
			LEFT OUTER JOIN F4201_tr ON (
				#TABLE_RESULT.company_cd			=	F4201_tr.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4201_tr.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4201_tr.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4201_tr.report_kind
			AND #TABLE_RESULT.report_no				=	F4201_tr.report_no
			AND @P_cre_user							=	F4201_tr.trans_user
			AND F4201_tr.del_datetime IS NULL
			)
		    LEFT OUTER JOIN F4201_tr AS F4201_tr_blank ON (
				#TABLE_RESULT.company_cd			=	F4201_tr_blank.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4201_tr_blank.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4201_tr_blank.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4201_tr_blank.report_kind
			AND #TABLE_RESULT.report_no				=	F4201_tr_blank.report_no
			AND ''									=	F4201_tr_blank.trans_user
			AND F4201_tr_blank.del_datetime IS NULL
			)
			LEFT OUTER JOIN L0041 ON (
				F4200.status_cd					=	L0041.status_cd
			AND L0041.del_datetime IS NULL
			) LEFT OUTER JOIN #TABLE_F4206_TEMP_JSON ON (
				#TABLE_RESULT.company_cd			=	#TABLE_F4206_TEMP_JSON.company_cd
			AND #TABLE_RESULT.fiscal_year			=	#TABLE_F4206_TEMP_JSON.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	#TABLE_F4206_TEMP_JSON.employee_cd
			AND #TABLE_RESULT.report_kind			=	#TABLE_F4206_TEMP_JSON.report_kind
			AND #TABLE_RESULT.report_no				=	#TABLE_F4206_TEMP_JSON.report_no)
			LEFT OUTER JOIN #TABLE_QUESTION ON(
				#TABLE_RESULT.company_cd			=	#TABLE_QUESTION.company_cd
			AND #TABLE_RESULT.fiscal_year			=	#TABLE_QUESTION.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	#TABLE_QUESTION.employee_cd
			AND #TABLE_RESULT.report_kind			=	#TABLE_QUESTION.report_kind
			AND #TABLE_RESULT.report_no				=	#TABLE_QUESTION.report_no
			)
			WHERE
				#TABLE_RESULT.employee_cd LIKE '%'+@P_reporter_cd+'%'
			ORDER BY 
				RIGHT(SPACE(10)+#TABLE_RESULT.employee_cd,10)
			,	#TABLE_RESULT.report_kind
			,	#TABLE_RESULT.report_no
		END
		ELSE IF @P_count_org = 2
		BEGIN
			SELECT 
				ISNULL(#TABLE_RESULT.fiscal_year,0)				AS	fiscal_year			-- 年度
			,	ISNULL(#TABLE_RESULT.report_kind,0)				AS	report_kind			-- 報告書種類
			,	ISNULL(#TABLE_RESULT.report_no,0)				AS	report_no			-- 報告番号
			,	ISNULL(#TABLE_RESULT.employee_cd,'')			AS	employee_cd			-- 社員番号
			,	ISNULL(#M0070H.employee_nm,'')					AS	employee_nm			-- 社員名
			,	ISNULL(#M0070H.belong_nm_1,'')					AS	organization_nm1	-- 組織1
			,	ISNULL(#M0070H.belong_nm_2,'')					AS	organization_nm2	-- 組織2
			,	ISNULL(#M0070H.position_nm,'')					AS	position_nm			-- 役職
			,	ISNULL(#M0070H.job_nm,'')						AS	job_nm				-- 職種
			--↓2023/07/25 fixed
			--,	ISNULL(#M0070H.grade_nm,'')						AS	grade_nm			-- 等級
			,	CASE WHEN @w_company_attribute=3 THEN '' ELSE ISNULL(#M0070H.grade_nm,'') END AS grade_nm
			--↑2023/07/25 fixed
			,	ISNULL(#M0070H.employee_typ_nm,'')				AS	employee_typ_nm		-- 社員区分
			,	CASE 
					WHEN ISNULL(F4200.title,'') <> ''
					THEN ISNULL(F4200.title,'')			
					ELSE CAST(ISNULL(F4200.times,0) AS NVARCHAR(2)) + IIF(@w_language = 2, 'Times', '回')
				END												AS	title	-- タイトル
			,	CASE 
					WHEN @w_language = 2
					THEN ISNULL(L0041.status_nm2,'')
					ELSE ISNULL(L0041.status_nm,'')
				END																	AS	status_nm			-- 状態
			,	ISNULL(F4201.adequacy_kbn,0)										AS	adequacy_kbn		-- 充実度
			,	ISNULL(F4201.busyness_kbn,0)										AS	busyness_kbn		-- 繁忙度
			,	ISNULL(F4201.other_kbn,0)											AS	other_kbn			-- その他
			,	replace(replace(#TABLE_QUESTION.question_content_1 	, char(13), ' '), char(10), ' ')  AS question_content_1  
			,	replace(replace(#TABLE_QUESTION.question_answer_1	, char(13), ' '), char(10), ' ')  AS question_answer_1 	
			,	replace(replace(#TABLE_QUESTION.question_content_2	, char(13), ' '), char(10), ' ')  AS question_content_2	
			,	replace(replace(#TABLE_QUESTION.question_answer_2	, char(13), ' '), char(10), ' ')  AS question_answer_2	
			,	replace(replace(#TABLE_QUESTION.question_content_3	, char(13), ' '), char(10), ' ')  AS question_content_3	
			,	replace(replace(#TABLE_QUESTION.question_answer_3	, char(13), ' '), char(10), ' ')  AS question_answer_3	
			,	replace(replace(#TABLE_QUESTION.question_content_4	, char(13), ' '), char(10), ' ')  AS question_content_4	
			,	replace(replace(#TABLE_QUESTION.question_answer_4	, char(13), ' '), char(10), ' ')  AS question_answer_4	
			,	replace(replace(#TABLE_QUESTION.question_content_5	, char(13), ' '), char(10), ' ')  AS question_content_5	
			,	replace(replace(#TABLE_QUESTION.question_answer_5	, char(13), ' '), char(10), ' ')  AS question_answer_5	
			,	replace(replace(#TABLE_QUESTION.question_content_6	, char(13), ' '), char(10), ' ')  AS question_content_6	
			,	replace(replace(#TABLE_QUESTION.question_answer_6	, char(13), ' '), char(10), ' ')  AS question_answer_6	
			,	replace(replace(#TABLE_QUESTION.question_content_7	, char(13), ' '), char(10), ' ')  AS question_content_7	
			,	replace(replace(#TABLE_QUESTION.question_answer_7	, char(13), ' '), char(10), ' ')  AS question_answer_7	
			,	replace(replace(#TABLE_QUESTION.question_content_8	, char(13), ' '), char(10), ' ')  AS question_content_8	
			,	replace(replace(#TABLE_QUESTION.question_answer_8	, char(13), ' '), char(10), ' ')  AS question_answer_8	
			,	replace(replace(#TABLE_QUESTION.question_content_9	, char(13), ' '), char(10), ' ')  AS question_content_9	
			,	replace(replace(#TABLE_QUESTION.question_answer_9	, char(13), ' '), char(10), ' ')  AS question_answer_9	
			,	replace(replace(#TABLE_QUESTION.question_content_10	, char(13), ' '), char(10), ' ')  AS question_content_10	
			,	replace(replace(#TABLE_QUESTION.question_answer_10, char(13), ' '), char(10), ' ')	  AS question_answer_10	
			,	CASE 
					WHEN F4201_tr.free_comment IS NOT NULL		
					THEN replace(replace(F4201_tr.free_comment, char(13), ' '), char(10), ' ')
					WHEN F4201_tr_blank.free_comment IS NOT NULL		
					THEN replace(replace(F4201_tr_blank.free_comment, char(13), ' '), char(10), ' ')
					ELSE replace(replace(F4201.free_comment, char(13), ' '), char(10), ' ')
				END																	AS	free_comment		-- 自由記入欄
			,	ISNULL(#TABLE_F4206_TEMP_JSON.note_json,'')							AS	note_json			-- 付箋
			FROM #TABLE_RESULT
			LEFT OUTER JOIN #M0070H ON (
				@P_company_cd						=	#M0070H.company_cd
			AND #TABLE_RESULT.employee_cd			=	#M0070H.employee_cd
			)
			LEFT OUTER JOIN F4200 ON (
				#TABLE_RESULT.company_cd			=	F4200.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4200.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4200.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4200.report_kind
			AND #TABLE_RESULT.report_no				=	F4200.report_no
			AND F4200.del_datetime IS NULL
			)
			LEFT OUTER JOIN F4201 ON (
				#TABLE_RESULT.company_cd			=	F4201.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4201.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4201.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4201.report_kind
			AND #TABLE_RESULT.report_no				=	F4201.report_no
			AND F4201.del_datetime IS NULL
			)
			LEFT OUTER JOIN F4201_tr ON (
				#TABLE_RESULT.company_cd			=	F4201_tr.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4201_tr.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4201_tr.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4201_tr.report_kind
			AND #TABLE_RESULT.report_no				=	F4201_tr.report_no
			AND @P_cre_user							=	F4201_tr.trans_user
			AND F4201_tr.del_datetime IS NULL
			)
			LEFT OUTER JOIN F4201_tr AS F4201_tr_blank ON (
				#TABLE_RESULT.company_cd			=	F4201_tr_blank.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4201_tr_blank.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4201_tr_blank.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4201_tr_blank.report_kind
			AND #TABLE_RESULT.report_no				=	F4201_tr_blank.report_no
			AND ''									=	F4201_tr_blank.trans_user
			AND F4201_tr_blank.del_datetime IS NULL
			)
			LEFT OUTER JOIN L0041 ON (
				F4200.status_cd					=	L0041.status_cd
			AND L0041.del_datetime IS NULL
			)
			LEFT OUTER JOIN #TABLE_F4206_TEMP_JSON ON (
				#TABLE_RESULT.company_cd			=	#TABLE_F4206_TEMP_JSON.company_cd
			AND #TABLE_RESULT.fiscal_year			=	#TABLE_F4206_TEMP_JSON.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	#TABLE_F4206_TEMP_JSON.employee_cd
			AND #TABLE_RESULT.report_kind			=	#TABLE_F4206_TEMP_JSON.report_kind
			AND #TABLE_RESULT.report_no				=	#TABLE_F4206_TEMP_JSON.report_no
			)LEFT OUTER JOIN #TABLE_QUESTION ON(
				#TABLE_RESULT.company_cd			=	#TABLE_QUESTION.company_cd
			AND #TABLE_RESULT.fiscal_year			=	#TABLE_QUESTION.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	#TABLE_QUESTION.employee_cd
			AND #TABLE_RESULT.report_kind			=	#TABLE_QUESTION.report_kind
			AND #TABLE_RESULT.report_no				=	#TABLE_QUESTION.report_no
			)
			WHERE
				#TABLE_RESULT.employee_cd LIKE '%'+@P_reporter_cd+'%'
			ORDER BY 
				RIGHT(SPACE(10)+#TABLE_RESULT.employee_cd,10)
			,	#TABLE_RESULT.report_kind
			,	#TABLE_RESULT.report_no
		END
		ELSE IF @P_count_org = 3
		BEGIN
		SELECT 
				ISNULL(#TABLE_RESULT.fiscal_year,0)				AS	fiscal_year			-- 年度
			,	ISNULL(#TABLE_RESULT.report_kind,0)				AS	report_kind			-- 報告書種類
			,	ISNULL(#TABLE_RESULT.report_no,0)				AS	report_no			-- 報告番号
			,	ISNULL(#TABLE_RESULT.employee_cd,'')			AS	employee_cd			-- 社員番号
			,	ISNULL(#M0070H.employee_nm,'')					AS	employee_nm			-- 社員名
			,	ISNULL(#M0070H.belong_nm_1,'')					AS	organization_nm1	-- 組織1
			,	ISNULL(#M0070H.belong_nm_2,'')					AS	organization_nm2	-- 組織2
			,	ISNULL(#M0070H.belong_nm_3,'')					AS	organization_nm3	-- 組織3
			,	ISNULL(#M0070H.position_nm,'')					AS	position_nm			-- 役職
			,	ISNULL(#M0070H.job_nm,'')						AS	job_nm				-- 職種
			--↓2023/07/25 fixed
			--,	ISNULL(#M0070H.grade_nm,'')						AS	grade_nm			-- 等級
			,	CASE WHEN @w_company_attribute=3 THEN '' ELSE ISNULL(#M0070H.grade_nm,'') END AS grade_nm
			--↑2023/07/25 fixed
			,	ISNULL(#M0070H.employee_typ_nm,'')				AS	employee_typ_nm		-- 社員区分
			,	CASE 
					WHEN ISNULL(F4200.title,'') <> ''
					THEN ISNULL(F4200.title,'')			
					ELSE CAST(ISNULL(F4200.times,0) AS NVARCHAR(2)) + IIF(@w_language = 2, 'Times', '回')
				END												AS	title	-- タイトル
			,	CASE 
					WHEN @w_language = 2
					THEN ISNULL(L0041.status_nm2,'')
					ELSE ISNULL(L0041.status_nm,'')
				END																	AS	status_nm			-- 状態
			,	ISNULL(F4201.adequacy_kbn,0)										AS	adequacy_kbn		-- 充実度
			,	ISNULL(F4201.busyness_kbn,0)										AS	busyness_kbn		-- 繁忙度
			,	ISNULL(F4201.other_kbn,0)											AS	other_kbn			-- その他
			,	replace(replace(#TABLE_QUESTION.question_content_1  , char(13), ' '), char(10), ' ') AS question_content_1    
			,	replace(replace(#TABLE_QUESTION.question_answer_1	, char(13), ' '), char(10), ' ') AS question_answer_1 	
			,	replace(replace(#TABLE_QUESTION.question_content_2	, char(13), ' '), char(10), ' ') AS question_content_2	
			,	replace(replace(#TABLE_QUESTION.question_answer_2	, char(13), ' '), char(10), ' ') AS question_answer_2	
			,	replace(replace(#TABLE_QUESTION.question_content_3	, char(13), ' '), char(10), ' ') AS question_content_3	
			,	replace(replace(#TABLE_QUESTION.question_answer_3	, char(13), ' '), char(10), ' ') AS question_answer_3	
			,	replace(replace(#TABLE_QUESTION.question_content_4	, char(13), ' '), char(10), ' ') AS question_content_4	
			,	replace(replace(#TABLE_QUESTION.question_answer_4	, char(13), ' '), char(10), ' ') AS question_answer_4	
			,	replace(replace(#TABLE_QUESTION.question_content_5	, char(13), ' '), char(10), ' ') AS question_content_5	
			,	replace(replace(#TABLE_QUESTION.question_answer_5	, char(13), ' '), char(10), ' ') AS question_answer_5	
			,	replace(replace(#TABLE_QUESTION.question_content_6	, char(13), ' '), char(10), ' ') AS question_content_6	
			,	replace(replace(#TABLE_QUESTION.question_answer_6	, char(13), ' '), char(10), ' ') AS question_answer_6	
			,	replace(replace(#TABLE_QUESTION.question_content_7	, char(13), ' '), char(10), ' ') AS question_content_7	
			,	replace(replace(#TABLE_QUESTION.question_answer_7	, char(13), ' '), char(10), ' ') AS question_answer_7	
			,	replace(replace(#TABLE_QUESTION.question_content_8	, char(13), ' '), char(10), ' ') AS question_content_8	
			,	replace(replace(#TABLE_QUESTION.question_answer_8	, char(13), ' '), char(10), ' ') AS question_answer_8	
			,	replace(replace(#TABLE_QUESTION.question_content_9	, char(13), ' '), char(10), ' ') AS question_content_9	
			,	replace(replace(#TABLE_QUESTION.question_answer_9	, char(13), ' '), char(10), ' ') AS question_answer_9	
			,	replace(replace(#TABLE_QUESTION.question_content_10	, char(13), ' '), char(10), ' ') AS question_content_10	
			,	replace(replace(#TABLE_QUESTION.question_answer_10  , char(13), ' '), char(10), ' ') AS question_answer_10	
			,	CASE 
					WHEN F4201_tr.free_comment IS NOT NULL		
					THEN replace(replace(F4201_tr.free_comment, char(13), ' '), char(10), ' ')
					WHEN F4201_tr_blank.free_comment IS NOT NULL		
					THEN replace(replace(F4201_tr_blank.free_comment, char(13), ' '), char(10), ' ')
					ELSE replace(replace(F4201.free_comment, char(13), ' '), char(10), ' ')
				END																	AS	free_comment		-- 自由記入欄
			,	ISNULL(#TABLE_F4206_TEMP_JSON.note_json,'')							AS	note_json			-- 付箋
			FROM #TABLE_RESULT
			LEFT OUTER JOIN #M0070H ON (
				@P_company_cd						=	#M0070H.company_cd
			AND #TABLE_RESULT.employee_cd			=	#M0070H.employee_cd
			)
			LEFT OUTER JOIN F4200 ON (
				#TABLE_RESULT.company_cd			=	F4200.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4200.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4200.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4200.report_kind
			AND #TABLE_RESULT.report_no				=	F4200.report_no
			AND F4200.del_datetime IS NULL
			)
			LEFT OUTER JOIN F4201 ON (
				#TABLE_RESULT.company_cd			=	F4201.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4201.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4201.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4201.report_kind
			AND #TABLE_RESULT.report_no				=	F4201.report_no
			AND F4201.del_datetime IS NULL
			)
			LEFT OUTER JOIN F4201_tr ON (
				#TABLE_RESULT.company_cd			=	F4201_tr.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4201_tr.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4201_tr.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4201_tr.report_kind
			AND #TABLE_RESULT.report_no				=	F4201_tr.report_no
			AND @P_cre_user							=	F4201_tr.trans_user
			AND F4201_tr.del_datetime IS NULL
			)
			LEFT OUTER JOIN F4201_tr AS F4201_tr_blank ON (
				#TABLE_RESULT.company_cd			=	F4201_tr_blank.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4201_tr_blank.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4201_tr_blank.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4201_tr_blank.report_kind
			AND #TABLE_RESULT.report_no				=	F4201_tr_blank.report_no
			AND ''									=	F4201_tr_blank.trans_user
			AND F4201_tr_blank.del_datetime IS NULL
			)
			LEFT OUTER JOIN L0041 ON (
				F4200.status_cd					=	L0041.status_cd
			AND L0041.del_datetime IS NULL
			)
			LEFT OUTER JOIN #TABLE_F4206_TEMP_JSON ON (
				#TABLE_RESULT.company_cd			=	#TABLE_F4206_TEMP_JSON.company_cd
			AND #TABLE_RESULT.fiscal_year			=	#TABLE_F4206_TEMP_JSON.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	#TABLE_F4206_TEMP_JSON.employee_cd
			AND #TABLE_RESULT.report_kind			=	#TABLE_F4206_TEMP_JSON.report_kind
			AND #TABLE_RESULT.report_no				=	#TABLE_F4206_TEMP_JSON.report_no
			)LEFT OUTER JOIN #TABLE_QUESTION ON(
				#TABLE_RESULT.company_cd			=	#TABLE_QUESTION.company_cd
			AND #TABLE_RESULT.fiscal_year			=	#TABLE_QUESTION.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	#TABLE_QUESTION.employee_cd
			AND #TABLE_RESULT.report_kind			=	#TABLE_QUESTION.report_kind
			AND #TABLE_RESULT.report_no				=	#TABLE_QUESTION.report_no
			)
			WHERE
				#TABLE_RESULT.employee_cd LIKE '%'+@P_reporter_cd+'%'
			ORDER BY 
				RIGHT(SPACE(10)+#TABLE_RESULT.employee_cd,10)
			,	#TABLE_RESULT.report_kind
			,	#TABLE_RESULT.report_no
		END
		ELSE IF @P_count_org = 4
		BEGIN
		SELECT 
				ISNULL(#TABLE_RESULT.fiscal_year,0)				AS	fiscal_year			-- 年度
			,	ISNULL(#TABLE_RESULT.report_kind,0)				AS	report_kind			-- 報告書種類
			,	ISNULL(#TABLE_RESULT.report_no,0)				AS	report_no			-- 報告番号
			,	ISNULL(#TABLE_RESULT.employee_cd,'')			AS	employee_cd			-- 社員番号
			,	ISNULL(#M0070H.employee_nm,'')					AS	employee_nm			-- 社員名
			,	ISNULL(#M0070H.belong_nm_1,'')					AS	organization_nm1	-- 組織1
			,	ISNULL(#M0070H.belong_nm_2,'')					AS	organization_nm2	-- 組織2
			,	ISNULL(#M0070H.belong_nm_3,'')					AS	organization_nm3	-- 組織3
			,	ISNULL(#M0070H.belong_nm_4,'')					AS	organization_nm4	-- 組織4
			,	ISNULL(#M0070H.position_nm,'')					AS	position_nm			-- 役職
			,	ISNULL(#M0070H.job_nm,'')						AS	job_nm				-- 職種
			--↓2023/07/25 fixed
			--,	ISNULL(#M0070H.grade_nm,'')						AS	grade_nm			-- 等級
			,	CASE WHEN @w_company_attribute=3 THEN '' ELSE ISNULL(#M0070H.grade_nm,'') END AS grade_nm
			--↑2023/07/25 fixed
			,	ISNULL(#M0070H.employee_typ_nm,'')				AS	employee_typ_nm		-- 社員区分
			,	CASE 
					WHEN ISNULL(F4200.title,'') <> ''
					THEN ISNULL(F4200.title,'')			
					ELSE CAST(ISNULL(F4200.times,0) AS NVARCHAR(2)) + IIF(@w_language = 2, 'Times', '回')
				END												AS	title	-- タイトル
			,	CASE 
					WHEN @w_language = 2
					THEN ISNULL(L0041.status_nm2,'')
					ELSE ISNULL(L0041.status_nm,'')
				END																	AS	status_nm			-- 状態
			,	ISNULL(F4201.adequacy_kbn,0)										AS	adequacy_kbn		-- 充実度
			,	ISNULL(F4201.busyness_kbn,0)										AS	busyness_kbn		-- 繁忙度
			,	ISNULL(F4201.other_kbn,0)											AS	other_kbn			-- その他
			,	replace(replace(#TABLE_QUESTION.question_content_1   , char(13), ' '), char(10), ' ') 	AS question_content_1  
			,	replace(replace(#TABLE_QUESTION.question_answer_1	 , char(13), ' '), char(10), ' ')	AS question_answer_1 	
			,	replace(replace(#TABLE_QUESTION.question_content_2	 , char(13), ' '), char(10), ' ')	AS question_content_2	
			,	replace(replace(#TABLE_QUESTION.question_answer_2	 , char(13), ' '), char(10), ' ')	AS question_answer_2	
			,	replace(replace(#TABLE_QUESTION.question_content_3	 , char(13), ' '), char(10), ' ')	AS question_content_3	
			,	replace(replace(#TABLE_QUESTION.question_answer_3	 , char(13), ' '), char(10), ' ')	AS question_answer_3	
			,	replace(replace(#TABLE_QUESTION.question_content_4	 , char(13), ' '), char(10), ' ')	AS question_content_4	
			,	replace(replace(#TABLE_QUESTION.question_answer_4	 , char(13), ' '), char(10), ' ')	AS question_answer_4	
			,	replace(replace(#TABLE_QUESTION.question_content_5	 , char(13), ' '), char(10), ' ')	AS question_content_5	
			,	replace(replace(#TABLE_QUESTION.question_answer_5	 , char(13), ' '), char(10), ' ')	AS question_answer_5	
			,	replace(replace(#TABLE_QUESTION.question_content_6	 , char(13), ' '), char(10), ' ')	AS question_content_6	
			,	replace(replace(#TABLE_QUESTION.question_answer_6	 , char(13), ' '), char(10), ' ')	AS question_answer_6	
			,	replace(replace(#TABLE_QUESTION.question_content_7	 , char(13), ' '), char(10), ' ')	AS question_content_7	
			,	replace(replace(#TABLE_QUESTION.question_answer_7	 , char(13), ' '), char(10), ' ')	AS question_answer_7	
			,	replace(replace(#TABLE_QUESTION.question_content_8	 , char(13), ' '), char(10), ' ')	AS question_content_8	
			,	replace(replace(#TABLE_QUESTION.question_answer_8	 , char(13), ' '), char(10), ' ')	AS question_answer_8	
			,	replace(replace(#TABLE_QUESTION.question_content_9	 , char(13), ' '), char(10), ' ')	AS question_content_9	
			,	replace(replace(#TABLE_QUESTION.question_answer_9	 , char(13), ' '), char(10), ' ')	AS question_answer_9	
			,	replace(replace(#TABLE_QUESTION.question_content_10	 , char(13), ' '), char(10), ' ')	AS question_content_10	
			,	replace(replace(#TABLE_QUESTION.question_answer_10	 , char(13), ' '), char(10), ' ')	AS question_answer_10	
			,	CASE 
					WHEN F4201_tr.free_comment IS NOT NULL		
					THEN replace(replace(F4201_tr.free_comment, char(13), ' '), char(10), ' ')
					WHEN F4201_tr_blank.free_comment IS NOT NULL		
					THEN replace(replace(F4201_tr_blank.free_comment, char(13), ' '), char(10), ' ')
					ELSE replace(replace(F4201.free_comment, char(13), ' '), char(10), ' ')
				END																	AS	free_comment		-- 自由記入欄
			,	ISNULL(#TABLE_F4206_TEMP_JSON.note_json,'')							AS	note_json			-- 付箋
			FROM #TABLE_RESULT
			LEFT OUTER JOIN #M0070H ON (
				@P_company_cd						=	#M0070H.company_cd
			AND #TABLE_RESULT.employee_cd			=	#M0070H.employee_cd
			)
			LEFT OUTER JOIN F4200 ON (
				#TABLE_RESULT.company_cd			=	F4200.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4200.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4200.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4200.report_kind
			AND #TABLE_RESULT.report_no				=	F4200.report_no
			AND F4200.del_datetime IS NULL
			)
			LEFT OUTER JOIN F4201 ON (
				#TABLE_RESULT.company_cd			=	F4201.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4201.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4201.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4201.report_kind
			AND #TABLE_RESULT.report_no				=	F4201.report_no
			AND F4201.del_datetime IS NULL
			)
			LEFT OUTER JOIN F4201_tr ON (
				#TABLE_RESULT.company_cd			=	F4201_tr.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4201_tr.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4201_tr.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4201_tr.report_kind
			AND #TABLE_RESULT.report_no				=	F4201_tr.report_no
			AND @P_cre_user							=	F4201_tr.trans_user
			AND F4201_tr.del_datetime IS NULL
			)
			LEFT OUTER JOIN F4201_tr AS F4201_tr_blank ON (
				#TABLE_RESULT.company_cd			=	F4201_tr_blank.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4201_tr_blank.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4201_tr_blank.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4201_tr_blank.report_kind
			AND #TABLE_RESULT.report_no				=	F4201_tr_blank.report_no
			AND ''									=	F4201_tr_blank.trans_user
			AND F4201_tr_blank.del_datetime IS NULL
			)
			LEFT OUTER JOIN L0041 ON (
				F4200.status_cd					=	L0041.status_cd
			AND L0041.del_datetime IS NULL
			)
			LEFT OUTER JOIN #TABLE_F4206_TEMP_JSON ON (
				#TABLE_RESULT.company_cd			=	#TABLE_F4206_TEMP_JSON.company_cd
			AND #TABLE_RESULT.fiscal_year			=	#TABLE_F4206_TEMP_JSON.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	#TABLE_F4206_TEMP_JSON.employee_cd
			AND #TABLE_RESULT.report_kind			=	#TABLE_F4206_TEMP_JSON.report_kind
			AND #TABLE_RESULT.report_no				=	#TABLE_F4206_TEMP_JSON.report_no
			) LEFT OUTER JOIN #TABLE_QUESTION ON(
				#TABLE_RESULT.company_cd			=	#TABLE_QUESTION.company_cd
			AND #TABLE_RESULT.fiscal_year			=	#TABLE_QUESTION.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	#TABLE_QUESTION.employee_cd
			AND #TABLE_RESULT.report_kind			=	#TABLE_QUESTION.report_kind
			AND #TABLE_RESULT.report_no				=	#TABLE_QUESTION.report_no
			)
			WHERE
				#TABLE_RESULT.employee_cd LIKE '%'+@P_reporter_cd+'%'
			ORDER BY 
				RIGHT(SPACE(10)+#TABLE_RESULT.employee_cd,10)
			,	#TABLE_RESULT.report_kind
			,	#TABLE_RESULT.report_no
		END
		ELSE IF @P_count_org > 4
		BEGIN
		SELECT 
				ISNULL(#TABLE_RESULT.fiscal_year,0)				AS	fiscal_year			-- 年度
			,	ISNULL(#TABLE_RESULT.report_kind,0)				AS	report_kind			-- 報告書種類
			,	ISNULL(#TABLE_RESULT.report_no,0)				AS	report_no			-- 報告番号
			,	ISNULL(#TABLE_RESULT.employee_cd,'')			AS	employee_cd			-- 社員番号
			,	ISNULL(#M0070H.employee_nm,'')					AS	employee_nm			-- 社員名
			,	ISNULL(#M0070H.belong_nm_1,'')					AS	organization_nm1	-- 組織1
			,	ISNULL(#M0070H.belong_nm_2,'')					AS	organization_nm2	-- 組織2
			,	ISNULL(#M0070H.belong_nm_3,'')					AS	organization_nm3	-- 組織3
			,	ISNULL(#M0070H.belong_nm_4,'')					AS	organization_nm4	-- 組織4
			,	ISNULL(#M0070H.belong_nm_5,'')					AS	organization_nm5	-- 組織5
			,	ISNULL(#M0070H.position_nm,'')					AS	position_nm			-- 役職
			,	ISNULL(#M0070H.job_nm,'')						AS	job_nm				-- 職種
			--↓2023/07/25 fixed
			--,	ISNULL(#M0070H.grade_nm,'')						AS	grade_nm			-- 等級
			,	CASE WHEN @w_company_attribute=3 THEN '' ELSE ISNULL(#M0070H.grade_nm,'') END AS grade_nm
			--↑2023/07/25 fixed
			,	ISNULL(#M0070H.employee_typ_nm,'')				AS	employee_typ_nm		-- 社員区分
			,	CASE 
					WHEN ISNULL(F4200.title,'') <> ''
					THEN ISNULL(F4200.title,'')			
					ELSE CAST(ISNULL(F4200.times,0) AS NVARCHAR(2)) + IIF(@w_language = 2, 'Times', '回')
				END												AS	title	-- タイトル
			,	CASE 
					WHEN @w_language = 2
					THEN ISNULL(L0041.status_nm2,'')
					ELSE ISNULL(L0041.status_nm,'')
				END																	AS	status_nm			-- 状態
			,	ISNULL(F4201.adequacy_kbn,0)										AS	adequacy_kbn		-- 充実度
			,	ISNULL(F4201.busyness_kbn,0)										AS	busyness_kbn		-- 繁忙度
			,	ISNULL(F4201.other_kbn,0)											AS	other_kbn			-- その他
			,	replace(replace(#TABLE_QUESTION.question_content_1  , char(13), ' '), char(10), ' ')	AS question_content_1  
			,	replace(replace(#TABLE_QUESTION.question_answer_1 	, char(13), ' '), char(10), ' ')	AS question_answer_1 	
			,	replace(replace(#TABLE_QUESTION.question_content_2	, char(13), ' '), char(10), ' ')	AS question_content_2	
			,	replace(replace(#TABLE_QUESTION.question_answer_2	, char(13), ' '), char(10), ' ')	AS question_answer_2	
			,	replace(replace(#TABLE_QUESTION.question_content_3	, char(13), ' '), char(10), ' ')	AS question_content_3	
			,	replace(replace(#TABLE_QUESTION.question_answer_3	, char(13), ' '), char(10), ' ')	AS question_answer_3	
			,	replace(replace(#TABLE_QUESTION.question_content_4	, char(13), ' '), char(10), ' ')	AS question_content_4	
			,	replace(replace(#TABLE_QUESTION.question_answer_4	, char(13), ' '), char(10), ' ')	AS question_answer_4	
			,	replace(replace(#TABLE_QUESTION.question_content_5	, char(13), ' '), char(10), ' ')	AS question_content_5	
			,	replace(replace(#TABLE_QUESTION.question_answer_5	, char(13), ' '), char(10), ' ')	AS question_answer_5	
			,	replace(replace(#TABLE_QUESTION.question_content_6	, char(13), ' '), char(10), ' ')	AS question_content_6	
			,	replace(replace(#TABLE_QUESTION.question_answer_6	, char(13), ' '), char(10), ' ')	AS question_answer_6	
			,	replace(replace(#TABLE_QUESTION.question_content_7	, char(13), ' '), char(10), ' ')	AS question_content_7	
			,	replace(replace(#TABLE_QUESTION.question_answer_7	, char(13), ' '), char(10), ' ')	AS question_answer_7	
			,	replace(replace(#TABLE_QUESTION.question_content_8	, char(13), ' '), char(10), ' ')	AS question_content_8	
			,	replace(replace(#TABLE_QUESTION.question_answer_8	, char(13), ' '), char(10), ' ')	AS question_answer_8	
			,	replace(replace(#TABLE_QUESTION.question_content_9	, char(13), ' '), char(10), ' ')	AS question_content_9	
			,	replace(replace(#TABLE_QUESTION.question_answer_9	, char(13), ' '), char(10), ' ')	AS question_answer_9	
			,	replace(replace(#TABLE_QUESTION.question_content_10	, char(13), ' '), char(10), ' ')	AS question_content_10	
			,	replace(replace(#TABLE_QUESTION.question_answer_10	, char(13), ' '), char(10), ' ')	AS question_answer_10	
			,	CASE 
					WHEN F4201_tr.free_comment IS NOT NULL		
					THEN replace(replace(F4201_tr.free_comment, char(13), ' '), char(10), ' ')
					WHEN F4201_tr_blank.free_comment IS NOT NULL		
					THEN replace(replace(F4201_tr_blank.free_comment, char(13), ' '), char(10), ' ')
					ELSE replace(replace(F4201.free_comment, char(13), ' '), char(10), ' ')
				END																	AS	free_comment		-- 自由記入欄
			,	ISNULL(#TABLE_F4206_TEMP_JSON.note_json,'')							AS	note_json			-- 付箋
			FROM #TABLE_RESULT
			LEFT OUTER JOIN #M0070H ON (
				@P_company_cd						=	#M0070H.company_cd
			AND #TABLE_RESULT.employee_cd			=	#M0070H.employee_cd
			)
			LEFT OUTER JOIN F4200 ON (
				#TABLE_RESULT.company_cd			=	F4200.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4200.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4200.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4200.report_kind
			AND #TABLE_RESULT.report_no				=	F4200.report_no
			AND F4200.del_datetime IS NULL
			)
			LEFT OUTER JOIN F4201 ON (
				#TABLE_RESULT.company_cd			=	F4201.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4201.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4201.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4201.report_kind
			AND #TABLE_RESULT.report_no				=	F4201.report_no
			AND F4201.del_datetime IS NULL
			)
			LEFT OUTER JOIN F4201_tr ON (
				#TABLE_RESULT.company_cd			=	F4201_tr.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4201_tr.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4201_tr.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4201_tr.report_kind
			AND #TABLE_RESULT.report_no				=	F4201_tr.report_no
			AND @P_cre_user							=	F4201_tr.trans_user
			AND F4201_tr.del_datetime IS NULL
			)
			LEFT OUTER JOIN F4201_tr AS F4201_tr_blank ON (
				#TABLE_RESULT.company_cd			=	F4201_tr_blank.company_cd
			AND #TABLE_RESULT.fiscal_year			=	F4201_tr_blank.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	F4201_tr_blank.employee_cd
			AND #TABLE_RESULT.report_kind			=	F4201_tr_blank.report_kind
			AND #TABLE_RESULT.report_no				=	F4201_tr_blank.report_no
			AND ''									=	F4201_tr_blank.trans_user
			AND F4201_tr_blank.del_datetime IS NULL
			)
			LEFT OUTER JOIN L0041 ON (
				F4200.status_cd					=	L0041.status_cd
			AND L0041.del_datetime IS NULL
			)
			LEFT OUTER JOIN #TABLE_F4206_TEMP_JSON ON (
				#TABLE_RESULT.company_cd			=	#TABLE_F4206_TEMP_JSON.company_cd
			AND #TABLE_RESULT.fiscal_year			=	#TABLE_F4206_TEMP_JSON.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	#TABLE_F4206_TEMP_JSON.employee_cd
			AND #TABLE_RESULT.report_kind			=	#TABLE_F4206_TEMP_JSON.report_kind
			AND #TABLE_RESULT.report_no				=	#TABLE_F4206_TEMP_JSON.report_no
			) LEFT OUTER JOIN #TABLE_QUESTION ON(
				#TABLE_RESULT.company_cd			=	#TABLE_QUESTION.company_cd
			AND #TABLE_RESULT.fiscal_year			=	#TABLE_QUESTION.fiscal_year
			AND #TABLE_RESULT.employee_cd			=	#TABLE_QUESTION.employee_cd
			AND #TABLE_RESULT.report_kind			=	#TABLE_QUESTION.report_kind
			AND #TABLE_RESULT.report_no				=	#TABLE_QUESTION.report_no
			)
			WHERE
				#TABLE_RESULT.employee_cd LIKE '%'+@P_reporter_cd+'%'
			ORDER BY 
				RIGHT(SPACE(10)+#TABLE_RESULT.employee_cd,10)
			,	#TABLE_RESULT.report_kind
			,	#TABLE_RESULT.report_no
		END
	END

	-- DROP
	DROP TABLE #LIST_POSITION
	DROP TABLE #LIST_STATUS
	DROP TABLE #M0070H
	DROP TABLE #TABLE_F4202_TEMP
	DROP TABLE #TABLE_ORGANIZATION
	DROP TABLE #TABLE_REPOTERS_RQ2010
	DROP TABLE #TABLE_RESULT
END
GO
