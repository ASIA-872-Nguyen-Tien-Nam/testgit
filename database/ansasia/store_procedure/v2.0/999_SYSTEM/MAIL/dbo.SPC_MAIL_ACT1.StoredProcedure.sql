DROP PROCEDURE [SPC_MAIL_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ [SPC_MAIL_INQ1]
-- EXEC [SPC_MAIL_INQ1]'','';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	MAIL
--*  
--*  作成日/create date			:	2018/12/06				
--*　作成者/creater				:	sondh								
--*   					
--*  更新日/update date			:  
--*　更新者/updater				:　
--*　更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [SPC_MAIL_ACT1]

AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 	
		@w_time						DATETIME2			= SYSDATETIME()
	,	@order_by_min				INT					= 0
	,	@ERR_TBL					ERRTABLE	

	-- START TRANSACTION 
	BEGIN TRANSACTION
	BEGIN TRY

	--UPDATE SEND_DATETIME
	UPDATE F0901
	SET
		send_datetime = @w_time
	WHERE 
		del_datetime IS NULL
	AND F0901.send_datetime IS NULL
	--
	UPDATE F2901
	SET
		send_datetime = @w_time
	WHERE 
		del_datetime IS NULL
	AND F2901.send_datetime IS NULL
	--
	UPDATE F4901
	SET
		send_datetime = @w_time
	WHERE 
		del_datetime IS NULL
	AND F4901.send_datetime IS NULL

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
	COMPLETE_QUERY:
	--
	IF EXISTS(SELECT 1 FROM @ERR_TBL AS ERR_TBL WHERE ERR_TBL.item = 'EXCEPTION')
	BEGIN
		IF @@TRANCOUNT >0
		BEGIN
			ROLLBACK TRANSACTION
		END
	END
	ELSE
	BEGIN
		COMMIT TRANSACTION
	END

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
