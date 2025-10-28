DROP PROCEDURE [SPC_Q2030_FND2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ M0020
-- EXEC SPC_Q2030_INQ1 '2018',1,1,'1'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	Q2030_評価分析
--*  
--*  作成日/create date			:	2018/10/10						
--*　作成者/creater				:	sondh								
--*   					
--*  更新日/update date			:	2022/08/16
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgrade 1.9
--*  更新日/update date			:	2023/06/06
--*　更新者/updater				:　namnt
--*　更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [SPC_Q2030_FND2]
	-- Add the parameters for the stored procedure here	 
	@P_fiscal_year						INT					=	0
,	@P_treatment_applications_no		SMALLINT			=	0
,	@P_evaluation_step					SMALLINT			=	0
,	@P_organization_cd					NVARCHAR(50)			=	0
,	@P_company_cd						SMALLINT			=	0
,	@P_user_id							NVARCHAR(50)		=	''
,	@P_page_size						INT					=   20
,	@P_page								INT					=	1
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								DATE				=	SYSDATETIME()
	,	@ERR_TBL							ERRTABLE
	,	@order_by_min						INT					=	0
	,	@totalRecord						BIGINT				=	0
	,	@pageMax							INT					=	0	
	,	@page_size							INT					=	10
	,	@authority_cd						SMALLINT			=	0
	,	@authority_typ						SMALLINT			=	0
	--	2018/12/20
	,	@beginning_date						DATE				=	NULL
	,	@year_month_day						DATE				=	NULL	
	,	@w_language							SMALLINT			=	1 --1:jp 2:en
	--
	,	@w_evaluation_organization_cnt		INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	,	@arrange_order						INT					=	0
	,	@position_cd						INT					=	0
	,	@choice_in_screen					TINYINT				=	0 
	,	@use_typ							smallint			=	0
	--
	CREATE TABLE #TABLE_ORGANIZATION (
		id						int	identity(1, 1)
	,	organization_typ		tinyint
	,	organization_cd_1		nvarchar(50)
	,	organization_cd_2		nvarchar(50)
	,	organization_cd_3		nvarchar(50)
	,	organization_cd_4		nvarchar(50)
	,	organization_cd_5		nvarchar(50)	
	,	choice_in_screen		tinyint
	)
	--
	CREATE TABLE #LIST_POSITION(
		id								int			identity(1,1)
	,	position_cd						int
	,	mode							smallint	-- 0.choice in screen 1. get from master
	)
	--
	CREATE TABLE #AUTHORITY(
		id								INT		IDENTITY(1,1) 
	,	company_cd						SMALLINT
	,	organization_typ				SMALLINT
	,	organization_cd					NVARCHAR(50)	
	,	employee_cd						NVARCHAR(10)	
	)	

	--
	CREATE TABLE #ORGANIZATION(
		id								INT		IDENTITY(1,1) 
	,	company_cd						SMALLINT
	,	organization_typ				SMALLINT
	,	organization_cd					NVARCHAR(50)	
	)	

	--
	CREATE TABLE #M0070(
		id								INT		IDENTITY(1,1) 
	,	company_cd						SMALLINT
	,	employee_cd						NVARCHAR(10)	
	,	belong_cd1						NVARCHAR(50)	
	)	

	--
	CREATE TABLE #M0020(
		id								INT		IDENTITY(1,1) 
	,	company_cd						SMALLINT
	,	organization_cd					NVARCHAR(50)
	,	employee_cd						NVARCHAR(10)
	)

	--
	CREATE TABLE #MAIN(
		id								INT		IDENTITY(1,1) 
	,	company_cd						SMALLINT
	,	fiscal_year						SMALLINT
	,	treatment_applications_no		SMALLINT
	,	evaluation_step					SMALLINT
	,	employee_cd						NVARCHAR(10)
	,	organization_cd					NVARCHAR(50)
	,	rank_cd							SMALLINT
	)

	--
	CREATE TABLE #GROUP(
		id								INT	IDENTITY(1,1)
	,	company_cd						SMALLINT
	,	group_cd						NVARCHAR(20)
	,	group_nm						NVARCHAR(50)
	,	group_emp						INT
	,	type_chk						INT
	)

	--
	CREATE TABLE #RANK_GROUP(
		id								INT		IDENTITY(1,1)
	,	company_cd						SMALLINT
	,	group_cd						NVARCHAR(20)
	,	rank_cd							SMALLINT
	,	rank_emp						INT
	)

	--
	CREATE TABLE #RANK_TOTAL(
		id								INT		IDENTITY(1,1)
	,	company_cd						SMALLINT
	,	rank_cd							SMALLINT
	,	emp								INT
	)

	--
	CREATE TABLE #RANK(
		id								INT		IDENTITY(1,1)
	,	company_cd						SMALLINT
	,	rank_cd							SMALLINT		
	,	rank_nm							NVARCHAR(10)
	)

	--
	CREATE TABLE #GROUP_DATA(
		id								INT	IDENTITY(1,1)
	,	company_cd						SMALLINT
	,	group_cd						NVARCHAR(20)
	,	group_nm						NVARCHAR(50)
	,	group_emp						INT
	,	type_chk						INT
	)
	--
	CREATE TABLE #M0070H(
		application_date				DATE
	,	company_cd						SMALLINT
	,	employee_cd						NVARCHAR(10)
	,	employee_nm						NVARCHAR(200)
	,	employee_ab_nm					NVARCHAR(50)
	,	furigana						NVARCHAR(50)
	,	office_cd						SMALLINT
	,	office_nm						NVARCHAR(50)
	,	belong_cd1						NVARCHAR(50)				
	,	belong_cd2						NVARCHAR(50)
	,	belong_cd3						NVARCHAR(50)
	,	belong_cd4						NVARCHAR(50)
	,	belong_cd5						NVARCHAR(50)				
	,	job_cd							SMALLINT
	,	position_cd						INT
	,	employee_typ					SMALLINT
	,	grade							SMALLINT
	,	belong_nm1						NVARCHAR(50)
	,	belong_nm2						NVARCHAR(50)
	,	belong_nm3						NVARCHAR(50)
	,	belong_nm4						NVARCHAR(50)
	,	belong_nm5						NVARCHAR(50)
	,	job_nm							NVARCHAR(50)
	,	position_nm						NVARCHAR(50)
	,	grade_nm						NVARCHAR(10)
	,	employee_typ_nm					NVARCHAR(50)
	)
	--GET DATA
	SELECT
		@authority_cd	=	ISNULL(S0010.authority_cd,0)	
	,	@authority_typ	=	ISNULL(S0010.authority_typ,0)
	,	@w_language		=	ISNULL(S0010.language,1)
	FROM S0010 LEFT JOIN M0070 ON(
		M0070.company_cd		=	S0010.company_cd
	AND M0070.employee_cd		=	S0010.employee_cd
	)
	WHERE 
		S0010.company_cd		=	@P_company_cd
	AND S0010.[user_id]			=	@P_user_id
	--↓↓↓ add by viettd 2022/08/16
	IF @authority_typ = 6
	BEGIN
	SET @authority_typ = 2 -- 評価者
	END
	-- COUNT ALL ORGANIZATIONS OF S0022 -- add by viettd 2021/06/03
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@authority_cd,1)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@authority_cd,1)
	--
	SET @arrange_order	= ISNULL((
		SELECT ISNULL(M0040.arrange_order,0)
		FROM M0040
		WHERE M0040.del_datetime IS NULL AND M0040.position_cd = @position_cd AND M0040.company_cd = @P_company_cd)
	,0)
	-- get @use_typ
	SELECT 
		@use_typ		=	ISNULL(S0020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
	FROM S0020
	WHERE
		S0020.company_cd		=	@P_company_cd
	AND S0020.authority_cd		=	@authority_cd
	AND S0020.del_datetime IS NULL
	--↑↑↑ end add by viettd 2022/08/16
	--START 2018/12/20
	SELECT 
		@beginning_date = M9100.beginning_date 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	--
	IF @beginning_date IS NOT NULL
	BEGIN
		SET @year_month_day = CAST((CAST(@P_fiscal_year AS NVARCHAR(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		SET @year_month_day = DATEADD(DD,-1,DATEADD(YYYY,1,@year_month_day))
	END
	ELSE
	BEGIN 
		SET @year_month_day = CAST((CAST(@P_fiscal_year AS NVARCHAR(4)) + '/12/31') AS DATE)
	END
	--GET DATA EMPLOYEE
	INSERT INTO #M0070H 
	EXECUTE [dbo].[SPC_REFER_M0070H_INQ1] @year_month_day,'',@P_company_cd
	-- GET #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 '',@P_user_id,@P_company_cd
	-- GET #LIST_POSITION
	IF NOT EXISTS (SELECT 1 FROM #LIST_POSITION)
	BEGIN
		-- 本人の役職より下位の社員のみ
		IF @use_typ = 1
		BEGIN
			INSERT INTO #LIST_POSITION
			SELECT 
				ISNULL(M0040.position_cd,0)				AS	position_cd
			,	1
			FROM M0040
			WHERE 
				M0040.company_cd		=	@P_company_cd
			AND M0040.arrange_order		>	@arrange_order		-- 1.本人の役職より下位の社員のみ
			AND M0040.del_datetime IS NULL
		END
		ELSE
		BEGIN
			INSERT INTO #LIST_POSITION
			SELECT 
				ISNULL(M0040.position_cd,0)				AS	position_cd
			,	1
			FROM M0040
			WHERE 
				M0040.company_cd		=	@P_company_cd
			AND M0040.del_datetime IS NULL
		END
	END
	-- FILTER 
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
	BEGIN
		SET @choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
		-- 1.choice in screen
		IF @choice_in_screen = 1
		BEGIN
			DELETE D FROM #M0070H AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
			    D.belong_cd1			=	S.organization_cd_1
			AND D.belong_cd2			=	S.organization_cd_2
			AND D.belong_cd3			=	S.organization_cd_3
			AND D.belong_cd4			=	S.organization_cd_4
			AND D.belong_cd5			=	S.organization_cd_5
			)
			WHERE 
				D.company_cd IS NULL
			OR	S.organization_typ IS NULL
		END
		ELSE IF NOT (@authority_typ = 3 AND @w_evaluation_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)	-- edited by viettd 2021/06/03
		BEGIN
			DELETE D FROM #M0070H AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.belong_cd1			=	S.organization_cd_1
			AND D.belong_cd2			=	S.organization_cd_2
			AND D.belong_cd3			=	S.organization_cd_3
			AND D.belong_cd4			=	S.organization_cd_4
			AND D.belong_cd5			=	S.organization_cd_5
			)
			WHERE 
				D.company_cd IS NULL
			OR	S.organization_typ IS NULL
			AND @authority_typ NOT IN(4,5) --4.会社管理者 5.総合管理者
		END
	END
	-- choice in screen
	IF EXISTS (SELECT 1 FROM #LIST_POSITION WHERE mode = 0)
	BEGIN
		DELETE D FROM #M0070H AS D
		LEFT OUTER JOIN #LIST_POSITION AS S ON (
			D.company_cd			=	@P_company_cd
		AND D.position_cd			=	S.position_cd
		)
		WHERE
			S.position_cd IS NULL
	END
	ELSE -- not choice in screen
	BEGIN
		IF @authority_typ NOT IN (4,5)
		BEGIN
			DELETE D FROM #M0070H AS D
			LEFT OUTER JOIN #LIST_POSITION AS S ON (
				D.company_cd		=	@P_company_cd
			AND D.position_cd		=	S.position_cd
			)
			WHERE
				S.position_cd IS NULL
		END
	END
	--END 2018/12/20
	IF @authority_typ IN (3,4,5) -- 管理会社		--CR 2018/11/28
	BEGIN
		INSERT INTO #AUTHORITY
		SELECT 
			@P_company_cd	
		,	ISNULL(M0020.organization_typ,0)
		,	ISNULL(M0020.organization_cd_1,0)
		,	ISNULL(#M0070H.employee_cd,'')
		FROM M0020 WITH(NOLOCK)
		LEFT JOIN #M0070H ON (
			M0020.company_cd			=	#M0070H.company_cd		
		AND M0020.organization_cd_1		=	#M0070H.belong_cd1
		AND M0020.organization_typ		=	1
		)
		WHERE 
			M0020.company_cd		=	@P_company_cd
		AND M0020.organization_typ	=	1
		AND	M0020.del_datetime IS NULL
		ORDER BY 
			M0020.arrange_order
		,	M0020.organization_cd_1	
	END
	ELSE IF @authority_typ IN (1,2)
	BEGIN
		INSERT INTO #AUTHORITY
		SELECT 
			@P_company_cd	
		,	ISNULL(M0020.organization_typ,0)
		,	ISNULL(M0020.organization_cd_1,0)
		,	ISNULL(#M0070H.employee_cd,'')
		FROM #M0070H
		LEFT OUTER JOIN M0020 ON (
			#M0070H.company_cd			=	M0020.company_cd
		AND 1							=	M0020.organization_typ
		AND #M0070H.belong_cd1			=	M0020.organization_cd_1
		)
		WHERE 
			#M0070H.company_cd			=	@P_company_cd
		AND #M0070H.employee_cd			=	@P_user_id
	END
	-- insert into #M0070
	IF @P_evaluation_step = 5
	BEGIN
		INSERT INTO #M0070
		SELECT 
			#M0070H.company_cd
		,	#M0070H.employee_cd
		,	#M0070H.belong_cd1
		FROM #M0070H
		INNER JOIN #AUTHORITY ON (
			#M0070H.company_cd				=	#AUTHORITY.company_cd
		AND #M0070H.employee_cd				=	#AUTHORITY.employee_cd
		AND #M0070H.belong_cd1				=	#AUTHORITY.organization_cd
		)
		INNER JOIN F0201 ON (
			#M0070H.company_cd				=	F0201.company_cd
		AND F0201.fiscal_year				=	@P_fiscal_year
		AND #M0070H.employee_cd				=	F0201.employee_cd
		AND F0201.treatment_applications_no	=	@P_treatment_applications_no
		AND F0201.del_datetime IS NULL
		AND F0201.confirm_datetime IS NOT NULL
		)
		WHERE
			#M0070H.company_cd = @P_company_cd	
	END
	ELSE
	BEGIN
		INSERT INTO #M0070
		SELECT 
			#M0070H.company_cd
		,	#M0070H.employee_cd
		,	#M0070H.belong_cd1
		FROM #M0070H
		INNER JOIN #AUTHORITY ON (
			#M0070H.company_cd				=	#AUTHORITY.company_cd
		AND #M0070H.employee_cd				=	#AUTHORITY.employee_cd
		AND #M0070H.belong_cd1				=	#AUTHORITY.organization_cd
		)
		WHERE
			#M0070H.company_cd = @P_company_cd	
	END
	--
	INSERT INTO #ORGANIZATION
	SELECT DISTINCT
		@P_company_cd
	,	#TABLE_ORGANIZATION.organization_typ
	,	#TABLE_ORGANIZATION.organization_cd_1
	FROM #TABLE_ORGANIZATION
	--
	INSERT INTO #M0020
	SELECT
		ISNULL(#ORGANIZATION.company_cd,0)
	,	ISNULL(#ORGANIZATION.organization_cd,0)
	,	ISNULL(#M0070.employee_cd,'')
	FROM #ORGANIZATION
	INNER JOIN M0020 ON (
		#ORGANIZATION.company_cd		=	M0020.company_cd
	AND #ORGANIZATION.organization_typ	=	M0020.organization_typ
	AND #ORGANIZATION.organization_cd	=	M0020.organization_cd_1
	)
	LEFT JOIN #M0070 ON (
		#ORGANIZATION.company_cd		=	#M0070.company_cd
	AND #ORGANIZATION.organization_cd	=	#M0070.belong_cd1
	)
	WHERE 
		M0020.organization_typ	=	1
	AND M0020.del_datetime IS NULL
	ORDER BY
		M0020.arrange_order
	,	M0020.organization_cd_1	
	--
	IF (@P_evaluation_step = 5)
	BEGIN
		--
		INSERT INTO #MAIN
		SELECT
			#M0020.company_cd
		,	@P_fiscal_year
		,	@P_treatment_applications_no
		,	@P_evaluation_step
		,	#M0020.employee_cd
		,	#M0020.organization_cd
		,	ISNULL(F0201.rank_cd,0)
		FROM #M0020 
		LEFT JOIN F0201 ON (
			#M0020.company_cd					=	F0201.company_cd
		AND F0201.fiscal_year					=	@P_fiscal_year
		AND #M0020.employee_cd					=	F0201.employee_cd
		AND F0201.treatment_applications_no		=	@P_treatment_applications_no
		AND F0201.del_datetime IS NULL
		)
		WHERE 
			(@P_organization_cd = -1 OR (#M0020.organization_cd = @P_organization_cd))
	END
	ELSE 
	BEGIN
		--
		INSERT INTO #MAIN
		SELECT
			#M0020.company_cd
		,	@P_fiscal_year
		,	@P_treatment_applications_no
		,	@P_evaluation_step
		,	#M0020.employee_cd
		,	#M0020.organization_cd
		,	ISNULL(F0200.rank_cd,0)
		FROM #M0020 
		LEFT JOIN F0200 ON (
			#M0020.company_cd					=	F0200.company_cd
		AND @P_fiscal_year						=	F0200.fiscal_year
		AND #M0020.employee_cd					=	F0200.employee_cd
		AND F0200.treatment_applications_no		=	@P_treatment_applications_no
		AND F0200.evaluation_step				=	@P_evaluation_step
		AND F0200.del_datetime IS NULL
		)
		WHERE 
			(@P_organization_cd = -1 OR (#M0020.organization_cd = @P_organization_cd))
	END
	--
	UPDATE #MAIN SET 
		rank_cd = 0
	FROM #MAIN
	LEFT JOIN M0130 ON (
		#MAIN.company_cd					=	M0130.company_cd
	AND #MAIN.rank_cd						=	M0130.rank_cd
	AND M0130.treatment_applications_no     =	@P_treatment_applications_no
	AND M0130.del_datetime IS NULL
	)
	WHERE
		M0130.rank_cd IS NULL
	--
	INSERT INTO #GROUP_DATA
	SELECT
		#MAIN.company_cd
	,	#MAIN.organization_cd
	,	ISNULL(M0020.organization_nm,'')
	,	SUM(IIF(rank_cd <> 0 AND employee_cd <> '',1,0))
	,	1							--using group
	FROM #MAIN
	LEFT JOIN M0020 ON (
		#MAIN.company_cd		=	M0020.company_cd
	AND #MAIN.organization_cd	=	M0020.organization_cd_1
	AND M0020.organization_typ	=	1
	AND M0020.del_datetime IS NULL
	)
	GROUP BY
		#MAIN.company_cd
	,	#MAIN.organization_cd
	,	M0020.organization_nm
	,	M0020.arrange_order
	ORDER BY
		M0020.arrange_order
	--
	SET @totalRecord	= (SELECT COUNT(1) FROM #GROUP_DATA)
	SET @pageMax		= CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	IF @pageMax			= 0
	BEGIN
		SET @pageMax	= 1
	END
	IF @P_page > @pageMax
	BEGIN
		SET @P_page = @pageMax
	END
	
	--
	INSERT INTO #GROUP
	SELECT
		#GROUP_DATA.company_cd
	,	#GROUP_DATA.group_cd
	,	ISNULL(#GROUP_DATA.group_nm,'')
	,	#GROUP_DATA.group_emp
	,	1							--using group
	FROM #GROUP_DATA
	ORDER BY 
		#GROUP_DATA.id
	offset (@P_page - 1) * @P_page_size rows
	fetch next @P_page_size rows only
	
	--
	INSERT INTO #RANK_GROUP
	SELECT 
		#MAIN.company_cd
	,	#MAIN.organization_cd		
	,	#MAIN.rank_cd
	,	SUM(IIF(rank_cd <> 0 AND employee_cd <> '',1,0))	AS total_rank		
	FROM #MAIN
	INNER JOIN #GROUP ON (
		#MAIN.company_cd			=	#GROUP.company_cd
	AND #MAIN.organization_cd		=	#GROUP.group_cd
	)
	GROUP BY 
		#MAIN.company_cd
	,	#MAIN.organization_cd	
	,	#MAIN.rank_cd
	ORDER BY 
		organization_cd	

	--
	INSERT INTO #RANK_TOTAL
	SELECT
		#MAIN.company_cd
	,	#MAIN.rank_cd
	,	SUM(IIF(rank_cd <> 0 AND employee_cd <> '',1,0))
	FROM #MAIN
	INNER JOIN #GROUP ON (
		#MAIN.company_cd			=	#GROUP.company_cd
	AND #MAIN.organization_cd		=	#GROUP.group_cd
	)
	GROUP BY
		#MAIN.company_cd
	,	#MAIN.rank_cd

	--
	INSERT INTO #GROUP
	SELECT
		#MAIN.company_cd
	,	0
	,	IIF(@w_language = 2,'Percentage Of Total','全体の割合')
	,	SUM(IIF(rank_cd <> 0 AND employee_cd <> '',1,0))
	,	2					--using total
	FROM #MAIN
	INNER JOIN #GROUP ON (
		#MAIN.company_cd			=	#GROUP.company_cd
	AND #MAIN.organization_cd		=	#GROUP.group_cd
	)
	GROUP BY
		#MAIN.company_cd

	--
	INSERT INTO #RANK
	SELECT 
		ISNULL(company_cd,0)
	,	ISNULL(rank_cd,0)
	,	ISNULL(rank_nm,'')
	FROM M0130
	WHERE 
		company_cd	=	@P_company_cd
	AND M0130.treatment_applications_no       = @P_treatment_applications_no
	AND del_datetime IS NULL
	--END GET DATA
	--[0]
	SELECT
		ISNULL(group_cd,0)							AS group_cd
	,	ISNULL(group_nm,'')							AS group_nm
	,	CONCAT(#GROUP.group_emp,IIF(@w_language = 2,' Person(s)','人'))				AS group_emp
	,	#GROUP.type_chk
	FROM #GROUP
	ORDER BY 
		#GROUP.type_chk
	,	#GROUP.id

	--[1]
	SELECT 
		#GROUP.company_cd
	,	#GROUP.group_cd
	,	#GROUP.group_nm
	,	#RANK.rank_cd		
	,	ISNULL(#RANK_GROUP.rank_emp,0)																AS rank_emp
	,	ISNULL(FLOOR(ROUND(((CAST(#RANK_GROUP.rank_emp AS NUMERIC(5,1))
					/CAST(#GROUP.group_emp AS NUMERIC(5,1))) * 100), 0)
			  ),0)																					AS tl_group
	,	CONCAT(ISNULL(#RANK_GROUP.rank_emp,0),
				IIF(@w_language = 2,' Person(s)','人'),'(',
				FLOOR(ROUND(((CAST(#RANK_GROUP.rank_emp AS NUMERIC(5,1))
							/CAST(#GROUP.group_emp AS NUMERIC(5,1))) * 100), 0)),'%)'
				)																					AS result
	FROM #GROUP
	CROSS JOIN #RANK
	LEFT JOIN #RANK_GROUP ON (
		#GROUP.company_cd		=	#RANK_GROUP.company_cd
	AND #GROUP.group_cd			=	#RANK_GROUP.group_cd
	AND #RANK.rank_cd			=	#RANK_GROUP.rank_cd
	)
	WHERE 
		#GROUP.type_chk = 1
	ORDER BY 
		#GROUP.id
	,	#RANK.rank_cd

	--[2]
	SELECT 
		#RANK.company_cd
	,	ISNULL(#RANK.rank_cd,0)																		AS rank_cd
	,	ISNULL(#RANK_TOTAL.emp,0)																	AS emp
	,	ISNULL(FLOOR(ROUND(((CAST(#RANK_TOTAL.emp AS NUMERIC(5,1))
				/CAST(#GROUP.group_emp AS NUMERIC(5,1))) * 100), 0)
			  ),0)																					AS tl_total
	,	CONCAT(ISNULL(#RANK_TOTAL.emp,0),
				IIF(@w_language = 2,' Person(s)','人'),'(',
				ISNULL(FLOOR(ROUND(((CAST(#RANK_TOTAL.emp AS NUMERIC(5,1))
							/CAST(#GROUP.group_emp AS NUMERIC(5,1))) * 100), 0)),0),'%)'
				)																					AS result
	FROM #RANK
	LEFT JOIN #RANK_TOTAL ON (
		#RANK.company_cd	=	#RANK_TOTAL.company_cd
	AND #RANK.rank_cd		=	#RANK_TOTAL.rank_cd
	)
	LEFT JOIN #GROUP ON (
		#RANK.company_cd = #GROUP.company_cd
	AND #GROUP.type_chk= 2
	)

	--[3]
	SELECT	
		@totalRecord	AS totalRecord
	,	@pageMax		AS pageMax
	,	@P_page			AS page
	,	@P_page_size	AS pagesize
	,	((@P_page - 1) * @P_page_size + 1) AS offset
	
	--[4]
	SELECT 
		ISNULL(company_cd,0)		AS company_cd
	,	ISNULL(rank_cd,0)			AS rank_cd
	,	ISNULL(rank_nm,'')			AS rank_nm
	FROM M0130
	WHERE 
		company_cd	=	@P_company_cd
	AND M0130.treatment_applications_no       = @P_treatment_applications_no
	AND del_datetime IS NULL
	--CLEAR TABLE TEMP
	DROP TABLE #GROUP
	DROP TABLE #GROUP_DATA
	DROP TABLE #M0020
	DROP TABLE #MAIN
	DROP TABLE #RANK
	DROP TABLE #RANK_GROUP
	DROP TABLE #RANK_TOTAL
	DROP TABLE #AUTHORITY
	DROP TABLE #M0070
	DROP TABLE #M0070H
	DROP TABLE #ORGANIZATION
	DROP TABLE #LIST_POSITION
	DROP TABLE #TABLE_ORGANIZATION
END
GO