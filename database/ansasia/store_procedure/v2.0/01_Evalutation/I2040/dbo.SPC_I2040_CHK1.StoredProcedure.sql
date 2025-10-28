DROP PROCEDURE [SPC_I2040_CHK1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ M0170
-- EXEC [SPC_I2040_LST1] '2018','6','a300','999';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	SHOW/HIDE ITEM 
--*  
--*  作成日/create date			:	2018/10/08						
--*　作成者/creater				:	dattnt								
--*   					
--*  更新日/update date			:	2022/08/16
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgrade 1.9
--*   					
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_I2040_CHK1]
	@P_employee_cd				nvarchar(10)	=	''
,	@P_fiscal_year				int				=	0
,	@P_login_employee_cd		nvarchar(20)	=	''
,	@P_cre_user					nvarchar(100)	=	''
,	@P_company_cd				smallint		=	0

AS
--select * from f0200 f0120 m0200
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@status_cd				smallint		=	0
	,	@authority_typ			smallint		=	0
	,	@login_user_typ			smallint		=	1	--	1. 被評価者用 2.評価者用
	,	@w_提出済状況			tinyint			=	0	--	0.未提出　1.提出済
	,	@w_承認済状況			tinyint			=	0	--	0.未承認　1.承認済
	--
	,	@w_rater_employee_cd_1	nvarchar(10)	=	''
	,	@w_rater_employee_cd_2	nvarchar(10)	=	''
	,	@w_rater_employee_cd_3	nvarchar(10)	=	''
	,	@w_rater_employee_cd_4	nvarchar(10)	=	''
	--
	--F0030 m0070 m0060 m0020 m0030 m0040 m0050 f0200 m0102
	CREATE TABLE #TABLE_RESULT(
		company_cd						smallint
	,	rater1_status					INT
	,	rater2_status					INT
	,	rater3_status					INT
	,	rater4_status					INT
	,	rater5_status					INT
	)
	--
	INSERT INTO #TABLE_RESULT VALUES(0,0,0,0,0,0)	
	-- GET @authority_typ
	SET @authority_typ = (SELECT ISNULL(S0010.authority_typ,0) FROM S0010 WHERE S0010.company_cd = @P_company_cd AND S0010.user_id = @P_cre_user)
	-- ↓↓↓　add by viettd 2022/08/16
	-- WHEN 6.管理者（評価者権限）THEN SET @authority_typ = 2.評価者
	IF @authority_typ = 6 
	BEGIN
		SET @authority_typ = 2	-- RATER
	END
	-- ↑↑↑　end add by viettd 2022/08/16
	-- GET 評価者
	SELECT 
		TOP 1
		@w_rater_employee_cd_1		=	ISNULL(F0030.rater_employee_cd_1,'')
	,	@w_rater_employee_cd_2		=	ISNULL(F0030.rater_employee_cd_2,'')
	,	@w_rater_employee_cd_3		=	ISNULL(F0030.rater_employee_cd_3,'')
	,	@w_rater_employee_cd_4		=	ISNULL(F0030.rater_employee_cd_4,'')
	FROM F0030
	WHERE
		F0030.company_cd			=	@P_company_cd
	AND F0030.fiscal_year			=	@P_fiscal_year
	AND F0030.employee_cd			=	@P_employee_cd
	AND F0030.del_datetime IS NULL
	
	IF @authority_typ = 2 AND @w_rater_employee_cd_1 = @P_login_employee_cd
	BEGIN
		SET @login_user_typ = 21 -- 21. 一次評価者
	END
	ELSE IF @authority_typ = 2 AND @w_rater_employee_cd_2 = @P_login_employee_cd
	BEGIN
		SET @login_user_typ = 22 -- 22. 一次評価者
	END
	ELSE IF @authority_typ = 2 AND @w_rater_employee_cd_3 = @P_login_employee_cd
	BEGIN
		SET @login_user_typ = 23 -- 23. 一次評価者
	END
	ELSE IF @authority_typ = 2 AND @w_rater_employee_cd_4 = @P_login_employee_cd
	BEGIN
		SET @login_user_typ = 24 -- 24. 一次評価者
	END
	ELSE IF @authority_typ = 3
	BEGIN
		SET @login_user_typ = 3  -- 3.管理者
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- 0: HIDE  1: ENABLED  2:DISBALE
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- STATUS = 0 : 初期状態
	IF @login_user_typ = 21
	BEGIN
		UPDATE #TABLE_RESULT SET 
			rater1_status					=	1		--	1:editable;	2: readonly; 0: hidden
	END
	ELSE IF @login_user_typ = 22
	BEGIN
		UPDATE #TABLE_RESULT SET 
			rater1_status					=	2		--	1:editable;	2: readonly; 0: hidden	
		,	rater2_status					=	1		--	1:editable;	2: readonly; 0: hidden
	END
	ELSE IF @login_user_typ = 23
	BEGIN
		UPDATE #TABLE_RESULT SET 
			rater1_status					=	2		--	1:editable;	2: readonly; 0: hidden
		,	rater2_status					=	2		--	1:editable;	2: readonly; 0: hidden
		,	rater3_status					=	1		--	1:editable;	2: readonly; 0: hidden
	END
	ELSE IF @login_user_typ = 24
	BEGIN
		UPDATE #TABLE_RESULT SET 
			rater1_status					=	2		--	1:editable;	2: readonly; 0: hidden
		,	rater2_status					=	2		--	1:editable;	2: readonly; 0: hidden
		,	rater3_status					=	2		--	1:editable;	2: readonly; 0: hidden
		,	rater4_status					=	1		--	1:editable;	2: readonly; 0: hidden
	END
	ELSE IF @login_user_typ = 3
	BEGIN
		UPDATE #TABLE_RESULT SET 
			rater1_status					=	2		--	1:editable;	2: readonly; 0: hidden
		,	rater2_status					=	2		--	1:editable;	2: readonly; 0: hidden
		,	rater3_status					=	2		--	1:editable;	2: readonly; 0: hidden
		,	rater4_status					=	2		--	1:editable;	2: readonly; 0: hidden
		,	rater4_status					=	1		--	1:editable;	2: readonly; 0: hidden
	END
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	SELECT * FROM #TABLE_RESULT
	--
	DROP TABLE #TABLE_RESULT
END
GO