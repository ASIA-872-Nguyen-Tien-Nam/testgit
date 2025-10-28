DROP PROCEDURE [SPC_eI0200_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	SPC_eI0200_INQ1
--*  
--*  作成日/create date			:	2024/04/02
--*　作成者/creater				:	manhnd						
--*  作成内容/create content		:	refer data ei0200
--*	 更新日/update date			:  	
--*	 更新者/updater				:　 
--*	 更新内容/update content	:	
--****************************************************************************************
CREATE PROCEDURE [SPC_eI0200_INQ1]
	@P_company_cd											SMALLINT
,	@P_employee_cd											NVARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		-- SCREEN
		@w_initial_floor_id					SMALLINT			=	0
	,	@w_picture							NVARCHAR(100)		=	N''
	--TABLES
	CREATE TABLE #TEMP (
        id									BIGINT			IDENTITY(1,1)
	,	application_date					DATE
	,	company_cd							SMALLINT
    ,   employee_cd							NVARCHAR(10)
    ,   employee_nm							NVARCHAR(101)
    ,   employee_ab_nm						NVARCHAR(101)
    ,   furigana							NVARCHAR(50)
    ,   office_cd							SMALLINT
    ,   office_nm							NVARCHAR(50)
    ,   belong_cd1							NVARCHAR(20)
    ,   belong_cd2							NVARCHAR(20)
    ,   belong_cd3							NVARCHAR(20)
    ,   belong_cd4							NVARCHAR(20)
    ,   belong_cd5							NVARCHAR(20)
	,   job_cd								SMALLINT
	,   position_cd							INT
	,   employee_typ						SMALLINT
	,   grade								SMALLINT
    ,   belong_cd1_nm						NVARCHAR(50)
    ,   belong_cd2_nm						NVARCHAR(50)
    ,   belong_cd3_nm						NVARCHAR(50)
    ,   belong_cd4_nm						NVARCHAR(50)
    ,   belong_cd5_nm						NVARCHAR(50)
    ,   job_nm								NVARCHAR(50)
    ,   position_nm							NVARCHAR(50)
    ,   grade_nm							NVARCHAR(10)
    ,   employee_typ_nm						NVARCHAR(50)
    )
	
	SELECT 
		@w_picture				=	ISNULL(picture,N'')
	,	@w_initial_floor_id		=	ISNULL(initial_floor_id,0)
	FROM F5000
	WHERE
		company_cd			=	@P_company_cd
	AND employee_cd			=	@P_employee_cd

	--[0] DATA
	INSERT INTO #TEMP
	EXEC SPC_REFER_M0070H_INQ1 NULL, @P_employee_cd, @P_company_cd

	SELECT 
		#TEMP.employee_cd											AS	employee_cd
	,	#TEMP.employee_nm											AS	employee_nm
	,	#TEMP.belong_cd1_nm											AS	organization_nm_1
	,	#TEMP.belong_cd2_nm											AS	organization_nm_2
	,	#TEMP.belong_cd3_nm											AS	organization_nm_3
	,	#TEMP.belong_cd4_nm											AS	organization_nm_4
	,	#TEMP.belong_cd5_nm											AS	organization_nm_5
	,	#TEMP.position_cd											AS	position_cd
	,	#TEMP.position_nm											AS	position_nm
	,	@w_picture													AS	picture
	,	@w_initial_floor_id											AS	initial_floor_id
	,	M5200.emailaddress_display_kbn								AS	show_mail
	,	M5200.company_mobile_display_kbn							AS	show_company_mobile_display_kbn
	,	M5200.extension_number_display_kbn							AS	show_extension_number_display_kbn
	,	IIF(ISNULL(M5200.emailaddress_display_kbn,0) = 1, ISNULL(M0070.mail,N''), N'')						AS	mail
	,	IIF(ISNULL(M5200.company_mobile_display_kbn,0) = 1, ISNULL(M0070.company_mobile_number,N''), N'')	AS	company_mobile_number
	,	IIF(ISNULL(M5200.extension_number_display_kbn,0) = 1, ISNULL(M0070.extension_number,N''), N'')		AS	extension_number
	FROM #TEMP
	LEFT OUTER JOIN M0070 ON (
		#TEMP.company_cd	=	M0070.company_cd
	AND	#TEMP.employee_cd	=	M0070.employee_cd
	)
	LEFT OUTER JOIN M5200 ON (
		M0070.company_cd	=	M5200.company_cd
	)

	--[1] COMBOBOX
	SELECT
		M5201.floor_id							AS	floor_id
	,	ISNULL(M5201.floor_name,N'')			AS	floor_name
	FROM M5200
	LEFT OUTER JOIN M5201 ON (
		M5200.company_cd				=	M5201.company_cd
	)
	WHERE
		M5200.company_cd				=	@P_company_cd
	AND M5200.del_datetime				IS NULL
	AND M5200.seating_chart_use_typ		= 1
	AND	M5201.del_datetime				IS NULL

	--[2] FIELDS
	SELECT 
		ISNULL(M5202.field_cd,0)					AS	field_cd
	,	ISNULL(M5202.field_nm,N'')					AS	field_nm
	,	ISNULL(F5001.registered_value,N'')			AS	registered_value
	FROM M5202
	LEFT JOIN F5001 ON (
		M5202.company_cd			=	F5001.company_cd
	AND	@P_employee_cd				=	F5001.employee_cd
	AND	M5202.field_cd				=	F5001.field_cd
	AND F5001.del_datetime IS NULL
	)
	WHERE
		M5202.company_cd			=	@P_company_cd
	AND	M5202.del_datetime		IS NULL
	ORDER BY
		M5202.arrange_order
END
GO
