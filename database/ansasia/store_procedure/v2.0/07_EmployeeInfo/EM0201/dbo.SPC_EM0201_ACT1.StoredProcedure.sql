SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	
--*  
--*  作成日/create date			:	2024/04
--*　作成者/creater				:	matsumoto					
--*  作成内容/create content	:	save EM0201					
--*	 更新日/update date			:  	
--*	 更新者/updater				:　 
--*	 更新内容/update content	:	
--****************************************************************************************
CREATE PROCEDURE [SPC_EM0201_ACT1] 
	-- Add the parameters for the stored procedure here
	@P_json									NVARCHAR(MAX)
	-- common
,	@P_cre_user								NVARCHAR(50)
,	@P_cre_ip								NVARCHAR(50)
,	@P_company_cd							SMALLINT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL							ERRTABLE	
	,	@order_by_min						INT					=	0
	,	@P_field_cd					SMALLINT			=	0
	,	@P_field_nm					NVARCHAR(50)		=	N''
	,	@P_arrange_order					INT					=	0
	,	@P_search_kbn				SMALLINT			=	0
	,	@P_mode								INT					=	0
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		-- SET VALUES
		SET @P_field_cd				=	JSON_VALUE(@P_json,'$.field_cd')
		SET @P_field_nm				=	JSON_VALUE(@P_json,'$.field_nm')
		SET @P_arrange_order				=	JSON_VALUE(@P_json,'$.arrange_order')
		SET @P_search_kbn			=	JSON_VALUE(@P_json,'$.search_kbn')
		SET @P_mode							=	JSON_VALUE(@P_json,'$.mode')
		
		--VALIDATE
		IF @P_mode = 1 --MODE EDIT
		BEGIN
			-- validate not exists data
			IF EXISTS (SELECT 1 FROM M5202 WHERE company_cd = @P_company_cd AND field_cd = @P_field_cd AND del_datetime IS NOT NULL)
			BEGIN
				INSERT INTO @ERR_TBL VALUES(
					8
				,	N'#field_cd'
				,	0-- oderby
				,	0-- dialog  
				,	0
				,	0
				,	N'field_cd not found'
				)
			END
		END
		-- do stuff
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			IF @P_mode = 0 --MODE ADD
			BEGIN
				SELECT 
					@P_field_cd = ISNULL(MAX(field_cd),0) + 1
				FROM M5202
				WHERE
					company_cd = @P_company_cd
				--
				INSERT INTO M5202 
				SELECT
					@P_company_cd
				,	@P_field_cd
				,	@P_field_nm
				,	@P_arrange_order
				,	@P_search_kbn
				,	@P_cre_user
				,	@P_cre_ip
				,	N'EM0201'
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
				UPDATE M5202 SET
					field_nm		=	@P_field_nm
				,	search_kbn		=	@P_search_kbn
				,	arrange_order			=	@P_arrange_order
				,	upd_user				=	@P_cre_user
				,	upd_ip					=	@P_cre_ip
				,	upd_prg					=	N'EM0201'
				,	upd_datetime			=	@w_time
				WHERE
					company_cd				=	@P_company_cd
				AND	field_cd		=	@P_field_cd
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
	--[1]
	SELECT 
		@P_field_cd						AS	field_cd
END
GO
