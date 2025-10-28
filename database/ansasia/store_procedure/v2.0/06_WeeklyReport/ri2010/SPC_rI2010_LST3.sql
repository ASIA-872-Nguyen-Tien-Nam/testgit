IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_rI2010_LST3]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_rI2010_LST3]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_rI2010_LST3 782,2023,'890',4,1,'890'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET VIEWERS FOR rI2010
--*  
--*  作成日/create date			:	2023/05/08						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2023/08/29
--*　更新者/updater				:	viettd
--*　更新内容/update content		:	add table F4121
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rI2010_LST3]
	@P_company_cd			SMALLINT		=	0
,	@P_fiscal_year			SMALLINT		=	0
,	@P_employee_cd			NVARCHAR(10)	=	''
,	@P_report_kind			SMALLINT		=	0
,	@P_report_no			SMALLINT		=	0
,	@P_page					INT				=	1
,	@P_page_size			INT				=	20
,	@P_login_employee_cd	NVARCHAR(10)	=	''	-- LOGIN EMPLOYEE
AS
BEGIN
	DECLARE 
		@w_beginning_date			date			=	NULL
	,	@w_year_month_day			date			=	NULL
	,	@w_language					smallint		=	0	-- 1.JP 2.EN
	,	@w_totalRecord				bigint			=	0
	,	@w_pageMax					int				=	0
	--
	,	@w_approver_employee_cd_1	nvarchar(10)	=	''
	,	@w_approver_employee_cd_2	nvarchar(10)	=	''
	,	@w_approver_employee_cd_3	nvarchar(10)	=	''
	,	@w_approver_employee_cd_4	nvarchar(10)	=	''

	--#TABLE_RESULT
	CREATE TABLE #TABLE_RESULT(
		id					int		identity(1,1)
	,	viewer_employee_cd			nvarchar(10)
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
	-- add by viettd 2023/08/29
	-- F4121
	CREATE TABLE #TABLE_F4121 (
		id						int			identity(1,1)
	,	company_cd				smallint
	,	fiscal_year				smallint
	,	employee_cd				nvarchar(10)
	,	report_kind				smallint
	,	viewer_employee_cd		nvarchar(10)
	)
	SELECT 
		@w_language =	ISNULL(S0010.[language],1)
	FROM S0010
	WHERE 
		S0010.company_cd	=	@P_company_cd
	AND S0010.employee_cd	=	@P_login_employee_cd
	AND S0010.del_datetime IS NULL
	--
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

	-- #M0070H
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @w_year_month_day,'',@P_company_cd
	-- GET INFO OF F4200
	SELECT 
		@w_approver_employee_cd_1	=	ISNULL(F4200.approver_employee_cd_1,'')
	,	@w_approver_employee_cd_2	=	ISNULL(F4200.approver_employee_cd_2,'')	
	,	@w_approver_employee_cd_3	=	ISNULL(F4200.approver_employee_cd_3,'')	
	,	@w_approver_employee_cd_4	=	ISNULL(F4200.approver_employee_cd_4,'')	
	FROM F4200
	WHERE 
		F4200.company_cd		=	@P_company_cd
	AND F4200.fiscal_year		=	@P_fiscal_year
	AND F4200.employee_cd		=	@P_employee_cd
	AND F4200.report_kind		=	@P_report_kind
	AND F4200.report_no			=	@P_report_no
	AND F4200.del_datetime IS NULL
	--
	INSERT INTO #TABLE_RESULT
	SELECT 
		ISNULL(F4120.viewer_employee_cd,'')		AS	viewer_employee_cd
	FROM F4120
	WHERE 
		F4120.company_cd	=	@P_company_cd
	AND F4120.fiscal_year	=	@P_fiscal_year
	AND F4120.employee_cd	=	@P_employee_cd
	AND F4120.report_kind	=	@P_report_kind
	AND F4120.report_no		=	@P_report_no
	AND F4120.del_datetime IS NULL
	-- add by viettd 2023/08/29
	-- F4120 HAS NOT DATA THEN GET DATA FROM F4121
	IF NOT EXISTS (SELECT 1 FROM #TABLE_RESULT)
	BEGIN
		-- GET #TABLE_F4121
		INSERT INTO #TABLE_F4121
		SELECT 
			F4121.company_cd
		,	F4121.fiscal_year
		,	F4121.employee_cd
		,	F4121.report_kind
		,	F4121.viewer_employee_cd
		FROM F4121
		WHERE 
			F4121.company_cd			=	@P_company_cd
		AND F4121.fiscal_year			=	@P_fiscal_year
		AND F4121.employee_cd			=	@P_employee_cd
		AND F4121.report_kind			=	@P_report_kind
		AND (
			@w_approver_employee_cd_1	=	''
		OR	@w_approver_employee_cd_1	<>	'' AND F4121.viewer_employee_cd	<>	@w_approver_employee_cd_1
		)
		AND (
			@w_approver_employee_cd_2	=	''
		OR	@w_approver_employee_cd_2	<>	'' AND F4121.viewer_employee_cd	<>	@w_approver_employee_cd_2
		)
		AND (
			@w_approver_employee_cd_3	=	''
		OR	@w_approver_employee_cd_3	<>	'' AND F4121.viewer_employee_cd	<>	@w_approver_employee_cd_3
		)
		AND (
			@w_approver_employee_cd_4	=	''
		OR	@w_approver_employee_cd_4	<>	'' AND F4121.viewer_employee_cd	<>	@w_approver_employee_cd_4
		)
		AND F4121.del_datetime IS NULL
		--
		INSERT INTO #TABLE_RESULT
		SELECT 
			#TABLE_F4121.viewer_employee_cd
		FROM #TABLE_F4121
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
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
		ISNULL(#TABLE_RESULT.viewer_employee_cd,'')		AS	employee_cd
	,	ISNULL(#M0070H.employee_nm,'')					AS	employee_nm
	,	ISNULL(#M0070H.employee_typ_nm,'')				AS	employee_typ_nm
	,	ISNULL(#M0070H.belong_nm_1,'')					AS	organization_nm1
	,	ISNULL(#M0070H.belong_nm_2,'')					AS	organization_nm2
	,	ISNULL(#M0070H.belong_nm_3,'')					AS	organization_nm3
	,	ISNULL(#M0070H.belong_nm_4,'')					AS	organization_nm4
	,	ISNULL(#M0070H.belong_nm_5,'')					AS	organization_nm5
	,	ISNULL(#M0070H.job_nm,'')						AS	job_nm
	,	ISNULL(#M0070H.position_nm,'')					AS	position_nm
	,	ISNULL(#M0070H.grade_nm,'')						AS	grade_nm
	,	CASE
			WHEN F4203.viewer_datetime IS NOT NULL
			THEN IIF(@w_language = 2, 'DONE','済')
			ELSE SPACE(0)
		END										AS	viewed_status
	,	CASE
			WHEN F4204.reaction_datetime IS NOT NULL
			THEN IIF(@w_language = 2, 'DONE','済')
			ELSE SPACE(0)
		END										AS	comment_status

	FROM #TABLE_RESULT
	LEFT OUTER JOIN #M0070H ON (
		@P_company_cd						=	#M0070H.company_cd
	AND #TABLE_RESULT.viewer_employee_cd	=	#M0070H.employee_cd
	)
	LEFT OUTER JOIN F4203 ON (
		@P_company_cd						=	F4203.company_cd
	AND @P_fiscal_year						=	F4203.fiscal_year
	AND @P_employee_cd						=	F4203.employee_cd
	AND @P_report_kind						=	F4203.report_kind
	AND @P_report_no						=	F4203.report_no
	AND #TABLE_RESULT.viewer_employee_cd	=	F4203.viewer_employee_cd
	AND F4203.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4204 ON (
		@P_company_cd						=	F4204.company_cd
	AND @P_fiscal_year						=	F4204.fiscal_year
	AND @P_employee_cd						=	F4204.employee_cd
	AND @P_report_kind						=	F4204.report_kind
	AND @P_report_no						=	F4204.report_no
	AND #TABLE_RESULT.viewer_employee_cd	=	F4204.reaction_no
	AND F4204.del_datetime IS NULL
	)
	ORDER BY 
		RIGHT(SPACE(10)+#TABLE_RESULT.viewer_employee_cd,10)
	offset (@P_page-1) * @P_page_size ROWS
	FETCH NEXT @P_page_size ROWS only
	--[1]
	SELECT	
		@w_totalRecord						AS totalRecord
	,	@w_pageMax							AS pageMax
	,	@P_page								AS [page]
	,	@P_page_size						AS pagesize
	,	((@P_page - 1) * @P_page_size + 1)	AS offset
	-- drop
	DROP TABLE #M0070H
END
GO
