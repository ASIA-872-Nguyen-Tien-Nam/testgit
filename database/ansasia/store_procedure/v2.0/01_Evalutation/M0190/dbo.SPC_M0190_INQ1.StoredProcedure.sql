DROP PROCEDURE [SPC_M0190_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ M0170
-- EXEC [SPC_M0190_INQ1] '1';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	REFER DATA
--*  
--*  作成日/create date			:	2018/09/17						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:  
--*　更新者/updater				:　
--*　更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_M0190_INQ1]
	@P_company_cd	SMALLINT = 0
,	@P_language		NVARCHAR(MAX)	=	'' 	--add tuyendn 2022/08/15
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@target_management_typ				AS	tinyint			= 0
	,	@evaluation_use_typ					AS	tinyint			= 0
	,	@interview_use_typ					AS	tinyint			= 0
	,	@feedback_use_typ					AS	tinyint			= 0
	,	@target_self_assessment_typ			AS	tinyint			= 0
	,	@target_evaluation_typ_1			AS	tinyint			= 0
	,	@target_evaluation_typ_2			AS	tinyint			= 0
	,	@target_evaluation_typ_3			AS	tinyint			= 0
	,	@target_evaluation_typ_4			AS	tinyint			= 0
	,	@evaluation_self_assessment_typ		AS	tinyint			= 0
	,	@evaluation_typ_1					AS	tinyint			= 0
	,	@evaluation_typ_2					AS	tinyint			= 0
	,	@evaluation_typ_3					AS	tinyint			= 0
	,	@evaluation_typ_4					AS	tinyint			= 0

	--
	SELECT	
		@target_management_typ				=	ISNULL(M0100.target_management_typ,0)
	,	@evaluation_use_typ					=	ISNULL(M0100.evaluation_use_typ,0)
	,	@interview_use_typ					=	ISNULL(M0100.interview_use_typ,0)
	,	@feedback_use_typ					=	ISNULL(M0100.feedback_use_typ,0)
	,	@target_self_assessment_typ			=	ISNULL(M0100.target_self_assessment_typ,0)
	,	@target_evaluation_typ_1			=	ISNULL(M0100.target_evaluation_typ_1,0)
	,	@target_evaluation_typ_2			=	ISNULL(M0100.target_evaluation_typ_2,0)
	,	@target_evaluation_typ_3			=	ISNULL(M0100.target_evaluation_typ_3,0)
	,	@target_evaluation_typ_4			=	ISNULL(M0100.target_evaluation_typ_4,0)
	,	@evaluation_self_assessment_typ		=	ISNULL(M0100.evaluation_self_assessment_typ,0)
	,	@evaluation_typ_1					=	ISNULL(M0100.evaluation_typ_1,0)
	,	@evaluation_typ_2					=	ISNULL(M0100.evaluation_typ_2,0)
	,	@evaluation_typ_3					=	ISNULL(M0100.evaluation_typ_3,0)
	,	@evaluation_typ_4					=	ISNULL(M0100.evaluation_typ_4,0)
	FROM M0100								
	WHERE 
		M0100.company_cd		=	@P_company_cd
	AND M0100.del_datetime IS NULL

	

	--[0] GET 1:目標管理
	SELECT
		ROW_NUMBER() OVER(ORDER BY L0040.status_cd ASC)		AS	row_num
	,	ISNULL(L0040.category,0)							AS	category
	,	ISNULL(L0040.status_cd,0)							AS	status_cd
	--add tuyendn 2022/08/08
	,	CASE
			WHEN	@P_language = 'en'
			THEN	ISNULL(L0040.status_nm_english,'')
			ELSE	ISNULL(L0040.status_nm,'')
		END													AS	status_nm
	,	ISNULL(M0310.status_nm,'')							AS	status_nm_item
	,	CASE WHEN		(@target_management_typ = 1		AND (L0040.status_cd <3 OR L0040.status_cd > 11 OR L0040.status_cd = 8))
					OR	 (@target_management_typ = 1	AND @feedback_use_typ = 1)
					OR	(@target_management_typ = 1		AND @target_self_assessment_typ	= 1		AND L0040.status_cd = 3)
					OR	(@target_management_typ = 1	AND @target_evaluation_typ_1		= 1		AND L0040.status_cd = 4)
					OR	(@target_management_typ = 1	AND @target_evaluation_typ_2		= 1		AND L0040.status_cd = 5)
					OR	(@target_management_typ = 1	AND @target_evaluation_typ_3		= 1		AND L0040.status_cd = 6)
					OR	(@target_management_typ = 1	AND @target_evaluation_typ_4		= 1		AND L0040.status_cd = 7)
					
			THEN 1
			ELSE 	ISNULL(M0310.status_use_typ,0)	
		END		AS	status_use_typ
	,	CASE 
			WHEN @target_management_typ = 0
			THEN 1
			WHEN @target_self_assessment_typ = 0 AND L0040.status_cd = 3 -- 自己評価
			THEN 1
			WHEN @target_evaluation_typ_1 = 0 AND L0040.status_cd = 4	--　一次評価
			THEN 1
			WHEN @target_evaluation_typ_2 = 0 AND L0040.status_cd = 5	--	二次評価
			THEN 1
			WHEN @target_evaluation_typ_3 = 0 AND L0040.status_cd = 6	--	三次評価
			THEN 1
			WHEN @target_evaluation_typ_4 = 0 AND L0040.status_cd = 7	--	四次評価
			THEN 1
			WHEN @feedback_use_typ = 0 AND (L0040.status_cd >=9 AND L0040.status_cd <= 11)
			THEN 1
			--WHEN M0310.status_use_typ = 0
			--THEN 1
			ELSE 0
		END													AS	disabled_status		-- 0.enabled 1.disabled
	FROM L0040
	LEFT OUTER JOIN M0310 ON(
		@P_company_cd				=	M0310.company_cd
	AND	L0040.category				=	M0310.category
	AND L0040.status_cd				=	M0310.status_cd
	)
	WHERE
		L0040.category	= 1			-- 1:目標管理
	AND	L0040.del_datetime IS NULL
	--[1] 
	SELECT
		ROW_NUMBER() OVER(ORDER BY L0040.status_cd ASC)		AS	row_num
	,	ISNULL(L0040.category,0)							AS	category
	,	ISNULL(L0040.status_cd,0)							AS	status_cd
	--add tuyendn 2022/08/08
	,	CASE
			WHEN	@P_language = 'en'
			THEN	ISNULL(L0040.status_nm_english,'')
			ELSE	ISNULL(L0040.status_nm,'')
		END													AS	status_nm
	,	ISNULL(M0310.status_nm,'')							AS	status_nm_item
	,	CASE WHEN		(@evaluation_use_typ = 1		AND (L0040.status_cd <1 OR L0040.status_cd > 9 OR L0040.status_cd = 6))
					OR	(@evaluation_use_typ = 1	AND @feedback_use_typ = 1)
					OR	(@evaluation_use_typ = 1	AND @evaluation_self_assessment_typ	= 1		AND L0040.status_cd = 1)
					OR	(@evaluation_use_typ = 1	AND @evaluation_typ_1		= 1		AND L0040.status_cd = 2)
					OR	(@evaluation_use_typ = 1	AND @evaluation_typ_2		= 1		AND L0040.status_cd = 3)
					OR	(@evaluation_use_typ = 1	AND @evaluation_typ_3		= 1		AND L0040.status_cd = 4)
					OR	(@evaluation_use_typ = 1	AND @evaluation_typ_4		= 1		AND L0040.status_cd = 5)
					
			THEN 1
			ELSE 	ISNULL(M0310.status_use_typ,0)	
		END		AS	status_use_typ
	,	CASE 
			WHEN @evaluation_use_typ = 0
			THEN 1
			WHEN @evaluation_self_assessment_typ = 0 AND L0040.status_cd = 1	-- 自己評価
			THEN 1
			WHEN @evaluation_typ_1 = 0 AND L0040.status_cd = 2	--　一次評価
			THEN 1
			WHEN @evaluation_typ_2 = 0 AND L0040.status_cd = 3	--	二次評価
			THEN 1
			WHEN @evaluation_typ_3 = 0 AND L0040.status_cd = 4	--	三次評価
			THEN 1
			WHEN @evaluation_typ_4 = 0 AND L0040.status_cd = 5	--	四次評価
			THEN 1
			WHEN @feedback_use_typ = 0 AND (L0040.status_cd >=7 AND L0040.status_cd <= 9)
			THEN 1
			--WHEN M0310.status_use_typ = 0
			--THEN 1
			ELSE 0
		END													AS	disabled_status		-- 0.enabled 1.disabled
	FROM L0040
	LEFT OUTER JOIN M0310 ON(
		@P_company_cd				=	M0310.company_cd
	AND	L0040.category				=	M0310.category
	AND L0040.status_cd				=	M0310.status_cd
	)
	WHERE
		L0040.category	= 2			-- 2:評価
	AND	L0040.del_datetime IS NULL
	--[2] 
	SELECT
		ROW_NUMBER() OVER(ORDER BY L0040.status_cd ASC)		AS	row_num
	,	ISNULL(L0040.category,0)							AS	category
	,	ISNULL(L0040.status_cd,0)							AS	status_cd
	--add tuyendn 2022/08/08
	,	CASE
			WHEN	@P_language = 'en'
			THEN	ISNULL(L0040.status_nm_english,'')
			ELSE	ISNULL(L0040.status_nm,'')
		END													AS	status_nm
	,	ISNULL(M0310.status_nm,'')							AS	status_nm_item
	--,	ISNULL(M0310.status_use_typ,0)						AS	status_use_typ
	,	CASE 
			WHEN 	L0040.status_cd = 12 AND M0100.feedback_use_typ = 0 
			THEN 0
			WHEN 	L0040.status_cd = 12 AND M0100.feedback_use_typ = 1
			THEN 1
			WHEN	L0040.status_cd > 1 AND L0040.status_cd < 12 AND M0100.interview_use_typ = 0
			THEN 0
			ELSE	M0310.status_use_typ
		END AS	status_use_typ
	,	CASE 
			WHEN ISNULL(M0310.status_cd,0) = 1	-- 1.期首面談
			THEN 0
			WHEN ISNULL(M0310.status_cd,L0040.status_cd) > 1 AND L0040_MAX.status_cd IS NOT NULL AND @feedback_use_typ = 0
			THEN 1
			WHEN ISNULL(M0310.status_cd,L0040.status_cd) > 1 AND ISNULL(M0310.status_cd,L0040.status_cd) < 12 AND @interview_use_typ = 0
			THEN 1
			ELSE 0
		END													AS	disabled_status		-- 0.enabled 1.disabled
	FROM L0040
	LEFT OUTER JOIN M0310 ON(
		@P_company_cd				=	M0310.company_cd
	AND	L0040.category				=	M0310.category
	AND L0040.status_cd				=	M0310.status_cd
	)
	LEFT OUTER JOIN (
		SELECT 
			MAX(ISNULL(L0040.status_cd,0))	AS	status_cd
		,	L0040.category					AS	category
		FROM L0040
		WHERE 
			L0040.category = 3
		AND L0040.del_datetime IS NULL
		GROUP BY
			L0040.category
	) AS L0040_MAX ON (
		L0040.category					=	L0040_MAX.category
	AND L0040.status_cd					=	L0040_MAX.status_cd
	)
	LEFT JOIN M0100 ON(
		@P_company_cd					=	M0100.company_cd
	)
	WHERE
		L0040.category	= 3			-- 3:期中面談
	AND	L0040.del_datetime IS NULL
	--[3]
	SELECT @target_management_typ AS	target_management_typ
END
