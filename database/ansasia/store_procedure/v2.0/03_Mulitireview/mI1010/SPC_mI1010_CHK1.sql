IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_mI1010_CHK1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_mI1010_CHK1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 -- +--TEST--+
-- EXEC XXX '{}','','::1';
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	check employee is using mulitireview service
--*  
--* 作成日/create date			:	2021/06/10											
--*	作成者/creater				:	viettd						
--*   					
--*	更新日/update date			:	2021/06/16
--*	更新者/updater				:　 viettd
--*	更新内容/update content		:	show rater_employee_cd_1 when change 対象社員名
--*   					
--*	更新日/update date			:	2022/09/23
--*	更新者/updater				:　 namnt
--*	更新内容/update content		:	
--****************************************************************************************

CREATE PROCEDURE [SPC_mI1010_CHK1]
	@P_company_cd		SMALLINT		=	0
,	@P_employee_cd		NVARCHAR(10)	=	''
,	@P_fiscal_year		SMALLINT		=	0	
AS
BEGIN
	SET NOCOUNT ON;
	--
	DECLARE 
		@w_multireview_typ					TINYINT				=	1 -- USE 
	,	@w_rater_employee_nm_1_string		NVARCHAR(200)		=	''	-- add by viettd 2021/06/16
	-- add by viettd 2021/06/16
	CREATE TABLE #TABLE_F0030_RATER1 (
		id						int			identity(1,1)
	,	rater_employee_cd_1		nvarchar(10)
	,	rater_employee_nm_1		nvarchar(200)
	)
	-- add by viettd 2021/06/16
	INSERT INTO #TABLE_F0030_RATER1
	SELECT 
		DISTINCT
		F0030.rater_employee_cd_1
	,	M0070.employee_nm
	FROM F0030
	LEFT OUTER JOIN M0070 ON (
		F0030.company_cd				=	M0070.company_cd
	AND F0030.rater_employee_cd_1		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	WHERE 
		F0030.company_cd		=	@P_company_cd
	AND F0030.fiscal_year		=	@P_fiscal_year
	AND F0030.employee_cd		=	@P_employee_cd
	AND F0030.del_datetime IS NULL
	--
	SET @w_rater_employee_nm_1_string = STUFF((SELECT ','+ CAST((rater_employee_nm_1) AS NVARCHAR(101))
								 FROM #TABLE_F0030_RATER1
								 FOR XML PATH('')),1,1,'')
	-- CHECK WHEN @P_employee_cd = '' 
	IF @P_employee_cd IS NULL OR @P_employee_cd = ''
	BEGIN
		GOTO COMPLETED
	END
	-- GET M0070.multireview_typ
	SET @w_multireview_typ =	(	
								SELECT 
									ISNULL(M0070.multireview_typ,1) 
								FROM M0070 
								WHERE 
									M0070.company_cd = @P_company_cd 
								AND M0070.employee_cd = @P_employee_cd 
								AND M0070.del_datetime IS NULL
								)
COMPLETED:
	-- CHECK IF @w_multireview_typ = 0 (マルチレビュー対象としない)
	SELECT 
		@w_multireview_typ				AS	multireview_typ
	,	@w_rater_employee_nm_1_string	AS	rater_employee_nm_1_string
END
GO
