IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_OM0300_INQ1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_OM0300_INQ1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：OM0300 - Refer
 *
 *  作成日  ：2020/10/06
 *  作成者  ：ANS-ASIA nghianm
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_OM0300_INQ1]
	@P_group_cd			SMALLINT = 0
,	@P_company_cd		SMALLINT = 0
AS
BEGIN
	SET NOCOUNT ON;
	--[0]
	SELECT
		ISNULL(M2600.company_cd,0)			AS company_cd	
	,	ISNULL(M2600.[1on1_group_cd],0)		AS group_cd
	,	ISNULL(M2600.[1on1_group_nm],'')	AS group_nm
	FROM M2600
	WHERE M2600.company_cd		= @P_company_cd
	AND	  M2600.[1on1_group_cd]	= @P_group_cd
	AND   M2600.del_datetime IS NULL
	--[1] select list m0040 position_nm
	SELECT 
		ISNULL(M0040.company_cd,0)			AS company_cd		
	,	ISNULL(M0040.position_cd,0)			AS position_cd		
	,	ISNULL(M0040.position_nm,'')		AS position_nm	
	,	CASE
			WHEN M0040.position_cd = M2601.code
			THEN 1
			ELSE 0 
		END AS checked
	FROM M0040
	LEFT JOIN M2601 ON (
		M0040.company_cd		= M2601.company_cd
	AND M0040.position_cd		= M2601.code
	AND M2601.[1on1_group_cd]	= @P_group_cd
	AND M2601.attribute			= 1
	AND M2601.del_datetime IS NULL
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
			WHEN M0030.job_cd = M2601.code
			THEN 1
			ELSE 0
		END AS checked
	FROM M0030
	LEFT JOIN M2601 ON (
		M0030.company_cd		= M2601.company_cd
	AND M0030.job_cd			= M2601.code
	AND M2601.[1on1_group_cd]	= @P_group_cd
	AND M2601.attribute			= 2
	AND M2601.del_datetime IS NULL
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
			WHEN M0050.grade = M2601.code
			THEN 1
			ELSE 0
		END AS checked
	FROM M0050
	LEFT JOIN M2601 ON (
		M0050.company_cd		= M2601.company_cd
	AND M0050.grade				= M2601.code
	AND M2601.[1on1_group_cd]	= @P_group_cd
	AND M2601.attribute			= 3
	AND M2601.del_datetime IS NULL
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
			WHEN M0060.employee_typ = M2601.code
			THEN 1
			ELSE 0
		END AS checked
	FROM M0060
	LEFT JOIN M2601 ON (
		M0060.company_cd		= M2601.company_cd
	AND M0060.employee_typ		= M2601.code
	AND M2601.[1on1_group_cd]	= @P_group_cd
	AND M2601.attribute			= 4
	AND   M2601.del_datetime IS NULL
	)
	WHERE M0060.company_cd = @P_company_cd
	AND   M0060.del_datetime IS NULL	
	ORDER BY M0060.arrange_order,M0060.employee_typ
	
	
END

GO
