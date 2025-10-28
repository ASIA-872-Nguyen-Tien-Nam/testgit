DROP PROCEDURE [SPC_EM0020_ACT3]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	SAVE DATA
--*  
--* 作成日/create date			:	2024/03										
--*	作成者/creater				:	trinhdt						
--*   					
--*	更新日/update date			:  						
--*	更新者/updater				:　  　								     	 
--*	更新内容/update content		:	　	
--****************************************************************************************
CREATE PROCEDURE [SPC_EM0020_ACT3] 
	-- Add the parameters for the stored procedure here
	@P_json			NVARCHAR(MAX)
	-- common
,	@P_cre_user		NVARCHAR(50)
,	@P_cre_ip		NVARCHAR(50)
,	@P_company_cd	SMALLINT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL							ERRTABLE	
	,	@order_by_min						INT					=	0
	,	@P_selected_items_no				SMALLINT			=	0
	,	@P_selected_items_nm				NVARCHAR(50)		=	''
	,	@P_arrange_order					SMALLINT			=	0
	,	@P_work_history_kbn					SMALLINT			=	0
	,	@P_id								SMALLINT			=	0
	,	@selected_items_no					SMALLINT			=	0
	
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		-- assign
		SET @P_selected_items_no					=	JSON_VALUE(@P_json,'$.selected_items_no')
		SET @P_selected_items_nm					=	JSON_VALUE(@P_json,'$.selected_items_nm')
		SET @P_arrange_order						=	JSON_VALUE(@P_json,'$.arrange_order')
		SET @P_work_history_kbn						=	JSON_VALUE(@P_json,'$.work_history_kbn')
		SET @P_id									=	JSON_VALUE(@P_json,'$.id')

	IF EXISTS (SELECT 1 FROM M5021 
					WHERE company_cd = @P_company_cd 
					AND selected_items_no = @P_selected_items_no 
					AND work_history_kbn = @P_work_history_kbn
					AND item_id = @P_id 
					AND del_datetime IS NOT NULL)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(
				8
			,	'#selected_items_no'
			,	0-- oderby
			,	0-- dialog  
			,	0
			,	0
			,	'selected_items_no not found'
			)
		END

	-- do stuff
	IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			IF @P_selected_items_no = 0
			BEGIN
				SET @selected_items_no  = ISNULL((SELECT MAX(selected_items_no) FROM M5021 
												WHERE company_cd = @P_company_cd 
												AND work_history_kbn = @P_work_history_kbn
												AND item_id = @P_id ), 0) + 1
				INSERT INTO M5021
				SELECT
					@P_company_cd
				,	@P_work_history_kbn
				,	@P_id
				,	@selected_items_no
				,	@P_selected_items_nm
				,	''
				,	@P_arrange_order
				,	@P_cre_user
				,	@P_cre_ip
				,	'eM0020'
				,	@w_time
				,	SPACE(0)
				,	SPACE(0)
				,	SPACE(0)
				,	NULL
				,	SPACE(0)
				,	SPACE(0)
				,	SPACE(0)
				,	NULL
			END
			ELSE BEGIN
				UPDATE M5021
				SET
					selected_items_nm			=	@P_selected_items_nm
				,	arrange_order				=	@P_arrange_order
				,	upd_user					=	@P_cre_user
				,	upd_ip						=	@P_cre_ip
				,	upd_prg						=	'eM0020'
				,	upd_datetime				=	@w_time
				WHERE
					company_cd					=	@P_company_cd
				AND work_history_kbn			=	@P_work_history_kbn
				AND item_id						=	@P_id
				AND	selected_items_no			=	@P_selected_items_no
			END
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
	SELECT @selected_items_no AS selected_items_no
END

GO
