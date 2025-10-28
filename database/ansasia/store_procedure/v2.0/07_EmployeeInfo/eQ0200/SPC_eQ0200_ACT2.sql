DROP PROCEDURE [SPC_eQ0200_ACT2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC XXX '{}','','::1';

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	DELETE DATA
--*  
--* 作成日/create date			:	2024/04											
--*	作成者/creater				:	trinhdt						
--*   					
--*	更新日/update date			:  						
--*	更新者/updater				:　  　								     	 
--*	更新内容/update content		:	　	
--****************************************************************************************
CREATE PROCEDURE [SPC_eQ0200_ACT2] 
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
	
	CREATE TABLE #TABLE_JSON(
		id								int				identity(1,1)
	,	employee_cd						nvarchar(10)
	)

	-- insert json
	INSERT INTO #TABLE_JSON
	SELECT 
		json_table.seat_item_employee_cd
	FROM OPENJSON(@P_json,'$.seat_del') WITH(
		seat_item_employee_cd			nvarchar(10)
	)AS json_table
	
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY

		UPDATE F5100
			SET
				del_user		=	@P_cre_user
			,	del_ip			=	@P_cre_ip
			,	del_prg         =	'eQ0200'
			,	del_datetime	=	@w_time
		FROM #TABLE_JSON
		INNER JOIN F5100 ON (
			@P_company_cd				=	F5100.company_cd
		AND	#TABLE_JSON.employee_cd		=	F5100.employee_cd
		)		

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

	-- DROP
	DROP TABLE #TABLE_JSON
END

GO
