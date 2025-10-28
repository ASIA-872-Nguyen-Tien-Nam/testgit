IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_RM0020_ACT2]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_RM0020_ACT2]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  個人マスタ：rm0020 - DELETE
 *
 *  作成日  ：2023/04/05
 *  作成者  ：ANS-ASIA quangnd
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_RM0020_ACT2] 
	@P_fiscal_year	SMALLINT	 = 0
	--
,	@P_cre_user		NVARCHAR(50) = ''
,	@P_cre_ip		NVARCHAR(50) = ''
,	@P_company_cd	SMALLINT	 = 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2	 = SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	--
	BEGIN TRANSACTION
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM M4000 WHERE company_cd = @P_company_cd AND fiscal_year = @P_fiscal_year AND del_datetime IS  NULL)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(
				21
			,	'#fiscal_year'
			,	0-- oderby
			,	1-- dialog  
			,	0
			,	0
			,	'fiscal_year not found'
			)
		END
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			UPDATE M4000 
			SET M4000.del_user		    = @P_cre_user
			,	M4000.del_ip			= @P_cre_ip
			,	M4000.del_prg			= 'rM0020'
			,	M4000.del_datetime      = @w_time
			WHERE M4000.company_cd  = @P_company_cd
			AND M4000.fiscal_year   = @P_fiscal_year
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
