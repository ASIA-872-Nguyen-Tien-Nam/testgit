DROP PROCEDURE [SPC_O0100_ACT17]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   	
--*  処理概要/process overview	:	O0100 社員マスタ (有期雇用契約)
--*  
--*  作成日/create date			:	2024/04/11								
--*　作成者/creater				:	Quanlh								
--*   					
--*  更新日/update date			:  						
--*　更新者/updater				:　  　								     	 
--*　更新内容/update content	:
--* 					
--****************************************************************************************

CREATE PROCEDURE [SPC_O0100_ACT17]
	-- Add the parameters for the stored procedure here
	@P_json			NVARCHAR(MAX)	= N''
,	@P_exec_user	NVARCHAR(100)	= N''
,	@P_company_cd	SMALLINT		= 0	
,	@P_cre_user		NVARCHAR(50)	= N''
,	@P_cre_ip		NVARCHAR(50)	= N''
,	@P_no			INT				= 0
,	@P_count		INT				= 0
,	@P_language		NVARCHAR(2)		= N''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 	
		@w_time			DATETIME2	= SYSDATETIME()
	,	@order_by_min	INT			= 0
	,	@ERR_TBL		ERRTABLE	
	--
	CREATE TABLE #TEMP(
		id							INT		IDENTITY(1,1)
	,	exec_user					NVARCHAR(100)
	,	company_cd					SMALLINT
	,	employee_cd					NVARCHAR(50)
	,	detail_no					NVARCHAR(50)
	,	leave_absence_startdate		NVARCHAR(50)
	,	leave_absence_enddate		NVARCHAR(50)
	,	remarks						NVARCHAR(150)
	)
	-- START TRANSACTION 
	BEGIN TRANSACTION
	BEGIN TRY
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- VALIDATE
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		IF ISJSON(@P_json) <= 0
		BEGIN
			INSERT INTO @ERR_TBL VALUES(		
				22						-- mã lỗi (trùng với mã trong bảng message) 					
			,	N''						-- id hoặc class của item(#id , .class), lỗi dạng dialog thì để trống 			
			,	0-- oderby				-- giá trị càng bé thì lỗi được hiển thị trước  				
			,	1-- dialog  			-- Kiểu hiển thị lối : 0. tooltip , 1.dialog 				
			,	0						-- Tùy ý : có thể lưu vị trí index của dòng của lỗi 				
			,	0						-- Tùy ý
			,	N'json format'			-- Comment nội dung lỗi (chủ yếu là dùng khi đọc code)
			)
		END
		-- GET  TEMP
		INSERT INTO #TEMP
		SELECT
			CONCAT(@P_exec_user, CAST(@P_no AS NVARCHAR(10)))																		
		,	@P_company_cd															
		,	RTRIM(LTRIM(employee_cd))											
		,	RTRIM(LTRIM(detail_no))
		,	RTRIM(LTRIM(leave_absence_startdate))
		,	RTRIM(LTRIM(leave_absence_enddate))																						
		,	RTRIM(LTRIM(remarks))												
		FROM OPENJSON(@P_json) WITH(										
			employee_cd					NVARCHAR(50)
		,	detail_no					NVARCHAR(50)
		,	leave_absence_startdate		NVARCHAR(50)
		,	leave_absence_enddate		NVARCHAR(50)
		,	remarks						NVARCHAR(150)						
		)
		--------------------------------------------
		--VALIDATE MAXLENGHT employee_cd 							
		INSERT INTO @ERR_TBL												
		SELECT															
			28				
		,	N'employee_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Employee Code',N'社員コード')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.employee_cd)>10)
		--VALIDATE REQUIRED employee_cd 							
		INSERT INTO @ERR_TBL												
		SELECT															
			8				
		,	N'employee_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Employee Code',N'社員コード')	
		FROM #TEMP 
		WHERE
			(#TEMP.employee_cd = N'')
		--	--
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.employee_cd NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				151				
			,	N'employee_cd'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Employee Code',N'社員コード')	
			FROM #TEMP 
			WHERE
				#TEMP.employee_cd = 0
		END
		-- VALIDATE EXIST employee_cd IN M0070
		IF NOT EXISTS (
			SELECT 1 FROM #TEMP 
			INNER JOIN M0070 ON (
				M0070.company_cd = @P_company_cd
			AND	M0070.employee_cd = #TEMP.employee_cd
			AND M0070.del_datetime is NULL
			)
		)
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				111				
			,	'employee_cd'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Employee Code','社員コード')	
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT detail_no
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'detail_no'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Detail No',N'明細番号')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.detail_no)>3)
		--VALIDATE NUMERIC detail_no
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	N'detail_no'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Detail No',N'明細番号')	
		FROM #TEMP 
		WHERE
			(#TEMP.detail_no <> N'')
		AND (#TEMP.detail_no LIKE '%[^0-9]%')
		--VALIDATE NUMERIC detail_no < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.detail_no NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	N'detail_no'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Detail No',N'明細番号')
			FROM #TEMP 
			WHERE 
				(#TEMP.detail_no NOT LIKE '%[^0-9]%')
			AND	(#TEMP.detail_no < 0)
		END
		--	validate detail_no = blank
		INSERT INTO @ERR_TBL
		SELECT
			8				
		,	N'detail_no'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Detail No',N'明細番号')
		FROM #TEMP 
		WHERE
			#TEMP.detail_no = ''
		--	validate detail_no = 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.detail_no NOT LIKE '%[^0-9]%' AND #TEMP.detail_no <> '')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	N'detail_no'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Detail No',N'明細番号')
			FROM #TEMP 
			WHERE
				#TEMP.detail_no = 0
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT leave_absence_startdate 							
		INSERT INTO @ERR_TBL												
		SELECT															
			28				
		,	N'leave_absence_startdate'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Leave Absence Start Date',N'休職開始日')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.leave_absence_startdate)>10)	
		--VALIDATE DATE leave_absence_startdate
		INSERT INTO @ERR_TBL
		SELECT
			15				
		,	N'leave_absence_startdate'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Leave Absence Start Date',N'休職開始日')	
		FROM #TEMP 
		WHERE
			(#TEMP.leave_absence_startdate <> N'')
		AND	(ISDATE(#TEMP.leave_absence_startdate)=0)
		--VALIDATE DATE leave_absence_startdate <  leave_absence_enddate	
		IF EXISTS (SELECT 1 FROM #TEMP WHERE (ISDATE(#TEMP.leave_absence_startdate)=1) AND (ISDATE(#TEMP.leave_absence_enddate)=1))
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				24				
			,	N'leave_absence_startdate'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Leave Absence Start Date',N'休職開始日')	
			FROM #TEMP 
			WHERE
				CAST(#TEMP.leave_absence_startdate AS DATE) > CAST(#TEMP.leave_absence_enddate AS DATE)
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT leave_absence_enddate 							
		INSERT INTO @ERR_TBL												
		SELECT															
			28				
		,	N'leave_absence_enddate'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Leave Absence End Date',N'休職終了日')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.leave_absence_enddate)>10)	
		--VALIDATE DATE leave_absence_enddate
		INSERT INTO @ERR_TBL
		SELECT
			15				
		,	N'leave_absence_enddate'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Leave Absence End Date',N'休職終了日')	
		FROM #TEMP 
		WHERE
			(#TEMP.leave_absence_enddate <> N'')
		AND	(ISDATE(#TEMP.leave_absence_enddate)=0)	
		--VALIDATE DATE leave_absence_startdate <  leave_absence_enddate	
		IF EXISTS (SELECT 1 FROM #TEMP WHERE (ISDATE(#TEMP.leave_absence_startdate)=1) AND (ISDATE(#TEMP.leave_absence_enddate)=1))
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				24				
			,	N'leave_absence_enddate'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Leave Absence End Date',N'休職終了日')		
			FROM #TEMP 
			WHERE
				CAST(#TEMP.leave_absence_startdate AS DATE) > CAST(#TEMP.leave_absence_enddate AS DATE)
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT remarks 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'remarks'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Remarks',N'休職事由')	
		FROM #TEMP 
		WHERE
			(LEN(remarks)>100)
		-------------------------------------------------
		--VALIDATE UNIQUE detail_no
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.detail_no NOT LIKE '%[^0-9]%')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				159			
			,	'detail_no'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Detail No','明細番号')	
			FROM #TEMP INNER JOIN WRK_M0087 ON(
				#TEMP.company_cd			= WRK_M0087.company_cd
			AND #TEMP.employee_cd			= WRK_M0087.employee_cd
			AND WRK_M0087.company_cd		= @P_company_cd
			AND WRK_M0087.detail_no			= #TEMP.detail_no
			)
		END

		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- PROCESS
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- Chổ nay dung de viet code xu ly du lieu sau khi validate xong
		--
		
		IF NOT EXISTS(SELECT 1 FROM @ERR_TBL)
		BEGIN
			DELETE W FROM  WRK_M0087 AS W LEFT JOIN  #TEMP AS T ON W.company_cd = @P_company_cd AND W.exec_user = T.exec_user  WHERE T.company_cd IS NOT NULL
			--
			INSERT INTO WRK_M0087 
			SELECT 
				#TEMP.exec_user
			,	#TEMP.company_cd
			,	#TEMP.employee_cd				
			,	#TEMP.detail_no							
			,	IIF(#TEMP.leave_absence_startdate = '', NULL, #TEMP.leave_absence_startdate )
			,	IIF(#TEMP.leave_absence_enddate = '', NULL, #TEMP.leave_absence_enddate )
			,	#TEMP.remarks			
			,	@P_cre_user			
			,	@P_cre_ip	
			,	N'O0100'		
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			FROM #TEMP
		END
		ELSE
		BEGIN
			DELETE W FROM  WRK_M0087 AS W LEFT JOIN  #TEMP AS T ON W.company_cd = @P_company_cd AND W.exec_user = T.exec_user  WHERE W.exec_user LIKE '%WRK_M0087_%'
			--
			INSERT INTO WRK_M0087 
			SELECT 
				CONCAT('WRK_M0087', CAST(@P_no AS NVARCHAR(10)))
			,	0
			,	N''								
			,	0			
			,	NULL	
			,	NULL
			,	N''
			,	@P_cre_user			
			,	@P_cre_ip	
			,	N'O0100'		
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			FROM #TEMP
		END			
		

		IF (@P_no = @P_count) 
		BEGIN
			--
			IF (EXISTS(SELECT 1 FROM @ERR_TBL) OR EXISTS(SELECT 1 FROM WRK_M0087 WHERE exec_user LIKE '%WRK_M0087%'))
			BEGIN
				TRUNCATE TABLE WRK_M0087
				--
				GOTO COMPLETE_QUERY
			END

			-- UPDATE M0087
			UPDATE M0087
			SET 
				leave_absence_startdate		=	WRK_M0087.leave_absence_startdate	
			,	leave_absence_enddate		=	WRK_M0087.leave_absence_enddate	
			,	remarks						=	WRK_M0087.remarks
			,	upd_user					=	@P_cre_user		
			,	upd_ip						=	@P_cre_ip	
			,	upd_prg						=	N'O0100'	
			,	upd_datetime				=	@w_time	
			,	del_user					=	SPACE(0)
			,	del_ip						=	SPACE(0)
			,	del_prg						=	SPACE(0)
			,	del_datetime				=	NULL
			FROM M0087 
			INNER JOIN WRK_M0087 ON (
				M0087.company_cd	=	WRK_M0087.company_cd
			AND M0087.employee_cd	=	WRK_M0087.employee_cd
			AND M0087.detail_no		=	WRK_M0087.detail_no
			AND WRK_M0087.company_cd    = @P_company_cd
			)		

			-- INSERT M0087
			INSERT INTO M0087
			SELECT  
				WRK_M0087.company_cd
			,	WRK_M0087.employee_cd
			,	WRK_M0087.detail_no					
			,	WRK_M0087.leave_absence_startdate		
			,	WRK_M0087.leave_absence_enddate			
			,	WRK_M0087.remarks				
			,	@P_cre_user			
			,	@P_cre_ip	
			,	N'O0100'		
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL
			FROM WRK_M0087 
			LEFT JOIN M0087 ON (
				M0087.company_cd	=	WRK_M0087.company_cd
			AND M0087.employee_cd	=	WRK_M0087.employee_cd
			AND M0087.detail_no		=	WRK_M0087.detail_no
			)	
			WHERE 
				M0087.employee_cd IS NULL
			AND	WRK_M0087.employee_cd <> N''
			AND M0087.detail_no IS NULL
			AND	WRK_M0087.detail_no <> N''
			AND WRK_M0087.company_cd    = @P_company_cd

			--
			DELETE WRK_M0087
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
	COMPLETE_QUERY:
	--
	IF EXISTS(SELECT 1 FROM @ERR_TBL AS ERR_TBL WHERE ERR_TBL.item = N'EXCEPTION')
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
