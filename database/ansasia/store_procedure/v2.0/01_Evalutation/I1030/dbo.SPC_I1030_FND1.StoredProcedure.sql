DROP PROCEDURE [SPC_I1030_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  èàóùäTóv: I1030_ï]âøé“ê›íË
 *
 *  çÏê¨ì˙  ÅF 2018/09/26
 *  çÏê¨é“  ÅF Tuantv
 *
 *  çXêVì˙  ÅF 2019/01/16
 *  çXêVé“  ÅF Longvv
 *  çXêVì‡óeÅF
 *
 *  çXêVì˙  ÅF 2019/05/14
 *  çXêVé“  ÅF Longvv
 *  çXêVì‡óeÅF èCê≥àÀóäÅu20190513ÅvÇèCê≥ÅB	
 *
 *  çXêVì˙  ÅF 2020/01/07
 *  çXêVé“  ÅF viettd
 *  çXêVì‡óeÅF upgrdate ver1.6	
 *
 *  çXêVì˙  ÅF 2020/02/17
 *  çXêVé“  ÅF viettd
 *  çXêVì‡óeÅF fix bug 	
 *
 *  çXêVì˙  ÅF 2020/03/06
 *  çXêVé“  ÅF viettd
 *  çXêVì‡óeÅF add condition employee_nm 	
 *
 *  çXêVì˙  ÅF 2020/04/10
 *  çXêVé“  ÅF viettd
 *  çXêVì‡óeÅF comment 
 *
 *  çXêVì˙  ÅF 2020/04/16
 *  çXêVé“  ÅF viettd
 *  çXêVì‡óeÅF view all when authority = 4.âÔé–ä«óùé“
 *
 *  çXêVì˙  ÅF 2020/05/21
 *  çXêVé“  ÅF viettd
 *  çXêVì‡óeÅF FIX VIEW + APPLY LASTEST
 *
 *  çXêVì˙  ÅF 2020/06/26
 *  çXêVé“  ÅF viettd
 *  çXêVì‡óeÅF change condition search with (ÉOÉãÅ[Év)
 *
 *  çXêVì˙  ÅF 2020/07/08
 *  çXêVé“  ÅF viettd
 *  çXêVì‡óeÅF change condition search with (ÉOÉãÅ[Év) : ï ÇÃÉOÅ[ÉOÉãÇìoò^çœÇÃèÍçáï\é¶Ç≥ÇÍÇ»Ç¢
 *
 *  çXêVì˙  ÅF 2020/12/09
 *  çXêVé“  ÅF viettd
 *  çXêVì‡óeÅF âÊñ è„Ç≈ÉOÉãÅ[ÉvÇëIëÇµÇ»Ç¢èÍçáÇÕÅAëSé–àıÇíäèoÇµÅAF0030Ç…ìoò^Ç≥ÇÍÇƒÇ¢ÇÈèÍçáÇÕï]âøé“Çï\é¶Ç∑ÇÈÅB
 *
 *  çXêVì˙  ÅF 2021/01/07
 *  çXêVé“  ÅF viettd
 *  çXêVì‡óeÅF ëﬁêEÇµÇΩé–àıÇÕï\é¶ÇµÇ»Ç¢
 *
 *  çXêVì˙  ÅF 2021/01/26
 *  çXêVé“  ÅF viettd
 *  çXêVì‡óeÅF EXPORT CSV : EXPORT WITH GROUP_CD + GROUP_NAME
 *
 *  çXêVì˙  ÅF 2021/01/27
 *  çXêVé“  ÅF viettd
 *  çXêVì‡óeÅF fix error when filter with belong_cd
 *   					
 *  çXêVì˙  : 2021/06/03
 *Å@çXêVé“  : viettdÅ@
 *Å@çXêVì‡óe: when 3.ä«óùé“(authority_typ = 3) and not choice organization in S0022 then view all employees
 *   					
 *  çXêVì˙  : 2021/08/24
 *Å@çXêVé“  : viettdÅ@
 *Å@çXêVì‡óe: âÊñ è„Ç∆çáívÇµÇΩÉOÉãÅ[ÉvÇ≈F0030ìoò^çœÇ›ÇÃé–àı + F0030Ç…ë∂ç›ÇµÇ»Ç¢Ç™ÅAÉOÉãÅ[ÉvéwíËèåèÇ…çáívÇ∑ÇÈé–àıÇï\é¶ÇµÇΩÇ¢Ç≈Ç∑ÅB
 *   					
 *  çXêVì˙  : 2021/09/08
 *Å@çXêVé“  : viettdÅ@
 *Å@çXêVì‡óe: add paging
 *   					
 *  çXêVì˙  : 2022/01/17
 *Å@çXêVé“  : viettdÅ@
 *Å@çXêVì‡óe: when dont choice group_cd then must join to treatment_no in screen
 *   					
 *  çXêVì˙  : 2022/08/16
 *Å@çXêVé“  : viettdÅ@
 *Å@çXêVì‡óe: upgrade ver1.9
 *   					
 *  çXêVì˙  : 2023/12/04
 *Å@çXêVé“  : viettdÅ@
 *Å@çXêVì‡óe: CHANGE M0151.code FROM SMALLINT -> INT

 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_I1030_FND1]
	@P_json						NVARCHAR(MAX)	=	''
,	@P_user_id					NVARCHAR(50)	=	''
,	@P_company_cd				SMALLINT		=	0
,	@P_mode						INT				=	0 -- 0.search | 1.export csv | 2.apply_lastest 
AS
BEGIN
	SET NOCOUNT ON; 
	DECLARE
		@ERR_TBL							ERRTABLE 
	,	@w_status							NVARCHAR(10)	= ''
	,	@w_check							INT				= 0
	,	@w_rowspan							INT				= 0
	,	@totalRecord						DECIMAL(18,0)	= 0
	,	@pageMax							INT				= 0
	,	@pageNumber							INT				= 0
	,	@w_item								NVARCHAR(100)	= ''
	,	@w_month_date						NVARCHAR(10)	= ''
	,	@w_year								DATE			= NULL
	,	@w_year_value						NVARCHAR(10)	= ''
	,	@year_month_day						DATE			= NULL	 
	,	@w_i								INT				= 1
	,	@w_count							INT				= 0
	,	@w_emp								NVARCHAR(10)	= '' 
	,	@arrange_order						INT				=	0
	,	@position_cd						INT		=	0
	,	@P_authority_cd						SMALLINT		=	0
	,	@P_authority_typ					SMALLINT		=	0
	,	@employee_cd						NVARCHAR(10)	=  ''
	,	@use_typ							smallint		=	0	 
	,	@choice_in_screen					tinyint			=	0
	--
	,	@P_fiscal_year						INT				=	0
	,	@P_group_cd							SMALLINT		=	0
	,	@P_ck_search						SMALLINT		=	0
	,	@P_employee_cd_screen				NVARCHAR(10)	=	''	-- FILTER IN SCREEN
	,	@P_employee_nm_screen				NVARCHAR(20)	=	''	-- FILTER IN SCREEN	 add by viettd 2020/03/06
	--
	,	@Rater1								NVARCHAR(20)	=	''
	,	@Rater2								NVARCHAR(20)	=	''
	,	@Rater3								NVARCHAR(20)	=	''
	,	@Rater4								NVARCHAR(20)	=	''
	,	@Count_Rater						SMALLINT		=	0
	,	@organization_typ_1					TINYINT			=	0
	,	@organization_typ_2					TINYINT			=	0
	,	@organization_typ_3					TINYINT			=	0
	,	@organization_typ_4					TINYINT			=	0
	,	@organization_typ_5					TINYINT			=	0
	--	add by viettd 2020/05/21			
	,	@i									int				=	1
	,	@cnt								int				=	0
	-- add by viettd 2021/06/03
	,	@w_evaluation_organization_cnt		INT				=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT		=	0
	,	@w_page								INT				=	0	-- add by viettd 2021/09/08
	,	@w_page_size						INT				=	0	-- add by viettd 2021/09/08
	,	@w_language							SMALLINT		=	1	--1 jp / 2 en
	--
	IF object_id('tempdb..#JSON_LIST_TREATMENT', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #JSON_LIST_TREATMENT
    END
	--
	IF object_id('tempdb..#TABLE_ORGANIZATION', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_ORGANIZATION
    END
	--
	IF object_id('tempdb..#DATA', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #DATA
    END
	--
	IF object_id('tempdb..#EVALUATIVE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #EVALUATIVE
    END
	--
	IF object_id('tempdb..#F0021_TEMP', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F0021_TEMP
    END
	--
	IF object_id('tempdb..#F0032_TEMP', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F0032_TEMP
    END
	--
	IF object_id('tempdb..#F0032', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #F0032
    END
	--
	IF object_id('tempdb..#M0070', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070
    END
	--
	IF object_id('tempdb..#M0070_EMPLOYEE_CD', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070_EMPLOYEE_CD
    END
	--
	IF object_id('tempdb..#M0070_TEMP', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070_TEMP
    END
	--
	IF object_id('tempdb..#TEMP_ROWSPAN', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TEMP_ROWSPAN
    END
	--
	IF object_id('tempdb..#TEMP_ROWSPAN_TABLE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TEMP_ROWSPAN_TABLE
    END
	--
	IF object_id('tempdb..#M0151', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0151
    END
	--
	IF object_id('tempdb..#RESULT', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #RESULT
    END
	--
	IF object_id('tempdb..#EMPLOYEE_COMMON', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #EMPLOYEE_COMMON
    END
	--
	IF object_id('tempdb..#M0030', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0030
    END
	--
	IF object_id('tempdb..#M0040', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0040
    END
	--
	IF object_id('tempdb..#M0050', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0050
    END
	--
	IF object_id('tempdb..#M0060', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0060
    END
	--
	IF object_id('tempdb..#M0070H', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070H
    END
	--
	IF object_id('tempdb..#HEADER', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #HEADER
    END
	--
	IF object_id('tempdb..#M0070_0', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070_0
    END
	--
	IF object_id('tempdb..#M0070_1', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070_1
    END
	--
	IF object_id('tempdb..#M0070_2', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070_2
    END
	--
	IF object_id('tempdb..#M0070_3', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070_3
    END
	--
	IF object_id('tempdb..#M0070_4', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070_4
    END
	--
	IF object_id('tempdb..#M0070_5', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0070_5
    END
	--
	IF object_id('tempdb..#M0300_îﬁï]âøé“', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #M0300_îﬁï]âøé“
    END
	-- add by viettd 2021/01/26
	-- CSV DATA TEMP TABLE
	IF object_id('tempdb..#TABLE_CSV', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_CSV
    END
	-- #TABLE_CSV_GROUP
	IF object_id('tempdb..#TABLE_CSV_GROUP', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_CSV_GROUP
    END
	-- add by viettd 2021/09/08
	-- #TABLE_PAGE_TOTAL
	IF object_id('tempdb..#TABLE_PAGE_TOTAL', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_PAGE_TOTAL
    END
	-- #TABLE_PAGE
	IF object_id('tempdb..#TABLE_PAGE', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_PAGE
    END
	-- #TABLE_EMPLOYEES_CHECKED
	IF object_id('tempdb..#TABLE_EMPLOYEES_CHECKED', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TABLE_EMPLOYEES_CHECKED
    END
	--
	CREATE TABLE #TABLE_EMPLOYEES_CHECKED (
		employee_cd				nvarchar(10)
	)
	--
	CREATE TABLE #HEADER(
		group_cd						nvarchar(50)
	,	group_nm						nvarchar(50)
	,	employee_cd					   	nvarchar(50)
	,	employee_nm					   	nvarchar(200)
	,	rater_employee_cd_1			   	nvarchar(50)
	,	rater_employee_nm_1			   	nvarchar(200)
	,	rater_employee_cd_2			   	nvarchar(50)
	,	rater_employee_nm_2			   	nvarchar(200)
	,	rater_employee_cd_3			   	nvarchar(50)
	,	rater_employee_nm_3			   	nvarchar(200)
	,	rater_employee_cd_4			   	nvarchar(50)
	,	rater_employee_nm_4			   	nvarchar(200)
	)
	--
	CREATE TABLE #JSON_LIST_TREATMENT(
		id								int			identity(1,1)
	,	treatment_applications_no		smallint
	)
	--
	CREATE TABLE #TABLE_ORGANIZATION (
		organization_typ				tinyint
	,	organization_cd_1				nvarchar(20)
	,	organization_cd_2				nvarchar(20)
	,	organization_cd_3				nvarchar(20)
	,	organization_cd_4				nvarchar(20)
	,	organization_cd_5				nvarchar(20)	
	,	choice_in_screen				tinyint		-- 1.choice in screen 0.get from master S0022
	)
	--
	CREATE TABLE #F0200 (
		id							int identity(1,1)
	,	company_cd					smallint
	,	fiscal_year					int
	,	employee_cd					nvarchar(10)
	,	treatment_applications_no	smallint
	,	num							int
	)
	-- #TABLE_CSV
	CREATE TABLE #TABLE_CSV (
		group_cd					smallint
	,	group_nm					nvarchar(50)			
	,	employee_cd					nvarchar(10)
	,	employee_nm					nvarchar(200)
	,	rater_employee_cd_1			nvarchar(10)
	,	rater_employee_nm_1			nvarchar(200)
	,	rater_employee_cd_2			nvarchar(10)
	,	rater_employee_nm_2			nvarchar(200)
	,	rater_employee_cd_3			nvarchar(10)
	,	rater_employee_nm_3			nvarchar(200)
	,	rater_employee_cd_4			nvarchar(10)
	,	rater_employee_nm_4			nvarchar(200)
	,	employee_typ				smallint
	,	job_cd						smallint
	,	position_cd					INT
	,	grade						smallint
	)
	-- #TABLE_CSV_GROUP
	CREATE TABLE #TABLE_CSV_GROUP(
		employee_cd					nvarchar(10)
	,	group_cd					int
	,	group_nm					nvarchar(50)
	,	employee_typ				smallint
	,	job_cd						smallint
	,	position_cd					INT
	,	grade						smallint
	)
	------------------------------GET JSON------------------------------
	SET @P_fiscal_year			=	JSON_VALUE(@P_json,'$.fiscal_year')
	SET @P_group_cd				=	JSON_VALUE(@P_json,'$.group_cd')
	SET @P_ck_search			=	JSON_VALUE(@P_json,'$.ck_search')
	SET @P_employee_cd_screen	=	JSON_VALUE(@P_json,'$.employee_cd')
	SET @P_employee_nm_screen	=	JSON_VALUE(@P_json,'$.employee_nm')												-- add by viettd 2020/03/06
	SET @w_page					=	IIF(JSON_VALUE(@P_json,'$.page') > 0,JSON_VALUE(@P_json,'$.page'),1)			-- add by viettd 2021/09/08
	SET @w_page_size			=	IIF(JSON_VALUE(@P_json,'$.page_size') > 0,JSON_VALUE(@P_json,'$.page_size'),20)	-- add by viettd 2021/09/08
	--
	INSERT INTO #JSON_LIST_TREATMENT
	SELECT json_table.treatment_applications_no FROM OPENJSON(@P_json,'$.list_treatment_applications_no') WITH(
		treatment_applications_no	smallint
	)AS json_table
	WHERE
		json_table.treatment_applications_no > 0
	-- add by viettd 2021/09/08
	-- mode 2.apply latest
	IF @P_mode = 2
	BEGIN
		INSERT INTO #TABLE_EMPLOYEES_CHECKED
		SELECT json_table.employee_cd FROM OPENJSON(@P_json,'$.employees_checked') WITH(
			employee_cd	nvarchar(10)
		)AS json_table
		WHERE
			json_table.employee_cd <> ''
	END
	-- INSERT DATA INTO #TABLE_ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC [dbo].SPC_REFER_ORGANIZATION_FND1 @P_json,@P_user_id,@P_company_cd
	--	
	SELECT 
		@P_authority_cd			=	S0010.authority_cd
	,	@P_authority_typ		=	S0010.authority_typ
	,	@employee_cd			=	S0010.employee_cd
	,	@position_cd			=	ISNULL(M0070.position_cd,0)
	,	@w_language				=	ISNULL(S0010.language,1)
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
	SELECT 
		@use_typ		=	ISNULL(S0020.use_typ,0)		-- 1. ñ{êlÇÃñêEÇÊÇËâ∫à ÇÃé–àıÇÃÇ›
	FROM S0020
	WHERE
		S0020.company_cd		=	@P_company_cd
	AND S0020.authority_cd		=	@P_authority_cd
	AND S0020.del_datetime IS NULL
	-- 
	SET @arrange_order	= ISNULL((SELECT ISNULL(M0040.arrange_order,0) FROM M0040 WHERE M0040.del_datetime IS NULL AND M0040.position_cd = @position_cd AND M0040.company_cd = @P_company_cd),0)
	-- COUNT ALL ORGANIZATIONS OF S0022 -- add by viettd 2021/06/03
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@P_authority_cd,1)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@P_authority_cd,1)
	--
	SET @w_year_value = (SELECT M9100.beginning_date FROM M9100 WHERE M9100.company_cd = @P_company_cd)
	--select @w_year_value as w_year_value
	IF(@w_year_value IS NOT NULL)
	BEGIN
		SET @w_month_date =(SELECT FORMAT(M9100.beginning_date,'MM-dd') FROM M9100 WHERE M9100.company_cd = @P_company_cd)
	END
	ELSE 
	BEGIN
		SET @w_month_date = '01-01'
	END
	SET @w_year = CONVERT(DATE,(CAST(@P_fiscal_year AS nvarchar(4)) + '-' + @w_month_date))	--	start of date this year
	SET @year_month_day = DATEADD(DAY,-1,DATEADD(YEAR,1,(CONVERT(DATE,@w_year))))			--	end of day this year 
	--select  @year_month_day as year_month_day
	SELECT 
		@Count_Rater =(	CASE
						WHEN
							SUM(ISNULL(M0100.target_evaluation_typ_1,0)+ISNULL(M0100.target_evaluation_typ_2,0)+ISNULL(M0100.target_evaluation_typ_3,0)+ISNULL(M0100.target_evaluation_typ_4,0)) 
						>	SUM(ISNULL(M0100.evaluation_typ_1,0)+ISNULL(M0100.evaluation_typ_2,0)+ISNULL(M0100.evaluation_typ_3,0)+ISNULL(M0100.evaluation_typ_4,0)) 
						THEN SUM(ISNULL(M0100.target_evaluation_typ_1,0)+ISNULL(M0100.target_evaluation_typ_2,0)+ISNULL(M0100.target_evaluation_typ_3,0)+ISNULL(M0100.target_evaluation_typ_4,0)) 
						ELSE SUM(ISNULL(M0100.evaluation_typ_1,0)+ISNULL(M0100.evaluation_typ_2,0)+ISNULL(M0100.evaluation_typ_3,0)+ISNULL(M0100.evaluation_typ_4,0)) 
					END)
	FROM M0100
	WHERE 
		M0100.company_cd	=	@P_company_cd
	AND	M0100.del_datetime	IS NULL
	--
	SET @Rater1 = IIF(@Count_Rater>=1,'','hidden')
	SET @Rater2 = IIF(@Count_Rater>=2,'','hidden')
	SET @Rater3 = IIF(@Count_Rater>=3,'','hidden')
	SET @Rater4 = IIF(@Count_Rater>=4,'','hidden')
	--
	SET @organization_typ_1 = (SELECT ISNULL(M0022.use_typ,0) FROM M0022 WHERE company_cd = @P_company_cd AND organization_typ = 1 AND del_datetime IS NULL)
	SET @organization_typ_2 = (SELECT ISNULL(M0022.use_typ,0) FROM M0022 WHERE company_cd = @P_company_cd AND organization_typ = 2 AND del_datetime IS NULL)
	SET @organization_typ_3 = (SELECT ISNULL(M0022.use_typ,0) FROM M0022 WHERE company_cd = @P_company_cd AND organization_typ = 3 AND del_datetime IS NULL)
	SET @organization_typ_4 = (SELECT ISNULL(M0022.use_typ,0) FROM M0022 WHERE company_cd = @P_company_cd AND organization_typ = 4 AND del_datetime IS NULL)
	SET @organization_typ_5 = (SELECT ISNULL(M0022.use_typ,0) FROM M0022 WHERE company_cd = @P_company_cd AND organization_typ = 5 AND del_datetime IS NULL)
	--
	CREATE TABLE #TEMP_ROWSPAN(
		id							BIGINT	IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	group_cd					SMALLINT
	,	row_span					SMALLINT
	)
	--
	CREATE TABLE #TEMP_ROWSPAN_TABLE(
		id							BIGINT	IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	row_span					SMALLINT
	)
	--
	CREATE TABLE #M0070_TEMP
	(
		company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	employee_nm					NVARCHAR(200)
	,	employee_typ				SMALLINT
	,	job_cd						SMALLINT
	,	grade						SMALLINT
	,	position_cd					INT
	,	rater_position_cd_1			INT
	,	rater_position_cd_2			INT
	,	rater_position_cd_3			INT
	,	rater_position_cd_4			INT
	,	belong_cd1					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd2					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd3					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd4					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd5					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_nm1					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm2					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm3					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm4					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm5					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	employee_typ_nm				NVARCHAR(50)
	,	job_nm						NVARCHAR(50)
	,	position_nm					NVARCHAR(50)
	,	grade_nm					NVARCHAR(10)
	,	treatment_applications_no	SMALLINT
	,	sheet_cd_f0021				SMALLINT
	,	sheet_nm_f0021				NVARCHAR(50)
	,	detail_no					SMALLINT			-- add by viettd 2020/01/07
	)	
	--
	CREATE TABLE #M0070
	(
		company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	employee_nm					NVARCHAR(200)
	,	employee_typ				SMALLINT
	,	job_cd						SMALLINT
	,	grade						SMALLINT
	,	position_cd					INT
	,	rater_position_cd_1			INT
	,	rater_position_cd_2			INT
	,	rater_position_cd_3			INT
	,	rater_position_cd_4			INT
	,	rater_employee_cd_1			NVARCHAR(10)
	,	rater_employee_cd_2			NVARCHAR(10)
	,	rater_employee_cd_3			NVARCHAR(10)
	,	rater_employee_cd_4			NVARCHAR(10)
	,	belong_cd1					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd2					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd3					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd4					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_cd5					NVARCHAR(20)		-- edited by viettd 2020/01/07
	,	belong_nm1					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm2					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm3					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm4					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm5					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	employee_typ_nm				NVARCHAR(50)
	,	job_nm						NVARCHAR(50)
	,	position_nm					NVARCHAR(50)
	,	grade_nm					NVARCHAR(10)
	,	treatment_applications_no	SMALLINT
	,	sheet_cd_f0021				SMALLINT
	,	sheet_nm_f0021				NVARCHAR(50)
	,	detail_no					SMALLINT			-- add by viettd 2020/01/07
	)
	--
	CREATE TABLE #M0151 (
		company_cd				SMALLINT
	,	group_cd				SMALLINT
	,	attribute				SMALLINT
	,	code					INT				-- edited by viettd 2023/12/04	
	)		
	--
	CREATE TABLE #F0021 (
		id							INT IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	group_cd					SMALLINT
	,	treatment_applications_no	SMALLINT
	,	detail_no					SMALLINT
	,	sheet_cd					SMALLINT
	)
	--
	CREATE TABLE #F0021_TEMP (
		company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	group_cd					SMALLINT
	,	treatment_applications_no	SMALLINT
	,	detail_no					SMALLINT
	,	sheet_cd					SMALLINT
	,	sheet_nm					NVARCHAR(50)
	)
	--
	CREATE TABLE #F0032_TEMP (
		company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	treatment_applications_no	SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	detail_no					SMALLINT
	,	sheet_cd					SMALLINT
	,	sheet_nm					NVARCHAR(50)
	)
	--
	CREATE TABLE #F0032 (
		id							INT IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	treatment_applications_no	SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	detail_no					SMALLINT
	,	sheet_cd					SMALLINT
	)
	--
	CREATE TABLE #EVALUATIVE (
		id							INT IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	treatment_applications_no	SMALLINT
	,	sheet_cd_f0021				SMALLINT
	,	sheet_nm_f0021				NVARCHAR(50)
	,	sheet_cd_f0032				SMALLINT
	,	sheet_nm_f0032				NVARCHAR(50)
	,	detail_no					SMALLINT				-- add by viettd 2020/01/07
	,	group_cd					SMALLINT				-- add by viettd 2020/01/07
	)
	--
	CREATE TABLE #DATA
	(
		company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	employee_nm					NVARCHAR(200)
	,	employee_typ				SMALLINT
	,	job_cd						SMALLINT
	,	grade						SMALLINT
	,	position_cd					INT
	,	rater_position_cd_1			INT
	,	rater_position_cd_2			INT
	,	rater_position_cd_3			INT
	,	rater_position_cd_4			INT
	,	rater_employee_cd_1			NVARCHAR(10)
	,	rater_employee_cd_2			NVARCHAR(10)
	,	rater_employee_cd_3			NVARCHAR(10)
	,	rater_employee_cd_4			NVARCHAR(10)
	,	belong_cd1					NVARCHAR(20)		-- edited by viettd 2021/01/27
	,	belong_cd2					NVARCHAR(20)		-- edited by viettd 2021/01/27
	,	belong_cd3					NVARCHAR(20)		-- edited by viettd 2021/01/27
	,	belong_cd4					NVARCHAR(20)		-- edited by viettd 2021/01/27
	,	belong_cd5					NVARCHAR(20)		-- edited by viettd 2021/01/27
	--
	,	belong_nm1					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm2					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm3					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm4					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm5					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	employee_typ_nm				NVARCHAR(50)
	,	job_nm						NVARCHAR(50)
	,	position_nm					NVARCHAR(50)
	,	grade_nm					NVARCHAR(10)
	,	treatment_applications_no	SMALLINT	
	,	sheet_cd_f0021				SMALLINT
	,	sheet_nm_f0021				NVARCHAR(50)
	,	sheet_cd_f0032				SMALLINT
	,	sheet_nm_f0032				NVARCHAR(50)
	,	detail_no					SMALLINT			-- add by viettd 2020/01/07
	)
	--
	CREATE TABLE #DATA_GROUP_COUNT
	(
		company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	num							smallint
	)
	--
	CREATE TABLE #RESULT
	(
		row_number					INT
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	employee_nm					NVARCHAR(200)
	,	employee_typ				SMALLINT
	,	job_cd						SMALLINT
	,	grade						SMALLINT
	,	position_cd					INT
	,	rater_position_cd_1			INT
	,	rater_position_cd_2			INT
	,	rater_position_cd_3			INT
	,	rater_position_cd_4			INT
	,	rater_employee_cd_1			NVARCHAR(10)
	,	rater_employee_cd_2			NVARCHAR(10)
	,	rater_employee_cd_3			NVARCHAR(10)
	,	rater_employee_cd_4			NVARCHAR(10)
	,	belong_cd1					NVARCHAR(20)		-- edited by viettd 2021/01/27
	,	belong_cd2					NVARCHAR(20)		-- edited by viettd 2021/01/27
	,	belong_cd3					NVARCHAR(20)		-- edited by viettd 2021/01/27
	,	belong_cd4					NVARCHAR(20)		-- edited by viettd 2021/01/27
	,	belong_cd5					NVARCHAR(20)		-- edited by viettd 2021/01/27
	--
	,	belong_nm1					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm2					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm3					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm4					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	belong_nm5					NVARCHAR(50)		-- edited by viettd 2020/01/07
	,	employee_typ_nm				NVARCHAR(50)
	,	job_nm						NVARCHAR(50)
	,	position_nm					NVARCHAR(50)
	,	grade_nm					NVARCHAR(10)
	,	treatment_applications_no	SMALLINT
	,	sheet_cd1					SMALLINT
	,	sheet_nm1					NVARCHAR(50)
	,	sheet_cd2					SMALLINT
	,	sheet_nm2					NVARCHAR(50)
	,	[row]						INT	
	,	key_number					INT	
	,	detail_no					SMALLINT			-- add by viettd 2020/01/07		
	)
	--
	CREATE TABLE #M0070_EMPLOYEE_CD
	(
		id							BIGINT	IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	group_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	employee_typ				SMALLINT
	,	job_cd						SMALLINT
	,	position_cd					INT
	,	grade						SMALLINT
	)
	--
	CREATE TABLE #EMPLOYEE_COMMON
	(
		id							BIGINT	IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	)
	--
	CREATE TABLE #M0060
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	employee_typ			SMALLINT
	,	group_cd				SMALLINT
	)	
	--
	CREATE TABLE #M0050
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	grade					SMALLINT
	,	group_cd				SMALLINT
	)
	--
	CREATE TABLE #M0040
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	position_cd				INT
	,	group_cd				SMALLINT
	)
	--
	CREATE TABLE #M0030
	(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	job_cd					SMALLINT
	,	group_cd				SMALLINT
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
	,	belong_cd1						nvarchar(20)
	,	belong_cd2						nvarchar(20)
	,	belong_cd3						nvarchar(20)
	,	belong_cd4						nvarchar(20)
	,	belong_cd5						nvarchar(20)
	,	job_cd							smallint
	,	position_cd						INT
	,	employee_typ					smallint
	,	grade							smallint
	,	belong_nm1						nvarchar(50)
	,	belong_nm2						nvarchar(50)
	,	belong_nm3						nvarchar(50)
	,	belong_nm4						nvarchar(50)
	,	belong_nm5						nvarchar(50)
	,	job_nm							nvarchar(50)
	,	position_nm						nvarchar(50)
	,	grade_nm						nvarchar(10)
	,	employee_typ_nm					nvarchar(50)
	)
	--
	CREATE TABLE #M0300_îﬁï]âøé“(
		id							int			identity(1,1)
	,	company_cd					smallint
	,	employee_cd					nvarchar(10)
	,	belong_cd1					nvarchar(20)
	,	belong_cd2					nvarchar(20)
	,	belong_cd3					nvarchar(20)
	,	belong_cd4					nvarchar(20)
	,	belong_cd5					nvarchar(20)
	,	position_cd					INT
	,	rater_position_cd_1			INT
	,	rater_position_cd_2			INT
	,	rater_position_cd_3			INT
	,	rater_position_cd_4			INT
	--	ï]âøé“
	,	rater_employee_cd_1			NVARCHAR(10)
	,	rater_employee_cd_2			NVARCHAR(10)
	,	rater_employee_cd_3			NVARCHAR(10)
	,	rater_employee_cd_4			NVARCHAR(10)
	)
	CREATE TABLE #M0070_0(
		company_cd			smallint
	,	employee_cd			nvarchar(10)			
	,	position_cd			INT
	,	belong_cd1			nvarchar(20)
	,	belong_cd2			nvarchar(20)
	,	belong_cd3			nvarchar(20)
	,	belong_cd4			nvarchar(20)
	,	belong_cd5			nvarchar(20)
	)
	CREATE TABLE #M0070_1(
		company_cd			smallint
	,	employee_cd			nvarchar(10)			
	,	position_cd			INT
	,	belong_cd1			nvarchar(20)
	,	belong_cd2			nvarchar(20)
	,	belong_cd3			nvarchar(20)
	,	belong_cd4			nvarchar(20)
	,	belong_cd5			nvarchar(20)
	)
	CREATE TABLE #M0070_2(
		company_cd			smallint
	,	employee_cd			nvarchar(10)	
	,	position_cd			INT		
	,	belong_cd1			nvarchar(20)
	,	belong_cd2			nvarchar(20)
	,	belong_cd3			nvarchar(20)
	,	belong_cd4			nvarchar(20)
	,	belong_cd5			nvarchar(20)
	)
	CREATE TABLE #M0070_3(
		company_cd			smallint
	,	employee_cd			nvarchar(10)
	,	position_cd			INT			
	,	belong_cd1			nvarchar(20)
	,	belong_cd2			nvarchar(20)
	,	belong_cd3			nvarchar(20)
	,	belong_cd4			nvarchar(20)
	,	belong_cd5			nvarchar(20)
	)
	CREATE TABLE #M0070_4(
		company_cd			smallint
	,	employee_cd			nvarchar(10)
	,	position_cd			INT			
	,	belong_cd1			nvarchar(20)
	,	belong_cd2			nvarchar(20)
	,	belong_cd3			nvarchar(20)
	,	belong_cd4			nvarchar(20)
	,	belong_cd5			nvarchar(20)
	)
	CREATE TABLE #M0070_5(
		company_cd			smallint
	,	employee_cd			nvarchar(10)	
	,	position_cd			INT		
	,	belong_cd1			nvarchar(20)
	,	belong_cd2			nvarchar(20)
	,	belong_cd3			nvarchar(20)
	,	belong_cd4			nvarchar(20)
	,	belong_cd5			nvarchar(20)
	)
	-- add by viettd 2021/09/08
	-- #TABLE_PAGE_TOTAL
	CREATE TABLE #TABLE_PAGE_TOTAL (
		company_cd			smallint
	,	employee_cd			nvarchar(10)
	)
	-- #TABLE_PAGE
	CREATE TABLE #TABLE_PAGE (
		company_cd			smallint
	,	employee_cd			nvarchar(10)
	)
	--Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°
	--INSERT DATA
	--Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°
	INSERT INTO #M0151
	SELECT
		M0151.company_cd			
	,	M0151.group_cd			
	,	M0151.attribute					
	,	M0151.code						
	FROM M0150
	LEFT JOIN M0151 ON (
		M0150.company_cd = M0151.company_cd
	AND M0150.group_cd	= M0151.group_cd
	)	
	WHERE
		M0151.company_cd	=	@P_company_cd
	AND M0151.group_cd		=	@P_group_cd
	GROUP BY 
		M0151.company_cd
	,	M0151.group_cd	
	,	M0151.attribute	
	,	M0151.code	
	--
	INSERT INTO #F0021
	SELECT 
		F0021.company_cd
	,	F0021.fiscal_year
	,	F0021.group_cd
	,	F0021.treatment_applications_no
	,	F0021.detail_no
	,	F0021.sheet_cd
	FROM F0021
	INNER JOIN #JSON_LIST_TREATMENT AS S ON (
		F0021.treatment_applications_no		=	S.treatment_applications_no
	)
	WHERE 
		F0021.company_cd	= @P_company_cd
	AND F0021.fiscal_year	= @P_fiscal_year
	AND F0021.group_cd		= @P_group_cd
	AND F0021.del_datetime IS NULL
	--
	SET @cnt = (SELECT COUNT(#F0021.sheet_cd) FROM #F0021)
	WHILE @i <= @cnt
	BEGIN
		INSERT INTO #F0021_TEMP
		SELECT 
			#F0021.company_cd
		,	#F0021.fiscal_year
		,	#F0021.group_cd
		,	#F0021.treatment_applications_no
		,	#F0021.detail_no
		,	#F0021.sheet_cd
		,	ISNULL(W_M0200.sheet_nm,'')
		FROM #F0021
		LEFT OUTER JOIN #F0021_TEMP ON (
			#F0021.company_cd		=	#F0021_TEMP.company_cd
		AND #F0021.fiscal_year		=	#F0021_TEMP.fiscal_year
		AND #F0021.group_cd			=	#F0021_TEMP.group_cd
		AND #F0021.sheet_cd			=	#F0021_TEMP.sheet_cd
		)
		LEFT OUTER JOIN W_M0200 ON (
			#F0021.company_cd		=	W_M0200.company_cd
		AND #F0021.fiscal_year		=	W_M0200.fiscal_year
		AND #F0021.sheet_cd			=	W_M0200.sheet_cd
		AND W_M0200.del_datetime IS NULL
		)
		WHERE 
			#F0021.id = @i
		AND #F0021_TEMP.sheet_cd IS NULL
		--
		SET @i = @i + 1
	END
	--
	INSERT INTO #M0060
	SELECT 
		M0060.company_cd		
	,	M0060.employee_typ
	,	#M0151.group_cd
	FROM M0060
	INNER JOIN #M0151 ON (
		M0060.company_cd	= #M0151.company_cd
	AND	M0060.employee_typ	= #M0151.code
	)
	WHERE 
		 M0060.company_cd = @P_company_cd
	 AND M0060.del_datetime IS NULL
	 AND #M0151.attribute = 1
	--
	INSERT INTO #M0050
	SELECT 
		M0050.company_cd		
	,	M0050.grade
	,	#M0151.group_cd
	FROM M0050
	INNER JOIN #M0151 ON (
		M0050.company_cd	= #M0151.company_cd
	AND	M0050.grade			= #M0151.code
	)
	WHERE 
		 M0050.company_cd = @P_company_cd
	 AND M0050.del_datetime IS NULL
	 AND #M0151.attribute = 4
	--
	INSERT INTO #M0040
	SELECT 
		M0040.company_cd
	,	M0040.position_cd
	,	#M0151.group_cd
	FROM M0040
	INNER JOIN #M0151 ON (
		M0040.company_cd	= #M0151.company_cd
	AND	M0040.position_cd	= #M0151.code
	)
	WHERE 
		 M0040.company_cd = @P_company_cd
	 AND M0040.del_datetime IS NULL
	 AND #M0151.attribute = 3
	--
	INSERT INTO #M0030
	SELECT 
		M0030.company_cd
	,	M0030.job_cd
	,	#M0151.group_cd
	FROM M0030
	INNER JOIN #M0151 ON (
		M0030.company_cd	= #M0151.company_cd
	AND	M0030.job_cd		= #M0151.code
	)
	WHERE 
		 M0030.company_cd = @P_company_cd
	 AND M0030.del_datetime IS NULL
	 AND #M0151.attribute = 2
	-----------------------------------------------------------------
	INSERT INTO #M0070H
	EXEC [dbo].SPC_REFER_M0070H_INQ1 @year_month_day,'',@P_company_cd
	-----------------------------------------------------------------
	INSERT INTO #M0070_EMPLOYEE_CD
	SELECT 
		#M0070H.company_cd
	,	-1						-- group_cd
	,	#M0070H.employee_cd
	,	#M0070H.employee_typ
	,	#M0070H.job_cd
	,	#M0070H.position_cd
	,	#M0070H.grade
	FROM M0070
	INNER JOIN #M0070H ON (
		M0070.company_cd	= #M0070H.company_cd
	AND M0070.employee_cd	= #M0070H.employee_cd
	)
	WHERE 
		M0070.company_cd	= @P_company_cd
	AND M0070.del_datetime IS NULL
	AND M0070.evaluated_typ = 1
	--Å´Å´Å´ add by viettd 2021/01/07
	-- CHECK company_in_dt
	AND 
	(
		M0070.company_in_dt IS NULL
	OR	M0070.company_in_dt IS NOT NULL AND M0070.company_in_dt <= @year_month_day -- START DAY OF THIS YEAR
	)
	-- CHECK company_out_dt
	AND 
	(
		M0070.company_out_dt IS NULL
	OR	M0070.company_out_dt IS NOT NULL AND M0070.company_out_dt > @year_month_day -- END DAY OF THIS YEAR
	)
	--Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°
	-- add by viettd 2021/08/24
	-- if don't choice group in screen (âÊñ è„Ç…ÉOÉãÅ[ÉvÇëIëÇ»Çµ)
	IF @P_group_cd = -1
	BEGIN
		-- UPDATE ANY GROUP IN F0030
		UPDATE #M0070_EMPLOYEE_CD SET 
			group_cd = ISNULL(F0030_GROUPED.group_cd,-1)
		FROM #M0070_EMPLOYEE_CD
		INNER JOIN (
			SELECT 
				ISNULL(F0030.company_cd,0)				AS	company_cd
			,	ISNULL(F0030.employee_cd,'')			AS	employee_cd
			,	ISNULL(F0030.group_cd,0)				AS	group_cd
			,	MIN(F0030.treatment_applications_no)	AS	treatment_applications_no
			FROM F0030
			-- add by viettd 2022/01/17
			INNER JOIN #JSON_LIST_TREATMENT ON (
				F0030.treatment_applications_no		=	#JSON_LIST_TREATMENT.treatment_applications_no
			)
			WHERE
				F0030.company_cd		=	@P_company_cd
			AND F0030.fiscal_year		=	@P_fiscal_year
			AND F0030.del_datetime IS NULL
			GROUP BY
				F0030.company_cd
			,	F0030.employee_cd
			,	F0030.group_cd
		) AS F0030_GROUPED ON(
			#M0070_EMPLOYEE_CD.company_cd		=	F0030_GROUPED.company_cd
		AND #M0070_EMPLOYEE_CD.employee_cd		=	F0030_GROUPED.employee_cd
		)
	END
	-- if choice group in screen (âÊñ è„Ç…ÉOÉãÅ[ÉvÇëIëÇ†ÇË)
	IF @P_group_cd <> -1
	BEGIN
		-- UPDATE @P_group_cd + TREATMENT_APPLICATIONS_NO
		UPDATE #M0070_EMPLOYEE_CD SET 
			group_cd = ISNULL(F0030_GROUPED.group_cd,-1)
		FROM #M0070_EMPLOYEE_CD
		INNER JOIN (
			SELECT 
				ISNULL(F0030.company_cd,0)				AS	company_cd
			,	ISNULL(F0030.employee_cd,'')			AS	employee_cd
			,	ISNULL(F0030.group_cd,0)				AS	group_cd
			,	MIN(F0030.treatment_applications_no)	AS	treatment_applications_no
			FROM F0030
			INNER JOIN #JSON_LIST_TREATMENT ON (
				F0030.company_cd				=	@P_company_cd
			AND F0030.treatment_applications_no	=	#JSON_LIST_TREATMENT.treatment_applications_no
			)
			WHERE
				F0030.company_cd	=	@P_company_cd
			AND F0030.fiscal_year	=	@P_fiscal_year
			AND F0030.group_cd		=	@P_group_cd
			AND F0030.del_datetime IS NULL
			GROUP BY
				F0030.company_cd
			,	F0030.employee_cd
			,	F0030.group_cd
		) AS F0030_GROUPED ON(
			#M0070_EMPLOYEE_CD.company_cd	=	F0030_GROUPED.company_cd
		AND	#M0070_EMPLOYEE_CD.employee_cd	=	F0030_GROUPED.employee_cd
		)
		-- UPDATE TREATMENT_APPLICATIONS_NO + OTHER @P_group_cd
		UPDATE #M0070_EMPLOYEE_CD SET 
			group_cd = ISNULL(F0030_GROUPED.group_cd,-1)
		FROM #M0070_EMPLOYEE_CD
		INNER JOIN (
			SELECT 
				ISNULL(F0030.company_cd,0)				AS	company_cd
			,	ISNULL(F0030.employee_cd,'')			AS	employee_cd
			,	MIN(F0030.group_cd)						AS	group_cd
			,	MIN(F0030.treatment_applications_no)	AS	treatment_applications_no
			FROM F0030
			INNER JOIN #JSON_LIST_TREATMENT ON (
				F0030.company_cd				=	@P_company_cd
			AND F0030.treatment_applications_no	=	#JSON_LIST_TREATMENT.treatment_applications_no
			)
			WHERE
				F0030.company_cd				=	@P_company_cd
			AND F0030.fiscal_year				=	@P_fiscal_year
			AND F0030.del_datetime IS NULL
			GROUP BY
				F0030.company_cd
			,	F0030.employee_cd
		) AS F0030_GROUPED ON(
			#M0070_EMPLOYEE_CD.company_cd	=	F0030_GROUPED.company_cd
		AND	#M0070_EMPLOYEE_CD.employee_cd	=	F0030_GROUPED.employee_cd
		)
		WHERE
			#M0070_EMPLOYEE_CD.group_cd = -1
		-- REMOVE EMPLOYEE WHEN GROUP <> @P_group_cd
		DELETE D FROM #M0070_EMPLOYEE_CD AS D
		WHERE 
			D.group_cd	<>	-1
		AND D.group_cd	<>	@P_group_cd
	END
	--Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°
	--Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å° FILTER DATA Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°
	-- äYìñÉOÉãÅ[ÉvÇ†ÇË
	IF @P_group_cd <> -1
	BEGIN
		-- #M0060
		IF EXISTS ( SELECT 1 FROM #M0060)
		BEGIN
			DELETE D FROM #M0070_EMPLOYEE_CD AS D
			LEFT OUTER JOIN #M0060 ON (
				D.company_cd	= #M0060.company_cd
			AND	D.employee_typ	= #M0060.employee_typ
			)
			WHERE 
				#M0060.employee_typ IS NULL
			AND D.group_cd = -1
		END 
		-- #M0030
		IF EXISTS ( SELECT 1 FROM #M0030)
		BEGIN
			DELETE D FROM #M0070_EMPLOYEE_CD AS D
			LEFT OUTER JOIN #M0030 ON (
				D.company_cd	= #M0030.company_cd
			AND	D.job_cd		= #M0030.job_cd
			)
			WHERE 
				#M0030.job_cd IS NULL
			AND D.group_cd = -1
		END
		-- #M0040
		IF EXISTS ( SELECT 1 FROM #M0040)
		BEGIN
			DELETE D FROM #M0070_EMPLOYEE_CD AS D
			LEFT OUTER JOIN #M0040 ON (
				D.company_cd	= #M0040.company_cd
			AND	D.position_cd	= #M0040.position_cd
			)
			WHERE 
				#M0040.position_cd IS NULL
			AND D.group_cd = -1
		END
		-- #M0050
		IF EXISTS ( SELECT 1 FROM #M0050)
		BEGIN
			DELETE D FROM #M0070_EMPLOYEE_CD AS D
			LEFT OUTER JOIN #M0050 ON (
				D.company_cd	= #M0050.company_cd
			AND	D.grade			= #M0050.grade
			)
			WHERE 
				#M0050.grade IS NULL
			AND D.group_cd = -1
		END
	END
	--Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°
	-- äYìñÉOÉãÅ[ÉvÇ»Çµ
	--Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°
	-- ADD LONGVV 2019/01/22
	-- take all employees of any group in table F0030
	INSERT INTO #EMPLOYEE_COMMON 
	SELECT 
		DISTINCT
		F0030.company_cd
	,	F0030.employee_cd
	FROM F0030
	WHERE 
		F0030.company_cd  = @P_company_cd
	AND F0030.fiscal_year = @P_fiscal_year
	AND F0030.del_datetime IS NULL 
	-- remove employee when existed in any group in F0030
	IF @P_ck_search = 1
	BEGIN
		DELETE #M0070_EMPLOYEE_CD
		FROM #M0070_EMPLOYEE_CD
		INNER JOIN #EMPLOYEE_COMMON ON (
			#M0070_EMPLOYEE_CD.company_cd	 = #EMPLOYEE_COMMON.company_cd
		AND #M0070_EMPLOYEE_CD.employee_cd	 = #EMPLOYEE_COMMON.employee_cd
		) 
	END
	--Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°
	--
	INSERT INTO #F0032
	SELECT 
		F0032.company_cd
	,	F0032.fiscal_year
	,	F0032.treatment_applications_no
	,	F0032.group_cd
	,	F0032.employee_cd
	,	F0032.detail_no
	,	F0032.sheet_cd
	FROM F0032
	INNER JOIN #JSON_LIST_TREATMENT AS S ON (
		F0032.treatment_applications_no		=	S.treatment_applications_no
	)
	INNER JOIN #M0070_EMPLOYEE_CD ON (
		F0032.company_cd		=	#M0070_EMPLOYEE_CD.company_cd
	AND F0032.employee_cd		=	#M0070_EMPLOYEE_CD.employee_cd
	)
	WHERE 
		F0032.company_cd	= @P_company_cd
	AND F0032.fiscal_year	= @P_fiscal_year
	AND (F0032.group_cd		= @P_group_cd
		OR @P_group_cd = -1
		)
	AND F0032.del_datetime IS NULL
	------------------
	SET @i = 1
	SET @cnt = (SELECT COUNT(#F0032.sheet_cd) FROM #F0032)
	WHILE @i <= @cnt
	BEGIN
		INSERT INTO #F0032_TEMP
		SELECT 
			#F0032.company_cd
		,	#F0032.fiscal_year
		,	#F0032.treatment_applications_no
		,	#F0032.group_cd
		,	#F0032.employee_cd
		,	#F0032.detail_no
		,	#F0032.sheet_cd
		,	ISNULL(W_M0200.sheet_nm,'')
		FROM #F0032
		LEFT OUTER JOIN #F0032_TEMP ON (
			#F0032.company_cd		=	#F0032_TEMP.company_cd
		AND #F0032.fiscal_year		=	#F0032_TEMP.fiscal_year
		AND #F0032.group_cd			=	#F0032_TEMP.group_cd
		AND #F0032.employee_cd		=	#F0032_TEMP.employee_cd
		AND #F0032.sheet_cd			=	#F0032_TEMP.sheet_cd
		)
		LEFT OUTER JOIN W_M0200 ON (
			#F0032.company_cd		=	W_M0200.company_cd
		AND #F0032.fiscal_year		=	W_M0200.fiscal_year
		AND #F0032.sheet_cd			=	W_M0200.sheet_cd
		AND W_M0200.del_datetime IS NULL
		)
		WHERE 
			#F0032.id = @i
		AND #F0032_TEMP.sheet_cd IS NULL
		--
		SET @i = @i + 1
	END
	-- #M0070_TEMP	
	-- IF EIXTS IN #F0021_TEMP
	IF EXISTS (SELECT 1 FROM #F0021_TEMP)
	BEGIN
		INSERT INTO #M0070_TEMP
		SELECT 
			M0070.company_cd
		,	@P_fiscal_year
		,	#M0070_EMPLOYEE_CD.group_cd
		,	M0070.employee_cd
		,	M0070.employee_nm
		,	#M0070H.employee_typ
		,	#M0070H.job_cd		
		,	#M0070H.grade						
		,	M0070.position_cd	
		,	M0300.rater_position_cd_1
		,	M0300.rater_position_cd_2
		,	M0300.rater_position_cd_3
		,	M0300.rater_position_cd_4	
		,	#M0070H.belong_cd1
		,	#M0070H.belong_cd2
		,	#M0070H.belong_cd3
		,	#M0070H.belong_cd4
		,	#M0070H.belong_cd5
		,	#M0070H.belong_nm1
		,	#M0070H.belong_nm2
		,	#M0070H.belong_nm3
		,	#M0070H.belong_nm4
		,	#M0070H.belong_nm5
		,	#M0070H.employee_typ_nm	
		,	#M0070H.job_nm			
		,	#M0070H.position_nm		
		,	#M0070H.grade_nm	
		,	#F0021_TEMP.treatment_applications_no
		,	#F0021_TEMP.sheet_cd
		,	M0200.sheet_nm
		,	#F0021_TEMP.detail_no
		FROM M0070
		INNER JOIN #M0070_EMPLOYEE_CD ON (
			M0070.company_cd	=	#M0070_EMPLOYEE_CD.company_cd
		AND	M0070.employee_cd	=	#M0070_EMPLOYEE_CD.employee_cd
		)
		LEFT OUTER JOIN #M0070H ON (
			M0070.company_cd		=	#M0070H.company_cd
		AND M0070.employee_cd		=	#M0070H.employee_cd
		)
		LEFT JOIN M0300 ON (
			M0070.company_cd		= M0300.company_cd
		AND M0070.belong_cd1		= M0300.organization_cd
		AND M0070.position_cd		= M0300.position_cd
		AND M0300.del_datetime IS NULL
		)
		LEFT OUTER JOIN #F0021_TEMP ON (
			M0070.company_cd			=	#F0021_TEMP.company_cd
		AND	@P_group_cd					=	#F0021_TEMP.group_cd		-- edited by viettd 2020/02/17
		)
		LEFT JOIN M0200 ON (
			#F0021_TEMP.company_cd		= M0200.company_cd
		AND #F0021_TEMP.sheet_cd		= M0200.sheet_cd
		)
		WHERE 
			M0070.company_cd		= @P_company_cd
		AND M0070.evaluated_typ		= 1
		AND M0070.del_datetime IS NULL 
	END
	ELSE
	BEGIN
		INSERT INTO #M0070_TEMP
		SELECT 
			M0070.company_cd
		,	@P_fiscal_year
		,	#M0070_EMPLOYEE_CD.group_cd
		,	M0070.employee_cd
		,	M0070.employee_nm
		,	#M0070H.employee_typ
		,	#M0070H.job_cd		
		,	#M0070H.grade						
		,	M0070.position_cd	
		,	M0300.rater_position_cd_1
		,	M0300.rater_position_cd_2
		,	M0300.rater_position_cd_3
		,	M0300.rater_position_cd_4	
		,	#M0070H.belong_cd1
		,	#M0070H.belong_cd2
		,	#M0070H.belong_cd3
		,	#M0070H.belong_cd4
		,	#M0070H.belong_cd5
		,	#M0070H.belong_nm1
		,	#M0070H.belong_nm2
		,	#M0070H.belong_nm3
		,	#M0070H.belong_nm4
		,	#M0070H.belong_nm5
		,	#M0070H.employee_typ_nm	
		,	#M0070H.job_nm			
		,	#M0070H.position_nm		
		,	#M0070H.grade_nm	
		,	#F0032_TEMP.treatment_applications_no
		,	NULL
		,	NULL
		,	#F0032_TEMP.detail_no
		FROM M0070
		INNER JOIN #M0070_EMPLOYEE_CD ON (
			M0070.company_cd	=	#M0070_EMPLOYEE_CD.company_cd
		AND	M0070.employee_cd	=	#M0070_EMPLOYEE_CD.employee_cd
		)
		LEFT OUTER JOIN #M0070H ON (
			M0070.company_cd		=	#M0070H.company_cd
		AND M0070.employee_cd		=	#M0070H.employee_cd
		)
		LEFT JOIN M0300 ON (
			M0070.company_cd		= M0300.company_cd
		AND M0070.belong_cd1		= M0300.organization_cd
		AND M0070.position_cd		= M0300.position_cd
		AND M0300.del_datetime IS NULL
		)
		LEFT OUTER JOIN #F0032_TEMP ON (
			#M0070_EMPLOYEE_CD.company_cd		=	#F0032_TEMP.company_cd
		AND #M0070_EMPLOYEE_CD.employee_cd		=	#F0032_TEMP.employee_cd
		AND	#M0070_EMPLOYEE_CD.group_cd			=	#F0032_TEMP.group_cd
		)
		LEFT JOIN M0200 ON (
			#F0032_TEMP.company_cd		= M0200.company_cd
		AND #F0032_TEMP.sheet_cd		= M0200.sheet_cd
		)
		WHERE 
			M0070.company_cd		= @P_company_cd
		AND M0070.evaluated_typ		= 1
		AND M0070.del_datetime IS NULL 
	END
	-- #M0070
	INSERT INTO #M0070
	SELECT 
		#M0070_TEMP.company_cd			
	,	#M0070_TEMP.fiscal_year			
	,	#M0070_TEMP.group_cd			
	,	#M0070_TEMP.employee_cd			
	,	#M0070_TEMP.employee_nm			
	,	#M0070_TEMP.employee_typ		
	,	#M0070_TEMP.job_cd				
	,	#M0070_TEMP.grade				
	,	#M0070_TEMP.position_cd			
	,	#M0070_TEMP.rater_position_cd_1	
	,	#M0070_TEMP.rater_position_cd_2	
	,	#M0070_TEMP.rater_position_cd_3	
	,	#M0070_TEMP.rater_position_cd_4	
	,	F0030.rater_employee_cd_1	
	,	F0030.rater_employee_cd_2	
	,	F0030.rater_employee_cd_3	
	,	F0030.rater_employee_cd_4	
	,	#M0070_TEMP.belong_cd1	
	,	#M0070_TEMP.belong_cd2
	,	#M0070_TEMP.belong_cd3
	,	#M0070_TEMP.belong_cd4
	,	#M0070_TEMP.belong_cd5	
	,	#M0070_TEMP.belong_nm1	
	,	#M0070_TEMP.belong_nm2
	,	#M0070_TEMP.belong_nm3
	,	#M0070_TEMP.belong_nm4
	,	#M0070_TEMP.belong_nm5	
	,	#M0070_TEMP.employee_typ_nm		
	,	#M0070_TEMP.job_nm				
	,	#M0070_TEMP.position_nm			
	,	#M0070_TEMP.grade_nm	
	,	#M0070_TEMP.treatment_applications_no			
	,	#M0070_TEMP.sheet_cd_f0021		
	,	#M0070_TEMP.sheet_nm_f0021
	,	#M0070_TEMP.detail_no
	FROM #M0070_TEMP
	LEFT JOIN F0030 ON (
		#M0070_TEMP.company_cd					= F0030.company_cd
	AND #M0070_TEMP.fiscal_year					= F0030.fiscal_year
	AND #M0070_TEMP.treatment_applications_no	= F0030.treatment_applications_no
	AND #M0070_TEMP.group_cd					= F0030.group_cd
	AND #M0070_TEMP.employee_cd					= F0030.employee_cd
	AND F0030.del_datetime IS NULL
	)
	WHERE 
		#M0070_TEMP.company_cd	= @P_company_cd
	AND	#M0070_TEMP.fiscal_year	= @P_fiscal_year
	--Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å° FILTER  Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°
	-- ORGANIZATION
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION)
	BEGIN
		SET @choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
		-- 1.choice in screen
		IF @choice_in_screen = 1
		BEGIN
			DELETE D FROM #M0070 AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.company_cd			=	@P_company_cd
			AND D.belong_cd1			=	S.organization_cd_1
			AND D.belong_cd2			=	S.organization_cd_2
			AND D.belong_cd3			=	S.organization_cd_3
			AND D.belong_cd4			=	S.organization_cd_4
			AND D.belong_cd5			=	S.organization_cd_5
			)
			WHERE 
				D.company_cd IS NULL
			OR	S.organization_typ IS NULL
		END
		ELSE IF NOT (@P_authority_typ = 3 AND @w_evaluation_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)	-- edited by viettd 2021/06/03
		BEGIN
			DELETE D FROM #M0070 AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.company_cd			=	@P_company_cd
			AND D.belong_cd1			=	S.organization_cd_1
			AND D.belong_cd2			=	S.organization_cd_2
			AND D.belong_cd3			=	S.organization_cd_3
			AND D.belong_cd4			=	S.organization_cd_4
			AND D.belong_cd5			=	S.organization_cd_5
			)
			WHERE 
				D.company_cd IS NULL
			OR	S.organization_typ IS NULL
			AND @P_authority_typ NOT IN(4,5) --4.âÔé–ä«óùé“
		END
	END
	-- ñ{êlÇÃñêEÇÊÇËâ∫à ÇÃé–àıÇÃÇ›
	IF @use_typ = 1
	BEGIN
		DELETE D FROM #M0070 AS D
		LEFT OUTER JOIN M0040 ON (
			D.company_cd		=	M0040.company_cd
		AND D.position_cd		=	M0040.position_cd
		)
		WHERE
			M0040.arrange_order <=	@arrange_order
	END
	--Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°
	-- #EVALUATIVE
	INSERT INTO #EVALUATIVE
	SELECT 
		#M0070.company_cd			
	,	#M0070.fiscal_year					
	,	#M0070.employee_cd					
	,	#M0070.treatment_applications_no	
	,	#M0070.sheet_cd_f0021
	,	#M0070.sheet_nm_f0021
	,	NULL							--	#F0032_TEMP.sheet_cd	
	,	NULL							--	#F0032_TEMP.sheet_nm
	,	#M0070.detail_no
	,	#M0070.group_cd
	FROM #M0070
	-- UPDATE NAME
	UPDATE #EVALUATIVE SET 
		sheet_cd_f0032	=	ISNULL(#F0032_TEMP.sheet_cd,0)
	,	sheet_nm_f0032	=	ISNULL(#F0032_TEMP.sheet_nm,'')
	FROM #EVALUATIVE
	INNER JOIN #F0032_TEMP ON (
		#EVALUATIVE.company_cd						=	#F0032_TEMP.company_cd
	AND #EVALUATIVE.fiscal_year						=	#F0032_TEMP.fiscal_year
	AND #EVALUATIVE.treatment_applications_no		=	#F0032_TEMP.treatment_applications_no
	AND #EVALUATIVE.group_cd						=	#F0032_TEMP.group_cd
	AND #EVALUATIVE.employee_cd						=	#F0032_TEMP.employee_cd
	AND #EVALUATIVE.detail_no						=	#F0032_TEMP.detail_no
	)
	-- GET NUMBER ROW OF SHEET_CD OF F0021
	INSERT INTO #TEMP_ROWSPAN
	SELECT
		TEMP.company_cd
	,	TEMP.fiscal_year
	,	TEMP.group_cd
	,	COUNT(sheet_cd)		-- number of rows
	FROM #F0021_TEMP AS TEMP
	GROUP BY 		  
		TEMP.company_cd
	,	TEMP.fiscal_year
	,	TEMP.group_cd
	-- 
	INSERT INTO #TEMP_ROWSPAN_TABLE
	SELECT 
		DISTINCT
		#M0070.company_cd
	,	#M0070.fiscal_year
	,	#M0070.group_cd
	,	#M0070.employee_cd
	,	#TEMP_ROWSPAN.row_span
	FROM #M0070
	LEFT OUTER JOIN #TEMP_ROWSPAN ON (
		#M0070.company_cd			=	#TEMP_ROWSPAN.company_cd
	AND #M0070.fiscal_year			=	#TEMP_ROWSPAN.fiscal_year
	AND #M0070.group_cd				=	#TEMP_ROWSPAN.group_cd
	)
	--UPDATE NUMBER ROW OF SHEET_CD OF F0032
	UPDATE #TEMP_ROWSPAN_TABLE SET 
		row_span	=	CASE 
							WHEN ISNULL(EVAL.row_span,0) > ISNULL(#TEMP_ROWSPAN_TABLE.row_span,0)
							THEN ISNULL(EVAL.row_span,0)
							ELSE ISNULL(#TEMP_ROWSPAN_TABLE.row_span,0)
						END
	FROM #TEMP_ROWSPAN_TABLE
	INNER JOIN (
		SELECT 
			#EVALUATIVE.company_cd				AS	company_cd
		,	#EVALUATIVE.fiscal_year				AS	fiscal_year
		,	#EVALUATIVE.group_cd				AS	group_cd
		,	#EVALUATIVE.employee_cd				AS	employee_cd
		,	COUNT(#EVALUATIVE.company_cd)		AS	row_span
		FROM #EVALUATIVE
		GROUP BY
			#EVALUATIVE.company_cd
		,	#EVALUATIVE.fiscal_year
		,	#EVALUATIVE.group_cd
		,	#EVALUATIVE.employee_cd
	) AS EVAL ON (
		#TEMP_ROWSPAN_TABLE.company_cd			=	EVAL.company_cd
	AND #TEMP_ROWSPAN_TABLE.fiscal_year			=	EVAL.fiscal_year
	AND #TEMP_ROWSPAN_TABLE.group_cd			=	EVAL.group_cd
	AND #TEMP_ROWSPAN_TABLE.employee_cd			=	EVAL.employee_cd
	)
	-- #DATA	
	INSERT INTO #DATA
	SELECT 
		#M0070.company_cd			
	,	#M0070.fiscal_year			
	,	#M0070.group_cd			
	,	#M0070.employee_cd	
	,	#M0070.employee_nm	
	,	#M0070.employee_typ	
	,	#M0070.job_cd
	,	#M0070.grade	
	,	#M0070.position_cd			
	,	#M0070.rater_position_cd_1	
	,	#M0070.rater_position_cd_2	
	,	#M0070.rater_position_cd_3	
	,	#M0070.rater_position_cd_4	
	,	#M0070.rater_employee_cd_1	
	,	#M0070.rater_employee_cd_2	
	,	#M0070.rater_employee_cd_3	
	,	#M0070.rater_employee_cd_4	
	,	#M0070.belong_cd1				-- add by viettd 2021/01/27
	,	#M0070.belong_cd2				-- add by viettd 2021/01/27
	,	#M0070.belong_cd3				-- add by viettd 2021/01/27
	,	#M0070.belong_cd4				-- add by viettd 2021/01/27
	,	#M0070.belong_cd5				-- add by viettd 2021/01/27
	--
	,	#M0070.belong_nm1	
	,	#M0070.belong_nm2
	,	#M0070.belong_nm3
	,	#M0070.belong_nm4
	,	#M0070.belong_nm5	
	,	#M0070.employee_typ_nm		
	,	#M0070.job_nm				
	,	#M0070.position_nm			
	,	#M0070.grade_nm	
	,	#M0070.treatment_applications_no
	,	#M0070.sheet_cd_f0021
	,	#M0070.sheet_nm_f0021
	,	NULL
	,	NULL
	,	#M0070.detail_no	
	FROM #M0070
	-- UPDATE sheet_cd_f0032 + sheet_nm_f0032
	UPDATE #DATA SET 
		sheet_cd_f0032	=	EVAL.sheet_cd_f0032
	,	sheet_nm_f0032	=	EVAL.sheet_nm_f0032
	FROM #DATA
	LEFT OUTER JOIN #EVALUATIVE AS EVAL ON (
		#DATA.company_cd					= EVAL.company_cd
	AND #DATA.fiscal_year					= EVAL.fiscal_year
	AND #DATA.treatment_applications_no		= EVAL.treatment_applications_no
	AND #DATA.group_cd						= EVAL.group_cd
	AND #DATA.employee_cd					= EVAL.employee_cd
	AND #DATA.detail_no						= EVAL.detail_no
	)
	-- INSERT TO #DATA RECORD NOT EXISTS IN #M0070 (F0021) BUT EXISTS IN #EVALUATIVE (F0032)
	INSERT INTO #DATA
	SELECT 
		#EVALUATIVE.company_cd			
	,	#EVALUATIVE.fiscal_year			
	,	#EVALUATIVE.group_cd			
	,	#EVALUATIVE.employee_cd	
	,	#M0070H.employee_nm	
	,	#M0070H.employee_typ	
	,	#M0070H.job_cd
	,	#M0070H.grade	
	,	#M0070H.position_cd			
	,	NULL
	,	NULL
	,	NULL
	,	NULL
	,	NULL
	,	NULL
	,	NULL
	,	NULL
	,	#M0070H.belong_cd1				-- add by viettd 2021/01/27
	,	#M0070H.belong_cd2				-- add by viettd 2021/01/27
	,	#M0070H.belong_cd3				-- add by viettd 2021/01/27
	,	#M0070H.belong_cd4				-- add by viettd 2021/01/27
	,	#M0070H.belong_cd5				-- add by viettd 2021/01/27
	--
	,	#M0070H.belong_nm1	
	,	#M0070H.belong_nm2
	,	#M0070H.belong_nm3
	,	#M0070H.belong_nm4
	,	#M0070H.belong_nm5	
	,	#M0070H.employee_typ_nm		
	,	#M0070H.job_nm				
	,	#M0070H.position_nm			
	,	#M0070H.grade_nm	
	,	#EVALUATIVE.treatment_applications_no
	,	#EVALUATIVE.sheet_cd_f0021
	,	#EVALUATIVE.sheet_nm_f0021
	,	#EVALUATIVE.sheet_cd_f0032
	,	#EVALUATIVE.sheet_nm_f0032
	,	#EVALUATIVE.detail_no
	FROM #EVALUATIVE
	INNER JOIN #M0070H ON(
		#EVALUATIVE.company_cd			=	#M0070H.company_cd
	AND #EVALUATIVE.employee_cd			=	#M0070H.employee_cd
	)
	LEFT OUTER JOIN #DATA ON(
		#EVALUATIVE.company_cd					=	#DATA.company_cd
	AND #EVALUATIVE.fiscal_year					=	#DATA.fiscal_year
	AND #EVALUATIVE.employee_cd					=	#DATA.employee_cd
	AND #EVALUATIVE.group_cd					=	#DATA.group_cd
	AND #EVALUATIVE.treatment_applications_no	=	#DATA.treatment_applications_no
	AND #EVALUATIVE.detail_no					=	#DATA.detail_no
	)
	WHERE
		#DATA.employee_cd IS NULL
	-- UPDATE INFORMATION OF rater1~rater4
	UPDATE #DATA SET 
		rater_employee_cd_1			=	M0070_MAX.rater_employee_cd_1	
	,	rater_employee_cd_2			=	M0070_MAX.rater_employee_cd_2	
	,	rater_employee_cd_3			=	M0070_MAX.rater_employee_cd_3	
	,	rater_employee_cd_4			=	M0070_MAX.rater_employee_cd_4	
	FROM #DATA
	INNER JOIN (
		SELECT 
			#M0070.company_cd			AS	company_cd
		,	#M0070.fiscal_year			AS	fiscal_year
		,	#M0070.employee_cd			AS	employee_cd
		,	#M0070.rater_employee_cd_1	AS	rater_employee_cd_1
		,	#M0070.rater_employee_cd_2	AS	rater_employee_cd_2
		,	#M0070.rater_employee_cd_3	AS	rater_employee_cd_3
		,	#M0070.rater_employee_cd_4	AS	rater_employee_cd_4
		,	MAX(#M0070.detail_no)		AS	detail_no
		FROM #M0070
		WHERE 
			#M0070.rater_employee_cd_1 IS NOT NULL
		OR	#M0070.rater_employee_cd_2 IS NOT NULL
		OR	#M0070.rater_employee_cd_3 IS NOT NULL
		OR	#M0070.rater_employee_cd_4 IS NOT NULL
		GROUP BY
			#M0070.company_cd	
		,	#M0070.fiscal_year	
		,	#M0070.employee_cd	
		,	#M0070.rater_employee_cd_1
		,	#M0070.rater_employee_cd_2
		,	#M0070.rater_employee_cd_3
		,	#M0070.rater_employee_cd_4
	) AS M0070_MAX ON (
		#DATA.company_cd			=	M0070_MAX.company_cd
	AND #DATA.fiscal_year			=	M0070_MAX.fiscal_year
	AND #DATA.employee_cd			=	M0070_MAX.employee_cd
	)
	-- #RESULT
	INSERT INTO #RESULT
	SELECT 
		ROW_NUMBER() OVER(PARTITION BY #DATA.company_cd,#DATA.fiscal_year,#DATA.group_cd,#DATA.employee_cd ORDER BY #DATA.employee_cd ASC) AS row_number 
	,	#DATA.company_cd			
	,	#DATA.fiscal_year			
	,	#DATA.group_cd			
	,	#DATA.employee_cd	
	,	#DATA.employee_nm
	,	#DATA.employee_typ	
	,	#DATA.job_cd
	,	#DATA.grade
	,	#DATA.position_cd			
	,	#DATA.rater_position_cd_1	
	,	#DATA.rater_position_cd_2	
	,	#DATA.rater_position_cd_3	
	,	#DATA.rater_position_cd_4	
	,	#DATA.rater_employee_cd_1	
	,	#DATA.rater_employee_cd_2	
	,	#DATA.rater_employee_cd_3	
	,	#DATA.rater_employee_cd_4	
	,	#DATA.belong_cd1				-- add by viettd 2021/01/27
	,	#DATA.belong_cd2				-- add by viettd 2021/01/27
	,	#DATA.belong_cd3				-- add by viettd 2021/01/27
	,	#DATA.belong_cd4				-- add by viettd 2021/01/27
	,	#DATA.belong_cd5				-- add by viettd 2021/01/27
	--
	,	#DATA.belong_nm1	
	,	#DATA.belong_nm2
	,	#DATA.belong_nm3
	,	#DATA.belong_nm4
	,	#DATA.belong_nm5
	,	#DATA.employee_typ_nm		
	,	#DATA.job_nm				
	,	#DATA.position_nm			
	,	#DATA.grade_nm	
	,	#DATA.treatment_applications_no
	,	#DATA.sheet_cd_f0021
	,	#DATA.sheet_nm_f0021
	,	#DATA.sheet_cd_f0032
	,	#DATA.sheet_nm_f0032	
	,	0
	,	DENSE_RANK () OVER(ORDER BY  
								#DATA.company_cd
							,	CASE ISNUMERIC(#DATA.employee_cd) 
								   WHEN 1 
								   THEN CAST(#DATA.employee_cd AS BIGINT) 
								   ELSE 999999999999999 
								END 
							,	#DATA.employee_cd
							,	#DATA.group_cd ASC) 
	,	#DATA.detail_no
	FROM #DATA
	LEFT OUTER JOIN #TEMP_ROWSPAN_TABLE AS TEMP ON(
		#DATA.company_cd	=	TEMP.company_cd
	AND	#DATA.fiscal_year	=	TEMP.fiscal_year
	AND	#DATA.group_cd		=	TEMP.group_cd
	AND #DATA.employee_cd	=	TEMP.employee_cd
	)
	WHERE
		#DATA.company_cd		=	@P_company_cd
	-- add by viettd 2020/02/17
	AND (
			@P_employee_cd_screen = ''
		OR	(
				@P_employee_cd_screen <> '' AND #DATA.employee_cd = @P_employee_cd_screen
		)
	)
	AND (
		#DATA.employee_nm LIKE '%'+@P_employee_nm_screen+'%'			-- add by viettd 2020/03/06
	OR	#DATA.employee_cd LIKE '%'+@P_employee_nm_screen+'%'
	)
	
	ORDER BY 
		#DATA.company_cd
	,	CASE ISNUMERIC(#DATA.employee_cd) 
			WHEN 1 
			THEN CAST(#DATA.employee_cd AS BIGINT) 
			ELSE 999999999999999 
		END 
	,	#DATA.employee_cd
	,	#DATA.group_cd	
	,	#DATA.treatment_applications_no
	,	#DATA.detail_no
	--
	INSERT INTO #DATA_GROUP_COUNT
	SELECT
		#RESULT.company_cd			
	,	#RESULT.fiscal_year			
	,	#RESULT.group_cd			
	,	#RESULT.employee_cd
	,	ISNULL(MAX([row_number]), 1)
	FROM #RESULT
	GROUP BY
		#RESULT.company_cd
	,	#RESULT.fiscal_year
	,	#RESULT.group_cd
	,	#RESULT.employee_cd
	--
	UPDATE A SET 
		[row] = B.num
	FROM #RESULT AS A
	INNER JOIN #DATA_GROUP_COUNT AS B ON (
		A.company_cd	= B.company_cd
	AND	A.fiscal_year	= B.fiscal_year
	AND	A.group_cd		= B.group_cd
	AND	A.employee_cd	= B.employee_cd
	)
	--
	INSERT INTO #F0200
	SELECT
		R.company_cd
	,	R.fiscal_year
	,	R.employee_cd
	,	R.treatment_applications_no
	,	COUNT(R.company_cd)
	FROM #RESULT AS R
	LEFT JOIN F0200 ON (
		R.company_cd	=	F0200.company_cd
	AND	R.fiscal_year	=	F0200.fiscal_year
	AND	R.employee_cd	=	F0200.employee_cd
	AND	R.treatment_applications_no	=	F0200.treatment_applications_no
	)
	WHERE
		F0200.confirm_datetime IS NOT NULL
	GROUP BY
		R.company_cd
	,	R.fiscal_year
	,	R.employee_cd
	,	R.treatment_applications_no
	-- add by viettd 2021/09/08
	INSERT INTO #TABLE_PAGE_TOTAL
	SELECT 
		#RESULT.company_cd
	,	#RESULT.employee_cd
	FROM #RESULT
	GROUP BY
		#RESULT.company_cd
	,	#RESULT.employee_cd
	-- get paging value
	SET @totalRecord	=	(SELECT COUNT(1) FROM #TABLE_PAGE_TOTAL)
	SET @pageMax		=	CEILING(CAST(@totalRecord AS FLOAT) / @w_page_size)
	IF @pageMax		= 0
	BEGIN
		SET @pageMax	= 1
	END
	IF @w_page > @pageMax
	BEGIN
		SET @w_page = @pageMax
	END
	--
	INSERT INTO #TABLE_PAGE
	SELECT 
		company_cd
	,	employee_cd
	FROM #TABLE_PAGE_TOTAL
	WHERE 
		#TABLE_PAGE_TOTAL.company_cd	=	@P_company_cd
	ORDER BY
		CASE ISNUMERIC(#TABLE_PAGE_TOTAL.employee_cd) 
			WHEN 1 
			THEN CAST(#TABLE_PAGE_TOTAL.employee_cd AS BIGINT) 
			ELSE 999999999999999 
		END 
	,	#TABLE_PAGE_TOTAL.employee_cd
	offset (@w_page - 1) * @w_page_size rows
	fetch next @w_page_size rows only
	-- end add by viettd 2021/09/08
	--Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°
	--RESULT
	--Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°
COMPLETED:
	--[0]
	-- check mode export csv
	IF @P_mode = 1
	BEGIN
		-- INSERT DATA INTO TABLE #TABLE_CSV
		INSERT INTO #TABLE_CSV
		SELECT 
			#RESULT.group_cd										AS	group_cd	
		,	ISNULL(M0150.group_nm,'')								AS	group_nm
		,	#RESULT.employee_cd										AS	employee_cd
		,	ISNULL(#RESULT.employee_nm,'')							AS	employee_nm	
		,	CONVERT(NVARCHAR(50),#RESULT.rater_employee_cd_1)		AS	rater_employee_cd_1
		,	CONVERT(NVARCHAR(50),M0070_A.employee_nm)				AS	rater_employee_nm_1
		,	CONVERT(NVARCHAR(50),#RESULT.rater_employee_cd_2)		AS	rater_employee_cd_2
		,	CONVERT(NVARCHAR(50),M0070_B.employee_nm)				AS	rater_employee_nm_2
		,	CONVERT(NVARCHAR(50),#RESULT.rater_employee_cd_3)		AS	rater_employee_cd_3
		,	CONVERT(NVARCHAR(50),M0070_C.employee_nm)				AS	rater_employee_nm_3
		,	CONVERT(NVARCHAR(50),#RESULT.rater_employee_cd_4)		AS	rater_employee_cd_4
		,	CONVERT(NVARCHAR(50),M0070_D.employee_nm)				AS	rater_employee_nm_4		
		,	ISNULL(#RESULT.employee_typ,0)							AS	employee_typ
		,	ISNULL(#RESULT.job_cd,0)								AS	job_cd
		,	ISNULL(#RESULT.position_cd,0)							AS	position_cd
		,	ISNULL(#RESULT.grade,0)									AS	grade
		FROM #RESULT
		LEFT JOIN M0070 AS M0070_A ON (
			#RESULT.company_cd			= M0070_A.company_cd
		AND #RESULT.rater_employee_cd_1	= M0070_A.employee_cd
		)
		LEFT JOIN M0070 AS M0070_B ON (
			#RESULT.company_cd			= M0070_B.company_cd
		AND #RESULT.rater_employee_cd_2	= M0070_B.employee_cd
		)
		LEFT JOIN M0070 AS M0070_C ON (
			#RESULT.company_cd			= M0070_C.company_cd
		AND #RESULT.rater_employee_cd_3	= M0070_C.employee_cd
		)
		LEFT JOIN M0070 AS M0070_D ON (
			#RESULT.company_cd			= M0070_D.company_cd
		AND #RESULT.rater_employee_cd_4	= M0070_D.employee_cd
		)
		LEFT OUTER JOIN M0150 ON(
			#RESULT.company_cd			=	M0150.company_cd
		AND #RESULT.group_cd			=	M0150.group_cd
		AND M0150.del_datetime IS NULL
		)
		WHERE 
			#RESULT.row_number = 1
		--
		INSERT INTO #TABLE_CSV_GROUP
		SELECT 
			#TABLE_CSV.employee_cd
		,	M0150.group_cd
		,	M0150.group_nm
		,	#TABLE_CSV.employee_typ
		,	#TABLE_CSV.job_cd
		,	#TABLE_CSV.position_cd
		,	#TABLE_CSV.grade
		FROM #TABLE_CSV
		LEFT OUTER JOIN M0150 ON (
			@P_company_cd			=	M0150.company_cd
		)
		WHERE 
			M0150.company_cd		=	@P_company_cd
		AND M0150.del_datetime IS NULL
		AND #TABLE_CSV.group_cd		=	-1

		-- 1.é–àıãÊï™
		DELETE D FROM #TABLE_CSV_GROUP AS D
		LEFT OUTER JOIN (
			SELECT 
				ISNULL(M0151.group_cd,0)	AS	group_cd
			,	ISNULL(M0151.code,0)		AS	employee_typ
			FROM M0151
			WHERE 
				M0151.company_cd	=	@P_company_cd
			AND M0151.attribute		=	1
			AND M0151.del_datetime IS NULL
		) AS M0151_é–àıãÊï™ ON (
			D.group_cd			=	M0151_é–àıãÊï™.group_cd
		AND	D.employee_typ		=	M0151_é–àıãÊï™.employee_typ
		)
		WHERE 
			M0151_é–àıãÊï™.group_cd IS NULL
		-- 2.êEéÌ
		DELETE D FROM #TABLE_CSV_GROUP AS D
		LEFT OUTER JOIN (
			SELECT 
				ISNULL(M0151.group_cd,0)	AS	group_cd
			,	ISNULL(M0151.code,0)		AS	job_cd
			FROM M0151
			WHERE 
				M0151.company_cd	=	@P_company_cd
			AND M0151.attribute		=	2
			AND M0151.del_datetime IS NULL
		) AS M0151_êEéÌ ON (
			D.group_cd			=	M0151_êEéÌ.group_cd
		AND	D.job_cd			=	M0151_êEéÌ.job_cd
		)
		WHERE 
			M0151_êEéÌ.group_cd IS NULL
		-- 3.ñêE
		DELETE D FROM #TABLE_CSV_GROUP AS D
		LEFT OUTER JOIN (
			SELECT 
				ISNULL(M0151.group_cd,0)	AS	group_cd
			,	ISNULL(M0151.code,0)		AS	position_cd
			FROM M0151
			WHERE 
				M0151.company_cd	=	@P_company_cd
			AND M0151.attribute		=	3
			AND M0151.del_datetime IS NULL
		) AS M0151_êEéÌ ON (
			D.group_cd			=	M0151_êEéÌ.group_cd
		AND	D.position_cd		=	M0151_êEéÌ.position_cd
		)
		WHERE 
			M0151_êEéÌ.group_cd IS NULL
		-- 4.ìôãâ
		DELETE D FROM #TABLE_CSV_GROUP AS D
		LEFT OUTER JOIN (
			SELECT 
				ISNULL(M0151.group_cd,0)	AS	group_cd
			,	ISNULL(M0151.code,0)		AS	grade
			FROM M0151
			WHERE 
				M0151.company_cd	=	@P_company_cd
			AND M0151.attribute		=	4
			AND M0151.del_datetime IS NULL
		) AS M0151_êEéÌ ON (
			D.group_cd			=	M0151_êEéÌ.group_cd
		AND	D.grade				=	M0151_êEéÌ.grade
		)
		WHERE 
			M0151_êEéÌ.group_cd IS NULL
		-- UPDATE GROUP INTO #TABLE_CSV
		UPDATE #TABLE_CSV SET 
			group_cd	=	ISNULL(TABLE_GROUP.group_cd,-1)
		,	group_nm	=	ISNULL(TABLE_GROUP.group_nm,'')
		FROM #TABLE_CSV
		INNER JOIN (
			SELECT 
				MIN(group_cd)		AS	group_cd
			,	group_nm			AS	group_nm
			,	employee_cd			AS	employee_cd
			FROM #TABLE_CSV_GROUP
			GROUP BY
				#TABLE_CSV_GROUP.employee_cd
			,	#TABLE_CSV_GROUP.group_nm
		) AS TABLE_GROUP ON (
			#TABLE_CSV.employee_cd	=	TABLE_GROUP.employee_cd
		)
		--Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å° CSV Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°
		-- INSERT DATA INTO #HEADER
		INSERT INTO #HEADER VALUES(
			IIF(@w_language= 2,'Group Code','ÉOÉãÅ[ÉvÉRÅ[Éh')
		,	IIF(@w_language= 2,'Group Title','ÉOÉãÅ[ÉvñºèÃ')			
		,	IIF(@w_language= 2,'Employee Code','é–àıÉRÅ[Éh')		
		,	IIF(@w_language= 2,'Employee Name','é–àıñº')					
		,	IIF(@w_language= 2,'First Evaluator','àÍéüï]âøé“')			
		,	IIF(@w_language= 2,'First Evaluator Name','àÍéüï]âøé“ñº')		
		,	IIF(@w_language= 2,'Second Evaluator','ìÒéüï]âøé“')			
		,	IIF(@w_language= 2,'Second Evaluator Name','ìÒéüï]âøé“ñº')		
		,	IIF(@w_language= 2,'Third Evaluator','éOéüï]âøé“')			
		,	IIF(@w_language= 2,'Third Evaluator Name','éOéüï]âøé“ñº')		
		,	IIF(@w_language= 2,'Fourth Evaluator','éléüï]âøé“')			
		,	IIF(@w_language= 2,'Fourth Evaluator Name','éléüï]âøé“ñº')		
		)
		--
		SELECT
			group_cd						AS group_cd
		,	group_nm						AS group_nm	
		,	employee_cd						AS employee_cd
		,	employee_nm						AS employee_nm	
		,	rater_employee_cd_1				AS rater_employee_cd_1
		,	rater_employee_nm_1				AS rater_employee_nm_1
		,	rater_employee_cd_2				AS rater_employee_cd_2
		,	rater_employee_nm_2				AS rater_employee_nm_2
		,	rater_employee_cd_3				AS rater_employee_cd_3
		,	rater_employee_nm_3				AS rater_employee_nm_3
		,	rater_employee_cd_4				AS rater_employee_cd_4
		,	rater_employee_nm_4				AS rater_employee_nm_4	
		FROM #HEADER
		UNION ALL
		SELECT 
			CASE 
				WHEN #TABLE_CSV.group_cd > 0
				THEN CAST(#TABLE_CSV.group_cd AS nvarchar(50))	
				ELSE SPACE(0)
			END																			AS	group_cd
		,	#TABLE_CSV.group_nm															AS	group_nm
		,	#TABLE_CSV.employee_cd														AS	employee_cd
		,	ISNULL(#TABLE_CSV.employee_nm,'')											AS	employee_nm	
		,	IIF(@Rater1 ='',CONVERT(NVARCHAR(50),#TABLE_CSV.rater_employee_cd_1),'')	AS	rater_employee_cd_1
		,	IIF(@Rater1 ='',CONVERT(NVARCHAR(50),#TABLE_CSV.rater_employee_nm_1),'')	AS	rater_employee_nm_1
		,	IIF(@Rater2 ='',CONVERT(NVARCHAR(50),#TABLE_CSV.rater_employee_cd_2),'')	AS	rater_employee_cd_2
		,	IIF(@Rater2 ='',CONVERT(NVARCHAR(50),#TABLE_CSV.rater_employee_nm_2),'')	AS	rater_employee_nm_2
		,	IIF(@Rater3 ='',CONVERT(NVARCHAR(50),#TABLE_CSV.rater_employee_cd_3),'')	AS	rater_employee_cd_3
		,	IIF(@Rater3 ='',CONVERT(NVARCHAR(50),#TABLE_CSV.rater_employee_nm_3),'')	AS	rater_employee_nm_3
		,	IIF(@Rater4 ='',CONVERT(NVARCHAR(50),#TABLE_CSV.rater_employee_cd_4),'')	AS	rater_employee_cd_4
		,	IIF(@Rater4 ='',CONVERT(NVARCHAR(50),#TABLE_CSV.rater_employee_nm_4),'')	AS	rater_employee_nm_4		
		FROM #TABLE_CSV
	END
	--Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å° apply_lastest Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°
	ELSE IF @P_mode = 2
	BEGIN
		-- add by viettd 2020/05/21
		INSERT INTO #M0300_îﬁï]âøé“
		SELECT 
			DISTINCT
			#M0070_EMPLOYEE_CD.company_cd
		,	#M0070_EMPLOYEE_CD.employee_cd
		,	#M0070H.belong_cd1
		,	#M0070H.belong_cd2
		,	#M0070H.belong_cd3
		,	#M0070H.belong_cd4
		,	#M0070H.belong_cd5
		,	#M0070_EMPLOYEE_CD.position_cd
		,	ISNULL(M0300.rater_position_cd_1,0)
		,	ISNULL(M0300.rater_position_cd_2,0)
		,	ISNULL(M0300.rater_position_cd_3,0)
		,	ISNULL(M0300.rater_position_cd_4,0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		FROM #M0070_EMPLOYEE_CD
		-- add by viettd 2021/09/08
		INNER JOIN #TABLE_EMPLOYEES_CHECKED ON (
			#M0070_EMPLOYEE_CD.company_cd	=	@P_company_cd
		AND #M0070_EMPLOYEE_CD.employee_cd	=	#TABLE_EMPLOYEES_CHECKED.employee_cd
		)
		INNER JOIN #M0070H ON (
			#M0070_EMPLOYEE_CD.company_cd	=	#M0070H.company_cd
		AND #M0070_EMPLOYEE_CD.employee_cd	=	#M0070H.employee_cd
		)
		LEFT OUTER JOIN M0300 ON (
			#M0070H.company_cd			=	M0300.company_cd
		AND #M0070H.belong_cd1			=	M0300.organization_cd
		AND #M0070H.position_cd			=	M0300.position_cd
		AND M0300.del_datetime IS NULL
		)
		WHERE 
			M0300.company_cd			=	@P_company_cd
		AND M0300.del_datetime IS NULL
		AND (
			M0300.rater_position_cd_1	<>	0
		OR	M0300.rater_position_cd_2	<>	0
		OR	M0300.rater_position_cd_3	<>	0
		OR	M0300.rater_position_cd_4	<>	0
		)
		-- Å¶M0300.rater_position_cd_X ÅÅÇOÇÃéûÇÕÅAèàóùëŒè€äOÅB
		-- belong_cd1 blank
		INSERT INTO #M0070_0
		SELECT 
			#M0070H.company_cd
		,	MIN(#M0070H.employee_cd)
		,	#M0070H.position_cd
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		FROM #M0070H
		WHERE
			#M0070H.company_cd	=	@P_company_cd
		AND #M0070H.belong_cd1  =	''
		AND #M0070H.belong_cd2	=	''
		AND #M0070H.belong_cd3	=	''
		AND #M0070H.belong_cd4	=	''
		AND #M0070H.belong_cd5	=	''
		GROUP BY
			#M0070H.company_cd
		,	#M0070H.position_cd
		-- belong_cd1
		INSERT INTO #M0070_1
		SELECT 
			#M0070H.company_cd
		,	MIN(#M0070H.employee_cd)
		,	#M0070H.position_cd
		,	#M0070H.belong_cd1
		,	#M0070H.belong_cd2
		,	#M0070H.belong_cd3
		,	#M0070H.belong_cd4
		,	#M0070H.belong_cd5
		FROM #M0070H
		INNER JOIN #M0300_îﬁï]âøé“ ON (
			#M0070H.company_cd		=	#M0300_îﬁï]âøé“.company_cd
		AND #M0070H.belong_cd1		=	#M0300_îﬁï]âøé“.belong_cd1
		)
		WHERE
			#M0070H.company_cd	=	@P_company_cd
		AND #M0070H.belong_cd1 <> ''
		AND #M0070H.belong_cd2	=	''
		AND #M0070H.belong_cd3	=	''
		AND #M0070H.belong_cd4	=	''
		AND #M0070H.belong_cd5	=	''
		GROUP BY
			#M0070H.company_cd
		,	#M0070H.belong_cd1
		,	#M0070H.belong_cd2
		,	#M0070H.belong_cd3
		,	#M0070H.belong_cd4
		,	#M0070H.belong_cd5
		,	#M0070H.position_cd
		-- belong_cd2
		INSERT INTO #M0070_2
		SELECT 
			#M0070H.company_cd
		,	MIN(#M0070H.employee_cd)
		,	#M0070H.position_cd
		,	#M0070H.belong_cd1
		,	#M0070H.belong_cd2
		,	#M0070H.belong_cd3
		,	#M0070H.belong_cd4
		,	#M0070H.belong_cd5
		FROM #M0070H
		INNER JOIN #M0300_îﬁï]âøé“ ON (
			#M0070H.company_cd		=	#M0300_îﬁï]âøé“.company_cd
		AND #M0070H.belong_cd1		=	#M0300_îﬁï]âøé“.belong_cd1
		AND #M0070H.belong_cd2		=	#M0300_îﬁï]âøé“.belong_cd2
		)
		WHERE
			#M0070H.company_cd	=	@P_company_cd
		AND #M0070H.belong_cd1 <> ''
		AND #M0070H.belong_cd2 <> ''
		AND #M0070H.belong_cd3	=	''
		AND #M0070H.belong_cd4	=	''
		AND #M0070H.belong_cd5	=	''
		GROUP BY
			#M0070H.company_cd
		,	#M0070H.belong_cd1
		,	#M0070H.belong_cd2
		,	#M0070H.belong_cd3
		,	#M0070H.belong_cd4
		,	#M0070H.belong_cd5
		,	#M0070H.position_cd
		-- belong_cd3
		INSERT INTO #M0070_3
		SELECT 
			#M0070H.company_cd
		,	MIN(#M0070H.employee_cd)
		,	#M0070H.position_cd
		,	#M0070H.belong_cd1
		,	#M0070H.belong_cd2
		,	#M0070H.belong_cd3
		,	#M0070H.belong_cd4
		,	#M0070H.belong_cd5
		FROM #M0070H
		INNER JOIN #M0300_îﬁï]âøé“ ON (
			#M0070H.company_cd		=	#M0300_îﬁï]âøé“.company_cd
		AND #M0070H.belong_cd1		=	#M0300_îﬁï]âøé“.belong_cd1
		AND #M0070H.belong_cd2		=	#M0300_îﬁï]âøé“.belong_cd2
		AND #M0070H.belong_cd3		=	#M0300_îﬁï]âøé“.belong_cd3
		)
		WHERE
			#M0070H.company_cd	=	@P_company_cd
		AND #M0070H.belong_cd1 <> ''
		AND #M0070H.belong_cd2 <> ''
		AND #M0070H.belong_cd3 <> ''
		AND #M0070H.belong_cd4	=	''
		AND #M0070H.belong_cd5	=	''
		GROUP BY
			#M0070H.company_cd
		,	#M0070H.belong_cd1
		,	#M0070H.belong_cd2
		,	#M0070H.belong_cd3
		,	#M0070H.belong_cd4
		,	#M0070H.belong_cd5
		,	#M0070H.position_cd
		-- belong_cd4
		INSERT INTO #M0070_4
		SELECT 
			#M0070H.company_cd
		,	MIN(#M0070H.employee_cd)
		,	#M0070H.position_cd
		,	#M0070H.belong_cd1
		,	#M0070H.belong_cd2
		,	#M0070H.belong_cd3
		,	#M0070H.belong_cd4
		,	#M0070H.belong_cd5
		FROM #M0070H
		INNER JOIN #M0300_îﬁï]âøé“ ON (
			#M0070H.company_cd		=	#M0300_îﬁï]âøé“.company_cd
		AND #M0070H.belong_cd1		=	#M0300_îﬁï]âøé“.belong_cd1
		AND #M0070H.belong_cd2		=	#M0300_îﬁï]âøé“.belong_cd2
		AND #M0070H.belong_cd3		=	#M0300_îﬁï]âøé“.belong_cd3
		AND #M0070H.belong_cd4		=	#M0300_îﬁï]âøé“.belong_cd4
		)
		WHERE
			#M0070H.company_cd	=	@P_company_cd
		AND #M0070H.belong_cd1 <> ''
		AND #M0070H.belong_cd2 <> ''
		AND #M0070H.belong_cd3 <> ''
		AND #M0070H.belong_cd4 <> ''
		AND #M0070H.belong_cd5	=	''
		GROUP BY
			#M0070H.company_cd
		,	#M0070H.belong_cd1
		,	#M0070H.belong_cd2
		,	#M0070H.belong_cd3
		,	#M0070H.belong_cd4
		,	#M0070H.belong_cd5
		,	#M0070H.position_cd
		-- belong_cd5
		INSERT INTO #M0070_5
		SELECT 
			#M0070H.company_cd
		,	MIN(#M0070H.employee_cd)
		,	#M0070H.position_cd
		,	#M0070H.belong_cd1
		,	#M0070H.belong_cd2
		,	#M0070H.belong_cd3
		,	#M0070H.belong_cd4
		,	#M0070H.belong_cd5
		FROM #M0070H
		INNER JOIN #M0300_îﬁï]âøé“ ON (
			#M0070H.company_cd		=	#M0300_îﬁï]âøé“.company_cd
		AND #M0070H.belong_cd1		=	#M0300_îﬁï]âøé“.belong_cd1
		AND #M0070H.belong_cd2		=	#M0300_îﬁï]âøé“.belong_cd2
		AND #M0070H.belong_cd3		=	#M0300_îﬁï]âøé“.belong_cd3
		AND #M0070H.belong_cd4		=	#M0300_îﬁï]âøé“.belong_cd4
		AND #M0070H.belong_cd5		=	#M0300_îﬁï]âøé“.belong_cd5
		)
		WHERE
			#M0070H.company_cd	=	@P_company_cd
		AND #M0070H.belong_cd1 <> ''
		AND #M0070H.belong_cd2 <> ''
		AND #M0070H.belong_cd3 <> ''
		AND #M0070H.belong_cd4 <> ''
		AND #M0070H.belong_cd5 <> ''
		GROUP BY
			#M0070H.company_cd
		,	#M0070H.belong_cd1
		,	#M0070H.belong_cd2
		,	#M0070H.belong_cd3
		,	#M0070H.belong_cd4
		,	#M0070H.belong_cd5
		,	#M0070H.position_cd
		-- belong_cd1 = 0
		IF EXISTS (SELECT 1 FROM #M0070_0)
		BEGIN
			-- 1
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_1 = #M0070_0.employee_cd
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_0 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_0.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_1		=	#M0070_0.position_cd
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_0.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_1	!=	0  --2020.10.01
			-- 2
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_2 = #M0070_0.employee_cd
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_0 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_0.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_2		=	#M0070_0.position_cd
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_0.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_2	!=	0  --2020.10.01
			--3
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_3 = #M0070_0.employee_cd
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_0 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_0.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_3		=	#M0070_0.position_cd
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_0.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_3	!=	0  --2020.10.01
			--4
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_4 = #M0070_0.employee_cd
			FROM #M0300_îﬁï]âøé“
			LEFT OUTER JOIN #M0070_0 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_0.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_4		=	#M0070_0.position_cd
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_0.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_4	!=	0  --2020.10.01
		END 
		--	belong_cd1
		IF EXISTS (SELECT 1 FROM #M0070_1)
		BEGIN
			-- 1
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_1 = #M0070_1.employee_cd
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_1 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_1.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_1		=	#M0070_1.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_1.belong_cd1
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_1.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_1	!=	0  --2020.10.01
			-- 2
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_2 = #M0070_1.employee_cd
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_1 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_1.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_2		=	#M0070_1.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_1.belong_cd1
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_1.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_2	!=	0  --2020.10.01
			--3
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_3 = #M0070_1.employee_cd
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_1 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_1.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_3		=	#M0070_1.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_1.belong_cd1
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_1.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_3	!=	0  --2020.10.01
			--4
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_4 = #M0070_1.employee_cd
			FROM #M0300_îﬁï]âøé“
			LEFT OUTER JOIN #M0070_1 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_1.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_4		=	#M0070_1.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_1.belong_cd1
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_1.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_4	!=	0  --2020.10.01
		END
		--	belong_cd2
		IF EXISTS (SELECT 1 FROM #M0070_2)
		BEGIN
			-- 1
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_1 =	CASE 
										WHEN ISNULL(#M0070_2.employee_cd,'') <> ''
										THEN #M0070_2.employee_cd
										ELSE #M0300_îﬁï]âøé“.rater_employee_cd_1
										END
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_2 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_2.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_1		=	#M0070_2.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_2.belong_cd1
			AND #M0300_îﬁï]âøé“.belong_cd2				=	#M0070_2.belong_cd2
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_2.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_1	!=	0  --2020.10.01
			-- 2
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_2 =	CASE 
										WHEN ISNULL(#M0070_2.employee_cd,'') <> ''
										THEN #M0070_2.employee_cd
										ELSE #M0300_îﬁï]âøé“.rater_employee_cd_2
										END
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_2 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_2.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_2		=	#M0070_2.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_2.belong_cd1
			AND #M0300_îﬁï]âøé“.belong_cd2				=	#M0070_2.belong_cd2
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_2.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_2	!=	0  --2020.10.01
			-- 3
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_3 =	CASE 
										WHEN ISNULL(#M0070_2.employee_cd,'') <> ''
										THEN #M0070_2.employee_cd
										ELSE #M0300_îﬁï]âøé“.rater_employee_cd_3
										END
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_2 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_2.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_3		=	#M0070_2.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_2.belong_cd1
			AND #M0300_îﬁï]âøé“.belong_cd2				=	#M0070_2.belong_cd2
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_2.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_3	!=	0  --2020.10.01
			-- 4
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_4 =	CASE 
										WHEN ISNULL(#M0070_2.employee_cd,'') <> ''
										THEN #M0070_2.employee_cd
										ELSE #M0300_îﬁï]âøé“.rater_employee_cd_4
										END
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_2 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_2.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_4		=	#M0070_2.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_2.belong_cd1
			AND #M0300_îﬁï]âøé“.belong_cd2				=	#M0070_2.belong_cd2
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_2.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_4	!=	0  --2020.10.01
		END
		--	belong_cd3
		IF EXISTS (SELECT 1 FROM #M0070_3)
		BEGIN
			-- 1
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_1 =	CASE 
										WHEN ISNULL(#M0070_3.employee_cd,'') <> ''
										THEN #M0070_3.employee_cd
										ELSE #M0300_îﬁï]âøé“.rater_employee_cd_1
										END
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_3 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_3.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_1		=	#M0070_3.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_3.belong_cd1
			AND #M0300_îﬁï]âøé“.belong_cd2				=	#M0070_3.belong_cd2
			AND #M0300_îﬁï]âøé“.belong_cd3				=	#M0070_3.belong_cd3
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_3.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_1	!=	0  --2020.10.01
			-- 2
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_2 =	CASE 
										WHEN ISNULL(#M0070_3.employee_cd,'') <> ''
										THEN #M0070_3.employee_cd
										ELSE #M0300_îﬁï]âøé“.rater_employee_cd_2
										END
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_3 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_3.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_2		=	#M0070_3.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_3.belong_cd1
			AND #M0300_îﬁï]âøé“.belong_cd2				=	#M0070_3.belong_cd2
			AND #M0300_îﬁï]âøé“.belong_cd3				=	#M0070_3.belong_cd3
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_3.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_2	!=	0  --2020.10.01
			-- 3
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_3 =	CASE 
										WHEN ISNULL(#M0070_3.employee_cd,'') <> ''
										THEN #M0070_3.employee_cd
										ELSE #M0300_îﬁï]âøé“.rater_employee_cd_3
										END
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_3 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_3.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_3		=	#M0070_3.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_3.belong_cd1
			AND #M0300_îﬁï]âøé“.belong_cd2				=	#M0070_3.belong_cd2
			AND #M0300_îﬁï]âøé“.belong_cd3				=	#M0070_3.belong_cd3
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_3.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_3	!=	0  --2020.10.01
			-- 4
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_4 =	CASE 
										WHEN ISNULL(#M0070_3.employee_cd,'') <> ''
										THEN #M0070_3.employee_cd
										ELSE #M0300_îﬁï]âøé“.rater_employee_cd_4
										END
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_3 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_3.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_4		=	#M0070_3.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_3.belong_cd1
			AND #M0300_îﬁï]âøé“.belong_cd2				=	#M0070_3.belong_cd2
			AND #M0300_îﬁï]âøé“.belong_cd3				=	#M0070_3.belong_cd3
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_3.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_4	!=	0  --2020.10.01
		END
		--	belong_cd4
		IF EXISTS (SELECT 1 FROM #M0070_4)
		BEGIN
			-- 1
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_1 =	CASE 
										WHEN ISNULL(#M0070_4.employee_cd,'') <> ''
										THEN #M0070_4.employee_cd
										ELSE #M0300_îﬁï]âøé“.rater_employee_cd_1
										END
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_4 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_4.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_1		=	#M0070_4.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_4.belong_cd1
			AND #M0300_îﬁï]âøé“.belong_cd2				=	#M0070_4.belong_cd2
			AND #M0300_îﬁï]âøé“.belong_cd3				=	#M0070_4.belong_cd3
			AND #M0300_îﬁï]âøé“.belong_cd4				=	#M0070_4.belong_cd4
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_4.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_1	!=	0  --2020.10.01
			-- 2
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_2 =	CASE 
										WHEN ISNULL(#M0070_4.employee_cd,'') <> ''
										THEN #M0070_4.employee_cd
										ELSE #M0300_îﬁï]âøé“.rater_employee_cd_2
										END
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_4 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_4.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_2		=	#M0070_4.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_4.belong_cd1
			AND #M0300_îﬁï]âøé“.belong_cd2				=	#M0070_4.belong_cd2
			AND #M0300_îﬁï]âøé“.belong_cd3				=	#M0070_4.belong_cd3
			AND #M0300_îﬁï]âøé“.belong_cd4				=	#M0070_4.belong_cd4
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_4.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_2	!=	0  --2020.10.01
			-- 3
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_3 =	CASE 
										WHEN ISNULL(#M0070_4.employee_cd,'') <> ''
										THEN #M0070_4.employee_cd
										ELSE #M0300_îﬁï]âøé“.rater_employee_cd_3
										END
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_4 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_4.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_3		=	#M0070_4.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_4.belong_cd1
			AND #M0300_îﬁï]âøé“.belong_cd2				=	#M0070_4.belong_cd2
			AND #M0300_îﬁï]âøé“.belong_cd3				=	#M0070_4.belong_cd3
			AND #M0300_îﬁï]âøé“.belong_cd4				=	#M0070_4.belong_cd4
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_4.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_3	!=	0  --2020.10.01
			-- 4
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_4 =	CASE 
										WHEN ISNULL(#M0070_4.employee_cd,'') <> ''
										THEN #M0070_4.employee_cd
										ELSE #M0300_îﬁï]âøé“.rater_employee_cd_4
										END
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_4 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_4.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_4		=	#M0070_4.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_4.belong_cd1
			AND #M0300_îﬁï]âøé“.belong_cd2				=	#M0070_4.belong_cd2
			AND #M0300_îﬁï]âøé“.belong_cd3				=	#M0070_4.belong_cd3
			AND #M0300_îﬁï]âøé“.belong_cd4				=	#M0070_4.belong_cd4
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_4.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_4	!=	0  --2020.10.01
		END
		--	belong_cd5
		IF EXISTS (SELECT 1 FROM #M0070_5)
		BEGIN
			-- 1
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_1 =	CASE 
										WHEN ISNULL(#M0070_5.employee_cd,'') <> ''
										THEN #M0070_5.employee_cd
										ELSE #M0300_îﬁï]âøé“.rater_employee_cd_1
										END
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_5 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_5.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_1		=	#M0070_5.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_5.belong_cd1
			AND #M0300_îﬁï]âøé“.belong_cd2				=	#M0070_5.belong_cd2
			AND #M0300_îﬁï]âøé“.belong_cd3				=	#M0070_5.belong_cd3
			AND #M0300_îﬁï]âøé“.belong_cd4				=	#M0070_5.belong_cd4
			AND #M0300_îﬁï]âøé“.belong_cd5				=	#M0070_5.belong_cd5
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_5.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_1	!=	0  --2020.10.01
			-- 2
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_2 =	CASE 
										WHEN ISNULL(#M0070_5.employee_cd,'') <> ''
										THEN #M0070_5.employee_cd
										ELSE #M0300_îﬁï]âøé“.rater_employee_cd_2
										END
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_5 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_5.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_2		=	#M0070_5.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_5.belong_cd1
			AND #M0300_îﬁï]âøé“.belong_cd2				=	#M0070_5.belong_cd2
			AND #M0300_îﬁï]âøé“.belong_cd3				=	#M0070_5.belong_cd3
			AND #M0300_îﬁï]âøé“.belong_cd4				=	#M0070_5.belong_cd4
			AND #M0300_îﬁï]âøé“.belong_cd5				=	#M0070_5.belong_cd5
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_5.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_2	!=	0  --2020.10.01
			-- 3
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_3 =	CASE 
										WHEN ISNULL(#M0070_5.employee_cd,'') <> ''
										THEN #M0070_5.employee_cd
										ELSE #M0300_îﬁï]âøé“.rater_employee_cd_3
										END
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_5 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_5.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_3		=	#M0070_5.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_5.belong_cd1
			AND #M0300_îﬁï]âøé“.belong_cd2				=	#M0070_5.belong_cd2
			AND #M0300_îﬁï]âøé“.belong_cd3				=	#M0070_5.belong_cd3
			AND #M0300_îﬁï]âøé“.belong_cd4				=	#M0070_5.belong_cd4
			AND #M0300_îﬁï]âøé“.belong_cd5				=	#M0070_5.belong_cd5
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_5.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_3	!=	0  --2020.10.01
			-- 4
			UPDATE #M0300_îﬁï]âøé“ SET 
				rater_employee_cd_4 =	CASE 
										WHEN ISNULL(#M0070_5.employee_cd,'') <> ''
										THEN #M0070_5.employee_cd
										ELSE #M0300_îﬁï]âøé“.rater_employee_cd_4
										END
			FROM #M0300_îﬁï]âøé“
			INNER JOIN #M0070_5 ON (
				#M0300_îﬁï]âøé“.company_cd				=	#M0070_5.company_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_4		=	#M0070_5.position_cd
			AND #M0300_îﬁï]âøé“.belong_cd1				=	#M0070_5.belong_cd1
			AND #M0300_îﬁï]âøé“.belong_cd2				=	#M0070_5.belong_cd2
			AND #M0300_îﬁï]âøé“.belong_cd3				=	#M0070_5.belong_cd3
			AND #M0300_îﬁï]âøé“.belong_cd4				=	#M0070_5.belong_cd4
			AND #M0300_îﬁï]âøé“.belong_cd5				=	#M0070_5.belong_cd5
			)
			WHERE
				#M0300_îﬁï]âøé“.employee_cd	<>	#M0070_5.employee_cd
			AND #M0300_îﬁï]âøé“.rater_position_cd_4	!=	0  --2020.10.01
		END
		------------------APPLY--------------------
		UPDATE #RESULT SET
			rater_employee_cd_1 =	#M0300_îﬁï]âøé“.rater_employee_cd_1
		,	rater_employee_cd_2 =	#M0300_îﬁï]âøé“.rater_employee_cd_2
		,	rater_employee_cd_3 =	#M0300_îﬁï]âøé“.rater_employee_cd_3
		,	rater_employee_cd_4 =	#M0300_îﬁï]âøé“.rater_employee_cd_4
		FROM #RESULT
		INNER JOIN #M0300_îﬁï]âøé“ ON (
			#RESULT.company_cd		=	#M0300_îﬁï]âøé“.company_cd
		AND	#RESULT.employee_cd		=	#M0300_îﬁï]âøé“.employee_cd
		)
		--Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å° APPLY LATEST Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°
		SELECT 
			#RESULT.row_number			
		,	#RESULT.company_cd
		,	#RESULT.fiscal_year			
		,	CASE 
				WHEN @P_group_cd <> -1
				THEN @P_group_cd
				ELSE ISNULL(#RESULT.group_cd,-1)
			END							AS	group_cd
		,	#RESULT.employee_cd			
		,	ISNULL(#RESULT.employee_nm,'')				AS employee_nm	
		,	#RESULT.employee_typ	
		,	#RESULT.job_cd	
		,	#RESULT.grade
		,	#RESULT.position_cd			
		,	#RESULT.rater_position_cd_1	
		,	#RESULT.rater_position_cd_2	
		,	#RESULT.rater_position_cd_3	
		,	#RESULT.rater_position_cd_4	
		,	ISNULL(#RESULT.rater_employee_cd_1,'')		AS rater_employee_cd_1
		,	ISNULL(#RESULT.rater_employee_cd_2,'')		AS rater_employee_cd_2
		,	ISNULL(#RESULT.rater_employee_cd_3,'')		AS rater_employee_cd_3
		,	ISNULL(#RESULT.rater_employee_cd_4,'')		AS rater_employee_cd_4 
		,	ISNULL(M0070_A.employee_nm,'')				AS rater_employee_nm_1
		,	ISNULL(M0070_B.employee_nm,'')				AS rater_employee_nm_2
		,	ISNULL(M0070_C.employee_nm,'')				AS rater_employee_nm_3
		,	ISNULL(M0070_D.employee_nm,'')				AS rater_employee_nm_4
		,	#RESULT.belong_cd1							AS belong_cd1
		,	#RESULT.belong_cd2							AS belong_cd2
		,	#RESULT.belong_cd3							AS belong_cd3
		,	#RESULT.belong_cd4							AS belong_cd4
		,	#RESULT.belong_cd5							AS belong_cd5
		,	ISNULL(#RESULT.belong_nm1,'')				AS belong_nm1
		,	ISNULL(#RESULT.belong_nm2,'')				AS belong_nm2
		,	ISNULL(#RESULT.belong_nm3,'')				AS belong_nm3
		,	ISNULL(#RESULT.belong_nm4,'')				AS belong_nm4
		,	ISNULL(#RESULT.belong_nm5,'')				AS belong_nm5
		,	ISNULL(#RESULT.employee_typ_nm,'')			AS employee_typ_nm
		,	ISNULL(#RESULT.job_nm,'')					AS job_nm
		,	ISNULL(#RESULT.position_nm,'')				AS position_nm
		,	ISNULL(#RESULT.grade_nm,'')					AS grade_nm
		,	#RESULT.treatment_applications_no			AS treatment_applications_no		
		,	#RESULT.detail_no							AS detail_no						-- add by viettd 2020/01/07
		,	#RESULT.sheet_cd1							AS sheet_cd_f0021		
		,	ISNULL(#RESULT.sheet_nm1,'')				AS sheet_nm1
		,	#RESULT.sheet_cd2							AS sheet_cd_f0032 
		,	ISNULL(#RESULT.sheet_nm2,'')				AS sheet_nm2 
		,	ISNULL(#RESULT.[row],1)						AS [row]				
		,   IIF(#RESULT.row_number = 1 ,  'tr_first' , 'tr_second' )+' '+IIF(key_number%2 = 0 ,  '' , 'tr-odd' ) AS classTr
		,   IIF(#RESULT.row_number = 1 ,  ''        , 'hidden' )		AS classCheckFirstHidden
		,   IIF(#RESULT.row_number = 1 ,  ''  , '' )					AS classCheckSecondHidden
		,	CONCAT('ckb0' , #RESULT.employee_cd	)						AS checkemployee_cd
		,	CONCAT(#RESULT.group_cd		 , #RESULT.employee_cd)			AS row_emp
		,	ISNULL(#F0200.num, '')										AS hasConfirm
		FROM #RESULT
		-- add by viettd 2021/09/08
		INNER JOIN #TABLE_PAGE ON (
			#RESULT.company_cd		=	#TABLE_PAGE.company_cd
		AND #RESULT.employee_cd		=	#TABLE_PAGE.employee_cd
		)
		LEFT JOIN M0070 AS M0070_A ON (
			#RESULT.company_cd			= M0070_A.company_cd
		AND #RESULT.rater_employee_cd_1	= M0070_A.employee_cd
		)
		LEFT JOIN M0070 AS M0070_B ON (
			#RESULT.company_cd			= M0070_B.company_cd
		AND #RESULT.rater_employee_cd_2	= M0070_B.employee_cd
		)
		LEFT JOIN M0070 AS M0070_C ON (
			#RESULT.company_cd			= M0070_C.company_cd
		AND #RESULT.rater_employee_cd_3	= M0070_C.employee_cd
		)
		LEFT JOIN M0070 AS M0070_D ON (
			#RESULT.company_cd			= M0070_D.company_cd
		AND #RESULT.rater_employee_cd_4	= M0070_D.employee_cd
		)
		LEFT JOIN #F0200 ON (
			#RESULT.company_cd					= #F0200.company_cd
		AND #RESULT.employee_cd					= #F0200.employee_cd
		AND #RESULT.treatment_applications_no	= #F0200.treatment_applications_no
		)
		ORDER BY 
			#RESULT.company_cd
		,	CASE ISNUMERIC(#RESULT.employee_cd) 
			   WHEN 1 
			   THEN CAST(#RESULT.employee_cd AS BIGINT) 
			   ELSE 999999999999999 
			END 
		,	#RESULT.employee_cd
		,	#RESULT.group_cd
	END
	ELSE
	BEGIN
	--Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å° SEARCH Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°Å°
		SELECT 
			#RESULT.row_number			
		,	#RESULT.company_cd
		,	#RESULT.fiscal_year			
		,	CASE 
				WHEN @P_group_cd <> -1
				THEN @P_group_cd
				ELSE ISNULL(#RESULT.group_cd,-1)
			END											AS	group_cd
		,	#RESULT.employee_cd			
		,	ISNULL(#RESULT.employee_nm,'')				AS	employee_nm	
		,	#RESULT.employee_typ	
		,	#RESULT.job_cd	
		,	#RESULT.grade
		,	#RESULT.position_cd			
		,	#RESULT.rater_position_cd_1	
		,	#RESULT.rater_position_cd_2	
		,	#RESULT.rater_position_cd_3	
		,	#RESULT.rater_position_cd_4	
		,	ISNULL(#RESULT.rater_employee_cd_1,'')		AS rater_employee_cd_1
		,	ISNULL(#RESULT.rater_employee_cd_2,'')		AS rater_employee_cd_2
		,	ISNULL(#RESULT.rater_employee_cd_3,'')		AS rater_employee_cd_3
		,	ISNULL(#RESULT.rater_employee_cd_4,'')		AS rater_employee_cd_4 
		,	ISNULL(M0070_A.employee_nm,'')				AS rater_employee_nm_1
		,	ISNULL(M0070_B.employee_nm,'')				AS rater_employee_nm_2
		,	ISNULL(M0070_C.employee_nm,'')				AS rater_employee_nm_3
		,	ISNULL(M0070_D.employee_nm,'')				AS rater_employee_nm_4
		,	#RESULT.belong_cd1							AS belong_cd1
		,	#RESULT.belong_cd2							AS belong_cd2
		,	#RESULT.belong_cd3							AS belong_cd3
		,	#RESULT.belong_cd4							AS belong_cd4
		,	#RESULT.belong_cd5							AS belong_cd5
		,	ISNULL(#RESULT.belong_nm1,'')				AS belong_nm1
		,	ISNULL(#RESULT.belong_nm2,'')				AS belong_nm2
		,	ISNULL(#RESULT.belong_nm3,'')				AS belong_nm3
		,	ISNULL(#RESULT.belong_nm4,'')				AS belong_nm4
		,	ISNULL(#RESULT.belong_nm5,'')				AS belong_nm5
		,	ISNULL(#RESULT.employee_typ_nm,'')			AS employee_typ_nm
		,	ISNULL(#RESULT.job_nm,'')					AS job_nm
		,	ISNULL(#RESULT.position_nm,'')				AS position_nm
		,	ISNULL(#RESULT.grade_nm,'')					AS grade_nm
		,	#RESULT.treatment_applications_no			AS treatment_applications_no
		,	#RESULT.detail_no							AS detail_no						-- add by viettd 2020/01/07
		,	#RESULT.sheet_cd1							AS sheet_cd_f0021		
		,	ISNULL(#RESULT.sheet_nm1,'')				AS sheet_nm1
		,	#RESULT.sheet_cd2							AS sheet_cd_f0032 
		,	ISNULL(#RESULT.sheet_nm2,'')				AS sheet_nm2 
		,	ISNULL(#RESULT.[row],1)						AS [row]				
		,   IIF(#RESULT.row_number = 1 ,  'tr_first' , 'tr_second' )+' '+IIF(key_number%2 = 0 ,  '' , 'tr-odd' ) AS classTr
		,   IIF(#RESULT.row_number = 1 ,  ''        , 'hidden' )		AS classCheckFirstHidden
		,   IIF(#RESULT.row_number = 1 ,  ''  , '' )					AS classCheckSecondHidden
		,	CONCAT('ckb0' , #RESULT.employee_cd	)						AS checkemployee_cd
		,	CONCAT(#RESULT.group_cd		 , #RESULT.employee_cd)			AS row_emp
		,	ISNULL(#F0200.num, '')										AS hasConfirm
		FROM #RESULT
		-- add by viettd 2021/09/08
		INNER JOIN #TABLE_PAGE ON (
			#RESULT.company_cd		=	#TABLE_PAGE.company_cd
		AND #RESULT.employee_cd		=	#TABLE_PAGE.employee_cd
		)
		LEFT JOIN M0070 AS M0070_A ON (
			#RESULT.company_cd			= M0070_A.company_cd
		AND #RESULT.rater_employee_cd_1	= M0070_A.employee_cd
		)
		LEFT JOIN M0070 AS M0070_B ON (
			#RESULT.company_cd			= M0070_B.company_cd
		AND #RESULT.rater_employee_cd_2	= M0070_B.employee_cd
		)
		LEFT JOIN M0070 AS M0070_C ON (
			#RESULT.company_cd			= M0070_C.company_cd
		AND #RESULT.rater_employee_cd_3	= M0070_C.employee_cd
		)
		LEFT JOIN M0070 AS M0070_D ON (
			#RESULT.company_cd			= M0070_D.company_cd
		AND #RESULT.rater_employee_cd_4	= M0070_D.employee_cd
		)
		LEFT JOIN #F0200 ON (
			#RESULT.company_cd					= #F0200.company_cd
		AND #RESULT.employee_cd					= #F0200.employee_cd
		AND #RESULT.treatment_applications_no	= #F0200.treatment_applications_no
		)
		ORDER BY 
			key_number
	END
	--[1]
	SET @w_status = 'OK'
	SELECT @w_status as status
	--[2]
	SELECT 
		F0021.company_cd
	,	F0021.fiscal_year
	,	F0021.group_cd
	,	F0021.sheet_cd
	,	F0021.treatment_applications_no
	FROM F0021
	WHERE 
		F0021.company_cd	= @P_company_cd
	AND F0021.fiscal_year	= @P_fiscal_year
	AND F0021.group_cd		= @P_group_cd
	ORDER BY F0021.sheet_cd
	--[3]
	SELECT 
		@Rater1					AS	Rater1
	,	@Rater2					AS	Rater2
	,	@Rater3					AS	Rater3
	,	@Rater4					AS	Rater4
	,	@organization_typ_1		AS	organization_typ_1
	,	@organization_typ_2		AS	organization_typ_2
	,	@organization_typ_3		AS	organization_typ_3
	,	@organization_typ_4		AS	organization_typ_4
	,	@organization_typ_5		AS	organization_typ_5		
	--[4]
	SELECT	
		@totalRecord	AS totalRecord
	,	@pageMax		AS pageMax
	,	@w_page			AS page
	,	@w_page_size	AS pagesize
	,	((@w_page - 1) * @w_page_size + 1) AS offset
END
GO