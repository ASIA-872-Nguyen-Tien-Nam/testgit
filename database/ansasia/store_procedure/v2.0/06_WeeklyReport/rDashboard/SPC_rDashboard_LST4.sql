IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_rDashboard_LST4]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_rDashboard_LST4]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_rDashboard_LST4 782,'721',2023,1
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET REPORTS FOR VIEWERS
--*  
--*  作成日/create date			:	2023/05/08						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rDashboard_LST4]
	@P_company_cd		SMALLINT		=	0
,	@P_employee_cd		NVARCHAR(10)	=	''	-- LOGIN EMPLOYEE
,	@P_fiscal_year		SMALLINT		=	0
,	@P_year				SMALLINT		=	-1		-- F4200.year
,	@P_month			SMALLINT		=	-1		-- F4200.month
,	@P_times			SMALLINT		=	-1		-- F4200.times
,	@P_report_kind		SMALLINT		=	-1
,	@P_mygroup_cd		SMALLINT		=	-1
,	@P_shared_report	SMALLINT		=	0	-- 0.not checked 1.checked
,	@P_approved_show	SMALLINT		=	0	-- 0.not checked 1.checked
,	@P_belong_cd1		NVARCHAR(20)	=	'-1'	-- 組織1
,	@P_belong_cd2		NVARCHAR(20)	=	'-1'	-- 組織2
,	@P_belong_cd3		NVARCHAR(20)	=	'-1'	-- 組織3
,	@P_belong_cd4		NVARCHAR(20)	=	'-1'	-- 組織4
,	@P_belong_cd5		NVARCHAR(20)	=	'-1'	-- 組織5
AS
BEGIN
	DECLARE 
		@w_language							smallint		=	0	-- 1.JP 2.EN
	,	@w_report_authority_typ				smallint		=	0
	,	@w_report_authority_cd				smallint		=	0
	,	@w_choice_in_screen					tinyint			=	0
	,	@w_cre_user							nvarchar(50)	=	''
	,	@w_beginning_date					date			=	NULL
	,	@w_year_month_day					date			=	NULL
	--
	CREATE TABLE #TABLE_RESULT (
		company_cd				SMALLINT
	,	employee_cd				NVARCHAR(10)
	,	report_kind				SMALLINT
	,	report_no				SMALLINT
	,	approver_status_cd		SMALLINT
	,	reaction_status_cd		SMALLINT
	,	submit_status			SMALLINT
	,	reaction_read_status	SMALLINT	--	0.has not reactions 1.not read 2.read
	,	sharewith_status		SMALLINT	--	0. NOT SHARE 1.SHARE DONE
	,	viewer_status_cd		SMALLINT	--	0. NOT VIEW 1. VIEW
	)
	--#M0070H
	CREATE TABLE #M0070H(
		application_date				date
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(200)
	,	employee_ab_nm					nvarchar(50)
	,	furigana						nvarchar(50)
	,	office_cd						smallint
	,	office_nm						nvarchar(50)
	,	belong_cd_1						nvarchar(20)
	,	belong_cd_2						nvarchar(20)
	,	belong_cd_3						nvarchar(20)
	,	belong_cd_4						nvarchar(20)
	,	belong_cd_5						nvarchar(20)
	,	job_cd							smallint
	,	position_cd						int
	,	employee_typ					smallint
	,	grade							smallint
	,	belong_nm_1						nvarchar(50)
	,	belong_nm_2						nvarchar(50)
	,	belong_nm_3						nvarchar(50)
	,	belong_nm_4						nvarchar(50)
	,	belong_nm_5						nvarchar(50)
	,	job_nm							nvarchar(50)
	,	position_nm						nvarchar(50)
	,	grade_nm						nvarchar(50)
	,	employee_typ_nm					nvarchar(50)
	)
	--	
	SELECT 
		@w_language					=	ISNULL(S0010.[language],1)
	,	@w_report_authority_typ		=	ISNULL(S0010.report_authority_typ,0)
	,	@w_report_authority_cd		=	ISNULL(S0010.report_authority_cd,0)
	,	@w_cre_user					=	ISNULL(S0010.[user_id],'')
	FROM S0010
	WHERE 
		S0010.company_cd	=	@P_company_cd
	AND S0010.employee_cd	=	@P_employee_cd
	AND S0010.del_datetime IS NULL
	SELECT 
		@w_beginning_date = M9100.report_beginning_date 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	--
	IF @w_beginning_date IS NOT NULL
	BEGIN
		SET @w_year_month_day = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/' + FORMAT(@w_beginning_date,'MM/dd')) AS DATE)
		SET @w_year_month_day = DATEADD(DD,-1,DATEADD(YYYY,1,@w_year_month_day))
	END
	ELSE
	BEGIN 
		SET @w_year_month_day = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/12/31') AS DATE)
	END
	-- #M0070H
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @w_year_month_day,'',@P_company_cd
	-- INSERT INTO #TABLE_RESULT
	INSERT INTO #TABLE_RESULT
	SELECT 
		F4200.company_cd
	,	F4200.employee_cd	
	,	F4200.report_kind	
	,	F4200.report_no	
	,	0	AS	approver_status_cd
	,	CASE 
			WHEN F4204.reaction_datetime IS NOT NULL
			THEN 1
			ELSE 0
		END								AS	reaction_status_cd
	,	CASE 
			WHEN F4201.submission_datetime IS NOT NULL
			THEN 1
			ELSE 0
		END								AS	submit_status -- 0.未提出　1.提出済
	,	CASE 
			WHEN F4900_TEMP.company_cd IS NULL
			THEN 0
			WHEN F4900_TEMP.confirmation_datetime IS NOT NULL
			THEN 2
			ELSE 1
		END								AS	reaction_read_status
	,	CASE 
			WHEN F4207_TEMP.employee_cd IS NOT NULL
			THEN 1
			ELSE 0
		END								AS	sharewith_status
	,	CASE 
			WHEN F4203.viewer_datetime IS NOT NULL
			THEN 1
			ELSE 0
		END								AS	viewer_status_cd
	FROM F4200
	LEFT OUTER JOIN #M0070H ON (
		F4200.company_cd		=	#M0070H.company_cd
	AND F4200.employee_cd		=	#M0070H.employee_cd
	)
	LEFT OUTER JOIN F4110 ON (
		F4200.company_cd		=	F4110.company_cd
	AND F4200.fiscal_year		=	F4110.fiscal_year
	AND F4200.employee_cd		=	F4110.employee_cd
	AND F4200.report_kind		=	F4110.report_kind
	AND F4200.report_no			=	F4110.report_no
	AND F4110.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4201 ON (
		F4200.company_cd		=	F4201.company_cd
	AND F4200.fiscal_year		=	F4201.fiscal_year
	AND F4200.employee_cd		=	F4201.employee_cd
	AND F4200.report_kind		=	F4201.report_kind
	AND F4200.report_no			=	F4201.report_no
	AND F4201.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4203 ON (
		F4200.company_cd		=	F4203.company_cd
	AND F4200.fiscal_year		=	F4203.fiscal_year
	AND F4200.employee_cd		=	F4203.employee_cd
	AND F4200.report_kind		=	F4203.report_kind
	AND F4200.report_no			=	F4203.report_no
	AND @P_employee_cd			=	F4203.viewer_employee_cd
	AND F4203.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4204 ON (
		F4200.company_cd		=	F4204.company_cd
	AND F4200.fiscal_year		=	F4204.fiscal_year
	AND F4200.employee_cd		=	F4204.employee_cd
	AND F4200.report_kind		=	F4204.report_kind
	AND F4200.report_no			=	F4204.report_no
	AND @P_employee_cd			=	F4204.reaction_no
	AND F4204.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4120 ON (
		F4200.company_cd		=	F4120.company_cd
	AND F4200.fiscal_year		=	F4120.fiscal_year
	AND F4200.employee_cd		=	F4120.employee_cd
	AND F4200.report_kind		=	F4120.report_kind
	AND F4200.report_no			=	F4120.report_no
	AND @P_employee_cd			=	F4120.viewer_employee_cd
	AND F4120.del_datetime IS NULL
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
		,	F4900.confirmation_datetime		AS	confirmation_datetime
		FROM F4900
		WHERE 
			F4900.company_cd		=	@P_company_cd
		AND F4900.infomation_typ	=	3	--	 3.リアクション
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
		,	F4900.confirmation_datetime
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
			F4207.company_cd
		,	F4207.fiscal_year
		,	F4207.employee_cd
		,	F4207.report_kind
		,	F4207.report_no
		FROM F4207
		WHERE 
			F4207.company_cd			=	@P_company_cd
		AND F4207.fiscal_year			=	@P_fiscal_year
		AND F4207.sharewith_employee_cd	=	@P_employee_cd
		AND F4207.del_datetime IS NULL
		GROUP BY
			F4207.company_cd
		,	F4207.fiscal_year
		,	F4207.employee_cd
		,	F4207.report_kind
		,	F4207.report_no
	) AS F4207_TEMP ON (
		F4200.company_cd		=	F4207_TEMP.company_cd
	AND F4200.fiscal_year		=	F4207_TEMP.fiscal_year
	AND F4200.employee_cd		=	F4207_TEMP.employee_cd
	AND F4200.report_kind		=	F4207_TEMP.report_kind
	AND F4200.report_no			=	F4207_TEMP.report_no
	)
	WHERE 
		F4200.company_cd	=	@P_company_cd
	AND F4200.fiscal_year	=	@P_fiscal_year
	AND F4200.status_cd		=	6	
	AND F4200.del_datetime IS NULL
	AND (
		(@P_year = -1)
	OR	(@P_report_kind	IN(1,2,3))
	OR (F4200.report_kind IN(1,2,3))
	OR	(F4200.report_kind > 0 AND @P_year <> - 1 AND F4200.[year] = @P_year AND (F4200.report_kind IN(4,5))
	)
	AND (
		(@P_month = -1)
	OR	(@P_report_kind	IN(1,2,3))
	OR (F4200.report_kind IN(1,2,3))
	OR	(F4200.report_kind > 0 AND @P_month <> - 1 AND F4200.[month] = @P_month AND F4200.report_kind IN(4,5))
	))
	AND (
		(@P_times = -1)
	OR	(@P_report_kind	IN(1,2,3))
	OR (F4200.report_kind IN(1,2,3))
	OR	(F4200.report_kind > 0 AND @P_times <> - 1 AND F4200.times = @P_times AND F4200.report_kind IN(4,5))
	)
	AND (
		(@P_report_kind = -1)
	OR	(@P_report_kind <> - 1 AND F4200.report_kind = @P_report_kind)
	)
	AND (
		(@P_belong_cd1 = '-1')
	OR	(@P_belong_cd1 <> '-1' AND #M0070H.belong_cd_1 = @P_belong_cd1)
	)
	AND (
		(@P_belong_cd2 = '-1')
	OR	(@P_belong_cd2 <> '-1' AND #M0070H.belong_cd_2 = @P_belong_cd2)
	)
	AND (
		(@P_belong_cd3 = '-1')
	OR	(@P_belong_cd3 <> '-1' AND #M0070H.belong_cd_3 = @P_belong_cd3)
	)
	AND (
		(@P_belong_cd4 = '-1')
	OR	(@P_belong_cd4 <> '-1' AND #M0070H.belong_cd_4 = @P_belong_cd4)
	)
	AND (
		(@P_belong_cd5 = '-1')
	OR	(@P_belong_cd5 <> '-1' AND #M0070H.belong_cd_5 = @P_belong_cd5)
	)
	AND (
		F4120.employee_cd IS NOT NULL
	OR	F4207_TEMP.employee_cd IS NOT NULL
	)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--FILTER
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--■ FILTER BY MY_GROUP_CD
	IF @P_mygroup_cd > 0
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D
		LEFT OUTER JOIN F4011 ON (
			@P_company_cd				=	F4011.company_cd
		AND	@P_employee_cd				=	F4011.employee_cd
		AND @P_mygroup_cd				=	F4011.mygroup_cd
		AND D.employee_cd				=	F4011.mygroup_member_cd
		AND F4011.del_datetime IS NULL
		)
		WHERE 
			F4011.company_cd IS NULL
	END
	-- FILTER @P_shared_report
	IF @P_shared_report > 0
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D
		WHERE 
			D.sharewith_status = 0
	END
	-- FILTER @P_approved_show
	IF @P_approved_show = 0
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D
		WHERE 
			D.viewer_status_cd = 1
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--result
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--[0]
	SELECT 
		ISNULL(F4200.fiscal_year,0)		AS	fiscal_year
	,	ISNULL(F4200.employee_cd,'')	AS	employee_cd
	,	ISNULL(F4200.report_kind,0)		AS	report_kind
	,	ISNULL(F4200.report_no,0)		AS	report_no
	,	FORMAT(F4201.submission_datetime,'yyyy/MM/dd HH:mm')
										AS	submission_datetime
	,	ISNULL(F4200.employee_cd,'')	AS	employee_cd
	,	ISNULL(M0070.employee_nm,'')	AS	employee_nm
	,	CASE 
			WHEN ISNULL(F4200.title,'') <> ''
			THEN ISNULL(F4200.title,'')			
			ELSE CAST(ISNULL(F4200.times,0) AS NVARCHAR(2)) + IIF(@w_language = 2, ' Times', '回')
		END								AS	title	-- タイトル
	,	ISNULL(F4201.adequacy_kbn,0)	AS	adequacy_kbn
	,	ISNULL(F4201.busyness_kbn,0)	AS	busyness_kbn
	,	ISNULL(F4201.other_kbn,0)		AS	other_kbn
	--	承認
	,	#TABLE_RESULT.approver_status_cd	AS	approver_status_cd
	,	CASE 
			WHEN #TABLE_RESULT.approver_status_cd = 1
			THEN IIF(@w_language = 1, N'済', N'DONE')
			ELSE SPACE(0)
		END									AS	approver_status
	
	,	#TABLE_RESULT.reaction_status_cd	AS	reaction_status_cd
	,	CASE 
			WHEN #TABLE_RESULT.reaction_status_cd = 1
			THEN IIF(@w_language = 1, N'済', N'DONE')
			ELSE SPACE(0)
		END								AS	reaction_status
	,	#TABLE_RESULT.submit_status		AS	submit_status -- 0.未提出　1.提出済
	,	#TABLE_RESULT.reaction_read_status	
										AS	reaction_read_status
	,	#TABLE_RESULT.sharewith_status	AS	sharewith_status
	,	CASE 
			WHEN #TABLE_RESULT.viewer_status_cd = 1
			THEN IIF(@w_language = 1, N'済', N'DONE')
			ELSE SPACE(0)
		END								AS	viewer_status
	FROM #TABLE_RESULT
	LEFT OUTER JOIN F4200 ON (
		#TABLE_RESULT.company_cd	=	F4200.company_cd
	AND @P_fiscal_year				=	F4200.fiscal_year
	AND #TABLE_RESULT.employee_cd	=	F4200.employee_cd
	AND #TABLE_RESULT.report_kind	=	F4200.report_kind
	AND #TABLE_RESULT.report_no		=	F4200.report_no
	AND F4200.del_datetime IS NULL
	)
	LEFT OUTER JOIN M0070 ON(
		F4200.company_cd		=	M0070.company_cd
	AND F4200.employee_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4110 ON (
		F4200.company_cd		=	F4110.company_cd
	AND F4200.fiscal_year		=	F4110.fiscal_year
	AND F4200.employee_cd		=	F4110.employee_cd
	AND F4200.report_kind		=	F4110.report_kind
	AND F4200.report_no			=	F4110.report_no
	AND F4110.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4201 ON (
		F4200.company_cd		=	F4201.company_cd
	AND F4200.fiscal_year		=	F4201.fiscal_year
	AND F4200.employee_cd		=	F4201.employee_cd
	AND F4200.report_kind		=	F4201.report_kind
	AND F4200.report_no			=	F4201.report_no
	AND F4201.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4204 ON (
		F4200.company_cd		=	F4204.company_cd
	AND F4200.fiscal_year		=	F4204.fiscal_year
	AND F4200.employee_cd		=	F4204.employee_cd
	AND F4200.report_kind		=	F4204.report_kind
	AND F4200.report_no			=	F4204.report_no
	AND @P_employee_cd			=	F4204.reaction_no
	AND F4204.del_datetime IS NULL
	)
	WHERE 
		#TABLE_RESULT.company_cd	=	@P_company_cd
	ORDER BY
		F4201.submission_datetime	DESC
	,	RIGHT(SPACE(10)+ISNULL(F4200.employee_cd,N''),10)

END
GO
