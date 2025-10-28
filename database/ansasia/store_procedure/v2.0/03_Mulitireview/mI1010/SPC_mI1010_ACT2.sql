IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_mI1010_ACT2]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_mI1010_ACT2]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：mI1010 - SAVE POPUP
 *
 *  作成日  ：2020-12-25
 *  作成者  ：ANS-ASIA DUONGNTT
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_mI1010_ACT2] 
	@P_company_cd		SMALLINT		= 0
,	@P_cre_user			NVARCHAR(50)	= ''
,	@P_cre_ip			NVARCHAR(50)	= ''
,	@P_json				NVARCHAR(MAX)	= ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2	 = SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@w_browsing_position	SMALLINT	 = 0

	--
	IF ISJSON(@P_json) <= 0
	BEGIN
		INSERT INTO @ERR_TBL VALUES(		
			22								-- mã lỗi (trùng với mã trong bảng message) 					
		,	''								-- id hoặc class của item(#id , .class), lỗi dạng dialog thì để trống  				
		,	0-- oderby						-- giá trị càng bé thì lỗi được hiển thị trước  				
		,	1-- dialog  					-- Kiểu hiển thị lối : 0. tooltip , 1.dialog 				
		,	0								-- Tùy ý : có thể lưu vị trí index của dòng của lỗi 				
		,	0								-- Tùy ý
		,	'json format'					-- Comment nội dung lỗi (chủ yếu là dùng khi đọc code)
		)
	END

	--
	CREATE TABLE #TBL_JSON(
		id								INT IDENTITY(1,1)
	,	browsing_kbn					SMALLINT
	,	position_cd						INT			
	)

	--
	CREATE TABLE #M3000(
		browsing_all_y_kbn				SMALLINT
	,	browsing_all_n_kbn				SMALLINT
	,	browsing_position_kbn			SMALLINT
	)

	--
	CREATE TABLE #M3001(
		browsing_position_cd			INT
	--
	,	flg_mode						INT		--0:INSERT, 1:UPDATE
	,	cre_user						NVARCHAR(50)
	,	cre_ip							NVARCHAR(50)
	,	cre_prg							NVARCHAR(20)
	,	cre_datetime					DATETIME
	)

	--
	INSERT INTO #TBL_JSON
	SELECT 
		browsing_kbn	
	,	position_cd	
	FROM OPENJSON(@P_json,'$.list_browsing') WITH(
		browsing_kbn		SMALLINT
	,	position_cd			INT
	)

	--
	IF NOT EXISTS (SELECT 1 FROM #TBL_JSON WHERE #TBL_JSON.browsing_kbn = 1)
	BEGIN
		INSERT INTO @ERR_TBL VALUES(		
			126								
		,	''										
		,	0-- oderby						
		,	1-- dialog  					
		,	0								
		,	0								
		,	'no row detail is checked'		
		)
	END

	--
	IF EXISTS (SELECT 1 FROM #TBL_JSON WHERE #TBL_JSON.browsing_kbn = 1 AND #TBL_JSON.id = 1)
	BEGIN
		INSERT INTO #M3000
		SELECT 
			1	
		,	0	
		,	0
	END
	--
	IF EXISTS (SELECT 1 FROM #TBL_JSON WHERE #TBL_JSON.browsing_kbn = 1 AND #TBL_JSON.id = 2)
	BEGIN
		INSERT INTO #M3000
		SELECT 
			0	
		,	1	
		,	0
	END
	--
	IF EXISTS (SELECT 1 FROM #TBL_JSON WHERE #TBL_JSON.browsing_kbn = 1 AND #TBL_JSON.id = 3)
	BEGIN
		INSERT INTO #M3000
		SELECT 
			0	
		,	0	
		,	1
	END

	--
	INSERT INTO #M3001
	SELECT
		#TBL_JSON.position_cd
	,	0
	,	NULL	
	,	NULL	
	,	NULL	
	,	NULL
	FROM #TBL_JSON
	WHERE 
		#TBL_JSON.browsing_kbn = 1
	AND #TBL_JSON.id > 3

	--
	BEGIN TRANSACTION
	BEGIN TRY
		--
		IF NOT EXISTS (SELECT 1 FROM @ERR_TBL)
		BEGIN
			IF EXISTS(SELECT 1  
						FROM M3000
						INNER JOIN #M3000 ON(
							M3000.company_cd		=	@P_company_cd
						AND M3000.del_datetime	IS NULL
					))
			BEGIN
				UPDATE M3000
				SET 
					browsing_all_y_kbn		=	#M3000.browsing_all_y_kbn		
				,	browsing_all_n_kbn		=	#M3000.browsing_all_n_kbn		
				,	browsing_position_kbn	=	#M3000.browsing_position_kbn	
				,	upd_user				=	@P_cre_user
				,	upd_ip					=	@P_cre_ip
				,	upd_prg					=	'MI1010 '
				,	upd_datetime			=	@w_time
				FROM M3000 
				INNER JOIN #M3000 ON(
					M3000.company_cd		=	@P_company_cd
				AND M3000.del_datetime	IS NULL
				)
			END

			--INSERT M3000
			INSERT INTO M3000
			SELECT 
				@P_company_cd
			,	#M3000.browsing_all_y_kbn	
			,	#M3000.browsing_all_n_kbn	
			,	#M3000.browsing_position_kbn
			,	@P_cre_user
			,	@P_cre_ip
			,	'MI1010 '
			,	@w_time
			,	''
			,	''
			,	''
			,	NULL
			,	''
			,	''
			,	''
			,	NULL
			FROM #M3000
			LEFT JOIN M3000 ON (
				M3000.company_cd		=	@P_company_cd
			AND M3000.del_datetime IS NULL
			)
			WHERE 
				M3000.company_cd IS NULL
		
			SET @w_browsing_position = (SELECT TOP 1 #M3000.browsing_position_kbn FROM #M3000)

			--M3001
			IF (@w_browsing_position = 0)
			BEGIN
				--
				DELETE FROM M3001
				WHERE 
					M3001.company_cd			=	@P_company_cd
			END
			ELSE
			BEGIN
				IF EXISTS(SELECT 1 FROM #M3001)
				BEGIN
					IF EXISTS(SELECT 1  
								FROM M3001
								INNER JOIN #M3001 ON(
									M3001.company_cd			=	@P_company_cd
								AND M3001.browsing_position_cd	=	#M3001.browsing_position_cd
								AND M3001.del_datetime	IS NULL
							))
					BEGIN
						UPDATE #M3001
						SET
							flg_mode					=	1
						,	cre_user					=	M3001.cre_user		
						,	cre_ip						=	M3001.cre_ip			
						,	cre_prg						=	M3001.cre_prg			
						,	cre_datetime				=	M3001.cre_datetime
						FROM #M3001
						LEFT JOIN M3001 ON (
							M3001.company_cd			=	@P_company_cd
						AND #M3001.browsing_position_cd	=	M3001.browsing_position_cd
						AND M3001.del_datetime IS NULL
						)
						WHERE 
							M3001.browsing_position_cd IS NOT NULL
					END
		
					--
					DELETE FROM M3001
					WHERE 
						M3001.company_cd			=	@P_company_cd

					--INSERT M3001
					INSERT INTO M3001
					SELECT 
						@P_company_cd
					,	#M3001.browsing_position_cd	
					,	IIF(#M3001.flg_mode = 0,@P_cre_user,#M3001.cre_user)
					,	IIF(#M3001.flg_mode = 0,@P_cre_ip,#M3001.cre_ip)
					,	IIF(#M3001.flg_mode = 0,'MI1010 ',#M3001.cre_prg)
					,	IIF(#M3001.flg_mode = 0,@w_time,#M3001.cre_datetime)
					,	IIF(#M3001.flg_mode = 0,SPACE(0),@P_cre_user)
					,	IIF(#M3001.flg_mode = 0,SPACE(0),@P_cre_ip)
					,	IIF(#M3001.flg_mode = 0,SPACE(0),'MI1010 ')
					,	IIF(#M3001.flg_mode = 0,NULL,@w_time)
					,	SPACE(0)
					,	SPACE(0)
					,	SPACE(0)
					,	NULL
					FROM #M3001
				--
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
