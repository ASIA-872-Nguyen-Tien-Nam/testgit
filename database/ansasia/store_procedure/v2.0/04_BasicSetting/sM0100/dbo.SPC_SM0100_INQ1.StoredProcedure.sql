DROP PROCEDURE [dbo].[SPC_SM0100_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- +--TEST--+ SM0100
--  EXEC SPC_SM0100_INQ1 '740';

--****************************************************************************************
--*   											
--*  処理概要/process overview	:	sM0100_利用設定
--*  
--*  作成日/create date			:	2020/10/08					
--*　作成者/creater				:	nghianm								
--*   					
--*  更新日/update date			:	2021/04/22
--*　更新者/updater				:	viettd
--*　更新内容/update content		:	add item 1on1_beginning_date
--* 
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_SM0100_INQ1]
	@P_company_cd	SMALLINT = 0
,	@P_language		NVARCHAR(10)	= N'jp'
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE
		@w_evaluation_use_typ			SMALLINT			=	0
	,	@w_multireview_use_typ			SMALLINT			=	0
	,	@w_1on1_use_typ					SMALLINT			=	0
	,	@w_report_use_typ				SMALLINT			=	0
	--[0]
	SELECT 
		REPLACE(RIGHT(M9100.beginning_date,5),'-','/')			AS beginning_date
	,	REPLACE(RIGHT(M9100.[1on1_beginning_date],5),'-','/')	AS beginning_date_1on1			-- add by viettd 2021/04/22
	,	REPLACE(RIGHT(M9100.[report_beginning_date],5),'-','/')	AS beginning_date_report		
	,	M9100.[1on1_beginning_date]								AS beginning_date_full_1on1		-- add by viettd 2021/04/22
	,	M9100.[report_beginning_date]							AS beginning_date_full_report
	,	M9100.beginning_date									AS beginning_date_full
	,	M9100.password_length									AS password_length
	,	M9100.password_character_limit							AS password_character_limit
	,	M9100.password_age										AS password_age
	,	M9100.mypurpose_use_typ									AS mypurpose_use_typ
	,	M9100.empinf_use_typ									AS empinf_user_typ
	,	M9101.empcom_use_typ									AS empcom_user_typ
	,	M9101.cert_use_typ										AS cert_user_typ
	,	M9101.resume_use_typ									AS resume_user_typ
	,	M9101.empsrch_use_typ									AS empsrch_user_typ
	,	ISNULL(M9100.multilingual_option_use_typ,0)				AS multilingual_option_use_typ
	FROM M9100 WITH(NOLOCK) 
	LEFT OUTER JOIN M9101 WITH(NOLOCK)  ON (
		M9100.company_cd		=	M9101.company_cd
	AND M9101.del_datetime IS NULL
	)
	WHERE 
		M9100.company_cd = @P_company_cd
	AND M9100.del_datetime IS NULL
	--[1]
	SELECT 
		@w_evaluation_use_typ		=	ISNULL(M0001.evaluation_use_typ,0)	
	,	@w_multireview_use_typ		=	ISNULL(M0001.multireview_use_typ,0)	
	,	@w_1on1_use_typ				=	ISNULL(M0001.[1on1_use_typ],0)		
	,	@w_report_use_typ			=	ISNULL(M0001.[report_use_typ],0)		
	FROM M0001 WITH(NOLOCK) 
	WHERE 
		M0001.company_cd	=	@P_company_cd
	AND M0001.del_datetime IS NULL
	-- add by viettd 2021/04/22
	SELECT 
		CASE 
			WHEN @w_evaluation_use_typ = 1 OR @w_multireview_use_typ = 1
			THEN 1	-- enabled
			ELSE 0	-- disabled
		END											AS	item_start_evaluation
	,	CASE 
			WHEN @w_1on1_use_typ = 1
			THEN 1	-- enabled
			ELSE 0	-- disabled
		END											AS	item_start_1on1
		,	CASE 
			WHEN @w_report_use_typ = 1
			THEN 1	-- enabled
			ELSE 0	-- disabled
		END											AS	item_start_report
	SELECT 
		L0034.tab_id	
	,	L0034.tab_nm
	,	M9102.use_typ
	FROM L0034 WITH(NOLOCK) 
	INNER JOIN M9102 WITH(NOLOCK)  ON(
		M9102.company_cd = @P_company_cd
	AND	L0034.tab_id = M9102.tab_id
	)
	WHERE
		L0034.refer_user_typ = 1
	-- add by QUANGND 
	SELECT 
		detail_no
	,	M9103.language_cd
	--,	language_name
	--,	language_name_en
	,	CASE 
			WHEN @P_language = N'jp' THEN language_name
			ELSE language_name_en
		END AS language_name
	FROM M9103
	LEFT JOIN L0014 ON (
		M9103.language_cd = L0014.language_cd
	AND L0014.del_datetime IS NULL
	)
	WHERE
		M9103.company_cd = @P_company_cd
	AND M9103.del_datetime IS NULL
	ORDER BY
		detail_no
	--
	SELECT 
		language_cd
	--,	language_name
	--,	language_name_en
	,	CASE 
			WHEN @P_language = N'jp' THEN IIF(language_name = '',language_name_en,language_name)
			ELSE language_name_en
		END AS language_name
	FROM L0014
	WHERE
		del_datetime IS NULL
	ORDER BY 
		ISNULL(arrange_order, 9999)
	,	language_cd
END
