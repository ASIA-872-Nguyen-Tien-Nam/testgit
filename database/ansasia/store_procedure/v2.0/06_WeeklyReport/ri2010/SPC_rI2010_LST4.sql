IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_rI2010_LST4]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_rI2010_LST4]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_rI2010_LST4 782,2023,'890',4,1,'890'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET SHARING EMPLOYEES FOR rI2010
--*  
--*  作成日/create date			:	2023/05/08						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rI2010_LST4]
	@P_fiscal_year			SMALLINT		=	0
,	@P_employee_cd			NVARCHAR(10)	=	''
,	@P_report_kind			SMALLINT		=	0
,	@P_report_no			SMALLINT		=	0
,	@P_page					INT				=	1
,	@P_page_size			INT				=	20
--
,	@P_employee_cd_key		NVARCHAR(10)	=	''
,	@P_employee_nm_key		NVARCHAR(50)	=	''
,	@P_employee_typ			SMALLINT		=	-1
,	@P_belong_cd1			NVARCHAR(20)	=	'-1'
,	@P_belong_cd2			NVARCHAR(20)	=	'-1'
,	@P_belong_cd3			NVARCHAR(20)	=	'-1'
,	@P_belong_cd4			NVARCHAR(20)	=	'-1'
,	@P_belong_cd5			NVARCHAR(20)	=	'-1'
,	@P_job_cd				SMALLINT		=	-1
,	@P_position_cd			INT				=	-1
,	@P_group_cd				SMALLINT		=	-1
,	@P_mygroup_cd			SMALLINT		=	-1
,	@P_company_cd			SMALLINT		=	0
,	@P_login_employee_cd	NVARCHAR(10)	=	''	-- LOGIN EMPLOYEE
 AS
BEGIN
	DECLARE 
		@w_beginning_date			date			=	NULL
	,	@w_year_month_day			date			=	NULL
	,	@w_language					smallint		=	0	-- 1.JP 2.EN
	,	@w_totalRecord				bigint			=	0
	,	@w_pageMax					int				=	0	
	,	@w_time						DATE			=	SYSDATETIME()
	--#TABLE_RESULT
	CREATE TABLE #TABLE_RESULT(
		id					int		identity(1,1)	
	,	employee_cd			nvarchar(10)				-- 共有社員
	)
	--#TABLE_EMPLOYEE_GROUP
	CREATE TABLE #TABLE_EMPLOYEE_GROUP(
		id					int		identity(1,1)	
	,	employee_cd			nvarchar(10)				-- 共有社員
	)
	--#TABLE_EMPLOYEE_MYGROUP
	CREATE TABLE #TABLE_EMPLOYEE_MYGROUP(
		id					int		identity(1,1)	
	,	employee_cd			nvarchar(10)				-- 共有社員
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
	SELECT 
		@w_language =	ISNULL(S0010.[language],1)
	FROM S0010
	WHERE 
		S0010.company_cd	=	@P_company_cd
	AND S0010.employee_cd	=	@P_login_employee_cd
	AND S0010.del_datetime IS NULL
	--
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
	--
	INSERT INTO #TABLE_RESULT
	SELECT 
		ISNULL(#M0070H.employee_cd,'')		AS	employee_cd
	FROM #M0070H
	INNER JOIN M0070 ON(
		#M0070H.company_cd = M0070.company_cd
	AND #M0070H.employee_cd = M0070.employee_cd
	)
	WHERE 
		(
			@P_employee_cd_key = ''
		OR	@P_employee_cd_key <> '' AND #M0070H.employee_cd LIKE '%'+@P_employee_cd_key+'%'
		)
	AND (
		#M0070H.employee_nm LIKE '%'+@P_employee_nm_key+'%'
	OR	#M0070H.employee_ab_nm LIKE '%'+@P_employee_nm_key+'%'
	OR	#M0070H.furigana LIKE '%'+@P_employee_nm_key+'%'
	)
	AND (
		@P_employee_typ = -1
	OR	@P_employee_typ > 0 AND #M0070H.employee_typ = @P_employee_typ
	)
	AND (
		@P_position_cd = -1
	OR	@P_position_cd > 0 AND #M0070H.position_cd = @P_position_cd
	)
	AND (
		@P_job_cd = -1
	OR	@P_job_cd > 0 AND #M0070H.job_cd = @P_job_cd
	)
	AND (
		@P_belong_cd1 = '-1'
	OR	@P_belong_cd1 <> '-1' AND #M0070H.belong_cd_1 = @P_belong_cd1
	)
	AND (
		@P_belong_cd2 = '-1'
	OR	@P_belong_cd2 <> '-1' AND #M0070H.belong_cd_2 = @P_belong_cd2
	)
	AND (
		@P_belong_cd3 = '-1'
	OR	@P_belong_cd3 <> '-1' AND #M0070H.belong_cd_3 = @P_belong_cd3
	)
	AND (
		@P_belong_cd4 = '-1'
	OR	@P_belong_cd4 <> '-1' AND #M0070H.belong_cd_4 = @P_belong_cd4
	)
	AND (
		@P_belong_cd5 = '-1'
	OR	@P_belong_cd5 <> '-1' AND #M0070H.belong_cd_5 = @P_belong_cd5
	)
	AND (M0070.company_out_dt IS  NULL OR M0070.company_out_dt >=  @w_time)
	-- FILTER @P_group_cd
	IF @P_group_cd > 0
	BEGIN
		INSERT INTO #TABLE_EMPLOYEE_GROUP
		SELECT 
			ISNULL(F4110.employee_cd,'')		AS	employee_cd
		FROM F4110
		WHERE
			F4110.company_cd		=	@P_company_cd
		AND F4110.fiscal_year		=	@P_fiscal_year
		AND F4110.group_cd			=	@P_group_cd
		AND F4110.del_datetime IS NULL
		GROUP BY
			F4110.employee_cd
		-- FILTER BY #TABLE_EMPLOYEE_GROUP
		DELETE D FROM #TABLE_RESULT AS D
		LEFT OUTER JOIN #TABLE_EMPLOYEE_GROUP AS S ON (
			D.employee_cd	=	S.employee_cd
		)
		WHERE
			S.employee_cd IS NULL
	END
	-- FILTER @P_mygroup_cd
	IF @P_mygroup_cd > 0
	BEGIN
		INSERT INTO #TABLE_EMPLOYEE_MYGROUP
		SELECT 
			ISNULL(F4011.mygroup_member_cd,'')		AS	mygroup_member_cd
		FROM F4011
		LEFT OUTER JOIN #TABLE_EMPLOYEE_MYGROUP AS S ON (
			F4011.mygroup_member_cd		=	S.employee_cd
		)
		WHERE 
			F4011.company_cd		=	@P_company_cd
		AND F4011.employee_cd		=	@P_login_employee_cd
		AND F4011.mygroup_cd		=	@P_mygroup_cd
		AND F4011.del_datetime IS NULL
		AND S.employee_cd IS NULL
		GROUP BY
			F4011.mygroup_member_cd
		-- FILTER BY #TABLE_EMPLOYEE_MYGROUP
		DELETE D FROM #TABLE_RESULT AS D
		LEFT OUTER JOIN #TABLE_EMPLOYEE_MYGROUP AS S ON (
			D.employee_cd	=	S.employee_cd
		)
		WHERE
			S.employee_cd IS NULL
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	SET @w_totalRecord = (SELECT COUNT(1) FROM #TABLE_RESULT)
	SET @w_pageMax = CEILING(CAST(@w_totalRecord AS FLOAT) / @P_page_size)
	IF @w_pageMax = 0
	BEGIN
		SET @w_pageMax = 1
	END
	IF @P_page > @w_pageMax
	BEGIN
		SET @P_page = @w_pageMax
	END
	--[0]
	SELECT 
		ISNULL(#TABLE_RESULT.employee_cd,'')			AS	employee_cd
	,	ISNULL(#M0070H.employee_nm,'')					AS	employee_nm
	,	ISNULL(#M0070H.employee_typ_nm,'')				AS	employee_typ_nm
	,	ISNULL(#M0070H.belong_nm_1,'')					AS	organization_nm1
	,	ISNULL(#M0070H.belong_nm_2,'')					AS	organization_nm2
	,	ISNULL(#M0070H.belong_nm_3,'')					AS	organization_nm3
	,	ISNULL(#M0070H.belong_nm_4,'')					AS	organization_nm4
	,	ISNULL(#M0070H.belong_nm_5,'')					AS	organization_nm5
	,	ISNULL(#M0070H.job_nm,'')						AS	job_nm
	,	ISNULL(#M0070H.position_nm,'')					AS	position_nm
	,	ISNULL(#M0070H.grade_nm,'')						AS	grade_nm
	FROM #TABLE_RESULT
	LEFT OUTER JOIN #M0070H ON (
		@P_company_cd						=	#M0070H.company_cd
	AND #TABLE_RESULT.employee_cd			=	#M0070H.employee_cd
	)
	ORDER BY 
		RIGHT(SPACE(10)+#TABLE_RESULT.employee_cd,10)
	offset (@P_page-1) * @P_page_size ROWS
	FETCH NEXT @P_page_size ROWS only
	--[1]
	SELECT	
		@w_totalRecord						AS totalRecord
	,	@w_pageMax							AS pageMax
	,	@P_page								AS [page]
	,	@P_page_size						AS pagesize
	,	((@P_page - 1) * @P_page_size + 1)	AS offset
	-- drop
	DROP TABLE #M0070H
END
GO
