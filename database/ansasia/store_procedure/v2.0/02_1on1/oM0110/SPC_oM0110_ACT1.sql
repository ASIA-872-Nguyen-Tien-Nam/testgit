/****** Object:  StoredProcedure [dbo].[SPC_oM0110_ACT1]    Script Date: 2018/08/28 16:39:16 ******/
SET ANSI_NULLS ON
GO
DROP PROCEDURE [dbo].[SPC_oM0110_ACT1] 
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	SAVE DATA
--*  
--* 作成日/create date			:	2020/10/23									
--*	作成者/creater				:	DUONGNTT						
--*   					
--*	更新日/update date			:	2021/05/14  			
--*	更新者/updater				:　 	VIETDT					     	 
--*	更新内容/update content		:	CR category3 remove required
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_oM0110_ACT1] 
	@P_json					NVARCHAR(MAX)
,	@P_cre_user				NVARCHAR(50)			= ''	
,	@P_cre_ip				NVARCHAR(50)			= ''
,	@P_company_cd			SMALLINT				= 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2			= SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			INT					= 0
	,	@P_company_cd_refer		SMALLINT			= -1
	,	@P_category1_cd			SMALLINT			= 0
	,	@P_refer_kbn			TINYINT				= 0
	,	@P_category1_nm			NVARCHAR(50)		= ''
	,	@max_category1_cd		SMALLINT			= 0
	,	@w_check				SMALLINT			= 0	--check cong ty dang login & cong ty cua ban ghi dang duoc refer co phai la 1 cong ty hay khong?
	,	@w_flg_del				SMALLINT			= 0
	,	@w_contract_company_attribute	SMALLINT	= 0
	--
	CREATE TABLE #DATA_TMP(
		id					INT IDENTITY(1,1)
	,	company_cd			SMALLINT
	,	category1_cd		SMALLINT
	,	refer_kbn			TINYINT
	,	category1_nm		NVARCHAR(50)
	,	category2_cd		SMALLINT
	,	category2_nm		NVARCHAR(50)
	,	category3_cd		SMALLINT
	,	category3_nm		NVARCHAR(50)
	,	question_cd			INT
	,	question			NVARCHAR(200)
	--
	,	cate2_no			INT
	,	cate3_no			INT
	,	company_cd_refer	SMALLINT
	)

	--
	CREATE TABLE #TABLE_M2111(
		id					INT IDENTITY(1,1)
	,	company_cd			SMALLINT
	,	category1_cd		SMALLINT
	,	refer_kbn			TINYINT
	,	category2_cd		SMALLINT
	,	cate2_no			INT
	,	category2_nm		NVARCHAR(50)
	--
	,	arrange_order		INT
	,	cre_user			NVARCHAR(50)
	,	cre_ip				NVARCHAR(50)
	,	cre_prg				NVARCHAR(20)
	,	cre_datetime		DATETIME
	,	flg_mode			VARCHAR(10)	--1:INSERT/2: UPDATE
	)

	--
	CREATE TABLE #TABLE_M2112(
		id					INT IDENTITY(1,1)
	,	company_cd			SMALLINT
	,	category1_cd		SMALLINT
	,	refer_kbn			TINYINT
	,	category2_cd		SMALLINT
	,	category3_cd		SMALLINT
	,	cate2_no			INT
	,	cate3_no			INT
	,	category3_nm		NVARCHAR(50)
	,	row_id_cate3		INT
	--
	,	arrange_order		INT
	,	cre_user			NVARCHAR(50)
	,	cre_ip				NVARCHAR(50)
	,	cre_prg				NVARCHAR(20)
	,	cre_datetime		DATETIME
	,	flg_mode			VARCHAR(10)	--1:INSERT/2: UPDATE
	)

	--
	CREATE TABLE #TABLE_M2113(
		id					INT IDENTITY(1,1)
	,	company_cd			SMALLINT
	,	category1_cd		SMALLINT
	,	refer_kbn			TINYINT
	,	category2_cd		SMALLINT
	,	category3_cd		SMALLINT
	,	question_cd			INT
	,	cate2_no			INT
	,	cate3_no			INT
	,	question			NVARCHAR(200)
	,	row_id_question		INT
	--
	,	arrange_order		INT
	,	cre_user			NVARCHAR(50)
	,	cre_ip				NVARCHAR(50)
	,	cre_prg				NVARCHAR(20)
	,	cre_datetime		DATETIME
	,	flg_mode			VARCHAR(10)	--1:INSERT/2: UPDATE
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

	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		--
		IF NOT EXISTS (SELECT 1 FROM @ERR_TBL)
		BEGIN
			--MC LOGIN
			SET @w_contract_company_attribute = (SELECT contract_company_attribute 
													FROM M0001 
													WHERE 
														M0001.company_cd = @P_company_cd
													AND M0001.del_datetime IS NULL
													)
			IF(@w_contract_company_attribute = 1)
			BEGIN
				SET @P_company_cd  = 0
			END
			-- 
			INSERT INTO #DATA_TMP
			SELECT
				@P_company_cd
			,	ISNULL(JSON_VALUE([value],'$.category1_cd'),0)
			,	ISNULL(JSON_VALUE([value],'$.refer_kbn'),0)
			,	ISNULL(JSON_VALUE([value],'$.category1_nm'),'')
			,	ISNULL(JSON_VALUE([value],'$.category2_cd'),0)
			,	ISNULL(JSON_VALUE([value],'$.category2_nm'),'')
			,	ISNULL(JSON_VALUE([value],'$.category3_cd'),0)
			,	ISNULL(JSON_VALUE([value],'$.category3_nm'),'')
			,	ISNULL(JSON_VALUE([value],'$.question_cd'),0)	
			,	ISNULL(JSON_VALUE([value],'$.question'),'')	
			,	ISNULL(JSON_VALUE([value],'$.cate2_no'),0)	
			,	ISNULL(JSON_VALUE([value],'$.cate3_no'),0)	
			,	ISNULL(JSON_VALUE([value],'$.company_cd_refer'),0)	
			FROM OPENJSON(@P_json)

			-- assign
			SET @P_category1_cd		=	(SELECT TOP 1 #DATA_TMP.category1_cd FROM #DATA_TMP)
			SET @P_category1_nm		=	(SELECT TOP 1 #DATA_TMP.category1_nm FROM #DATA_TMP)
			SET @P_company_cd_refer	=	(SELECT TOP 1 #DATA_TMP.company_cd_refer FROM #DATA_TMP)
			SET @P_refer_kbn		=	(SELECT TOP 1 #DATA_TMP.refer_kbn FROM #DATA_TMP)
		
			--
			IF(@P_company_cd_refer <> @P_company_cd)
			BEGIN
				SET @w_check		=	1
			END
			--
			IF (@P_refer_kbn = 0)
			BEGIN
				IF(@P_company_cd = 0 OR (@P_company_cd <> 0 AND @P_company_cd_refer = 0))
				BEGIN
					SET @P_refer_kbn	=	1
					--
					UPDATE #DATA_TMP
					SET refer_kbn		=	1
				END 
				ELSE
				BEGIN
					SET @P_refer_kbn	=	2
					--
					UPDATE #DATA_TMP
					SET refer_kbn		=	2
				END
			END

			--DATA M2111
			INSERT INTO #TABLE_M2111
			SELECT 
				company_cd			
			,	category1_cd	
			,	refer_kbn	
			,	category2_cd
			,	cate2_no	
			,	''			--category2_nm
			--
			,	NULL
			,	NULL
			,	NULL
			,	NULL
			,	NULL
			,	1
			FROM #DATA_TMP
			GROUP BY 
				company_cd		
			,	category1_cd	
			,	refer_kbn	
			,	category2_cd	
			,	cate2_no
			ORDER BY 
				company_cd			
			,	category1_cd	
			,	refer_kbn	
			,	cate2_no	
			,	category2_cd
			--
			UPDATE #TABLE_M2111
			SET #TABLE_M2111.category2_nm	=	#DATA_TMP.category2_nm
			FROM #TABLE_M2111
			INNER JOIN #DATA_TMP ON (
				#TABLE_M2111.company_cd		=	#DATA_TMP.company_cd
			AND #TABLE_M2111.category1_cd	=	#DATA_TMP.category1_cd
			AND #TABLE_M2111.refer_kbn		=	#DATA_TMP.refer_kbn
			AND #TABLE_M2111.category2_cd	=	#DATA_TMP.category2_cd
			AND #TABLE_M2111.cate2_no		=	#DATA_TMP.cate2_no
			)
			WHERE #DATA_TMP.category2_nm <> ''

			--DATA M2112
			INSERT INTO #TABLE_M2112
			SELECT 
				company_cd		
			,	category1_cd
			,	refer_kbn		
			,	category2_cd	
			,	category3_cd	
			,	cate2_no	
			,	cate3_no
			,	''			--category3_nm
			,	ROW_NUMBER() OVER(PARTITION BY company_cd,category1_cd,refer_kbn,category2_cd,cate2_no ORDER BY company_cd ASC,category1_cd ASC,refer_kbn ASC,cate2_no ASC,cate3_no ASC,category2_cd ASC)
			--
			,	NULL
			,	NULL
			,	NULL
			,	NULL
			,	NULL
			,	1
			FROM #DATA_TMP
			GROUP BY 
				company_cd		
			,	category1_cd
			,	refer_kbn		
			,	category2_cd	
			,	category3_cd	
			,	cate2_no
			,	cate3_no
			ORDER BY 
				company_cd		
			,	category1_cd
			,	refer_kbn	
			,	cate2_no
			,	cate3_no	
			,	category2_cd	
			,	category3_cd	
			--
			UPDATE #TABLE_M2112
			SET #TABLE_M2112.category3_nm	=	#DATA_TMP.category3_nm
			FROM #TABLE_M2112
			INNER JOIN #DATA_TMP ON (
				#TABLE_M2112.company_cd		=	#DATA_TMP.company_cd
			AND #TABLE_M2112.category1_cd	=	#DATA_TMP.category1_cd
			AND #TABLE_M2112.refer_kbn		=	#DATA_TMP.refer_kbn
			AND #TABLE_M2112.category2_cd	=	#DATA_TMP.category2_cd
			AND #TABLE_M2112.category3_cd	=	#DATA_TMP.category3_cd
			AND #TABLE_M2112.cate2_no		=	#DATA_TMP.cate2_no
			AND #TABLE_M2112.cate3_no		=	#DATA_TMP.cate3_no
			)
			--WHERE #DATA_TMP.category3_nm <> '' --edited by vietdt 2021/05/14
		
			--
			SET @max_category1_cd	=	(SELECT ISNULL(MAX(category1_cd),0) FROM M2110 WHERE company_cd = @P_company_cd AND refer_kbn = @P_refer_kbn) 

			--
			IF(@P_company_cd_refer <> @P_company_cd)
			BEGIN
				IF EXISTS (SELECT 1 FROM M2110 WHERE company_cd = @P_company_cd AND category1_cd = @P_category1_cd AND refer_kbn = @P_refer_kbn AND del_datetime IS NOT NULL)
				BEGIN
					SET @w_flg_del = 1
				END
			END 
			ELSE
			BEGIN
				IF EXISTS (SELECT 1 FROM M2110 WHERE company_cd = @P_company_cd AND category1_cd = @P_category1_cd AND refer_kbn = @P_refer_kbn AND del_datetime IS NOT NULL)
				BEGIN
					INSERT INTO @ERR_TBL VALUES(
						8
					,	'#category1_cd'
					,	0-- oderby
					,	1-- dialog  
					,	0
					,	0
					,	'category1_cd not found'
					)
				END
			END

			-- do stuff
			IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
			BEGIN
				IF @w_check = 1
				BEGIN
					--
					IF (@w_flg_del = 0)
					BEGIN
						INSERT INTO M2110
						SELECT 
							@P_company_cd
						,	IIF(@P_company_cd_refer = 0,@P_category1_cd,@max_category1_cd + 1)
						,	@P_refer_kbn
						,	@P_category1_nm
						,	NULL
						,	@P_cre_user	
						,	@P_cre_ip
						,	'oM0110'	
						,	@w_time
						,	SPACE(0)
						,	SPACE(0)
						,	SPACE(0)
						,	NULL
						,	SPACE(0)
						,	SPACE(0)
						,	SPACE(0)
						,	NULL
				
						SET @P_category1_cd	= (IIF(@P_company_cd_refer = 0,@P_category1_cd,@max_category1_cd + 1))
					END
					ELSE
					BEGIN
						--
						UPDATE M2110
						SET
							category1_nm	=	@P_category1_nm
						,	upd_user		=	@P_cre_user
						,	upd_ip			=	@P_cre_ip
						,	upd_prg			=	'oM0110'
						,	upd_datetime	=	@w_time
						--
						,	del_user		=	SPACE(0)
						,	del_ip			=	SPACE(0)
						,	del_prg			=	SPACE(0)
						,	del_datetime	=	NULL
						WHERE
							company_cd		=	@P_company_cd
						AND	category1_cd	=	@P_category1_cd
						AND	refer_kbn		=	@P_refer_kbn

						--
						UPDATE M2111
						SET
							del_user		=	SPACE(0)
						,	del_ip			=	SPACE(0)
						,	del_prg			=	SPACE(0)
						,	del_datetime	=	NULL
						WHERE
							company_cd		=	@P_company_cd
						AND	category1_cd	=	@P_category1_cd
						AND	refer_kbn		=	@P_refer_kbn

						--
						UPDATE M2112
						SET
							del_user		=	SPACE(0)
						,	del_ip			=	SPACE(0)
						,	del_prg			=	SPACE(0)
						,	del_datetime	=	NULL
						WHERE
							company_cd		=	@P_company_cd
						AND	category1_cd	=	@P_category1_cd
						AND	refer_kbn		=	@P_refer_kbn
					
						--
						UPDATE M2113
						SET
							del_user		=	SPACE(0)
						,	del_ip			=	SPACE(0)
						,	del_prg			=	SPACE(0)
						,	del_datetime	=	NULL
						WHERE
							company_cd		=	@P_company_cd
						AND	category1_cd	=	@P_category1_cd
						AND	refer_kbn		=	@P_refer_kbn
					END
				END
				ELSE 
				BEGIN
					--
					UPDATE M2110
					SET
						category1_nm	=	@P_category1_nm
					,	upd_user		=	@P_cre_user
					,	upd_ip			=	@P_cre_ip
					,	upd_prg			=	'oM0110'
					,	upd_datetime	=	@w_time
					WHERE
						company_cd		=	@P_company_cd
					AND	category1_cd	=	@P_category1_cd
					AND	refer_kbn		=	@P_refer_kbn
					AND del_datetime IS NULL
				END

				--M2111
				IF EXISTS(SELECT 1 FROM M2111 WHERE M2111.company_cd = @P_company_cd AND M2111.category1_cd	= @P_category1_cd AND M2111.refer_kbn = @P_refer_kbn AND M2111.del_datetime IS NULL)
				BEGIN
					UPDATE #TABLE_M2111
					SET 
						arrange_order		=	M2111.arrange_order	
					,	cre_user			=	M2111.cre_user		
					,	cre_ip				=	M2111.cre_ip			
					,	cre_prg				=	M2111.cre_prg			
					,	cre_datetime		=	M2111.cre_datetime	
					,	flg_mode			=	2
					FROM #TABLE_M2111
					LEFT JOIN M2111 ON (
						#TABLE_M2111.company_cd		=	M2111.company_cd
					AND #TABLE_M2111.category1_cd	=	M2111.category1_cd
					AND #TABLE_M2111.refer_kbn		=	M2111.refer_kbn
					AND #TABLE_M2111.category2_cd	=	M2111.category2_cd
					AND M2111.del_datetime IS NULL
					)
					WHERE M2111.company_cd IS NOT NULL

					DELETE FROM M2111
					WHERE 
						M2111.company_cd	=	@P_company_cd
					AND M2111.category1_cd	=	@P_category1_cd
					AND M2111.refer_kbn		=	@P_refer_kbn

					INSERT INTO M2111
					SELECT 
						@P_company_cd
					,	@P_category1_cd
					,	@P_refer_kbn
					,	#TABLE_M2111.category2_cd
					,	#TABLE_M2111.category2_nm
					,	#TABLE_M2111.arrange_order	
					,	#TABLE_M2111.cre_user		
					,	#TABLE_M2111.cre_ip			
					,	#TABLE_M2111.cre_prg			
					,	#TABLE_M2111.cre_datetime	
					,	@P_cre_user	
					,	@P_cre_ip
					,	'oM0110'	
					,	@w_time
					,	SPACE(0)
					,	SPACE(0)
					,	SPACE(0)
					,	NULL
					FROM #TABLE_M2111
					WHERE #TABLE_M2111.flg_mode	=	2
				END

				IF EXISTS(SELECT 1 FROM #TABLE_M2111 WHERE #TABLE_M2111.flg_mode = 1)
				BEGIN
					INSERT INTO M2111
					SELECT 
						@P_company_cd
					,	@P_category1_cd
					,	@P_refer_kbn
					,	#TABLE_M2111.id
					,	#TABLE_M2111.category2_nm
					,	NULL
					,	@P_cre_user	
					,	@P_cre_ip
					,	'oM0110'	
					,	@w_time
					,	SPACE(0)
					,	SPACE(0)
					,	SPACE(0)
					,	NULL
					,	SPACE(0)
					,	SPACE(0)
					,	SPACE(0)
					,	NULL
					FROM #TABLE_M2111
					WHERE #TABLE_M2111.flg_mode	= 1
				END

				--UPDATE category2_cd
				UPDATE #TABLE_M2112
				SET 
					#TABLE_M2112.category2_cd	=	#TABLE_M2111.id
				FROM #TABLE_M2112
				INNER JOIN #TABLE_M2111 ON (
					#TABLE_M2112.company_cd		=	#TABLE_M2111.company_cd
				AND #TABLE_M2112.category1_cd	=	#TABLE_M2111.category1_cd
				AND #TABLE_M2112.refer_kbn		=	#TABLE_M2111.refer_kbn
				AND #TABLE_M2112.cate2_no		=	#TABLE_M2111.cate2_no
				)
				WHERE 
					(#TABLE_M2112.category2_cd	=	0
				OR	#TABLE_M2112.category1_cd	=	0
				)
			
				UPDATE #DATA_TMP
				SET 
					#DATA_TMP.category2_cd		=	#TABLE_M2111.id
				FROM #DATA_TMP
				INNER JOIN #TABLE_M2111 ON (
					#DATA_TMP.company_cd		=	#TABLE_M2111.company_cd
				AND #DATA_TMP.category1_cd		=	#TABLE_M2111.category1_cd
				AND #DATA_TMP.refer_kbn			=	#TABLE_M2111.refer_kbn
				AND #DATA_TMP.cate2_no			=	#TABLE_M2111.cate2_no
				)
				WHERE 
					(#DATA_TMP.category2_cd		=	0
				OR	#DATA_TMP.category1_cd		=	0
				)
			
				--M2112
				IF EXISTS(SELECT 1 FROM M2112 WHERE M2112.company_cd = @P_company_cd AND M2112.category1_cd	= @P_category1_cd AND M2112.refer_kbn = @P_refer_kbn AND M2112.del_datetime IS NULL)
				BEGIN
					UPDATE #TABLE_M2112
					SET 
						arrange_order		=	M2112.arrange_order	
					,	cre_user			=	M2112.cre_user		
					,	cre_ip				=	M2112.cre_ip			
					,	cre_prg				=	M2112.cre_prg			
					,	cre_datetime		=	M2112.cre_datetime	
					,	flg_mode			=	2
					FROM #TABLE_M2112
					LEFT JOIN M2112 ON (
						#TABLE_M2112.company_cd		=	M2112.company_cd
					AND #TABLE_M2112.category1_cd	=	M2112.category1_cd
					AND #TABLE_M2112.refer_kbn		=	M2112.refer_kbn
					AND #TABLE_M2112.category2_cd	=	M2112.category2_cd
					AND #TABLE_M2112.category3_cd	=	M2112.category3_cd
					AND M2112.del_datetime IS NULL
					)
					WHERE M2112.company_cd IS NOT NULL

					DELETE FROM M2112
					WHERE 
						M2112.company_cd	=	@P_company_cd
					AND M2112.category1_cd	=	@P_category1_cd
					AND M2112.refer_kbn		=	@P_refer_kbn

					INSERT INTO M2112
					SELECT 
						@P_company_cd
					,	@P_category1_cd
					,	@P_refer_kbn
					,	#TABLE_M2112.category2_cd
					,	#TABLE_M2112.category3_cd
					,	#TABLE_M2112.category3_nm
					,	#TABLE_M2112.arrange_order	
					,	#TABLE_M2112.cre_user		
					,	#TABLE_M2112.cre_ip			
					,	#TABLE_M2112.cre_prg			
					,	#TABLE_M2112.cre_datetime	
					,	@P_cre_user	
					,	@P_cre_ip
					,	'oM0110'	
					,	@w_time
					,	SPACE(0)
					,	SPACE(0)
					,	SPACE(0)
					,	NULL
					FROM #TABLE_M2112
					WHERE #TABLE_M2112.flg_mode	=	2
				END

				IF EXISTS(SELECT 1 FROM #TABLE_M2112 WHERE #TABLE_M2112.flg_mode = 1)
				BEGIN
					INSERT INTO M2112
					SELECT 
						@P_company_cd
					,	@P_category1_cd
					,	@P_refer_kbn
					,	#TABLE_M2112.category2_cd
					,	#TABLE_M2112.cate3_no
					,	#TABLE_M2112.category3_nm
					,	NULL
					,	@P_cre_user	
					,	@P_cre_ip
					,	'oM0110'	
					,	@w_time
					,	SPACE(0)
					,	SPACE(0)
					,	SPACE(0)
					,	NULL
					,	SPACE(0)
					,	SPACE(0)
					,	SPACE(0)
					,	NULL
					FROM #TABLE_M2112
					WHERE #TABLE_M2112.flg_mode	= 1
				END

				UPDATE #DATA_TMP
				SET 
					#DATA_TMP.category3_cd		=	#TABLE_M2112.cate3_no
				FROM #DATA_TMP
				INNER JOIN #TABLE_M2112 ON (
					#DATA_TMP.company_cd		=	#TABLE_M2112.company_cd
				AND #DATA_TMP.category1_cd		=	#TABLE_M2112.category1_cd
				AND #DATA_TMP.refer_kbn			=	#TABLE_M2112.refer_kbn
				AND #DATA_TMP.category2_cd		=	#TABLE_M2112.category2_cd
				AND #DATA_TMP.cate2_no			=	#TABLE_M2112.cate2_no
				AND #DATA_TMP.cate3_no			=	#TABLE_M2112.cate3_no
				)
				WHERE 
					(#DATA_TMP.category3_cd		=	0
				OR	#DATA_TMP.category1_cd		=	0
				)

				--DATA M2113
				INSERT INTO #TABLE_M2113
				SELECT 
					company_cd			
				,	category1_cd	
				,	refer_kbn	
				,	category2_cd		
				,	category3_cd		
				,	question_cd			
				,	cate2_no			
				,	cate3_no			
				,	question
				,	ROW_NUMBER() OVER(PARTITION BY company_cd,category1_cd,refer_kbn,category2_cd,cate2_no,category3_cd,cate3_no ORDER BY company_cd ASC,category1_cd ASC,refer_kbn ASC,cate2_no ASC,category2_cd ASC,cate3_no ASC,category3_cd ASC)
				--
				,	NULL
				,	NULL
				,	NULL
				,	NULL
				,	NULL
				,	1
				FROM #DATA_TMP
				--
				IF EXISTS(SELECT 1 FROM M2113 WHERE M2113.company_cd = @P_company_cd AND M2113.category1_cd	= @P_category1_cd AND M2113.refer_kbn = @P_refer_kbn AND M2113.del_datetime IS NULL)
				BEGIN
					UPDATE #TABLE_M2113
					SET 
						arrange_order		=	M2113.arrange_order	
					,	cre_user			=	M2113.cre_user		
					,	cre_ip				=	M2113.cre_ip			
					,	cre_prg				=	M2113.cre_prg			
					,	cre_datetime		=	M2113.cre_datetime	
					,	flg_mode			=	2
					FROM #TABLE_M2113
					LEFT JOIN M2113 ON (
						#TABLE_M2113.company_cd		=	M2113.company_cd
					AND #TABLE_M2113.category1_cd	=	M2113.category1_cd
					AND #TABLE_M2113.refer_kbn		=	M2113.refer_kbn
					AND #TABLE_M2113.category2_cd	=	M2113.category2_cd
					AND #TABLE_M2113.category3_cd	=	M2113.category3_cd
					AND #TABLE_M2113.question_cd	=	M2113.question_cd
					AND M2113.del_datetime IS NULL
					)
					WHERE M2113.question_cd IS NOT NULL

					DELETE FROM M2113
					WHERE 
						M2113.company_cd	=	@P_company_cd
					AND M2113.category1_cd	=	@P_category1_cd
					AND M2113.refer_kbn		=	@P_refer_kbn

					INSERT INTO M2113
					SELECT 
						@P_company_cd
					,	@P_category1_cd
					,	@P_refer_kbn
					,	#TABLE_M2113.category2_cd
					,	#TABLE_M2113.category3_cd
					,	#TABLE_M2113.question_cd
					,	#TABLE_M2113.question
					,	#TABLE_M2113.arrange_order	
					,	#TABLE_M2113.cre_user		
					,	#TABLE_M2113.cre_ip			
					,	#TABLE_M2113.cre_prg			
					,	#TABLE_M2113.cre_datetime	
					,	@P_cre_user	
					,	@P_cre_ip
					,	'oM0110'	
					,	@w_time
					,	SPACE(0)
					,	SPACE(0)
					,	SPACE(0)
					,	NULL
					FROM #TABLE_M2113
					WHERE #TABLE_M2113.flg_mode	=	2
				END

				IF EXISTS(SELECT 1 FROM #TABLE_M2113 WHERE #TABLE_M2113.flg_mode = 1)
				BEGIN
					INSERT INTO M2113
					SELECT 
						@P_company_cd
					,	@P_category1_cd
					,	@P_refer_kbn
					,	#TABLE_M2113.category2_cd
					,	#TABLE_M2113.category3_cd
					,	#TABLE_M2113.row_id_question
					,	#TABLE_M2113.question
					,	NULL
					,	@P_cre_user	
					,	@P_cre_ip
					,	'oM0110'	
					,	@w_time
					,	SPACE(0)
					,	SPACE(0)
					,	SPACE(0)
					,	NULL
					,	SPACE(0)
					,	SPACE(0)
					,	SPACE(0)
					,	NULL
					FROM #TABLE_M2113
					WHERE #TABLE_M2113.flg_mode	= 1
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
	--
	DROP TABLE #DATA_TMP
	DROP TABLE #TABLE_M2111
	DROP TABLE #TABLE_M2112
	DROP TABLE #TABLE_M2113

END
GO