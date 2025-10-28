DROP PROCEDURE [SPC_I1040_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC SPC_M0130_INQ1 '';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	M0140_評語マスタ
--*  
--*  作成日/create date			:	2018/09/19					
--*　作成者/creater				:	datnt								
--*   					
--*  更新日/update date			:  
--*　更新者/updater				:　
--*　更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [SPC_I1040_FND1]
	-- Add the parameters for the stored procedure here
	@P_company_cd				SMALLINT		= 0
,	@P_fiscal_year				SMALLINT		= 0
,	@P_period_cd				SMALLINT		= 0
,	@P_language					NVARCHAR(2)		= ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATE			=	SYSDATETIME()
	,   @beginning_date		    DATE			=	NULL
	,	@period_from			DATE			=	NULL	
	,	@period_to				DATE			=	NULL
	,	@step					INT				=	0
	-- GET PERIOD_DATE
	CREATE TABLE #DEATAIL(
		category			INT
	,	name				NVARCHAR(60)
	,	status_nm			NVARCHAR(100)
	,	status_cd			INT
	,	start_date			DATE
	,	deadline_date		DATE
	,	notice_information	INT
	,	alert_information	INT	
	,	display_typ			INT
	)
	SELECT 
		@beginning_date	=	M9100.beginning_date
	FROM M9100
	WHERE	company_cd	=	@P_company_cd
	AND		del_datetime IS NULL
	SELECT 
		@period_from	=	M0101.period_from
	,	@period_to		=	M0101.period_to	
	FROM M0101
	WHERE	company_cd	=	@P_company_cd
	AND		detail_no	=	@P_period_cd
	AND		del_datetime IS NULL
	--
/*
	IF(CAST('2018-'+FORMAT(@period_from,'MM-dd') AS DATE)	>	CAST('2018-'+ FORMAT(@period_to,'MM-dd') AS DATE) AND @P_fiscal_year >0 )
	BEGIN
		SET @period_from = CAST(CONVERT(NVARCHAR(4),@P_fiscal_year)+'-'+RIGHT(@period_from,5) AS DATE)
		SET @period_to = CAST(CONVERT(NVARCHAR(4),(@P_fiscal_year+1))+'-'+RIGHT(@period_to,5) AS DATE)
	END
	ELSE IF(CAST('2018-'+FORMAT(@period_from,'MM-dd') AS DATE) < CAST('2018-'+ FORMAT(@period_to,'MM-dd') AS DATE) AND @P_fiscal_year >0)
	BEGIN
		SET @period_from = CAST(CONVERT(NVARCHAR(4),@P_fiscal_year)+'-'+RIGHT(@period_from,5) AS DATE)
		SET @period_to = CAST(CONVERT(NVARCHAR(4),@P_fiscal_year)+'-'+RIGHT(@period_to,5) AS DATE)
	END
*/
	IF(CAST('2018-'+FORMAT(@period_from,'MM-dd') AS DATE)	>	CAST('2018-'+ FORMAT(@period_to,'MM-dd') AS DATE) AND @P_fiscal_year >0 AND MONTH(@beginning_date)<=MONTH(@period_from))
	BEGIN
		SET @period_from = CAST(CONVERT(NVARCHAR(4),@P_fiscal_year)+'-'+RIGHT(@period_from,5) AS DATE)
		SET @period_to   = CAST(CONVERT(NVARCHAR(4),(@P_fiscal_year+1))+'-'+RIGHT(@period_to,5) AS DATE)
	END
		ELSE IF(CAST('2018-'+FORMAT(@period_from,'MM-dd') AS DATE)	>	CAST('2018-'+ FORMAT(@period_to,'MM-dd') AS DATE) AND @P_fiscal_year >0)
	BEGIN
		SET @period_from = CAST(CONVERT(NVARCHAR(4),@P_fiscal_year)+'-'+RIGHT(@period_from,5) AS DATE)
		SET @period_to   = CAST(CONVERT(NVARCHAR(4),(@P_fiscal_year+1))+'-'+RIGHT(@period_to,5) AS DATE)
	END
	ELSE IF(CAST('2018-'+FORMAT(@period_from,'MM-dd') AS DATE) < CAST('2018-'+ FORMAT(@period_to,'MM-dd') AS DATE) AND @P_fiscal_year >0 AND MONTH(@beginning_date)<=MONTH(@period_from))
	BEGIN
		SET @period_from = CAST(CONVERT(NVARCHAR(4),@P_fiscal_year)+'-'+RIGHT(@period_from,5) AS DATE)
		SET @period_to   = CAST(CONVERT(NVARCHAR(4),@P_fiscal_year)+'-'+RIGHT(@period_to,5) AS DATE)
	END
	ELSE IF(CAST('2018-'+FORMAT(@period_from,'MM-dd') AS DATE) < CAST('2018-'+ FORMAT(@period_to,'MM-dd') AS DATE) AND @P_fiscal_year >0)
	BEGIN
		SET @period_from = CAST(CONVERT(NVARCHAR(4),@P_fiscal_year+1)+'-'+RIGHT(@period_from,5) AS DATE)
		SET @period_to   = CAST(CONVERT(NVARCHAR(4),@P_fiscal_year+1)+'-'+RIGHT(@period_to,5) AS DATE)
	END
	ELSE
	BEGIN
		SET	@period_from = NULL
		SET	@period_to	 = NULL
	END
	--[0]
	SELECT 
		FORMAT(@period_from,'yyyy/MM/dd')+'  ~  '+FORMAT(@period_to,'yyyy/MM/dd')	AS  period_year
	,	FORMAT(@period_from,'yyyy/MM/dd')											AS  period_from
	,	FORMAT(@period_to,'yyyy/MM/dd')												AS  period_to
	--- GET DETAIL DATA
	INSERT INTO #DEATAIL
	SELECT 
		M0310.category
	
	
	,	CASE	
			WHEN @P_language = 'en' 
			THEN L0010.name_english
			ELSE L0010.name
			END AS name
	,	CASE	
			WHEN M0310.status_nm = NULL OR M0310.status_nm = ''
			THEN 
				CASE	
					WHEN @P_language = 'en' 
					THEN L0040.status_nm_english
					ELSE L0040.status_nm
					END 
			ELSE M0310.status_nm
			END AS status_nm
	,	M0310.status_cd
	,	FORMAT(F0300.start_date,'yyyy/MM/dd')											AS [start_date]
	,	FORMAT(F0300.deadline_date,'yyyy/MM/dd')										AS [deadline_date]
	,	CASE WHEN F0300.notice_information	= 1 AND F0300.notice_mail	= 0
			THEN	1
			WHEN F0300.notice_information	= 0 AND F0300.notice_mail	= 1
			THEN	2
			WHEN F0300.notice_information	= 1 AND F0300.notice_mail	= 1
			THEN	3
			WHEN F0300.notice_information	IS NULL AND F0300.notice_mail	IS NULL AND M0311.notice_information	= 1 AND M0311.notice_mail	= 0
			THEN	1
			WHEN F0300.notice_information	IS NULL AND F0300.notice_mail	IS NULL AND M0311.notice_information	= 0 AND M0311.notice_mail	= 1
			THEN	2
			WHEN F0300.notice_information	IS NULL AND F0300.notice_mail	IS NULL AND M0311.notice_information	= 1 AND M0311.notice_mail	= 1
			THEN	3
			ELSE 0
		END	AS notice_information
	,	CASE WHEN F0300.alert_information	= 1 AND F0300.alert_mail	 = 0
			THEN	1
			WHEN F0300.alert_information	= 0 AND F0300.alert_mail	 = 1
			THEN	2
			WHEN F0300.alert_information	= 1 AND F0300.alert_mail	 = 1
			THEN	3
			WHEN  F0300.alert_information IS NULL AND F0300.alert_mail IS NULL AND M0311.alert_information = 1 AND M0311.alert_mail = 0
			THEN  1
			WHEN  F0300.alert_information IS NULL AND F0300.alert_mail IS NULL AND M0311.alert_information = 0 AND M0311.alert_mail = 1
			THEN  2
			WHEN  F0300.alert_information IS NULL AND F0300.alert_mail IS NULL AND M0311.alert_information = 1 AND M0311.alert_mail = 1
			THEN  3
			ELSE 0
		END	AS alert_information
	,	1								-- NOT DISPLAY
	FROM M0310 
	LEFT JOIN F0300 ON (
		M0310.company_cd	=	F0300.company_cd
	AND	M0310.category		=	F0300.category
	AND	M0310.status_cd		=	F0300.status_cd
	AND (	@P_fiscal_year	=	F0300.fiscal_year)
	AND	(	@P_period_cd	=	F0300.period_detail_no)
	AND F0300.del_datetime	IS NULL
	)
	LEFT JOIN L0010 ON(
		M0310.category	=	L0010.number_cd
	AND	10				=	L0010.name_typ
	AND L0010.del_datetime IS NULL
	)
	LEFT JOIN L0040 ON (
		M0310.category	=	L0040.category
	AND	M0310.status_cd	=	L0040.status_cd
	AND	(L0040.category <> 3 
		 OR	(
				L0040.category = 3 AND L0040.status_cd >=2 AND L0040.status_cd <= 11 	
			)	
		)
	)
	LEFT JOIN M0311 ON (
		M0310.company_cd	=	M0311.company_cd
	AND	M0310.category		=	M0311.category
	AND	M0310.status_cd		=	M0311.status_cd
	AND M0311.del_datetime IS NULL
	)
	WHERE M0310.company_cd		=	@P_company_cd
	AND	M0310.status_use_typ	=	1
	AND M0310.status_cd > 0 -- CR2021-02-23 datnt
	AND	(M0310.category <> 3 
		 OR	(
				M0310.category = 3 AND M0310.status_cd >=2 AND M0310.status_cd <= 11 	
			)	
		)
	AND m0310.del_datetime IS NULL
	-- UPDATE STATUS 目標管理機能
	UPDATE #DEATAIL SET
		display_typ =  CASE
							WHEN M0100.target_management_typ = 0
							THEN 0
							WHEN M0100.target_self_assessment_typ = 0 AND #DEATAIL.status_cd = 3
							THEN 0
							WHEN M0100.target_evaluation_typ_1 = 0 AND #DEATAIL.status_cd = 4
							THEN 0
							WHEN M0100.target_evaluation_typ_2 = 0 AND #DEATAIL.status_cd = 5
							THEN 0
							WHEN M0100.target_evaluation_typ_3 = 0 AND #DEATAIL.status_cd = 6
							THEN 0
							WHEN M0100.target_evaluation_typ_4 = 0 AND #DEATAIL.status_cd = 7
							THEN 0
							ELSE 1
						END
	FROM #DEATAIL
	INNER JOIN M0100 ON (
		@P_company_cd		=	M0100.company_cd
	)
	WHERE
		M0100.company_cd	=	@P_company_cd
	AND	M0100.del_datetime IS NULL
	AND #DEATAIL.category = 1
	-- UPDATE STATUS 目標管理機能
	UPDATE #DEATAIL SET
		display_typ =  CASE
							WHEN M0100.evaluation_use_typ = 0
							THEN 0
							WHEN M0100.evaluation_self_assessment_typ = 0 AND #DEATAIL.status_cd = 1
							THEN 0
							WHEN M0100.evaluation_typ_1 = 0 AND #DEATAIL.status_cd = 2
							THEN 0
							WHEN M0100.evaluation_typ_2 = 0 AND #DEATAIL.status_cd = 3
							THEN 0
							WHEN M0100.evaluation_typ_3 = 0 AND #DEATAIL.status_cd = 4
							THEN 0
							WHEN M0100.evaluation_typ_4 = 0 AND #DEATAIL.status_cd = 5
							THEN 0
							ELSE 1
						END
	FROM #DEATAIL
	INNER JOIN M0100 ON (
		@P_company_cd		=	M0100.company_cd
	)
	WHERE
		M0100.company_cd	=	@P_company_cd
	AND	M0100.del_datetime IS NULL
	AND #DEATAIL.category = 2
	-- UPDATE STATUS 目標管理機能
	UPDATE #DEATAIL SET
		display_typ =  CASE
							WHEN M0100.interview_use_typ = 0
							THEN 0
							ELSE 1
						END
	FROM #DEATAIL
	INNER JOIN M0100 ON (
		@P_company_cd		=	M0100.company_cd
	)
	WHERE
		M0100.company_cd	=	@P_company_cd
	AND	M0100.del_datetime IS NULL
	AND #DEATAIL.category = 3


	--[1]
	SELECT  
		category			
	, ROW_NUMBER() over(PARTITION BY #DEATAIL.category
                         ORDER BY #DEATAIL.category asc)  	AS  category_num	
	,	 COUNT(#DEATAIL.category) over(PARTITION BY #DEATAIL.category
                         ORDER BY #DEATAIL.category asc)  	AS  category_count	
	,	name				
	,	status_nm			
	,	status_cd			
	,	FORMAT(start_date,'yyyy/MM/dd')											AS [start_date]
	,	FORMAT(deadline_date,'yyyy/MM/dd')										AS [deadline_date]	
	,	notice_information	
	,	alert_information	
	FROM #DEATAIL
	WHERE display_typ = 1
	--[2]
	SELECT 
		COUNT(distinct category)		AS category_group
	FROM M0310
	WHERE	company_cd		=	@P_company_cd
	AND		status_use_typ	=	1
	AND		del_datetime IS NULL

END
GO
