DROP PROCEDURE [dbo].[SPC_rI1021_INQ2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  個人マスタ：rI1021 - Refer
 *
 *  作成日  ：2023/04/05
 *  作成者  ：ANS-ASIA quangnd
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_rI1021_INQ2]
	@P_company_cd		SMALLINT		=	0
,	@P_fiscal_year		smallint		=	0
,	@P_report_kind		smallint		=	0
,	@P_group_cd			smallint		=	0
,	@P_employee_cd		NVARCHAR(10)	=	''
AS
BEGIN
	-- Declare the return variable here
	DECLARE 
		@beginning_date							datetime		=	null
	,	@start_date								datetime		=	null
	,	@end_date								datetime		=	null
	,	@w_company_out_dt						datetime		=	null
	,	@w_company_in_dt						datetime		=	null
	,	@w_today								date			=	NULL
	,	@w_status								smallint		=	0
	--
	SELECT 
		@beginning_date = M9100.[report_beginning_date]		-- edited by viettd 2021/04/22 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	-- CACULATE BEGIN AND END OF DATE
	IF @beginning_date IS NOT NULL
	BEGIN
		SET @start_date = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		SET @end_date = DATEADD(DD,-1,DATEADD(YYYY,1,@start_date))
	END
	ELSE
	BEGIN 
		SET @start_date		= CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/01/01') AS DATE)
		SET @end_date		= CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/12/31') AS DATE)
	END
	--
	SELECT 
		@w_company_in_dt	= company_in_dt
	,	@w_company_out_dt	= company_out_dt
	FROM M0070
	WHERE
		company_cd	= @P_company_cd
	AND	employee_cd	= @P_employee_cd
	AND del_datetime IS NULL
	--
	IF(@P_employee_cd <> '')
	BEGIN
		SET @w_status = 1
	END
	--
	IF(@w_company_in_dt > @end_date)
	BEGIN
		SET @w_status = 87
	END
	IF(@w_company_out_dt IS NOT NULL)
	BEGIN
		IF(@w_company_out_dt < @start_date)
		BEGIN
			SET @w_status = 87
		END
	END
	--get deadline f4100
	SELECT
		@w_today = MAX(deadline_date)
	FROM F4100
	WHERE
		company_cd	= @P_company_cd
	AND fiscal_year = @P_fiscal_year
	AND	group_cd	= @P_group_cd
	AND	report_kind	= @P_report_kind
	AND user_typ	= 1
	AND del_datetime IS NULL
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
	-- #M0070H
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @w_today,@P_employee_cd,@P_company_cd
	--
	IF EXISTS (SELECT 1 FROM #M0070H)
	BEGIN
		SELECT 
			company_cd		
		,	employee_cd		
		,	employee_nm	
		,	employee_typ_nm					
		,	belong_nm_1		
		,	belong_nm_2		
		,	belong_nm_3		
		,	belong_nm_4		
		,	belong_nm_5		
		,	job_nm			
		,	position_nm		
		,	grade_nm
		,	@w_status						as [status]
		FROM #M0070H
	END
	ELSE
	BEGIN
		SELECT
			@w_status						as [status]
	END

END
GO
