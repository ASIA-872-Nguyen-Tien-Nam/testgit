DROP PROCEDURE [SPC_rI1021_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	rI1021-APPLY
--*  
--*  作成日/create date			:	2023/04/27					
--*　作成者/creater				:	quangnd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rI1021_INQ1]
	@P_company_cd				smallint			=	0
,	@P_fiscal_year				smallint			=	0
,	@P_report_kind				smallint			=	0
,	@P_group_cd					smallint			=	0
,	@P_employee					nvarchar(10)		=	''	
,	@P_today					date				=	NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_today							date				=	GETDATE()
	,	@w_browse_position_typ				smallint			=	0
	,	@w_browse_department_typ			smallint			=	0
	,	@w_arrange_order					int					=	0
	,	@w_position_cd						int					=	0
	-----
	set @w_today = IIF(@P_today = NULL,@w_today,@P_today)
	CREATE TABLE #M0071(
		id						int				identity(1,1)
	,	company_cd				smallint
	,	employee_cd				nvarchar(10)
	,	application_date		date
	)
	INSERT INTO #M0071
	SELECT 
		ISNULL(M0071.company_cd,0)				AS	company_cd
	,	ISNULL(M0071.employee_cd,'')			AS	employee_cd
	,	MAX(M0071.application_date)				AS	application_date
	FROM M0071
	WHERE 
		M0071.company_cd		=	@P_company_cd
	AND M0071.application_date	<=	@w_today
	AND M0071.del_datetime IS NULL
	GROUP BY
		M0071.company_cd
	,	M0071.employee_cd
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
	--#INFO_EMP
	CREATE TABLE #INFO_EMP(
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
	CREATE TABLE #F4121_FAKE (
		id					int		identity(1,1)
	,	employee_cd			nvarchar(10)
	,	viewer_employee_cd	nvarchar(10)
	,	viewer_employee_nm	nvarchar(101)
	)
	--
	CREATE TABLE #F4121_JSON (
		id					int		identity(1,1)
	,	employee_cd			nvarchar(10)
	,	list_viewer			nvarchar(max)
	)
	--
	CREATE TABLE #M4603 (
		company_cd				SMALLINT
	,	group_cd				SMALLINT
	,	organization_cd_1		NVARCHAR(20)
	,	organization_cd_2		NVARCHAR(20)
	,	organization_cd_3		NVARCHAR(20)
	,	organization_cd_4		NVARCHAR(20)
	,	organization_cd_5		NVARCHAR(20)	
	)
	--
	CREATE TABLE #M4604 (
		company_cd				SMALLINT
	,	group_cd				SMALLINT
	,	attribute				SMALLINT
	,	code					SMALLINT	
	)	
	--
	CREATE TABLE #M0060
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	employee_typ			SMALLINT
	,	group_cd				SMALLINT
	)	
	--
	CREATE TABLE #M0050
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	grade					SMALLINT
	,	group_cd				SMALLINT
	)
	--
	CREATE TABLE #M0040
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	position_cd				INT
	,	group_cd				SMALLINT
	)
	--
	CREATE TABLE #M0030
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	job_cd					SMALLINT
	,	group_cd				SMALLINT
	)
	--
	CREATE TABLE #M0040_EMP
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	position_cd				INT
	)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--GET INFORMATION 
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--
	SELECT 
		@w_browse_position_typ		= ISNULL(browse_position_typ,0)
	,	@w_browse_department_typ	= ISNULL(browse_department_typ,0)
	FROM M4600
	WHERE
		company_cd  = @P_company_cd
	AND	group_cd	= @P_group_cd
	AND del_datetime IS NULL
	-- #M0070H
	INSERT INTO #M0070H
	SELECT 
		#M0071.application_date					AS	application_date
	,	ISNULL(M0071.company_cd,'')				AS	company_cd
	,	ISNULL(M0071.employee_cd,'')			AS	employee_cd
	,	ISNULL(M0070.employee_nm,'')			AS	employee_nm
	,	ISNULL(M0070.employee_ab_nm,'')			AS	employee_ab_nm
	,	ISNULL(M0070.furigana,'')				AS	furigana
	,	ISNULL(M0071.office_cd,0)				AS	office_cd
	,	CASE
			WHEN ISNULL(M0010.office_ab_nm,'') = '' THEN ISNULL(M0010.office_nm,'')		
			ELSE M0010.office_ab_nm
		END	AS	office_nm
	--
	,	ISNULL(M0071.belong_cd1,'')				AS	belong_cd1
	,	ISNULL(M0071.belong_cd2,'')				AS	belong_cd2
	,	ISNULL(M0071.belong_cd3,'')				AS	belong_cd3
	,	ISNULL(M0071.belong_cd4,'')				AS	belong_cd4
	,	ISNULL(M0071.belong_cd5,'')				AS	belong_cd5
	--
	,	ISNULL(M0071.job_cd,0)					AS	job_cd
	,	ISNULL(M0071.position_cd,0)				AS	position_cd
	,	ISNULL(M0071.employee_typ,0)			AS	employee_typ
	,	ISNULL(M0071.grade,0)					AS	grade
	,CASE
		WHEN ISNULL(m0020_1.organization_ab_nm,'') = '' THEN ISNULL(m0020_1.organization_nm,'')	
		ELSE m0020_1.organization_ab_nm
	END																						AS belong_cd1_nm
	,CASE
		WHEN ISNULL(m0020_2.organization_ab_nm,'') = '' THEN ISNULL(m0020_2.organization_nm,'')		
		ELSE m0020_2.organization_ab_nm
	END																						AS belong_cd2_nm
	,CASE
		WHEN ISNULL(m0020_3.organization_ab_nm,'') = '' THEN ISNULL(m0020_3.organization_nm,'')		
		ELSE m0020_3.organization_ab_nm
	END																						AS belong_cd3_nm
	,CASE
		WHEN ISNULL(m0020_4.organization_ab_nm,'') = '' THEN ISNULL(m0020_4.organization_nm,'')		
		ELSE m0020_4.organization_ab_nm
	END																						AS belong_cd4_nm
	,CASE
		WHEN ISNULL(m0020_5.organization_ab_nm,'') = '' THEN ISNULL(m0020_5.organization_nm,'')		
		ELSE m0020_5.organization_ab_nm
	END																						AS belong_cd5_nm
	,CASE
		WHEN ISNULL(m0030.job_ab_nm,'') = '' THEN ISNULL(m0030.job_nm,'')		
		ELSE m0030.job_ab_nm
	END																						AS	job_nm
	,CASE
		WHEN ISNULL(M0040.position_ab_nm,'') = '' THEN ISNULL(M0040.position_nm,'')		
		ELSE M0040.position_ab_nm
	END																						AS	position_nm
	,	ISNULL(M0050.grade_nm,'')				AS	grade_nm
	,	ISNULL(M0060.employee_typ_nm,'')		AS	employee_typ_nm
	FROM #M0071
	LEFT OUTER JOIN M0071 ON (
		#M0071.company_cd					=	M0071.company_cd
	AND #M0071.employee_cd					=	M0071.employee_cd
	AND #M0071.application_date				=	M0071.application_date
	)
	LEFT OUTER JOIN M0070 ON (
		M0071.company_cd				=	M0070.company_cd
	AND M0071.employee_cd				=	M0070.employee_cd
	)
	LEFT OUTER JOIN M0010 ON (
		M0071.company_cd				=	M0010.company_cd
	AND M0071.office_cd					=	M0010.office_cd
	)
	
	LEFT OUTER JOIN M0020 AS M0020_1 ON (
		M0071.company_cd				=	M0020_1.company_cd
	AND M0071.belong_cd1				=	M0020_1.organization_cd_1
	AND SPACE(0)						=	M0020_1.organization_cd_2
	AND SPACE(0)						=	M0020_1.organization_cd_3
	AND SPACE(0)						=	M0020_1.organization_cd_4
	AND SPACE(0)						=	M0020_1.organization_cd_5
	AND	1								=	M0020_1.organization_typ
	)
	LEFT OUTER JOIN M0020 AS M0020_2 ON (
		M0071.company_cd				=	M0020_2.company_cd
	AND M0071.belong_cd1				=	M0020_2.organization_cd_1
	AND M0071.belong_cd2				=	M0020_2.organization_cd_2
	AND SPACE(0)						=	M0020_1.organization_cd_3
	AND SPACE(0)						=	M0020_1.organization_cd_4
	AND SPACE(0)						=	M0020_1.organization_cd_5
	AND	2								=	M0020_2.organization_typ
	)
	LEFT OUTER JOIN M0020 AS M0020_3 ON (
		M0071.company_cd				=	M0020_3.company_cd
	AND M0071.belong_cd1				=	M0020_3.organization_cd_1
	AND M0071.belong_cd2				=	M0020_3.organization_cd_2
	AND M0071.belong_cd3				=	M0020_3.organization_cd_3
	AND SPACE(0)						=	M0020_1.organization_cd_4
	AND SPACE(0)						=	M0020_1.organization_cd_5
	AND	3								=	M0020_3.organization_typ
	)
	LEFT OUTER JOIN M0020 AS M0020_4 ON (
		M0071.company_cd				=	M0020_4.company_cd
	AND M0071.belong_cd1				=	M0020_4.organization_cd_1
	AND M0071.belong_cd2				=	M0020_4.organization_cd_2
	AND M0071.belong_cd3				=	M0020_4.organization_cd_3
	AND M0071.belong_cd4				=	M0020_4.organization_cd_4
	AND SPACE(0)						=	M0020_1.organization_cd_5
	AND	4								=	M0020_4.organization_typ
	)
	LEFT OUTER JOIN M0020 AS M0020_5 ON (
		M0071.company_cd				=	M0020_5.company_cd
	AND M0071.belong_cd1				=	M0020_5.organization_cd_1
	AND M0071.belong_cd2				=	M0020_5.organization_cd_2
	AND M0071.belong_cd3				=	M0020_5.organization_cd_3
	AND M0071.belong_cd4				=	M0020_5.organization_cd_4
	AND M0071.belong_cd5				=	M0020_5.organization_cd_5
	AND	5								=	M0020_5.organization_typ
	)
	LEFT OUTER JOIN M0030 ON (
		M0071.company_cd				=	M0030.company_cd
	AND M0071.job_cd					=	M0030.job_cd
	)
	LEFT OUTER JOIN M0040 ON (
		M0071.company_cd				=	M0040.company_cd
	AND M0071.position_cd				=	M0040.position_cd
	)
	LEFT OUTER JOIN M0050 ON (
		M0071.company_cd				=	M0050.company_cd
	AND M0071.grade						=	M0050.grade
	)
	LEFT OUTER JOIN M0060 ON (
		M0071.company_cd				=	M0060.company_cd
	AND M0071.employee_typ				=	M0060.employee_typ
	)
	--
	INSERT INTO #INFO_EMP
	SELECT
		#M0070H.application_date
	,	#M0070H.company_cd		
	,	#M0070H.employee_cd		
	,	#M0070H.employee_nm		
	,	#M0070H.employee_ab_nm	
	,	#M0070H.furigana		
	,	#M0070H.office_cd		
	,	#M0070H.office_nm		
	,	#M0070H.belong_cd_1		
	,	#M0070H.belong_cd_2		
	,	#M0070H.belong_cd_3		
	,	#M0070H.belong_cd_4		
	,	#M0070H.belong_cd_5		
	,	#M0070H.job_cd			
	,	#M0070H.position_cd		
	,	#M0070H.employee_typ	
	,	#M0070H.grade			
	,	#M0070H.belong_nm_1		
	,	#M0070H.belong_nm_2		
	,	#M0070H.belong_nm_3		
	,	#M0070H.belong_nm_4		
	,	#M0070H.belong_nm_5		
	,	#M0070H.job_nm			
	,	#M0070H.position_nm		
	,	#M0070H.grade_nm		
	,	#M0070H.employee_typ_nm	
	FROM #M0070H
	WHERE
		#M0070H.employee_cd = @P_employee
	--
	SET @w_position_cd	= (SELECT position_cd FROM #INFO_EMP)
	-- get @arrange_order
	SELECT 
		@w_arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@w_position_cd
	AND M0040.del_datetime IS NULL
	--
	INSERT INTO #M4604
	SELECT
		M4604.company_cd			
	,	M4604.group_cd			
	,	M4604.attribute					
	,	M4604.code						
	FROM M4604
	WHERE
		M4604.company_cd	=	@P_company_cd
	AND M4604.group_cd		=	@P_group_cd
	AND M4604.del_datetime IS NULL
	--
	INSERT INTO #M4603
	SELECT
		M4603.company_cd			
	,	M4603.group_cd			
	,	M4603.organization_cd_1
	,	M4603.organization_cd_2					
	,	M4603.organization_cd_3					
	,	M4603.organization_cd_4					
	,	M4603.organization_cd_5										
	FROM M4603
	WHERE
		M4603.company_cd	=	@P_company_cd
	AND M4603.group_cd		=	@P_group_cd
	AND	M4603.organization_cd_1 <>''
	AND M4603.del_datetime IS NULL
	--
	INSERT INTO #M0060
	SELECT 
		M0060.company_cd		
	,	M0060.employee_typ
	,	#M4604.group_cd
	FROM M0060
	INNER JOIN #M4604 ON (
		M0060.company_cd	= #M4604.company_cd
	AND	M0060.employee_typ	= #M4604.code
	)
	WHERE 
		 M0060.company_cd = @P_company_cd
	 AND M0060.del_datetime IS NULL
	 AND #M4604.attribute = 4
	--
	INSERT INTO #M0050
	SELECT 
		M0050.company_cd		
	,	M0050.grade
	,	#M4604.group_cd
	FROM M0050
	INNER JOIN #M4604 ON (
		M0050.company_cd	= #M4604.company_cd
	AND	M0050.grade			= #M4604.code
	)
	WHERE 
		 M0050.company_cd = @P_company_cd
	 AND M0050.del_datetime IS NULL
	 AND #M4604.attribute = 3
	--
	INSERT INTO #M0040
	SELECT 
		M0040.company_cd
	,	M0040.position_cd
	,	#M4604.group_cd
	FROM M0040
	INNER JOIN #M4604 ON (
		M0040.company_cd	= #M4604.company_cd
	AND	M0040.position_cd	= #M4604.code
	)
	WHERE 
		 M0040.company_cd = @P_company_cd
	 AND M0040.del_datetime IS NULL
	 AND #M4604.attribute = 1
	--
	INSERT INTO #M0030
	SELECT 
		M0030.company_cd
	,	M0030.job_cd
	,	#M4604.group_cd
	FROM M0030
	INNER JOIN #M4604 ON (
		M0030.company_cd	= #M4604.company_cd
	AND	M0030.job_cd		= #M4604.code
	)
	WHERE 
		M0030.company_cd = @P_company_cd
	AND M0030.del_datetime IS NULL
	AND #M4604.attribute = 2
	--
	IF(@w_browse_position_typ = 1)
	BEGIN
		INSERT INTO #M0040_EMP
		SELECT 
			@P_company_cd
		,	ISNULL(M0040.position_cd,0)			
		FROM M0040
		WHERE 
			M0040.company_cd		=	@P_company_cd
		AND M0040.arrange_order		>=	@w_arrange_order
		AND M0040.del_datetime IS NULL
		--DELETE
		IF EXISTS ( SELECT 1 FROM #M0040_EMP)
		BEGIN
			DELETE D FROM #M0070H AS D
			INNER JOIN #M0040_EMP ON (
				D.company_cd	= #M0040_EMP.company_cd
			AND	D.position_cd	= #M0040_EMP.position_cd
			)
		END
	END
	--
	IF(@w_browse_department_typ = 1)
	BEGIN
		DELETE D FROM #M0070H AS D
		LEFT OUTER JOIN #INFO_EMP ON (
			D.company_cd			=	@P_company_cd
		AND D.belong_cd_1			=	#INFO_EMP.belong_cd_1
		AND D.belong_cd_2			=	#INFO_EMP.belong_cd_2
		AND D.belong_cd_3			=	#INFO_EMP.belong_cd_3
		AND D.belong_cd_4			=	#INFO_EMP.belong_cd_4
		AND D.belong_cd_5			=	#INFO_EMP.belong_cd_5
		)
		WHERE 
			#INFO_EMP.company_cd IS NULL
	END
	ELSE
	BEGIN
		IF EXISTS ( SELECT 1 FROM #M4603)
		BEGIN
			DELETE D FROM #M0070H AS D
			LEFT OUTER JOIN #M4603 ON (
				D.company_cd			=	@P_company_cd
			AND D.belong_cd_1			=	#M4603.organization_cd_1
			AND D.belong_cd_2			=	#M4603.organization_cd_2
			AND D.belong_cd_3			=	#M4603.organization_cd_3
			AND D.belong_cd_4			=	#M4603.organization_cd_4
			AND D.belong_cd_5			=	#M4603.organization_cd_5
			)
			WHERE 
				#M4603.group_cd IS NULL
		END
	END
	-- KHÔNG XEM ĐC CHÍNH MÌNH và những thằng đã đc appvo
	DELETE D FROM #M0070H AS D
	WHERE 
		D.employee_cd = @P_employee
	OR	@P_group_cd	  = 0
	OR	@P_group_cd	  = -1
	-- #M0060
	IF EXISTS ( SELECT 1 FROM #M0060)
	BEGIN
		DELETE D FROM #M0070H AS D
		LEFT OUTER JOIN #M0060 ON (
			D.company_cd	= #M0060.company_cd
		AND	D.employee_typ	= #M0060.employee_typ
		)
		WHERE 
			#M0060.employee_typ IS NULL
	END 
	-- #M0030
	IF EXISTS ( SELECT 1 FROM #M0030)
	BEGIN
		DELETE D FROM #M0070H AS D
		LEFT OUTER JOIN #M0030 ON (
			D.company_cd	= #M0030.company_cd
		AND	D.job_cd		= #M0030.job_cd
		)
		WHERE 
			#M0030.job_cd IS NULL
	END
	-- #M0040
	IF EXISTS ( SELECT 1 FROM #M0040)
	BEGIN
		DELETE D FROM #M0070H AS D
		LEFT OUTER JOIN #M0040 ON (
			D.company_cd	= #M0040.company_cd
		AND	D.position_cd	= #M0040.position_cd
		)
		WHERE 
			#M0040.position_cd IS NULL
	END
	-- #M0050
	IF EXISTS ( SELECT 1 FROM #M0050)
	BEGIN
		DELETE D FROM #M0070H AS D
		LEFT OUTER JOIN #M0050 ON (
			D.company_cd	= #M0050.company_cd
		AND	D.grade			= #M0050.grade
		)
		WHERE 
			#M0050.grade IS NULL
	END
	--ĐÃ LỌC XONG NHÂN VIÊN
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--GET DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	INSERT INTO #F4121_FAKE
	SELECT
		@P_employee
	,	#M0070H.employee_cd
	,	#M0070H.employee_nm
	FROM #M0070H
	ORDER BY 
		CASE ISNUMERIC(#M0070H.employee_cd) 
			WHEN 1 
			THEN CAST(#M0070H.employee_cd AS BIGINT) 
			ELSE 999999999999999 
		END
	-- JSON
	INSERT INTO #F4121_JSON
	SELECT 
		#F4121_FAKE.employee_cd
	,	(
		SELECT 
			#F4121_FAKE.viewer_employee_cd	AS	"viewer_employee_cd"
		,	#F4121_FAKE.viewer_employee_nm	AS	"viewer_employee_nm"
		FROM #F4121_FAKE
		FOR JSON PATH
		)
	FROM #F4121_FAKE
	WHERE 
		#F4121_FAKE.employee_cd = @P_employee
	GROUP BY 
		#F4121_FAKE.employee_cd
	--RESULT
	SELECT
		@P_company_cd				AS company_cd
	,	#F4121_JSON.employee_cd		AS employee_cd
	,	#F4121_JSON.list_viewer		AS list_viewer
	FROM #F4121_JSON
END
GO
