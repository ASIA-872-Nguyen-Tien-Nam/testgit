SET ANSI_NULLS ON
GO
DROP PROCEDURE [dbo].[SPC_M0070_12_ACT1] 
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	SAVE DATA
--*  
--* 作成日/create date			:	2024/04/08											
--*	作成者/creater				:	Quanlh						
--*   					
--*	更新日/update date			:  						
--*	更新者/updater				:　  　								     	 
--*	更新内容/update content		:	　	
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_M0070_12_ACT1] 
	-- Add the parameters for the stored procedure here
	@P_json					NVARCHAR(MAX)
	-- common
,	@P_cre_user				NVARCHAR(50)		= N''
,	@P_cre_ip				NVARCHAR(50)		= N''
,	@P_company_cd			SMALLINT			= 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time										DATETIME2			= SYSDATETIME()
	,	@order_by_min								INT					= 0
	,	@ERR_TBL									ERRTABLE	
	--
	,	@employee_cd								NVARCHAR(10)		= N''
	,	@base_salary								MONEY				= 0
	,	@basic_annual_income						MONEY				= 0
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
	-- ASSIGN
	IF ISJSON(@P_json) <= 0
	BEGIN
		INSERT INTO @ERR_TBL VALUES(		
			22								-- mã lỗi (trùng với mã trong bảng message) 					
		,	N''								-- id hoặc class của item(#id , .class), lỗi dạng dialog thì để trống  				
		,	0-- oderby						-- giá trị càng bé thì lỗi được hiển thị trước  				
		,	1-- dialog  					-- Kiểu hiển thị lối : 0. tooltip , 1.dialog 				
		,	0								-- Tùy ý : có thể lưu vị trí index của dòng của lỗi 				
		,	0								-- Tùy ý
		,	N'json format'					-- Comment nội dung lỗi (chủ yếu là dùng khi đọc code)
		)
	END
	--
	SET @employee_cd										=	JSON_VALUE(@P_json,'$.employee_cd				')					
	SET @base_salary										=	JSON_VALUE(@P_json,'$.base_salary				')	
	SET @basic_annual_income								=	JSON_VALUE(@P_json,'$.basic_annual_income		')		
	--
	IF NOT EXISTS (SELECT 1 FROM @ERR_TBL)
		BEGIN
		IF EXISTS(SELECT 1 FROM M0092 WHERE 
					company_cd		=	@P_company_cd
				AND employee_cd		=	@employee_cd
				)
			BEGIN	
				UPDATE M0092
				SET						
					base_salary										=	@base_salary		
				,	basic_annual_income								=	@basic_annual_income
				,	upd_user										=	@P_cre_user	
				,	upd_ip											=	@P_cre_ip	
				,	upd_prg											=	N'M0070'			
				,	upd_datetime									=	@w_time	
				,	del_user										=	SPACE(0)
				,	del_ip											=	SPACE(0)
				,	del_prg											=	SPACE(0)
				,	del_datetime									=	NULL	
				WHERE 
					company_cd		=	@P_company_cd
				AND employee_cd		=	@employee_cd
			END
			ELSE
			BEGIN
				INSERT INTO M0092
				SELECT 
					@P_company_cd								--company_cd
				,	@employee_cd
				,	@base_salary										
				,	@basic_annual_income								
				,	@P_cre_user									--cre_user						
				,	@P_cre_ip									--cre_ip						
				,	N'M0070'										--cre_prg						
				,	@w_time										--cre_datetime						
				,	SPACE(0)									--upd_user						
				,	SPACE(0)									--upd_ip						
				,	SPACE(0)									--upd_prg						
				,	NULL										--upd_datetime						
				,	SPACE(0)									--del_user						
				,	SPACE(0)									--del_ip						
				,	SPACE(0)									--del_prg						
				,	NULL										--del_datetime						
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
		,	N'EXCEPTION'
		,	0
		,	999 -- exception error
		,	0
		,	0
		,	N'Error'                                                          + CHAR(13) + CHAR(10) +
            N'Procedure : ' + ISNULL(ERROR_PROCEDURE(), '???')                + CHAR(13) + CHAR(10) +
            N'Line : '      + ISNULL(CAST(ERROR_LINE() AS NVARCHAR(10)), '0') + CHAR(13) + CHAR(10) +
            N'Message : '   + ISNULL(ERROR_MESSAGE(), 'An unexpected error occurred.')
	END CATCH
	--DELETE FROM @ERR_TBL
	IF(@@TRANCOUNT > 0)
	BEGIN
		COMMIT TRANSACTION
	END
    -- INSERT STATEMENTS FOR PROCEDURE HERE
	COMPLETE_QUERY:
	-- GET ERROR_TYPE MIN
	SELECT 
		@order_by_min = MIN(order_by)
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
	WHERE order_by = @order_by_min
	ORDER BY 
		order_by
END

GO