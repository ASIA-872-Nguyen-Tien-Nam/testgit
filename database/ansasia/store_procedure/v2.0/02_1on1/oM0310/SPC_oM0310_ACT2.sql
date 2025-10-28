/****** Object:  StoredProcedure [dbo].[SPC_oM0310_ACT2]    Script Date: 2018/08/28 17:16:04 ******/
SET ANSI_NULLS ON
GO
DROP PROCEDURE [dbo].[SPC_oM0310_ACT2]
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	DELETE DATA
--*  
--* 作成日/create date			:	2020/11/06									
--*	作成者/creater				:	DUONGNTT						
--*   					
--*	更新日/update date			:  			
--*	更新者/updater				:　 						     	 
--*	更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_oM0310_ACT2] 
	@P_cre_user		NVARCHAR(50) = ''
,	@P_cre_ip		NVARCHAR(50) = ''
,	@P_company_cd	SMALLINT	 = 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time							DATETIME2			= SYSDATETIME()
	,	@ERR_TBL						ERRTABLE			  
	,	@order_by_min					INT					= 0
	
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		--
		IF NOT EXISTS (SELECT 1 FROM M2610 WHERE company_cd = @P_company_cd AND del_datetime IS NULL)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(
				21
			,	'#company_cd'
			,	0-- oderby
			,	1-- dialog  
			,	0
			,	0
			,	'company_cd not found'
			)
		END
		
		--
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			UPDATE M2610
			SET
				del_user		=	@P_cre_user
			,	del_ip			=	@P_cre_ip
			,	del_prg			=	'oM0310'
			,	del_datetime	=	@w_time
			WHERE
				company_cd		=	@P_company_cd
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
