DROP PROCEDURE [SPC_RM0200_ACT2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	DELETE DATA
--*		
--* 作成日/create date			:	2023/04/11											
--*	作成者/creater				:	namnt			
--*   		
--****************************************************************************************
CREATE PROCEDURE [SPC_RM0200_ACT2] 
	-- Add the parameters for the stored procedure here
	@P_company_cd		SMALLINT		=	0
,	@P_report_kind		SMALLINT		=	0
,	@P_sheet_cd			SMALLINT		=	0
,	@P_adaption_date	DATE			=	NULL
,	@P_cre_user			NVARCHAR(50)	=	''
,	@P_cre_ip			NVARCHAR(50)	=	''

AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2		= SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			INT				= 0	
	,	@w_office_cd			SMALLINT		= 0
	IF NOT EXISTS (SELECT 1 FROM M4200 WHERE company_cd		= @P_company_cd 
											AND	 sheet_cd		= @P_sheet_cd
											AND	 adaption_date	= @P_adaption_date 
											AND	 report_kind	= @P_report_kind 
											AND  del_datetime IS NULL)
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
	BEGIN TRANSACTION
		BEGIN TRY
			UPDATE M4200
			SET 
				M4200.del_user			= @P_cre_user
			,	M4200.del_ip			= @P_cre_ip
			,	M4200.del_datetime		= @w_time
			,	M4200.del_prg			= 'rM0200'
			WHERE M4200.company_cd = @P_company_cd
			AND M4200.sheet_cd	= @P_sheet_cd
			AND M4200.adaption_date	= @P_adaption_date
			AND M4200.report_kind	= @P_report_kind
			AND M4200.del_datetime IS NULL
			UPDATE M4201
			SET 
				M4201.del_user			= @P_cre_user
			,	M4201.del_ip			= @P_cre_ip
			,	M4201.del_datetime		= @w_time
			,	M4201.del_prg			= 'rM0200'
			WHERE M4201.company_cd = @P_company_cd
			AND M4201.adaption_date	= @P_adaption_date
			AND M4201.report_kind	= @P_report_kind
			AND M4201.sheet_cd	= @P_sheet_cd
			AND M4201.del_datetime IS NULL
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
	IF (SELECT COUNT(1) FROM @ERR_TBL) > 1
	BEGIN
		ROLLBACK TRANSACTION
	END
	IF(@@TRANCOUNT > 0)
	BEGIN
		COMMIT TRANSACTION
	END
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
