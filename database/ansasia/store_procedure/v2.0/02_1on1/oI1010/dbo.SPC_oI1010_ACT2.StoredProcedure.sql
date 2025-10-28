DROP PROCEDURE [SPC_OI1010_ACT2]
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
CREATE PROCEDURE [SPC_OI1010_ACT2] 
	-- Add the parameters for the stored procedure here
	@P_company_cd				SMALLINT		=	0
,	@P_fiscal_year				SMALLINT		=	0
,	@P_oneonone_group_json		NVARCHAR(MAX)	= ''
,	@P_cre_user					NVARCHAR(50)	=	''
,	@P_cre_ip					NVARCHAR(50)	=	''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2		= SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			INT				= 0	
	,	@w_office_cd			SMALLINT		= 0
	-- START TRANSACTION
	CREATE TABLE #M2600 (
		oneonone_group      	SMALLINT
	)
	BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO #M2600
		SELECT 
			ISNULL(oneonone_group ,0)  
		FROM OPENJSON(@P_oneonone_group_json, '$.oneonone_group_list') WITH(
			oneonone_group      	smallint
		)
		IF NOT EXISTS (SELECT 1 FROM M2620 INNER JOIN #M2600 ON(
										M2620.company_cd		=	@P_company_cd
									AND M2620.fiscal_year		=	@P_fiscal_year
									AND M2620.[1on1_group_cd]	=	#M2600.oneonone_group
									AND M2620.del_datetime IS NULL
									) )
			BEGIN
				INSERT INTO @ERR_TBL VALUES(
					21
				,	'#category1_cd'
				,	0-- oderby
				,	1-- dialog  
				,	0
				,	0
				,	'category1_cd not found'
				)
			END
		IF EXISTS(SELECT 1 FROM F2000 INNER JOIN #M2600 ON(
										F2000.company_cd		=	@P_company_cd
									AND F2000.fiscal_year		=	@P_fiscal_year
									AND F2000.[1on1_group_cd]	=	#M2600.oneonone_group
									AND F2000.del_datetime IS NULL
									)  )
		BEGIN
			INSERT INTO @ERR_TBL VALUES(
					124
				,	''
				,	0-- oderby
				,	1-- dialog  
				,	0
				,	0
				,	'existed employe in group'
				)
		END
		IF EXISTS (SELECT 1 FROM @ERR_TBL)
		BEGIN
			GOTO COMPLETE_QUERY
		END
			UPDATE M2620
			SET 
				M2620.del_user			= @P_cre_user
			,	M2620.del_ip			= @P_cre_ip
			,	M2620.del_datetime		= @w_time
			,	M2620.del_prg			= 'oI1010'
			FROM M2620 
			INNER JOIN #M2600 ON(
				M2620.company_cd		=	@P_company_cd
			AND M2620.fiscal_year		=	@P_fiscal_year
			AND M2620.[1on1_group_cd]	=	#M2600.oneonone_group
			)
			WHERE 
				M2620.company_cd		= @P_company_cd
			AND M2620.fiscal_year		= @P_fiscal_year
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
	--
	COMPLETE_QUERY:
	IF (SELECT COUNT(1) FROM @ERR_TBL) > 1
	BEGIN
		ROLLBACK TRANSACTION
	END
	--
	IF(@@TRANCOUNT > 0)
	BEGIN
		COMMIT TRANSACTION
	END
    -- Insert statements for procedure here
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
