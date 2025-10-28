DROP PROCEDURE [SPC_EM0030_ACT3]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_EM0030_ACT3 '{"training_cd":"5","training_nm":"name 3","arrange_order":"0","mode":"1"}','721','::1','740';

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
CREATE PROCEDURE [SPC_EM0030_ACT3] 
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
	,	@P_training_cd						SMALLINT			=	0
	,	@P_training_nm						NVARCHAR(50)		=	''
	,	@P_arrange_order					INT					=	0
	,	@P_mode								INT					=	0
	,	@training_cd						SMALLINT			=	0
	
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		-- assign
		SET @P_training_cd					=	JSON_VALUE(@P_json,'$.training_cd')
		SET @P_training_nm					=	JSON_VALUE(@P_json,'$.training_nm')
		SET @P_arrange_order				=	JSON_VALUE(@P_json,'$.arrange_order')
		SET @P_mode							=	JSON_VALUE(@P_json,'$.mode')

	IF (@P_mode = 1)
	BEGIN

		IF EXISTS (SELECT 1 FROM M5031 WHERE company_cd = @P_company_cd AND training_category_cd = @P_training_cd AND del_datetime IS NOT NULL)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(
				8
			,	'#training_cd'
			,	0-- oderby
			,	0-- dialog  
			,	0
			,	0
			,	'training_cd not found'
			)
		END

		-- do stuff
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			IF @P_training_cd = 0
			BEGIN
				SET @training_cd  = ISNULL((SELECT MAX(training_category_cd) FROM M5031 WHERE company_cd = @P_company_cd), 0) + 1
				INSERT INTO M5031
				SELECT
					@P_company_cd
				,	@training_cd
				,	@P_training_nm
				,	N''
				,	@P_arrange_order
				,	@P_cre_user
				,	@P_cre_ip
				,	'eM0030'
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
				UPDATE M5031
				SET
					training_category_nm		=	@P_training_nm
				,	arrange_order				=	@P_arrange_order
				,	upd_user					=	@P_cre_user
				,	upd_ip						=	@P_cre_ip
				,	upd_prg						=	'eM0030'
				,	upd_datetime				=	@w_time
				WHERE
					company_cd					=	@P_company_cd
				AND	training_category_cd		=	@P_training_cd
			END
		END
	END
	ELSE
	BEGIN
	IF EXISTS (SELECT 1 FROM M5032 WHERE company_cd = @P_company_cd AND training_course_format_cd = @P_training_cd AND del_datetime IS NOT NULL)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(
				8
			,	'#training_cd'
			,	0-- oderby
			,	0-- dialog  
			,	0
			,	0
			,	'training_cd not found'
			)
		END

		-- do stuff
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			IF @P_training_cd = 0
			BEGIN
				SET @training_cd  = ISNULL((SELECT MAX(training_course_format_cd) FROM M5032 WHERE company_cd = @P_company_cd), 0) + 1
				INSERT INTO M5032
				SELECT
					@P_company_cd
				,	@training_cd
				,	@P_training_nm
				,	N''
				,	@P_arrange_order
				,	@P_cre_user
				,	@P_cre_ip
				,	'eM0030'
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
				UPDATE M5032
				SET
					training_course_format_nm	=	@P_training_nm
				,	arrange_order				=	@P_arrange_order
				,	upd_user					=	@P_cre_user
				,	upd_ip						=	@P_cre_ip
				,	upd_prg						=	'eM0030'
				,	upd_datetime				=	@w_time
				WHERE
					company_cd						=	@P_company_cd
				AND	training_course_format_cd		=	@P_training_cd
			END
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
	SELECT @training_cd AS training_cd
END

GO
