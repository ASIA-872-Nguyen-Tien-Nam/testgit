IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_rDashboard_LST3]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_rDashboard_LST3]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_rDashboard_LST3 782,'721',2023,1
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET REPORTS FOR APPOVERS
--*  
--*  作成日/create date			:	2023/05/08						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rDashboard_LST3]
	@P_company_cd		SMALLINT		=	0
,	@P_employee_cd		NVARCHAR(10)	=	''	-- LOGIN EMPLOYEE
,	@P_fiscal_year		SMALLINT		=	0
,	@P_report_kind		SMALLINT		=	0	
,	@P_year				SMALLINT		=	-1		-- F4200.year
,	@P_month			SMALLINT		=	-1		-- F4200.month
,	@P_times			SMALLINT		=	-1		-- F4200.times
,	@P_mygroup_cd		SMALLINT		=	-1
,	@P_belong_cd1		NVARCHAR(20)	=	'-1'	-- 組織1
,	@P_belong_cd2		NVARCHAR(20)	=	'-1'	-- 組織2
,	@P_belong_cd3		NVARCHAR(20)	=	'-1'	-- 組織3
,	@P_unapproved_only	SMALLINT		=	0	-- 0.not checked 1.checked
,	@P_approved_show	SMALLINT		=	0	-- 0.not checked 1.checked
AS
BEGIN
	DECLARE 
		@w_language							smallint		=	0	-- 1.JP 2.EN
	,	@w_beginning_date					date			=	NULL
	,	@w_year_month_day					date			=	NULL
	,	@w_cre_user							nvarchar(50)	=	''
	--	
	SELECT 
		@w_language =	ISNULL(S0010.[language],1)
	,	@w_cre_user	=	ISNULL(S0010.user_id,'')
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
	--#TABLE_RESULT
	CREATE TABLE #TABLE_RESULT (
		fiscal_year				smallint
	,	employee_cd				nvarchar(10)
	,	report_kind				smallint
	,	report_no				smallint
	,	approver_status_cd		smallint	-- 承認者が承認した
	,	reaction_status_cd		smallint	-- 承認者がリアクションした
	,	submit_status			smallint
	,	reaction_read_status	smallint	--	0.has not reactions 1.not read 2.read
	,	approver_can_link		smallint	--	0.approver not link | 1.approver can link
	,	admin_approve_done		smallint	
	,	approver_not_approved	smallint	--	0.not approved 1.approved
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
	-- #M0070H
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @w_year_month_day,'',@P_company_cd
	-- #TABLE_RESULT
	INSERT INTO #TABLE_RESULT
	SELECT 
		ISNULL(F4200.fiscal_year,0)		AS	fiscal_year
	,	ISNULL(F4200.employee_cd,'')	AS	employee_cd
	,	ISNULL(F4200.report_kind,0)		AS	report_kind
	,	ISNULL(F4200.report_no,0)		AS	report_no
	--	承認
	,	CASE 
			WHEN F4200.approver_employee_cd_1 = @P_employee_cd AND F4200.approver_datetime_1 IS NOT NULL
			THEN 1
			WHEN F4200.approver_employee_cd_2 = @P_employee_cd AND F4200.approver_datetime_2 IS NOT NULL
			THEN 1
			WHEN F4200.approver_employee_cd_3 = @P_employee_cd AND F4200.approver_datetime_3 IS NOT NULL
			THEN 1
			WHEN F4200.approver_employee_cd_4 = @P_employee_cd AND F4200.approver_datetime_4 IS NOT NULL
			THEN 1
			ELSE 0
		END								AS	approver_status_cd
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
			WHEN F4200.approver_employee_cd_1	=	@P_employee_cd AND F4200.status_cd < 2
			THEN 0
			WHEN F4200.approver_employee_cd_2	=	@P_employee_cd AND F4200.status_cd < 3
			THEN 0
			WHEN F4200.approver_employee_cd_3	=	@P_employee_cd AND F4200.status_cd < 4
			THEN 0
			WHEN F4200.approver_employee_cd_4	=	@P_employee_cd AND F4200.status_cd < 5
			THEN 0
			ELSE 1
		END								AS	approver_can_link
	,	CASE 
			WHEN F4200.approver_employee_cd_1 =	@P_employee_cd AND F4200.approver_user_1 <> @w_cre_user AND F4200.status_cd >= 2 AND F4200.approver_datetime_1 IS NOT NULL
			THEN 1
			WHEN F4200.approver_employee_cd_2 =	@P_employee_cd AND F4200.approver_user_2 <> @w_cre_user AND F4200.status_cd >= 3 AND F4200.approver_datetime_2 IS NOT NULL
			THEN 1
			WHEN F4200.approver_employee_cd_3 =	@P_employee_cd AND F4200.approver_user_3 <> @w_cre_user AND F4200.status_cd >= 4 AND F4200.approver_datetime_3 IS NOT NULL
			THEN 1
			WHEN F4200.approver_employee_cd_4 =	@P_employee_cd AND F4200.approver_user_4 <> @w_cre_user AND F4200.status_cd >= 5 AND F4200.approver_datetime_4 IS NOT NULL
			THEN 1
			ELSE 0
		END								AS	admin_approve_done
	,	CASE
			WHEN F4200.approver_employee_cd_1	=	@P_employee_cd AND F4200.status_cd = 2 AND F4200.approver_datetime_1 IS NULL
			THEN 1
			WHEN F4200.approver_employee_cd_2	=	@P_employee_cd AND F4200.status_cd = 3 AND F4200.approver_datetime_2 IS NULL
			THEN 1
			WHEN F4200.approver_employee_cd_3	=	@P_employee_cd AND F4200.status_cd = 4 AND F4200.approver_datetime_3 IS NULL
			THEN 1
			WHEN F4200.approver_employee_cd_4	=	@P_employee_cd AND F4200.status_cd = 5 AND F4200.approver_datetime_4 IS NULL
			THEN 1
			ELSE 0
		END								AS	approver_not_approved
				
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
	LEFT OUTER JOIN F4204 ON (
		F4200.company_cd		=	F4204.company_cd
	AND F4200.fiscal_year		=	F4204.fiscal_year
	AND F4200.employee_cd		=	F4204.employee_cd
	AND F4200.report_kind		=	F4204.report_kind
	AND F4200.report_no			=	F4204.report_no
	AND @P_employee_cd			=	F4204.reaction_no
	AND F4204.del_datetime IS NULL
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
	WHERE 
		F4200.company_cd	=	@P_company_cd
	AND F4200.fiscal_year	=	@P_fiscal_year
	AND F4200.report_kind	=	@P_report_kind
	AND F4200.del_datetime IS NULL
	AND (
		F4200.approver_employee_cd_1	=	@P_employee_cd
	OR	F4200.approver_employee_cd_2	=	@P_employee_cd
	OR	F4200.approver_employee_cd_3	=	@P_employee_cd
	OR	F4200.approver_employee_cd_4	=	@P_employee_cd
	)
	AND (
		(@P_year = -1)
	OR	@P_report_kind < 4
	OR	(@P_year <> - 1 AND F4200.[year] = @P_year)
	)
	AND (
		(@P_month = -1)
	OR	@P_report_kind < 4
	OR	(@P_month <> - 1 AND F4200.[month] = @P_month)
	)
	AND (
		(@P_times = -1)
	OR	@P_report_kind < 4
	OR	(@P_times <> - 1 AND F4200.times = @P_times)
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
	-- FILTER 未承認のみ
	IF @P_unapproved_only = 1
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D
		WHERE
			D.approver_status_cd	=	1
	END
	-- FILTER 処理済も表示する
	IF @P_approved_show = 0
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D
		WHERE
		(	D.approver_status_cd	=	1
		--AND D.reaction_status_cd	=	1
		)
		OR
		(
			D.admin_approve_done	=	1
		)
	END
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
			END							AS	title	-- タイトル
	,	ISNULL(F4201.adequacy_kbn,0)	AS	adequacy_kbn
	,	ISNULL(F4201.busyness_kbn,0)	AS	busyness_kbn
	,	ISNULL(F4201.other_kbn,0)		AS	other_kbn
	--	承認
	,	#TABLE_RESULT.approver_status_cd	AS	approver_status_cd
	,	CASE 
			WHEN #TABLE_RESULT.approver_status_cd = 1
			THEN IIF(@w_language = 2, N'DONE', N'済')
			ELSE SPACE(0)
		END									AS	approver_status
	
	,	#TABLE_RESULT.reaction_status_cd	AS	reaction_status_cd
	,	CASE 
			WHEN #TABLE_RESULT.reaction_status_cd = 1
			THEN IIF(@w_language = 2,N'DONE', N'済')
			ELSE SPACE(0)
		END									AS	reaction_status
	,	#TABLE_RESULT.submit_status			AS	submit_status -- 0.未提出　1.提出済
	,	#TABLE_RESULT.reaction_read_status	AS	reaction_read_status
	,	#TABLE_RESULT.approver_can_link		AS	approver_can_link
	,	IIF(@w_language = 2, ISNULL(L0041.status_nm2,''),ISNULL(L0041.status_nm,''))
											AS	status_nm
	,	ISNULL(#TABLE_RESULT.approver_not_approved,0)	
											AS	approver_not_approved
	FROM #TABLE_RESULT
	INNER JOIN F4200 ON (
		@P_company_cd				=	F4200.company_cd
	AND #TABLE_RESULT.fiscal_year	=	F4200.fiscal_year
	AND #TABLE_RESULT.employee_cd	=	F4200.employee_cd
	AND #TABLE_RESULT.report_kind	=	F4200.report_kind
	AND #TABLE_RESULT.report_no		=	F4200.report_no
	AND F4200.del_datetime IS NULL
	)
	LEFT OUTER JOIN L0041 ON (
		F4200.status_cd			=	L0041.status_cd
	AND L0041.del_datetime IS NULL
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
	ORDER BY
		F4201.submission_datetime	DESC
	,	RIGHT(SPACE(10)+ISNULL(F4200.employee_cd,N''),10)
	--DROP
	DROP TABLE #TABLE_RESULT
	DROP TABLE #M0070H
END

GO
