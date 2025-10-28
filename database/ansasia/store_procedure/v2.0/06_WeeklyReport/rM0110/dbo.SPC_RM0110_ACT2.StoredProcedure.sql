DROP PROCEDURE [SPC_RM0110_ACT2]
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
CREATE PROCEDURE [SPC_RM0110_ACT2] 
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
	IF NOT EXISTS (SELECT 1 FROM M4120 WHERE company_cd = @P_company_cd AND mark_kbn = @P_mark_kbn AND del_datetime IS NULL)
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
	--
	IF EXISTS (	SELECT 1 
				FROM M4200 
				WHERE 
					company_cd = @P_company_cd 
					AND ((@P_mark_kbn = 1 AND M4200.adequacy_use_typ = 1)
						OR(@P_mark_kbn = 2 AND M4200.busyness_use_typ = 1)
						OR(@P_mark_kbn = 3 AND M4200.other_use_typ = 1))
					AND del_datetime IS NULL)
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT 
				155
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
			UPDATE M4120
			SET 
				M4120.del_user			= @P_cre_user
			,	M4120.del_ip			= @P_cre_ip
			,	M4120.del_datetime		= @w_time
			,	M4120.del_prg			= 'rM0110'
			WHERE 
				M4120.company_cd = @P_company_cd
			AND	M4120.mark_kbn	 = @P_mark_kbn
			AND M4120.del_datetime IS NULL
			--
			UPDATE M4121
			SET 
				M4121.del_user			= @P_cre_user
			,	M4121.del_ip			= @P_cre_ip
			,	M4121.del_datetime		= @w_time
			,	M4121.del_prg			= 'rM0110'
			WHERE 
				M4121.company_cd	= @P_company_cD
			AND M4121.mark_kbn		=	@P_mark_kbn
			AND M4121.del_datetime IS NULL
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
