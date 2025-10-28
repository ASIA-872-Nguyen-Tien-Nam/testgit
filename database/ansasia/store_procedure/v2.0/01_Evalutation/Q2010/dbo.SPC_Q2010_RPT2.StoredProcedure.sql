DROP PROCEDURE [SPC_Q2010_RPT2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	EXPORT EXCEL 3
--*  
--* 作成日/create date			:	2020/10/12									
--*	作成者/creater				:	NamNB						
--*   					
--*  更新日/update date			:	2022/08/16
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	upgrade 1.9
--*   					
--****************************************************************************************
CREATE PROCEDURE [SPC_Q2010_RPT2]
	-- Add the parameters for the stored procedure here
	@P_language					nvarchar(10)		=	'jp'		
,	@P_json						nvarchar(max)		=	''	
,	@P_login_employee_cd		nvarchar(10)		=	''		
,	@P_cre_user					nvarchar(50)		=	''	
,	@P_company_cd				smallint			=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					date				=	SYSDATETIME()
	,	@authority_typ			smallint			=	0
	,	@year_month_day			date				=	NULL
	,	@fiscal_year			int					=	0
	--
	,	@chk					tinyint			=	0	-- add by viettd 2020/05/18
	,	@i						int				=	1
	,	@cnt					int				=	0
	,	@w_employee_cd			nvarchar(10)	=	''
	,	@w_sheet_cd				smallint		=	0
	--
	IF object_id('tempdb..#TABLE_JSON', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #TABLE_JSON
	END
	--
	IF object_id('tempdb..#TABLE_EMPLOYEE', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #TABLE_EMPLOYEE
	END
	--
	IF object_id('tempdb..#TABLE_DETAIL', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #TABLE_DETAIL
	END
	--
	IF object_id('tempdb..#TABLE_RESULT', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #TABLE_RESULT
	END
	--
	CREATE TABLE #TABLE_RESULT(
		id								int			identity(1,1)
	,	fiscal_year						nvarchar(200)
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(200)
	,	sheet_cd						nvarchar(20)
	,	sheet_nm						nvarchar(200)
	,	item_no							nvarchar(200)
	,	item_title						nvarchar(400)
	,	item_1							nvarchar(400)
	,	item_2							nvarchar(400)
	,	item_3							nvarchar(400)
	,	item_4							nvarchar(400)
	,	item_5							nvarchar(400)
	,	weight							nvarchar(200)
	,	challenge_level_nm				nvarchar(200)
	
	)
	CREATE TABLE #DISPLAY_TYP(
		employee_cd						nvarchar(400)	
	,	sheet_cd						INT
	,	item_title_display_typ			nvarchar(400)	
	,	item_1_display_typ				nvarchar(400)
	,	item_2_display_typ				nvarchar(400)
	,	item_3_display_typ				nvarchar(400)
	,	item_4_display_typ				nvarchar(400)
	,	item_5_display_typ				nvarchar(400)
	,	weight_display_typ				nvarchar(200)
	,	challenge_level_display_typ		nvarchar(200)
	)
	--
	CREATE TABLE #TABLE_JSON(
		id								int			identity(1,1)
	,	employee_cd						nvarchar(10)
	,	sheet_cd						smallint
	)
	--
	SET @fiscal_year		=	JSON_VALUE(@P_json,'$.fiscal_year')
	--
	INSERT INTO #TABLE_JSON
	SELECT json_table.employee_cd,json_table.sheet_cd FROM OPENJSON(@P_json,'$.list') WITH(
		employee_cd						nvarchar(10)
	,	sheet_cd						smallint
	)AS json_table
	--↓↓↓ add by viettd 2020/05/18
	SET @cnt = (SELECT COUNT(id) FROM #TABLE_JSON)
	WHILE @i <= @cnt
	BEGIN
		SELECT 
			@w_employee_cd	=	ISNULL(#TABLE_JSON.employee_cd,'')
		,	@w_sheet_cd		=	ISNULL(#TABLE_JSON.sheet_cd,0)
		FROM #TABLE_JSON
		WHERE #TABLE_JSON.id = @i
		--
		EXEC [dbo].SPC_PERMISSION_CHK1 @fiscal_year,@w_employee_cd,@w_sheet_cd,@P_cre_user,@P_company_cd,1,@chk OUT
		-- 0.参照不可　1.参照可能	2.更新可能
		IF @chk IN (0)
		BEGIN
			DELETE D FROM #TABLE_JSON AS D WHERE D.id = @i
		END
		-- LOOP @i
		SET @i = @i + 1
	END
	--↑↑↑ end add by viettd 2020/05/18
	--
	INSERT INTO #TABLE_RESULT
	SELECT
		@fiscal_year
	,	TBL.employee_cd
	,	ISNULL(M0070.employee_nm, '')
	,	ISNULL(W_M0200.sheet_cd, '')
	,	ISNULL(W_M0200.sheet_nm, '')
	,	ISNULL(F0111.item_no, '')
	,	ISNULL(F0111.item_title, '')
	,	ISNULL(F0111.item_1, '')
	,	ISNULL(F0111.item_2, '')
	,	ISNULL(F0111.item_3, '')
	,	ISNULL(F0111.item_4, '')
	,	ISNULL(F0111.item_5, '')
	,	ISNULL(F0111.weight, '')
	,	ISNULL(W_M0110.challenge_level_nm, '')
	FROM #TABLE_JSON AS TBL
	LEFT JOIN F0111 ON (
		@P_company_cd			=	F0111.company_cd
	AND	@fiscal_year			=	F0111.fiscal_year
	AND	TBL.employee_cd			=	F0111.employee_cd
	AND	TBL.sheet_cd			=	F0111.sheet_cd
	AND	F0111.del_datetime IS NULL
	)
	LEFT JOIN W_M0110 ON (
		@P_company_cd			=	W_M0110.company_cd
	AND	F0111.fiscal_year		=	W_M0110.fiscal_year
	AND	F0111.challenge_level	=	W_M0110.challenge_level
	AND	W_M0110.del_datetime IS NULL
	)
	LEFT OUTER JOIN M0070 ON (
		@P_company_cd			=	M0070.company_cd
	AND TBL.employee_cd			=	M0070.employee_cd
	)
	LEFT JOIN W_M0200 ON (
		@P_company_cd			=	W_M0200.company_cd
	AND @fiscal_year			=	W_M0200.fiscal_year
	AND	TBL.sheet_cd			=	W_M0200.sheet_cd
	AND	W_M0200.del_datetime IS NULL
	)
	--
	INSERT INTO #DISPLAY_TYP
	SELECT 
		TBL.employee_cd
	,	TBL.sheet_cd
	,	MAX(ISNULL(W_M0200.item_title_display_typ, 0))
	,	MAX(ISNULL(W_M0200.item_display_typ_1, 0))
	,	MAX(ISNULL(W_M0200.item_display_typ_2, 0))
	,	MAX(ISNULL(W_M0200.item_display_typ_3, 0))
	,	MAX(ISNULL(W_M0200.item_display_typ_4, 0))
	,	MAX(ISNULL(W_M0200.item_display_typ_5, 0))
	,	MAX(ISNULL(W_M0200.weight_display_typ, 0))
	,	MAX(ISNULL(W_M0200.challenge_level_display_typ, 0))
	FROM #TABLE_JSON AS TBL 
	LEFT JOIN W_M0200 ON (
		@P_company_cd			=	W_M0200.company_cd
	AND @fiscal_year			=	W_M0200.fiscal_year
	AND	TBL.sheet_cd			=	W_M0200.sheet_cd
	AND	W_M0200.del_datetime IS NULL
	)
	GROUP BY 
		TBL.employee_cd
	,	TBL.sheet_cd	
	-- OUTPUT
	--[0]
	SELECT
		fiscal_year
	,	#TABLE_RESULT.employee_cd					
	,	employee_nm					
	,	sheet_nm					
	,	item_no						
	,	item_title					
	,	item_title_display_typ		
	,	item_1						
	,	item_1_display_typ			
	,	item_2						
	,	item_2_display_typ			
	,	item_3						
	,	item_3_display_typ			
	,	item_4						
	,	item_4_display_typ			
	,	item_5						
	,	item_5_display_typ			
	,	weight						
	,	weight_display_typ			
	,	challenge_level_nm			
	,	challenge_level_display_typ	
	,	@P_language					AS	language	--add vietdt 2022/08/22
	FROM #TABLE_RESULT
	LEFT JOIN #DISPLAY_TYP ON(
		#TABLE_RESULT.employee_cd	=	#DISPLAY_TYP.employee_cd
	AND #TABLE_RESULT.sheet_cd		=	#DISPLAY_TYP.sheet_cd
	)
END
GO
