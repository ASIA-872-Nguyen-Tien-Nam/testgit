DROP PROCEDURE [SPC_I2040_INQ2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ 
-- EXEC [SPC_I2030_INQ1] '807','2'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	I2030
--*  
--*  作成日/create date			:	2018/09/26				
--*　作成者/creater				:	Longvv								
--*   					
--*  更新日/update date			:	2021/09/01
--*　更新者/updater				:　	viettd　
--*　更新内容/update content		:	fix show rank_json when only 最終評価
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_I2040_INQ2]
	@P_company_cd		SMALLINT		=	0
,	@P_fiscal_year		INT				=	0
,	@P_json  		NVARCHAR(MAX)				=	''
AS
BEGIN
	DECLARE
		@w_is_use_sheet_cd		tinyint		=	0
	-- #TREATMENT_NO
	CREATE TABLE #TREATMENT_NO(
		id				INT IDENTITY(1,1)
	,	treatment_no	INT
	)
	--check json
	IF(ISJSON(@P_json) > 0)
	BEGIN
		INSERT INTO #TREATMENT_NO
		SELECT
			[row].treatment_applications_no												
		FROM OPENJSON(@P_json,'$.list_treatment_applications_no') WITH(			
			treatment_applications_no				INT
		) AS [row] 
	END
	IF EXISTS ( SELECT 1 FROM #TREATMENT_NO 
							INNER JOIN F0011 ON(
								@P_company_cd				=	F0011.company_cd
							AND @P_fiscal_year				=	F0011.fiscal_year
							AND #TREATMENT_NO.treatment_no	=	F0011.treatment_applications_no
							AND 1							=	F0011.sheet_use_typ
							AND 1							=	F0011.use_typ
							AND F0011.del_datetime IS NULL
							)
	)
	BEGIN
		SET @w_is_use_sheet_cd = 1
	END
	--[0]
	-- add by viettd 2021/09/01
	IF @w_is_use_sheet_cd = 1
	BEGIN
		SELECT 
			rank_cd
		,	rank_nm
		FROM W_M0130 
		INNER JOIN #TREATMENT_NO ON(
			W_M0130.treatment_applications_no = #TREATMENT_NO.treatment_no
		)
		WHERE 
			W_M0130.company_cd					=	@P_company_cd
		AND W_M0130.fiscal_year					=	@P_fiscal_year
		AND del_datetime IS NULL
	END
	ELSE
	BEGIN
		SELECT 
			rank_cd
		,	rank_nm
		FROM M0130 
		INNER JOIN #TREATMENT_NO ON(
			M0130.treatment_applications_no = #TREATMENT_NO.treatment_no
		)
		WHERE 
			M0130.company_cd					=	@P_company_cd
		AND del_datetime IS NULL
	END
	--[1]
	SELECT 
		grade
	,	grade_nm
	FROM M0050
	WHERE 
		M0050.company_cd	= @P_company_cd
	AND del_datetime IS NULL
	-- get treatment no last year (- 1)
	--[2]
	SELECT 
		ISNULL(F0011.company_cd,0)								AS	company_cd
	,	ISNULL(F0011.treatment_applications_no,0)				AS	treatment_applications_no
	,	ISNULL(M0102.treatment_applications_nm,'')				AS	treatment_applications_nm
	,	ISNULL(F0011.use_typ,0)									AS	use_typ
	FROM F0011
	LEFT OUTER JOIN M0102 ON (
		F0011.company_cd				=	M0102.company_cd
	AND F0011.treatment_applications_no	=	M0102.detail_no
	)
	WHERE
		F0011.company_cd			=	@P_company_cd
	AND F0011.fiscal_year			=	@P_fiscal_year - 3
	AND F0011.use_typ				=	1
	AND F0011.del_datetime IS NULL
	AND M0102.del_datetime IS NULL
	--[3]
	SELECT 
		ISNULL(F0011.company_cd,0)								AS	company_cd
	,	ISNULL(F0011.treatment_applications_no,0)				AS	treatment_applications_no
	,	ISNULL(M0102.treatment_applications_nm,'')				AS	treatment_applications_nm
	,	ISNULL(F0011.use_typ,0)									AS	use_typ
	FROM F0011
	LEFT OUTER JOIN M0102 ON (
		F0011.company_cd				=	M0102.company_cd
	AND F0011.treatment_applications_no	=	M0102.detail_no
	)
	WHERE
		F0011.company_cd			=	@P_company_cd
	AND F0011.fiscal_year			=	@P_fiscal_year - 2 
	AND F0011.use_typ				=	1
	AND F0011.del_datetime IS NULL
	AND M0102.del_datetime IS NULL
	--[4]
	SELECT 
		ISNULL(F0011.company_cd,0)								AS	company_cd
	,	ISNULL(F0011.treatment_applications_no,0)				AS	treatment_applications_no
	,	ISNULL(M0102.treatment_applications_nm,'')				AS	treatment_applications_nm
	,	ISNULL(F0011.use_typ,0)									AS	use_typ
	FROM F0011
	LEFT OUTER JOIN M0102 ON (
		F0011.company_cd				=	M0102.company_cd
	AND F0011.treatment_applications_no	=	M0102.detail_no
	)
	WHERE
		F0011.company_cd			=	@P_company_cd
	AND F0011.fiscal_year			=	@P_fiscal_year - 1
	AND F0011.use_typ				=	1
	AND F0011.del_datetime IS NULL
	AND M0102.del_datetime IS NULL
	--[5] is only slect tratement have been not use sheet_cd
	SELECT @w_is_use_sheet_cd AS is_use_sheet_cd
END
GO