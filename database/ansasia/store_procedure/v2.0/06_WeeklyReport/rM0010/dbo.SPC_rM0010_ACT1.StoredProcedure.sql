DROP PROCEDURE [SPC_rM0010_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_M0100_ACT1 '{}','1','::1','1';
--select * from M4101

--	EXEC SPC_rM0010_ACT1 '{"annual_report_typ":"1","target_self_assessment_typ":"","first_annual_report_typ":"1","second_annual_report_typ":"0","third_annual_report_typ":"0","fourth_annual_report_typ":"0","semi_annual_report_typ":"1","first_semi_annual_report_typ":"1","second_semi_annual_report_typ":"1","third_semi_annual_report_typ":"0","fourth_semi_annual_report_typ":"0","quarterly_report_typ":"","first_quarterly_report_typ":"1","second_quarterly_report_typ":"1","third_quarterly_report_typ":"0","fourth_quarterly_report_typ":"0","monthly_report_typ":"0","first_monthly_report_typ":"0","second_monthly_report_typ":"0","third_monthly_report_typ":"0","fourth_monthly_report_typ":"0","weekly_report_typ":"0","first_weekly_report_typ":"0","second_weekly_report_typ":"0","third_weekly_report_typ":"0","fourth_weekly_report_typ":"0","sticky_2":[{"note_name":"要注意","detail_no":"","note_color":"1"},{"note_name":"素晴らしい","detail_no":"","note_color":"1"},{"note_name":"様子見","detail_no":"","note_color":"1"},{"note_name":"危険","detail_no":"1","note_color":"1"}],"sticky":[{"note_name":"要注意","detail_no":"6","note_color":"1"},{"note_name":"素晴らしい","detail_no":"7","note_color":"1"},{"note_name":"様子見","detail_no":"2","note_color":"1"},{"note_name":"危険","detail_no":"1","note_color":"1"}],"viewer_sharing":"0","share_notify_reporter":"0","viewable_deadline_kbn":"0"}','namnt','192.168.5.118','10036';
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	SAVE DATA
--*   
--* 作成日/create date			:	2023/04/04										
--*	作成者/creater				:	namnt					
--*   					
--*	更新日/update date			:  						
--*	更新者/updater				:　  　	 							     	 
--*	更新内容/update content		:	　	
--****************************************************************************************
CREATE PROCEDURE [SPC_rM0010_ACT1] 
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
	,	@w_annual_report_typ				TINYINT				=	0        
    ,	@w_first_annual_report_typ			TINYINT				=	0        
    ,	@w_second_annual_report_typ         TINYINT				=	0        
    ,	@w_third_annual_report_typ          TINYINT				=	0        
    ,	@w_fourth_annual_report_typ         TINYINT				=	0        
    ,	@w_semi_annual_report_typ			TINYINT				=	0        
    ,	@w_first_semi_annual_report_typ     TINYINT				=	0        
    ,	@w_second_semi_annual_report_typ	TINYINT				=	0        
    ,	@w_third_semi_annual_report_typ     TINYINT				=	0        
    ,	@w_fourth_semi_annual_report_typ    TINYINT				=	0        
    ,	@w_quarterly_report_typ             TINYINT				=	0        
    ,	@w_first_quarterly_report_typ       TINYINT				=	0        
    ,	@w_second_quarterly_report_typ      TINYINT				=	0  
	,	@w_third_quarterly_report_typ		TINYINT				=	0      
    ,	@w_fourth_quarterly_report_typ      TINYINT				=	0        
    ,	@w_monthly_report_typ				TINYINT				=	0
	,	@w_first_monthly_report_typ         TINYINT				=	0
	,	@w_second_monthly_report_typ        TINYINT				=	0
	,	@w_third_monthly_report_typ         TINYINT				=	0
	,	@w_fourth_monthly_report_typ        TINYINT				=	0
	,	@w_weekly_report_typ				TINYINT				=	0
	,	@w_first_weekly_report_typ          TINYINT				=	0
	,	@w_second_weekly_report_typ         TINYINT				=	0
	,	@w_third_weekly_report_typ          TINYINT				=	0
	,	@w_fourth_weekly_report_typ         TINYINT				=	0
    ,	@w_weeklyreport_deadline			SMALLINT			=	0	
	,	@w_weeklyreport_judgment_date		SMALLINT			=	0	
	,	@w_viewing_sharing					TINYINT				=	0	
	,	@w_share_notify_reporter			TINYINT				=	0	
	,	@w_viewable_deadline_kbn			TINYINT				=	0	
	,	@w_monthlyreport_deadline			SMALLINT			=	0
	,	@w_comment_option_use_typ				TINYINT				=	0
	,	@w_comment_option_authorizer_use_typ	TINYINT				=	0
	,	@w_comment_option_viewer_use_typ		TINYINT				=	0
	--
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		-- assign
		SET	@w_annual_report_typ				=	JSON_VALUE(@P_json,'$.annual_report_typ')       
		SET	@w_first_annual_report_typ			=	JSON_VALUE(@P_json,'$.first_annual_report_typ')
		SET	@w_second_annual_report_typ			=	JSON_VALUE(@P_json,'$.second_annual_report_typ')    
		SET	@w_third_annual_report_typ			=	JSON_VALUE(@P_json,'$.third_annual_report_typ')    
		SET	@w_fourth_annual_report_typ			=	JSON_VALUE(@P_json,'$.fourth_annual_report_typ')    
		SET	@w_semi_annual_report_typ			=	JSON_VALUE(@P_json,'$.semi_annual_report_typ')    
		SET	@w_first_semi_annual_report_typ		=	JSON_VALUE(@P_json,'$.first_semi_annual_report_typ')         
		SET	@w_second_semi_annual_report_typ	=	JSON_VALUE(@P_json,'$.second_semi_annual_report_typ') 
		SET	@w_third_semi_annual_report_typ		=	JSON_VALUE(@P_json,'$.third_semi_annual_report_typ')           
		SET	@w_fourth_semi_annual_report_typ	=	JSON_VALUE(@P_json,'$.fourth_semi_annual_report_typ')           
		SET	@w_quarterly_report_typ				=	JSON_VALUE(@P_json,'$.quarterly_report_typ')           
		SET	@w_first_quarterly_report_typ		=	JSON_VALUE(@P_json,'$.first_quarterly_report_typ')           
		SET	@w_second_quarterly_report_typ		=	JSON_VALUE(@P_json,'$.second_quarterly_report_typ')  
		SET	@w_third_quarterly_report_typ		=	JSON_VALUE(@P_json,'$.third_quarterly_report_typ')        
		SET	@w_fourth_quarterly_report_typ		=	JSON_VALUE(@P_json,'$.fourth_quarterly_report_typ')              
		SET	@w_monthly_report_typ				=	JSON_VALUE(@P_json,'$.monthly_report_typ')        
		SET	@w_first_monthly_report_typ			=	JSON_VALUE(@P_json,'$.first_monthly_report_typ')           
		SET	@w_second_monthly_report_typ		=	JSON_VALUE(@P_json,'$.second_monthly_report_typ')      
		SET	@w_third_monthly_report_typ			=	JSON_VALUE(@P_json,'$.third_monthly_report_typ')     
		SET	@w_fourth_monthly_report_typ		=	JSON_VALUE(@P_json,'$.fourth_monthly_report_typ') 
		SET	@w_monthlyreport_deadline			=	JSON_VALUE(@P_json,'$.monthlyreport_deadline') 
		SET	@w_weekly_report_typ				=	JSON_VALUE(@P_json,'$.weekly_report_typ')        
		SET	@w_first_weekly_report_typ			=	JSON_VALUE(@P_json,'$.first_weekly_report_typ')           
		SET	@w_second_weekly_report_typ			=	JSON_VALUE(@P_json,'$.second_weekly_report_typ')      
		SET	@w_third_weekly_report_typ			=	JSON_VALUE(@P_json,'$.third_weekly_report_typ')     
		SET	@w_fourth_weekly_report_typ			=	JSON_VALUE(@P_json,'$.fourth_weekly_report_typ') 
		SET	@w_weeklyreport_deadline			=	JSON_VALUE(@P_json,'$.weeklyreport_deadline')              
		SET	@w_weeklyreport_judgment_date		=	JSON_VALUE(@P_json,'$.weeklyreport_judgment_date') 
		SET	@w_viewing_sharing					=	JSON_VALUE(@P_json,'$.viewer_sharing')
		SET	@w_share_notify_reporter			=	JSON_VALUE(@P_json,'$.share_notify_reporter')         
		SET	@w_viewable_deadline_kbn			=	JSON_VALUE(@P_json,'$.viewable_deadline_kbn')  
		SET	@w_comment_option_use_typ			 =	JSON_VALUE(@P_json,'$.comment_option_use_typ')
		SET	@w_comment_option_authorizer_use_typ =	JSON_VALUE(@P_json,'$.approver')
		SET	@w_comment_option_viewer_use_typ	 =	JSON_VALUE(@P_json,'$.viewer')
		-- CREATE TABLE #TEMP_M4101 approver
		CREATE TABLE #TEMP_M4101_INSERT (
			id				INT			
		,	detail_no		SMALLINT
		,	company_cd		SMALLINT
		,	note_kind		SMALLINT
		,	note_color		SMALLINT
		,	note_name		NVARCHAR(10)
		)
		CREATE TABLE #TEMP_M4101_UPDATE (
			id				INT		
		,	detail_no		SMALLINT
		,	company_cd		SMALLINT
		,	note_kind		SMALLINT
		,	note_color		SMALLINT
		,	note_name		NVARCHAR(10)
		,	cre_user		NVARCHAR(50)
		,	cre_ip			NVARCHAR(50)
		,	cre_datetime	DATETIME
		)
		--
		INSERT INTO #TEMP_M4101_INSERT
		SELECT
			row_number() OVER (ORDER BY (SELECT NULL))
		,	NULL
		,	@P_company_cd
		,	1
		,	JSON_VALUE([value],'$.note_color')			AS	note_color
		,	IIF(JSON_VALUE([value],'$.note_name') = '',NULL,JSON_VALUE([value],'$.note_name'))  	AS	note_name
		FROM OPENJSON(@P_json,'$.sticky_2')
		WHERE ISNULL(JSON_VALUE([value],'$.detail_no'),0) = 0
		INSERT INTO #TEMP_M4101_UPDATE
		SELECT
			row_number() OVER(ORDER BY (SELECT NULL))
		,	JSON_VALUE([value],'$.detail_no')			AS	detail_no
		,	@P_company_cd
		,	1
		,	JSON_VALUE([value],'$.note_color')			AS	note_color
		,	IIF(JSON_VALUE([value],'$.note_name') = '',NULL,JSON_VALUE([value],'$.note_name'))  	AS	note_name
		,	''
		,	''
		,	NULL
		FROM OPENJSON(@P_json,'$.sticky_2')
		WHERE ISNULL(JSON_VALUE([value],'$.detail_no'),0) <> 0
		INSERT INTO #TEMP_M4101_INSERT
		SELECT
			row_number() OVER (ORDER BY (SELECT NULL))
		,	NULL
		,	@P_company_cd
		,	2
		,	JSON_VALUE([value],'$.note_color')			AS	note_color
		,	IIF(JSON_VALUE([value],'$.note_name') = '',NULL,JSON_VALUE([value],'$.note_name'))  	AS	note_name
		FROM OPENJSON(@P_json,'$.sticky')
		WHERE ISNULL(JSON_VALUE([value],'$.detail_no'),0) = 0
		INSERT INTO #TEMP_M4101_UPDATE
		SELECT
			row_number() OVER (ORDER BY (SELECT NULL))
		,	JSON_VALUE([value],'$.detail_no')			AS	detail_no
		,	@P_company_cd
		,	2				
		,	JSON_VALUE([value],'$.note_color')			AS	note_color
		,	IIF(JSON_VALUE([value],'$.note_name') = '',NULL,JSON_VALUE([value],'$.note_name'))  	AS	note_name
		,	''
		,	''
		,	NULL
		FROM OPENJSON(@P_json,'$.sticky')
		WHERE ISNULL(JSON_VALUE([value],'$.detail_no'),0) <> 0
		UPDATE #TEMP_M4101_UPDATE SET
			#TEMP_M4101_UPDATE.cre_user = M4101.cre_user
		,	#TEMP_M4101_UPDATE.cre_ip	= M4101.cre_ip
		,	#TEMP_M4101_UPDATE.cre_datetime	= M4101.cre_datetime
		FROM #TEMP_M4101_UPDATE LEFT JOIN M4101 ON(
		 M4101.company_cd = #TEMP_M4101_UPDATE.company_cd
		 AND M4101.note_kind = #TEMP_M4101_UPDATE.note_kind
		 AND M4101.detail_no = #TEMP_M4101_UPDATE.detail_no
		 )
		DELETE FROM M4101
		WHERE M4101.company_cd = @P_company_cd
		IF EXISTS (SELECT 1 FROM #TEMP_M4101_UPDATE) 
			BEGIN
				SET @max_detail_no1 = ISNULL((SELECT MAX(ISNULL(M4101.detail_no,0)) FROM M4101 WHERE company_cd = @P_company_cd),0) 
				INSERT INTO M4101
				SELECT
					@P_company_cd
				,	note_kind
				,	TEMP.detail_no         
				,	note_color         
				,	note_name                     
				,	TEMP.cre_user
				,	TEMP.cre_ip
				,	'rM0010'
				,	TEMP.cre_datetime
				,	@P_cre_user
				,	@P_cre_ip
				,	'rM0010'
				,	@w_time
				,	NULL
				,	NULL
				,	''
				,	NULL
				FROM #TEMP_M4101_UPDATE AS TEMP
			END
			--insert 
			IF EXISTS (SELECT 1 FROM #TEMP_M4101_INSERT) 
			BEGIN
				SET @max_detail_no1 = ISNULL((SELECT MAX(ISNULL(M4101.detail_no,0)) FROM M4101 WHERE company_cd = @P_company_cd AND M4101.note_kind = 1),0) 
				SET @max_detail_no2 = ISNULL((SELECT MAX(ISNULL(M4101.detail_no,0)) FROM M4101 WHERE company_cd = @P_company_cd AND M4101.note_kind = 2),0) 
				INSERT INTO M4101 
				SELECT
					@P_company_cd
				,	note_kind
				,	IIF(note_kind = 1,@max_detail_no1+TEMP.id,@max_detail_no2+TEMP.id)         
				,	note_color         
				,	note_name                     
				,	@P_cre_user
				,	@P_cre_ip
				,	'rM0010'
				,	@w_time
				,	NULL
				,	NULL
				,	''
				,	NULL
				,	NULL
				,	NULL
				,	''
				,	NULL
				FROM #TEMP_M4101_INSERT AS TEMP
			END
		IF NOT EXISTS (SELECT 1 FROM M4100 WHERE M4100.company_cd = @P_company_cd)
		BEGIN
			INSERT INTO M4100 
			SELECT
				@P_company_cd
			,	@w_annual_report_typ			
			,	@w_first_annual_report_typ		
			,	@w_second_annual_report_typ		
			,	@w_third_annual_report_typ		
			,	@w_fourth_annual_report_typ		
			,	@w_semi_annual_report_typ		
			,	@w_first_semi_annual_report_typ	
			,	@w_second_semi_annual_report_typ
			,	@w_third_semi_annual_report_typ	
			,	@w_fourth_semi_annual_report_typ
			,	@w_quarterly_report_typ			
			,	@w_first_quarterly_report_typ	
			,	@w_second_quarterly_report_typ	
			,	@w_third_quarterly_report_typ	
			,	@w_fourth_quarterly_report_typ	
			,	@w_monthly_report_typ			
			,	@w_first_monthly_report_typ		
			,	@w_second_monthly_report_typ	
			,	@w_third_monthly_report_typ		
			,	@w_fourth_monthly_report_typ
			,	@w_monthlyreport_deadline
			,	@w_weekly_report_typ			
			,	@w_first_weekly_report_typ		
			,	@w_second_weekly_report_typ		
			,	@w_third_weekly_report_typ		
			,	@w_fourth_weekly_report_typ		
			,	@w_weeklyreport_deadline		
			,	@w_weeklyreport_judgment_date	
			,	@w_viewing_sharing				
			,	@w_share_notify_reporter		
			,	@w_viewable_deadline_kbn	
			,	@w_comment_option_use_typ			
			,	@w_comment_option_authorizer_use_typ
			,	@w_comment_option_viewer_use_typ	
			,	@P_cre_user
			,	@P_cre_ip
			,	'rM0010'
			,	@w_time
			,	NULL
			,	NULL
			,	''
			,	NULL
			,	NULL
			,	NULL
			,	''
			,	NULL
		END
		ELSE
		BEGIN
			UPDATE M4100 SET
				annualreport_user_typ						=   @w_annual_report_typ			
			,	annualreport_first_approval					=   @w_first_annual_report_typ		
			,	annualreport_second_approval				=   @w_second_annual_report_typ		
			,	annualreport_third_approval					=   @w_third_annual_report_typ		
			,	annualreport_fourth_approval				=   @w_fourth_annual_report_typ		
			,	semi_annualreport_user_typ					=   @w_semi_annual_report_typ		
			,	semi_annualreport_first_approval			=   @w_first_semi_annual_report_typ
			,	semi_annualreport_second_approval			=   @w_second_semi_annual_report_typ
			,	semi_annualreport_third_approval			=   @w_third_semi_annual_report_typ
			,	semi_annualreport_fourth_approval			=   @w_fourth_semi_annual_report_typ
			,	quarterlyreport_user_typ					=   @w_quarterly_report_typ			
			,	quarterlyreport_first_approval				=   @w_first_quarterly_report_typ	
			,	quarterlyreport_second_approval				=   @w_second_quarterly_report_typ	
			,	quarterlyreport_third_approval				=   @w_third_quarterly_report_typ	
			,	quarterlyreport_fourth_approval				=   @w_fourth_quarterly_report_typ	
			,	monthlyreport_user_typ						=   @w_monthly_report_typ			
			,	monthlyreport_first_approval				=   @w_first_monthly_report_typ		
			,	monthlyreport_second_approval				=   @w_second_monthly_report_typ	
			,	monthlyreport_third_approval				=   @w_third_monthly_report_typ		
			,	monthlyreport_fourth_approval				=   @w_fourth_monthly_report_typ	
			,	monthlyreport_deadline						=   @w_monthlyreport_deadline
			,	weeklyreport_user_typ						=   @w_weekly_report_typ			
			,	weeklyreport_first_approval					=   @w_first_weekly_report_typ		
			,	weeklyreport_second_approval				=   @w_second_weekly_report_typ		
			,	weeklyreport_third_approval					=   @w_third_weekly_report_typ		
			,	weeklyreport_fourth_approval				=   @w_fourth_weekly_report_typ		
			,	weeklyreport_deadline						=   @w_weeklyreport_deadline		
			,	weeklyreport_judgment_date					=   @w_weeklyreport_judgment_date	
			,	viewer_sharing								=   @w_viewing_sharing				
			,	share_notify_reporter						=   @w_share_notify_reporter		
			,	viewable_Deadline_kbn						=   @w_viewable_deadline_kbn
			,	comment_option_use_typ						=	@w_comment_option_use_typ			
			,	comment_option_authorizer_use_typ			=	@w_comment_option_authorizer_use_typ
			,	comment_option_viewer_use_typ				=	@w_comment_option_viewer_use_typ	
			,	upd_user									=	@P_cre_user
			,	upd_ip										=	@P_cre_ip
			,	upd_prg										=	'rM0010'
			,	upd_datetime								=	@w_time

			FROM M4100
			WHERE 
				M4100.company_cd = @P_company_cd
			
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
	select 
		@max_detail_no1
	,	@max_detail_no2
END


GO
