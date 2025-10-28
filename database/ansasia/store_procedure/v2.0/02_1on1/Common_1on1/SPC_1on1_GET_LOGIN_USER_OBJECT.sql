IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_1on1_GET_LOGIN_USER_OBJECT]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].SPC_1on1_GET_LOGIN_USER_OBJECT
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：GET LOGIN USER OBJECT IN 1ON1
 *
 *  作成日  ：2021/07/28
 *  作成者  ：viettd
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_1on1_GET_LOGIN_USER_OBJECT]
	@P_company_cd				SMALLINT		= 0
,	@P_fiscal_year				SMALLINT		= 0
,	@P_employee_cd				NVARCHAR(10)	= ''
,	@P_login_employee_cd		NVARCHAR(10)	= ''
,	@P_times					SMALLINT		= 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_1on1_authority_typ		SMALLINT		= 0
	,	@w_coach_cd					NVARCHAR(10)	= ''
	--
	CREATE TABLE #TABLE_RESULT(
		object_cd			INT	-- 1.Member | 2.Coach | 20.Coach of once times | 21.Coach at this time | 3.Admin | 5.General Admin | 0.Other
	,	comment				NVARCHAR(50)
	)
	INSERT INTO #TABLE_RESULT VALUES(0,'OTHER')
	-- GET @w_1on1_authority_typ
	SELECT 
		TOP 1
		@w_1on1_authority_typ	=	ISNULL(S0010.[1on1_authority_typ],0)
	FROM S0010
	WHERE 
		S0010.company_cd		=	@P_company_cd
	AND S0010.employee_cd		=	@P_login_employee_cd
	AND S0010.del_datetime IS NULL
	-- IF @P_fiscal_year = 0 THEN GET CURRENT YEAR
	IF @P_fiscal_year = 0
	BEGIN
		SET @P_fiscal_year = dbo.FNC_GET_YEAR_1ON1(@P_company_cd,NULL)
	END
	-- IF LOGIN USER IS ５．総合管理者
	IF @w_1on1_authority_typ = 5
	BEGIN
		UPDATE #TABLE_RESULT SET 
			object_cd = 5
		,	comment = 'General Admin 総合管理者'
		GOTO COMPLETED
	END
	-- IF LOGIN USER IS MEMBER
	IF @P_login_employee_cd <> '' AND @P_login_employee_cd = @P_employee_cd
	BEGIN
		UPDATE #TABLE_RESULT SET 
			object_cd = 1
		,	comment = 'Member'
		GOTO COMPLETED
	END
	-- IF LOGIN USER IS Coach at this time
	IF EXISTS (SELECT 1 
						FROM F2001 
						WHERE 
							F2001.company_cd	= @P_company_cd 
						AND F2001.fiscal_year	= @P_fiscal_year 
						AND F2001.employee_cd	= @P_employee_cd 
						AND F2001.times			= @P_times 
						AND F2001.coach_cd		= @P_login_employee_cd
						AND F2001.del_datetime IS NULL
						)
	BEGIN
		UPDATE #TABLE_RESULT SET 
			object_cd = 21
		,	comment = 'Coach at this time'
		GOTO COMPLETED
	END
	-- IF LOGIN USER IS Coach of once times
	IF EXISTS (SELECT 1 
						FROM F2001 
						WHERE 
							F2001.company_cd	= @P_company_cd 
						AND F2001.fiscal_year	= @P_fiscal_year 
						AND F2001.employee_cd	= @P_employee_cd 
						AND F2001.coach_cd		= @P_login_employee_cd
						AND F2001.del_datetime IS NULL
						)
	BEGIN
		UPDATE #TABLE_RESULT SET 
			object_cd = 20
		,	comment = 'Coach of once times'
		GOTO COMPLETED
	END
	-- IF LOGIN USER IS Coach
	IF @P_login_employee_cd <> '' AND @w_1on1_authority_typ = 2
	BEGIN
		UPDATE #TABLE_RESULT SET 
			object_cd = 2
		,	comment = 'Coach'
		GOTO COMPLETED
	END
	-- IF LOGIN USER IS ADMIN
	IF @P_login_employee_cd <> '' AND @w_1on1_authority_typ IN (3,4)
	BEGIN
		UPDATE #TABLE_RESULT SET 
			object_cd = 3
		,	comment = 'Admin'
		GOTO COMPLETED
	END
COMPLETED:
	SELECT * FROM #TABLE_RESULT
	--
	DROP TABLE #TABLE_RESULT
END
GO
