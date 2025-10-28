DROP PROCEDURE [SPC_M0100_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_M0100_ACT1 '{}','1','::1','1';

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	SAVE DATA
--*  
--* 作成日/create date			:	2020/10/08										
--*	作成者/creater				:	nghianm						
--*   					
--*	更新日/update date			:  						
--*	更新者/updater				:　  　								     	 
--*	更新内容/update content		:	　	
--****************************************************************************************
CREATE PROCEDURE [SPC_M0100_ACT1] 
	-- Add the parameters for the stored procedure here
	@P_json			NVARCHAR(MAX)	= ''
,	@P_cre_user		NVARCHAR(50)	= ''
,	@P_cre_ip		NVARCHAR(50)	= ''
,	@P_company_cd	INT				= 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL							ERRTABLE	
	,	@order_by_min						INT					=	0
	,	@max_detail_no1						SMALLINT			=	0
	,	@max_detail_no2						SMALLINT			=	0
	,	@P_target_management_typ			TINYINT				=	0        
    ,	@P_target_self_assessment_typ       TINYINT				=	0        
    ,	@P_target_evaluation_typ_1          TINYINT				=	0        
    ,	@P_target_evaluation_typ_2          TINYINT				=	0        
    ,	@P_target_evaluation_typ_3          TINYINT				=	0        
    ,	@P_target_evaluation_typ_4          TINYINT				=	0        
    ,	@P_evaluation_use_typ               TINYINT				=	0        
    ,	@P_evaluation_self_assessment_typ   TINYINT				=	0        
    ,	@P_evaluation_typ_1                 TINYINT				=	0        
    ,	@P_evaluation_typ_2                 TINYINT				=	0        
    ,	@P_evaluation_typ_3                 TINYINT				=	0        
    ,	@P_evaluation_typ_4                 TINYINT				=	0        
    ,	@P_interview_use_typ                TINYINT				=	0  
	,	@P_feedback_use_typ					TINYINT				=	0      
    ,	@P_rank_change_1                    TINYINT				=	0        
    ,	@P_adjustpoint_input_1              TINYINT				=	0        
    ,	@P_adjustpoint_from_1               NUMERIC(8,2)		=	0
    ,	@P_adjustpoint_to_1					NUMERIC(8,2)		=	0
    ,	@P_rank_change_2                    TINYINT				=	0  
    ,	@P_adjustpoint_input_2              TINYINT				=	0 
    ,	@P_adjustpoint_from_2               NUMERIC(8,2)		=	0
    ,	@P_adjustpoint_to_2					NUMERIC(8,2)		=	0
    ,	@P_rank_change_3                    TINYINT				=	0 
    ,	@P_adjustpoint_input_3              TINYINT				=	0  
    ,	@P_adjustpoint_from_3               NUMERIC(8,2)		=	0
    ,	@P_adjustpoint_to_3                 NUMERIC(8,2)		=	0
    ,	@P_rank_change_4                    TINYINT				=	0  
    ,	@P_adjustpoint_input_4              TINYINT				=	0 
    ,	@P_adjustpoint_from_4               NUMERIC(8,2)		=	0
    ,	@P_adjustpoint_to_4                 NUMERIC(8,2)		=	0
    ,	@P_rater_interview_use_typ          TINYINT				=	0		
	--
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		-- assign
		SET	@P_target_management_typ            =	JSON_VALUE(@P_json,'$.target_management_typ')       
		SET	@P_target_self_assessment_typ       =	JSON_VALUE(@P_json,'$.target_self_assessment_typ')
		SET	@P_target_evaluation_typ_1          =	JSON_VALUE(@P_json,'$.target_evaluation_typ_1')    
		SET	@P_target_evaluation_typ_2          =	JSON_VALUE(@P_json,'$.target_evaluation_typ_2')    
		SET	@P_target_evaluation_typ_3          =	JSON_VALUE(@P_json,'$.target_evaluation_typ_3')    
		SET	@P_target_evaluation_typ_4          =	JSON_VALUE(@P_json,'$.target_evaluation_typ_4')    
		SET	@P_evaluation_use_typ               =	JSON_VALUE(@P_json,'$.evaluation_use_typ')         
		SET	@P_evaluation_self_assessment_typ   =	JSON_VALUE(@P_json,'$.evaluation_self_assessment_typ') 
		SET	@P_evaluation_typ_1                 =	JSON_VALUE(@P_json,'$.evaluation_typ_1')           
		SET	@P_evaluation_typ_2                 =	JSON_VALUE(@P_json,'$.evaluation_typ_2')           
		SET	@P_evaluation_typ_3                 =	JSON_VALUE(@P_json,'$.evaluation_typ_3')           
		SET	@P_evaluation_typ_4                 =	JSON_VALUE(@P_json,'$.evaluation_typ_4')           
		SET	@P_interview_use_typ                =	JSON_VALUE(@P_json,'$.interview_use_typ')  
		SET @P_feedback_use_typ					=	JSON_VALUE(@P_json,'$.feedback_use_typ')        
		SET	@P_rank_change_1                    =	JSON_VALUE(@P_json,'$.rank_change_1')              
		SET	@P_adjustpoint_input_1              =	JSON_VALUE(@P_json,'$.adjustpoint_input_1')        
		SET	@P_adjustpoint_from_1               =	IIF(JSON_VALUE(@P_json,'$.adjustpoint_from_1') = '' ,NULL,JSON_VALUE(@P_json,'$.adjustpoint_from_1'))         
		SET	@P_adjustpoint_to_1                 =	IIF(JSON_VALUE(@P_json,'$.adjustpoint_to_1')='',NULL,JSON_VALUE(@P_json,'$.adjustpoint_to_1'))           
		SET	@P_rank_change_2                    =	JSON_VALUE(@P_json,'$.rank_change_2')              
		SET	@P_adjustpoint_input_2              =	JSON_VALUE(@P_json,'$.adjustpoint_input_2')        
		SET	@P_adjustpoint_from_2               =	IIF(JSON_VALUE(@P_json,'$.adjustpoint_from_2')='',NULL,JSON_VALUE(@P_json,'$.adjustpoint_from_2'))         
		SET	@P_adjustpoint_to_2                 =	IIF(JSON_VALUE(@P_json,'$.adjustpoint_to_2')='',NULL,JSON_VALUE(@P_json,'$.adjustpoint_to_2'))           
		SET	@P_rank_change_3                    =	JSON_VALUE(@P_json,'$.rank_change_3')              
		SET	@P_adjustpoint_input_3              =	JSON_VALUE(@P_json,'$.adjustpoint_input_3')        
		SET	@P_adjustpoint_from_3               =	IIF(JSON_VALUE(@P_json,'$.adjustpoint_from_3')='',NULL,JSON_VALUE(@P_json,'$.adjustpoint_from_3'))         
		SET	@P_adjustpoint_to_3                 =	IIF(JSON_VALUE(@P_json,'$.adjustpoint_to_3')='',NULL,JSON_VALUE(@P_json,'$.adjustpoint_to_3'))           
		SET	@P_rank_change_4                    =	JSON_VALUE(@P_json,'$.rank_change_4')              
		SET	@P_adjustpoint_input_4              =	JSON_VALUE(@P_json,'$.adjustpoint_input_4')       
		SET	@P_adjustpoint_from_4               =	IIF(JSON_VALUE(@P_json,'$.adjustpoint_from_4')='',NULL,JSON_VALUE(@P_json,'$.adjustpoint_from_4'))        
		SET	@P_adjustpoint_to_4                 =	IIF(JSON_VALUE(@P_json,'$.adjustpoint_to_4')='',NULL,JSON_VALUE(@P_json,'$.adjustpoint_to_4'))            
		SET	@P_rater_interview_use_typ          =	JSON_VALUE(@P_json,'$.rater_interview_use_typ')
		-- CREATE TABLE #TEMP_M0101_INSERT
		CREATE TABLE #TEMP_M0101_INSERT (
			id				INT			IDENTITY(1,1)	
		,	detail_no		SMALLINT
		,	period_nm		NVARCHAR(50)
		,	period_from		NVARCHAR(10)
		,	period_to		NVARCHAR(10) 
		)
		--
		INSERT INTO #TEMP_M0101_INSERT
		SELECT
			JSON_VALUE([value],'$.detail_no')			AS	detail_no
		,	JSON_VALUE([value],'$.period_nm')			AS	period_nm
		,	IIF(JSON_VALUE([value],'$.period_from_full') = '',NULL,JSON_VALUE([value],'$.period_from_full'))  	AS	period_from
		,	IIF(JSON_VALUE([value],'$.period_to_full') = '',NULL,JSON_VALUE([value],'$.period_to_full'))		AS	period_to
		FROM OPENJSON(@P_json,'$.table_m0101')
		WHERE ISNULL(JSON_VALUE([value],'$.detail_no'),0) = 0 AND JSON_VALUE([value],'$.period_nm') <> ''
		-- CREATE TABLE #TEMP_M0101
		CREATE TABLE #TEMP_M0101_UPDATE (
			id				INT			IDENTITY(1,1)	
		,	detail_no		SMALLINT
		,	period_nm		NVARCHAR(50)
		,	period_from		NVARCHAR(10)
		,	period_to		NVARCHAR(10) 
		)
		--
		INSERT INTO #TEMP_M0101_UPDATE
		SELECT
			JSON_VALUE([value],'$.detail_no')																	AS	detail_no
		,	JSON_VALUE([value],'$.period_nm')																	AS	period_nm
		,	IIF(JSON_VALUE([value],'$.period_from_full') = '',NULL,JSON_VALUE([value],'$.period_from_full'))  	AS	period_from
		,	IIF(JSON_VALUE([value],'$.period_to_full') = '',NULL,JSON_VALUE([value],'$.period_to_full'))		AS	period_to
		FROM OPENJSON(@P_json,'$.table_m0101')
		WHERE ISNULL(JSON_VALUE([value],'$.detail_no'),0) <> 0

		-- CREATE TABLE #TEMP_M0102_INSERT
		CREATE TABLE #TEMP_M0102_INSERT (
			id								INT			IDENTITY(1,1)	
		,	detail_no						SMALLINT
		,	treatment_applications_nm		NVARCHAR(50)
		)
		--
		INSERT INTO #TEMP_M0102_INSERT
		SELECT
			JSON_VALUE([value],'$.detail_no')							AS	detail_no
		,	JSON_VALUE([value],'$.input_treatment_applications_nm')		AS	treatment_applications_nm
		FROM OPENJSON(@P_json,'$.table_m0102')
		WHERE ISNULL(JSON_VALUE([value],'$.detail_no'),0) = 0  
		-- CREATE TABLE #TEMP_M0102_UPDATE
		CREATE TABLE #TEMP_M0102_UPDATE (
			id								INT			IDENTITY(1,1)	
		,	detail_no						SMALLINT
		,	treatment_applications_nm		NVARCHAR(50)
		)
		--
		INSERT INTO #TEMP_M0102_UPDATE
		SELECT
			JSON_VALUE([value],'$.detail_no')							AS	detail_no
		,	JSON_VALUE([value],'$.input_treatment_applications_nm')		AS	treatment_applications_nm
		FROM OPENJSON(@P_json,'$.table_m0102')
		WHERE ISNULL(JSON_VALUE([value],'$.detail_no'),0) <> 0
				
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			--■ UPDATE M0100
			IF EXISTS (SELECT 1 FROM M0100 WHERE M0100.company_cd = @P_company_cd AND del_datetime IS NULL ) 
			BEGIN
			UPDATE M0100 SET 
				target_management_typ				=	@P_target_management_typ         
			,	target_self_assessment_typ       	=	@P_target_self_assessment_typ    
			,	target_evaluation_typ_1          	=	@P_target_evaluation_typ_1       
			,	target_evaluation_typ_2          	=	@P_target_evaluation_typ_2       
			,	target_evaluation_typ_3          	=	@P_target_evaluation_typ_3       
			,	target_evaluation_typ_4          	=	@P_target_evaluation_typ_4       
			,	evaluation_use_typ               	=	@P_evaluation_use_typ            
			,	evaluation_self_assessment_typ   	=	@P_evaluation_self_assessment_typ
			,	evaluation_typ_1                 	=	@P_evaluation_typ_1              
			,	evaluation_typ_2                 	=	@P_evaluation_typ_2              
			,	evaluation_typ_3                 	=	@P_evaluation_typ_3              
			,	evaluation_typ_4                 	=	@P_evaluation_typ_4              
			,	interview_use_typ                	=	@P_interview_use_typ 
			,	feedback_use_typ					=	@P_feedback_use_typ            
			,	rank_change_1                    	=	@P_rank_change_1
			,	rater_interview_use_typ             =	@P_rater_interview_use_typ                 
			,	adjustpoint_input_1              	=	@P_adjustpoint_input_1           
			,	adjustpoint_from_1               	=	@P_adjustpoint_from_1            
			,	adjustpoint_to_1                 	=	@P_adjustpoint_to_1              
			,	rank_change_2                    	=	@P_rank_change_2                 
			,	adjustpoint_input_2              	=	@P_adjustpoint_input_2           
			,	adjustpoint_from_2               	=	@P_adjustpoint_from_2            
			,	adjustpoint_to_2                 	=	@P_adjustpoint_to_2              
			,	rank_change_3                    	=	@P_rank_change_3                 
			,	adjustpoint_input_3              	=	@P_adjustpoint_input_3           
			,	adjustpoint_from_3               	=	@P_adjustpoint_from_3            
			,	adjustpoint_to_3                 	=	@P_adjustpoint_to_3              
			,	rank_change_4                    	=	@P_rank_change_4                 
			,	adjustpoint_input_4              	=	@P_adjustpoint_input_4           
			,	adjustpoint_from_4               	=	@P_adjustpoint_from_4            
			,	adjustpoint_to_4                 	=	@P_adjustpoint_to_4              
			,	upd_user							=	@P_cre_user			
			,	upd_ip								=	@P_cre_ip	
			,	upd_prg								=	'M0100'
			,	upd_datetime						=	@w_time		
			FROM M0100
			WHERE 
				M0100.company_cd	= @P_company_cd
			AND M0100.del_datetime	IS NULL
			END
			ELSE
			BEGIN
				--■ INSERT M0100
				INSERT INTO M0100 (
					company_cd	
				,	target_management_typ			
				,	target_self_assessment_typ      
				,	target_evaluation_typ_1         
				,	target_evaluation_typ_2         
				,	target_evaluation_typ_3         
				,	target_evaluation_typ_4         
				,	evaluation_use_typ              
				,	evaluation_self_assessment_typ  
				,	evaluation_typ_1                
				,	evaluation_typ_2                
				,	evaluation_typ_3                
				,	evaluation_typ_4                
				,	interview_use_typ  
				,	feedback_use_typ             
				,	rank_change_1                   
				,	adjustpoint_input_1             
				,	adjustpoint_from_1              
				,	adjustpoint_to_1                
				,	rank_change_2                   
				,	adjustpoint_input_2             
				,	adjustpoint_from_2              
				,	adjustpoint_to_2                
				,	rank_change_3                   
				,	adjustpoint_input_3             
				,	adjustpoint_from_3              
				,	adjustpoint_to_3                
				,	rank_change_4                   
				,	adjustpoint_input_4             
				,	adjustpoint_from_4              
				,	adjustpoint_to_4                
				--,	beginning_date
				--,	[1on1_beginning_date]
				--,	report_beginning_date
				--,	rater_interview_use_typ
				--,	password_length                 
				--,	password_character_limit        
				--,	password_age
				--,	mypurpose_use_typ
				,	cre_user
				,	cre_ip
				,	cre_prg
				,	cre_datetime
				)
				SELECT
					@P_company_cd	
				,	@P_target_management_typ     
				,	@P_target_self_assessment_typ
				,	@P_target_evaluation_typ_1   
				,	@P_target_evaluation_typ_2   
				,	@P_target_evaluation_typ_3   
				,	@P_target_evaluation_typ_4   
				,	@P_evaluation_use_typ        
				,	@P_evaluation_self_assessment_typ
				,	@P_evaluation_typ_1          
				,	@P_evaluation_typ_2          
				,	@P_evaluation_typ_3          
				,	@P_evaluation_typ_4          
				,	@P_interview_use_typ  
				,	@P_feedback_use_typ       
				,	@P_rank_change_1             
				,	@P_adjustpoint_input_1       
				,	@P_adjustpoint_from_1        
				,	@P_adjustpoint_to_1          
				,	@P_rank_change_2             
				,	@P_adjustpoint_input_2       
				,	@P_adjustpoint_from_2        
				,	@P_adjustpoint_to_2          
				,	@P_rank_change_3             
				,	@P_adjustpoint_input_3       
				,	@P_adjustpoint_from_3        
				,	@P_adjustpoint_to_3          
				,	@P_rank_change_4             
				,	@P_adjustpoint_input_4       
				,	@P_adjustpoint_from_4        
				,	@P_adjustpoint_to_4  
				
				--,	NULL
				--,	NULL
				--,	NULL
				--,	@P_rater_interview_use_typ
				--,	0           
				--,	0  
				--,	0
				--,	0
				,	@P_cre_user
				,	@P_cre_ip
				,	'M0100'
				,	@w_time
			END
			--M0101
			--■ UPDATE M0101
			IF EXISTS (SELECT 1 FROM #TEMP_M0101_UPDATE) 
			BEGIN
				--UPDATE M0101
				UPDATE M0101 SET 
					detail_no			=	TEMP.detail_no				
				,	period_nm			=	TEMP.period_nm	
				,	period_from			=	TEMP.period_from	
				,	period_to			=	TEMP.period_to	                               
				,	upd_user			=	@P_cre_user			
				,	upd_ip				=	@P_cre_ip	
				,	upd_prg				=	'M0100'
				,	upd_datetime		=	@w_time		
				FROM M0101
				INNER JOIN #TEMP_M0101_UPDATE AS TEMP ON (
					M0101.detail_no		= TEMP.detail_no
				)
				WHERE 
					M0101.company_cd	= @P_company_cd
				AND M0101.del_datetime	IS NULL
				--DELETE M0101
				UPDATE M0101 SET    
					del_user			=	@P_cre_user			
				,	del_ip				=	@P_cre_ip	
				,	del_prg				=	'M0100'
				,	del_datetime		=	@w_time		
				FROM M0101
				LEFT JOIN #TEMP_M0101_UPDATE AS TEMP ON (
					M0101.detail_no		= TEMP.detail_no
				)
				WHERE 
					M0101.company_cd	= @P_company_cd
				AND M0101.del_datetime	IS NULL
				AND TEMP.detail_no		IS NULL
			END
			ELSE
			BEGIN
				--DELETE M0101
				UPDATE M0101 SET    
					del_user			=	@P_cre_user			
				,	del_ip				=	@P_cre_ip	
				,	del_prg				=	'M0100'
				,	del_datetime		=	@w_time		
				FROM M0101
				WHERE 
					M0101.company_cd	= @P_company_cd
				AND M0101.del_datetime	IS NULL
			END
			--■ INSERT M0101
			IF EXISTS (SELECT 1 FROM #TEMP_M0101_INSERT) 
			BEGIN
				SET @max_detail_no1 = ISNULL((SELECT MAX(ISNULL(M0101.detail_no,0)) FROM M0101 WHERE company_cd = @P_company_cd),0) 
				INSERT INTO M0101 (
					company_cd	
				,	detail_no			
				,	period_nm      
				,	period_from         
				,	period_to                            				
				,	cre_user
				,	cre_ip
				,	cre_prg
				,	cre_datetime
				)
				SELECT
					@P_company_cd	
				,	@max_detail_no1+TEMP.id     
				,	TEMP.period_nm      
				,	TEMP.period_from         
				,	TEMP.period_to                     
				,	@P_cre_user
				,	@P_cre_ip
				,	'M0100'
				,	@w_time
				FROM #TEMP_M0101_INSERT AS TEMP
			END
			--M0102
			--■ UPDATE M0102
			IF EXISTS (SELECT 1 FROM #TEMP_M0102_UPDATE) 
			BEGIN
				UPDATE M0102 SET 
					detail_no					=	TEMP.detail_no				
				,	treatment_applications_nm	=	TEMP.treatment_applications_nm	                               
				,	upd_user					=	@P_cre_user			
				,	upd_ip						=	@P_cre_ip	
				,	upd_prg						=	'M0100'
				,	upd_datetime				=	@w_time		
				FROM M0102
				INNER JOIN #TEMP_M0102_UPDATE AS TEMP ON (
					M0102.detail_no		= TEMP.detail_no
				)
				WHERE 
					M0102.company_cd	= @P_company_cd
				AND M0102.del_datetime	IS NULL
				--DELETE M0102
				UPDATE M0102 SET    
					del_user			=	@P_cre_user			
				,	del_ip				=	@P_cre_ip	
				,	del_prg				=	'M0100'
				,	del_datetime		=	@w_time		
				FROM M0102
				LEFT JOIN #TEMP_M0102_UPDATE AS TEMP ON (
					M0102.detail_no		= TEMP.detail_no
				)
				WHERE 
					M0102.company_cd	= @P_company_cd
				AND M0102.del_datetime	IS NULL
				AND TEMP.detail_no		IS NULL
			END
			ELSE
			BEGIN
				--DELETE M0102
				UPDATE M0102 SET    
					del_user			=	@P_cre_user			
				,	del_ip				=	@P_cre_ip	
				,	del_prg				=	'M0100'
				,	del_datetime		=	@w_time		
				FROM M0102
				WHERE 
					M0102.company_cd	= @P_company_cd
				AND M0102.del_datetime	IS NULL
			END
			IF EXISTS (SELECT 1 FROM #TEMP_M0102_INSERT) 
			BEGIN
				SET @max_detail_no2 = ISNULL((SELECT MAX(ISNULL(M0102.detail_no,0)) FROM M0102 WHERE company_cd = @P_company_cd),0) 
				--■ INSERT M0101
				INSERT INTO M0102 (
					company_cd	
				,	detail_no			
				,	treatment_applications_nm                                 				
				,	cre_user
				,	cre_ip
				,	cre_prg
				,	cre_datetime
				)
				SELECT
					@P_company_cd	
				,	@max_detail_no2+TEMP.id     
				,	TEMP.treatment_applications_nm                         
				,	@P_cre_user
				,	@P_cre_ip
				,	'M0100'
				,	@w_time
				FROM #TEMP_M0102_INSERT AS TEMP
			END
			--UPDATE M0310
			IF EXISTS (SELECT 1 FROM M0310 WHERE company_cd = @P_company_cd AND del_datetime IS NULL)
			BEGIN
				--（目標）
				UPDATE M0310
				SET 
					M0310.status_use_typ	=	CASE 
													WHEN	(M0310.status_cd	=	3		AND	@P_target_self_assessment_typ	=	1)
														OR	(M0310.status_cd	=	4		AND	@P_target_evaluation_typ_1		=	1)
														OR	(M0310.status_cd	=	5		AND	@P_target_evaluation_typ_2		=	1)
														OR	(M0310.status_cd	=	6		AND	@P_target_evaluation_typ_3		=	1)
														OR	(M0310.status_cd	=	7		AND	@P_target_evaluation_typ_4		=	1)
														OR	(M0310.status_cd	>=	9		AND M0310.status_cd					<=	11
																							AND	@P_feedback_use_typ				=	1)
													THEN	1
													ELSE	0
												END	
				,	upd_user				=	@P_cre_user
				,	upd_ip					=	@P_cre_ip
				,	upd_prg					=	'M0100'
				,	upd_datetime			=	@w_time
				FROM M0310
				WHERE 
					M0310.company_cd	=	@P_company_cd
				AND	M0310.category		=	1
				AND	M0310.status_cd		>=	3
				AND	M0310.status_cd		<=	11
				AND	M0310.status_cd		<>	8
				AND	M0310.del_datetime	IS NULL
				--（評価）
				UPDATE M0310
				SET 
					M0310.status_use_typ	=	CASE 
													WHEN	(M0310.status_cd	=	1		AND	@P_evaluation_self_assessment_typ	=	1)
														OR	(M0310.status_cd	=	2		AND	@P_evaluation_typ_1					=	1)
														OR	(M0310.status_cd	=	3		AND	@P_evaluation_typ_2					=	1)
														OR	(M0310.status_cd	=	4		AND	@P_evaluation_typ_3					=	1)
														OR	(M0310.status_cd	=	5		AND	@P_evaluation_typ_4					=	1)
														OR	(M0310.status_cd	>=	7		AND M0310.status_cd						<=	9
																							AND	@P_feedback_use_typ					=	1)
													THEN	1
													ELSE	0
												END	
				,	upd_user				=	@P_cre_user
				,	upd_ip					=	@P_cre_ip
				,	upd_prg					=	'M0100'
				,	upd_datetime			=	@w_time
				FROM M0310
				WHERE 
					M0310.company_cd	=	@P_company_cd
				AND	M0310.category		=	2
				AND	M0310.status_cd		>=	1
				AND	M0310.status_cd		<=	9
				AND	M0310.status_cd		<>	6
				AND	M0310.del_datetime	IS NULL
			END
			--UPDATE M0310 category = 3 Datnt 2019-01-14
			IF(@P_target_management_typ = 1 )
			BEGIN
				UPDATE M0310 SET
					status_use_typ = 1
					,	upd_user				=	@P_cre_user
					,	upd_ip					=	@P_cre_ip
					,	upd_prg					=	'M0100'
					,	upd_datetime			=	@w_time
				FROM M0310
				WHERE M0310.company_cd	= @P_company_cd
					AND M0310.category	= 3
					AND M0310.status_cd = 1
			END
			IF(@P_interview_use_typ = 0 )
			BEGIN
				UPDATE M0310 SET
					status_use_typ = 0
				,	upd_user				=	@P_cre_user
				,	upd_ip					=	@P_cre_ip
				,	upd_prg					=	'M0100'
				,	upd_datetime			=	@w_time
				FROM M0310
				WHERE M0310.company_cd	= @P_company_cd
					AND M0310.category	= 3
					AND M0310.status_cd > 1 AND M0310.status_cd < 12
			END
			
				UPDATE M0310 SET
					status_use_typ = CASE	WHEN @P_feedback_use_typ = 1
											THEN 1
											ELSE 0
									END
				,	upd_user				=	@P_cre_user
				,	upd_ip					=	@P_cre_ip
				,	upd_prg					=	'M0100'
				,	upd_datetime			=	@w_time
				FROM M0310
				WHERE M0310.company_cd	= @P_company_cd
					AND M0310.category	= 3
					AND M0310.status_cd = 12

			-- UPDATE detail_no 
				UPDATE M0310 SET
					detail_no = CASE WHEN M0310.category IN(1,2) THEN #M0310.detail_no - 1
									ELSE #M0310.detail_no
									END
				,	upd_user				=	@P_cre_user
				,	upd_ip					=	@P_cre_ip
				,	upd_prg					=	'M0100'
				,	upd_datetime			=	@w_time
				FROM M0310 
				INNER JOIN  (
					SELECT 
						company_cd
					,	category
					,	status_cd
					,	RANK () OVER ( PARTITION BY category
										ORDER BY status_cd ASC
									) detail_no 
					FROM M0310
					WHERE M0310.status_use_typ = 1
					AND M0310.company_cd	= @P_company_cd
					AND del_datetime IS NULL
				) AS #M0310 ON(
						M0310.company_cd	= #M0310.company_cd
					AND M0310.category	= #M0310.category
					AND M0310.status_cd = #M0310.status_cd
				)
				UPDATE M0310 SET
					detail_no = NULL
				,	upd_user				=	@P_cre_user
				,	upd_ip					=	@P_cre_ip
				,	upd_prg					=	'M0100'
				,	upd_datetime			=	@w_time
				WHERE M0310.company_cd	= @P_company_cd
				  AND status_use_typ = 0
				  AND del_datetime IS NULL
				
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
	--■DROP TABLE
	--DROP TABLE #TEMP_M0101_INSERT
	--DROP TABLE #TEMP_M0101_UPDATE
	--DROP TABLE #TEMP_M0102_INSERT
	--DROP TABLE #TEMP_M0102_UPDATE
END

GO
