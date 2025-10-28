DROP PROCEDURE [SPC_OI1020_ACT2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	DELETE DATA
--*  
--* 作成日/create date			:	2020/10/26											
--*	作成者/creater				:	datnt						
--*   					
--*	更新日/update date			:  	2021/04/22					
--*	更新者/updater				:　 viettd 　								     	 
--*	更新内容/update content		:	change 　	[FNC_GET_YEAR] => [FNC_GET_YEAR_1ON1]
--****************************************************************************************
CREATE PROCEDURE [SPC_OI1020_ACT2] 
	-- Add the parameters for the stored procedure here
	@P_company_cd		SMALLINT		= 0
,	@P_cre_user			NVARCHAR(50) = ''
,	@P_cre_ip			NVARCHAR(50) = ''
,	@P_json				NVARCHAR(MAX)	= ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2		= SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			INT				= 0	
	,	@w_fiscal_year			INT				= 0
	,	@w_1on1_group_cd		SMALLINT		= 0
	,	@current_year			INT				= 0
	-- CHECK JSON 
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
	-- GET @w_fiscal_year FROM JSON
	SET @w_fiscal_year		=	JSON_VALUE(@P_json,'$.fiscal_year')
	SET @w_1on1_group_cd	=	JSON_VALUE(@P_json,'$.group_cd')
	SET @current_year		= (SELECT [dbo].[FNC_GET_YEAR_1ON1] (@P_company_cd,@w_time))
	--#TBL_JSON
	CREATE TABLE #TBL_JSON(
		 row_index		INT
	,	 employee_cd	NVARCHAR(10)
	,	 times			INT
	,	 coach_cd		NVARCHAR(10)
	,	[f2200_status]	INT					-- 0. NOT EIXSTS DATA IN F2200 | 1. EXISTS DATA INTO F2200
	)
	--#TBL_EMPLOYEE
	CREATE TABLE #TBL_EMPLOYEE(
		 employee_cd	NVARCHAR(10)
	)
	--#TBL_COACH_TIMES
	CREATE TABLE #TBL_COACH_TIMES(
		times		SMALLINT
	,	coach_cd	NVARCHAR(10)
	)
	--#AUTHORITY
	CREATE TABLE #AUTHORITY(
		employee_cd		NVARCHAR(10)
	,	employee_status	INT   -- 1:member / 2:coach 
	)
	-- INSERT DATA INTO #TBL_JSON
	INSERT INTO #TBL_JSON
	SELECT 
		row_index		
	,	employee_cd	
	,	times			
	,	ISNULL(coach_cd ,'')	
	,	0
	FROM OPENJSON(@P_json,'$.list_pair') WITH(
		row_index		INT
	,	employee_cd		NVARCHAR(10)
	,	times			INT
	,	coach_cd		NVARCHAR(50)
	)
	--
	UPDATE #TBL_JSON SET 
		[f2200_status]	=	1	-- EXISTS DATA INTO F2200
	FROM #TBL_JSON 
	INNER JOIN F2200 ON(
		@P_company_cd			=	F2200.company_cd
	AND @w_fiscal_year			=	F2200.fiscal_year
	AND #TBL_JSON.employee_cd	=	F2200.employee_cd
	--AND #TBL_JSON.times		=	F2200.times
	AND F2200.del_datetime IS NULL
	)
	-- INSERT INTO #TBL_EMPLOYEE
	INSERT INTO #TBL_EMPLOYEE
	SELECT 
		employee_cd
	FROM #TBL_JSON
	GROUP BY
		#TBL_JSON.employee_cd
	-- VALIDATE
	-- MESS 126
	IF NOT EXISTS (SELECT 1 FROM #TBL_JSON)
	BEGIN
		INSERT INTO @ERR_TBL VALUES(		
			126								-- mã lỗi (trùng với mã trong bảng message) 					
		,	''								-- id hoặc class của item(#id , .class), lỗi dạng dialog thì để trống  				
		,	0-- oderby						-- giá trị càng bé thì lỗi được hiển thị trước  				
		,	1-- dialog  					-- Kiểu hiển thị lối : 0. tooltip , 1.dialog 				
		,	0								-- Tùy ý : có thể lưu vị trí index của dòng của lỗi 				
		,	0								-- Tùy ý
		,	'no row detail is checked'		-- Comment nội dung lỗi (chủ yếu là dùng khi đọc code)
		)
	END
	-- MESS 21
	IF NOT EXISTS (SELECT 1 FROM #TBL_JSON INNER JOIN F2001 ON ( @P_company_cd = F2001.company_cd AND @w_fiscal_year = F2001.fiscal_year and #TBL_JSON.employee_cd = F2001.employee_cd)  )
	BEGIN
		INSERT INTO @ERR_TBL VALUES(		
			21								-- mã lỗi (trùng với mã trong bảng message) 					
		,	''								-- id hoặc class của item(#id , .class), lỗi dạng dialog thì để trống  				
		,	0-- oderby						-- giá trị càng bé thì lỗi được hiển thị trước  				
		,	1-- dialog  					-- Kiểu hiển thị lối : 0. tooltip , 1.dialog 				
		,	0								-- Tùy ý : có thể lưu vị trí index của dòng của lỗi 				
		,	0								-- Tùy ý
		,	'no data in f2001 yet'			-- Comment nội dung lỗi (chủ yếu là dùng khi đọc code)
		)
	END
	-- MESS 129
	
		INSERT INTO @ERR_TBL 
		SELECT 
			129								-- mã lỗi (trùng với mã trong bảng message) 					
		,	'.emp_error'								-- id hoặc class của item(#id , .class), lỗi dạng dialog thì để trống  				
		,	0-- oderby						-- giá trị càng bé thì lỗi được hiển thị trước  				
		,	4-- dialog  					-- Kiểu hiển thị lối : 0. tooltip , 1.dialog 				
		,	#TBL_JSON.row_index								-- Tùy ý : có thể lưu vị trí index của dòng của lỗi 				
		,	0								-- Tùy ý
		,	'CANNOT DELTE WHEN EXISTS DATA IN F2200'-- Comment nội dung lỗi (chủ yếu là dùng khi đọc code)
		FROM #TBL_JSON
		WHERE [f2200_status] = 1
	-- 
	BEGIN TRANSACTION
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM @ERR_TBL)
		BEGIN
			-- GET DATA INTO #TBL_COACH_TIMES
			INSERT INTO #TBL_COACH_TIMES
			SELECT 
				F2001.times
			,	F2001.coach_cd
			FROM #TBL_EMPLOYEE
			LEFT OUTER JOIN F2001 ON (
				@P_company_cd				=	F2001.company_cd
			AND @w_fiscal_year				=	F2001.fiscal_year
			AND #TBL_EMPLOYEE.employee_cd	=	F2001.employee_cd
			AND F2001.del_datetime IS NULL
			)
			GROUP BY
				F2001.times
			,	F2001.coach_cd
			-- GET ALL COACH + MEMBER INTO #AUTHORITY
			-- laay toan bo thang MEMBER bi xoa
			INSERT INTO #AUTHORITY 
			SELECT 
				#TBL_JSON.employee_cd
			,	0
			FROM  #TBL_JSON
			-- laay toan bo thang COACH bi xoa
			INSERT INTO #AUTHORITY
			SELECT 
				F2001.coach_cd
			,	0
			FROM #TBL_EMPLOYEE
			LEFT OUTER JOIN F2001 ON (
				@P_company_cd				=	F2001.company_cd
			AND @w_fiscal_year				=	F2001.fiscal_year
			AND #TBL_EMPLOYEE.employee_cd	=	F2001.employee_cd
			AND F2001.del_datetime IS NULL
			)
			GROUP BY
				F2001.coach_cd
			-- UPDATE F2000
			UPDATE F2000 SET 
				F2000.del_user			= @P_cre_user
			,	F2000.del_ip			= @P_cre_ip
			,	F2000.del_datetime		= @w_time
			,	F2000.del_prg			= 'oI1020'
			FROM F2000 
			INNER JOIN #TBL_JSON ON(
				F2000.company_cd		=	@P_company_cd
			AND F2000.fiscal_year		=	@w_fiscal_year
			AND F2000.employee_cd		=	#TBL_JSON.employee_cd
			)
			-- UDPATE F2001
			UPDATE F2001 SET 
				F2001.del_user			= @P_cre_user
			,	F2001.del_ip			= @P_cre_ip
			,	F2001.del_datetime		= @w_time
			,	F2001.del_prg			= 'oI1020'
			FROM F2001 
			INNER JOIN #TBL_JSON ON(
				F2001.company_cd		=	@P_company_cd
			AND F2001.fiscal_year		=	@w_fiscal_year
			AND F2001.employee_cd		=	#TBL_JSON.employee_cd
			)
			--UPDATE QUYEN
			--**step1** update nhung thang coach cua eployee bi xoa neu khong con lam coach nhung lam member
			UPDATE #AUTHORITY SET 
				employee_status = 1
			FROM #AUTHORITY INNER JOIN F2001 ON(
				@P_company_cd	=	F2001.company_cd
			AND @current_year	=	F2001.fiscal_year		-- only current year	
			AND #AUTHORITY.employee_cd	=	F2001.employee_cd
			)
			WHERE F2001.del_datetime IS NULL
			--**step2** update nhung thang coach cua eployee bi xoa neu khong con lam coach nhung lam coach nv khac
			UPDATE #AUTHORITY SET 
				employee_status = 2
			FROM #AUTHORITY INNER JOIN F2001 ON(
				@P_company_cd	=	F2001.company_cd
			AND @current_year	=	F2001.fiscal_year	-- only current year
			AND #AUTHORITY.employee_cd	=	F2001.coach_cd
			)
			WHERE F2001.del_datetime IS NULL
			
			-- update nhung coach hoac employee bi xoa maf van la coach cua employee khac =2
			UPDATE S0010 SET 
				[1on1_authority_typ]	= #AUTHORITY.employee_status
			,	S0010.upd_user			= @P_cre_user
			,	S0010.upd_ip			= @P_cre_ip
			,	S0010.upd_datetime		= @w_time
			,	S0010.upd_prg			= 'oI1020'
			FROM S0010 
			INNER JOIN #AUTHORITY ON(
				S0010.company_cd		=	@P_company_cd
			AND S0010.employee_cd		=	#AUTHORITY.employee_cd
			)	
			AND S0010.del_datetime IS NULL
			WHERE ISNULL(S0010.[1on1_authority_typ],0) < 3
			-------------------- F2301 --------------------------
			-- DELETE ALL 2.MEMBER
			DELETE D FROM F2301 AS D
			INNER JOIN #TBL_EMPLOYEE ON (
				D.company_cd		=	@P_company_cd
			AND D.fiscal_year		=	@w_fiscal_year
			AND D.[1on1_group_cd]	=	@w_1on1_group_cd
			AND D.submit			=	2	-- MEMBER
			AND D.employee_cd		=	#TBL_EMPLOYEE.employee_cd
			)
			-- DELETE ALL COACH EIXTS IN F2001
			DELETE D FROM #TBL_COACH_TIMES AS D
			INNER JOIN F2001 ON (
				@P_company_cd			=	F2001.company_cd
			AND @w_fiscal_year			=	F2001.fiscal_year
			AND D.times					=	F2001.times
			AND D.coach_cd				=	F2001.coach_cd
			AND F2001.del_datetime IS NULL
			)
			-- DELETE ALL COACH IN F2301 WHEN NOT EXITS IN F2001
			DELETE D FROM F2301 AS D
			INNER JOIN #TBL_COACH_TIMES ON (
				D.company_cd			=	@P_company_cd
			AND D.fiscal_year			=	@w_fiscal_year
			AND D.[1on1_group_cd]		=	@w_1on1_group_cd
			AND D.times					=	#TBL_COACH_TIMES.times
			AND D.submit				=	1	-- 1.COACH
			AND D.employee_cd			=	#TBL_COACH_TIMES.coach_cd
			)
			-- CR 26/3/2021 DELETE TABLE F2900
			UPDATE F2900 
			SET
				del_user		= @P_cre_user							
			,	del_ip			= @P_cre_ip							
			,	del_prg			= 'oI1020'							
			,	del_datetime	= @w_time							
			FROM #TBL_EMPLOYEE 
			INNER JOIN  F2900  ON(
				@P_company_cd				= F2900.company_cd	
			AND	1							= F2900.infomation_typ
			AND	CAST(@w_time AS DATE)		= F2900.infomation_date
			AND #TBL_EMPLOYEE.employee_cd	= F2900.target_employee_cd
			AND @w_fiscal_year				= F2900.fiscal_year
			AND #TBL_EMPLOYEE.employee_cd	= F2900.employee_cd
			)
			

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
	IF(@@TRANCOUNT > 0)
	BEGIN
		COMMIT TRANSACTION
	END
    -- Insert statements for procedure here
	COMPLETE_QUERY:
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
