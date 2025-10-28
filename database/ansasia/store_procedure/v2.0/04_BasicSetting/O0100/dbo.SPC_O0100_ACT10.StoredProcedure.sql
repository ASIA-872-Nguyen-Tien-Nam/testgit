DROP PROCEDURE [SPC_O0100_ACT10]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   											
--*  ˆ—ŠT—v/process overview	:	O0100
--*  
--*  ì¬“ú/create date			:	2018/10/04								
--*@ì¬ŽÒ/creater				:	sondh@								
--*   					
--*  XV“ú/update date			:  	2021/09/14						
--*@XVŽÒ/updater				:@ viettd @								     	 
--*@XV“à—e/update content		:	change authority in S0010
--*   					
--****************************************************************************************

CREATE PROCEDURE [SPC_O0100_ACT10]
	-- Add the parameters for the stored procedure here
	@P_json						NVARCHAR(MAX) =	''
,	@P_exec_user				NVARCHAR(50)  =	''
,	@P_company_cd				SMALLINT	  =	0	
,	@P_cre_user					NVARCHAR(20)  =	''
,	@P_cre_ip					NVARCHAR(50)  =	''
,	@P_no						INT			  =	0
,	@P_count					INT			  =	0
,	@P_language				NVARCHAR(2)			= ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 	
		@w_time					DATETIME2 = SYSDATETIME()
	,	@order_by_min			INT		  = 0
	,	@ERR_TBL				ERRTABLE  
	,	@old_pass				nvarchar(20) = ''
	--
	CREATE TABLE #TEMP(
		id						INT		IDENTITY(1,1)
	,	exec_user				NVARCHAR(50)
	,	company_cd				SMALLINT
	,	employee_cd				NVARCHAR(50)
	,	[password]				NVARCHAR(50)
	)
	-- START TRANSACTION 
	BEGIN TRANSACTION
	BEGIN TRY
		--šššššššššššššššššššššššššššššš
		-- VALIDATE
		--šššššššššššššššššššššššššššššš
		IF ISJSON(@P_json) <= 0
		BEGIN
			INSERT INTO @ERR_TBL VALUES(		
				22						-- mã lỗi (trùng với mã trong bảng message) 					
			,	''						-- id hoặc class của item(#id , .class), lỗi dạng dialog thì để trống 			
			,	0-- oderby				-- giá trị càng bé thì lỗi được hiển thị trước  				
			,	1-- dialog  			-- Kiểu hiển thị lối : 0. tooltip , 1.dialog 				
			,	0						-- Tùy ý : có thể lưu vị trí index của dòng của lỗi 				
			,	0						-- Tùy ý
			,	'json format'			-- Comment nội dung lỗi (chủ yếu là dùng khi đọc code)
			)
		END
		-- GET  DATA
		INSERT INTO #TEMP
		SELECT
			@P_exec_user 
		,	@P_company_cd
		,	RTRIM(LTRIM(employee_cd))		
		,	RTRIM(LTRIM([password]))		
		FROM OPENJSON(@P_json) WITH(
			employee_cd					NVARCHAR(50)
		,	[password]					NVARCHAR(50)
		)
		--VALIDATE MAXLENGHT employee_cd 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'employee_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Employee Code','社員コード')	
		FROM #TEMP 
		WHERE
			(LEN(employee_cd)>10)
				--VALIDATE REQUIRED employee_cd 							
		INSERT INTO @ERR_TBL												
		SELECT															
			8				
		,	'employee_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Employee Code','社員コード')	
		FROM #TEMP 
		WHERE
			(#TEMP.employee_cd = '')
		--	--
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.employee_cd NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				151			
			,	'employee_cd'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Employee Code','社員コード')	
			FROM #TEMP 
			WHERE
				#TEMP.employee_cd = 0
		END
		--VALIDATE MAXLENGHT password 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'password'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Password','パスワード')		
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.[password])>20)
		--
		INSERT INTO @ERR_TBL
		SELECT
			111			
		,	'employee_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Employee Code','社員コード')		
		FROM #TEMP LEFT JOIN M0070 ON(
			@P_company_cd		=	M0070.company_cd
		AND #TEMP.employee_cd	=	M0070.employee_cd
		AND M0070.del_datetime IS NULL
		)
		WHERE M0070.company_cd IS NULL 
		AND #TEMP.employee_cd	<> '0' 
		AND #TEMP.employee_cd	<> ''
		--
		IF NOT EXISTS(SELECT 1 FROM @ERR_TBL)
		BEGIN
		DELETE W FROM  WRK_S0010 AS W INNER JOIN  #TEMP AS T ON (
										W.company_cd = @P_company_cd 
									AND W.exec_user = T.exec_user) 		
			INSERT INTO WRK_S0010 
			SELECT 
				#TEMP.exec_user								
			,	#TEMP.company_cd		
			,	''						AS	user_id
			,	#TEMP.employee_cd		
			,	#TEMP.[password]		
			,	''						AS	sso_user
			,	0						AS	authority_typ						
			,	0						AS	authority_cd
			,	0						AS	[1on1_authority_typ]
			,	0						AS	[1on1_authority_cd]
			,	0						AS	multireview_authority_typ
			,	0						AS	multireview_authority_cd
			,	0						AS	empinfo_authority_typ
			,	0						AS	empinfo_authority_cd
			,	0						AS	setting_authority_typ
			,	0						AS	setting_authority_cd
			,	0						AS	report_authority_typ
			,	0						AS	report_authority_cd
			,	SPACE(0)				AS	remember_token
			,	0						AS	failed_login_count
			,	NULL					AS	pass_change_datetime
			,	SPACE(0)				AS	last_login_ip
			,	NULL					AS	last_login_datetime
			,	@P_cre_user				AS	cre_user
			,	@P_cre_ip				AS	cre_ip
			,	'O0100'					AS	cre_prg
			,	@w_time					AS	cre_datetime
			,	SPACE(0)				AS	upd_user
			,	SPACE(0)				AS	upd_ip
			,	SPACE(0)				AS	upd_prg
			,	NULL					AS	upd_datetime
			,	SPACE(0)				AS	del_user
			,	SPACE(0)				AS	del_ip
			,	SPACE(0)				AS	del_prg
			,	NULL					AS	del_datetime
			FROM #TEMP
		END
		
		IF (@P_no = @P_count) 
		BEGIN
			--
			UPDATE S0010
			SET
				[password]			=	WRK_S0010.[password]
			,	upd_user			=	@P_cre_user
			,	upd_ip				=	@P_cre_ip
			,	upd_prg				=	'O0100'
			,	upd_datetime		=	@w_time
			,	del_user			=	SPACE(0)
			,	del_ip				=	SPACE(0)
			,	del_prg				=	SPACE(0)
			,	del_datetime		=	NULL
			FROM S0010
			INNER JOIN WRK_S0010 ON (
				S0010.company_cd		=		WRK_S0010.company_cd
			AND S0010.employee_cd		=		WRK_S0010.employee_cd
			AND S0010.del_datetime IS NULL
			)
			WHERE
				WRK_S0010.employee_cd <> ''
			--
			TRUNCATE TABLE WRK_S0010
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
	COMPLETE_QUERY:
	--
	IF EXISTS(SELECT 1 FROM @ERR_TBL AS ERR_TBL WHERE ERR_TBL.item = 'EXCEPTION')
	BEGIN
		IF @@TRANCOUNT >0
		BEGIN
			ROLLBACK TRANSACTION
		END
	END
	ELSE
	BEGIN
		COMMIT TRANSACTION
	END

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
