DROP PROCEDURE [SPC_INFORMATION_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +TEST+
-- EXEC SPC_INFORMATION_FND1 '','','','0','142','f','20','1';
/****************************************************************************************************
 *
 *  処理概要	:	SEARCH NOTIFICATION
 *
 *  作成日  ：	2018/08/20
 *  作成者  ：	Tuantv
 *
 *  更新日  ：	2021/05/19
 *  更新者  ：	viettd
 *  更新内容：	add company_cd into where condition
 ****************************************************************************************************/
 CREATE PROCEDURE [SPC_INFORMATION_FND1] 
  	@P_infomation_date_from			DATE				=	NULL
,	@P_infomation_date_to			DATE				=	NULL
,	@P_infomation_title				NVARCHAR(50)		=	''	
,	@P_confirmation_datetime_flg	SMALLINT			=	0
,	@P_company_cd					SMALLINT			=	0
,	@P_user_id						NVARCHAR(50)		=	''	
,	@P_page_size					INT					=	50
,	@P_page							INT					=	1
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@ERR_TBL				ERRTABLE
	,	@totalRecord			BIGINT			=	0
	,	@pageNumber				INT				=	0
	,	@pageMax				INT				=	0
	,	@P_employee_cd			NVARCHAR(10)	=	''
	,	@P_authority_typ		SMALLINT		=	0
	--
	SELECT TOP 1
		@P_employee_cd		=	ISNULL(S0010.employee_cd,'')
	,	@P_authority_typ	=	ISNULL(S0010.authority_typ,'')
	FROM S0010
	WHERE 
		S0010.user_id		=	@P_user_id
	AND	S0010.del_datetime	IS NULL
	AND S0010.company_cd	=	@P_company_cd	-- add by viettd 2021/05/19
	--
	CREATE TABLE #TEMP_INFORMATION
	(
	 	company_cd				SMALLINT		
	, 	category				SMALLINT	
	,	status_cd				SMALLINT
	,	infomationn_typ			TINYINT
	,	infomation_date			DATE
	,	target_employee_cd		NVARCHAR(10)
	,	fiscal_year				SMALLINT		
	,	sheet_cd				SMALLINT	
	,	employee_cd				NVARCHAR(10)	
	,	infomation_title		NVARCHAR(50)	
	,	infomation_message		NVARCHAR(1000)	
	,	confirmation_datetime	DATE														
	)	
	INSERT INTO #TEMP_INFORMATION
	SELECT 
		company_cd						
	, 	category				
	,	status_cd				
	,	infomationn_typ	
	,	infomation_date		
	,	target_employee_cd	
	,	fiscal_year			
	,	sheet_cd				
	,	employee_cd					
	,	infomation_title			
	,	infomation_message			
	,	confirmation_datetime
	FROM F0900
	WHERE 
		F0900.company_cd			=	@P_company_cd
	AND	F0900.employee_cd			=	@P_employee_cd
	AND	(
			(@P_authority_typ			>	2)	
		OR	(@P_authority_typ			<=	2	AND	F0900.employee_cd			=	@P_employee_cd)
		)
	AND	(
		(@P_infomation_date_from	=	'')
	OR	(@P_infomation_date_from	<> ''	AND	@P_infomation_date_from	<=	F0900.infomation_date)
	)
	AND	(
		(@P_infomation_date_to		=	'')
	OR	(@P_infomation_date_to		<> ''	AND	@P_infomation_date_to	>=	F0900.infomation_date)
	)
	AND	((@P_infomation_title				= '')
		OR	(dbo.FNC_COM_REPLACE_SPACE(F0900.infomation_title)		LIKE '%' +	dbo.FNC_COM_REPLACE_SPACE(@P_infomation_title) + '%'))	
	AND	F0900.del_datetime		IS NULL
	AND	(
		(@P_confirmation_datetime_flg	=	0)	
	OR	(@P_confirmation_datetime_flg	=	1	AND	F0900.confirmation_datetime IS NULL)
	) 
	ORDER BY 
		CASE 
			WHEN F0900.confirmation_datetime IS NULL 
			THEN 0
			ELSE 1
		END
	,	F0900.infomation_date	 DESC 
	,	F0900.target_employee_cd ASC
	--
	SET @totalRecord = (SELECT COUNT(1) FROM #TEMP_INFORMATION)
	SET @pageMax = CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	IF @pageMax = 0
	BEGIN
		SET @pageMax = 1
	END
	IF @P_page > @pageMax
	BEGIN
		SET @P_page = @pageMax
	END	

	SELECT 
		F0900.company_cd						
	, 	F0900.category				
	,	status_cd				
	,	infomationn_typ	
	,	CASE 
			WHEN infomation_date IS NOT NULL
			THEN CONVERT(NVARCHAR(10),infomation_date,111)
			ELSE NULL
		END				AS infomation_date
	,	target_employee_cd
	,	fiscal_year				
	,	F0900.sheet_cd				
	,	employee_cd					
	,	infomation_title			
	,	infomation_message			
	,	CASE
			WHEN	confirmation_datetime IS NULL
			THEN	1
			ELSE	0
		END confirmation_datetime_flg	
	,	CASE	
			WHEN M0200.sheet_kbn = 1
			THEN '/master/i2010'
			ELSE '/master/i2020'
		END	AS screen_refer
	FROM #TEMP_INFORMATION	AS F0900
	LEFT OUTER JOIN M0200 WITH(NOLOCK) ON (
		F0900.company_cd			=	M0200.company_cd
	AND	F0900.sheet_cd				=	M0200.sheet_cd
	)
	ORDER BY 
		CASE 
			WHEN F0900.confirmation_datetime IS NULL 
			THEN 0
			ELSE 1
		END
	,	F0900.infomation_date		DESC 
	,	F0900.target_employee_cd	ASC
	offset (@P_page - 1) * @P_page_size rows
	fetch next @P_page_size rows only
	--[1]
	SELECT	
		@totalRecord	AS totalRecord
	,	@pageMax		AS pageMax
	,	@P_page			AS page
	,	@P_page_size	AS pagesize
	,	((@P_page - 1) * @P_page_size + 1) AS offset
	END
GO
