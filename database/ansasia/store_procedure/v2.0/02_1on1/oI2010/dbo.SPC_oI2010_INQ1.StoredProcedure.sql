DROP PROCEDURE [SPC_oI2010_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ oI2010
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	[SPC_oI2010_INQ1]_GET DATA
--*  
--* 作成日/create date			:	2020/12/03											
--*	作成者/creater				:	DatNT						
--*   					
--*	更新日/update date			:	2021/04/09						
--*	更新者/updater				:	viettd　								     	 
--*	更新内容/update content		:	add library L0010.23~26
--*   	
--*	更新日/update date			:	2021/04/13						
--*	更新者/updater				:	vietdt　								     	 
--*	更新内容/update content		:	add conditions apply report
--*  
--*	更新日/update date			:	2021/04/16						
--*	更新者/updater				:	vietdt　								     	 
--*	更新内容/update content		:	add conditions show/hidden question
--*  
--*	更新日/update date			:	2021/05/14						
--*	更新者/updater				:	vietdt　								     	 
--*	更新内容/update content		:	CR add search data time,place
--*
--*	更新日/update date			:	2021/12/03						
--*	更新者/updater				:	vietdt　								     	 
--*	更新内容/update content		:	add search data in table F2200_temp,F2201_temp
--*
--*  更新日/update date			:	2022/01/13
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	CR add condition answer,fullfillment_type,next_action,coach_comment1,...
--*
--*  更新日/update date			:	2022/08/19
--*　更新者/updater				:	vietdt
--*　更新内容/update content		:	CR V1.9
--****************************************************************************************

CREATE PROCEDURE [SPC_oI2010_INQ1]
	-- Add the parameters for the stored procedure here	
	@P_language					nvarchar(10)	= 'jp'		
,	@P_company_cd				SMALLINT		= 0
,	@P_fiscal_year				SMALLINT		= 0
,	@P_member_cd				NVARCHAR(10)	= ''
,	@P_login_user				NVARCHAR(50)	= ''
,	@P_times					INT				= 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@ERR_TBL				ERRTABLE
	,	@w_time					DATETIME2		=	SYSDATETIME()
	,	@group_cd				SMALLINT		=	-1	
	,	@mark_type				SMALLINT		=	0
	,	@beginning_date			DATE			=	NULL
	,	@year_end				DATE			=	NULL	
	,	@year_date_from			DATE			=	NULL	
	,	@year_end_30day			DATE			=	NULL		
	,	@w_1on1_authority_typ	SMALLINT		=	0					--add by vietdt 2021/12/03
	,	@w_login_employee_cd	NVARCHAR(10)	=	''					--add by vietdt 2021/12/03
	
	--
	CREATE TABLE #MODE(
		fiscal_year			INT
	,	employee_cd			NVARCHAR(10)
	,	times				INT
	,	coach_cd			NVARCHAR(10)
	,	interview_cd		INT
	,	adaption_date		DATE
	,	screen_mode			INT   --1*:member screen [11: first time / 12 save before / 13:save after]
								  --2*:coach screen [21: first time / 22 save before / 23:save after]
	,	permission			SMALLINT	
	,	coach_comment2_typ	SMALLINT-- 0. not view,1. view
	)
	--add by vietdt 2021/04/16 	
	CREATE TABLE #DATA(
		title					NVARCHAR(100)
	,	times					SMALLINT
	,	interview_cd			SMALLINT
	,	interview_nm			NVARCHAR(50)
	,	adaption_date			DATE
	,	member_cd				NVARCHAR(10)
	,	coach_cd				NVARCHAR(10)
	,	oneonone_schedule_date	NVARCHAR(20)
	,	coach_nm				NVARCHAR(200)
	,	member_nm				NVARCHAR(200)
	,	fullfillment_type		SMALLINT
	,	interview_date			DATETIME
	,	free_question			NVARCHAR(500)
	,	member_comment			NVARCHAR(400)	
	,	coach_comment1			NVARCHAR(400)
	,	next_action				NVARCHAR(400)
	,	coach_comment2			NVARCHAR(400)
	,	target1					NVARCHAR(1000)
	,	target2					NVARCHAR(1000)
	,	target3					NVARCHAR(1000)
	,	comment					NVARCHAR(400)
	,	remark1					NVARCHAR(50)
	,	remark_name				NVARCHAR(10)
	,	screen_mode				INT
	,	mark_cd					SMALLINT
	,	time					NVARCHAR(20)	--add by vietdt 2021/05/14
	,	place					NVARCHAR(100)	--add by vietdt 2021/05/14
	)
	--add by vietdt 2021/04/16 
	CREATE TABLE #M2100(
		company_cd			SMALLINT
	,	fiscal_year			SMALLINT
	,	employee_cd			NVARCHAR(10)
	,	target1				NVARCHAR(1000)	
	,	target2				NVARCHAR(1000)
	,	target3				NVARCHAR(1000)	
	,	comment				NVARCHAR(400)	
	,	target1_nm			NVARCHAR(50)
	,	target1_use_typ		TINYINT
	,	target2_nm			NVARCHAR(50)
	,	target2_use_typ		TINYINT
	,	target3_nm			NVARCHAR(50)
	,	target3_use_typ		TINYINT
	,	comment_nm			NVARCHAR(50)
	,	comment_use_typ		TINYINT
	)
	--
	SELECT	
		--@beginning_date		=	M0100.beginning_date
		@beginning_date		=	M9100.[1on1_beginning_date]
	FROM M9100
	WHERE
		M9100.company_cd			=	@P_company_cd
	AND M9100.del_datetime IS NULL
	IF @beginning_date IS NOT NULL
	BEGIN
		SET @year_date_from		= CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		SET @year_end			= DATEADD(DD,-1,DATEADD(YYYY,1,@year_date_from))
	END
	ELSE
	BEGIN 
		SET @year_end			=	CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/12/31') AS DATE)
	END
	-- get @mark_type (1.天気 | 2.表情 | 3.表情2 | 4.表情3 | 5.文字)
	SET @mark_type = (SELECT ISNULL(mark_type,1) FROM M2120 WHERE company_cd = @P_company_cd AND del_datetime IS NULL)
	IF @mark_type IS NULL 
	BEGIN
		SET @mark_type = 1 -- 天気
	END
	-- GET GROUP_CD
	SELECT 
		@group_cd= [1on1_group_cd]
	FROM F2000	 
	WHERE 
		company_cd	= @P_company_cd 
	AND fiscal_year	= @P_fiscal_year 
	AND	employee_cd	= @P_member_cd
	AND del_datetime IS NULL
	-- insert  #MODE
	INSERT INTO #MODE
	EXEC [dbo].SPC_oI2010_CHK1 @P_company_cd,@P_fiscal_year,@P_member_cd,@P_login_user,@P_times
	--add by vietdt 2021/12/03
	SELECT 
		@w_1on1_authority_typ	=	ISNULL(S0010.[1on1_authority_typ],0)	
	,	@w_login_employee_cd	=	ISNULL(S0010.employee_cd,'')
	FROM S0010
	WHERE 
		S0010.company_cd	= @P_company_cd 
	AND S0010.user_id		= @P_login_user
	AND S0010.del_datetime IS NULL

	--INSERT #DATA --add by vietdt 2021/04/16 
	INSERT INTO #DATA
	SELECT
		CASE
			WHEN	@P_language = 'en'
			THEN	IIF(ISNULL(M2620.[1on1_title],'') = '','Times '+CAST(M2620.times AS NVARCHAR(10)),M2620.[1on1_title])	--add by vietdt	2022/08/19
			ELSE	IIF(ISNULL(M2620.[1on1_title],'') = '',CAST(M2620.times AS NVARCHAR(10))+'回目',M2620.[1on1_title])
		END				  AS title
	,	M2620.times
	,	F2001.interview_cd
	,	M2200.interview_nm
	,	F2001.adaption_date
	,	F2001.employee_cd AS member_cd
	,	F2001.coach_cd
	-- edit by vietdt 2021/12/03
	,	CASE 
			WHEN F2200_temp.company_cd IS NOT NULL AND #MODE.screen_mode = 11
			THEN FORMAT(ISNULL(F2200_temp.interview_date,F2010.[1on1_schedule_date]),'yyyy/MM/dd')	
			ELSE FORMAT(ISNULL(F2200.interview_date,F2010.[1on1_schedule_date]),'yyyy/MM/dd')
		END			AS oneonone_schedule_date
	-- edit by vietdt 2021/12/03
	,	#COACH.employee_nm AS coach_nm
	,	#MEMBER.employee_nm AS member_nm
	-- edit by vietdt 2021/12/03
	,	CASE 
			WHEN F2200_temp.company_cd IS NOT NULL	AND #MODE.screen_mode = 11
			THEN F2200_temp.fullfillment_type	
			ELSE F2200.fullfillment_type
		END
	,	CASE 
			WHEN F2200_temp.company_cd IS NOT NULL AND #MODE.screen_mode = 11
			THEN F2200_temp.interview_date			
			ELSE F2200.interview_date
		END
	,	CASE 
			WHEN F2200_temp.company_cd IS NOT NULL AND #MODE.screen_mode = 11
			THEN F2200_temp.free_question			
			WHEN F2001.coach_cd = @w_login_employee_cd AND F2200.submit_datetime_member IS NULL	--add vietdt 2022/01/13
			THEN NULL
			ELSE F2200.free_question
		END
	,	CASE 
			WHEN F2200_temp.company_cd IS NOT NULL AND (#MODE.screen_mode = 12 OR (@w_1on1_authority_typ IN (4,5) AND F2200.fin_datetime_member IS NULL)) AND F2200.fin_datetime_coach IS NULL
			THEN F2200_temp.member_comment			
			WHEN F2001.coach_cd = @w_login_employee_cd AND F2200.fin_datetime_member IS NULL AND F2200.fin_datetime_coach IS NULL	--add vietdt 2022/01/13
			THEN ''
			ELSE F2200.member_comment
		END
	,	CASE 
			WHEN F2200_temp.company_cd IS NOT NULL AND (#MODE.screen_mode = 22 OR (@w_1on1_authority_typ IN (4,5) AND F2200.fin_datetime_coach IS NULL))
			THEN F2200_temp.coach_comment1	
			WHEN F2001.employee_cd = @w_login_employee_cd AND F2200.fin_datetime_coach IS NULL 	--add vietdt 2022/01/13
			THEN ''
			ELSE F2200.coach_comment1
		END
	,	CASE 
			WHEN F2200_temp.company_cd IS NOT NULL AND (#MODE.screen_mode = 12 OR (@w_1on1_authority_typ IN (4,5) AND F2200.fin_datetime_member IS NULL))  AND F2200.fin_datetime_coach IS NULL
			THEN F2200_temp.next_action			
			WHEN F2001.coach_cd = @w_login_employee_cd AND F2200.fin_datetime_member IS NULL AND F2200.fin_datetime_coach IS NULL	--add vietdt 2022/01/13
			THEN ''
			ELSE F2200.next_action
		END
	,	CASE 
			WHEN F2200_temp.company_cd IS NOT NULL AND (#MODE.screen_mode = 22 OR (@w_1on1_authority_typ IN (4,5) AND F2200.fin_datetime_coach IS NULL))
			THEN F2200_temp.coach_comment2	
			ELSE F2200.coach_comment2
		END
	-- edit by vietdt 2021/12/03
	,	F2100.target1		
	,	F2100.target2		
	,	F2100.target3		
	,	F2100.comment
	-- edit by vietdt 2021/12/03
	,	CASE 
			WHEN F2200_temp.company_cd IS NOT NULL AND #MODE.screen_mode = 11
			THEN L0010_temp.remark1			
			ELSE L0010.remark1
		END
	-- edit by vietdt 2021/12/03
	,	M2120.[name] AS remark_name
	,	#MODE.screen_mode AS screen_mode
	-- edit by vietdt 2021/12/03
	,	CASE  
			WHEN F2200_temp.company_cd IS NOT NULL AND #MODE.screen_mode = 11
			THEN M2121_temp.mark_cd			
			ELSE M2121.mark_cd
		END
	-- edit by vietdt 2021/12/03
	,	ISNULL(F2010.time,'')			--add by vietdt 2021/05/14
	,	ISNULL(F2010.place,'')			--add by vietdt 2021/05/14
	FROM M2620
	LEFT JOIN F2000 ON (
		M2620.company_cd		= F2000.company_cd
	AND M2620.fiscal_year		= F2000.fiscal_year
	AND @P_member_cd			= F2000.employee_cd
	AND F2000.del_datetime IS NULL
	)
	LEFT JOIN F2001 ON (
		M2620.company_cd		= F2001.company_cd
	AND M2620.fiscal_year		= F2001.fiscal_year
	AND F2000.employee_cd		= F2001.employee_cd
	AND M2620.times				= F2001.times 
	AND F2001.del_datetime IS NULL
	)
	LEFT JOIN F2010 ON(
		F2001.company_cd	= F2010.company_cd	
	AND	F2001.fiscal_year	= F2010.fiscal_year	
	AND	F2001.employee_cd	= F2010.employee_cd	
	AND	F2001.times			= F2010.times		
	AND F2010.del_datetime IS NULL
	)
	LEFT JOIN M2200 ON (
		M2620.company_cd		= M2200.company_cd
	AND F2001.interview_cd		= M2200.interview_cd
	AND F2001.adaption_date		= M2200.adaption_date
	AND M2200.del_datetime IS NULL
	)
	LEFT JOIN M0070 AS #COACH ON(
		M2620.company_cd		= #COACH.company_cd
	AND F2001.coach_cd			= #COACH.employee_cd
	AND #COACH.del_datetime IS NULL
	)
	LEFT JOIN M0070 AS #MEMBER ON(
		M2620.company_cd			= #MEMBER.company_cd
	AND F2001.employee_cd			= #MEMBER.employee_cd
	AND #MEMBER.del_datetime IS NULL
	)
	LEFT JOIN F2100 ON(
		M2620.company_cd		= F2100.company_cd
	AND M2620.fiscal_year		= F2100.fiscal_year
	AND F2001.employee_cd		= F2100.employee_cd
	AND F2100.del_datetime IS NULL
	)
	LEFT JOIN F2200 ON (
		M2620.company_cd		= F2200.company_cd
	AND M2620.fiscal_year		= F2200.fiscal_year
	AND F2001.employee_cd		= F2200.employee_cd
	AND F2001.times				= F2200.times
	AND F2001.interview_cd		= F2200.interview_cd
	AND F2001.adaption_date		= F2200.adaption_date
	AND F2200.del_datetime IS NULL
	)
	--add by vietdt 2021/12/03
	LEFT JOIN F2200_temp ON (
		M2620.company_cd		= F2200_temp.company_cd
	AND M2620.fiscal_year		= F2200_temp.fiscal_year
	AND F2001.employee_cd		= F2200_temp.employee_cd
	AND F2001.times				= F2200_temp.times
	AND F2001.interview_cd		= F2200_temp.interview_cd
	AND F2001.adaption_date		= F2200_temp.adaption_date
	AND @P_login_user			= F2200_temp.input_user
	AND F2200_temp.del_datetime IS NULL
	)
	--add by vietdt 2021/12/03
	LEFT JOIN M2121 ON (
		M2620.company_cd				= M2121.company_cd
	AND @mark_type						= M2121.mark_typ
	AND (
		F2200.fullfillment_type			= M2121.mark_cd			-- lay theo fullfillment_type 
	OR	( IIF(ISNULL(F2200.fullfillment_type,0) = 0,0,1) = 0	-- 0 : chua co data fullfillment_type / 1 da co
			AND 0 = M2121.item_no -- lay mac dinh
		)
	)
		AND M2121.del_datetime IS NULL
	)
	--add by vietdt 2021/12/03
	LEFT JOIN M2121 AS M2121_temp ON (
		M2620.company_cd				= M2121_temp.company_cd
	AND @mark_type						= M2121_temp.mark_typ
	AND (
		F2200_temp.fullfillment_type	= M2121_temp.mark_cd			-- lay theo fullfillment_type 
	OR	( IIF(ISNULL(F2200_temp.fullfillment_type,0) = 0,0,1) = 0	-- 0 : chua co data fullfillment_type / 1 da co
			AND 0 = M2121_temp.item_no -- lay mac dinh
		)
	)
		AND M2121_temp.del_datetime IS NULL
	)
	--
	LEFT JOIN L0010  ON(
		 L0010.number_cd	=	ISNULL(M2121.mark_cd,1)
	AND (	(L0010.name_typ = 22 AND @mark_type = 1)	-- 天気
		OR	(L0010.name_typ = 23 AND @mark_type = 2)	-- 表情
		OR	(L0010.name_typ = 25 AND @mark_type = 3)	-- 表情2		add by viettd 2021/04/09
		OR	(L0010.name_typ = 26 AND @mark_type = 4)	-- 表情3		add by viettd 2021/04/09
		OR	(L0010.name_typ = 24 AND @mark_type = 5)	-- 文字		add by viettd 2021/04/09
		)
	)
	--add by vietdt 2021/12/03
	LEFT JOIN L0010 AS L0010_temp  ON(
		 L0010_temp.number_cd	=	ISNULL(M2121_temp.mark_cd,1)
	AND (	(L0010_temp.name_typ = 22 AND @mark_type = 1)	-- 天気
		OR	(L0010_temp.name_typ = 23 AND @mark_type = 2)	-- 表情
		OR	(L0010_temp.name_typ = 25 AND @mark_type = 3)	-- 表情2		add by viettd 2021/04/09
		OR	(L0010_temp.name_typ = 26 AND @mark_type = 4)	-- 表情3		add by viettd 2021/04/09
		OR	(L0010_temp.name_typ = 24 AND @mark_type = 5)	-- 文字		add by viettd 2021/04/09
		)
	)
	LEFT JOIN M2120 ON(
		@P_company_cd	=	 M2120.company_cd 
	AND m2120.del_datetime IS NULL
	)
	LEFT JOIN #MODE ON(
		F2001.employee_cd	=	#MODE.employee_cd
	AND F2001.times			=	#MODE.times
	)
	WHERE 
		M2620.company_cd		= @P_company_cd
	AND M2620.fiscal_year		= @P_fiscal_year
	AND M2620.[1on1_group_cd]	= @group_cd
	AND @P_member_cd			= F2000.employee_cd
	AND (M2620.times = @P_times OR @P_times = 0)
	--add by vietdt 2021/04/13 --If not rated, it will not be displayed
	AND	(	
			(
				@P_times = 0
			AND	F2200.company_cd IS NOT NULL
			)
		OR	@P_times <> 0
		)
	--add by vietdt 2021/04/13
	AND M2620.del_datetime IS NULL
	-- need call SPC_OM0100_INQ2 to get data for excel --add by vietdt 2021/04/16 
	INSERT INTO #M2100
	EXEC SPC_OM0100_INQ2 @P_company_cd,@P_fiscal_year,@P_member_cd
	--[0]
	SELECT 
		#DATA.title					
	,	#DATA.times					
	,	#DATA.interview_cd			
	,	#DATA.interview_nm			
	,	#DATA.adaption_date			
	,	#DATA.member_cd				
	,	#DATA.coach_cd				
	,	#DATA.oneonone_schedule_date	
	,	#DATA.coach_nm				
	,	#DATA.member_nm				
	,	#DATA.fullfillment_type		
	,	#DATA.interview_date			
	,	#DATA.free_question			
	,	#DATA.member_comment			
	,	#DATA.coach_comment1			
	,	#DATA.next_action				
	,	#DATA.coach_comment2			
	,	#DATA.target1					
	,	#DATA.target2					
	,	#DATA.target3					
	,	#DATA.comment					
	,	#DATA.remark1					
	,	#DATA.remark_name				
	,	#DATA.screen_mode				
	,	#DATA.mark_cd	
	,	CASE
			WHEN	ISNULL(#M2100.target1_use_typ,0) = 1 AND ISNULL(M2200.target1_use_typ,0) = 1
			THEN	1
			ELSE	0
		END								AS target1_use_typ
	,	CASE
			WHEN	ISNULL(#M2100.target2_use_typ,0) = 1 AND ISNULL(M2200.target2_use_typ,0) = 1
			THEN	1
			ELSE	0
		END								AS target2_use_typ
	,	CASE
			WHEN	ISNULL(#M2100.target3_use_typ,0) = 1 AND ISNULL(M2200.target3_use_typ,0) = 1
			THEN	1
			ELSE	0
		END								AS target3_use_typ
	,	CASE
			WHEN	ISNULL(#M2100.comment_use_typ,0) = 1 AND ISNULL(M2200.comment_use_typ,0) = 1
			THEN	1
			ELSE	0
		END								AS comment_use_typ
	,	question_nm
	,	answer_nm
	,	free_question_nm
	,	ISNULL(free_question_use_typ,0) AS free_question_use_typ
	,	member_comment_nm
	,	ISNULL(member_comment_typ,0)	AS member_comment_typ
	,	coach_comment1_nm
	,	ISNULL(coach_comment1_typ,0)	AS coach_comment1_typ
	,	next_action_nm
	,	ISNULL(next_action_typ,0)		AS next_action_typ
	,	coach_comment2_nm
	,	ISNULL(coach_comment2_typ,0)	AS coach_comment2_typ
	,	time		--add by vietdt 2021/05/14
	,	place		--add by vietdt 2021/05/14
	,	@P_language	AS	language
	FROM #DATA
	INNER JOIN M2200 ON (
		M2200.company_cd		=	@P_company_cd
	AND M2200.interview_cd		=	#DATA.interview_cd
	AND M2200.adaption_date		=	#DATA.adaption_date
	AND M2200.del_datetime	IS NULL
	)
	LEFT JOIN M2120 ON(
		M2200.company_cd		=	M2120.company_cd
	)
	LEFT JOIN #M2100 ON (
		M2200.company_cd = #M2100.company_cd
	)
	--[1]
	SELECT 
		F2001.interview_cd
	,	M2201.interview_gyocd
	,	M2201.question
	-- edit by vietdt 2021/12/03
	,	CASE 
			WHEN F2201_temp.company_cd IS NOT NULL AND #MODE.screen_mode = 11
			THEN F2201_temp.answer	
			WHEN F2001.coach_cd = @w_login_employee_cd AND F2200.submit_datetime_member IS NULL	--add vietdt 2022/01/13
			THEN ''
			ELSE F2201.answer
		END								AS answer
	-- edit by vietdt 2021/12/03
	,	F2001.times
	FROM F2001 
	LEFT JOIN #MODE ON(
		F2001.employee_cd	=	#MODE.employee_cd
	AND F2001.times			=	#MODE.times
	)
	LEFT JOIN  M2201 ON(
		F2001.company_cd	=	M2201.company_cd
	AND F2001.interview_cd	=	M2201.interview_cd
	AND F2001.adaption_date	=	M2201.adaption_date
	AND M2201.del_datetime IS NULL
	)
	LEFT JOIN F2201 ON(
		F2001.company_cd		=	F2201.company_cd
	AND F2001.fiscal_year		=	F2201.fiscal_year
	AND F2001.employee_cd		=	F2201.employee_cd
	AND F2001.times				=	F2201.times
	AND F2001.interview_cd		=	F2201.interview_cd
	AND F2001.adaption_date		=	F2201.adaption_date
	AND M2201.interview_gyocd	=	F2201.interview_gyocd
	AND F2201.del_datetime IS NULL
	)
	--add by vietdt 2021/12/03
	LEFT JOIN F2201_temp ON(
		F2001.company_cd		=	F2201_temp.company_cd
	AND F2001.fiscal_year		=	F2201_temp.fiscal_year
	AND F2001.employee_cd		=	F2201_temp.employee_cd
	AND F2001.times				=	F2201_temp.times
	AND F2001.interview_cd		=	F2201_temp.interview_cd
	AND F2001.adaption_date		=	F2201_temp.adaption_date
	AND @P_login_user			=	F2201_temp.input_user
	AND M2201.interview_gyocd	=	F2201_temp.interview_gyocd
	AND F2201_temp.del_datetime IS NULL
	)
	--add by vietdt 2021/12/03
	--add by vietdt 2022/01/13
	LEFT JOIN F2200 ON (
		F2001.company_cd		= F2200.company_cd
	AND F2001.fiscal_year		= F2200.fiscal_year
	AND F2001.employee_cd		= F2200.employee_cd
	AND F2001.times				= F2200.times
	AND F2001.interview_cd		= F2200.interview_cd
	AND F2001.adaption_date		= F2200.adaption_date
	AND F2200.del_datetime IS NULL
	)
	--add by vietdt 2022/01/13
	WHERE F2001.company_cd	= @P_company_cd
	AND F2001.fiscal_year	= @P_fiscal_year
	AND F2001.employee_cd	= @P_member_cd
	AND (F2001.times			= @P_times OR @P_times = 0)
	AND F2001.del_datetime IS NULL
	ORDER BY
		F2001.interview_cd
	,	arrange_order ASC
	--[2] 
	SELECT
		company_cd		
	,	fiscal_year		
	,	employee_cd		
	,	target1			
	,	target2			
	,	target3			
	,	comment			
	,	target1_nm		
	,	target1_use_typ	
	,	target2_nm		
	,	target2_use_typ	
	,	target3_nm		
	,	target3_use_typ	
	,	comment_nm		
	,	comment_use_typ	
	FROM #M2100
	--[3]
	SET @year_end_30day = DATEADD(DD,30,@year_end)
	SELECT 	FORMAT(@year_end_30day,'yyyy/MM/dd')		AS year_end_30day
	-- DROP TABLE 
	DROP TABLE #MODE
	DROP TABLE #DATA
	DROP TABLE #M2100
END
GO
