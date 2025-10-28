IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_eQ0200_LST2]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_eQ0200_LST2]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_eQ0200_LST2 '11','','721','740';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET SEATS CHART FOR eQ0200
--*  
--*  作成日/create date			:	2024/04/01					
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_eQ0200_LST2]
	@P_floor_id				SMALLINT		=	0
,	@P_search_key			NVARCHAR(100)	=	''	-- key search
,	@P_user_id				NVARCHAR(50)	=	''	-- LOGIN USER_ID
,	@P_company_cd			SMALLINT		=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@w_today							date			= getdate()
	--,	@w_login_position_cd				int				=	0
	,	@w_empinfo_authority_typ			smallint		=	0
	--,	@w_empinfo_authority_cd				smallint		=	0
	--,	@w_use_typ							smallint		=	0	
	--,	@w_arrange_order					int				=	0
	--,	@w_evaluation_organization_cnt		int				=	0	-- 0.view all 1.only view organization choiced
	--,	@w_organization_belong_person_typ	smallint		=	0
	--,	@w_choice_in_screen					tinyint			=	0
	,	@w_seating_chart_typ				tinyint			=	0
	,	@w_btn_seat_register				tinyint			=	0	-- 0.not use 1.use
	----#LIST_POSITION
	--CREATE TABLE #LIST_POSITION(
	--	id								int			identity(1,1)
	--,	position_cd						int
	--,	mode							smallint	-- 0.choice in screen 1. get from master
	--)
	----#TABLE_ORGANIZATION
	--CREATE TABLE #TABLE_ORGANIZATION (
	--	organization_typ				tinyint
	--,	organization_cd_1				nvarchar(20)
	--,	organization_cd_2				nvarchar(20)
	--,	organization_cd_3				nvarchar(20)
	--,	organization_cd_4				nvarchar(20)
	--,	organization_cd_5				nvarchar(20)	
	--,	choice_in_screen				tinyint		-- 1.choice in screen 0.get from master S0022
	--)
	--[0]
	CREATE TABLE #TABLE_RESULT(
		id								int				identity(1,1)
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	position_cd						int
	,	belong_cd_1						nvarchar(20)
	,	belong_cd_2						nvarchar(20)
	,	belong_cd_3						nvarchar(20)
	,	belong_cd_4						nvarchar(20)
	,	belong_cd_5						nvarchar(20)
	,	search							int
	)

	CREATE TABLE #TABLE_RESULT_SEARCH(
		id								int				identity(1,1)
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	position_cd						int
	,	belong_cd_1						nvarchar(20)
	,	belong_cd_2						nvarchar(20)
	,	belong_cd_3						nvarchar(20)
	,	belong_cd_4						nvarchar(20)
	,	belong_cd_5						nvarchar(20)
	,	search							int
	)

	CREATE TABLE #TABLE_EMPLOYEES(
		id								int				identity(1,1)
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(101)
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
	--
	SELECT 
		@w_empinfo_authority_typ	=	ISNULL(S0010.empinfo_authority_typ,0)
	--,	@w_empinfo_authority_cd		=	ISNULL(S0010.empinfo_authority_cd,0)
	--,	@w_login_position_cd		=	ISNULL(M0070.position_cd,0)
	FROM S0010
	LEFT OUTER JOIN M0070 ON (
		S0010.company_cd		=	M0070.company_cd
	AND S0010.employee_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	WHERE 
		S0010.company_cd	=	@P_company_cd
	AND S0010.user_id		=	@P_user_id
	AND S0010.del_datetime IS NULL
	--SELECT 
	--	@w_use_typ		=	ISNULL(S5020.use_typ,0)		-- 1. 本人の役職より下位の社員のみ
	--FROM S5020
	--WHERE
	--	S5020.company_cd		=	@P_company_cd
	--AND S5020.authority_cd		=	@w_empinfo_authority_cd
	--AND S5020.del_datetime IS NULL
	---- get @arrange_order
	--SELECT 
	--	@w_arrange_order	=	ISNULL(M0040.arrange_order,0)
	--FROM M0040
	--WHERE 
	--	M0040.company_cd		=	@P_company_cd
	--AND M0040.position_cd		=	@w_login_position_cd
	--AND M0040.del_datetime IS NULL
	-- GET @w_seating_chart_typ
	SELECT 
		@w_seating_chart_typ = ISNULL(M5201.seating_chart_typ,0)
	FROM M5201
	WHERE 
		M5201.company_cd	=	@P_company_cd
	AND M5201.floor_id		=	@P_floor_id
	AND M5201.del_datetime IS NULL
	-- GET #M0070H
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @w_today,'',@P_company_cd
	---- COUNT ALL ORGANIZATIONS
	--SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_empinfo_authority_cd,6)
	---- GET @w_organization_belong_person_typ
	--SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_empinfo_authority_cd,6)
	---- INSERT DATA INTO #TABLE_ORGANIZATION
	--INSERT INTO #TABLE_ORGANIZATION
	--EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 '',@P_user_id,@P_company_cd, 6
	---- INSERT DATA INTO #LIST_POSITION
	---- GET #LIST_POSITION
	--IF NOT EXISTS (SELECT 1 FROM #LIST_POSITION)
	--BEGIN
	--	-- 本人の役職より下位の社員のみ
	--	IF @w_use_typ = 1
	--	BEGIN
	--		INSERT INTO #LIST_POSITION
	--		SELECT 
	--			ISNULL(M0040.position_cd,0)				AS	position_cd
	--		,	1
	--		FROM M0040
	--		WHERE 
	--			M0040.company_cd		=	@P_company_cd
	--		AND M0040.arrange_order		>	@w_arrange_order		-- 1. 本人の役職より下位の社員のみ
	--		AND M0040.del_datetime IS NULL
	--	END
	--	ELSE
	--	BEGIN
	--		INSERT INTO #LIST_POSITION
	--		SELECT 
	--			ISNULL(M0040.position_cd,0)				AS	position_cd
	--		,	1
	--		FROM M0040
	--		WHERE 
	--			M0040.company_cd		=	@P_company_cd
	--		AND M0040.del_datetime IS NULL
	--	END
	--END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--FILTER
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	---- FILTER BY #TABLE_ORGANIZATION
	---- FILTER 組織
	--IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
	--BEGIN
	--	SET @w_choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
	--	-- 1.choice in screen
	--	IF @w_choice_in_screen = 1
	--	BEGIN
	--		DELETE D FROM #M0070H AS D
	--		FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
	--			D.company_cd			=	@P_company_cd
	--		AND D.belong_cd_1			=	S.organization_cd_1
	--		AND D.belong_cd_2			=	S.organization_cd_2
	--		AND D.belong_cd_3			=	S.organization_cd_3
	--		AND D.belong_cd_4			=	S.organization_cd_4
	--		AND D.belong_cd_5			=	S.organization_cd_5
	--		)
	--		WHERE 
	--			D.company_cd IS NULL
	--		OR	S.organization_typ IS NULL
	--	END
	--	ELSE IF NOT (@w_empinfo_authority_typ = 3 AND @w_evaluation_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)
	--	BEGIN
	--		DELETE D FROM #M0070H AS D
	--		FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
	--			D.company_cd			=	@P_company_cd
	--		AND D.belong_cd_1			=	S.organization_cd_1
	--		AND D.belong_cd_2			=	S.organization_cd_2
	--		AND D.belong_cd_3			=	S.organization_cd_3
	--		AND D.belong_cd_4			=	S.organization_cd_4
	--		AND D.belong_cd_5			=	S.organization_cd_5
	--		)
	--		WHERE 
	--			D.company_cd IS NULL
	--		OR	S.organization_typ IS NULL
	--		AND @w_empinfo_authority_typ NOT IN(4,5)		--4.会社管理者 5.総合管理者
	--	END
	--END
	---- FILTER 役職
	---- choice in screen
	--IF EXISTS (SELECT 1 FROM #LIST_POSITION WHERE mode = 0)
	--BEGIN
	--	DELETE D FROM #M0070H AS D
	--	LEFT OUTER JOIN #LIST_POSITION AS S ON (
	--		D.company_cd			=	@P_company_cd
	--	AND D.position_cd			=	S.position_cd
	--	)
	--	WHERE
	--		S.position_cd IS NULL
	--END
	--ELSE -- not choice in screen
	--BEGIN
	--	IF @w_empinfo_authority_typ NOT IN (4,5)
	--	BEGIN
	--		DELETE D FROM #M0070H AS D
	--		LEFT OUTER JOIN #LIST_POSITION AS S ON (
	--			D.company_cd		=	@P_company_cd
	--		AND D.position_cd		=	S.position_cd
	--		)
	--		WHERE
	--			S.position_cd IS NULL
	--		AND (
	--			@w_use_typ = 1
	--		OR	@w_use_typ = 0 AND D.position_cd > 0
	--		)
	--	END
	--END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--result 
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- insert #TABLE_RESULT
	INSERT INTO #TABLE_RESULT_SEARCH
	SELECT 
		F5100.company_cd	
	,	F5100.employee_cd	
	,	S.position_cd	
	,	S.belong_cd_1	
	,	S.belong_cd_2	
	,	S.belong_cd_3	
	,	S.belong_cd_4	
	,	S.belong_cd_5
	,	1
	FROM F5100
	INNER JOIN #M0070H AS S ON (
		F5100.company_cd	=	S.company_cd
	AND F5100.employee_cd	=	S.employee_cd
	)
	WHERE 
		F5100.company_cd		=	@P_company_cd
	AND F5100.floor_id			=	@P_floor_id
	AND F5100.del_datetime IS NULL
	AND (
		(S.employee_cd LIKE '%'+@P_search_key+'%')
	OR	(S.employee_nm LIKE '%'+@P_search_key+'%')
	)

	INSERT INTO #TABLE_RESULT
	SELECT 
		F5100.company_cd	
	,	F5100.employee_cd	
	,	S.position_cd	
	,	S.belong_cd_1	
	,	S.belong_cd_2	
	,	S.belong_cd_3	
	,	S.belong_cd_4	
	,	S.belong_cd_5	
	,	0
	FROM F5100
	INNER JOIN #M0070H AS S ON (
		F5100.company_cd	=	S.company_cd
	AND F5100.employee_cd	=	S.employee_cd
	)
	WHERE 
		F5100.company_cd		=	@P_company_cd
	AND F5100.floor_id			=	@P_floor_id
	AND F5100.del_datetime IS NULL

	IF (@P_search_key <> '')
	BEGIN
	UPDATE #TABLE_RESULT SET 
		search		=	1
	FROM #TABLE_RESULT
	INNER JOIN #TABLE_RESULT_SEARCH ON (
		#TABLE_RESULT.employee_cd	=	#TABLE_RESULT_SEARCH.employee_cd
	AND	#TABLE_RESULT.company_cd	=	#TABLE_RESULT_SEARCH.company_cd
	AND #TABLE_RESULT.belong_cd_1	=	#TABLE_RESULT_SEARCH.belong_cd_1
	AND #TABLE_RESULT.belong_cd_2	=	#TABLE_RESULT_SEARCH.belong_cd_2
	AND #TABLE_RESULT.belong_cd_3	=	#TABLE_RESULT_SEARCH.belong_cd_3
	AND #TABLE_RESULT.belong_cd_4	=	#TABLE_RESULT_SEARCH.belong_cd_4
	AND #TABLE_RESULT.belong_cd_5	=	#TABLE_RESULT_SEARCH.belong_cd_5
	AND #TABLE_RESULT.position_cd	=	#TABLE_RESULT_SEARCH.position_cd
	)
	END
	
	-- M5201.seating_chart_typ ＝ 1.固定席 の場合は ログインユーザー=管理者のみ、M5201.seating_chart_typ ＝2.フリーアドレス の場合は 全員 がボタン利用可能。
	IF (@w_seating_chart_typ = 1 AND @w_empinfo_authority_typ >= 3)
	BEGIN
		SET @w_btn_seat_register = 1
	END
	--[0]
	SELECT 
		ISNULL(M5201.floor_id,0)			AS	floor_id
	,	CASE 
			WHEN ISNULL(M5201.floor_map,'') <> ''
			THEN '/uploads/em0200/'+ CAST(M5201.company_cd AS nvarchar(10)) +'/' + REPLACE(ISNULL(M5201.floor_map,N''), '.pdf', '.jpg')
			ELSE SPACE(0)
		END									AS	floor_map
	,	ISNULL(M5201.seating_chart_typ,0)	AS	seating_chart_typ
	,	@w_btn_seat_register				AS	btn_seat_register
	,	FORMAT(SYSDATETIME(),'yyyy/MM/dd HH:mm')		AS	date_refer	
	FROM M5201
	WHERE 
		M5201.company_cd	=	@P_company_cd
	AND M5201.floor_id		=	@P_floor_id
	AND M5201.del_datetime IS NULL
	--[1]
	SELECT 
		#TABLE_RESULT.employee_cd				AS	employee_cd
	,	LEFT(ISNULL(M0070.employee_nm,''), 4)	AS	employee_nm
	,	ISNULL(M0070.employee_nm,'')			AS	employee_nm_full
	,	ISNULL(F5100.rect_left,0)				AS	x
	,	ISNULL(F5100.rect_top,0)				AS	y
	,	#TABLE_RESULT.search					AS	search
	FROM #TABLE_RESULT
	LEFT OUTER JOIN M0070 ON (
		#TABLE_RESULT.company_cd	=	M0070.company_cd
	AND #TABLE_RESULT.employee_cd	=	M0070.employee_cd
	)
	LEFT OUTER JOIN F5100 ON (
		#TABLE_RESULT.company_cd	=	F5100.company_cd
	AND #TABLE_RESULT.employee_cd	=	F5100.employee_cd
	)
	WHERE 
		((@w_today <= M0070.company_out_dt
	AND M0070.company_out_dt IS NOT NULL)
	OR M0070.company_out_dt IS NULL)
	AND (@w_today >= M0070.company_in_dt
	AND M0070.company_in_dt IS NOT NULL)

	-- DROP
	DROP TABLE #M0070H
	DROP TABLE #TABLE_EMPLOYEES
	DROP TABLE #TABLE_RESULT
END
GO
