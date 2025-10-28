DROP PROCEDURE [SPC_O0100_RPT24]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+TEST+
-- 
/****************************************************************************************************
*
 *  処理概要:  export csv file 社員マスタ (賞罰)
 *
 *  作成日  ： 2024/04/08
 *  作成者  ： Quanlh
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_O0100_RPT24]
	@P_company_cd			SMALLINT		= 0
,	@P_language				NVARCHAR(2)		= N''
AS
BEGIN
	SET NOCOUNT ON;
	--
	CREATE TABLE #DATA (
		id							INT IDENTITY(1,1)
	,	employee_cd					NVARCHAR(20)
	,	detail_no					NVARCHAR(20)
	,	reward_punishment_typ		NVARCHAR(50)
	,	decision_date				NVARCHAR(50)
	,	reason						NVARCHAR(100)
	,	remarks						NVARCHAR(100)
	)

	--INSERT #DATA	
	IF (@P_language = N'en')
	BEGIN
		INSERT INTO #DATA
		SELECT 
			N'Employee Code' 			AS employee_cd					
		,	N'Detail No' 				AS detail_no					
		,	N'Reward Punishment Type' 	AS reward_punishment_typ			
		,	N'Decision Date' 			AS decision_date				
		,	N'Reason' 					AS reason									
		,	N'Remarks' 					AS remarks							
	END
	ELSE
	BEGIN
		INSERT INTO #DATA
		SELECT 
			N'社員コード' 				AS employee_cd					
		,	N'明細番号' 					AS detail_no					
		,	N'賞罰種別' 					AS reward_punishment_typ		
		,	N'賞罰決定日' 				AS decision_date			
		,	N'賞罰理由' 					AS reason								
		,	N'備考' 						AS remarks	
	END
	--INSERT #DATA 
	INSERT INTO #DATA
	SELECT 
		ISNULL(M0093.employee_cd,N'')				
	,	ISNULL(detail_no,0)	
	,	ISNULL(reward_punishment_typ,0)	
	,	FORMAT(NULLIF(decision_date,N'1900-01-01'), 'yyyy/MM/dd')	
	,	ISNULL(reason,N'')
	,	ISNULL(remarks,N'')
	FROM M0093
	WHERE 
		M0093.company_cd			=	@P_company_cd
	AND M0093.del_datetime IS NULL
	ORDER BY 
		CASE (SELECT 1 WHERE M0093.employee_cd NOT LIKE '%[^0-9]%')
		   WHEN 1 
		   THEN CAST(M0093.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	M0093.employee_cd
	,	M0093.detail_no

	--[0]
	SELECT
		#DATA.employee_cd				
	,	#DATA.detail_no					
	,	#DATA.reward_punishment_typ	
	,	#DATA.decision_date					
	,	#DATA.reason			
	,	#DATA.remarks							
	FROM #DATA
	ORDER BY
		id
END
GO

