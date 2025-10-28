IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_MI2000_ACT2]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_MI2000_ACT2]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：OM0400 - DELETE
 *
 *  作成日  ：2020/10/28
 *  作成者  ：ANS-ASIA nghianm
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_MI2000_ACT2] 
	@P_employee_cd					NVARCHAR(10)	= ''
,	@P_detail_no					SMALLINT		= 0
,	@P_company_cd					SMALLINT		= 0
	--	
,	@P_cre_user						NVARCHAR(50)	= ''
,	@P_cre_ip						NVARCHAR(50)	= ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			int					=	0
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM F3000 WHERE company_cd = @P_company_cd AND employee_cd = @P_employee_cd AND detail_no = @P_detail_no  AND del_datetime IS  NULL)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(
				21
			,	'#detail_no'
			,	0-- oderby
			,	1-- dialog  
			,	0
			,	0
			,	'detail_no not found'
			)
		END
		-- PROCESS
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			--UPDATE DELETE F3000
			UPDATE F3000 SET 
				del_datetime	= @w_time
			,	del_ip			= @P_cre_ip
			,	del_prg			= 'MI2000'
			,	del_user		= @P_cre_user
			WHERE 
				F3000.company_cd	= @P_company_cd
			AND F3000.employee_cd	= @P_employee_cd
			AND F3000.detail_no		= @P_detail_no
			--UPDATE DELETE F3001
			UPDATE F3001 SET 
				del_datetime	= @w_time
			,	del_ip			= @P_cre_ip
			,	del_prg			= 'MI2000'
			,	del_user		= @P_cre_user
			WHERE 
				F3001.company_cd	= @P_company_cd
			AND F3001.employee_cd	= @P_employee_cd
			AND F3001.detail_no		= @P_detail_no
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
