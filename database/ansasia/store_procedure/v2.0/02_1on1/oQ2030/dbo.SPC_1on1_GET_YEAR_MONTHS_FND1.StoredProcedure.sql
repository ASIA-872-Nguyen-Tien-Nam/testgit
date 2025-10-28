DROP PROCEDURE [SPC_1on1_GET_YEAR_MONTHS_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_1on1_GET_YEAR_MONTHS_INQ1 2020,740
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET ALL MONTH OF YEAR
--*  
--*  作成日/create date			:	2020/12/18						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--* 
--****************************************************************************************
CREATE PROCEDURE [SPC_1on1_GET_YEAR_MONTHS_FND1]
	-- Add the parameters for the stored procedure here
	@P_fiscal_year				smallint			=	0
,	@P_company_cd				smallint			=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@beginning_date			date				=	NULL
	,	@date_from				date				=	NULL
	,	@date_to				date				=	NULL
	,	@date_temp				date				=	NULL
	,	@check_eo_month			int					=	0
	,	@day_start				int					=	0
	,	@day_end				int					=	0
	,	@date_fr_temp			date				=	NULL
	,	@date_to_temp			date				=	NULL
	--
	CREATE TABLE #RESULT (
		month_num		int
	,	date_from		date
	,	date_to			date
	)
	--
	SELECT 
		--@beginning_date = M0100.beginning_date
		@beginning_date = M9100.[1on1_beginning_date] 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	--
	IF @beginning_date IS NOT NULL
	BEGIN
		SET @date_from = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		SET @date_to = DATEADD(DD,-1,DATEADD(YYYY,1,@date_from))
	END
	ELSE
	BEGIN 
		SET @date_from = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/01/01') AS DATE)
		SET @date_to = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/12/31') AS DATE)
	END
	--
	SET @day_start = FORMAT(@beginning_date,'dd')
	SET @day_end   = FORMAT(@date_to,'dd')
	--
	IF (@day_start IN (29,30))
	BEGIN
		SET @check_eo_month = 1
	END
	--
	IF (@day_start = 31)
	BEGIN
		SET @check_eo_month = 2
	END
	--
	SET @date_temp = @date_from
	IF(@check_eo_month = 2)
	BEGIN
		WHILE @date_temp < @date_to
		BEGIN
			SET @date_fr_temp	=	EOMONTH(@date_temp)
			SET	@date_to_temp	=	DATEADD(DD,-1,EOMONTH(DATEADD(MM,1,@date_temp)))
			--
			INSERT INTO #RESULT
			SELECT 
				MONTH(@date_temp)
			,	@date_fr_temp		
			,	@date_to_temp		
			-- 
			SET @date_temp = @date_to_temp
		END
	END
	ELSE
	BEGIN
		WHILE @date_temp <= @date_to
		BEGIN
			IF(@check_eo_month = 0)
			BEGIN
				INSERT INTO #RESULT
				SELECT 
					MONTH(@date_temp)
				,	@date_temp
				,	DATEADD(DD,-1,DATEADD(MM,1,@date_temp))
				-- PLUS 1 MONTH
				SET @date_temp = DATEADD(MM,1,@date_temp)
			END
			--
			IF(@check_eo_month = 1)
			BEGIN
				IF(MONTH(@date_temp) = 2)
				BEGIN
					SET @date_to_temp =  CAST((CAST(FORMAT(DATEADD(DD,-1,DATEADD(MM,1,@date_temp)),'yyyy/MM') AS nvarchar(7)) + '/' + CONVERT(VARCHAR(2),@day_end)) AS DATE)
				END
				ELSE
				BEGIN
					SET @date_to_temp = DATEADD(DD,-1,DATEADD(MM,1,@date_temp))
				END
				--
				INSERT INTO #RESULT
				SELECT 
					MONTH(@date_temp)
				,	@date_temp
				,	@date_to_temp   --DATEADD(DD,-1,DATEADD(MM,1,@date_temp))
				-- PLUS 1 MONTH
				IF(MONTH(@date_temp) = 2)
				BEGIN
					SET @date_temp = DATEADD(DD,1,@date_to_temp)
				END
				ELSE
				BEGIN
					SET @date_temp = DATEADD(MM,1,@date_temp)
				END
			END
		END
	END
	--[0]
	SELECT * FROM #RESULT
	-- DROP TABLE
	DROP TABLE #RESULT
END
GO
