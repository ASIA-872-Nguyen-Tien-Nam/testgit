DROP PROCEDURE [SPC_DASHBOARD_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ [SPC_DASHBOARD_INQ1]
-- EXEC SPC_DASHBOARD_INQ1 '2018','1','794';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	DASHBOARD
--*  
--*  作成日/create date			:	2018/10/22				
--*　作成者/creater				:	Longvv								
--*   					
--*  更新日/update date			:	2019/05/27
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	update ver 1.5
--*   					
--*  更新日/update date			:	2020/02/14  
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	remove condition M0100.interview_use_typ = 1
--*   					
--*  更新日/update date			:	2020/02/18  
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	※本人が上司の場合は評価者用ダッシュボード、被評価者の場合は被評価者用ダッシュボードを表示。
--*   					
--*  更新日/update date			:	2020/04/28  
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	完了したシートを抜ける。
--*
--*  更新日/update date			:	2021/03/09  
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	change belong_cd1 from smallint -> nvrachar(20)
--*
--*  更新日/update date			:	2022/12/22  
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	人事評価機能の評価者権限としては、
--*									・今年度の評価シートはすべて閲覧可能
--*									・昨年度以前の評価シートは未完了のもののみ閲覧可能（評価完了したら閲覧できなくなる）
--*									としたいです。
-- 
--****************************************************************************************
CREATE PROCEDURE [SPC_DASHBOARD_INQ1]
	@P_company_cd				SMALLINT		=	0
,	@P_employee_cd				NVARCHAR(10)	=	''
,	@P_user_id					NVARCHAR(50)	=	''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_Date							DATE			=	GETDATE()
	,	@YEAR							SMALLINT		=	0
	,	@P_fiscal_year					SMALLINT		=	0
	,	@P_beginning_date				DATE			=	NULL
	,	@P_sheet_cd						SMALLINT		=	0
	,	@SUM_Status						INT				=	0
	,	@interview_use_typ				SMALLINT		=	0	--期首面談なし
	,	@evaluation_self_assessment		SMALLINT		=	0	--自己評価なし
	,	@status_cd						SMALLINT		=	0
	,	@count_status_cd0				INT				=	0
	,	@countAuthority					INT				=	0
	,	@arrange_order					INT				=	0
	,	@position_cd					INT      		=	0
	,	@P_authority_cd					SMALLINT		=	0
	,	@P_authority_typ				SMALLINT		=	0
	,	@employee_cd					NVARCHAR(20)	=	''
	,	@employee_login_typ				SMALLINT		=	0	-- 2.評価者 , 1.彼評価者
	,	@current_year					INT				=	dbo.FNC_GET_YEAR(@P_company_cd,NULL)	-- add by viettd 2022/12/22
	--
	--#TEMP_S0022
	CREATE TABLE #TEMP_S0022 (
		id					INT IDENTITY(1,1) NOT NULL
	,	belong_cd1			nvarchar(50)			-- edited by viettd 2021/03/09
	,	count_belong_cd2	INT
	)
	--
	CREATE TABLE #M0101(
		id						int			identity(1,1)
	,	detail_no				smallint
	,	period_nm				nvarchar(50)
	)
	--
	SELECT 
		@P_authority_cd			=	S0010.authority_cd
	,	@P_authority_typ		=	S0010.authority_typ
	,	@employee_cd			=	S0010.employee_cd
	,	@position_cd			=	ISNULL(M0070.position_cd,0)
	FROM S0010 
	LEFT JOIN M0070 ON (
		M0070.company_cd		=	S0010.company_cd
	AND M0070.employee_cd		=	S0010.employee_cd
	AND M0070.del_datetime		IS NULL 
	) 
	WHERE
		S0010.company_cd		=	@P_company_cd
	AND S0010.user_id			=	@P_user_id
	AND S0010.del_datetime IS NULL
	--
    SET @arrange_order	= ISNULL((
		SELECT ISNULL(M0040.arrange_order,0) FROM M0040 
		WHERE 
			M0040.company_cd	= @P_company_cd
		AND M0040.position_cd	= @position_cd
		AND	M0040.del_datetime IS NULL )
	,0)
	--
	--SET @interview_use_typ
	--IF EXISTS (SELECT 1 
	--			FROM M0100 
	--			WHERE 
	--				M0100.company_cd			=	@P_company_cd
	--			AND	M0100.interview_use_typ		=	1
	--			AND M0100.del_datetime IS NULL)
	--AND EXISTS (SELECT 1 
	--			FROM M0310 
	--			WHERE 
	--				M0310.company_cd		=	@P_company_cd
	--			AND	M0310.category			=	3 
	--			AND M0310.status_cd			=	1
	--			AND M0310.status_use_typ	=	1
	--			AND M0310.del_datetime IS NULL)
	--BEGIN
	--	SET @interview_use_typ	=	1						--	期首面談あり
	--END
	-- edited by viettd 2020/02/14
	IF EXISTS (SELECT 1 
				FROM M0310 
				WHERE 
					M0310.company_cd		=	@P_company_cd
				AND	M0310.category			=	3 
				AND M0310.status_cd			=	1
				AND M0310.status_use_typ	=	1
				AND M0310.del_datetime IS NULL)
	BEGIN
		SET @interview_use_typ	=	1						--	期首面談あり
	END
	--SET @evaluation_self_assessment
	IF EXISTS(	SELECT 1 
				FROM M0100 
				WHERE 
					M0100.company_cd						=	@P_company_cd
				AND	M0100.evaluation_self_assessment_typ	=	1
				AND M0100.del_datetime IS NULL)
	BEGIN
		SET @evaluation_self_assessment	=	1				--	自己評価あり
	END
	--settinng status_cd = 0 
	IF	@interview_use_typ	= 1 
	BEGIN	--	期首面談あり
		SELECT @status_cd			=	0		
	END
	ELSE
	BEGIN	--	期首面談なし
		IF @evaluation_self_assessment = 1
		BEGIN
			SELECT @status_cd		=	1	-- 自己評価あり
		END
		ELSE
		BEGIN
			SELECT @status_cd		=	2	-- 自己評価なし
		END
	END
	-- GET @P_fiscal_year
	SELECT 
		@P_beginning_date =	 M9100.beginning_date 
	FROM M9100 
	WHERE  
		M9100.company_cd = @P_company_cd 
	AND M9100.del_datetime IS NULL
	--
	SET	@YEAR =  YEAR(@w_Date)	
	IF (CAST(CONVERT(NVARCHAR(4),(@YEAR))+'-'+FORMAT(@P_beginning_date,'MM-dd') AS DATE) <=	@w_Date) OR @P_beginning_date IS NULL
	BEGIN
		SET @P_fiscal_year = @YEAR
	END
	ELSE
	BEGIN
		SET @P_fiscal_year = @YEAR-1 --fixed by yamazaki 2019.01.09 @YEAR+1⇒@YEAR-1
	END
	IF NOT EXISTS (SELECT 1 FROM F0010 WHERE F0010.fiscal_year = @P_fiscal_year AND F0010.company_cd = @P_company_cd)
	BEGIN
		SET @P_fiscal_year = (SELECT TOP 1 fiscal_year FROM F0010 
		                      WHERE (F0010.company_cd = @P_company_cd)
							    AND (F0010.del_datetime IS NULL)
							  ORDER BY F0010.fiscal_year DESC
							  )
	END
	--
	INSERT INTO #M0101
	SELECT 
		ISNULL(M0101.detail_no,0)			AS	detail_no
	,	ISNULL(M0101.period_nm,'')			AS	period_nm
	FROM M0101
	WHERE 
		M0101.company_cd		=	@P_company_cd
	AND M0101.del_datetime IS NULL
	--[0]
	SELECT 
		ISNULL(#M0101.detail_no,0)			AS	detail_no
	,	ISNULL(#M0101.period_nm,'')			AS	period_nm
	FROM #M0101
	--[1]
		EXEC [dbo].SPC_DASHBOARD_FND1 0,0,@P_company_cd,@P_fiscal_year,@P_user_id
	--[2]
	 SELECT 
		F0900.company_cd
	,	F0900.category
	,	F0900.status_cd
	,	F0900.infomationn_typ
	,	CASE
			WHEN	ISNULL(F0900.infomation_date,'') <> ''
			THEN	CONVERT(NVARCHAR(10),F0900.infomation_date,111)
			ELSE	NULL
		END			AS infomation_date
	,	F0900.target_employee_cd
	,	F0900.fiscal_year
	,	F0900.sheet_cd
	,	F0900.employee_cd
	,	M0070.employee_nm			AS target_employee_nm
	,	F0900.infomation_title		AS infomation_title
	,	F0900.infomation_message
	FROM F0900
	LEFT OUTER JOIN M0070 WITH(NOLOCK) ON(
		F0900.company_cd			=	M0070.company_cd
	AND	F0900.target_employee_cd	=	M0070.employee_cd
	AND	M0070.del_datetime			IS	NULL
	)
	WHERE 
		F0900.company_cd	=	@P_company_cd
	AND	F0900.employee_cd	=	@P_employee_cd	--Edit longvv  fix is 2019/02/18
	AND	F0900.confirmation_datetime	IS NULL
	AND	F0900.del_datetime	IS NULL
	ORDER BY 
		CASE 
			WHEN F0900.confirmation_datetime IS NULL 
			THEN 0
			ELSE 1
		END
	,	F0900.infomation_date	 DESC 
	,	F0900.target_employee_cd ASC
	--[3]
	-- add by viettd 2020/02/18
	IF EXISTS (SELECT 1 FROM F0100 
						LEFT OUTER JOIN M0200 ON (
							F0100.company_cd			=	M0200.company_cd
						AND F0100.sheet_cd				=	M0200.sheet_cd
						AND M0200.del_datetime IS NULL
						)
						WHERE 
							F0100.company_cd	=	@P_company_cd
						AND F0100.fiscal_year	=	@P_fiscal_year
						AND (
							F0100.rater_employee_cd_1	=	@P_employee_cd
						OR	F0100.rater_employee_cd_2	=	@P_employee_cd
						OR	F0100.rater_employee_cd_3	=	@P_employee_cd
						OR	F0100.rater_employee_cd_4	=	@P_employee_cd
						)
						-- edited by viettd 2022/12/22
						AND (
							-- 今年度の評価シートはすべて閲覧可能
							@P_fiscal_year >= @current_year	
						OR	(
							-- 昨年度以前の評価シートは未完了のもののみ閲覧可能（評価完了したら閲覧できなくなる）
								@P_fiscal_year < @current_year
								-- add by viettd 2020/04/28
								AND 
								(
									(M0200.sheet_kbn = 1 AND F0100.status_cd < 12)
								OR	(M0200.sheet_kbn = 2 AND F0100.status_cd < 10)	
								)
							)
						)
	)
	BEGIN
		SET @employee_login_typ = 2 -- 評価者
	END
	ELSE
	BEGIN
		SET @employee_login_typ = 1 -- 彼評価者
	END
	-- 
	SELECT 
		M0001.company_cd		AS company_cd 	
	,	M0001.company_nm		AS company_nm
	,	@employee_login_typ		AS employee_login_typ
	FROM M0001
	WHERE 
		M0001.company_cd	=	@P_company_cd
	AND	M0001.del_datetime	IS NULL
	--[4]
	SELECT @P_fiscal_year AS fiscal_year
	--DROP TABLE 
	DROP TABLE #TEMP_S0022
	DROP TABLE #M0101
END	
GO
