DROP PROCEDURE [SPC_RM0120_ACT2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	DELETE DATA
--*  
--* 作成日/create date			:	2023/04/13											
--*	作成者/creater				:	quangnd						
--*   					
--*	更新日/update date			:  						
--*	更新者/updater				:　  　								     	 
--*	更新内容/update content		:	　	
--****************************************************************************************
CREATE PROCEDURE [SPC_RM0120_ACT2] 
	-- Add the parameters for the stored procedure here
	@P_company_cd	SMALLINT		=	0
,	@P_mark_kbn		SMALLINT		=	0
,	@P_cre_user		NVARCHAR(50)	=	''
,	@P_cre_ip		NVARCHAR(50)	=	''

AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2		= SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			INT				= 0	
	-- START TRANSACTION
	IF NOT EXISTS (SELECT 1 FROM M4122 WHERE company_cd = @P_company_cd AND mark_kbn = @P_mark_kbn AND del_datetime IS NULL)
	BEGIN
		INSERT INTO @ERR_TBL
		SELECT 
			21
		,	''
		,	0
		,	1 -- exception error
		,	0
		,	0
		,	''
	END
	IF EXISTS (SELECT 1 FROM @ERR_TBL)  GOTO COMPLETE_QUERY
	BEGIN TRANSACTION
	BEGIN TRY
			--
			UPDATE M4122
			SET 
				M4122.del_user			= @P_cre_user
			,	M4122.del_ip			= @P_cre_ip
			,	M4122.del_datetime		= @w_time
			,	M4122.del_prg			= 'rM0120'
			WHERE 
				M4122.company_cd = @P_company_cd
			AND	M4122.mark_kbn	 = @P_mark_kbn
			AND M4122.del_datetime IS NULL
			--
			UPDATE M4123
			SET 
				M4123.del_user			= @P_cre_user
			,	M4123.del_ip			= @P_cre_ip
			,	M4123.del_datetime		= @w_time
			,	M4123.del_prg			= 'rM0120'
			WHERE 
				M4123.company_cd	= @P_company_cD
			AND M4123.mark_kbn		= @P_mark_kbn
			AND M4123.del_datetime IS NULL
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
