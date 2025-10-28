DROP PROCEDURE [SPC_OM0120_ACT2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	DELETE DATA
--*  
--* 作成日/create date			:	2020/10/26											
--*	作成者/creater				:	datnt						
--*   					
--*	更新日/update date			:  						
--*	更新者/updater				:　  　								     	 
--*	更新内容/update content		:	　	
--****************************************************************************************
CREATE PROCEDURE [SPC_OM0120_ACT2] 
	-- Add the parameters for the stored procedure here
	@P_company_cd	SMALLINT		=	0
,	@P_mark_typ		SMALLINT		=	0
,	@P_cre_user		NVARCHAR(50)	=	''
,	@P_cre_ip		NVARCHAR(50)	=	''

AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2		= SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			INT				= 0	
	,	@w_office_cd			SMALLINT		= 0
	-- START TRANSACTION

	BEGIN TRANSACTION
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM M2120 WHERE company_cd = @P_company_cd AND del_datetime IS NULL)
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
		IF NOT EXISTS (SELECT 1 FROM @ERR_TBL)
		BEGIN 
			IF NOT EXISTS (SELECT 1 FROM M2121 WHERE M2121.company_cd = @P_company_cd 
													AND M2121.mark_typ <> @P_mark_typ 
													AND del_datetime IS NULL )
			BEGIN
				UPDATE M2120
				SET 
					M2120.del_user			= @P_cre_user
				,	M2120.del_ip			= @P_cre_ip
				,	M2120.del_datetime		= @w_time
				,	M2120.del_prg			= 'oM0120'
				WHERE (M2120.company_cd = @P_company_cd)
				AND (M2120.del_datetime IS NULL)
			END
			UPDATE M2121
			SET 
				M2121.del_user			= @P_cre_user
			,	M2121.del_ip			= @P_cre_ip
			,	M2121.del_datetime		= @w_time
			,	M2121.del_prg			= 'oM0120'
			WHERE (M2121.company_cd = @P_company_cd)
			AND M2121.mark_typ		=	@P_mark_typ
			AND (M2121.del_datetime IS NULL)
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
