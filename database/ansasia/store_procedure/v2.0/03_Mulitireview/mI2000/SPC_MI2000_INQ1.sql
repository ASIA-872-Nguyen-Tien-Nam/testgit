IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_MI2000_INQ1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_MI2000_INQ1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：MI2000 - Refer
 *
 *  作成日  ：2021/01/05
 *  作成者  ：ANS-ASIA nghianm
 *
 *  更新日  ：2021/04/07
 *  更新者  ：ANS-ASIA vietdt
 *  更新内容：add permission
 * EXEC SPC_MI2000_INQ1 '10000','minni05','0','accmin0','2022';
 *  更新日  ：2021/05/13
 *  更新者  ：viettd
 *  更新内容：show employee_rater_1
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_MI2000_INQ1]
	@P_company_cd					smallint		= 0
,	@P_employee_cd					nvarchar(10)	= ''
,	@P_detail_no					smallint		= 0
,	@P_cre_user						nvarchar(50)	= ''	-- LOGIN 
,	@P_fiscal_year					smallint		= 0		-- add by viettd 2021/05/13
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_multireview_authority_typ	smallint		=	0
	,	@w_check_permission_msg			nvarchar(50)	=	''	-- check permisssion message
	,	@w_login_employee_cd			nvarchar(10)	=	''	-- login employee_cd
	,	@w_fiscal_year					smallint		=	0
	,	@w_review_date					date			=	NULL
	,	@w_supporter_cd					nvarchar(10)	=	''	-- supporter_cd
	,	@w_permission					SMALLINT		=	2	-- 0. not view,1. view , 2.edited	--add by vietdt 2021/04/07
	,	@w_authority_mI2020				SMALLINT		=	0										--add by vietdt 2021/04/07
	,	@w_other_browsing_kbn			SMALLINT		=	0										--add by vietdt 2021/04/07
	--
	,	@rater_employee_nm_1_string		NVARCHAR(200)	=	''	-- add by viettd 2021/05/13
	-- add by viettd 2021/05/13
	CREATE TABLE #TABLE_F0030_RATER1 (
		id						int			identity(1,1)
	,	rater_employee_cd_1		nvarchar(10)
	,	rater_employee_nm_1		nvarchar(101)
	)
	-- get login info
	SELECT 
		@w_multireview_authority_typ		=	ISNULL(S0010.multireview_authority_typ,0)
	,	@w_login_employee_cd				=	ISNULL(M0070.employee_cd,'')
	,	@w_authority_mI2020					=	ISNULL(S3021.authority,0)
	FROM S0010
	LEFT OUTER JOIN M0070 ON (
		S0010.company_cd		=	M0070.company_cd
	AND S0010.employee_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT JOIN S3021 ON (
		S0010.company_cd			=	S3021.company_cd
	AND	S0010.[1on1_authority_cd]	=	S3021.authority_cd
	AND	'mI2000'					=	S3021.function_id
	AND	S3021.del_datetime	IS NULL
	)
	WHERE 
		S0010.company_cd	= @P_company_cd 
	AND S0010.user_id		= @P_cre_user
	AND S0010.del_datetime IS NULL
	--
	IF @w_multireview_authority_typ = 3 AND @w_authority_mI2020 = 0
	BEGIN
		SET @w_multireview_authority_typ = 2 -- SUPPOTER
	END
	-- get review_date
	IF @P_detail_no > 0
	BEGIN
		SELECT 
			@w_review_date	=	F3000.review_date
		,	@w_supporter_cd	=	F3000.supporter_cd
		FROM F3000
		WHERE 
			F3000.company_cd	=	@P_company_cd
		AND F3000.employee_cd	=	@P_employee_cd
		AND F3000.detail_no		=	@P_detail_no
		-- GET @w_fiscal_year
		SET @w_fiscal_year = [dbo].FNC_GET_YEAR(@P_company_cd,@w_review_date)
		-- GET confirm_flg
		IF EXISTS (SELECT 1 FROM F3010 WHERE company_cd = @P_company_cd AND fiscal_year = @w_fiscal_year AND del_datetime IS NULL AND confirm_flg = 1)
		BEGIN
			SET @w_permission = 1	-- 1.view
			SET @w_check_permission_msg = 'Confirmed this year'
			GOTO COMPLETED
		END
		-- IF @w_multireview_authority_typ < 2
		IF @w_multireview_authority_typ < 2
		BEGIN
			SET @w_permission = 0 -- 0.not view
			SET @w_check_permission_msg = 'multireview_authority_typ not larger than 2.supporter'
			GOTO COMPLETED
		END
		-- when suppoter & rater
		IF @w_multireview_authority_typ = 2
		BEGIN
			IF NOT EXISTS(SELECT 1 FROM F3000 
											WHERE 
												company_cd		= @P_company_cd 
											AND employee_cd		= @P_employee_cd 
											AND detail_no		= @P_detail_no 
											AND supporter_cd	= @w_login_employee_cd 
											AND del_datetime IS NULL)
			BEGIN
				--other_browsing_kbn
				IF	EXISTS(SELECT 1 FROM F3020 WHERE 
												company_cd			= @P_company_cd 
											AND fiscal_year			= @w_fiscal_year 
											AND employee_cd			= @P_employee_cd 
											AND supporter_cd		= @w_login_employee_cd   
											AND	other_browsing_kbn	= 1
											AND del_datetime IS NULL)
				BEGIN
					SET @w_other_browsing_kbn = 1
				END
				-- @w_authority_mI2020 = 0  AND @w_other_browsing_kbn = 0 not view 
				IF	@w_authority_mI2020 = 0 AND @w_other_browsing_kbn = 0 
				BEGIN
					SET @w_permission = 0
				END
				ELSE
				BEGIN
					SET @w_permission = 1
				END
				SET @w_check_permission_msg = 'login user is not supporter'
				GOTO COMPLETED
			END
		END
		-- when admin 
		IF @w_multireview_authority_typ = 3
		BEGIN
			-- 1.VIEW
			IF @w_authority_mI2020 = 1
			BEGIN
				-- WHEN NOT SUPPOTER
				IF @w_supporter_cd <> @w_login_employee_cd 
				BEGIN
					SET @w_permission = 1 --  VIEW
					SET @w_check_permission_msg = 'login user is admin & authority = 1'
				END
			END
		END
	END
COMPLETED:
	--[1]
	SELECT
		F3000.company_cd
	,	@w_fiscal_year							AS	fiscal_year
	,	F3000.employee_cd
	,	F3000.detail_no
	,	F3000.supporter_cd
	,	FORMAT(F3000.review_date,'yyyy/MM/dd')	AS review_date 
	,	F3000.project_title
	,	F3000.evaluation_point
	,	FORMAT(F3000.comment_date,'yyyy/MM/dd') AS comment_date 
	,	F3000.comment
	FROM F3000
	WHERE 
		F3000.company_cd	= @P_company_cd
	AND	F3000.employee_cd	= @P_employee_cd
	AND F3000.detail_no		= @P_detail_no
	AND F3000.del_datetime IS NULL
	--[2] -- EMPLOYEE_NM
	-- add by viettd 2021/05/13
	-- IF @P_fiscal_year NOT EXISTS THEN USING @w_fiscal_year FROM @w_review_date
	IF @P_fiscal_year = 0	
	BEGIN
		SET @P_fiscal_year	=	@w_fiscal_year
	END
	--
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
	SET @rater_employee_nm_1_string = STUFF((SELECT ','+ CAST((rater_employee_nm_1) AS NVARCHAR(101))
								 FROM #TABLE_F0030_RATER1
								 FOR XML PATH('')),1,1,'')
	SELECT 
		employee_cd						AS	employee_cd	
	,	employee_nm						AS	employee_nm
	,	@rater_employee_nm_1_string		AS	rater_employee_nm_1_string
	FROM M0070
	WHERE M0070.company_cd	= @P_company_cd
	AND M0070.employee_cd	= @P_employee_cd
	AND M0070.del_datetime IS NULL
	--[3] -- SUPPOTER NAME
	IF @w_supporter_cd = '' -- IF SUPPOTER_CD = '' GET EMPLOYEE_CD LOGIN
	BEGIN
		SET @w_supporter_cd = @w_login_employee_cd
	END
	--
	SELECT 
		employee_cd			as	supporter_cd
	,	employee_nm			as	supporter_nm
	FROM M0070
	WHERE M0070.company_cd	= @P_company_cd
	AND M0070.employee_cd	= @w_supporter_cd
	AND M0070.del_datetime IS NULL
	--[4]
	SELECT 
		@w_permission				AS	permission
	,	@w_check_permission_msg		AS	check_permission_msg
END
GO
