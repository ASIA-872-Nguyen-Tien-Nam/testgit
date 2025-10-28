DROP PROCEDURE [SPC_I1041_ACT2]
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
--* 作成日/create date			:	2018/08/16											
--*	作成者/creater				:	namnb						
--*   					
--*	更新日/update date			:  						
--*	更新者/updater				:　  　								     	 
--*	更新内容/update content		:	　	
--****************************************************************************************
CREATE PROCEDURE [SPC_I1041_ACT2] 
	-- Add the parameters for the stored procedure here
	@P_category		INT				=	0
,	@P_status_cd	INT				=	0
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
	,	@employee_cd			nvarchar(20)
	,	@user_id				nvarchar(50)
	
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM M0311 WHERE company_cd = @P_company_cd AND category = @P_category AND status_cd = @P_status_cd AND del_datetime IS NULL)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(
				21
			,	'#employee_cd'
			,	0-- oderby
			,	2-- dialog  
			,	0
			,	0
			,	'employee_cd not found'
			)
		END
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			UPDATE M0311
			SET
				del_user		=	@P_cre_user
			,	del_ip			=	@P_cre_ip
			,	del_prg			=	'I0141'
			,	del_datetime	=	@w_time
			WHERE
				company_cd		=	@P_company_cd
			AND	category		=	@P_category
			AND	status_cd		=	@P_status_cd
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
