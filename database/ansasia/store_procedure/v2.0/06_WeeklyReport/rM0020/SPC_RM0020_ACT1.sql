DROP PROCEDURE [SPC_RM0020_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  個人マスタ：RM0020 - SAVE/UPDATE
 *
 *  作成日  ：2023/04/05
 *  作成者  ：ANS-ASIA quangnd
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_RM0020_ACT1] 
	@P_json				NVARCHAR(MAX)	= ''
,	@P_cre_user			NVARCHAR(50)	= ''
,	@P_cre_ip			NVARCHAR(50)	= ''
,	@P_company_cd		SMALLINT		= 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2	 = SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@fiscal_year			SMALLINT
	,	@target1_nm				NVARCHAR(50)
	,	@target1_use_typ		TINYINT
	,	@target2_nm				NVARCHAR(200)
	,	@target2_use_typ		TINYINT
	,	@target3_nm				NVARCHAR(50)
	,	@target3_use_typ		TINYINT
	,	@target4_nm				NVARCHAR(50)
	,	@target4_use_typ		TINYINT
	,	@target5_nm				NVARCHAR(50)
	,	@target5_use_typ		TINYINT
	--
	CREATE TABLE #HISTORY_M4000 (
		company_cd			SMALLINT
	,	fiscal_year			SMALLINT
	,	target1_nm			NVARCHAR(50)
	,	target1_use_typ		TINYINT
	,	target2_nm			NVARCHAR(50)
	,	target2_use_typ		TINYINT
	,	target3_nm			NVARCHAR(50)
	,	target3_use_typ		TINYINT
	,	target4_nm			NVARCHAR(50)
	,	target4_use_typ		TINYINT
	,	target5_nm			NVARCHAR(50)
	,	target5_use_typ		TINYINT
	,	arrange_order		INT
	,	cre_user			NVARCHAR(50)
	,	cre_ip				NVARCHAR(50)
	,	cre_prg				NVARCHAR(20)
	,	cre_datetime		DATETIME
	,	upd_user			NVARCHAR(50)
	,	upd_ip				NVARCHAR(50)
	,	upd_prg				NVARCHAR(20)
	,	upd_datetime		DATETIME
	,	del_user			NVARCHAR(50)
	,	del_ip				NVARCHAR(50)
	,	del_prg				NVARCHAR(20)
	,	del_datetime		DATETIME
	)
	--
	SET @fiscal_year			=	ISNULL(JSON_VALUE(@P_json,'$.fiscal_year'),0)
	SET @target1_nm				=	ISNULL(JSON_VALUE(@P_json,'$.target1_name'),'')
	SET @target1_use_typ		=	ISNULL(JSON_VALUE(@P_json,'$.target1_use_typ'),0)
	SET @target2_nm				=	ISNULL(JSON_VALUE(@P_json,'$.target2_name'),'')
	SET @target2_use_typ		=	ISNULL(JSON_VALUE(@P_json,'$.target2_use_typ'),0)
	SET @target3_nm				=	ISNULL(JSON_VALUE(@P_json,'$.target3_name'),'')
	SET @target3_use_typ		=	ISNULL(JSON_VALUE(@P_json,'$.target3_use_typ'),0)
	SET @target4_nm				=	ISNULL(JSON_VALUE(@P_json,'$.target4_name'),'')
	SET @target4_use_typ		=	ISNULL(JSON_VALUE(@P_json,'$.target4_use_typ'),0)
	SET @target5_nm				=	ISNULL(JSON_VALUE(@P_json,'$.target5_name'),'')
	SET @target5_use_typ		=	ISNULL(JSON_VALUE(@P_json,'$.target5_use_typ'),0)
	--


	BEGIN TRANSACTION
	BEGIN TRY
		IF ISJSON(@P_json) <= 0
		BEGIN
			INSERT INTO @ERR_TBL VALUES(		
				22														
			,	''									 				
			,	0-- oderby							  				
			,	1-- dialog  							
			,	0													
			,	0									
			,	'json format'						
			)
		END
		--
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			INSERT INTO #HISTORY_M4000
			SELECT 
				M4000.company_cd
			,	M4000.fiscal_year
			,	M4000.target1_nm
			,	M4000.target1_use_typ
			,	M4000.target2_nm
			,	M4000.target2_use_typ
			,	M4000.target3_nm
			,	M4000.target3_use_typ
			,	M4000.target4_nm
			,	M4000.target4_use_typ
			,	M4000.target5_nm
			,	M4000.target5_use_typ
			,	M4000.arrange_order
			,	M4000.cre_user
			,	M4000.cre_ip
			,	M4000.cre_prg
			,	M4000.cre_datetime
			,	M4000.upd_user
			,	M4000.upd_ip
			,	M4000.upd_prg
			,	M4000.upd_datetime
			,	M4000.del_user
			,	M4000.del_ip
			,	M4000.del_prg
			,	M4000.del_datetime
			FROM M4000
			WHERE M4000.company_cd = @P_company_cd  
			AND M4000.fiscal_year = @fiscal_year
			AND del_datetime IS NULL
			--
			DELETE FROM M4000 WHERE M4000.company_cd = @P_company_cd  AND M4000.fiscal_year = @fiscal_year
				INSERT INTO M4000
				SELECT
					@P_company_cd
				,	@fiscal_year
				,	@target1_nm
				,	@target1_use_typ
				,	@target2_nm
				,	@target2_use_typ
				,	@target3_nm
				,	@target3_use_typ
				,	@target4_nm
				,	@target4_use_typ
				,	@target5_nm
				,	@target5_use_typ
				,	0
				,	@P_cre_user
				,	@P_cre_ip
				,	'rM0020'
				,	@w_time
				,	''
				,	''
				,	''
				,	NULL
				,	''
				,	''
				,	''
				,	NULL
			
			--
			UPDATE M4000 SET
					cre_prg	= CASE WHEN #HISTORY_M4000.del_datetime IS NOT NULL
									THEN SPACE(0)
									ELSE
										'rM0020'
									END
				,	cre_user		= CASE WHEN #HISTORY_M4000.del_datetime IS NOT NULL
									THEN @P_cre_user
									ELSE
										#HISTORY_M4000.cre_user
									END
				,	cre_ip			= CASE WHEN #HISTORY_M4000.del_datetime IS NOT NULL
									THEN @P_cre_ip
									ELSE
										#HISTORY_M4000.cre_ip
									END
				,	cre_datetime	= CASE WHEN #HISTORY_M4000.del_datetime IS NOT NULL
									THEN @w_time
									ELSE
										#HISTORY_M4000.cre_datetime
									END
				,	upd_prg			= CASE WHEN #HISTORY_M4000.del_datetime IS NOT NULL
									THEN SPACE(0)
									ELSE
										'rM0020'
									END
				,	upd_user		= CASE WHEN #HISTORY_M4000.del_datetime IS NOT NULL
									THEN SPACE(0)
									ELSE
										@P_cre_user
									END
				,	upd_ip			= CASE WHEN #HISTORY_M4000.del_datetime IS NOT NULL
									THEN SPACE(0)
									ELSE
										@P_cre_ip
									END
				,	upd_datetime	= CASE WHEN #HISTORY_M4000.del_datetime IS NOT NULL
									THEN NULL
									ELSE
										@w_time
									END
				FROM M4000
				INNER JOIN #HISTORY_M4000 ON(
					M4000.company_cd		=	#HISTORY_M4000.company_cd
				AND M4000.fiscal_year		=	#HISTORY_M4000.fiscal_year
				)
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

	
	--[0]
	SELECT 
		message_no
	,	item
	,	order_by
	,	error_typ
	,	value1
	,	value2
	,	remark
	FROM @ERR_TBL
	ORDER BY 
		order_by
END

GO
