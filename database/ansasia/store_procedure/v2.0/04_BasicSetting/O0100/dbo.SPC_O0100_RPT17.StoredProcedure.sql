DROP PROCEDURE [SPC_O0100_RPT17]
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
 *  作成日  ： 2024/04/08
 *  作成者  ： Quanlh
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_O0100_RPT17]
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
	,	leave_absence_startdate		NVARCHAR(50)
	,	leave_absence_enddate		NVARCHAR(50)
	,	remarks						NVARCHAR(100)
	)

	--INSERT #DATA	
	IF (@P_language = N'en')
	BEGIN
		INSERT INTO #DATA
		SELECT 
			N'Employee Code' 			AS employee_cd					
		,	N'Detail No' 				AS detail_no					
		,	N'Reward Punishment Type' 	AS leave_absence_startdate				
		,	N'Leave Absence End Date' 	AS leave_absence_enddate												
		,	N'Remarks' 					AS remarks							
	END
	ELSE
	BEGIN
		INSERT INTO #DATA
		SELECT 
			N'社員コード' 				AS employee_cd					
		,	N'明細番号' 					AS detail_no					
		,	N'休職開始日' 				AS leave_absence_startdate			
		,	N'休職終了日' 				AS leave_absence_enddate								
		,	N'休職事由' 						AS remarks	
	END
	--INSERT #DATA 
	INSERT INTO #DATA
	SELECT 
		ISNULL(M0087.employee_cd,N'')				
	,	ISNULL(detail_no,0)	
	,	FORMAT(NULLIF(leave_absence_startdate,N'1900-01-01'), 'yyyy/MM/dd')
	,	FORMAT(NULLIF(leave_absence_enddate,N'1900-01-01'), 'yyyy/MM/dd')
	,	ISNULL(remarks,N'')
	FROM M0087
	WHERE 
		M0087.company_cd			=	@P_company_cd
	AND M0087.del_datetime IS NULL
	ORDER BY 
		CASE (SELECT 1 WHERE M0087.employee_cd NOT LIKE '%[^0-9]%')
		   WHEN 1 
		   THEN CAST(M0087.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	M0087.employee_cd
	,	M0087.detail_no

	--[0]
	SELECT
		#DATA.employee_cd				
	,	#DATA.detail_no					
	,	#DATA.leave_absence_startdate	
	,	#DATA.leave_absence_enddate							
	,	#DATA.remarks							
	FROM #DATA
	ORDER BY
		id
END
GO

