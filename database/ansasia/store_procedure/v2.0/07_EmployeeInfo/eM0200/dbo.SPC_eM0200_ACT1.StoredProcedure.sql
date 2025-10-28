DROP PROCEDURE [SPC_eM0200_ACT1]
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
--*  作成日/create date			:	2024/03/26
--*　作成者/creater				:	manhnd						
--*  作成内容/create content		:	save em0200			
--*	 更新日/update date			:  	
--*	 更新者/updater				:　 
--*	 更新内容/update content	:	
--****************************************************************************************
CREATE PROCEDURE [SPC_eM0200_ACT1] 
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
	,	@w_max_no							INT					=	0
	-- SCREEN
	,	@w_organization_chart_use_typ		SMALLINT			=	0
	,	@w_seating_chart_use_typ			SMALLINT			=	0
	,	@w_search_function_use_typ			SMALLINT			=	0
	,	@w_initial_display					SMALLINT			=	0
	,	@w_emailaddress_display_kbn			SMALLINT			=	0
	,	@w_company_mobile_display_kbn		SMALLINT			=	0
	,	@w_extension_number_display_kbn		SMALLINT			=	0

	-- TABLES
	CREATE TABLE #TABLE_DETAILS (
        id									BIGINT			IDENTITY(1,1)
    ,   floor_id							SMALLINT
    ,   floor_name							NVARCHAR(20)
	,   floor_map							NVARCHAR(100)
    ,   floor_map_name						NVARCHAR(300)
    ,   seating_chart_typ					SMALLINT
    )
	CREATE TABLE #TABLE_INSERT (
        id									BIGINT			IDENTITY(1,1)
    ,   floor_id							SMALLINT
    ,   floor_name							NVARCHAR(20)
	,   floor_map							NVARCHAR(100)
    ,   floor_map_name						NVARCHAR(300)
    ,   seating_chart_typ					SMALLINT
    )
	CREATE TABLE #CHECK_DUPLICATE (
        id									BIGINT			IDENTITY(1,1)
    ,   floor_id							SMALLINT
    ,   floor_name							NVARCHAR(20)
	,   floor_map							NVARCHAR(100)
    ,   floor_map_name						NVARCHAR(300)
    ,   seating_chart_typ					SMALLINT
	,	count_duplicate						INT
	,	error_id							INT
    )

	--SET VALUES
	SET @w_organization_chart_use_typ				=	JSON_VALUE(@P_json,'$.organization_chart_use_typ')
	SET @w_seating_chart_use_typ					=	JSON_VALUE(@P_json,'$.seating_chart_use_typ')
	SET @w_search_function_use_typ					=	JSON_VALUE(@P_json,'$.search_function_use_typ')
	SET @w_initial_display							=	JSON_VALUE(@P_json,'$.initial_display')
	SET @w_emailaddress_display_kbn					=	JSON_VALUE(@P_json,'$.emailaddress_display_kbn')
	SET @w_company_mobile_display_kbn				=	JSON_VALUE(@P_json,'$.company_mobile_display_kbn')
	SET @w_extension_number_display_kbn				=	JSON_VALUE(@P_json,'$.extension_number_display_kbn')

	--SET MAX FLOOR_ID
	SELECT 
		@w_max_no = ISNULL(MAX(floor_id),0)
	FROM M5201
	WHERE
		company_cd		=	@P_company_cd
	-- DATA TABLES
	INSERT INTO #TABLE_DETAILS
	SELECT
		JSON_VALUE([value],'$.floor_id')						AS floor_id
	,	JSON_VALUE([value],'$.floor_name')						AS floor_name
	,	JSON_VALUE([value],'$.floor_map')						AS floor_map
	,	ISNULL(JSON_VALUE([value],'$.floor_map_name'), N'')		AS floor_map_name
	,	JSON_VALUE([value],'$.seating_chart_typ')				AS seating_chart_typ
	FROM OPENJSON(@P_json,'$.tr')

	INSERT INTO #CHECK_DUPLICATE
	SELECT 
		floor_id
	,	floor_name
	,	floor_map
	,	floor_map_name
	,	seating_chart_typ
	,	COUNT(1) OVER (PARTITION BY floor_name)
	,	id
	FROM #TABLE_DETAILS

	-- VALIDATE
	-- VALIDATE DUPLICATE FLOOR_NAME
	INSERT INTO @ERR_TBL
	SELECT
		165
	,	N'.floor_name' 
	,	0-- oderby
	,	0-- dialog  
	,	error_id
	,	0
	,	N'floor_name'
	FROM #CHECK_DUPLICATE
	WHERE
		count_duplicate > 1
	
	-- VALIDATE MAX LENGTH
	INSERT INTO @ERR_TBL
	SELECT
		27
	,	N'.floor_map_name' 
	,	0-- oderby
	,	0-- dialog  
	,	#TABLE_DETAILS.id
	,	0
	,	N'floor_map_name'
	FROM #TABLE_DETAILS
	WHERE
		LEN(floor_map_name) > 100

	--@w_seating_chart_use_typ = 1 => VALIDATE REQUIRED FOR フロア名 AND フロアマップ
	IF @w_seating_chart_use_typ = 1 
	BEGIN 
		INSERT INTO @ERR_TBL
		SELECT 
			8
		,	N'.floor_name' 
		,	0-- oderby
		,	0-- dialog  
		,	#TABLE_DETAILS.id
		,	0
		,	N'floor_name'
		FROM #TABLE_DETAILS
		WHERE
			floor_name = N''

		INSERT INTO @ERR_TBL
		SELECT 
			8
		,	N'.floor_map_name' 
		,	0-- oderby
		,	0-- dialog  
		,	#TABLE_DETAILS.id
		,	0
		,	N'floor_map_name'
		FROM #TABLE_DETAILS
		WHERE
			floor_map = N''
	END

	-- IF INVALID => RETURN ERROR
	IF EXISTS (SELECT 1 FROM @ERR_TBL)
	BEGIN 
		GOTO COMPLETE_QUERY
	END

	INSERT INTO #TABLE_INSERT
	SELECT 
		ROW_NUMBER() OVER(ORDER BY id) + @w_max_no
	,	floor_name
	,	floor_map
	,	floor_map_name
	,	seating_chart_typ
	FROM #TABLE_DETAILS
	WHERE
		floor_id = 0

	--START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		-- CHECK EXISTS DATA IN M5200, IF NOT EXISTS => INSERT, ELSE => UPDATE
		IF NOT EXISTS (SELECT 1 FROM M5200 WHERE company_cd = @P_company_cd AND del_datetime IS NULL)
		BEGIN 
			INSERT INTO M5200
			SELECT 
				@P_company_cd
			,	@w_organization_chart_use_typ
			,	@w_seating_chart_use_typ
			,	@w_search_function_use_typ
			,	@w_initial_display
			,	@w_emailaddress_display_kbn
			,	@w_company_mobile_display_kbn
			,	@w_extension_number_display_kbn
			,	@P_cre_user
			,	@P_cre_ip
			,	N'eM0200'
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
		ELSE 
		BEGIN 
			UPDATE M5200 SET
				organization_chart_use_typ				=	@w_organization_chart_use_typ
			,	seating_chart_use_typ					=	@w_seating_chart_use_typ
			,	search_function_use_typ					=	@w_search_function_use_typ
			,	initial_display							=	@w_initial_display
			,	emailaddress_display_kbn				=	@w_emailaddress_display_kbn
			,	company_mobile_display_kbn				=	@w_company_mobile_display_kbn
			,	extension_number_display_kbn			=	@w_extension_number_display_kbn
			,	upd_user								=	@P_cre_user
			,	upd_ip									=	@P_cre_ip
			,	upd_prg									=	N'eM0200'
			,	upd_datetime							=	@w_time
			WHERE
				company_cd = @P_company_cd 
			AND del_datetime IS NULL
		END

		--M5201
		--DELETE
		UPDATE M5201 SET
			M5201.del_user				=	@P_cre_user
		,	M5201.del_ip				=	@P_cre_ip
		,	M5201.del_prg				=	N'eM0200'
		,	M5201.del_datetime			=	@w_time
		FROM M5201
		LEFT OUTER JOIN #TABLE_DETAILS ON (
			M5201.company_cd			=	@P_company_cd
		AND	M5201.floor_id				=	#TABLE_DETAILS.floor_id
		)
		WHERE
			#TABLE_DETAILS.floor_id IS NULL
		AND M5201.del_datetime IS NULL
		AND M5201.company_cd = @P_company_cd
				
		--UPDATE
		UPDATE M5201 SET	
			M5201.floor_name			=	#TABLE_DETAILS.floor_name
		,	M5201.floor_map				=	#TABLE_DETAILS.floor_map
		,	M5201.floor_map_name		=	CASE 
												WHEN #TABLE_DETAILS.floor_map_name <> N''
												THEN #TABLE_DETAILS.floor_map_name
												WHEN #TABLE_DETAILS.floor_map_name = N''
												THEN M5201.floor_map_name
											END
		,	M5201.seating_chart_typ		=	#TABLE_DETAILS.seating_chart_typ
		,	M5201.upd_user				=	@P_cre_user
		,	M5201.upd_ip				=	@P_cre_ip
		,	M5201.upd_prg				=	N'eM0200'
		,	M5201.upd_datetime			=	@w_time
		FROM #TABLE_DETAILS
		INNER JOIN M5201 ON (
			@P_company_cd				=	M5201.company_cd
		AND #TABLE_DETAILS.floor_id		=	M5201.floor_id
		)
		WHERE
			M5201.company_cd = @P_company_cd

		--INSERT
		INSERT INTO M5201
		SELECT
			@P_company_cd
		,	floor_id
		,	floor_name
		,	floor_map
		,	floor_map_name
		,	seating_chart_typ
		,	@P_cre_user
		,	@P_cre_ip
		,	N'eM0200'
		,	@w_time
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	NULL
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	NULL
		FROM #TABLE_INSERT
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
