DROP PROCEDURE [SPC_I2020_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC 
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	SAVE DATA
--*  
--* 作成日/create date			:	2018/10/08											
--*	作成者/creater				:	Longvv						
--*   					
--*	更新日/update date			:  	2019/12/20					
--*	更新者/updater				:　 viettd 　								     	 
--*	更新内容/update content		:	upgrade ver 1.6　	
--*   					
--*	更新日/update date			:  	2020/02/18					
--*	更新者/updater				:　 viettd 　								     	 
--*	更新内容/update content		:	fix bug　	
--*   					
--*	更新日/update date			:  	2020/10/12					
--*	更新者/updater				:　 viettd 　								     	 
--*	更新内容/update content		:	upgradate ver1.7 & 1on1	
--*   					
--*	更新日/update date			:	2021/11/16  						
--*	更新者/updater				:	viettd　								     	 
--*	更新内容/update content		:	※処遇用途内のシートの評価がすべて完了した場合、メッセージを表示する。（※特記事項8）
--*   					
--*	更新日/update date			:	2021/12/01  						
--*	更新者/updater				:	viettd　								     	 
--*	更新内容/update content		:	upgradate ver1.8
--*   					
--*	更新日/update date			:	2021/08/16  						
--*	更新者/updater				:	viettd　								     	 
--*	更新内容/update content		:	upgradate ver1.9
--*
--****************************************************************************************
CREATE PROCEDURE [SPC_I2020_ACT1] 
	-- Add the parameters for the stored procedure here
	@P_json			NVARCHAR(MAX)	=	''
,	@P_cre_user		NVARCHAR(50)	=	''
,	@P_cre_ip		NVARCHAR(50)	=	''
,	@P_company_cd	INT				=	0
,	@P_user_id		NVARCHAR(50)	=	''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL							ERRTABLE	
	,	@order_by_min						INT					=	0
	,	@P_fiscal_year						SMALLINT			=	0        
    ,	@P_employee_cd_refer			    NVARCHAR(10)		=	''           
    ,	@P_sheet_cd					        SMALLINT			=	0  
	,	@P_status_cd						SMALLINT			=	0
    ,	@P_evaluation_step					SMALLINT			=	0        
    ,	@P_evaluation_comment_0				NVARCHAR(1000)		=	''        
    ,	@P_evaluation_comment_1				NVARCHAR(1000)		=	''
	,	@P_evaluation_comment_2				NVARCHAR(1000)		=	''
	,	@P_evaluation_comment_3				NVARCHAR(1000)		=	''
	,	@P_evaluation_comment_4				NVARCHAR(1000)		=	''
	,	@P_mode								SMALLINT			=	0	--0:一時保存 1:登録 2:承認 3:差戻し
	,	@P_TOTAL_0							NUMERIC(8,2)		=	0
	,	@P_TOTAL_1							NUMERIC(8,2)		=	0
	,	@P_TOTAL_2							NUMERIC(8,2)		=	0
	,	@P_TOTAL_3							NUMERIC(8,2)		=	0
	,	@P_TOTAL_4							NUMERIC(8,2)		=	0
	,	@authority_cd						SMALLINT			=	0
	,	@authority_typ						SMALLINT			=	0
	,	@employee_cd_login					NVARCHAR(20)		=	''
	,	@point_kinds						SMALLINT			=	0
	,	@point_calculation_typ1				SMALLINT			=	0
	,	@point_calculation_typ2				SMALLINT			=	0
	,	@step								SMALLINT			=	0
	,	@status_cd							SMALLINT			=	0
	,	@status_cd_M0310					SMALLINT			=	0
	,	@status_cd_M0100					SMALLINT			=	0
	,	@evaluation_step					SMALLINT			=	0
	,	@interview_use_typ					SMALLINT			=	0	--期首面談
	,	@evaluation_self_assessment			SMALLINT			=	0	--自己評価
	,	@generic_comment_display_typ_1		tinyint				=	0
	,	@generic_comment_display_typ_2		tinyint				=	0
	,	@generic_comment_display_typ_3		tinyint				=	0
	,	@generic_comment_display_typ_4		tinyint				=	0
	,	@generic_comment_display_typ_5		tinyint				=	0
	,	@generic_comment_display_typ_6		tinyint				=	0
	,	@generic_comment_display_typ_7		tinyint				=	0
	,	@generic_comment_display_typ_8		tinyint				=	0				-- add by viettd 2020/10/12
	--
	,	@P_generic_comment_1				NVARCHAR(400)		=	''	-- 汎用コメント1
	,	@P_generic_comment_2				NVARCHAR(400)		=	''  -- 汎用コメント2
	,	@P_generic_comment_3				NVARCHAR(400)		=	''  -- 汎用コメント3
	,	@P_generic_comment_4				NVARCHAR(400)		=	''  -- 汎用コメント4 
	,	@P_generic_comment_5				NVARCHAR(400)		=	''  -- 汎用コメント5 
	,	@P_generic_comment_6				NVARCHAR(400)		=	''  -- 汎用コメント6 
	,	@P_generic_comment_7				NVARCHAR(400)		=	''  -- 汎用コメント7 
	,	@P_generic_comment_8				NVARCHAR(400)		=	''  -- 汎用コメント8	-- add by viettd 2020/10/12
	--SET @interview_use_typ
	IF 
	EXISTS(	SELECT 1 
				FROM M0100 
				WHERE 
					M0100.company_cd			=	@P_company_cd
				AND	M0100.interview_use_typ		=	1
				AND M0100.del_datetime IS NULL)
	AND 
	EXISTS(	SELECT 1 
				FROM M0310 
				WHERE 
					M0310.company_cd		=	@P_company_cd
				AND	M0310.category			=	3 
				--AND M0310.status_cd			=	1
				AND M0310.status_use_typ	=	1
				AND M0310.del_datetime IS NULL)
	BEGIN
		SET @interview_use_typ	=	1						--	あり
	END
	--SET @evaluation_self_assessment
	IF 
	EXISTS(	SELECT 1 
				FROM M0100 
				WHERE 
					M0100.company_cd						=	@P_company_cd
				AND	M0100.evaluation_self_assessment_typ	=	1
				AND M0100.del_datetime IS NULL)
	AND 
	EXISTS(SELECT 1 
			FROM M0310 
			WHERE 
				M0310.company_cd		=	@P_company_cd
			AND	M0310.category			=	2
			AND	M0310.status_cd			=	1	--自己評価中
			AND M0310.status_use_typ	=	1
			AND M0310.del_datetime IS NULL)
	BEGIN
		SET @evaluation_self_assessment	=	1		--	あり
	END
	--S0010 SET DATA	
	SELECT 
		@authority_typ		=	S0010.authority_typ
	,	@authority_cd		=	S0010.authority_cd
	,	@employee_cd_login	=	S0010.employee_cd
	FROM S0010
	WHERE 
		S0010.company_cd	=	@P_company_cd
	AND	S0010.user_id		=	@P_user_id
	AND	S0010.del_datetime IS NULL
	---
	IF object_id('tempdb..#TEMP_TABLE_JSON', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TEMP_TABLE_JSON
    END
	IF object_id('tempdb..#TEMP_TABLE_EVALUATION', 'U') IS NOT NULL
    BEGIN
        DROP TABLE #TEMP_TABLE_EVALUATION
    END
	IF object_id('tempdb..#TEMP_F0100', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #TEMP_F0100
	END
	IF object_id('tempdb..#TEMP_RATER', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #TEMP_RATER
	END
	IF object_id('tempdb..#TABLE_MESS', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #TABLE_MESS
	END
	-- CREATE TABLE #TEMP_TABLE_JSON
	CREATE TABLE #TEMP_TABLE_JSON (
		id							INT			IDENTITY(1,1)	
	,	item_no						SMALLINT
	,	weight						SMALLINT
	,	point_cd_0					SMALLINT
	,	point_cd_1					SMALLINT
	,	point_cd_2					SMALLINT
	,	point_cd_3					SMALLINT
	,	point_cd_4					SMALLINT 
	,	evaluation_comment			NVARCHAR(1000) -- 自己評価コメント
	,	evaluation_comment_detail_1	NVARCHAR(1000) -- 一次評価コメント
	,	evaluation_comment_detail_2	NVARCHAR(1000) -- 二次評価コメント
	,	evaluation_comment_detail_3	NVARCHAR(1000) -- 三次評価コメント
	,	evaluation_comment_detail_4	NVARCHAR(1000) -- 四次評価コメント
	)
	-- CREATE TABLE #TEMP_TABLE_EVALUATION
	CREATE TABLE #TEMP_TABLE_EVALUATION (
		id							INT			IDENTITY(1,1)	
	,	evaluation_step				SMALLINT
	,	point_sum					NUMERIC(8,2)
	,	evaluation_comment			NVARCHAR(1000)
	)
	--CREATE TABLE #TEMP_F0100
	CREATE	TABLE #TEMP_F0100 (
		ID						BIGINT			IDENTITY (1,1)
	,	company_cd				SMALLINT
	,	employee_cd				NVARCHAR(10)
	,	rater_employee_cd_1		NVARCHAR(10)
	,	rater_employee_cd_2		NVARCHAR(10)
	,	rater_employee_cd_3		NVARCHAR(10)
	,	rater_employee_cd_4		NVARCHAR(10)
	)
	--CREATE TABLE #TEMP_RATER
	CREATE TABLE #TEMP_RATER (
		id							INT			IDENTITY(1,1)	
	,	evaluation_step				SMALLINT
	,	point_sum					NUMERIC(8,2)
	,	evaluation_comment			NVARCHAR(1000)
	,	employee_cd					NVARCHAR(10)
	)
	--#TABLE_MESS
	CREATE TABLE #TABLE_MESS (
		id							int				identity(1,1)
	,	message_cd					smallint
	,	message_typ					smallint
	,	message_nm					nvarchar(20)
	,	message						nvarchar(100)
	)
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		-- assign
		SET	@P_fiscal_year						=	JSON_VALUE(@P_json,'$.fiscal_year')       
		SET	@P_employee_cd_refer				=	JSON_VALUE(@P_json,'$.employee_cd_refer')
		SET	@P_sheet_cd							=	JSON_VALUE(@P_json,'$.sheet_cd') 
		SET @P_status_cd						=	JSON_VALUE(@P_json,'$.status_cd') 
		SET	@P_evaluation_step					=	JSON_VALUE(@P_json,'$.evaluation_step')    
		SET	@P_evaluation_comment_0				=	JSON_VALUE(@P_json,'$.evaluation_comment_0')    
		SET	@P_evaluation_comment_1				=	JSON_VALUE(@P_json,'$.evaluation_comment_1')    
		SET	@P_evaluation_comment_2             =	JSON_VALUE(@P_json,'$.evaluation_comment_2')         
		SET	@P_evaluation_comment_3				=	JSON_VALUE(@P_json,'$.evaluation_comment_3') 
		SET	@P_evaluation_comment_4             =	JSON_VALUE(@P_json,'$.evaluation_comment_4') 
		SET	@P_mode								=	JSON_VALUE(@P_json,'$.mode') 
		SET @P_TOTAL_0							=	CONVERT(NUMERIC(8,2),IIF(JSON_VALUE(@P_json,'$.TOTAL_0')='','0',JSON_VALUE(@P_json,'$.TOTAL_0'))) 
		SET @P_TOTAL_1							=	CONVERT(NUMERIC(8,2),IIF(JSON_VALUE(@P_json,'$.TOTAL_1')='','0',JSON_VALUE(@P_json,'$.TOTAL_1'))) 
		SET @P_TOTAL_2							=	CONVERT(NUMERIC(8,2),IIF(JSON_VALUE(@P_json,'$.TOTAL_2')='','0',JSON_VALUE(@P_json,'$.TOTAL_2'))) 
		SET @P_TOTAL_3							=	CONVERT(NUMERIC(8,2),IIF(JSON_VALUE(@P_json,'$.TOTAL_3')='','0',JSON_VALUE(@P_json,'$.TOTAL_3'))) 
		SET @P_TOTAL_4							=	CONVERT(NUMERIC(8,2),IIF(JSON_VALUE(@P_json,'$.TOTAL_4')='','0',JSON_VALUE(@P_json,'$.TOTAL_4'))) 
		--
		SET	@P_generic_comment_1             =	JSON_VALUE(@P_json,'$.generic_comment_1')
		SET	@P_generic_comment_2             =	JSON_VALUE(@P_json,'$.generic_comment_2')
		SET	@P_generic_comment_3             =	JSON_VALUE(@P_json,'$.generic_comment_3')
		SET	@P_generic_comment_4             =	JSON_VALUE(@P_json,'$.generic_comment_4')
		SET	@P_generic_comment_5             =	JSON_VALUE(@P_json,'$.generic_comment_5')
		SET	@P_generic_comment_6             =	JSON_VALUE(@P_json,'$.generic_comment_6')
		SET	@P_generic_comment_7             =	JSON_VALUE(@P_json,'$.generic_comment_7')	
		SET	@P_generic_comment_8             =	JSON_VALUE(@P_json,'$.generic_comment_8')		
		--SET @evaluation_step
		IF	@P_status_cd	=	0	OR @P_status_cd	> 5
		BEGIN
			IF	@P_status_cd	>	5
			BEGIN
				SET @evaluation_step	=	-1	--Not Save F0120,F0121
			END
			ELSE
			BEGIN
				IF @interview_use_typ	=	1
				BEGIN	
					SET @evaluation_step	=	-1	--Not Save F0120,F0121
				END
				ELSE
				BEGIN
					IF	@evaluation_self_assessment	=	1
					BEGIN
						SET @evaluation_step	=	0	
					END
					ELSE
					BEGIN
						SET @evaluation_step	=	1
					END
				END
			END
			
		END
		ELSE
		BEGIN
			IF	@P_evaluation_step	=	5
			BEGIN
				IF	@P_status_cd	=	1
				BEGIN
					SET @evaluation_step	=	0
				END	
				IF	@P_status_cd	=	2
				BEGIN
					SET @evaluation_step	=	1
				END	
				IF	@P_status_cd	=	3
				BEGIN
					SET @evaluation_step	=	2
				END	
				IF	@P_status_cd	=	4
				BEGIN
					SET @evaluation_step	=	3
				END
				IF	@P_status_cd	=	5
				BEGIN
					SET @evaluation_step	=	4
				END
			END
			ELSE
			BEGIN
				SET @evaluation_step = @P_evaluation_step
			END
		END
		--SET @status_cd_M0310
		IF EXISTS (SELECT 1 
					FROM M0310 
					WHERE 
						M0310.company_cd		=	@P_company_cd
					AND	M0310.category			=	2
					AND	M0310.del_datetime		IS NULL
					)
		BEGIN
			SELECT	TOP 1
				 @status_cd_M0310				=	ISNULL(M0310.status_cd,0)
			FROM M0310
			wHERE 
				M0310.company_cd		=	@P_company_cd
			AND	M0310.category			=	2
			AND	M0310.status_use_typ	=	1
			AND	M0310.status_cd			>	1
			AND	M0310.del_datetime		IS NULL
			ORDER BY M0310.status_cd
		END	
		--SET @status_cd_M0100
		IF EXISTS (SELECT 1 
					FROM M0100 
					WHERE 
						M0100.company_cd		=	@P_company_cd
					AND	M0100.del_datetime		IS NULL
					)
		BEGIN
			SELECT 
				 @status_cd_M0100		=	CASE
												--WHEN M0100.evaluation_self_assessment_typ	=	1	
												--THEN 1	
												WHEN M0100.evaluation_typ_1	=	1					
												THEN 2
												WHEN M0100.evaluation_typ_2	=	1					
												THEN 3
												WHEN M0100.evaluation_typ_3	=	1					
												THEN 4
												WHEN M0100.evaluation_typ_4	=	1					
												THEN 5
												ELSE 6
											END
			FROM M0100
			WHERE 
				M0100.company_cd		=	@P_company_cd
			AND	M0100.del_datetime		IS NULL	
		END
		--SET @status_cd
		IF @status_cd_M0310	>	@status_cd_M0100
		BEGIN 
			SET @status_cd	=	@status_cd_M0310
		END
		ELSE
		BEGIN
			SET @status_cd	=	@status_cd_M0100
		END
		-- GET DATA FROM W_M0200
		--SET @point_kinds,@point_calculation_typ
		SELECT
			@point_kinds						=	ISNULL(W_M0200.point_kinds,0)
		,	@point_calculation_typ1				=	ISNULL(W_M0200.point_calculation_typ1,0)
		,	@point_calculation_typ2				=	ISNULL(W_M0200.point_calculation_typ2,0)
		,	@generic_comment_display_typ_1		=	ISNULL(W_M0200.generic_comment_display_typ_1,0)
		,	@generic_comment_display_typ_2		=	ISNULL(W_M0200.generic_comment_display_typ_2,0)
		,	@generic_comment_display_typ_3		=	ISNULL(W_M0200.generic_comment_display_typ_3,0)
		,	@generic_comment_display_typ_4		=	ISNULL(W_M0200.generic_comment_display_typ_4,0)
		,	@generic_comment_display_typ_5		=	ISNULL(W_M0200.generic_comment_display_typ_5,0)
		,	@generic_comment_display_typ_6		=	ISNULL(W_M0200.generic_comment_display_typ_6,0)
		,	@generic_comment_display_typ_7		=	ISNULL(W_M0200.generic_comment_display_typ_7,0)
		,	@generic_comment_display_typ_8		=	ISNULL(W_M0200.generic_comment_display_typ_8,0)
		FROM W_M0200 
		WHERE 
			W_M0200.company_cd		=	@P_company_cd 
		AND W_M0200.fiscal_year		=	@P_fiscal_year
		AND	W_M0200.sheet_cd		=	@P_sheet_cd	
		AND W_M0200.del_datetime IS NULL     
		--
		INSERT INTO #TEMP_TABLE_JSON
		SELECT
			JSON_VALUE([value],'$.item_no')														AS	item_no
		,	JSON_VALUE([value],'$.weight')														AS	weight
		,	IIF(JSON_VALUE([value],'$.point_cd_0')=-1,0,JSON_VALUE([value],'$.point_cd_0'))		AS	point_cd_0
		,	IIF(JSON_VALUE([value],'$.point_cd_1')=-1,0,JSON_VALUE([value],'$.point_cd_1'))		AS	point_cd_1
		,	IIF(JSON_VALUE([value],'$.point_cd_2')=-1,0,JSON_VALUE([value],'$.point_cd_2'))		AS	point_cd_2
		,	IIF(JSON_VALUE([value],'$.point_cd_3')=-1,0,JSON_VALUE([value],'$.point_cd_3'))		AS	point_cd_3
		,	IIF(JSON_VALUE([value],'$.point_cd_4')=-1,0,JSON_VALUE([value],'$.point_cd_4'))		AS	point_cd_4
		,	JSON_VALUE([value],'$.evaluation_comment')											AS	evaluation_comment
		--,	JSON_VALUE([value],'$.evaluation_comment_detail')									AS	evaluation_comment_detail
		,	JSON_VALUE([value],'$.evaluation_comment_detail_1')									AS	evaluation_comment_detail_1
		,	JSON_VALUE([value],'$.evaluation_comment_detail_2')									AS	evaluation_comment_detail_2
		,	JSON_VALUE([value],'$.evaluation_comment_detail_3')									AS	evaluation_comment_detail_3
		,	JSON_VALUE([value],'$.evaluation_comment_detail_4')									AS	evaluation_comment_detail_4
		FROM OPENJSON(@P_json,'$.tr_list')
		--
		IF @P_evaluation_step <> 5
		BEGIN
		INSERT INTO #TEMP_TABLE_EVALUATION
			SELECT
			@P_evaluation_step
		,	CASE
				WHEN	@P_evaluation_step = 0
				THEN	@P_TOTAL_0
				WHEN	@P_evaluation_step = 1
				THEN	@P_TOTAL_1
				WHEN	@P_evaluation_step = 2
				THEN	@P_TOTAL_2
				WHEN	@P_evaluation_step = 3
				THEN	@P_TOTAL_3
				WHEN	@P_evaluation_step = 4
				THEN	@P_TOTAL_4
				ELSE	0
			END
		,	CASE
				WHEN	@P_evaluation_step = 0
				THEN	@P_evaluation_comment_0
				WHEN	@P_evaluation_step = 1
				THEN	@P_evaluation_comment_1
				WHEN	@P_evaluation_step = 2
				THEN	@P_evaluation_comment_2
				WHEN	@P_evaluation_step = 3
				THEN	@P_evaluation_comment_3
				WHEN	@P_evaluation_step = 4
				THEN	@P_evaluation_comment_4
				ELSE	''
			END
		END	
		ELSE
		BEGIN
			WHILE @step <= 4 
			BEGIN
				INSERT INTO #TEMP_TABLE_EVALUATION
				SELECT
					@step
				,	CASE
						WHEN	@step = 0
						THEN	@P_TOTAL_0
						WHEN	@step = 1
						THEN	@P_TOTAL_1
						WHEN	@step = 2
						THEN	@P_TOTAL_2
						WHEN	@step = 3
						THEN	@P_TOTAL_3
						WHEN	@step = 4
						THEN	@P_TOTAL_4
						ELSE	0
					END
				,	CASE
						WHEN	@step = 0
						THEN	@P_evaluation_comment_0
						WHEN	@step = 1
						THEN	@P_evaluation_comment_1
						WHEN	@step = 2
						THEN	@P_evaluation_comment_2
						WHEN	@step = 3
						THEN	@P_evaluation_comment_3
						WHEN	@step = 4
						THEN	@P_evaluation_comment_4
						ELSE	''
					END
				SET @step	=	@step + 1
			END
		END
		--
		--INSERT INTO  #TEMP_F0100
		INSERT INTO #TEMP_F0100
		SELECT TOP 1
			F0100.company_cd
		,	F0100.employee_cd
		,	F0100.rater_employee_cd_1
		,	F0100.rater_employee_cd_2
		,	F0100.rater_employee_cd_3
		,	F0100.rater_employee_cd_4
		FROM F0100
		WHERE
			F0100.company_cd	=	@P_company_cd
		AND	F0100.fiscal_year	=	@P_fiscal_year
		AND F0100.employee_cd	=	@P_employee_cd_refer
		AND	F0100.sheet_cd		=	@P_sheet_cd
		AND	F0100.del_datetime	IS NULL
		--
		--INSERT INTO  #TEMP_RATER
		INSERT INTO #TEMP_RATER
		SELECT 
			TEMP.evaluation_step
		,	TEMP.point_sum
		,	TEMP.evaluation_comment
		,	CASE
				WHEN TEMP.evaluation_step = 0
				THEN TEMP1.employee_cd
				WHEN TEMP.evaluation_step = 1
				THEN TEMP1.rater_employee_cd_1
				WHEN TEMP.evaluation_step = 2
				THEN TEMP1.rater_employee_cd_2
				WHEN TEMP.evaluation_step = 3
				THEN TEMP1.rater_employee_cd_3
				WHEN TEMP.evaluation_step = 4
				THEN TEMP1.rater_employee_cd_4
				ELSE ''
			END
		FROM #TEMP_TABLE_EVALUATION AS TEMP
		LEFT OUTER JOIN #TEMP_F0100 AS TEMP1 ON(
			1	=	1	
		)
		--DELETE FROM #TEMP_RATER
		DELETE #TEMP_RATER
		FROM #TEMP_RATER
		LEFT OUTER JOIN M0200 WITH(NOLOCK) ON(
			@P_company_cd	=	M0200.company_cd 
		AND	@P_sheet_cd		=	M0200.sheet_cd		
		AND M0200.del_datetime IS NULL
		)
		LEFT OUTER JOIN M0100 WITH(NOLOCK) ON(
			M0200.company_cd	=	M0100.company_cd
		AND M0100.del_datetime IS NULL	
		) 
		WHERE 
			( --2019.11.26 バグ修正
			(/*ISNULL(M0200.self_assessment_comment_display_typ,0)	=	0
		OR	*/ISNULL(M0100.evaluation_self_assessment_typ,0)			=	0)
		AND	#TEMP_RATER.evaluation_step	=	0)
		OR	(ISNULL(M0100.evaluation_typ_1,0)			=	0
		AND	#TEMP_RATER.evaluation_step	=	1)
		OR	(ISNULL(M0100.evaluation_typ_3,0)			=	0
		AND	#TEMP_RATER.evaluation_step	=	3)
		OR	(ISNULL(M0100.evaluation_typ_3,0)			=	0
		AND	#TEMP_RATER.evaluation_step	=	3)
		OR	(ISNULL(M0100.evaluation_typ_4,0)			=	0
		AND	#TEMP_RATER.evaluation_step	=	4) 
		--
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
		--■■■■■■■■■■■■■■■■■■ F0101　■■■■■■■■■■■■■■■■■■
		-- 自己評価中
		IF @P_status_cd = 1 AND @P_evaluation_step IN (0,5) 
		BEGIN
		IF EXISTS (SELECT 1 FROM F0101 WHERE 
												F0101.company_cd	=	@P_company_cd
											AND F0101.fiscal_year	=	@P_fiscal_year
											AND F0101.employee_cd	=	@P_employee_cd_refer
											AND F0101.sheet_cd		=	@P_sheet_cd)
			BEGIN
				UPDATE F0101 SET 
					generic_comment_1	=	CASE 
												WHEN @generic_comment_display_typ_1  = 1	-- 1.ENABLED
												THEN @P_generic_comment_1
												ELSE F0101.generic_comment_1
											END
				,	generic_comment_2	=	CASE 
												WHEN @generic_comment_display_typ_2 = 1	-- 1.ENABLED
												THEN @P_generic_comment_2
												ELSE F0101.generic_comment_2
											END					
				,	generic_comment_5	=	CASE 
												WHEN @generic_comment_display_typ_5 = 1	-- 1.ENABLED
												THEN @P_generic_comment_5
												ELSE F0101.generic_comment_5
											END					
				,	generic_comment_6	=	CASE 
												WHEN @generic_comment_display_typ_6 = 1	-- 1.ENABLED
												THEN @P_generic_comment_6
												ELSE F0101.generic_comment_6
											END					
				,	generic_comment_7	=	CASE 
												WHEN @generic_comment_display_typ_7 = 1	-- 1.ENABLED
												THEN @P_generic_comment_7
												ELSE F0101.generic_comment_7
											END		
				,	generic_comment_8	=	CASE 
												WHEN @generic_comment_display_typ_8 = 1	-- 1.ENABLED
												THEN @P_generic_comment_8
												ELSE F0101.generic_comment_8
											END							
				,	upd_user			=	@P_cre_user
				,	upd_ip				=	@P_cre_ip
				,	upd_prg				=	'I2020'
				,	upd_datetime		=	@w_time
				,	del_user			=	SPACE(0)
				,	del_ip				=	SPACE(0)
				,	del_prg				=	SPACE(0)
				,	del_datetime		=	NULL
				WHERE 
					F0101.company_cd	=	@P_company_cd
				AND F0101.fiscal_year	=	@P_fiscal_year
				AND F0101.employee_cd	=	@P_employee_cd_refer
				AND F0101.sheet_cd		=	@P_sheet_cd
			END
			ELSE
			BEGIN
				INSERT INTO F0101
				SELECT 
					@P_company_cd
				,	@P_fiscal_year
				,	@P_employee_cd_refer
				,	@P_sheet_cd
				,	CASE 
						WHEN @generic_comment_display_typ_1  = 1	-- 1.ENABLED
						THEN @P_generic_comment_1
						ELSE ''
					END
				,	CASE 
						WHEN @generic_comment_display_typ_2  = 1	-- 1.ENABLED
						THEN @P_generic_comment_2
						ELSE ''
					END
				,	CASE 
						WHEN @generic_comment_display_typ_3  = 1	-- 1.ENABLED
						THEN @P_generic_comment_3
						ELSE ''
					END
				,	CASE 
						WHEN @generic_comment_display_typ_4  = 1	-- 1.ENABLED
						THEN @P_generic_comment_4
						ELSE ''
					END
				,	CASE 
						WHEN @generic_comment_display_typ_5  = 1	-- 1.ENABLED
						THEN @P_generic_comment_5
						ELSE ''
					END
				,	CASE 
						WHEN @generic_comment_display_typ_6  = 1	-- 1.ENABLED
						THEN @P_generic_comment_6
						ELSE ''
					END
				,	CASE 
						WHEN @generic_comment_display_typ_7  = 1	-- 1.ENABLED
						THEN @P_generic_comment_7
						ELSE ''
					END														
				,	CASE 
						WHEN @generic_comment_display_typ_8  = 1	-- 1.ENABLED
						THEN @P_generic_comment_8
						ELSE ''
					END														
				,	@P_cre_user														--	cre_user
				,	@P_cre_ip														--	cre_ip
				,	'I2020'
				,	@w_time															--	cre_datetime
				,	SPACE(0)														--	upd_user
				,	SPACE(0)														--	upd_ip
				,	SPACE(0)
				,	NULL															--	upd_datetime
				,	SPACE(0)														--	del_user
				,	SPACE(0)														--	del_ip
				,	SPACE(0)
				,	NULL
			END
		END
		-- 一次評価者
		IF @P_evaluation_step IN (1,5)
		BEGIN
			IF EXISTS (SELECT 1 FROM F0101 WHERE 
												F0101.company_cd	=	@P_company_cd
											AND F0101.fiscal_year	=	@P_fiscal_year
											AND F0101.employee_cd	=	@P_employee_cd_refer
											AND F0101.sheet_cd		=	@P_sheet_cd)
			BEGIN
				UPDATE F0101 SET 
					generic_comment_3	=	CASE 
												WHEN @generic_comment_display_typ_3 = 1	-- 1.ENABLED
												THEN @P_generic_comment_3
												ELSE F0101.generic_comment_3
											END					
				,	generic_comment_4	=	CASE 
												WHEN @generic_comment_display_typ_4 = 1	-- 1.ENABLED
												THEN @P_generic_comment_4
												ELSE F0101.generic_comment_4
											END								
				,	upd_user			=	@P_cre_user
				,	upd_ip				=	@P_cre_ip
				,	upd_prg				=	'I2020'
				,	upd_datetime		=	@w_time
				,	del_user			=	SPACE(0)
				,	del_ip				=	SPACE(0)
				,	del_prg				=	SPACE(0)
				,	del_datetime		=	NULL
				WHERE 
					F0101.company_cd	=	@P_company_cd
				AND F0101.fiscal_year	=	@P_fiscal_year
				AND F0101.employee_cd	=	@P_employee_cd_refer
				AND F0101.sheet_cd		=	@P_sheet_cd
			END
			ELSE
			BEGIN
				INSERT INTO F0101
				SELECT 
					@P_company_cd
				,	@P_fiscal_year
				,	@P_employee_cd_refer
				,	@P_sheet_cd
				,	CASE 
						WHEN @generic_comment_display_typ_1  = 1	-- 1.ENABLED
						THEN @P_generic_comment_1
						ELSE ''
					END
				,	CASE 
						WHEN @generic_comment_display_typ_2  = 1	-- 1.ENABLED
						THEN @P_generic_comment_2
						ELSE ''
					END
				,	CASE 
						WHEN @generic_comment_display_typ_3  = 1	-- 1.ENABLED
						THEN @P_generic_comment_3
						ELSE ''
					END
				,	CASE 
						WHEN @generic_comment_display_typ_4  = 1	-- 1.ENABLED
						THEN @P_generic_comment_4
						ELSE ''
					END
				,	CASE 
						WHEN @generic_comment_display_typ_5  = 1	-- 1.ENABLED
						THEN @P_generic_comment_5
						ELSE ''
					END
				,	CASE 
						WHEN @generic_comment_display_typ_6  = 1	-- 1.ENABLED
						THEN @P_generic_comment_6
						ELSE ''
					END
				,	CASE 
						WHEN @generic_comment_display_typ_7  = 1	-- 1.ENABLED
						THEN @P_generic_comment_7
						ELSE ''
					END			
				,	CASE 
						WHEN @generic_comment_display_typ_8  = 1	-- 1.ENABLED
						THEN @P_generic_comment_8
						ELSE ''
					END																			
				,	@P_cre_user														--	cre_user
				,	@P_cre_ip														--	cre_ip
				,	'I2020'
				,	@w_time															--	cre_datetime
				,	SPACE(0)														--	upd_user
				,	SPACE(0)														--	upd_ip
				,	SPACE(0)
				,	NULL															--	upd_datetime
				,	SPACE(0)														--	del_user
				,	SPACE(0)														--	del_ip
				,	SPACE(0)
				,	NULL
			END
		END
		-- add by viettd 2021/11/16
		-- CHECK MESS 148
		-- @P_mode = --0:一時保存 1:登録 2:承認 3:差戻し
		IF @P_mode = 1
		BEGIN
			INSERT INTO #TABLE_MESS
			EXEC [dbo].[SPC_I2010_CHK1]
				@P_fiscal_year			
			,	@P_sheet_cd				
			,	@P_employee_cd_refer			
			,	@P_company_cd			
			,	@P_status_cd
			,	2					-- sheet_kbn
		END
		-- end add by viettd 2021/11/16
		--■■■■■■■■■■■■■■■■■■ F0120　■■■■■■■■■■■■■■■■■■
		--■ UPDATE F0120
		UPDATE F0120 SET 
			rater_employee_cd					=	TEMP.employee_cd
		,	evaluation_comment					=	TEMP.evaluation_comment
		,	point_sum							=	TEMP.point_sum
		,	submit_user							=	CASE 
														WHEN @P_mode = 1
														THEN @P_cre_user
														ELSE F0120.submit_user
													END			
		,	submit_ip							=	CASE 
														WHEN @P_mode = 1
														THEN @P_cre_ip
														ELSE F0120.submit_ip
													END	
		,	submit_datetime						=	CASE 
														WHEN @P_mode = 1
														THEN @w_time
														ELSE F0120.submit_datetime
													END	
		,	upd_user							=	@P_cre_user			
		,	upd_ip								=	@P_cre_ip	
		,	upd_prg								=	'I2020'
		,	upd_datetime						=	@w_time	
		,	del_user							=	''			
		,	del_ip								=	''	
		,	del_prg								=	''
		,	del_datetime						=	NULL	
		FROM F0120
		INNER JOIN #TEMP_RATER AS TEMP ON (
			F0120.evaluation_step	=	TEMP.evaluation_step
		AND	TEMP.employee_cd		<>	''
		AND	@evaluation_step		>=	TEMP.evaluation_step
		)
		WHERE 
			F0120.company_cd		=	@P_company_cd 
		AND F0120.fiscal_year		=	@P_fiscal_year 
		AND F0120.employee_cd		=	@P_employee_cd_refer
		AND	F0120.sheet_cd			=	@P_sheet_cd
		--■ INSERT F0120
		INSERT INTO F0120 (
			company_cd	
		,	fiscal_year		
		,	employee_cd     
		,	sheet_cd      
		,	evaluation_step       
		,	rater_employee_cd         
		,	evaluation_comment        
		,	point_sum  
		,	submit_user
		,	submit_ip
		,	submit_datetime                                   				
		,	cre_user
		,	cre_ip
		,	cre_prg
		,	cre_datetime
		)
		SELECT
			@P_company_cd	
		,	@P_fiscal_year
		,	@P_employee_cd_refer
		,	@P_sheet_cd
		,	TEMP.evaluation_step
		,	TEMP.employee_cd
		,	TEMP.evaluation_comment
		,	TEMP.point_sum
		,	CASE 
				WHEN @P_mode = 1
				THEN @P_cre_user
				ELSE ''
			END
		,	CASE 
				WHEN @P_mode = 1
				THEN @P_cre_ip
				ELSE ''
			END
		,	CASE 
				WHEN @P_mode = 1
				THEN @w_time
				ELSE NULL
			END                    
		,	@P_cre_user
		,	@P_cre_ip
		,	'I2020'
		,	@w_time
		FROM #TEMP_RATER AS TEMP 
		LEFT OUTER JOIN F0120 ON (
			@P_company_cd			=	F0120.company_cd
		AND @P_fiscal_year			=	F0120.fiscal_year
		AND @P_employee_cd_refer	=	F0120.employee_cd	
		AND	@P_sheet_cd				=	F0120.sheet_cd
		AND	TEMP.evaluation_step	=	F0120.evaluation_step
		)
		WHERE 
			TEMP.employee_cd		<>	''
		AND	F0120.company_cd		IS NULL
		AND	TEMP.evaluation_step	<=	@evaluation_step
		--■ UPDATE F0121
		UPDATE F0121 SET 
			point_cd							=	CASE
														WHEN	TEMP_EVALUATION.evaluation_step = 0
														THEN	TEMP.point_cd_0 
														WHEN	TEMP_EVALUATION.evaluation_step = 1
														THEN	TEMP.point_cd_1 
														WHEN	TEMP_EVALUATION.evaluation_step = 2
														THEN	TEMP.point_cd_2 
														WHEN	TEMP_EVALUATION.evaluation_step = 3
														THEN	TEMP.point_cd_3 
														WHEN	TEMP_EVALUATION.evaluation_step = 4
														THEN	TEMP.point_cd_4 
														ELSE	0
													END 
		,	evaluation_comment					=	CASE
														WHEN	TEMP_EVALUATION.evaluation_step = 0
														THEN	TEMP.evaluation_comment
														WHEN	TEMP_EVALUATION.evaluation_step = 1
														THEN	TEMP.evaluation_comment_detail_1
														WHEN	TEMP_EVALUATION.evaluation_step = 2
														THEN	TEMP.evaluation_comment_detail_2
														WHEN	TEMP_EVALUATION.evaluation_step = 3
														THEN	TEMP.evaluation_comment_detail_3
														WHEN	TEMP_EVALUATION.evaluation_step = 4
														THEN	TEMP.evaluation_comment_detail_4
														ELSE	''
													END
		,	upd_user							=	@P_cre_user			
		,	upd_ip								=	@P_cre_ip
		,	upd_prg								=	'I2020'	
		,	upd_datetime						=	@w_time	
		,	del_user							=	''			
		,	del_ip								=	''	
		,	del_prg								=	''
		,	del_datetime						=	NULL	
		FROM F0121
		INNER JOIN #TEMP_TABLE_JSON AS TEMP ON (
			F0121.item_no				=	TEMP.item_no
		)
		INNER JOIN #TEMP_RATER AS TEMP_EVALUATION ON (
			F0121.evaluation_step		=	TEMP_EVALUATION.evaluation_step
		AND	TEMP_EVALUATION.employee_cd <>	''
		AND	@evaluation_step			>=	TEMP_EVALUATION.evaluation_step	
		)
		WHERE 
			F0121.company_cd			=	@P_company_cd 
		AND F0121.fiscal_year			=	@P_fiscal_year 
		AND F0121.employee_cd			=	@P_employee_cd_refer	
		AND	F0121.sheet_cd				=	@P_sheet_cd
		--■ INSERT F0121
		INSERT INTO F0121 (
			company_cd	
		,	fiscal_year		
		,	employee_cd     
		,	sheet_cd      
		,	evaluation_step  
		,	item_no     
		,	point_cd         
		,	evaluation_comment                                             				
		,	cre_user
		,	cre_ip
		,	cre_prg
		,	cre_datetime
		)
		SELECT
			@P_company_cd	
		,	@P_fiscal_year
		,	CASE 
				WHEN	@P_evaluation_step		<>	0	
				THEN	@P_employee_cd_refer
				ELSE	@employee_cd_login
			END
		,	@P_sheet_cd
		,	TEMP_EVALUATION.evaluation_step
		,	TEMP.item_no
		,	CASE
				WHEN	TEMP_EVALUATION.evaluation_step = 0
				THEN	TEMP.point_cd_0 
				WHEN	TEMP_EVALUATION.evaluation_step = 1
				THEN	TEMP.point_cd_1 
				WHEN	TEMP_EVALUATION.evaluation_step = 2
				THEN	TEMP.point_cd_2 
				WHEN	TEMP_EVALUATION.evaluation_step = 3
				THEN	TEMP.point_cd_3 
				WHEN	TEMP_EVALUATION.evaluation_step = 4
				THEN	TEMP.point_cd_4 
				ELSE	0
			END       
		,	CASE
				WHEN	TEMP_EVALUATION.evaluation_step = 0
				THEN	TEMP.evaluation_comment 
				WHEN	TEMP_EVALUATION.evaluation_step = 1
				THEN	TEMP.evaluation_comment_detail_1
				WHEN	TEMP_EVALUATION.evaluation_step = 2
				THEN	TEMP.evaluation_comment_detail_2 
				WHEN	TEMP_EVALUATION.evaluation_step = 3
				THEN	TEMP.evaluation_comment_detail_3
				WHEN	TEMP_EVALUATION.evaluation_step = 4
				THEN	TEMP.evaluation_comment_detail_4 
				ELSE	''
			END            
		,	@P_cre_user
		,	@P_cre_ip
		,	'I2020'	
		,	@w_time
		FROM #TEMP_TABLE_JSON AS TEMP
		LEFT JOIN #TEMP_RATER AS TEMP_EVALUATION ON(
			1=1
		)
		LEFT JOIN  F0121	ON (
			TEMP.item_no					=	F0121.item_no
		AND	@P_company_cd					=	F0121.company_cd 
		AND @P_fiscal_year					=	F0121.fiscal_year
		AND @P_employee_cd_refer			=	F0121.employee_cd	
		AND TEMP_EVALUATION.evaluation_step	=	F0121.evaluation_step
		AND	@P_sheet_cd						=	F0121.sheet_cd
		) 
		WHERE 
			TEMP_EVALUATION.employee_cd		<>	''
		AND	F0121.company_cd				IS NULL
		AND	TEMP_EVALUATION.evaluation_step	<=	@evaluation_step	
			--UPDATE F0100
			IF	(@P_mode = 1)	
			AND(
				(@evaluation_step	=	0 	AND @P_status_cd	<=	1)
			--OR	(@evaluation_step	=	1 	AND @P_status_cd	=	0)
				)	
			BEGIN
			UPDATE F0100 SET 
				status_cd		=	@status_cd
			,	upd_user		=	@P_cre_user			
			,	upd_ip			=	@P_cre_ip	
			,	upd_prg			=	'I2020'	
			,	upd_datetime	=	@w_time		
			FROM F0100
			WHERE
				F0100.company_cd	=	@P_company_cd
			AND	F0100.fiscal_year	=	@P_fiscal_year
			AND	F0100.employee_cd	=	@P_employee_cd_refer
			AND	F0100.sheet_cd		=	@P_sheet_cd
			AND	F0100.del_datetime	IS	NULL
			END
		END
	END TRY
	BEGIN CATCH
	IF (@@TRANCOUNT > 0)
		BEGIN
			ROLLBACK TRANSACTION
		END
		DELETE FROM @ERR_TBL
		INSERT INTO @ERR_TBL
		SELECT	
			0
		,	'EXCEPTION'
		,	0
		,	999 -- exception error
		,	0
		,	0
		,	'Error'                                                          + CHAR(13) + CHAR(10) +
            'Procedure : ' + ISNULL(ERROR_PROCEDURE(), '???')                + CHAR(13) + CHAR(10) +
            'Line : '      + ISNULL(CAST(ERROR_LINE() AS NVARCHAR(10)), '0') + CHAR(13) + CHAR(10) +
            'Message : '   + ISNULL(ERROR_MESSAGE(), 'An unexpected error occurred.')
	END CATCH
	--DELETE FROM @ERR_TBL
	IF(@@TRANCOUNT > 0)
	BEGIN
		COMMIT TRANSACTION
	END
    -- Insert statements for procedure here
	COMPLETE_QUERY:
	-- GET ERROR_TYPE MIN
	SELECT 
		@order_by_min = MIN(order_by)
	FROM @ERR_TBL
	--[0] SELECT ERROR TABLE
	SELECT 
		message_no
	,	item
	,	order_by
	,	error_typ
	,	value1
	,	value2
	,	remark
	FROM @ERR_TBL
	WHERE order_by = @order_by_min
	ORDER BY 
		order_by
	--[1]
	SELECT 
		#TABLE_MESS.message_cd			AS	message_cd
	,	#TABLE_MESS.message_typ			AS	message_typ
	,	#TABLE_MESS.message_nm			AS	message_nm
	,	#TABLE_MESS.[message]			AS	[message]
	FROM #TABLE_MESS
	--[2]
	-- add by viettd 2021/12/01
	SELECT 
		#TEMP_F0100.rater_employee_cd_1		AS	employee_cd
	,	@P_status_cd						AS	status_cd
	FROM #TEMP_F0100
END
GO