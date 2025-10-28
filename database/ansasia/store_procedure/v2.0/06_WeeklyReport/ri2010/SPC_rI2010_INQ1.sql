DROP PROCEDURE [SPC_rI2010_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_rI2010_INQ1 782,2023,'890',4,1,'890'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	FIND A REPORT FOR rI2010
--*  
--*  作成日/create date			:	2023/05/08						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2024/04/03	
--*　更新者/updater				:	viettd
--*　更新内容/update content		:	change row_number from report_no to times
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rI2010_INQ1]
	@P_company_cd			SMALLINT		=	0
,	@P_fiscal_year			SMALLINT		=	0
,	@P_employee_cd			NVARCHAR(10)	=	''
,	@P_report_kind			SMALLINT		=	0
,	@P_report_no			SMALLINT		=	0
,	@P_session_key			NVARCHAR(100)	=	''	-- SESSION KEY OF USER
,	@P_login_employee_cd	NVARCHAR(10)	=	''	-- LOGIN EMPLOYEE
AS
BEGIN
	--[0]
	DECLARE 
		@w_language				smallint		=	0	-- 1.JP 2.EN
	,	@w_deadline_date		date			=	NULL
	,	@w_report_total			int				=	0
	,	@w_report_index			int				=	0
	,	@w_report_no_index		int				=	0
	--
	,	@w_report_no_next_index	int				=	0	--	次回の報告書_INDEX(PAGING)
	,	@w_fiscal_year_next		smallint		=	0	--	次回の報告書(PAGING)
	,	@w_employee_cd_next		nvarchar(10)	=	''	--	次回の報告書(PAGING)
	,	@w_report_kind_next		smallint		=	0	--	次回の報告書(PAGING)
	,	@w_report_no_next		smallint		=	0	--	次回の報告書(PAGING)

	,	@w_report_no_prev_index	int				=	0	--	前回の報告書_INDEX(PAGING)
	,	@w_fiscal_year_prev		smallint		=	0	--	前回の報告書(PAGING)
	,	@w_employee_cd_prev		nvarchar(10)	=	''	--	前回の報告書(PAGING)
	,	@w_report_kind_prev		smallint		=	0	--	前回の報告書(PAGING)
	,	@w_report_no_prev		smallint		=	0	--	前回の報告書(PAGING)
	--
	,	@w_report_no_prev_1		int				=	0	--	前回の報告書
	,	@w_report_no_prev_2		int				=	0	--	前々回の報告書
	,	@w_report_no_prev_3		int				=	0	--	３回前の報告書
	--
	,	@w_login_user_is_viewer	tinyint			=	0	-- 1.viewer 2.shared 0.not viewer or shared
	--
	,	@w_company_attribute	smallint		=	0	-- 1.管理会社 2.ユーザー会社 3.グループ会社　--2023/07/25 add

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
	CREATE TABLE #F4200_NO (
		report_index		int		
	,	report_no			smallint	
	,	is_submited			tinyint
	)
	--
	CREATE TABLE #F4200_NO_PREV (
		id					int			identity(1,1)
	,	report_index		int		
	,	report_no			smallint	
	)
	--
	CREATE TABLE #LIST_REPORT_NO (
		id				int		identity(1,1)
	,	fiscal_year		smallint
	,	employee_cd		nvarchar(10)
	,	report_kind		smallint
	,	report_no		smallint
	)
	--	
	SELECT 
		@w_language =	ISNULL(S0010.[language],1)
	FROM S0010
	WHERE 
		S0010.company_cd	=	@P_company_cd
	AND S0010.employee_cd	=	@P_login_employee_cd
	AND S0010.del_datetime IS NULL

	--↓ 2023/07/25 add：GET company_attribute 
	SELECT 
		@w_company_attribute =	M0001.contract_company_attribute
	FROM M0001
	WHERE 
		M0001.company_cd	=	@P_company_cd
    --↑ 2023/07/25 add
	-- GET deadline_date of times
	SELECT 
		@w_deadline_date	=	F4100.deadline_date
	FROM F4110
	LEFT OUTER JOIN F4100 ON (
		F4110.company_cd		=	F4100.company_cd
	AND F4110.fiscal_year		=	F4100.fiscal_year
	AND F4110.group_cd			=	F4100.group_cd
	AND F4110.report_kind		=	F4100.report_kind
	AND F4110.times				=	F4100.detail_no
	)
	WHERE 
		F4110.company_cd		=	@P_company_cd
	AND F4110.fiscal_year		=	@P_fiscal_year
	AND F4110.employee_cd		=	@P_employee_cd
	AND F4110.report_kind		=	@P_report_kind
	AND F4110.report_no			=	@P_report_no
	AND F4110.del_datetime IS NULL
	-- INSERT #M0070H
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @w_deadline_date,'',@P_company_cd
	-- CHECK LOGIN USER IS VIEWER OF REPORT
	IF EXISTS (SELECT 1 FROM F4120 
						WHERE 
							company_cd			=	@P_company_cd
						AND fiscal_year			=	@P_fiscal_year
						AND employee_cd			=	@P_employee_cd
						AND report_kind			=	@P_report_kind
						AND report_no			=	@P_report_no
						AND viewer_employee_cd	=	@P_login_employee_cd
						AND F4120.del_datetime IS NULL
						)
	BEGIN
		SET @w_login_user_is_viewer = 1		-- LOGIN USER IS VIEWER OF REPORT
	END
	-- CHECK LOGIN USER IS SHARED OF REPORT 
	IF EXISTS (SELECT 1 FROM F4207 
						WHERE 
							company_cd				=	@P_company_cd
						AND fiscal_year				=	@P_fiscal_year
						AND employee_cd				=	@P_employee_cd
						AND report_kind				=	@P_report_kind
						AND report_no				=	@P_report_no
						AND sharewith_employee_cd	=	@P_login_employee_cd
						AND F4207.del_datetime IS NULL
						)
	BEGIN
		SET @w_login_user_is_viewer	= 2		-- LOGIN USER IS SHARED OF REPORT
	END
	-- INSERT #F4200_NO
	INSERT INTO #F4200_NO
	SELECT 
		--ROW_NUMBER() OVER(ORDER BY F4200.report_no)
		ROW_NUMBER() OVER(ORDER BY F4200.times)				-- edited by viettd 2024/04/03
	,	F4200.report_no
	,	CASE 
			WHEN F4201.submission_datetime IS NOT NULL
			THEN 1
			ELSE 0
		END
	FROM F4200
	LEFT OUTER JOIN F4201 ON (
		F4200.company_cd		=	F4201.company_cd
	AND F4200.fiscal_year		=	F4201.fiscal_year
	AND F4200.employee_cd		=	F4201.employee_cd
	AND F4200.report_kind		=	F4201.report_kind
	AND F4200.report_no			=	F4201.report_no
	AND F4201.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4120 ON (
		F4200.company_cd			=	F4120.company_cd
	AND F4200.fiscal_year			=	F4120.fiscal_year
	AND F4200.employee_cd			=	F4120.employee_cd
	AND F4200.report_kind			=	F4120.report_kind
	AND F4200.report_no				=	F4120.report_no
	AND @P_login_employee_cd		=	F4120.viewer_employee_cd
	AND F4120.del_datetime IS NULL
	)
	LEFT OUTER JOIN (
		SELECT 
			MAX(F4207.shareby_employee_cd)		AS	shareby_employee_cd
		,	F4207.company_cd					AS	company_cd	
		,	F4207.fiscal_year					AS	fiscal_year	
		,	F4207.employee_cd					AS	employee_cd	
		,	F4207.report_kind					AS	report_kind	
		,	F4207.report_no						AS	report_no		
		FROM F4207
		WHERE 
			F4207.company_cd				=	@P_company_cd
		AND F4207.fiscal_year				=	@P_fiscal_year
		AND F4207.employee_cd				=	@P_employee_cd
		AND F4207.report_kind				=	@P_report_kind
		AND F4207.report_no					=	@P_report_no
		AND F4207.sharewith_employee_cd		=	@P_login_employee_cd
		AND F4207.del_datetime IS NULL
		GROUP BY
			F4207.company_cd	
		,	F4207.fiscal_year	
		,	F4207.employee_cd	
		,	F4207.report_kind	
		,	F4207.report_no			
	) AS F4207_TMP ON (
		F4200.company_cd		=	F4207_TMP.company_cd
	AND F4200.fiscal_year		=	F4207_TMP.fiscal_year
	AND F4200.employee_cd		=	F4207_TMP.employee_cd
	AND F4200.report_kind		=	F4207_TMP.report_kind
	AND F4200.report_no			=	F4207_TMP.report_no
	)
	WHERE 
		F4200.company_cd			=	@P_company_cd
	AND F4200.fiscal_year			=	@P_fiscal_year
	AND F4200.employee_cd			=	@P_employee_cd
	AND F4200.report_kind			=	@P_report_kind
	AND F4200.del_datetime IS NULL
	AND (
		(@w_login_user_is_viewer = 0)
	OR	(@w_login_user_is_viewer = 1 AND F4200.status_cd = 6 AND F4120.company_cd IS NOT NULL)
	OR	(@w_login_user_is_viewer = 2 AND F4200.status_cd = 6 AND F4207_TMP.company_cd IS NOT NULL)
	)
	-- INSERT INTO #LIST_REPORT_NO
	INSERT INTO #LIST_REPORT_NO
	SELECT 
		WRK_WEEKLYREPORT_CACHE.fiscal_year
	,	WRK_WEEKLYREPORT_CACHE.employee_cd
	,	WRK_WEEKLYREPORT_CACHE.report_kind
	,	WRK_WEEKLYREPORT_CACHE.report_no
	FROM WRK_WEEKLYREPORT_CACHE
	WHERE 
		WRK_WEEKLYREPORT_CACHE.session_key = @P_session_key
	--[0] -- EMPLOYEE INFOMATION
	SELECT 
		ISNULL(M0070.employee_cd,'')				AS	employee_cd			--	社員コード
	,	ISNULL(M0070.employee_nm,'')				AS	employee_nm			--	社員名
	,	ISNULL(#M0070H.employee_typ_nm,'')			AS	employee_typ_nm
	,	ISNULL(#M0070H.job_nm,'')					AS	job_nm
	,	ISNULL(#M0070H.position_nm,'')				AS	position_nm
	--↓2023/07/25 fixed
	--,	ISNULL(#M0070H.grade_nm,'')					AS grade_nm
	,	CASE WHEN @w_company_attribute=3 THEN '' ELSE ISNULL(#M0070H.grade_nm,'') END AS grade_nm
	--↑2023/07/25 fixed
	,	ISNULL(#M0070H.belong_nm_1,'')				AS	belong_nm1				
	,	ISNULL(#M0070H.belong_nm_2,'')				AS	belong_nm2				
	,	ISNULL(#M0070H.belong_nm_3,'')				AS	belong_nm3				
	,	ISNULL(#M0070H.belong_nm_4,'')				AS	belong_nm4				
	,	ISNULL(#M0070H.belong_nm_5,'')				AS	belong_nm5		
	,	ISNULL(M0070_1.employee_nm,'')				AS	approver_employee_nm_1
	,	ISNULL(M0070_2.employee_nm,'')				AS	approver_employee_nm_2
	,	ISNULL(M0070_3.employee_nm,'')				AS	approver_employee_nm_3
	,	ISNULL(M0070_4.employee_nm,'')				AS	approver_employee_nm_4
	,	ISNULL(M0070.picture,'')					AS	picture
	FROM F4200
	LEFT OUTER JOIN M0070 ON (
		F4200.company_cd		=	M0070.company_cd
	AND F4200.employee_cd		=	M0070.employee_cd
	)
	LEFT OUTER JOIN #M0070H ON (
		F4200.company_cd		=	#M0070H.company_cd
	AND F4200.employee_cd		=	#M0070H.employee_cd
	)
	LEFT OUTER JOIN M0070 AS M0070_1 ON (
		F4200.company_cd				=	M0070_1.company_cd
	AND F4200.approver_employee_cd_1	=	M0070_1.employee_cd
	)
	LEFT OUTER JOIN M0070 AS M0070_2 ON (
		F4200.company_cd				=	M0070_2.company_cd
	AND F4200.approver_employee_cd_2	=	M0070_2.employee_cd
	)
	LEFT OUTER JOIN M0070 AS M0070_3 ON (
		F4200.company_cd				=	M0070_3.company_cd
	AND F4200.approver_employee_cd_3	=	M0070_3.employee_cd
	)
	LEFT OUTER JOIN M0070 AS M0070_4 ON (
		F4200.company_cd				=	M0070_4.company_cd
	AND F4200.approver_employee_cd_4	=	M0070_4.employee_cd
	)
	WHERE 
		F4200.company_cd			=	@P_company_cd
	AND F4200.fiscal_year			=	@P_fiscal_year
	AND F4200.employee_cd			=	@P_employee_cd
	AND F4200.report_kind			=	@P_report_kind
	AND F4200.report_no				=	@P_report_no
	AND F4200.del_datetime IS NULL
	--[1]
	-- GET CURRENT INDEX OF REPORT_NO IN DASHBOARD
	SELECT 
		@w_report_no_index = ISNULL(#LIST_REPORT_NO.id,0)
	FROM #LIST_REPORT_NO
	WHERE
		fiscal_year		=	@P_fiscal_year
	AND employee_cd		=	@P_employee_cd
	AND report_kind		=	@P_report_kind
	AND report_no		=	@P_report_no
	-- GET CURRENT INDEX OF REPORT_NO
	SELECT 
		@w_report_index	=	ISNULL(#F4200_NO.report_index,0)
	FROM #F4200_NO
	WHERE 
		#F4200_NO.report_no	=	@P_report_no
	-- GET NEXT OF REPORT_NO IN DASHBOARD
	SELECT 
		TOP 1
		@w_report_no_next			=	ISNULL(#LIST_REPORT_NO.report_no,0)		
	,	@w_report_no_next_index		=	ISNULL(#LIST_REPORT_NO.id,0)
	,	@w_fiscal_year_next			=	ISNULL(#LIST_REPORT_NO.fiscal_year,0)
	,	@w_employee_cd_next			=	ISNULL(#LIST_REPORT_NO.employee_cd,'')
	,	@w_report_kind_next			=	ISNULL(#LIST_REPORT_NO.report_kind,0)
	FROM #LIST_REPORT_NO
	WHERE 
		#LIST_REPORT_NO.id > @w_report_no_index
	ORDER BY
		#LIST_REPORT_NO.id ASC
	--  GET PREV OF REPORT_NO IN DASHBOARD
	SELECT 
		TOP 1
		@w_report_no_prev			=	ISNULL(#LIST_REPORT_NO.report_no,0)		
	,	@w_report_no_prev_index		=	ISNULL(#LIST_REPORT_NO.id,0)
	,	@w_fiscal_year_prev			=	ISNULL(#LIST_REPORT_NO.fiscal_year,0)
	,	@w_employee_cd_prev			=	ISNULL(#LIST_REPORT_NO.employee_cd,'')
	,	@w_report_kind_prev			=	ISNULL(#LIST_REPORT_NO.report_kind,0)
	FROM #LIST_REPORT_NO
	WHERE 
		#LIST_REPORT_NO.id < @w_report_no_index
	ORDER BY
		#LIST_REPORT_NO.id DESC
	--	GET 
	--	前回の報告書	
	--	前々回の報告書
	--	３回前の報告書
	INSERT INTO #F4200_NO_PREV
	SELECT 
		TOP 3
		#F4200_NO.report_index
	,	#F4200_NO.report_no
	FROM #F4200_NO
	WHERE 
		#F4200_NO.report_index	<	@w_report_index
	AND #F4200_NO.is_submited = 1
	ORDER BY
		#F4200_NO.report_index DESC
	-- GET @w_report_no_prev
	SELECT 
		@w_report_no_prev_1	=	ISNULL(#F4200_NO_PREV.report_no,0)		
	FROM #F4200_NO_PREV
	WHERE #F4200_NO_PREV.id	= 1
	-- GET @w_report_no_prev
	SELECT 
		@w_report_no_prev_2	=	ISNULL(#F4200_NO_PREV.report_no,0)		
	FROM #F4200_NO_PREV
	WHERE #F4200_NO_PREV.id	= 2
	-- GET @w_report_no_prev
	SELECT 
		@w_report_no_prev_3	=	ISNULL(#F4200_NO_PREV.report_no,0)		
	FROM #F4200_NO_PREV
	WHERE #F4200_NO_PREV.id	= 3
	-- GET REPORT TOTAL
	SELECT 
		@w_report_total	=	COUNT(#LIST_REPORT_NO.id)
	FROM #LIST_REPORT_NO
	--
	SELECT 
		@P_report_no			AS	report_no_current
	,	@w_report_no_index		AS	report_index
	,	@w_report_total			AS	report_total
	,	@w_fiscal_year_next		AS	fiscal_year_next
	,	@w_employee_cd_next		AS	employee_cd_next
	,	@w_report_kind_next		AS	report_kind_next
	,	@w_report_no_next		AS	report_no_next
	--
	,	@w_fiscal_year_prev		AS	fiscal_year_prev
	,	@w_employee_cd_prev		AS	employee_cd_prev
	,	@w_report_kind_prev		AS	report_kind_prev
	,	@w_report_no_prev		AS	report_no_prev
	--
	,	@w_report_no_prev_1		AS	report_no_prev_1
	,	@w_report_no_prev_2		AS	report_no_prev_2
	,	@w_report_no_prev_3		AS	report_no_prev_3
	-- DROP TABLE
	DROP TABLE #F4200_NO
	DROP TABLE #M0070H
	DROP TABLE #F4200_NO_PREV
	DROP TABLE #LIST_REPORT_NO
END
GO
