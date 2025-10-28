IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_OQ2020_ACT1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_OQ2020_ACT1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：OQ2020 - SAVE/UPDATE
 *
 *  作成日  ：2020-12-14
 *  作成者  ：ANS-ASIA nghianm
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_OQ2020_ACT1] 
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
	,	@fiscal_year			SMALLINT
	,	@employee_cd			NVARCHAR(10)
	,	@target1				NVARCHAR(1000)
	,	@target2				NVARCHAR(1000)
	,	@target3				NVARCHAR(1000)
	,	@comment				NVARCHAR(400)
	--
	IF ISJSON(@P_json) <= 0
	BEGIN
		INSERT INTO @ERR_TBL VALUES(		
			22									-- mã lỗi (trùng với mã trong bảng message) 					
		,	''									-- id hoặc class của item(#id , .class), lỗi dạng dialog thì để trống  				
		,	0-- oderby							-- giá trị càng bé thì lỗi được hiển thị trước  				
		,	1-- dialog  						-- Kiểu hiển thị lối : 0. tooltip , 1.dialog 				
		,	0									-- Tùy ý : có thể lưu vị trí index của dòng của lỗi 				
		,	0									-- Tùy ý
		,	'json format'						-- Comment nội dung lỗi (chủ yếu là dùng khi đọc code)
		)
	END

	SET @fiscal_year		=	ISNULL(JSON_VALUE(@P_json,'$.fiscal_year'),0)
	SET @employee_cd		=	ISNULL(JSON_VALUE(@P_json,'$.employee_cd'),'')
	SET @target1			=	ISNULL(JSON_VALUE(@P_json,'$.target1_nm'),0)
	SET @target2			=	ISNULL(JSON_VALUE(@P_json,'$.target2_nm'),'')
	SET @target3			=	ISNULL(JSON_VALUE(@P_json,'$.target3_nm'),0)
	SET @comment			=	ISNULL(JSON_VALUE(@P_json,'$.comment'),0)
	--
	BEGIN TRANSACTION
	BEGIN TRY
		--
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM F2100 WHERE company_cd = @P_company_cd AND fiscal_year = @fiscal_year AND employee_cd = @employee_cd)
			BEGIN
				INSERT INTO F2100
				SELECT
					@P_company_cd
				,	@fiscal_year
				,	@employee_cd
				,	@target1
				,	@target2
				,	@target3
				,	@comment
				,	@P_cre_user
				,	@P_cre_ip
				,	'oQ2020'
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
				UPDATE F2100
				SET target1		= @target1
				,	target2		= @target2
				,	target3		= @target3
				,	comment		= @comment
				,	upd_user	= @P_cre_user
				,	upd_ip		= @P_cre_ip
				,	upd_prg		= 'oQ2020'
				,	upd_datetime = @w_time
				WHERE F2100.company_cd	= @P_company_cd
				AND F2100.fiscal_year	= @fiscal_year
				AND F2100.employee_cd	= @employee_cd
				AND F2100.del_datetime IS NULL
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
