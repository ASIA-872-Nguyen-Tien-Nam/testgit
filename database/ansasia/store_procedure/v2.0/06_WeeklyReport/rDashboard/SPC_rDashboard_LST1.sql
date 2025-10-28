IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_rDashboard_LST1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_rDashboard_LST1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_rDashboard_LST1 782,'721',-1,-1
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET LIST REPORTS FOR REPOTER DASHBOARD
--*  
--*  作成日/create date			:	2023/05/08						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rDashboard_LST1]
	@P_company_cd		SMALLINT		=	0
,	@P_employee_cd		NVARCHAR(10)	=	''	-- LOGIN EMPLOYEE
,	@P_year				SMALLINT		=	-1
,	@P_month			SMALLINT		=	-1
AS
BEGIN
	--[0]
	DECLARE 
		@w_language			smallint		=	0	-- 1.JP 2.EN
	,	@w_year_month		int				=	0
	,	@w_today			date			=	GETDATE()
	--	

	SELECT 
		@w_language =	ISNULL(S0010.[language],1)
	FROM S0010
	WHERE 
		S0010.company_cd	=	@P_company_cd
	AND S0010.employee_cd	=	@P_employee_cd
	AND S0010.del_datetime IS NULL
	--
	CREATE TABLE #TABLE_RESULT(
		company_cd				smallint
	,	fiscal_year				smallint
	,	employee_cd				nvarchar(10)
	,	report_kind				smallint
	,	report_no				smallint
	,	year_from				int
	,	year_to					int
	,	year_month_from			int
	,	year_month_to			int
	)
	-- GET FROM REPORT_KIND IN (4,5)
	INSERT INTO #TABLE_RESULT
	SELECT 
		F4200.company_cd
	,	F4200.fiscal_year
	,	F4200.employee_cd
	,	F4200.report_kind
	,	F4200.report_no
	,	0
	,	0
	,	0
	,	0
	FROM F4200
	WHERE 
		F4200.company_cd	=	@P_company_cd
	AND F4200.employee_cd	=	@P_employee_cd
	AND F4200.report_kind IN (4,5)
	AND (
		(@P_year = -1)
	OR	(@P_year <> - 1 AND F4200.[year] = @P_year)
	)
	AND (
		(@P_month = -1)
	OR	(@P_month <> - 1 AND F4200.[month] = @P_month)
	)
	AND F4200.del_datetime IS NULL
	-- GET ALL FROM REPORT_KIND IN (1,2,3)
	INSERT INTO #TABLE_RESULT
	SELECT 
		F4200.company_cd
	,	F4200.fiscal_year
	,	F4200.employee_cd
	,	F4200.report_kind
	,	F4200.report_no
	,	CAST(CAST(CONVERT(nvarchar(8),F4100.start_date,112) AS NVARCHAR(4)) AS INT)
	,	CAST(CAST(CONVERT(nvarchar(8),F4100.deadline_date,112) AS NVARCHAR(4)) AS INT)
	,	CAST(CAST(CONVERT(nvarchar(8),F4100.start_date,112) AS NVARCHAR(6)) AS INT)
	,	CAST(CAST(CONVERT(nvarchar(8),F4100.deadline_date,112) AS NVARCHAR(6)) AS INT)
	FROM F4200
	LEFT OUTER JOIN F4110 ON (
		F4200.company_cd		=	F4110.company_cd
	AND F4200.fiscal_year		=	F4110.fiscal_year
	AND F4200.employee_cd		=	F4110.employee_cd	
	AND F4200.report_kind		=	F4110.report_kind	
	AND F4200.report_no			=	F4110.report_no		
	AND F4110.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4100 ON (
		F4110.company_cd		=	F4100.company_cd
	AND F4110.fiscal_year		=	F4100.fiscal_year
	AND F4110.group_cd			=	F4100.group_cd	
	AND F4110.report_kind		=	F4100.report_kind	
	AND F4110.report_no			=	F4100.detail_no		
	AND F4110.del_datetime IS NULL
	)
	WHERE 
		F4200.company_cd	=	@P_company_cd
	AND F4200.employee_cd	=	@P_employee_cd
	AND F4200.report_kind IN (1,2,3)
	AND F4200.del_datetime IS NULL
	-- FILTER BY @P_year & @P_month
	IF @P_year > 0 AND @P_month > 0
	BEGIN
		SET @w_year_month = CAST((CAST(@P_year AS NVARCHAR(4)) + RIGHT('00'+CAST(@P_month AS NVARCHAR(2)),2)) AS INT)
		--
		DELETE D FROM #TABLE_RESULT AS D 
		WHERE
			D.report_kind IN (1,2,3)
		AND (
			D.year_month_from	>	@w_year_month
		OR	D.year_month_to		<	@w_year_month 
		)
	END
	-- FILTER BY @P_year AND DONT CHOIC @P_month
	IF @P_year > 0 AND @P_month < 0
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D 
		WHERE
			D.report_kind IN (1,2,3)
		AND (
			D.year_from		>	@P_year
		OR	D.year_to		<	@P_year 
		)
	END
	--[0]
	SELECT 
		ISNULL(F4200.status_cd,0)		AS	status_cd
	,	CASE 
			WHEN @w_language = 2
			THEN ISNULL(L0041.status_nm2,'')
			ELSE ISNULL(L0041.status_nm,'')
		END								AS	status_nm
	,	CASE 
			WHEN ISNULL(F4200.title,'') <> ''
			THEN ISNULL(F4200.title,'')			
			ELSE CAST(ISNULL(F4200.times,0) AS NVARCHAR(2)) + IIF(@w_language = 2, ' Times', '回')
		END								AS	title	-- タイトル
	,	FORMAT(F4100.[start_date],'yyyy/MM/dd') + '~' + FORMAT(F4100.deadline_date,'yyyy/MM/dd')
										AS	target_period	-- 対象期間
	,	ISNULL(F4201.adequacy_kbn,0)	AS	adequacy_kbn
	,	ISNULL(F4201.busyness_kbn,0)	AS	busyness_kbn
	,	ISNULL(F4201.other_kbn,0)		AS	other_kbn
	--,	ISNULL(F4201.free_comment,'')	AS	free_comment
	,	CASE 
			WHEN ISNULL(F4202.answer_sentence,'')	<>	''
			THEN ISNULL(F4202.answer_sentence,'')
			ELSE ISNULL(F4201.free_comment,'')
		END								AS	free_comment
	--	hide item
	,	ISNULL(F4200.fiscal_year,0)		AS	fiscal_year
	,	ISNULL(F4200.employee_cd,'')	AS	employee_cd
	,	ISNULL(F4200.report_kind,0)		AS	report_kind
	,	ISNULL(F4200.report_no,0)		AS	report_no
	,	CASE 
			WHEN F4900_READ.company_cd IS NOT NULL
			THEN 2
			WHEN F4900_TEMP.company_cd IS NOT NULL
			THEN 1
			ELSE 0
		END								AS	reaction_read_status	-- 0.リアクションなし｜１．未読　｜２．読済
	,	IIF(FORMAT(F4100.[start_date],'yyyy/MM/dd')<=@w_today AND @w_today<=FORMAT(F4100.deadline_date,'yyyy/MM/dd'),1,0) AS background_color
	FROM #TABLE_RESULT
	LEFT OUTER JOIN F4200 ON (
		#TABLE_RESULT.company_cd	=	F4200.company_cd
	AND #TABLE_RESULT.fiscal_year	=	F4200.fiscal_year
	AND #TABLE_RESULT.employee_cd	=	F4200.employee_cd
	AND #TABLE_RESULT.report_kind	=	F4200.report_kind
	AND #TABLE_RESULT.report_no		=	F4200.report_no
	AND F4200.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0041 ON (
		F4200.status_cd	=	L0041.status_cd
	AND L0041.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4110 ON (
		F4200.company_cd		=	F4110.company_cd
	AND F4200.fiscal_year		=	F4110.fiscal_year
	AND F4200.employee_cd		=	F4110.employee_cd
	AND F4200.report_kind		=	F4110.report_kind
	AND F4200.report_no			=	F4110.report_no
	AND F4110.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4100 ON (
		F4110.company_cd		=	F4100.company_cd
	AND F4110.fiscal_year		=	F4100.fiscal_year
	AND F4110.group_cd			=	F4100.group_cd
	AND F4110.report_kind		=	F4100.report_kind
	AND F4110.times				=	F4100.detail_no
	AND F4100.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4201 ON (
		F4200.company_cd		=	F4201.company_cd
	AND F4200.fiscal_year		=	F4201.fiscal_year
	AND F4200.employee_cd		=	F4201.employee_cd
	AND F4200.report_kind		=	F4201.report_kind
	AND F4200.report_no			=	F4201.report_no
	AND F4201.del_datetime IS NULL
	)
	LEFT OUTER JOIN M4201 ON(
		F4200.company_cd		=	M4201.company_cd
	AND F4200.report_kind		=	M4201.report_kind
	AND F4200.sheet_cd			=	M4201.sheet_cd
	AND	F4200.adaption_date		=	M4201.adaption_date
	AND	1						=	M4201.sheet_detail_no
	AND	M4201.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4202 ON(
		F4200.company_cd		=	F4202.company_cd
	AND F4200.fiscal_year		=	F4202.fiscal_year
	AND F4200.employee_cd		=	F4202.employee_cd
	AND F4200.report_kind		=	F4202.report_kind
	AND F4200.report_no			=	F4202.report_no
	AND M4201.question_no		=	F4202.question_no
	AND	F4202.del_datetime IS NULL
	)
	LEFT OUTER JOIN (
		SELECT 
			F4900.company_cd				AS	company_cd
		,	F4900.infomation_typ			AS	infomation_typ
		,	F4900.fiscal_year				AS	fiscal_year
		,	F4900.employee_cd				AS	employee_cd
		,	F4900.report_kind				AS	report_kind
		,	F4900.report_no					AS	report_no
		,	F4900.to_employee_cd			AS	to_employee_cd
		,	MIN(F4900.from_employee_cd)		AS	from_employee_cd
		FROM F4900
		WHERE 
			F4900.company_cd		=	@P_company_cd
		AND F4900.infomation_typ	=	3	--	 3.リアクション
		AND F4900.employee_cd		=	@P_employee_cd
		AND F4900.to_employee_cd	=	@P_employee_cd
		AND F4900.del_datetime IS NULL
		GROUP BY
			F4900.company_cd
		,	F4900.infomation_typ
		,	F4900.fiscal_year
		,	F4900.employee_cd
		,	F4900.report_kind
		,	F4900.report_no
		,	F4900.to_employee_cd
	) AS F4900_TEMP ON (
			F4200.company_cd		=	F4900_TEMP.company_cd
		AND 3						=	F4900_TEMP.infomation_typ
		AND F4200.fiscal_year		=	F4900_TEMP.fiscal_year
		AND F4200.employee_cd		=	F4900_TEMP.employee_cd
		AND F4200.report_kind		=	F4900_TEMP.report_kind
		AND F4200.report_no			=	F4900_TEMP.report_no
		AND @P_employee_cd			=	F4900_TEMP.to_employee_cd
	)
	LEFT OUTER JOIN (
		SELECT 
			F4900.company_cd				AS	company_cd
		,	F4900.infomation_typ			AS	infomation_typ
		,	F4900.fiscal_year				AS	fiscal_year
		,	F4900.employee_cd				AS	employee_cd
		,	F4900.report_kind				AS	report_kind
		,	F4900.report_no					AS	report_no
		,	F4900.to_employee_cd			AS	to_employee_cd
		,	MIN(F4900.from_employee_cd)		AS	from_employee_cd
		FROM F4900
		WHERE 
			F4900.company_cd		=	@P_company_cd
		AND F4900.infomation_typ	=	3	--	 3.リアクション
		AND F4900.employee_cd		=	@P_employee_cd
		AND F4900.to_employee_cd	=	@P_employee_cd
		AND F4900.confirmation_datetime IS NOT NULL
		AND F4900.del_datetime IS NULL
		GROUP BY
			F4900.company_cd
		,	F4900.infomation_typ
		,	F4900.fiscal_year
		,	F4900.employee_cd
		,	F4900.report_kind
		,	F4900.report_no
		,	F4900.to_employee_cd
	) AS F4900_READ ON (
			F4200.company_cd		=	F4900_READ.company_cd
		AND 3						=	F4900_READ.infomation_typ
		AND F4200.fiscal_year		=	F4900_READ.fiscal_year
		AND F4200.employee_cd		=	F4900_READ.employee_cd
		AND F4200.report_kind		=	F4900_READ.report_kind
		AND F4200.report_no			=	F4900_READ.report_no
		AND @P_employee_cd			=	F4900_READ.to_employee_cd
	)
	WHERE 
		F4200.company_cd	=	@P_company_cd
	AND F4200.employee_cd	=	@P_employee_cd
	AND F4200.del_datetime IS NULL
	ORDER BY
		F4200.report_kind DESC
	,	F4100.start_date
	-- DROP TBLE

	DROP TABLE #TABLE_RESULT
END
GO
