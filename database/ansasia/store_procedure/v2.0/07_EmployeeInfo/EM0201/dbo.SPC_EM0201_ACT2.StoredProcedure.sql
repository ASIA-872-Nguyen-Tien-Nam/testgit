SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC XXX '{}','','::1';

--****************************************************************************************
--*   											
--* ˆ—ŠT—v/process overview	:	DELETE DATA
--*  
--* ì¬“ú/create date			:	2024/04											
--*	ì¬ŽÒ/creater				:	matsumoto						@	
--****************************************************************************************
CREATE PROCEDURE [SPC_EM0201_ACT2] 
	-- Add the parameters for the stored procedure here
	@P_json			nvarchar(max)	=	''
	-- common
,	@P_cre_user		nvarchar(50)	=	''
,	@P_cre_ip		nvarchar(50)	=	''
,	@P_company_cd	smallint
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			int					=	0
	,	@P_field_cd				smallint
	
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		SET @P_field_cd			=	JSON_VALUE(@P_json,'$.field_cd')

		IF NOT EXISTS (SELECT 1 FROM M5202 WHERE company_cd = @P_company_cd AND field_cd = @P_field_cd AND del_datetime IS NULL)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(
				21
			,	'#field_cd'
			,	0-- oderby
			,	2-- dialog  
			,	0
			,	0
			,	'field_cd not found'
			)
		END

		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			UPDATE M5202
				SET
					del_user		=	@P_cre_user
				,	del_ip			=	@P_cre_ip
				,	del_prg         =	'EM0201'
				,	del_datetime	=	@w_time
				WHERE
					company_cd		=	@P_company_cd
				AND	field_cd		=	@P_field_cd
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
