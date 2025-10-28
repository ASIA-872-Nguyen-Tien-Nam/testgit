DROP PROCEDURE [SPC_O0100_RPT20]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+TEST+
-- 
/****************************************************************************************************
*
 *  処理概要:  export csv file 社員マスタ (給与)
 *
 *  作成日  ： 2024/04/08
 *  作成者  ： Quanlh
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_O0100_RPT20]
	@P_company_cd			SMALLINT		= 0
,	@P_language				NVARCHAR(2)		= N''
AS
BEGIN
	SET NOCOUNT ON;
	--
	CREATE TABLE #DATA (
		id							INT IDENTITY(1,1)
	,	employee_cd					NVARCHAR(20)
	,	base_salary					NVARCHAR(20)
	,	basic_annual_income			NVARCHAR(50)
	)

	--INSERT #DATA	
	IF (@P_language = N'en')
	BEGIN
		INSERT INTO #DATA
		SELECT 
			N'Employee Code' 			AS employee_cd								
		,	N'Base Balary' 				AS base_salary									
		,	N'Basic Annual Income' 		AS basic_annual_income							
	END
	ELSE
	BEGIN
		INSERT INTO #DATA
		SELECT 
			N'社員コード' 				AS employee_cd							
		,	N'基本給' 					AS base_salary								
		,	N'基本年収' 					AS basic_annual_income	
	END
	--INSERT #DATA 
	INSERT INTO #DATA
	SELECT 
		ISNULL(M0092.employee_cd,N'')				
	,	REPLACE(RTRIM(LTRIM(ISNULL(M0092.base_salary,0))),'.00','')			AS base_salary 
	,	REPLACE(RTRIM(LTRIM(ISNULL(M0092.basic_annual_income,0))),'.00','') AS basic_annual_income
	FROM M0092
	WHERE 
		M0092.company_cd			=	@P_company_cd
	AND M0092.del_datetime IS NULL
	ORDER BY 
		M0092.employee_cd

	--[0]
	SELECT
		#DATA.employee_cd				
	,	#DATA.base_salary					
	,	#DATA.basic_annual_income							
	FROM #DATA
	ORDER BY
		id
END

GO

