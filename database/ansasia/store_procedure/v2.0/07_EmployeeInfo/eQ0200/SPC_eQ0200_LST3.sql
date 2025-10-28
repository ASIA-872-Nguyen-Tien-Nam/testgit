IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_eQ0200_LST3]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_eQ0200_LST3]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_eQ0200_LST2 0,'721',782
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	SEARCH EMPLOYEE INFORMATION LIST FOR eQ0200
--*  
--*  作成日/create date			:	2024/04/01					
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_eQ0200_LST3]
	@P_json					NVARCHAR(max)	=	''	-- json
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
	--	SCREEN PARAMS
	,	@w_employee_cd						nvarchar(10)	=	''
	,	@w_employee_nm						nvarchar(101)	=	''
	,	@w_belong_cd1						nvarchar(20)	=	''
	,	@w_belong_cd2						nvarchar(20)	=	''
	,	@w_belong_cd3						nvarchar(20)	=	''
	,	@w_belong_cd4						nvarchar(20)	=	''
	,	@w_belong_cd5						nvarchar(20)	=	''
	,	@w_cert_use_typ						nvarchar(50)	=	''
	,	@w_resume_use_typ					nvarchar(50)	=	''
	,	@w_i								int				=	1
	,	@w_cnt								int				=	0
	,	@w_field_cd							smallint		=	0
	,	@w_field_val						nvarchar(50)	=	''
	--
	,	@totalRecord						bigint				=	0
	,	@pageMax							int					=	0	
	,	@page_size							int					=	50
	,	@page								int					=	0
	SET @w_today = CONVERT(date, @w_today)
	--#LIST_POSITION
	CREATE TABLE #LIST_POSITION(
		id								int			identity(1,1)
	,	position_cd						int
	,	mode							smallint	-- 0.choice in screen 1. get from master
	)
	--#TABLE_ORGANIZATION
	CREATE TABLE #TABLE_ORGANIZATION (
		organization_typ				tinyint
	,	organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)	
	,	choice_in_screen				tinyint		-- 1.choice in screen 0.get from master S0022
	)
	--
	CREATE TABLE #TABLE_JSON (
		id					int			identity(1,1)	
	,	field_cd			smallint
	,	field_val			nvarchar(50)
	)
	-- コミュニケーション項目
	CREATE TABLE #TABLE_F5001 (
		id					int			identity(1,1)	
	,	employee_cd			nvarchar(10)
	)
	-- 資格
	CREATE TABLE #TABLE_M0075 (
		id					int			identity(1,1)	
	,	employee_cd			nvarchar(10)
	)
	-- 業務経歴
	CREATE TABLE #TABLE_M0077 (
		id					int			identity(1,1)	
	,	employee_cd			nvarchar(10)
	)
	CREATE TABLE #TABLE_RESULT (
		id					int			identity(1,1)	
	,	employee_cd			nvarchar(10)
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
	-- GET PARAM FROM JSON
	SET @w_employee_cd		=	JSON_VALUE(@P_json,'$.employee_cd')
	SET @w_employee_nm		=	JSON_VALUE(@P_json,'$.employee_nm')
	SET @w_belong_cd1		=	JSON_VALUE(@P_json,'$.belong_cd1')
	SET @w_belong_cd2		=	JSON_VALUE(@P_json,'$.belong_cd2')
	SET @w_belong_cd3		=	JSON_VALUE(@P_json,'$.belong_cd3')
	SET @w_belong_cd4		=	JSON_VALUE(@P_json,'$.belong_cd4')
	SET @w_belong_cd5		=	JSON_VALUE(@P_json,'$.belong_cd5')
	SET @w_cert_use_typ		=	JSON_VALUE(@P_json,'$.cert_use_typ')
	SET @w_resume_use_typ	=	JSON_VALUE(@P_json,'$.resume_use_typ')
	SET @page_size			=	JSON_VALUE(@P_json,'$.page_size')
	SET @page				=	JSON_VALUE(@P_json,'$.page')
	--
	INSERT INTO #TABLE_JSON
	SELECT 
		json_table.field_cd
	,	json_table.field_val
	FROM OPENJSON(@P_json,'$.items') WITH(
		field_cd	smallint
	,	field_val	nvarchar(50)
	)AS json_table
	WHERE
		json_table.field_val <> SPACE(0)
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
	-- FILTER BY #TABLE_ORGANIZATION
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
	-- INSERT INTO #TABLE_RESULT
	INSERT INTO #TABLE_RESULT
	SELECT 
		#M0070H.employee_cd
	FROM #M0070H
	WHERE 
		#M0070H.employee_nm LIKE '%'+@w_employee_nm+'%'
	AND (
		(@w_employee_cd = SPACE(0))
	OR	(@w_employee_cd <> SPACE(0) AND #M0070H.employee_cd = @w_employee_cd)
	)
	AND (
		(@w_belong_cd1 = -1)
	OR	(@w_belong_cd1 <> -1 AND #M0070H.belong_cd_1 = @w_belong_cd1)
	)
	AND (
		(@w_belong_cd2 = -1)
	OR	(@w_belong_cd2 <> -1 AND #M0070H.belong_cd_2 = @w_belong_cd2)
	)
	AND (
		(@w_belong_cd3 = -1)
	OR	(@w_belong_cd3 <> -1 AND #M0070H.belong_cd_3 = @w_belong_cd3)
	)
	AND (
		(@w_belong_cd4 = -1)
	OR	(@w_belong_cd4 <> -1 AND #M0070H.belong_cd_4 = @w_belong_cd4)
	)
	AND (
		(@w_belong_cd5 = -1)
	OR	(@w_belong_cd5 <> -1 AND #M0070H.belong_cd_5 = @w_belong_cd5)
	)
	-- FILTER 資格
	IF @w_cert_use_typ <> SPACE(0)
	BEGIN
		INSERT INTO #TABLE_M0075
		SELECT 
			M0075.employee_cd
		FROM M0075
		INNER JOIN #TABLE_RESULT ON(
			M0075.company_cd	=	@P_company_cd
		AND	M0075.employee_cd	=	#TABLE_RESULT.employee_cd
		)
		INNER JOIN M5010 ON (
			M0075.company_cd		=	M5010.company_cd
		AND M0075.qualification_cd	=	M5010.qualification_cd
		AND M5010.del_datetime IS NULL
		)
		WHERE
			M0075.company_cd	=	@P_company_cd
		AND M0075.del_datetime IS NULL
		AND M5010.qualification_nm LIKE '%'+@w_cert_use_typ+'%'
		GROUP BY
			M0075.employee_cd
		-- DELETE
		DELETE D FROM #TABLE_RESULT AS D
		LEFT OUTER JOIN #TABLE_M0075 AS S ON(
			D.employee_cd = S.employee_cd
		)
		WHERE
			S.employee_cd IS NULL
	END
	-- FILTER 業務経歴
	IF @w_resume_use_typ <> SPACE(0)
	BEGIN
		INSERT INTO #TABLE_M0077
		SELECT 
			M0077.employee_cd
		FROM M0077
		INNER JOIN #TABLE_RESULT ON(
			M0077.company_cd	=	@P_company_cd
		AND	M0077.employee_cd	=	#TABLE_RESULT.employee_cd
		)
		INNER JOIN M5020 ON (
			M0077.company_cd		=	M5020.company_cd
		AND M0077.work_history_kbn	=	M5020.work_history_kbn
		AND M0077.item_id			=	M5020.item_id
		AND M5020.del_datetime IS NULL
		)
		LEFT OUTER JOIN L0010 ON (
			78						=	L0010.name_typ
		AND M0077.item_id			=	L0010.number_cd
		AND L0010.del_datetime IS NULL
		)
		WHERE
			M0077.company_cd	=	@P_company_cd
		AND M0077.del_datetime IS NULL
		AND (
			(M0077.text_item LIKE '%'+@w_resume_use_typ+'%')
		OR	(L0010.numeric_value1 IN(2,3,4) AND M5020.item_title LIKE '%'+@w_resume_use_typ+'%')
		)
		GROUP BY
			M0077.employee_cd
		-- DELETE 
		DELETE D FROM #TABLE_RESULT AS D
		LEFT OUTER JOIN #TABLE_M0077 AS S ON(
			D.employee_cd = S.employee_cd
		)
		WHERE
			S.employee_cd IS NULL
	END
	-- FILTER コミュニケーション項目
	IF EXISTS (SELECT 1 FROM #TABLE_JSON)
	BEGIN
		SET @w_cnt	=	(SELECT COUNT(1) FROM #TABLE_JSON)
		WHILE @w_i <= @w_cnt
		BEGIN
			SELECT 
				@w_field_cd		=	ISNULL(#TABLE_JSON.field_cd,0)
			,	@w_field_val	=	ISNULL(#TABLE_JSON.field_val,'')
			FROM #TABLE_JSON WHERE id = @w_i
			--
			IF @w_i = 1
			BEGIN
			INSERT INTO #TABLE_F5001
			SELECT 
				F5001.employee_cd
			FROM F5001
			INNER JOIN #TABLE_RESULT ON (
				F5001.company_cd	=	@P_company_cd
			AND	F5001.employee_cd	=	#TABLE_RESULT.employee_cd	
			)
			LEFT OUTER JOIN #TABLE_F5001 AS S ON (
				F5001.employee_cd	=	S.employee_cd
			)
			WHERE 
				F5001.company_cd	=	@P_company_cd
			AND F5001.field_cd		=	@w_field_cd
			AND F5001.del_datetime IS NULL
			AND F5001.registered_value LIKE '%'+@w_field_val+'%'
			AND S.employee_cd IS NULL
			GROUP BY
				F5001.employee_cd
			END
			ELSE
			BEGIN
				-- AND field other
				DELETE F5001_1 FROM #TABLE_RESULT AS F5001_1
				LEFT OUTER JOIN (
					SELECT 
						F5001.employee_cd
					FROM F5001
					INNER JOIN #TABLE_RESULT ON (
						F5001.company_cd	=	@P_company_cd
					AND	F5001.employee_cd	=	#TABLE_RESULT.employee_cd	
					)
					INNER JOIN #TABLE_F5001 AS S ON (
						F5001.employee_cd	=	S.employee_cd
					)
					WHERE 
						F5001.company_cd	=	@P_company_cd
					AND F5001.field_cd		=	@w_field_cd
					AND F5001.del_datetime IS NULL
					AND F5001.registered_value LIKE '%'+@w_field_val+'%'
					GROUP BY
						F5001.employee_cd
				) AS S ON(
					F5001_1.employee_cd = S.employee_cd
				) WHERE
				S.employee_cd IS NULL

			END
			--
			SET @w_i = @w_i + 1
		END
		-- DELETE 
		DELETE D FROM #TABLE_RESULT AS D
		LEFT OUTER JOIN #TABLE_F5001 AS S ON(
			D.employee_cd = S.employee_cd
		)
		WHERE
			S.employee_cd IS NULL
	END

	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--result 
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	SET @totalRecord = (SELECT COUNT(1) FROM #TABLE_RESULT)
	SET @pageMax = CEILING(CAST(@totalRecord AS FLOAT) / @page_size)
	IF @pageMax = 0
	BEGIN
		SET @pageMax = 1
	END
	IF @page > @pageMax
	BEGIN
		SET @page = @pageMax
	END
	--[0]
	SELECT 
		#TABLE_RESULT.employee_cd				AS	employee_cd
	,	ISNULL(#M0070H.employee_nm,'')			AS	employee_nm
	,	ISNULL(#M0070H.belong_nm_1,'')			AS	belong_nm_1
	,	ISNULL(#M0070H.belong_nm_2,'')			AS	belong_nm_2
	,	ISNULL(#M0070H.belong_nm_3,'')			AS	belong_nm_3
	,	ISNULL(#M0070H.belong_nm_4,'')			AS	belong_nm_4
	,	ISNULL(#M0070H.belong_nm_5,'')			AS	belong_nm_5
	,	ISNULL(#M0070H.position_nm,'')			AS	position_nm
	FROM #TABLE_RESULT
	LEFT OUTER JOIN M0070 ON (
		M0070.company_cd		= @P_company_cd
	AND #TABLE_RESULT.employee_cd = M0070.employee_cd
	)
	LEFT OUTER JOIN #M0070H ON (
		@P_company_cd				=	#M0070H.company_cd
	AND	#TABLE_RESULT.employee_cd	=	#M0070H.employee_cd
	)
	WHERE 
		((@w_today <= M0070.company_out_dt
	AND M0070.company_out_dt IS NOT NULL)
	OR M0070.company_out_dt IS NULL)
	AND (@w_today >= M0070.company_in_dt
	AND M0070.company_in_dt IS NOT NULL)
	ORDER BY 
		RIGHT(SPACE(10)+ISNULL(#TABLE_RESULT.employee_cd,N''),10)
	offset (@page-1) * @page_size ROWS
	FETCH NEXT @page_size ROWS only
	--[1]
	SELECT	
		@totalRecord					AS totalRecord
	,	@pageMax						AS pageMax
	,	@page							AS page
	,	@page_size						AS pagesize
	,	((@page - 1) * @page_size + 1)	AS offset
	-- DROP
	DROP TABLE #LIST_POSITION
	DROP TABLE #M0070H
	DROP TABLE #TABLE_ORGANIZATION
END
GO
