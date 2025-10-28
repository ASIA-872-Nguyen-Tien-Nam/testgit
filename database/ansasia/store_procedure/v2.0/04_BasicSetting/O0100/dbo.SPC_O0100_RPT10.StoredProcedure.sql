DROP PROCEDURE [SPC_O0100_RPT10]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+TEST+
-- 
/****************************************************************************************************
 *
 *  ˆ—ŠT—v:  export csv file
 *
 *  ì¬“ú  F 2018/10/01
 *  ì¬ŽÒ  F sondh
 *
 *  XV“ú  F
 *  XVŽÒ  F
 *  XV“à—eF
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_O0100_RPT10]
	@P_company_cd			SMALLINT			= 0
,	@P_language				NVARCHAR(2)		= ''
AS
BEGIN
	SET NOCOUNT ON;
	--
	CREATE TABLE #DATA (
		id						INT IDENTITY(1,1)
	,	employee_cd				NVARCHAR(20)
	,	[password]				NVARCHAR(20)
	)

	--INSERT #DATA	
	IF (@P_language = 'en')
	BEGIN
		INSERT INTO #DATA
		SELECT 
			'Employee Code'					
		,	'Password'						
		
	END
	ELSE
	BEGIN
		INSERT INTO #DATA
		SELECT 
			'社員コード'									
		,	'パスワード'					
	END						   		
	--INSERT #DATA 
	INSERT INTO #DATA
	SELECT 				
		ISNULL(employee_cd,'')
	,	ISNULL([password],'')				
	FROM S0010
	WHERE 
		company_cd	=	@P_company_cd
	AND authority_typ <> 4
	AND del_datetime IS NULL
	ORDER BY 
		CASE (SELECT 1 WHERE S0010.employee_cd NOT LIKE '%[^0-9]%')
		   WHEN 1 
		   THEN CAST(S0010.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	S0010.employee_cd

	--[0]
	SELECT
		#DATA.employee_cd											
	,	#DATA.[password]				
	FROM #DATA
	ORDER BY
		id
END

GO
