DROP PROCEDURE [SPC_M0100_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ M0100
-- EXEC [SPC_M0100_INQ1] '1'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	M0100_利用設定
--*  
--*  作成日/create date			:	2020/10/08						
--*　作成者/creater				:	nghianm								
--*
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_M0100_INQ1]
	@P_company_cd	SMALLINT = 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_Date					DATE			=	GETDATE()
	,	@YEAR					SMALLINT		=	0
	SET	@YEAR =  YEAR(@w_Date)	
	--CREATE TABLE #TEMP_F0300
	CREATE TABLE #TEMP_F0300(
		id							INT	IDENTITY(1,1)	
	,	company_cd					SMALLINT
	,	period_detail_no			SMALLINT
	)
	--
	INSERT INTO #TEMP_F0300
	SELECT 
		F0300.company_cd
	,	F0300.period_detail_no
	FROM F0300
	WHERE 
		F0300.company_cd	=	@P_company_cd
	--AND F0300.fiscal_year	=	@YEAR
	AND	F0300.del_datetime	IS	NULL
	GROUP BY 
		F0300.company_cd
	,	F0300.period_detail_no
	--CREATE TABLE #TEMP_F0011
	CREATE TABLE #TEMP_F0011(
		id							INT	IDENTITY(1,1)	
	,	company_cd					SMALLINT
	,	treatment_applications_no	SMALLINT
	,	use_typ						SMALLINT
	)
	--
	INSERT INTO #TEMP_F0011
	SELECT 
		F0011.company_cd
	,	F0011.treatment_applications_no
	,	MAX(F0011.use_typ)
	FROM F0011
	WHERE 
		F0011.company_cd	=	@P_company_cd
	--AND F0011.fiscal_year	=	@YEAR
	AND	F0011.del_datetime	IS	NULL
	GROUP BY 
		F0011.company_cd
	,	F0011.treatment_applications_no
	--[0]
	SELECT 
		ISNULL(company_cd,0)								AS	company_cd										
	,	ISNULL(target_management_typ,0)						AS	target_management_typ	
	,	CASE 
			WHEN	ISNULL(target_management_typ,0) = 1 
			THEN	'active'
			ELSE	''
		END													AS	target_management_typ_class									
	,	ISNULL(evaluation_use_typ,0)						AS	evaluation_use_typ	
	,	CASE 
			WHEN	ISNULL(evaluation_use_typ,0) = 1 
			THEN	'active'
			ELSE	''
		END													AS	evaluation_use_typ_class										
	,	ISNULL(interview_use_typ,0)							AS	interview_use_typ	
	,	CASE 
			WHEN	ISNULL(interview_use_typ,0) = 1 
			THEN	'active'
			ELSE	''
		END													AS	interview_use_typ_class	
	,	ISNULL(feedback_use_typ,0)							AS	feedback_use_typ	
	,	CASE 
			WHEN	ISNULL(feedback_use_typ,0) = 1 
			THEN	'active'
			ELSE	''
		END													AS	feedback_use_typ_class									
	,	ISNULL(target_self_assessment_typ,0)				AS	target_self_assessment_typ
	,	CASE 
			WHEN	ISNULL(target_management_typ,0) = 0
			THEN	'disabled'
			ELSE	IIF(ISNULL(target_self_assessment_typ,0)=1,'active','')
		END													AS	target_self_assessment_typ_class												
	,	ISNULL(target_evaluation_typ_1,0)					AS	target_evaluation_typ_1
	,	CASE 
			WHEN	ISNULL(target_management_typ,0) = 0		--OR	ISNULL(target_self_assessment_typ,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(target_evaluation_typ_1,0)=1,'active','')
		END													AS	target_evaluation_typ_1_class										
	,	ISNULL(target_evaluation_typ_2,0)					AS	target_evaluation_typ_2	
	,	CASE 
			WHEN	ISNULL(target_management_typ,0) = 0		--OR	ISNULL(target_self_assessment_typ,0) = 0 
				OR	ISNULL(target_evaluation_typ_1,0) = 0
			THEN 'disabled'
			ELSE IIF(ISNULL(target_evaluation_typ_2,0)=1,'active','')
		END													AS	target_evaluation_typ_2_class										
	,	ISNULL(target_evaluation_typ_3,0)					AS	target_evaluation_typ_3	
	,	CASE 
			WHEN	ISNULL(target_management_typ,0) = 0		--OR	ISNULL(target_self_assessment_typ,0) = 0 
				OR	ISNULL(target_evaluation_typ_1,0) = 0	OR	ISNULL(target_evaluation_typ_2,0) = 0
			THEN 'disabled'
			ELSE IIF(ISNULL(target_evaluation_typ_3,0)=1,'active','')
		END													AS	target_evaluation_typ_3_class										
	,	ISNULL(target_evaluation_typ_4,0)					AS	target_evaluation_typ_4	
	,	CASE 
			WHEN	ISNULL(target_management_typ,0) = 0		--OR	ISNULL(target_self_assessment_typ,0) = 0 
				OR	ISNULL(target_evaluation_typ_1,0) = 0	OR	ISNULL(target_evaluation_typ_2,0) = 0
				OR	ISNULL(target_evaluation_typ_3,0) = 0
			THEN 'disabled'
			ELSE IIF(ISNULL(target_evaluation_typ_4,0)=1,'active','')
		END													AS	target_evaluation_typ_4_class									
	,	ISNULL(evaluation_self_assessment_typ,0)			AS	evaluation_self_assessment_typ	
	,	CASE 
			WHEN	ISNULL(evaluation_use_typ,0) = 0
			THEN 'disabled'
			ELSE IIF(ISNULL(evaluation_self_assessment_typ,0)=1,'active','')	
		END													AS	evaluation_self_assessment_typ_class								
	,	ISNULL(evaluation_typ_1,0)							AS	evaluation_typ_1		
	,	CASE 
			WHEN	ISNULL(evaluation_use_typ,0) = 0		--OR	ISNULL(evaluation_self_assessment_typ,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(evaluation_typ_1,0)=1,'active','')
		END													AS	evaluation_typ_1_class								
	,	ISNULL(evaluation_typ_2,0)							AS	evaluation_typ_2	
	,	CASE 
			WHEN	ISNULL(evaluation_use_typ,0) = 0		--OR	ISNULL(evaluation_self_assessment_typ,0) = 0
				OR	ISNULL(evaluation_typ_1,0) = 0 
			THEN	'disabled'
			ELSE	IIF(ISNULL(evaluation_typ_2,0)=1,'active','')
		END													AS	evaluation_typ_2_class										
	,	ISNULL(evaluation_typ_3,0)							AS	evaluation_typ_3
	,	CASE 
			WHEN	ISNULL(evaluation_use_typ,0) = 0		--OR	ISNULL(evaluation_self_assessment_typ,0) = 0
				OR	ISNULL(evaluation_typ_1,0) = 0			OR	ISNULL(evaluation_typ_2,0) = 0 
			THEN	'disabled'
			ELSE	IIF(ISNULL(evaluation_typ_3,0)=1,'active','')
		END													AS	evaluation_typ_3_class											
	,	ISNULL(evaluation_typ_4,0)							AS	evaluation_typ_4	
	,	CASE 
			WHEN	ISNULL(evaluation_use_typ,0) = 0		--OR	ISNULL(evaluation_self_assessment_typ,0) = 0
				OR	ISNULL(evaluation_typ_1,0) = 0			OR	ISNULL(evaluation_typ_2,0) = 0		
				OR	ISNULL(evaluation_typ_3,0) = 0 
			THEN	'disabled'
			ELSE	IIF(ISNULL(evaluation_typ_4,0)=1,'active','')
		END													AS	evaluation_typ_4_class									
	,	ISNULL(rank_change_1,0)								AS	rank_change_1		
	,	CASE 
			WHEN	(ISNULL(target_management_typ,0) = 1		--AND	ISNULL(target_self_assessment_typ,0) = 1 
				AND	ISNULL(target_evaluation_typ_1,0) = 1)	
				OR	(ISNULL(evaluation_use_typ,0) = 1		--AND	ISNULL(evaluation_self_assessment_typ,0) = 1
				AND	ISNULL(evaluation_typ_1,0) = 1) 
			THEN	IIF(ISNULL(rank_change_1,0)=1,'active','')
			ELSE	'disabled'
		END													AS	rank_change_1_class									
	,	ISNULL(adjustpoint_input_1,0)						AS	adjustpoint_input_1	
	,	CASE 
			WHEN	(ISNULL(target_management_typ,0) = 1		--AND	ISNULL(target_self_assessment_typ,0) = 1 
				AND	ISNULL(target_evaluation_typ_1,0) = 1)	
				OR	(ISNULL(evaluation_use_typ,0) = 1		--AND	ISNULL(evaluation_self_assessment_typ,0) = 1
				AND	ISNULL(evaluation_typ_1,0) = 1) 
			THEN	IIF(ISNULL(adjustpoint_input_1,0)=1,'active','')
			ELSE	'disabled'
		END													AS	adjustpoint_input_1_class
	,	CAST(adjustpoint_from_1 as nvarchar(10))			AS	adjustpoint_from_1
	,	CAST(adjustpoint_to_1 as nvarchar(10))				AS	adjustpoint_to_1
	,	ISNULL(rank_change_2,0)								AS	rank_change_2
	,	CASE 
			WHEN	(ISNULL(target_management_typ,0) = 1	--AND	ISNULL(target_self_assessment_typ,0) = 1 
				AND	ISNULL(target_evaluation_typ_1,0) = 1	AND	ISNULL(target_evaluation_typ_2,0) = 1)
				OR	(ISNULL(evaluation_use_typ,0) = 1		--AND	ISNULL(evaluation_self_assessment_typ,0) = 1
				AND	ISNULL(evaluation_typ_1,0) = 1			AND	ISNULL(evaluation_typ_2,0) = 1) 	
			THEN	IIF(ISNULL(rank_change_2,0)=1,'active','')
			ELSE	'disabled'
		END													AS	rank_change_2_class													
	,	ISNULL(adjustpoint_input_2,0)						AS	adjustpoint_input_2
	,	CASE 
			WHEN	(ISNULL(target_management_typ,0) = 1	--AND	ISNULL(target_self_assessment_typ,0) = 1 
				AND	ISNULL(target_evaluation_typ_1,0) = 1	AND	ISNULL(target_evaluation_typ_2,0) = 1)
				OR	(ISNULL(evaluation_use_typ,0) = 1		--AND	ISNULL(evaluation_self_assessment_typ,0) = 1
				AND	ISNULL(evaluation_typ_1,0) = 1			AND	ISNULL(evaluation_typ_2,0) = 1) 	
			THEN	IIF(ISNULL(adjustpoint_input_2,0)=1,'active','')
			ELSE	'disabled'
		END													AS	adjustpoint_input_2_class
	,	CAST(adjustpoint_from_2 as nvarchar(10))			AS	adjustpoint_from_2
	,	CAST(adjustpoint_to_2 as nvarchar(10))				AS	adjustpoint_to_2
	,	ISNULL(rank_change_3,0)								AS	rank_change_3	
	,	CASE 
			WHEN	(ISNULL(target_management_typ,0) = 1	--AND	ISNULL(target_self_assessment_typ,0) = 1 
				AND	ISNULL(target_evaluation_typ_1,0) = 1	AND	ISNULL(target_evaluation_typ_2,0) = 1
				AND	ISNULL(target_evaluation_typ_3,0) = 1)
				OR	(ISNULL(evaluation_use_typ,0) = 1		--AND	ISNULL(evaluation_self_assessment_typ,0) = 1
				AND	ISNULL(evaluation_typ_1,0) = 1			AND	ISNULL(evaluation_typ_2,0) = 1 	
				AND	ISNULL(evaluation_typ_3,0) = 1 )		
			THEN	IIF(ISNULL(rank_change_3,0)=1,'active','')
			ELSE	'disabled'
		END													AS	rank_change_3_class										
	,	ISNULL(adjustpoint_input_3,0)						AS	adjustpoint_input_3	
	,	CASE 
			WHEN	(ISNULL(target_management_typ,0) = 1	--AND	ISNULL(target_self_assessment_typ,0) = 1 
				AND	ISNULL(target_evaluation_typ_1,0) = 1	AND	ISNULL(target_evaluation_typ_2,0) = 1
				AND	ISNULL(target_evaluation_typ_3,0) = 1)
				OR	(ISNULL(evaluation_use_typ,0) = 1		--AND	ISNULL(evaluation_self_assessment_typ,0) = 1
				AND	ISNULL(evaluation_typ_1,0) = 1			AND	ISNULL(evaluation_typ_2,0) = 1 	
				AND	ISNULL(evaluation_typ_3,0) = 1 )		
			THEN	IIF(ISNULL(adjustpoint_input_3,0)=1,'active','')
			ELSE	'disabled'
		END													AS	adjustpoint_input_3_class
	,	CAST(adjustpoint_from_3 as nvarchar(10))			AS	adjustpoint_from_3
	,	CAST(adjustpoint_to_3 as nvarchar(10))				AS	adjustpoint_to_3
	,	ISNULL(rank_change_4,0)								AS	rank_change_4	
	,	CASE 
			WHEN	(ISNULL(target_management_typ,0) = 1	--AND	ISNULL(target_self_assessment_typ,0) = 1 
				AND	ISNULL(target_evaluation_typ_1,0) = 1	AND	ISNULL(target_evaluation_typ_2,0) = 1
				AND	ISNULL(target_evaluation_typ_3,0) = 1	AND	ISNULL(target_evaluation_typ_4,0) = 1)
				OR	(ISNULL(evaluation_use_typ,0) = 1		--AND	ISNULL(evaluation_self_assessment_typ,0) = 1
				AND	ISNULL(evaluation_typ_1,0) = 1			AND	ISNULL(evaluation_typ_2,0) = 1 	
				AND	ISNULL(evaluation_typ_3,0) = 1			AND	ISNULL(evaluation_typ_4,0) = 1 )
			THEN	IIF(ISNULL(rank_change_4,0)=1,'active','')
			ELSE	'disabled'
		END													AS	rank_change_4_class										
	,	ISNULL(adjustpoint_input_4,0)						AS	adjustpoint_input_4
	,	CASE 
			WHEN	(ISNULL(target_management_typ,0) = 1	--AND	ISNULL(target_self_assessment_typ,0) = 1 
				AND	ISNULL(target_evaluation_typ_1,0) = 1	AND	ISNULL(target_evaluation_typ_2,0) = 1
				AND	ISNULL(target_evaluation_typ_3,0) = 1	AND	ISNULL(target_evaluation_typ_4,0) = 1)
				OR	(ISNULL(evaluation_use_typ,0) = 1		--AND	ISNULL(evaluation_self_assessment_typ,0) = 1
				AND	ISNULL(evaluation_typ_1,0) = 1			AND	ISNULL(evaluation_typ_2,0) = 1 	
				AND	ISNULL(evaluation_typ_3,0) = 1			AND	ISNULL(evaluation_typ_4,0) = 1 )
			THEN	IIF(ISNULL(adjustpoint_input_4,0)=1,'active','')
			ELSE	'disabled'
		END													AS	adjustpoint_input_4_class
	,	CAST(adjustpoint_from_4 as nvarchar(10))			AS	adjustpoint_from_4
	,	CAST(adjustpoint_to_4 as nvarchar(10))				AS	adjustpoint_to_4
	,	ISNULL(M0100.rater_interview_use_typ, 0)			AS	rater_interview_use_typ
	,	CASE
			WHEN ISNULL(interview_use_typ,0) = 0 THEN 'disabled' --add vietdt cr 2022/03/10
			WHEN ISNULL(rater_interview_use_typ,0) = 1 THEN 'active'
			ELSE ''
		END													AS	rater_interview_use_typ_class
	 FROM M0100 WITH(NOLOCK)
	 WHERE 
		(M0100.company_cd = @P_company_cd)
	AND	(m0100.del_datetime IS NULL)
	--[1]
	SELECT
		ISNULL(M0101.detail_no,0)			AS	detail_no
	,	ISNULL(M0101.period_nm,'')			AS	period_nm
	,	RIGHT(CONVERT(NVARCHAR(10),ISNULL(M0101.period_from,NULL),111),5)	AS	period_from		
	,	ISNULL(M0101.period_from,NULL)			AS	period_from_full	
	,	RIGHT(CONVERT(NVARCHAR(10),ISNULL(M0101.period_to,NULL),111),5)		AS	period_to		
	,	ISNULL(M0101.period_to,NULL)			AS	period_to_full	
	,	CASE 
			WHEN	TEMP.company_cd IS NULL
			THEN	1					
			ELSE	0
		END									AS	removeButton_flg
	FROM M0101
	LEFT OUTER JOIN #TEMP_F0300 AS TEMP ON (
		M0101.company_cd	=	TEMP.company_cd
	AND	M0101.detail_no		=	TEMP.period_detail_no
	)
	WHERE 
		M0101.company_cd= @P_company_cd
	AND	M0101.del_datetime IS NULL
	ORDER BY M0101.detail_no
	 --[2]
	SELECT
		ISNULL(M0102.detail_no,0)							AS	detail_no
	,	ISNULL(M0102.treatment_applications_nm,'')			AS	treatment_applications_nm		
	,	CASE 
		WHEN	TEMP.company_cd IS  NULL OR TEMP.use_typ != 1
		THEN	1
		ELSE	0
	END									AS	removeButton_flg
	FROM M0102
	LEFT OUTER JOIN #TEMP_F0011 AS TEMP ON (
		M0102.company_cd	=	TEMP.company_cd
	AND	M0102.detail_no		=	TEMP.treatment_applications_no
	)
	WHERE 
		M0102.company_cd= @P_company_cd
	AND	M0102.del_datetime IS NULL
	ORDER BY M0102.detail_no
	--[3]
	SELECT 
		number_cd
	,	name
	FROM L0010		
	WHERE L0010.name_typ = 3
	--DROP TABLE 
	DROP TABLE #TEMP_F0011
	DROP TABLE #TEMP_F0300
END
GO