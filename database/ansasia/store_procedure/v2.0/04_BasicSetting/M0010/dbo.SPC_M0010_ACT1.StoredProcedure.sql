DROP PROCEDURE [SPC_M0010_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC [SPC_M0010_ACT1] '{}','','::1','1';

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	SAVE DATA
--*  
--* 作成日/create date			:	2018/08/16											
--*	作成者/creater				:	tuantv						
--*   					
--*	更新日/update date			:  						
--*	更新者/updater				:　  　								     	 
--*	更新内容/update content		:	　	
--****************************************************************************************
CREATE PROCEDURE [SPC_M0010_ACT1] 
	-- Add the parameters for the stored procedure here
	@P_json			NVARCHAR(MAX)	=	''
,	@P_cre_user		NVARCHAR(50)	=	''
,	@P_cre_ip		NVARCHAR(50)	=	''
,	@P_company_cd	SMALLINT		=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2		= SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			INT				= 0	
	,	@w_office_cd			SMALLINT		= 0
	,	@w_office_nm			NVARCHAR(50)	= ''	
	,	@w_office_ab_nm			NVARCHAR(20)	= ''	
	,	@w_zip_cd				NVARCHAR(8)		= ''	
	,	@w_address1				NVARCHAR(100)	= ''	
	,	@w_address2				NVARCHAR(100)	= ''
	,	@w_address3				NVARCHAR(100)	= ''
	,	@w_tel					NVARCHAR(20)	= ''	
	,	@w_fax					NVARCHAR(20)	= ''	
	,	@w_responsible_cd		NVARCHAR(10)	= ''	
	,	@w_arrange_order		INT				= 0	
	,	@w_mode					NVARCHAR(1)		= ''
	,	@w_max_id				SMALLINT		= 0
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY

		SET @w_office_cd		=	JSON_VALUE(@P_json,'$.office_cd')
		SET @w_office_nm		=	JSON_VALUE(@P_json,'$.office_nm')
		SET @w_office_ab_nm		=	JSON_VALUE(@P_json,'$.office_ab_nm')
		SET @w_zip_cd			=	LEFT(JSON_VALUE(@P_json,'$.zip_cd'),3)+ RIGHT(JSON_VALUE(@P_json,'$.zip_cd'),4)
		SET @w_address1			=	JSON_VALUE(@P_json,'$.address1')
		SET @w_address2			=	JSON_VALUE(@P_json,'$.address2')
		SET @w_address3			=	JSON_VALUE(@P_json,'$.address3')
		SET @w_tel				=	JSON_VALUE(@P_json,'$.tel')
		SET @w_fax				=	JSON_VALUE(@P_json,'$.fax')
		SET @w_responsible_cd	=	JSON_VALUE(@P_json,'$.employee_cd')
		SET @w_arrange_order	=	JSON_VALUE(@P_json,'$.arrange_order')
		SET @w_mode				=	JSON_VALUE(@P_json,'$.mode')
		SET @w_max_id = (
			SELECT MAX(office_cd) 
			FROM M0010 WITH(NOLOCK)
			WHERE (M0010.company_cd = @P_company_cd)
		)
		IF(@w_mode = 'A')
		BEGIN
			IF EXISTS(SELECT COUNT(1) FROM M0010 WHERE M0010.company_cd = @P_company_cd HAVING COUNT(1) < 1 )
			BEGIN 
				SET @w_max_id = 1
			END
			ELSE
			BEGIN
				SET @w_max_id = @w_max_id + 1
			END
			INSERT INTO M0010
			SELECT 
				@P_company_cd
			,	@w_max_id	--@w_office_cd
			,	@w_office_nm
			,	@w_office_ab_nm
			,	@w_zip_cd
			,	@w_address1
			,	@w_address2
			,	@w_address3
			,	@w_tel				
			,	@w_fax				
			,	ISNULL(@w_responsible_cd,0)
			,	@w_arrange_order	
			,	@P_cre_user
			,	@P_cre_ip
			,	'M0010'
			,	@w_time
			,	''
			,	''
			,	''
			,	NULL
			,	''
			,	''
			,	''
			,	NULL
		END

		IF(@w_mode = 'U')
		BEGIN
			UPDATE M0010
			SET 
				M0010.office_nm			= @w_office_nm   
			,	M0010.office_ab_nm		= @w_office_ab_nm
			,	M0010.zip_cd			= @w_zip_cd
			,	M0010.address1			= @w_address1
			,	M0010.address2			= @w_address2
			,	M0010.address3			= @w_address3
			,	M0010.tel				= @w_tel				
			,	M0010.fax				= @w_fax				
			,	M0010.responsible_cd	= @w_responsible_cd	
			,	M0010.arrange_order		= @w_arrange_order	
			,	M0010.upd_user			= @P_cre_user
			,	M0010.upd_ip			= @P_cre_ip
			,	M0010.upd_prg			= 'M0010'		
			,	M0010.upd_datetime		= @w_time
			FROM M0010 WITH(NOLOCK)
			WHERE (M0010.company_cd		= @P_company_cd)
			AND (M0010.office_cd		= @w_office_cd)
			AND (M0010.del_datetime IS NULL)
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
	SELECT IIF(@w_mode = 'A',@w_max_id,@w_office_cd) AS office_cd
END
GO

