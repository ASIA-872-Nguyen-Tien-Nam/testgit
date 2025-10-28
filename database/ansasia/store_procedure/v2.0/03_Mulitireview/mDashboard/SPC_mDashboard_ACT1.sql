IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_mDashboard_ACT1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_mDashboard_ACT1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：mDashboard - confirm
 *
 *  作成日  ：2021/01/12
 *  作成者  ：ANS-ASIA DUONGNTT
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_mDashboard_ACT1]
	@P_company_cd		SMALLINT		=	0
,	@P_fiscal_year		SMALLINT		=	0
,	@P_confirm_flg		SMALLINT		=	0
,	@P_cre_user			NVARCHAR(50)	= ''
,	@P_cre_ip			NVARCHAR(50)	= ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time			DATETIME2	 = SYSDATETIME()
	,	@ERR_TBL		ERRTABLE	
	
	--CHECK MASTER
	IF EXISTS(SELECT 1 FROM F3010 WHERE F3010.company_cd = @P_company_cd AND F3010.fiscal_year = @P_fiscal_year AND F3010.del_datetime IS NOT NULL)
	BEGIN
		INSERT INTO @ERR_TBL VALUES(	
			17								
		,	''										
		,	0-- oderby						
		,	1-- dialog  					
		,	0							
		,	0								
		,	'Data had been deleted'		
		)
	END

	--
	BEGIN TRANSACTION
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM @ERR_TBL)
		BEGIN
			IF EXISTS (
					SELECT 1
					FROM F3010
					WHERE 
						F3010.company_cd	=	@P_company_cd
					AND F3010.fiscal_year	=	@P_fiscal_year
					AND F3010.del_datetime IS NULL
			)
			BEGIN
				--UPDATE
				UPDATE F3010
				SET
					interview_datetime		=	@w_time
				,	interview_cd			=	@P_cre_user
				,	confirm_flg				=	@P_confirm_flg
				,	upd_user				=	@P_cre_user
				,	upd_ip					=	@P_cre_ip
				,	upd_prg					=	'mDashboard'
				,	upd_datetime			=	@w_time
				FROM F3010
				WHERE 
					F3010.company_cd		=	@P_company_cd
				AND F3010.fiscal_year		=	@P_fiscal_year
				AND F3010.del_datetime IS NULL
			END
			ELSE
			BEGIN
				--INSERT
				INSERT INTO F3010
				SELECT
					@P_company_cd
				,	@P_fiscal_year
				,	@w_time
				,	@P_cre_user
				,	@P_confirm_flg
				,	@P_cre_user
				,	@P_cre_ip
				,	'mDashboard'
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

	--[0]
	SELECT 
		message_no
	,	item
	,	order_by
	,	error_typ
	,	value1
	,	value2
	,	remark
	FROM @ERR_TBL
	ORDER BY 
		order_by
END

GO
