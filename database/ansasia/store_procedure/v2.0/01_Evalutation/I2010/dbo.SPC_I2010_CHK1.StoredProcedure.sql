DROP PROCEDURE [SPC_I2010_CHK1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- 
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	処遇用途内のシートの評価がすべて完了した場合、メッセージ148を表示する。
--*  
--*  作成日/create date			:	2021/11/16						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:　	
--*　更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_I2010_CHK1]
	@P_fiscal_year				int				=	0
,	@P_sheet_cd					smallint		=	0
,	@P_employee_cd				nvarchar(10)	=	''
,	@P_company_cd				smallint		=	0
,	@P_status_cd				smallint		=	0
,	@P_sheet_kbn				tinyint			=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@w_treatment_sheet_cnt			int				=	0
	,	@w_treatment_sheet_submited_cnt	int				=	0
	,	@w_evaluation_step				smallint		=	0
	--
	CREATE TABLE #F0032_OTHER_SHEET_CD (
		id							int				identity(1,1)
	,	company_cd					int
	,	fiscal_year					int
	,	employee_cd					nvarchar(10)
	,	sheet_cd					smallint
	)
	CREATE TABLE #F0032_TREAMENT_NO (
		id							int				identity(1,1)
	,	company_cd					int
	,	fiscal_year					int
	,	treatment_applications_no	smallint
	,	employee_cd					nvarchar(10)
	)
	CREATE TABLE #TABLE_MESS (
		message_cd					smallint
	,	message_typ					smallint
	,	message_nm					nvarchar(20)
	,	message						nvarchar(100)
	)
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	-- PROCESS
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	INSERT INTO #TABLE_MESS VALUES (0,0,SPACE(0),SPACE(0))
	--
	-- INSERT #F0032_TREAMENT_NO
	INSERT INTO #F0032_TREAMENT_NO
	SELECT 
		DISTINCT
		company_cd					
	,	fiscal_year					
	,	treatment_applications_no	
	,	employee_cd					
	FROM F0032
	WHERE 
		F0032.company_cd		=	@P_company_cd
	AND F0032.fiscal_year		=	@P_fiscal_year
	AND F0032.employee_cd		=	@P_employee_cd
	AND F0032.sheet_cd			=	@P_sheet_cd
	AND F0032.del_datetime IS NULL
	-- INSERT #F0032_OTHER_SHEET_CD
	INSERT INTO #F0032_OTHER_SHEET_CD
	SELECT 
		DISTINCT
		F0032.company_cd					
	,	F0032.fiscal_year					
	,	F0032.employee_cd					
	,	F0032.sheet_cd		
	FROM F0032
	INNER JOIN #F0032_TREAMENT_NO ON (
		F0032.company_cd						=	#F0032_TREAMENT_NO.company_cd
	AND F0032.fiscal_year						=	#F0032_TREAMENT_NO.fiscal_year
	AND F0032.treatment_applications_no			=	#F0032_TREAMENT_NO.treatment_applications_no
	AND F0032.employee_cd						=	#F0032_TREAMENT_NO.employee_cd
	)
	WHERE 
		F0032.company_cd			=	@P_company_cd
	AND F0032.fiscal_year			=	@P_fiscal_year
	AND F0032.employee_cd			=	@P_employee_cd
	AND F0032.sheet_cd				<>	@P_sheet_cd
	AND F0032.del_datetime IS NULL
	-- get @w_evaluation_step
	SET @w_evaluation_step = CASE 
								WHEN @P_sheet_kbn = 1 AND @P_status_cd = 4	-- ４：自己評価済。一次評価中。
								THEN 1
								WHEN @P_sheet_kbn = 1 AND @P_status_cd = 5	-- ５：一次評価済。二次評価中。
								THEN 2
								WHEN @P_sheet_kbn = 1 AND @P_status_cd = 6	-- ６：二次評価済。三次評価中。
								THEN 3
								WHEN @P_sheet_kbn = 1 AND @P_status_cd = 7	-- ７：三次評価済。四次評価中。
								THEN 4
								--
								WHEN @P_sheet_kbn = 2 AND @P_status_cd = 2	-- ２：自己評価済。一次評価中。
								THEN 1
								WHEN @P_sheet_kbn = 2 AND @P_status_cd = 3	-- ３：一次評価済。二次評価中。
								THEN 2
								WHEN @P_sheet_kbn = 2 AND @P_status_cd = 4	-- ４：二次評価済。三次評価中。
								THEN 3
								WHEN @P_sheet_kbn = 2 AND @P_status_cd = 5	-- ５：三次評価済。四次評価中。
								THEN 4
								ELSE 0 
							END
	-- CHECK MESS 148
	IF @w_evaluation_step >= 1 AND @w_evaluation_step <= 4
	BEGIN
		-- GET @w_treatment_sheet_cnt
		SELECT 
			@w_treatment_sheet_cnt = COUNT(#F0032_OTHER_SHEET_CD.sheet_cd)
		FROM #F0032_OTHER_SHEET_CD
		-- GET @w_treatment_sheet_submited_cnt
		SELECT 
			@w_treatment_sheet_submited_cnt = COUNT(F0120.sheet_cd)
		FROM #F0032_OTHER_SHEET_CD
		INNER JOIN F0120 ON (
			#F0032_OTHER_SHEET_CD.company_cd	=	F0120.company_cd
		AND #F0032_OTHER_SHEET_CD.fiscal_year	=	F0120.fiscal_year
		AND #F0032_OTHER_SHEET_CD.employee_cd	=	F0120.employee_cd
		AND #F0032_OTHER_SHEET_CD.sheet_cd		=	F0120.sheet_cd
		AND @w_evaluation_step					=	F0120.evaluation_step
		)
		WHERE 
			F0120.company_cd		=	@P_company_cd
		AND F0120.fiscal_year		=	@P_fiscal_year
		AND F0120.employee_cd		=	@P_employee_cd
		AND F0120.evaluation_step	=	@w_evaluation_step
		AND F0120.submit_datetime	IS NOT NULL	-- 確認済
		AND F0120.del_datetime IS NULL
		-- WHEN OTHER SHEET HAS DONE SUBMITED
		IF @w_treatment_sheet_cnt = @w_treatment_sheet_submited_cnt
		BEGIN
			UPDATE #TABLE_MESS SET 
				message_cd		= L0020.message_cd
			,	message_typ		= L0020.message_typ
			,	message_nm		= L0020.message_nm
			,	message			= L0020.message
			FROM L0020
			WHERE 
				L0020.message_cd = 148
		END
	END
	--[0]
	SELECT * FROM #TABLE_MESS
	-- DROP TABLE
	DROP TABLE #F0032_OTHER_SHEET_CD
	DROP TABLE #F0032_TREAMENT_NO
	DROP TABLE #TABLE_MESS
END
GO