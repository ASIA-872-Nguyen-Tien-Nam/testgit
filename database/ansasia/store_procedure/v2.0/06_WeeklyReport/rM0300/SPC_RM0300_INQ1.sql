DROP PROCEDURE [SPC_RM0300_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  SPC_RM0300_INQ1 
 *

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	REFER DATA
--*		
--* 作成日/create date			:	2023/04/17										
--*	作成者/creater				:	namnt			
--*   		
--****************************************************************************************/
CREATE PROCEDURE [SPC_RM0300_INQ1]
	@P_group_cd			SMALLINT = 0
,	@P_company_cd		SMALLINT = 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@w_belong_cd1_emp	SMALLINT = 0
	,	@w_belong_cd2_emp	SMALLINT = 0
	,	@w_belong_cd3_emp	SMALLINT = 0
	,	@w_belong_cd4_emp	SMALLINT = 0
	,	@w_belong_cd5_emp	SMALLINT = 0
	,	@w_belong_cd2_1_emp SMALLINT = 0
	,	@w_belong_cd2_2_emp SMALLINT = 0
	,	@w_belong_cd2_3_emp SMALLINT = 0
	,	@w_belong_cd2_4_emp SMALLINT = 0
	,	@w_belong_cd2_5_emp SMALLINT = 0
	SET @w_belong_cd1_emp	  = (SELECT ISNULL(M4601.organization_cd_1,0) from M4601 WHERE company_cd =@P_company_cd AND group_cd = @P_group_cd)
	SET @w_belong_cd2_emp	  = (SELECT ISNULL(M4601.organization_cd_2,0) from M4601 WHERE company_cd =@P_company_cd AND group_cd = @P_group_cd)
	SET @w_belong_cd3_emp	  = (SELECT ISNULL(M4601.organization_cd_3,0) from M4601 WHERE company_cd =@P_company_cd AND group_cd = @P_group_cd)
	SET @w_belong_cd4_emp	  = (SELECT ISNULL(M4601.organization_cd_4,0) from M4601 WHERE company_cd =@P_company_cd AND group_cd = @P_group_cd)
	SET @w_belong_cd5_emp	  = (SELECT ISNULL(M4601.organization_cd_5,0) from M4601 WHERE company_cd =@P_company_cd AND group_cd = @P_group_cd)
	SET @w_belong_cd2_1_emp	  = (SELECT ISNULL(M4603.organization_cd_1,0) from M4603 WHERE company_cd =@P_company_cd AND group_cd = @P_group_cd)
	SET @w_belong_cd2_2_emp	  = (SELECT ISNULL(M4603.organization_cd_2,0) from M4603 WHERE company_cd =@P_company_cd AND group_cd = @P_group_cd)
	SET @w_belong_cd2_3_emp	  = (SELECT ISNULL(M4603.organization_cd_3,0) from M4603 WHERE company_cd =@P_company_cd AND group_cd = @P_group_cd)
	SET @w_belong_cd2_4_emp	  = (SELECT ISNULL(M4603.organization_cd_4,0) from M4603 WHERE company_cd =@P_company_cd AND group_cd = @P_group_cd)
	SET @w_belong_cd2_5_emp	  = (SELECT ISNULL(M4603.organization_cd_5,0) from M4603 WHERE company_cd =@P_company_cd AND group_cd = @P_group_cd)
	--[0]
	SELECT
		ISNULL(M4600.company_cd,0)				AS company_cd	
	,	ISNULL(M4600.group_cd,0)				AS group_cd
	,	ISNULL(M4600.group_nm,'')				AS group_nm
	,	ISNULL(M4600.browse_position_typ,0)		AS browse_position_typ
	,	ISNULL(M4600.browse_department_typ,0)	AS browse_department_typ
	,	ISNULL(M4601.organization_cd_1,0)		AS belong_cd1
	,	ISNULL(M4601.organization_cd_2,0)		AS belong_cd2
	,	ISNULL(M4601.organization_cd_3,0)		AS belong_cd3
	,	ISNULL(M4601.organization_cd_4,0)		AS belong_cd4
	,	ISNULL(M4601.organization_cd_5,0)		AS belong_cd5
	,	ISNULL(M4603.organization_cd_1,0)		AS belong_cd2_1
	,	ISNULL(M4603.organization_cd_2,0)		AS belong_cd2_2
	,	ISNULL(M4603.organization_cd_3,0)		AS belong_cd2_3
	,	ISNULL(M4603.organization_cd_4,0)		AS belong_cd2_4
	,	ISNULL(M4603.organization_cd_5,0)		AS belong_cd2_5
	FROM M4600 LEFT JOIN M4601 ON(
		M4600.company_cd = M4601.company_cd
	AND	M4600.group_cd = M4601.group_cd
	) LEFT JOIN M4603 ON(
		M4600.company_cd = M4603.company_cd
	AND	M4600.group_cd = M4603.group_cd
	)
	WHERE M4600.company_cd		= @P_company_cd
	AND	  M4600.group_cd	= @P_group_cd
	AND   M4600.del_datetime IS NULL
	AND   M4601.del_datetime IS NULL
	AND   M4603.del_datetime IS NULL
	--[1]
	SELECT 
		ISNULL(M0040.company_cd,0)			AS company_cd		
	,	ISNULL(M0040.position_cd,0)			AS position_cd		
	,	ISNULL(M0040.position_nm,'')		AS position_nm	
	,	CASE
			WHEN M0040.position_cd = M4602.code
			THEN 1
			ELSE 0 
		END AS checked
	FROM M0040
	LEFT JOIN M4602 ON (
		M0040.company_cd		= M4602.company_cd
	AND M0040.position_cd		= M4602.code
	AND M4602.group_cd	= @P_group_cd
	AND M4602.attribute			= 1
	AND M4602.del_datetime IS NULL
	)
	WHERE M0040.company_cd = @P_company_cd
	AND   M0040.del_datetime IS NULL
	ORDER BY M0040.arrange_order,M0040.position_cd

	----
	--[2] select list m0030 job_nm
	SELECT 
		ISNULL(M0030.company_cd,0)			AS company_cd		
	,	ISNULL(M0030.job_cd,0)				AS job_cd		
	,	ISNULL(M0030.job_nm,'')				AS job_nm
	,	CASE
			WHEN M0030.job_cd = M4602.code
			THEN 1
			ELSE 0
		END AS checked
	FROM M0030
	LEFT JOIN M4602 ON (
		M0030.company_cd		= M4602.company_cd
	AND M0030.job_cd			= M4602.code
	AND M4602.group_cd			= @P_group_cd
	AND M4602.attribute			= 2
	AND M4602.del_datetime IS NULL
	)
	WHERE M0030.company_cd = @P_company_cd
	AND   M0030.del_datetime IS NULL
	ORDER BY M0030.arrange_order,M0030.job_cd
	----
	--[3] select list m0050 grade_nm
	SELECT 
		ISNULL(M0050.company_cd,0)			AS company_cd		
	,	ISNULL(M0050.grade,0)				AS grade		
	,	ISNULL(M0050.grade_nm,'')			AS grade_nm		
	,	CASE
			WHEN M0050.grade = M4602.code
			THEN 1
			ELSE 0
		END AS checked
	FROM M0050
	LEFT JOIN M4602 ON (
		M0050.company_cd		= M4602.company_cd
	AND M0050.grade				= M4602.code
	AND M4602.group_cd	= @P_group_cd
	AND M4602.attribute			= 3
	AND M4602.del_datetime IS NULL
	)
	WHERE M0050.company_cd = @P_company_cd
	AND   M0050.del_datetime IS NULL
	ORDER BY M0050.arrange_order

	----
	--[4] select list m0060 grade_nm
	SELECT 
		ISNULL(M0060.company_cd,0)			AS company_cd		
	,	ISNULL(M0060.employee_typ,0)		AS employee_typ		
	,	ISNULL(M0060.employee_typ_nm,'')	AS employee_typ_nm
	,	CASE
			WHEN M0060.employee_typ = M4602.code
			THEN 1
			ELSE 0
		END AS checked
	FROM M0060
	LEFT JOIN M4602 ON (
		M0060.company_cd		= M4602.company_cd
	AND M0060.employee_typ		= M4602.code
	AND M4602.[group_cd]		= @P_group_cd
	AND M4602.attribute			= 4
	AND   M4602.del_datetime IS NULL
	)
	WHERE M0060.company_cd		= @P_company_cd
	AND   M0060.del_datetime	IS NULL	
	ORDER BY M0060.arrange_order,M0060.employee_typ
	--[5]
	SELECT 
		ISNULL(M0040.company_cd,0)			AS company_cd		
	,	ISNULL(M0040.position_cd,0)			AS position_cd		
	,	ISNULL(M0040.position_nm,'')		AS position_nm	
	,	CASE
			WHEN M0040.position_cd = M4604.code
			THEN 1
			ELSE 0 
		END AS checked
	FROM M0040
	LEFT JOIN M4604 ON (
		M0040.company_cd		= M4604.company_cd
	AND M0040.position_cd		= M4604.code
	AND M4604.group_cd	= @P_group_cd
	AND M4604.attribute			= 1
	AND M4604.del_datetime IS NULL
	)
	WHERE M0040.company_cd = @P_company_cd
	AND   M0040.del_datetime IS NULL
	ORDER BY M0040.arrange_order,M0040.position_cd

	----
	--[6] select list m0030 job_nm
	SELECT 
		ISNULL(M0030.company_cd,0)			AS company_cd		
	,	ISNULL(M0030.job_cd,0)				AS job_cd		
	,	ISNULL(M0030.job_nm,'')				AS job_nm
	,	CASE
			WHEN M0030.job_cd = M4604.code
			THEN 1
			ELSE 0
		END AS checked
	FROM M0030
	LEFT JOIN M4604 ON (
		M0030.company_cd		= M4604.company_cd
	AND M0030.job_cd			= M4604.code
	AND M4604.group_cd	= @P_group_cd
	AND M4604.attribute			= 2
	AND M4604.del_datetime IS NULL
	)	
	WHERE M0030.company_cd = @P_company_cd
	AND   M0030.del_datetime IS NULL
	ORDER BY M0030.arrange_order,M0030.job_cd
	----
	--[7] select list m0050 grade_nm
	SELECT 
		ISNULL(M0050.company_cd,0)			AS company_cd		
	,	ISNULL(M0050.grade,0)				AS grade		
	,	ISNULL(M0050.grade_nm,'')			AS grade_nm		
	,	CASE
			WHEN M0050.grade = M4604.code
			THEN 1
			ELSE 0
		END AS checked
	FROM M0050
	LEFT JOIN M4604 ON (
		M0050.company_cd		= M4604.company_cd
	AND M0050.grade				= M4604.code
	AND M4604.group_cd			= @P_group_cd
	AND M4604.attribute			= 3
	AND M4604.del_datetime IS NULL
	)
	WHERE M0050.company_cd = @P_company_cd
	AND   M0050.del_datetime IS NULL
	ORDER BY M0050.arrange_order

	----
	--[8] select list m0060 grade_nm
	SELECT 
		ISNULL(M0060.company_cd,0)			AS company_cd		
	,	ISNULL(M0060.employee_typ,0)		AS employee_typ		
	,	ISNULL(M0060.employee_typ_nm,'')	AS employee_typ_nm
	,	CASE
			WHEN M0060.employee_typ = M4604.code
			THEN 1
			ELSE 0
		END AS checked
	FROM M0060
	LEFT JOIN M4604 ON (
		M0060.company_cd		= M4604.company_cd
	AND M0060.employee_typ		= M4604.code
	AND M4604.[group_cd]		= @P_group_cd
	AND M4604.attribute			= 4
	AND   M4604.del_datetime	IS NULL
	)
	WHERE M0060.company_cd		= @P_company_cd
	AND   M0060.del_datetime	IS NULL	
	ORDER BY M0060.arrange_order,M0060.employee_typ
	SELECT 
		M0020.organization_nm
	,	M0020.organization_cd_1
	,	M0020.organization_cd_2
	,	M0020.organization_cd_3
	,	M0020.organization_cd_4
	,	M0020.organization_cd_5	
	FROM M0020 
	WHERE M0020.company_cd				= @P_company_cd
	AND M0020.organization_typ = 1
	AND M0020.del_datetime IS NULL
	--[9]
	SELECT 
		M0020.organization_nm
	,	M0020.organization_cd_1
	,	M0020.organization_cd_2
	,	M0020.organization_cd_3
	,	M0020.organization_cd_4
	,	M0020.organization_cd_5	
	FROM M0020 
	WHERE M0020.company_cd				= @P_company_cd
	AND M0020.organization_typ = 2
	AND m0020.organization_cd_1 = @w_belong_cd1_emp
	AND M0020.del_datetime IS NULL
	--[10] get combobox with  type = 3
	SELECT
		M0020.organization_nm
	,	M0020.organization_cd_1
	,	M0020.organization_cd_2
	,	M0020.organization_cd_3
	,	M0020.organization_cd_4
	,	M0020.organization_cd_5
	FROM M0020
	WHERE M0020.company_cd		= @P_company_cd
	AND M0020.organization_typ	= 3
	AND m0020.organization_cd_1 = @w_belong_cd1_emp
	AND m0020.organization_cd_2 = @w_belong_cd2_emp
	AND M0020.del_datetime IS NULL
	--[11] get combobox with  type = 4
	SELECT
		M0020.organization_nm
	,	M0020.organization_cd_1 
	,	M0020.organization_cd_2 
	,	M0020.organization_cd_3 
	,	M0020.organization_cd_4 
	,	M0020.organization_cd_5 
	FROM M0020 
	WHERE M0020.company_cd		= @P_company_cd
	AND M0020.organization_typ	= 4
	AND m0020.organization_cd_1 = @w_belong_cd1_emp
	AND m0020.organization_cd_2 = @w_belong_cd2_emp
	AND m0020.organization_cd_3 = @w_belong_cd3_emp
	AND M0020.del_datetime IS NULL
	--[12] get combobox with  type = 5
	SELECT
		M0020.organization_nm
	,	M0020.organization_cd_1 
	,	M0020.organization_cd_2 
	,	M0020.organization_cd_3 
	,	M0020.organization_cd_4 
	,	M0020.organization_cd_5 
	FROM M0020 
	WHERE M0020.company_cd		= @P_company_cd
	AND M0020.organization_typ	= 5
	AND m0020.organization_cd_1 = @w_belong_cd1_emp
	AND m0020.organization_cd_2 = @w_belong_cd2_emp
	AND m0020.organization_cd_3 = @w_belong_cd3_emp
	AND m0020.organization_cd_4 = @w_belong_cd4_emp
	AND M0020.del_datetime IS NULL
	SELECT 
		M0020.organization_nm
	,	M0020.organization_cd_1
	,	M0020.organization_cd_2
	,	M0020.organization_cd_3
	,	M0020.organization_cd_4
	,	M0020.organization_cd_5	
	FROM M0020 
	WHERE M0020.company_cd				= @P_company_cd
	AND M0020.organization_typ = 1
	AND M0020.del_datetime IS NULL
	--[9]
	SELECT 
		M0020.organization_nm
	,	M0020.organization_cd_1
	,	M0020.organization_cd_2
	,	M0020.organization_cd_3
	,	M0020.organization_cd_4
	,	M0020.organization_cd_5	
	FROM M0020 
	WHERE M0020.company_cd				= @P_company_cd
	AND M0020.organization_typ = 2
	AND m0020.organization_cd_1 = @w_belong_cd2_1_emp
	AND M0020.del_datetime IS NULL
	--[10] get combobox with  type = 3
	SELECT
		M0020.organization_nm
	,	M0020.organization_cd_1
	,	M0020.organization_cd_2
	,	M0020.organization_cd_3
	,	M0020.organization_cd_4
	,	M0020.organization_cd_5
	FROM M0020
	WHERE M0020.company_cd				= @P_company_cd
	AND M0020.organization_typ = 3
	AND m0020.organization_cd_1 = @w_belong_cd2_1_emp
	AND m0020.organization_cd_2 = @w_belong_cd2_2_emp
	AND M0020.del_datetime IS NULL
	--[11] get combobox with  type = 4
	SELECT
		M0020.organization_nm
	,	M0020.organization_cd_1 
	,	M0020.organization_cd_2 
	,	M0020.organization_cd_3 
	,	M0020.organization_cd_4 
	,	M0020.organization_cd_5 
	FROM M0020 
	WHERE M0020.company_cd				= @P_company_cd
	AND M0020.organization_typ = 4
	AND m0020.organization_cd_1 = @w_belong_cd2_1_emp
	AND m0020.organization_cd_2 = @w_belong_cd2_2_emp
	AND m0020.organization_cd_3 = @w_belong_cd2_3_emp
	AND M0020.del_datetime IS NULL
	--[12] get combobox with  type = 5
	SELECT
		M0020.organization_nm
	,	M0020.organization_cd_1 
	,	M0020.organization_cd_2 
	,	M0020.organization_cd_3 
	,	M0020.organization_cd_4 
	,	M0020.organization_cd_5 
	FROM M0020 
	WHERE M0020.company_cd				= @P_company_cd
	AND M0020.organization_typ = 5
	AND m0020.organization_cd_1 = @w_belong_cd2_1_emp
	AND m0020.organization_cd_2 = @w_belong_cd2_2_emp
	AND m0020.organization_cd_3 = @w_belong_cd2_3_emp
	AND m0020.organization_cd_4 = @w_belong_cd2_4_emp
	AND M0020.del_datetime IS NULL
END

GO
