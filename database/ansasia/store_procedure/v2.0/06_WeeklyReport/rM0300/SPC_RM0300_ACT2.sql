IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_RM0300_ACT2]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_RM0300_ACT2]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  SPC_RM0300_ACT2 - DELETE
 *

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	REFER DATA
--*		
--* 作成日/create date			:	2023/04/17										
--*	作成者/creater				:	namnt			
--*   		
--****************************************************************************************/
CREATE PROCEDURE [SPC_RM0300_ACT2] 
	@P_group_cd			SMALLINT		= 0
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
	
	IF NOT EXISTS (SELECT 1 FROM M4600 WHERE company_cd = @P_company_cd AND group_cd = @P_group_cd AND del_datetime IS  NULL)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(
				21
			,	'#group_cd'
			,	0-- oderby
			,	1-- dialog  
			,	0
			,	0
			,	'group_cd not found'
			)
		END

		IF EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
		GOTO  COMPLETE_QUERY
		END
		-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		--UPDATE DELETE M0080
			UPDATE M4600 
			SET M4600.del_datetime	= @w_time
			,	M4600.del_ip		= @P_cre_ip
			,	M4600.del_prg		= 'rM0300'
			,	M4600.del_user		= @P_cre_user
			WHERE M4600.company_cd = @P_company_cd
			AND M4600.group_cd = @P_group_cd
			--
			--UPDATE DELETE M0081
			UPDATE M4601 
			SET M4601.del_datetime	= @w_time
			,	M4601.del_ip		= @P_cre_ip
			,	M4601.del_prg		= 'rM0300'
			,	M4601.del_user		= @P_cre_user
			WHERE M4601.company_cd = @P_company_cd
			AND M4601.group_cd = @P_group_cd
			UPDATE M4603
			SET M4603.del_datetime	= @w_time
			,	M4603.del_ip		= @P_cre_ip
			,	M4603.del_prg		= 'rM0300'
			,	M4603.del_user		= @P_cre_user
			WHERE M4603.company_cd = @P_company_cd
			AND M4603.group_cd = @P_group_cd
			UPDATE M4602
			SET M4602.del_datetime	= @w_time
			,	M4602.del_ip		= @P_cre_ip
			,	M4602.del_prg		= 'rM0300'
			,	M4602.del_user		= @P_cre_user
			WHERE M4602.company_cd = @P_company_cd
			AND M4602.group_cd = @P_group_cd
			UPDATE M4604
			SET M4604.del_datetime	= @w_time
			,	M4604.del_ip		= @P_cre_ip
			,	M4604.del_prg		= 'rM0300'
			,	M4604.del_user		= @P_cre_user
			WHERE M4604.company_cd = @P_company_cd
			AND M4604.group_cd = @P_group_cd
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
