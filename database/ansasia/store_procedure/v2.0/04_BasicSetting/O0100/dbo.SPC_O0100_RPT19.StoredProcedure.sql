DROP PROCEDURE [SPC_O0100_RPT19]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+TEST+
-- 
/****************************************************************************************************
*
 *  処理概要:  export csv file 社員マスタ (社会保険)
 *
 *  作成日  ： 2024/04/08
 *  作成者  ： Quanlh
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_O0100_RPT19]
	@P_company_cd			SMALLINT		= 0
,	@P_language				NVARCHAR(2)		= N''
AS
BEGIN
	SET NOCOUNT ON;
	--
	CREATE TABLE #DATA (
		id										INT IDENTITY(1,1)
	,	employee_cd								NVARCHAR(20)
	,	employment_insurance_no					NVARCHAR(50)
	,	basic_pension_no						NVARCHAR(50)
	,	employment_insurance_status				NVARCHAR(50)
	,	health_insurance_status					NVARCHAR(50)
	,	health_insurance_reference_no			NVARCHAR(50)
	,	employees_pension_insurance_status		NVARCHAR(50)
	,	employees_pension_reference_no			NVARCHAR(50)
	,	welfare_pension_status					NVARCHAR(50)
	,	employees_pension_member_no				NVARCHAR(50)
	,	social_insurance_kbn					NVARCHAR(20)
	,	detail_no								NVARCHAR(20)
	,	joining_date							NVARCHAR(50)
	,	date_of_loss							NVARCHAR(50)
	,	reason_for_loss_kbn						NVARCHAR(50)
	,	reason_for_loss							NVARCHAR(50)
	)

	--INSERT #DATA	
	IF (@P_language = N'en')
	BEGIN
		INSERT INTO #DATA
		SELECT 
			N'Employee Code' 						AS employee_cd	
		,	N'Employment Insurance' 				AS employment_insurance_no				
		,	N'Basic Pension No' 					AS basic_pension_no					
		,	N'Employment Insurance Status' 			AS employment_insurance_status				
		,	N'Health Insurance Status' 				AS health_insurance_status					
		,	N'Health Insurance Reference No' 		AS health_insurance_reference_no				
		,	N'Employees Pension Insurance Status'	AS employees_pension_insurance_status				
		,	N'Employees Pension Reference No' 		AS employees_pension_reference_no		
		,	N'Welfare Pension Status' 				AS welfare_pension_status				
		,	N'Employees Pension Member No' 			AS employees_pension_member_no			
		,	N'Social Insurance' 					AS social_insurance_kbn	
		,	N'Detail No' 							AS detail_no						
		,	N'Joining Date' 						AS joining_date			
		,	N'Date Of Loss' 						AS date_of_loss					
		,	N'Reason For Loss' 						AS reason_for_loss_kbn				
		,	N'Reason For Loss' 						AS reason_for_loss						
	END
	ELSE
	BEGIN
		INSERT INTO #DATA
		SELECT 
			N'社員コード' 							AS employee_cd	
		,	N'雇用保険番号' 							AS employment_insurance_no				
		,	N'基礎年金番号' 							AS basic_pension_no					
		,	N'雇用保険加入状況' 						AS employment_insurance_status				
		,	N'健康保険加入状況' 						AS health_insurance_status					
		,	N'健康保険被保険者整理番号' 				AS health_insurance_reference_no				
		,	N'厚生年金保険加入状況' 					AS employees_pension_insurance_status				
		,	N'厚生年金保険被保険者整理番号' 			AS employees_pension_reference_no		
		,	N'厚生年金基金加入状況' 					AS welfare_pension_status				
		,	N'厚生年金基金加入員番号' 				AS employees_pension_member_no	
		,	N'区分' 									AS social_insurance_kbn	
		,	N'明細番号' 								AS detail_no							
		,	N'加入日' 								AS joining_date			
		,	N'喪失日' 								AS date_of_loss					
		,	N'喪失理由区分' 							AS reason_for_loss_kbn				
		,	N'喪失理由' 								AS reason_for_loss			
	END
	--INSERT #DATA
	INSERT INTO #DATA
	SELECT 
		ISNULL(M0090.employee_cd,N'')				
	,	ISNULL(M0090.employment_insurance_no,N'')				
	,	ISNULL(M0090.basic_pension_no,N'')					
	,	ISNULL(M0090.employment_insurance_status,0)				
	,	ISNULL(M0090.health_insurance_status,0)					
	,	ISNULL(M0090.health_insurance_reference_no,0)			
	,	ISNULL(M0090.employees_pension_insurance_status,0)		
	,	ISNULL(M0090.employees_pension_reference_no,0)		
	,	ISNULL(M0090.welfare_pension_status,0)				
	,	ISNULL(M0090.employees_pension_member_no,0)	
	,	ISNULL(M0091.social_insurance_kbn,0)	
	,	ISNULL(M0091.detail_no,0)
	,	FORMAT(NULLIF(M0091.joining_date,N'1900-01-01'), 'yyyy/MM/dd')			
	,	FORMAT(NULLIF(M0091.date_of_loss,N'1900-01-01'), 'yyyy/MM/dd')						
	,	ISNULL(M0091.reason_for_loss_kbn,0)				
	,	ISNULL(M0091.reason_for_loss,0)			
	FROM M0090
	LEFT JOIN M0091 ON(
		M0090.company_cd	= M0091.company_cd
	AND M0090.employee_cd	= M0091.employee_cd
	AND M0091.del_datetime IS NULL
	)
	WHERE 
		M0090.company_cd			=	@P_company_cd
	AND M0090.del_datetime IS NULL
	ORDER BY 
		M0090.employee_cd

	--[0]
	SELECT
		#DATA.employee_cd				
	,	#DATA.employment_insurance_no				
	,	#DATA.basic_pension_no					
	,	#DATA.employment_insurance_status			
	,	#DATA.health_insurance_status				
	,	#DATA.health_insurance_reference_no			
	,	#DATA.employees_pension_insurance_status	
	,	#DATA.employees_pension_reference_no		
	,	#DATA.welfare_pension_status				
	,	#DATA.employees_pension_member_no	
	,	#DATA.social_insurance_kbn	
	,	#DATA.detail_no					
	,	#DATA.joining_date			
	,	#DATA.date_of_loss					
	,	#DATA.reason_for_loss_kbn				
	,	#DATA.reason_for_loss			
	FROM #DATA
	ORDER BY
		id
END
GO
