IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_rI2010_INQ4]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_rI2010_INQ4]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_rI2010_INQ3 782,2023,'890',4,1,'890'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET LOGIN USER TYPE FOR REPORT
--*  
--*  作成日/create date			:	2023/07/14						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rI2010_INQ4]
	@P_company_cd			smallint		=	0
,	@P_login_employee_cd	nvarchar(10)	=	''
,	@P_fiscal_year			smallint		=	0
,	@P_report_kind			smallint		=	0
,	@P_report_no			smallint		=	0
,	@P_employee_cd			nvarchar(10)	=	''
AS
BEGIN
	DECLARE 
		@w_hide				smallint		=	0
	--
	CREATE TABLE #EMPLOYEE (
		id					int		identity(1,1)
	,	employee_cd			nvarchar(10)
	)
	--
	INSERT INTO #EMPLOYEE
	SELECT
		@P_employee_cd
	--approver
	INSERT INTO #EMPLOYEE
	SELECT
		value AS approver_employe
	FROM F4200
	UNPIVOT (value FOR approver_employee IN (approver_employee_cd_1, approver_employee_cd_2, approver_employee_cd_3, approver_employee_cd_4)) AS unpvt
	WHERE
		company_cd  = @P_company_cd
	AND fiscal_year = @P_fiscal_year
	AND employee_cd = @P_employee_cd
	AND report_kind = @P_report_kind
	AND report_no	= @P_report_no
	AND value IS NOT NULL
	AND value <> ''
	AND del_datetime IS NULL
	--reporter
	INSERT INTO #EMPLOYEE
	SELECT
		F4200.employee_cd
	FROM F4200
	WHERE
		company_cd  = @P_company_cd
	AND fiscal_year = @P_fiscal_year
	AND report_kind = @P_report_kind
	AND report_no	= @P_report_no
	AND (
			approver_employee_cd_1 = @P_employee_cd
		OR	approver_employee_cd_2 = @P_employee_cd
		OR	approver_employee_cd_3 = @P_employee_cd
		OR	approver_employee_cd_4 = @P_employee_cd
		)
	AND del_datetime IS NULL
	--
	INSERT INTO #EMPLOYEE
	SELECT
		F4207.sharewith_employee_cd
	FROM F4207
	WHERE
		company_cd  = @P_company_cd
	AND fiscal_year = @P_fiscal_year
	AND employee_cd = @P_employee_cd
	AND report_kind = @P_report_kind
	AND report_no	= @P_report_no
	AND del_datetime IS NULL
	--
	INSERT INTO #EMPLOYEE
	SELECT
		F4121.viewer_employee_cd
	FROM F4121
	WHERE
		company_cd  = @P_company_cd
	AND fiscal_year = @P_fiscal_year
	AND employee_cd = @P_employee_cd
	AND report_kind = @P_report_kind
	AND del_datetime IS NULL
	--set @w_hide
	SELECT
		@w_hide = 1
	FROM S0010
	INNER JOIN M9100 ON (
		@P_company_cd = M9100.company_cd
	AND M9100.del_datetime IS NULL
	)
	INNER JOIN #EMPLOYEE ON (
		S0010.employee_cd	=	#EMPLOYEE.employee_cd
	AND @P_login_employee_cd = #EMPLOYEE.employee_cd
	)
	WHERE 
		S0010.company_cd					=	@P_company_cd	
	AND S0010.multilingual_use_typ			=	1
	AND M9100.multilingual_option_use_typ	=	1
	AND S0010.del_datetime IS NULL
	--[0]
	SELECT
		CASE						
			WHEN	S0010.multilingual_use_typ = 1 and M9100.multilingual_option_use_typ = 1 AND @w_hide = 1
			THEN	ISNULL(supported_languages,'')
			ELSE	''
		END					   AS  supported_languages
	,	CASE						
			WHEN	@w_hide = 1
			THEN	ISNULL(L0014.language_name,'')
			ELSE	''
		END											AS language_name
	,	@w_hide                AS check_hide 
	,	CASE						
			WHEN	@w_hide = 1
			THEN	ISNULL(S0010.multilingual_use_typ,0)
			ELSE	0
		END				AS multilingual_use_typ

	FROM S0010
	LEFT JOIN M9100 ON (
		@P_company_cd = M9100.company_cd
	AND M9100.del_datetime IS NULL
	)
	LEFT JOIN L0014 ON (
		S0010.supported_languages = language_cd
	)
	WHERE 
		S0010.company_cd	=	@P_company_cd
	AND S0010.employee_cd	=	@P_login_employee_cd
	AND S0010.del_datetime IS NULL

END
GO