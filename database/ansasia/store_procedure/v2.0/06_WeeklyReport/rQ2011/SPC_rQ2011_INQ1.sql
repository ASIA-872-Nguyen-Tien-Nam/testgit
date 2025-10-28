DROP PROCEDURE [dbo].[SPC_rQ2011_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  個人マスタ：rQ2011 - Refer
 *
 *  作成日  ：2023/04/05
 *  作成者  ：ANS-ASIA quangnd
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_rQ2011_INQ1]
	@P_company_cd		SMALLINT		= 0
,	@P_employee_cd		NVARCHAR(10)	= ''
AS
BEGIN
	-- Declare the return variable here
	DECLARE 
		@w_today					date		= GETDATE()
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
		,	1						as [status]
		FROM #M0070H
	END
	ELSE
	BEGIN
		SELECT
			0						as [status]
	END

END
GO
