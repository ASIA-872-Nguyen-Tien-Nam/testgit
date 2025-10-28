DROP PROCEDURE [SPC_O0100_RPT18]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+TEST+
-- 
/****************************************************************************************************
*
 *  処理概要:  export csv file 社員マスタ (有期雇用契約)
 *
 *  作成日  ： 2024/04/11
 *  作成者  ： Quanlh
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_O0100_RPT18]
	@P_company_cd			SMALLINT		= 0
,	@P_language				NVARCHAR(2)		= N''
AS
BEGIN
	SET NOCOUNT ON;
	--
	CREATE TABLE #DATA (
		id							INT IDENTITY(1,1)
	,	employee_cd					NVARCHAR(50)
	,	employment_contract_no		NVARCHAR(50)
	,	detail_no					NVARCHAR(50)
	,	start_date					NVARCHAR(50)
	,	expiration_date				NVARCHAR(50)
	,	contract_renewal_kbn		NVARCHAR(50)
	,	reason_resignation			NVARCHAR(100)
	,	remarks						NVARCHAR(100)
	)

	--INSERT #DATA	
	IF (@P_language = N'en')
	BEGIN
		INSERT INTO #DATA
		SELECT 
			N'Employee Code' 			AS employee_cd								
		,	N'Employment Contract No'	AS employment_contract_no							
		,	N'Detail No' 				AS detail_no						
		,	N'Start Date'				AS start_date				
		,	N'Expiration Date'			AS expiration_date			
		,	N'Contract Renewal'			AS contract_renewal_kbn	
		,	N'Reason Resignation'		AS reason_resignation		
		,	N'Remarks'					AS remarks					
	END
	ELSE
	BEGIN
		INSERT INTO #DATA
		SELECT 
			N'社員コード' 				AS employee_cd							
		,	N'雇用契約番号'				AS employment_contract_no							
		,	N'明細番号' 					AS detail_no						
		,	N'雇用開始日'				AS start_date				
		,	N'雇用契約満了日'				AS expiration_date			
		,	N'契約更新の有無'				AS contract_renewal_kbn	
		,	N'退職理由'					AS reason_resignation		
		,	N'備考'						AS remarks		
	END
	--INSERT #DATA 
	INSERT INTO #DATA
	SELECT 
		ISNULL(M0088.employee_cd,N'')
	,	ISNULL(M0088.employment_contract_no,0)
	,	ISNULL(M0088.detail_no,0)	
	,	FORMAT(NULLIF(start_date,N'1900-01-01'), 'yyyy/MM/dd')			AS start_date
	,	FORMAT(NULLIF(expiration_date,N'1900-01-01'), 'yyyy/MM/dd')		AS expiration_date
	,	ISNULL(M0088.contract_renewal_kbn,0)
	,	ISNULL(M0088.reason_resignation,N'')
	,	ISNULL(M0088.remarks,N'')
	FROM M0088
	WHERE 
		M0088.company_cd			=	@P_company_cd
	AND M0088.del_datetime IS NULL
	ORDER BY 
		M0088.employee_cd

	--[0]
	SELECT
		#DATA.employee_cd				
	,	#DATA.employment_contract_no		
	,	#DATA.detail_no					
	,	#DATA.start_date				
	,	#DATA.expiration_date			
	,	#DATA.contract_renewal_kbn	
	,	#DATA.reason_resignation		
	,	#DATA.remarks		
	FROM #DATA
	ORDER BY
		id
END
GO

