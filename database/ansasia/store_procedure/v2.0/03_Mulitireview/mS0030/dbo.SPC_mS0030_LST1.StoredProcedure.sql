DROP PROCEDURE [SPC_mS0030_LST1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC SPC_mS0030_LST1 '10000','','','-1','-1','-1','-1','-1','','0','0','0','hanhntm','20','1','{"list_organization_step1":[],"list_organization_step2":[],"list_organization_step3":[],"list_organization_step4":[],"list_organization_step5":[]}';

CREATE PROCEDURE [SPC_mS0030_LST1]
/****************************************************************************************************
 *
 *  処理概要:  Search
 *
 *  作成日  ： 2020/09/25
 *  作成者  ： nghianm
 *
 *  更新日  ：	2021/01/25
 *  更新者  ：	viettd
 *  更新内容：	upgrade ver1.7 & 1on1
 *
 *  更新日  ：	2021/06/03
 *  更新者  ：	viettd
 *  更新内容：	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
 *
 *  更新日  ：	2021/10/12
 *  更新者  ：	viettd
 *  更新内容：	dont show employees when authority_typ = 5.総合管理者
 *
 ****************************************************************************************************/
 	@P_company_cd				SMALLINT			= 0
, 	@P_employee_cd				NVARCHAR(10)		= ''
,	@P_employee_nm				NVARCHAR(20)		= ''
,	@P_organization_cd_1		NVARCHAR(20)		= ''
,	@P_organization_cd_2		NVARCHAR(20)		= ''
,	@P_organization_cd_3		NVARCHAR(20)		= ''
,	@P_organization_cd_4		NVARCHAR(20)		= ''
,	@P_organization_cd_5		NVARCHAR(20)		= ''
,	@P_position_cd				INT			= 0	
,	@P_check_authority			SMALLINT			= 0
,	@P_authority_cd_screen		SMALLINT			= 0	
,	@P_employee_typ				SMALLINT			= 0	
,	@P_user_id					NVARCHAR(50)		= ''
,	@P_page_size				INT					= 50
,	@P_page						INT					= 1
,	@P_json						NVARCHAR(MAX)		= ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@ERR_TBL							ERRTABLE
	,	@w_time								DATETIME2			=	SYSDATETIME()
	,	@totalRecord						BIGINT				=	0
	,	@pageNumber							INT					=	0
	,	@pageMax							INT					=	0
	--
	,	@arrange_order						INT					=	0
	,	@position_cd						INT					=	0
	,	@P_authority_cd						SMALLINT			=	0
	,	@P_authority_typ					SMALLINT			=	0
	,	@employee_cd						NVARCHAR(10)		=	''
	,	@choice_in_screen					INT					=	0
	-- add by viettd 2021/06/03
	,	@w_mulitireview_organization_cnt	INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	--
	SET @w_time = CONVERT(date, @w_time)
	SELECT 
		@P_authority_typ	=	ISNULL(S0010.multireview_authority_typ,0) 
	,	@P_authority_cd		=	ISNULL(S0010.multireview_authority_cd,0)
	,	@position_cd		=	ISNULL(M0070.position_cd,0)
	,	@employee_cd		=	ISNULL(M0070.employee_cd,0)
	FROM S0010 LEFT JOIN M0070 ON (
		M0070.company_cd		=	S0010.company_cd
	AND M0070.employee_cd		=	S0010.employee_cd
	AND M0070.del_datetime		IS NULL 
	) 
	WHERE 
		S0010.user_id		= @P_user_id 
	AND S0010.company_cd	= @P_company_cd 
	AND S0010.del_datetime  IS NULL
	--
    SET @arrange_order = ISNULL((
		SELECT ISNULL(M0040.arrange_order,0)
		FROM M0040
		WHERE
			M0040.del_datetime IS NULL
		AND M0040.position_cd =	@position_cd
		AND M0040.company_cd = @P_company_cd
	),0)
	-- COUNT ALL ORGANIZATIONS OF S3022 -- add by viettd 2021/06/03
	SET @w_mulitireview_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@P_authority_cd,3)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@P_authority_cd,3)
	--
	CREATE TABLE #M0070 (
		id						int	identity(1, 1)
	,	employee_cd				nvarchar(10)
	,	employee_nm				nvarchar(101)
	,	employee_typ			smallint
	,	employee_typ_nm			nvarchar(100)
	,	belong_cd1				nvarchar(50)
	,	belong_cd2				nvarchar(50)
	,	belong_cd3				nvarchar(50)
	,	belong_cd4				nvarchar(50)
	,	belong_cd5				nvarchar(50)
	,	organization_nm_1		nvarchar(50)
	,	organization_nm_2		nvarchar(50)
	,	organization_nm_3		nvarchar(50)
	,	organization_nm_4		nvarchar(50)
	,	organization_nm_5		nvarchar(50)
	,	job_cd					smallint
	,	job_nm					nvarchar(50)
	,	position_cd				INT
	,	position_nm				nvarchar(50)
	,	grade					smallint
	,	grade_nm				nvarchar(50)
	,	office_cd				nvarchar(50)
	,	office_nm				nvarchar(50)
	,	user_id					nvarchar(50)
	,	authority_cd			smallint
	,	authority_nm			nvarchar(50)
	)
	--
	CREATE TABLE #TABLE_ORGANIZATION (
		id						int	identity(1, 1)
	,	organization_typ		tinyint
	,	organization_cd_1		nvarchar(20)
	,	organization_cd_2		nvarchar(20)
	,	organization_cd_3		nvarchar(20)
	,	organization_cd_4		nvarchar(20)
	,	organization_cd_5		nvarchar(20)	
	,	choice_in_screen		tinyint
	)
	--#TEMP_F0030
	CREATE TABLE #TEMP_F0030 (
		id				BIGINT IDENTITY(1,1) NOT NULL
	,	employee_cd		NVARCHAR(10)	
	)
	--
	INSERT INTO #TEMP_F0030
	SELECT
		F0030.employee_cd 
	FROM F0030
	WHERE
		F0030.company_cd	=	@P_company_cd
	AND F0030.del_datetime	IS NULL
	AND (
			(F0030.rater_employee_cd_1 =	@employee_cd)
		OR	(F0030.rater_employee_cd_2 =	@employee_cd)
		OR	(F0030.rater_employee_cd_3 =	@employee_cd)
		OR	(F0030.rater_employee_cd_4 =	@employee_cd)
	)
	AND	@P_authority_typ	=	2
	GROUP BY F0030.employee_cd
	--
	INSERT INTO #M0070
	SELECT
		M0070.employee_cd
	,	M0070.employee_nm
	,	M0070.employee_typ
	,	M0060.employee_typ_nm
	,	M0070.belong_cd1
	,	M0070.belong_cd2
	,	M0070.belong_cd3
	,	M0070.belong_cd4
	,	M0070.belong_cd5
	,CASE
		WHEN ISNULL(M0020_CD1.organization_ab_nm,'') = '' THEN ISNULL(M0020_CD1.organization_nm,'')	
		ELSE M0020_CD1.organization_ab_nm
	END																						AS organization_nm_1
	,CASE
		WHEN ISNULL(M0020_CD2.organization_ab_nm,'') = '' THEN ISNULL(M0020_CD2.organization_nm,'')		
		ELSE M0020_CD2.organization_ab_nm
	END																						AS organization_nm_2
	,CASE
		WHEN ISNULL(M0020_CD3.organization_ab_nm,'') = '' THEN ISNULL(M0020_CD3.organization_nm,'')		
		ELSE M0020_CD3.organization_ab_nm
	END																						AS organization_nm_3
	,CASE
		WHEN ISNULL(M0020_CD4.organization_ab_nm,'') = '' THEN ISNULL(M0020_CD4.organization_nm,'')		
		ELSE M0020_CD4.organization_ab_nm
	END																						AS organization_nm_4
	,CASE
		WHEN ISNULL(M0020_CD5.organization_ab_nm,'') = '' THEN ISNULL(M0020_CD5.organization_nm,'')		
		ELSE M0020_CD5.organization_ab_nm
	END																						AS organization_nm_5
	,	M0070.job_cd
	,CASE
		WHEN ISNULL(m0030.job_ab_nm,'') = '' THEN ISNULL(m0030.job_nm,'')		
		ELSE m0030.job_ab_nm
	END	 AS job_nm
	,	M0070.position_cd
	,CASE
		WHEN ISNULL(M0040.position_ab_nm,'') = '' THEN ISNULL(M0040.position_nm,'')		
		ELSE M0040.position_ab_nm
	END	AS position_nm
	,	M0070.grade
	,	M0050.grade_nm
	,	M0070.office_cd
	,CASE
		WHEN ISNULL(M0010.office_ab_nm,'') = '' THEN ISNULL(M0010.office_nm,'')		
		ELSE M0010.office_ab_nm
	END	AS office_nm
	,	S0010.user_id
	,	ISNULL(S0010.multireview_authority_cd, '')
	,	S3020.authority_nm
	FROM M0070
	LEFT JOIN M0060 ON (
		M0070.company_cd	=	M0060.company_cd
	AND	M0070.employee_typ	=	M0060.employee_typ
	)
	LEFT JOIN M0020 AS M0020_CD1 ON (
		M0070.company_cd	=	M0020_CD1.company_cd
	AND	1					=	M0020_CD1.organization_typ
	AND	M0070.belong_cd1	=	M0020_CD1.organization_cd_1
	)
	LEFT JOIN M0020 AS M0020_CD2 ON (
		M0070.company_cd	=	M0020_CD2.company_cd
	AND	2					=	M0020_CD2.organization_typ
	AND	M0070.belong_cd1	=	M0020_CD2.organization_cd_1
	AND	M0070.belong_cd2	=	M0020_CD2.organization_cd_2
	)
	LEFT JOIN M0020 AS M0020_CD3 ON (
		M0070.company_cd	=	M0020_CD3.company_cd
	AND	3					=	M0020_CD3.organization_typ
	AND	M0070.belong_cd1	=	M0020_CD3.organization_cd_1
	AND	M0070.belong_cd2	=	M0020_CD3.organization_cd_2
	AND	M0070.belong_cd3	=	M0020_CD3.organization_cd_3
	)
	LEFT JOIN M0020 AS M0020_CD4 ON (
		M0070.company_cd	=	M0020_CD4.company_cd
	AND	4					=	M0020_CD4.organization_typ
	AND	M0070.belong_cd1	=	M0020_CD4.organization_cd_1
	AND	M0070.belong_cd2	=	M0020_CD4.organization_cd_2
	AND	M0070.belong_cd3	=	M0020_CD4.organization_cd_3
	AND	M0070.belong_cd4	=	M0020_CD4.organization_cd_4
	)
	LEFT JOIN M0020 AS M0020_CD5 ON (
		M0070.company_cd	=	M0020_CD5.company_cd
	AND	5					=	M0020_CD5.organization_typ
	AND	M0070.belong_cd1	=	M0020_CD5.organization_cd_1
	AND	M0070.belong_cd2	=	M0020_CD5.organization_cd_2
	AND	M0070.belong_cd3	=	M0020_CD5.organization_cd_3
	AND	M0070.belong_cd4	=	M0020_CD5.organization_cd_4
	AND	M0070.belong_cd5	=	M0020_CD5.organization_cd_5
	)
	LEFT JOIN M0030 ON (
		M0070.company_cd	=	M0030.company_cd
	AND	M0070.job_cd		=	M0030.job_cd
	)
	LEFT JOIN M0040 ON (
		M0070.company_cd	=	M0040.company_cd
	AND	M0070.position_cd	=	M0040.position_cd
	)
	LEFT JOIN M0050 ON (
		M0070.company_cd	=	M0050.company_cd
	AND	M0070.grade			=	M0050.grade
	)
	LEFT JOIN M0010 ON (
		M0070.company_cd	=	M0010.company_cd
	AND	M0070.office_cd		=	M0010.office_cd
	)
	LEFT JOIN S0010 ON (
		M0070.company_cd	=	S0010.company_cd
	AND	M0070.employee_cd	=	S0010.employee_cd
	AND	S0010.del_datetime IS NULL
	)
	LEFT JOIN S3020 ON (
		M0070.company_cd	=	S3020.company_cd
	AND	S0010.multireview_authority_cd		=	S3020.authority_cd
	)
	LEFT JOIN S3020 AS S3020_LOGIN ON (
		M0070.company_cd		=	S3020_LOGIN.company_cd
	AND	@P_authority_cd			=	S3020_LOGIN.authority_cd
	)
	LEFT JOIN #TEMP_F0030 ON (
		M0070.employee_cd	=	#TEMP_F0030.employee_cd 
	)
	WHERE
		M0070.company_cd	=	@P_company_cd
	AND	M0070.del_datetime IS NULL
	AND ISNULL(S0010.multireview_authority_typ,0) <> 5				-- add by viettd 2021/10/12
	AND (
		@P_employee_cd = ''
	OR	(@P_employee_cd <> '' AND M0070.employee_cd = @P_employee_cd)
	)
	AND(
			@P_employee_nm				=	''
		OR	(dbo.FNC_COM_REPLACE_SPACE(M0070.employee_nm)		LIKE	'%' +	dbo.FNC_COM_REPLACE_SPACE(@P_employee_nm)		+ '%')
		OR	(dbo.FNC_COM_REPLACE_SPACE(M0070.furigana)			LIKE	'%' +	dbo.FNC_COM_REPLACE_SPACE(@P_employee_nm)		+ '%')
	)
	AND (
		@P_employee_typ = 0
	OR	(@P_employee_typ <> 0 AND M0070.employee_typ = @P_employee_typ)
	)
	AND	(@P_organization_cd_1 = '-1'	OR	M0070.belong_cd1 =	@P_organization_cd_1)
	AND	(@P_organization_cd_2 = '-1'	OR	M0070.belong_cd2 =	@P_organization_cd_2)
	AND	(@P_organization_cd_3 = '-1'	OR	M0070.belong_cd3 =	@P_organization_cd_3)
	AND	(@P_organization_cd_4 = '-1'	OR	M0070.belong_cd4 =	@P_organization_cd_4)
	AND	(@P_organization_cd_5 = '-1'	OR	M0070.belong_cd5 =	@P_organization_cd_5)
	AND (
		@P_position_cd = 0
	OR	(@P_position_cd <> 0 AND M0070.position_cd = @P_position_cd)
	)
	AND (
		@P_authority_cd_screen = 0
	OR	(@P_authority_cd_screen <> 0 AND S0010.multireview_authority_cd = @P_authority_cd_screen)
	)
	AND (
			@P_authority_typ	<> 3
		OR (
				@P_authority_typ	= 3 
				AND(
					(ISNULL(S3020_LOGIN.use_typ,0)	<> 1 OR ( ISNULL(S3020_LOGIN.use_typ,0)  = 1 AND ISNULL(M0040.arrange_order,0) > @arrange_order ))
				)
			)
	)
	AND (
			(@P_authority_typ	<>	2) 
		OR	(@P_authority_typ	=	2	AND #TEMP_F0030.employee_cd IS NOT NULL)
	)
	AND (M0070.company_out_dt IS  NULL OR M0070.company_out_dt >=  @w_time)
	
	--
	IF @P_check_authority = 1
	BEGIN
		DELETE D FROM #M0070 AS D
		INNER JOIN S0010 ON (
			@P_company_cd		= S0010.company_cd
		AND D.employee_cd		= S0010.employee_cd
		)
		WHERE
			ISNULL(S0010.multireview_authority_cd,0) <> 0
		AND S0010.del_datetime IS NULL
	END
	-- get permission
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 @P_json,@P_user_id,@P_company_cd,3

	--
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
	BEGIN
		SET @choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
		-- 1.choice in screen 
		-- 0.get from master S0022
		-- Filter organization_typ = 1
		IF @choice_in_screen = 1
		BEGIN
			DELETE D FROM #M0070 AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.belong_cd1			=	S.organization_cd_1
			AND D.belong_cd2			=	S.organization_cd_2
			AND D.belong_cd3			=	S.organization_cd_3
			AND D.belong_cd4			=	S.organization_cd_4
			AND D.belong_cd5			=	S.organization_cd_5
			)
			WHERE 
				D.employee_cd IS NULL
			OR	S.organization_typ IS NULL
		END
		ELSE IF NOT (@P_authority_typ = 3 AND @w_mulitireview_organization_cnt = 0 AND @w_organization_belong_person_typ = 0) -- edited by viettd 2021/06/03
		BEGIN
			DELETE D FROM #M0070 AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.belong_cd1			=	S.organization_cd_1
			AND D.belong_cd2			=	S.organization_cd_2
			AND D.belong_cd3			=	S.organization_cd_3
			AND D.belong_cd4			=	S.organization_cd_4
			AND D.belong_cd5			=	S.organization_cd_5
			)
			WHERE 
				D.employee_cd IS NULL
			OR	S.organization_typ IS NULL
			AND @P_authority_typ  NOT IN(4,5) --4.会社管理者 5.総合管理者
		END
	END

	--[0]
	SELECT 
		id
	,	employee_cd			
	,	employee_nm			
	,	employee_typ		
	,	employee_typ_nm		
	,	belong_cd1			
	,	belong_cd2			
	,	belong_cd3			
	,	belong_cd4			
	,	belong_cd5			
	,	organization_nm_1	
	,	organization_nm_2	
	,	organization_nm_3	
	,	organization_nm_4	
	,	organization_nm_5	
	,	job_cd				
	,	job_nm				
	,	position_cd			
	,	position_nm			
	,	grade				
	,	grade_nm			
	,	office_cd			
	,	office_nm			
	,	user_id				
	,	authority_cd		
	,	authority_nm		
	FROM #M0070
	ORDER BY 
		CASE ISNUMERIC(#M0070.employee_cd) 
		   WHEN 1 
		   THEN CAST(#M0070.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	#M0070.employee_cd
	offset (@P_page - 1) * @P_page_size rows
	fetch next @P_page_size rows only

	SET @totalRecord = (SELECT COUNT(1) FROM #M0070)
	SET @pageMax = CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	IF @pageMax = 0
	BEGIN
		SET @pageMax = 1
	END
	IF @P_page > @pageMax
	BEGIN
		SET @P_page = @pageMax
	END	

	--[1]
	SELECT	
		@totalRecord	AS totalRecord
	,	@pageMax		AS pageMax
	,	@P_page			AS page
	,	@P_page_size	AS pagesize
	,	((@P_page - 1) * @P_page_size + 1) AS offset

	--[2]
	SELECT
		organization_typ
	,	use_typ
	,	organization_group_nm
	FROM M0022
	WHERE
		company_cd = @P_company_cd
	AND	del_datetime IS NULL

	--[3]
	SELECT 
		id						
	,	organization_typ		
	,	organization_cd_1		
	,	organization_cd_2		
	,	organization_cd_3		
	,	organization_cd_4		
	,	organization_cd_5		
	,	choice_in_screen		
	FROM #TABLE_ORGANIZATION

	--
	DROP TABLE #M0070, #TABLE_ORGANIZATION, #TEMP_F0030

END
GO
