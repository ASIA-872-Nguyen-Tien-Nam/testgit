IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_OQ2020_LST1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_OQ2020_LST1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要	：	OQ2020
 *
 *  作成日	：	2020/10/26
 *  作成者	：	ANS-ASIA nghianm
 *
 *	更新日	：	2021/04/05
 *  更新者	：	ANS-ASIA vietdt
 *  更新内容	：	add decentralization				
 *
 *	更新日	：	2021/05/10
 *  更新者	：	ANS-ASIA vietdt
 *  更新内容	：	is 20210507 F2010.title => M2620.1on1_title
 *
 *	更新日	：	2021/05/17
 *  更新者	：	viettd
 *  更新内容	：	login user is not coach at times 
 *
 *	更新日	：	2021/05/28
 *  更新者	：	viettd
 *  更新内容	：	change permission of coach			
 *
 *	更新日	：	2022/01/11
 *  更新者	：	vietdt
 *  更新内容	：	cr add condition F2200.fullfillment_type,member_comment,coach_comment1		
 *
 *	更新日	：	2022/01/13
 *  更新者	：	vietdt
 *  更新内容	：	CR add permission of coach when [1on1_beginning_date] = NULL
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_OQ2020_LST1]
	@P_company_cd	SMALLINT		=	0
,	@P_fiscal_year	SMALLINT		=	0
,	@P_employee_cd	NVARCHAR(10)	=	''
,	@P_start_date	DATE			=	NULL
,	@P_finish_date	DATE			=	NULL
,	@P_time_to		SMALLINT		=	0
,	@P_time_from	SMALLINT		=	0
,	@P_cre_user		NVARCHAR(50)	=	''
AS
BEGIN
	SET NOCOUNT ON;
    --
	DECLARE
		@totalRecord					BIGINT			= 0
	,	@pageNumber						INT				= 0
	,	@count							SMALLINT		= 0
	,	@mark_type						SMALLINT		= 0
	,	@name_typ						SMALLINT		= 0
	,	@w_1on1_authority_typ			SMALLINT		= 0
	,	@login_employee_cd				NVARCHAR(10)	= ''
	,	@w_authority_oq2020				SMALLINT		= 0 -- edited by vietdt 2021/04/05
	,	@w_permission					SMALLINT		= 1	-- 0. not view,1. view , 2.edited
	--
	,	@w_login_user_is_coach			TINYINT			= 0 -- 0.not coach 1.is coach
	,	@w_user_is_coach_current_year	TINYINT			= 0 -- 0.not coach 1.is coach
	,	@w_fiscal_year_current			INT				=	[dbo].FNC_GET_YEAR_1ON1(@P_company_cd,NULL) -- add by viettd 2021/05/28
	--	add 2022/01/13
	,	@w_beginning_date				date			=	NULL
	--
	SET @P_start_date			=	IIF(@P_start_date = '1900-01-01' ,NULL,@P_start_date)
	SET @P_finish_date			=	IIF(@P_finish_date = '1900-01-01',NULL,@P_finish_date)
	--add vietdt 2022/01/13 get @w_beginning_date 
	SELECT 
		@w_beginning_date = M9100.[1on1_beginning_date] 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	--
	CREATE TABLE #F2001 (
		id							INT IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	times						SMALLINT
	,	coach_cd					NVARCHAR(10)
	,	coach_mn					NVARCHAR(200)
	,	interview_cd				SMALLINT
	,	adaption_date				DATE
	,	title						NVARCHAR(50)
	,	interview_date				DATETIME
	,	fullfillment_type			SMALLINT
	,	member_comment				NVARCHAR(400)
	,	coach_comment1				NVARCHAR(400)
	,	picture						NVARCHAR(20)		
	,	authority					smallint	-- 0.not view 1.only view 2.edited
	,	f2200_data_is_view			smallint	-- 0.not view 1.view
	)
	--
	CREATE TABLE #F2010 (
		id							INT IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	times						SMALLINT
	)
	--
	CREATE TABLE #F2200 (
		id							INT IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	times						SMALLINT
	)
	--
	SET @mark_type = (SELECT M2120.mark_type FROM M2120 WHERE M2120.company_cd = @P_company_cd AND M2120.del_datetime IS NULL)
	SET @name_typ  = ( CASE 
							WHEN @mark_type = 1 THEN 22
							WHEN @mark_type = 2 THEN 23
							WHEN @mark_type = 3 THEN 25
							WHEN @mark_type = 4 THEN 26
							WHEN @mark_type = 5 THEN 24
							ELSE 0
						END)
	--
	SELECT 
		@w_1on1_authority_typ	=	ISNULL(S0010.[1on1_authority_typ],0)
	,	@login_employee_cd		=	ISNULL(S0010.employee_cd,'')
	,	@w_authority_oq2020		=	ISNULL(S2021.authority,0)
	FROM S0010
	LEFT JOIN S2021 ON (
		S0010.company_cd			=	S2021.company_cd
	AND	S0010.[1on1_authority_cd]	=	S2021.authority_cd
	AND	'oQ2020'					=	S2021.function_id
	AND	S2021.del_datetime	IS NULL
	)
	WHERE 
		S0010.company_cd	= @P_company_cd 
	AND S0010.user_id		= @P_cre_user
	AND S0010.del_datetime IS NULL
	-- add by viettd 2021/05/17
	IF EXISTS (SELECT 1 
					FROM F2001 
					WHERE 
						F2001.company_cd	=	@P_company_cd
					AND F2001.fiscal_year	=	@P_fiscal_year
					AND F2001.employee_cd	=	@P_employee_cd
					AND F2001.coach_cd		=	@login_employee_cd
					AND F2001.del_datetime IS NULL
	)
	BEGIN
		SET @w_login_user_is_coach = 1	-- login user is coach of member
	END
	-- add by viettd 2021/05/28
	IF EXISTS (SELECT 1 
					FROM F2001 
					WHERE 
						F2001.company_cd	=	@P_company_cd
					AND F2001.fiscal_year	=	@w_fiscal_year_current
					AND F2001.employee_cd	=	@P_employee_cd
					AND F2001.coach_cd		=	@login_employee_cd
					AND F2001.del_datetime IS NULL
	)
	BEGIN
		SET @w_user_is_coach_current_year = 1	-- login user is coach of member at current year
	END
	--
	INSERT INTO #F2001
	SELECT
		F2001.company_cd
	,	F2001.fiscal_year
	,	F2001.employee_cd
	,	F2001.times
	,	F2001.coach_cd
	,	M0070.employee_nm
	,	F2001.interview_cd
	,	F2001.adaption_date
	,	M2620.[1on1_title]
	,	CASE
			WHEN F2200.interview_date IS NULL
			THEN F2010.[1on1_schedule_date]
			ELSE F2200.interview_date
		END
	--add vietdt  2022/01/11
	,	CASE
			WHEN F2200.submit_datetime_member IS NOT NULL
			THEN F2200.fullfillment_type
			ELSE NULL
		END
	,	CASE
			WHEN F2200.fin_datetime_member IS NOT NULL
			THEN F2200.member_comment
			ELSE ''
		END
	,	CASE
			WHEN F2200.fin_datetime_coach IS NOT NULL
			THEN F2200.coach_comment1
			ELSE ''
		END
	--add vietdt  2022/01/11
	,	L0010.remark1
	,	CASE
			--	総合管理者と会社管理者
			WHEN @w_1on1_authority_typ IN (4,5)	
			THEN 2
			--	管理者（oQ2020の2.更新可能と1.参照可能の権限を持っている人）
			WHEN @w_1on1_authority_typ = 3 AND @w_authority_oq2020 = 2
			THEN 2
			--	管理者（oQ2020の0.参照不可を持っている人）but is coach or member
			WHEN @w_1on1_authority_typ = 3 AND @w_authority_oq2020 IN(0,1) AND (@P_employee_cd	=	@login_employee_cd OR	F2001.coach_cd	=	@login_employee_cd)
			THEN 2 
			WHEN @w_1on1_authority_typ = 3 AND @w_authority_oq2020 = 1
			THEN 1
			-- coach or member
			WHEN @w_1on1_authority_typ NOT IN (3,4,5) AND (@P_employee_cd	=	@login_employee_cd OR	F2001.coach_cd	=	@login_employee_cd)
			THEN 2
			ELSE 0
		END										AS	authority
	,	0										AS	f2200_data_is_view
	FROM F2001
	LEFT JOIN F2010 ON (
		F2001.company_cd	= F2010.company_cd
	AND F2001.fiscal_year	= F2010.fiscal_year 
	AND F2001.employee_cd	= F2010.employee_cd 
	AND F2001.times			= F2010.times 
	AND F2010.del_datetime IS NULL
	)
	LEFT JOIN F2200 ON (
		F2001.company_cd	= F2200.company_cd
	AND F2001.fiscal_year	= F2200.fiscal_year 
	AND F2001.employee_cd	= F2200.employee_cd 
	AND F2001.times			= F2200.times 
	AND F2001.interview_cd	= F2200.interview_cd 
	AND F2001.adaption_date	= F2200.adaption_date 
	AND F2200.del_datetime IS NULL
	)
	LEFT JOIN M2121 ON (
		F2001.company_cd	= M2121.company_cd
	AND M2121.mark_typ		=	@mark_type
	AND F2200.fullfillment_type	=	M2121.mark_cd
	AND M2121.del_datetime IS NULL
	--add vietdt  2022/01/11
	AND	F2200.submit_datetime_member IS NOT NULL
	)
	LEFT JOIN L0010  ON(
		M2121.mark_cd		=	L0010.number_cd	
	AND L0010.name_typ		=	@name_typ
	AND L0010.del_datetime IS NULL	
	)
	LEFT JOIN M0070 ON (
		F2001.company_cd	= M0070.company_cd
	AND	F2001.coach_cd		= M0070.employee_cd 
	AND M0070.del_datetime IS NULL
	)
	--edited by vietdt 2021/05/10
	LEFT JOIN F2000 ON (
		F2001.company_cd	= F2000.company_cd
	AND F2001.fiscal_year	= F2000.fiscal_year 
	AND F2001.employee_cd	= F2000.employee_cd 
	AND	F2000.del_datetime	IS NULL
	)
	LEFT JOIN M2620 ON (
		F2001.company_cd		= M2620.company_cd
	AND F2001.fiscal_year		= M2620.fiscal_year 
	AND F2000.[1on1_group_cd]	= M2620.[1on1_group_cd]
	AND F2001.times				= M2620.times 
	AND M2620.del_datetime IS NULL
	)
	--edited by vietdt 2021/05/10
	WHERE F2001.company_cd = @P_company_cd
	AND	F2001.fiscal_year = @P_fiscal_year
	AND	F2001.employee_cd = @P_employee_cd
	AND 
		(	@P_start_date IS NULL
		OR	@P_start_date <= CASE
								WHEN F2200.interview_date IS NULL
								THEN F2010.[1on1_schedule_date]
								ELSE F2200.interview_date
							END
		)
	AND 
		(	@P_finish_date IS NULL
		OR	@P_finish_date >= CASE
								WHEN F2200.interview_date IS NULL
								THEN F2010.[1on1_schedule_date]
								ELSE F2200.interview_date
							END
		)
	AND 
		(	@P_time_from = 0
		OR	F2001.times >= @P_time_from)
	AND 
		(	@P_time_to = 0
		OR	F2001.times <= @P_time_to)
	AND	F2001.del_datetime IS NULL
	--add vietdt 2022/01/13
	AND (
		(@w_1on1_authority_typ = 2 AND @w_beginning_date IS NOT NULL)
	OR	@w_1on1_authority_typ <> 2
	)
	-- add by viettd 2021/05/17
	-- IF F2200.fin_datetime_coach IS NOT NULL THEN SET f2200_data_is_view = 1
	UPDATE #F2001 SET 
		f2200_data_is_view	 =	1	-- 1.view	
	FROM #F2001
	INNER JOIN F2200 ON (
		#F2001.company_cd	= F2200.company_cd
	AND #F2001.fiscal_year	= F2200.fiscal_year 
	AND #F2001.employee_cd	= F2200.employee_cd 
	AND #F2001.times		= F2200.times 
	)
	WHERE 
		F2200.company_cd		=	@P_company_cd
	AND F2200.fiscal_year		=	@P_fiscal_year
	AND F2200.fin_datetime_coach IS NOT NULL
	AND F2200.del_datetime IS NULL
	-- IF #F2001.authority = 2 THEN f2200_data_is_view = 1
	UPDATE #F2001 SET 
		f2200_data_is_view = 1
	FROM #F2001
	WHERE 
		#F2001.authority	=	2 -- 2.can edited
	-- CHECK LOGIN USER IS COACH OF MEMBER BUT NOT COACH THIS TIMES
	IF @w_login_user_is_coach = 1
	BEGIN
		UPDATE #F2001 SET 
			authority	=	1	--	1.only view
		FROM #F2001
		WHERE
			authority = 0 -- LOGIN IS NOT COACH OF TIMES
	END
	-- IF F2200.interview_date IS NOT NULL THEN CAN ONLY VIEW
	UPDATE #F2001 SET 
		authority	=	1	
	FROM #F2001
	INNER JOIN F2200 ON (
		#F2001.company_cd	= F2200.company_cd
	AND #F2001.fiscal_year	= F2200.fiscal_year 
	AND #F2001.employee_cd	= F2200.employee_cd 
	AND #F2001.times		= F2200.times 
	)
	WHERE 
		F2200.company_cd		=	@P_company_cd
	AND F2200.fiscal_year		=	@P_fiscal_year
	--AND F2200.interview_date IS NOT NULL
	AND	F2200.submit_datetime_member IS NOT NULL
	AND F2200.del_datetime IS NULL
	-- add by viettd 2021/05/28
	-- when part year : if login user is coach at current year and at min 1 times of @P_fiscal_year
	IF @P_fiscal_year < @w_fiscal_year_current AND @w_user_is_coach_current_year = 1 AND @w_login_user_is_coach = 1
	BEGIN
		UPDATE #F2001 SET 
			authority = 2	-- 2.can edited
		FROM #F2001
	END
	--check permission
	IF EXISTS (SELECT 1 FROM #F2001 WHERE employee_cd = @login_employee_cd OR coach_cd = @login_employee_cd)
	BEGIN
		SET @w_permission	=	2
	END
	ELSE
	BEGIN
		--
		IF	@w_1on1_authority_typ IN (4,5)
		BEGIN
			SET @w_permission = 2
		END
		--
		IF	@w_1on1_authority_typ = 3  AND @w_authority_oq2020 = 2
		BEGIN
			SET @w_permission = 2
		END
	END
	--[0]
	SELECT
		company_cd
	,	fiscal_year
	,	employee_cd
	,	times
	,	coach_cd
	,	coach_mn
	,	interview_cd
	,	adaption_date
	,	title
	,	FORMAT(interview_date,'yyyy/MM/dd') AS	interview_date 
	,	fullfillment_type
	,	member_comment
	,	coach_comment1
	,	picture
	,	authority
	,	f2200_data_is_view
	FROM #F2001
	ORDER BY 
		company_cd
	,	fiscal_year
	,	times
	--[1]
	SELECT @w_permission	AS permission
	-- clean
	DROP TABLE #F2001
	DROP TABLE #F2010
	DROP TABLE #F2200
END
GO
