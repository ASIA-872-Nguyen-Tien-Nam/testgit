IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_mI1010_INQ1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_mI1010_INQ1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：mi1010 - Refer
 *
 *  作成日  ：	2020/12/24
 *  作成者  ：	ANS-ASIA DUONGNTT
 *
 *  更新日  ：	2021/06/16
 *  更新者  ：	viettd
 *  更新内容：	don't show suppoter from F0100 , only show suppoter from F0100
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_mI1010_INQ1]
	@P_company_cd		SMALLINT		=	0
,	@P_fiscal_year		SMALLINT		=	0	
,	@P_employee_cd		NVARCHAR(10)	=	''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@beginning_date					DATE				=	NULL
	,	@year_month_day					DATE				=	NULL
	--
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
	,	employee_ab_nm					nvarchar(10)
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
	CREATE TABLE #RESULT(
		id								INT IDENTITY(1,1)
	,	company_cd						SMALLINT
	,	fiscal_year						SMALLINT
	,	employee_cd						NVARCHAR(10)
	,	supporter_cd					NVARCHAR(10)
	,	supporter_nm					NVARCHAR(200)
	,	other_browsing_kbn				SMALLINT
	--
	,	job_cd							SMALLINT				--job_cd
	,	job_nm							NVARCHAR(50)			--job_nm
	,	position_cd						INT						--position_cd
	,	position_nm						NVARCHAR(50)			--position_nm
	,	grade							SMALLINT				--grade
	,	grade_nm						NVARCHAR(50)			--grade_nm
	,	employee_typ					SMALLINT				--employee_typ
	,	employee_typ_nm					NVARCHAR(50)			--employee_typ_nm
	)
	--
	SELECT 
		@beginning_date = M9100.beginning_date 
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
	
	-- comment out by viettd 2021/06/16
	--IF NOT EXISTS (SELECT 1 FROM F3020
	--						WHERE
	--							F3020.company_cd	=	@P_company_cd
	--						AND	F3020.fiscal_year	=	@P_fiscal_year
	--						AND F3020.employee_cd	=	@P_employee_cd
	--						AND	F3020.del_datetime IS NULL)
	--BEGIN
	--	INSERT INTO #RESULT
	--	SELECT DISTINCT
	--		F0100.company_cd			
	--	,	F0100.fiscal_year			
	--	,	F0100.employee_cd			
	--	,	F0100.rater_employee_cd_1		
	--	,	#M0070H.employee_nm
	--	,	0
	--	--
	--	,	#M0070H.job_cd		
	--	,	#M0070H.job_nm			
	--	,	#M0070H.position_cd	
	--	,	#M0070H.position_nm	
	--	,	#M0070H.grade	
	--	,	#M0070H.grade_nm	
	--	,	#M0070H.employee_typ	
	--	,	#M0070H.employee_typ_nm
	--	FROM F0100
	--	LEFT OUTER JOIN #M0070H ON (
	--		F0100.company_cd			=	#M0070H.company_cd
	--	AND F0100.rater_employee_cd_1	=	#M0070H.employee_cd
	--	)
	--	WHERE
	--		F0100.company_cd	=	@P_company_cd
	--	AND	F0100.fiscal_year	=	@P_fiscal_year
	--	AND F0100.employee_cd	=	@P_employee_cd
	--	AND	F0100.del_datetime IS NULL
	--END
	--
	INSERT INTO #RESULT
	SELECT
		F3020.company_cd			
	,	F3020.fiscal_year			
	,	F3020.employee_cd			
	,	F3020.supporter_cd		
	,	#M0070H.employee_nm
	,	ISNULL(F3020.other_browsing_kbn,0)	
	,	#M0070H.job_cd			
	,	#M0070H.job_nm			
	,	#M0070H.position_cd		
	,	#M0070H.position_nm	
	,	#M0070H.grade	
	,	#M0070H.grade_nm		
	,	#M0070H.employee_typ	
	,	#M0070H.employee_typ_nm
	FROM F3020
	LEFT OUTER JOIN #M0070H ON (
		F3020.company_cd	=	#M0070H.company_cd
	AND F3020.supporter_cd	=	#M0070H.employee_cd
	)
	WHERE
		F3020.company_cd	=	@P_company_cd
	AND	F3020.fiscal_year	=	@P_fiscal_year
	AND F3020.employee_cd	=	@P_employee_cd
	AND	F3020.del_datetime IS NULL
	ORDER BY 
		F3020.supporter_cd	
	--[0]
	SELECT
		employee_cd
	,	employee_nm
	,	job_cd
	,	job_nm
	,	position_cd
	,	position_nm
	,	grade
	,	grade_nm
	,	employee_typ
	,	employee_typ_nm
	FROM #M0070H
	WHERE
		#M0070H.company_cd	=	@P_company_cd
	AND #M0070H.employee_cd	=	@P_employee_cd	
	--[1]
	SELECT TOP 30
		id
	,	company_cd			
	,	fiscal_year			
	,	employee_cd			
	,	supporter_cd
	,	supporter_nm		
	,	other_browsing_kbn	
	--
	,	job_cd				
	,	job_nm				
	,	position_cd			
	,	position_nm			
	,	grade				
	,	grade_nm			
	,	employee_typ		
	,	employee_typ_nm						
	FROM #RESULT
	-- clean
	DROP TABLE #RESULT
END
GO