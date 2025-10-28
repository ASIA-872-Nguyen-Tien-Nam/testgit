DROP PROCEDURE [SPC_O0100_ACT15]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   	
--*  処理概要/process overview	:	O0100 社員マスタ (通勤)
--*  
--*  作成日/create date			:	2024/04/12								
--*　作成者/creater				:	Quanlh								
--*   					
--*  更新日/update date			:  						
--*　更新者/updater				:　  　								     	 
--*　更新内容/update content	:
--* 					
--****************************************************************************************

CREATE PROCEDURE [SPC_O0100_ACT15]
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
		@w_time					DATETIME2	= SYSDATETIME()
	,	@order_by_min			INT			= 0
	,	@w_numeric_value1		INT			= 0
	,	@ERR_TBL				ERRTABLE	
	--
	CREATE TABLE #TEMP(
		id										INT		IDENTITY(1,1)
	,	exec_user								NVARCHAR(100)
	,	company_cd								SMALLINT
	,	employee_cd								NVARCHAR(50)
	,	detail_no								NVARCHAR(50)
	,	commuting_method						NVARCHAR(50)
	,	commuting_distance						NVARCHAR(50)
	,	drivinglicense_renewal_deadline			NVARCHAR(50)
	,	commuting_method_detail					NVARCHAR(50)
	,	departure_point							NVARCHAR(50)
	,	arrival_point							NVARCHAR(50)
	,	commuter_ticket_classification			NVARCHAR(50)
	,	commuting_expenses						NVARCHAR(50)
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
		,	RTRIM(LTRIM(commuting_method))				
		,	REPLACE(RTRIM(LTRIM(commuting_distance)),'.00','')																								
		,	RTRIM(LTRIM(drivinglicense_renewal_deadline))	
		,	RTRIM(LTRIM(commuting_method_detail))			
		,	RTRIM(LTRIM(departure_point))					
		,	RTRIM(LTRIM(arrival_point))					
		,	RTRIM(LTRIM(commuter_ticket_classification))				
		,	REPLACE(RTRIM(LTRIM(commuting_expenses)),'.00','')				
		FROM OPENJSON(@P_json) WITH(										
			employee_cd								NVARCHAR(50)
		,	detail_no								NVARCHAR(50)
		,	commuting_method						NVARCHAR(50)
		,	commuting_distance						NVARCHAR(50)
		,	drivinglicense_renewal_deadline			NVARCHAR(50)
		,	commuting_method_detail					NVARCHAR(50)
		,	departure_point							NVARCHAR(50)
		,	arrival_point							NVARCHAR(50)
		,	commuter_ticket_classification			NVARCHAR(50)
		,	commuting_expenses						NVARCHAR(50)						
		)
		
		SET @w_numeric_value1 = (
			SELECT 
				L0010.numeric_value1 
			FROM #TEMP INNER JOIN L0010 ON (
				L0010.number_cd = #TEMP.commuting_method
			AND L0010.name_typ = 64
			AND L0010.del_datetime is NULL
			)
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
		--	validate required detail_no 
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
		--VALIDATE MAXLENGHT commuting_method
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'commuting_method'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Commuting Method',N'通勤手段')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.commuting_method)>3)
		--VALIDATE NUMERIC commuting_method
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	N'commuting_method'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Commuting Method',N'通勤手段')	
		FROM #TEMP 
		WHERE
			(#TEMP.commuting_method <> N'')
		AND (#TEMP.commuting_method LIKE '%[^0-9]%')
		-- VALIDATE EXIST commuting_method IN L0010
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.commuting_method NOT LIKE '%[^0-9]%')
		BEGIN
			IF NOT EXISTS (
				SELECT 1 FROM #TEMP 
				LEFT JOIN L0010 ON (
					L0010.number_cd = #TEMP.commuting_method
				AND L0010.name_typ = 64
				AND L0010.del_datetime is NULL
				)
				WHERE #TEMP.commuting_method = 0 OR L0010.number_cd IS NOT NULL
			)
			BEGIN
				INSERT INTO @ERR_TBL
				SELECT
					70				
				,	'commuting_method'				
				,	0-- oderby		
				,	1-- dialog  	
				,	0				
				,	0				
				,	IIF(@P_language = N'en',N'Commuting Method',N'通勤手段')	
			END
		END
		-------------------------------------------------
		-- VALIDATE DECIMAL commuting_distance numeric(7,2)
		IF EXISTS (SELECT 1 FROM #TEMP WHERE LEN(#TEMP.commuting_distance)> 0) -- check null
		BEGIN
			IF (SELECT ISNUMERIC(#TEMP.commuting_distance) FROM #TEMP) = 0 -- check type numeric
			BEGIN
				INSERT INTO @ERR_TBL
				SELECT
					11				
				,	'commuting_distance'				
				,	0-- oderby		
				,	1-- dialog  	
				,	0				
				,	0				
				,	IIF(@P_language = N'en',N'Commuting Distance',N'通勤距離')	
			END
			ELSE
			BEGIN
				IF (SELECT CHARINDEX('-', #TEMP.commuting_distance) FROM #TEMP) > 0 -- check negative
				BEGIN
					INSERT INTO @ERR_TBL
					SELECT
						13				
					,	'commuting_distance'				
					,	0-- oderby		
					,	1-- dialog  	
					,	0				
					,	0				
					,	IIF(@P_language = N'en',N'Commuting Distance',N'通勤距離')
				END
				ELSE
				BEGIN
					IF (SELECT CHARINDEX('.', #TEMP.commuting_distance) FROM #TEMP) > 0 -- check format 
					BEGIN
						IF (SELECT LEN(#TEMP.commuting_distance) - CHARINDEX('.', #TEMP.commuting_distance) FROM #TEMP) > 2 -- phan thap phan
						OR (SELECT LEN(LEFT(#TEMP.commuting_distance, CHARINDEX('.', #TEMP.commuting_distance) -1)) FROM #TEMP) > 5 -- phan so nguyen
						BEGIN
							INSERT INTO @ERR_TBL
							SELECT
								28				
							,	'commuting_distance'				
							,	0-- oderby		
							,	1-- dialog  	
							,	0				
							,	0				
							,	IIF(@P_language = N'en',N'Commuting Distance',N'通勤距離')	
						END
					END
					ELSE
					BEGIN
						INSERT INTO @ERR_TBL
						SELECT	
							28				
						,	'commuting_distance'				
						,	0-- oderby		
						,	1-- dialog  	
						,	0				
						,	0				
						,	IIF(@P_language = N'en',N'Commuting Distance',N'通勤距離')	
						FROM #TEMP
						WHERE 
							LEN(#TEMP.commuting_distance) > 5
					END 
				END
			END
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT drivinglicense_renewal_deadline 							
		INSERT INTO @ERR_TBL												
		SELECT															
			28				
		,	N'drivinglicense_renewal_deadline'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Drivinglicense Renewal Deadline',N'運転免許証更新期限')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.drivinglicense_renewal_deadline)>10)	
		-------------------------------------------------
		--VALIDATE DATE drivinglicense_renewal_deadline
		INSERT INTO @ERR_TBL
		SELECT
			15				
		,	N'drivinglicense_renewal_deadline'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Drivinglicense Renewal Deadline',N'運転免許証更新期限')	
		FROM #TEMP 
		WHERE
			(#TEMP.drivinglicense_renewal_deadline <> N'')
		AND	(ISDATE(#TEMP.drivinglicense_renewal_deadline)=0)
		-------------------------------------------------
		--VALIDATE MAXLENGHT commuting_method_detail 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'commuting_method_detail'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Commuting Method Detail',N'通勤手段詳細')	
		FROM #TEMP 
		WHERE
			(LEN(commuting_method_detail)>20)
		-------------------------------------------------
		--VALIDATE MAXLENGHT departure_point 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'departure_point'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Departure Point',N'出発地')	
		FROM #TEMP 
		WHERE
			(LEN(departure_point)>20)
		-------------------------------------------------
		--VALIDATE MAXLENGHT arrival_point 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'arrival_point'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Arrival Point',N'到着地')	
		FROM #TEMP 
		WHERE
			(LEN(arrival_point)>20)
		-------------------------------------------------
		--VALIDATE MAXLENGHT commuter_ticket_classification
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'commuter_ticket_classification'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Commuter Ticket Classification',N'定期券区分')	
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.commuter_ticket_classification)>3)
		--VALIDATE NUMERIC commuter_ticket_classification
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	N'commuter_ticket_classification'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Commuter Ticket Classification',N'定期券区分')	
		FROM #TEMP 
		WHERE
			(#TEMP.commuter_ticket_classification <> N'')
		AND (#TEMP.commuter_ticket_classification LIKE '%[^0-9]%')
		-- VALIDATE EXIST commuter_ticket_classification IN L0010
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.commuter_ticket_classification NOT LIKE '%[^0-9]%' AND #TEMP.commuting_method IN(3,4,6))
		BEGIN
			IF NOT EXISTS (
				SELECT 1 FROM #TEMP 
				INNER JOIN L0010 ON (
					L0010.number_cd = #TEMP.commuter_ticket_classification
				AND ((L0010.name_typ = 65 AND (@w_numeric_value1 = 3 OR @w_numeric_value1 = 5)) OR (L0010.name_typ = 66 AND @w_numeric_value1 = 4))
				AND L0010.del_datetime is NULL
				)
			)
			BEGIN
				INSERT INTO @ERR_TBL
				SELECT
					70				
				,	'commuter_ticket_classification'				
				,	0-- oderby		
				,	1-- dialog  	
				,	0				
				,	0				
				,	IIF(@P_language = N'en',N'Commuter Ticket Classification',N'定期券区分')	
			END
		END
		-------------------------------------------------
		--VALIDATE MAXLENGHT commuting_expenses
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	N'commuting_expenses'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Commuting Expenses',N'通勤費')		
		FROM #TEMP 
		WHERE
			(LEN(#TEMP.commuting_expenses)>7)
		--VALIDATE NUMERIC commuting_expenses
		INSERT INTO @ERR_TBL
		SELECT
			13				
		,	N'commuting_expenses'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	IIF(@P_language = N'en',N'Commuting Expenses',N'通勤費')		
		FROM #TEMP 
		WHERE
			(#TEMP.commuting_expenses <> N'')
		AND (#TEMP.commuting_expenses LIKE '%[^0-9]%')
		--VALIDATE NUMERIC commuting_expenses < 0
		IF EXISTS (SELECT 1 FROM #TEMP WHERE #TEMP.commuting_expenses NOT LIKE '%[^0-9]%' AND LEN(#TEMP.commuting_expenses) <= 7)
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				13				
			,	N'commuting_expenses'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	IIF(@P_language = N'en',N'Commuting Expenses',N'通勤費')	
			FROM #TEMP 
			WHERE 
				(#TEMP.commuting_expenses < 0)
		END
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
			FROM #TEMP INNER JOIN WRK_M0084 ON(
				#TEMP.company_cd			= WRK_M0084.company_cd
			AND #TEMP.employee_cd			= WRK_M0084.employee_cd
			AND WRK_M0084.company_cd		= @P_company_cd
			AND WRK_M0084.detail_no			= #TEMP.detail_no
			)
		END
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- PROCESS
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- Chổ nay dung de viet code xu ly du lieu sau khi validate xong
		--
		IF NOT EXISTS(SELECT 1 FROM @ERR_TBL)
		BEGIN
			DELETE W FROM  WRK_M0084 AS W LEFT JOIN  #TEMP AS T ON W.company_cd = @P_company_cd AND W.exec_user = T.exec_user  WHERE T.company_cd IS NOT NULL
			--
			INSERT INTO WRK_M0084 
			SELECT 
				#TEMP.exec_user
			,	#TEMP.company_cd
			,	#TEMP.employee_cd				
			,	#TEMP.detail_no							
			,	#TEMP.commuting_method			
			,	CASE
					WHEN #TEMP.commuting_method = 1 THEN IIF(#TEMP.commuting_distance = '', N'0', #TEMP.commuting_distance)
					WHEN #TEMP.commuting_method = 2 THEN IIF(#TEMP.commuting_distance = '', N'0', #TEMP.commuting_distance)
					WHEN #TEMP.commuting_method = 5 THEN IIF(#TEMP.commuting_distance = '', N'0', #TEMP.commuting_distance)
					WHEN #TEMP.commuting_method = 7 THEN IIF(#TEMP.commuting_distance = '', N'0', #TEMP.commuting_distance)
					ELSE N'0'
				END
			,	CASE
					WHEN #TEMP.commuting_method = 1 THEN IIF(#TEMP.drivinglicense_renewal_deadline = '', NULL, #TEMP.drivinglicense_renewal_deadline) 
					WHEN #TEMP.commuting_method = 5 THEN IIF(#TEMP.drivinglicense_renewal_deadline = '', NULL, #TEMP.drivinglicense_renewal_deadline) 
					ELSE NULL
				END
			,	CASE
					WHEN #TEMP.commuting_method = 8 THEN #TEMP.commuting_method_detail 
					ELSE ''
				END
			,	CASE
					WHEN #TEMP.commuting_method = 3 THEN #TEMP.departure_point 
					WHEN #TEMP.commuting_method = 4 THEN #TEMP.departure_point 
					WHEN #TEMP.commuting_method = 6 THEN #TEMP.departure_point 
					WHEN #TEMP.commuting_method = 8 THEN #TEMP.departure_point 
					ELSE ''
				END
			,	CASE
					WHEN #TEMP.commuting_method = 3 THEN #TEMP.arrival_point 
					WHEN #TEMP.commuting_method = 4 THEN #TEMP.arrival_point 
					WHEN #TEMP.commuting_method = 6 THEN #TEMP.arrival_point 
					WHEN #TEMP.commuting_method = 8 THEN #TEMP.arrival_point 
					ELSE ''
				END
			,	CASE
					WHEN #TEMP.commuting_method = 3 THEN #TEMP.commuter_ticket_classification
					WHEN #TEMP.commuting_method = 4 THEN #TEMP.commuter_ticket_classification
					WHEN #TEMP.commuting_method = 6 THEN #TEMP.commuter_ticket_classification
					ELSE 0
				END	
			,	IIF(#TEMP.commuting_method = 0, NULL, #TEMP.commuting_expenses )	
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
			DELETE W FROM  WRK_M0084 AS W LEFT JOIN  #TEMP AS T ON W.company_cd = @P_company_cd AND W.exec_user = T.exec_user  WHERE W.exec_user LIKE '%WRK_M0084_%'
			--
			INSERT INTO WRK_M0084 
			SELECT 
				CONCAT('WRK_M0084', CAST(@P_no AS NVARCHAR(10)))
			,	0
			,	N''								
			,	0
			,	0
			,	0
			,	NULL	
			,	N''
			,	N''
			,	N''
			,	0
			,	0
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
			IF (EXISTS(SELECT 1 FROM @ERR_TBL) OR EXISTS(SELECT 1 FROM WRK_M0084 WHERE exec_user LIKE '%WRK_M0084%'))
			BEGIN
				TRUNCATE TABLE WRK_M0084
				--
				GOTO COMPLETE_QUERY
			END

			-- UPDATE M0084
			UPDATE M0084
			SET 
				commuting_method					=	WRK_M0084.commuting_method				
			,	commuting_distance					=	WRK_M0084.commuting_distance				
			,	drivinglicense_renewal_deadline		=	WRK_M0084.drivinglicense_renewal_deadline	
			,	commuting_method_detail				=	WRK_M0084.commuting_method_detail			
			,	departure_point						=	WRK_M0084.departure_point					
			,	arrival_point						=	WRK_M0084.arrival_point					
			,	commuter_ticket_classification		=	WRK_M0084.commuter_ticket_classification	
			,	commuting_expenses					=	WRK_M0084.commuting_expenses				
			,	upd_user							=	@P_cre_user		
			,	upd_ip								=	@P_cre_ip	
			,	upd_prg								=	N'O0100'	
			,	upd_datetime						=	@w_time	
			,	del_user							=	SPACE(0)
			,	del_ip								=	SPACE(0)
			,	del_prg								=	SPACE(0)
			,	del_datetime						=	NULL
			FROM M0084 
			INNER JOIN WRK_M0084 ON (
				M0084.company_cd	=	WRK_M0084.company_cd
			AND M0084.employee_cd	=	WRK_M0084.employee_cd
			AND M0084.detail_no		=	WRK_M0084.detail_no
			AND WRK_M0084.company_cd    = @P_company_cd
			)		

			-- INSERT M0084
			INSERT INTO M0084
			SELECT  
				WRK_M0084.company_cd
			,	WRK_M0084.employee_cd
			,	WRK_M0084.detail_no					
			,	WRK_M0084.commuting_method				
			,	WRK_M0084.commuting_distance				
			,	WRK_M0084.drivinglicense_renewal_deadline	
			,	WRK_M0084.commuting_method_detail			
			,	WRK_M0084.departure_point					
			,	WRK_M0084.arrival_point					
			,	WRK_M0084.commuter_ticket_classification	
			,	WRK_M0084.commuting_expenses				
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
			FROM WRK_M0084 
			LEFT JOIN M0084 ON (
				M0084.company_cd	=	WRK_M0084.company_cd
			AND M0084.employee_cd	=	WRK_M0084.employee_cd
			AND M0084.detail_no		=	WRK_M0084.detail_no
			)	
			WHERE 
				M0084.employee_cd IS NULL
			AND	WRK_M0084.employee_cd <> N''
			AND M0084.detail_no IS NULL
			AND	WRK_M0084.detail_no <> N''
			AND WRK_M0084.company_cd    = @P_company_cd

			--
			DELETE WRK_M0084
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
