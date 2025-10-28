DROP PROCEDURE [SPC_M0040_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC XXX '{}','','::1';

--****************************************************************************************
--*   											
--*   											
--* 処理概要/process overview	:	SAVE DATA
--*  
--* 作成日/create date			:	2018/08/20											
--*	作成者/creater				:	longvv				
--*   					
--*	更新日/update date			:  						
--*	更新者/updater				:　  　								     	 
--*	更新内容/update content		:	　	
--****************************************************************************************
CREATE PROCEDURE [SPC_M0040_ACT1] 
	-- Add the parameters for the stored procedure here
	@P_json			nvarchar(max)
	-- common
,	@P_cre_user		nvarchar(50)
,	@P_cre_ip		nvarchar(50)
,	@P_company_cd	smallint
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			int					=	0
	,	@P_position_cd			int			=	0
	,	@P_position_nm			nvarchar(50)		=	''
	,	@P_position_ab_nm		nvarchar(10)		=	''
	,	@P_arrange_order		int					=	0
	,	@P_import_cd			nvarchar(255)		=	''
	,	@position_cd			int					=	0
	,	@import_cd_check  		int					=	0
	
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		-- assign
		SET @P_position_cd		=	JSON_VALUE(@P_json,'$.position_cd')
		SET @P_position_nm		=	JSON_VALUE(@P_json,'$.position_nm')
		SET @P_position_ab_nm	=	JSON_VALUE(@P_json,'$.position_ab_nm')
		SET @P_arrange_order	=	JSON_VALUE(@P_json,'$.arrange_order')
		SET @P_import_cd		=	JSON_VALUE(@P_json,'$.import_cd')

		SET @import_cd_check		=	ISNULL((SELECT 1 FROM M0040 WHERE
											company_cd			=	@P_company_cd
										AND	import_cd			=	@P_import_cd
										AND	position_cd			=	@P_position_cd
										AND	del_datetime IS NULL), 0)

		--If update and not update itself
		IF @P_position_cd <> 0 AND @import_cd_check = 0 AND EXISTS (
			SELECT 1 FROM M0040
			WHERE
				company_cd = @P_company_cd
			AND	import_cd  = @P_import_cd
			AND import_cd  <> ''
			AND	del_datetime IS NULL
		)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(		
				159
			,	'#import_cd'
			,	0
			,	1
			,	0
			,	0
			,	'validate 159'
			)
		END

		--If insert
		IF @P_position_cd = 0 AND EXISTS (
			SELECT 1 FROM M0040
			WHERE
				company_cd = @P_company_cd
			AND	import_cd  = @P_import_cd
			AND import_cd  <> ''
			AND	del_datetime IS NULL
		)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(		
				159
			,	'#import_cd'
			,	0
			,	1
			,	0
			,	0
			,	'validate 159'
			)
		END

		--IF EXISTS (SELECT 1 FROM M0040 WHERE company_cd = @P_company_cd AND position_cd = @P_position_cd AND del_datetime IS NOT NULL)
		--BEGIN
		--	INSERT INTO @ERR_TBL VALUES(
		--		8
		--	,	'#position_cd'
		--	,	0-- oderby
		--	,	0-- dialog  
		--	,	0
		--	,	0
		--	,	'position_cd not found'
		--	)
		--END

		-- do stuff
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			IF @P_position_cd = 0
			BEGIN
				SET @position_cd  = ISNULL((SELECT MAX(position_cd) FROM M0040 WHERE company_cd = @P_company_cd), 0) + 1
				INSERT INTO M0040 (
					company_cd
				,	position_cd
				,	position_nm
				,	position_ab_nm
				,	import_cd
				,	arrange_order
				,	cre_user
				,	cre_ip
				,	cre_prg
				,	cre_datetime
				)
				SELECT
					@P_company_cd
				,	@position_cd 
				,	@P_position_nm
				,	@P_position_ab_nm
				,	@P_import_cd
				,	@P_arrange_order
				,	@P_cre_user
				,	@P_cre_ip
				,	'M0040'
				,	@w_time
			END
			ELSE BEGIN
				UPDATE M0040
				SET
					position_nm		=	@P_position_nm
				,	position_ab_nm	=	@P_position_ab_nm
				,	import_cd		=	@P_import_cd
				,	arrange_order	=	@P_arrange_order
				,	upd_user		=	@P_cre_user
				,	upd_ip			=	@P_cre_ip
				,	upd_prg         =	'M0040'
				,	upd_datetime	=	@w_time
				WHERE
					company_cd		=	@P_company_cd
				AND	position_cd		=	@P_position_cd
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
	SELECT @position_cd AS position_cd
END

GO
