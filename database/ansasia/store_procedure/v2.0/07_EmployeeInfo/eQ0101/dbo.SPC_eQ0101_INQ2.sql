DROP PROCEDURE [SPC_EQ0101_INQ2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--EXEC SPC_EQ0101_INQ2 'a008', '10035','hanhntm'
--****************************************************************************************
--*   											
--* �����T�v/process overview	:	LIST DATA
--*  
--* �쐬��/create date			:	2024/04											
--*	�쐬��/creater				:	trinhdt				
--*			
--****************************************************************************************
CREATE PROCEDURE [SPC_EQ0101_INQ2]
	  @P_employee_cd			NVARCHAR(10)	
,	  @P_company_cd				SMALLINT
,	  @P_user_id				NVARCHAR(100)	=	N''
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE 
		@string_column				NVARCHAR(MAX)	= ''
	,	@string_sql					NVARCHAR(MAX)	= ''
	,	@fiscal_year_max			INT				=  0
	,	@fiscal_year_min			INT				=  0
	,	@current_year				INT				=	dbo.FNC_GET_YEAR(@P_company_cd,NULL)

	CREATE TABLE #TBL_EQ0101(
		fiscal_year						INT
	,	treatment_applications_no		SMALLINT
	,	treatment_applications_nm		NVARCHAR(50)
	,	rank_nm							NVARCHAR(10)
	)

	CREATE TABLE #TBL_EQ0101_TMP(
		fiscal_year						INT
	,	treatment_applications_no		SMALLINT
	,	treatment_applications_nm		NVARCHAR(50)
	,	rank_nm							NVARCHAR(10)
	)

	INSERT INTO #TBL_EQ0101
	SELECT 
		ISNULL(F0201.fiscal_year,0)								AS	fiscal_year
	,	ISNULL(F0201.treatment_applications_no,'')				AS	treatment_applications_no
	,	ISNULL(M0102.treatment_applications_nm,'')				AS	treatment_applications_nm
	,	ISNULL(W_M0130.rank_nm,'')								AS	rank_nm
	FROM F0201
	LEFT OUTER JOIN M0102 ON (
		F0201.company_cd				=	M0102.company_cd
	AND F0201.treatment_applications_no	=	M0102.detail_no
	)
	LEFT JOIN W_M0130 ON (
		F0201.company_cd						=	W_M0130.company_cd
	AND F0201.fiscal_year						=	W_M0130.fiscal_year
	AND F0201.rank_cd							=	W_M0130.rank_cd
	AND	F0201.treatment_applications_no			=	W_M0130.treatment_applications_no
	AND	W_M0130.del_datetime IS NULL
	)
	WHERE
		F0201.company_cd			=	@P_company_cd
	AND F0201.employee_cd			=	@P_employee_cd
	AND	F0201.fiscal_year <= @current_year
	AND	F0201.evaluatorFB_datetime IS NOT NULL
	AND	F0201.del_datetime IS NULL
	AND M0102.del_datetime IS NULL

	SET @fiscal_year_max = (Select Max(A.fiscal_year) FROM ((SELECT TOP 5 fiscal_year FROM #TBL_EQ0101 GROUP BY fiscal_year ORDER BY fiscal_year DESC)) AS A)

	SET @fiscal_year_min = (Select Min(A.fiscal_year) FROM ((SELECT TOP 5 fiscal_year FROM #TBL_EQ0101 GROUP BY fiscal_year ORDER BY fiscal_year DESC)) AS A)

	-- insert top 5 year desc
	INSERT INTO #TBL_EQ0101_TMP
	SELECT
		fiscal_year
	,	treatment_applications_no
	,	treatment_applications_nm
	,	rank_nm
	FROM #TBL_EQ0101 WHERE fiscal_year <= @fiscal_year_max AND fiscal_year >= @fiscal_year_min

	SELECT @string_column = stuff((select ', ['+ cast((A.treatment_applications_no) as nvarchar(50))+']'
								 from 
								 (SELECT DISTINCT #TBL_EQ0101_TMP.treatment_applications_no FROM #TBL_EQ0101_TMP) AS A
								 for xml path('')),1,1,'')

	SET @string_sql = 
	'
	SELECT TOP 5
		fiscal_year,
		'+@string_column+'
	FROM
	(
	SELECT 
		#TBL_EQ0101_TMP.fiscal_year						
	,	#TBL_EQ0101_TMP.treatment_applications_no		
	,	#TBL_EQ0101_TMP.rank_nm							
	FROM #TBL_EQ0101_TMP
	) AS P
	Pivot(MAX(rank_nm) FOR treatment_applications_no IN ('+@string_column+')) AS A
	ORDER BY A.fiscal_year DESC
	'

	--[0]
	IF(ISNULL(@string_sql,'') = '')
	BEGIN
		select '' as fiscal_year
	END
	ELSE
	BEGIN
		EXEC(@string_sql) 
	END

	--[1]
	SELECT 
	  #TBL_EQ0101_TMP.treatment_applications_no
	, #TBL_EQ0101_TMP.treatment_applications_nm 
	FROM #TBL_EQ0101_TMP
	GROUP BY 
	  #TBL_EQ0101_TMP.treatment_applications_no
	, #TBL_EQ0101_TMP.treatment_applications_nm 

	--CLEAR
	DROP TABLE #TBL_EQ0101
	DROP TABLE #TBL_EQ0101_TMP

END
GO