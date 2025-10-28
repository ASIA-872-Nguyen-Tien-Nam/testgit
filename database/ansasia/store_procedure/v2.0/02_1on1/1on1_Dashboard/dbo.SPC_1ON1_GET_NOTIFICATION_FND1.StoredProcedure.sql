DROP PROCEDURE [SPC_1ON1_GET_NOTIFICATION_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_1ON1_GET_NOTIFICATION_FND1 2020,1,740,'721',3
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	1ON1 GET LIST NOTIFICATION
--*  
--*  作成日/create date			:	2020/11/30				
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2021/04/01
--*　更新者/updater				:　	vietdt
--*　更新内容/update content		:	display data F2900
--*   					
--*  更新日/update date			:	2021/05/10
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	dont show 年間目標を設定してください when F2100 created
--*   							:	dont show 1on1日程が決まりました when F2200.fin_datetime_coach is not null
--*   	
--*  更新日/update date			:	2022/01/13
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	CR add permission of coach when [1on1_beginning_date] = NULL
--*   					
--*  更新日/update date			:	2022/08/18
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	update ver 1.9	
--*   					
--*  更新日/update date			:	2022/11/18
--*　更新者/updater				:	viettd
--*　更新内容/update content		:	fix maxlength
--*
--****************************************************************************************
CREATE PROCEDURE [SPC_1ON1_GET_NOTIFICATION_FND1]
	@P_company_cd				smallint		=	0	-- company_cd
,	@P_employee_cd				nvarchar(10)	=	''	-- login employee_cd
,	@P_information_typ			smallint		=	0	-- 1:リマインド 2:アラート 3:通知
,	@P_fiscal_year				smallint		=	0	-- 年度
,	@P_coach_member				smallint		=	0	-- screen 1 :coach , 2:member
,	@P_language					NVARCHAR(2)		= 'jp'

AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_date							date			=	GETDATE()
	,	@w_1on1_group_cd				smallint		=	0
	,	@w_beginning_date				date			=	NULL
	-- add by viettd 2021/05/10
	 CREATE TABLE #TABLE_INFORMATION (
		id						int		identity(1,1)
	,	infomation_typ			tinyint
	,	message_typ				tinyint
	,	infomation_title		nvarchar(50)
	,	target_employee_cd		nvarchar(10)
	,	target_employee_nm		nvarchar(20)
	,	infomation_date			date
	)
	--add vietdt 2022/01/13 get @w_beginning_date 
	SELECT 
		@w_beginning_date = M9100.[1on1_beginning_date] 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	--  F0900.infomation_typ = 3 (通知) & 1ON1
	IF @P_information_typ = 3
	BEGIN
		-- get @w_1on1_group_cd
		SELECT 
			@w_1on1_group_cd = ISNULL(F2000.[1on1_group_cd],0)
		FROM F2000 WITH(NOLOCK)
		WHERE 
			F2000.company_cd		=	@P_company_cd
		AND F2000.fiscal_year		=	@P_fiscal_year
		AND F2000.employee_cd		=	@P_employee_cd
		AND F2000.del_datetime IS NULL
		--[0]
		SELECT 
			ISNULL(F2900.infomation_title,'')						AS	infomation_title
		,	CASE 
				WHEN @P_language = 'en'
				THEN 'Times '+CAST(ISNULL(F2001.times,0) AS nvarchar(10))
				ELSE CAST(ISNULL(F2001.times,0) AS nvarchar(10)) + N'回目'
			END														AS	times
		,	FORMAT(M2620.deadline_date,'yyyy/MM/dd')				AS	deadline_date
		FROM F2900 WITH (NOLOCK)
		LEFT OUTER JOIN F2001 WITH(NOLOCK) ON (
			F2900.company_cd		=	F2001.company_cd
		AND F2900.fiscal_year		=	F2001.fiscal_year
		AND F2900.employee_cd		=	F2001.employee_cd
		AND F2001.del_datetime IS NULL
		)
		LEFT OUTER JOIN M2620 WITH(NOLOCK) ON (
			F2001.company_cd		=	M2620.company_cd
		AND F2001.fiscal_year		=	M2620.fiscal_year
		AND @w_1on1_group_cd		=	M2620.[1on1_group_cd]
		AND F2001.times				=	M2620.times
		AND M2620.del_datetime IS NULL
		)
		WHERE 
			F2900.company_cd		=	@P_company_cd
		AND F2900.employee_cd		=	@P_employee_cd
		AND F2900.infomation_typ	=	@P_information_typ
		AND F2900.del_datetime IS NULL
	END 
	--  F0900.infomation_typ = 1:リマインド 2:アラート
	ELSE
	BEGIN
		-- INSERT INFORMATION DATA INTO TABLE #TABLE_INFORMATION
		INSERT INTO #TABLE_INFORMATION
		SELECT 
			ISNULL(F2900.infomation_typ,0)			AS	infomation_typ
		,	ISNULL(F2900.message_typ,0)				AS	message_typ
		,	ISNULL(F2900.infomation_title,'')		AS	infomation_title
		,	ISNULL(F2900.target_employee_cd,'')		AS	target_employee_cd
		,	ISNULL(M0070.employee_nm,'')			AS	target_employee_nm
		,	F2900.infomation_date					AS	infomation_date
		FROM F2900 WITH (NOLOCK)
		LEFT OUTER JOIN M0070 WITH (NOLOCK) ON(
			F2900.company_cd			=	M0070.company_cd
		AND F2900.target_employee_cd	=	M0070.employee_cd
		)
		WHERE 
			F2900.company_cd		=	@P_company_cd
		AND F2900.employee_cd		=	@P_employee_cd
		AND F2900.infomation_typ	=	@P_information_typ
		--edited by vietdt 2021/04/01
		AND	( 
				(
					@P_coach_member = 1 --screen coach
				AND	F2900.target_employee_cd	<>	@P_employee_cd
				AND	F2900.employee_cd			=	@P_employee_cd
				--add vietdt 2022/01/13
				AND	@w_beginning_date IS NOT NULL
				)
			OR	(
					@P_coach_member = 2 --screen member
				AND	F2900.target_employee_cd	=	@P_employee_cd
				AND	F2900.employee_cd			=	@P_employee_cd
				)
			OR	@P_coach_member = 0	-- F2900.infomation_typ <> 1
			)
		--edited by vietdt 2021/04/01
		AND F2900.del_datetime IS NULL
		ORDER BY
			F2900.infomation_date DESC
		-- add by viettd 2021/05/10
		-- WHEN odashboardmember  (@P_coach_member = 2)
		IF @P_coach_member = 2
		BEGIN
			-- 1. CHECK [年間目標] IS INSTERED
			IF EXISTS (
				SELECT 1 FROM F2100 
				WHERE 
					F2100.company_cd	= @P_company_cd 
				AND F2100.fiscal_year	= @P_fiscal_year 
				AND F2100.employee_cd	= @P_employee_cd 
				AND F2100.del_datetime IS NULL 
				AND (
					ISNULL(F2100.target1,'') <> ''	-- WILL 
				OR	ISNULL(F2100.target2,'') <> ''	-- CAN
				OR	ISNULL(F2100.target3,'') <> ''	-- MUST
				)
			)
			BEGIN
				-- DELETE [年間目標を設定してください。] ROW
				DELETE D FROM #TABLE_INFORMATION AS D
				WHERE 
					D.infomation_typ	=	1
				AND D.message_typ		=	1
				--AND D.infomation_title	= '年間目標を設定してください。'
			END
			-- 2. CHECK [1on1日程が決まりました] F2200.fin_datetime_coach is not null
			DELETE D FROM #TABLE_INFORMATION AS D
			INNER JOIN F2200 ON (
				@P_company_cd			=	F2200.company_cd
			AND @P_fiscal_year			=	F2200.fiscal_year
			AND @P_employee_cd			=	F2200.employee_cd
			AND D.infomation_date		=	CAST(F2200.interview_date AS date)	
			)
			WHERE 
				F2200.company_cd	=	@P_company_cd
			AND F2200.fiscal_year	=	@P_fiscal_year
			AND F2200.del_datetime IS NULL
			AND F2200.fin_datetime_coach IS NOT NULL -- 1on1が終了
			AND D.message_typ		<>	1	-- 	年間目標
		END
		-- WHEN odashboard  (@P_coach_member = 1)
		IF @P_coach_member = 1
		BEGIN
			-- 2. CHECK [1on1日程が決まりました] F2200.fin_datetime_coach is not null
			DELETE D FROM #TABLE_INFORMATION AS D
			INNER JOIN F2200 ON (
				@P_company_cd			=	F2200.company_cd
			AND @P_fiscal_year			=	F2200.fiscal_year
			AND D.target_employee_cd	=	F2200.employee_cd
			AND D.infomation_date		=	CAST(F2200.interview_date AS date)	
			)
			WHERE 
				F2200.company_cd	=	@P_company_cd
			AND F2200.fiscal_year	=	@P_fiscal_year
			AND F2200.del_datetime IS NULL
			AND F2200.fin_datetime_coach IS NOT NULL -- 1on1が終了
			AND D.message_typ		<>	1	-- 	年間目標
		END
		--[0]
		SELECT 
			infomation_title
		,	target_employee_cd
		,	target_employee_nm
		,	FORMAT(ISNULL(infomation_date,''),'yyyy/MM/dd')		AS	infomation_date
		FROM #TABLE_INFORMATION
	END
END	
GO
