/****** Object:  StoredProcedure [dbo].[SPC_M0070_01_ACT1]    Script Date: 2018/09/18 15:02:00 ******/
SET ANSI_NULLS ON
GO
DROP PROCEDURE [dbo].[SPC_M0070_01_ACT1] 
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_M0070_01_ACT1 '{"blood_type":"1","headquarters_prefectures":"1","headquarters_other":"1","possibility_transfer":"1","nationality":"ABW","residence_card_no":"1","status_residence":"1","expiry_date":"","permission_activities":"1","disability_classification":"1","disability_recognition_date":"","disability_content":"1","common_name":"2","common_name_furigana":"2","maiden_name":"2","maiden_name_furigana":"2","business_name":"1","business_name_furigana":"2","attached_file1":"721_personal_certificate_17115249611.pdf","attached_file1_name":"QUY DINH VE CHE DO THUONG THAM NIEN CHO NHAN VIEN","attached_file1_uploaddatetime":"2024\/03\/27 02:27","attached_file2":"721_personal_certificate_17115250972.pdf","attached_file2_name":"a9bd12fcad00f45dKH tổ chức ngày hội hiến máu tình nguyện 2024.pdf","attached_file2_uploaddatetime":"","attached_file3":"721_personal_certificate_17115250973.pdf","attached_file3_name":"tes1 - Copy.pdf","attached_file3_uploaddatetime":"","attached_file4":"721_personal_certificate_17115250974.pdf","attached_file4_name":"tes1.pdf","attached_file4_uploaddatetime":"","attached_file5":"721_personal_certificate_17115250975.pdf","attached_file5_name":"QUY DINH VE CHE DO THUONG THAM NIEN CHO NHAN VIEN (1) - Copy.pdf","attached_file5_uploaddatetime":"","driver_point":"","analytical_point":"","expressive_point":"","amiable_point":"","employee_cd":"1"}','721','::1','740';

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	SAVE DATA
--*  
--* 作成日/create date			:	2018/09/17											
--*	作成者/creater				:	SonDH						
--*   					
--*	更新日/update date			:  						
--*	更新者/updater				:　  　								     	 
--*	更新内容/update content		:	　	
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_M0070_01_ACT1] 
	-- Add the parameters for the stored procedure here
	@P_json					NVARCHAR(MAX)
	-- common
,	@P_cre_user				NVARCHAR(50)		= ''
,	@P_cre_ip				NVARCHAR(50)		= ''
,	@P_company_cd			SMALLINT			= 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time										DATETIME2			= SYSDATETIME()
	,	@order_by_min								INT					= 0
	,	@ERR_TBL									ERRTABLE	
	--
	,	@employee_cd								NVARCHAR(10)		= ''
	,	@blood_type									SMALLINT			= 0
	,	@headquarters_prefectures					SMALLINT			= 0
	,	@headquarters_other							NVARCHAR(20)		= ''
	,	@possibility_transfer						SMALLINT			= 0
	,	@nationality								NVARCHAR(3)			= ''
	,	@residence_card_no							NVARCHAR(12)		= ''
	,	@status_residence							SMALLINT			= 0
	,	@expiry_date								DATE
	,	@permission_activities						SMALLINT			= 0
	,	@disability_classification					SMALLINT			= 0
	,	@disability_recognition_date				DATE
	,	@disability_content							NVARCHAR(50)		= ''
	,	@common_name								NVARCHAR(100)		= ''
	,	@common_name_furigana						NVARCHAR(100)		= ''
	,	@maiden_name								NVARCHAR(100)		= ''
	,	@maiden_name_furigana						NVARCHAR(100)		= ''
	,	@business_name								NVARCHAR(100)		= ''
	,	@business_name_furigana						NVARCHAR(100)		= ''

	,	@attached_file1								NVARCHAR(50)		= ''
	,	@attached_file1_name						NVARCHAR(50)		= ''
	,	@attached_file1_uploaddatetime				DATETIME			= NULL
	,	@attached_file2								NVARCHAR(50)		= ''
	,	@attached_file2_name						NVARCHAR(50)		= ''
	,	@attached_file2_uploaddatetime				DATETIME			= NULL
	,	@attached_file3								NVARCHAR(50)		= ''
	,	@attached_file3_name						NVARCHAR(50)		= ''
	,	@attached_file3_uploaddatetime				DATETIME			= NULL
	,	@attached_file4								NVARCHAR(50)		= ''
	,	@attached_file4_name						NVARCHAR(50)		= ''
	,	@attached_file4_uploaddatetime				DATETIME			= NULL
	,	@attached_file5								NVARCHAR(50)		= ''
	,	@attached_file5_name						NVARCHAR(50)		= ''
	,	@attached_file5_uploaddatetime				DATETIME			= NULL

	,	@base_style									SMALLINT			= 0
	,	@sub_style									SMALLINT			= 0
	,	@driver_point								SMALLINT			= 0	
	,	@analytical_point							SMALLINT			= 0		
	,	@expressive_point							SMALLINT			= 0		
	,	@amiable_point								SMALLINT			= 0	

	CREATE TABLE #TBL_JSON(
		attached_file1_old	NVARCHAR(50)
	,	attached_file2_old	NVARCHAR(50)
	,	attached_file3_old	NVARCHAR(50)
	,	attached_file4_old	NVARCHAR(50)
	,	attached_file5_old	NVARCHAR(50)
	)


	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
	-- ASSIGN
	IF ISJSON(@P_json) <= 0
	BEGIN
		INSERT INTO @ERR_TBL VALUES(		
			22								-- mã lỗi (trùng với mã trong bảng message) 					
		,	''								-- id hoặc class của item(#id , .class), lỗi dạng dialog thì để trống  				
		,	0-- oderby						-- giá trị càng bé thì lỗi được hiển thị trước  				
		,	1-- dialog  					-- Kiểu hiển thị lối : 0. tooltip , 1.dialog 				
		,	0								-- Tùy ý : có thể lưu vị trí index của dòng của lỗi 				
		,	0								-- Tùy ý
		,	'json format'					-- Comment nội dung lỗi (chủ yếu là dùng khi đọc code)
		)
	END

	--
	SET @employee_cd					=	JSON_VALUE(@P_json,'$.employee_cd')					
	SET @blood_type						=	JSON_VALUE(@P_json,'$.blood_type')							
	SET @headquarters_prefectures		=	JSON_VALUE(@P_json,'$.headquarters_prefectures')		
	SET @headquarters_other				=	JSON_VALUE(@P_json,'$.headquarters_other')				
	SET @possibility_transfer			=	JSON_VALUE(@P_json,'$.possibility_transfer')			
	SET @nationality					=	JSON_VALUE(@P_json,'$.nationality')					
	SET @residence_card_no				=	JSON_VALUE(@P_json,'$.residence_card_no')			
	SET @status_residence				=	JSON_VALUE(@P_json,'$.status_residence')				
	SET @expiry_date					=	IIF(JSON_VALUE(@P_json,'$.expiry_date')='',NULL,JSON_VALUE(@P_json,'$.expiry_date'))			
	SET @permission_activities			=	JSON_VALUE(@P_json,'$.permission_activities')			
	SET @disability_classification		=	JSON_VALUE(@P_json,'$.disability_classification')		
	SET @disability_recognition_date	=	IIF(JSON_VALUE(@P_json,'$.disability_recognition_date')='',NULL,JSON_VALUE(@P_json,'$.disability_recognition_date'))
	SET @disability_content				=	JSON_VALUE(@P_json,'$.disability_content')				
	SET	@common_name					=	JSON_VALUE(@P_json,'$.common_name')					
	SET @common_name_furigana			=	JSON_VALUE(@P_json,'$.common_name_furigana')			
	SET @maiden_name					=	JSON_VALUE(@P_json,'$.maiden_name')					
	SET	@maiden_name_furigana			=	JSON_VALUE(@P_json,'$.maiden_name_furigana')			
	SET @business_name					=	JSON_VALUE(@P_json,'$.business_name')					
	SET @business_name_furigana			=	JSON_VALUE(@P_json,'$.business_name_furigana')			
	SET @attached_file1					=	JSON_VALUE(@P_json,'$.attached_file1')					
	SET @attached_file1_name			=	JSON_VALUE(@P_json,'$.attached_file1_name')			
	SET @attached_file1_uploaddatetime	=	IIF(JSON_VALUE(@P_json,'$.attached_file1_uploaddatetime')='',NULL,JSON_VALUE(@P_json,'$.attached_file1_uploaddatetime'))
	SET @attached_file2					=	JSON_VALUE(@P_json,'$.attached_file2')					
	SET @attached_file2_name			=	JSON_VALUE(@P_json,'$.attached_file2_name')			
	SET	@attached_file2_uploaddatetime	=	IIF(JSON_VALUE(@P_json,'$.attached_file2_uploaddatetime')='',NULL,JSON_VALUE(@P_json,'$.attached_file2_uploaddatetime'))
	SET @attached_file3					=	JSON_VALUE(@P_json,'$.attached_file3')					
	SET @attached_file3_name			=	JSON_VALUE(@P_json,'$.attached_file3_name')			
	SET	@attached_file3_uploaddatetime	=	IIF(JSON_VALUE(@P_json,'$.attached_file3_uploaddatetime')='',NULL,JSON_VALUE(@P_json,'$.attached_file3_uploaddatetime'))	
	SET @attached_file4					=	JSON_VALUE(@P_json,'$.attached_file4')					
	SET @attached_file4_name			=	JSON_VALUE(@P_json,'$.attached_file4_name')			
	SET	@attached_file4_uploaddatetime	=	IIF(JSON_VALUE(@P_json,'$.attached_file4_uploaddatetime')='',NULL,JSON_VALUE(@P_json,'$.attached_file4_uploaddatetime'))
	SET @attached_file5					=	JSON_VALUE(@P_json,'$.attached_file5')					
	SET @attached_file5_name			=	JSON_VALUE(@P_json,'$.attached_file5_name')			
	SET @attached_file5_uploaddatetime	=	IIF(JSON_VALUE(@P_json,'$.attached_file5_uploaddatetime')='',NULL,JSON_VALUE(@P_json,'$.attached_file5_uploaddatetime'))
	SET @base_style						=	JSON_VALUE(@P_json,'$.base_style')						
	SET @sub_style						=	JSON_VALUE(@P_json,'$.sub_style')						
	SET @driver_point					=	JSON_VALUE(@P_json,'$.driver_point')					
	SET @analytical_point				=	JSON_VALUE(@P_json,'$.analytical_point')				
	SET @expressive_point				=	JSON_VALUE(@P_json,'$.expressive_point')				
	SET @amiable_point					=	JSON_VALUE(@P_json,'$.amiable_point')		
	
	-- INSERT value character item 
	INSERT INTO #TBL_JSON
	SELECT
		attached_file1
	,	attached_file2			
	,	attached_file3
	,	attached_file4
	,	attached_file5
	FROM M0074 
	WHERE company_cd = @P_company_cd 
	AND employee_cd = @employee_cd
	
	--
	--SELECT @attached_file1_uploaddatetime, @attached_file2_uploaddatetime, @w_time
	IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
	BEGIN
		--
		IF EXISTS (SELECT 1 FROM M0074 WHERE company_cd = @P_company_cd AND employee_cd = @employee_cd)
		BEGIN
		---check has change file => update uploadtime
			IF((@attached_file1_uploaddatetime IS NOT NULL OR @attached_file1_name <> '') 
			AND (EXISTS (SELECT
							1
							FROM M0074
							WHERE company_cd = @P_company_cd
							AND employee_cd = @employee_cd
							AND attached_file1 <> @attached_file1)))
			BEGIN
				SET @attached_file1_uploaddatetime = @w_time
			END
			IF((@attached_file2_uploaddatetime IS NOT NULL OR @attached_file2_name <> '')
			AND (EXISTS (SELECT
							1
							FROM M0074
							WHERE company_cd = @P_company_cd
							AND employee_cd = @employee_cd
							AND attached_file2 <> @attached_file2)))
			BEGIN
				SET @attached_file2_uploaddatetime = @w_time
			END
			IF((@attached_file3_uploaddatetime IS NOT NULL OR @attached_file3_name <> '')
			AND (EXISTS (SELECT
							1
							FROM M0074
							WHERE company_cd = @P_company_cd
							AND employee_cd = @employee_cd
							AND attached_file3 <> @attached_file3)))
			BEGIN
				SET @attached_file3_uploaddatetime = @w_time
			END
			IF((@attached_file4_uploaddatetime IS NOT NULL OR @attached_file4_name <> '')
			AND (EXISTS (SELECT
							1
							FROM M0074
							WHERE company_cd = @P_company_cd
							AND employee_cd = @employee_cd
							AND attached_file4 <> @attached_file4)))
			BEGIN
				SET @attached_file4_uploaddatetime = @w_time
			END
			IF((@attached_file5_uploaddatetime IS NOT NULL OR @attached_file5_name <> '')
			AND (EXISTS (SELECT
							1
							FROM M0074
							WHERE company_cd = @P_company_cd
							AND employee_cd = @employee_cd
							AND attached_file5 <> @attached_file5)))
			BEGIN
				SET @attached_file5_uploaddatetime = @w_time
			END
			--SELECT @attached_file2_name,@attached_file1_uploaddatetime, @attached_file2_uploaddatetime, @attached_file3_uploaddatetime, @attached_file4_uploaddatetime, @attached_file5_uploaddatetime
			UPDATE M0074
			SET
				blood_type								= 		@blood_type												
			,	headquarters_prefectures				= 		@headquarters_prefectures			
			,	headquarters_other						= 		@headquarters_other					
			,	possibility_transfer					= 		@possibility_transfer			
			,	nationality								= 		@nationality					
			,	residence_card_no						=		@residence_card_no				
			,	status_residence						= 		@status_residence					
			,	expiry_date								= 		@expiry_date						
			,	permission_activities					= 		@permission_activities			
			,	disability_classification				= 		@disability_classification					
			,	disability_recognition_date				= 		@disability_recognition_date		
			,	disability_content						= 		@disability_content					
			,	common_name								= 		@common_name					
			,	common_name_furigana					= 		@common_name_furigana			
			,	maiden_name								= 		@maiden_name						
			,	maiden_name_furigana					= 		@maiden_name_furigana				
			,	business_name							= 		@business_name					
			,	business_name_furigana					= 		@business_name_furigana				
			,	attached_file1							= 		@attached_file1									
			,	attached_file1_name						= 		@attached_file1_name				
			,	attached_file1_uploaddatetime			= 		@attached_file1_uploaddatetime			
			,	attached_file2							= 		@attached_file2						
			,	attached_file2_name						= 		@attached_file2_name			
			,	attached_file2_uploaddatetime			= 		@attached_file2_uploaddatetime		
			,	attached_file3							= 		@attached_file3					
			,	attached_file3_name						= 		@attached_file3_name				
			,	attached_file3_uploaddatetime			= 		@attached_file3_uploaddatetime	
			,	attached_file4							= 		@attached_file4						
			,	attached_file4_name						= 		@attached_file4_name			
			,	attached_file4_uploaddatetime			= 		@attached_file4_uploaddatetime	
			,	attached_file5							= 		@attached_file5							
			,	attached_file5_name						= 		@attached_file5_name			
			,	attached_file5_uploaddatetime			= 		@attached_file5_uploaddatetime		
			,	base_style								= 		@base_style							
			,	sub_style								= 		@sub_style							
			,	driver_point							= 		@driver_point						
			,	analytical_point						= 		@analytical_point					
			,	expressive_point						= 		@expressive_point					
			,	amiable_point							= 		@amiable_point						
			,	upd_user								=		@P_cre_user	
			,	upd_ip									=		@P_cre_ip	
			,	upd_prg									=		'M0070'			
			,	upd_datetime							=		@w_time	
			,	del_user								=		SPACE(0)
			,	del_ip									=		SPACE(0)
			,	del_prg									=		SPACE(0)
			,	del_datetime							=		NULL	
			WHERE 
				company_cd		=	@P_company_cd
			AND employee_cd		=	@employee_cd
		END
		ELSE
		BEGIN
			INSERT INTO M0074
			SELECT 
				@P_company_cd								--company_cd
			,	@employee_cd
			,	@blood_type						
			,	@headquarters_prefectures		
			,	@headquarters_other				
			,	@possibility_transfer			
			,	@nationality					
			,	@residence_card_no				
			,	@status_residence				
			,	@expiry_date					
			,	@permission_activities			
			,	@disability_classification		
			,	@disability_recognition_date
			,	@disability_content				
			,	@common_name					
			,	@common_name_furigana			
			,	@maiden_name					
			,	@maiden_name_furigana			
			,	@business_name					
			,	@business_name_furigana			
			,	@attached_file1					
			,	@attached_file1_name			
			,	IIF(@attached_file1='',NULL,@w_time)	
			,	@attached_file2					
			,	@attached_file2_name			
			,	IIF(@attached_file2='',NULL,@w_time)		
			,	@attached_file3					
			,	@attached_file3_name			
			,	IIF(@attached_file3='',NULL,@w_time)		
			,	@attached_file4					
			,	@attached_file4_name			
			,	IIF(@attached_file4='',NULL,@w_time)		
			,	@attached_file5					
			,	@attached_file5_name			
			,	IIF(@attached_file5='',NULL,@w_time)		
			,	@base_style						
			,	@sub_style						
			,	@driver_point					
			,	@analytical_point				
			,	@expressive_point				
			,	@amiable_point					
			,	@P_cre_user									--cre_user						
			,	@P_cre_ip									--cre_ip						
			,	'M0070'										--cre_prg						
			,	@w_time										--cre_datetime						
			,	SPACE(0)									--upd_user						
			,	SPACE(0)									--upd_ip						
			,	SPACE(0)									--upd_prg						
			,	NULL										--upd_datetime						
			,	SPACE(0)									--del_user						
			,	SPACE(0)									--del_ip						
			,	SPACE(0)									--del_prg						
			,	NULL										--del_datetime						
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
    -- INSERT STATEMENTS FOR PROCEDURE HERE
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

	SELECT 
		#TBL_JSON.attached_file1_old AS attached_file1_old
	,	#TBL_JSON.attached_file2_old AS attached_file2_old
	,	#TBL_JSON.attached_file3_old AS attached_file3_old
	,	#TBL_JSON.attached_file4_old AS attached_file4_old
	,	#TBL_JSON.attached_file5_old AS attached_file5_old
	,	@attached_file1 AS attached_file1
	,	@attached_file2 AS attached_file2
	,	@attached_file3 AS attached_file3
	,	@attached_file4 AS attached_file4
	,	@attached_file5 AS attached_file5
	FROM #TBL_JSON

END

GO