IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_mI1010_RPT2]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_mI1010_RPT2]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：mI1010 - Report csv
 *
 *  作成日  ：	2021/01/06
 *  作成者  ：	ANS-ASIA DUONGNTT
 *
 *  更新日  ：	2021/05/17
 *  更新者  ：	viettd
 *  更新内容：	show employee_cd from F0030
 *
 *  更新日  ：	2021/06/10
 *  更新者  ：	viettd
 *  更新内容：	M0070.multireview_typ=1(マルチレビュー対象者)になっている社員は表示対象外とする。
 *			:	ADD ORDER BY M0070.employee_cd
 *
 *  更新日  ：	2021/06/16
 *  更新者  ：	viettd
 *  更新内容：	if exists data into F3020 then only show data in F3020 else show data from F0030 (rater1)
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_mI1010_RPT2]
	@P_language					NVARCHAR(5)
,	@P_fiscal_year				SMALLINT = 0
,	@P_company_cd				SMALLINT = 0
AS
BEGIN
	SET NOCOUNT ON;
	-- #TABLE_F3020
	CREATE TABLE #TABLE_F3020 (
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	fiscal_year				SMALLINT
	,	employee_cd				NVARCHAR(15)
	,	supporter_cd			NVARCHAR(15)
	)
	-- #F3020
	CREATE TABLE #F3020(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	fiscal_year				SMALLINT
	,	employee_cd				NVARCHAR(10)
	,	supporter_cd			NVARCHAR(10)
	,	row_num					SMALLINT
	)
	-- add by viettd 2021/05/17
	-- #TABLE_F0030
	CREATE TABLE #TABLE_F0030(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	fiscal_year				SMALLINT
	,	employee_cd				NVARCHAR(10)
	,	rater_employee_cd_1		NVARCHAR(10)
	)
	-- #TABLE_EMPLOYEE
	CREATE TABLE #TABLE_EMPLOYEE (
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	fiscal_year				SMALLINT
	,	employee_cd				NVARCHAR(10)
	)
	-- #RESULT
	CREATE TABLE #RESULT (
		row_typ					TINYINT			-- 0.header 1.body
	,	employee_cd				NVARCHAR(15)
	,	employee_nm				NVARCHAR(200)
	,	supporter_cd1			NVARCHAR(15)
	,	supporter_cd2			NVARCHAR(15)
	,	supporter_cd3			NVARCHAR(15)
	,	supporter_cd4			NVARCHAR(15)
	,	supporter_cd5			NVARCHAR(15)
	,	supporter_cd6			NVARCHAR(15)
	,	supporter_cd7			NVARCHAR(15)
	,	supporter_cd8			NVARCHAR(15)
	,	supporter_cd9			NVARCHAR(15)
	,	supporter_cd10			NVARCHAR(15)
	,	supporter_cd11			NVARCHAR(15)
	,	supporter_cd12			NVARCHAR(15)
	,	supporter_cd13			NVARCHAR(15)
	,	supporter_cd14			NVARCHAR(15)
	,	supporter_cd15			NVARCHAR(15)
	,	supporter_cd16			NVARCHAR(15)
	,	supporter_cd17			NVARCHAR(15)
	,	supporter_cd18			NVARCHAR(15)
	,	supporter_cd19			NVARCHAR(15)
	,	supporter_cd20			NVARCHAR(15)
	,	supporter_cd21			NVARCHAR(15)
	,	supporter_cd22			NVARCHAR(15)
	,	supporter_cd23			NVARCHAR(15)
	,	supporter_cd24			NVARCHAR(15)
	,	supporter_cd25			NVARCHAR(15)
	,	supporter_cd26			NVARCHAR(15)
	,	supporter_cd27			NVARCHAR(15)
	,	supporter_cd28			NVARCHAR(15)
	,	supporter_cd29			NVARCHAR(15)
	,	supporter_cd30			NVARCHAR(15)
	)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--INSERT DATA
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- #TABLE_F3020　（サポーター）
	INSERT INTO #TABLE_F3020
	SELECT
		F3020.company_cd			
	,	F3020.fiscal_year			
	,	F3020.employee_cd	
	,	F3020.supporter_cd	
	FROM F3020
	WHERE
		F3020.company_cd	=	@P_company_cd
	AND	F3020.fiscal_year	=	@P_fiscal_year
	AND	F3020.del_datetime IS NULL
	GROUP BY 
		F3020.company_cd	
	,	F3020.fiscal_year	
	,	F3020.employee_cd
	,	F3020.supporter_cd	
	-- #TABLE_F0030 (一次評価者)
	INSERT INTO #TABLE_F0030
	SELECT 
		F0030.company_cd
	,	F0030.fiscal_year
	,	F0030.employee_cd
	,	F0030.rater_employee_cd_1
	FROM F0030
	LEFT OUTER JOIN M0070 ON (
		F0030.company_cd		=	M0070.company_cd
	AND F0030.employee_cd		=	M0070.employee_cd
	)
	WHERE 
		F0030.company_cd			=	@P_company_cd
	AND F0030.fiscal_year			=	@P_fiscal_year
	AND F0030.rater_employee_cd_1	<>	''
	AND F0030.del_datetime IS NULL
	AND ISNULL(M0070.multireview_typ,0) = 1	-- 0.マルチレビュー対象としない	-- add by viettd 2021/06/10
	GROUP BY
		F0030.company_cd
	,	F0030.fiscal_year
	,	F0030.employee_cd
	,	F0030.rater_employee_cd_1
	-- IF EMPLOYEE NOT EXISTS IN F3020 THEN INSERT FROM F0030(RATER1) INTO F3020 (SUPPOTER)
	INSERT INTO #TABLE_F3020
	SELECT 
		#TABLE_F0030.company_cd
	,	#TABLE_F0030.fiscal_year
	,	#TABLE_F0030.employee_cd
	,	#TABLE_F0030.rater_employee_cd_1	AS	supporter_cd
	FROM #TABLE_F0030
	LEFT OUTER JOIN #TABLE_F3020 ON (
		#TABLE_F0030.company_cd				=	#TABLE_F3020.company_cd
	AND #TABLE_F0030.fiscal_year			=	#TABLE_F3020.fiscal_year
	AND #TABLE_F0030.employee_cd			=	#TABLE_F3020.employee_cd
	--AND #TABLE_F0030.rater_employee_cd_1	=	#TABLE_F3020.supporter_cd	-- comment out by viettd 2021/06/16
	)
	WHERE 
		#TABLE_F3020.employee_cd IS NULL
	-- INSERT INTO #F3020
	INSERT INTO #F3020
	SELECT
		#TABLE_F3020.company_cd			
	,	#TABLE_F3020.fiscal_year			
	,	#TABLE_F3020.employee_cd			
	,	#TABLE_F3020.supporter_cd	
	,	ROW_NUMBER() OVER(PARTITION BY company_cd, fiscal_year, employee_cd ORDER BY company_cd ASC, fiscal_year ASC)
	FROM #TABLE_F3020
	-- INSERT INTO #TABLE_EMPLOYEE
	INSERT INTO #TABLE_EMPLOYEE
	SELECT 
		#TABLE_F3020.company_cd
	,	#TABLE_F3020.fiscal_year
	,	#TABLE_F3020.employee_cd
	FROM #TABLE_F3020
	GROUP BY
		#TABLE_F3020.company_cd
	,	#TABLE_F3020.fiscal_year
	,	#TABLE_F3020.employee_cd
	-- INSERT HEADER CSV INTO #RESULT
	IF @P_language ='en'
	BEGIN
	INSERT INTO #RESULT
	SELECT 
		0					-- header
	,	'Employee CD'						
	,	'Employee nm'						
	,	'Supporter CD1'					
	,	'Supporter CD2'					
	,	'Supporter CD3'							
	,	'Supporter CD4'					
	,	'Supporter CD5'					
	,	'Supporter CD6'					
	,	'Supporter CD7'	
	,	'Supporter CD8'	
	,	'Supporter CD9'	
	,	'Supporter CD10'
	,	'Supporter CD11'
	,	'Supporter CD12'
	,	'Supporter CD13'
	,	'Supporter CD14'
	,	'Supporter CD15'
	,	'Supporter CD16'
	,	'Supporter CD17'
	,	'Supporter CD18'
	,	'Supporter CD19'
	,	'Supporter CD20'
	,	'Supporter CD21'
	,	'Supporter CD22'
	,	'Supporter CD23'
	,	'Supporter CD24'
	,	'Supporter CD25'
	,	'Supporter CD26'
	,	'Supporter CD27'
	,	'Supporter CD28'
	,	'Supporter CD29'
	,	'Supporter CD30'
	END
	ELSE
	BEGIN
	INSERT INTO #RESULT
	SELECT 
		0					-- header
	,	'対象社員名CD'						
	,	'対象社員名'						
	,	'サポーターCD1'					
	,	'サポーターCD2'					
	,	'サポーターCD3'							
	,	'サポーターCD4'					
	,	'サポーターCD5'					
	,	'サポーターCD6'					
	,	'サポーターCD7'	
	,	'サポーターCD8'	
	,	'サポーターCD9'	
	,	'サポーターCD10'
	,	'サポーターCD11'
	,	'サポーターCD12'
	,	'サポーターCD13'
	,	'サポーターCD14'
	,	'サポーターCD15'
	,	'サポーターCD16'
	,	'サポーターCD17'
	,	'サポーターCD18'
	,	'サポーターCD19'
	,	'サポーターCD20'
	,	'サポーターCD21'
	,	'サポーターCD22'
	,	'サポーターCD23'
	,	'サポーターCD24'
	,	'サポーターCD25'
	,	'サポーターCD26'
	,	'サポーターCD27'
	,	'サポーターCD28'
	,	'サポーターCD29'
	,	'サポーターCD30'
	-- INSERT DETAIL CSV INTO #RESULT
	END
	INSERT INTO #RESULT
	SELECT 
		1				-- body
	,	#TABLE_EMPLOYEE.employee_cd
	,	ISNULL(M0070.employee_nm,'')			AS	employee_nm
	,	ISNULL(SUPPORTER_1.supporter_cd,'')
	,	ISNULL(SUPPORTER_2.supporter_cd,'')
	,	ISNULL(SUPPORTER_3.supporter_cd,'')
	,	ISNULL(SUPPORTER_4.supporter_cd,'')
	,	ISNULL(SUPPORTER_5.supporter_cd,'')
	,	ISNULL(SUPPORTER_6.supporter_cd,'')
	,	ISNULL(SUPPORTER_7.supporter_cd,'')
	,	ISNULL(SUPPORTER_8.supporter_cd,'')
	,	ISNULL(SUPPORTER_9.supporter_cd,'')
	,	ISNULL(SUPPORTER_10.supporter_cd,'')
	,	ISNULL(SUPPORTER_11.supporter_cd,'')
	,	ISNULL(SUPPORTER_12.supporter_cd,'')
	,	ISNULL(SUPPORTER_13.supporter_cd,'')
	,	ISNULL(SUPPORTER_14.supporter_cd,'')
	,	ISNULL(SUPPORTER_15.supporter_cd,'')
	,	ISNULL(SUPPORTER_16.supporter_cd,'')
	,	ISNULL(SUPPORTER_17.supporter_cd,'')
	,	ISNULL(SUPPORTER_18.supporter_cd,'')
	,	ISNULL(SUPPORTER_19.supporter_cd,'')
	,	ISNULL(SUPPORTER_20.supporter_cd,'')
	,	ISNULL(SUPPORTER_21.supporter_cd,'')
	,	ISNULL(SUPPORTER_22.supporter_cd,'')
	,	ISNULL(SUPPORTER_23.supporter_cd,'')
	,	ISNULL(SUPPORTER_24.supporter_cd,'')
	,	ISNULL(SUPPORTER_25.supporter_cd,'')
	,	ISNULL(SUPPORTER_26.supporter_cd,'')
	,	ISNULL(SUPPORTER_27.supporter_cd,'')
	,	ISNULL(SUPPORTER_28.supporter_cd,'')
	,	ISNULL(SUPPORTER_29.supporter_cd,'')
	,	ISNULL(SUPPORTER_30.supporter_cd,'')
	FROM #TABLE_EMPLOYEE
	LEFT OUTER JOIN M0070 ON (
		#TABLE_EMPLOYEE.company_cd		=	M0070.company_cd
	AND #TABLE_EMPLOYEE.employee_cd	=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT JOIN #F3020 AS SUPPORTER_1 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_1.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_1.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_1.employee_cd
	AND SUPPORTER_1.row_num			=	1
	)
	LEFT JOIN #F3020 AS SUPPORTER_2 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_2.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_2.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_2.employee_cd
	AND SUPPORTER_2.row_num			=	2
	)
	LEFT JOIN #F3020 AS SUPPORTER_3 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_3.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_3.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_3.employee_cd
	AND SUPPORTER_3.row_num			=	3
	)
	LEFT JOIN #F3020 AS SUPPORTER_4 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_4.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_4.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_4.employee_cd
	AND SUPPORTER_4.row_num			=	4
	)
	LEFT JOIN #F3020 AS SUPPORTER_5 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_5.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_5.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_5.employee_cd
	AND SUPPORTER_5.row_num			=	5
	)
	LEFT JOIN #F3020 AS SUPPORTER_6 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_6.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_6.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_6.employee_cd
	AND SUPPORTER_6.row_num			=	6
	)
	LEFT JOIN #F3020 AS SUPPORTER_7 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_7.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_7.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_7.employee_cd
	AND SUPPORTER_7.row_num			=	7
	)
	LEFT JOIN #F3020 AS SUPPORTER_8 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_8.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_8.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_8.employee_cd
	AND SUPPORTER_8.row_num			=	8
	)
	LEFT JOIN #F3020 AS SUPPORTER_9 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_9.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_9.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_9.employee_cd
	AND SUPPORTER_9.row_num			=	9
	)
	LEFT JOIN #F3020 AS SUPPORTER_10 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_10.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_10.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_10.employee_cd
	AND SUPPORTER_10.row_num		=	10
	)
	LEFT JOIN #F3020 AS SUPPORTER_11 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_11.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_11.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_11.employee_cd
	AND SUPPORTER_11.row_num		=	11
	)
	LEFT JOIN #F3020 AS SUPPORTER_12 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_12.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_12.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_12.employee_cd
	AND SUPPORTER_12.row_num		=	12
	)
	LEFT JOIN #F3020 AS SUPPORTER_13 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_13.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_13.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_13.employee_cd
	AND SUPPORTER_13.row_num		=	13
	)
	LEFT JOIN #F3020 AS SUPPORTER_14 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_14.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_14.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_14.employee_cd
	AND SUPPORTER_14.row_num		=	14
	)
	LEFT JOIN #F3020 AS SUPPORTER_15 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_15.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_15.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_15.employee_cd
	AND SUPPORTER_15.row_num		=	15
	)
	LEFT JOIN #F3020 AS SUPPORTER_16 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_16.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_16.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_16.employee_cd
	AND SUPPORTER_16.row_num		=	16
	)
	LEFT JOIN #F3020 AS SUPPORTER_17 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_17.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_17.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_17.employee_cd
	AND SUPPORTER_17.row_num		=	17
	)
	LEFT JOIN #F3020 AS SUPPORTER_18 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_18.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_18.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_18.employee_cd
	AND SUPPORTER_18.row_num		=	18
	)
	LEFT JOIN #F3020 AS SUPPORTER_19 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_19.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_19.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_19.employee_cd
	AND SUPPORTER_19.row_num		=	19
	)
	LEFT JOIN #F3020 AS SUPPORTER_20 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_20.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_20.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_20.employee_cd
	AND SUPPORTER_20.row_num		=	20
	)
	LEFT JOIN #F3020 AS SUPPORTER_21 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_21.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_21.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_21.employee_cd
	AND SUPPORTER_21.row_num		=	21
	)
	LEFT JOIN #F3020 AS SUPPORTER_22 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_22.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_22.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_22.employee_cd
	AND SUPPORTER_22.row_num		=	22
	)
	LEFT JOIN #F3020 AS SUPPORTER_23 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_23.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_23.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_23.employee_cd
	AND SUPPORTER_23.row_num		=	23
	)
	LEFT JOIN #F3020 AS SUPPORTER_24 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_24.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_24.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_24.employee_cd
	AND SUPPORTER_24.row_num		=	24
	)
	LEFT JOIN #F3020 AS SUPPORTER_25 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_25.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_25.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_25.employee_cd
	AND SUPPORTER_25.row_num		=	25
	)
	LEFT JOIN #F3020 AS SUPPORTER_26 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_26.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_26.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_26.employee_cd
	AND SUPPORTER_26.row_num		=	26
	)
	LEFT JOIN #F3020 AS SUPPORTER_27 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_27.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_27.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_27.employee_cd
	AND SUPPORTER_27.row_num		=	27
	)
	LEFT JOIN #F3020 AS SUPPORTER_28 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_28.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_28.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_28.employee_cd
	AND SUPPORTER_28.row_num		=	28
	)
	LEFT JOIN #F3020 AS SUPPORTER_29 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_29.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_29.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_29.employee_cd
	AND SUPPORTER_29.row_num		=	29
	)
	LEFT JOIN #F3020 AS SUPPORTER_30 ON (
		#TABLE_EMPLOYEE.company_cd		=	SUPPORTER_30.company_cd
	AND #TABLE_EMPLOYEE.fiscal_year	=	SUPPORTER_30.fiscal_year
	AND #TABLE_EMPLOYEE.employee_cd	=	SUPPORTER_30.employee_cd
	AND SUPPORTER_30.row_num		=	30
	)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--RESULT
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--[0]
	SELECT
		#RESULT.employee_cd		
	,	#RESULT.employee_nm		
	,	#RESULT.supporter_cd1	
	,	#RESULT.supporter_cd2	
	,	#RESULT.supporter_cd3	
	,	#RESULT.supporter_cd4	
	,	#RESULT.supporter_cd5	
	,	#RESULT.supporter_cd6	
	,	#RESULT.supporter_cd7	
	,	#RESULT.supporter_cd8	
	,	#RESULT.supporter_cd9	
	,	#RESULT.supporter_cd10	
	,	#RESULT.supporter_cd11	
	,	#RESULT.supporter_cd12	
	,	#RESULT.supporter_cd13	
	,	#RESULT.supporter_cd14	
	,	#RESULT.supporter_cd15	
	,	#RESULT.supporter_cd16	
	,	#RESULT.supporter_cd17	
	,	#RESULT.supporter_cd18	
	,	#RESULT.supporter_cd19	
	,	#RESULT.supporter_cd20	
	,	#RESULT.supporter_cd21	
	,	#RESULT.supporter_cd22	
	,	#RESULT.supporter_cd23	
	,	#RESULT.supporter_cd24	
	,	#RESULT.supporter_cd25	
	,	#RESULT.supporter_cd26	
	,	#RESULT.supporter_cd27	
	,	#RESULT.supporter_cd28	
	,	#RESULT.supporter_cd29	
	,	#RESULT.supporter_cd30	
	FROM #RESULT
	-- add by viettd 2021/06/10
	ORDER BY 
		#RESULT.row_typ
	,	CASE 
			ISNUMERIC(#RESULT.employee_cd) 
			WHEN 1 
			THEN CAST(#RESULT.employee_cd AS BIGINT) 
			ELSE 999999999999999 
		END 
    ,	#RESULT.employee_cd
	-- DROP TABLE
	DROP TABLE #TABLE_F3020
	DROP TABLE #F3020
	DROP TABLE #RESULT
	DROP TABLE #TABLE_F0030
	DROP TABLE #TABLE_EMPLOYEE
END
GO