IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_eQ0200_LST1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_eQ0200_LST1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_eQ0200_LST1 'jp','',721,10000
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET ORGANIZATOIN CHARTS FOR eQ0200
--*  
--*  作成日/create date			:	2024/04/01					
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_eQ0200_LST1]
	@P_language				NVARCHAR(255)	=	''
,	@P_key_search			NVARCHAR(100)	=	''	-- key search
,	@P_user_id				NVARCHAR(50)	=	''	-- LOGIN USER_ID
,	@P_company_cd			SMALLINT		=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@w_today							date			= getdate()
	--,	@w_login_position_cd				int				=	0
	--,	@w_empinfo_authority_typ			smallint		=	0
	--,	@w_empinfo_authority_cd				smallint		=	0
	--,	@w_use_typ							smallint		=	0	
	--,	@w_arrange_order					int				=	0
	--,	@w_evaluation_organization_cnt		int				=	0	-- 0.view all 1.only view organization choiced
	--,	@w_organization_belong_person_typ	smallint		=	0
	--,	@w_choice_in_screen					tinyint			=	0
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
	,	organization_typ				tinyint
	,	organization_nm					nvarchar(50)
	,	organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)
	,	row_typ							tinyint
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(101)
	,	position_nm						nvarchar(200)
	,	position_cd						int
	,	arrange_order					int
	,	sub								int
	)

	--#M0070H
	CREATE TABLE #M0070H(
		application_date				date
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(200)
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
	,	concurrent_information			nvarchar(max)
	)
	CREATE TABLE #TBL_M0073(
		organization_typ				tinyint
	,	organization_nm					nvarchar(50) 							
	,	belong_cd_1						nvarchar(20)
	,	belong_cd_2						nvarchar(20)
	,	belong_cd_3						nvarchar(20)
	,	belong_cd_4						nvarchar(20)
	,	belong_cd_5						nvarchar(20)
	,	employee_cd						nvarchar(10)
	,	position_cd						int
	,	position_nm						nvarchar(200)
	,	arrange_order					int
	)

	CREATE TABLE #TBL_M0073_RESULT(
		organization_typ				tinyint
	,	organization_nm					nvarchar(50)
	,	belong_cd_1						nvarchar(20)
	,	belong_cd_2						nvarchar(20)
	,	belong_cd_3						nvarchar(20)
	,	belong_cd_4						nvarchar(20)
	,	belong_cd_5						nvarchar(20)
	,	employee_cd						nvarchar(10)
	,	position_cd						int
	,	position_nm						nvarchar(50)
	,	arrange_order					int
	,	concurrent_information			nvarchar(max)
	)
	--
	--SELECT 
	--	@w_empinfo_authority_typ	=	ISNULL(S0010.empinfo_authority_typ,0)
	--,	@w_empinfo_authority_cd		=	ISNULL(S0010.empinfo_authority_cd,0)
	--,	@w_login_position_cd		=	ISNULL(M0070.position_cd,0)
	--FROM S0010
	--LEFT OUTER JOIN M0070 ON (
	--	S0010.company_cd		=	M0070.company_cd
	--AND S0010.employee_cd		=	M0070.employee_cd
	--AND M0070.del_datetime IS NULL
	--)
	--WHERE 
	--	S0010.company_cd	=	@P_company_cd
	--AND S0010.user_id		=	@P_user_id
	--AND S0010.del_datetime IS NULL
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
	-- GET #M0070H
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ2 @w_today,'',@P_company_cd
	---- COUNT ALL ORGANIZATIONS
	--SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_empinfo_authority_cd,6)
	---- GET @w_organization_belong_person_typ
	--SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_empinfo_authority_cd,6)
	---- INSERT DATA INTO #TABLE_ORGANIZATION
	--INSERT INTO #TABLE_ORGANIZATION
	--EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 '',@P_user_id,@P_company_cd, 6
	-- INSERT DATA INTO #LIST_POSITION
	-- GET #LIST_POSITION
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
	-- FILTER BY #TABLE_ORGANIZATION
	-- FILTER 組織
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
	--INSERT INTO FROM M0020
	INSERT INTO #TABLE_RESULT
	SELECT 
		M0020.organization_typ
	,	M0020.organization_nm						-- organization_nm
	,	M0020.organization_cd_1		-- organization_cd_1			
	,	M0020.organization_cd_2		-- organization_cd_2			
	,	M0020.organization_cd_3		-- organization_cd_3			
	,	M0020.organization_cd_4		-- organization_cd_4			
	,	M0020.organization_cd_5		-- organization_cd_5			
	,	1			-- row_typ
	,	SPACE(0)	-- employee_cd	
	,	SPACE(0)	-- employee_nm	
	,	SPACE(0)	-- position_nm	
	,	0			-- position_cd	
	,	0			-- arrange_order	
	,	0			-- no sub	
	FROM M0020
	WHERE 
		M0020.company_cd	=	@P_company_cd
	AND M0020.del_datetime IS NULL


	--INNER JOIN M0020 ON (
	--	@P_company_cd							=	M0020.company_cd
	--AND #TABLE_ORGANIZATION.organization_cd_1	=	M0020.organization_cd_1
	--AND #TABLE_ORGANIZATION.organization_cd_2	=	M0020.organization_cd_2
	--AND #TABLE_ORGANIZATION.organization_cd_3	=	M0020.organization_cd_3
	--AND #TABLE_ORGANIZATION.organization_cd_4	=	M0020.organization_cd_4
	--AND #TABLE_ORGANIZATION.organization_cd_5	=	M0020.organization_cd_5
	--AND M0020.del_datetime IS NULL
	--)
	--INSERT INTO FROM M0073
	INSERT INTO #TBL_M0073
	SELECT 
		ISNULL(M0020.organization_typ,0)	AS	organization_typ
	,	ISNULL(M0020.organization_nm,'')	AS	organization_nm
	,	M0073.belong_cd1		AS	"belong_cd1"
	,	M0073.belong_cd2		AS	"belong_cd2"
	,	M0073.belong_cd3		AS	"belong_cd3"
	,	M0073.belong_cd4		AS	"belong_cd4"
	,	M0073.belong_cd5		AS	"belong_cd5"
	,	M0073.employee_cd					
	,	M0040.position_cd					
	,	CASE
			WHEN ISNULL(M0040.position_ab_nm,'') = '' THEN ISNULL(M0040.position_nm,'')		
			ELSE M0040.position_ab_nm
		END																						AS	position_nm	
	,	ISNULL(M0040.arrange_order,999999999)
	FROM M0073
	INNER JOIN #M0070H ON(
		M0073.company_cd		=	#M0070H.company_cd
	AND M0073.employee_cd		=	#M0070H.employee_cd
	AND M0073.application_date	=	#M0070H.application_date
	)
	LEFT OUTER JOIN M0020 ON (
		M0073.company_cd		=	M0020.company_cd
	AND	M0073.belong_cd1		=	M0020.organization_cd_1
	AND M0073.belong_cd2		=	M0020.organization_cd_2
	AND M0073.belong_cd3		=	M0020.organization_cd_3
	AND M0073.belong_cd4		=	M0020.organization_cd_4
	AND M0073.belong_cd5		=	M0020.organization_cd_5
	AND M0020.del_datetime IS NULL
	)
	LEFT OUTER JOIN M0040 ON(
		M0073.company_cd		=	M0040.company_cd
	AND M0073.position_cd		=	M0040.position_cd
	AND M0040.del_datetime IS NULL
	)
	WHERE
		M0073.company_cd		=	@P_company_cd
	AND M0073.del_datetime IS NULL

	INSERT INTO #TBL_M0073_RESULT
	SELECT 
		#TBL_M0073.organization_typ
		,	#TBL_M0073.organization_nm
		,	#TBL_M0073.belong_cd_1
		,	#TBL_M0073.belong_cd_2
		,	#TBL_M0073.belong_cd_3
		,	#TBL_M0073.belong_cd_4
		,	#TBL_M0073.belong_cd_5
		,	#TBL_M0073.employee_cd
		,	#TBL_M0073.position_cd
		,	#TBL_M0073.position_nm
		,	#TBL_M0073.arrange_order
		,	1  --is sub
		FROM #TBL_M0073
	GROUP BY
			#TBL_M0073.organization_typ
		,	#TBL_M0073.organization_nm
		,	#TBL_M0073.belong_cd_1
		,	#TBL_M0073.belong_cd_2
		,	#TBL_M0073.belong_cd_3
		,	#TBL_M0073.belong_cd_4
		,	#TBL_M0073.belong_cd_5
		,	#TBL_M0073.employee_cd
		,	#TBL_M0073.position_cd
		,	#TBL_M0073.position_nm
		,	#TBL_M0073.arrange_order


	INSERT INTO #TABLE_RESULT
	SELECT 
		ISNULL(#TBL_M0073_RESULT.organization_typ,0)	
	,	ISNULL(#TBL_M0073_RESULT.organization_nm,'')
	,	#TBL_M0073_RESULT.belong_cd_1					-- organization_cd_1	
	,	#TBL_M0073_RESULT.belong_cd_2					-- organization_cd_2	
	,	#TBL_M0073_RESULT.belong_cd_3					-- organization_cd_3	
	,	#TBL_M0073_RESULT.belong_cd_4					-- organization_cd_4	
	,	#TBL_M0073_RESULT.belong_cd_5					-- organization_cd_5	
	,	2										-- row_typ
	,	#TBL_M0073_RESULT.employee_cd					-- employee_cd	
	,	M0070.employee_nm						-- employee_nm	
	,	ISNULL(#TBL_M0073_RESULT.position_nm,'') 					-- position_nm
	,	IIF(#TBL_M0073_RESULT.position_cd IS NULL, 999999999, #TBL_M0073_RESULT.position_cd)					-- position_cd
	,	#TBL_M0073_RESULT.arrange_order			-- arrange_order is null order by last
	,	1		-- sub	
	FROM #TBL_M0073_RESULT
	INNER JOIN M0070 ON (
		M0070.company_cd = @P_company_cd
	AND	#TBL_M0073_RESULT.employee_cd = M0070.employee_cd
	AND	M0070.del_datetime IS NULL
	)
	WHERE 
		#TBL_M0073_RESULT.employee_cd LIKE '%'+@P_key_search+'%'
	OR	M0070.employee_nm LIKE '%'+@P_key_search+'%'

	-- INSERT INTO FROM M0070
	INSERT INTO #TABLE_RESULT
	SELECT 
		ISNULL(M0020.organization_typ,0)	
	,	ISNULL(M0020.organization_nm,'')
	,	#M0070H.belong_cd_1					-- organization_cd_1	
	,	#M0070H.belong_cd_2					-- organization_cd_2	
	,	#M0070H.belong_cd_3					-- organization_cd_3	
	,	#M0070H.belong_cd_4					-- organization_cd_4	
	,	#M0070H.belong_cd_5					-- organization_cd_5	
	,	2									-- row_typ
	,	#M0070H.employee_cd					-- employee_cd	
	,	#M0070H.employee_nm					-- employee_nm	
	,	#M0070H.position_nm					-- position_nm
	,	#M0070H.position_cd					-- position_cd
	,	ISNULL(M0040.arrange_order,999999999)		as	arrange_order	-- arrange_order is null order by last
	,	0		-- no sub	
	FROM #M0070H
	LEFT OUTER JOIN M0020 ON (
		#M0070H.company_cd		=	M0020.company_cd
	AND	#M0070H.belong_cd_1		=	M0020.organization_cd_1
	AND #M0070H.belong_cd_2		=	M0020.organization_cd_2
	AND #M0070H.belong_cd_3		=	M0020.organization_cd_3
	AND #M0070H.belong_cd_4		=	M0020.organization_cd_4
	AND #M0070H.belong_cd_5		=	M0020.organization_cd_5
	AND M0020.del_datetime IS NULL
	)
	LEFT OUTER JOIN M0040 ON (
		#M0070H.company_cd		=	M0040.company_cd
	AND #M0070H.position_cd		=	M0040.position_cd
	AND M0040.del_datetime IS NULL
	)
	WHERE 
		#M0070H.employee_cd LIKE '%'+@P_key_search+'%'
	OR	#M0070H.employee_nm LIKE '%'+@P_key_search+'%'

	--[0] GET LIST EMPLOYEES NOT REGISTER ORGANIZATION
	SELECT 
		#TABLE_RESULT.employee_cd
	,	#TABLE_RESULT.employee_nm
	,	#TABLE_RESULT.position_nm
	,	#TABLE_RESULT.sub
	,	#TABLE_RESULT.arrange_order
	FROM #TABLE_RESULT
	LEFT OUTER JOIN M0070 ON (
		M0070.company_cd		= @P_company_cd
	AND #TABLE_RESULT.employee_cd = M0070.employee_cd
	)
	WHERE 
		organization_typ = 0
	AND	((@w_today <= M0070.company_out_dt
	AND M0070.company_out_dt IS NOT NULL)
	OR M0070.company_out_dt IS NULL)
	AND (@w_today >= M0070.company_in_dt
	AND M0070.company_in_dt IS NOT NULL)
	ORDER BY 
		arrange_order 
	,	#TABLE_RESULT.position_cd
	,	#TABLE_RESULT.employee_cd
	--[1] GET LIST EMPLOYEES REGISTER ORGANIZATION
	SELECT 
		#TABLE_RESULT.organization_typ
	,	#TABLE_RESULT.organization_cd_1
	,	#TABLE_RESULT.organization_cd_2
	,	#TABLE_RESULT.organization_cd_3
	,	#TABLE_RESULT.organization_cd_4
	,	#TABLE_RESULT.organization_cd_5
	,	#TABLE_RESULT.organization_nm
	,	(
		SELECT 
			S.employee_cd				AS	"employee_cd"
		,	S.employee_nm				AS	"employee_nm"
		,	S.position_nm				AS	"position_nm"
		,	S.sub						AS	sub
		FROM #TABLE_RESULT AS S
		LEFT OUTER JOIN M0070 ON (
			M0070.company_cd		= @P_company_cd
		AND S.employee_cd = M0070.employee_cd
		)
		WHERE 
			S.organization_cd_1	=	#TABLE_RESULT.organization_cd_1
		AND S.organization_cd_2	=	#TABLE_RESULT.organization_cd_2
		AND S.organization_cd_3	=	#TABLE_RESULT.organization_cd_3
		AND S.organization_cd_4	=	#TABLE_RESULT.organization_cd_4
		AND S.organization_cd_5	=	#TABLE_RESULT.organization_cd_5
		AND S.organization_typ	<>	0
		AND S.employee_cd		<>	SPACE(0)
		AND	((@w_today <= M0070.company_out_dt
		AND M0070.company_out_dt IS NOT NULL)
		OR M0070.company_out_dt IS NULL)
		AND (@w_today >= M0070.company_in_dt
		AND M0070.company_in_dt IS NOT NULL)
		ORDER BY
			S.sub	
		,	S.arrange_order 
		,	S.position_cd
		,	S.employee_cd
		FOR JSON PATH
	) AS employee_info
	FROM #TABLE_RESULT
	
	WHERE 
		organization_typ <> 0
	GROUP BY 
		#TABLE_RESULT.organization_typ
	,	#TABLE_RESULT.organization_cd_1
	,	#TABLE_RESULT.organization_cd_2
	,	#TABLE_RESULT.organization_cd_3
	,	#TABLE_RESULT.organization_cd_4
	,	#TABLE_RESULT.organization_cd_5
	,	#TABLE_RESULT.organization_nm
	ORDER BY
		#TABLE_RESULT.organization_cd_1
	,	#TABLE_RESULT.organization_cd_2
	,	#TABLE_RESULT.organization_cd_3
	,	#TABLE_RESULT.organization_cd_4
	,	#TABLE_RESULT.organization_cd_5
	,	#TABLE_RESULT.organization_typ

	SELECT @P_language AS language 
	-- DROP
	DROP TABLE #M0070H
	DROP TABLE #TABLE_RESULT
	DROP TABLE #TBL_M0073
	DROP TABLE #TBL_M0073_RESULT
END
GO
