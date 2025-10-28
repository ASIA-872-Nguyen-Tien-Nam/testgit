DROP PROCEDURE [SPC_1ON1_GET_SCHEDULE_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ [SPC_DASHBOARD_INQ1]
-- EXEC SPC_1ON1_GET_SCHEDULE_FND1 2020,1,740,'721',3
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	1ON1 GET LIST SCHEDULE OF COACH/MEMBER
--*  
--*  作成日/create date			:	2020/11/30				
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2022/01/13
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	CR add permission of coach when [1on1_beginning_date] = NULL
--*   					
--****************************************************************************************
CREATE PROCEDURE [SPC_1ON1_GET_SCHEDULE_FND1]
	@P_company_cd				smallint		=	0	-- company_cd
,	@P_fiscal_year				smallint		=	0	-- 年度
,	@P_employee_cd				nvarchar(10)	=	''	-- login employee_cd
,	@P_1on1_authority_typ		smallint		=	0	-- login authority_typ
,	@P_from_coach				smallint		=	0	-- from coach
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_date							date			=	GETDATE()
	,	@w_times_max					int				=	0
	,	@w_times_str					nvarchar(max)	=	''
	,	@w_i							int				=	1
	,	@w_sql_str						nvarchar(max)	=	''
	,	@w_page_max						int				=	0
	,	@w_beginning_date				date			=	NULL
	-- create temp table
	--
	IF object_id('tempdb..#F2010_TABLE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F2010_TABLE
    END	
	--
	CREATE TABLE #F2010_TABLE (
		id					int	identity(1,1)
	,	company_cd			smallint
	,	fiscal_year			smallint
	,	employee_cd			nvarchar(10)
	,	coach_cd			nvarchar(10)
	,	times				smallint
	,	[1on1_group_cd]		smallint
	)

	--add vietdt 2022/01/13 get @w_beginning_date 
	SELECT 
		@w_beginning_date = M9100.[1on1_beginning_date] 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	-- COACH 
	IF @P_from_coach = 1 AND @P_1on1_authority_typ IN(2,3,4,5)
	BEGIN
		INSERT INTO #F2010_TABLE
		SELECT 
			F2010.company_cd
		,	F2010.fiscal_year
		,	F2010.employee_cd
		,	F2001.coach_cd
		,	F2010.times
		,	ISNULL(F2000.[1on1_group_cd],0)	AS	[group_cd_1on1]
		FROM F2010 WITH(NOLOCK)
		LEFT OUTER JOIN F2001 WITH(NOLOCK) ON (
			F2010.company_cd			=	F2001.company_cd
		AND F2010.fiscal_year			=	F2001.fiscal_year
		AND F2010.employee_cd			=	F2001.employee_cd
		AND F2010.times					=	F2001.times
		AND F2001.del_datetime IS NULL
		)
		LEFT OUTER JOIN F2000 WITH(NOLOCK) ON (
			F2001.company_cd			=	F2000.company_cd
		AND F2001.fiscal_year			=	F2000.fiscal_year
		AND F2001.employee_cd			=	F2000.employee_cd
		AND F2000.del_datetime IS NULL
		)
		LEFT OUTER JOIN F2200 WITH(NOLOCK) ON (
			F2010.company_cd			=	F2200.company_cd
		AND F2010.fiscal_year			=	F2200.fiscal_year
		AND F2010.employee_cd			=	F2200.employee_cd
		AND F2010.times					=	F2200.times
		AND F2001.interview_cd			=	F2200.interview_cd
		AND F2001.adaption_date			=	F2200.adaption_date
		AND F2200.del_datetime IS NULL
		)
		WHERE 
			F2010.company_cd		=	@P_company_cd
		AND F2010.fiscal_year		=	@P_fiscal_year
		AND F2010.del_datetime IS NULL
		AND F2001.coach_cd			=	@P_employee_cd
		AND	F2200.fin_datetime_coach	IS NULL
		--add vietdt 2022/01/13
		AND (
				(@P_1on1_authority_typ = 2 AND @w_beginning_date IS NOT NULL)
			OR	(@P_1on1_authority_typ > 2)
			)
		--
		GOTO COMPLETED
	END
	-- MEMBER 
	IF @P_from_coach = 0 
	BEGIN
		INSERT INTO #F2010_TABLE
		SELECT 
			F2010.company_cd
		,	F2010.fiscal_year
		,	F2010.employee_cd
		,	F2001.coach_cd
		,	F2010.times
		,	ISNULL(F2000.[1on1_group_cd],0)	AS	[group_cd_1on1]
		FROM F2010 WITH(NOLOCK)
		LEFT OUTER JOIN F2001 WITH(NOLOCK) ON (
			F2010.company_cd			=	F2001.company_cd
		AND F2010.fiscal_year			=	F2001.fiscal_year
		AND F2010.employee_cd			=	F2001.employee_cd
		AND F2010.times					=	F2001.times
		AND F2001.del_datetime IS NULL
		)
		LEFT OUTER JOIN F2000 WITH(NOLOCK) ON (
			F2001.company_cd			=	F2000.company_cd
		AND F2001.fiscal_year			=	F2000.fiscal_year
		AND F2001.employee_cd			=	F2000.employee_cd
		AND F2000.del_datetime IS NULL
		)
		LEFT OUTER JOIN F2200 WITH(NOLOCK) ON (
			F2010.company_cd			=	F2200.company_cd
		AND F2010.fiscal_year			=	F2200.fiscal_year
		AND F2010.employee_cd			=	F2200.employee_cd
		AND F2010.times					=	F2200.times
		AND F2001.interview_cd			=	F2200.interview_cd
		AND F2001.adaption_date			=	F2200.adaption_date
		AND F2200.del_datetime IS NULL
		)
		WHERE 
			F2010.company_cd		=	@P_company_cd
		AND F2010.fiscal_year		=	@P_fiscal_year
		AND F2010.del_datetime IS NULL
		AND F2010.employee_cd		=	@P_employee_cd
		AND	F2200.fin_datetime_member IS NULL
		GOTO COMPLETED
	END
COMPLETED:
	--[0]
	SELECT 
		#F2010_TABLE.company_cd			AS	company_cd
	,	#F2010_TABLE.fiscal_year		AS	fiscal_year
	,	#F2010_TABLE.employee_cd		AS	employee_cd
	,	ISNULL(M0070_M.employee_nm,'')	AS	employee_nm
	,	#F2010_TABLE.coach_cd			AS	coach_cd
	,	ISNULL(M0070_C.employee_nm,'')	AS	coach_nm
	,	#F2010_TABLE.times				AS	times
	,	FORMAT(F2010.[1on1_schedule_date],'yyyy/MM/dd')		AS	[schedule_date_1on1]
	,	ISNULL(F2010.[time],'')			AS	[time]
	,	ISNULL(F2010.title,'')			AS	title
	,	ISNULL(F2010.place,'')			AS	place
	,	@P_from_coach					AS	is_coach
	,	#F2010_TABLE.[1on1_group_cd]	AS	[group_cd_1on1]
	FROM #F2010_TABLE
	LEFT OUTER JOIN F2010 WITH(NOLOCK) ON(
		#F2010_TABLE.company_cd		=	F2010.company_cd
	AND #F2010_TABLE.fiscal_year	=	F2010.fiscal_year
	AND #F2010_TABLE.employee_cd	=	F2010.employee_cd
	AND #F2010_TABLE.times			=	F2010.times
	)
	LEFT OUTER JOIN M0070 AS M0070_M WITH(NOLOCK) ON(
		#F2010_TABLE.company_cd		=	M0070_M.company_cd
	AND #F2010_TABLE.employee_cd	=	M0070_M.employee_cd
	)
	LEFT OUTER JOIN M0070 AS M0070_C WITH(NOLOCK) ON(
		#F2010_TABLE.company_cd		=	M0070_C.company_cd
	AND #F2010_TABLE.coach_cd		=	M0070_C.employee_cd
	)
	ORDER BY 
		F2010.[1on1_schedule_date] ASC
END	
GO
