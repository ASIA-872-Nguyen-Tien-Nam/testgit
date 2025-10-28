DROP PROCEDURE [SPC_rI1010_ACT2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	DELETE DATA
--*  
--* 作成日/create date			:	2023/04/19											
--*	作成者/creater				:	quangnd						
--*   					
--*	更新日/update date			:  						
--*	更新者/updater				:　  　								     	 
--*	更新内容/update content		:	　	
--****************************************************************************************
CREATE PROCEDURE [SPC_rI1010_ACT2] 
	-- Add the parameters for the stored procedure here
	@P_json						NVARCHAR(MAX)	=	''
,	@P_company_cd				SMALLINT		=	0
,	@P_cre_user					NVARCHAR(50)	=	''
,	@P_cre_ip					NVARCHAR(50)	=	''
,	@P_month					SMALLINT		=	-1
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2		= SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			INT			= 0	
	,	@w_fiscal_year			SMALLINT	= 0
	,	@w_report_kind			SMALLINT	= 1
	,	@w_group_cd				SMALLINT	= -1
	--
	CREATE TABLE #F4100(
		id					INT		IDENTITY(1,1)
	,	company_cd			SMALLINT
	,	fiscal_year			SMALLINT
	,	group_cd			SMALLINT
	,	report_kind			SMALLINT
	)
	CREATE TABLE #DETAIL_NO(
		id					INT		IDENTITY(1,1)
	,	detail_no			SMALLINT
	)

	CREATE TABLE #DATE_DETAIL_WEEKLY(
		id							INT	IDENTITY(1,1)
	,	detail_no					SMALLINT
	,	month						SMALLINT
	,	normal_month				SMALLINT
	,	[start_date]				DATETIME
	,	deadline_date				DATETIME
	)
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
	IF EXISTS (SELECT 1 FROM @ERR_TBL)  GOTO COMPLETE_QUERY
	--
	SET @w_fiscal_year	= ISNULL(JSON_VALUE(@P_json,'$.fiscal_year'),0)
	SET @w_report_kind	= ISNULL(JSON_VALUE(@P_json,'$.report_kind'),0)
	--
	INSERT INTO #F4100
	SELECT 
		@P_company_cd
	,	@w_fiscal_year
	,	ISNULL(report_group ,0)  
	,	@w_report_kind
	FROM OPENJSON(@P_json, '$.report_group_list') WITH(
		report_group      	SMALLINT
	)
	
	--
	INSERT INTO #DETAIL_NO
	SELECT 
		ISNULL(detail_no,0)
	FROM OPENJSON(@P_json, '$.detail_no') WITH(
		detail_no      	SMALLINT
	)

	SET @w_group_cd = (SELECT TOP 1 (group_cd) FROM #F4100)
	IF @w_report_kind IN(1,2,3) 
	BEGIN
		INSERT INTO #DATE_DETAIL_WEEKLY
		EXEC [dbo].[SPC_WEEKLYREPORT_GET_WEEKLY] @P_company_cd,@w_fiscal_year,0
	END
	ELSE IF @w_report_kind = 4
	BEGIN
		IF @P_month = -1
		BEGIN
			SET @P_month = 0
			INSERT INTO #DATE_DETAIL_WEEKLY
			EXEC [dbo].[SPC_WEEKLYREPORT_GET_WEEKLY] @P_company_cd,@w_fiscal_year,@P_month
		END
		ELSE
		BEGIN
			INSERT INTO #DETAIL_NO
			SELECT @P_month
		END
	END
	ELSE IF @w_report_kind = 5
	BEGIN
		INSERT INTO #DATE_DETAIL_WEEKLY
		EXEC [dbo].[SPC_WEEKLYREPORT_GET_WEEKLY] @P_company_cd,@w_fiscal_year,@P_month
	END
	INSERT INTO #DETAIL_NO
	SELECT 
		a.detail_no
	FROM #DATE_DETAIL_WEEKLY AS a 
	LEFT JOIN #DETAIL_NO AS b ON(
		a.detail_no = b.detail_no
	) 
	WHERE 
		b.detail_no IS  NULL
	IF NOT EXISTS (SELECT 1 
				FROM F4100
				INNER JOIN #F4100 ON (
					F4100.company_cd = #F4100.company_cd
				AND F4100.fiscal_year = #F4100.fiscal_year
				AND F4100.group_cd		= #F4100.group_cd
				AND F4100.report_kind = #F4100.report_kind
				)
				INNER JOIN #DETAIL_NO ON (
					F4100.detail_no = #DETAIL_NO.detail_no
				)
				WHERE 
					F4100.company_cd = @P_company_cd 
				AND F4100.fiscal_year = @w_fiscal_year
				AND F4100.report_kind = @w_report_kind
				AND del_datetime IS NULL)
	BEGIN
		INSERT INTO @ERR_TBL
		SELECT 
			21
		,	''
		,	0
		,	1 -- exception error
		,	0
		,	0
		,	''
	END
	IF EXISTS (SELECT 1 FROM @ERR_TBL)  GOTO COMPLETE_QUERY
	
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
			UPDATE F4100
			SET 
				F4100.del_user			= @P_cre_user
			,	F4100.del_ip			= @P_cre_ip
			,	F4100.del_datetime		= @w_time
			,	F4100.del_prg			= 'rI1010'
			FROM F4100 
			INNER JOIN #F4100 ON(
				F4100.[group_cd]		=	#F4100.group_cd
			)
			INNER JOIN #DETAIL_NO ON(
				F4100.detail_no		=	#DETAIL_NO.detail_no
			)
			WHERE 
				F4100.company_cd		=	@P_company_cd
			AND F4100.fiscal_year		=	@w_fiscal_year
			AND F4100.report_kind		=   @w_report_kind
			AND F4100.del_datetime		IS NULL
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
	--
	COMPLETE_QUERY:
	IF (SELECT COUNT(1) FROM @ERR_TBL) > 1
	BEGIN
		ROLLBACK TRANSACTION
	END
	--
	IF(@@TRANCOUNT > 0)
	BEGIN
		COMMIT TRANSACTION
	END
    -- Insert statements for procedure here
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
	WHERE order_by = @order_by_min
	ORDER BY 
		order_by
END
GO
