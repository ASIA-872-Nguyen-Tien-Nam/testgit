DROP PROCEDURE [SPC_INFORMATION_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- +--TEST--+ SPC_INFORMATION_INQ1
-- EXEC [SPC_INFORMATION_INQ1]]'';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	
--*  
--*  作成日/create date			:	2018/10/24				
--*　作成者/creater				:	LONGVV								
--*   					
--*  更新日/update date			:  
--*　更新者/updater				:　
--*　更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [SPC_INFORMATION_INQ1]
	@P_company_cd			SMALLINT		=	0
,	@P_category				SMALLINT		=	0
,	@P_status_cd			SMALLINT		=	0
,	@P_infomationn_typ		TINYINT			=	0
,	@P_infomation_date		DATE			=	NULL
,	@P_target_employee_cd	NVARCHAR(10)	=	''
,	@P_sheet_cd				SMALLINT		=	0	
,	@P_employee_cd			NVARCHAR(10)	=	''
,	@P_fiscal_year			SMALLINT		=	0	
,	@P_cre_user				NVARCHAR(50)	=	''
,	@P_cre_ip				NVARCHAR(50)	=	''
AS
BEGIN	
	SET NOCOUNT ON;
	DECLARE @w_time			DATETIME2			=	SYSDATETIME()
	--[0]
	SELECT 
		CASE 
			WHEN	F0900.infomation_date IS NOT NULL
			THEN	CONVERT(NVARCHAR(10),F0900.infomation_date,111)
			ELSE	NULL
		END										AS	infomation_date
	,	ISNULL(F0900.infomation_title,'')		AS	infomation_title
	,	ISNULL(F0900.infomation_message,'')		AS	infomation_message	
	,	ISNULL(F0900.target_employee_cd,'')		AS	target_employee_cd
	,	ISNULL(F0900.sheet_cd,0)				AS	sheet_cd
	,	ISNULL(F0900.employee_cd,'')			AS	employee_cd
	,	ISNULL(M0070.employee_nm,'')			AS	target_employee_nm
	,	ISNULL(M0200.sheet_nm,'')				AS	sheet_nm
	,	ISNULL(F0900.fiscal_year,0)				AS	fiscal_year
	,	CASE	
			WHEN M0200.sheet_kbn = 1
			THEN '/master/i2010'
			ELSE '/master/i2020'
		END	AS screen_refer
	FROM F0900 WITH(NOLOCK)
	LEFT OUTER JOIN M0070 WITH(NOLOCK) ON (
		F0900.company_cd			=	M0070.company_cd
	AND	F0900.target_employee_cd	=	M0070.employee_cd
	)
	LEFT OUTER JOIN M0200 WITH(NOLOCK) ON (
		F0900.company_cd			=	M0200.company_cd
	AND	F0900.sheet_cd				=	M0200.sheet_cd
	)
	WHERE 
		F0900.company_cd			=	@P_company_cd
	AND	F0900.category				=	@P_category
	AND F0900.status_cd				=	@P_status_cd
	AND	F0900.infomationn_typ		=	@P_infomationn_typ
	AND	F0900.infomation_date		=	@P_infomation_date
	AND	F0900.target_employee_cd	=	@P_target_employee_cd
	AND	F0900.sheet_cd				=	@P_sheet_cd
	AND	F0900.employee_cd			=	@P_employee_cd
	AND F0900.fiscal_year			=	@P_fiscal_year
	AND	F0900.del_datetime IS NULL
	-- UPDATE CONFRIMDATE F0900
	UPDATE F0900 SET 
		confirmation_datetime	= @w_time
	WHERE 
		F0900.company_cd			=	@P_company_cd
	AND	F0900.category				=	@P_category
	AND F0900.status_cd				=	@P_status_cd
	AND	F0900.infomationn_typ		=	@P_infomationn_typ
	AND	F0900.infomation_date		=	@P_infomation_date
	AND	F0900.target_employee_cd	=	@P_target_employee_cd
	AND	F0900.sheet_cd				=	@P_sheet_cd
	AND	F0900.employee_cd			=	@P_employee_cd
	AND F0900.fiscal_year			=	@P_fiscal_year
	AND	F0900.del_datetime IS NULL

END
GO
