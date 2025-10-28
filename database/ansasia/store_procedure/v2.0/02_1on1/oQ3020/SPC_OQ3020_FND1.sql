DROP PROCEDURE [SPC_OQ3020_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*  処理概要/process overview	:	SERACH DATA
--*  作成日/create date			:	2020/11/30						
--*　作成者/creater				:	NGHIANM								
--*   					
--*  更新日/update date			:	2021/04/23
--*　更新者/updater				:	viettd
--*　更新内容/update content		:	change FNC_GET_YEAR => FNC_GET_YEAR_1ON1
--* 
--*  更新日/update date			:	2021/05/13
--*　更新者/updater				:	viettd
--*　更新内容/update content		:	IS : search get all data 
--*   					
--*  更新日/update date			:	2021/06/03
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
--*   					
--*  更新日/update date			:	2022/08/19
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	update ver 1.9	
--* 
--****************************************************************************************
CREATE PROCEDURE [SPC_OQ3020_FND1]
	-- Add the parameters for the stored procedure here
	@P_language					nvarchar(10)		= 'jp'		
,	@P_json						NVARCHAR(MAX)		=	''	
,	@P_login_employee_cd		NVARCHAR(10)		=	''		-- login user
,	@P_cre_user					NVARCHAR(50)		=	''	
,	@P_company_cd				SMALLINT			=	0
,	@P_mode						SMALLINT			=	0		--0: search , 1:excel
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								DATETIME			=	SYSDATETIME()
	,	@totalRecord						BIGINT				=	0
	,	@pageMax							INT					=	0	
	,	@page_size							INT					=	50
	,	@page								INT					=	0
	,	@year_month_day						DATE				=	NULL
	--
	,	@fiscal_year						INT					=	0
	,	@employee_cd						NVARCHAR(20)		=	''
	,	@employee_typ						SMALLINT			=	0
	,	@employee_role						SMALLINT			=	0
	,	@group_cd							SMALLINT			=	0
	,	@position_cd						SMALLINT			=	0
	,	@grade								SMALLINT			=	0
	,	@job_cd								SMALLINT			=	0
	,	@coach_cd							NVARCHAR(20)		=	''
	--
	,	@authority_typ						SMALLINT			=	0
	,	@authority_cd						SMALLINT			=	0
	,	@use_typ							SMALLINT			=	0	
	,	@arrange_order						INT					=	0
	,	@login_position_cd					INT					=	0
	--
	,	@beginning_date						DATE				=	NULL
	,	@current_year						INT					=	dbo.FNC_GET_YEAR_1ON1(@P_company_cd,NULL)
	,	@choice_in_screen					TINYINT				=	0
	,	@w_list_time						INT					=	0 -- 1: time checked , 0 time unchecked
	-- add by viettd 2021/06/03
	,	@w_1on1_organization_cnt			INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	--
	IF object_id('tempdb..#TABLE_ORGANIZATION', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_ORGANIZATION
    END
	--
	IF object_id('tempdb..#TABLE_M0022', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_M0022
    END
	--
	IF object_id('tempdb..#JSON_TIMES', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #JSON_TIMES
    END
	--
	IF object_id('tempdb..#LIST_POSITION', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #LIST_POSITION
    END
	--
	IF object_id('tempdb..#F0032_TABLE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F0032_TABLE
    END
	--
	IF object_id('tempdb..#M0070H', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070H
    END
	--
	IF object_id('tempdb..#SUM_TOTAL', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #SUM_TOTAL
    END
	--
	CREATE TABLE #TABLE_ORGANIZATION (
		organization_typ				tinyint
	,	organization_cd_1				nvarchar(50)
	,	organization_cd_2				nvarchar(50)
	,	organization_cd_3				nvarchar(50)
	,	organization_cd_4				nvarchar(50)
	,	organization_cd_5				nvarchar(50)	
	,	choice_in_screen				tinyint		-- 1.choice in screen 0.get from master S0022
	)
	CREATE TABLE #SUM_TOTAL (
		id								int			identity(1,1)
	,	company_cd						smallint
	,	fiscal_year						smallint
	,	employee_cd						nvarchar(10)
	,	questionnaire_cd				smallint
	,	sum_total						smallint
	)
	--
	CREATE TABLE #JSON_TIMES(
		id								int			identity(1,1)
	,	times							smallint
	)
	--
	CREATE TABLE #LIST_POSITION(
		id								int			identity(1,1)
	,	position_cd						int
	,	mode							int	-- 0. choice in screen 1. in master
	)
	--
	CREATE TABLE #TABLE_M0022(
		id								int			identity(1,1)
	,	organization_typ				tinyint
	,	use_typ							smallint	
	,	organization_group_nm			nvarchar(20)
	)
	--
	--
	CREATE TABLE #F2310_TABLE(
		id								int			identity(1,1)
	,	company_cd						smallint
	,	fiscal_year						smallint
	,	group_cd						smallint
	,	times							smallint
	,	questionnaire_cd				smallint
	,	answer_no						smallint
	,	employee_cd						nvarchar(10)
	--	
	,	belong_cd_1						nvarchar(50)
	,	belong_cd_2						nvarchar(50)
	,	belong_cd_3						nvarchar(50)
	,	belong_cd_4						nvarchar(50)
	,	belong_cd_5						nvarchar(50)
	,	job_cd							smallint
	,	position_cd						int
	,	employee_typ					smallint
	,	grade							smallint
	,	questionnaire_gyono				smallint
	,	question						nvarchar(200)
	,	sentence_answer					nvarchar(200)
	,	points_answer					smallint
	,	sub_total						smallint		-- 0: normal ; 1:sub_total
	)
	--
	CREATE TABLE #M0070H(
		application_date				date
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(200)
	,	employee_ab_nm					nvarchar(200)
	,	furigana						nvarchar(200)
	,	office_cd						smallint
	,	office_nm						nvarchar(50)
	,	belong_cd_1						nvarchar(50)
	,	belong_cd_2						nvarchar(50)
	,	belong_cd_3						nvarchar(50)
	,	belong_cd_4						nvarchar(50)
	,	belong_cd_5						nvarchar(50)
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
	SELECT 
		@authority_typ		=	ISNULL(S0010.[1on1_authority_typ],0)
	,	@authority_cd		=	ISNULL(S0010.[1on1_authority_cd],0)
	,	@login_position_cd	=	ISNULL(M0070.position_cd,0)
	FROM S0010
	LEFT OUTER JOIN M0070 ON (
		S0010.company_cd		=	M0070.company_cd
	AND S0010.employee_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	WHERE 
		S0010.company_cd	= @P_company_cd 
	AND S0010.user_id		= @P_cre_user
	AND S0010.del_datetime IS NULL
	-- get @use_typ
	SELECT 
		@use_typ		=	ISNULL(S0020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
	FROM S0020
	WHERE
		S0020.company_cd		=	@P_company_cd
	AND S0020.authority_cd		=	@authority_cd
	AND S0020.del_datetime IS NULL
	-- get @arrange_order
	SELECT 
		@arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@login_position_cd
	AND M0040.del_datetime IS NULL
	-- COUNT ALL ORGANIZATIONS OF S2022 -- add by viettd 2021/06/03
	SET @w_1on1_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@authority_cd,2)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@authority_cd,2)
	--
	SET @fiscal_year		=	JSON_VALUE(@P_json,'$.fiscal_year')
	SET @employee_typ		=	JSON_VALUE(@P_json,'$.employee_typ')
	SET @employee_role		=	JSON_VALUE(@P_json,'$.employee_role')
	SET @group_cd			=	JSON_VALUE(@P_json,'$.group_cd')
	SET @position_cd		=	JSON_VALUE(@P_json,'$.position_cd')
	SET @grade				=	JSON_VALUE(@P_json,'$.grade')
	SET @job_cd				=	JSON_VALUE(@P_json,'$.job_cd')
	SET @employee_cd		=	JSON_VALUE(@P_json,'$.employee_cd')
	SET @coach_cd			=	JSON_VALUE(@P_json,'$.coach_cd')
	SET @page				=	JSON_VALUE(@P_json,'$.page')
	SET @page_size			=	JSON_VALUE(@P_json,'$.page_size')
	--
	INSERT INTO #JSON_TIMES
	SELECT json_table.times FROM OPENJSON(@P_json,'$.list_times') WITH(
		times	smallint
	)AS json_table
	WHERE
		json_table.times > 0
	--

	INSERT INTO #LIST_POSITION
	SELECT @position_cd,0 WHERE @position_cd >= 0
	--
	-- INSERT DATA INTO #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 @P_json,@P_cre_user,@P_company_cd,2
	--
	SELECT 
		@beginning_date = M9100.beginning_date 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	--
	IF @beginning_date IS NOT NULL
	BEGIN
		SET @year_month_day = CAST((CAST(@fiscal_year AS nvarchar(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		SET @year_month_day = DATEADD(DD,-1,DATEADD(YYYY,1,@year_month_day))
	END
	ELSE
	BEGIN 
		SET @year_month_day = CAST((CAST(@fiscal_year AS nvarchar(4)) + '/12/31') AS DATE)
	END
	--
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @year_month_day,'',@P_company_cd
	--
	INSERT INTO #TABLE_M0022 VALUES(1,0,'')
	INSERT INTO #TABLE_M0022 VALUES(2,0,'')
	INSERT INTO #TABLE_M0022 VALUES(3,0,'')
	INSERT INTO #TABLE_M0022 VALUES(4,0,'')
	INSERT INTO #TABLE_M0022 VALUES(5,0,'')
	--
	UPDATE #TABLE_M0022 SET 
		use_typ					=	ISNULL(M0022.use_typ,0)
	,	organization_group_nm	=	ISNULL(M0022.organization_group_nm,'')
	FROM #TABLE_M0022
	INNER JOIN M0022 ON (
		@P_company_cd					=	M0022.company_cd
	AND #TABLE_M0022.organization_typ	=	M0022.organization_typ
	)
	WHERE
		M0022.company_cd		=	@P_company_cd
	AND M0022.del_datetime IS NULL
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- GET #LIST_POSITION
	IF NOT EXISTS (SELECT 1 FROM #LIST_POSITION)
	BEGIN
		IF @use_typ = 1
		BEGIN
			INSERT INTO #LIST_POSITION
			SELECT 
				ISNULL(M0040.position_cd,0)				AS	position_cd
			,	1
			FROM M0040
			WHERE 
				M0040.company_cd		=	@P_company_cd
			AND M0040.arrange_order		>	@arrange_order		-- 1. 本人の役職より下位の社員のみ
			AND M0040.del_datetime IS NULL
		END
	END
	--
	IF EXISTS (SELECT 1 FROM #JSON_TIMES)
	BEGIN
		SET @w_list_time  = 1
	END
	-- FILTER 評価ステップ
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--GET DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF @P_mode = 0
	BEGIN
		INSERT INTO #F2310_TABLE
		SELECT
			F2310.company_cd
		,	F2310.fiscal_year
		--,	MAX(F2310.[1on1_group_cd])
		,	F2310.[1on1_group_cd]			
		,	F2310.times						--edited by vietdt 2021/05/13
		,	F2310.questionnaire_cd
		,	F2310.answer_no					--edited by vietdt 2021/05/13
		,	F2310.employee_cd
		,	#M0070H.belong_cd_1
		,	#M0070H.belong_cd_2
		,	#M0070H.belong_cd_3
		,	#M0070H.belong_cd_4
		,	#M0070H.belong_cd_5
		,	#M0070H.job_cd					
		,	#M0070H.position_cd						
		,	#M0070H.employee_typ					
		,	#M0070H.grade		
		,	NULL		--	F2311.questionnaire_gyono
		,	NULL		--	M2401.question
		,	NULL		--	F2311.sentence_answer
		,	NULL		--	F2311.points_answer
		,	0			--	NORMAL
		FROM F2310
		LEFT JOIN #M0070H ON (
			F2310.company_cd  = #M0070H.company_cd
		AND F2310.employee_cd = #M0070H.employee_cd
		)
		LEFT JOIN F2001 ON (
			F2310.company_cd  = F2001.company_cd
		AND F2310.fiscal_year = F2001.fiscal_year
		AND F2310.employee_cd = F2001.employee_cd
		AND F2310.times		  = F2001.times
		)
		INNER JOIN M2400 ON (
			F2310.company_cd			= M2400.company_cd
		AND F2310.questionnaire_cd		= M2400.questionnaire_cd
		)
		LEFT OUTER JOIN #JSON_TIMES ON (
			F2310.times				=	#JSON_TIMES.times
		)
		WHERE F2310.company_cd		= @P_company_cd
		AND   F2310.fiscal_year		= @fiscal_year
		AND	((@employee_role = 1 AND M2400.submit = 1)
			OR (@employee_role <> 1 AND M2400.submit = 2))
		AND	  (
				@group_cd = -1
			OR (F2310.[1on1_group_cd]   = @group_cd)
			)
		AND  (
				@employee_cd = ''
			OR (#M0070H.employee_cd   = @employee_cd)
			)
		AND  (
				@coach_cd = ''
			OR (F2001.coach_cd   = @coach_cd)
			)
		AND	  (
				@grade = -1
			OR (#M0070H.grade   = @grade)
			)
		AND	  (
				@job_cd = -1
			OR (#M0070H.job_cd   = @job_cd)
			)
		AND	  (
				@employee_typ = -1
			OR (#M0070H.employee_typ   = @employee_typ)
			)
		AND	(
				@w_list_time	= 0 
			OR	(	
					@w_list_time	= 1
				AND	#JSON_TIMES.times IS NOT NULL
				)
			)
		AND F2310.del_datetime IS NULL
		GROUP BY 
				F2310.company_cd				
			,	F2310.fiscal_year				
			,	F2310.times						--edited by vietdt 2021/05/13
			,	F2310.answer_no					--edited by vietdt 2021/05/13
			,	F2310.[1on1_group_cd]
			,	F2310.questionnaire_cd
			,	F2310.employee_cd
			,	#M0070H.belong_cd_1
			,	#M0070H.belong_cd_2
			,	#M0070H.belong_cd_3
			,	#M0070H.belong_cd_4
			,	#M0070H.belong_cd_5
			,	#M0070H.job_cd			
			,	#M0070H.position_cd		
			,	#M0070H.employee_typ	
			,	#M0070H.grade	
	END
	ELSE
	BEGIN
		INSERT INTO #F2310_TABLE
		SELECT
			F2310.company_cd
		,	F2310.fiscal_year
		,	F2310.[1on1_group_cd]
		,	F2310.times
		,	F2310.questionnaire_cd
		,	F2310.answer_no
		,	F2310.employee_cd
		,	#M0070H.belong_cd_1
		,	#M0070H.belong_cd_2
		,	#M0070H.belong_cd_3
		,	#M0070H.belong_cd_4
		,	#M0070H.belong_cd_5
		,	#M0070H.job_cd					
		,	#M0070H.position_cd						
		,	#M0070H.employee_typ					
		,	#M0070H.grade		
		,	F2311.questionnaire_gyono
		,	M2401.question
		,	F2311.sentence_answer
		,	F2311.points_answer
		,	0		--NORMAL
		FROM F2310
		LEFT JOIN #M0070H ON (
			F2310.company_cd  = #M0070H.company_cd
		AND F2310.employee_cd = #M0070H.employee_cd
		)
		LEFT JOIN F2001 ON (
			F2310.company_cd  = F2001.company_cd
		AND F2310.fiscal_year = F2001.fiscal_year
		AND F2310.employee_cd = F2001.employee_cd
		AND F2310.times		  = F2001.times
		)
		INNER JOIN M2400 ON (
			F2310.company_cd			= M2400.company_cd
		AND F2310.questionnaire_cd		= M2400.questionnaire_cd
		)
		LEFT JOIN F2311 ON (
			F2310.company_cd		= F2311.company_cd
		AND F2310.fiscal_year		= F2311.fiscal_year
		AND F2310.[1on1_group_cd]	= F2311.[1on1_group_cd]
		AND F2310.times				= F2311.times
		AND F2310.questionnaire_cd	= F2311.questionnaire_cd
		AND F2310.answer_no			= F2311.answer_no
		AND F2311.del_datetime IS NULL
		)
		LEFT JOIN M2401 ON (
			F2311.company_cd			= M2401.company_cd
		AND F2311.questionnaire_cd		= M2401.questionnaire_cd
		AND F2311.questionnaire_gyono	= M2401.questionnaire_gyono
		AND M2401.del_datetime IS NULL
		)
		LEFT OUTER JOIN #JSON_TIMES ON (
			F2310.times				=	#JSON_TIMES.times
		)
		WHERE F2310.company_cd		= @P_company_cd
		AND   F2310.fiscal_year		= @fiscal_year
		AND	((@employee_role = 1 AND M2400.submit = 1)
			OR (@employee_role <> 1 AND M2400.submit = 2))
		AND	  (
				@group_cd = -1
			OR (F2310.[1on1_group_cd]   = @group_cd)
			)
		AND  (
				@employee_cd = ''
			OR (#M0070H.employee_cd   = @employee_cd)
			)
		AND  (
				@coach_cd = ''
			OR (F2001.coach_cd   = @coach_cd)
			)
		AND	  (
				@grade = -1
			OR (#M0070H.grade   = @grade)
			)
		AND	  (
				@job_cd = -1
			OR (#M0070H.job_cd   = @job_cd)
			)
		AND	  (
				@employee_typ = -1
			OR (#M0070H.employee_typ   = @employee_typ)
			)
		AND	(
				@w_list_time	= 0 
			OR	(	
					@w_list_time	= 1
				AND	#JSON_TIMES.times IS NOT NULL
				)
			)
		AND F2310.del_datetime IS NULL
		GROUP BY 
				F2310.company_cd				
			,	F2310.fiscal_year	
			,	F2310.[1on1_group_cd]
			,	F2310.times
			,	F2310.questionnaire_cd
			,	F2310.employee_cd
			,	F2310.answer_no
			,	#M0070H.belong_cd_1
			,	#M0070H.belong_cd_2
			,	#M0070H.belong_cd_3
			,	#M0070H.belong_cd_4
			,	#M0070H.belong_cd_5
			,	#M0070H.job_cd			
			,	#M0070H.position_cd		
			,	#M0070H.employee_typ	
			,	#M0070H.grade	
			,	F2311.questionnaire_gyono
			,	M2401.question
			,	F2311.sentence_answer
			,	F2311.points_answer
	END
	--■■■■■■■■■■■■■ FILTER DATA ■■■■■■■■■■■■■

	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
	BEGIN
		SET @choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
		-- 1.choice in screen
		IF @choice_in_screen = 1
		BEGIN
			DELETE D FROM #F2310_TABLE AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.company_cd			=	@P_company_cd
			AND D.belong_cd_1			=	S.organization_cd_1
			AND D.belong_cd_2			=	S.organization_cd_2
			AND D.belong_cd_3			=	S.organization_cd_3
			AND D.belong_cd_4			=	S.organization_cd_4
			AND D.belong_cd_5			=	S.organization_cd_5
			)
			WHERE 
			(	D.company_cd IS NULL
			OR	S.organization_typ IS NULL
			)
			AND D.employee_cd IS NOT NULL -- CLICK AN DANH
		END
		ELSE IF NOT (@authority_typ = 3 AND @w_1on1_organization_cnt = 0 AND @w_organization_belong_person_typ = 0) -- edited by viettd 2021/06/03
		BEGIN
			DELETE D FROM #F2310_TABLE AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.company_cd			=	@P_company_cd
			AND D.belong_cd_1			=	S.organization_cd_1
			AND D.belong_cd_2			=	S.organization_cd_2
			AND D.belong_cd_3			=	S.organization_cd_3
			AND D.belong_cd_4			=	S.organization_cd_4
			AND D.belong_cd_5			=	S.organization_cd_5
			)
			WHERE 
			(
				D.company_cd IS NULL
			OR	S.organization_typ IS NULL
			)
			AND D.employee_cd IS NOT NULL -- CLICK AN DANH
			AND @authority_typ NOT IN (4,5) --4.会社管理者 5.総合管理者
		END
	END
	--FILTER POSITION
	IF EXISTS (SELECT 1 FROM #LIST_POSITION)
	BEGIN
		-- choice screen
		IF EXISTS (SELECT 1 FROM #LIST_POSITION WHERE mode = 0)
		BEGIN
			DELETE D FROM #F2310_TABLE AS D
			LEFT OUTER JOIN #LIST_POSITION AS S ON (
				D.position_cd	= S.position_cd
			)
			WHERE
				S.position_cd IS NULL
			AND D.employee_cd IS NOT NULL -- CLICK AN DANH
		END
		ELSE
		BEGIN
			-- 
			IF @authority_typ NOT IN (4,5)
			BEGIN
				DELETE D FROM #F2310_TABLE AS D
				LEFT OUTER JOIN #LIST_POSITION AS S ON (
					D.position_cd	= S.position_cd
				)
				WHERE
					S.position_cd IS NULL
				AND D.employee_cd IS NOT NULL -- CLICK AN DANH
			END
		END
	END
	--■■■■■■■■■■■■■ END FILTER DATA ■■■■■■■■■■■■■
	
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--PROCESS DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--INSERT INTO #RESULT
	IF @P_mode = 0
	BEGIN
		SET @totalRecord = (SELECT COUNT(1) FROM #F2310_TABLE)
		SET @pageMax = CEILING(CAST(@totalRecord AS FLOAT) / @page_size)
		IF @pageMax = 0
		BEGIN
			SET @pageMax = 1
		END
		IF @page > @pageMax
		BEGIN
			SET @page = @pageMax
		END
		--
		SELECT 
			#F2310_TABLE.company_cd
		,	#F2310_TABLE.fiscal_year
		,	M2600.[1on1_group_cd]
		,	ISNULL(#F2310_TABLE.employee_cd, IIF(@P_language = 'en','Anonymous','匿名'))		AS	employee_cd
		,	#M0070H.employee_nm
		,	M2620.times
		,	M2600.[1on1_group_nm]		AS group_nm
		,	CASE	
				WHEN	M2620.[1on1_title] = ''
				THEN	IIF(@P_language = 'en','Times ' +CONVERT(VARCHAR(5),M2620.times),CONVERT(VARCHAR(5),M2620.times) + '回目')
				ELSE	M2620.[1on1_title]
			END							AS group_title
		,	CASE
				WHEN M0070.gender = 1 
				THEN IIF(@P_language = 'en','Male',N'男性')
				WHEN M0070.gender = 2 
				THEN IIF(@P_language = 'en','Female',N'女性')
				ELSE N''
			END	AS gender
		,	dbo.FNC_GET_BIRTHDAY_AGE(M0070.birth_date,NULL)	AS age
		,	#M0070H.belong_nm_1
		,	#M0070H.belong_nm_2
		,	#M0070H.belong_nm_3
		,	#M0070H.belong_nm_4
		,	#M0070H.belong_nm_5
		,	#M0070H.position_nm
		,	#M0070H.grade_nm
		,	M2400.questionnaire_nm
		FROM #F2310_TABLE
		LEFT JOIN M2600 ON (
			#F2310_TABLE.company_cd = M2600.company_cd
		AND #F2310_TABLE.group_cd	= M2600.[1on1_group_cd]
		)
		LEFT JOIN M2620 ON (
			#F2310_TABLE.company_cd		= M2620.company_cd
		AND	#F2310_TABLE.fiscal_year	= M2620.fiscal_year
		AND #F2310_TABLE.group_cd		= M2620.[1on1_group_cd]
		AND #F2310_TABLE.times			= M2620.times
		)
		LEFT JOIN M0070 ON (
			#F2310_TABLE.company_cd		= M0070.company_cd
		AND #F2310_TABLE.employee_cd	= M0070.employee_cd
		AND M0070.del_datetime IS NULL
		)
		LEFT JOIN #M0070H ON (
			#F2310_TABLE.company_cd		= #M0070H.company_cd
		AND #F2310_TABLE.employee_cd	= #M0070H.employee_cd
		)
		LEFT JOIN M2400 ON (
			#F2310_TABLE.company_cd			= M2400.company_cd
		AND #F2310_TABLE.questionnaire_cd	= M2400.questionnaire_cd
		)
		ORDER BY 
			company_cd
		,	M2600.[1on1_group_cd]
		,	CASE ISNUMERIC(#F2310_TABLE.employee_cd) 
				WHEN 1 
				THEN CAST(#F2310_TABLE.employee_cd AS BIGINT) 
				ELSE 999999999999999 
			END
		,	M2620.times
		,	#F2310_TABLE.questionnaire_cd
		OFFSET (@page-1) * @page_size ROWS
		FETCH NEXT IIF(@page_size = 0,10,@page_size) ROWS ONLY
	END
	ELSE
	BEGIN
		--GET SUB_TOTAL
		INSERT INTO #SUM_TOTAL
		SELECT 
				company_cd			AS company_cd		
			,	fiscal_year			AS fiscal_year		
			,	employee_cd			AS employee_cd		
			,	questionnaire_cd	AS questionnaire_cd
			,	COUNT(company_cd)	AS sum_total
		FROM #F2310_TABLE
		GROUP BY company_cd,fiscal_year,employee_cd,questionnaire_cd

		UPDATE #F2310_TABLE
		SET sub_total = #SUM_TOTAL.sum_total
		FROM #F2310_TABLE
		INNER JOIN #SUM_TOTAL ON (
			#F2310_TABLE.company_cd			= #SUM_TOTAL.company_cd
		AND	#F2310_TABLE.fiscal_year		= #SUM_TOTAL.fiscal_year
		AND	#F2310_TABLE.employee_cd		= #SUM_TOTAL.employee_cd
		AND	#F2310_TABLE.questionnaire_cd	= #SUM_TOTAL.questionnaire_cd
		)
		--
		SELECT 
			#F2310_TABLE.company_cd
		,	#F2310_TABLE.fiscal_year
		,	M2600.[1on1_group_cd]
		,	ISNULL(#F2310_TABLE.employee_cd,IIF(@P_language = 'en','Anonymous','匿名'))		AS	employee_cd
		,	#M0070H.employee_nm
		,	M2620.times
		,	M2400.questionnaire_cd
		,	#F2310_TABLE.answer_no
		,	M2600.[1on1_group_nm]	AS group_nm
		,	CASE	
					WHEN	M2620.[1on1_title] = ''
					THEN	IIF(@P_language = 'en','Times ' +CONVERT(VARCHAR(5),M2620.times),CONVERT(VARCHAR(5),M2620.times) + '回目')
					ELSE	M2620.[1on1_title]
				END							AS group_title
		,	CASE
				WHEN M0070.gender = 1 
				THEN IIF(@P_language = 'en','Male',N'男性')
				WHEN M0070.gender = 2 
				THEN IIF(@P_language = 'en','Female',N'女性')
				ELSE N''
			END	AS gender
		,	CASE
				WHEN dbo.FNC_GET_BIRTHDAY_AGE(M0070.birth_date,NULL) = 0
				THEN NULL
				ELSE dbo.FNC_GET_BIRTHDAY_AGE(M0070.birth_date,NULL)
			END	AS age 
		,	#M0070H.belong_nm_1
		,	#M0070H.belong_nm_2
		,	#M0070H.belong_nm_3
		,	#M0070H.belong_nm_4
		,	#M0070H.belong_nm_5
		,	#M0070H.position_nm
		,	#M0070H.grade_nm
		,	M2400.questionnaire_nm
		,	#F2310_TABLE.question			
		,	#F2310_TABLE.sentence_answer
		,	CAST(#F2310_TABLE.points_answer AS nvarchar(10))	AS points_answer
		,	F2310.comment
		,	#F2310_TABLE.sub_total
		,	#F2310_TABLE.id
		,	@P_language		AS language
		FROM #F2310_TABLE
		LEFT JOIN M2600 ON (
			#F2310_TABLE.company_cd = M2600.company_cd
		AND #F2310_TABLE.group_cd	= M2600.[1on1_group_cd]
		)
		LEFT JOIN M2620 ON (
			#F2310_TABLE.company_cd		= M2620.company_cd
		AND	#F2310_TABLE.fiscal_year	= M2620.fiscal_year
		AND #F2310_TABLE.group_cd		= M2620.[1on1_group_cd]
		AND #F2310_TABLE.times			= M2620.times
		)
		LEFT JOIN M0070 ON (
			#F2310_TABLE.company_cd		= M0070.company_cd
		AND #F2310_TABLE.employee_cd	= M0070.employee_cd
		AND M0070.del_datetime IS NULL
		)
		LEFT JOIN #M0070H ON (
			#F2310_TABLE.company_cd		= #M0070H.company_cd
		AND #F2310_TABLE.employee_cd	= #M0070H.employee_cd
		)
		LEFT JOIN M2400 ON (
				#F2310_TABLE.company_cd			= M2400.company_cd
			AND #F2310_TABLE.questionnaire_cd	= M2400.questionnaire_cd
		)
		INNER JOIN F2310 ON (
			#F2310_TABLE.company_cd			= F2310.company_cd
		AND #F2310_TABLE.fiscal_year		= F2310.fiscal_year
		AND #F2310_TABLE.group_cd			= F2310.[1on1_group_cd]
		AND #F2310_TABLE.times				= F2310.times
		AND #F2310_TABLE.questionnaire_cd	= F2310.questionnaire_cd
		AND #F2310_TABLE.answer_no			= F2310.answer_no
		AND	ISNULL(#F2310_TABLE.employee_cd,'')		= ISNULL(F2310.employee_cd,'')
		)
		ORDER BY
			company_cd
		,	M2600.[1on1_group_cd]
		,	CASE ISNUMERIC(#F2310_TABLE.employee_cd) 
				WHEN 1 
				THEN CAST(#F2310_TABLE.employee_cd AS BIGINT) 
				ELSE 999999999999999 
			END
		,	M2620.times
		,	#F2310_TABLE.questionnaire_cd
		,	#F2310_TABLE.answer_no
		,	#F2310_TABLE.sub_total
		,	#F2310_TABLE.questionnaire_gyono
	END
	--[1]
	SELECT	
		@totalRecord					AS	totalRecord
	,	@pageMax						AS	pageMax
	,	@page							AS	page
	,	@page_size						AS	pagesize
	,	((@page - 1) * @page_size + 1)	AS	offset
	--[2]
	SELECT 
		ISNULL(M0022.organization_typ,0)				AS	organization_typ
	,	ISNULL(M0022.organization_group_nm,'')			AS	organization_group_nm
	,	ISNULL(M0022.use_typ,0)							AS	use_typ
	FROM #TABLE_M0022 AS M0022
	ORDER BY
		M0022.organization_typ
END
GO
