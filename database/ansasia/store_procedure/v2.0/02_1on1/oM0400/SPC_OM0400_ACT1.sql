DROP PROCEDURE [SPC_OM0400_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：OM0400 - SAVE/UPDATE
 *
 *  作成日  ：2020-10-27
 *  作成者  ：ANS-ASIA nghianm
 *
 *  更新日  ：2021/05/14
 *  更新者  ：VIETDT
 *  更新内容：CR guideline point varchar(10) ->varchar(20)
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_OM0400_ACT1] 
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
	,	@order_by_min			INT					= 0
	,	@ERR_TBL				ERRTABLE	
	,	@refer_kbn				TINYINT			=	0
	,	@refer_questionnaire_cd	SMALLINT		=	0
	,	@questionnaire_cd_max	SMALLINT		=	0
	,	@questionnaire_cd		SMALLINT		=	0
	,	@questionnaire_nm		NVARCHAR(50)	=	''
	,	@submit					TINYINT			=	0
	,	@comment_use_typ		SMALLINT		=	0
	,	@purpose				NVARCHAR(200)	=	''
	,	@purpose_use_typ		TINYINT			=	0
	,	@complement				NVARCHAR(200)	=	''
	,	@complement_use_typ		TINYINT			=	0
	,	@company_cd_refer		SMALLINT		=	0
	,	@mode					TINYINT			=	0


	--
	CREATE TABLE #M2401(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	questionnaire_gyono		SMALLINT
	,	question				NVARCHAR(200)	
	,	question_typ			TINYINT
	,	sentence_use_typ		TINYINT
	,	points_use_typ			TINYINT
	,	guideline_10point		NVARCHAR(20)	
	,	guideline_5point		NVARCHAR(20)	
	,	guideline_0point		NVARCHAR(20)
	
	)
	--
	CREATE TABLE #HISTORY_M2401 (
		company_cd				SMALLINT
	,	questionnaire_cd		SMALLINT
	,	questionnaire_gyono		SMALLINT
	,	question				NVARCHAR(200)
	,	question_typ			TINYINT
	,	sentence_use_typ		TINYINT
	,	points_use_typ			TINYINT
	,	guideline_10point		NVARCHAR(20)
	,	guideline_5point		NVARCHAR(20)
	,	guideline_0point		NVARCHAR(20)
	,	arrange_order			INT
	,	cre_user				NVARCHAR(50)
	,	cre_ip					NVARCHAR(50)
	,	cre_prg					NVARCHAR(20)
	,	cre_datetime			DATETIME
	,	upd_user				NVARCHAR(50)
	,	upd_ip					NVARCHAR(50)
	,	upd_prg					NVARCHAR(20)
	,	upd_datetime			DATETIME
	,	del_user				NVARCHAR(50)
	,	del_ip					NVARCHAR(50)
	,	del_prg					NVARCHAR(20)
	,	del_datetime			DATETIME
	)
	
	BEGIN TRANSACTION
	BEGIN TRY
		IF ISJSON(@P_json) <= 0
		BEGIN
			INSERT INTO @ERR_TBL VALUES(		
				22									-- ma l?i (trung v?i ma trong b?ng message) 					
			,	''									-- id ho?c class c?a item(#id , .class), l?i d?ng dialog thi ?? tr?ng  				
			,	0-- oderby							-- gia tr? cang be thi l?i ???c hi?n th? tr??c  				
			,	1-- dialog  						-- Ki?u hi?n th? l?i : 0. tooltip , 1.dialog 				
			,	0									-- Tuy y : co th? l?u v? tri index c?a dong c?a l?i 				
			,	0									-- Tuy y
			,	'json format'						-- Comment n?i dung l?i (ch? y?u la dung khi ??c code)
			)
		END

		SET @refer_kbn				=	ISNULL(JSON_VALUE(@P_json,'$.refer_kbn'),0)
		SET @refer_questionnaire_cd =	ISNULL(JSON_VALUE(@P_json,'$.refer_questionnaire_cd'),0)
		SET @questionnaire_cd		=	ISNULL(JSON_VALUE(@P_json,'$.questionnaire_cd'),0)
		SET @questionnaire_nm		=	ISNULL(JSON_VALUE(@P_json,'$.questionnaire_nm'),'')
		SET @submit					=	ISNULL(JSON_VALUE(@P_json,'$.submit'),0)
		SET @comment_use_typ		=	ISNULL(JSON_VALUE(@P_json,'$.comment_use_typ'),0)
		SET @purpose				=	ISNULL(JSON_VALUE(@P_json,'$.purpose'),'')
		SET @purpose_use_typ		=	ISNULL(JSON_VALUE(@P_json,'$.purpose_use_typ'),0)
		SET @complement				=	ISNULL(JSON_VALUE(@P_json,'$.complement'),'')
		SET @complement_use_typ		=	ISNULL(JSON_VALUE(@P_json,'$.complement_use_typ'),0)
		SET @company_cd_refer		=	ISNULL(JSON_VALUE(@P_json,'$.company_cd_refer'),-1)
		SET @mode					=	ISNULL(JSON_VALUE(@P_json,'$.mode'),0)

		--
		IF(@P_company_cd <> 0 AND @company_cd_refer = 0)
		BEGIN
			SET @refer_kbn = 1
		END
		IF(@P_company_cd = 0 )
		BEGIN
			SET @refer_kbn = 1
		END
		SET @questionnaire_cd_max = ISNULL((SELECT MAX(questionnaire_cd) 
											 FROM M2400 
											 WHERE M2400.company_cd  = @P_company_cd ),0) + 1
		--
		INSERT INTO #M2401
		SELECT 
			@P_company_cd
		,	questionnaire_gyono
		,	question
		,	question_typ
		,	sentence_use_typ
		,	points_use_typ
		,	guideline_10point
		,	guideline_5point
		,	guideline_0point
		FROM OPENJSON(@P_json, '$.browsing_setting') WITH(
			questionnaire_gyono		SMALLINT
		,	question				NVARCHAR(200)
		,	question_typ			TINYINT
		,	sentence_use_typ		TINYINT
		,	points_use_typ			TINYINT	
		,	guideline_10point		NVARCHAR(20)
		,	guideline_5point		NVARCHAR(20)
		,	guideline_0point		NVARCHAR(20)
		)
		
		--
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			IF @mode = 0	-- insert
			BEGIN
			IF(@P_company_cd <> 0 AND @company_cd_refer = 0)	--company_cd_refer : company_cd of each questiontion_nm
			BEGIN
				--INSERT INTO #DOUBLE_KEY
				--INSERT M20400
				IF EXISTS (SELECT 1 FROM M2400 WHERE M2400.company_cd = @P_company_cd 
													AND M2400.refer_kbn = 1 
													AND M2400.refer_questionnaire_cd = @refer_questionnaire_cd
													AND M2400.questionnaire_cd	= @questionnaire_cd)
				BEGIN
					UPDATE M2400
					SET M2400.questionnaire_nm	= @questionnaire_nm
					,	M2400.submit			= @submit
					,	M2400.comment_use_typ	= @comment_use_typ
					,	M2400.purpose			= @purpose
					,	M2400.purpose_use_typ	= @purpose_use_typ
					,	M2400.complement		= @complement
					,	M2400.complement_use_typ= complement_use_typ
					,	M2400.cre_user			= @P_cre_user
					,	M2400.cre_ip			= @P_cre_ip
					,	M2400.cre_prg			= 'oM0400'
					,	M2400.cre_datetime		= @w_time
					,	M2400.upd_user			= space(0)
					,	M2400.upd_prg			= space(0)
					,	M2400.upd_datetime		= NULL
					,	M2400.del_user			= space(0)
					,	M2400.del_ip			= space(0)
					,	M2400.del_prg			= space(0)
					,	M2400.del_datetime		= NULL
					WHERE M2400.company_cd = @P_company_cd 
					AND M2400.refer_kbn = 1 
					--AND M2400.refer_questionnaire_cd = @refer_questionnaire_cd
					AND M2400.questionnaire_cd = @questionnaire_cd

					DELETE FROM M2401 WHERE M2401.company_cd = @P_company_cd  AND questionnaire_cd = @questionnaire_cd

					INSERT INTO M2401
					SELECT
						@P_company_cd
					,	@questionnaire_cd
					,	#M2401.questionnaire_gyono
					,	CASE
							WHEN #M2401.question_typ = 0
							THEN 2
							ELSE #M2401.question_typ
						END
					,	#M2401.question
					,	#M2401.sentence_use_typ
					,	#M2401.points_use_typ
					,	#M2401.guideline_10point
					,	#M2401.guideline_5point
					,	#M2401.guideline_0point
					,	0
					,	@P_cre_user
					,	@P_cre_ip
					,	'oM0400'
					,	@w_time
					,	space(0)
					,	space(0)
					,	space(0)
					,	NULL
					,	space(0)
					,	space(0)
					,	space(0)
					,	NULL
					FROM #M2401 
					--

				END
				ELSE
				BEGIN
					INSERT INTO M2400
					SELECT
						@P_company_cd
					,	@questionnaire_cd_max
					,	1
					,	@questionnaire_cd
					,	@questionnaire_nm
					,	@submit
					,	@comment_use_typ
					,	@purpose
					,	@purpose_use_typ
					,	@complement
					,	@complement_use_typ
					,	0
					,	@P_cre_user
					,	@P_cre_ip
					,	'oM0400'
					,	@w_time
					,	space(0)
					,	space(0)
					,	space(0)
					,	NULL
					,	space(0)
					,	space(0)
					,	space(0)
					,	NULL
					--
					--INSERT M2401
					INSERT INTO M2401
					SELECT
						@P_company_cd
					,	@questionnaire_cd_max
					,	questionnaire_gyono
					,	CASE
							WHEN #M2401.question_typ = 0
							THEN 2
							ELSE #M2401.question_typ
						END
					,	question
					,	sentence_use_typ
					,	points_use_typ
					,	CASE
							WHEN points_use_typ = 2
							THEN space(0)
							ELSE guideline_10point
						END
					,	CASE
							WHEN points_use_typ = 2
							THEN space(0)
							ELSE guideline_5point
						END
					,	CASE
							WHEN points_use_typ = 2
							THEN space(0)
							ELSE guideline_0point
						END
					,	0
					,	@P_cre_user
					,	@P_cre_ip
					,	'oM0400'
					,	@w_time
					,	space(0)
					,	space(0)
					,	space(0)
					,	NULL
					,	space(0)
					,	space(0)
					,	space(0)
					,	NULL
					FROM #M2401
					--
				END
			END
			ELSE
			BEGIN
				SET @questionnaire_cd_max = ISNULL((SELECT MAX(questionnaire_cd) 
											 FROM M2400 
											 WHERE M2400.company_cd  = @P_company_cd 
											),0) + 1

				--INSERT M20400
				INSERT INTO M2400
				SELECT
					@P_company_cd
				,	@questionnaire_cd_max
				,	CASE
						WHEN @P_company_cd = 0
						THEN 1
						ELSE 2
					END
				,	0
				,	@questionnaire_nm
				,	@submit
				,	@comment_use_typ
				,	@purpose
				,	@purpose_use_typ
				,	@complement
				,	@complement_use_typ
				,	0
				,	@P_cre_user
				,	@P_cre_ip
				,	'oM0400'
				,	@w_time
				,	space(0)
				,	space(0)
				,	space(0)
				,	NULL
				,	space(0)
				,	space(0)
				,	space(0)
				,	NULL
				--
				
				--INSERT M2401
				INSERT INTO M2401
				SELECT
					@P_company_cd
				,	@questionnaire_cd_max
				,	questionnaire_gyono
				,	CASE
						WHEN @P_company_cd = 0
						THEN 1
						ELSE 2
					END
				,	question
				,	sentence_use_typ
				,	points_use_typ
				,	CASE
						WHEN points_use_typ = 2
						THEN space(0)
						ELSE guideline_10point
					END
				,	CASE
						WHEN points_use_typ = 2
						THEN space(0)
						ELSE guideline_5point
					END
				,	CASE
						WHEN points_use_typ = 2
						THEN space(0)
						ELSE guideline_0point
					END
				,	0
				,	@P_cre_user
				,	@P_cre_ip
				,	'oM0400'
				,	@w_time
				,	space(0)
				,	space(0)
				,	space(0)
				,	NULL
				,	space(0)
				,	space(0)
				,	space(0)
				,	NULL
				FROM #M2401
			--
			END
		END
		ELSE
		BEGIN	--update
			--UPDATE M2400
			UPDATE M2400
			SET
				M2400.questionnaire_nm			= @questionnaire_nm
			,	M2400.submit					= @submit
			,	M2400.comment_use_typ			= @comment_use_typ
			,	M2400.purpose					= @purpose
			,	M2400.purpose_use_typ			= @purpose_use_typ
			,	M2400.complement				= @complement
			,	M2400.complement_use_typ 		= @complement_use_typ
			,	M2400.upd_user					= @P_cre_user
			,	M2400.upd_ip					= @P_cre_ip
			,	M2400.upd_prg					= 'oM0400'
			,	M2400.upd_datetime				= @w_time
			WHERE M2400.company_cd				= @P_company_cd
			AND   M2400.refer_kbn				= @refer_kbn
			--AND	  M2400.refer_questionnaire_cd	= @refer_questionnaire_cd
			AND	  M2400.questionnaire_cd		= @questionnaire_cd
			--
			--UPDATE M2401
			INSERT INTO #HISTORY_M2401
			SELECT 
				M2401.company_cd
			,	M2401.questionnaire_cd
			,	M2401.questionnaire_gyono
			,	M2401.question
			,	M2401.question_typ
			,	M2401.sentence_use_typ
			,	M2401.points_use_typ
			,	M2401.guideline_10point
			,	M2401.guideline_5point
			,	M2401.guideline_0point
			,	M2401.arrange_order
			,	M2401.cre_user
			,	M2401.cre_ip
			,	M2401.cre_prg
			,	M2401.cre_datetime
			,	M2401.upd_user
			,	M2401.upd_ip
			,	M2401.upd_prg
			,	M2401.upd_datetime
			,	M2401.del_user
			,	M2401.del_ip
			,	M2401.del_prg
			,	M2401.del_datetime
			FROM M2401
			WHERE	M2401.company_cd		= @P_company_cd 
			AND		M2401.questionnaire_cd	= @questionnaire_cd
			AND		M2401.del_datetime IS NULL
			--DELETE M2401
			DELETE FROM M2401 WHERE M2401.company_cd = @P_company_cd AND M2401.questionnaire_cd = @questionnaire_cd 
			--INSERT INTO M2401
			INSERT INTO M2401
			SELECT 
				#M2401.company_cd
			,	@questionnaire_cd
			,	#M2401.questionnaire_gyono
			,	#M2401.question_typ
			,	#M2401.question
			,	#M2401.sentence_use_typ
			,	#M2401.points_use_typ
			,	CASE
					WHEN #M2401.points_use_typ = 2
					THEN space(0)
					ELSE #M2401.guideline_10point
				END
			,	CASE
					WHEN #M2401.points_use_typ = 2
					THEN space(0)
					ELSE #M2401.guideline_5point
				END
			,	CASE
					WHEN #M2401.points_use_typ = 2
					THEN space(0)
					ELSE #M2401.guideline_0point
				END
			,	0
			,	@P_cre_user
			,	@P_cre_ip
			,	'oM0400'
			,	@w_time
			,	space(0)
			,	space(0)
			,	space(0)
			,	NULL
			,	space(0)
			,	space(0)
			,	space(0)
			,	NULL
			FROM #M2401
			--UPDATE M2401 (del+add)
			UPDATE M2401 SET
				cre_user		= CASE WHEN #HISTORY_M2401.del_datetime IS NOT NULL
								THEN @P_cre_user
								ELSE
									#HISTORY_M2401.cre_user
								END
			,	cre_ip			= CASE WHEN #HISTORY_M2401.del_datetime IS NOT NULL
								THEN @P_cre_ip
								ELSE
									#HISTORY_M2401.cre_ip
								END
			,	cre_datetime	= CASE WHEN #HISTORY_M2401.del_datetime IS NOT NULL
								THEN @w_time
								ELSE
									#HISTORY_M2401.cre_datetime
								END
			,	upd_prg			= CASE WHEN #HISTORY_M2401.del_datetime IS NOT NULL
								THEN SPACE(0)
								ELSE
									'oM0400'
								END
			,	upd_user		= CASE WHEN #HISTORY_M2401.del_datetime IS NOT NULL
								THEN SPACE(0)
								ELSE
									@P_cre_user
								END
			,	upd_ip			= CASE WHEN #HISTORY_M2401.del_datetime IS NOT NULL
								THEN SPACE(0)
								ELSE
									@P_cre_ip
								END
			,	upd_datetime	= CASE WHEN #HISTORY_M2401.del_datetime IS NOT NULL
								THEN NULL
								ELSE
									@w_time
								END
			FROM M2401
			INNER JOIN #HISTORY_M2401 ON(
				M2401.company_cd			=	#HISTORY_M2401.company_cd
			AND M2401.questionnaire_cd		=	#HISTORY_M2401.questionnaire_cd
			AND M2401.questionnaire_gyono	=	#HISTORY_M2401.questionnaire_gyono
			)
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
	WHERE order_by = @order_by_min
	ORDER BY 
		order_by
END

GO
