DROP PROCEDURE [SPC_M0170_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ M0170
-- EXEC [SPC_M0170_INQ1] '','';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	M0170
--*  
--*  作成日/create date			:	2018/09/14						
--*　作成者/creater				:	Tuantv								
--*   					
--*  更新日/update date			:  
--*　更新者/updater				:　
--*　更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_M0170_INQ1]
	@P_company_cd	SMALLINT = 0
,	@P_sheet_cd		SMALLINT = 0
AS
BEGIN
	CREATE TABLE #TEMP
	(
		company_cd						SMALLINT
	,	sheet_cd						SMALLINT
	,	evaluation_count				INT
	,	colspan							INT			
	)

	INSERT INTO #TEMP 
	SELECT 
		@P_company_cd
	,	@P_sheet_cd
	,	M0200.self_assessment_comment_display_typ + M0200.point_criteria_display_typ
	,	M0200.item_display_typ_1 + M0200.item_display_typ_2 + M0200.item_display_typ_3 +weight_display_typ
	FROM M0200
	WHERE M0200.company_cd  = @P_company_cd
	AND M0200.sheet_cd		= @P_sheet_cd
	AND M0200.del_datetime IS NULL


	--select '#TEMP',* from #TEMP
	--[0]
	SELECT 
		M0200.company_cd
	,	M0200.sheet_cd
	,	ISNULL(M0200.sheet_kbn,0)								AS sheet_kbn
	,	ISNULL(M0200.sheet_nm,'')								AS sheet_nm
	,	ISNULL(M0200.sheet_ab_nm,'')							AS sheet_ab_nm
	,	ISNULL(M0200.category,0)								AS category
	,	ISNULL(M0200.evaluation_period,0)						AS evaluation_period
	,	ISNULL(M0200.point_kinds,0)								AS point_kinds
	,	ISNULL(M0200.point_calculation_typ1,0)					AS point_calculation_typ1
	,	ISNULL(M0200.point_calculation_typ2,0)					AS point_calculation_typ2
	,	ISNULL(M0200.evaluation_self_typ,0)						AS evaluation_self_typ
	,	ISNULL(M0200.details_feedback_typ,0)					AS details_feedback_typ
	,	ISNULL(M0200.comments_feedback_typ,0)					AS comments_feedback_typ
	,	ISNULL(M0200.upload_file,'')							AS upload_file
	,	ISNULL(M0200.upload_file_nm, '')						AS upload_file_nm
	,	ISNULL(M0200.goal_number,0)								AS goal_number
	,	ISNULL(M0200.generic_comment_display_typ_1,0)			AS generic_comment_display_typ_1
	,	ISNULL(M0200.generic_comment_title_1,'')				AS generic_comment_title_1
	,	ISNULL(M0200.generic_comment_1,'')						AS generic_comment_1
	,	ISNULL(M0200.generic_comment_display_typ_2,0)			AS generic_comment_display_typ_2
	,	ISNULL(M0200.generic_comment_title_2,'')				AS generic_comment_title_2
	,	ISNULL(M0200.generic_comment_2,'')						AS generic_comment_2
	,	ISNULL(M0200.generic_comment_display_typ_3,0)			AS generic_comment_display_typ_3
	,	ISNULL(M0200.generic_comment_title_3,'')				AS generic_comment_title_3
	,	ISNULL(M0200.generic_comment_display_typ_4,0)			AS generic_comment_display_typ_4
	,	ISNULL(M0200.generic_comment_title_4,'')				AS generic_comment_title_4
	,	ISNULL(M0200.generic_comment_display_typ_5,0)			AS generic_comment_display_typ_5
	,	ISNULL(M0200.generic_comment_title_5,'')				AS generic_comment_title_5
	,	ISNULL(M0200.generic_comment_display_typ_6,0)			AS generic_comment_display_typ_6
	,	ISNULL(M0200.generic_comment_title_6,'')				AS generic_comment_title_6
	,	ISNULL(M0200.generic_comment_display_typ_7,0)			AS generic_comment_display_typ_7
	,	ISNULL(M0200.generic_comment_title_7,'')				AS generic_comment_title_7
	,	ISNULL(M0200.generic_comment_display_typ_8,0)			AS generic_comment_display_typ_8
	,	ISNULL(M0200.generic_comment_title_8,'')				AS generic_comment_title_8
	,	ISNULL(M0200.generic_comment_8,'')						AS generic_comment_8
	,	ISNULL(M0200.item_display_typ_1,0)						AS item_display_typ_1
	,	ISNULL(M0200.item_title_1,'')							AS item_title_1
	,	ISNULL(M0200.item_display_typ_2,0)						AS item_display_typ_2
	,	ISNULL(M0200.item_title_2,'')							AS item_title_2
	,	ISNULL(M0200.item_display_typ_3,0)						AS item_display_typ_3
	,	ISNULL(M0200.item_title_3,'')							AS item_title_3
	,	ISNULL(M0200.item_display_typ_4,0)						AS item_display_typ_4
	,	ISNULL(M0200.item_title_4,'')							AS item_title_4 
	,	ISNULL(M0200.item_display_typ_5,0)						AS item_display_typ_5
	,	ISNULL(M0200.item_title_5,'')							AS item_title_5
	,	ISNULL(M0200.weight_display_typ,0)						AS weight_display_typ
	,	ISNULL(M0200.challenge_level_display_typ,0)				AS challenge_level_display_typ
	,	ISNULL(M0200.detail_self_progress_comment_display_typ,0)AS detail_self_progress_comment_display_typ
	,	ISNULL(M0200.progress_comment_display_typ,0)			AS progress_comment_display_typ
	,	ISNULL(M0200.progress_comment_title,'')					AS progress_comment_title
	,	ISNULL(M0200.detail_self_progress_comment_title,'')		AS detail_self_progress_comment_title
	,	ISNULL(M0200.detail_progress_comment_display_typ,0)		AS detail_progress_comment_display_typ
	,	ISNULL(M0200.detail_progress_comment_title,'')			AS detail_progress_comment_title
	,	ISNULL(M0200.self_progress_comment_display_typ,0)		AS self_progress_comment_display_typ
	,	ISNULL(M0200.self_progress_comment_title,'')				AS self_progress_comment_title
	,	ISNULL(M0200.evaluation_display_typ,0)					AS evaluation_display_typ
	,	ISNULL(M0200.detail_comment_display_typ_0,0)			AS detail_comment_display_typ_0
	,	ISNULL(M0200.detail_comment_display_typ_1,0)			AS detail_comment_display_typ_1
	,	ISNULL(M0200.detail_comment_display_typ_2,0)			AS detail_comment_display_typ_2
	,	ISNULL(M0200.detail_comment_display_typ_3,0)			AS detail_comment_display_typ_3
	,	ISNULL(M0200.detail_comment_display_typ_4,0)			AS detail_comment_display_typ_4
	,	ISNULL(M0200.total_score_display_typ,0)					AS total_score_display_typ
	,	ISNULL(M0200.point_criteria_display_typ,0)				AS point_criteria_display_typ
	,	ISNULL(M0200.challengelevel_criteria_display_typ,0)		AS challengelevel_criteria_display_typ
	,	ISNULL(M0200.self_assessment_comment_display_typ,0)		AS self_assessment_comment_display_typ
	,	ISNULL(M0200.evaluation_comment_display_typ,0)			AS evaluation_comment_display_typ
	,	ISNULL(M0200.arrange_order,0)							AS arrange_order
	,	(M0200.generic_comment_display_typ_1 + M0200.generic_comment_display_typ_2 + M0200.generic_comment_display_typ_3+ 
		M0200.generic_comment_display_typ_4 + M0200.generic_comment_display_typ_5)			AS generic_count
	,	#TEMP.evaluation_count									AS evaluation_count
	,	#TEMP.colspan											AS colspan
	,	CASE 
			WHEN ISNULL(M0200.upload_file,'') <> ''
			THEN '/uploads/m0170/'+CONVERT(NVARCHAR(10),M0200.company_cd)+'/'+ISNULL(M0200.upload_file,'')	
			ELSE ''
		END			AS file_address
	FROM M0200 WITH(NOLOCK)	
	LEFT JOIN M0120 ON (
		M0200.company_cd	= M0120.company_cd
	AND	M0200.point_kinds	= M0120.point_kinds
	)
	LEFT JOIN #TEMP ON (
		M0200.company_cd	= #TEMP.company_cd
	AND	M0200.sheet_cd		= #TEMP.sheet_cd
	)
	WHERE 
		M0200.company_cd	= @P_company_cd
	AND M0200.sheet_cd		= @P_sheet_cd
	AND M0200.sheet_kbn		= 2
	AND M0200.del_datetime IS NULL
	
	--[1]
	SELECT 
		M0201.company_cd
	,	M0201.sheet_cd
	,	M0201.item_no
	,	ISNULL(M0201.item_detail_1,'')		AS item_detail_1
	,	ISNULL(M0201.item_detail_2,'')		AS item_detail_2
	,	ISNULL(M0201.item_detail_3,'')		AS item_detail_3
	,	ISNULL(weight,0)					AS weight
	FROM M0200
	LEFT JOIN M0201 ON (
		M0200.company_cd = M0201.company_cd
	AND	M0200.sheet_cd	 = M0201.sheet_cd
	)
	WHERE 
		M0200.company_cd	= @P_company_cd
	AND M0200.sheet_cd		= @P_sheet_cd
	AND M0200.sheet_kbn		= 2
	AND M0200.del_datetime IS NULL
	AND M0201.del_datetime IS NULL

END
GO
