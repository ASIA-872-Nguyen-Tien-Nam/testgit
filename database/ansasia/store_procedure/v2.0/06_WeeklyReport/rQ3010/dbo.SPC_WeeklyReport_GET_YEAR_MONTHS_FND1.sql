DROP PROCEDURE [SPC_WeeklyReport_GET_YEAR_MONTHS_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_WeeklyReport_GET_YEAR_MONTHS_FND1 2023,782,'721'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET ALL MONTH OF YEAR
--*  
--*  作成日/create date			:	2023/05/24						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--* 
--****************************************************************************************
CREATE PROCEDURE [SPC_WeeklyReport_GET_YEAR_MONTHS_FND1]
	-- Add the parameters for the stored procedure here
	@P_fiscal_year				smallint			=	0
,	@P_company_cd				smallint			=	0
,	@P_cre_user					nvarchar(50)		=	''
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
	,	@w_language				smallint			=	0
	--
	CREATE TABLE #RESULT (
		month_num		int
	,	date_from		date
	,	date_to			date
	)
	--
	SELECT 
		@w_language					=	ISNULL(S0010.[language],0)
	FROM S0010
	LEFT OUTER JOIN M0070 ON (
		S0010.company_cd		=	M0070.company_cd
	AND S0010.employee_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	WHERE 
		S0010.company_cd	= @P_company_cd 
	AND S0010.user_id		= @P_cre_user
	AND S0010.del_datetime IS NULL

	--
	SELECT 
		@beginning_date = M9100.report_beginning_date 
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
	SELECT
		month_num
	,	CASE 
			WHEN month_num = 1
			THEN IIF(@w_language = 2, N'Jan',N'1月')
			WHEN month_num = 2
			THEN IIF(@w_language = 2, N'Feb',N'2月')
			WHEN month_num = 3
			THEN IIF(@w_language = 2, N'Mar',N'3月')
			WHEN month_num = 4
			THEN IIF(@w_language = 2, N'Apr',N'4月')
			WHEN month_num = 5
			THEN IIF(@w_language = 2, N'May',N'5月')
			WHEN month_num = 6
			THEN IIF(@w_language = 2, N'Jun',N'6月')
			WHEN month_num = 7
			THEN IIF(@w_language = 2, N'Jul',N'7月')
			WHEN month_num = 8
			THEN IIF(@w_language = 2, N'Aug',N'8月')
			WHEN month_num = 9
			THEN IIF(@w_language = 2, N'Sep',N'9月')
			WHEN month_num = 10
			THEN IIF(@w_language = 2, N'Oct',N'10月')
			WHEN month_num = 11
			THEN IIF(@w_language = 2, N'Nov',N'11月')
			WHEN month_num = 12
			THEN IIF(@w_language = 2, N'Dec',N'12月')
			ELSE SPACE(0)
		END			AS	month_num_nm
	,	date_from
	,	date_to	
	FROM #RESULT
	-- DROP TABLE
	DROP TABLE #RESULT
END
GO
