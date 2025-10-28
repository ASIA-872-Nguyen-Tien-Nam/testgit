IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_COMPREHENSIVE_EMPLOYEE_FND1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_COMPREHENSIVE_EMPLOYEE_FND1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：POPUP SEARCH EMPLOYEE COMPREHENSIVE MANAGER
 *
 *  作成日  ：2021/05/157
 *  作成者  ：ANS-ASIA VIETDT
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
 CREATE PROCEDURE [SPC_COMPREHENSIVE_EMPLOYEE_FND1] 
 	@P_company_cd			SMALLINT			=	0
,	@P_page_size			INT					=	20
,	@P_page					INT					=	1
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@ERR_TBL				ERRTABLE
	,	@totalRecord			BIGINT				=	0
	,	@pageNumber				INT					=	0
	,	@pageMax				INT					=	0	
	,	@arrange_order			INT					=	0
	--#EMPLOYEEE MPLOYEE COMPREHENSIVE MANAGER
	CREATE TABLE #EMPLOYEE(
	 	company_cd			SMALLINT		
	, 	employee_cd			NVARCHAR(10)	
	)	
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- GET ALL EMPLOYEE_CD
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	INSERT INTO #EMPLOYEE
	SELECT 
		M0070.company_cd
	,	M0070.employee_cd
	FROM S0010 
	INNER JOIN M0070 ON(
		S0010.company_cd	=	M0070.company_cd
	AND	S0010.employee_cd	=	M0070.employee_cd
	AND	M0070.del_datetime	IS NULL
	)
	WHERE 
		S0010.company_cd			=	@P_company_cd
	AND	S0010.[1on1_authority_typ]	=5
	AND	S0010.del_datetime IS NULL
	--
	SET @totalRecord = (SELECT COUNT(1) FROM #EMPLOYEE)
	SET @pageMax = CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	IF @pageMax = 0
	BEGIN
		SET @pageMax = 1
	END
	IF @P_page > @pageMax
	BEGIN
		SET @P_page = @pageMax
	END	
	-- [0]
	SELECT 
		#EMPLOYEE.company_cd			
	,	ISNULL(#EMPLOYEE.employee_cd,'')	AS employee_cd			
	,	''									AS employee_ab_nm		
	,	ISNULL(M0010.office_nm,'')			AS office_nm		
	,	ISNULL(M0070.employee_nm,'')		AS employee_nm			
	,	ISNULL(M0070.employee_typ,0)		AS employee_typ	
	,	ISNULL(M0060.employee_typ_nm,'')	AS employee_typ_nm		
	,	ISNULL(M1.organization_nm,'')		AS organization_nm1	
	,	ISNULL(M2.organization_nm,'')		AS organization_nm2
	,	ISNULL(M3.organization_nm,'')		AS organization_nm3	
	,	ISNULL(M4.organization_nm,'')		AS organization_nm4
	,	ISNULL(M5.organization_nm,'')		AS organization_nm5	
	,	ISNULL(M0030.job_nm,'')				AS job_nm				
	,	ISNULL(M0040.position_nm,'')		AS position_nm			
	,	ISNULL(M0050.grade_nm,'')			AS grade_nm	
	FROM #EMPLOYEE
	INNER JOIN M0070 ON (
		#EMPLOYEE.company_cd	=	M0070.company_cd
	AND	#EMPLOYEE.employee_cd	=	M0070.employee_cd
	AND	M0070.del_datetime		IS NULL
	)
	LEFT JOIN M0010 ON (
		M0070.company_cd = M0010.company_cd
	AND M0070.office_cd = M0010.office_cd
	)
	LEFT JOIN M0020 AS M1 ON (
		M1.company_cd			=	M0070.company_cd
	AND M1.organization_cd_1	=	M0070.belong_cd1
	AND M1.organization_typ		=	1
	) 
	LEFT JOIN M0020 AS M2 ON (
		M2.company_cd			=	M0070.company_cd
	AND M2.organization_cd_1		=	M0070.belong_cd1
	AND M2.organization_cd_2		=	M0070.belong_cd2
	AND M2.organization_typ		=	2
	) 
	LEFT JOIN M0020 AS M3 ON (
		M3.company_cd			=	M0070.company_cd
	AND M3.organization_cd_1		=	M0070.belong_cd1
	AND M3.organization_cd_2		=	M0070.belong_cd2
	AND M3.organization_cd_3		=	M0070.belong_cd3
	AND M3.organization_typ		=	3
	) 
	LEFT JOIN M0020 AS M4 ON (
		M4.company_cd			=	M0070.company_cd
	AND M4.organization_cd_1		=	M0070.belong_cd1
	AND M4.organization_cd_2		=	M0070.belong_cd2
	AND M4.organization_cd_3		=	M0070.belong_cd3
	AND M4.organization_cd_4		=	M0070.belong_cd4
	AND M4.organization_typ		=	4
	) 
	LEFT JOIN M0020 AS M5 ON (
		M5.company_cd			=	M0070.company_cd
	AND M5.organization_cd_1		=	M0070.belong_cd1
	AND M5.organization_cd_2		=	M0070.belong_cd2
	AND M5.organization_cd_3		=	M0070.belong_cd3
	AND M5.organization_cd_4		=	M0070.belong_cd4
	AND M5.organization_cd_5		=	M0070.belong_cd5
	AND M5.organization_typ		=	5
	) 
	LEFT JOIN M0030 ON (
		M0070.company_cd = M0030.company_cd
	AND M0070.job_cd	= M0030.job_cd
	)
	LEFT JOIN M0040 ON (
		M0070.company_cd  = M0040.company_cd
	AND M0070.position_cd	= M0040.position_cd
	)
	LEFT JOIN M0050 ON (
		M0070.company_cd = M0050.company_cd
	AND M0070.grade = M0050.grade
	)
	LEFT JOIN M0060 ON (
		M0070.company_cd = M0060.company_cd
	AND M0070.employee_typ = M0060.employee_typ
	)
	ORDER BY 
		CASE ISNUMERIC(#EMPLOYEE.employee_cd) 
		   WHEN 1 
		   THEN CAST(#EMPLOYEE.employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	#EMPLOYEE.employee_cd
	offset (@P_page - 1) * @P_page_size rows
	fetch next @P_page_size rows only
	--[1]
	SELECT	
		@totalRecord	AS totalRecord
	,	@pageMax		AS pageMax
	,	@P_page			AS page
	,	@P_page_size	AS pagesize
	,	((@P_page - 1) * @P_page_size + 1) AS offset
	--CLEAN
	DROP TABLE #EMPLOYEE
END
GO
