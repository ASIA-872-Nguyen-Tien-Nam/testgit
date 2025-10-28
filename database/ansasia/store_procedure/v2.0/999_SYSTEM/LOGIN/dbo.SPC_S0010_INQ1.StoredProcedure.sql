DROP PROCEDURE [SPC_S0010_INQ1]
GO
SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ S0010
-- EXEC SPC_S0010_INQ1 '{"contract_cd":"MC","user_id":"mcadmin","password":"mirai","sso_id":"mcadmin"}';
-- select * from m0070
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	LOGIN (SSO対応版)
--*  
--*  作成日/create date			:	2018/09/03						
--*　作成者/creater				:	tannq								
--*   					 
--*  更新日/update date			:	2018/11/12	
--*　更新者/updater				:　	longvv-longvv@ans-asia.com
--*　更新内容/update content		:	Update CR 2018/11/12	
--*   					
--*  更新日/update date			:	2019/05/27	
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	update ver 1.5
--*   					
--*  更新日/update date			:	2019/08/12	
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	SSO
--*   					
--*  更新日/update date			:	2020/09/07	
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	UPDATE ver1.7 + 1on1
--*   					
--*  更新日/update date			:	2021/06/16	
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	Mulitireview : add check user is rater_1
--*   					
--*  更新日/update date			:	2022/08/09	
--*　更新者/updater				:　	vietdt
--*　更新内容/update content		:	UPDATE ver1.9 language 
--*   					
--*  更新日/update date			:	2023/03/30	
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	UPDATE ver2.0 
--****************************************************************************************
CREATE PROCEDURE [SPC_S0010_INQ1]
	-- Add the parameters for the stored procedure here
	@P_json										NVARCHAR(max)	=	''
,	@P_cre_ip			NVARCHAR(100)	=	''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time							DATE				=	SYSDATETIME()
	,	@now							DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL						ERRTABLE
	,	@order_by_min					INT					=	0
	,	@user_id						NVARCHAR(100)		=	JSON_VALUE(@P_json,'$.user_id')
	,	@P_sso_id						NVARCHAR(255)		=	JSON_VALUE(@P_json,'$.sso_id')		
	,	@password						NVARCHAR(40)		=	JSON_VALUE(@P_json,'$.password')
	,	@P_contract_cd					NVARCHAR(20)		=	JSON_VALUE(@P_json,'$.contract_cd')		
	,	@pass_remain					INT					=	0	
	,	@change_pass_status				INT					=	0	
	,	@company_cd						INT					=	0
	,	@w_1on1_authority_typ			SMALLINT			=	0		-- １on１機能権限タイプ
	,	@w_multireview_authority_typ	SMALLINT			=	0		-- マルチレビュー機能権限タイプ
	,	@w_setting_authority_typ		SMALLINT			=	0		-- 共通設定機能権限タイプ
	,	@w_authority_typ				SMALLINT			=	0		-- 人事評価システム
	,	@w_report_authority_typ			SMALLINT			=	0		-- 週報設定機能権限タイプ
	,	@w_empinfo_authority_typ		SMALLINT			=	0		

	,	@w_contract_company_attribute	SMALLINT			=	0		-- 1. MIRAC 2.NORMAL COMPANY
	,	@w_evaluation_use_typ			SMALLINT			=	0
	,	@w_1on1_use_typ					SMALLINT			=	0
	,	@w_multireview_use_typ			SMALLINT			=	0
	,	@w_report_use_typ				SMALLINT			=	0
	,	@w_empinf_use_typ				TINYINT				=	0
	,	@w_empsrch_use_typ				TINYINT				=	0
	,	@w_empcom_use_typ				TINYINT				=	0
	--
	,	@is_trial_service				INT					=	0
	,	@is_real_service				INT					=	0
	,	@failed_login_count				TINYINT				=	0	-- add by viettd 2019/06/04		
	,	@w_user_is_rater_1				TINYINT				=	0	-- 0.IS NOT RATER_1 | 1.IS RATER_1 -- add by viettd 2021/06/16
	,	@w_employee_cd					NVARCHAR(10)		=	''	-- add by viettd 2021/06/16
	,	@w_fiscal_year_current			SMALLINT			=	0
	IF EXISTS (SELECT 1 FROM  M0001 WHERE 
										contract_cd COLLATE Latin1_General_CS_AS	=	@P_contract_cd 
									AND (	evaluation_contract_attribute	= 1 
										 OR [1on1_contract_attribute]		= 1 
										 OR multireview_contract_attribute	= 1
										 OR report_contract_attribute		= 1
										 )
									AND del_datetime IS NULL)
	BEGIN
		SET @is_trial_service  = 1 
	END
	IF EXISTS (SELECT 1 FROM  M0001 WHERE 
										contract_cd COLLATE Latin1_General_CS_AS	=	@P_contract_cd 
									AND (	evaluation_contract_attribute	= 2 
										 OR [1on1_contract_attribute]		= 2 
										 OR multireview_contract_attribute	= 2
										 OR report_contract_attribute		= 2
										 )
									AND del_datetime IS NULL)
	BEGIN
		SET @is_real_service  = 1 
	END
	IF(@P_sso_id <> '' OR (@user_id = '' AND @password = ''))
	BEGIN
		-- GET PASS AND USER_ID
		SELECT 
			@user_id	=	S0010.user_id
		,	@password	= 	S0010.password
		FROM S0010 
		INNER JOIN (
			SELECT TOP 1 
				company_cd
			FROM M0001 
			WHERE M0001.contract_cd COLLATE Latin1_General_CS_AS	=	@P_contract_cd
			AND M0001.del_datetime IS NULL
		)	AS #M0001 ON(
			S0010.company_cd = #M0001.company_cd
		)
		LEFT JOIN M0070 ON (
			M0070.company_cd	=	S0010.company_cd
		AND (M0070.employee_cd	=	S0010.employee_cd OR '0' = S0010.employee_cd)
		AND M0070.del_datetime  IS NULL
		)
		WHERE 
			S0010.sso_user = @P_sso_id
		AND M0070.del_datetime IS NULL
	END
	-- GET USER INFORMATION
	SELECT 
		@company_cd						= ISNULL(M0001.company_cd,0) 
	,	@w_contract_company_attribute	= ISNULL(M0001.contract_company_attribute,0)
	,	@w_evaluation_use_typ			= ISNULL(M0001.evaluation_use_typ,0)
	,	@w_1on1_use_typ					= ISNULL(M0001.[1on1_use_typ],0)
	,	@w_multireview_use_typ			= ISNULL(M0001.multireview_use_typ,0)
	,	@w_report_use_typ				= ISNULL(M0001.report_use_typ,0)
	FROM M0001 
	WHERE 
		contract_cd = @P_contract_cd 
	AND del_datetime IS NULL
	-- GET @w_empinf_use_typ
	SELECT 
		@w_empinf_use_typ = ISNULL(M9100.empinf_use_typ,0)
	FROM M9100
	WHERE 
		M9100.company_cd	=	@company_cd
	AND M9100.del_datetime	IS NULL
	-- GET empsrch_use_typ + empcom_use_typ
	SELECT 
		@w_empsrch_use_typ = ISNULL(M9101.empsrch_use_typ,0)
	,	@w_empcom_use_typ = ISNULL(M9101.empcom_use_typ,0)
	FROM M9101
	WHERE 
		M9101.company_cd	=	@company_cd
	AND M9101.del_datetime	IS NULL
	--SET @w_setting_authority_typ ,@w_1on1_authority_typ , @w_multireview_authority_typ , @w_report_authority_typ
	SELECT 
		@w_setting_authority_typ		=	ISNULL(S0010.setting_authority_typ,0)
	,	@w_1on1_authority_typ			=	ISNULL(S0010.[1on1_authority_typ],0)
	,	@w_multireview_authority_typ	=	ISNULL(S0010.multireview_authority_typ,0)
	,	@w_authority_typ				=	ISNULL(S0010.authority_typ,0)
	,	@w_report_authority_typ			=	ISNULL(S0010.report_authority_typ,0)
	,	@w_empinfo_authority_typ		=	ISNULL(S0010.empinfo_authority_typ,1)
	,	@w_employee_cd					=	ISNULL(S0010.employee_cd,'')
	FROM S0010 
	WHERE 
		S0010.company_cd = @company_cd 
	AND S0010.[user_id] COLLATE Latin1_General_CS_AS = @user_id 
	AND S0010.del_datetime IS NULL 
	SET @w_fiscal_year_current							=	dbo.FNC_GET_YEAR_WEEKLY_REPORT(@company_cd,NULL)
	-- ↓↓↓　add by viettd 2021/06/16
	IF EXISTS (SELECT 1 FROM F0030 WHERE company_cd = @company_cd AND rater_employee_cd_1 = @w_employee_cd AND del_datetime IS NULL)
	BEGIN
		SET @w_user_is_rater_1 = 1 -- USER IS RATER_1
	END
	IF @w_empinfo_authority_typ <= 0
	BEGIN
		SET @w_empinfo_authority_typ = 1 -- USER IS RATER_1
	END
	-- ↑↑↑　end add by viettd 2021/06/16
	--			
	CREATE TABLE #SESSION_TBL (
		id								INT				IDENTITY(1,1) NOT NULL
	,	company_cd						SMALLINT
	,	company_nm						NVARCHAR(50)
	,	[user_id]						NVARCHAR(50)
	,	employee_cd						NVARCHAR(20)
	,	[password]						NVARCHAR(40)
	
	,	authority_typ					SMALLINT
	,	authority_cd					SMALLINT
	,	[1on1_authority_typ]			SMALLINT
	,	[1on1_authority_cd]				SMALLINT
	,	multireview_authority_typ		SMALLINT
	,	multireview_authority_cd		SMALLINT
	,	setting_authority_typ			SMALLINT
	,	setting_authority_cd			SMALLINT
	,	report_authority_typ			SMALLINT			-- add by viettd 2023/03/30
	,	report_authority_cd				SMALLINT			-- add by viettd 2023/03/30
	,	empinfo_authority_typ			SMALLINT			-- add by viettd 2024/03/15
	,	empinfo_authority_cd			SMALLINT			-- add by viettd 2024/03/15
	,	remember_token					NVARCHAR(120)
	,	failed_login_count				TINYINT
	,	pass_change_datetime			DATETIME
	,	last_login_ip					NVARCHAR(100)
	,	last_login_datetime				DATETIME
	,	cre_user						NVARCHAR(50)
	,	cre_ip							NVARCHAR(100)
	,	cre_prg							NVARCHAR(20)
	,	cre_datetime					DATETIME
	,	upd_user						NVARCHAR(50)
	,	upd_ip							NVARCHAR(100)
	,	upd_prg							NVARCHAR(20)
	,	upd_datetime					DATETIME
	,	del_user						NVARCHAR(50)
	,	del_ip							NVARCHAR(100)
	,	del_prg							NVARCHAR(20)
	,	del_datetime					DATETIME
	--
	,	authority_nm					NVARCHAR(50)
	,	[1on1_authority_nm]				NVARCHAR(50)
	,	multireview_authority_nm		NVARCHAR(50)
	,	setting_authority_nm			NVARCHAR(50)		-- add by viettd 2023/03/30
	,	report_authority_nm				NVARCHAR(50)		-- add by viettd 2023/03/30

	--
	,	authority_typ_nm				NVARCHAR(30)
	,	[1on1_authority_typ_nm]			NVARCHAR(30)
	,	multireview_authority_typ_nm	NVARCHAR(30)
	,	setting_authority_typ_nm		NVARCHAR(30)		-- add by viettd 2023/03/30
	,	report_authority_typ_nm			NVARCHAR(30)		-- add by viettd 2023/03/30

	--
	,	password_age					TINYINT
	,	evaluation_use_typ				SMALLINT
	,	evaluation_use_start_dt			DATE
	,	evaluation_user_end_dt			DATE
	,	[1on1_use_typ]					SMALLINT
	,	[1on1_use_start_dt]				DATE
	,	[1on1_user_end_dt]				DATE
	,	multireview_use_typ				SMALLINT
	,	multireview_use_start_dt		DATE
	,	multireview_user_end_dt			DATE
	,	report_use_typ					SMALLINT			-- add by viettd 2023/03/30
	,	report_use_start_dt				DATE				-- add by viettd 2023/03/30
	,	report_user_end_dt				DATE				-- add by viettd 2023/03/30
	,	empinf_use_typ					SMALLINT			-- add by viettd 2024/03/15
	,	empsrch_use_typ					SMALLINT			-- add by viettd 2024/03/15
	,	empcom_use_typ					SMALLINT			-- add by viettd 2024/03/15
	--
	,	contract_company_attribute		SMALLINT
	,	user_is_rater_1					TINYINT				-- add by viettd 2021/06/16
	,	[language]						NVARCHAR(10)		-- add by vietdt 2022/08/09
	) 
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--validate login
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- IF USER IS MIRAC
	IF @w_contract_company_attribute = 1 -- 1.MIRAC
	BEGIN
		-- MESSGAE 30
		IF NOT EXISTS (
			SELECT 1
			FROM S0010
			WHERE
				S0010.company_cd								=	@company_cd
			AND	S0010.user_id COLLATE Latin1_General_CS_AS		=	@user_id
			AND S0010.del_datetime	IS NULL
		)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(		
				30									-- ma l?i (trung v?i ma trong b?ng message) 					
			,	''									-- id ho?c class c?a item(#id , .class), l?i d?ng dialog thi ?? tr?ng  				
			,	1-- oderby							-- gia tr? cang be thi l?i ???c hi?n th? tr??c  				
			,	1-- dialog  						-- Ki?u hi?n th? l?i : 0. tooltip , 1.dialog 				
			,	0									-- Tuy y : co th? l?u v? tri index c?a dong c?a l?i 				
			,	0									-- Tuy y
			,	'IDとパスワードを確認してください。'	-- Comment n?i dung l?i (ch? y?u la dung khi ??c code)
			)
		END
	END
	ELSE -- 2.NORMAL COMPANY_CD
	BEGIN
		--1.メッセージ30
		IF NOT EXISTS (
		SELECT
			1
		FROM S0010
		LEFT JOIN M0070 ON (
			M0070.company_cd	=	S0010.company_cd
		AND M0070.employee_cd	=	S0010.employee_cd
		AND M0070.del_datetime  IS NULL
		AND (M0070.company_out_dt IS NULL OR (M0070.company_out_dt >= @w_time AND M0070.company_out_dt IS NOT NULL))
		AND (
				(M0070.company_out_dt > M0070.company_in_dt AND M0070.company_out_dt IS NOT NULL AND M0070.company_in_dt IS NOT NULL)
			OR  (M0070.company_out_dt IS NULL)
			)
		)
		INNER JOIN M0001 ON (
			M0001.company_cd	=	S0010.company_cd
		AND M0001.del_datetime IS NULL 
		)
		WHERE
			M0001.contract_cd COLLATE Latin1_General_CS_AS	=	@P_contract_cd
		AND S0010.user_id COLLATE Latin1_General_CS_AS		=	@user_id
		AND S0010.password COLLATE Latin1_General_CS_AS		=	@password
		AND S0010.del_datetime	IS NULL
		AND (  (M0001.[1on1_use_typ] = 1 
				AND (
					S0010.[1on1_authority_typ]		IN	(4,5) OR
					(S0010.[1on1_authority_typ]	NOT IN (4,5) AND M0070.employee_cd IS NOT NULL )
					)
				)
			OR (M0001.evaluation_use_typ = 1 
				AND (
					S0010.authority_typ		IN	(4,5) OR
					(S0010.authority_typ	NOT IN (4,5) AND M0070.employee_cd IS NOT NULL )
					)
				)
			OR (M0001.multireview_use_typ = 1 
				AND (
					S0010.multireview_authority_typ		IN	(4,5) OR
					(S0010.multireview_authority_typ	NOT IN (4,5) AND M0070.employee_cd IS NOT NULL )
					)
				)
			OR ( 
					S0010.setting_authority_typ		IN	(4,5) OR
					(S0010.setting_authority_typ	NOT IN (4,5) AND M0070.employee_cd IS NOT NULL )
				)
			OR ( 
					S0010.report_authority_typ		IN	(4,5) OR
					(S0010.report_authority_typ	NOT IN (4,5) AND M0070.employee_cd IS NOT NULL )
				)
			
		)
		AND ISNULL(M0001.contract_company_attribute,0)	IN (2,3) -- みらいコンサルティング以外 --edit vietdt 2022/07/06
		)
		OR
		EXISTS(
			SELECT 1
			FROM S0010
			INNER JOIN M0001 ON (
				M0001.company_cd	=	S0010.company_cd
			AND M0001.del_datetime IS NULL 
			)	
			LEFT OUTER JOIN M9100 WITH(NOLOCK) ON (
				S0010.company_cd	=	M9100.company_cd
			AND	M9100.del_datetime	IS NULL
			)
			WHERE 
				M0001.contract_cd COLLATE Latin1_General_CS_AS	=	@P_contract_cd
			AND S0010.user_id COLLATE Latin1_General_CS_AS		=	@user_id
			AND S0010.password COLLATE Latin1_General_CS_AS		=	@password
			AND S0010.del_datetime	IS NULL
			AND ISNULL(M9100.password_age,0)	<>	0
			AND (
				@w_time > CAST (DATEADD (MONTH,ISNULL(M9100.password_age,0),S0010.pass_change_datetime)  	AS DATE )	
			)
		)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(		
				30									-- ma l?i (trung v?i ma trong b?ng message) 					
			,	''									-- id ho?c class c?a item(#id , .class), l?i d?ng dialog thi ?? tr?ng  				
			,	1-- oderby							-- gia tr? cang be thi l?i ???c hi?n th? tr??c  				
			,	1-- dialog  						-- Ki?u hi?n th? l?i : 0. tooltip , 1.dialog 				
			,	0									-- Tuy y : co th? l?u v? tri index c?a dong c?a l?i 				
			,	0									-- Tuy y
			,	'IDとパスワードを確認してください。'	-- Comment n?i dung l?i (ch? y?u la dung khi ??c code)
			)
		END
		-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		-- 1.トライアル (Message 36)
		-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		IF EXISTS (
			SELECT
				1
			FROM S0010
			INNER JOIN M0001 ON (
				M0001.company_cd	=	S0010.company_cd
			AND M0001.del_datetime IS NULL 
			)	
			WHERE
				M0001.contract_cd COLLATE Latin1_General_CS_AS	=	@P_contract_cd
			--check han su dung trial multireview module 
			AND((	M0001.multireview_contract_attribute		=	1
				AND	ISNULL(M0001.multireview_user_end_dt,@w_time)				<	@w_time)
				OR M0001.multireview_contract_attribute			<>  1
			)
			---check han su dung trial 1on1 module 
			AND((	M0001.[1on1_contract_attribute]				=	1
				AND	ISNULL(M0001.[1on1_user_end_dt],@w_time)					<	@w_time)
				OR M0001.[1on1_contract_attribute]				<>  1
			)
			--check han su dung trial evaluation module
			AND((	M0001.evaluation_contract_attribute			=	1
				AND	ISNULL(M0001.evaluation_user_end_dt,@w_time)				<	@w_time)
				OR M0001.evaluation_contract_attribute			<>  1
			)
			--check han su dung trial weeklyreport module
			AND((	M0001.report_contract_attribute			=	1
				AND	ISNULL(M0001.report_user_end_dt,@w_time)				<	@w_time)
				OR M0001.report_contract_attribute			<>  1
			)
			AND S0010.user_id COLLATE Latin1_General_CS_AS		=	@user_id
			AND S0010.password COLLATE Latin1_General_CS_AS		=	@password
			AND S0010.del_datetime	IS NULL
		)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(		
				36									-- ma l?i (trung v?i ma trong b?ng message) 					
			,	''									-- id ho?c class c?a item(#id , .class), l?i d?ng dialog thi ?? tr?ng  				
			,	1-- oderby							-- gia tr? cang be thi l?i ???c hi?n th? tr??c  				
			,	1-- dialog  						-- Ki?u hi?n th? l?i : 0. tooltip , 1.dialog 				
			,	0									-- Tuy y : co th? l?u v? tri index c?a dong c?a l?i 				
			,	0									-- Tuy y
			,	'trial out of date'		-- Comment n?i dung l?i (ch? y?u la dung khi ??c code)
			)
		END
		-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		-- 2.本契約 (Message 78)
		-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		-- evaluation_contract_attribute = 1
		IF EXISTS (
		SELECT
			1
		FROM S0010
		INNER JOIN M0001 ON (
			M0001.company_cd	=	S0010.company_cd
		AND M0001.del_datetime IS NULL 
		)	
		WHERE
			M0001.contract_cd COLLATE Latin1_General_CS_AS	=	@P_contract_cd
		-- check han su dung evaluation module
		AND	(
			(	M0001.evaluation_contract_attribute			=	2
			AND	M0001.evaluation_user_end_dt				<	@w_time
			AND M0001.evaluation_user_end_dt IS NOT NULL
			)
			OR	(M0001.evaluation_use_start_dt				>	@w_time
				AND M0001.evaluation_user_end_dt IS NOT NULL)
			OR M0001.evaluation_contract_attribute			<>	2
			OR evaluation_use_typ = 0
		)
		-- check han su dung multireview module
		AND	(
			(	M0001.multireview_contract_attribute		=	2
			AND	M0001.multireview_user_end_dt				<	@w_time
			AND M0001.multireview_user_end_dt IS NOT NULL
			)
			OR	(M0001.multireview_use_start_dt				>	@w_time
				AND M0001.multireview_user_end_dt IS NOT NULL)
			OR M0001.multireview_contract_attribute			<>	2
			OR multireview_use_typ = 0
		)
		-- check han su dung one on one module
		AND	(
			(	M0001.[1on1_contract_attribute]				=	2
			AND	M0001.[1on1_user_end_dt]					<	@w_time
			AND M0001.[1on1_user_end_dt] IS NOT NULL
			)
			OR	(M0001.[1on1_use_start_dt]					>	@w_time
				AND M0001.[1on1_user_end_dt] IS NOT NULL)
			OR M0001.[1on1_contract_attribute]				<>	2
			OR [1on1_use_typ] = 0
		)
		-- check han su dung weeklyreport module
		AND	(
			(	M0001.report_contract_attribute				=	2
			AND	M0001.report_user_end_dt					<	@w_time
			AND M0001.report_user_end_dt IS NOT NULL
			)
			OR	(M0001.report_use_start_dt					>	@w_time
				AND M0001.report_user_end_dt IS NOT NULL)
			OR M0001.report_contract_attribute				<>	2
			OR report_use_typ = 0
		)
		AND S0010.user_id COLLATE Latin1_General_CS_AS		=	@user_id
		AND S0010.password COLLATE Latin1_General_CS_AS		=	@password
		AND S0010.del_datetime	IS NULL
		)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(		
				78									-- ma l?i (trung v?i ma trong b?ng message) 					
			,	''									-- id ho?c class c?a item(#id , .class), l?i d?ng dialog thi ?? tr?ng  				
			,	1-- oderby							-- gia tr? cang be thi l?i ???c hi?n th? tr??c  				
			,	1-- dialog  						-- Ki?u hi?n th? l?i : 0. tooltip , 1.dialog 				
			,	0									-- Tuy y : co th? l?u v? tri index c?a dong c?a l?i 				
			,	0									-- Tuy y
			,	'service out of date'				-- Comment n?i dung l?i (ch? y?u la dung khi ??c code)
			)
		END
		-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		-- remove error 36 and 78 if 1 on 2 in use and not out of date
		-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		IF	(NOT EXISTS(SELECT 1 FROM @ERR_TBL WHERE message_no = 36 ) AND @is_trial_service = 1) 
		OR  (NOT EXISTS(SELECT 1 FROM @ERR_TBL WHERE message_no = 78 ) AND @is_real_service = 1) 
		BEGIN
			DELETE @ERR_TBL WHERE message_no IN (36,78)
		END
		-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		-- 2.本契約 (Message 78)
		-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		IF EXISTS (
		SELECT
			1
		FROM S0010
		INNER JOIN M0001 ON (
			M0001.company_cd	=	S0010.company_cd
		AND M0001.del_datetime IS NULL 
		)	
		WHERE
			M0001.contract_cd COLLATE Latin1_General_CS_AS	=	@P_contract_cd
		AND ( (evaluation_use_typ		= 1 AND authority_typ  =  0 )
			OR evaluation_use_typ = 0
			)
		AND	( ([1on1_use_typ]			= 1 AND [1on1_authority_typ] =  0)
			OR [1on1_use_typ] = 0
			)
		AND	( (multireview_use_typ		= 1 AND multireview_authority_typ =  0)
			OR multireview_use_typ = 0
			)
		AND	( 
			report_use_typ = 0
			)
		AND S0010.setting_authority_typ < 3
		AND S0010.user_id COLLATE Latin1_General_CS_AS		=	@user_id
		AND S0010.password COLLATE Latin1_General_CS_AS		=	@password
		AND S0010.del_datetime	IS NULL
		)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(		
				78									-- ma l?i (trung v?i ma trong b?ng message) 					
			,	''									-- id ho?c class c?a item(#id , .class), l?i d?ng dialog thi ?? tr?ng  				
			,	1-- oderby							-- gia tr? cang be thi l?i ???c hi?n th? tr??c  				
			,	1-- dialog  						-- Ki?u hi?n th? l?i : 0. tooltip , 1.dialog 				
			,	0									-- Tuy y : co th? l?u v? tri index c?a dong c?a l?i 				
			,	0									-- Tuy y
			,	'not authorized'				-- Comment n?i dung l?i (ch? y?u la dung khi ??c code)
			)
		END

		-- CHECK M0070.company_in_dt > TODAY
		IF (
			(@w_evaluation_use_typ = 1 AND @w_authority_typ NOT IN (4,5))
		OR	(@w_1on1_use_typ = 1 AND @w_1on1_authority_typ NOT IN (4,5))
		OR	(@w_multireview_use_typ = 1 AND @w_multireview_authority_typ NOT IN (4,5))
		OR	(@w_report_use_typ = 1 AND @w_report_use_typ NOT IN (4,5))
		OR	(@w_setting_authority_typ NOT IN(4,5))
		)
		BEGIN
			IF EXISTS (
			SELECT
				1
			FROM S0010
			LEFT JOIN M0070 ON (
				M0070.company_cd	=	S0010.company_cd
			AND M0070.employee_cd	=	S0010.employee_cd
			AND M0070.del_datetime  IS NULL
			)
			WHERE
				S0010.company_cd								=	@company_cd	
			AND	S0010.user_id COLLATE Latin1_General_CS_AS		=	@user_id
			AND S0010.password COLLATE Latin1_General_CS_AS		=	@password
			AND	M0070.company_in_dt			IS	NOT	NULL
			AND	M0070.company_in_dt			>	@w_time	
			AND S0010.del_datetime	IS NULL
			)
			BEGIN
				INSERT INTO @ERR_TBL VALUES(		
					78									-- ma l?i (trung v?i ma trong b?ng message) 					
				,	''									-- id ho?c class c?a item(#id , .class), l?i d?ng dialog thi ?? tr?ng  				
				,	1-- oderby							-- gia tr? cang be thi l?i ???c hi?n th? tr??c  				
				,	1-- dialog  						-- Ki?u hi?n th? l?i : 0. tooltip , 1.dialog 				
				,	0									-- Tuy y : co th? l?u v? tri index c?a dong c?a l?i 				
				,	0									-- Tuy y
				,	'M0070.company_in_dt > today'		-- Comment n?i dung l?i (ch? y?u la dung khi ??c code)
				)
			END
		END
	END
	-- START TRANSACTION 
	BEGIN TRANSACTION
	BEGIN TRY
		-- ログイン成功
		IF NOT EXISTS (SELECT message_no FROM @ERR_TBL)
		BEGIN
			-- UPDATE LASTEST LOGIN USER 
			UPDATE S0010 SET 
				last_login_ip		=	@P_cre_ip
			,	last_login_datetime	=	@now
			--,	failed_login_count	=	0
			FROM S0010 INNER JOIN M0001 ON (
				M0001.company_cd	=	S0010.company_cd
			AND M0001.del_datetime IS NULL 
			)	
			WHERE
				S0010.user_id		=	@user_id
			AND S0010.password		=	@password
			AND S0010.del_datetime	IS NULL
			AND M0001.contract_cd COLLATE Latin1_General_CS_AS	=	@P_contract_cd	
			-- GET DATA FOR SESSION
			INSERT INTO #SESSION_TBL 
			SELECT 
				S0010.company_cd
			,	M0001.company_nm
			,	S0010.user_id
			,	S0010.employee_cd
			,	S0010.password
			,	ISNULL(S0010.authority_typ,3)				AS	authority_typ
			,	S0010.authority_cd							AS  authority_cd
			,	ISNULL(S0010.[1on1_authority_typ],3)		AS	[1on1_authority_typ]
			,	S0010.[1on1_authority_cd]					AS	[1on1_authority_cd]
			,	ISNULL(S0010.multireview_authority_typ,3)	AS	multireview_authority_typ
			,	S0010.multireview_authority_cd				AS	multireview_authority_cd
			,	ISNULL(S0010.setting_authority_typ,3)		AS	setting_authority_typ
			,	S0010.setting_authority_cd					AS	setting_authority_cd
			,	ISNULL(S0010.report_authority_typ,3)		AS	report_authority_typ
			,	S0010.report_authority_cd					AS	report_authority_cd
			,	ISNULL(S0010.empinfo_authority_typ,0)		AS	empinfo_authority_typ
			,	S0010.empinfo_authority_cd					AS	empinfo_authority_cd
			,	S0010.remember_token
			,	S0010.failed_login_count
			,	S0010.pass_change_datetime
			,	S0010.last_login_ip
			,	S0010.last_login_datetime
			,	S0010.cre_user
			,	S0010.cre_ip
			,	S0010.cre_prg
			,	S0010.cre_datetime
			,	S0010.upd_user
			,	S0010.upd_ip
			,	S0010.upd_prg
			,	S0010.upd_datetime
			,	S0010.del_user
			,	S0010.del_ip
			,	S0010.del_prg
			,	S0010.del_datetime
			,	#S0020_EVAL.authority_nm		AS authority_nm
			,	#S0020_1ON1.authority_nm		AS [1on1_authority_nm]
			,	#S0020_MTP.authority_nm			AS multireview_authority_nm
			,	#S0020_SET.authority_nm			AS setting_authority_nm
			,	#S0020_RPT.authority_nm			AS report_authority_nm
			,	#L0010_EVAL.name				AS authority_typ_nm
			,	#L0010_1ON1.name				AS [1on1_authority_typ_nm]
			,	#L0010_MTP.name					AS multireview_authority_typ_nm
			,	#L0010_SET.name					AS setting_authority_typ_nm
			,	#L0010_RPT.name					AS report_authority_typ_nm
			,	ISNULL(M9100.password_age,0)	AS password_age
			,	M0001.evaluation_use_typ
			,	M0001.evaluation_use_start_dt
			,	M0001.evaluation_user_end_dt
			,	M0001.[1on1_use_typ]
			,	M0001.[1on1_use_start_dt]
			,	M0001.[1on1_user_end_dt]
			,	M0001.multireview_use_typ
			,	M0001.multireview_use_start_dt
			,	M0001.multireview_user_end_dt
			,	M0001.report_use_typ
			,	M0001.report_use_start_dt
			,	M0001.report_user_end_dt
			,	@w_empinf_use_typ
			,	@w_empsrch_use_typ
			,	@w_empcom_use_typ
			,	ISNULL(M0001.contract_company_attribute,0)
			,	@w_user_is_rater_1	-- add by viettd 2021/06/16
			-- add by vietdt 2022/08/09	
			,	CASE						
					WHEN	S0010.language = 2
					THEN	'en'
					ELSE	'jp'
				END
			FROM S0010 
			INNER JOIN M0001 ON (
				M0001.company_cd	=	S0010.company_cd
			AND M0001.del_datetime IS NULL 
			)	
			LEFT JOIN S0020 AS #S0020_EVAL ON (
				#S0020_EVAL.company_cd		=	S0010.company_cd
			AND #S0020_EVAL.authority_cd	=	S0010.authority_cd
			AND #S0020_EVAL.del_datetime	IS NULL 
			)
			LEFT JOIN S2020 AS #S0020_1ON1 ON (
				#S0020_1ON1.company_cd		=	S0010.company_cd
			AND #S0020_1ON1.authority_cd	=	S0010.[1on1_authority_cd]
			AND #S0020_1ON1.del_datetime	IS NULL 
			)
			LEFT JOIN S9020 AS #S0020_SET ON (
				#S0020_SET.company_cd		=	S0010.company_cd
			AND #S0020_SET.authority_cd		=	S0010.setting_authority_cd
			AND #S0020_SET.del_datetime	IS NULL 
			)
			LEFT JOIN S3020 AS #S0020_MTP ON (
				#S0020_MTP.company_cd		=	S0010.company_cd
			AND #S0020_MTP.authority_cd		=	S0010.multireview_authority_cd
			AND #S0020_MTP.del_datetime	IS NULL 
			)
			LEFT JOIN S4020 AS #S0020_RPT ON (
				#S0020_RPT.company_cd		=	S0010.company_cd
			AND #S0020_RPT.authority_cd		=	S0010.report_authority_cd
			AND #S0020_RPT.del_datetime	IS NULL 
			)
			LEFT JOIN L0010 AS #L0010_EVAL ON (
				#L0010_EVAL.name_typ	=	4
			AND #L0010_EVAL.number_cd	=	S0010.authority_typ
			)
			LEFT JOIN L0010 AS #L0010_1ON1 ON (
				#L0010_1ON1.name_typ	=	4
			AND #L0010_1ON1.number_cd	=	S0010.[1on1_authority_typ]
			)
			LEFT JOIN L0010 AS #L0010_MTP ON (
				#L0010_MTP.name_typ		=	4
			AND #L0010_MTP.number_cd	=	S0010.multireview_authority_typ
			)
			LEFT JOIN L0010 AS #L0010_SET ON (
				#L0010_SET.name_typ		=	4
			AND #L0010_SET.number_cd	=	S0010.setting_authority_typ
			)
			LEFT JOIN L0010 AS #L0010_RPT ON (
				#L0010_RPT.name_typ		=	4
			AND #L0010_RPT.number_cd	=	S0010.report_authority_typ
			)
			LEFT JOIN M9100 ON (
				M9100.company_cd	=	S0010.company_cd
			AND M9100.del_datetime IS NULL
			)
			WHERE
				S0010.user_id COLLATE Latin1_General_CS_AS		=	@user_id
			AND S0010.password COLLATE Latin1_General_CS_AS		=	@password
			AND S0010.del_datetime	IS NULL
			AND M0001.contract_cd COLLATE Latin1_General_CS_AS	=	@P_contract_cd	
			--AND ISNULL(M0001.contract_company_attribute,0)				<>	2
			-- CHECK PASSWORD AGE   datnt

			IF(SELECT password_age FROM #SESSION_TBL) > 0
			BEGIN
				SELECT @pass_remain	=	DATEDIFF(dd,@now,DATEADD(mm,#SESSION_TBL.password_age,#SESSION_TBL.pass_change_datetime))
				FROM #SESSION_TBL
			END
			IF(@pass_remain > 0 AND @pass_remain <= 14 )
			BEGIN
				SET @change_pass_status = 1
			END
		END
		-- ログイン失敗
		--ELSE IF @failed_login_count < 5
		--BEGIN
		--	UPDATE S0010 SET 
		--		failed_login_count	=	ISNULL(S0010.failed_login_count,0) + 1
		--	FROM S0010 
		--	INNER JOIN M0001 ON (
		--		M0001.company_cd	=	S0010.company_cd
		--	AND M0001.del_datetime IS NULL 
		--	)	
		--	WHERE
		--		S0010.[user_id]		=	@user_id
		--	AND S0010.del_datetime	IS NULL
		--	AND M0001.contract_cd COLLATE Latin1_General_CS_AS	=	@P_contract_cd	
		--	AND S0010.authority_typ <> 4
		--END

		IF @w_report_authority_typ<2 
		AND (NOT EXISTS(SELECT 1 FROM M0070 
						INNER JOIN F4121 ON (
							M0070.company_cd = F4121.company_cd
						AND M0070.employee_cd = F4121.viewer_employee_cd
						AND M0070.company_cd = F4121.company_cd
						AND M0070.del_datetime IS NULL
						AND F4121.del_datetime IS NULL
						) 
						WHERE
							M0070.report_typ = 0
						AND M0070.employee_cd = @w_employee_cd	
						AND F4121.fiscal_year = @w_fiscal_year_current
						AND M0070.company_cd = @company_cd
						)
				AND NOT EXISTS (SELECT 1 FROM M0070 
						WHERE
							(M0070.report_typ = 1
							AND M0070.employee_cd = @w_employee_cd)
						AND M0070.company_cd = @company_cd
						)
		)
		BEGIN
			UPDATE #SESSION_TBL
			SET report_use_typ = 0
			FROM #SESSION_TBL
		END
	END TRY
	BEGIN CATCH
	IF (@@TRANCOUNT > 0)
		BEGIN
			ROLLBACK TRANSACTION
		END
		DELETE FROM @ERR_TBL
		INSERT INTO @ERR_TBL
		SELECT	
			0
		,	'EXCETION'
		,	0
		,	999 -- exception error
		,	0
		,	0
		,	'Error'                                                          + CHAR(13) + CHAR(10) +
            'Procedure : ' + ISNULL(ERROR_PROCEDURE(), '???')                + CHAR(13) + CHAR(10) +
            'Line : '      + ISNULL(CAST(ERROR_LINE() AS NVARCHAR(10)), '0') + CHAR(13) + CHAR(10) +
            'Message : '   + ISNULL(ERROR_MESSAGE(), 'An unexpected error occurred.')
	END CATCH
	--DELETE FROM @ERR_TBL
	IF(@@TRANCOUNT > 0)
	BEGIN
		COMMIT TRANSACTION
	END
    -- Insert statements for procedure here
	COMPLETE_QUERY:
	-- GET ERROR_TYPE MIN
	SELECT 
		@order_by_min = MIN(order_by)
	FROM @ERR_TBL
	--[0]
	SELECT
		company_cd						
	,	company_nm
	,	[user_id]						
	,	employee_cd						
	,	[password]						
	,	authority_typ					
	,	authority_cd					
	,	[1on1_authority_typ]			
	,	[1on1_authority_cd]				
	,	multireview_authority_typ		
	,	report_authority_cd		
	,	setting_authority_typ			
	,	setting_authority_cd		
	,	report_authority_typ
	,	report_authority_cd
	,	empinfo_authority_typ
	,	empinfo_authority_cd
	,	remember_token					
	,	failed_login_count				
	,	pass_change_datetime			
	,	last_login_ip					
	,	last_login_datetime				
	,	cre_user						
	,	cre_ip							
	,	cre_prg							
	,	cre_datetime					
	,	upd_user						
	,	upd_ip							
	,	upd_prg							
	,	upd_datetime					
	,	del_user						
	,	del_ip							
	,	del_prg							
	,	del_datetime					
	,	authority_nm					
	,	[1on1_authority_nm]				
	,	multireview_authority_nm	
	,	setting_authority_nm
	,	report_authority_nm

	,	authority_typ_nm				
	,	[1on1_authority_typ_nm]			
	,	multireview_authority_typ_nm	
	,	setting_authority_typ_nm
	,	report_authority_typ_nm

	,	password_age					
	,	evaluation_use_typ				
	,	evaluation_use_start_dt			
	,	evaluation_user_end_dt			
	,	[1on1_use_typ]					
	,	[1on1_use_start_dt]				
	,	[1on1_user_end_dt]				
	,	multireview_use_typ				
	,	multireview_use_start_dt		
	,	multireview_user_end_dt			
	,	report_use_typ
	,	report_use_start_dt
	,	report_user_end_dt
	,	empinf_use_typ
	,	empsrch_use_typ
	,	empcom_use_typ
	,	contract_company_attribute		
	,	@change_pass_status				AS change_pass_status
	,	@pass_remain					AS pass_remain
	,	@w_setting_authority_typ		AS setting_authority_typ
	,	@w_1on1_authority_typ			AS w_1on1_authority_typ
	,	@w_multireview_authority_typ	AS multireview_authority_typ
	,	CASE 
			WHEN evaluation_user_end_dt < @w_time AND evaluation_user_end_dt IS NOT NULL 
			THEN 0
			ELSE 1  
		END								AS evaluation_time_status
	,	CASE 
			WHEN multireview_user_end_dt < @w_time  AND multireview_user_end_dt IS NOT NULL 
			THEN 0
			ELSE 1  
		END								AS multireview_time_status
	,	CASE 
			WHEN [1on1_user_end_dt] < @w_time  AND [1on1_user_end_dt] IS NOT NULL 
			THEN 0
			ELSE 1  
		END								AS oneonone_time_status
	,	CASE 
			WHEN report_user_end_dt < @w_time  AND report_user_end_dt IS NOT NULL 
			THEN 0
			ELSE 1  
		END								AS report_time_status
	,	
		IIF(ISNULL(authority_typ,0) > 0,1,0) 
	+	IIF(ISNULL(@w_1on1_authority_typ,0) > 0,1,0) 
	+	IIF(ISNULL(@w_multireview_authority_typ,0) > 0,1,0)  
	+	IIF(ISNULL(@w_report_use_typ,0) > 0,1,0)
	+	IIF(ISNULL(@w_empinfo_authority_typ,0) > 0,1,0)
										AS count_authority
	,	user_is_rater_1									-- add by viettd 2021/06/16
	,	[language]										-- add by vietdt 2022/08/09
	,	CONVERT(NVARCHAR(100),NEWID())	AS	login_key	-- add by viettd 2023/06/19
	FROM #SESSION_TBL
	--[1] SELECT ERROR TABLE
	SELECT 
		message_no
	,	item
	,	order_by
	,	error_typ
	,	value1
	,	value2
	,	remark
	FROM @ERR_TBL
	WHERE order_by = @order_by_min
	ORDER BY 
		order_by
END
GO