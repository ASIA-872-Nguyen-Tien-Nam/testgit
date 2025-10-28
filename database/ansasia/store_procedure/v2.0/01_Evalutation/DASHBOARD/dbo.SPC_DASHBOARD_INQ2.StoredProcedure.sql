DROP PROCEDURE [SPC_DASHBOARD_INQ2]
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
-- 
--****************************************************************************************
CREATE PROCEDURE [SPC_DASHBOARD_INQ2]
	@P_company_cd				SMALLINT		=	0
,	@P_fiscal_year				SMALLINT		=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_Date							DATE			=	GETDATE()
	--
	
	CREATE TABLE #M0101(
		id						INT			IDENTITY(1,1)
	,	detail_no				SMALLINT
	,	period_nm				NVARCHAR(5)
	)
	--
	INSERT INTO #M0101
	SELECT 
		ISNULL(M0101.detail_no,0)			AS	detail_no
	,	ISNULL(M0101.period_nm,'')			AS	period_nm
	FROM F0011 
	INNER JOIN M0101 ON(
		F0011.company_cd				=	M0101.company_cd
	AND F0011.treatment_applications_no	=	M0101.detail_no
	AND M0101.del_datetime IS NULL
	)
	WHERE 
		F0011.company_cd		=	@P_company_cd
	AND F0011.fiscal_year		=	@P_fiscal_year
	AND F0011.use_typ			=	1
	AND F0011.del_datetime IS NULL
	--[0]
	SELECT 
		ISNULL(#M0101.detail_no,0)			AS	detail_no
	,	ISNULL(#M0101.period_nm,'')			AS	period_nm
	FROM #M0101
	--
	
END	
GO
