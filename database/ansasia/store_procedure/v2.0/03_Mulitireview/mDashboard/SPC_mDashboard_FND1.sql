IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_mDashboard_FND1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_mDashboard_FND1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC SPC_mDashboard_FND1 '740','2022','721','721','0';
/****************************************************************************************************
 *
 *  処理概要：mDashboard - list
 *
 *  作成日  ：	2021/01/08
 *  作成者  ：	ANS-ASIA DUONGNTT
 *
 *  更新日  ：	2021/03/18
 *  更新者  ：	viettd
 *  更新内容：	add condition check 
 *
 *  更新日  ：	2021/03/30
 *  更新者  ：	viettd
 *  更新内容：	[平均点] : change F3000.evaluation_point to F3001.point
 *
 *  更新日  ：	2021/04/15
 *  更新者  ：	vietdt
 *  更新内容：	CR 通知明細 add screen.年度＝F3900.fiscal_year 
 *
 *  更新日  ：	2021/05/04
 *  更新者  ：	vietdt
 *  更新内容：	CR notes 6 : change the condition of the search results
 *
 *  更新日  ：	2021/05/07
 *  更新者  ：	vietdt
 *  更新内容：	CR notes 6 : change the condition of the search results
 *
 *  更新日  ：	2021/06/03
 *  更新者  ：	viettd
 *  更新内容：	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
 *EXEC SPC_mDashboard_FND1 '740','2022','721','721','0';
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_mDashboard_FND1]
	@P_company_cd		SMALLINT		=	0
,	@P_fiscal_year		SMALLINT		=	0	
,	@P_supporter_cd		NVARCHAR(10)	=	''	-- LOGIN employee_cd
,	@P_cre_user			NVARCHAR(50)	=	''	
,	@P_screen_flg		INT				=	0	--0: admin/rater ダッシュボード（評価者・管理者用） ;1: supporter ダッシュボード（サポーター用）
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_confirm_flg						int				=	0
	,	@w_choice_in_screen					smallint		=	0
	,	@w_multireview_authority_typ		smallint		=	0	
	,	@w_multireview_authority_cd			smallint		=	0
	,	@w_use_typ							smallint		=	0	
	,	@w_arrange_order					int				=	0
	,	@w_login_position_cd				int				=	0
	,	@w_beginning_date					date			=	NULL
	,	@w_year_month_day					date			=	NULL
	-- add by viettd 2021/06/03
	,	@w_mulitireview_organization_cnt	INT				=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT		=	0
	,	@w_language							SMALLINT		=	0
	-- #TABLE_RESULT (main table)
	CREATE TABLE #TABLE_RESULT(
		id								INT IDENTITY(1,1)
	,	company_cd						SMALLINT
	,	fiscal_year						SMALLINT
	,	employee_cd						NVARCHAR(10)
	,	employee_nm						NVARCHAR(101)
	,	sum_evaluation_point			FLOAT
	,	num_detail						INT
	,	cre_datetime					DATETIME
	,	detail_no						SMALLINT	-- max(detail_no)
	--	MASTER INFO
	,	belong_cd1						NVARCHAR(20)
	,	belong_cd2						NVARCHAR(20)
	,	belong_cd3						NVARCHAR(20)
	,	belong_cd4						NVARCHAR(20)
	,	belong_cd5						NVARCHAR(20)
	,	position_cd						INT
	)
	-- #TABLE_F3000
	CREATE TABLE #TABLE_F3000(
		company_cd						SMALLINT
	,	employee_cd						NVARCHAR(10)
	,	detail_no						SMALLINT
	,	reviews_number					INT			-- レビュー件数
	,	year_review						INT
	,	cre_datetime					DATETIME	-- 最新レビュー日時
	)
	-- #TABLE_REVIEW_RESULT
	CREATE TABLE #TABLE_REVIEW_RESULT(
		company_cd						SMALLINT
	,	employee_cd						NVARCHAR(10)
	,	max_detail_no					SMALLINT	-- max(detail_no)
	,	reviews_number					INT			-- レビュー件数
	,	max_cre_datetime				DATETIME	-- 最新レビュー日時
	,	sum_point						FLOAT
	,	record_cnt						INT
	,	avg_point						FLOAT
	)
	-- #TABLE_ORGANIZATION
	CREATE TABLE #TABLE_ORGANIZATION (
		organization_typ				tinyint
	,	organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)	
	,	choice_in_screen				tinyint		-- 1.choice in screen 0.get from master S0022
	)
	-- #LIST_POSITION
	CREATE TABLE #LIST_POSITION(
		id								int			identity(1,1)
	,	position_cd						int
	,	mode							smallint
	)
	--#M0070H
	CREATE TABLE #M0070H(
		application_date				date
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(101)
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
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--PREPARE DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- GET @multireview_authority_typ
	SELECT 
		@w_multireview_authority_typ		=	ISNULL(S0010.multireview_authority_typ,0)
	,	@w_multireview_authority_cd			=	ISNULL(S0010.multireview_authority_cd,0)
	,	@w_login_position_cd				=	ISNULL(M0070.position_cd,0)
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
		@w_use_typ		=	ISNULL(S3020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
	FROM S3020
	WHERE
		S3020.company_cd		=	@P_company_cd
	AND S3020.authority_cd		=	@w_multireview_authority_cd
	AND S3020.del_datetime IS NULL
	--get @w_language
	SELECT 
		@w_language	=	ISNULL(S0010.language,0)
	FROM S0010
	WHERE 
		S0010.company_cd		=	@P_company_cd
	AND S0010.employee_cd		=	@P_supporter_cd
	AND S0010.del_datetime IS NULL
	-- get @arrange_order
	SELECT 
		@w_arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@w_login_position_cd
	AND M0040.del_datetime IS NULL
	-- COUNT ALL ORGANIZATIONS OF S3022 -- add by viettd 2021/06/03
	SET @w_mulitireview_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_multireview_authority_cd,3)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_multireview_authority_cd,3)
	-- get @w_beginning_date
	SELECT 
		@w_beginning_date = M9100.beginning_date 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	-- get #M0070H
	IF @w_beginning_date IS NOT NULL
	BEGIN
		SET @w_year_month_day = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/' + FORMAT(@w_beginning_date,'MM/dd')) AS DATE)
		SET @w_year_month_day = DATEADD(DD,-1,DATEADD(YYYY,1,@w_year_month_day))
	END
	ELSE
	BEGIN 
		SET @w_year_month_day = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/12/31') AS DATE)
	END
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @w_year_month_day,'',@P_company_cd
	--edited by vietdt 2021/05/04
	--admin/rater
	IF	@P_screen_flg = 0
	BEGIN
		--admin --add by vietdt 2021/05/07
		IF	@w_multireview_authority_typ	>= 3
		BEGIN
			INSERT INTO #TABLE_RESULT
			SELECT
				F3020.company_cd			
			,	F3020.fiscal_year		
			,	F3020.employee_cd		
			,	ISNULL(M0070.employee_nm,'')
			--
			,	NULL
			,	NULL
			,	NULL
			,	NULL
			,	M0070.belong_cd_1		
			,	M0070.belong_cd_2		
			,	M0070.belong_cd_3		
			,	M0070.belong_cd_4		
			,	M0070.belong_cd_5		
			,	M0070.position_cd		
			FROM F3020
			LEFT OUTER JOIN #M0070H AS M0070 ON (
				F3020.company_cd	=	M0070.company_cd
			AND F3020.employee_cd	=	M0070.employee_cd
			)
			WHERE
				F3020.company_cd	=	@P_company_cd
			AND	F3020.fiscal_year	=	@P_fiscal_year
			AND	F3020.del_datetime IS NULL
			GROUP BY
				F3020.company_cd			
			,	F3020.fiscal_year		
			,	F3020.employee_cd		
			,	ISNULL(M0070.employee_nm,'')
			,	M0070.belong_cd_1		
			,	M0070.belong_cd_2		
			,	M0070.belong_cd_3		
			,	M0070.belong_cd_4		
			,	M0070.belong_cd_5		
			,	M0070.position_cd
		END
		--rater --add by vietdt 2021/05/07
		IF	@w_multireview_authority_typ	< 3
		BEGIN
			-- insert data into #TABLE_RESULT
			INSERT INTO #TABLE_RESULT
			SELECT
				F3020.company_cd			
			,	F3020.fiscal_year		
			,	F3020.employee_cd		
			,	ISNULL(M0070.employee_nm,'')
			--
			,	NULL
			,	NULL
			,	NULL
			,	NULL
			,	M0070.belong_cd_1		
			,	M0070.belong_cd_2		
			,	M0070.belong_cd_3		
			,	M0070.belong_cd_4		
			,	M0070.belong_cd_5		
			,	M0070.position_cd
			FROM F0030
			INNER JOIN F3020 ON (
				F0030.company_cd	=	F3020.company_cd
			AND	F0030.fiscal_year	=	F3020.fiscal_year
			AND	F0030.employee_cd	=	F3020.employee_cd
			AND	F3020.del_datetime	IS NULL
			)
			LEFT OUTER JOIN #M0070H AS M0070 ON (
				F3020.company_cd	=	M0070.company_cd
			AND F3020.employee_cd	=	M0070.employee_cd
			)
			WHERE
				F0030.company_cd			=	@P_company_cd
			AND	F0030.fiscal_year			=	@P_fiscal_year
			AND F0030.rater_employee_cd_1	=	@P_supporter_cd 
			AND	F0030.del_datetime IS NULL
			GROUP BY
				F3020.company_cd			
			,	F3020.fiscal_year		
			,	F3020.employee_cd		
			,	ISNULL(M0070.employee_nm,'')
			,	M0070.belong_cd_1		
			,	M0070.belong_cd_2		
			,	M0070.belong_cd_3		
			,	M0070.belong_cd_4		
			,	M0070.belong_cd_5		
			,	M0070.position_cd
		END
	END
	--suppoter
	IF	@P_screen_flg =	1
	BEGIN
		INSERT INTO #TABLE_RESULT
		SELECT
			F3020.company_cd			
		,	F3020.fiscal_year		
		,	F3020.employee_cd		
		,	ISNULL(M0070.employee_nm,'')
		--
		,	NULL
		,	NULL
		,	NULL
		,	NULL
		,	M0070.belong_cd_1		
		,	M0070.belong_cd_2		
		,	M0070.belong_cd_3		
		,	M0070.belong_cd_4		
		,	M0070.belong_cd_5		
		,	M0070.position_cd		
		FROM F3020
		LEFT OUTER JOIN #M0070H AS M0070 ON (
			F3020.company_cd	=	M0070.company_cd
		AND F3020.employee_cd	=	M0070.employee_cd
		)
		WHERE
			F3020.company_cd	=	@P_company_cd
		AND	F3020.fiscal_year	=	@P_fiscal_year
		AND F3020.supporter_cd	=	@P_supporter_cd
		AND	F3020.del_datetime IS NULL
		GROUP BY
			F3020.company_cd			
		,	F3020.fiscal_year		
		,	F3020.employee_cd		
		,	ISNULL(M0070.employee_nm,'')
		,	M0070.belong_cd_1		
		,	M0070.belong_cd_2		
		,	M0070.belong_cd_3		
		,	M0070.belong_cd_4		
		,	M0070.belong_cd_5		
		,	M0070.position_cd
	END
	--edited by vietdt 2021/05/04
	-- IF SCREEN 0: admin/rater ダッシュボード（評価者・管理者用） THEN FILTER 
	IF ( @P_screen_flg = 0 AND @w_multireview_authority_typ = 3) --edited by vietdt 2021/05/07
	BEGIN
		-- FILTER #TABLE_ORGANIZATION
		-- INSERT DATA INTO #TABLE_ORGANIZATION
		INSERT INTO #TABLE_ORGANIZATION
		EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 '',@P_cre_user,@P_company_cd,3
		-- INSERT DATA INTO #LIST_POSITION
		IF NOT EXISTS (SELECT 1 FROM #LIST_POSITION)
		BEGIN
			IF @w_use_typ = 1
			BEGIN
				INSERT INTO #LIST_POSITION
				SELECT 
					ISNULL(M0040.position_cd,0)				AS	position_cd
				,	1
				FROM M0040
				WHERE 
					M0040.company_cd		=	@P_company_cd
				AND M0040.arrange_order		>	@w_arrange_order		-- 1. 本人の役職より下位の社員のみ
				AND M0040.del_datetime IS NULL
			END
		END
		-- FILTER 組織
		IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
		BEGIN
			SET @w_choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
			-- 1.choice in screen
			IF @w_choice_in_screen = 1
			BEGIN
				DELETE D FROM #TABLE_RESULT AS D
				FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
					D.company_cd			=	@P_company_cd
				AND D.belong_cd1			=	S.organization_cd_1
				AND D.belong_cd2			=	S.organization_cd_2
				AND D.belong_cd3			=	S.organization_cd_3
				AND D.belong_cd4			=	S.organization_cd_4
				AND D.belong_cd5			=	S.organization_cd_5
				)
				WHERE 
					D.company_cd IS NULL
				OR	S.organization_typ IS NULL
			END
			ELSE IF NOT (@w_multireview_authority_typ = 3 AND @w_mulitireview_organization_cnt = 0 AND @w_organization_belong_person_typ = 0) -- edited by viettd 2021/06/03
			BEGIN
				DELETE D FROM #TABLE_RESULT AS D
				FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
					D.company_cd			=	@P_company_cd
				AND D.belong_cd1			=	S.organization_cd_1
				AND D.belong_cd2			=	S.organization_cd_2
				AND D.belong_cd3			=	S.organization_cd_3
				AND D.belong_cd4			=	S.organization_cd_4
				AND D.belong_cd5			=	S.organization_cd_5
				)
				WHERE 
					D.company_cd IS NULL
				OR	S.organization_typ IS NULL
				AND @w_multireview_authority_typ NOT IN (4,5) --4.会社管理者 5.総合管理者
			END
		END
		-- FILTER 役職
		IF EXISTS (SELECT 1 FROM #LIST_POSITION)
		BEGIN
			-- choice in screen
			IF EXISTS (SELECT 1 FROM #LIST_POSITION WHERE mode = 0)
			BEGIN
				DELETE D FROM #TABLE_RESULT AS D
				LEFT OUTER JOIN #LIST_POSITION AS S ON (
					D.company_cd		=	@P_company_cd
				AND D.position_cd		=	S.position_cd
				)
				WHERE
					S.position_cd IS NULL
			END
			ELSE -- not choice in screen
			BEGIN
				IF @w_multireview_authority_typ NOT IN (4,5)
				BEGIN
					DELETE D FROM #TABLE_RESULT AS D
					LEFT OUTER JOIN #LIST_POSITION AS S ON (
						D.company_cd		=	@P_company_cd
					AND D.position_cd		=	S.position_cd
					)
					WHERE
						S.position_cd IS NULL
				END
			END
		END
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- PROCESS DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- INSERT DATA INTO #TABLE_F3000
	INSERT INTO #TABLE_F3000
	SELECT 
		F3000.company_cd			
	,	F3000.employee_cd	
	,	F3000.detail_no		
	,	COUNT(1)  OVER(PARTITION BY F3000.company_cd, F3000.employee_cd ORDER BY F3000.company_cd ASC) AS reviews_number
	,	dbo.FNC_GET_YEAR(@P_company_cd,F3000.review_date)	AS	year_review
	,	CASE 
			WHEN F3000.upd_datetime IS NOT NULL
			THEN F3000.upd_datetime
			ELSE F3000.cre_datetime
		END													AS	cre_datetime
	FROM #TABLE_RESULT
	INNER JOIN F3000 ON (
		#TABLE_RESULT.company_cd	=	F3000.company_cd
	AND #TABLE_RESULT.employee_cd	=	F3000.employee_cd
	)
	WHERE 
		dbo.FNC_GET_YEAR(@P_company_cd,F3000.review_date)	=	@P_fiscal_year
	AND F3000.del_datetime IS NULL
	AND (
		(@P_screen_flg	=	0)	-- admin&rater
	OR	(@P_screen_flg	=	1 AND F3000.supporter_cd	=	@P_supporter_cd)	-- suppoter
	)
	-- insert into #TABLE_REVIEW_RESULT
	INSERT INTO #TABLE_REVIEW_RESULT
	SELECT 
		#TABLE_F3000.company_cd			
	,	#TABLE_F3000.employee_cd	
	,	MAX(#TABLE_F3000.detail_no)		AS	max_detail_no		-- screen (max detail_no)
	,	#TABLE_F3000.reviews_number		AS	reviews_number
	,	NULL							AS	max_cre_datetime
	,	0								AS	sum_point
	,	#TABLE_F3000.reviews_number		AS	record_cnt
	,	0								AS	avg_point
	FROM #TABLE_F3000	
	GROUP BY
		#TABLE_F3000.company_cd
	,	#TABLE_F3000.employee_cd
	,	#TABLE_F3000.reviews_number
	-- UPDATE max_cre_datetime
	UPDATE #TABLE_REVIEW_RESULT SET 
		max_cre_datetime = F3000_MAX.cre_datetime
	FROM #TABLE_REVIEW_RESULT
	INNER JOIN (
		SELECT 
			#TABLE_F3000.company_cd			AS	company_cd
		,	#TABLE_F3000.employee_cd		AS	employee_cd
		,	MAX(#TABLE_F3000.cre_datetime)	AS	cre_datetime
		FROM #TABLE_F3000
		GROUP BY
			#TABLE_F3000.company_cd		
		,	#TABLE_F3000.employee_cd	
	) AS F3000_MAX ON (
		#TABLE_REVIEW_RESULT.company_cd		=	F3000_MAX.company_cd
	AND #TABLE_REVIEW_RESULT.employee_cd	=	F3000_MAX.employee_cd
	)
	-- if suppoter 
	IF @P_screen_flg = 1
	BEGIN
		-- update #TABLE_REVIEW_RESULT when suppoter
		UPDATE #TABLE_REVIEW_RESULT SET 
			sum_point = ISNULL(F3000_SUM.evaluation_point,0)
		FROM #TABLE_REVIEW_RESULT
		INNER JOIN (
			SELECT 
				#TABLE_F3000.company_cd			AS	company_cd
			,	#TABLE_F3000.employee_cd		AS	employee_cd
			,	SUM(F3000.evaluation_point)		AS	evaluation_point
			FROM #TABLE_F3000
			LEFT OUTER JOIN F3000 ON (
				#TABLE_F3000.company_cd		=	F3000.company_cd
			AND #TABLE_F3000.employee_cd	=	F3000.employee_cd
			AND #TABLE_F3000.detail_no		=	F3000.detail_no
			AND F3000.del_datetime IS NULL
			)
			GROUP BY
				#TABLE_F3000.company_cd
			,	#TABLE_F3000.employee_cd
		) AS F3000_SUM ON(
			#TABLE_REVIEW_RESULT.company_cd		=	F3000_SUM.company_cd
		AND #TABLE_REVIEW_RESULT.employee_cd		=	F3000_SUM.employee_cd
		)
	END
	ELSE		-- ADMIN/RATER
	BEGIN
		-- update #TABLE_REVIEW_RESULT when admin & rater
		UPDATE #TABLE_REVIEW_RESULT SET 
			sum_point	= ISNULL(F3001_SUM.point,0)
		,	record_cnt	= ISNULL(F3001_SUM.record_cnt,0)
		FROM #TABLE_REVIEW_RESULT
		INNER JOIN (
			SELECT 
				#TABLE_F3000.company_cd		AS	company_cd
			,	#TABLE_F3000.employee_cd	AS	employee_cd
			,	SUM(F3001.point)			AS	point
			,	COUNT(F3001.detail_no)		AS	record_cnt
			FROM #TABLE_F3000
			LEFT OUTER JOIN F3001 ON (
				#TABLE_F3000.company_cd		=	F3001.company_cd
			AND #TABLE_F3000.employee_cd	=	F3001.employee_cd
			AND #TABLE_F3000.detail_no		=	F3001.detail_no
			AND F3001.del_datetime IS NULL
			)
			WHERE 
				F3001.company_cd	=	@P_company_cd
			AND (
				(@w_multireview_authority_typ > 2)	-- ADMIN
			OR	(@w_multireview_authority_typ = 2 AND F3001.rater_employee_cd_1 = @P_supporter_cd)
			)
			GROUP BY
				#TABLE_F3000.company_cd
			,	#TABLE_F3000.employee_cd
		) AS F3001_SUM ON(
			#TABLE_REVIEW_RESULT.company_cd		=	F3001_SUM.company_cd
		AND #TABLE_REVIEW_RESULT.employee_cd	=	F3001_SUM.employee_cd
		)
	END
	-- UPDATE avg_point
	UPDATE #TABLE_REVIEW_RESULT SET 
		avg_point = CASE 
						WHEN record_cnt <> 0
						THEN ROUND(sum_point/record_cnt,2)
						ELSE 0
					END
	FROM #TABLE_REVIEW_RESULT 
	-- UPDATE #TABLE_RESULT FROM TABLE #TABLE_REVIEW_RESULT
	UPDATE #TABLE_RESULT SET 
		sum_evaluation_point	=	#TABLE_REVIEW_RESULT.avg_point
	,	num_detail				=	#TABLE_REVIEW_RESULT.reviews_number
	,	cre_datetime			=	#TABLE_REVIEW_RESULT.max_cre_datetime
	,	detail_no				=	#TABLE_REVIEW_RESULT.max_detail_no
	FROM #TABLE_RESULT
	INNER JOIN #TABLE_REVIEW_RESULT ON (
		#TABLE_RESULT.company_cd		=	#TABLE_REVIEW_RESULT.company_cd
	AND #TABLE_RESULT.employee_cd		=	#TABLE_REVIEW_RESULT.employee_cd
	)
	--[0]
	IF(@w_language = 2)
	BEGIN
	SELECT
		company_cd			
	,	fiscal_year			
	,	employee_cd	
	,	employee_nm	
	,	CASE
			WHEN sum_evaluation_point IS NOT NULL
			THEN CONCAT(CONVERT(VARCHAR(20),sum_evaluation_point),' Point(s)')	
			ELSE ''	
		END						AS	sum_evaluation_point
	,	CASE
			WHEN num_detail IS NOT NULL
			THEN CONCAT(CONVERT(VARCHAR(20),num_detail),' Review(s)')	
			ELSE ''	
		END						AS	num_detail
	,	FORMAT(cre_datetime,'yyyy/MM/dd HH:mm')		AS cre_datetime
	,	detail_no						
	FROM #TABLE_RESULT
	END
	ELSE
	BEGIN
	SELECT
		company_cd			
	,	fiscal_year			
	,	employee_cd	
	,	employee_nm	
	,	CASE
			WHEN sum_evaluation_point IS NOT NULL
			THEN CONCAT(CONVERT(VARCHAR(20),sum_evaluation_point),'点')	
			ELSE ''	
		END						AS	sum_evaluation_point
	,	CASE
			WHEN num_detail IS NOT NULL
			THEN CONCAT(CONVERT(VARCHAR(20),num_detail),'件')	
			ELSE ''	
		END						AS	num_detail
	,	FORMAT(cre_datetime,'yyyy/MM/dd HH:mm')		AS cre_datetime
	,	detail_no						
	FROM #TABLE_RESULT
	END
	--[1]
	IF @P_screen_flg = 0 --manager
	BEGIN
		IF EXISTS (SELECT 1 FROM F3010 
							WHERE 
								F3010.company_cd	=	@P_company_cd 
							AND F3010.fiscal_year	=	@P_fiscal_year 
							AND F3010.confirm_flg	=	1
							AND F3010.del_datetime IS NULL)
		BEGIN
			SET @w_confirm_flg	=	1
		END
	END
	-- SELECT
	SELECT @w_confirm_flg		AS confirm_flg
	--[2]
	SELECT
		F3900.cre_datetime					AS	cre_datetime
	,	CONCAT(ISNULL(infomation_message,''),' ','(',FORMAT(F3900.cre_datetime,'yyyy/MM/dd HH:mm'),')')	
											AS infomation_message
	FROM F3900
	WHERE
		F3900.company_cd			=	@P_company_cd
	AND	F3900.infomationn_typ		=	3
	AND	F3900.fiscal_year			=	@P_fiscal_year		--add by vietdt 2021/04/15
	AND F3900.employee_cd			=	@P_supporter_cd
	AND F3900.del_datetime IS NULL
	ORDER BY
		F3900.cre_datetime DESC
	-- clean
	DROP TABLE #TABLE_RESULT
	DROP TABLE #TABLE_F3000
	DROP TABLE #TABLE_REVIEW_RESULT
	DROP TABLE #LIST_POSITION
	DROP TABLE #TABLE_ORGANIZATION
END
GO
