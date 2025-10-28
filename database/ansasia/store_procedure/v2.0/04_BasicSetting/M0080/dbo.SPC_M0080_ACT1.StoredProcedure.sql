DROP PROCEDURE [SPC_M0080_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：M0080 - SAVE/UPDATE
 *
 *  作成日  ：2020-09-25
 *  作成者  ：ANS-ASIA nghianm
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_M0080_ACT1] 
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
	,	@item_cd				SMALLINT
	,	@item_nm				NVARCHAR(20)
	,	@arrange_order			INT
	,	@item_kind				SMALLINT
	,	@item_digits			SMALLINT
	,	@rater_browsing_kbn		SMALLINT
	,	@item_display_kbn		SMALLINT
	,	@search_item_kbn		SMALLINT
	,	@item_cd_max			SMALLINT
	,	@mode					SMALLINT
	,	@check_data				SMALLINT

	--
	CREATE TABLE #M0082(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	item_cd					SMALLINT
	,	authority_cd			SMALLINT
	,	chk						SMALLINT	
	)
	--
	CREATE TABLE #M0081(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	item_cd					SMALLINT
	,	detail_no				SMALLINT	
	,	detail_nm				NVARCHAR(50)
	)
	--
	CREATE TABLE #HISTORY_M0081 (
		company_cd		SMALLINT
	,	item_cd			SMALLINT
	,	detail_no		SMALLINT
	,	detail_name		NVARCHAR(50)
	,	cre_user		NVARCHAR(50)
	,	cre_ip			NVARCHAR(50)
	,	cre_prg			NVARCHAR(20)
	,	cre_datetime	DATETIME
	,	upd_user		NVARCHAR(50)
	,	upd_ip			NVARCHAR(50)
	,	upd_prg			NVARCHAR(20)
	,	upd_datetime	DATETIME
	,	del_user		NVARCHAR(50)
	,	del_ip			NVARCHAR(50)
	,	del_prg			NVARCHAR(20)
	,	del_datetime	DATETIME
	)
	--
	CREATE TABLE #HISTORY_M0082 (
		company_cd		SMALLINT
	,	item_cd			SMALLINT
	,	authority_cd	SMALLINT
	,	browsing_kbn	SMALLINT
	,	cre_user		NVARCHAR(50)
	,	cre_ip			NVARCHAR(50)
	,	cre_prg			NVARCHAR(20)
	,	cre_datetime	DATETIME
	,	upd_user		NVARCHAR(50)
	,	upd_ip			NVARCHAR(50)
	,	upd_prg			NVARCHAR(20)
	,	upd_datetime	DATETIME
	,	del_user		NVARCHAR(50)
	,	del_ip			NVARCHAR(50)
	,	del_prg			NVARCHAR(20)
	,	del_datetime	DATETIME
	)
	--
	CREATE TABLE #ERROR_M0081 (
		company_cd		SMALLINT
	,	item_cd			SMALLINT
	,	detail_no		SMALLINT
	)
	--
	SET @item_cd				=	ISNULL(JSON_VALUE(@P_json,'$.item_cd'),0)
	SET @item_nm				=	ISNULL(JSON_VALUE(@P_json,'$.item_nm'),'')
	SET @arrange_order			=	ISNULL(JSON_VALUE(@P_json,'$.arrange_order'),0)
	SET @item_kind				=	ISNULL(JSON_VALUE(@P_json,'$.item_kind'),0)
	SET @item_digits			=	ISNULL(JSON_VALUE(@P_json,'$.item_digits'),0)
	SET @rater_browsing_kbn		=	ISNULL(JSON_VALUE(@P_json,'$.rater_browsing_kbn'),0)
	SET @item_display_kbn		=	ISNULL(JSON_VALUE(@P_json,'$.item_display_kbn'),0)
	SET @search_item_kbn		=	ISNULL(JSON_VALUE(@P_json,'$.search_item_kbn'),0)
	SET @mode					=	ISNULL(JSON_VALUE(@P_json,'$.mode'),0)

	SET @item_cd_max = ISNULL((SELECT MAX(item_cd) 
										 FROM M0080 
										 WHERE M0080.company_cd  = @P_company_cd),0) + 1
	--

	--
	IF(@item_kind = 4 OR @item_kind = 5)
	BEGIN
		IF @mode = 1
		BEGIN
			INSERT INTO #M0081
			SELECT 
				@P_company_cd
			,	@item_cd
			,	detail_no
			,	detail_nm
			FROM OPENJSON(@P_json, '$.choice_field') WITH(
				detail_no		SMALLINT
			,	detail_nm		NVARCHAR(50)	
			)
		END
		ELSE
		BEGIN
			INSERT INTO #M0081
			SELECT 
				@P_company_cd
			,	@item_cd_max
			,	detail_no
			,	detail_nm
			FROM OPENJSON(@P_json, '$.choice_field') WITH(
				detail_no		SMALLINT
			,	detail_nm		NVARCHAR(50)	
			)
		END
	END
	--INSERT INTO #ERROR_M0081
	INSERT INTO #ERROR_M0081
	SELECT 
		company_cd
	,	item_cd
	,	detail_no
	FROM #M0081 
	GROUP BY #M0081.detail_no,company_cd,item_cd HAVING COUNT(detail_no) > 1 


	BEGIN TRANSACTION
	BEGIN TRY
		--INSERT INTO @ERR_TBL
		INSERT INTO @ERR_TBL 
		SELECT 
			32
		,	'.detail_no'
		,	0
		,	3
		,	#M0081.id
		,	#M0081.id
		,	'32_明細が重複しています'
		FROM #ERROR_M0081
		LEFT JOIN #M0081 ON (
			#ERROR_M0081.company_cd = #M0081.company_cd
		AND #ERROR_M0081.item_cd	= #M0081.item_cd
		AND #ERROR_M0081.detail_no  = #M0081.detail_no
		)
		--
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			IF NOT EXISTS (SELECT 1 
							FROM M0080
							WHERE M0080.company_cd = @P_company_cd
							AND M0080.item_cd	= @item_cd
							AND M0080.del_datetime IS NULL
							)
			BEGIN
				--INSERT #M0082
					INSERT INTO #M0082
					SELECT
						@P_company_cd
					,	@item_cd_max
					,	authority_cd
					,	chk
					FROM OPENJSON(@P_json, '$.browsing_setting') WITH(
						authority_cd	SMALLINT	
					,	chk				SMALLINT
					)
				--INSERT M0080
				INSERT INTO M0080 
				SELECT 
					@P_company_cd
				,	@item_cd_max
				,	@item_nm
				,	@item_kind
				,	@item_digits
				,	@item_display_kbn
				,	@search_item_kbn
				,	@rater_browsing_kbn
				,	@arrange_order
				,	@P_cre_user
				,	@P_cre_ip
				,	'M0080'
				,	@w_time
				,	''
				,	''
				,	''
				,	NULL
				,	''
				,	''
				,	''
				,	NULL
			
			END
			ELSE
			BEGIN
				--INSERT #M0082
					INSERT INTO #M0082
					SELECT
						@P_company_cd
					,	@item_cd
					,	authority_cd
					,	chk
					FROM OPENJSON(@P_json, '$.browsing_setting') WITH(
						authority_cd	SMALLINT	
					,	chk				SMALLINT
					)
				UPDATE M0080
				SET M0080.company_cd			=	@P_company_cd
				,	M0080.item_nm				=	@item_nm
				,	M0080.item_kind				=	@item_kind
				,	M0080.item_digits			=	@item_digits
				,	M0080.item_display_kbn		=	@item_display_kbn
				,	M0080.search_item_kbn		=	@search_item_kbn
				,	M0080.rater_browsing_kbn	=	@rater_browsing_kbn
				,	M0080.arrange_order			=	@arrange_order
				,	M0080.upd_prg				=	'M0080'
				,	M0080.upd_ip				=	@P_cre_ip
				,	M0080.upd_user				=	@P_cre_user
				,	M0080.upd_datetime			=	@w_time
				WHERE	M0080.company_cd = @P_company_cd
				AND		M0080.item_cd	 = @item_cd
			END
			--INSERT INTO #HISTORY_M0082
			INSERT INTO #HISTORY_M0082
			SELECT 
				M0082.company_cd
			,	M0082.item_cd
			,	M0082.authority_cd
			,	M0082.browsing_kbn
			,	M0082.cre_user
			,	M0082.cre_ip
			,	M0082.cre_prg
			,	M0082.cre_datetime
			,	M0082.upd_user
			,	M0082.upd_ip
			,	M0082.upd_prg
			,	M0082.upd_datetime
			,	M0082.del_user
			,	M0082.del_ip
			,	M0082.del_prg
			,	M0082.del_datetime
			FROM M0082
			WHERE M0082.company_cd = @P_company_cd 
			AND M0082.item_cd = @item_cd
			AND M0082.del_datetime IS NULL
			--DELETE M0081
			DELETE FROM M0082 WHERE M0082.company_cd = @P_company_cd AND M0082.item_cd = @item_cd
			--INSERT INTO M0082
			INSERT INTO M0082
			SELECT 
				#M0082.company_cd
			,	#M0082.item_cd
			,	#M0082.authority_cd
			,	#M0082.chk
			,	@P_cre_user
			,	@P_cre_ip
			,	'M0080'
			,	@w_time
			,	''
			,	''
			,	''
			,	NULL
			,	''
			,	''
			,	''
			,	NULL
			FROM #M0082
			UPDATE M0082 SET
				cre_user		= CASE WHEN #HISTORY_M0082.del_datetime IS NOT NULL
								THEN @P_cre_user
								ELSE
									#HISTORY_M0082.cre_user
								END
			,	cre_ip			= CASE WHEN #HISTORY_M0082.del_datetime IS NOT NULL
								THEN @P_cre_ip
								ELSE
									#HISTORY_M0082.cre_ip
								END
			,	cre_datetime	= CASE WHEN #HISTORY_M0082.del_datetime IS NOT NULL
								THEN @w_time
								ELSE
									#HISTORY_M0082.cre_datetime
								END
			,	upd_prg			= CASE WHEN #HISTORY_M0082.del_datetime IS NOT NULL
								THEN SPACE(0)
								ELSE
									'M0080'
								END
			,	upd_user		= CASE WHEN #HISTORY_M0082.del_datetime IS NOT NULL
								THEN SPACE(0)
								ELSE
									@P_cre_user
								END
			,	upd_ip			= CASE WHEN #HISTORY_M0082.del_datetime IS NOT NULL
								THEN SPACE(0)
								ELSE
									@P_cre_ip
								END
			,	upd_datetime	= CASE WHEN #HISTORY_M0082.del_datetime IS NOT NULL
								THEN NULL
								ELSE
									@w_time
								END
			FROM M0082
			INNER JOIN #HISTORY_M0082 ON(
				M0082.company_cd	=	#HISTORY_M0082.company_cd
			AND M0082.item_cd		=	#HISTORY_M0082.item_cd
			AND M0082.authority_cd	=	#HISTORY_M0082.authority_cd
			)
			------
			IF(@item_kind = 4 OR @item_kind = 5)
			BEGIN
				--INSERT #M0081
				IF @mode = 1
				BEGIN
					--INSERT INTO #HISTORY_M0081
					INSERT INTO #HISTORY_M0081
					SELECT 
						M0081.company_cd
					,	M0081.item_cd
					,	M0081.detail_no
					,	M0081.detail_name
					,	M0081.cre_user
					,	M0081.cre_ip
					,	M0081.cre_prg
					,	M0081.cre_datetime
					,	M0081.upd_user
					,	M0081.upd_ip
					,	M0081.upd_prg
					,	M0081.upd_datetime
					,	M0081.del_user
					,	M0081.del_ip
					,	M0081.del_prg
					,	M0081.del_datetime
					FROM M0081
					WHERE M0081.company_cd = @P_company_cd 
					AND M0081.item_cd = @item_cd
					AND M0081.del_datetime IS NULL
					--DELETE M0081
					DELETE FROM M0081 WHERE M0081.company_cd = @P_company_cd AND M0081.item_cd = @item_cd
					--INSERT INTO M0081
					INSERT INTO M0081
					SELECT 
						#M0081.company_cd
					,	#M0081.item_cd
					,	#M0081.detail_no
					,	#M0081.detail_nm
					,	@P_cre_user
					,	@P_cre_ip
					,	'M0080'
					,	@w_time
					,	''
					,	''
					,	''
					,	NULL
					,	''
					,	''
					,	''
					,	NULL
					FROM #M0081
					--UPDATE M0081 (del+add)
					UPDATE M0081 SET
					cre_user			= CASE WHEN #HISTORY_M0081.del_datetime IS NOT NULL
										THEN @P_cre_user
										ELSE
											#HISTORY_M0081.cre_user
										END
					,	cre_ip			= CASE WHEN #HISTORY_M0081.del_datetime IS NOT NULL
										THEN @P_cre_ip
										ELSE
											#HISTORY_M0081.cre_ip
										END
					,	cre_datetime	= CASE WHEN #HISTORY_M0081.del_datetime IS NOT NULL
										THEN @w_time
										ELSE
											#HISTORY_M0081.cre_datetime
										END
					,	upd_prg			= CASE WHEN #HISTORY_M0081.del_datetime IS NOT NULL
										THEN SPACE(0)
										ELSE
											'M0080'
										END
					,	upd_user		= CASE WHEN #HISTORY_M0081.del_datetime IS NOT NULL
										THEN SPACE(0)
										ELSE
											@P_cre_user
										END
					,	upd_ip			= CASE WHEN #HISTORY_M0081.del_datetime IS NOT NULL
										THEN SPACE(0)
										ELSE
											@P_cre_ip
										END
					,	upd_datetime	= CASE WHEN #HISTORY_M0081.del_datetime IS NOT NULL
										THEN NULL
										ELSE
											@w_time
										END
					FROM M0081
					INNER JOIN #HISTORY_M0081 ON(
						M0081.company_cd	=	#HISTORY_M0081.company_cd
					AND M0081.item_cd		=	#HISTORY_M0081.item_cd
					AND M0081.detail_no	=	#HISTORY_M0081.detail_no
					)
				
				END
				ELSE
				BEGIN
					--INSERT M0081
					INSERT INTO M0081
					SELECT 
						#M0081.company_cd
					,	#M0081.item_cd
					,	#M0081.detail_no
					,	#M0081.detail_nm
					,	@P_cre_user
					,	@P_cre_ip
					,	'M0080'
					,	@w_time
					,	''
					,	''
					,	''
					,	NULL
					,	''
					,	''
					,	''
					,	NULL
					FROM #M0081
				END
				----------
				
			END
			ELSE 
			BEGIN
				IF EXISTS (SELECT 1 FROM M0081 WHERE M0081.company_cd = @P_company_cd AND M0081.item_cd = @item_cd AND del_datetime IS NULL )
				DELETE FROM M0081
				WHERE M0081.company_cd  = @P_company_cd
				AND M0081.item_cd = @item_cd
			END
			-------------
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
