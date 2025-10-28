DROP PROCEDURE [SPC_M0010_ACT2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	DELETE DATA
--*  
--* 作成日/create date			:	2018/08/16											
--*	作成者/creater				:	tuantv						
--*   					
--*	更新日/update date			:  						
--*	更新者/updater				:　  　								     	 
--*	更新内容/update content		:	　	
--****************************************************************************************
CREATE PROCEDURE [SPC_M0010_ACT2] 
	-- Add the parameters for the stored procedure here
	@P_cre_user		NVARCHAR(50)	=	''
,	@P_cre_ip		NVARCHAR(50)	=	''
,	@P_company_cd	SMALLINT		=	0
,	@P_json			NVARCHAR(MAX)	=	''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2		= SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			INT				= 0	
	,	@w_office_cd			SMALLINT		= 0
	-- START TRANSACTION
	SET @w_office_cd		=	JSON_VALUE(@P_json,'$.office_cd')

	BEGIN TRANSACTION
	BEGIN TRY
		IF EXISTS(
			SELECT 1
			FROM M0010 WITH(NOLOCK)
			WHERE (M0010.company_cd = @P_company_cd)
			AND (M0010.office_cd	= @w_office_cd)
			AND (M0010.del_datetime IS NULL)
		)
		BEGIN
			UPDATE M0010
			SET 
				M0010.del_user			= @P_cre_user
			,	M0010.del_ip			= @P_cre_ip
			,	M0010.del_datetime		= @w_time
			,	M0010.del_prg			= 'M0010'
			WHERE (M0010.company_cd = @P_company_cd)
			AND (M0010.office_cd	= @w_office_cd)
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
	IF(@@TRANCOUNT > 0)
	BEGIN
		COMMIT TRANSACTION
	END
    -- Insert statements for procedure here
	COMPLETE_QUERY:

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
