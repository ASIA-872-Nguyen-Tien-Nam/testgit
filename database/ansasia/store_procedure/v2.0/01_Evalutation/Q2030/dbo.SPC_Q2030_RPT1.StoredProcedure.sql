DROP PROCEDURE [SPC_Q2030_RPT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ M0020
-- EXEC SPC_Q2030_INQ2 '2017','1','1','1',2,1,'1','20','1';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	Q2030_評価分析
--*  
--*  作成日/create date			:	2018/10/12						
--*　作成者/creater				:	sondh								
--*   					
--*  更新日/update date			:	2022/08/16
--*　更新者/updater				:　 viettd
--*　更新内容/update content		:	upgrade 1.9
--****************************************************************************************
CREATE PROCEDURE [SPC_Q2030_RPT1]
	-- Add the parameters for the stored procedure here	
	@P_fiscal_year						INT					=	0
,	@P_treatment_applications_no		SMALLINT			=	0
,	@P_evaluation_step					SMALLINT			=	0
,	@P_select_target_1					SMALLINT			=	0
,	@P_organization_cd					NVARCHAR(50)			=	''
,	@P_unit_display						NVARCHAR(50)			=	''
,	@P_rank_cd							SMALLINT			=	0
,	@P_company_cd						SMALLINT			=	0
,	@P_user_id							NVARCHAR(50)		=	''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								DATE				=	SYSDATETIME()
	,	@ERR_TBL							ERRTABLE
	,	@order_by_min						INT					=	0
	,	@authority_cd						SMALLINT			=	0
	,	@authority_typ						SMALLINT			=	0
	--	2018/12/20
	,	@beginning_date						DATE				=	NULL
	,	@year_month_day						DATE				=	NULL	
	,	@str_header							NVARCHAR(MAX)		=	''
	,	@str_exce							NVARCHAR(MAX)		=	''
	,	@w_language							SMALLINT			=	1 --1:jp 2:en
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
	CREATE TABLE #RESULT(
		id								INT IDENTITY(1,1)
	,	employee_cd						NVARCHAR(20)
	,	employee_nm						NVARCHAR(200)
	,	employee_typ_nm					NVARCHAR(50)
	,	[1]								NVARCHAR(50)
	,	[2]								NVARCHAR(50)
	,	[3]								NVARCHAR(50)
	,	[4]								NVARCHAR(50)
	,	[5]								NVARCHAR(50)
	,	job_nm							NVARCHAR(50)
	,	grade_nm						NVARCHAR(50)
	,	rank_nm							NVARCHAR(20)
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
	CREATE TABLE #MAIN(
		id								INT		IDENTITY(1,1) 
	,	company_cd						SMALLINT
	,	fiscal_year						SMALLINT
	,	group_cd						SMALLINT
	,	treatment_applications_no		SMALLINT
	,	evaluation_step					SMALLINT
	,	employee_cd						NVARCHAR(10)
	,	rank_cd							SMALLINT
	,	belong_cd1						NVARCHAR(50)
	,	belong_cd2						NVARCHAR(50)
	,	job_cd							SMALLINT
	,	employee_typ					SMALLINT
	,	grade							SMALLINT
	,	sheet_cd						SMALLINT		-- add by viettd 2022/08/16
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
	,	belong_cd1						NVARCHAR(50)				--department_cd
	,	belong_cd2						NVARCHAR(50)				--team_cd
	,	belong_cd3						NVARCHAR(50)				--team_cd
	,	belong_cd4						NVARCHAR(50)				--team_cd
	,	belong_cd5						NVARCHAR(50)				--team_cd
	,	job_cd							SMALLINT
	,	position_cd						INT
	,	employee_typ					SMALLINT
	,	grade							SMALLINT
	,	organization_nm1				NVARCHAR(50)
	,	organization_nm2				NVARCHAR(50)
	,	organization_nm3				NVARCHAR(50)
	,	organization_nm4				NVARCHAR(50)
	,	organization_nm5				NVARCHAR(50)
	,	job_nm							NVARCHAR(50)
	,	position_nm						NVARCHAR(50)
	,	grade_nm						NVARCHAR(10)
	,	employee_typ_nm					NVARCHAR(50)
	)
	--
	CREATE TABLE #M0071_SHEET(
		company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	fiscal_year						int
	,	sheet_cd						smallint
	,	application_date				date
	,	employee_nm						nvarchar(200)
	,	employee_ab_nm					nvarchar(50)
	,	furigana						nvarchar(50)
	,	office_cd						smallint
	,	office_nm						nvarchar(50)
	,	belong_cd1						nvarchar(20)
	,	belong_cd2						nvarchar(20)
	,	belong_cd3						nvarchar(20)
	,	belong_cd4						nvarchar(20)
	,	belong_cd5						nvarchar(20)
	,	job_cd							smallint
	,	position_cd						int
	,	employee_typ					smallint
	,	grade							smallint
	,	belong_nm1						nvarchar(50)
	,	belong_nm2						nvarchar(50)
	,	belong_nm3						nvarchar(50)
	,	belong_nm4						nvarchar(50)
	,	belong_nm5						nvarchar(50)
	,	job_nm							nvarchar(50)
	,	position_nm						nvarchar(50)
	,	grade_nm						nvarchar(10)
	,	employee_typ_nm					nvarchar(50)
	)
	SET @str_header = (
		SELECT STUFF((SELECT ',[' + CAST(organization_typ AS nvarchar(20))+']' FROM M0022 WHERE  company_cd =@P_company_cd AND del_datetime IS NULL and use_typ = 1 FOR XML PATH ('')), 1, 1, '' ) 
	)
	--
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
	--
	INSERT INTO #M0071_SHEET
	EXEC [dbo].SPC_REFER_M0071_INQ1 @P_fiscal_year,'',0,@P_company_cd
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
	--
	IF @authority_typ IN (3,4,5) -- 管理会社			--CR 2018/11/28
	BEGIN
		--
		IF(@P_select_target_1 = 2)
		BEGIN
			INSERT INTO #AUTHORITY
			SELECT 
				@P_company_cd	
			,	ISNULL(M0020.organization_typ,0)
			,	ISNULL(M0020.organization_cd_1,'')
			,	ISNULL(#M0070H.employee_cd,'')
			FROM M0020 WITH(NOLOCK)
			LEFT JOIN #M0070H ON (
				M0020.company_cd			=	#M0070H.company_cd
			AND M0020.organization_cd_1		=	#M0070H.belong_cd1
			)
			WHERE 
				(M0020.company_cd		= @P_company_cd)
			AND	(M0020.organization_typ = 1)
			AND	(M0020.del_datetime IS NULL)
		END
		ELSE
		BEGIN
			INSERT INTO #AUTHORITY
			SELECT 
				@P_company_cd	
			,	ISNULL(M0020.organization_typ,0)
			,	ISNULL(M0020.organization_cd_1,'')
			,	ISNULL(#M0070H.employee_cd,'')
			FROM #M0070H WITH(NOLOCK)
			LEFT JOIN M0020 ON (
				#M0070H.company_cd		=	M0020.company_cd		
			AND #M0070H.belong_cd1		=	M0020.organization_cd_1
			AND M0020.organization_typ	=	1
			AND	M0020.del_datetime IS NULL
			)
			WHERE 
				#M0070H.company_cd	= @P_company_cd
			ORDER BY 
				M0020.arrange_order
			,	M0020.organization_cd_1	
		END
	END
	ELSE IF @authority_typ IN (1,2)
	BEGIN
		--
		INSERT INTO #AUTHORITY
		SELECT 
			@P_company_cd	
		,	ISNULL(M0020.organization_typ,0)
		,	ISNULL(M0020.organization_cd_1,'')
		,	ISNULL(M0070.employee_cd,'')
		FROM M0070
		LEFT OUTER JOIN M0020 ON (
			M0070.company_cd			=	M0020.company_cd
		AND 1							=	M0020.organization_typ
		AND M0070.belong_cd1			=	M0020.organization_cd_1
		)
		WHERE 
			M0070.company_cd			=	@P_company_cd
		AND M0070.employee_cd			=	@P_user_id
	END
	--
	IF (@P_evaluation_step = 5)
	BEGIN
		--
		INSERT INTO #MAIN
		SELECT 
			ISNULL(F0201.company_cd,0)						
		,	ISNULL(F0201.fiscal_year,0)						
		,	ISNULL(F0030.group_cd,0)
		,	ISNULL(F0201.treatment_applications_no,0)
		,	@P_evaluation_step
		,	ISNULL(F0201.employee_cd,'')
		,	ISNULL(F0201.rank_cd,0)						
		,	ISNULL(#M0070H.belong_cd1,0)
		,	ISNULL(#M0070H.belong_cd2,0)
		,	ISNULL(#M0070H.job_cd,0)
		,	ISNULL(#M0070H.employee_typ,0)
		,	ISNULL(#M0070H.grade,0)
		,	ISNULL(F0032_SHEET_MAX.sheet_cd,0)
		FROM F0201
		LEFT JOIN F0030 ON (
			F0201.company_cd				=	F0030.company_cd
		AND F0201.fiscal_year				=	F0030.fiscal_year
		AND F0201.employee_cd				=	F0030.employee_cd
		AND F0201.treatment_applications_no	=	F0030.treatment_applications_no
		AND F0030.del_datetime IS NULL
		)
		INNER JOIN #AUTHORITY ON (
			F0201.company_cd		=	#AUTHORITY.company_cd
		AND F0201.employee_cd		=	#AUTHORITY.employee_cd
		)
		LEFT OUTER JOIN (
			SELECT 
				ISNULL(F0032.company_cd,0)						AS	company_cd
			,	ISNULL(F0032.fiscal_year,0)						AS	fiscal_year
			,	ISNULL(F0032.employee_cd,0)						AS	employee_cd
			,	ISNULL(F0032.treatment_applications_no,0)		AS	treatment_applications_no
			,	MAX(F0032.sheet_cd)								AS	sheet_cd
			FROM F0032
			WHERE 
				F0032.company_cd		=	@P_company_cd
			AND F0032.fiscal_year		=	@P_fiscal_year
			AND F0032.del_datetime IS NULL
			GROUP BY
				F0032.company_cd
			,	F0032.fiscal_year
			,	F0032.employee_cd
			,	F0032.treatment_applications_no
		) AS F0032_SHEET_MAX ON (
			F0030.company_cd					=	F0032_SHEET_MAX.company_cd
		AND F0030.fiscal_year					=	F0032_SHEET_MAX.fiscal_year
		AND F0030.employee_cd					=	F0032_SHEET_MAX.employee_cd
		AND F0030.treatment_applications_no		=	F0032_SHEET_MAX.treatment_applications_no
		)
		LEFT OUTER JOIN #M0070H ON (
			F0032_SHEET_MAX.company_cd			=	#M0070H.company_cd
		AND F0032_SHEET_MAX.employee_cd			=	#M0070H.employee_cd
		)
		WHERE 
			F0201.company_cd				=	@P_company_cd
		AND F0201.fiscal_year				=	@P_fiscal_year
		AND F0201.treatment_applications_no =	@P_treatment_applications_no
		AND F0201.rank_cd					=	@P_rank_cd
		AND F0201.confirm_datetime IS NOT NULL
		AND F0201.del_datetime IS NULL
		AND (@P_unit_display = (CASE 
									WHEN @P_select_target_1 = 1 
										THEN CAST(F0030.group_cd AS nvarchar(50))
									WHEN @P_select_target_1 = 2
										THEN #M0070H.belong_cd1 
									WHEN @P_select_target_1 = 3
										THEN  CAST(#M0070H.job_cd AS nvarchar(50))
									ELSE CAST(#M0070H.grade AS nvarchar(50))
								END
							   )
			 )
		AND ((@P_select_target_1 = 2 AND (@P_organization_cd ='-1' OR (#M0070H.belong_cd1 = @P_organization_cd))) OR @P_select_target_1 <> 2)
		ORDER BY 
			F0030.group_cd
	END
	ELSE
	BEGIN
		--
		INSERT INTO #MAIN
		SELECT 
			ISNULL(F0200.company_cd,0)						
		,	ISNULL(F0200.fiscal_year,0)						
		,	ISNULL(F0030.group_cd,0)
		,	ISNULL(F0200.treatment_applications_no,0)
		,	ISNULL(F0200.evaluation_step,0)
		,	ISNULL(F0200.employee_cd,'')
		,	ISNULL(F0200.rank_cd,0)						
		,	ISNULL(#M0070H.belong_cd1,'')
		,	ISNULL(#M0070H.belong_cd2,'')
		,	ISNULL(#M0070H.job_cd,0)
		,	ISNULL(#M0070H.employee_typ,0)
		,	ISNULL(#M0070H.grade,0)
		,	ISNULL(F0032_SHEET_MAX.sheet_cd,0)
		FROM F0200
		LEFT JOIN F0030 ON (
			F0200.company_cd		=	F0030.company_cd
		AND F0200.fiscal_year		=	F0030.fiscal_year
		AND F0200.employee_cd		=	F0030.employee_cd
		AND F0200.treatment_applications_no	=	F0030.treatment_applications_no
		AND F0030.del_datetime IS NULL
		)
		INNER JOIN #AUTHORITY ON (
			F0200.company_cd		=	#AUTHORITY.company_cd
		AND F0200.employee_cd		=	#AUTHORITY.employee_cd
		)
		LEFT OUTER JOIN (
			SELECT 
				ISNULL(F0032.company_cd,0)						AS	company_cd
			,	ISNULL(F0032.fiscal_year,0)						AS	fiscal_year
			,	ISNULL(F0032.employee_cd,0)						AS	employee_cd
			,	ISNULL(F0032.treatment_applications_no,0)		AS	treatment_applications_no
			,	MAX(F0032.sheet_cd)								AS	sheet_cd
			FROM F0032
			WHERE 
				F0032.company_cd		=	@P_company_cd
			AND F0032.fiscal_year		=	@P_fiscal_year
			AND F0032.del_datetime IS NULL
			GROUP BY
				F0032.company_cd
			,	F0032.fiscal_year
			,	F0032.employee_cd
			,	F0032.treatment_applications_no
		) AS F0032_SHEET_MAX ON (
			F0030.company_cd					=	F0032_SHEET_MAX.company_cd
		AND F0030.fiscal_year					=	F0032_SHEET_MAX.fiscal_year
		AND F0030.employee_cd					=	F0032_SHEET_MAX.employee_cd
		AND F0030.treatment_applications_no		=	F0032_SHEET_MAX.treatment_applications_no
		)
		LEFT OUTER JOIN #M0070H ON (
			F0032_SHEET_MAX.company_cd			=	#M0070H.company_cd
		AND F0032_SHEET_MAX.employee_cd			=	#M0070H.employee_cd
		)
		WHERE 
			F0200.company_cd	=	@P_company_cd
		AND F0200.del_datetime IS NULL
		AND (F0200.fiscal_year = @P_fiscal_year)
		AND (F0200.treatment_applications_no = @P_treatment_applications_no)
		AND (F0200.evaluation_step = @P_evaluation_step)
		AND F0200.rank_cd = @P_rank_cd
		AND (@P_unit_display = (CASE 
									WHEN @P_select_target_1 = 1 
										THEN CAST(F0030.group_cd AS nvarchar(50))
									WHEN @P_select_target_1 = 2
										THEN #M0070H.belong_cd1 
									WHEN @P_select_target_1 = 3
										THEN  CAST(#M0070H.job_cd AS nvarchar(50))
									ELSE CAST(#M0070H.grade AS nvarchar(50))
								END
							   )
			 )
		AND ((@P_select_target_1 = 2 AND (@P_organization_cd = '-1' OR (#M0070H.belong_cd1 = @P_organization_cd))) OR @P_select_target_1 <> 2)
		ORDER BY 
			F0030.group_cd
	END

	--
	INSERT INTO #RESULT
	SELECT
		IIF(@w_language = 2,'Employee Number','社員番号')
	,	IIF(@w_language = 2,'Employee Name','社員名')
	,	IIF(@w_language = 2,'Employee Classification','社員区分')
	,	[1]						--	belong_cd1_nm	
	,	[2]						--	belong_cd2_nm	
	,	[3]						--	belong_cd3_nm	
	,	[4]						--	belong_cd4_nm	
	,	[5]						--	belong_cd5_nm	
	,	IIF(@w_language = 2,'Job Title','職種')
	,	IIF(@w_language = 2,'Rank','等級')
	,	IIF(@w_language = 2,'Settled Rank','決定評語')
	FROM(
		SELECT 
		[1], [2], [3], [4], [5]  
		FROM  
		(SELECT M0022.organization_typ, M0022.organization_group_nm   
			FROM M0022 WHERE	company_cd = @P_company_cd 
							AND del_datetime IS NULL 
							AND use_typ = 1  
		) AS SourceTable  
		PIVOT  
		(  
		MAX(organization_group_nm)  
		FOR organization_typ IN ([1], [2], [3], [4], [5])  
		) AS PivotTable 
	) AS #M0022
	--
	INSERT INTO #RESULT
	SELECT 
		#MAIN.employee_cd										AS employee_cd
	,	ISNULL(#M0071_SHEET.employee_nm,'')						AS employee_nm
	,	ISNULL(#M0071_SHEET.employee_typ_nm,'')					AS employee_typ_nm
	,	CASE
			WHEN ISNULL(M1.organization_ab_nm,'') = ''
			THEN ISNULL(M1.organization_nm,'')
			ELSE ISNULL(M1.organization_ab_nm,'')
		END	 AS organization_nm_1
	
	,	CASE
			WHEN ISNULL(M2.organization_ab_nm,'') = ''
			THEN ISNULL(M2.organization_nm,'')
			ELSE ISNULL(M2.organization_ab_nm,'')
		END	 AS organization_nm_2
		,	CASE
			WHEN ISNULL(M3.organization_ab_nm,'') = ''
			THEN ISNULL(M3.organization_nm,'')
			ELSE ISNULL(M3.organization_ab_nm,'')
		END	 AS organization_nm_3
	,	CASE
			WHEN ISNULL(M4.organization_ab_nm,'') = ''
			THEN ISNULL(M4.organization_nm,'')
			ELSE ISNULL(M4.organization_ab_nm,'')
		END	 AS organization_nm_4
	,	CASE
			WHEN ISNULL(M5.organization_ab_nm,'') = ''
			THEN ISNULL(M5.organization_nm,'')
			ELSE ISNULL(M5.organization_ab_nm,'')
		END	 AS organization_nm_5
	,	ISNULL(#M0071_SHEET.job_nm,'')							AS job_nm
	,	ISNULL(#M0071_SHEET.grade_nm,'')						AS grade_nm
	,	ISNULL(M0130.rank_nm,'')								AS rank_nm
	FROM #MAIN
	LEFT OUTER JOIN #M0071_SHEET ON (
		#MAIN.company_cd		=	#M0071_SHEET.company_cd
	AND #MAIN.fiscal_year		=	#M0071_SHEET.fiscal_year
	AND #MAIN.employee_cd		=	#M0071_SHEET.employee_cd
	AND #MAIN.sheet_cd			=	#M0071_SHEET.sheet_cd
	)
	LEFT JOIN M0130 ON (
		#MAIN.company_cd			=	M0130.company_cd
	AND #MAIN.rank_cd				=	M0130.rank_cd
	AND M0130.treatment_applications_no		=	@P_treatment_applications_no
	AND M0130.del_datetime IS NULL
	)
	LEFT JOIN M0020 AS M1 ON (
		M1.company_cd			=	#M0071_SHEET.company_cd
	AND M1.organization_cd_1	=	#M0071_SHEET.belong_cd1
	AND M1.organization_typ		=	1
	--AND M1.del_datetime			IS NULL 
	) 
	LEFT JOIN M0020 AS M2 ON (
		M2.company_cd			=	#M0071_SHEET.company_cd
	AND M2.organization_cd_1	=	#M0071_SHEET.belong_cd1
	AND M2.organization_cd_2	=	#M0071_SHEET.belong_cd2
	AND M2.organization_typ		=	2
	--AND M2.del_datetime			IS NULL 
	)
	LEFT JOIN M0020 AS M3 ON (
		M3.company_cd			=	#M0071_SHEET.company_cd
	AND M3.organization_cd_1	=	#M0071_SHEET.belong_cd1
	AND M3.organization_cd_2	=	#M0071_SHEET.belong_cd2
	AND M3.organization_cd_3	=	#M0071_SHEET.belong_cd3
	AND M3.organization_typ		=	3
	--AND M2.del_datetime			IS NULL 
	)
	LEFT JOIN M0020 AS M4 ON (
		M4.company_cd			=	#M0071_SHEET.company_cd
	AND M4.organization_cd_1	=	#M0071_SHEET.belong_cd1
	AND M4.organization_cd_2	=	#M0071_SHEET.belong_cd2
	AND M4.organization_cd_3	=	#M0071_SHEET.belong_cd3
	AND M4.organization_cd_4	=	#M0071_SHEET.belong_cd4
	AND M4.organization_typ		=	4
	--AND M2.del_datetime			IS NULL 
	)
	LEFT JOIN M0020 AS M5 ON (
		M5.company_cd			=	#M0071_SHEET.company_cd
	AND M5.organization_cd_1	=	#M0071_SHEET.belong_cd1
	AND M5.organization_cd_2	=	#M0071_SHEET.belong_cd2
	AND M5.organization_cd_3	=	#M0071_SHEET.belong_cd3
	AND M5.organization_cd_4	=	#M0071_SHEET.belong_cd4
	AND M5.organization_cd_5	=	#M0071_SHEET.belong_cd5
	AND M5.organization_typ		=	5
	--AND M2.del_datetime			IS NULL 
	) 
	ORDER BY 
		CASE ISNUMERIC(#MAIN.employee_cd) 
		   WHEN 1 
		   THEN CAST(#MAIN.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	#MAIN.employee_cd
	--[0]
	SET @str_exce = 
	'SELECT
		employee_cd
	,	employee_nm
	,	employee_typ_nm
	,	'+@str_header+'
	,	job_nm
	,	grade_nm
	,	rank_nm
	FROM #RESULT
	ORDER BY
		#RESULT.id
	'
	EXECUTE(@str_exce)

	--CLEAR TABLE TEMP
	DROP TABLE #AUTHORITY
	DROP TABLE #RESULT
	DROP TABLE #MAIN
	DROP TABLE #M0071_SHEET
	DROP TABLE #LIST_POSITION
	DROP TABLE #M0070H
	DROP TABLE #TABLE_ORGANIZATION
END
GO