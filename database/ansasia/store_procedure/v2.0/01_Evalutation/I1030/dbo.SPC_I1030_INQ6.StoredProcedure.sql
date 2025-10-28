DROP PROCEDURE [SPC_I1030_INQ6]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
 *
 *  処理概要:  Search office
 *
 *  作成日  ： 2018/08/20
 *  作成者  ： Tuantv
 *
 *  更新日  ：	2019/12/10
 *  更新者  ：	viettd
 *  更新内容：	upgradate ver1.6
 *
 *  更新日  ： 2020/04/16
 *  更新者  ： viettd
 *  更新内容： view all when authority = 4.会社管理者
 *
 *  更新日  ： 2021/06/03
 *  更新者  ： viettd
 *  更新内容： when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
 ****************************************************************************************************/
 CREATE PROCEDURE [SPC_I1030_INQ6] 
    @P_search_key			NVARCHAR(200)	= ''
, 	@P_company_cd			SMALLINT		= 0
,	@P_fiscal_year			INT				= 0
,	@P_user_id				NVARCHAR(50)	= ''
,	@P_authority_cd			SMALLINT		= 0
,	@P_authority_typ		SMALLINT		= 0	
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@ERR_TBL				ERRTABLE
	,	@w_month_date						NVARCHAR(10)	= ''
	,	@w_year								NVARCHAR(10)	= ''
	--	add by viettd 2019/01/07
	,	@use_typ							smallint		=	0			
	,	@authority_cd						smallint		=	0
	,	@authority_typ						smallint		=	0
	,	@position_cd						int		        =	0
	,	@arrange_order						INT				=	0
	-- add by viettd 2021/06/03
	,	@w_evaluation_organization_cnt		INT				=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT		=	0
	--
	SET @w_month_date =(SELECT FORMAT(M9100.beginning_date,'MM-dd') FROM M9100 WHERE M9100.company_cd = @P_company_cd)
	SET @w_year =  CONVERT(NVARCHAR(10),@P_fiscal_year) +'-'+ @w_month_date
	--
	SELECT 
		@authority_typ				=	ISNULL(S0010.authority_typ,0) 
	,	@authority_cd				=	ISNULL(S0010.authority_cd,0)
	,	@position_cd				=	ISNULL(M0070.position_cd,0)
	FROM S0010 LEFT JOIN M0070 ON (
		M0070.company_cd		=	S0010.company_cd
	AND M0070.employee_cd		=	S0010.employee_cd
	AND M0070.del_datetime		IS NULL 
	) 
	WHERE 
		S0010.user_id		= @P_user_id 
	AND S0010.company_cd	= @P_company_cd 
	AND S0010.del_datetime  IS NULL
	-- get @arrange_order
	SELECT 
		@arrange_order	=	ISNULL(M0040.arrange_order,0)
	FROM M0040
	WHERE 
		M0040.company_cd		=	@P_company_cd
	AND M0040.position_cd		=	@position_cd
	AND M0040.del_datetime IS NULL
	--
	SELECT 
		@use_typ = ISNULL(S0020.use_typ,0)
	FROM S0020
	WHERE 
		S0020.company_cd	=	@P_company_cd
	AND S0020.authority_cd	=	@authority_cd
	AND S0020.del_datetime IS NULL
	-- COUNT ALL ORGANIZATIONS OF S0022 -- add by viettd 2021/06/03
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@authority_cd,1)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@authority_cd,1)
	--
	CREATE TABLE #TABLE_ORGANIZATION (
		organization_typ				tinyint
	,	organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)	
	,	choice_in_screen				tinyint		-- 1.choice in screen 0.get from master S0022
	)
	--#LIST_POSITION
	CREATE TABLE #LIST_POSITION(
		id								int			identity(1,1)
	,	position_cd						int
	,	mode							smallint
	)
	--
	CREATE TABLE #RESULT (
		company_cd		SMALLINT
	,	employee_cd		NVARCHAR(10)
	,	employee_nm		NVARCHAR(200)
	,	belong_cd1		NVARCHAR(20)
	,	belong_cd2		NVARCHAR(20)
	,	belong_cd3		NVARCHAR(20)
	,	belong_cd4		NVARCHAR(20)
	,	belong_cd5		NVARCHAR(20)
	,	position_cd		int
	)
	-- INSERT DATA INTO #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 '',@P_user_id,@P_company_cd
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
	------------------------- INSERT DATA -------------------------
	INSERT INTO #RESULT
	SELECT  
		ISNULL(M0070.company_cd,0)		AS	company_cd
	,	ISNULL(M0070.employee_cd,'')	AS	employee_cd
	,	ISNULL(M0070.employee_nm,'')	AS	employee_nm
	,	ISNULL(M0070.belong_cd1,'')		AS	belong_cd1
	,	ISNULL(M0070.belong_cd2,'')		AS	belong_cd2
	,	ISNULL(M0070.belong_cd3,'')		AS	belong_cd3
	,	ISNULL(M0070.belong_cd4,'')		AS	belong_cd4
	,	ISNULL(M0070.belong_cd5,'')		AS	belong_cd5	
	,	ISNULL(M0070.position_cd,0)		AS	position_cd
	FROM M0070
	WHERE 
		M0070.company_cd = @P_company_cd
	AND M0070.del_datetime IS NULL
	AND (M0070.employee_nm		LIKE '%'+@P_search_key+'%'  
	OR M0070.furigana			LIKE '%'+@P_search_key+'%'
	OR M0070.employee_cd		LIKE '%'+@P_search_key+'%'
	)
	AND M0070.evaluated_typ = 1
	AND (
		M0070.company_out_dt IS NULL
	OR  (M0070.company_out_dt IS NOT NULL AND CONVERT(DATE,@w_year) < M0070.company_out_dt)
	)
	ORDER BY 
		CASE ISNUMERIC(M0070.employee_cd) 
		   WHEN 1 
		   THEN CAST(M0070.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	M0070.employee_cd
	--■■■■■■■■■■■■■■■■■■ FILTER  ■■■■■■■■■■■■■■■■■■
	-- ORGANIZATION
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
	BEGIN
		IF NOT (@authority_typ = 3 AND @w_evaluation_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)	-- edited by viettd 2021/06/03
		BEGIN
			DELETE D FROM #RESULT AS D
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
			AND @authority_typ NOT IN(4,5) --4.会社管理者 5.総合管理者
		END
	END
	-- 本人の役職より下位の社員のみ
	IF @use_typ = 1
	BEGIN
		IF @authority_typ NOT IN (4,5)
		BEGIN
			DELETE D FROM #RESULT AS D
			LEFT OUTER JOIN #LIST_POSITION AS S ON (
				D.company_cd		=	@P_company_cd
			AND D.position_cd		=	S.position_cd
			)
			WHERE
				S.position_cd IS NULL
		END
	END
	--[0]
	SELECT
		#RESULT.employee_nm											AS value
	,	ISNULL(#RESULT.employee_cd,'')								AS id
	,	#RESULT.employee_cd+':'+ISNULL(#RESULT.employee_nm,'')		AS label
	FROM #RESULT
END
GO
