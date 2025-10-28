IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_mI1010_RPT1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_mI1010_RPT1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：mI1010 - Report
 *
 *  作成日  ：2021/01/05
 *  作成者  ：ANS-ASIA DUONGNTT
 *   					
 *  更新日/update date			:	2022/08/22
 *　更新者/updater				:	viettd　
 *　更新内容/update content		:	Ver 1.9　
 *EXEC SPC_mI1010_RPT1 'en','{"fiscal_year":"2022","employee_cd":"4"}',740
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_mI1010_RPT1]
	@P_language					nvarchar(10)		=	'jp'		
,	@P_json						NVARCHAR(max)		=	''	
,	@P_company_cd				SMALLINT			=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					datetime			=	SYSDATETIME()
	,	@year_month_day			date				=	NULL
	,	@fiscal_year			int					=	0
	,	@employee_cd			nvarchar(10)		=	''
	,	@organization_group_nm1	nvarchar(50)		=	''
	,	@organization_group_nm2	nvarchar(50)		=	''
	,	@organization_group_nm3	nvarchar(50)		=	''
	,	@organization_group_nm4	nvarchar(50)		=	''
	,	@organization_group_nm5	nvarchar(50)		=	''
	,	@use_typ_group_1		SMALLINT			=	0
	,	@use_typ_group_2		SMALLINT			=	0
	,	@use_typ_group_3		SMALLINT			=	0
	,	@use_typ_group_4		SMALLINT			=	0
	,	@use_typ_group_5		SMALLINT			=	0

	--社員
	IF object_id('tempdb..#M0070', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070
    END
	--社員履歴
	IF object_id('tempdb..#M0070H', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070H
    END
	--
	CREATE TABLE #M0070H(
		application_date				date
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(200)
	,	employee_ab_nm					nvarchar(50)
	,	furigana						nvarchar(50)
	,	office_cd						smallint
	,	office_nm						nvarchar(50)
	,	belong_cd_1						nvarchar(50)
	,	belong_cd_2						nvarchar(50)
	,	belong_cd_3						nvarchar(50)
	,	belong_cd_4						nvarchar(50)
	,	belong_cd_5						nvarchar(50)
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
	CREATE TABLE #LIST_ORGANIZATION
	(
		organization_typ				TINYINT
	,	organization_group_nm			NVARCHAR(50)
	,	organization_step				INT		 
	,	use_typ							SMALLINT
	)
	--
	CREATE TABLE #F3020(
		id								INT IDENTITY(1,1)
	,	company_cd						SMALLINT
	,	fiscal_year						SMALLINT
	,	employee_cd						NVARCHAR(10)
	,	supporter_cd					NVARCHAR(10)
	)
	--
	CREATE TABLE #RESULT(
		id								INT IDENTITY(1,1)
	-- employee
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(200)
	,	position_nm						nvarchar(50)
	,	belong_nm_1						nvarchar(50)
	,	belong_nm_2						nvarchar(50)
	,	belong_nm_3						nvarchar(50)
	,	belong_nm_4						nvarchar(50)
	,	belong_nm_5						nvarchar(50)
	--supporter
	,	supporter_cd					NVARCHAR(10)
	,	supporter_nm					nvarchar(50)
	,	s_position_nm					nvarchar(50)
	,	s_grade_nm						nvarchar(50)
	,	s_job_nm						nvarchar(50)
	,	s_employee_typ_nm				nvarchar(50)
	)
	--
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @year_month_day,'',@P_company_cd
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■	
	
	SET @fiscal_year		=	JSON_VALUE(@P_json,'$.fiscal_year')
	SET @employee_cd		=	JSON_VALUE(@P_json,'$.employee_cd')

	--
	INSERT INTO #LIST_ORGANIZATION
	SELECT 
		ISNULL(M0022.organization_typ,0)			AS	organization_typ
	,	ISNULL(M0022.organization_group_nm,'')		AS	organization_group_nm
	,	ROW_NUMBER() OVER(ORDER BY M0022.organization_typ)			
													AS	organization_step
	,	M0022.use_typ								AS	use_typ
	FROM M0022
	WHERE 
		M0022.company_cd	=	@P_company_cd
	AND M0022.del_datetime IS NULL

	--
	SET @organization_group_nm1	=	(SELECT organization_group_nm FROM #LIST_ORGANIZATION WHERE organization_step = 1)
	SET @organization_group_nm2	=	(SELECT organization_group_nm FROM #LIST_ORGANIZATION WHERE organization_step = 2)
	SET @organization_group_nm3	=	(SELECT organization_group_nm FROM #LIST_ORGANIZATION WHERE organization_step = 3)
	SET @organization_group_nm4	=	(SELECT organization_group_nm FROM #LIST_ORGANIZATION WHERE organization_step = 4)
	SET @organization_group_nm5	=	(SELECT organization_group_nm FROM #LIST_ORGANIZATION WHERE organization_step = 5)
	SET	@use_typ_group_1		=	(SELECT use_typ FROM #LIST_ORGANIZATION WHERE organization_step = 1)
	SET	@use_typ_group_2		=	(SELECT use_typ FROM #LIST_ORGANIZATION WHERE organization_step = 2)
	SET	@use_typ_group_3		=	(SELECT use_typ FROM #LIST_ORGANIZATION WHERE organization_step = 3)
	SET	@use_typ_group_4		=	(SELECT use_typ FROM #LIST_ORGANIZATION WHERE organization_step = 4)
	SET	@use_typ_group_5		=	(SELECT use_typ FROM #LIST_ORGANIZATION WHERE organization_step = 5)

	--
	INSERT INTO #F3020
	SELECT
		F3020.company_cd			
	,	F3020.fiscal_year			
	,	F3020.employee_cd			
	,	F3020.supporter_cd	
	FROM F3020
	WHERE
		F3020.company_cd	=	@P_company_cd
	AND	F3020.fiscal_year	=	@fiscal_year
	AND F3020.employee_cd	=	@employee_cd
	AND	F3020.del_datetime IS NULL
	ORDER BY 
		F3020.supporter_cd	

	IF	@P_language = 'en'
	BEGIN
		INSERT INTO #RESULT
		SELECT 
			''								--employee_cd
		,	'Target Employee'				--employee_nm			
		,	'Position'						--position_nm			
		,	@organization_group_nm1			--belong_nm_1					
		,	@organization_group_nm2			--belong_nm_2					
		,	@organization_group_nm3			--belong_nm_3							
		,	@organization_group_nm4			--belong_nm_4					
		,	@organization_group_nm5			--belong_nm_5
		,	''								--supporter_cd
		,	'Supporter Name'				--supporter_nm		
		,	'Position'						--s_position_nm	
		,	'Job'							--s_job_nm	
		,	'Grade'							--s_grade_nm	
		,	'Classification'				--s_employee_typ_nm
	END
	ELSE
	BEGIN
		INSERT INTO #RESULT
		SELECT 
			''								--employee_cd
		,	'対象社員'						--employee_nm			
		,	'役職'							--position_nm			
		,	@organization_group_nm1			--belong_nm_1					
		,	@organization_group_nm2			--belong_nm_2					
		,	@organization_group_nm3			--belong_nm_3							
		,	@organization_group_nm4			--belong_nm_4					
		,	@organization_group_nm5			--belong_nm_5
		,	''								--supporter_cd
		,	'サポーター名'					--supporter_nm		
		,	'役職'							--s_position_nm	
		,	'等級'							--s_job_nm	
		,	'職種'							--s_grade_nm	
		,	'社員区分'						--s_employee_typ_nm
	END
	--
	INSERT INTO #RESULT
	SELECT 
		EMPLOYEE.employee_cd			
	,	ISNULL(EMPLOYEE.employee_nm,'')			
	,	ISNULL(EMPLOYEE.position_nm,'')
	,	CASE
			WHEN @use_typ_group_1 = 1 THEN 	ISNULL(EMPLOYEE.belong_nm_1,'')
			ELSE ''
		END	
	,	CASE
			WHEN @use_typ_group_2 = 1 THEN 	ISNULL(EMPLOYEE.belong_nm_2,'')
			ELSE ''
		END	
	,	CASE
			WHEN @use_typ_group_3 = 1 THEN 	ISNULL(EMPLOYEE.belong_nm_3,'')
			ELSE ''
		END
	,	CASE
			WHEN @use_typ_group_4 = 1 THEN 	ISNULL(EMPLOYEE.belong_nm_4,'')
			ELSE ''
		END
	,	CASE
			WHEN @use_typ_group_5 = 1 THEN 	ISNULL(EMPLOYEE.belong_nm_5,'')
			ELSE ''
		END
	--
	,	#F3020.supporter_cd		
	,	ISNULL(SUPPORTER.employee_nm,'')		
	,	ISNULL(SUPPORTER.position_nm,'')		
	,	ISNULL(SUPPORTER.grade_nm,'')			
	,	ISNULL(SUPPORTER.job_nm,'')		
	,	ISNULL(SUPPORTER.employee_typ_nm,'')				
	FROM #M0070H AS EMPLOYEE
	LEFT JOIN #F3020 ON (
		EMPLOYEE.company_cd		=	#F3020.company_cd		
	AND EMPLOYEE.employee_cd	=	#F3020.employee_cd		
	)
	LEFT JOIN #M0070H AS SUPPORTER ON (
		#F3020.company_cd		=	SUPPORTER.company_cd
	AND #F3020.supporter_cd		=	SUPPORTER.employee_cd
	)
	WHERE
		EMPLOYEE.company_cd		=	@P_company_cd
	AND EMPLOYEE.employee_cd	=	@employee_cd

	--[0]
	SELECT
		employee_nm			
	,	position_nm			
	,	belong_nm_1			
	,	belong_nm_2			
	,	belong_nm_3			
	,	belong_nm_4			
	,	belong_nm_5	
	,	supporter_nm		
	,	s_position_nm	
	,	s_job_nm	
	,	s_grade_nm	
	,	s_employee_typ_nm	
	,	@P_language					AS	language	--add vietdt 2022/08/22
	FROM #RESULT

	-- clean
	DROP TABLE #M0070H
	DROP TABLE #F3020
	DROP TABLE #RESULT
END

GO
