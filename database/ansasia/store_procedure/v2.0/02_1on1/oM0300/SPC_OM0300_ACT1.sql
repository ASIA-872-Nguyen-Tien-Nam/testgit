IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_OM0300_ACT1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_OM0300_ACT1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：OM0300 - SAVE/UPDATE
 *
 *  作成日  ：2020-10-06
 *  作成者  ：ANS-ASIA nghianm
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_OM0300_ACT1] 
	@P_json			NVARCHAR(MAX)
	--
,	@P_cre_user		NVARCHAR(50) = ''
,	@P_cre_ip		NVARCHAR(50) = ''
,	@P_company_cd	SMALLINT	 = 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2	 = SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@1on1_group_cd			SMALLINT
	,	@1on1_group_nm			NVARCHAR(20)
	,	@1on1_group_cd_max		SMALLINT
	,	@mode					SMALLINT


	--
	CREATE TABLE #M02601(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	attribute				SMALLINT
	,	code					SMALLINT
	)
	--
	SET @1on1_group_cd			=	ISNULL(JSON_VALUE(@P_json,'$.group_cd'),0)
	SET @1on1_group_nm			=	ISNULL(JSON_VALUE(@P_json,'$.group_nm'),'')
	SET @mode					=	ISNULL(JSON_VALUE(@P_json,'$.mode'),0)	--0:insert , 1:update
	--
	INSERT INTO #M02601
	SELECT 
		@P_company_cd
	,	2
	,	code
	FROM OPENJSON (@P_json,'$.list_m0030') WITH(
		code	SMALLINT
	)AS json_table
	UNION ALL
	SELECT 
		@P_company_cd
	,	1
	,	code
	FROM OPENJSON (@P_json,'$.list_m0040') WITH(
		code	SMALLINT
	)AS json_table
	UNION ALL 
	SELECT 
		@P_company_cd
	,	3
	,	code
	FROM OPENJSON (@P_json,'$.list_m0050') WITH(
		code	SMALLINT
	)AS json_table
	UNION ALL 
	SELECT 
		@P_company_cd
	,	4
	,	code
	FROM OPENJSON (@P_json,'$.list_m0060') WITH(
		code	SMALLINT
	)AS json_table
	--
	SET @1on1_group_cd_max = ISNULL((SELECT MAX([1on1_group_cd]) 
										 FROM M2600 
										 WHERE M2600.company_cd  = @P_company_cd),0) + 1


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
		IF(@mode = 0)
		BEGIN
			--INSERT INTO M2600
			INSERT INTO M2600
			SELECT 
				@P_company_cd
			,	@1on1_group_cd_max
			,	@1on1_group_nm
			,	@1on1_group_cd_max
			,	@P_cre_user
			,	@P_cre_ip
			,	'oM0300'
			,	@w_time
			,	''
			,	''
			,	''
			,	NULL
			,	''
			,	''
			,	''
			,	NULL
			--INSERT INTO M2601
			INSERT INTO M2601
			SELECT 
				#M02601.company_cd
			,	@1on1_group_cd_max
			,	#M02601.attribute
			,	RANK() OVER (PARTITION BY company_cd,attribute
								ORDER BY code 
								)
			,	#M02601.code
			,	0
				,	@P_cre_user
			,	@P_cre_ip
			,	'oM0300'
			,	@w_time
			,	''
			,	''
			,	''
			,	NULL
			,	''
			,	''
			,	''
			,	NULL
			FROM #M02601
		END
		ELSE
		BEGIN
			--UPDATE M2600
			UPDATE M2600
			SET
				[1on1_group_nm] = @1on1_group_nm
			,	upd_user		= @P_cre_user
			,	upd_ip			= @P_cre_ip
			,	upd_prg			= 'oM0300'
			,	upd_datetime	= @w_time
			FROM M2600
			WHERE M2600.company_cd		= @P_company_cd
			AND   M2600.[1on1_group_cd] = @1on1_group_cd

			--UPDATE M2601
			DELETE FROM M2601 WHERE  M2601.company_cd = @P_company_cd AND M2601.[1on1_group_cd] = @1on1_group_cd
			INSERT INTO M2601
			SELECT 
				#M02601.company_cd
			,	@1on1_group_cd
			,	#M02601.attribute
			,	RANK() OVER (PARTITION BY company_cd,attribute
								ORDER BY code 
								)
			,	#M02601.code
			,	0
				,	@P_cre_user
			,	@P_cre_ip
			,	'oM0300'
			,	@w_time
			,	''
			,	''
			,	''
			,	NULL
			,	''
			,	''
			,	''
			,	NULL
			FROM #M02601
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
