IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_WeeklyReport_GET_SEARCH_CONDITIONS_INQ1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_WeeklyReport_GET_SEARCH_CONDITIONS_INQ1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_WeeklyReport_GET_SEARCH_CONDITIONS_INQ1 '{"fiscal_year":"2021","position_cd":"10","job_cd":"4","employee_typ":"1","coach_nm":"ANS 201","list_group_1on1":[{"group_cd_1on1":"1"},{"group_cd_1on1":"2"},{"group_cd_1on1":"3"}],"list_organization_step1":[{"organization_cd_1":"1"},{"organization_cd_1":"2"}],"list_organization_step2":[{"organization_cd_1":"1","organization_cd_2":"1","organization_cd_3":"","organization_cd_4":"","organization_cd_5":""},{"organization_cd_1":"1","organization_cd_2":"2","organization_cd_3":"","organization_cd_4":"","organization_cd_5":""}],"list_organization_step3":[{"organization_cd_1":"1","organization_cd_2":"1","organization_cd_3":"1","organization_cd_4":"","organization_cd_5":""},{"organization_cd_1":"1","organization_cd_2":"1","organization_cd_3":"2","organization_cd_4":"","organization_cd_5":""},{"organization_cd_1":"1","organization_cd_2":"2","organization_cd_3":"1","organization_cd_4":"","organization_cd_5":""},{"organization_cd_1":"1","organization_cd_2":"2","organization_cd_3":"2","organization_cd_4":"","organization_cd_5":""}],"list_organization_step4":[{"organization_cd_1":"1","organization_cd_2":"2","organization_cd_3":"1","organization_cd_4":"1","organization_cd_5":""},{"organization_cd_1":"1","organization_cd_2":"2","organization_cd_3":"2","organization_cd_4":"1","organization_cd_5":""},{"organization_cd_1":"1","organization_cd_2":"2","organization_cd_3":"2","organization_cd_4":"2","organization_cd_5":""}],"list_organization_step5":[{"organization_cd_1":"1","organization_cd_2":"2","organization_cd_3":"1","organization_cd_4":"1","organization_cd_5":"1"}],"list_grade":[{"grade":"1"},{"grade":"2"},{"grade":"3"},{"grade":"4"}]}',721,740

--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET ALL CONDITION OF ANALYSIS (rQ3010~rQ3040)
--*  
--*  作成日/create date			:	2023/05/24				
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--* 
--****************************************************************************************
CREATE PROCEDURE [SPC_WeeklyReport_GET_SEARCH_CONDITIONS_INQ1]
	-- Add the parameters for the stored procedure here
	@P_json						nvarchar(max)		=	''	
,	@P_cre_user					nvarchar(50)		=	''	
,	@P_company_cd				smallint			=	0
,	@P_target_type				smallint			=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_fiscal_year						int					=	0
	,	@w_employee_typ						smallint			=	0
	,	@w_position_cd						int					=	0
	,	@w_job_cd							smallint			=	0
	,	@w_view_unit						smallint			=	0	-- 0.全社、1.部署 、2.職種、3.等級、4.年齢
	,	@w_target							smallint			=	0	-- 0.点数 1.回答率
	,	@w_submit							smallint			=	0	-- 1.コーチ 2.メンバー
	--	oq2033
	,	@w_combination_vertical				smallint			=	0	-- 組み合わせ 1
	,	@w_combination_horizontal			smallint			=	0	-- 組み合わせ 2
	--  rq3020
	,	@w_field_3020						smallint			=	0	
	,	@w_field_3030						smallint			=	0
	,	@w_language							smallint			=	1	-- 1:jp / 2:en
	--
	SELECT 
		@w_language				=	ISNULL(S0010.language,1)
	FROM S0010
	WHERE 
		S0010.company_cd	= @P_company_cd 
	AND S0010.user_id		= @P_cre_user
	AND S0010.del_datetime IS NULL
	--
	CREATE TABLE #TABLE_ORGANIZATION_ANALYSIS (
		organization_typ				tinyint
	,	organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)
	,	organization_nm					nvarchar(50)
	)
	--
	CREATE TABLE #LIST_POSITION_ANALYSIS(
		id								int			identity(1,1)
	,	position_cd						int
	,	mode							smallint
	)
	--
	CREATE TABLE #LIST_GRADE_ANALYSIS(
		id								int			identity(1,1)
	,	grade							smallint
	)
	--
	CREATE TABLE #LIST_GROUP_ANALYSIS (
		id								int			identity(1,1)
	,	group_cd						smallint
	)
	--
	CREATE TABLE #TABLE_SEARCH_CONDITIONS(
		fiscal_year_nm				nvarchar(10)
	,	group_cd_nm					nvarchar(500)
	,	organization_hd_1			nvarchar(20)
	,	organization_hd_2			nvarchar(20)
	,	organization_hd_3			nvarchar(20)
	,	organization_hd_4			nvarchar(20)
	,	organization_hd_5			nvarchar(20)
	,	organization_nm_1			nvarchar(500)
	,	organization_nm_2			nvarchar(500)
	,	organization_nm_3			nvarchar(500)
	,	organization_nm_4			nvarchar(500)
	,	organization_nm_5			nvarchar(500)
	,	position_nm					nvarchar(20)
	,	job_nm						nvarchar(20)
	,	grade_nm					nvarchar(500)
	,	employee_typ_nm				nvarchar(20)
	)
	-- GET VALUE FROM JSON
	SET @w_fiscal_year				=	JSON_VALUE(@P_json,'$.fiscal_year')							-- 年度
	SET @w_employee_typ				=	JSON_VALUE(@P_json,'$.employee_typ')						-- 社員区分
	SET @w_position_cd				=	JSON_VALUE(@P_json,'$.position_cd')							-- 役職						
	SET @w_job_cd					=	JSON_VALUE(@P_json,'$.job_cd')								-- 職種
	SET @w_view_unit				=	ISNULL(JSON_VALUE(@P_json,'$.view_unit'),0)					-- 表示単位
	SET @w_target					=	ISNULL(JSON_VALUE(@P_json,'$.target'),0)					-- 対象
	SET @w_submit					=	ISNULL(JSON_VALUE(@P_json,'$.submit'),0)					-- 回答者
	-- oq2033
	SET @w_combination_vertical		=	ISNULL(JSON_VALUE(@P_json,'$.combination_vertical'),0)		-- 組み合わせ 1
	SET @w_combination_horizontal	=	ISNULL(JSON_VALUE(@P_json,'$.combination_horizontal'),0)	-- 組み合わせ 2
	SET @w_field_3020				=	ISNULL(JSON_VALUE(@P_json,'$.adequacy_type'),0)
	SET @w_field_3030				=	ISNULL(JSON_VALUE(@P_json,'$.employee_role'),0)
	-- INSERT DATA INTO #LIST_POSITION_ANALYSIS
	IF @w_position_cd IS NOT NULL AND @w_position_cd <> -1
	BEGIN
		INSERT INTO #LIST_POSITION_ANALYSIS SELECT @w_position_cd , 0
	END
	-- INSERT DATA INTO #LIST_GRADE_ANALYSIS
	INSERT INTO #LIST_GRADE_ANALYSIS
	SELECT json_table.grade FROM OPENJSON(@P_json,'$.list_grade') WITH(
		grade	smallint
	)AS json_table
	WHERE
		json_table.grade > 0
	-- INSERT DATA INTO #GROUP_1ON1
	INSERT INTO #LIST_GROUP_ANALYSIS
	SELECT json_table.group_cd FROM OPENJSON(@P_json,'$.list_group_cd') WITH(
		group_cd	smallint
	)AS json_table
	WHERE
		json_table.group_cd > 0
	-- INSERT DATA INTO #TABLE_ORGANIZATION_ANALYSIS
	--組織１
	INSERT INTO #TABLE_ORGANIZATION_ANALYSIS
	SELECT 
		1
	,	ISNULL(json_table.organization_cd_1,'')
	,	ISNULL(json_table.organization_cd_2,'')
	,	ISNULL(json_table.organization_cd_3,'')
	,	ISNULL(json_table.organization_cd_4,'')
	,	ISNULL(json_table.organization_cd_5,'')
	,	SPACE(0)						AS	organization_nm
	FROM OPENJSON(@P_json,'$.list_organization_step1') WITH(
		organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)
	)AS json_table
	WHERE
		json_table.organization_cd_1 <> ''
	--組織２
	INSERT INTO #TABLE_ORGANIZATION_ANALYSIS
	SELECT 
		2
	,	ISNULL(json_table.organization_cd_1,'')
	,	ISNULL(json_table.organization_cd_2,'')
	,	ISNULL(json_table.organization_cd_3,'')
	,	ISNULL(json_table.organization_cd_4,'')
	,	ISNULL(json_table.organization_cd_5,'')
	,	SPACE(0)						AS	organization_nm
	FROM OPENJSON(@P_json,'$.list_organization_step2') WITH(
		organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)
	)AS json_table
	WHERE
		json_table.organization_cd_2 <> ''
	--組織３
	INSERT INTO #TABLE_ORGANIZATION_ANALYSIS
	SELECT 
		3
	,	ISNULL(json_table.organization_cd_1,'')
	,	ISNULL(json_table.organization_cd_2,'')
	,	ISNULL(json_table.organization_cd_3,'')
	,	ISNULL(json_table.organization_cd_4,'')
	,	ISNULL(json_table.organization_cd_5,'')
	,	SPACE(0)						AS	organization_nm
	FROM OPENJSON(@P_json,'$.list_organization_step3') WITH(
		organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)
	)AS json_table
	WHERE
		json_table.organization_cd_3 <> ''
	--組織４
	INSERT INTO #TABLE_ORGANIZATION_ANALYSIS
	SELECT 
		4
	,	ISNULL(json_table.organization_cd_1,'')
	,	ISNULL(json_table.organization_cd_2,'')
	,	ISNULL(json_table.organization_cd_3,'')
	,	ISNULL(json_table.organization_cd_4,'')
	,	ISNULL(json_table.organization_cd_5,'')
	,	SPACE(0)						AS	organization_nm
	FROM OPENJSON(@P_json,'$.list_organization_step4') WITH(
		organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)
	)AS json_table
	WHERE
		json_table.organization_cd_4 <> ''
	--組織５
	INSERT INTO #TABLE_ORGANIZATION_ANALYSIS
	SELECT 
		5
	,	ISNULL(json_table.organization_cd_1,'')
	,	ISNULL(json_table.organization_cd_2,'')
	,	ISNULL(json_table.organization_cd_3,'')
	,	ISNULL(json_table.organization_cd_4,'')
	,	ISNULL(json_table.organization_cd_5,'')
	,	SPACE(0)						AS	organization_nm
	FROM OPENJSON(@P_json,'$.list_organization_step5') WITH(
		organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)
	)AS json_table
	WHERE
		json_table.organization_cd_5 <> ''
	-- UPDATE organization_nm
	UPDATE #TABLE_ORGANIZATION_ANALYSIS SET 
		organization_nm	=	ISNULL(M0020.organization_nm,'')
	FROM #TABLE_ORGANIZATION_ANALYSIS
	INNER JOIN M0020 ON (
		@P_company_cd										=	M0020.company_cd
	AND #TABLE_ORGANIZATION_ANALYSIS.organization_cd_1		=	M0020.organization_cd_1
	AND #TABLE_ORGANIZATION_ANALYSIS.organization_cd_2		=	M0020.organization_cd_2
	AND #TABLE_ORGANIZATION_ANALYSIS.organization_cd_3		=	M0020.organization_cd_3
	AND #TABLE_ORGANIZATION_ANALYSIS.organization_cd_4		=	M0020.organization_cd_4
	AND #TABLE_ORGANIZATION_ANALYSIS.organization_cd_5		=	M0020.organization_cd_5
	AND M0020.del_datetime IS NULL
	)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--INSERT DATA INTO TEMP TABLE
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	INSERT INTO #TABLE_SEARCH_CONDITIONS
	SELECT 
		CAST(@w_fiscal_year AS nvarchar(4)) + IIF(@w_language = 2,'','年度')		AS	fiscal_year_nm
	,	STUFF((SELECT N', '+ CAST(ISNULL(M4600.group_nm,'') AS NVARCHAR(20))
								FROM #LIST_GROUP_ANALYSIS
								LEFT OUTER JOIN M4600 ON (
									@P_company_cd					=	M4600.company_cd
								AND #LIST_GROUP_ANALYSIS.group_cd	=	M4600.group_cd
								AND M4600.del_datetime IS NULL
								)
								FOR XML PATH(''),TYPE).value(N'.[1]', N'nvarchar(max)'),1, 1, N'')
	,	(SELECT ISNULL(M0022.organization_group_nm,IIF(@w_language = 2,'Organization 1','組織１')) FROM M0022 WHERE M0022.company_cd = @P_company_cd AND M0022.organization_typ = 1 AND M0022.use_typ = 1 AND M0022.del_datetime IS NULL)
	,	(SELECT ISNULL(M0022.organization_group_nm,IIF(@w_language = 2,'Organization 2','組織２')) FROM M0022 WHERE M0022.company_cd = @P_company_cd AND M0022.organization_typ = 2 AND M0022.use_typ = 1 AND M0022.del_datetime IS NULL)
	,	(SELECT ISNULL(M0022.organization_group_nm,IIF(@w_language = 2,'Organization 3','組織３')) FROM M0022 WHERE M0022.company_cd = @P_company_cd AND M0022.organization_typ = 3 AND M0022.use_typ = 1 AND M0022.del_datetime IS NULL)
	,	(SELECT ISNULL(M0022.organization_group_nm,IIF(@w_language = 2,'Organization 4','組織４')) FROM M0022 WHERE M0022.company_cd = @P_company_cd AND M0022.organization_typ = 4 AND M0022.use_typ = 1 AND M0022.del_datetime IS NULL)
	,	(SELECT ISNULL(M0022.organization_group_nm,IIF(@w_language = 2,'Organization 5','組織５')) FROM M0022 WHERE M0022.company_cd = @P_company_cd AND M0022.organization_typ = 5 AND M0022.use_typ = 1 AND M0022.del_datetime IS NULL)
	,	STUFF((SELECT N', '+ CAST(ISNULL(organization_nm,'') AS NVARCHAR(20))
								FROM #TABLE_ORGANIZATION_ANALYSIS
								WHERE 
									#TABLE_ORGANIZATION_ANALYSIS.organization_typ	=	1
								FOR XML PATH(''),TYPE).value(N'.[1]', N'nvarchar(max)'),1, 1, N'')
	,	STUFF((SELECT N', '+ CAST(ISNULL(organization_nm,'') AS NVARCHAR(20))
								FROM #TABLE_ORGANIZATION_ANALYSIS
								WHERE 
									#TABLE_ORGANIZATION_ANALYSIS.organization_typ	=	2
								FOR XML PATH(''),TYPE).value(N'.[1]', N'nvarchar(max)'),1, 1, N'')
	,	STUFF((SELECT N', '+ CAST(ISNULL(organization_nm,'') AS NVARCHAR(20))
								FROM #TABLE_ORGANIZATION_ANALYSIS
								WHERE 
									#TABLE_ORGANIZATION_ANALYSIS.organization_typ	=	3
								FOR XML PATH(''),TYPE).value(N'.[1]', N'nvarchar(max)'),1, 1, N'')
	,	STUFF((SELECT N', '+ CAST(ISNULL(organization_nm,'') AS NVARCHAR(20))
								FROM #TABLE_ORGANIZATION_ANALYSIS
								WHERE 
									#TABLE_ORGANIZATION_ANALYSIS.organization_typ	=	4
								FOR XML PATH(''),TYPE).value(N'.[1]', N'nvarchar(max)'),1, 1, N'')
	,	STUFF((SELECT N', '+ CAST(ISNULL(organization_nm,'') AS NVARCHAR(20))
								FROM #TABLE_ORGANIZATION_ANALYSIS
								WHERE 
									#TABLE_ORGANIZATION_ANALYSIS.organization_typ	=	5
								FOR XML PATH(''),TYPE).value(N'.[1]', N'nvarchar(max)'),1, 1, N'')
	,	SPACE(0)	--	position_nm		
	,	SPACE(0)	--	job_nm			
	,	STUFF((SELECT N', '+ CAST(ISNULL(M0050.grade_nm,'') AS NVARCHAR(20))
								FROM #LIST_GRADE_ANALYSIS
								LEFT OUTER JOIN M0050 ON (
									@P_company_cd			=	M0050.company_cd
								AND #LIST_GRADE_ANALYSIS.grade		=	M0050.grade
								AND M0050.del_datetime IS NULL
								)
								FOR XML PATH(''),TYPE).value(N'.[1]', N'nvarchar(max)'),1, 1, N'')
	,	SPACE(0)	--	employee_typ_nm	
	-- UPDATE position_nm
	UPDATE #TABLE_SEARCH_CONDITIONS SET 
		position_nm	= ISNULL(M0040.position_nm,'')
	FROM #TABLE_SEARCH_CONDITIONS
	INNER JOIN M0040 ON (
		@P_company_cd		=	M0040.company_cd
	AND @w_position_cd		=	M0040.position_cd
	AND M0040.del_datetime IS NULL
	)
	-- UPDATE job_nm
	UPDATE #TABLE_SEARCH_CONDITIONS SET 
		job_nm	= ISNULL(M0030.job_nm,'')
	FROM #TABLE_SEARCH_CONDITIONS
	INNER JOIN M0030 ON (
		@P_company_cd		=	M0030.company_cd
	AND @w_job_cd			=	M0030.job_cd
	AND M0030.del_datetime IS NULL
	)
	-- UPDATE employee_typ_nm
	UPDATE #TABLE_SEARCH_CONDITIONS SET 
		employee_typ_nm	= ISNULL(M0060.employee_typ_nm,'')
	FROM #TABLE_SEARCH_CONDITIONS
	INNER JOIN M0060 ON (
		@P_company_cd		=	M0060.company_cd
	AND @w_employee_typ		=	M0060.employee_typ
	AND M0060.del_datetime IS NULL
	)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	SELECT 
		fiscal_year_nm							AS	fiscal_year_nm		
	,	group_cd_nm								AS	group_cd_nm	
	,	ISNULL(organization_hd_1,IIF(@w_language = 2,'Organization 1',N'組織１'))		AS	organization_hd_1		
	,	ISNULL(organization_hd_2,IIF(@w_language = 2,'Organization 2',N'組織２'))		AS	organization_hd_2		
	,	ISNULL(organization_hd_3,IIF(@w_language = 2,'Organization 3',N'組織３'))		AS	organization_hd_3		
	,	ISNULL(organization_hd_4,IIF(@w_language = 2,'Organization 4',N'組織４'))		AS	organization_hd_4		
	,	ISNULL(organization_hd_5,IIF(@w_language = 2,'Organization 5',N'組織５'))		AS	organization_hd_5		
	,	organization_nm_1						AS	organization_nm_1	
	,	organization_nm_2						AS	organization_nm_2	
	,	organization_nm_3						AS	organization_nm_3	
	,	organization_nm_4						AS	organization_nm_4	
	,	organization_nm_5						AS	organization_nm_5	
	,	position_nm								AS	position_nm			
	,	job_nm									AS	job_nm				
	,	grade_nm								AS	grade_nm			
	,	employee_typ_nm							AS	employee_typ_nm		
	,	CASE 
			WHEN @w_view_unit = 1 THEN IIF(@w_language = 2,'Department',N'部署') 
			WHEN @w_view_unit = 2 THEN IIF(@w_language = 2,'Job',N'職種')
			WHEN @w_view_unit = 3 THEN IIF(@w_language = 2,'Grade',N'等級')
			WHEN @w_view_unit = 4 THEN IIF(@w_language = 2,'Age',N'年齢')
			ELSE IIF(@w_language = 2,'Whole Company',N'全社')
		END										AS	view_unit_nm		-- 集計単位 -- 0.全社、1.部署 、2.職種、3.等級、4.年齢
	,	CASE 
			WHEN @w_submit = 1 THEN IIF(@w_language = 2,'Coach',N'コーチ') 
			WHEN @w_submit = 2 THEN IIF(@w_language = 2,'Member',N'メンバー')
			ELSE N''
		END										AS	submit_nm			-- 回答者 -- 1.コーチ 2.メンバー
	,	CASE 
			WHEN @w_target = 0 THEN IIF(@w_language = 2,'Points',N'点数')
			WHEN @w_target = 1 THEN IIF(@w_language = 2,'Response Rate',N'回答率')
			ELSE N''
		END										AS	target_nm			-- 対象 -- 0.点数 1.回答率
	,	CASE 
			WHEN @w_combination_vertical = 1 THEN IIF(@w_language = 2,'Progress Status',N'実施状況')
			WHEN @w_combination_vertical = 2 THEN IIF(@w_language = 2,'Satisfaction Level',N'充実度')
			WHEN @w_combination_vertical = 3 THEN IIF(@w_language = 2,'Reactions',N'リアクション')
			ELSE N''
		END										AS	 combination_vertical	--組み合わせ 1
	,	CASE 
			WHEN @w_combination_horizontal = 1 THEN IIF(@w_language = 2,'Progress Status',N'実施状況')
			WHEN @w_combination_horizontal = 2 THEN IIF(@w_language = 2,'Satisfaction Level',N'充実度')
			WHEN @w_combination_horizontal = 3 THEN IIF(@w_language = 2,'Reactions',N'リアクション')
			ELSE N''
		END										AS	 combination_horizontal	--組み合わせ 2
	,	CASE 
			WHEN @w_field_3020 = 1 THEN IIF(@w_language = 2,'Adequacy',N'充実度')
			WHEN @w_field_3020 = 2 THEN IIF(@w_language = 2,'Busyness',N'繁忙度')
			ELSE N''
		END										AS	 field_3020_nm	--組み合わせ 2
	,	CASE 
			WHEN @w_field_3030 = 1 THEN IIF(@w_language = 2,'Approver Reaction',N'承認者リアクション')
			WHEN @w_field_3030 = 2 THEN IIF(@w_language = 2,'Viewer Reaction',N'閲覧者リアクション')
			ELSE N''
		END										AS	 field_3030_nm	--組み合わせ 2
	,	@w_language								AS   language
	FROM #TABLE_SEARCH_CONDITIONS
	-- DROP TEMP TABLE
	DROP TABLE #LIST_GRADE_ANALYSIS
	DROP TABLE #LIST_GROUP_ANALYSIS
	DROP TABLE #LIST_POSITION_ANALYSIS
	DROP TABLE #TABLE_ORGANIZATION_ANALYSIS
	DROP TABLE #TABLE_SEARCH_CONDITIONS
END
GO