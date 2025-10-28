DROP PROCEDURE [dbo].[SPC_EQ0101_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ 
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	M0070_社員マスタ
--*  
--*  作成日/create date			:	2018/08/16						
--*　作成者/creater				:	DatNT								
--*   					
--*  更新日/update date			:	2018/11/15
--*　更新者/updater				:　	Longvv
--*　更新内容/update content		:	UPDATE CR 2018/11/15
--*   					
--*  更新日/update date			:	2021/06/03
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
--*	 EXEC SPC_M0070_INQ1 '30','740','721','jp';
--*	 EXEC SPC_M0070_INQ1 '235','10046','721','jp';

--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_EQ0101_INQ1]
	-- Add the parameters for the stored procedure here	
	@P_employee_cd								NVARCHAR(MAX)	=	''
,	@P_company_cd								SMALLINT		=	0
,	@P_language									NVARCHAR(2)		=	''
AS
BEGIN
	DECLARE 
		@w_time									DATETIME2			=	SYSDATETIME()
	,	@month_count							INT					=	0
	,	@w_max_application_date					DATE				=	NULL
	,	@w_company_out_dt						DATE				=	NULL
	,	@w_application_date_grade				DATE				=	NULL
	,	@w_grade								INT					=	0
	,	@w_belong_cd1							INT					=	0

	--
	CREATE TABLE #M0071 (
		application_date		DATE
	,	grade					SMALLINT
	,	grade_nm				NVARCHAR(10)
	--,	grade_length_stay		NVARCHAR(20)
	,	belong_cd1				NVARCHAR(20)
	,	belong_cd2				NVARCHAR(20)	
	,	belong_cd3				NVARCHAR(20)	
	,	belong_cd4				NVARCHAR(20)	
	,	belong_cd5				NVARCHAR(20)
	,	belong_cd1_nm			NVARCHAR(50)
	,	belong_cd2_nm			NVARCHAR(50)	
	,	belong_cd3_nm			NVARCHAR(50)	
	,	belong_cd4_nm			NVARCHAR(50)	
	,	belong_cd5_nm			NVARCHAR(50)
	--,	number_years_enrolled	NVARCHAR(20)
	,	position_cd				INT	
	,	position_nm				NVARCHAR(50)
	,	job_cd					INT
	,	job_nm					NVARCHAR(50)
	,	office_cd				INT
	,	office_nm				NVARCHAR(50)
	,	employee_typ			INT
	,	employee_typ_nm			NVARCHAR(50)
	)
	CREATE TABLE #M0073 (
		detail_no				SMALLINT
	,	arrange_order			SMALLINT
	,	belong_cd1				NVARCHAR(20)
	,	belong_cd2				NVARCHAR(20)	
	,	belong_cd3				NVARCHAR(20)	
	,	belong_cd4				NVARCHAR(20)	
	,	belong_cd5				NVARCHAR(20)
	,	belong_cd1_nm			NVARCHAR(50)
	,	belong_cd2_nm			NVARCHAR(50)	
	,	belong_cd3_nm			NVARCHAR(50)	
	,	belong_cd4_nm			NVARCHAR(50)	
	,	belong_cd5_nm			NVARCHAR(50)
	,	position_cd				INT	
	,	position_nm				NVARCHAR(50)
	)

	CREATE TABLE #HISTORY (
		application_date		DATE
	,	type					INT
	,	belong_cd1				NVARCHAR(20)
	,	belong_cd2				NVARCHAR(20)	
	,	belong_cd3				NVARCHAR(20)	
	,	belong_cd4				NVARCHAR(20)	
	,	belong_cd5				NVARCHAR(20)
	,	belong_cd1_nm			NVARCHAR(50)
	,	belong_cd2_nm			NVARCHAR(50)	
	,	belong_cd3_nm			NVARCHAR(50)	
	,	belong_cd4_nm			NVARCHAR(50)	
	,	belong_cd5_nm			NVARCHAR(50)
	,	position_nm				NVARCHAR(50)
	,	grade_nm				NVARCHAR(10)
	,	job_nm					NVARCHAR(50)
	,	office_nm				NVARCHAR(50)
	,	employee_typ_nm			NVARCHAR(50)
	,	arrange_order			INT	
	,	detail_no				INT
	)

	CREATE TABLE #MAX_M0071 (
		company_cd			INT	
	,	employee_cd			NVARCHAR(10)
	,	application_date	DATE
	)

	--SET DATA @month_count
	SELECT 
		@month_count		=	DATEDIFF(MM,M0070.company_in_dt,ISNULL(M0070.company_out_dt,@w_time)) 
	,	@w_company_out_dt	=	company_out_dt
	FROM M0070
	WHERE
		company_cd  = @P_company_cd
	AND	employee_cd = @P_employee_cd
	AND del_datetime IS NULL

	--[0] (fixed header)
	SELECT 
		ISNULL(M0070.picture,'')								AS	picture
	,	ISNULL(M0070.employee_cd,'')							AS	employee_cd
	,	ISNULL(M0070.employee_last_nm,'')						AS	employee_last_nm
	,	ISNULL(M0070.employee_first_nm,'')						AS	employee_first_nm
	,	ISNULL(M0070.employee_nm,'')							AS	employee_nm
	,	ISNULL(M0070.furigana,'')								AS	furigana
	,	FORMAT(M0070.company_in_dt,'yyyy/MM/dd')				AS	company_in_dt
	,	FORMAT(M0070.company_out_dt,'yyyy/MM/dd')				AS	company_out_dt
	,	IIF(@month_count / 12 = 0,''
		, CAST(@month_count / 12 AS nvarchar(10)) +IIF(@P_language = 'en'
		, IIF((@month_count / 12) = 1 OR (@month_count / 12) = -1, ' Year ', ' Years '), '年')) +  IIF(@month_count % 12 = 0,''
		, CAST(@month_count % 12 AS nvarchar(10)) + IIF(@P_language = 'en'
		, IIF((@month_count % 12) = 1 OR (@month_count % 12) = -1, ' Month ', ' Months '), 'ヶ月')
		)														AS	period_date
	,	FORMAT(M0070.birth_date,'yyyy/MM/dd')					AS	birth_date
	,	[dbo].FNC_GET_BIRTHDAY_AGE(M0070.birth_date,NULL)		AS	year_old
	,	M0070.gender											AS	gender
	FROM M0070 
	WHERE
		company_cd		=	@P_company_cd
	AND employee_cd		=	@P_employee_cd
	AND del_datetime IS NULL

	--[1] tab 社員情報 (header)
	SELECT 
		M0070.mail												AS	mail
	,	M0070.company_mobile_number								AS	company_mobile_number
	,	M0070.extension_number									AS	extension_number
	,	FORMAT(M0070.company_out_dt,'yyyy/MM/dd')				AS	company_out_dt
	,	M0070.salary_grade										AS	salary_grade
	,	L0010.name												AS	name
	,	M0070.retirement_reason									AS	retirement_reason
	FROM M0070 
	LEFT JOIN L0010 ON (
		L0010.name_typ			=	17
	AND	M0070.retirement_reason_typ	=	L0010.number_cd
	)
	WHERE
		M0070.company_cd		=	@P_company_cd
	AND M0070.employee_cd		=	@P_employee_cd
	AND M0070.del_datetime IS NULL

	--get max application_date
	INSERT INTO #MAX_M0071
	SELECT 
		company_cd
	,	employee_cd
	,	MAX(application_date)
	FROM M0071
	WHERE
		company_cd			=	@P_company_cd
	AND employee_cd			=	@P_employee_cd
	AND del_datetime IS NULL
	GROUP BY
		company_cd
	,	employee_cd
	--#M0071
	INSERT INTO #M0071
	SELECT 
		FORMAT(#MAX_M0071.application_date,'yyyy/MM/dd')								AS	application_date
	,	M0071.grade																		AS	grade
	,	M0050.grade_nm																	AS	grade_nm
	--,	''																				AS	grade_length_stay
	,	M0071.belong_cd1																AS	belong_cd1
	,	M0071.belong_cd2																AS	belong_cd2
	,	M0071.belong_cd3																AS	belong_cd3
	,	M0071.belong_cd4																AS	belong_cd4
	,	M0071.belong_cd5																AS	belong_cd5
	,	ISNULL(M0020_CD1.organization_nm,'')											AS	belong_cd1_nm
	,	ISNULL(M0020_CD2.organization_nm,'')											AS	belong_cd2_nm
	,	ISNULL(M0020_CD3.organization_nm,'')											AS	belong_cd3_nm
	,	ISNULL(M0020_CD4.organization_nm,'')											AS	belong_cd4_nm
	,	ISNULL(M0020_CD5.organization_nm,'')											AS	belong_cd5_nm
	--,	''																				AS	number_years_enrolled
	,	M0071.position_cd																AS	position_cd
	,	M0040.position_nm																AS	position_nm
	,	M0071.job_cd																	AS	job_cd
	,	M0030.job_nm																	AS	job_nm
	,	M0071.office_cd																	AS	office_cd
	,	M0010.office_nm																	AS	office_nm
	,	M0071.employee_typ																AS	employee_typ
	,	M0060.employee_typ_nm															AS	employee_typ_nm
	FROM #MAX_M0071
	LEFT OUTER JOIN M0071 ON (
		#MAX_M0071.company_cd		=	M0071.company_cd
	AND #MAX_M0071.employee_cd		=	M0071.employee_cd
	AND #MAX_M0071.application_date	=	M0071.application_date
	)
	LEFT JOIN M0020 AS M0020_CD1 ON (
		M0071.company_cd	=	M0020_CD1.company_cd
	AND	1					=	M0020_CD1.organization_typ
	AND	M0071.belong_cd1	=	M0020_CD1.organization_cd_1
	)
	LEFT JOIN M0020 AS M0020_CD2 ON (
		M0071.company_cd	=	M0020_CD2.company_cd
	AND	2					=	M0020_CD2.organization_typ
	AND	M0071.belong_cd1	=	M0020_CD2.organization_cd_1
	AND	M0071.belong_cd2	=	M0020_CD2.organization_cd_2
	)
	LEFT JOIN M0020 AS M0020_CD3 ON (
		M0071.company_cd	=	M0020_CD3.company_cd
	AND	3					=	M0020_CD3.organization_typ
	AND	M0071.belong_cd1	=	M0020_CD3.organization_cd_1
	AND	M0071.belong_cd2	=	M0020_CD3.organization_cd_2
	AND	M0071.belong_cd3	=	M0020_CD3.organization_cd_3
	)
	LEFT JOIN M0020 AS M0020_CD4 ON (
		M0071.company_cd	=	M0020_CD4.company_cd
	AND	4					=	M0020_CD4.organization_typ
	AND	M0071.belong_cd1	=	M0020_CD4.organization_cd_1
	AND	M0071.belong_cd2	=	M0020_CD4.organization_cd_2
	AND	M0071.belong_cd3	=	M0020_CD4.organization_cd_3
	AND	M0071.belong_cd4	=	M0020_CD4.organization_cd_4
	)
	LEFT JOIN M0020 AS M0020_CD5 ON (
		M0071.company_cd	=	M0020_CD5.company_cd
	AND	5					=	M0020_CD5.organization_typ
	AND	M0071.belong_cd1	=	M0020_CD5.organization_cd_1
	AND	M0071.belong_cd2	=	M0020_CD5.organization_cd_2
	AND	M0071.belong_cd3	=	M0020_CD5.organization_cd_3
	AND	M0071.belong_cd4	=	M0020_CD5.organization_cd_4
	AND	M0071.belong_cd5	=	M0020_CD5.organization_cd_5
	)
	LEFT JOIN M0040 ON (
		M0071.company_cd	=	M0040.company_cd
	AND	M0071.position_cd	=	M0040.position_cd
	)
	LEFT JOIN M0030 ON (
		M0071.company_cd	=	M0030.company_cd
	AND	M0071.job_cd		=	M0030.job_cd
	)
	LEFT JOIN M0010 ON (
		M0071.company_cd	=	M0010.company_cd
	AND	M0071.office_cd		=	M0010.office_cd
	)
	LEFT JOIN M0060 ON (
		M0071.company_cd	=	M0060.company_cd
	AND	M0071.employee_typ	=	M0060.employee_typ
	)
	LEFT JOIN M0050 ON (
		M0071.company_cd	=	M0050.company_cd
	AND	M0071.grade			=	M0050.grade
	)
	--[2] tab 社員情報 (所属情報)
	SELECT 
		@w_grade = grade 
	,	@w_belong_cd1 = belong_cd1
	FROM #M0071

	SELECT 
		FORMAT(application_date, 'yyyy/MM/dd')				AS	application_date
	,	grade												AS	grade
	,	grade_nm											AS	grade_nm
	,	belong_cd1											AS	belong_cd1
	,	belong_cd2											AS	belong_cd2
	,	belong_cd3											AS	belong_cd3
	,	belong_cd4											AS	belong_cd4
	,	belong_cd5											AS	belong_cd5
	,	belong_cd1_nm										AS	belong_cd1_nm
	,	belong_cd2_nm										AS	belong_cd2_nm
	,	belong_cd3_nm										AS	belong_cd3_nm
	,	belong_cd4_nm										AS	belong_cd4_nm
	,	belong_cd5_nm										AS	belong_cd5_nm
	,	position_cd											AS	position_cd
	,	position_nm											AS	position_nm
	,	job_cd												AS	job_cd
	,	job_nm												AS	job_nm
	,	office_cd											AS	office_cd
	,	office_nm											AS	office_nm
	,	employee_typ										AS	employee_typ
	,	employee_typ_nm										AS	employee_typ_nm
	FROM #M0071

	-- update @w_max_application_date
	SELECT 
		@w_max_application_date =	application_date
	FROM #MAX_M0071
	--#M0073
	INSERT INTO #M0073
	SELECT 
		M0073.detail_no												AS	detail_no
	,	M0073.arrange_order											AS	arrange_order
	,	M0073.belong_cd1											AS	belong_cd1
	,	M0073.belong_cd2											AS	belong_cd2
	,	M0073.belong_cd3											AS	belong_cd3
	,	M0073.belong_cd4											AS	belong_cd4
	,	M0073.belong_cd5											AS	belong_cd5
	,	ISNULL(M0020_CD1.organization_nm,'')						AS	belong_cd1_nm
	,	ISNULL(M0020_CD2.organization_nm,'')						AS	belong_cd2_nm
	,	ISNULL(M0020_CD3.organization_nm,'')						AS	belong_cd3_nm
	,	ISNULL(M0020_CD4.organization_nm,'')						AS	belong_cd4_nm
	,	ISNULL(M0020_CD5.organization_nm,'')						AS	belong_cd5_nm
	,	M0073.position_cd											AS	position_cd
	,	M0040.position_nm											AS	position_nm
	FROM M0073 
	LEFT JOIN M0020 AS M0020_CD1 ON (
		M0073.company_cd	=	M0020_CD1.company_cd
	AND	1					=	M0020_CD1.organization_typ
	AND	M0073.belong_cd1	=	M0020_CD1.organization_cd_1
	)
	LEFT JOIN M0020 AS M0020_CD2 ON (
		M0073.company_cd	=	M0020_CD2.company_cd
	AND	2					=	M0020_CD2.organization_typ
	AND	M0073.belong_cd1	=	M0020_CD2.organization_cd_1
	AND	M0073.belong_cd2	=	M0020_CD2.organization_cd_2
	)
	LEFT JOIN M0020 AS M0020_CD3 ON (
		M0073.company_cd	=	M0020_CD3.company_cd
	AND	3					=	M0020_CD3.organization_typ
	AND	M0073.belong_cd1	=	M0020_CD3.organization_cd_1
	AND	M0073.belong_cd2	=	M0020_CD3.organization_cd_2
	AND	M0073.belong_cd3	=	M0020_CD3.organization_cd_3
	)
	LEFT JOIN M0020 AS M0020_CD4 ON (
		M0073.company_cd	=	M0020_CD4.company_cd
	AND	4					=	M0020_CD4.organization_typ
	AND	M0073.belong_cd1	=	M0020_CD4.organization_cd_1
	AND	M0073.belong_cd2	=	M0020_CD4.organization_cd_2
	AND	M0073.belong_cd3	=	M0020_CD4.organization_cd_3
	AND	M0073.belong_cd4	=	M0020_CD4.organization_cd_4
	)
	LEFT JOIN M0020 AS M0020_CD5 ON (
		M0073.company_cd	=	M0020_CD5.company_cd
	AND	5					=	M0020_CD5.organization_typ
	AND	M0073.belong_cd1	=	M0020_CD5.organization_cd_1
	AND	M0073.belong_cd2	=	M0020_CD5.organization_cd_2
	AND	M0073.belong_cd3	=	M0020_CD5.organization_cd_3
	AND	M0073.belong_cd4	=	M0020_CD5.organization_cd_4
	AND	M0073.belong_cd5	=	M0020_CD5.organization_cd_5
	)
	LEFT JOIN M0040 ON (
		M0073.company_cd	=	M0040.company_cd
	AND	M0073.position_cd	=	M0040.position_cd
	)
	WHERE 
		M0073.company_cd		=	@P_company_cd 
	AND M0073.employee_cd		=	@P_employee_cd 
	AND M0073.application_date	=	@w_max_application_date
	AND M0073.del_datetime IS NULL

	--[3] tab 社員情報 (所属情報)
	SELECT * FROM #M0073
	ORDER BY
		#M0073.arrange_order
	,	#M0073.detail_no

	--TAB 所属履歴
	INSERT INTO #HISTORY
	SELECT 
		M0071.application_date
	,	0	
	,	M0071.belong_cd1
	,	M0071.belong_cd2
	,	M0071.belong_cd3
	,	M0071.belong_cd4
	,	M0071.belong_cd5
	,	CASE
			WHEN ISNULL(M0020_1.organization_ab_nm,'') = '' 
			THEN ISNULL(M0020_1.organization_nm,'')	
			ELSE ISNULL(M0020_1.organization_ab_nm,'')
		END											
	,	CASE
			WHEN ISNULL(M0020_2.organization_ab_nm,'') = '' 
			THEN ISNULL(M0020_2.organization_nm,'')	
			ELSE ISNULL(M0020_2.organization_ab_nm,'')
		END																				
	,	CASE
			WHEN ISNULL(M0020_3.organization_ab_nm,'') = '' 
			THEN ISNULL(M0020_3.organization_nm,'')	
			ELSE ISNULL(M0020_3.organization_ab_nm,'')
		END																					
	,	CASE
			WHEN ISNULL(M0020_4.organization_ab_nm,'') = '' 
			THEN ISNULL(M0020_4.organization_nm,'')	
			ELSE ISNULL(M0020_4.organization_ab_nm,'')
		END																					
	,	CASE
			WHEN ISNULL(M0020_5.organization_ab_nm,'') = '' 
			THEN ISNULL(M0020_5.organization_nm,'')	
			ELSE ISNULL(M0020_5.organization_ab_nm,'')
		END																					
	,	CASE
			WHEN ISNULL(M0040.position_ab_nm,'') = '' 
			THEN ISNULL(M0040.position_nm,'')	
			ELSE ISNULL(M0040.position_ab_nm,'')
		END	
	,	ISNULL(M0050.grade_nm,'')
	,	CASE
			WHEN ISNULL(M0030.job_ab_nm,'') = '' 
			THEN ISNULL(M0030.job_nm,'')	
			ELSE ISNULL(M0030.job_ab_nm,'')
		END	
	,	CASE
			WHEN ISNULL(M0010.office_ab_nm,'') = '' 
			THEN ISNULL(M0010.office_nm,'')
			ELSE ISNULL(M0010.office_ab_nm,'')
		END
	,	ISNULL(M0060.employee_typ_nm,'')
	,	0
	,	0
	FROM M0071
	LEFT JOIN M0020 AS M0020_1 ON (
		M0071.company_cd	=	M0020_1.company_cd
	AND	1					=	M0020_1.organization_typ
	AND	M0071.belong_cd1	=	M0020_1.organization_cd_1	
	)
	LEFT JOIN M0020 AS M0020_2 ON (
		M0071.company_cd	=	M0020_2.company_cd
	AND	2					=	M0020_2.organization_typ
	AND	M0071.belong_cd1	=	M0020_2.organization_cd_1
	AND	M0071.belong_cd2	=	M0020_2.organization_cd_2	
	)
	LEFT JOIN M0020 AS M0020_3 ON (
		M0071.company_cd	=	M0020_3.company_cd
	AND	3					=	M0020_3.organization_typ
	AND	M0071.belong_cd1	=	M0020_3.organization_cd_1
	AND	M0071.belong_cd2	=	M0020_3.organization_cd_2
	AND	M0071.belong_cd3	=	M0020_3.organization_cd_3
	)
	LEFT JOIN M0020 AS M0020_4 ON (
		M0071.company_cd	=	M0020_4.company_cd
	AND	4					=	M0020_4.organization_typ
	AND	M0071.belong_cd1	=	M0020_4.organization_cd_1
	AND	M0071.belong_cd2	=	M0020_4.organization_cd_2
	AND	M0071.belong_cd3	=	M0020_4.organization_cd_3
	AND	M0071.belong_cd4	=	M0020_4.organization_cd_4	
	)
	LEFT JOIN M0020 AS M0020_5 ON (
		M0071.company_cd	=	M0020_5.company_cd
	AND	5					=	M0020_5.organization_typ
	AND	M0071.belong_cd1	=	M0020_5.organization_cd_1
	AND	M0071.belong_cd2	=	M0020_5.organization_cd_2
	AND	M0071.belong_cd3	=	M0020_5.organization_cd_3
	AND	M0071.belong_cd4	=	M0020_5.organization_cd_4
	AND	M0071.belong_cd5	=	M0020_5.organization_cd_5	
	)
	LEFT JOIN M0010 ON (
		M0071.company_cd	=	M0010.company_cd
	AND M0071.office_cd		=	M0010.office_cd	
	)
	LEFT JOIN M0030 ON (
		M0071.company_cd	=	M0030.company_cd
	AND M0071.job_cd		=	M0030.job_cd
	)
	LEFT JOIN M0040 ON (
		M0071.company_cd	=	M0040.company_cd
	AND	M0071.position_cd	=	M0040.position_cd
	)
	LEFT JOIN M0050 ON (
		M0071.company_cd	=	M0050.company_cd
	AND	M0071.grade			=	M0050.grade
	)
	LEFT JOIN M0060 ON (
		M0071.company_cd	=	M0060.company_cd
	AND	M0071.employee_typ	=	M0060.employee_typ
	)
	WHERE
		M0071.company_cd	=	@P_company_cd
	AND M0071.employee_cd	=	@P_employee_cd
	AND M0071.del_datetime IS NULL
	ORDER BY 
		application_date DESC

	INSERT INTO #HISTORY
	SELECT
		M0073.application_date
	,	1	
	,	M0073.belong_cd1
	,	M0073.belong_cd2
	,	M0073.belong_cd3
	,	M0073.belong_cd4
	,	M0073.belong_cd5
	,	CASE
			WHEN ISNULL(M0020_1.organization_ab_nm,'') = '' 
			THEN ISNULL(M0020_1.organization_nm,'')	
			ELSE ISNULL(M0020_1.organization_ab_nm,'')
		END											
	,	CASE
			WHEN ISNULL(M0020_2.organization_ab_nm,'') = '' 
			THEN ISNULL(M0020_2.organization_nm,'')	
			ELSE ISNULL(M0020_2.organization_ab_nm,'')
		END																				
	,	CASE
			WHEN ISNULL(M0020_3.organization_ab_nm,'') = '' 
			THEN ISNULL(M0020_3.organization_nm,'')	
			ELSE ISNULL(M0020_3.organization_ab_nm,'')
		END																					
	,	CASE
			WHEN ISNULL(M0020_4.organization_ab_nm,'') = '' 
			THEN ISNULL(M0020_4.organization_nm,'')	
			ELSE ISNULL(M0020_4.organization_ab_nm,'')
		END																					
	,	CASE
			WHEN ISNULL(M0020_5.organization_ab_nm,'') = '' 
			THEN ISNULL(M0020_5.organization_nm,'')	
			ELSE ISNULL(M0020_5.organization_ab_nm,'')
		END																					
	,	CASE
			WHEN ISNULL(M0040.position_ab_nm,'') = '' 
			THEN ISNULL(M0040.position_nm,'')	
			ELSE ISNULL(M0040.position_ab_nm,'')
		END	
	,	''
	,	''
	,	''
	,	''
	,	M0073.arrange_order
	,	M0073.detail_no
	FROM M0073
	LEFT JOIN M0071 ON(
		M0073.company_cd		=	M0071.company_cd
	AND M0073.employee_cd		=	M0071.employee_cd
	AND M0073.application_date	=	M0071.application_date
	)
	LEFT JOIN M0010 ON (
		M0071.company_cd	=	M0010.company_cd
	AND M0071.office_cd		=	M0010.office_cd	
	)
	LEFT JOIN M0020 AS M0020_1 ON (
		M0073.company_cd	=	M0020_1.company_cd
	AND	1					=	M0020_1.organization_typ
	AND	M0073.belong_cd1	=	M0020_1.organization_cd_1	
	)
	LEFT JOIN M0020 AS M0020_2 ON (
		M0073.company_cd	=	M0020_2.company_cd
	AND	2					=	M0020_2.organization_typ
	AND	M0073.belong_cd1	=	M0020_2.organization_cd_1
	AND	M0073.belong_cd2	=	M0020_2.organization_cd_2	
	)
	LEFT JOIN M0020 AS M0020_3 ON (
		M0073.company_cd	=	M0020_3.company_cd
	AND	3					=	M0020_3.organization_typ
	AND	M0073.belong_cd1	=	M0020_3.organization_cd_1
	AND	M0073.belong_cd2	=	M0020_3.organization_cd_2
	AND	M0073.belong_cd3	=	M0020_3.organization_cd_3
	)
	LEFT JOIN M0020 AS M0020_4 ON (
		M0073.company_cd	=	M0020_4.company_cd
	AND	4					=	M0020_4.organization_typ
	AND	M0073.belong_cd1	=	M0020_4.organization_cd_1
	AND	M0073.belong_cd2	=	M0020_4.organization_cd_2
	AND	M0073.belong_cd3	=	M0020_4.organization_cd_3
	AND	M0073.belong_cd4	=	M0020_4.organization_cd_4	
	)
	LEFT JOIN M0020 AS M0020_5 ON (
		M0073.company_cd	=	M0020_5.company_cd
	AND	5					=	M0020_5.organization_typ
	AND	M0073.belong_cd1	=	M0020_5.organization_cd_1
	AND	M0073.belong_cd2	=	M0020_5.organization_cd_2
	AND	M0073.belong_cd3	=	M0020_5.organization_cd_3
	AND	M0073.belong_cd4	=	M0020_5.organization_cd_4
	AND	M0073.belong_cd5	=	M0020_5.organization_cd_5	
	)
	LEFT JOIN M0040 ON (
		M0073.company_cd	=	M0040.company_cd
	AND	M0073.position_cd	=	M0040.position_cd
	)
	WHERE	
		M0073.company_cd	=	@P_company_cd 
	AND M0073.employee_cd	=	@P_employee_cd
	AND M0073.del_datetime IS NULL

	--[4]
	SELECT 
		FORMAT(application_date,'yyyy/MM/dd')					AS	application_date
	,	type													AS	type
	,	arrange_order											AS	arrange_order
	,	detail_no												AS	detail_no
	,	belong_cd1												AS	belong_cd1
	,	belong_cd2												AS	belong_cd2
	,	belong_cd3												AS	belong_cd3
	,	belong_cd4												AS	belong_cd4
	,	belong_cd5												AS	belong_cd5
	,	belong_cd1_nm											AS	belong_cd1_nm
	,	belong_cd2_nm											AS	belong_cd2_nm
	,	belong_cd3_nm											AS	belong_cd3_nm
	,	belong_cd4_nm											AS	belong_cd4_nm
	,	belong_cd5_nm											AS	belong_cd5_nm
	,	position_nm												AS	position_nm
	,	grade_nm												AS	grade_nm
	,	job_nm													AS	job_nm
	,	office_nm												AS	office_nm
	,	employee_typ_nm											AS	employee_typ_nm
	FROM #HISTORY
	ORDER BY
		application_date DESC
	,	arrange_order 
	,	detail_no

	--[5]
	SELECT 
		@w_application_date_grade	=	MAX(M0071.application_date ) 
	FROM M0071
	LEFT JOIN #M0071 ON (
		M0071.company_cd		=	@P_company_cd
	AND M0071.employee_cd		=	@P_employee_cd
	)
	WHERE
		M0071.company_cd		=	@P_company_cd
	AND M0071.employee_cd		=	@P_employee_cd
	AND M0071.grade				<>	#M0071.grade
	AND M0071.application_date	<=	#M0071.application_date
	AND M0071.del_datetime IS NULL

	SELECT  
		@w_application_date_grade = MIN(M0071.application_date )
	FROM M0071
	WHERE 
		M0071.company_cd		= @P_company_cd
	AND (	
		(@w_application_date_grade	IS NULL)
	OR	(@w_application_date_grade	IS NOT NULL	AND M0071.application_date	> @w_application_date_grade)
	)
	AND	M0071.employee_cd		= @P_employee_cd
	AND	del_datetime IS NULL

	IF (@w_application_date_grade IS NULL AND EXISTS (	SELECT 1 
														FROM M0071 
														LEFT JOIN #M0071  ON (
															M0071.company_cd	= @P_company_cd
														AND	M0071.grade			= #M0071.grade
														)
														WHERE  
															M0071.company_cd	= @P_company_cd
														AND	M0071.employee_cd	= @P_employee_cd
														AND ISNULL(M0071.grade,0)			<> 0
														AND	del_datetime IS NULL  )
	)
	BEGIN 
		SET @w_application_date_grade = @w_company_out_dt
	END

	

	SET @month_count =	CASE
							WHEN @w_company_out_dt IS NULL
							THEN DATEDIFF(MM,@w_application_date_grade,@w_time)
							ELSE DATEDIFF(MM,@w_application_date_grade,@w_company_out_dt)
						END
	SELECT	
		CASE	
			WHEN @w_grade > 0 AND @month_count > 0
			THEN IIF(@month_count / 12 = 0,'',CAST(@month_count / 12 AS nvarchar(10)) + IIF(@P_language = 'en', IIF((@month_count / 12) = 1 OR (@month_count / 12) = -1, ' Year ', ' Years '), '年')) +  IIF(@month_count % 12 = 0,'',CAST(@month_count % 12 AS nvarchar(10)) + IIF(@P_language = 'en', IIF((@month_count % 12) = 1 OR (@month_count % 12) = -1, ' Month ', ' Months '), 'ヶ月'))  
			ELSE ''
		END								AS year_grade
	
	--[6]
	SELECT 
		CASE	
			WHEN @w_belong_cd1 <> '' AND @month_count > 0
			THEN IIF(@month_count / 12 = 0,'',CAST(@month_count / 12 AS nvarchar(10)) + IIF(@P_language = 'en', IIF((@month_count / 12) = 1 OR (@month_count / 12) = -1, ' Year ', ' Years '), '年')) +  IIF(@month_count % 12 = 0,'',CAST(@month_count % 12 AS nvarchar(10)) + IIF(@P_language = 'en', IIF((@month_count % 12) = 1 OR (@month_count % 12) = -1, ' Month ', ' Months '), 'ヶ月')) 		
			ELSE ''
		END								AS year_depart
	--[7] Get marcopolo
	SELECT 
		SSO_use_typ
	,	marcopolo_use_typ 
	FROM M0001 
	WHERE 
		company_cd = @P_company_cd
	AND del_datetime IS NULL
END
GO
