IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_1on1_PERMISSION_CHK1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].SPC_1on1_PERMISSION_CHK1
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：COMMON - CHECK MEMBER
 *
 *  作成日  ：2020/11/18
 *  作成者  ：ANS-ASIA nghianm
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_1on1_PERMISSION_CHK1]
	@P_company_cd				SMALLINT		= 0
,	@P_fiscal_year				SMALLINT		= 0
,	@P_employee_cd				NVARCHAR(10)	= ''
,	@P_coach_cd					NVARCHAR(10)	= ''
,	@P_times					SMALLINT		= 0

AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@year		NVARCHAR(10) = ''
	,	@coach_cd	NVARCHAR(10) = ''
	SET @coach_cd = (SELECT coach_cd FROM F2001 WHERE company_cd = @P_company_cd 
										AND fiscal_year = @P_fiscal_year 
										AND employee_cd = @P_employee_cd
										AND 
											(times = @P_times
										OR	@P_times = 0)
										AND del_datetime IS NULL)
		IF(@P_coach_cd = '')
		BEGIN
			SET @P_coach_cd = @coach_cd
		END
	--[0]
	SELECT 
		ISNULL(M0070.employee_cd,'')	AS	employee_cd
	,	ISNULL(M0070.employee_nm,'')	AS	employee_nm
	FROM M0070
	WHERE 
		M0070.company_cd			=	@P_company_cd
	AND	M0070.employee_cd			=	@coach_cd
	AND M0070.del_datetime IS NULL
	
	--[1]
	SELECT 
		ISNULL(M0070.employee_cd,'')	AS	employee_cd
	,	ISNULL(M0070.employee_nm,'')	AS	employee_nm
	FROM M0070
	WHERE 
		M0070.company_cd			=	@P_company_cd
	AND	M0070.employee_cd			=	@P_employee_cd
	AND M0070.del_datetime IS NULL
	
END
GO
