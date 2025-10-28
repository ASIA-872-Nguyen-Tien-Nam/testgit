DROP PROCEDURE [SPC_DASHBOARD_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ [SPC_DASHBOARD_INQ1]
-- EXEC SPC_DASHBOARD_FND1 '2018','1','794';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	DASHBOARD
--*  
--*  作成日/create date			:	2018/10/22				
--*　作成者/creater				:	Longvv								
--*   					
--*  更新日/update date			:	2019/05/27  
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	update ver 1.5
--*   					
--*  更新日/update date			:	2019/06/04  
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	評価要素 = 0:目標、1:定性評価 
--*   					
--*  更新日/update date			:	2020/02/14  
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	remove condition M0100.interview_use_typ = 1
--*
--*  更新日/update date			:	2021/03/09  
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	change belong_cd1 from smallint -> nvrachar(20)
--*   					
--*  更新日/update date			:	2021/06/03
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
--*   					
--*  更新日/update date			:	2022/01/18
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	fix bug when has not 期首面談
--*   					
--*  更新日/update date			:	2022/03/31
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when admin is rater then show all employees who you evalutate
--*   					
--*  更新日/update date			:	2022/08/17
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	update ver 1.9
--*   					
--*  更新日/update date			:	2024/06/17
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	fix sheet history
--****************************************************************************************
CREATE PROCEDURE [SPC_DASHBOARD_FND1]
	@P_select_period			SMALLINT		=	0
,	@P_select_category_typ		SMALLINT		=	0	
,	@P_company_cd				SMALLINT		=	0
,	@P_fiscal_year				SMALLINT		=	0
,	@P_user_id					NVARCHAR(50)	=	''
,	@P_organization_cd			NVARCHAR(500)	=	''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_Date								DATE			=	GETDATE()
	,	@YEAR								SMALLINT		=	0
	,	@P_beginning_date					DATE			=	NULL
	,	@SUM_Status							INT				=	0
	,	@interview_use_typ					SMALLINT		=	0	--期首面談なし
	,	@evaluation_self_assessment			SMALLINT		=	0	--自己評価なし
	,	@status_cd							SMALLINT		=	0
	--,	@count_status_cd0					INT				=	0
	,	@arrange_order						INT				=	0
	,	@position_cd						int      		=	0
	,	@P_authority_cd						SMALLINT		=	0
	,	@P_authority_typ					SMALLINT		=	0
	,	@employee_cd						NVARCHAR(20)	=	''
	,	@sheet_kbn							TINYINT			=	0 
	,	@choice_in_screen					TINYINT			=	0 
	-- add by viettd 2021/06/03
	,	@w_evaluation_organization_cnt		INT				=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT		=	0
	,	@w_language							INT				=	1	--add by vietdt  2022/08/17 
	,	@w_people							NVARCHAR(20)	=	'人'--add by vietdt  2022/08/17 
	,	@year_month_day						DATE			=	NULL
	,	@beginning_date						DATE			=	NULL
	,	@w_authority						INT				=	2
	--
	CREATE TABLE #W_M0200_TABLE (
		company_cd				SMALLINT	
	,	fiscal_year				INT
	,	sheet_cd				SMALLINT
	,	sheet_kbn				TINYINT
	)
	--
	CREATE TABLE #TABLE_ORGANIZATION (
		id						int	identity(1, 1)
	,	organization_typ		tinyint
	,	organization_cd_1		nvarchar(50)
	,	organization_cd_2		nvarchar(50)
	,	organization_cd_3		nvarchar(50)
	,	organization_cd_4		nvarchar(50)
	,	organization_cd_5		nvarchar(50)	
	,	choice_in_screen		tinyint
	)
	--
	CREATE TABLE #TEMP_STATUS (
		ID				INT	IDENTITY(1,1)
	,	status_cd		SMALLINT
	,	count_status	SMALLINT
	,	sheet_kbn		TINYINT
	)
	--
	CREATE TABLE #TEMP_STATUS_M0070 (
		ID				INT	IDENTITY(1,1)
	,	status_cd		SMALLINT
	,	count_status	SMALLINT
	,	sheet_kbn		TINYINT
	,	employee_cd		nvarchar(10)
	,	belong_cd1		nvarchar(20)
	,	belong_cd2		nvarchar(20)
	,	belong_cd3		nvarchar(20)
	,	belong_cd4		nvarchar(20)
	,	belong_cd5		nvarchar(20)
	,	rater_step		smallint			-- add by viettd 2022/03/31	
		--	add by vietdt 2022/09/08
	,	sheet_belong_cd_1				nvarchar(20)
	,	sheet_belong_cd_2				nvarchar(20)
	,	sheet_belong_cd_3				nvarchar(20)
	,	sheet_belong_cd_4				nvarchar(20)
	,	sheet_belong_cd_5				nvarchar(20)
	)
	----add by vietdt  2022/08/17
	CREATE TABLE #M0071_TEMP(
		company_cd			SMALLINT
	,	employee_cd			NVARCHAR(10)
	,	fiscal_year			SMALLINT
	,	sheet_cd			smallint
	,	application_date	DATE
	,	employee_nm			NVARCHAR(200)
	,	employee_ab_nm		NVARCHAR(200)
	,	furigana			NVARCHAR(50)
	,	office_cd			SMALLINT
	,	office_nm			NVARCHAR(50)
	,	belong_cd1			NVARCHAR(50)
	,	belong_cd2			NVARCHAR(50)
	,	belong_cd3			NVARCHAR(50)
	,	belong_cd4			NVARCHAR(50)
	,	belong_cd5			NVARCHAR(50)
	,	job_cd				SMALLINT
	,	position_cd			INT
	,	employee_typ		SMALLINT
	,	grade				SMALLINT
	,	belong_nm1			NVARCHAR(50)
	,	belong_nm2			NVARCHAR(50)
	,	belong_nm3			NVARCHAR(50)
	,	belong_nm4			NVARCHAR(50)
	,	belong_nm5			NVARCHAR(50)
	,	job_nm				NVARCHAR(50)
	,	position_nm			NVARCHAR(50)
	,	grade_nm			NVARCHAR(50)
	,	employee_typ_nm		NVARCHAR(50)
	)
	--
	CREATE TABLE #M0070H(
		application_date				date
	,	company_cd						smallint
	,	employee_cd						nvarchar(10)
	,	employee_nm						nvarchar(200)
	,	employee_ab_nm					nvarchar(50)
	,	furigana						nvarchar(50)
	,	office_cd						smallint
	,	office_nm						nvarchar(50)
	,	belong_cd_1						nvarchar(20)
	,	belong_cd_2						nvarchar(20)
	,	belong_cd_3						nvarchar(20)
	,	belong_cd_4						nvarchar(20)
	,	belong_cd_5						nvarchar(20)
	,	job_cd							smallint
	,	position_cd						int
	,	employee_typ					smallint
	,	grade							smallint
	,	belong_nm_1						nvarchar(50)
	,	belong_nm_2						nvarchar(50)
	,	belong_nm_3						nvarchar(50)
	,	belong_nm_4						nvarchar(50)
	,	belong_nm_5						nvarchar(50)
	,	job_nm							nvarchar(50)
	,	position_nm						nvarchar(50)
	,	grade_nm						nvarchar(50)
	,	employee_typ_nm					nvarchar(50)
	)
	--
	SELECT 
		@P_authority_cd			=	S0010.authority_cd
	,	@P_authority_typ		=	S0010.authority_typ
	,	@employee_cd			=	S0010.employee_cd
	,	@position_cd			=	ISNULL(M0070.position_cd,0)
	,	@w_language				=	ISNULL(S0010.language,1)		--add by vietdt  2022/08/17 
	FROM S0010 
	LEFT JOIN M0070 ON (
		M0070.company_cd		=	S0010.company_cd
	AND M0070.employee_cd		=	S0010.employee_cd
	AND M0070.del_datetime		IS NULL 
	) 
	WHERE
		S0010.company_cd		=	@P_company_cd
	AND S0010.user_id			=	@P_user_id
	AND S0010.del_datetime IS NULL
	--
	IF	@w_language = 2
	BEGIN
		SET @w_people = ' people'
	END
	--
	IF @P_select_category_typ = 0
	BEGIN
		SET @sheet_kbn = 1	-- 目標管理
	END
	ELSE
	BEGIN
		SET @sheet_kbn	= 2　-- 定性評価
	END
	--
	IF	@P_authority_typ = 3
	BEGIN
		SELECT 
			@w_authority			=	ISNULL(S0021.authority,0)	--	0.参照不可　1.参照可能	2.更新可能
		FROM S0021
		WHERE 
			S0021.company_cd		=	@P_company_cd
		AND S0021.authority_cd		=	@P_authority_cd
		AND (
			@sheet_kbn = 1 AND S0021.function_id = 'I2010'	-- 目標評価シート
		OR	@sheet_kbn = 2 AND S0021.function_id = 'I2020'	-- 定性評価シート
		)
	END
	-- COUNT ALL ORGANIZATIONS OF S0022 -- add by viettd 2021/06/03
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@P_authority_cd,1)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@P_authority_cd,1)
	--
    SET @arrange_order	= ISNULL((
		SELECT ISNULL(M0040.arrange_order,0)
		FROM M0040
		WHERE M0040.del_datetime IS NULL AND M0040.position_cd = @position_cd AND M0040.company_cd = @P_company_cd)
	,0)
	--
	-- edited by viettd 2020/01/14
	IF EXISTS(SELECT 1 FROM M0310 
						WHERE 
							M0310.company_cd		=	@P_company_cd
						AND	M0310.category			=	3 
						AND M0310.status_cd			=	1
						AND M0310.status_use_typ	=	1
						AND M0310.del_datetime IS NULL)
	BEGIN
		SET @interview_use_typ	=	1						--	期首面談あり
	END
	--SET @evaluation_self_assessment
	IF EXISTS(	SELECT 1 
				FROM M0100 
				WHERE 
					M0100.company_cd						=	@P_company_cd
				AND	M0100.evaluation_self_assessment_typ	=	1
				AND M0100.del_datetime IS NULL)
	BEGIN
		SET @evaluation_self_assessment	=	1				--	自己評価あり
	END
	--settinng status_cd = 0 
	IF	@interview_use_typ	= 1 
	BEGIN	
		SELECT @status_cd			=	0
	END
	ELSE
	BEGIN
		IF @evaluation_self_assessment = 1
		BEGIN
			SELECT @status_cd		=	1
		END
		ELSE
		BEGIN
			SELECT @status_cd		=	2
		END
	END
	-- add by viettd 2019/05/27
	INSERT INTO #W_M0200_TABLE
	SELECT 
		company_cd		
	,	fiscal_year		
	,	sheet_cd	
	,	sheet_kbn	
	FROM W_M0200
	WHERE 
		W_M0200.company_cd			=	@P_company_cd
	AND W_M0200.fiscal_year			=	@P_fiscal_year
	AND W_M0200.sheet_kbn			=	@sheet_kbn
	AND (
			@P_select_period = 0
		OR	(@P_select_period <> 0 AND W_M0200.evaluation_period	=	@P_select_period)
	)
	-- comment out by viettd 2019/06/04
	--AND (
	--		(@P_select_category_typ = 0)
	--	OR	(@P_select_category_typ <> 0 AND W_M0200.category =	@P_select_category_typ)
	--)
	AND W_M0200.del_datetime IS NULL
	--add by vietdt  2022/08/17
	INSERT INTO #M0071_TEMP
	EXEC [dbo].[SPC_REFER_M0071_INQ1] @P_fiscal_year,'',0,@P_company_cd
	----add by vietdt  2022/08/17
	SELECT 
		@beginning_date = M9100.beginning_date 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	--
	IF @beginning_date IS NOT NULL
	BEGIN
		SET @year_month_day = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		SET @year_month_day = DATEADD(DD,-1,DATEADD(YYYY,1,@year_month_day))
	END
	ELSE
	BEGIN 
		SET @year_month_day = CAST((CAST(@P_fiscal_year AS nvarchar(4)) + '/12/31') AS DATE)
	END
	--
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @year_month_day,'',@P_company_cd
	--INSERT INTO #TEMP_STATUS
	INSERT INTO #TEMP_STATUS_M0070
	SELECT
		L0040.status_cd 
	,	0--COUNT(F0100.status_cd)		
	,	@sheet_kbn
	,	#M0070H.employee_cd
	,	#M0070H.belong_cd_1
	,	#M0070H.belong_cd_2
	,	#M0070H.belong_cd_3
	,	#M0070H.belong_cd_4
	,	#M0070H.belong_cd_5
	,	CASE 
				WHEN ISNULL(F0100.rater_employee_cd_4,'')	=	@employee_cd
				THEN 4
				WHEN ISNULL(F0100.rater_employee_cd_3,'')	=	@employee_cd
				THEN 3
				WHEN ISNULL(F0100.rater_employee_cd_2,'')	=	@employee_cd
				THEN 2
				WHEN ISNULL(F0100.rater_employee_cd_1,'')	=	@employee_cd
				THEN 1
				ELSE 0
			END						AS	rater_step
	--
	,	#M0071_TEMP.belong_cd1
	,	#M0071_TEMP.belong_cd2
	,	#M0071_TEMP.belong_cd3
	,	#M0071_TEMP.belong_cd4
	,	#M0071_TEMP.belong_cd5
	FROM L0040
	--↓↓↓ edited by viettd 2019/05/28
	INNER JOIN #W_M0200_TABLE AS M0200 WITH(NOLOCK) ON (
		@P_company_cd			=	M0200.company_cd
	AND @P_fiscal_year			=	M0200.fiscal_year
	AND L0040.category			=	M0200.sheet_kbn
	)
	INNER JOIN F0100 WITH(NOLOCK) ON (
		@P_company_cd			=	F0100.company_cd
	AND L0040.status_cd			=	F0100.status_cd
	AND @P_fiscal_year			=	F0100.fiscal_year
	AND M0200.sheet_cd			=	F0100.sheet_cd
	AND F0100.del_datetime IS NULL
	)
    INNER JOIN #M0070H WITH(NOLOCK) ON(
		F0100.company_cd		=	#M0070H.company_cd
	AND	F0100.employee_cd		=	#M0070H.employee_cd
	)
	LEFT OUTER JOIN M0040 WITH(NOLOCK) ON (
		#M0070H.company_cd	=	M0040.company_cd
	AND	#M0070H.position_cd	=	M0040.position_cd
	)
	LEFT OUTER JOIN S0020 ON (
		#M0070H.company_cd	=	S0020.company_cd
	AND	@P_authority_cd		=	S0020.authority_cd
	)
    LEFT OUTER JOIN #M0071_TEMP WITH(NOLOCK) ON(
		F0100.company_cd		=	#M0071_TEMP.company_cd
	AND	F0100.employee_cd		=	#M0071_TEMP.employee_cd
	AND	F0100.sheet_cd			=	#M0071_TEMP.sheet_cd
	)
	WHERE 
		F0100.company_cd	=	@P_company_cd
	AND	F0100.del_datetime	IS NULL
	AND L0040.category		= @sheet_kbn
		--期限
	AND (
		--add by vietdt  2022/08/17
				@P_authority_typ	IN(4,5)
		-- add by viettd 2022/03/31
		OR	(
			F0100.rater_employee_cd_4	=	@employee_cd
		OR	F0100.rater_employee_cd_3	=	@employee_cd
		OR	F0100.rater_employee_cd_2	=	@employee_cd
		OR	F0100.rater_employee_cd_1	=	@employee_cd
		)
		OR (
				@P_authority_typ	= 3 
				AND(
					(ISNULL(S0020.use_typ,0)	<> 1 OR ( ISNULL(S0020.use_typ,0)  = 1 AND ISNULL(M0040.arrange_order,0) > @arrange_order ))
				)
			)
		--add by vietdt  2022/08/17
		OR	@P_authority_typ	=	6 AND F0100.employee_cd	=	@employee_cd
	)
	AND	@w_authority <> 0
	-- delete permission
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 @P_organization_cd,@P_user_id,@P_company_cd

	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
	BEGIN
		SET @choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
		-- 1.choice in screen
		IF @choice_in_screen = 1
		BEGIN
			DELETE D FROM #TEMP_STATUS_M0070 AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
			    D.sheet_belong_cd_1			=	S.organization_cd_1
			AND D.sheet_belong_cd_2			=	S.organization_cd_2
			AND D.sheet_belong_cd_3			=	S.organization_cd_3
			AND D.sheet_belong_cd_4			=	S.organization_cd_4
			AND D.sheet_belong_cd_5			=	S.organization_cd_5
			)
			WHERE 
				D.status_cd IS NULL
			OR	S.organization_typ IS NULL
		END
		ELSE IF NOT (@P_authority_typ = 3 AND @w_evaluation_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)	-- edited by viettd 2021/06/03
		BEGIN
			DELETE D FROM #TEMP_STATUS_M0070 AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.sheet_belong_cd_1			=	S.organization_cd_1
			AND D.sheet_belong_cd_2			=	S.organization_cd_2
			AND D.sheet_belong_cd_3			=	S.organization_cd_3
			AND D.sheet_belong_cd_4			=	S.organization_cd_4
			AND D.sheet_belong_cd_5			=	S.organization_cd_5
			)
			WHERE 
				D.status_cd IS NULL
			OR	S.organization_typ IS NULL
			AND @P_authority_typ NOT IN(4,5) --4.会社管理者 5.総合管理者
			--AND D.rater_step NOT IN (1,2,3,4)	--一次評価者～四次評価者		 add by viettd 2022/03/31
		END
	END
	--
	INSERT INTO #TEMP_STATUS
	SELECT
		status_cd
	,	COUNT(status_cd)
	,	@sheet_kbn
	FROM #TEMP_STATUS_M0070
	GROUP BY 
		status_cd
	ORDER BY 
		status_cd
	---------------------------------------------------------
	IF	(@status_cd	<> 0 AND @sheet_kbn = 2)
	BEGIN
		--@count_status_cd0
		--SELECT @count_status_cd0  = count_status  FROM #TEMP_STATUS	 WHERE status_cd = 0
		--
		DELETE #TEMP_STATUS	 WHERE status_cd = 0
		--
		--UPDATE #TEMP_STATUS SET 
		--	count_status	=	count_status	+	@count_status_cd0
		--FROM #TEMP_STATUS
		--WHERE 
		--	status_cd	=	@status_cd
	END
	--SET @SUM_Status
	SET @SUM_Status = (SELECT SUM(count_status) FROM #TEMP_STATUS)	
	--[0]
	SELECT	
		ISNULL(#TEMP_STATUS.status_cd,0)									AS	status_cd
	,	CASE 
			WHEN #TEMP_STATUS.sheet_kbn	=	2	
			THEN 'step'+CONVERT(NVARCHAR(4),IIF(ISNULL(#TEMP_STATUS.status_cd,0)=0,0,(ISNULL(#TEMP_STATUS.status_cd,0)+2)))
			ELSE 'step'+CONVERT(NVARCHAR(4),ISNULL(#TEMP_STATUS.status_cd,0))
		END																	AS	step
	,	#TEMP_STATUS.count_status											AS	count_status_cd
	,	CASE
			WHEN	ISNULL(M0310.status_nm,'')	<>	''
			THEN	ISNULL(M0310.status_nm,'')+'('+CONVERT(NVARCHAR(10),#TEMP_STATUS.count_status)+@w_people+')'
			ELSE	ISNULL(IIF(@w_language = 2,L0040.status_nm_english,L0040.status_nm),'')+'('+CONVERT(NVARCHAR(10),#TEMP_STATUS.count_status)+@w_people+')'
		END																	AS	count_status_cd_nm
	,	CASE
			WHEN	ISNULL(M0310.status_nm,'')	<>	''
			THEN	ISNULL(M0310.status_nm,'')
			ELSE	ISNULL(IIF(@w_language = 2,L0040.status_nm_english,L0040.status_nm),'')	
		END																	AS	status_nm
	,	CONVERT(NVARCHAR(6),ROUND(CAST((#TEMP_STATUS.count_status*97) AS FLOAT)/@SUM_Status,2))+'%' 
																			AS status_percent
	FROM #TEMP_STATUS
	LEFT OUTER JOIN L0040 ON (
		#TEMP_STATUS.status_cd	=	L0040.status_cd
	AND #TEMP_STATUS.sheet_kbn	=	L0040.category
	)
	LEFT OUTER JOIN M0310  ON (
		@P_company_cd				=	M0310.company_cd
	AND	@sheet_kbn					=	M0310.category
	AND	L0040.status_cd				=	M0310.status_cd
	AND	M0310.del_datetime	IS NULL
	)
	WHERE #TEMP_STATUS.count_status	> 0
	GROUP BY 
		#TEMP_STATUS.status_cd
	,	L0040.status_nm
	,	L0040.status_nm_english
	,	M0310.status_nm
	,	#TEMP_STATUS.count_status
	,	#TEMP_STATUS.sheet_kbn
	--DROP TABLE 
	DROP TABLE #TEMP_STATUS
	DROP TABLE #W_M0200_TABLE, #TABLE_ORGANIZATION, #TEMP_STATUS_M0070
END	
GO
