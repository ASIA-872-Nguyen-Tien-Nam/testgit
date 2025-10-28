DROP PROCEDURE [SPC_Q0071_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ [[SPC_Q0071_INQ1]]
-- EXEC [SPC_Q0071_INQ1] '10029','a021','721';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	Employee information management
--*  
--*  作成日/create date			:	2018/09/07				
--*　作成者/creater				:	Tuantv								
--*   					
--*  更新日/update date			:	2021/09/17
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	when import data from part then show evalutaion
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_Q0071_INQ1]
	@P_company_cd	SMALLINT	 = 0
,	@P_employee_cd	NVARCHAR(10) = ''
,	@P_user_id		NVARCHAR(60)	=	''
AS
BEGIN
	SET NOCOUNT ON;
	--
	DECLARE 
		@string_column				NVARCHAR(MAX)	= ''
	,	@string_sql					NVARCHAR(MAX)	= ''
	,	@w_feedback_use_typ			INT				=  0
	,	@login_user					NVARCHAR(60)	=	''
	,	@authority_typ				INT				=	''
	--
	CREATE TABLE #TABLE_F0031(
		id							INT			IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					INT
	,	employee_cd					NVARCHAR(10)
	,	treatment_applications_no	SMALLINT
	,	treatment_applications_nm	NVARCHAR(50)
	,	rank_cd						SMALLINT
	,	rank_nm						NVARCHAR(50)
	,	sheet_cd					SMALLINT
	,	sheet_nm					NVARCHAR(50)
	,	evaluation_step				SMALLINT
	,	point_sum					NUMERIC(8,2)
	)
	--
	CREATE TABLE #TABLE_F0030(
		id							INT			IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					INT
	,	treatment_applications_no	INT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	rater_employee_cd_1			SMALLINT
	,	rater_employee_cd_2			SMALLINT
	,	rater_employee_cd_3			SMALLINT
	,	rater_employee_cd_4			SMALLINT
	)
	--
	CREATE TABLE #TABLE_M0200(
		id							INT			IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					INT
	,	treatment_applications_no	SMALLINT
	,	sheet_cd					SMALLINT
	,	sheet_nm					NVARCHAR(50)
	,	sheet_kbn					TINYINT
	,	rank_sheet					INT
	)
	CREATE TABLE #TEMP_M0071(
		count_organizaion_cd INT
	)
	--
	CREATE TABLE #F0032(
		company_cd					INT
	,	fiscal_year					INT
	,	treatment_applications_no	INT
	,	group_cd					INT
	,	employee_cd					NVARCHAR(50)
	,	sheet_cd					INT
	,	weight						INT
	)
	-- GET @w_feedback_use_typ
	SELECT 
		@w_feedback_use_typ = ISNULL(M0100.feedback_use_typ,0)
	FROM M0100
	WHERE 
		M0100.company_cd	=	@P_company_cd
	AND M0100.del_datetime IS NULL
	-- GET @authority_typ , @login_user
	SELECT 
		@authority_typ	= S0010.authority_typ 
	,	@login_user		= employee_cd 
	FROM S0010 
	WHERE 
		S0010.company_cd	=	@P_company_cd  
	AND S0010.user_id		=	@P_user_id 
	AND S0010.del_datetime IS NULL
	--
	INSERT INTO #TABLE_F0030
	SELECT
		ISNULL(F0030.company_cd,0)
	,	ISNULL(F0030.fiscal_year,0)	
	,	ISNULL(F0030.treatment_applications_no,0)	
	,	ISNULL(F0030.group_cd,0)	
	,	ISNULL(F0030.employee_cd,'')
	,	IIF(ISNULL(F0030.rater_employee_cd_1,'') <> '',1,0)
	,	IIF(ISNULL(F0030.rater_employee_cd_2,'') <> '',1,0)
	,	IIF(ISNULL(F0030.rater_employee_cd_3,'') <> '',1,0)
	,	IIF(ISNULL(F0030.rater_employee_cd_4,'') <> '',1,0)
	FROM F0030
	WHERE
		F0030.company_cd	=	@P_company_cd
	AND F0030.employee_cd	=	@P_employee_cd
	AND F0030.del_datetime IS NULL
	--
	INSERT INTO  #F0032
	SELECT
		company_cd
	,	fiscal_year
	,	treatment_applications_no
	,	MAX(group_cd)
	,	employee_cd
	,	sheet_cd
	,	weight
	FROM F0032
	WHERE 
		F0032.company_cd	=	@P_company_cd
	AND F0032.del_datetime IS NULL
	GROUP BY	
		company_cd
	,	fiscal_year
	,	treatment_applications_no
	,	employee_cd
	,	detail_no
	,	sheet_cd
	,	weight
	--
	INSERT INTO #TABLE_F0031
	SELECT 
		ISNULL(#F0032.company_cd,0)				
	,	ISNULL(#F0032.fiscal_year,0)					
	,	ISNULL(#F0032.employee_cd,'')					
	,	ISNULL(#F0032.treatment_applications_no,0)		AS treatment_applications_no
	,	ISNULL(M0102.treatment_applications_nm,'')		
	,	IIF(F0201.evaluatorFB_datetime is not null,ISNULL(F0201.rank_cd,0),NULL) AS rank_cd
	,	IIF(F0201.evaluatorFB_datetime is not null,ISNULL(W_M0130.rank_nm,''),'')					AS rank_nm
	,	ISNULL(#F0032.sheet_cd,0)						AS sheet_cd
	,	ISNULL(W_M0200.sheet_nm,'')						AS sheet_nm		
	,	ISNULL(TABLE_F0030.evaluation_step,0)			AS evaluation_step
	,	0												AS point_sum
	FROM #F0032 
	LEFT JOIN F0011 ON (
		#F0032.company_cd = F0011.company_cd
	AND	#F0032.fiscal_year = F0011.fiscal_year
	AND #F0032.treatment_applications_no = F0011.treatment_applications_no
	) 
	LEFT OUTER JOIN M0102 ON (
		#F0032.company_cd						=	M0102.company_cd
	AND #F0032.treatment_applications_no		=	M0102.detail_no	
	AND M0102.del_datetime IS NULL
	)
	LEFT OUTER JOIN F0201 ON (
		#F0032.company_cd						=	F0201.company_cd
	AND #F0032.fiscal_year						=	F0201.fiscal_year
	AND #F0032.employee_cd						=	F0201.employee_cd
	AND #F0032.treatment_applications_no		=	F0201.treatment_applications_no	
	AND F0201.del_datetime IS NULL
	AND (
		@authority_typ = 4 
	OR (@login_user = #F0032.employee_cd AND F0201.evaluatorFB_datetime IS NOT NULL) 
	OR (@login_user <> #F0032.employee_cd AND F0201.raterFB_datetime IS NOT NULL))
	)
	LEFT OUTER JOIN W_M0130 ON (
		F0201.company_cd						=	W_M0130.company_cd
	AND F0201.rank_cd							=	W_M0130.rank_cd
	AND	F0201.fiscal_year						=	W_M0130.fiscal_year
	AND #F0032.treatment_applications_no		=	W_M0130.treatment_applications_no
	AND	W_M0130.del_datetime IS NULL
	)
	LEFT OUTER JOIN W_M0200 ON (
		#F0032.company_cd						=	W_M0200.company_cd
	AND #F0032.sheet_cd							=	W_M0200.sheet_cd
	AND #F0032.fiscal_year						=	W_M0200.fiscal_year
	AND W_M0200.del_datetime IS NULL
	)
	LEFT OUTER JOIN (
		SELECT 
			#TABLE_F0030.company_cd					AS	company_cd
		,	#TABLE_F0030.fiscal_year				AS	fiscal_year
		,	#TABLE_F0030.employee_cd				AS	employee_cd
		,	#TABLE_F0030.treatment_applications_no	AS	treatment_applications_no
		,	SUM(
				#TABLE_F0030.rater_employee_cd_1
			+	#TABLE_F0030.rater_employee_cd_2
			+	#TABLE_F0030.rater_employee_cd_3
			+	#TABLE_F0030.rater_employee_cd_4
			)
													AS	evaluation_step
		FROM #TABLE_F0030
		GROUP BY
			#TABLE_F0030.company_cd	
		,	#TABLE_F0030.fiscal_year
		,	#TABLE_F0030.treatment_applications_no	
		,	#TABLE_F0030.employee_cd
	) AS TABLE_F0030 ON (
		#F0032.company_cd						=	TABLE_F0030.company_cd
	AND #F0032.fiscal_year						=	TABLE_F0030.fiscal_year
	AND #F0032.employee_cd						=	TABLE_F0030.employee_cd
	AND #F0032.treatment_applications_no		=	TABLE_F0030.treatment_applications_no
	)
	WHERE 
		#F0032.company_cd			=	@P_company_cd
	AND #F0032.employee_cd			=	@P_employee_cd
	AND F0011.use_typ = 1
	AND F0011.sheet_use_typ = 1
	-- add by viettd 2021/09/17
	INSERT INTO #TABLE_F0031
	SELECT 
		ISNULL(F0201.company_cd,0)				
	,	ISNULL(F0201.fiscal_year,0)					
	,	ISNULL(F0201.employee_cd,'')					
	,	ISNULL(F0201.treatment_applications_no,0)		AS treatment_applications_no
	,	ISNULL(M0102.treatment_applications_nm,'')		AS treatment_applications_nm
	,	IIF(F0201.evaluatorFB_datetime is not null,ISNULL(F0201.rank_cd,0),NULL) AS rank_cd
	,	CASE 
			WHEN (W_M0130.rank_cd IS NOT NULL AND F0201.evaluatorFB_datetime is not null)
			THEN ISNULL(W_M0130.rank_nm,'') 
			WHEN (F0201.evaluatorFB_datetime IS NOT NULL)
			THEN ISNULL(M0130.rank_nm,'')
			ELSE ''
		END												AS rank_nm
	,	0												AS sheet_cd
	,	SPACE(0)										AS sheet_nm		
	,	ISNULL(TABLE_F0030.evaluation_step,0)			AS evaluation_step
	,	0												AS point_sum
	FROM F0201
	LEFT OUTER JOIN #TABLE_F0031 ON (
		F0201.company_cd		=	#TABLE_F0031.company_cd
	AND F0201.fiscal_year		=	#TABLE_F0031.fiscal_year
	AND F0201.treatment_applications_no		=	#TABLE_F0031.treatment_applications_no
	AND F0201.employee_cd		=	#TABLE_F0031.employee_cd
	)
	LEFT OUTER JOIN M0102 ON (
		F0201.company_cd						=	M0102.company_cd
	AND F0201.treatment_applications_no			=	M0102.detail_no	
	AND M0102.del_datetime IS NULL
	)
	LEFT JOIN F0011 ON (
		F0201.company_cd = F0011.company_cd
	AND	F0201.fiscal_year = F0011.fiscal_year
	AND F0201.treatment_applications_no = F0011.treatment_applications_no
	) 
	LEFT OUTER JOIN W_M0130 ON (
		F0201.company_cd						=	W_M0130.company_cd
	AND	F0201.fiscal_year						=	W_M0130.fiscal_year
	AND F0201.treatment_applications_no			=	W_M0130.treatment_applications_no
	AND F0201.rank_cd							=	W_M0130.rank_cd
	AND	W_M0130.del_datetime IS NULL
	)
	LEFT OUTER JOIN M0130 ON (
		F0201.company_cd						=	M0130.company_cd
	AND F0201.treatment_applications_no			=	M0130.treatment_applications_no
	AND F0201.rank_cd							=	M0130.rank_cd
	AND	M0130.del_datetime IS NULL
	)
	LEFT OUTER JOIN (
		SELECT 
			#TABLE_F0030.company_cd					AS	company_cd
		,	#TABLE_F0030.fiscal_year				AS	fiscal_year
		,	#TABLE_F0030.employee_cd				AS	employee_cd
		,	#TABLE_F0030.treatment_applications_no	AS	treatment_applications_no
		,	SUM(
				#TABLE_F0030.rater_employee_cd_1
			+	#TABLE_F0030.rater_employee_cd_2
			+	#TABLE_F0030.rater_employee_cd_3
			+	#TABLE_F0030.rater_employee_cd_4
			)
													AS	evaluation_step
		FROM #TABLE_F0030
		GROUP BY
			#TABLE_F0030.company_cd	
		,	#TABLE_F0030.fiscal_year
		,	#TABLE_F0030.treatment_applications_no	
		,	#TABLE_F0030.employee_cd
	) AS TABLE_F0030 ON (
		F0201.company_cd						=	TABLE_F0030.company_cd
	AND F0201.fiscal_year						=	TABLE_F0030.fiscal_year
	AND F0201.employee_cd						=	TABLE_F0030.employee_cd
	AND F0201.treatment_applications_no			=	TABLE_F0030.treatment_applications_no
	)
	WHERE 
		F0201.company_cd		=	@P_company_cd
	AND F0201.employee_cd		=	@P_employee_cd
	AND F0201.del_datetime IS NULL
	AND F0011.use_typ = 1
	AND F0011.sheet_use_typ = 0
	
	-- end add by viettd 2021/09/17
	UPDATE #TABLE_F0031 SET 
		point_sum = ISNULL(F0120.point_sum,0)
	FROM F0120
	LEFT OUTER JOIN (
		SELECT 
			F0120.company_cd							AS	company_cd
		,	F0120.fiscal_year							AS	fiscal_year
		,	F0120.employee_cd							AS	employee_cd
		,	F0120.sheet_cd								AS	sheet_cd
		,	MAX(ISNULL(F0120.evaluation_step,0))		AS	evaluation_step
		FROM F0120
		INNER JOIN #TABLE_F0031  AS TEMP ON (
			F0120.company_cd			=	TEMP.company_cd
		AND F0120.fiscal_year			=	TEMP.fiscal_year
		AND F0120.employee_cd			=	TEMP.employee_cd
		AND F0120.sheet_cd				=	TEMP.sheet_cd
		)
		GROUP BY
			F0120.company_cd							
		,	F0120.fiscal_year							
		,	F0120.employee_cd							
		,	F0120.sheet_cd						
	) AS TABLE_F0120 ON (
		F0120.company_cd					=	TABLE_F0120.company_cd
	AND F0120.fiscal_year					=	TABLE_F0120.fiscal_year
	AND F0120.employee_cd					=	TABLE_F0120.employee_cd
	AND F0120.sheet_cd						=	TABLE_F0120.sheet_cd
	)
	WHERE
		#TABLE_F0031.company_cd				=	F0120.company_cd
	AND #TABLE_F0031.fiscal_year			=	F0120.fiscal_year
	AND #TABLE_F0031.employee_cd			=	F0120.employee_cd
	AND #TABLE_F0031.sheet_cd				=	F0120.sheet_cd
	AND	(
		(#TABLE_F0031.evaluation_step		>	TABLE_F0120.evaluation_step
	AND	F0120.evaluation_step				=	TABLE_F0120.evaluation_step)
	OR	(#TABLE_F0031.evaluation_step		<=	TABLE_F0120.evaluation_step
	AND	F0120.evaluation_step				=	#TABLE_F0031.evaluation_step)
	)
	AND	F0120.company_cd					=	@P_company_cd
	AND F0120.employee_cd					=	@P_employee_cd
	AND	F0120.del_datetime IS NULL
	-- INSERT DATA INTO #TABLE_M0200
	INSERT INTO #TABLE_M0200
	SELECT
		ISNULL(#TABLE_F0031.company_cd,0)					AS company_cd
	,	ISNULL(#TABLE_F0031.fiscal_year,0)					AS fiscal_year
	,	ISNULL(#TABLE_F0031.treatment_applications_no,0)	AS treatment_applications_no
	,	ISNULL(#TABLE_F0031.sheet_cd,0)						AS sheet_cd
	,	ISNULL(W_M0200.sheet_nm,'')							AS sheet_nm
	,	ISNULL(W_M0200.sheet_kbn,0)							AS sheet_kbn
	,	ROW_NUMBER() OVER(PARTITION BY #TABLE_F0031.company_cd,#TABLE_F0031.fiscal_year,#TABLE_F0031.employee_cd,#TABLE_F0031.treatment_applications_no
		ORDER BY #TABLE_F0031.fiscal_year,#TABLE_F0031.employee_cd,#TABLE_F0031.treatment_applications_no) 
 	FROM #TABLE_F0031
	INNER JOIN M0100 ON (
		#TABLE_F0031.company_cd = M0100.company_cd
	)
	LEFT OUTER JOIN W_M0200 ON (
		#TABLE_F0031.company_cd			=	W_M0200.company_cd
	AND #TABLE_F0031.sheet_cd			=	W_M0200.sheet_cd
	AND	#TABLE_F0031.fiscal_year		=	W_M0200.fiscal_year
	)
	WHERE M0100.feedback_use_typ = 1
	AND #TABLE_F0031.sheet_cd <> 0

	
	--z
	INSERT INTO #TEMP_M0071 
	SELECT
		CASE WHEN ISNULL(M0071.belong_cd5,'')<> '' THEN 5
			 WHEN ISNULL(M0071.belong_cd4,'')<> '' THEN 4
			 WHEN ISNULL(M0071.belong_cd3,'')<> '' THEN 3
			 WHEN ISNULL(M0071.belong_cd2,'')<> '' THEN 2
			 WHEN ISNULL(M0071.belong_cd1,'')<> '' THEN 1
		ELSE 0
		END
	FROM M0071
	WHERE M0071.company_cd			= @P_company_cd 
	AND M0071.employee_cd			= @P_employee_cd
	AND M0071.del_datetime IS NULL
	--[0]
	SELECT 
		M0070.company_cd							AS company_cd
	,	M0070.employee_cd							AS employee_cd
	,	ISNULL(M0070.employee_nm,'')				AS employee_nm	
	,	ISNULL(M0070.picture,'')					AS picture	
	,	ISNULL(M0070.employee_typ,0)				AS employee_typ
	,	ISNULL(M0070.belong_cd1,0)					AS belong_cd1
	,	ISNULL(M0070.belong_cd2,0)					AS belong_cd2
	,	ISNULL(M0070.belong_cd3,0)					AS belong_cd3
	,	ISNULL(M0070.belong_cd4,0)					AS belong_cd4
	,	ISNULL(M0070.belong_cd5,0)					AS belong_cd5
	,	ISNULL(M0070.employee_typ,0)				AS employee_typ
	,	ISNULL(M0070.job_cd,0)						AS job_cd
	,	ISNULL(M0070.position_cd,0)					AS position_cd
	,	ISNULL(M0070.grade,0)						AS grade
	,	ISNULL(M0060.employee_typ_nm,'')			AS employee_typ_nm
	,	CASE 
			WHEN  ISNULL(M0030.job_ab_nm,'') = ''
			THEN  ISNULL(M0030.job_nm,'')
			ELSE  ISNULL(M0030.job_ab_nm,'')
		END											AS job_nm	
	,	CASE 
			WHEN  ISNULL(M1.organization_ab_nm,'')	= ''
			THEN  ISNULL(M1.organization_nm,'')
			ELSE  ISNULL(M1.organization_ab_nm,'')
		END											AS belong_cd1_nm										
	,	CASE 
			WHEN  ISNULL(M2.organization_ab_nm,'')	= ''
			THEN  ISNULL(M2.organization_nm,'')
			ELSE  ISNULL(M2.organization_ab_nm,'')
		END											AS belong_cd2_nm		
	,	CASE 
			WHEN  ISNULL(M3.organization_ab_nm,'')	= ''
			THEN  ISNULL(M3.organization_nm,'')
			ELSE  ISNULL(M3.organization_ab_nm,'')
		END											AS belong_cd3_nm		
	,	CASE 
			WHEN  ISNULL(M4.organization_ab_nm,'')	= ''
			THEN  ISNULL(M4.organization_nm,'')
			ELSE  ISNULL(M4.organization_ab_nm,'')
		END											AS belong_cd4_nm	
	,	CASE 
			WHEN  ISNULL(M5.organization_ab_nm,'')	= ''
			THEN  ISNULL(M5.organization_nm,'')
			ELSE  ISNULL(M5.organization_ab_nm,'')
		END											AS belong_cd5_nm	
	,	CASE 
			WHEN  ISNULL(M0040.position_ab_nm,'')	= ''
			THEN  ISNULL(M0040.position_nm,'')
			ELSE  ISNULL(M0040.position_ab_nm,'')
		END											AS position_nm	
																			
	,	ISNULL(M0050.grade_nm,'')					AS grade_nm		
	FROM M0070
	LEFT OUTER JOIN M0071 ON (
		M0070.company_cd			=	M0071.company_cd
	AND M0070.employee_cd			=	M0071.employee_cd
	)
	LEFT OUTER JOIN M0010 ON (
		M0070.company_cd			=	M0010.company_cd
	AND M0070.office_cd				=	M0010.office_cd
	)
	LEFT JOIN M0020 AS M1 ON (
		M1.company_cd			=	M0070.company_cd
	AND M1.organization_cd_1	=	M0070.belong_cd1
	AND M1.organization_typ		=	1
	--AND M1.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M2 ON (
		M2.company_cd			=	M0070.company_cd
	AND M2.organization_cd_1		=	M0070.belong_cd1
	AND M2.organization_cd_2		=	M0070.belong_cd2
	AND M2.organization_typ		=	2
	--AND M2.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M3 ON (
		M3.company_cd			=	M0070.company_cd
	AND M3.organization_cd_1		=	M0070.belong_cd1
	AND M3.organization_cd_2		=	M0070.belong_cd2
	AND M3.organization_cd_3		=	M0070.belong_cd3
	AND M3.organization_typ		=	3
	--AND M2.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M4 ON (
		M4.company_cd			=	M0070.company_cd
	AND M4.organization_cd_1		=	M0070.belong_cd1
	AND M4.organization_cd_2		=	M0070.belong_cd2
	AND M4.organization_cd_3		=	M0070.belong_cd3
	AND M4.organization_cd_4		=	M0070.belong_cd4
	AND M4.organization_typ		=	4
	--AND M2.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M5 ON (
		M5.company_cd			=	M0070.company_cd
	AND M5.organization_cd_1		=	M0070.belong_cd1
	AND M5.organization_cd_2		=	M0070.belong_cd2
	AND M5.organization_cd_3		=	M0070.belong_cd3
	AND M5.organization_cd_4		=	M0070.belong_cd4
	AND M5.organization_cd_5		=	M0070.belong_cd5
	AND M5.organization_typ		=	5
	--AND M2.del_datetime			IS NULL 
	) 
	LEFT JOIN M0030 ON(
		M0070.company_cd			= M0030.company_cd
	AND M0070.job_cd				= M0030.job_cd
	)
	LEFT JOIN M0040 ON(
		M0070.company_cd			= M0040.company_cd
	AND M0070.position_cd			= M0040.position_cd
	)
	LEFT JOIN M0050 ON(
		M0070.company_cd			= M0050.company_cd
	AND M0070.grade					= M0050.grade
	)
	LEFT OUTER JOIN M0060 ON(
		M0070.company_cd			= M0060.company_cd
	AND M0070.employee_typ			= M0060.employee_typ
	)
	WHERE M0070.company_cd			= @P_company_cd
	AND M0070.employee_cd			= @P_employee_cd
	AND M0070.del_datetime IS NULL
	--[1]
	SELECT
		M0071.company_cd							AS company_cd
	,	M0071.employee_cd							AS employee_cd
	,	CASE 
			WHEN  ISNULL(job_ab_nm,'') = ''
			THEN  ISNULL(job_nm,'')
			ELSE  ISNULL(job_ab_nm,'')
		END											AS job_nm	
	,	CASE 
			WHEN  ISNULL(M1.organization_ab_nm,'')	= ''
			THEN  ISNULL(M1.organization_nm,'')
			ELSE  ISNULL(M1.organization_ab_nm,'')
		END											AS belong_cd1_nm										
	,	CASE 
			WHEN  ISNULL(M2.organization_ab_nm,'')	= ''
			THEN  ISNULL(M2.organization_nm,'')
			ELSE  ISNULL(M2.organization_ab_nm,'')
		END											AS belong_cd2_nm		
	,	CASE 
			WHEN  ISNULL(M3.organization_ab_nm,'')	= ''
			THEN  ISNULL(M3.organization_nm,'')
			ELSE  ISNULL(M3.organization_ab_nm,'')
		END											AS belong_cd3_nm		
	,	CASE 
			WHEN  ISNULL(M4.organization_ab_nm,'')	= ''
			THEN  ISNULL(M4.organization_nm,'')
			ELSE  ISNULL(M4.organization_ab_nm,'')
		END											AS belong_cd4_nm		
	,	CASE 
			WHEN  ISNULL(M5.organization_ab_nm,'')	= ''
			THEN  ISNULL(M5.organization_nm,'')
			ELSE  ISNULL(M5.organization_ab_nm,'')
		END											AS belong_cd5_nm		
	,	CASE 
			WHEN  ISNULL(M0040.position_ab_nm,'') = ''
			THEN  ISNULL(M0040.position_nm,'')
			ELSE  ISNULL(M0040.position_ab_nm,'')
		END											AS position_nm	
																	
	,	ISNULL(M0050.grade_nm,'')					AS grade_nm		
	,	FORMAT(M0071.application_date,'yyyy/MM/dd')	AS application_date	
	,	ISNULL(M0071.office_cd,0)					AS office_cd 					
	,	ISNULL(M0071.belong_cd1,0)					AS belong_cd_1b
	,	ISNULL(M0071.belong_cd2,0)					AS belong_cd_2b
	,	ISNULL(M0071.belong_cd3,0)					AS belong_cd_3b
	,	ISNULL(M0071.belong_cd4,0)					AS belong_cd_4b
	,	ISNULL(M0071.belong_cd5,0)					AS belong_cd_5b
	,	ISNULL(M0071.job_cd,0)						AS job_cd 	
	,	ISNULL(M0071.position_cd,0)					AS position_cd 	
	,	ISNULL(M0071.employee_typ,0)				AS employee_typ 	
	,	ISNULL(M0071.grade,0)						AS grade 	
	,	ISNULL(M0010.office_nm,'')					AS office_nm 											
	--,	ISNULL(M0020_C.organization_nm,'')			AS organization_nm_1a
	--,	ISNULL(M0020_D.organization_nm,'')			AS organization_nm_2a													
	,	CASE 
			WHEN  ISNULL(M0030.job_ab_nm,'') = ''
			THEN  ISNULL(M0030.job_nm,'')
			ELSE  ISNULL(M0030.job_ab_nm,'')
		END											AS job_nm 										

																										
	,	ISNULL(M0060.employee_typ_nm,'')			AS employee_typ_nm 												
	,	ISNULL(M0050.grade_nm,'')					AS grade_nm 		
	FROM M0071 
	LEFT OUTER JOIN M0010 ON (
		M0071.company_cd			=	M0010.company_cd
	AND M0071.office_cd				=	M0010.office_cd
	)
	LEFT JOIN M0020 AS M1 ON (
		M1.company_cd			=	M0071.company_cd
	AND M1.organization_cd_1	=	M0071.belong_cd1
	AND M1.organization_typ		=	1
	--AND M1.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M2 ON (
		M2.company_cd			=	M0071.company_cd
	AND M2.organization_cd_1		=	M0071.belong_cd1
	AND M2.organization_cd_2		=	M0071.belong_cd2
	AND M2.organization_typ		=	2
	--AND M2.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M3 ON (
		M3.company_cd			=	M0071.company_cd
	AND M3.organization_cd_1		=	M0071.belong_cd1
	AND M3.organization_cd_2		=	M0071.belong_cd2
	AND M3.organization_cd_3		=	M0071.belong_cd3
	AND M3.organization_typ		=	3
	--AND M2.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M4 ON (
		M4.company_cd			=	M0071.company_cd
	AND M4.organization_cd_1		=	M0071.belong_cd1
	AND M4.organization_cd_2		=	M0071.belong_cd2
	AND M4.organization_cd_3		=	M0071.belong_cd3
	AND M4.organization_cd_4		=	M0071.belong_cd4
	AND M4.organization_typ		=	4
	--AND M2.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M5 ON (
		M5.company_cd			=	M0071.company_cd
	AND M5.organization_cd_1		=	M0071.belong_cd1
	AND M5.organization_cd_2		=	M0071.belong_cd2
	AND M5.organization_cd_3		=	M0071.belong_cd3
	AND M5.organization_cd_4		=	M0071.belong_cd4
	AND M5.organization_cd_5		=	M0071.belong_cd5
	AND M5.organization_typ		=	5
	--AND M2.del_datetime			IS NULL 
	) 
	LEFT JOIN M0030 ON(
		M0071.company_cd			= M0030.company_cd
	AND M0071.job_cd				= M0030.job_cd
	)
	LEFT JOIN M0040 ON(
		M0071.company_cd			= M0040.company_cd
	AND M0071.position_cd			= M0040.position_cd
	)
	LEFT JOIN M0050 ON(
		M0071.company_cd			= M0050.company_cd
	AND M0071.grade					= M0050.grade
	)
	LEFT OUTER JOIN M0060 ON(
		M0071.company_cd			= M0060.company_cd
	AND M0071.employee_typ			= M0060.employee_typ
	)
	WHERE M0071.company_cd			= @P_company_cd 
	AND M0071.employee_cd			= @P_employee_cd
	AND M0071.del_datetime IS NULL
	ORDER BY M0071.application_date DESC

	--[2] 
	--select '#TABLE_M0200',* from #TABLE_M0200
	--select '#TABLE_F0031',* From #TABLE_F0031
	--return 
	

	SELECT @string_column = stuff((select ', ['+ cast((A.rank_sheet) as nvarchar(10))+']'
								 from 
								 (SELECT DISTINCT #TABLE_M0200.rank_sheet FROM #TABLE_M0200) AS A
								 for xml path('')),1,1,'')
	IF @string_column IS NULL
	BEGIN
		SET @string_column = '[1]'
	END
	SET @string_sql = 
	'
	SELECT
		fiscal_year,
		treatment_applications_nm,
		rank_nm,
		'+@string_column+'
	FROM
	(
	SELECT 
		#TABLE_F0031.fiscal_year						
	,	#TABLE_F0031.treatment_applications_nm
	,	#TABLE_F0031.rank_nm
	,	(
		''{"point_sum":'' + CAST(point_sum AS NVARCHAR(10)) +
		'',"sheet_nm":"'' + ISNULL(REPLACE(#TABLE_F0031.sheet_nm, ''"'', ''\"''), '''') +
		''","sheet_cd":'' + CONVERT(NVARCHAR(20), #TABLE_F0031.sheet_cd) +
		'',"sheet_kbn":'' + CONVERT(NVARCHAR(20), #TABLE_M0200.sheet_kbn) +
		''}''
		) as point_sum	
	,	ISNULL(rank_sheet,0) AS rank_sheet
	,	#TABLE_F0031.treatment_applications_no
	FROM #TABLE_F0031
	LEFT OUTER JOIN #TABLE_M0200 ON (
		#TABLE_F0031.company_cd					=	#TABLE_M0200.company_cd
	AND #TABLE_F0031.fiscal_year				=	#TABLE_M0200.fiscal_year
	AND #TABLE_F0031.treatment_applications_no	=	#TABLE_M0200.treatment_applications_no
	AND #TABLE_F0031.sheet_cd					=	#TABLE_M0200.sheet_cd
	)
	) AS P
	Pivot(MAX(point_sum) FOR rank_sheet IN ('+@string_column+')) AS A
	ORDER BY fiscal_year DESC,
	A.treatment_applications_no ASC
	'
	--print @string_sql
	--,	IIF(point_sum=0,NULL,(cast(point_sum as nvarchar(10))	+''|''+ sheet_nm))		as	point_sum
	IF(ISNULL(@string_sql,'') = '')
	BEGIN
		select '1' as tbl2
	END
	ELSE
	BEGIN
		EXEC(@string_sql) 
	END
	--select @string_sql
	--[3]
	SELECT
	MAX(rank_sheet) AS  sheet_num
	FROM #TABLE_M0200

	--[4]
	SELECT @w_feedback_use_typ AS feedback_use_typ
	--[5]
	SELECT 
	CASE WHEN ISNULL(M0022.organization_group_nm,'')   = '' 
		THEN '組織'+CAST(M0022.organization_typ AS NVARCHAR (3))
		ELSE M0022.organization_group_nm
	END AS organization_group_nm
	,	M0022.organization_typ
	FROM M0022 
	WHERE company_cd = @P_company_cd
	--AND use_typ = 1
	AND M0022.del_datetime IS NULL
	--[6]
	SELECT ISNULL(MAX(count_organizaion_cd),0) AS count_organizaion_cd  from #TEMP_M0071
	
END
GO