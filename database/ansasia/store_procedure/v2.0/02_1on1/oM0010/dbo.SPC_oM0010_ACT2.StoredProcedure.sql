DROP PROCEDURE [SPC_OM0010_ACT2]
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
CREATE PROCEDURE [SPC_OM0010_ACT2] 
	-- Add the parameters for the stored procedure here
	@P_company_cd		SMALLINT		=	0
,	@P_refer_kbn		SMALLINT		=	0
,	@P_file_cd			SMALLINT		=	0
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
	,	@contract_company_attr	INT				=	0
	-- START TRANSACTION
	SET @contract_company_attr = (SELECT contract_company_attribute  FROM M0001 WHERE company_cd = @P_company_cd AND del_datetime IS NULL)
	IF @contract_company_attr = 1
	BEGIN
		SET @P_company_cd = 0
	END
	BEGIN TRANSACTION
	BEGIN TRY
		
			UPDATE M2300
			SET 
				M2300.del_user			= @P_cre_user
			,	M2300.del_ip			= @P_cre_ip
			,	M2300.del_datetime		= @w_time
			,	M2300.del_prg			= 'oM0010'
			WHERE 
				M2300.company_cd		= @P_company_cd
			AND M2300.refer_kbn			= @P_refer_kbn
			AND M2300.file_cd			= @P_file_cd
			AND M2300.del_datetime IS NULL

		
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
