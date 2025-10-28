DROP PROCEDURE [dbo].[SPC_eQ0101_RPT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- 
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	eQ0101
--*  
--*  作成日/create date			:	2024/04/15						
--*　作成者/creater				:	quanlh								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*   					
--****************************************************************************************
CREATE PROCEDURE [SPC_eQ0101_RPT1]
	-- Add the parameters for the stored procedure here
	@P_language					NVARCHAR(10)		=	N'jp'
,	@P_employee_cd				NVARCHAR(10)		=	N''
,	@P_company_cd				SMALLINT			=	0
,	@P_cre_user					NVARCHAR(50)		=	N''	
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time												DATETIME			=	SYSDATETIME()
	,	@w_year_old											NVARCHAR(10)		=	N''
	,	@total3												MONEY				=	0
	,	@total4												MONEY				=	0
	,	@total6												MONEY				=	0
	,	@total												MONEY				=	0
	,	@sum_total											MONEY				=	0		
	,	@month_count										INT					=	0	
	,	@w_relationship										NVARCHAR(10)		=	N''
	,	@w_i												INT					=	1
	,	@w_cnt												INT					=	0
	,	@w_i_2												INT					=	1
	,	@w_cnt_2											INT					=	0
	,	@w_detail_no										SMALLINT		
	,	@w_detail_no_2										SMALLINT
	--
	CREATE TABLE #CHECK_PER (
		empinfo_authority_typ		INT
	,	tab_id						INT 
	,	use_typ_M5100				INT
	,	use_typ_M9102				INT
	)
	--
	INSERT INTO #CHECK_PER
	SELECT 	
		S0010.empinfo_authority_typ
	,	M5100.tab_id
	,	ISNULL(M5100.use_typ,0) AS use_typ_M5100
	,	NULL
	FROM S0010
	LEFT JOIN M5100 WITH(NOLOCK) ON (
		M5100.company_cd			=  S0010.company_cd
	AND	S0010.empinfo_authority_cd = M5100.authority_cd
	AND M5100.del_datetime IS NULL
	)
	WHERE
		S0010.company_cd = @P_company_cd
	AND	S0010.user_id	 = @P_cre_user
	AND S0010.empinfo_authority_typ IN (3)
	AND	S0010.del_datetime IS NULL
	INSERT INTO #CHECK_PER
	SELECT 	
		S0010.empinfo_authority_typ
	,	M9102.tab_id
	,	NULL
	,	ISNULL(M9102.use_typ,0)	AS use_typ_M9102
	FROM S0010	
	LEFT JOIN M9102 WITH(NOLOCK) ON (
		M9102.company_cd			= S0010.company_cd	
	AND M9102.del_datetime IS NULL
	)	
	WHERE
		S0010.company_cd = @P_company_cd
	AND	S0010.user_id	 = @P_cre_user
	AND S0010.empinfo_authority_typ IN (4,5)
	AND	S0010.del_datetime IS NULL
	-- GET @month_count
	SELECT @month_count = DATEDIFF(MM,M0070.company_in_dt,ISNULL(M0070.company_out_dt,@w_time)) 
	FROM M0070
	WHERE
		company_cd  = @P_company_cd
	AND	employee_cd = @P_employee_cd

	-- language [0]
	SELECT @P_language AS language	
	--[1]
	SELECT 
		M0070.employee_cd
	,	M0070.furigana
	,	M0070.employee_nm
	,	M0070.picture
	,	ISNULL( CONVERT(VARCHAR(10), M0070.company_in_dt, 111)	, NULL) AS company_in_dt
	,	IIF(@month_count / 12 = 0,'',CAST(@month_count / 12 AS nvarchar(10)) +IIF(@P_language = 'en', IIF((@month_count / 12) = 1 OR (@month_count / 12) = -1, ' Year ', ' Years '), '年')) +  IIF(@month_count % 12 = 0,'',CAST(@month_count % 12 AS nvarchar(10)) + IIF(@P_language = 'en', IIF((@month_count % 12) = 1 OR (@month_count % 12) = -1, ' Month ', ' Months '), 'ヶ月')) 
			 AS	period_date
	,	CASE
				WHEN @P_language = N'en'
				THEN ISNULL(L0010_gender.name_english,N'')
				ELSE ISNULL(L0010_gender.name,N'')
		END					AS gender
	,	M0070.picture
	,	ISNULL( CONVERT(VARCHAR(10), M0070.birth_date, 111)	, NULL) AS birth_date
	,	[dbo].FNC_GET_BIRTHDAY_AGE(M0070.birth_date,NULL)	AS	year_old
	,	M0070.mail
	,	M0070.company_mobile_number
	,	M0070.extension_number
	,	ISNULL( CONVERT(VARCHAR(10), M0070.company_out_dt, 111)	, NULL) AS company_out_dt
	,	M0070.retirement_reason	
	,	M0070.salary_grade
	FROM M0070  WITH(NOLOCK)
	LEFT JOIN L0010 AS L0010_gender  WITH(NOLOCK) ON(
		M0070.gender				= L0010_gender.number_cd
	AND	L0010_gender.name_typ		= 68
	AND	L0010_gender.del_datetime IS NULL
	)
	WHERE
		M0070.employee_cd	= @P_employee_cd
	AND	M0070.company_cd	= @P_company_cd
	AND M0070.del_datetime IS NULL
	--[2]
	CREATE TABLE #M0071 (
		application_date		DATE				
	,	grade_nm				NVARCHAR(100)
	,	position_nm				NVARCHAR(100)
	,	job_nm					NVARCHAR(100)
	,	office_nm				NVARCHAR(100)
	,	employee_typ_nm			NVARCHAR(100)
	,	organization_cd_1		NVARCHAR(100)
	,	organization_cd_2		NVARCHAR(100)
	,	organization_cd_3		NVARCHAR(100)
	,	organization_cd_4		NVARCHAR(100)
	,	organization_cd_5		NVARCHAR(100)
	)						
	--	
	INSERT #M0071
	SELECT TOP 1
		ISNULL( CONVERT(VARCHAR(10), M0071.application_date, 111)	, NULL) AS application_date
	,	ISNULL(M0050.grade_nm, N'')				AS grade_nm
	,	CASE
			WHEN ISNULL(M0040.position_ab_nm,'') = '' THEN m0040.position_nm	
			ELSE M0040.position_ab_nm
		END		AS position_nm
	,	CASE
			WHEN ISNULL(M0030.job_ab_nm,'') = '' THEN m0030.job_nm	
			ELSE M0030.job_ab_nm
		END		AS job_nm
	,	CASE
			WHEN ISNULL(M0010.office_ab_nm,'') = '' THEN M0010.office_nm
			ELSE M0010.office_ab_nm
		END	AS office_nm
	,	ISNULL(M0060.employee_typ_nm  , N'')	AS employee_typ_nm
	,	CASE
				WHEN ISNULL(m0020_1.organization_ab_nm,'') = '' THEN m0020_1.organization_nm	
				ELSE m0020_1.organization_ab_nm
			END									AS organization_cd_1
	,	CASE
				WHEN ISNULL(m0020_2.organization_ab_nm,'') = '' THEN m0020_2.organization_nm	
				ELSE m0020_2.organization_ab_nm
			END									AS organization_cd_2
	,	CASE
				WHEN ISNULL(m0020_3.organization_ab_nm,'') = '' THEN m0020_3.organization_nm	
				ELSE m0020_3.organization_ab_nm
			END									AS organization_cd_3
	,	CASE
				WHEN ISNULL(m0020_4.organization_ab_nm,'') = '' THEN m0020_4.organization_nm	
				ELSE m0020_4.organization_ab_nm
			END									AS organization_cd_4
	,	CASE
				WHEN ISNULL(m0020_5.organization_ab_nm,'') = '' THEN m0020_5.organization_nm	
				ELSE m0020_5.organization_ab_nm
			END									AS organization_cd_5
	FROM M0071 WITH(NOLOCK)
	LEFT JOIN M0010 WITH(NOLOCK) ON (
			M0071.company_cd	= M0010.company_cd
		AND M0071.office_cd		= M0010.office_cd
	)
	LEFT JOIN M0030 WITH(NOLOCK) ON ( 
			M0071.company_cd	= M0030.company_cd
		AND M0071.job_cd		= M0030.job_cd
	)
	LEFT JOIN M0040 WITH(NOLOCK) ON (
			M0071.company_cd	= M0040.company_cd
		AND	M0071.position_cd	= M0040.position_cd
	)
	LEFT JOIN M0050 WITH(NOLOCK) ON( 
			M0071.company_cd	= M0050.company_cd
		AND	M0071.grade	= M0050.grade
		)
	LEFT JOIN M0060 WITH(NOLOCK) ON (
			M0071.company_cd	= M0060.company_cd
		AND	M0071.employee_typ	= M0060.employee_typ
	)
	LEFT JOIN M0020 AS M0020_1 WITH(NOLOCK) ON(
			M0071.company_cd	= M0020_1.company_cd
		AND	1					= M0020_1.organization_typ
		AND	M0071.belong_cd1	= M0020_1.organization_cd_1	
	)
	LEFT JOIN M0020 AS M0020_2  WITH(NOLOCK) ON(
			M0071.company_cd	= M0020_2.company_cd
		AND	2					= M0020_2.organization_typ
		AND	M0071.belong_cd1	= M0020_2.organization_cd_1
		AND	M0071.belong_cd2	= M0020_2.organization_cd_2	
	)
	LEFT JOIN M0020 AS M0020_3  WITH(NOLOCK) ON( 
			M0071.company_cd	= M0020_3.company_cd
		AND	3					= M0020_3.organization_typ
		AND	M0071.belong_cd1	= M0020_3.organization_cd_1
		AND	M0071.belong_cd2	= M0020_3.organization_cd_2
		AND	M0071.belong_cd3	= M0020_3.organization_cd_3	
	)
	LEFT JOIN M0020 AS M0020_4  WITH(NOLOCK) ON( 
			M0071.company_cd	= M0020_4.company_cd
		AND	4					= M0020_4.organization_typ
		AND	M0071.belong_cd1	= M0020_4.organization_cd_1
		AND	M0071.belong_cd2	= M0020_4.organization_cd_2
		AND	M0071.belong_cd3	= M0020_4.organization_cd_3
		AND	M0071.belong_cd4	= M0020_4.organization_cd_4	
	)
	LEFT JOIN M0020 AS M0020_5  WITH(NOLOCK) ON( 
			M0071.company_cd	= M0020_5.company_cd
		AND	5					= M0020_5.organization_typ
		AND	M0071.belong_cd1	= M0020_5.organization_cd_1
		AND	M0071.belong_cd2	= M0020_5.organization_cd_2
		AND	M0071.belong_cd3	= M0020_5.organization_cd_3
		AND	M0071.belong_cd4	= M0020_5.organization_cd_4
		AND	M0071.belong_cd5	= M0020_5.organization_cd_5	
	)
	WHERE
		M0071.employee_cd	= @P_employee_cd
	AND	M0071.company_cd	= @P_company_cd
	AND M0071.del_datetime IS NULL
	ORDER BY application_date DESC
	--
	SELECT TOP 1
		ISNULL( CONVERT(VARCHAR(10), #M0071.application_date, 111)	, NULL) AS application_date
	,	#M0071.grade_nm
	,	#M0071.position_nm
	,	#M0071.job_nm
	,	#M0071.office_nm
	,	#M0071.employee_typ_nm
	,	#M0071.organization_cd_1
	,	#M0071.organization_cd_2
	,	#M0071.organization_cd_3
	,	#M0071.organization_cd_4
	,	#M0071.organization_cd_5
	FROM #M0071
	--[3]
	SELECT TOP 3
		CASE
				WHEN ISNULL(m0020_1.organization_ab_nm,'') = '' THEN m0020_1.organization_nm	
				ELSE m0020_1.organization_ab_nm
			END									AS organization_cd_1
	,	CASE
				WHEN ISNULL(m0020_2.organization_ab_nm,'') = '' THEN m0020_2.organization_nm	
				ELSE m0020_2.organization_ab_nm
			END									AS organization_cd_2
	,	CASE
				WHEN ISNULL(m0020_3.organization_ab_nm,'') = '' THEN m0020_3.organization_nm	
				ELSE m0020_3.organization_ab_nm
			END									AS organization_cd_3
	,	CASE
				WHEN ISNULL(m0020_4.organization_ab_nm,'') = '' THEN m0020_4.organization_nm	
				ELSE m0020_4.organization_ab_nm
			END									AS organization_cd_4
	,	CASE
				WHEN ISNULL(m0020_5.organization_ab_nm,'') = '' THEN m0020_5.organization_nm	
				ELSE m0020_5.organization_ab_nm
			END									AS organization_cd_5
	,	CASE
			WHEN ISNULL(M0040.position_ab_nm,'') = '' THEN m0040.position_nm	
			ELSE M0040.position_ab_nm
		END										AS position_nm
	,	M0073.arrange_order
	,	M0073.detail_no
	,	M0073.application_date
	FROM M0073 WITH(NOLOCK)
	INNER JOIN #M0071 WITH(NOLOCK) ON(		
		 M0073.application_date = #M0071.application_date
	)
	LEFT JOIN M0040 WITH(NOLOCK) ON (
			M0073.company_cd	= M0040.company_cd
		AND	M0073.position_cd	= M0040.position_cd
	)
	LEFT JOIN M0020 AS M0020_1 WITH(NOLOCK) ON(
			M0073.company_cd	= M0020_1.company_cd
		AND	1					= M0020_1.organization_typ
		AND	M0073.belong_cd1	= M0020_1.organization_cd_1	
	)
	LEFT JOIN M0020 AS M0020_2  WITH(NOLOCK) ON(
			M0073.company_cd	= M0020_2.company_cd
		AND	2					= M0020_2.organization_typ
		AND	M0073.belong_cd1	= M0020_2.organization_cd_1
		AND	M0073.belong_cd2	= M0020_2.organization_cd_2	
	)
	LEFT JOIN M0020 AS M0020_3  WITH(NOLOCK) ON( 
			M0073.company_cd	= M0020_3.company_cd
		AND	3					= M0020_3.organization_typ
		AND	M0073.belong_cd1	= M0020_3.organization_cd_1
		AND	M0073.belong_cd2	= M0020_3.organization_cd_2
		AND	M0073.belong_cd3	= M0020_3.organization_cd_3	
	)
	LEFT JOIN M0020 AS M0020_4  WITH(NOLOCK) ON( 
			M0073.company_cd	= M0020_4.company_cd
		AND	4					= M0020_4.organization_typ
		AND	M0073.belong_cd1	= M0020_4.organization_cd_1
		AND	M0073.belong_cd2	= M0020_4.organization_cd_2
		AND	M0073.belong_cd3	= M0020_4.organization_cd_3
		AND	M0073.belong_cd4	= M0020_4.organization_cd_4	
	)
	LEFT JOIN M0020 AS M0020_5  WITH(NOLOCK) ON( 
			M0073.company_cd	= M0020_5.company_cd
		AND	5					= M0020_5.organization_typ
		AND	M0073.belong_cd1	= M0020_5.organization_cd_1
		AND	M0073.belong_cd2	= M0020_5.organization_cd_2
		AND	M0073.belong_cd3	= M0020_5.organization_cd_3
		AND	M0073.belong_cd4	= M0020_5.organization_cd_4
		AND	M0073.belong_cd5	= M0020_5.organization_cd_5	
	)
	WHERE
		M0073.employee_cd	= @P_employee_cd
	AND	M0073.company_cd	= @P_company_cd
	AND M0073.application_date = #M0071.application_date
	AND M0073.del_datetime IS NULL
	ORDER BY
		M0073.application_date	DESC
	,	M0073.arrange_order		ASC
	,	M0073.detail_no
		
	--[4]
	CREATE TABLE #M0071_2 (
		application_date		DATE				
	,	office_nm				NVARCHAR(100)
	,	belong_cd1_nm			NVARCHAR(100)
	,	belong_cd2_nm			NVARCHAR(100)
	,	belong_cd3_nm			NVARCHAR(100)
	,	belong_cd4_nm			NVARCHAR(100)
	,	belong_cd5_nm			NVARCHAR(100)
	,	position_nm				NVARCHAR(100)
	,	job_nm					NVARCHAR(100)
	,	employee_typ_nm			NVARCHAR(100)
	,	grade_nm				NVARCHAR(100)
	)	
	--
	INSERT #M0071_2
	SELECT TOP 2
			ISNULL( CONVERT(VARCHAR(10), M0071.application_date, 111)	, NULL) AS application_date		 
		  ,	CASE
				WHEN ISNULL(M0010.office_ab_nm, N'') = '' THEN ISNULL(M0010.office_nm, N'')
				ELSE ISNULL(M0010.office_ab_nm, N'')
			END AS office_nm
		  ,CASE
				WHEN ISNULL(m0020_1.organization_ab_nm,'') = '' THEN ISNULL(m0020_1.organization_nm, N'')
				ELSE ISNULL(m0020_1.organization_ab_nm, N'')
			END																						AS belong_cd1_nm
		  ,CASE
				WHEN ISNULL(m0020_2.organization_ab_nm,'') = '' THEN ISNULL(m0020_2.organization_nm, N'')	
				ELSE ISNULL(m0020_2.organization_ab_nm, N'')
			END																						AS belong_cd2_nm
		  ,CASE
				WHEN ISNULL(m0020_3.organization_ab_nm,'') = '' THEN ISNULL(m0020_3.organization_nm, N'')	
				ELSE ISNULL(m0020_3.organization_ab_nm, N'')
			END																						AS belong_cd3_nm
		  ,CASE
				WHEN ISNULL(m0020_4.organization_ab_nm,'') = '' THEN ISNULL(m0020_4.organization_nm, N'')	
				ELSE ISNULL(m0020_4.organization_ab_nm, N'')
			END																						AS belong_cd4_nm
		  ,CASE
				WHEN ISNULL(m0020_5.organization_ab_nm,'') = '' THEN ISNULL(m0020_5.organization_nm	, N'')
				ELSE ISNULL(m0020_5.organization_ab_nm, N'')
			END																						AS belong_cd5_nm
		  ,	CASE
				WHEN ISNULL(m0040.position_ab_nm,'') = '' THEN ISNULL(m0040.position_nm	, N'')
				ELSE ISNULL(m0040.position_ab_nm , N'')
			END	AS position_nm
		  ,	CASE
				WHEN ISNULL(m0030.job_ab_nm,'') = '' THEN ISNULL(m0030.job_nm, N'')	
				ELSE ISNULL(m0030.job_ab_nm, N'')
			END	 AS job_nm
		  ,	ISNULL(M0060.employee_typ_nm, N'')	AS employee_typ_nm
		  ,	ISNULL(M0050.grade_nm, N'') AS grade_nm
		FROM M0071 WITH(NOLOCK)
		LEFT JOIN M0010 WITH(NOLOCK) ON(  
			M0071.company_cd	= M0010.company_cd
		AND M0071.office_cd		= M0010.office_cd
		)
		LEFT JOIN M0020 AS M0020_1 WITH(NOLOCK) ON(  
			M0071.company_cd	= M0020_1.company_cd
		AND	1					= M0020_1.organization_typ
		AND	M0071.belong_cd1	= M0020_1.organization_cd_1	
		)
		LEFT JOIN M0020 AS M0020_2 WITH(NOLOCK) ON(  
			M0071.company_cd	= M0020_2.company_cd
		AND	2					= M0020_2.organization_typ
		AND	M0071.belong_cd1	= M0020_2.organization_cd_1
		AND	M0071.belong_cd2	= M0020_2.organization_cd_2	
		)
		LEFT JOIN M0020 AS M0020_3 WITH(NOLOCK) ON(  
			M0071.company_cd	= M0020_3.company_cd
		AND	3					= M0020_3.organization_typ
		AND	M0071.belong_cd1	= M0020_3.organization_cd_1
		AND	M0071.belong_cd2	= M0020_3.organization_cd_2
		AND	M0071.belong_cd3	= M0020_3.organization_cd_3	
		)
		LEFT JOIN M0020 AS M0020_4 WITH(NOLOCK) ON(  
			M0071.company_cd	= M0020_4.company_cd
		AND	4					= M0020_4.organization_typ
		AND	M0071.belong_cd1	= M0020_4.organization_cd_1
		AND	M0071.belong_cd2	= M0020_4.organization_cd_2
		AND	M0071.belong_cd3	= M0020_4.organization_cd_3
		AND	M0071.belong_cd4	= M0020_4.organization_cd_4	
		)
		LEFT JOIN M0020 AS M0020_5 WITH(NOLOCK) ON(  
			M0071.company_cd	= M0020_5.company_cd
		AND	5					= M0020_5.organization_typ
		AND	M0071.belong_cd1	= M0020_5.organization_cd_1
		AND	M0071.belong_cd2	= M0020_5.organization_cd_2
		AND	M0071.belong_cd3	= M0020_5.organization_cd_3
		AND	M0071.belong_cd4	= M0020_5.organization_cd_4
		AND	M0071.belong_cd5	= M0020_5.organization_cd_5	
		)
		LEFT JOIN M0030 WITH(NOLOCK) ON(  
			M0071.company_cd	= M0030.company_cd
		AND M0071.job_cd		= M0030.job_cd
		)
		LEFT JOIN M0040 WITH(NOLOCK) ON( 
			M0071.company_cd	= M0040.company_cd
		AND	M0071.position_cd	= M0040.position_cd
		)
		LEFT JOIN M0050 WITH(NOLOCK) ON( 
			M0071.company_cd	= M0050.company_cd
		AND	M0071.grade	= M0050.grade
		)
		LEFT JOIN M0060 WITH(NOLOCK) ON( 
			M0071.company_cd	= M0060.company_cd
		AND	M0071.employee_typ	= M0060.employee_typ
		)
		WHERE	
			M0071.company_cd = @P_company_cd 
		AND employee_cd = @P_employee_cd
		AND M0071.del_datetime IS NULL
		ORDER BY
			M0071.application_date DESC
	SELECT 
		ISNULL( CONVERT(VARCHAR(10), #M0071_2.application_date, 111)	, NULL) AS application_date		
	,	grade_nm			
	,	belong_cd1_nm		
	,	belong_cd2_nm		
	,	belong_cd3_nm		
	,	belong_cd4_nm		
	,	belong_cd5_nm	
	,	position_nm			
	,	job_nm				
	,	office_nm			
	,	employee_typ_nm		
	FROM #M0071_2
	--
	CREATE TABLE #M0073 (
		id					INT
	,	application_date	NVARCHAR(500)
	,	belong_cd1_nm		NVARCHAR(500)
	,	belong_cd2_nm		NVARCHAR(500)
	,	belong_cd3_nm		NVARCHAR(500)
	,	belong_cd4_nm		NVARCHAR(500)
	,	belong_cd5_nm		NVARCHAR(500)
	,	position_nm			NVARCHAR(500)
	,	detail_no			INT
	,	arrange_order		INT
	)
	--	[5]
	INSERT INTO #M0073
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY M0073.application_date ORDER BY M0073.detail_no) as id
	,	ISNULL( CONVERT(VARCHAR(10), #M0071_2.application_date, 111)	, NULL) AS application_date	  
	,	CASE
			WHEN ISNULL(m0020_1.organization_ab_nm,'') = '' THEN m0020_1.organization_nm	
			ELSE m0020_1.organization_ab_nm
		END																						AS belong_cd1_nm
	,	CASE
			WHEN ISNULL(m0020_2.organization_ab_nm,'') = '' THEN m0020_2.organization_nm	
			ELSE m0020_2.organization_ab_nm
		END																						AS belong_cd2_nm
	,	CASE
			WHEN ISNULL(m0020_3.organization_ab_nm,'') = '' THEN m0020_3.organization_nm	
			ELSE m0020_3.organization_ab_nm
		END																						AS belong_cd3_nm
	,	CASE
			WHEN ISNULL(m0020_4.organization_ab_nm,'') = '' THEN m0020_4.organization_nm	
			ELSE m0020_4.organization_ab_nm
		END																						AS belong_cd4_nm
	,	CASE
			WHEN ISNULL(m0020_5.organization_ab_nm,'') = '' THEN m0020_5.organization_nm	
			ELSE m0020_5.organization_ab_nm
		END																						AS belong_cd5_nm
	,	CASE
			WHEN ISNULL(m0040.position_ab_nm,'') = '' THEN M0040.position_nm	
			ELSE M0040.position_ab_nm
		END	AS 	position_nm 		
	,	M0073.detail_no
	,	M0073.arrange_order
	FROM  M0073 WITH(NOLOCK)
	LEFT JOIN  #M0071_2 ON(
		M0073.application_date = #M0071_2.application_date
	 AND M0073.del_datetime IS NULL
	) 
	LEFT JOIN M0020 AS M0020_1 WITH(NOLOCK) ON(  
		M0073.company_cd	= M0020_1.company_cd
	AND	1					= M0020_1.organization_typ
	AND	M0073.belong_cd1	= M0020_1.organization_cd_1		)
	LEFT JOIN M0020 AS M0020_2 WITH(NOLOCK) ON(  
		M0073.company_cd	= M0020_2.company_cd
	AND	2					= M0020_2.organization_typ
	AND	M0073.belong_cd1	= M0020_2.organization_cd_1
	AND	M0073.belong_cd2	= M0020_2.organization_cd_2	
	)
	LEFT JOIN M0020 AS M0020_3 WITH(NOLOCK) ON(  
		M0073.company_cd	= M0020_3.company_cd
	AND	3					= M0020_3.organization_typ
	AND	M0073.belong_cd1	= M0020_3.organization_cd_1
	AND	M0073.belong_cd2	= M0020_3.organization_cd_2
	AND	M0073.belong_cd3	= M0020_3.organization_cd_3	
	)
	LEFT JOIN M0020 AS M0020_4 WITH(NOLOCK) ON(  
		M0073.company_cd	= M0020_4.company_cd
	AND	4					= M0020_4.organization_typ
	AND	M0073.belong_cd1	= M0020_4.organization_cd_1
	AND	M0073.belong_cd2	= M0020_4.organization_cd_2
	AND	M0073.belong_cd3	= M0020_4.organization_cd_3
	AND	M0073.belong_cd4	= M0020_4.organization_cd_4	
	)
	LEFT JOIN M0020 AS M0020_5 WITH(NOLOCK) ON(  
		M0073.company_cd	= M0020_5.company_cd
	AND	5					= M0020_5.organization_typ
	AND	M0073.belong_cd1	= M0020_5.organization_cd_1
	AND	M0073.belong_cd2	= M0020_5.organization_cd_2
	AND	M0073.belong_cd3	= M0020_5.organization_cd_3
	AND	M0073.belong_cd4	= M0020_5.organization_cd_4
	AND	M0073.belong_cd5	= M0020_5.organization_cd_5	
	)	
	LEFT JOIN M0040 WITH(NOLOCK) ON( 
		M0073.company_cd	= M0040.company_cd
	AND	M0073.position_cd	= M0040.position_cd
	)
	WHERE 
		M0073.del_datetime IS NULL
	AND	M0073.company_cd = @P_company_cd
	AND	M0073.employee_cd = @P_employee_cd
	ORDER BY 
		application_date		DESC
	,	M0073.arrange_order		ASC
	,	M0073.detail_no			
	--
	CREATE TABLE #M0073_2 (	
		application_date	NVARCHAR(500)
	,	belong_cd1_nm		NVARCHAR(500)
	,	belong_cd2_nm		NVARCHAR(500)
	,	belong_cd3_nm		NVARCHAR(500)
	,	belong_cd4_nm		NVARCHAR(500)
	,	belong_cd5_nm		NVARCHAR(500)
	,	position_nm			NVARCHAR(500)
	,	detail_no			INT
	)
	INSERT INTO #M0073_2
	SELECT TOP 2
		ISNULL(#M0073.application_date, NULL) AS application_date
	,	ISNULL(#M0073.belong_cd1_nm, N'')	AS 	belong_cd1_nm
	,	ISNULL(#M0073.belong_cd2_nm, N'')	AS 	belong_cd2_nm
	,	ISNULL(#M0073.belong_cd3_nm, N'')	AS 	belong_cd3_nm
	,	ISNULL(#M0073.belong_cd4_nm, N'')	AS 	belong_cd4_nm
	,	ISNULL(#M0073.belong_cd5_nm, N'')	AS 	belong_cd5_nm
	,	ISNULL(#M0073.position_nm, N'')		AS 	position_nm	
	,	ISNULL(#M0073.detail_no, 0)			AS detail_no
	FROM #M0073
	INNER JOIN (SELECT 
		a.application_date
	,	b.arrange_order
	,	MIN(a.detail_no) as detail_no
	FROM  #M0073 as a INNER join (
	SELECT 
		ISNULL(application_date,NULL) AS application_date
	,	ISNULL(MIN(arrange_order), 0) AS arrange_order
	FROM #M0073	
	WHERE
		id IS NOT NULL
	GROUP BY 
		application_date) as b on(a.application_date = b.application_date and a.arrange_order = b.arrange_order)  
		group by a.application_date,b.arrange_order) as temp ON (
		#M0073.arrange_order = temp.arrange_order
	AND #M0073.detail_no = temp.detail_no
	AND #M0073.application_date = temp.application_date
	)
	WHERE
		id IS NOT NULL	
	ORDER BY 
		#M0073.application_date DESC
	--
	SELECT 
		ISNULL(#M0073_2.application_date, NULL) AS application_date
	,	ISNULL(#M0073_2.belong_cd1_nm, N'')	AS 	belong_cd1_nm
	,	ISNULL(#M0073_2.belong_cd2_nm, N'')	AS 	belong_cd2_nm
	,	ISNULL(#M0073_2.belong_cd3_nm, N'')	AS 	belong_cd3_nm
	,	ISNULL(#M0073_2.belong_cd4_nm, N'')	AS 	belong_cd4_nm
	,	ISNULL(#M0073_2.belong_cd5_nm, N'')	AS 	belong_cd5_nm
	,	ISNULL(#M0073_2.position_nm, N'')		AS 	position_nm	
	,	ISNULL(#M0073_2.detail_no, 0)			AS detail_no
	FROM #M0071_2
	LEFT JOIN #M0073_2 ON (
		#M0071_2.application_date = #M0073_2.application_date
	)
	--[6]
	SELECT *
FROM (
    SELECT 
        CASE WHEN ISNULL(M0022.organization_group_nm, '') = '' 
            THEN '組織' + CAST(M0022.organization_typ AS NVARCHAR(3))
            ELSE M0022.organization_group_nm
        END AS organization_group_nm,
        M0022.organization_typ
    FROM M0022 
    WHERE company_cd = @P_company_cd
    AND M0022.del_datetime IS NULL
) AS SourceTable
PIVOT (
    MAX(organization_group_nm)
    FOR organization_typ IN ([1], [2], [3], [4], [5])
) AS PivotTable;

	--tab その他社員情報 [7]
	IF EXISTS (SELECT * FROM #CHECK_PER WHERE (empinfo_authority_typ IN (4,5) AND tab_id = 1 AND use_typ_M9102 = 1) OR (empinfo_authority_typ = 3 AND tab_id = 1  AND use_typ_M5100 <> 0 ))
	BEGIN
		SELECT	
		CASE
				WHEN @P_language = N'en'
				THEN ISNULL(blood.name_english,N'')
				ELSE ISNULL(blood.name,N'')
		END	AS blood_type
	,	L0011.name AS headquarters_prefectures
	,	ISNULL(M0074.headquarters_other,N'') AS headquarters_other
	,	CASE
				WHEN @P_language = N'en'
				THEN ISNULL(possi.name_english,N'')
				ELSE ISNULL(possi.name,N'')
		END	AS possibility_transfer
	,	CASE
				WHEN @P_language = N'en'
				THEN ISNULL(nat.name_en,N'')
				ELSE ISNULL(nat.name,N'')
		END	AS nationality
	,	ISNULL(M0074.residence_card_no,N'') AS residence_card_no
	,	CASE
				WHEN @P_language = N'en'
				THEN ISNULL(sta.name_english,N'')
				ELSE ISNULL(sta.name,N'')
		END	AS status_residence
	,	ISNULL( CONVERT(VARCHAR(10), M0074.expiry_date, 111)	, NULL)	AS expiry_date
	,	CASE
				WHEN @P_language = N'en'
				THEN ISNULL(per.name_english,N'')
				ELSE ISNULL(per.name,N'')
		END	AS permission_activities
	,	CASE
				WHEN @P_language = N'en'
				THEN ISNULL(disabili.name_english,N'')
				ELSE ISNULL(disabili.name,N'')
		END	AS disability_classification
	,	ISNULL( CONVERT(VARCHAR(10), M0074.disability_recognition_date, 111)	, NULL)	AS disability_recognition_date
	,	ISNULL(M0074.disability_content,N'')		AS disability_content
	,	ISNULL(M0074.common_name,N'')				AS common_name
	,	ISNULL(M0074.common_name_furigana,N'')		AS common_name_furigana
	,	ISNULL(M0074.maiden_name,N'')				AS maiden_name
	,	ISNULL(M0074.maiden_name_furigana,N'')		AS maiden_name_furigana
	,	ISNULL(M0074.business_name,N'')				AS business_name
	,	ISNULL(M0074.business_name_furigana,N'')	AS business_name_furigana
	,	CASE
				WHEN @P_language = N'en'
				THEN ISNULL(base.name_english,N'')
				ELSE ISNULL(base.name,N'')
		END	AS base_style	
	,	CASE
				WHEN @P_language = N'en'
				THEN ISNULL(sub.name_english,N'')
				ELSE ISNULL(sub.name,N'')
		END	AS sub_style	
	,	ISNULL(M0074.driver_point,0)		AS driver_point
	,	ISNULL(M0074.analytical_point,0)	AS analytical_point
	,	ISNULL(M0074.expressive_point,0)	AS expressive_point
	,	ISNULL(M0074.amiable_point,0)		AS amiable_point
	FROM M0074 WITH(NOLOCK)
	LEFT JOIN L0010 AS base WITH(NOLOCK) ON(
		M0074.base_style = base.number_cd
	AND	base.name_typ				= 18
	AND	base.del_datetime IS NULL
	)
	LEFT JOIN L0010 AS sub WITH(NOLOCK) ON(
		M0074.sub_style = sub.number_cd
	AND	sub.name_typ				= 18
	AND	sub.del_datetime IS NULL
	)
	LEFT JOIN L0010 AS blood WITH(NOLOCK) ON(
		M0074.blood_type = blood.number_cd
	AND	blood.name_typ				= 52
	AND	blood.del_datetime IS NULL
	)
	LEFT JOIN L0010 AS possi WITH(NOLOCK) ON(
		M0074.possibility_transfer = possi.number_cd
	AND	possi.name_typ				= 53
	AND	possi.del_datetime IS NULL
	)
	LEFT JOIN L0012 AS nat WITH(NOLOCK) ON(
		M0074.nationality = nat.number_cd
	AND	nat.del_datetime IS NULL
	)
	LEFT JOIN L0010 AS sta WITH(NOLOCK) ON(
		M0074.status_residence = sta.number_cd
	AND	sta.name_typ				= 54
	AND	sta.del_datetime IS NULL
	)
	LEFT JOIN L0010 AS per WITH(NOLOCK) ON(
		M0074.permission_activities = per.number_cd
	AND	per.name_typ				= 55
	AND	per.del_datetime IS NULL
	)
	LEFT JOIN L0010 AS disabili WITH(NOLOCK) ON(
		M0074.disability_classification = disabili.number_cd
	AND	disabili.name_typ				= 56
	AND	disabili.del_datetime IS NULL
	)
	LEFT JOIN L0011 ON(
		M0074.headquarters_prefectures	=	L0011.number_cd
	AND L0011.del_datetime IS NULL
	)
	WHERE
		M0074.employee_cd	= @P_employee_cd
	AND	M0074.company_cd	= @P_company_cd
	AND M0074.del_datetime IS NULL	
	END 
	ELSE 
	BEGIN 
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
	END
	--tab 資格タブ [8]
	IF EXISTS (SELECT * FROM #CHECK_PER WHERE (empinfo_authority_typ IN (4,5) AND tab_id = 2 AND use_typ_M9102 = 1) OR (empinfo_authority_typ = 3 AND tab_id = 2  AND use_typ_M5100 <> 0 ))
	BEGIN
		CREATE TABLE #M0075 (	
			id							INT NOT NULL IDENTITY(1,1) 
		,	qualification_nm			NVARCHAR(500)
		,	qualification_typ_nm		NVARCHAR(500)
		,	headquarters_other			DATE
		,	possibility_transfer		DATE
		,	remarks						NVARCHAR(500)
		) 
		--
		INSERT INTO #M0075
		SELECT 	
			ISNULL(M5010.qualification_nm		, 0)	AS	qualification_nm
		,	CASE
				WHEN @P_language = N'en'
				THEN ISNULL(L0010.name_english,N'')
				ELSE ISNULL(L0010.name,N'')
		END		AS	qualification_typ_nm
		,	headquarters_other
		,	possibility_transfer
		,	ISNULL(M0075.remarks				, N'')	AS	remarks
		FROM M0075 WITH (NOLOCK)
		LEFT JOIN M5010	WITH (NOLOCK) ON (
			M5010.company_cd		=	M0075.company_cd
		AND	M5010.qualification_cd	=	M0075.qualification_cd
		)
		LEFT JOIN L0010 WITH (NOLOCK) ON (
			L0010.name_typ			=	57
		AND	L0010.number_cd			=	M5010.qualification_typ
		AND	L0010.del_datetime		IS NULL
		)
		WHERE
			M0075.company_cd	= @P_company_cd
		AND	M0075.employee_cd	= @P_employee_cd
		AND M0075.del_datetime IS NULL	
		--
		SELECT
			#M0075.id 
		,	qualification_nm
		,	qualification_typ_nm
		,	ISNULL( CONVERT(VARCHAR(10), #M0075.headquarters_other, 111)	, NULL)	AS headquarters_other	
		,	ISNULL( CONVERT(VARCHAR(10), #M0075.possibility_transfer, 111)	, NULL)	AS	possibility_transfer
		,	remarks	
		FROM #M0075
	END
	ELSE 
	BEGIN 
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
	END
	--[9][10]人事評価
	IF EXISTS (SELECT * FROM #CHECK_PER WHERE (empinfo_authority_typ IN (4,5) AND tab_id = 3 AND use_typ_M9102 = 1) OR (empinfo_authority_typ = 3 AND tab_id = 3  AND use_typ_M5100 <> 0 ))
	BEGIN
	DECLARE 
		@string_column				NVARCHAR(MAX)	= ''
	,	@string_sql					NVARCHAR(MAX)	= ''
	,	@fiscal_year_max			INT				=  0
	,	@fiscal_year_min			INT				=  0
	,	@current_year				INT				=	dbo.FNC_GET_YEAR(@P_company_cd,NULL)

	CREATE TABLE #TBL_EQ0101(
		fiscal_year						INT
	,	treatment_applications_no		SMALLINT
	,	treatment_applications_nm		NVARCHAR(50)
	,	rank_nm							NVARCHAR(10)
	)

	CREATE TABLE #TBL_EQ0101_TMP(
		fiscal_year						INT
	,	treatment_applications_no		SMALLINT
	,	treatment_applications_nm		NVARCHAR(50)
	,	rank_nm							NVARCHAR(10)
	)

	INSERT INTO #TBL_EQ0101
	SELECT 
		ISNULL(F0201.fiscal_year,0)								AS	fiscal_year
	,	ISNULL(F0201.treatment_applications_no,'')				AS	treatment_applications_no
	,	ISNULL(M0102.treatment_applications_nm,'')				AS	treatment_applications_nm
	,	ISNULL(W_M0130.rank_nm,'')								AS	rank_nm
	FROM F0201
	LEFT OUTER JOIN M0102 ON (
		F0201.company_cd				=	M0102.company_cd
	AND F0201.treatment_applications_no	=	M0102.detail_no
	)
	LEFT JOIN W_M0130 ON (
		F0201.company_cd						=	W_M0130.company_cd
	AND F0201.fiscal_year						=	W_M0130.fiscal_year
	AND F0201.rank_cd							=	W_M0130.rank_cd
	AND	F0201.treatment_applications_no			=	W_M0130.treatment_applications_no
	AND	W_M0130.del_datetime IS NULL
	)
	WHERE
		F0201.company_cd			=	@P_company_cd
	AND F0201.employee_cd			=	@P_employee_cd
	AND	F0201.fiscal_year <= @current_year
	AND	F0201.evaluatorFB_datetime IS NOT NULL
	AND	F0201.del_datetime IS NULL
	AND M0102.del_datetime IS NULL

	SET @fiscal_year_max = (Select Max(A.fiscal_year) FROM ((SELECT TOP 5 fiscal_year FROM #TBL_EQ0101 GROUP BY fiscal_year ORDER BY fiscal_year DESC)) AS A)

	SET @fiscal_year_min = (Select Min(A.fiscal_year) FROM ((SELECT TOP 5 fiscal_year FROM #TBL_EQ0101 GROUP BY fiscal_year ORDER BY fiscal_year DESC)) AS A)

	-- insert top 5 year desc
	INSERT INTO #TBL_EQ0101_TMP
	SELECT
		fiscal_year
	,	treatment_applications_no
	,	treatment_applications_nm
	,	rank_nm
	FROM #TBL_EQ0101 WHERE fiscal_year <= @fiscal_year_max AND fiscal_year >= @fiscal_year_min

	SELECT @string_column = stuff((select ', ['+ cast((A.treatment_applications_no) as nvarchar(50))+']'
								 from 
								 (SELECT DISTINCT #TBL_EQ0101_TMP.treatment_applications_no FROM #TBL_EQ0101_TMP) AS A
								 for xml path('')),1,1,'')

	SET @string_sql = 
	'
	SELECT TOP 5
		fiscal_year,
		'+@string_column+'
	FROM
	(
	SELECT 
		#TBL_EQ0101_TMP.fiscal_year						
	,	#TBL_EQ0101_TMP.treatment_applications_no		
	,	#TBL_EQ0101_TMP.rank_nm							
	FROM #TBL_EQ0101_TMP
	) AS P
	Pivot(MAX(rank_nm) FOR treatment_applications_no IN ('+@string_column+')) AS A
	ORDER BY A.fiscal_year DESC
	'
	--[9]
	IF(ISNULL(@string_sql,'') = '')
	BEGIN
		select '' as fiscal_year
	END
	ELSE
	BEGIN
		EXEC(@string_sql) 
	END
	--[10]
	SELECT TOP 6
	  #TBL_EQ0101_TMP.treatment_applications_no
	, #TBL_EQ0101_TMP.treatment_applications_nm 
	FROM #TBL_EQ0101_TMP
	GROUP BY 
	  #TBL_EQ0101_TMP.treatment_applications_no
	, #TBL_EQ0101_TMP.treatment_applications_nm 

	--CLEAR
	DROP TABLE #TBL_EQ0101
	DROP TABLE #TBL_EQ0101_TMP
	END
	ELSE 
	BEGIN 
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
	END	
	--tab 研修受講履歴タブ [11]
	IF EXISTS (SELECT * FROM #CHECK_PER WHERE (empinfo_authority_typ IN (4,5) AND tab_id = 4 AND use_typ_M9102 = 1) OR (empinfo_authority_typ = 3 AND tab_id = 4 AND use_typ_M5100 <> 0 ))
	BEGIN
		SELECT
		M0076.detail_no																					AS	detail_no
	,	IIF(ISNULL(M0076.training_cd,0) = 0, N'', CAST(ISNULL(M0076.training_cd,0) AS NVARCHAR))		AS	training_cd
	,	ISNULL(M0076.training_nm,N'')																	AS	training_nm
	,	ISNULL(M5031.training_category_nm,N'')															AS	training_category_cd
	,	ISNULL(M5032.training_course_format_nm,0)														AS	training_course_format_cd
	,	ISNULL(M0076.lecturer_name,N'')																	AS	lecturer_name
	,	ISNULL( CONVERT(VARCHAR(10), M0076.training_date_from, 111)	, NULL)								AS	training_date_from
	,	ISNULL( CONVERT(VARCHAR(10), M0076.training_date_to, 111)	, NULL)								AS	training_date_to
	,	CASE
				WHEN @P_language = N'en'
				THEN ISNULL(L0010_59.name_english,N'')
				ELSE ISNULL(L0010_59.name,N'')
		END																								AS	training_status
	,	ISNULL( CONVERT(VARCHAR(10), M0076.passing_date, 111)	, NULL)									AS	passing_date
	,	CASE
				WHEN @P_language = N'en'
				THEN ISNULL(L0010_60.name_english,N'')
				ELSE ISNULL(L0010_60.name,N'')
		END																								AS	report_submission
	,	ISNULL( CONVERT(VARCHAR(10), M0076.report_submission_date, 111)	, NULL)							AS	report_submission_date
	,	ISNULL(M0076.report_storage_location,N'')														AS	report_storage_location
	,	ISNULL(M0076.nationality,N'')																	AS	nationality
	FROM M0076 WITH (NOLOCK)
	LEFT JOIN M5030 WITH (NOLOCK) ON (
		M0076.training_cd		= M5030.training_cd
	AND	M0076.company_cd		= M5030.company_cd
	AND	M5030.del_datetime		IS NULL
	)
	LEFT JOIN M5031 WITH (NOLOCK) ON (
		M0076.training_category_cd		= M5031.training_category_cd
	AND	M0076.company_cd				= M5031.company_cd
	AND	M5030.del_datetime				IS NULL
	)
	LEFT JOIN M5032 WITH (NOLOCK) ON (
		M0076.training_course_format_cd		= M5032.training_course_format_cd
	AND	M0076.company_cd				= M5032.company_cd
	AND	M5030.del_datetime				IS NULL
	)
	LEFT JOIN L0010 AS L0010_59 WITH (NOLOCK) ON (
		L0010_59.name_typ			= 59
	AND	M0076.training_status		= L0010_59.number_cd				
	AND	L0010_59.del_datetime		IS NULL
	)
	LEFT JOIN L0010 AS L0010_60 WITH (NOLOCK) ON (
		L0010_60.name_typ			= 60
	AND	M0076.report_submission		= L0010_60.number_cd				
	AND	L0010_60.del_datetime		IS NULL
	)	
	WHERE
		M0076.company_cd			=	@P_company_cd
	AND	M0076.employee_cd			=	@P_employee_cd
	AND M0076.del_datetime IS NULL	
	ORDER BY M0076.detail_no DESC
	END
	ELSE 
	BEGIN 
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
	END
	--tab 業務経歴タブ [12-13]
	IF EXISTS (SELECT * FROM #CHECK_PER WHERE (empinfo_authority_typ IN (4,5) AND tab_id = 5 AND use_typ_M9102 = 1) OR (empinfo_authority_typ = 3 AND tab_id = 5 AND use_typ_M5100 <> 0 ))
	BEGIN		
		
		CREATE TABLE #M0077 (
			id						INT  identity(1,1)
		,	work_history_kbn		SMALLINT
		,	count_detail			INT
		)
		--
		CREATE TABLE #M5020_1 (
			id					INT  identity(1,1)	
		,	work_history_kbn	SMALLINT
		,	max_item_line		SMALLINT
		)
		CREATE TABLE #M0077_detail_no1 (
			id					INT  identity(1,1)	
		,	detail_no			SMALLINT		
		)
		CREATE TABLE #M5020_2 (
			id					INT  identity(1,1)
		,	work_history_kbn	SMALLINT	
		,	max_item_line		SMALLINT
		)	
		CREATE TABLE #M0077_detail_no2 (
			id					INT  identity(1,1)	
		,	detail_no			SMALLINT		
		)
		--
		INSERT INTO #M0077
		SELECT 
				temp.work_history_kbn
			,	COUNT(1) AS count_detail
		FROM
			(	SELECT
					M5020.work_history_kbn
				,	M0077.detail_no
				FROM M5020	WITH(NOLOCK) 
				INNER JOIN M0077 WITH(NOLOCK) ON (		
					M0077.work_history_kbn	= M5020.work_history_kbn
				AND	M0077.company_cd		= @P_company_cd
				AND	M0077.employee_cd		= @P_employee_cd
				AND	M0077.item_id			= M5020.item_id
				AND M0077.del_datetime		IS NULL
				)
				WHERE
				M5020.company_cd		=	@P_company_cd
				And item_display_kbn	=	1
				AND M5020.del_datetime	IS NULL
				GROUP BY
					M0077.detail_no
				,	M5020.work_history_kbn	
			) AS temp
				GROUP BY work_history_kbn
		--
		INSERT INTO #M5020_1
		SELECT  
			M5020.work_history_kbn
		,	MAX(M5020.item_arrangement_line) AS max_item_line
		FROM M5020 WITH(NOLOCK)		
		WHERE
			M5020.company_cd		=	@P_company_cd
		AND M5020.work_history_kbn = 1
		AND M5020.item_display_kbn = 1
		AND M5020.del_datetime IS NULL
		GROUP BY 
			M5020.work_history_kbn
		--
		INSERT INTO #M5020_2
		SELECT  
			M5020.work_history_kbn
		,	MAX(M5020.item_arrangement_line) AS max_item_line
		FROM M5020 WITH(NOLOCK)			
		WHERE
			M5020.company_cd		=	@P_company_cd
		AND M5020.work_history_kbn = 2
		AND M5020.item_display_kbn = 1
		AND M5020.del_datetime IS NULL
		GROUP BY 
			M5020.work_history_kbn
		--
		INSERT INTO #M0077_detail_no1	
		SELECT  
			M0077.detail_no
		FROM M0077
		INNER JOIN M5020 ON (		
				M0077.work_history_kbn	= M5020.work_history_kbn
			AND	M5020.company_cd	= @P_company_cd
			AND	M0077.item_id	= M5020.item_id
			AND M5020.del_datetime IS NULL
			)
		WHERE
		M0077.del_datetime IS NULL
		AND M0077.company_cd		=	@P_company_cd
		AND	M0077.employee_cd	= @P_employee_cd
		AND M5020.work_history_kbn = 1
		GROUP BY 
			detail_no	
		ORDER BY detail_no DESC
		--
		INSERT INTO #M0077_detail_no2
		SELECT  
			detail_no
		FROM M0077
		INNER JOIN M5020 ON (		
				M0077.work_history_kbn	= M5020.work_history_kbn
			AND	M5020.company_cd	= @P_company_cd
			AND	M0077.item_id	= M5020.item_id
			AND M5020.del_datetime IS NULL
			)
		WHERE
		M0077.del_datetime IS NULL
		AND M0077.company_cd		=	@P_company_cd
		AND	M0077.employee_cd	= @P_employee_cd
		AND M5020.work_history_kbn = 2
		GROUP BY 
			detail_no
		ORDER BY detail_no DESC
		----[9]		
		CREATE TABLE #TABLE_M5020(
		work_history_kbn			SMALLINT
	,	item_id						SMALLINT
	,	numeric_value2				INT
	,	numeric_value1				INT
	,	item_title					NVARCHAR(50)
	,	item_display_kbn			SMALLINT
	,	item_arrangement_column		SMALLINT
	,	item_arrangement_line		SMALLINT
	,	detail_no					SMALLINT
	,	date_from					VARCHAR(10)
	,	date_to						VARCHAR(10)
	,	text_item					NVARCHAR(150)
	,	selected_items_nm			NVARCHAR(100)
	,	number_item					NUMERIC(10,2)
	)

	CREATE TABLE #M5020_REQ (
		row_count  int  
	,	detail_no	smallint
	,	work_history_kbn			SMALLINT
	,	item_id		smallint
	,	detail_json	nvarchar(max)
	)

	CREATE TABLE #M0077_DETAIL_1 (
		id					int			identity(1,1)
	,	detail_no			smallint
	)

	CREATE TABLE #M0077_DETAIL_2 (
		id					int			identity(1,1)
	,	detail_no			smallint
	)

	-- detail no work 1
	INSERT INTO #M0077_DETAIL_1
	SELECT
	 M0077.detail_no
	FROM M0077 WITH (NOLOCK)
	WHERE 
		M0077.company_cd	= @P_company_cd
	AND	M0077.employee_cd	= @P_employee_cd
	AND M0077.work_history_kbn =  1
	AND M0077.del_datetime IS NULL
	GROUP BY 
		 M0077.detail_no

	-- detail no work 2
	INSERT INTO #M0077_DETAIL_2
	SELECT
	 M0077.detail_no
	FROM M0077 WITH (NOLOCK)
	WHERE 
		M0077.company_cd	= @P_company_cd
	AND	M0077.employee_cd	= @P_employee_cd
	AND M0077.work_history_kbn =  2
	AND M0077.del_datetime IS NULL
	GROUP BY 
		 M0077.detail_no

	INSERT INTO #TABLE_M5020
	SELECT
			M5020.work_history_kbn					AS work_history_kbn
		,	M5020.item_id							AS item_id
		,	L0010.numeric_value2					AS numeric_value2
		,	L0010.numeric_value1					AS numeric_value1
		,	M5020.item_title						AS item_title
		,	M5020.item_display_kbn					AS item_display_kbn
		,	M5020.item_arrangement_column			AS item_arrangement_column
		,	M5020.item_arrangement_line				AS item_arrangement_line
		,	ISNULL(M0077.detail_no,0)				AS	detail_no
		,	ISNULL( CONVERT(VARCHAR(10), M0077.date_from, 111), NULL)	AS	date_from
		,	ISNULL( CONVERT(VARCHAR(10), M0077.date_to, 111), NULL)	AS	date_to	
		,	M0077.text_item
		,	ISNULL( M5021.selected_items_nm, '') AS selected_items_nm
		,	M0077.number_item
		FROM M5020 WITH (NOLOCK)
		INNER JOIN M0077 WITH (NOLOCK) ON (		
			M0077.work_history_kbn	= M5020.work_history_kbn
		AND	M0077.company_cd	= @P_company_cd
		AND	M0077.employee_cd	= @P_employee_cd
		AND	M0077.item_id	= M5020.item_id
		AND M0077.del_datetime IS NULL
		)
		LEFT JOIN L0010 WITH (NOLOCK) ON(
			M5020.item_id	=	L0010.number_cd
		AND	78				=	L0010.name_typ
		AND L0010.del_datetime IS NULL
		)
		LEFT JOIN M5021 WITH(NOLOCK) ON  (
			M5021.company_cd		=	@P_company_cd
		AND	M5021.work_history_kbn	=	M5020.work_history_kbn
		AND	M5021.item_id			=	M5020.item_id
		AND	M5021.selected_items_no	=	M0077.select_item
		AND M5021.del_datetime	IS NULL
		)
		WHERE
			M5020.company_cd		=	@P_company_cd
		AND M5020.del_datetime IS NULL

	-- insert item no has M0077
	SET @w_cnt = IIF((SELECT COUNT(1) FROM #M0077_DETAIL_1) = 0, 1, (SELECT COUNT(1) FROM #M0077_DETAIL_1))
	WHILE @w_i <= @w_cnt
	BEGIN
		SELECT 
			@w_detail_no = #M0077_DETAIL_1.detail_no
		FROM #M0077_DETAIL_1
		WHERE 
			#M0077_DETAIL_1.id = @w_i

		INSERT INTO #TABLE_M5020
		SELECT	
			M5020.work_history_kbn					AS work_history_kbn
		,	M5020.item_id							AS item_id
		,	L0010.numeric_value2					AS numeric_value2
		,	L0010.numeric_value1					AS numeric_value1
		,	M5020.item_title						AS item_title
		,	M5020.item_display_kbn					AS item_display_kbn
		,	M5020.item_arrangement_column			AS item_arrangement_column
		,	M5020.item_arrangement_line				AS item_arrangement_line
		,	ISNULL(@w_detail_no,0)					AS	detail_no
		,	ISNULL( CONVERT(VARCHAR(10), M0077.date_from, 111), NULL)	AS	date_from
		,	ISNULL( CONVERT(VARCHAR(10), M0077.date_to, 111), NULL)	AS	date_to	
		,	M0077.text_item
		,	ISNULL( M5021.selected_items_nm, '') AS selected_items_nm
		,	M0077.number_item
		FROM M5020 WITH (NOLOCK)
		LEFT JOIN M0077 WITH (NOLOCK) ON (		
			M0077.work_history_kbn	= M5020.work_history_kbn
		AND	M0077.company_cd	= @P_company_cd
		AND	M0077.employee_cd	= @P_employee_cd
		AND	M0077.item_id	= M5020.item_id
		AND M0077.del_datetime IS NULL
		)
		LEFT JOIN L0010 WITH (NOLOCK) ON(
			M5020.item_id	=	L0010.number_cd
		AND	78				=	L0010.name_typ
		AND L0010.del_datetime IS NULL
		)
		LEFT JOIN M5021 WITH(NOLOCK) ON  (
			M5021.company_cd		=	@P_company_cd
		AND	M5021.work_history_kbn	=	M5020.work_history_kbn
		AND	M5021.item_id			=	M5020.item_id
		AND	M5021.selected_items_no	=	M0077.select_item
		AND M5021.del_datetime	IS NULL
		)
		WHERE
			M5020.company_cd		=	@P_company_cd
		AND M5020.work_history_kbn = 1
		AND M5020.item_display_kbn = 1
		AND M5020.del_datetime IS NULL
		AND M0077.detail_no IS NULL
		AND M0077.item_id IS NULL
	SET @w_i = @w_i + 1
	END

	SET @w_cnt_2 =  IIF((SELECT COUNT(1) FROM #M0077_DETAIL_2) = 0, 1, (SELECT COUNT(1) FROM #M0077_DETAIL_2))
	WHILE @w_i_2 <= @w_cnt_2
	BEGIN
		SELECT 
			@w_detail_no_2 = #M0077_DETAIL_2.detail_no
		FROM #M0077_DETAIL_2
		WHERE 
			#M0077_DETAIL_2.id = @w_i_2

		INSERT INTO #TABLE_M5020
		SELECT	
			M5020.work_history_kbn					AS work_history_kbn
		,	M5020.item_id							AS item_id
		,	L0010.numeric_value2					AS numeric_value2
		,	L0010.numeric_value1					AS numeric_value1
		,	M5020.item_title						AS item_title
		,	M5020.item_display_kbn					AS item_display_kbn
		,	M5020.item_arrangement_column			AS item_arrangement_column
		,	M5020.item_arrangement_line				AS item_arrangement_line
		,	ISNULL(@w_detail_no_2,0)					AS	detail_no
		,	ISNULL( CONVERT(VARCHAR(10), M0077.date_from, 111), NULL)	AS	date_from
		,	ISNULL( CONVERT(VARCHAR(10), M0077.date_to, 111), NULL)	AS	date_to	
		,	M0077.text_item
		,	ISNULL( M5021.selected_items_nm, '') AS selected_items_nm
		,	M0077.number_item
		
		FROM M5020 WITH (NOLOCK)
		LEFT JOIN M0077 WITH (NOLOCK) ON (		
			M0077.work_history_kbn	= M5020.work_history_kbn
		AND	M0077.company_cd	= @P_company_cd
		AND	M0077.employee_cd	= @P_employee_cd
		AND	M0077.item_id	= M5020.item_id
		AND M0077.del_datetime IS NULL
		)
		LEFT JOIN L0010 WITH (NOLOCK) ON(
			M5020.item_id	=	L0010.number_cd
		AND	78				=	L0010.name_typ
		AND L0010.del_datetime IS NULL
		)
		LEFT JOIN M5021 WITH(NOLOCK) ON  (
			M5021.company_cd		=	@P_company_cd
		AND	M5021.work_history_kbn	=	M5020.work_history_kbn
		AND	M5021.item_id			=	M5020.item_id
		AND	M5021.selected_items_no	=	M0077.select_item
		AND M5021.del_datetime	IS NULL
		)
		WHERE
			M5020.company_cd		=	@P_company_cd
		AND M5020.work_history_kbn = 2
		AND M5020.item_display_kbn = 1
		AND M5020.del_datetime IS NULL
		AND M0077.detail_no IS NULL
		AND M0077.item_id IS NULL
	SET @w_i_2 = @w_i_2 + 1
	END


	-- insert item  has M0077 no M5020
	SET @w_cnt = IIF((SELECT COUNT(1) FROM #M0077_DETAIL_1) = 0, 1, (SELECT COUNT(1) FROM #M0077_DETAIL_1))
	SET @w_i = 1
	WHILE @w_i <= @w_cnt
	BEGIN
		SELECT 
			@w_detail_no = #M0077_DETAIL_1.detail_no
		FROM #M0077_DETAIL_1
		WHERE 
			#M0077_DETAIL_1.id = @w_i

		INSERT INTO #TABLE_M5020
		SELECT	
			M5020.work_history_kbn					AS work_history_kbn
		,	M5020.item_id							AS item_id
		,	L0010.numeric_value2					AS numeric_value2
		,	L0010.numeric_value1					AS numeric_value1
		,	M5020.item_title						AS item_title
		,	M5020.item_display_kbn					AS item_display_kbn
		,	M5020.item_arrangement_column			AS item_arrangement_column
		,	M5020.item_arrangement_line				AS item_arrangement_line
		,	ISNULL(@w_detail_no,0)					AS	detail_no
		,	ISNULL( CONVERT(VARCHAR(10), M0077.date_from, 111), NULL)	AS	date_from
		,	ISNULL( CONVERT(VARCHAR(10), M0077.date_to, 111), NULL)		AS	date_to	
		,	M0077.text_item
		,	ISNULL( M5021.selected_items_nm, '')						AS  selected_items_nm
		,	M0077.number_item		
		FROM M0077 WITH (NOLOCK)
		LEFT JOIN M5020 WITH (NOLOCK) ON (		
			M0077.work_history_kbn	= M5020.work_history_kbn
		AND	M0077.company_cd	= @P_company_cd
		AND	M0077.employee_cd	= @P_employee_cd
		AND	M0077.item_id	= M5020.item_id
		AND M0077.del_datetime IS NULL
		)
		LEFT JOIN L0010 WITH (NOLOCK) ON(
			M5020.item_id	=	L0010.number_cd
		AND	78				=	L0010.name_typ
		AND L0010.del_datetime IS NULL
		)
		LEFT JOIN M5021 WITH(NOLOCK) ON  (
			M5021.company_cd		=	@P_company_cd
		AND	M5021.work_history_kbn	=	M5020.work_history_kbn
		AND	M5021.item_id			=	M5020.item_id
		AND	M5021.selected_items_no	=	M0077.select_item
		AND M5021.del_datetime	IS NULL
		)
		WHERE
			M5020.company_cd		=	@P_company_cd
		AND M5020.work_history_kbn = 1
		AND M5020.item_display_kbn = 1
		AND M5020.item_id IS NULL
		AND M5020.del_datetime IS NULL
	SET @w_i = @w_i + 1
	END

	SET @w_cnt_2 =  IIF((SELECT COUNT(1) FROM #M0077_DETAIL_2) = 0, 1, (SELECT COUNT(1) FROM #M0077_DETAIL_2))
	SET @w_i_2 = 1
	WHILE @w_i_2 <= @w_cnt_2
	BEGIN
		SELECT 
			@w_detail_no_2 = #M0077_DETAIL_2.detail_no
		FROM #M0077_DETAIL_2
		WHERE 
			#M0077_DETAIL_2.id = @w_i_2

		INSERT INTO #TABLE_M5020
		SELECT	
			M5020.work_history_kbn					AS work_history_kbn
		,	M5020.item_id							AS item_id
		,	L0010.numeric_value2					AS numeric_value2
		,	L0010.numeric_value1					AS numeric_value1
		,	M5020.item_title						AS item_title
		,	M5020.item_display_kbn					AS item_display_kbn
		,	M5020.item_arrangement_column			AS item_arrangement_column
		,	M5020.item_arrangement_line				AS item_arrangement_line
		,	ISNULL(@w_detail_no_2,0)					AS	detail_no
		,	ISNULL( CONVERT(VARCHAR(10), M0077.date_from, 111), NULL)	AS	date_from
		,	ISNULL( CONVERT(VARCHAR(10), M0077.date_to, 111), NULL)	AS	date_to	
		,	M0077.text_item
		,	ISNULL( M5021.selected_items_nm, '') AS selected_items_nm
		,	M0077.number_item		
		FROM M5020 WITH (NOLOCK)
		LEFT JOIN M0077 WITH (NOLOCK) ON (		
			M0077.work_history_kbn	= M5020.work_history_kbn
		AND	M0077.company_cd	= @P_company_cd
		AND	M0077.employee_cd	= @P_employee_cd
		AND	M0077.item_id	= M5020.item_id
		AND M0077.del_datetime IS NULL
		)
		LEFT JOIN L0010 WITH (NOLOCK) ON(
			M5020.item_id	=	L0010.number_cd
		AND	78				=	L0010.name_typ
		AND L0010.del_datetime IS NULL
		)
		LEFT JOIN M5021 WITH(NOLOCK) ON  (
			M5021.company_cd		=	@P_company_cd
		AND	M5021.work_history_kbn	=	M5020.work_history_kbn
		AND	M5021.item_id			=	M5020.item_id
		AND	M5021.selected_items_no	=	M0077.select_item
		AND M5021.del_datetime	IS NULL
		)
		WHERE
			M5020.company_cd		=	@P_company_cd
		AND M5020.work_history_kbn = 2
		AND M5020.item_display_kbn = 1
		AND M5020.item_id IS NULL
		AND M5020.del_datetime IS NULL
		SET @w_i_2 = @w_i_2 + 1
	END
		--
		SELECT 
			ISNULL(#TABLE_M5020.work_history_kbn, 0)				AS work_history_kbn
		,	ISNULL(#TABLE_M5020.item_id, 0)							AS item_id
		,	ISNULL(#TABLE_M5020.numeric_value2, 0)					AS numeric_value2
		,	ISNULL(#TABLE_M5020.numeric_value1, 0)					AS numeric_value1
		,	ISNULL(#TABLE_M5020.item_title, N'')					AS item_title
		,	ISNULL(#TABLE_M5020.item_display_kbn, 0)				AS item_display_kbn
		,	ISNULL(#TABLE_M5020.item_arrangement_column, 0)			AS item_arrangement_column
		,	ISNULL(#TABLE_M5020.item_arrangement_line, 0)			AS item_arrangement_line
		,	ISNULL(#TABLE_M5020.detail_no, 0)						AS detail_no
		,	ISNULL(#TABLE_M5020.date_from, N'')						AS date_from
		,	ISNULL(#TABLE_M5020.date_to	, N'')						AS date_to
		,	ISNULL(#TABLE_M5020.text_item, N'')						AS text_item
		,	ISNULL(#TABLE_M5020.selected_items_nm, N'')				AS selected_items_nm
		,	ISNULL(#TABLE_M5020.number_item, 0)						AS number_item
		,	ISNULL( #M0077_detail_no1.id, 0)						AS detail_no1
		,	ISNULL( #M0077.count_detail,0) * ISNULL(#M5020_1.max_item_line,0)						AS count_line
		,	ISNULL(#M5020_1.max_item_line,0)						AS max_item_line
		FROM #TABLE_M5020 
		LEFT JOIN #M5020_1 ON (
			#TABLE_M5020.work_history_kbn = #M5020_1.work_history_kbn
		)	
		LEFT JOIN #M0077 ON (
			#TABLE_M5020.work_history_kbn = #M0077.work_history_kbn
		)
		LEFT JOIN #M0077_detail_no1 ON (
			#TABLE_M5020.detail_no = #M0077_detail_no1.detail_no
		)
		WHERE
			#TABLE_M5020.work_history_kbn = 1
		AND	item_display_kbn = 1
		ORDER BY 
					#TABLE_M5020.detail_no					DESC
				,	#TABLE_M5020.item_arrangement_line		ASC
				,	#TABLE_M5020.item_arrangement_column	ASC	
		SELECT 
			ISNULL(#TABLE_M5020.work_history_kbn, 0)				AS work_history_kbn
		,	ISNULL(#TABLE_M5020.item_id, 0)							AS item_id
		,	ISNULL(#TABLE_M5020.numeric_value2, 0)					AS numeric_value2
		,	ISNULL(#TABLE_M5020.numeric_value1, 0)					AS numeric_value1
		,	ISNULL(#TABLE_M5020.item_title, N'')					AS item_title
		,	ISNULL(#TABLE_M5020.item_display_kbn, 0)				AS item_display_kbn
		,	ISNULL(#TABLE_M5020.item_arrangement_column, 0)			AS item_arrangement_column
		,	ISNULL(#TABLE_M5020.item_arrangement_line, 0)			AS item_arrangement_line
		,	ISNULL(#TABLE_M5020.detail_no, 0)						AS detail_no
		,	ISNULL(#TABLE_M5020.date_from, N'')						AS date_from
		,	ISNULL(#TABLE_M5020.date_to	, N'')						AS date_to
		,	ISNULL(#TABLE_M5020.text_item, N'')						AS text_item
		,	ISNULL(#TABLE_M5020.selected_items_nm, N'')				AS selected_items_nm
		,	ISNULL(#TABLE_M5020.number_item, 0)						AS number_item
		,	ISNULL( #M0077_detail_no2.id, 0) 								AS detail_no2
		,	ISNULL( #M0077.count_detail,0) * ISNULL(#M5020_2.max_item_line,0)	 							AS count_line
		,	ISNULL(#M5020_2.max_item_line,0)						AS max_item_line
		FROM #TABLE_M5020 
		LEFT JOIN #M5020_2 ON (
			#TABLE_M5020.work_history_kbn = #M5020_2.work_history_kbn
		)	
		LEFT JOIN #M0077 ON (
			#TABLE_M5020.work_history_kbn = #M0077.work_history_kbn
		)
		LEFT JOIN #M0077_detail_no2 ON (
			#TABLE_M5020.detail_no = #M0077_detail_no2.detail_no
		)
		WHERE
			#TABLE_M5020.work_history_kbn = 2
		AND	item_display_kbn = 1
		ORDER BY 
			#TABLE_M5020.detail_no					DESC
		,	#TABLE_M5020.item_arrangement_line		ASC
		,	#TABLE_M5020.item_arrangement_column	ASC	
		
	END
	ELSE 
	BEGIN 
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
	END
	--tab 学歴タブ [14-15]
	IF EXISTS (SELECT * FROM #CHECK_PER WHERE (empinfo_authority_typ IN (4,5) AND tab_id = 6 AND use_typ_M9102 = 1) OR (empinfo_authority_typ = 3 AND tab_id = 6  AND use_typ_M5100 <> 0 ))
	BEGIN
		SELECT 	
			CASE
				WHEN	@P_language = N'en'
				THEN	ISNULL(L0010.name_english,N'')
				ELSE	ISNULL(L0010.name,N'')
			END												AS final_education_kbn_nm
		,	ISNULL(M0078.final_education_other		, N'')	AS final_education_other
		,	ISNULL(M0078.graduation_year			, 0)	AS graduation_year
		,	ISNULL(L0013.school_name				, N'')	AS school_name
		,	ISNULL(M0078.faculty					, N'')	AS faculty
		,	ISNULL(M0078.major						, N'')	AS major
		FROM M0078 WITH (NOLOCK)
		LEFT JOIN L0013	WITH (NOLOCK) ON (
			M0078.graduation_school_cd	=	L0013.school_code
		)
		LEFT JOIN L0010 WITH (NOLOCK) ON (
			L0010.name_typ			=	61
		AND	L0010.number_cd			=	M0078.final_education_kbn
		AND	L0010.del_datetime		IS NULL
		)
		WHERE
			M0078.company_cd	= @P_company_cd
		AND	M0078.employee_cd	= @P_employee_cd
		AND M0078.del_datetime IS NULL
		--[13]
		SELECT 
			ISNULL(M0079.graduation_year			, 0)	AS graduation_year
		,	ISNULL(l0013.school_name				, N'')	AS school_name
		,	ISNULL(M0079.faculty					, N'')	AS faculty
		,	ISNULL(M0079.major						, N'')	AS major
		FROM M0079 WITH (NOLOCK)
		LEFT JOIN L0013	WITH (NOLOCK) ON (
			M0079.graduation_school_cd	=	L0013.school_code
		)
		WHERE
			M0079.company_cd	= @P_company_cd
		AND	M0079.employee_cd	= @P_employee_cd
		AND M0079.del_datetime IS NULL
	END
	ELSE 
	BEGIN 
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
	END
	--tab 連絡先タブ [16]
	IF EXISTS (SELECT * FROM #CHECK_PER WHERE (empinfo_authority_typ IN (4,5) AND tab_id = 7 AND use_typ_M9102 = 1) OR (empinfo_authority_typ = 3 AND tab_id = 7  AND use_typ_M5100 <> 0 ))
	BEGIN
		SET @w_relationship	= (
			SELECT 
				CASE
					WHEN @P_language = N'en'		
					THEN IIF(ISNULL(L0010.name_english,N'') = N'',M0083.emergency_contact_relationship,L0010.name_english)
					ELSE IIF(ISNULL(L0010.name,N'') = N'',M0083.emergency_contact_relationship,L0010.name)
				END									AS relationship FROM M0083 WITH(NOLOCK)	
			LEFT JOIN L0010 WITH(NOLOCK) ON(
				M0083.emergency_contact_relationship = CONVERT(NVARCHAR(10), L0010.number_cd)
			AND	L0010.name_typ				= 63
			AND	L0010.del_datetime IS NULL
			)
			WHERE
				M0083.employee_cd = @P_employee_cd
			AND M0083.company_cd = @P_company_cd
			AND M0083.del_datetime IS NULL
			)
		SET @w_year_old = [dbo].FNC_GET_BIRTHDAY_AGE((SELECT emergency_contact_birthday FROM M0083 WITH(NOLOCK) WHERE M0083.employee_cd = @P_employee_cd AND M0083.company_cd = @P_company_cd AND M0083.del_datetime IS NULL),NULL)
		--
		SELECT
			CASE
					WHEN @P_language = N'en'
					THEN ISNULL(L0010_62.name_english,N'')
					ELSE ISNULL(L0010_62.name,N'')
			END		AS owning_house_kbn				
		,	M0083.head_household					
		,	IIF((M0083.post_code != NULL OR M0083.post_code !=N''),(LEFT(M0083.post_code,3)+N'-'+RIGHT(M0083.post_code,4)),N'') AS post_code						
		,	M0083.address1						
		,	M0083.address2						
		,	M0083.address3						
		,	M0083.home_phone_number				
		,	M0083.personal_phone_number			
		,	M0083.personal_email_address			
		,	M0083.emergency_contact_name			
		,	IIF(@w_relationship = N'0',N'',@w_relationship)			AS emergency_contact_relationship
		,	ISNULL(FORMAT(M0083.emergency_contact_birthday,'yyyy/MM/dd'),N'')				AS emergency_contact_birthday
		,	IIF(M0083.emergency_contact_birthday IS NOT NULL,@w_year_old,N'')				AS	year_old
		,	IIF((M0083.emergency_contact_post_code != NULL OR M0083.emergency_contact_post_code !=N''),(LEFT(M0083.emergency_contact_post_code,3)+N'-'+RIGHT(M0083.emergency_contact_post_code,4)),N'') AS emergency_contact_post_code		
		,	M0083.emergency_contact_addres1		
		,	M0083.emergency_contact_addres2		
		,	M0083.emergency_contact_phone_number	
		FROM M0083 WITH(NOLOCK)	
		LEFT JOIN L0010 AS L0010_63 WITH(NOLOCK) ON(
			M0083.emergency_contact_relationship = CONVERT(NVARCHAR(10), L0010_63.number_cd)
		AND	L0010_63.name_typ				= 63
		AND	L0010_63.del_datetime IS NULL
		)
		LEFT JOIN L0010 AS L0010_62 WITH(NOLOCK) ON(
			M0083.owning_house_kbn = L0010_62.number_cd
		AND	L0010_62.name_typ				= 62
		AND	L0010_62.del_datetime IS NULL
		)
		WHERE
			M0083.employee_cd = @P_employee_cd
		AND M0083.company_cd = @P_company_cd
		AND M0083.del_datetime IS NULL
	END
	ELSE 
	BEGIN 
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
	END
	--tab 通勤タブ 	[17-18]
	IF EXISTS (SELECT * FROM #CHECK_PER WHERE (empinfo_authority_typ IN (4,5) AND tab_id = 8 AND use_typ_M9102 = 1) OR (empinfo_authority_typ = 3 AND tab_id = 8  AND use_typ_M5100 <> 0 ))
	BEGIN
		SET @total3 = (SELECT  SUM(M0084.commuting_expenses * 1.0 / L0010_65.numeric_value1) AS Total
						FROM M0084 WITH(NOLOCK) 
						LEFT JOIN L0010 AS L0010_65 WITH(NOLOCK) ON(
							M0084.commuter_ticket_classification = L0010_65.number_cd
						AND	L0010_65.name_typ				= 65
						AND	L0010_65.del_datetime IS NULL
						)
						WHERE 
							M0084.employee_cd = @P_employee_cd 
						AND M0084.company_cd = @P_company_cd 
						AND M0084.commuting_method = 3 
						AND M0084.del_datetime IS NULL				
						)	
		SET @total4 = (SELECT  SUM(M0084.commuting_expenses * 1.0 / L0010_65.numeric_value1) AS Total
						FROM M0084 WITH(NOLOCK) 
						LEFT JOIN L0010 AS L0010_65 WITH(NOLOCK) ON(
							M0084.commuter_ticket_classification = L0010_65.number_cd
						AND	L0010_65.name_typ				= 65
						AND	L0010_65.del_datetime IS NULL
						)
						WHERE 
							M0084.employee_cd = @P_employee_cd 
						AND M0084.company_cd = @P_company_cd 
						AND M0084.commuting_method = 4 
						AND M0084.del_datetime IS NULL				
						)	
		SET @total6 = (SELECT  SUM(M0084.commuting_expenses * 1.0 / L0010_66.numeric_value1) AS Total
						FROM M0084 WITH(NOLOCK) 
						LEFT JOIN L0010 AS L0010_66 WITH(NOLOCK) ON(
							M0084.commuter_ticket_classification = L0010_66.number_cd
						AND	L0010_66.name_typ				= 66
						AND	L0010_66.del_datetime IS NULL
						)
						WHERE 
							M0084.employee_cd = @P_employee_cd 
						AND M0084.company_cd = @P_company_cd 
						AND M0084.commuting_method = 6
						AND M0084.del_datetime IS NULL				
						)	
		SET @total = (SELECT  SUM(M0084.commuting_expenses) AS Total
						FROM M0084 WITH(NOLOCK) 					
						WHERE 
							M0084.employee_cd = @P_employee_cd 
						AND M0084.company_cd = @P_company_cd 
						AND M0084.commuting_method <> 3
						AND M0084.commuting_method <> 4
						AND M0084.commuting_method <> 6
						AND M0084.del_datetime IS NULL				
						)	
		SET @sum_total = ISNULL(@total,0) + ISNULL(@total3,0) + ISNULL(@total4,0) +ISNULL(@total6,0)
		--[14]
		SELECT
			M0084.detail_no
		,	M0084.commuting_method
		,	CASE
					WHEN @P_language = N'en'
					THEN ISNULL(L0010_64.name_english,N'')
					ELSE ISNULL(L0010_64.name,N'')
			END		AS commuting_method_name
		,	CASE
				WHEN M0084.commuting_method IN (1, 2, 5, 7) THEN ISNULL(FORMAT(M0084.commuting_distance, '###,###.##'), N'0')
				WHEN M0084.commuting_method IN (3, 4, 6) THEN ISNULL(M0084.departure_point, N'')
				WHEN M0084.commuting_method = 8 THEN ISNULL(M0084.commuting_method_detail, N'')
				ELSE SPACE(0)
			END AS data_2
		,	CASE
				WHEN M0084.commuting_method IN (1, 5) THEN ISNULL( CONVERT(VARCHAR(10), M0084.drivinglicense_renewal_deadline, 111), NULL)
				WHEN M0084.commuting_method IN (2, 7) THEN ISNULL(FORMAT(M0084.commuting_expenses, '###,###'),0)
				WHEN M0084.commuting_method IN (3, 4, 6) THEN ISNULL(M0084.arrival_point,N'')				
				WHEN M0084.commuting_method = 8 THEN ISNULL(M0084.departure_point,N'')
				ELSE SPACE(0) 
			END													AS data_3
		,	CASE
				WHEN M0084.commuting_method IN (1, 5) THEN ISNULL(FORMAT(M0084.commuting_expenses, '###,###'), N'0')		
				WHEN M0084.commuting_method IN (3, 4) THEN IIF( @P_language = N'en', L0010_65.name_english, L0010_65.name)
				WHEN M0084.commuting_method = 6 THEN IIF( @P_language = N'en', L0010_66.name_english, L0010_66.name)
				WHEN M0084.commuting_method = 8 THEN ISNULL(M0084.departure_point, N'')
				ELSE SPACE(0)
			END AS data_4
		,	CASE			
				WHEN M0084.commuting_method IN (3, 4, 6, 8) THEN ISNULL(FORMAT(M0084.commuting_expenses, '###,###'),0)
				ELSE SPACE(0) 
			END													AS data_5
		,	 CASE
				WHEN @P_language = N'en'
				THEN N'Means Of Commuting'
				ELSE N'通勤手段'
			END	 AS head_1
		,	CASE
				WHEN M0084.commuting_method IN (1, 2, 5, 7) THEN IIF(@P_language = N'en',N'Distance',N'通勤距離')	
				WHEN M0084.commuting_method IN (3, 6) THEN IIF(@P_language = N'en',N'Station Closest To Home', N'自宅最寄り駅')
				WHEN M0084.commuting_method = 4 THEN IIF(@P_language = N'en',N'Bus Start Point',N'バス利用区間起点')
				WHEN M0084.commuting_method = 8 THEN IIF(@P_language = N'en',N'Commuting method details',N'通勤手段詳細')
				ELSE SPACE(0) 
			END													AS head_2
		,	CASE
				WHEN M0084.commuting_method IN (1, 5) THEN IIF(@P_language = N'en',N'License renewal deadline',N'運転免許証更新期限')
				WHEN M0084.commuting_method IN (2, 7) THEN IIF(@P_language = N'en',N'Allowance',N'通勤費')
				WHEN M0084.commuting_method IN (3, 6) THEN IIF(@P_language = N'en',N'Station Closest To Workplace',N'勤務地最寄り駅')
				WHEN M0084.commuting_method = 4 THEN IIF(@P_language = N'en',N'End Of Bus Section',N'バス利用区間終点')
				WHEN M0084.commuting_method = 8 THEN IIF(@P_language = N'en',N'Point Of Departure',N'出発地')
				ELSE SPACE(0) 
			END													AS head_3
		,	CASE
				WHEN M0084.commuting_method IN (1, 5) THEN IIF(@P_language = N'en',N'Allowance',N'通勤費'	)
				WHEN M0084.commuting_method IN (3, 4, 6) THEN IIF(@P_language = N'en',N'Ticket Classification',N'定期券区分')
				WHEN M0084.commuting_method = 8 THEN IIF(@P_language = N'en',N'Place Of Arrival',N'到着地')
				ELSE SPACE(0) 
			END													AS head_4
		,	CASE			
				WHEN M0084.commuting_method IN (3, 4, 6) THEN IIF(@P_language = N'en',N'Ticket Amount',N'定期券金額')
				WHEN M0084.commuting_method = 8 THEN IIF(@P_language = N'en',N'Allowance',N'通勤費')
				ELSE SPACE(0) 
			END													AS head_5	
		FROM M0084 WITH(NOLOCK)
		LEFT JOIN L0010 AS L0010_64 WITH(NOLOCK) ON(
			M0084.commuting_method = L0010_64.number_cd
		AND	L0010_64.name_typ				= 64
		AND	L0010_64.del_datetime IS NULL
		)
		LEFT JOIN L0010 AS L0010_65 WITH(NOLOCK) ON(
			M0084.commuter_ticket_classification = L0010_65.number_cd
		AND	L0010_65.name_typ				= 65
		AND	L0010_65.del_datetime IS NULL
		)
		LEFT JOIN L0010 AS L0010_66 WITH(NOLOCK) ON(
			M0084.commuter_ticket_classification = L0010_66.number_cd
		AND	L0010_66.name_typ				= 66
		AND	L0010_66.del_datetime IS NULL
		)
		WHERE
			M0084.employee_cd = @P_employee_cd
		AND M0084.company_cd = @P_company_cd
		AND M0084.del_datetime IS NULL	
		--[15]
		SELECT	ISNULL(FORMAT(@sum_total, '###,###.##'),0) AS total_expenses
	END
	ELSE 
	BEGIN 
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
	END
	--tab 家族タブ [19]
	IF EXISTS (SELECT * FROM #CHECK_PER WHERE (empinfo_authority_typ IN (4,5) AND tab_id = 9 AND use_typ_M9102 = 1) OR (empinfo_authority_typ = 3 AND tab_id = 9 AND use_typ_M5100 <> 0 ))
	BEGIN
	SELECT
		CASE
				WHEN @P_language = N'en'
				THEN ISNULL(L0010_67.name_english,N'')
				ELSE ISNULL(L0010_67.name,N'')
		END		 AS marital_status
	,	ISNULL(M0086.full_name,N'')				AS full_name
	,	ISNULL(M0086.full_name_furigana,N'')	AS full_name_furigana
	,	CASE
			WHEN	@P_language = N'en'
			THEN	IIF(ISNULL(L0010_63.name_english,N'') = N'', M0086.relationship, L0010_63.name_english)
			ELSE	IIF(ISNULL(L0010_63.name,N'') = N'', M0086.relationship, L0010_63.name)
		END												AS relationship
	,	CASE
				WHEN @P_language = N'en'
				THEN ISNULL(L0010_68.name_english,N'')
				ELSE ISNULL(L0010_68.name,N'')
		END					AS gender
	,	CONVERT(VARCHAR(10),M0086.birthday, 111)		AS birthday
	,	CASE
				WHEN @P_language = N'en'
				THEN ISNULL(L0010_69.name_english,N'')
				ELSE ISNULL(L0010_69.name,N'')
		END					AS residential_classification
	,	CASE
			WHEN	@P_language = N'en'
			THEN	IIF(ISNULL(L0010_70.name_english,N'') = N'', M0086.profession, L0010_70.name_english)
			ELSE	IIF(ISNULL(L0010_70.name,N'') = N'', M0086.profession, L0010_70.name)
		END												AS profession
	FROM M0086 WITH(NOLOCK)
	LEFT JOIN M0085 WITH(NOLOCK) ON(
		M0086.company_cd	= M0085.company_cd
	AND	M0086.employee_cd	= M0085.employee_cd
	AND M0085.del_datetime IS NULL
	)
	LEFT JOIN L0010 AS L0010_67 WITH (NOLOCK) ON (
		L0010_67.name_typ			=	67
	AND	M0085.marital_status		= L0010_67.number_cd				
	AND	L0010_67.del_datetime		IS NULL
	)
	LEFT JOIN L0010 AS L0010_63 WITH (NOLOCK) ON (
		L0010_63.name_typ			=	63
	AND	M0086.relationship			= CONVERT(NVARCHAR(10),L0010_63.number_cd)
	AND	L0010_63.del_datetime		IS NULL
	)
	LEFT JOIN L0010 AS L0010_68 WITH (NOLOCK) ON (
		L0010_68.name_typ			=	68
	AND	M0086.gender				=	L0010_68.number_cd	
	AND	L0010_68.del_datetime		IS NULL
	)
	LEFT JOIN L0010 AS L0010_69 WITH (NOLOCK) ON (
		L0010_69.name_typ				 =	69
	AND	M0086.residential_classification =	L0010_69.number_cd
	AND	L0010_69.del_datetime		IS NULL
	)
	LEFT JOIN L0010 AS L0010_70 WITH (NOLOCK) ON (
		L0010_70.name_typ			=	70
	AND	M0086.profession			=	CONVERT(NVARCHAR(10),L0010_70.number_cd)
	AND	L0010_70.del_datetime		IS NULL
	)
	WHERE
		M0086.company_cd	= @P_company_cd
	AND	M0086.employee_cd	= @P_employee_cd
	AND M0086.del_datetime IS NULL
	END
	ELSE 
	BEGIN 
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
	END
	--tab 休職タブ [20]
	IF EXISTS (SELECT * FROM #CHECK_PER WHERE (empinfo_authority_typ IN (4,5) AND tab_id = 10 AND use_typ_M9102 = 1) OR (empinfo_authority_typ = 3 AND tab_id = 10 AND use_typ_M5100 <> 0 ))
	BEGIN
	CREATE TABLE #M0087 (	
		id							INT NOT NULL IDENTITY(1,1) 
	,	leave_absence_startdate		DATE
	,	leave_absence_enddate		DATE
	,	remarks						NVARCHAR(500)
	)
	--
	INSERT INTO #M0087
	SELECT	
		leave_absence_startdate
	,	leave_absence_enddate
	,	ISNULL(remarks,N'') AS remarks
	FROM M0087 WITH(NOLOCK)
	WHERE
		M0087.employee_cd	= @P_employee_cd
	AND	M0087.company_cd	= @P_company_cd
	AND M0087.del_datetime IS NULL
	--
	SELECT 
		id
	,	ISNULL( CONVERT(VARCHAR(10), leave_absence_startdate, 111)	, NULL)	AS leave_absence_startdate	
	,	ISNULL( CONVERT(VARCHAR(10), leave_absence_enddate, 111)	, NULL)	AS leave_absence_enddate	
	,	remarks					
	FROM #M0087
	END
	ELSE 
	BEGIN 
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
	END
	--tab 有期雇用契約タブ [21]
	IF EXISTS (SELECT * FROM #CHECK_PER WHERE (empinfo_authority_typ IN (4,5) AND tab_id = 11 AND use_typ_M9102 = 1) OR (empinfo_authority_typ = 3 AND tab_id = 11 AND use_typ_M5100 <> 0 ))
	BEGIN
		CREATE TABLE #TABLE_M0088 (
			employment_contract_no	INT
		,	detail_no				INT  
		,	start_date				DATE
		,	expiration_date			DATE
		,	contract_renewal_kbn	NVARCHAR(200)
		,	reason_resignation		NVARCHAR(200)
		,	remarks					NVARCHAR(200)
		)
		--
		CREATE TABLE #M0088_REQ (
			id									INT NOT NULL IDENTITY(1,1) 
		,	employment_contract_no				INT
		,	total_contract_period				INT
		,	number_of_contract_renewals			INT
		,	stt_detail_no						INT  
		,	start_date							DATE
		,	expiration_date						DATE
		,	contract_renewal_kbn				NVARCHAR(200)
		,	reason_resignation					NVARCHAR(200)
		,	remarks								NVARCHAR(200)
		,	check_footer						INT
		)
		--
		INSERT INTO #TABLE_M0088
		SELECT
			employment_contract_no
		,	detail_no
		,	ISNULL( CONVERT(VARCHAR(10), start_date, 111), NULL)	AS	start_date
		,	ISNULL( CONVERT(VARCHAR(10), expiration_date, 111), NULL)	AS	expiration_date
		,	CASE
					WHEN @P_language = N'en'
					THEN ISNULL(L0010.name_english,N'')
					ELSE ISNULL(L0010.name,N'')
			END	AS contract_renewal_kbn
		,	reason_resignation
		,	remarks
		FROM M0088
		LEFT JOIN L0010 WITH(NOLOCK) ON (
			M0088.contract_renewal_kbn	= L0010.number_cd
		AND L0010.name_typ				= 76
		AND L0010.del_datetime IS NULL
		)
		WHERE
			M0088.employee_cd = @P_employee_cd
		AND M0088.company_cd = @P_company_cd
		AND M0088.del_datetime IS NULL
		--
		INSERT INTO #M0088_REQ
		SELECT 
			employment_contract_no
		,	(
			SELECT 
				SUM (
					CASE 
					WHEN YEAR(expiration_date) < YEAR(start_date) THEN 0
					WHEN YEAR(expiration_date) = YEAR(start_date) THEN
						CASE 
							WHEN DAY(expiration_date) = DAY(EOMONTH(expiration_date)) AND DAY(start_date) = 1 AND MONTH(start_date) = MONTH(expiration_date) THEN 1
							ELSE MONTH(expiration_date) - MONTH(start_date) +
								CASE 
									WHEN DAY(expiration_date) = DAY(EOMONTH(expiration_date)) AND MONTH(start_date) != MONTH(expiration_date) THEN 1
									ELSE 0
								END +
								CASE 
									WHEN DAY(expiration_date) - DAY(start_date) = -1 THEN 1
									ELSE 0
								END -
								CASE 
									WHEN DAY(expiration_date) < DAY(start_date) THEN 1
									ELSE 0
								END
						END
					ELSE
						DATEDIFF(YEAR, start_date, expiration_date)*12 - MONTH(start_date) + MONTH(expiration_date)  +
							CASE 
								WHEN DAY(expiration_date) < DAY(start_date) THEN -1
								ELSE 0
							END +
							CASE 
								WHEN DAY(expiration_date) = DAY(EOMONTH(expiration_date)) AND MONTH(start_date) != MONTH(expiration_date) THEN 1
								ELSE 0
							END +
							CASE 
								WHEN DAY(expiration_date) - DAY(start_date) = -1 THEN 1
								ELSE 0
							END
				END
				)
			FROM #TABLE_M0088
			WHERE
				#TABLE_M0088.employment_contract_no = M0088.employment_contract_no
		)	AS total_contract_period
		,	(
			SELECT 
				COUNT(detail_no)
			FROM #TABLE_M0088
			WHERE
				#TABLE_M0088.employment_contract_no = M0088.employment_contract_no
		)	AS number_of_contract_renewals
		,	ROW_NUMBER() OVER(PARTITION BY employment_contract_no ORDER BY employment_contract_no ASC) AS stt_detail_no
		,	ISNULL( CONVERT(VARCHAR(10), start_date, 111), NULL)	AS	start_date
		,	ISNULL( CONVERT(VARCHAR(10), expiration_date, 111), NULL)	AS	expiration_date
		,	contract_renewal_kbn
		,	reason_resignation
		,	remarks		
		,	0
		FROM M0088
		WHERE 
			M0088.employee_cd = @P_employee_cd
		AND M0088.company_cd = @P_company_cd
		AND M0088.del_datetime IS NULL
		GROUP BY employment_contract_no,detail_no,start_date,expiration_date, contract_renewal_kbn, reason_resignation, remarks
		--	
		UPDATE #M0088_REQ
		SET check_footer = 1
		FROM #M0088_REQ inner join (
		SELECT employment_contract_no, MAX(stt_detail_no) AS stt_detail_no FROM #M0088_REQ GROUP BY employment_contract_no
		) AS b ON(#M0088_REQ.employment_contract_no = b.employment_contract_no AND #M0088_REQ.stt_detail_no = b.stt_detail_no )
		--
		SELECT 
			id
		,	employment_contract_no
		,	IIF(@P_language = N'en',CAST(total_contract_period / 12 AS NVARCHAR(255)) + N' year ' + CAST(total_contract_period % 12 AS NVARCHAR(255)) + N' months',CAST(total_contract_period / 12 AS NVARCHAR(255)) + N'年' + CAST(total_contract_period % 12 AS NVARCHAR(255)) + N'ヵ月')  AS total_contract_period
		,	number_of_contract_renewals
		,	stt_detail_no
		,	ISNULL( CONVERT(VARCHAR(10), start_date, 111), NULL)	AS	start_date
		,	ISNULL( CONVERT(VARCHAR(10), expiration_date, 111), NULL)	AS	expiration_date
		,	CASE
					WHEN @P_language = N'en'
					THEN ISNULL(L0010.name_english,N'')
					ELSE ISNULL(L0010.name,N'')
			END	AS contract_renewal_kbn
		,	reason_resignation
		,	remarks		
		,	check_footer
		FROM #M0088_REQ
		LEFT JOIN L0010 WITH(NOLOCK) ON (
			#M0088_REQ.contract_renewal_kbn	= L0010.number_cd
		AND L0010.name_typ				= 76
		AND L0010.del_datetime IS NULL
		)
		WHERE 
			id <> 0
	DROP TABLE #M0088_REQ
	DROP TABLE #TABLE_M0088
	END
	ELSE 
	BEGIN 
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
	END
	--tab 社会保険タブ [22-26]
	IF EXISTS (SELECT * FROM #CHECK_PER WHERE (empinfo_authority_typ IN (4,5) AND tab_id = 12 AND use_typ_M9102 = 1) OR (empinfo_authority_typ = 3 AND tab_id = 12 AND use_typ_M5100 <> 0 ))
	BEGIN
	--1		[20]
	SELECT 
		ISNULL(employment_insurance_no				, N'') AS employment_insurance_no
	,	ISNULL(basic_pension_no						, N'') AS basic_pension_no
	,	CASE
			WHEN employment_insurance_status = 1 THEN IIF(@P_language = N'en',N'Join',N'加入')
			WHEN employment_insurance_status = 2 THEN IIF(@P_language = N'en',N'Non-participation',N'非加入')
			ELSE SPACE(0)
		END AS employment_insurance_status
	,	CASE
			WHEN health_insurance_status = 1 THEN IIF(@P_language = N'en',N'Join',N'加入')
			WHEN health_insurance_status = 2 THEN IIF(@P_language = N'en',N'Non-participation',N'非加入')
			ELSE SPACE(0)
		END   AS health_insurance_status
	,	ISNULL(health_insurance_reference_no		, 0)   AS health_insurance_reference_no
	,	CASE
			WHEN employees_pension_insurance_status = 1 THEN IIF(@P_language = N'en',N'Join',N'加入')
			WHEN employees_pension_insurance_status = 2 THEN IIF(@P_language = N'en',N'Non-participation',N'非加入')
			ELSE SPACE(0)
		END   AS employees_pension_insurance_status
	,	ISNULL(employees_pension_reference_no		, 0)   AS employees_pension_reference_no
	,	CASE
			WHEN welfare_pension_status = 1 THEN IIF(@P_language = N'en',N'Join',N'加入')
			WHEN welfare_pension_status = 2 THEN IIF(@P_language = N'en',N'Non-participation',N'非加入')
			ELSE SPACE(0)
		END   AS welfare_pension_status
	,	ISNULL(employees_pension_member_no			, 0)   AS employees_pension_member_no
	FROM M0090 WITH (NOLOCK)
	WHERE 
		M0090.company_cd	= @P_company_cd
	AND M0090.employee_cd	= @P_employee_cd
	AND M0090.del_datetime IS NULL
	--
	--CREATE TABLE #Temp (
	--	id int identity (0,1),
	--	header INT,
	--	joining_date NVARCHAR(10),
	--	date_of_loss NVARCHAR(10),
	--	reason_for_loss NVARCHAR(255)
	--);
	--INSERT INTO #Temp
	SELECT
		1 AS header	
	,	ISNULL(CONVERT(VARCHAR(10),joining_date,111), NULL) AS joining_date
	,	ISNULL(CONVERT(VARCHAR(10),date_of_loss,111), NULL) AS date_of_loss
	,	CASE
			WHEN	@P_language = N'en'
			THEN	ISNULL(L0010.name_english,N'')
			ELSE	ISNULL(L0010.name,N'')
		END										AS reason_for_loss_kbn
	FROM M0091 WITH (NOLOCK)
	LEFT JOIN L0010 WITH (NOLOCK) ON (
		L0010.name_typ			=	71
	AND	L0010.number_cd =	M0091.reason_for_loss_kbn
	AND	L0010.del_datetime		IS NULL
	)
	WHERE 
		M0091.company_cd	= @P_company_cd
	AND M0091.employee_cd	= @P_employee_cd
	AND M0091.del_datetime IS NULL
	AND M0091.social_insurance_kbn  = 1
	--UNION ALL
	SELECT
		2 AS header
	,	ISNULL(CONVERT(VARCHAR(10),joining_date,111),NULL) AS joining_date
	,	ISNULL(CONVERT(VARCHAR(10),date_of_loss,111),NULL) AS date_of_loss
	,	CASE
			WHEN	@P_language = N'en'
			THEN	IIF(ISNULL(L0010.name_english,N'') = N'', M0091.reason_for_loss, L0010.name_english)
			ELSE	IIF(ISNULL(L0010.name,N'') = N'', M0091.reason_for_loss, L0010.name)
		END										AS reason_for_loss
	FROM M0091 WITH (NOLOCK)
	LEFT JOIN L0010 WITH (NOLOCK) ON (
		L0010.name_typ			=	72
	AND	CONVERT(NVARCHAR(10),L0010.number_cd) =	M0091.reason_for_loss
	AND	L0010.del_datetime		IS NULL
	)
	WHERE 
		M0091.company_cd	= @P_company_cd
	AND M0091.employee_cd	= @P_employee_cd
	AND M0091.del_datetime IS NULL
	AND M0091.social_insurance_kbn  = 2
	--UNION ALL
	SELECT
		3 AS header
	,	ISNULL(CONVERT(VARCHAR(10),joining_date,111),NULL) AS joining_date
	,	ISNULL(CONVERT(VARCHAR(10),date_of_loss,111),NULL) AS date_of_loss
	,	CASE
			WHEN	@P_language = N'en'
			THEN	IIF(ISNULL(L0010.name_english,N'') = N'', M0091.reason_for_loss, L0010.name_english)
			ELSE	IIF(ISNULL(L0010.name,N'') = N'', M0091.reason_for_loss, L0010.name)
		END										AS reason_for_loss
	FROM M0091 WITH (NOLOCK)
	LEFT JOIN L0010 WITH (NOLOCK) ON (
		L0010.name_typ			=	73
	AND	CONVERT(NVARCHAR(10),L0010.number_cd) =	M0091.reason_for_loss
	AND	L0010.del_datetime		IS NULL
	)
	WHERE 
		M0091.company_cd	= @P_company_cd
	AND M0091.employee_cd	= @P_employee_cd
	AND M0091.del_datetime IS NULL
	AND M0091.social_insurance_kbn  = 3
	--UNION ALL
	SELECT
		4 AS header
	,	ISNULL(CONVERT(VARCHAR(10),joining_date,111),NULL) AS joining_date
	,	ISNULL(CONVERT(VARCHAR(10),date_of_loss,111),NULL) AS date_of_loss
	,	CASE
			WHEN	@P_language = N'en'
			THEN	IIF(ISNULL(L0010.name_english,N'') = N'', M0091.reason_for_loss, L0010.name_english)
			ELSE	IIF(ISNULL(L0010.name,N'') = N'', M0091.reason_for_loss, L0010.name)
		END										AS reason_for_loss	
	FROM M0091 WITH (NOLOCK)
	LEFT JOIN L0010 WITH (NOLOCK) ON (
		L0010.name_typ			=	74
	AND	CONVERT(NVARCHAR(10),L0010.number_cd) =	M0091.reason_for_loss
	AND	L0010.del_datetime		IS NULL
	)
	WHERE 
		M0091.company_cd	= @P_company_cd
	AND M0091.employee_cd	= @P_employee_cd
	AND M0091.del_datetime IS NULL
	AND M0091.social_insurance_kbn  = 4

	-- Tạo bảng kết quả tạm thời

	--SELECT 
	--	(#Temp.id + #Temp.header*2 +((#Temp.id + #Temp.header*2)/45)*2) AS page
	--,	#Temp.header 
	--,	#Temp.joining_date 
	--,	#Temp.date_of_loss 
	--,	#Temp.reason_for_loss 
	--,	IIF(Temp1.id IS NULL,0, 1) + IIF(Temp2.id IS NULL,0, 2) AS slpit_page
	----,	ISNULL(a*45 - (Temp3.id + Temp3.header*2 +((Temp3.id + Temp3.header*2)/45)*2),1) -1 AS to_page
	--,a
	--FROM #Temp
	--LEFT JOIN (
	--SELECT 
	--	MIN(id) AS id
	--FROM #Temp 
	
	--GROUP BY header
	--)AS Temp1 ON (
	--	#Temp.id = Temp1.id
	--)
	--LEFT JOIN (
	--SELECT 
	--	MIN(#Temp.id) as id
	--, 45-(#Temp.id + #Temp.header*2 +((#Temp.id + #Temp.header*2)/45)*2)%45 AS a
	--FROM #Temp 
	----WHERE (#Temp.id + header*2 +((#Temp.id + header*2)/45)*2)/45 > 0
	--GROUP BY 45-(#Temp.id + #Temp.header*2 +((#Temp.id + #Temp.header*2)/45)*2)%45
	--)AS Temp2 ON (
	--	#Temp.id = Temp2.id
	--)
	--LEFT JOIN #Temp as Temp3 ON (
	--	#Temp.id = Temp3.id+1
	--)

	END
	ELSE 
	BEGIN 
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
	END
	--tab 給与タブ [27]
	IF EXISTS (SELECT * FROM #CHECK_PER WHERE (empinfo_authority_typ IN (4,5) AND tab_id = 13 AND use_typ_M9102 = 1) OR (empinfo_authority_typ = 3 AND tab_id = 13 AND use_typ_M5100 <> 0 ))
	BEGIN
	SELECT
		ISNULL(FORMAT(M0092.base_salary, '###,###'),0) AS base_salary
	,	ISNULL(FORMAT(M0092.basic_annual_income, '###,###'),0) AS basic_annual_income
	FROM M0092 WITH(NOLOCK)	
	WHERE
		M0092.employee_cd = @P_employee_cd
	AND M0092.company_cd = @P_company_cd
	AND M0092.del_datetime IS NULL
	END
	ELSE 
	BEGIN 
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
	END
	--tab 賞罰タブ [28]
	IF EXISTS (SELECT * FROM #CHECK_PER WHERE (empinfo_authority_typ IN (4,5) AND tab_id = 14 AND use_typ_M9102 = 1) OR (empinfo_authority_typ = 3 AND tab_id = 14 AND use_typ_M5100 <> 0 ))
	BEGIN
	CREATE TABLE #M0093 (	
			id							INT NOT NULL IDENTITY(1,1) 
		,	detail_no					INT
		,	reward_punishment_typ		NVARCHAR(500)	
		,	decision_date				DATE
		,	reason						NVARCHAR(500)	
		,	remarks						NVARCHAR(500)
		) 
		--
	INSERT INTO #M0093
	SELECT
		detail_no
	,	CASE
				WHEN @P_language = N'en'
				THEN ISNULL(L0010.name_english,N'')
				ELSE ISNULL(L0010.name,N'')
			END	AS reward_punishment_typ
	,	ISNULL( CONVERT(VARCHAR(10), M0093.decision_date, 111)	, NULL)	AS decision_date
	,	reason
	,	remarks
	FROM M0093 WITH(NOLOCK)
	LEFT JOIN L0010 WITH(NOLOCK) ON(
		M0093.reward_punishment_typ = L0010.number_cd
	AND	L0010.name_typ				= 75
	AND	L0010.del_datetime IS NULL
	)
	WHERE
		M0093.employee_cd = @P_employee_cd
	AND M0093.company_cd = @P_company_cd
	AND M0093.del_datetime IS NULL
	--
	SELECT 
		#M0093.id
	,	reward_punishment_typ
	,	ISNULL( CONVERT(VARCHAR(10), #M0093.decision_date, 111)	, NULL)	AS decision_date
	,	ISNULL(reason,N'')	AS reason
	,	ISNULL(remarks,N'') AS remarks
	FROM #M0093
	END
	ELSE 
	BEGIN 
		SELECT NULL AS NO_PERMISSION
		WHERE 1=0
	END
	--[29]任意情報
	SELECT
		M0080.item_nm
	,	CASE
			WHEN M0080.item_kind = 1 THEN ISNULL(M0072.character_item,N'')
			WHEN M0080.item_kind = 2 THEN ISNULL(CAST(M0072.number_item AS NVARCHAR(50)),N'')
			WHEN M0080.item_kind = 3 THEN ISNULL( CONVERT(VARCHAR(10), M0072.date_item, 111), NULL)
			WHEN M0080.item_kind = 4 THEN ISNULL(M0081.detail_name,N'')
			WHEN M0080.item_kind = 5 THEN ISNULL(M0081.detail_name,N'')
			ELSE N''
		END AS value_name
	,	CASE
			WHEN M0080.item_kind IN (1, 4, 5) THEN N'text'
			WHEN M0080.item_kind = 2 THEN N'number'
			WHEN M0080.item_kind = 3 THEN N'date'
			ELSE N''
		END AS value_type
	FROM M0072 WITH(NOLOCK)
	LEFT JOIN M0080 WITH(NOLOCK) ON(
		M0072.item_cd		= M0080.item_cd
	AND	M0072.company_cd	= M0080.company_cd
	)
	LEFT JOIN M0081 WITH(NOLOCK) ON(
		M0080.item_cd		= M0081.item_cd
	AND	M0072.company_cd	= M0081.company_cd
	AND M0072.number_item	= M0081.detail_no
	)
	WHERE
		M0072.company_cd = @P_company_cd 
	AND M0072.employee_cd = @P_employee_cd 
	AND M0072.del_datetime IS NULL		
	ORDER BY 
		M0080.arrange_order
	,	M0072.item_cd ASC

	
	DROP TABLE #CHECK_PER
	DROP TABLE #M0071
	DROP TABLE #M0073
	DROP TABLE #M0071_2
	DROP TABLE #M0073_2
END
GO
