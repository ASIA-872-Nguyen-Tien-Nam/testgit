IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_rQ2020_FND1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_rQ2020_FND1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--EXEC SPC_rQ2020_FND1 '782','2023','','','4','888','721','0';
--EXEC SPC_rQ2020_FND1 '789','2023','','','4','nv41','0','1';
--EXEC SPC_rQ2020_FND1 '10035','2023','','','5','a042','0','1';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET LIST RQ2020
--*  
--*  作成日/create date			:	2023/05/22						
--*　作成者/creater				:	QUANGND								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rQ2020_FND1]
	@P_company_cd				SMALLINT		=	0
,	@P_fiscal_year				SMALLINT		=	0
,	@P_year_month_start			INT				=	0
,	@P_year_month_end			INT				=	0
,	@P_report_kind				SMALLINT		=   0
,	@P_employee_cd				NVARCHAR(10)	=	''
,	@P_employee_cd_login		NVARCHAR(10)	=	''
,	@P_mode						SMALLINT		=	0	--0|search,1|csv
AS
BEGIN
	--[0]
	DECLARE 
		@w_language					smallint	=	0	-- 1.JP 2.EN
	,	@w_report_authority_typ		smallint	=	0
	,	@w_is_approver_viewer_share smallint	=   0	
	,	@w_cre_user					NVARCHAR(50)=	''

	IF(@P_employee_cd = @P_employee_cd_login)
	BEGIN
		SET @w_is_approver_viewer_share = 1
	END
	IF EXISTS (SELECT 1
				FROM F4200
				WHERE
					F4200.company_cd  = @P_company_cd
				AND	F4200.fiscal_year = @P_fiscal_year
				AND F4200.employee_cd = @P_employee_cd
				AND (
					F4200.approver_employee_cd_1	=	@P_employee_cd_login
				OR	F4200.approver_employee_cd_2	=	@P_employee_cd_login
				OR	F4200.approver_employee_cd_3	=	@P_employee_cd_login
				OR	F4200.approver_employee_cd_4	=	@P_employee_cd_login
				)
				AND F4200.del_datetime IS NULL
			)
	BEGIN
		SET @w_is_approver_viewer_share = 1
	END
	IF EXISTS (SELECT 1
				FROM F4120
				WHERE
					F4120.company_cd			= @P_company_cd
				AND	F4120.fiscal_year			= @P_fiscal_year
				AND F4120.employee_cd			= @P_employee_cd
				AND F4120.viewer_employee_cd	= @P_employee_cd_login
				AND F4120.del_datetime IS NULL
				)
	BEGIN
		SET @w_is_approver_viewer_share = 1
	END
	IF EXISTS (SELECT 1
				FROM F4207
				WHERE
					F4207.company_cd			= @P_company_cd
				AND	F4207.fiscal_year			= @P_fiscal_year
				AND F4207.employee_cd			= @P_employee_cd
				AND F4207.sharewith_employee_cd	= @P_employee_cd_login
				AND F4207.del_datetime IS NULL
				)
	BEGIN
		SET @w_is_approver_viewer_share = 1
	END
	--
	CREATE TABLE #RESULT (
		id							INT IDENTITY(1,1)
	,	status_cd					SMALLINT
	,	title						NVARCHAR(20)
	,	adequacy_kbn				SMALLINT
	,	busyness_kbn				SMALLINT
	,	other_kbn					SMALLINT
	,	question_no					SMALLINT
	,	question                    NVARCHAR(200)
	,	answer						NVARCHAR(400)
	,	answer_kbn                  SMALLINT
	,	answer_sentence				NVARCHAR(400)
	,	answer_number				NUMERIC(3,1)
	,	answer_select				SMALLINT
	,	fiscal_year					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	report_kind					SMALLINT
	,	report_no					SMALLINT
	,	adaption_date				DATE
	,	sheet_cd					SMALLINT
	,	company_cd					SMALLINT
	,	can_link					SMALLINT     --0 VIEW, 1 LINK
	)
	CREATE TABLE #TABLE_QUESTION_ANSWER(
		id						int		identity(1,1)
	,	company_cd				smallint
	,	fiscal_year				smallint
	,	employee_cd				nvarchar(10)
	,	report_kind				smallint
	,	report_no				smallint
	,	sheet_detail_no			SMALLINT
	,	question_no				tinyint
	,	question_content		nvarchar(200)
	,	question_answer			nvarchar(400)
	)
	CREATE TABLE #TABLE_QUESTION(
		id						int		identity(1,1)
	,	company_cd				smallint
	,	fiscal_year				smallint
	,	employee_cd				nvarchar(10)
	,	report_kind				smallint
	,	report_no				smallint
	,	question_no_1			tinyint
	,	question_content_1		nvarchar(200)
	,	question_answer_1		nvarchar(400)
	,	question_no_2			tinyint
	,	question_content_2		nvarchar(200)
	,	question_answer_2		nvarchar(400)
	,	question_no_3			tinyint
	,	question_content_3		nvarchar(200)
	,	question_answer_3		nvarchar(400)
	,	question_no_4			tinyint
	,	question_content_4		nvarchar(200)
	,	question_answer_4		nvarchar(400)
	,	question_no_5			tinyint
	,	question_content_5		nvarchar(200)
	,	question_answer_5		nvarchar(400)
	,	question_no_6			tinyint
	,	question_content_6		nvarchar(200)
	,	question_answer_6		nvarchar(400)
	,	question_no_7			tinyint
	,	question_content_7		nvarchar(200)
	,	question_answer_7		nvarchar(400)
	,	question_no_8			tinyint
	,	question_content_8		nvarchar(200)
	,	question_answer_8		nvarchar(400)
	,	question_no_9			tinyint
	,	question_content_9		nvarchar(200)
	,	question_answer_9		nvarchar(400)
	,	question_no_10			tinyint
	,	question_content_10		nvarchar(200)
	,	question_answer_10		nvarchar(400)
	)
	--
	CREATE TABLE #HEADER(
		title						NVARCHAR(20)
	,	adequacy_kbn				NVARCHAR(20)
	,	busyness_kbn				NVARCHAR(20)
	,	other_kbn					NVARCHAR(20)

	,	question1                    NVARCHAR(200)
	,	answer1						NVARCHAR(400)
	,	question2                    NVARCHAR(200)
	,	answer2						NVARCHAR(400)
	,	question3                    NVARCHAR(200)
	,	answer3						NVARCHAR(400)
	,	question4                    NVARCHAR(200)
	,	answer4						NVARCHAR(400)
	,	question5                    NVARCHAR(200)
	,	answer5						NVARCHAR(400)
	,	question6                    NVARCHAR(200)
	,	answer6						NVARCHAR(400)
	,	question7                    NVARCHAR(200)
	,	answer7						NVARCHAR(400)
	,	question8                    NVARCHAR(200)
	,	answer8						NVARCHAR(400)
	,	question9                    NVARCHAR(200)
	,	answer9						NVARCHAR(400)
	,	question10                    NVARCHAR(200)
	,	answer10						NVARCHAR(400)
	)
	--
	SELECT 
		@w_language					=	ISNULL(S0010.[language],1)
	,	@w_report_authority_typ		=	ISNULL(S0010.report_authority_typ,0)
	FROM S0010
	LEFT OUTER JOIN M0070 ON (
		S0010.company_cd		=	M0070.company_cd
	AND S0010.employee_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	WHERE 
		S0010.company_cd	=	@P_company_cd
	AND S0010.employee_cd	=	@P_employee_cd_login
	AND S0010.del_datetime IS NULL
	-- insert
	INSERT INTO #RESULT
	SELECT 
		ISNULL(F4200.status_cd,0)			
	,	CASE 
			WHEN ISNULL(F4200.title,'') <> '' THEN ISNULL(F4200.title,'')			
			ELSE CAST(ISNULL(F4200.times,0) AS NVARCHAR(2)) + IIF(@w_language = 2, 'Times', '回')
		END										
	,	ISNULL(F4201.adequacy_kbn,0)		
	,	ISNULL(F4201.busyness_kbn,0)		
	,	ISNULL(F4201.other_kbn,0)					
	,	ISNULL(F4202.question_no,0)	
	,	IIF(ISNULL(F4202.question_no,0)=0,'',ISNULL(M4201.question,''))	
	,	CASE 
			WHEN M4125.answer_kind = 1  THEN ISNULL(F4202.answer_sentence,'')
			WHEN M4125.answer_kind = 2  THEN CAST(ISNULL(F4202.answer_number,0) AS NVARCHAR(400))
			ELSE ISNULL(M4126.detail_name,'')
		END
	,	ISNULL(M4125.answer_kind,0)			
	,	ISNULL(F4202.answer_sentence,'')	
	,	ISNULL(F4202.answer_number,0)		
	,	ISNULL(F4202.answer_select,0)		
	--	hide item
	,	ISNULL(F4200.fiscal_year,0)		
	,	ISNULL(F4200.employee_cd,'')
	,	ISNULL(F4200.report_kind,0)		
	,	ISNULL(F4200.report_no,0)
	,	ISNULL(F4200.adaption_date,NULL)
	,	ISNULL(F4200.sheet_cd,0)
	,	ISNULL(F4200.company_cd,0)
	,	CASE 
			WHEN @P_employee_cd = @P_employee_cd_login  THEN 1
			WHEN @P_employee_cd_login = F4200.approver_employee_cd_1 AND F4200.status_cd >=2  THEN 1
			WHEN @P_employee_cd_login = F4200.approver_employee_cd_2 AND F4200.status_cd >=3  THEN 1
			WHEN @P_employee_cd_login = F4200.approver_employee_cd_3 AND F4200.status_cd >=4  THEN 1
			WHEN @P_employee_cd_login = F4200.approver_employee_cd_4 AND F4200.status_cd >=5  THEN 1
			WHEN F4120.viewer_employee_cd IS NOT NULL AND F4200.status_cd = 6  THEN 1
			WHEN F4207.employee_cd IS NOT NULL AND F4200.status_cd = 6  THEN 1
			WHEN @w_report_authority_typ IN (4,5) THEN 1
			ELSE 0
		END
	FROM F4200
	LEFT OUTER JOIN F4120 ON (
		F4200.company_cd		=	F4120.company_cd
	AND F4200.fiscal_year		=	F4120.fiscal_year
	AND F4200.employee_cd		=	F4120.employee_cd
	AND F4200.report_kind		=	F4120.report_kind
	AND F4200.report_no			=	F4120.report_no
	AND @P_employee_cd_login	=	F4120.viewer_employee_cd
	AND F4120.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4201 ON (
		F4200.company_cd		=	F4201.company_cd
	AND F4200.fiscal_year		=	F4201.fiscal_year
	AND F4200.employee_cd		=	F4201.employee_cd
	AND F4200.report_kind		=	F4201.report_kind
	AND F4200.report_no			=	F4201.report_no
	AND F4201.del_datetime IS NULL
	)
	LEFT OUTER JOIN ( 
		SELECT 
			M4201.company_cd				AS company_cd	
		,	M4201.report_kind				AS report_kind
		,	M4201.sheet_cd					AS sheet_cd
		,	M4201.adaption_date				AS adaption_date
		--,	min(M4201.question_no)			AS question_no
		--,	M4201.question					AS question
		,	min(M4201.sheet_detail_no) 		AS sheet_detail_no
		FROM M4201
		WHERE
			M4201.company_cd	= @P_company_cd
		AND M4201.report_kind	= @P_report_kind
		AND	M4201.del_datetime IS NULL
		GROUP BY
			M4201.company_cd	
		,	M4201.report_kind	
		,	M4201.sheet_cd		
		,	M4201.adaption_date	
		--,	M4201.sheet_detail_no
		--,	M4201.question_no
		--,	M4201.question
	)	AS  M4201_TEMP ON (
			F4200.company_cd		=	M4201_TEMP.company_cd
		AND F4200.report_kind		=	M4201_TEMP.report_kind
		AND F4200.sheet_cd			=	M4201_TEMP.sheet_cd
		AND F4200.adaption_date		=	M4201_TEMP.adaption_date
	)
	--LEFT OUTER JOIN ( 
	--	SELECT 
	--		F4202.company_cd		AS company_cd	
	--	,	F4202.fiscal_year		AS fiscal_year
	--	,	F4202.employee_cd		AS employee_cd
	--	,	F4202.report_kind		AS report_kind
	--	,	F4202.report_no			AS report_no
	--	,	min(question_no) 		AS question_no
	--	FROM F4202
	--	WHERE
	--		F4202.company_cd	= @P_company_cd
	--	AND	F4202.fiscal_year	= @P_fiscal_year
	--	AND F4202.employee_cd	= @P_employee_cd
	--	AND F4202.report_kind	= @P_report_kind
	--	AND	F4202.del_datetime IS NULL
	--	GROUP BY
	--		F4202.company_cd
	--	,	F4202.company_cd	
	--	,	F4202.fiscal_year	
	--	,	F4202.employee_cd	
	--	,	F4202.report_kind	
	--	,	F4202.report_no	
	--)	AS  F4202_TEMP ON (
	--		F4200.company_cd		=	F4202_TEMP.company_cd
	--	AND F4200.fiscal_year		=	F4202_TEMP.fiscal_year
	--	AND F4200.employee_cd		=	F4202_TEMP.employee_cd
	--	AND F4200.report_kind		=	F4202_TEMP.report_kind
	--	AND F4200.report_no			=	F4202_TEMP.report_no
	--)
	LEFT OUTER JOIN M4201  ON (
		M4201_TEMP.company_cd			=	M4201.company_cd
	AND M4201_TEMP.report_kind			=	M4201.report_kind
	AND M4201_TEMP.sheet_cd				=	M4201.sheet_cd
	AND M4201_TEMP.adaption_date		=	M4201.adaption_date
	AND M4201_TEMP.sheet_detail_no		=	M4201.sheet_detail_no
	AND M4201.del_datetime IS NULL
	)
	LEFT OUTER JOIN F4202 ON (
		F4200.company_cd	=	F4202.company_cd
	AND F4200.fiscal_year	=	F4202.fiscal_year
	AND F4200.employee_cd	=	F4202.employee_cd
	AND F4200.report_kind	=	F4202.report_kind
	AND F4200.report_no		=	F4202.report_no
	AND	M4201.question_no	=	F4202.question_no
	AND F4202.del_datetime IS NULL
	)
	LEFT OUTER JOIN M4125 ON (
		F4202.company_cd		=	M4125.company_cd
	AND	F4202.question_no		=	M4125.question_no
	AND M4125.del_datetime IS NULL
	)
	LEFT OUTER JOIN M4126  ON (
		F4200.company_cd		=	M4126.company_cd
	AND F4202.question_no		=	M4126.question_no
	AND F4202.answer_select		=	M4126.detail_no
	AND M4126.del_datetime IS NULL
	)
	LEFT OUTER JOIN (
		SELECT 
			F4207.company_cd
		,	F4207.fiscal_year
		,	F4207.employee_cd
		,	F4207.report_kind
		,	F4207.report_no
		,	MIN(F4207.shareby_employee_cd) AS shareby_employee_cd
		,	F4207.sharewith_employee_cd
		FROM F4207
		WHERE 
			F4207.company_cd			=	@P_company_cd
		AND F4207.fiscal_year			=	@P_fiscal_year
		AND	F4207.employee_cd			=	@P_employee_cd
		AND F4207.report_kind			=	@P_report_kind
		AND F4207.sharewith_employee_cd	=	@P_employee_cd_login
		AND F4207.del_datetime IS NULL
		GROUP BY
			F4207.company_cd
		,	F4207.fiscal_year
		,	F4207.employee_cd
		,	F4207.report_kind
		,	F4207.report_no
		,	F4207.sharewith_employee_cd
		
	) AS F4207_TEMP ON (
		F4200.company_cd		=	F4207_TEMP.company_cd
	AND F4200.fiscal_year		=	F4207_TEMP.fiscal_year
	AND F4200.employee_cd		=	F4207_TEMP.employee_cd
	AND F4200.report_kind		=	F4207_TEMP.report_kind
	AND F4200.report_no			=	F4207_TEMP.report_no
	)
	LEFT OUTER JOIN F4207 ON (
		F4207_TEMP.company_cd			=	F4207.company_cd
	AND F4207_TEMP.fiscal_year			=	F4207.fiscal_year
	AND F4207_TEMP.employee_cd			=	F4207.employee_cd
	AND F4207_TEMP.report_kind			=	F4207.report_kind
	AND F4207_TEMP.report_no			=	F4207.report_no
	AND	F4207_TEMP.shareby_employee_cd	=	F4207.shareby_employee_cd
	AND	F4207_TEMP.sharewith_employee_cd=	F4207.sharewith_employee_cd
	AND F4207.del_datetime IS NULL
	)
	WHERE 
		F4200.company_cd	= @P_company_cd
	AND	F4200.fiscal_year	= @P_fiscal_year
	AND F4200.employee_cd	= @P_employee_cd
	AND F4200.report_kind	= @P_report_kind
	AND (@P_year_month_start = ''
		OR ( @P_year_month_start <> '' AND (F4200.[year]*100 + F4200.[month])  >=  @P_year_month_start))
	AND	(@P_year_month_end =''
		OR (@P_year_month_end <> ''AND	(F4200.[year]*100 + F4200.[month])  <=  @P_year_month_end ))
	AND	F4200.del_datetime IS NULL
	AND ( @w_report_authority_typ >= 3
		OR(@w_report_authority_typ <3 AND @w_is_approver_viewer_share = 1))
	ORDER BY
		F4200.report_no ASC
	--
	IF(@w_report_authority_typ =3 AND @w_is_approver_viewer_share = 0)
	BEGIN
		UPDATE #RESULT SET 
			can_link = 1
		FROM #RESULT
	END
	--
	IF(@P_mode = 0)
	BEGIN
		SELECT
			title					AS	title	-- タイトル
		,	adequacy_kbn			AS	adequacy_kbn
		,	busyness_kbn			AS	busyness_kbn
		,	other_kbn				AS	other_kbn
		,	question        		AS	question
		,	answer					AS	answer
		,	fiscal_year				AS	fiscal_year
		,	employee_cd				AS	employee_cd
		,	report_kind				AS	report_kind
		,	report_no				AS	report_no
		,	can_link				AS  can_link
		FROM #RESULT				
	END
	ELSE
	BEGIN
		SELECT 
			@w_cre_user = ISNULL(S0010.[user_id],'')
		FROM S0010 
		WHERE 
			company_cd		= @P_company_cd
		AND employee_cd		= @P_employee_cd_login
		AND del_datetime	IS NULL
		--
		INSERT INTO  #TABLE_QUESTION_ANSWER
		SELECT
			#RESULT.company_cd				
		,	#RESULT.fiscal_year				
		,	#RESULT.employee_cd				
		,	#RESULT.report_kind				
		,	#RESULT.report_no				
		,	ISNULL(M4201.sheet_detail_no,0)			
		,	ISNULL(M4125.question_no,0)				
		,	ISNULL(M4201.question,'')		
		,	CASE 
				WHEN M4125.answer_kind = 1 THEN
					CASE 
						WHEN F4202_tr.answer_sentence IS NOT NULL THEN ISNULL(F4202_tr.answer_sentence,'')
						WHEN F4202_tr_blank.answer_sentence IS NOT NULL  THEN ISNULL(F4202_tr_blank.answer_sentence,'')
						ELSE ISNULL(F4202.answer_sentence,'')
					END
				WHEN M4125.answer_kind = 2  THEN CAST(ISNULL(F4202.answer_number,0) AS NVARCHAR(400))
				ELSE ISNULL(M4126.detail_name,'')	
			END
		FROM #RESULT 
		LEFT JOIN M4201 ON(
			#RESULT.company_cd		= M4201.company_cd									
		AND	#RESULT.report_kind		= M4201.report_kind		
		AND	#RESULT.sheet_cd			= M4201.sheet_cd
		AND	#RESULT.adaption_date		= M4201.adaption_date
		AND M4201.del_datetime IS NULL
		) 
		LEFT JOIN F4202 ON(
			#RESULT.company_cd		= F4202.company_cd		
		AND	#RESULT.fiscal_year		= F4202.fiscal_year		
		AND	#RESULT.employee_cd		= F4202.employee_cd		
		AND	#RESULT.report_kind		= F4202.report_kind		
		AND	#RESULT.report_no		= F4202.report_no		
		AND	M4201.question_no				= F4202.question_no
		) 
		LEFT JOIN F4202_tr ON(
			#RESULT.company_cd		= F4202_tr.company_cd		
		AND	#RESULT.fiscal_year		= F4202_tr.fiscal_year		
		AND	#RESULT.employee_cd		= F4202_tr.employee_cd		
		AND	#RESULT.report_kind		= F4202_tr.report_kind		
		AND	#RESULT.report_no			= F4202_tr.report_no		
		AND	M4201.question_no				= F4202_tr.question_no
		AND @w_cre_user						= F4202_tr.trans_user
		) 
		LEFT JOIN F4202_tr AS F4202_tr_blank ON(
			#RESULT.company_cd		= F4202_tr_blank.company_cd		
		AND	#RESULT.fiscal_year		= F4202_tr_blank.fiscal_year		
		AND	#RESULT.employee_cd		= F4202_tr_blank.employee_cd		
		AND	#RESULT.report_kind		= F4202_tr_blank.report_kind		
		AND	#RESULT.report_no			= F4202_tr_blank.report_no		
		AND	M4201.question_no				= F4202_tr_blank.question_no
		AND ''								= F4202_tr_blank.trans_user
		) 
		LEFT JOIN M4125 ON(
			F4202.company_cd		= M4125.company_cd										
		AND	F4202.question_no		= M4125.question_no
		AND M4125.del_datetime IS NULL
		) 
		LEFT JOIN M4126 ON(
			F4202.company_cd				= M4126.company_cd		
		AND	F4202.question_no				= M4126.question_no
		AND	F4202.answer_select				= M4126.detail_no
		AND M4126.del_datetime				IS NULL
		)
		--
		INSERT INTO #TABLE_QUESTION
		SELECT
			A.company_cd				
		,	A.fiscal_year				
		,	A.employee_cd				
		,	A.report_kind				
		,	Q_1.report_no
		,	Q_1.question_no
		,	Q_1.question_content
		,	Q_1.question_answer
		,	Q_2.question_no
		,	Q_2.question_content
		,	Q_2.question_answer
		,	Q_3.question_no
		,	Q_3.question_content
		,	Q_3.question_answer
		,	Q_4.question_no
		,	Q_4.question_content
		,	Q_4.question_answer
		,	Q_5.question_no
		,	Q_5.question_content
		,	Q_5.question_answer
		,	Q_6.question_no
		,	Q_6.question_content
		,	Q_6.question_answer
		,	Q_7.question_no
		,	Q_7.question_content
		,	Q_7.question_answer
		,	Q_8.question_no
		,	Q_8.question_content
		,	Q_8.question_answer
		,	Q_9.question_no
		,	Q_9.question_content
		,	Q_9.question_answer
		,	Q_10.question_no
		,	Q_10.question_content
		,	Q_10.question_answer
		FROM #RESULT AS A
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_1 ON(
			A.company_cd	= Q_1.company_cd
		AND A.fiscal_year	= Q_1.fiscal_year
		AND A.employee_cd	= Q_1.employee_cd
		AND A.report_kind	= Q_1.report_kind
		AND A.report_no		= Q_1.report_no
		AND Q_1.sheet_detail_no	= 1
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_2 ON(
			A.company_cd	= Q_2.company_cd
		AND A.fiscal_year	= Q_2.fiscal_year
		AND A.employee_cd	= Q_2.employee_cd
		AND A.report_kind	= Q_2.report_kind
		AND A.report_no		= Q_2.report_no
		AND Q_2.sheet_detail_no	= 2
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_3 ON(
			A.company_cd	= Q_3.company_cd
		AND A.fiscal_year	= Q_3.fiscal_year
		AND A.employee_cd	= Q_3.employee_cd
		AND A.report_kind	= Q_3.report_kind
		AND A.report_no		= Q_3.report_no
		AND Q_3.sheet_detail_no	= 3
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_4 ON(
			A.company_cd	= Q_4.company_cd
		AND A.fiscal_year	= Q_4.fiscal_year
		AND A.employee_cd	= Q_4.employee_cd
		AND A.report_kind	= Q_4.report_kind
		AND A.report_no		= Q_4.report_no
		AND Q_4.sheet_detail_no	= 4
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_5 ON(
			A.company_cd	= Q_5.company_cd
		AND A.fiscal_year	= Q_5.fiscal_year
		AND A.employee_cd	= Q_5.employee_cd
		AND A.report_kind	= Q_5.report_kind
		AND A.report_no		= Q_5.report_no
		AND Q_5.sheet_detail_no	= 5
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_6 ON(
			A.company_cd	= Q_6.company_cd
		AND A.fiscal_year	= Q_6.fiscal_year
		AND A.employee_cd	= Q_6.employee_cd
		AND A.report_kind	= Q_6.report_kind
		AND A.report_no		= Q_6.report_no
		AND Q_6.sheet_detail_no	= 6
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_7 ON(
			A.company_cd	= Q_7.company_cd
		AND A.fiscal_year	= Q_7.fiscal_year
		AND A.employee_cd	= Q_7.employee_cd
		AND A.report_kind	= Q_7.report_kind
		AND A.report_no		= Q_7.report_no
		AND Q_7.sheet_detail_no	= 7
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_8 ON(
			A.company_cd	= Q_8.company_cd
		AND A.fiscal_year	= Q_8.fiscal_year
		AND A.employee_cd	= Q_8.employee_cd
		AND A.report_kind	= Q_8.report_kind
		AND A.report_no		= Q_8.report_no
		AND Q_8.sheet_detail_no	= 8
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_9 ON(
			A.company_cd	= Q_9.company_cd
		AND A.fiscal_year	= Q_9.fiscal_year
		AND A.employee_cd	= Q_9.employee_cd
		AND A.report_kind	= Q_9.report_kind
		AND A.report_no		= Q_9.report_no
		AND Q_9.sheet_detail_no	= 9
		)
		LEFT JOIN #TABLE_QUESTION_ANSWER AS Q_10 ON(
			A.company_cd	= Q_10.company_cd
		AND A.fiscal_year	= Q_10.fiscal_year
		AND A.employee_cd	= Q_10.employee_cd
		AND A.report_kind	= Q_10.report_kind
		AND A.report_no		= Q_10.report_no
		AND Q_10.sheet_detail_no	= 10
		)
		--
		INSERT INTO #HEADER VALUES(		
			IIF(@w_language = 2, 'Title','タイトル') 
		,	IIF(@w_language = 2, 'Adequacy','充実度')
		,	IIF(@w_language = 2, 'Busyness','繁忙度')
		,	IIF(@w_language = 2, 'Other','その他')	
		,	IIF(@w_language = 2, 'Question1','質問1')	
		,	IIF(@w_language = 2, 'Answer1','回答1')	
		,	IIF(@w_language = 2, 'Question2','質問2')	
		,	IIF(@w_language = 2, 'Answer2','回答2')	
		,	IIF(@w_language = 2, 'Question3','質問3')	
		,	IIF(@w_language = 2, 'Answer3','回答3')	
		,	IIF(@w_language = 2, 'Question4','質問4')	
		,	IIF(@w_language = 2, 'Answer4','回答4')	
		,	IIF(@w_language = 2, 'Question5','質問5')	
		,	IIF(@w_language = 2, 'Answer5','回答5')	
		,	IIF(@w_language = 2, 'Question6','質問6')	
		,	IIF(@w_language = 2, 'Answer6','回答6')	
		,	IIF(@w_language = 2, 'Question7','質問7')	
		,	IIF(@w_language = 2, 'Answer 7','回答7')	
		,	IIF(@w_language = 2, 'Question8','質問8')	
		,	IIF(@w_language = 2, 'Answer 8','回答8')	
		,	IIF(@w_language = 2, 'Question 9','質問9')	
		,	IIF(@w_language = 2, 'Answer 9','回答9')
		,	IIF(@w_language = 2, 'Question 10','質問10')	
		,	IIF(@w_language = 2, 'Answer 10','回答10')
		)
		INSERT INTO #HEADER
		SELECT
			CONVERT(nvarchar(20),ISNULL(title,''))				AS	title	-- タイトル
		,	CONVERT(nvarchar(20),ISNULL(adequacy_kbn,0))			AS	adequacy_kbn
		,	CONVERT(nvarchar(20),ISNULL(busyness_kbn,0))			AS	busyness_kbn
		,	CONVERT(nvarchar(20),ISNULL(other_kbn,0))			AS	other_kbn
		,	#TABLE_QUESTION.question_content_1
		,	#TABLE_QUESTION.question_answer_1
		,	#TABLE_QUESTION.question_content_2
		,	#TABLE_QUESTION.question_answer_2
		,	#TABLE_QUESTION.question_content_3
		,	#TABLE_QUESTION.question_answer_3
		,	#TABLE_QUESTION.question_content_4
		,	#TABLE_QUESTION.question_answer_4
		,	#TABLE_QUESTION.question_content_5
		,	#TABLE_QUESTION.question_answer_5
		,	#TABLE_QUESTION.question_content_6
		,	#TABLE_QUESTION.question_answer_6
		,	#TABLE_QUESTION.question_content_7
		,	#TABLE_QUESTION.question_answer_7
		,	#TABLE_QUESTION.question_content_8
		,	#TABLE_QUESTION.question_answer_8
		,	#TABLE_QUESTION.question_content_9
		,	#TABLE_QUESTION.question_answer_9
		,	#TABLE_QUESTION.question_content_10
		,	#TABLE_QUESTION.question_answer_10
		FROM #RESULT	
		LEFT OUTER JOIN #TABLE_QUESTION ON(
				#RESULT.company_cd			=	#TABLE_QUESTION.company_cd
			AND #RESULT.fiscal_year			=	#TABLE_QUESTION.fiscal_year
			AND #RESULT.employee_cd			=	#TABLE_QUESTION.employee_cd
			AND #RESULT.report_kind			=	#TABLE_QUESTION.report_kind
			AND #RESULT.report_no			=	#TABLE_QUESTION.report_no
			)
		-- export CSV
		SELECT
			title													AS	title	-- タイトル
		,	adequacy_kbn											AS	adequacy_kbn
		,	busyness_kbn											AS	busyness_kbn
		,	other_kbn												AS	other_kbn
		,	replace(replace(#HEADER.question1, char(13), ' '), char(10), ' ')  	 question1
		,	replace(replace(#HEADER.answer1	 , char(13), ' '), char(10), ' ')	 answer1
		,	replace(replace(#HEADER.question2, char(13), ' '), char(10), ' ')	 question2
		,	replace(replace(#HEADER.answer2	, char(13), ' '), char(10), ' ')	 answer2	
		,	replace(replace(#HEADER.question3, char(13), ' '), char(10), ' ')	 question3
		,	replace(replace(#HEADER.answer3	, char(13), ' '), char(10), ' ')	 answer3	
		,	replace(replace(#HEADER.question4, char(13), ' '), char(10), ' ')	 question4
		,	replace(replace(#HEADER.answer4	, char(13), ' '), char(10), ' ')	 answer4	 
		,	replace(replace(#HEADER.question5, char(13), ' '), char(10), ' ')	 question5
		,	replace(replace(#HEADER.answer5	, char(13), ' '), char(10), ' ')	 answer5	 
		,	replace(replace(#HEADER.question6, char(13), ' '), char(10), ' ')	 question6
		,	replace(replace(#HEADER.answer6	, char(13), ' '), char(10), ' ')	 answer6	 
		,	replace(replace(#HEADER.question7, char(13), ' '), char(10), ' ')	 question7
		,	replace(replace(#HEADER.answer7	, char(13), ' '), char(10), ' ')	 answer7	 
		,	replace(replace(#HEADER.question8, char(13), ' '), char(10), ' ')	 question8
		,	replace(replace(#HEADER.answer8	, char(13), ' '), char(10), ' ')	 answer8	 
		,	replace(replace(#HEADER.question9, char(13), ' '), char(10), ' ')	 question9
		,	replace(replace(#HEADER.answer9	, char(13), ' '), char(10), ' ')	 answer9	 
		,	replace(replace(#HEADER.question10, char(13), ' '), char(10), ' ')	 question10
		,	replace(replace(#HEADER.answer10, char(13), ' '), char(10), ' ')	 answer10
		FROM #HEADER
	END


END
GO
