DROP PROCEDURE [SPC_eM0100_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	
--*  
--*  作成日/create date			:	2024/04/01
--*　作成者/creater				:	manhnd						
--*  作成内容/create content		:	save em0100			
--*	 更新日/update date			:  	
--*	 更新者/updater				:　 
--*	 更新内容/update content	:	
--****************************************************************************************
CREATE PROCEDURE [SPC_eM0100_ACT1] 
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
	,	@w_order_by_min						INT					=	0
	-- TABLES
	CREATE TABLE #TABLE_DETAILS (
        id									BIGINT			IDENTITY(1,1)
    ,   authority_cd						SMALLINT
    ,   tab_id								SMALLINT
    --,   use_typ								NVARCHAR(20)
	,	use_typ								SMALLINT
	)
	--START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		--DATA TABLES
		INSERT INTO #TABLE_DETAILS
		SELECT
			JSON_VALUE([value],'$.authority_cd')					AS	authority_cd
		,	JSON_VALUE([value],'$.tab_id')							AS	tab_id
		,	JSON_VALUE([value],'$.use_typ')							AS	use_typ
		FROM OPENJSON(@P_json,'$.tabs')

		--DELETE
		UPDATE M5100 SET
			--M5100.use_typ			=	N'0'
			M5100.use_typ			=	0
		,	M5100.upd_user			=	@P_cre_user
		,	M5100.upd_ip			=	@P_cre_ip
		,	M5100.upd_prg			=	N'eM0100'
		,	M5100.upd_datetime		=	@w_time
		FROM M5100
		LEFT OUTER JOIN #TABLE_DETAILS ON (
			M5100.company_cd		=	@P_company_cd
		AND M5100.authority_cd		=	#TABLE_DETAILS.authority_cd
		AND M5100.tab_id			=	#TABLE_DETAILS.tab_id
		)
		WHERE
			M5100.company_cd		=	@P_company_cd
		AND	#TABLE_DETAILS.authority_cd IS NULL
		
		--UPDATE
		UPDATE M5100 SET
			M5100.use_typ		=	#TABLE_DETAILS.use_typ
		,	M5100.upd_user		=	@P_cre_user
		,	M5100.upd_ip		=	@P_cre_ip
		,	M5100.upd_prg		=	N'eM0100'
		,	M5100.upd_datetime	=	@w_time
		FROM M5100
		INNER JOIN #TABLE_DETAILS ON (
			M5100.company_cd	=	@P_company_cd
		AND	M5100.authority_cd	=	#TABLE_DETAILS.authority_cd
		AND	M5100.tab_id		=	#TABLE_DETAILS.tab_id
		)
		WHERE
			M5100.company_cd		=	@P_company_cd	
		
		--INSERT
		INSERT INTO M5100 
		SELECT
			@P_company_cd
		,	#TABLE_DETAILS.authority_cd
		,	#TABLE_DETAILS.tab_id
		,	#TABLE_DETAILS.use_typ
		,	@P_cre_user
		,	@P_cre_ip
		,	N'eM0100'
		,	@w_time
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	NULL
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	NULL
		FROM #TABLE_DETAILS
		LEFT OUTER JOIN M5100 ON (
			@P_company_cd					=	M5100.company_cd
		AND	#TABLE_DETAILS.authority_cd		=	M5100.authority_cd
		AND	#TABLE_DETAILS.tab_id			=	M5100.tab_id
		)
		WHERE
			M5100.company_cd IS NULL
			
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
		@w_order_by_min = MIN(order_by)
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
	WHERE order_by = @w_order_by_min
	ORDER BY 
		order_by
END
GO
