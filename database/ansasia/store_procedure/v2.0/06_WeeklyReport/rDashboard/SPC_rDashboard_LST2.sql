DROP PROCEDURE [SPC_rDashboard_LST2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_rDashboard_LST2 782,'721',2023,1
-- EXEC SPC_rDashboard_LST2 782,'721',2023,2
-- EXEC SPC_rDashboard_LST2 782,'721',2023,3
-- EXEC SPC_rDashboard_LST2 782,'721',2023,4

--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET INFORMATIONS FOR ALERT (アラート)
--*  
--*  作成日/create date			:	2023/05/08						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2024/07/01
--*　更新者/updater				:	Yamazaki
--*　更新内容/update content	:	条件からfiscal_yearを外す（年度が替わると未チェックの通知が見れなくなるため）
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rDashboard_LST2]
	@P_company_cd		SMALLINT		=	0
,	@P_employee_cd		NVARCHAR(10)	=	''	-- LOGIN EMPLOYEE
,	@P_fiscal_year		SMALLINT		=	0
,	@P_infomation_typ	SMALLINT		=	0	-- 1:通知 2:アラート 3:リアクション 4.共有 5.差戻
AS
BEGIN
	--[0]
	DECLARE 
		@w_today			date			=	GETDATE()
	--,	@w_language			smallint		=	0	-- 1.JP 2.EN
	--	
	--SELECT 
	--	@w_language =	ISNULL(S0010.[language],1)
	--FROM S0010
	--WHERE 
	--	S0010.company_cd	=	@P_company_cd
	--AND S0010.employee_cd	=	@P_employee_cd
	--AND S0010.del_datetime IS NULL

	-- 1 (通知) | 3 (リアクション) | 4 (共有)
	IF @P_infomation_typ IN(1,3,4)
	BEGIN
		--[0]
		SELECT 
			ISNULL(F4900.fiscal_year,0)					AS	fiscal_year
		,	ISNULL(F4900.infomation_typ,0)				AS	infomation_typ
		,	ISNULL(F4900.employee_cd,'')				AS	employee_cd
		,	ISNULL(F4900.report_kind,0)					AS	report_kind
		,	ISNULL(F4900.report_no,0)					AS	report_no
		,	FORMAT(F4900.infomation_date,'yyyy/MM/dd')	AS	infomation_date
		,	ISNULL(F4900.infomation_title,'')			AS	infomation_title
		,	ISNULL(F4900.infomation_message,'')			AS	infomation_message
		,	FORMAT(F4900.display_period,'yyyy/MM/dd')	AS	display_period
		,	ISNULL(F4900.from_employee_cd,'')			AS	from_employee_cd
		,	ISNULL(F4900.to_employee_cd,'')				AS	to_employee_cd
		FROM F4900
		WHERE 
			F4900.company_cd		=	@P_company_cd
		AND F4900.infomation_typ	=	@P_infomation_typ
		--AND F4900.fiscal_year		=	@P_fiscal_year　　--2024/07/01
		AND F4900.to_employee_cd	=	@P_employee_cd
		AND F4900.display_period	>=	@w_today
		AND F4900.confirmation_datetime	IS NULL
		AND F4900.del_datetime IS NULL
	END
	-- 2.アラート
	IF @P_infomation_typ	=	2
	BEGIN
		--[0]
		SELECT 
			ISNULL(F4900.fiscal_year,0)					AS	fiscal_year
		,	ISNULL(F4900.infomation_typ,0)				AS	infomation_typ
		,	ISNULL(F4900.employee_cd,'')				AS	employee_cd
		,	ISNULL(F4900.report_kind,0)					AS	report_kind
		,	ISNULL(F4900.report_no,0)					AS	report_no
		,	FORMAT(F4900.infomation_date,'yyyy/MM/dd')	AS	infomation_date
		,	ISNULL(F4900.infomation_title,'')			AS	infomation_title
		,	ISNULL(F4900.infomation_message,'')			AS	infomation_message
		,	FORMAT(F4900.display_period,'yyyy/MM/dd')	AS	display_period
		,	ISNULL(F4900.from_employee_cd,'')			AS	from_employee_cd
		,	ISNULL(F4900.to_employee_cd,'')				AS	to_employee_cd
		FROM F4900
		WHERE 
			F4900.company_cd		=	@P_company_cd
		AND F4900.infomation_typ	=	2
		AND F4900.fiscal_year		=	@P_fiscal_year
		AND F4900.to_employee_cd	=	@P_employee_cd
		AND F4900.del_datetime IS NULL
	END
	-- 5.差戻
	IF @P_infomation_typ = 5
	BEGIN
		--[0]
		SELECT 
			ISNULL(F4900.fiscal_year,0)					AS	fiscal_year
		,	ISNULL(F4900.infomation_typ,0)				AS	infomation_typ
		,	ISNULL(F4900.employee_cd,'')				AS	employee_cd
		,	ISNULL(F4900.report_kind,0)					AS	report_kind
		,	ISNULL(F4900.report_no,0)					AS	report_no
		,	FORMAT(F4900.infomation_date,'yyyy/MM/dd')	AS	infomation_date
		,	ISNULL(F4900.infomation_title,'')			AS	infomation_title
		,	ISNULL(F4900.infomation_message,'')			AS	infomation_message
		,	FORMAT(F4900.display_period,'yyyy/MM/dd')	AS	display_period
		,	ISNULL(F4900.from_employee_cd,'')			AS	from_employee_cd
		,	ISNULL(F4900.to_employee_cd,'')				AS	to_employee_cd
		FROM F4900
		WHERE 
			F4900.company_cd		=	@P_company_cd
		AND F4900.infomation_typ	=	@P_infomation_typ
		--AND F4900.fiscal_year		=	@P_fiscal_year　　--2024/07/01
		AND F4900.to_employee_cd	=	@P_employee_cd
		AND F4900.confirmation_datetime IS NULL
		AND F4900.del_datetime IS NULL
	END
END
GO
