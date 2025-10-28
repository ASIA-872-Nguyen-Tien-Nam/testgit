/****** Object:  StoredProcedure [dbo].[SPC_M0070_01_ACT1]    Script Date: 2018/09/18 15:02:00 ******/
SET ANSI_NULLS ON
GO
DROP PROCEDURE [dbo].[SPC_M0070_06_ACT1] 
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	SAVE DATA
--*  
--* 作成日/create date			:	2024/04/03											
--*	作成者/creater				:	Quanlh						
--*   					
--*	更新日/update date			:  						
--*	更新者/updater				:　  　								     	 
--*	更新内容/update content		:	　	
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_M0070_06_ACT1] 
	-- Add the parameters for the stored procedure here
	@P_json					NVARCHAR(MAX)
	-- common
,	@P_cre_user				NVARCHAR(50)		= N''
,	@P_cre_ip				NVARCHAR(50)		= N''
,	@P_company_cd			SMALLINT			= 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time										DATETIME2			= SYSDATETIME()
	,	@order_by_min								INT					= 0
	,	@ERR_TBL									ERRTABLE	
	--
	,	@employee_cd								NVARCHAR(10)		= N''
	,	@owning_house_kbn							SMALLINT			= 0
	,	@head_household								SMALLINT			= 0
	,	@post_code									NVARCHAR(8)			= N''
	,	@address1									NVARCHAR(10)		= N''
	,	@address2									NVARCHAR(50)		= N''
	,	@address3									NVARCHAR(50)		= N''
	,	@home_phone_number							NVARCHAR(20)		= 0
	,	@personal_phone_number						NVARCHAR(20)		= N''
	,	@personal_email_address						NVARCHAR(100)		= N''
	,	@emergency_contact_name						NVARCHAR(50)		= N''
	,	@emergency_contact_relationship				NVARCHAR(10)		= N''
	,	@emergency_contact_birthday					DATE				= NULL
	,	@emergency_contact_post_code				NVARCHAR(8)			= N''
	,	@emergency_contact_addres1					NVARCHAR(10)		= N''
	,	@emergency_contact_addres2					NVARCHAR(50)		= N''
	,	@emergency_contact_addres3					NVARCHAR(50)		= N''
	,	@emergency_contact_phone_number				NVARCHAR(20)		= N''
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
	-- ASSIGN
	IF ISJSON(@P_json) <= 0
	BEGIN
		INSERT INTO @ERR_TBL VALUES(		
			22								-- mã lỗi (trùng với mã trong bảng message) 					
		,	N''								-- id hoặc class của item(#id , .class), lỗi dạng dialog thì để trống  				
		,	0-- oderby						-- giá trị càng bé thì lỗi được hiển thị trước  				
		,	1-- dialog  					-- Kiểu hiển thị lối : 0. tooltip , 1.dialog 				
		,	0								-- Tùy ý : có thể lưu vị trí index của dòng của lỗi 				
		,	0								-- Tùy ý
		,	N'json format'					-- Comment nội dung lỗi (chủ yếu là dùng khi đọc code)
		)
	END
	--
	SET @employee_cd										=	JSON_VALUE(@P_json,'$.employee_cd					')					
	SET @owning_house_kbn									=	JSON_VALUE(@P_json,'$.owning_house_kbn				')	
	SET @head_household										=	JSON_VALUE(@P_json,'$.head_household				')	
	SET @post_code											=	LEFT(JSON_VALUE(@P_json,'$.post_code'),3)+ RIGHT(JSON_VALUE(@P_json,'$.post_code'),4)	
	SET @address1											=	JSON_VALUE(@P_json,'$.address1						')	
	SET @address2											=	JSON_VALUE(@P_json,'$.address2						')	
	SET @address3											=	JSON_VALUE(@P_json,'$.address3						')	
	SET @home_phone_number									=	JSON_VALUE(@P_json,'$.home_phone_number				')	
	SET @personal_phone_number								=	JSON_VALUE(@P_json,'$.personal_phone_number			')	
	SET @personal_email_address								=	JSON_VALUE(@P_json,'$.personal_email_address		')	
	SET @emergency_contact_name								=	JSON_VALUE(@P_json,'$.emergency_contact_name		')	
	SET @emergency_contact_relationship						=	JSON_VALUE(@P_json,'$.relationship')	
	SET @emergency_contact_birthday							=	CAST(NULLIF(JSON_VALUE(@P_json,'$.emergency_contact_birthday'),N'') AS DATE)	
	SET @emergency_contact_post_code						=	LEFT(JSON_VALUE(@P_json,'$.emergency_contact_post_code'),3)+ RIGHT(JSON_VALUE(@P_json,'$.emergency_contact_post_code'),4)	
	SET @emergency_contact_addres1							=	JSON_VALUE(@P_json,'$.emergency_contact_addres1		')	
	SET @emergency_contact_addres2							=	JSON_VALUE(@P_json,'$.emergency_contact_addres2		')	
	SET @emergency_contact_addres3							=	JSON_VALUE(@P_json,'$.emergency_contact_addres3		')	
	SET @emergency_contact_phone_number						=	JSON_VALUE(@P_json,'$.emergency_contact_phone_number')		
	--
	IF EXISTS(SELECT 1 FROM M0083 WHERE 
					company_cd		=	@P_company_cd
				AND employee_cd		=	@employee_cd
				AND	@emergency_contact_birthday > @w_time
				)
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				24
			,	N'.emergency_contact_birthday' 
			,	0-- oderby
			,	0-- dialog  
			,	0
			,	0
			,	N'error emergency_contact_birthday'
			FROM M0083		
			 WHERE 
				company_cd		=	@P_company_cd
			AND employee_cd		=	@employee_cd
		END
	--SELECT 
	IF NOT EXISTS (SELECT 1 FROM @ERR_TBL)
		BEGIN
		IF EXISTS(SELECT 1 FROM M0083 WHERE 
					company_cd		=	@P_company_cd
				AND employee_cd		=	@employee_cd
				)
			BEGIN	
				UPDATE M0083
				SET
					owning_house_kbn								= 	@owning_house_kbn												
				,	head_household									= 	@head_household								
				,	post_code										= 	@post_code									
				,	address1										= 	@address1								
				,	address2										= 	@address2						
				,	address3										=	@address3						
				,	home_phone_number								=	@home_phone_number				
				,	personal_phone_number							=	@personal_phone_number			
				,	personal_email_address							=	@personal_email_address			
				,	emergency_contact_name							=	@emergency_contact_name			
				,	emergency_contact_relationship					=	@emergency_contact_relationship
				,	emergency_contact_birthday						=	@emergency_contact_birthday		
				,	emergency_contact_post_code						=	@emergency_contact_post_code	
				,	emergency_contact_addres1						=	@emergency_contact_addres1		
				,	emergency_contact_addres2						=	@emergency_contact_addres2		
				,	emergency_contact_addres3						=	@emergency_contact_addres3		
				,	emergency_contact_phone_number					=	@emergency_contact_phone_number
				,	upd_user										=	@P_cre_user	
				,	upd_ip											=	@P_cre_ip	
				,	upd_prg											=	N'M0070'			
				,	upd_datetime									=	@w_time	
				,	del_user										=	SPACE(0)
				,	del_ip											=	SPACE(0)
				,	del_prg											=	SPACE(0)
				,	del_datetime									=	NULL	
				WHERE 
					company_cd		=	@P_company_cd
				AND employee_cd		=	@employee_cd
			END
			ELSE
			BEGIN
				INSERT INTO M0083
				SELECT 
					@P_company_cd								--company_cd
				,	@employee_cd
				,	@owning_house_kbn				
				,	@head_household					
				,	@post_code						
				,	@address1						
				,	@address2						
				,	@address3						
				,	@home_phone_number				
				,	@personal_phone_number			
				,	@personal_email_address			
				,	@emergency_contact_name			
				,	@emergency_contact_relationship
				,	@emergency_contact_birthday		
				,	@emergency_contact_post_code	
				,	@emergency_contact_addres1		
				,	@emergency_contact_addres2		
				,	@emergency_contact_addres3		
				,	@emergency_contact_phone_number
				,	@P_cre_user									--cre_user						
				,	@P_cre_ip									--cre_ip						
				,	N'M0070'										--cre_prg						
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
		,	N'EXCEPTION'
		,	0
		,	999 -- exception error
		,	0
		,	0
		,	N'Error'                                                          + CHAR(13) + CHAR(10) +
            N'Procedure : ' + ISNULL(ERROR_PROCEDURE(), '???')                + CHAR(13) + CHAR(10) +
            N'Line : '      + ISNULL(CAST(ERROR_LINE() AS NVARCHAR(10)), '0') + CHAR(13) + CHAR(10) +
            N'Message : '   + ISNULL(ERROR_MESSAGE(), 'An unexpected error occurred.')
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
END

GO