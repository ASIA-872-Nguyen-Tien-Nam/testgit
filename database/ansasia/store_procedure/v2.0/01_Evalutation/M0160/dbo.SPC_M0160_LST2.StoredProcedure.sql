DROP PROCEDURE [SPC_M0160_LST2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC SPC_M0160_LST1 '','1','16','1'
--****************************************************************************************
--*   											
--*  �����T�v/process overview	:	M0160_�ڕW�Ǘ��V�[�g�}�X�^
--*  
--*  �쐬��/create date			:	2018/09/03						
--*�@�쐬��/creater				:	sondh								
--*   					
--*  �X�V��/update date			:	2018/11/20
--*�@�X�V��/updater				:�@	Longvv-longvv@ans-asia.com
--*�@�X�V���e/update content		:	���p�̃A���_�[�o�[�u_�v�Ō���
--*   					
--*  �X�V��/update date			:	2021/09/06
--*�@�X�V��/updater				:�@	viettd
--*�@�X�V���e/update content		:	move item �i���R�����g
--*
--****************************************************************************************
CREATE PROCEDURE [SPC_M0160_LST2]
	@P_company_cd		SMALLINT	= 0
,	@P_number_of_row	INT			= 0
,	@P_sheet_cd			INT			= 0
,	@P_language			NVARCHAR(2) = ''   --add tuyendn 22/08/24
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
	@i							INT		=  1
 ,	@check_challenge_level		INT		= 0
   IF EXISTS(SELECT 1 FROM M0110 WHERE del_datetime IS NULL AND company_cd = @P_company_cd)
	BEGIN
		SET @check_challenge_level = 1
	END
	ELSE
	BEGIN
		SET @check_challenge_level = 0
	END
	--
	CREATE TABLE #RESULT (
		row_no									SMALLINT
	,	item_title								NVARCHAR(400)
	,	item_title_title						NVARCHAR(100)
	,	item_title_1							NVARCHAR(100)
	,	item_title_2							NVARCHAR(100)
	,	item_title_3							NVARCHAR(100)
	,	item_title_4							NVARCHAR(100)
	,	item_title_5							NVARCHAR(100)
	,	item_title_display_typ					SMALLINT
	,	item_display_typ_1						SMALLINT
	,	item_display_typ_2						SMALLINT
	,	item_display_typ_3						SMALLINT
	,	item_display_typ_4						SMALLINT
	,	item_display_typ_5						SMALLINT
	,	point_calculation_typ1					SMALLINT
	,	point_calculation_typ2					SMALLINT
	,	weight_display_typ						SMALLINT
	,	challenge_level_display_typ				SMALLINT
	,	detail_progress_comment_display_typ		SMALLINT
	,	progress_comment_display_typ			SMALLINT
	,	evaluation_display_typ					SMALLINT
	,	detail_comment_display_typ_0			SMALLINT
	,	detail_comment_display_typ_1			SMALLINT
	,	detail_comment_display_typ_2			SMALLINT
	,	detail_comment_display_typ_3			SMALLINT
	,	detail_comment_display_typ_4			SMALLINT
	,	col_span								INT
	,	total_score_display_typ					TINYINT		-- add by viettd 2021/09/06
	--
	,	detail_self_progress_comment_display_typ	SMALLINT
	,	detail_self_progress_comment_title			NVARCHAR(100)
	,	detail_progress_comment_title				NVARCHAR(100)
	)
	WHILE @i <= @P_number_of_row
	BEGIN
		INSERT INTO #RESULT
		SELECT TOP 1
			@i
		,	''		--item_title
		,	CASE 
				WHEN @P_language = 'en'
				THEN
					N'Objective Title'
				ELSE  
					N'目標タイトル'
			END 
		,	CASE 
				WHEN @P_language = 'en'
				THEN
					N'Objective Title 1'
				ELSE  
					N'目標タイトル１'
			END 
		,	CASE 
				WHEN @P_language = 'en'
				THEN
					N'Objective Title 2'
				ELSE  
					N'目標タイトル２'
			END 
		,	CASE 
				WHEN @P_language = 'en'
				THEN
					N'Objective Title 3'
				ELSE  
					N'目標タイトル3'
			END 
		,	CASE 
				WHEN @P_language = 'en'
				THEN
					N'Objective Title 4'
				ELSE  
					N'目標タイトル4'
			END 
		,	CASE 
				WHEN @P_language = 'en'
				THEN
					N'Objective Title 5'
				ELSE  
					N'目標タイトル5'
			END 
	
		,	1	--item_title_display_typ		
		,	1	--item_display_typ_1			
		,	1	--item_display_typ_2			
		,	1	--item_display_typ_3			
		,	1	--item_display_typ_4			
		,	1	--item_display_typ_5	
		,	1
		,	1
		,	1	--weight_display_typ			
		,	1	--challenge_level_display_typ	
		,	1	--progress_comment_display_typ
		,	1	--progress_comment_display_typ
		,	1	--evaluation_display_typ		
		,	1	--detail_comment_display_typ_0
		,	1	--detail_comment_display_typ_1
		,	1	--detail_comment_display_typ_2
		,	1	--detail_comment_display_typ_3
		,	1	--detail_comment_display_typ_4
		,	10	-- col_span	edited by viettd 2021/09/06
		,	1	-- total_score_display_typ
		,	1--detail_self_progress_comment_display_typ
		,	CASE 
				WHEN @P_language = 'en'
				THEN
					N'Progress Comments (By Employee)'
				ELSE  
					'自己進捗コメント(項目別)' --detail_self_progress_comment_title
			END 
		,	CASE 
				WHEN @P_language = 'en'
				THEN
					N'Progress Comments (By Evaluation)'
				ELSE  
					'評価者進捗コメント(項目別)' --detail_progress_comment_title
			END 
		
		---------------------
		SET @i = @i + 1
	END
	IF EXISTS (SELECT 1 FROM M0200 WHERE company_cd = @P_company_cd AND sheet_cd = @P_sheet_cd AND del_datetime IS NULL)
	BEGIN
		UPDATE #RESULT
		SET
			#RESULT.item_title_title			=	ISNULL(M0200.item_title_title,'')
		,	item_title_1						=	M0200.item_title_1
		,	item_title_2						=	M0200.item_title_2
		,	item_title_3						=	M0200.item_title_3
		,	item_title_4						=	M0200.item_title_4
		,	item_title_5						=	M0200.item_title_5
		,	item_title_display_typ				=	ISNULL(M0200.item_title_display_typ,0)												
		,	item_display_typ_1					=	ISNULL(M0200.item_display_typ_1,0)													
		,	item_display_typ_2					=	ISNULL(M0200.item_display_typ_2,0)													
		,	item_display_typ_3					=	ISNULL(M0200.item_display_typ_3,0)													
		,	item_display_typ_4					=	ISNULL(M0200.item_display_typ_4,0)													
		,	item_display_typ_5					=	ISNULL(M0200.item_display_typ_5,0)	
		,	point_calculation_typ1				=	ISNULL(M0200.point_calculation_typ1,0)
		,	point_calculation_typ2				=	ISNULL(M0200.point_calculation_typ2,0)
		,	weight_display_typ					=	ISNULL(M0200.weight_display_typ,0)													
		,	challenge_level_display_typ			=	ISNULL(M0200.challenge_level_display_typ,0)											
		,	detail_progress_comment_display_typ	=	ISNULL(M0200.detail_progress_comment_display_typ,0)
		,	progress_comment_display_typ		=	ISNULL(M0200.progress_comment_display_typ,0)
		,	evaluation_display_typ				=	ISNULL(M0200.evaluation_display_typ,0)												
		,	detail_comment_display_typ_0		=	ISNULL(M0200.detail_comment_display_typ_0,0)										
		,	detail_comment_display_typ_1		=	ISNULL(M0200.detail_comment_display_typ_1,0)										
		,	detail_comment_display_typ_2		=	ISNULL(M0200.detail_comment_display_typ_2,0)										
		,	detail_comment_display_typ_3		=	ISNULL(M0200.detail_comment_display_typ_3,0)										
		,	detail_comment_display_typ_4		=	ISNULL(M0200.detail_comment_display_typ_4,0)
		,	col_span							=	( 
														M0200.item_title_display_typ		-- add by viettd 2021/09/06 
													+	M0200.item_display_typ_1 
													+	M0200.item_display_typ_2 
													+	M0200.item_display_typ_3 
													+	M0200.item_display_typ_4 
													+	M0200.item_display_typ_5 
													+	M0200.weight_display_typ 
													+	M0200.challenge_level_display_typ 
													+	M0200.detail_self_progress_comment_display_typ 
													+	M0200.detail_progress_comment_display_typ
													)						
		,	total_score_display_typ				=	ISNULL(M0200.total_score_display_typ,0)
		--
		,	detail_self_progress_comment_display_typ = ISNULL(M0200.detail_self_progress_comment_display_typ, 0)
		,	detail_self_progress_comment_title = ISNULL(M0200.detail_self_progress_comment_title, '')
		,	detail_progress_comment_title = ISNULL(M0200.detail_progress_comment_title, '')
		FROM #RESULT 
		INNER JOIN M0200 ON(
			@P_company_cd	=	M0200.company_cd
		AND @P_sheet_cd		=	M0200.sheet_cd
		AND M0200.del_datetime IS NULL
		)
	END
	IF EXISTS (SELECT 1 FROM M0201 WHERE company_cd = @P_company_cd AND sheet_cd = @P_sheet_cd AND del_datetime IS NULL)
	BEGIN
		UPDATE #RESULT
		SET
			#RESULT.item_title					=	ISNULL(M0201.item_title,'')					
		FROM #RESULT 
		INNER JOIN M0201 ON (
			@P_company_cd	=	M0201.company_cd
		AND @P_sheet_cd		=	M0201.sheet_cd
		AND #RESULT.row_no	=	M0201.item_no
		AND M0201.del_datetime IS NULL
		)
	END
	--[0]
	SELECT 
		row_no						
	,	item_title	
	,	item_title_title
	,	item_title_1
	,	item_title_2
	,	item_title_3
	,	item_title_4
	,	item_title_5
	,	item_title_display_typ		
	,	item_display_typ_1			
	,	item_display_typ_2			
	,	item_display_typ_3			
	,	item_display_typ_4			
	,	item_display_typ_5	
	,	point_calculation_typ1
	,	point_calculation_typ2
	,	weight_display_typ			
	,	challenge_level_display_typ	
	,	detail_progress_comment_display_typ
	,	progress_comment_display_typ
	,	evaluation_display_typ		
	,	detail_comment_display_typ_0
	,	detail_comment_display_typ_1
	,	detail_comment_display_typ_2
	,	detail_comment_display_typ_3
	,	detail_comment_display_typ_4
	,	@check_challenge_level AS check_challenge_level
	,	col_span
	,	total_score_display_typ
	--
	,	detail_self_progress_comment_display_typ
	,	detail_self_progress_comment_title
	,	detail_progress_comment_title
	FROM #RESULT
	-- clean
	DROP TABLE #RESULT
END


GO
