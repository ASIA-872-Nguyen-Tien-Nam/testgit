DROP PROCEDURE [SPC_O0100_RPT15]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+TEST+
-- 
/****************************************************************************************************
*
 *  処理概要:  export csv file 社員マスタ (通勤)
 *
 *  作成日  ： 2024/04/12
 *  作成者  ： Quanlh
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_O0100_RPT15]
	@P_company_cd			SMALLINT		= 0
,	@P_language				NVARCHAR(2)		= N''
AS
BEGIN
	SET NOCOUNT ON;
	--
	CREATE TABLE #DATA (
		id										INT IDENTITY(1,1)
	,	employee_cd								NVARCHAR(20)
	,	detail_no								NVARCHAR(20)
	,	commuting_method						NVARCHAR(50)
	,	commuting_distance						NVARCHAR(50)
	,	drivinglicense_renewal_deadline			NVARCHAR(50)
	,	commuting_method_detail					NVARCHAR(50)
	,	departure_point							NVARCHAR(50)
	,	arrival_point							NVARCHAR(50)
	,	commuter_ticket_classification			NVARCHAR(50)
	,	commuting_expenses						NVARCHAR(50)
	)

	--INSERT #DATA	
	IF (@P_language = N'en')
	BEGIN
		INSERT INTO #DATA
		SELECT 
			N'Employee Code' 							AS employee_cd					
		,	N'Detail No' 								AS detail_no					
		,	N'Commuting Method' 						AS commuting_method						
		,	N'Commuting Distance' 						AS commuting_distance														
		,	N'Drivinglicense Renewal Deadline' 			AS drivinglicense_renewal_deadline	
		,	N'Commuting Method Detail' 					AS commuting_method_detail			
		,	N'Departure Point' 							AS departure_point					
		,	N'Arrival Point' 							AS arrival_point					
		,	N'Commuter Ticket Classification' 			AS commuter_ticket_classification			
		,	N'Commuting Expenses' 						AS commuting_expenses				

	END
	ELSE
	BEGIN
		INSERT INTO #DATA
		SELECT 
			N'社員コード' 					AS employee_cd					
		,	N'明細番号' 						AS detail_no					
		,	N'通勤手段' 						AS commuting_method						
		,	N'通勤距離' 						AS commuting_distance														
		,	N'運転免許証更新期限' 			AS drivinglicense_renewal_deadline	
		,	N'通勤手段詳細' 					AS commuting_method_detail			
		,	N'出発地' 						AS departure_point					
		,	N'到着地' 						AS arrival_point					
		,	N'定期券区分' 					AS commuter_ticket_classification				
		,	N'通勤費' 						AS commuting_expenses	
	END
	--INSERT #DATA 
	INSERT INTO #DATA
	SELECT 
		ISNULL(M0084.employee_cd,N'')				
	,	ISNULL(detail_no,0)	
	,	ISNULL(commuting_method,0)	
	,	ISNULL(commuting_distance,0)	
	,	FORMAT(NULLIF(drivinglicense_renewal_deadline,N'1900-01-01'), 'yyyy/MM/dd')
	,	ISNULL(commuting_method_detail,N'')
	,	ISNULL(departure_point,N'')
	,	ISNULL(arrival_point,N'')
	,	ISNULL(commuter_ticket_classification,0)
	,	REPLACE(RTRIM(LTRIM(ISNULL(commuting_expenses,0))),'.00','')
	FROM M0084
	WHERE 
		M0084.company_cd			=	@P_company_cd
	AND M0084.del_datetime IS NULL
	ORDER BY 
		M0084.employee_cd
	,	M0084.detail_no

	--[0]
	SELECT
		#DATA.employee_cd				
	,	#DATA.detail_no					
	,	#DATA.commuting_method						
	,	#DATA.commuting_distance									
	,	#DATA.drivinglicense_renewal_deadline	
	,	#DATA.commuting_method_detail			
	,	#DATA.departure_point					
	,	#DATA.arrival_point					
	,	#DATA.commuter_ticket_classification		
	,	#DATA.commuting_expenses	
	FROM #DATA
	ORDER BY
		id
END
GO

