IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_mI1010_ACT3]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_mI1010_ACT3]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：mI1010 - IMPORT CSV
 *
 *  作成日  ：2021-01-06
 *  作成者  ：ANS-ASIA DUONGNTT
 *
 *  更新日  ：2021/04/20
 *  更新者  ：ANS-ASIA VIETDT
 *  更新内容：add update/delete table F3020
 *
 *  更新日  ：2021/06/10
 *  更新者  ：viettd
 *  更新内容：add check M0070.multireview_typ = 0 (マルチレビュー対象としない)
 *
 *  更新日  ：2021/07/21
 *  更新者  ：viettd
 *  更新内容：uppdate S0010.multireview_authority_typ
 *
 ****************************************************************************************************/
CREATE PROCEDURE [dbo].[SPC_mI1010_ACT3]
	-- Add the parameters for the stored procedure here
	@P_fiscal_year				SMALLINT			=	0
,	@P_json						NVARCHAR(max)		=	''
,	@P_exec_user				NVARCHAR(100)		=	''
,	@P_company_cd				SMALLINT			=	0	
,	@P_cre_user					NVARCHAR(50)		=	''
,	@P_cre_ip					NVARCHAR(50)		=	''
,	@P_no						INT					=	0
,	@P_count					INT					=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 	
		@w_time					DATETIME2			= SYSDATETIME()
	,	@order_by_min			INT					= 0
	,	@ERR_TBL				ERRTABLE	
		--
	,	@i						SMALLINT			=	1
	,	@w_COLUMN_NM			NVARCHAR(255)		=	''
	,	@w_ITEM_NM				NVARCHAR(255)		=	''
	,	@w_MAXLEN				INT					=	0
	,	@w_Str_SQL				NVARCHAR(MAX)		=	''
	--
	CREATE TABLE #TEMP(
		id						INT		IDENTITY(1,1)
	,	exec_user				NVARCHAR(100)
	,	company_cd				SMALLINT
	,	fiscal_year				SMALLINT
	,	employee_cd				NVARCHAR(10)
	,	supporter_cd1			NVARCHAR(10)
	,	supporter_cd2			NVARCHAR(10)
	,	supporter_cd3			NVARCHAR(10)
	,	supporter_cd4			NVARCHAR(10)
	,	supporter_cd5			NVARCHAR(10)
	,	supporter_cd6			NVARCHAR(10)
	,	supporter_cd7			NVARCHAR(10)
	,	supporter_cd8			NVARCHAR(10)
	,	supporter_cd9			NVARCHAR(10)
	,	supporter_cd10			NVARCHAR(10)
	,	supporter_cd11			NVARCHAR(10)
	,	supporter_cd12			NVARCHAR(10)
	,	supporter_cd13			NVARCHAR(10)
	,	supporter_cd14			NVARCHAR(10)
	,	supporter_cd15			NVARCHAR(10)
	,	supporter_cd16			NVARCHAR(10)
	,	supporter_cd17			NVARCHAR(10)
	,	supporter_cd18			NVARCHAR(10)
	,	supporter_cd19			NVARCHAR(10)
	,	supporter_cd20			NVARCHAR(10)
	,	supporter_cd21			NVARCHAR(10)
	,	supporter_cd22			NVARCHAR(10)
	,	supporter_cd23			NVARCHAR(10)
	,	supporter_cd24			NVARCHAR(10)
	,	supporter_cd25			NVARCHAR(10)
	,	supporter_cd26			NVARCHAR(10)
	,	supporter_cd27			NVARCHAR(10)
	,	supporter_cd28			NVARCHAR(10)
	,	supporter_cd29			NVARCHAR(10)
	,	supporter_cd30			NVARCHAR(10)
	)
	
	--
	CREATE TABLE #F3020(
		id						INT IDENTITY(1,1)
	,	employee_cd				NVARCHAR(10)
	,	supporter				NVARCHAR(50)
	,	supporter_cd			NVARCHAR(10)
	)

	--
	CREATE TABLE #CHECK_DUPLICATE(
		id						INT IDENTITY(1,1)
	,	item_nm					NVARCHAR(255)
	,	supporter_cd			NVARCHAR(10)
	,	flg_check				SMALLINT
	)

	--
	CREATE TABLE #CHECKLIST(
		ID						INT IDENTITY(1,1)
	,	COLUMN_NM				NVARCHAR(50)	
	,	ITEM_NM					NVARCHAR(255)
	,	MAXLEN					INT		
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
			CONCAT(@P_exec_user, CAST(@P_no AS NVARCHAR(10))) 
		,	@P_company_cd
		,	@P_fiscal_year
		,	RTRIM(LTRIM(employee_cd))	
		,	RTRIM(LTRIM(supporter_cd1))
		,	RTRIM(LTRIM(supporter_cd2))
		,	RTRIM(LTRIM(supporter_cd3))
		,	RTRIM(LTRIM(supporter_cd4))
		,	RTRIM(LTRIM(supporter_cd5))
		,	RTRIM(LTRIM(supporter_cd6))
		,	RTRIM(LTRIM(supporter_cd7))
		,	RTRIM(LTRIM(supporter_cd8))
		,	RTRIM(LTRIM(supporter_cd9))
		,	RTRIM(LTRIM(supporter_cd10))
		,	RTRIM(LTRIM(supporter_cd11))
		,	RTRIM(LTRIM(supporter_cd12))
		,	RTRIM(LTRIM(supporter_cd13))
		,	RTRIM(LTRIM(supporter_cd14))
		,	RTRIM(LTRIM(supporter_cd15))
		,	RTRIM(LTRIM(supporter_cd16))
		,	RTRIM(LTRIM(supporter_cd17))
		,	RTRIM(LTRIM(supporter_cd18))
		,	RTRIM(LTRIM(supporter_cd19))
		,	RTRIM(LTRIM(supporter_cd20))
		,	RTRIM(LTRIM(supporter_cd21))
		,	RTRIM(LTRIM(supporter_cd22))
		,	RTRIM(LTRIM(supporter_cd23))
		,	RTRIM(LTRIM(supporter_cd24))
		,	RTRIM(LTRIM(supporter_cd25))
		,	RTRIM(LTRIM(supporter_cd26))
		,	RTRIM(LTRIM(supporter_cd27))
		,	RTRIM(LTRIM(supporter_cd28))
		,	RTRIM(LTRIM(supporter_cd29))
		,	RTRIM(LTRIM(supporter_cd30))
		FROM OPENJSON(@P_json) WITH(
			employee_cd				NVARCHAR(10)
		,	supporter_cd1			NVARCHAR(10)
		,	supporter_cd2			NVARCHAR(10)
		,	supporter_cd3			NVARCHAR(10)
		,	supporter_cd4			NVARCHAR(10)
		,	supporter_cd5			NVARCHAR(10)
		,	supporter_cd6			NVARCHAR(10)
		,	supporter_cd7			NVARCHAR(10)
		,	supporter_cd8			NVARCHAR(10)
		,	supporter_cd9			NVARCHAR(10)
		,	supporter_cd10			NVARCHAR(10)
		,	supporter_cd11			NVARCHAR(10)
		,	supporter_cd12			NVARCHAR(10)
		,	supporter_cd13			NVARCHAR(10)
		,	supporter_cd14			NVARCHAR(10)
		,	supporter_cd15			NVARCHAR(10)
		,	supporter_cd16			NVARCHAR(10)
		,	supporter_cd17			NVARCHAR(10)
		,	supporter_cd18			NVARCHAR(10)
		,	supporter_cd19			NVARCHAR(10)
		,	supporter_cd20			NVARCHAR(10)
		,	supporter_cd21			NVARCHAR(10)
		,	supporter_cd22			NVARCHAR(10)
		,	supporter_cd23			NVARCHAR(10)
		,	supporter_cd24			NVARCHAR(10)
		,	supporter_cd25			NVARCHAR(10)
		,	supporter_cd26			NVARCHAR(10)
		,	supporter_cd27			NVARCHAR(10)
		,	supporter_cd28			NVARCHAR(10)
		,	supporter_cd29			NVARCHAR(10)
		,	supporter_cd30			NVARCHAR(10)
		)
		--VALIDATE REQUIRE employee_cd 
		INSERT INTO @ERR_TBL
		SELECT
			8				
		,	'employee_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	'対象社員名CD'	
		FROM #TEMP 
		WHERE
			LEN(#TEMP.employee_cd)	= 0

		--VALIDATE MAXLENGTH employee_cd 
		INSERT INTO @ERR_TBL
		SELECT
			28				
		,	'employee_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	'対象社員名CD'	
		FROM #TEMP 
		WHERE
			LEN(#TEMP.employee_cd)>10

		--CHECK MASTER employee_cd
		INSERT INTO @ERR_TBL
		SELECT
			21				
		,	'employee_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	'対象社員名CD'	
		FROM #TEMP 
		LEFT JOIN M0070 ON (
			#TEMP.company_cd	=	M0070.company_cd
		AND #TEMP.employee_cd	=	M0070.employee_cd
		AND M0070.del_datetime IS NULL
		)
		WHERE
			LEN(#TEMP.employee_cd)<=10
		AND LEN(#TEMP.employee_cd)> 0
		AND M0070.employee_cd IS NULL
		-- add by viettd 2021/06/10
		INSERT INTO @ERR_TBL
		SELECT
			145				
		,	'employee_cd'				
		,	0-- oderby		
		,	1-- dialog  	
		,	0				
		,	0				
		,	'対象社員名CD'	
		FROM #TEMP 
		LEFT JOIN M0070 ON (
			#TEMP.company_cd	=	M0070.company_cd
		AND #TEMP.employee_cd	=	M0070.employee_cd
		AND M0070.del_datetime IS NULL
		)
		WHERE
			LEN(#TEMP.employee_cd)	<=	10
		AND LEN(#TEMP.employee_cd)	>	0
		AND M0070.multireview_typ	=	0	-- マルチレビュー対象としない
		--
		INSERT INTO #F3020
		SELECT 
			employee_cd
		,	supporter
		,	supporter_cd
		FROM
			(SELECT 
				employee_cd
			,	supporter_cd1	
			,	supporter_cd2	
			,	supporter_cd3	
			,	supporter_cd4	
			,	supporter_cd5	
			,	supporter_cd6	
			,	supporter_cd7	
			,	supporter_cd8	
			,	supporter_cd9	
			,	supporter_cd10	
			,	supporter_cd11	
			,	supporter_cd12	
			,	supporter_cd13	
			,	supporter_cd14	
			,	supporter_cd15	
			,	supporter_cd16	
			,	supporter_cd17	
			,	supporter_cd18	
			,	supporter_cd19	
			,	supporter_cd20	
			,	supporter_cd21	
			,	supporter_cd22	
			,	supporter_cd23	
			,	supporter_cd24	
			,	supporter_cd25	
			,	supporter_cd26	
			,	supporter_cd27	
			,	supporter_cd28	
			,	supporter_cd29	
			,	supporter_cd30	
			FROM #TEMP) AS P
		UNPIVOT
			(supporter_cd FOR supporter IN(
				supporter_cd1	
			,	supporter_cd2	
			,	supporter_cd3	
			,	supporter_cd4	
			,	supporter_cd5	
			,	supporter_cd6	
			,	supporter_cd7	
			,	supporter_cd8	
			,	supporter_cd9	
			,	supporter_cd10
			,	supporter_cd11
			,	supporter_cd12
			,	supporter_cd13
			,	supporter_cd14
			,	supporter_cd15
			,	supporter_cd16
			,	supporter_cd17
			,	supporter_cd18
			,	supporter_cd19
			,	supporter_cd20
			,	supporter_cd21
			,	supporter_cd22
			,	supporter_cd23
			,	supporter_cd24
			,	supporter_cd25
			,	supporter_cd26
			,	supporter_cd27
			,	supporter_cd28
			,	supporter_cd29
			,	supporter_cd30
			))
		AS unpvt
		
		--VALIDATE REQUIRE: EXISTS AT LEAST 1 supporter_cd 
		IF NOT EXISTS(SELECT 1 FROM #F3020 WHERE #F3020.supporter_cd IS NOT NULL OR #F3020.supporter_cd <> '')
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				8				
			,	'supporter_cd'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	'サポーターコード'	
			FROM #TEMP 
		END

		--VALIDATE MAXLENGTH supporter_cd 
		SET @i = 1
		INSERT INTO #CHECKLIST
		VALUES	
			('supporter_cd1','サポーターCD1',10)	
		,	('supporter_cd2','サポーターCD2',10)	
		,	('supporter_cd3','サポーターCD3',10)	
		,	('supporter_cd4','サポーターCD4',10)	
		,	('supporter_cd5','サポーターCD5',10)	
		,	('supporter_cd6','サポーターCD6',10)	
		,	('supporter_cd7','サポーターCD7',10)	
		,	('supporter_cd8','サポーターCD8',10)	
		,	('supporter_cd9','サポーターCD9',10)	
		,	('supporter_cd10','サポーターCD10',10)
		,	('supporter_cd11','サポーターCD11',10)
		,	('supporter_cd12','サポーターCD12',10)
		,	('supporter_cd13','サポーターCD13',10)
		,	('supporter_cd14','サポーターCD14',10)
		,	('supporter_cd15','サポーターCD15',10)
		,	('supporter_cd16','サポーターCD16',10)
		,	('supporter_cd17','サポーターCD17',10)
		,	('supporter_cd18','サポーターCD18',10)
		,	('supporter_cd19','サポーターCD19',10)
		,	('supporter_cd20','サポーターCD20',10)
		,	('supporter_cd21','サポーターCD21',10)
		,	('supporter_cd22','サポーターCD22',10)
		,	('supporter_cd23','サポーターCD23',10)
		,	('supporter_cd24','サポーターCD24',10)
		,	('supporter_cd25','サポーターCD25',10)
		,	('supporter_cd26','サポーターCD26',10)
		,	('supporter_cd27','サポーターCD27',10)
		,	('supporter_cd28','サポーターCD28',10)
		,	('supporter_cd29','サポーターCD29',10)
		,	('supporter_cd30','サポーターCD30',10)				
		--
		WHILE @i <= 30
		BEGIN
			SELECT 
				@w_COLUMN_NM	=	COLUMN_NM
			,	@w_ITEM_NM		=	ITEM_NM
			,	@w_MAXLEN		=	MAXLEN
			FROM #CHECKLIST 
			WHERE 
				ID = @i
			--
			SET @w_Str_SQL	=	'SELECT
									28
								,	'''+CONVERT(NVARCHAR(50),@w_COLUMN_NM)+'''
								,	0			
								,	1
								,	0
								,	0
								,	'''+@w_ITEM_NM+'''
								FROM #TEMP 
								WHERE 
									LEN('+@w_COLUMN_NM+') >'+ CONVERT(NVARCHAR(10), @w_MAXLEN)
								
			INSERT INTO @ERR_TBL
			EXECUTE (@w_Str_SQL)
			--
			SET @i = @i + 1
		END
		
		--CHECK MASTER supporter_cd
		SET @i = 1
		WHILE @i <= 30
		BEGIN
			SELECT 
				@w_COLUMN_NM	=	COLUMN_NM
			,	@w_ITEM_NM		=	ITEM_NM
			,	@w_MAXLEN		=	MAXLEN
			FROM #CHECKLIST 
			WHERE 
				ID = @i
			--
			SET @w_Str_SQL	=	'SELECT
									21
								,	'''+CONVERT(NVARCHAR(50),@w_COLUMN_NM)+'''
								,	0			
								,	1
								,	0
								,	0
								,	'''+@w_ITEM_NM+'''
								FROM #TEMP 
								LEFT JOIN M0070 ON (
									#TEMP.company_cd		=	M0070.company_cd
								AND '+@w_COLUMN_NM+'		=	M0070.employee_cd
								AND M0070.del_datetime IS NULL
								)
								WHERE 
									M0070.employee_cd IS NULL
								AND	LEN('+@w_COLUMN_NM+') > 0
								AND	LEN('+@w_COLUMN_NM+') <='+ CONVERT(NVARCHAR(10), @w_MAXLEN)
								
			INSERT INTO @ERR_TBL
			EXECUTE (@w_Str_SQL)
			--
			SET @i = @i + 1
		END

		--CHECK DUPLICATE supporter_cd
		INSERT INTO #CHECK_DUPLICATE
		SELECT
			#CHECKLIST.ITEM_NM
		,	supporter_cd			
		,	COUNT(1) OVER (PARTITION BY supporter_cd)		
		FROM #F3020
		LEFT JOIN #CHECKLIST ON (
			#F3020.supporter	=	#CHECKLIST.COLUMN_NM
		)
		WHERE
			supporter_cd <> ''

		--
		IF EXISTS(SELECT 1 FROM #CHECK_DUPLICATE WHERE flg_check > 1)
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				32				
			,	'supporter_cd'				
			,	0-- oderby		
			,	1-- dialog  	
			,	0				
			,	0				
			,	#CHECK_DUPLICATE.item_nm	
			FROM #CHECK_DUPLICATE
			WHERE 
				flg_check > 1 
		END

		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- PROCESS
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- Chỗ này dùng để viết code xử lý dữ liệu sau khi validate xong
		--INSERT WRK_F3020 supporter_cd <> ''
		IF NOT EXISTS(SELECT 1 FROM @ERR_TBL)
		BEGIN
			--
			DELETE W FROM WRK_F3020 AS W LEFT JOIN  #TEMP AS T ON W.company_cd = @P_company_cd AND W.exec_user = T.exec_user  WHERE T.company_cd IS NOT NULL
			--
			INSERT INTO WRK_F3020 
			SELECT 
				CONCAT(#TEMP.exec_user,#F3020.supporter_cd)
			,	#TEMP.company_cd
			,	#TEMP.fiscal_year			
			,	#F3020.employee_cd			
			,	#F3020.supporter_cd		
			,	0	
			,	@P_cre_user			
			,	@P_cre_ip	
			,	'MI1010 '		
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			FROM #F3020
			LEFT JOIN #TEMP ON (
				#F3020.employee_cd	=	#TEMP.employee_cd
			)
			WHERE 
				#F3020.supporter_cd <> ''
			OR	#F3020.id = 1					--get data employee_cd has supporter_cd = ''	--add by vietdt 2021/04/20
		END
		ELSE
		BEGIN
			--
			INSERT INTO WRK_F3020 
			SELECT 
				CONCAT('WRK_F3020_', CAST(@P_no AS NVARCHAR(10)))	
			,	0													
			,	0													
			,	''													
			,	''													
			,	0													
			,	@P_cre_user											
			,	@P_cre_ip											
			,	'MI1010 '												
			,	@w_time												
			,	SPACE(0)											
			,	SPACE(0)											
			,	SPACE(0)											
			,	NULL												
			,	SPACE(0)											
			,	SPACE(0)											
			,	SPACE(0)											
			,	NULL												
		END
		IF (@P_no = @P_count) 
		BEGIN
			--
			IF (EXISTS(SELECT 1 FROM @ERR_TBL) OR EXISTS(SELECT 1 FROM WRK_F3020 WHERE exec_user LIKE '%WRK_F3020%'))
			BEGIN
				TRUNCATE TABLE WRK_F3020
				--
				GOTO COMPLETE_QUERY
			END
			--add by vietdt 2021/04/20
			--DELETE F3020
			DELETE F3020
			FROM F3020 
			LEFT JOIN WRK_F3020 ON (
				F3020.company_cd	=	WRK_F3020.company_cd		
			AND	F3020.fiscal_year	=	WRK_F3020.fiscal_year		
			AND	F3020.employee_cd	=	WRK_F3020.employee_cd	
			AND	F3020.supporter_cd	=	WRK_F3020.supporter_cd
			AND F3020.del_datetime IS NULL
			)INNER JOIN (
				SELECT 
					WRK_F3020.company_cd
				,	WRK_F3020.fiscal_year
				,	WRK_F3020.employee_cd
				FROM WRK_F3020
				GROUP BY
					WRK_F3020.company_cd
				,	WRK_F3020.fiscal_year
				,	WRK_F3020.employee_cd
			) AS #WRK_F3020_employee_cd ON (
					F3020.company_cd	=	#WRK_F3020_employee_cd.company_cd		
				AND	F3020.fiscal_year	=	#WRK_F3020_employee_cd.fiscal_year		
				AND	F3020.employee_cd	=	#WRK_F3020_employee_cd.employee_cd	
			)
			WHERE
				F3020.company_cd		=	@P_company_cd
			AND	F3020.fiscal_year		=	@P_fiscal_year
			AND	WRK_F3020.company_cd	IS NULL
			--UPDATE F3020
			UPDATE	F3020
			SET
				F3020.upd_user		=	@P_cre_user
			,	F3020.upd_ip		=	@P_cre_ip
			,	F3020.upd_prg		=	'MI1010 '
			,	F3020.upd_datetime	=	@w_time
			FROM F3020
			INNER JOIN WRK_F3020 ON (
				F3020.company_cd	=	WRK_F3020.company_cd		
			AND	F3020.fiscal_year	=	WRK_F3020.fiscal_year		
			AND	F3020.employee_cd	=	WRK_F3020.employee_cd	
			AND	F3020.supporter_cd	=	WRK_F3020.supporter_cd
			AND F3020.del_datetime IS NULL
			)
			--add by vietdt 2021/04/20
			--INSERT F3020
			INSERT INTO F3020
			SELECT 
				WRK_F3020.company_cd
			,	WRK_F3020.fiscal_year	
			,	WRK_F3020.employee_cd	
			,	WRK_F3020.supporter_cd	
			,	WRK_F3020.other_browsing_kbn
			,	@P_cre_user			
			,	@P_cre_ip	
			,	'MI1010 '		
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			FROM WRK_F3020
			LEFT JOIN F3020 ON (
				WRK_F3020.company_cd	=	F3020.company_cd	
			AND WRK_F3020.fiscal_year	=	F3020.fiscal_year		
			AND WRK_F3020.employee_cd	=	F3020.employee_cd
			AND WRK_F3020.supporter_cd	=	F3020.supporter_cd
			AND F3020.del_datetime IS NULL
			)
			WHERE 
				F3020.supporter_cd IS NULL	
			AND	WRK_F3020.supporter_cd <> ''	--add by vietdt 2021/04/20
			-- edited by viettd 2021/07/21
			-- UPDATE S0010 WHEN SUPPORTER
			UPDATE S0010 SET
				S0010.multireview_authority_typ		=	2
			,	S0010.upd_user						=	@P_cre_user
			,	S0010.upd_ip						=	@P_cre_ip
			,	S0010.upd_prg						=	'MI1010 '
			,	S0010.upd_datetime					=	@w_time
			FROM S0010
			INNER JOIN WRK_F3020 ON (
				S0010.company_cd	=	WRK_F3020.company_cd
			AND S0010.employee_cd	=	WRK_F3020.supporter_cd	
			)
			WHERE 
				S0010.del_datetime IS NULL
			AND S0010.multireview_authority_typ		<	2
			-- end edited by viettd 2021/07/21
			TRUNCATE TABLE WRK_F3020
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

	--
	DROP TABLE #TEMP
	DROP TABLE #F3020
	DROP TABLE #CHECKLIST
END
GO
