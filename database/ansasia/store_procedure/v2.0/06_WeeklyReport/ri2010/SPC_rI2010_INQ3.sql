IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_rI2010_INQ3]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_rI2010_INQ3]
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
CREATE PROCEDURE [SPC_rI2010_INQ3]
	@P_company_cd			smallint		=	0
,	@P_fiscal_year			smallint		=	0
,	@P_employee_cd			nvarchar(10)	=	''
,	@P_report_kind			smallint		=	0
,	@P_report_no			smallint		=	0
,	@P_login_employee_cd	nvarchar(10)	=	''	-- LOGIN EMPLOYEE
AS
BEGIN
	DECLARE
		@w_approver_employee_cd_1			nvarchar(10)	=	''
	,	@w_approver_employee_cd_2			nvarchar(10)	=	''
	,	@w_approver_employee_cd_3			nvarchar(10)	=	''
	,	@w_approver_employee_cd_4			nvarchar(10)	=	''
	,	@w_login_use_typ					tinyint			=	0		-- check F4120 is exists 
	-- login permison
	,	@w_report_authority_typ				smallint		=	0
	,	@w_report_authority_cd				smallint		=	0
	,	@w_authority_ri2010					smallint		=	0
	--	
	,	@w_user_id							nvarchar(50)	=	''
	,	@w_login_position_cd				int				=	0
	,	@w_use_typ							smallint		=	0	
	,	@w_arrange_order					int				=	0
	,	@w_evaluation_organization_cnt		int				=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	smallint		=	0
	,	@w_beginning_date					DATE			=	NULL
	,	@w_year_month_day					DATE			=	NULL
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
	-- GET REPORT INFO
	SELECT 
		@w_approver_employee_cd_1	=	ISNULL(F4200.approver_employee_cd_1,'')
	,	@w_approver_employee_cd_2	=	ISNULL(F4200.approver_employee_cd_2,'')
	,	@w_approver_employee_cd_3	=	ISNULL(F4200.approver_employee_cd_3,'')
	,	@w_approver_employee_cd_4	=	ISNULL(F4200.approver_employee_cd_4,'')
	FROM F4200
	WHERE 
		F4200.company_cd			=	@P_company_cd
	AND F4200.fiscal_year			=	@P_fiscal_year
	AND F4200.employee_cd			=	@P_employee_cd
	AND F4200.report_kind			=	@P_report_kind
	AND F4200.report_no				=	@P_report_no
	AND F4200.del_datetime IS NULL
	-- GET @w_report_authority_typ
	SELECT 
		@w_report_authority_typ		=	ISNULL(S0010.report_authority_typ,0)
	,	@w_report_authority_cd		=	ISNULL(S0010.report_authority_cd,0)
	,	@w_login_position_cd		=	ISNULL(M0070.position_cd,0)
	,	@w_user_id					=	ISNULL(S0010.user_id,'')
	FROM S0010
	LEFT OUTER JOIN M0070 ON (
		S0010.company_cd		=	M0070.company_cd
	AND S0010.employee_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	WHERE 
		S0010.company_cd		=	@P_company_cd
	AND S0010.employee_cd		=	@P_login_employee_cd
	AND S0010.del_datetime IS NULL
	-- GET @w_authority_ri2010
	SELECT 
		@w_authority_ri2010 = ISNULL(S4021.authority,0)
	FROM S4021
	WHERE 
		S4021.company_cd		=	@P_company_cd
	AND	S4021.authority_cd		=	@w_report_authority_cd
	AND S4021.function_id		=	'ri2010'
	AND S4021.del_datetime IS NULL
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- CHECK LOGIN USER IS 4.会社管理者　5.総合管理者
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF @w_report_authority_typ IN (4,5)
	BEGIN
		SET @w_login_use_typ = 4
		GOTO UPDATE_LOGIN_USE
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- CHECK LOGIN USER IS VIEWER | SHAREDWITH | REPORTER | APPROVER
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- CHECK LOGIN USER IS VIEWER OF REPORT
	IF EXISTS (SELECT 1 FROM F4120 
						WHERE 
							company_cd			=	@P_company_cd
						AND fiscal_year			=	@P_fiscal_year
						AND employee_cd			=	@P_employee_cd
						AND report_kind			=	@P_report_kind
						AND report_no			=	@P_report_no
						AND viewer_employee_cd	=	@P_login_employee_cd
						AND F4120.del_datetime IS NULL
						)
	BEGIN
		SET @w_login_use_typ = 3		-- LOGIN USER IS VIEWER OF REPORT
	END
	-- CHECK LOGIN USER IS SHARED OF REPORT 
	IF EXISTS (SELECT 1 FROM F4207 
						WHERE 
							company_cd				=	@P_company_cd
						AND fiscal_year				=	@P_fiscal_year
						AND employee_cd				=	@P_employee_cd
						AND report_kind				=	@P_report_kind
						AND report_no				=	@P_report_no
						AND sharewith_employee_cd	=	@P_login_employee_cd
						AND F4207.del_datetime IS NULL
						)
	BEGIN
		SET @w_login_use_typ	= 3		-- LOGIN USER IS VIEWER OF REPORT
	END
	-- CHECK LOGIN USER IS APPROVER
	IF @w_approver_employee_cd_1 <> '' AND @P_login_employee_cd = @w_approver_employee_cd_1
	BEGIN
		SET @w_login_use_typ = 21
	END
	IF @w_approver_employee_cd_2 <> '' AND @P_login_employee_cd = @w_approver_employee_cd_2
	BEGIN
		SET @w_login_use_typ = 22
	END
	IF @w_approver_employee_cd_3 <> '' AND @P_login_employee_cd = @w_approver_employee_cd_3
	BEGIN
		SET @w_login_use_typ = 23
	END
	IF @w_approver_employee_cd_4 <> '' AND  @P_login_employee_cd = @w_approver_employee_cd_4
	BEGIN
		SET @w_login_use_typ = 24
	END
	-- CHECK LOGIN USER IS REPORTER
	IF @P_login_employee_cd = @P_employee_cd
	BEGIN
		SET @w_login_use_typ = 1
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- CHECK LOGIN USER IS 3.管理者
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- 3.管理者 authority = 0.参照不可
	IF @w_report_authority_typ = 3 AND @w_authority_ri2010 = 0 AND @w_login_use_typ = 0
	BEGIN
		GOTO UPDATE_LOGIN_USE
	END
	-- 3.管理者 authority = 1.参照可能　2.変更可能
	IF @w_report_authority_typ = 3 AND @w_authority_ri2010 > 0
	BEGIN
		-- GET @w_use_typ
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
		-- GET @w_beginning_date
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
		EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 '',@w_user_id,@P_company_cd, 5
		-- INSERT DATA INTO #LIST_POSITION
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
		-- FILTER 組織
		IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
		BEGIN
			IF NOT (@w_report_authority_typ = 3 AND @w_evaluation_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)
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
		END
		-- FILTER 役職
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
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		--REPOTER IS LOGIN USER 'S PERMISSON
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		-- 2 (変更可能)
		IF @w_authority_ri2010 = 2 AND EXISTS (SELECT 1 FROM #M0070H WHERE employee_cd = @P_employee_cd)
		BEGIN
			SET @w_login_use_typ = 4
			GOTO UPDATE_LOGIN_USE
		END
		--  1 (閲覧可能) 
		IF @w_authority_ri2010 = 1 AND EXISTS (SELECT 1 FROM #M0070H WHERE employee_cd = @P_employee_cd) AND @w_login_use_typ = 0
		BEGIN
			SET @w_login_use_typ = 4
			GOTO UPDATE_LOGIN_USE
		END
		-- GOTO UPDATE_LOGIN_USE
		GOTO UPDATE_LOGIN_USE
	END
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--COMPLETED
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
UPDATE_LOGIN_USE:	
	SELECT @w_login_use_typ		AS	login_use_typ
	-- DROP
	DROP TABLE #LIST_POSITION
	DROP TABLE #M0070H
	DROP TABLE #TABLE_ORGANIZATION
END
GO