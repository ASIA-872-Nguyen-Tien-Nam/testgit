IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_OI1011_ACT2]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_OI1011_ACT2]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：OI1011 - DELETE
 *
 *  作成日  ：2020/11/10
 *  作成者  ：ANS-ASIA nghianm
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_OI1011_ACT2] 
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
	,	@P_job_cd				smallint
	
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM M2500 WHERE company_cd = @P_company_cd AND mail_kbn = @P_mail_kbn AND del_datetime IS  NULL)
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

		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
		--UPDATE DELETE M0080
			UPDATE M2500 
			SET M2500.del_datetime	= @w_time
			,	M2500.del_ip		= @P_cre_ip
			,	M2500.del_prg		= 'oI1011'
			,	M2500.del_user		= @P_cre_user
			WHERE M2500.company_cd	= @P_company_cd
			AND M2500.mail_kbn		= @P_mail_kbn
			--
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
END

GO
