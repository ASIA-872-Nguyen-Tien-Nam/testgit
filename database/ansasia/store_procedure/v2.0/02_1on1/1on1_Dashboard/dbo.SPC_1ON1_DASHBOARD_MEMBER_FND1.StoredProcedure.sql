DROP PROCEDURE [SPC_1ON1_DASHBOARD_MEMBER_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ [SPC_DASHBOARD_INQ1]
-- EXEC SPC_1ON1_DASHBOARD_COACH_FND1 2020,1,740,'721',3
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	1ON1 DASHBOARD MEMBER LIST TIMES
--*  
--*  作成日/create date			:	2020/11/30				
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2021/10/06
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	fix when F2300.questionnaire_cd = -1
--*   					
--*  更新日/update date			:	2021/10/07
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	add show item F2200.title
--*  
--*  更新日/update date			:	2022/01/13
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	CR add condition F2200.fullfillment_type,next_action,coach_comment1
--*   					
--*  更新日/update date			:	2022/08/18
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	update ver 1.9	
--* 
--****************************************************************************************
CREATE PROCEDURE [SPC_1ON1_DASHBOARD_MEMBER_FND1]
	@P_fiscal_year				smallint		=	0	-- 年度
,	@P_company_cd				smallint		=	0	-- company_cd
,	@P_employee_cd				nvarchar(10)	=	''	-- login employee_cd
,	@P_1on1_authority_typ		smallint		=	0	-- login authority_typ
,	@P_language					NVARCHAR(2)		= 'jp'
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
	--
	-- create temp table
	--
	IF object_id('tempdb..#F2001_TABLE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F2001_TABLE
    END
	--
	IF object_id('tempdb..#F2310_TABLE_MIN', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F2310_TABLE_MIN
    END
	
	CREATE TABLE #F2001_TABLE(
		id						int			identity(1,1)
	,	company_cd				smallint
	,	fiscal_year				smallint
	,	employee_cd				nvarchar(20)
	,	[1on1_group_cd]			smallint
	,	times					smallint
	,	coach_cd				nvarchar(20)
	,	interview_cd			smallint
	,	adaption_date			date
	,	is_questionnaire_cd		tinyint			--	F2310.questionnaire_cd is exists ?
	)

	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--INSERT DATA TO TEMP TABLE
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--
	INSERT INTO #F2001_TABLE
	SELECT 
		ISNULL(F2001.company_cd,0)
	,	ISNULL(F2001.fiscal_year,0)
	,	ISNULL(F2001.employee_cd,'')
	,	ISNULL(F2000.[1on1_group_cd],0)
	,	ISNULL(F2001.times,0)
	,	ISNULL(F2001.coach_cd,'')
	,	ISNULL(F2001.interview_cd,0)
	,	F2001.adaption_date
	,	0						AS	is_questionnaire_cd	--	is_questionnaire_cd
	FROM F2001 WITH(NOLOCK)
	LEFT OUTER JOIN F2000 WITH(NOLOCK) ON (
		F2001.company_cd		=	F2000.company_cd
	AND F2001.fiscal_year		=	F2000.fiscal_year
	AND F2001.employee_cd		=	F2000.employee_cd
	AND F2000.del_datetime IS NULL
	)
	WHERE
		F2001.company_cd			=	@P_company_cd
	AND F2001.fiscal_year			=	@P_fiscal_year
	AND F2001.employee_cd			=	@P_employee_cd
	AND F2001.del_datetime IS NULL
	--[0]
	SELECT 
		#F2001_TABLE.company_cd			
	,	#F2001_TABLE.fiscal_year			
	,	#F2001_TABLE.employee_cd			
	,	#F2001_TABLE.[1on1_group_cd]		AS	w_1on1_group_cd
	,	#F2001_TABLE.times				
	,	#F2001_TABLE.coach_cd	
	,	ISNULL(M0070.employee_nm,'')		AS	coach_cd_nm		
	,	#F2001_TABLE.interview_cd AS interview_cd
	,	FORMAT(#F2001_TABLE.adaption_date,'yyyy/MM/dd') AS adaption_date	
	,	CASE 
			WHEN	F2200.submit_datetime_member IS NOT NULL 
			THEN	ISNULL(F2200.fullfillment_type,0)
			ELSE	0
		END									AS	fullfillment_type
	,	CASE 
			WHEN	F2200.fin_datetime_member IS NOT NULL 
			THEN	ISNULL(F2200.next_action,'')
			ELSE	''
		END									AS	next_action
	,	ISNULL(F2200.member_comment,'')		AS	member_comment
	,	CASE 
			WHEN	F2200.fin_datetime_coach IS NOT NULL 
			THEN	ISNULL(F2200.coach_comment1,'')	
			ELSE	''
		END									AS	coach_comment1
	,	FORMAT(ISNULL(F2200.interview_date,F2010.[1on1_schedule_date]),'yyyy/MM/dd')				AS	interview_date
	,	CASE 
			WHEN  F2301.send_datetime IS NOT NULL  
			THEN 1 -- disable button pencil
			WHEN(	F2301.company_cd IS NOT NULL 
				AND F2301.send_datetime IS  NULL 
				AND F2300.questionnaire_cd IS NOT NULL 
				AND F2200.company_cd IS NOT NULL
				AND	ISNULL(F2200.fin_user_member,'') <> ''
				)
			THEN 2 -- enable button pencil
		ELSE 0 -- hidden
		END AS is_questionnaire_cd
	,	F2300.questionnaire_cd
	-- add by viettd 2021/10/07
	,	CASE 
			WHEN ISNULL(M2620.[1on1_title],'') <> '' 
			THEN M2620.[1on1_title]
			WHEN @P_language = 'en'
			THEN 'Times '+ CAST(ISNULL(#F2001_TABLE.times,0) AS nvarchar(5))
			ELSE CAST(ISNULL(#F2001_TABLE.times,0) AS nvarchar(5)) + '回目'
		END									AS	title
	FROM #F2001_TABLE
	LEFT OUTER JOIN M0070 WITH(NOLOCK) ON (
		#F2001_TABLE.company_cd		=	M0070.company_cd
	AND #F2001_TABLE.coach_cd		=	M0070.employee_cd
	)
	LEFT OUTER JOIN F2200 WITH(NOLOCK) ON (
		#F2001_TABLE.company_cd			=	F2200.company_cd
	AND #F2001_TABLE.fiscal_year		=	F2200.fiscal_year
	AND #F2001_TABLE.employee_cd		=	F2200.employee_cd
	AND #F2001_TABLE.times				=	F2200.times
	AND #F2001_TABLE.interview_cd		=	F2200.interview_cd
	AND #F2001_TABLE.adaption_date		=	F2200.adaption_date
	AND F2200.del_datetime IS NULL
	)
	LEFT JOIN F2300 ON(
		#F2001_TABLE.company_cd			=	F2300.company_cd
	AND #F2001_TABLE.fiscal_year		=	F2300.fiscal_year
	AND #F2001_TABLE.[1on1_group_cd]	=	F2300.[1on1_group_cd]
	AND #F2001_TABLE.times				=	F2300.times
	AND F2300.submit					=	2	-- member
	AND F2300.questionnaire_cd			>	0	-- add by viettd 2021/10/06
	AND F2300.del_datetime IS NULL
	)
	LEFT JOIN F2301  ON(
		#F2001_TABLE.company_cd			=	F2301.company_cd
	AND #F2001_TABLE.fiscal_year		=	F2301.fiscal_year
	AND #F2001_TABLE.[1on1_group_cd]	=	F2301.[1on1_group_cd]
	AND #F2001_TABLE.times				=	F2301.times
	AND 2								=	F2301.submit
	AND @P_employee_cd					=	F2301.employee_cd
	AND F2301.del_datetime IS NULL
	)
	LEFT JOIN F2010 ON(
		#F2001_TABLE.company_cd		=	F2010.company_cd
	AND #F2001_TABLE.fiscal_year	=	F2010.fiscal_year
	AND #F2001_TABLE.employee_cd	=   F2010.employee_cd
	AND #F2001_TABLE.times			=	F2010.times
	AND F2010.del_datetime IS  NULL
	)
	-- add by viettd 2021/10/07
	LEFT JOIN M2620 ON(
		#F2001_TABLE.company_cd			=	M2620.company_cd
	AND #F2001_TABLE.fiscal_year		=	M2620.fiscal_year
	AND #F2001_TABLE.[1on1_group_cd]	=   M2620.[1on1_group_cd]
	AND #F2001_TABLE.times				=	M2620.times
	AND M2620.del_datetime IS  NULL
	)
	-- end add by viettd 2021/10/07
END	
GO