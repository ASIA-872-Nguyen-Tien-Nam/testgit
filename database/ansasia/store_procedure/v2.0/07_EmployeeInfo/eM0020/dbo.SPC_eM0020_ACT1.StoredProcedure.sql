DROP PROCEDURE [dbo].[SPC_EM0020_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：em0020
 *
 *  作成日  ：2024/03
 *  作成者  ：TRINHDT
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_EM0020_ACT1] 
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

	--
	,	@work_history_kbn			SMALLINT		= 0


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
	,	item_id							SMALLINT
	,	item_title						NVARCHAR(50)	
	,	item_display_kbn				SMALLINT
	,	item_arrangement_column			SMALLINT
	,	item_arrangement_line			SMALLINT
	)

		
	--
	INSERT INTO #TBL_JSON
	SELECT 
		item_id					
	,	item_title				
	,	item_display_kbn		
	,	item_arrangement_column	
	,	item_arrangement_line	
	FROM OPENJSON(@P_json, '$.list_item') WITH(
		item_id							SMALLINT
	,	item_title						NVARCHAR(50)	
	,	item_display_kbn				SMALLINT
	,	item_arrangement_column			SMALLINT
	,	item_arrangement_line			SMALLINT
	)

	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY

		SET @work_history_kbn					=	JSON_VALUE(@P_json,'$.work_history_kbn')					

		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			--UPDATE M5020
			UPDATE M5020
			SET	
				item_id						=	#TBL_JSON.item_id
			,	item_title					=	#TBL_JSON.item_title
			,	item_display_kbn			=	#TBL_JSON.item_display_kbn		
			,	item_arrangement_column		=	#TBL_JSON.item_arrangement_column
			,	item_arrangement_line		=	#TBL_JSON.item_arrangement_line
			,	upd_user					=	@P_cre_user
			,	upd_ip						=	@P_cre_ip
			,	upd_prg						=	'eM0020'
			,	upd_datetime				=	@w_time
			FROM M5020
			INNER JOIN #TBL_JSON ON (
				M5020.company_cd		=	@P_company_cd
			AND M5020.work_history_kbn	=	@work_history_kbn
			AND M5020.item_id			=	#TBL_JSON.item_id
			AND M5020.del_datetime IS NULL
			)

			--UPDATE M5020
			UPDATE M5020
			SET	
				item_id						=	#TBL_JSON.item_id
			,	item_title					=	#TBL_JSON.item_title
			,	item_display_kbn			=	#TBL_JSON.item_display_kbn		
			,	item_arrangement_column		=	#TBL_JSON.item_arrangement_column
			,	item_arrangement_line		=	#TBL_JSON.item_arrangement_line
			,	cre_user					=	@P_cre_user
			,	cre_ip						=	@P_cre_ip
			,	cre_prg						=	'eM0020'
			,	cre_datetime				=	@w_time
			,	upd_user					=	SPACE(0)
			,	upd_ip						=	SPACE(0)
			,	upd_prg						=	SPACE(0)
			,	upd_datetime				=	NULL
			--
			,	del_user					=	SPACE(0)
			,	del_ip						=	SPACE(0)
			,	del_prg						=	SPACE(0)
			,	del_datetime				=	NULL
			FROM M5020
			INNER JOIN #TBL_JSON ON (
				M5020.company_cd		=	@P_company_cd
			AND M5020.work_history_kbn	=	@work_history_kbn
			AND M5020.item_id			=	#TBL_JSON.item_id
			AND M5020.del_datetime IS NOT NULL
			)

			--INSERT
			INSERT INTO M5020
			SELECT
				@P_company_cd			
			,	@work_history_kbn		
			,	#TBL_JSON.item_id
			,	#TBL_JSON.item_title
			,	#TBL_JSON.item_display_kbn		
			,	#TBL_JSON.item_arrangement_column
			,	#TBL_JSON.item_arrangement_line
			,	@P_cre_user	
			,	@P_cre_ip
			,	'eM0020'	
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL
			FROM #TBL_JSON
			LEFT JOIN M5020 ON (
				M5020.company_cd		=	@P_company_cd
			AND M5020.work_history_kbn	=	@work_history_kbn
			AND M5020.item_id			=	#TBL_JSON.item_id
			)
			WHERE M5020.company_cd IS NULL	
			AND M5020.work_history_kbn IS NULL
			AND M5020.item_id IS NULL

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
	ELSE
	BEGIN
		ROLLBACK TRANSACTION
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
	ORDER BY 
		order_by

	--
	DROP TABLE #TBL_JSON
END

GO
