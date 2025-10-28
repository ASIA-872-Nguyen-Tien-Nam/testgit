IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_RI0020_INQ1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_RI0020_INQ1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_RI0020_INQ1 782,2023,'721'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET TARGET OF EMPLOYEE rI0020 個人目標登録
--*  
--*  作成日/create date			:	2023/05/08						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_RI0020_INQ1]
	@P_company_cd		SMALLINT		= 0
,	@P_fiscal_year		SMALLINT		= 0
,	@P_employee_cd		NVARCHAR(10)	= ''
,	@P_get_default		SMALLINT		= 0	-- 0.dont get defualt | 1.get defualt
AS
BEGIN
	--[0]
	CREATE TABLE #F4000 (
		company_cd			SMALLINT
	,	fiscal_year			SMALLINT
	,	employee_cd			NVARCHAR(10)
	,	fiscal_year_max		SMALLINT
	)
	-- GET FROM F4000 BY @P_fiscal_year
	INSERT INTO #F4000
	SELECT 
		company_cd
	,	fiscal_year
	,	employee_cd
	,	fiscal_year
	FROM F4000
	WHERE 
		F4000.company_cd	=	@P_company_cd
	AND F4000.fiscal_year	=	@P_fiscal_year
	AND F4000.employee_cd	=	@P_employee_cd
	AND F4000.del_datetime IS NULL
	--1.get defualt
	IF @P_get_default = 1
	BEGIN
		-- IF NOT EIXTS IN F4000 BY @P_fiscal_year THEN GET FROM PART DATA
		IF NOT EXISTS (SELECT 1 FROM #F4000)
		BEGIN
			INSERT INTO #F4000
			SELECT 
				company_cd
			,	@P_fiscal_year
			,	employee_cd
			,	MAX(fiscal_year)	AS	fiscal_year
			FROM F4000
			WHERE 
				F4000.company_cd	=	@P_company_cd
			AND F4000.fiscal_year	<	@P_fiscal_year
			AND F4000.del_datetime IS NULL
			GROUP BY
				company_cd
			,	employee_cd
		END
	END
	--
	SELECT 
		ISNULL(M4000.company_cd,0)			AS		company_cd	
	,	ISNULL(M4000.fiscal_year,0)			AS		fiscal_year
	,	ISNULL(F4000.employee_cd,'')		AS		employee_cd
	,	ISNULL(F4000.target1,'')			AS		target1
	,	ISNULL(F4000.target2,'')			AS		target2
	,	ISNULL(F4000.target3,'')			AS		target3
	,	ISNULL(F4000.target4,'')			AS		target4
	,	ISNULL(F4000.target5,'')			AS		target5
	,	ISNULL(M4000.target1_nm,'')			AS		target1_nm
	,	ISNULL(M4000.target1_use_typ,0)		AS		target1_use_typ
	,	ISNULL(M4000.target2_nm,'')			AS		target2_nm
	,	ISNULL(M4000.target2_use_typ,0)		AS		target2_use_typ
	,	ISNULL(M4000.target3_nm,'')			AS		target3_nm
	,	ISNULL(M4000.target3_use_typ,0)		AS		target3_use_typ
	,	ISNULL(M4000.target4_nm,'')			AS		target4_nm
	,	ISNULL(M4000.target4_use_typ,0)		AS		target4_use_typ
	,	ISNULL(M4000.target5_nm,'')			AS		target5_nm
	,	ISNULL(M4000.target5_use_typ,0)		AS		target5_use_typ
	,	CASE 
			WHEN F4000_REGISTER.company_cd IS NOT NULL
			THEN 1
			ELSE 0
		END									AS		is_registered
	FROM M4000
	LEFT OUTER JOIN #F4000 ON (
		M4000.company_cd		=	#F4000.company_cd
	AND M4000.fiscal_year		=	#F4000.fiscal_year
	AND @P_employee_cd			=	#F4000.employee_cd
	)
	LEFT OUTER JOIN F4000 ON (
		#F4000.company_cd		=	F4000.company_cd
	AND #F4000.fiscal_year_max	=	F4000.fiscal_year
	AND #F4000.employee_cd		=	F4000.employee_cd
	AND F4000.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4000 AS F4000_REGISTER ON (
		#F4000.company_cd		=	F4000_REGISTER.company_cd
	AND #F4000.fiscal_year		=	F4000_REGISTER.fiscal_year
	AND #F4000.employee_cd		=	F4000_REGISTER.employee_cd
	AND F4000_REGISTER.del_datetime IS NULL
	)
	WHERE 
		M4000.company_cd  = @P_company_cd
	AND M4000.fiscal_year = @P_fiscal_year 
	AND	M4000.del_datetime IS NULL
END
GO
