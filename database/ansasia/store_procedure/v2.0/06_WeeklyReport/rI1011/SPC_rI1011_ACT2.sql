BEGIN
    DROP PROCEDURE [dbo].[SPC_rI1011_ACT2]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：rI1011 - DELETE
 *
 *  作成日  ：2023/04/20
 *  作成者  ：ANS-ASIA quangnd
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_rI1011_ACT2] 
	@P_mail_kbn			SMALLINT		= 0
	--	
,	@P_company_cd		SMALLINT		= 0
,	@P_cre_user			NVARCHAR(50)	= ''
,	@P_cre_ip			NVARCHAR(50)	= ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			int					=	0
	--
	IF NOT EXISTS (SELECT 1 FROM M4500 WHERE company_cd = @P_company_cd AND mail_kbn = @P_mail_kbn AND del_datetime IS  NULL)
	BEGIN
		INSERT INTO @ERR_TBL VALUES(
			21
		,	'#mail_kbn'
		,	0-- oderby
		,	2-- dialog  
		,	0
		,	0
		,	'mail_kbn not found'
		)
	END
	IF EXISTS (SELECT 1 FROM @ERR_TBL) GOTO COMPLETE_QUERY
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
	--UPDATE DELETE M4500
		UPDATE M4500 
		SET M4500.del_datetime	=  @w_time
		,	M4500.del_ip		=  @P_cre_ip
		,	M4500.del_prg		= 'rI1011'
		,	M4500.del_user		=  @P_cre_user
		WHERE
			M4500.company_cd	= @P_company_cd
		AND M4500.mail_kbn		= @P_mail_kbn
		--
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
END

GO
