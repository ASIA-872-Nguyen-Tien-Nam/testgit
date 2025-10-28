IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_oQ2010_ACT1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_oQ2010_ACT1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：OI1020 - SAVE/UPDATE
 *
 *  作成日  ：2020-12-16
 *  作成者  ：ANS-ASIA DUONGNTT
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_oQ2010_ACT1] 
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
		id 					INT IDENTITY(1,1)
	,	item_cd				SMALLINT
	,	display_kbn			SMALLINT
	,	order_no			SMALLINT
	)

	--
	INSERT INTO #TBL_JSON
	SELECT 
		item_cd	
	,	display_kbn
	,	order_no	
	FROM OPENJSON(@P_json,'$.list_check_display') WITH(
			item_cd			SMALLINT
		,	display_kbn		SMALLINT
		,	order_no		SMALLINT
	)

	--
	IF NOT EXISTS (SELECT 1 FROM #TBL_JSON)
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
	BEGIN TRANSACTION
	BEGIN TRY
		--
		IF NOT EXISTS (SELECT 1 FROM @ERR_TBL)
		BEGIN
			--
			IF EXISTS(SELECT 1  
						FROM S2011
						INNER JOIN #TBL_JSON ON(
							S2011.company_cd		=	@P_company_cd
						AND S2011.[user_id]			=	@P_cre_user
						AND S2011.item_cd			=	#TBL_JSON.item_cd
						AND S2011.del_datetime	IS NULL
					))
			BEGIN
				UPDATE S2011
				SET 
					display_kbn				=	#TBL_JSON.display_kbn
				,	order_no				=	#TBL_JSON.id
				,	upd_user				=	@P_cre_user
				,	upd_ip					=	@P_cre_ip
				,	upd_prg					=	'oQ2010'
				,	upd_datetime			=	@w_time
				FROM S2011 
				INNER JOIN #TBL_JSON ON(
					S2011.company_cd		=	@P_company_cd
				AND S2011.[user_id]			=	@P_cre_user
				AND S2011.item_cd			=	#TBL_JSON.item_cd
				AND S2011.del_datetime	IS NULL
				)
			END

			--INSERT S2011
			INSERT INTO S2011
			SELECT 
				@P_company_cd
			,	@P_cre_user
			,	#TBL_JSON.item_cd
			,	#TBL_JSON.display_kbn
			,	#TBL_JSON.id
			,	@P_cre_user
			,	@P_cre_ip
			,	'oQ2010'
			,	@w_time
			,	''
			,	''
			,	''
			,	NULL
			,	''
			,	''
			,	''
			,	NULL
			FROM #TBL_JSON
			LEFT JOIN S2011 ON (
				S2011.company_cd		=	@P_company_cd
			AND S2011.[user_id]			=	@P_cre_user
			AND #TBL_JSON.item_cd		=	S2011.item_cd
			AND S2011.del_datetime IS NULL
			)
			WHERE 
				S2011.item_cd IS NULL
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
