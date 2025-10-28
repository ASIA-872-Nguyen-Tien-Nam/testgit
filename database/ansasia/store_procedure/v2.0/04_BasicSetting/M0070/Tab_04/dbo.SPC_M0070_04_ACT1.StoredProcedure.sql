DROP PROCEDURE [SPC_M0070_04_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	M0070_業務経歴
--*  
--* 作成日/create date			:												
--*	作成者/creater				:						
--*   					
--*	更新日/update date			:  					
--*	更新者/updater				:　 　								     	 
--*	更新内容/update content		:	　	
--* 
--****************************************************************************************
CREATE PROCEDURE [SPC_M0070_04_ACT1] 
	-- Add the parameters for the stored procedure here
	@P_json			NVARCHAR(max)	=	N''
	-- common
,	@P_cre_user		NVARCHAR(50)	=	N''
,	@P_cre_ip		NVARCHAR(50)	=	N''
,	@P_company_cd	SMALLINT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			INT					=	0
	,	@employee_cd			NVARCHAR(20)
	,	@w_max_1				INT					=	0
	,	@w_max_2				INT					=	0
	
	CREATE TABLE #TBL_M0077_HEAD(
		id_head						INT NOT NULL IDENTITY(1,1) 							
	,	detail_no					SMALLINT
	,	work_history_kbn			SMALLINT
	,	check_new_row				SMALLINT
	)

	CREATE TABLE #TBL_M0077(
		numeric_value1				INT
	,	item_id						SMALLINT
	,	date_from					DATE
	,	date_to						DATE
	,	text_item					NVARCHAR(150)
	,	select_item					SMALLINT
	,	number_item					NUMERIC(10,2)
	,	work_history_kbn			SMALLINT
	,	check_new_row				SMALLINT
	)

	CREATE TABLE #TBL_M0077_NEW(
		id							INT NOT NULL IDENTITY(1,1) 		
	,	work_history_kbn			SMALLINT
	,	check_new_row				SMALLINT
	)

	-- DATA TABLE JSON
	INSERT INTO #TBL_M0077_HEAD
	SELECT
		ISNULL(detail_no, 0)
	,	ISNULL(work_history_kbn, 0)
	,	ISNULL(check_new_row, 0)
	FROM OPENJSON(@P_json,'$.detail') WITH(
		detail_no					SMALLINT
	,	work_history_kbn			SMALLINT
	,	check_new_row				SMALLINT
	) AS json_table
	ORDER BY json_table.check_new_row DESC


	INSERT INTO #TBL_M0077
	SELECT
		ISNULL(numeric_value1, 0)
	,	ISNULL(item_id, 0)
	,	IIF(date_from = '',NULL,date_from)
	,	IIF(date_to = '',NULL,date_to)
	,	ISNULL(text_item, N'')
	,	IIF(ISNULL(select_item, 0) = -1,0,ISNULL(select_item, 0))
	,	IIF(number_item = '',NULL,REPLACE(number_item,',',''))
	,	ISNULL(work_history_kbn, 0)
	,	ISNULL(check_new_row, 0)
	FROM OPENJSON(@P_json,'$.list1_tab_04') WITH(
		numeric_value1				INT
	,	item_id						SMALLINT
	,	date_from					DATE
	,	date_to						DATE
	,	text_item					NVARCHAR(150)
	,	select_item					SMALLINT
	,	number_item					NVARCHAR(12)
	,	work_history_kbn			SMALLINT
	,	check_new_row				SMALLINT
	) AS json_table
	ORDER BY json_table.check_new_row DESC

	-- check row not full blank
	INSERT INTO #TBL_M0077_NEW
	SELECT
		#TBL_M0077.work_history_kbn	
	,	#TBL_M0077.check_new_row
	FROM #TBL_M0077_HEAD
	LEFT JOIN #TBL_M0077 ON (
		#TBL_M0077_HEAD.work_history_kbn = #TBL_M0077.work_history_kbn
	AND	#TBL_M0077_HEAD.check_new_row = #TBL_M0077.check_new_row
	)
	WHERE
		#TBL_M0077_HEAD.detail_no = 0
	AND NOT (
			#TBL_M0077.date_from IS NULL
		AND #TBL_M0077.date_to IS NULL
		AND #TBL_M0077.text_item LIKE N''
		AND	#TBL_M0077.select_item = 0
		AND #TBL_M0077.number_item = 0
	)	
	GROUP BY #TBL_M0077.work_history_kbn, #TBL_M0077.check_new_row
	ORDER BY #TBL_M0077.check_new_row DESC

	INSERT INTO @ERR_TBL
	SELECT
		24
	,	N'.date_from' 
	,	0-- oderby
	,	0-- dialog  
	,	#TBL_M0077.check_new_row
	,	0
	,	N'error date_from'
	FROM #TBL_M0077
	LEFT JOIN #TBL_M0077_NEW ON (
		#TBL_M0077_NEW.work_history_kbn = #TBL_M0077.work_history_kbn
	AND	#TBL_M0077_NEW.check_new_row = #TBL_M0077.check_new_row
	)
	WHERE 
		#TBL_M0077.date_from IS NOT NULL
	AND	#TBL_M0077.date_to IS NOT NULL
	AND #TBL_M0077.date_from > #TBL_M0077.date_to

	INSERT INTO @ERR_TBL
	SELECT
		24
	,	N'.date_to' 
	,	0-- oderby
	,	0-- dialog  
	,	#TBL_M0077.check_new_row
	,	0
	,	N'error date_to'
	FROM #TBL_M0077
	LEFT JOIN #TBL_M0077_NEW ON (
		#TBL_M0077_NEW.work_history_kbn = #TBL_M0077.work_history_kbn
	AND	#TBL_M0077_NEW.check_new_row = #TBL_M0077.check_new_row
	)
	WHERE 
		#TBL_M0077.date_from IS NOT NULL
	AND	#TBL_M0077.date_to IS NOT NULL
	AND #TBL_M0077.date_from > #TBL_M0077.date_to

	INSERT INTO @ERR_TBL
	SELECT
		8
	,	N'.date_to' 
	,	0-- oderby
	,	0-- dialog  
	,	#TBL_M0077.check_new_row
	,	0
	,	N'error date_to'
	FROM #TBL_M0077
	LEFT JOIN #TBL_M0077_NEW ON (
		#TBL_M0077_NEW.work_history_kbn = #TBL_M0077.work_history_kbn
	AND	#TBL_M0077_NEW.check_new_row = #TBL_M0077.check_new_row
	)
	WHERE 
		#TBL_M0077.date_from IS NOT NULL
	AND	#TBL_M0077.date_to IS NULL

	INSERT INTO @ERR_TBL
	SELECT
		8
	,	N'.date_from' 
	,	0-- oderby
	,	0-- dialog  
	,	#TBL_M0077.check_new_row
	,	0
	,	N'error date_from'
	FROM #TBL_M0077
	LEFT JOIN #TBL_M0077_NEW ON (
		#TBL_M0077_NEW.work_history_kbn = #TBL_M0077.work_history_kbn
	AND	#TBL_M0077_NEW.check_new_row = #TBL_M0077.check_new_row
	)
	WHERE 
		#TBL_M0077.date_from IS NULL
	AND	#TBL_M0077.date_to IS NOT NULL

	--SELECT * FROM #TBL_M0077_HEAD
	--SELECT * FROM #TBL_M0077
	--SELECT * FROM #TBL_M0077_NEW
	-- START TRANSACTION5
	BEGIN TRANSACTION
	BEGIN TRY
		SET @employee_cd			=	JSON_VALUE(@P_json,'$.employee_cd')

		SELECT 
			@w_max_1 =	ISNULL(MAX(M0077.detail_no), 0)
		FROM M0077
		WHERE
			M0077.company_cd            = @P_company_cd
		AND M0077.employee_cd			= @employee_cd
		AND M0077.work_history_kbn		= 1

		SELECT 
			@w_max_2 =	ISNULL(MAX(M0077.detail_no), 0)
		FROM M0077
		WHERE
			M0077.company_cd            = @P_company_cd
		AND M0077.employee_cd			= @employee_cd
		AND M0077.work_history_kbn		= 2

		IF NOT EXISTS (SELECT 1 FROM @ERR_TBL)
		BEGIN
			-- del item no
			UPDATE M0077
			SET
				del_user		=	@P_cre_user
			,	del_ip			=	@P_cre_ip
			,	del_prg			=	N'M0070'
			,	del_datetime	=	@w_time
			FROM M0077
			LEFT JOIN #TBL_M0077_HEAD ON (
				M0077.work_history_kbn		= #TBL_M0077_HEAD.work_history_kbn
			AND	M0077.detail_no				= #TBL_M0077_HEAD.detail_no
			AND	M0077.company_cd		    = @P_company_cd
			AND	M0077.employee_cd		    = @employee_cd
			)
			LEFT JOIN #TBL_M0077 ON (
				#TBL_M0077.work_history_kbn = #TBL_M0077_HEAD.work_history_kbn
			AND	#TBL_M0077.check_new_row = #TBL_M0077_HEAD.check_new_row
			AND	#TBL_M0077.item_id = M0077.item_id
			AND	#TBL_M0077_HEAD.detail_no <> 0
			)
			WHERE
				M0077.del_datetime IS NULL
			AND	#TBL_M0077.item_id IS NULL
			AND	M0077.company_cd            = @P_company_cd
			AND M0077.employee_cd			= @employee_cd

			--update item in DB and screen
			UPDATE M0077 
			SET
				date_from						= IIF(#TBL_M0077.numeric_value1 = 1,#TBL_M0077.date_from,NULL)	
			,	date_to							= IIF(#TBL_M0077.numeric_value1 = 1,#TBL_M0077.date_to,NULL)	
			,	text_item						= IIF(#TBL_M0077.numeric_value1 = 2 OR #TBL_M0077.numeric_value1 = 3 OR #TBL_M0077.numeric_value1 = 4,#TBL_M0077.text_item,'')
			,	select_item						= IIF(#TBL_M0077.numeric_value1 = 5,#TBL_M0077.select_item,0)
			,	number_item						= IIF(#TBL_M0077.numeric_value1 = 6,#TBL_M0077.number_item,0)
			,	upd_user						= @P_cre_user
			,	upd_ip							= @P_cre_ip
			,	upd_prg							= N'M0070'
			,	upd_datetime					= @w_time
			,	del_user						= N''
			,	del_ip							= N''
			,	del_prg							= N''
			,	del_datetime					= NULL
			FROM #TBL_M0077
			INNER JOIN #TBL_M0077_HEAD ON (
				#TBL_M0077.work_history_kbn = #TBL_M0077_HEAD.work_history_kbn
			AND	#TBL_M0077.check_new_row = #TBL_M0077_HEAD.check_new_row
			AND	#TBL_M0077_HEAD.detail_no <> 0
			)
			INNER JOIN M0077 ON (
				M0077.work_history_kbn		= #TBL_M0077.work_history_kbn
			AND	M0077.detail_no				= #TBL_M0077_HEAD.detail_no
			AND	M0077.item_id				= #TBL_M0077.item_id
			)
			WHERE
				M0077.company_cd            = @P_company_cd
			AND M0077.employee_cd			= @employee_cd

			----insert item new in screen em0020
			INSERT INTO M0077 
			SELECT
				@P_company_cd
			,	@employee_cd
			,	#TBL_M0077.work_history_kbn
			,	#TBL_M0077_HEAD.detail_no					
			,	#TBL_M0077.item_id	
			,	IIF(#TBL_M0077.numeric_value1 = 1,#TBL_M0077.date_from,NULL)	
			,	IIF(#TBL_M0077.numeric_value1 = 1,#TBL_M0077.date_to,NULL)	
			,	IIF(#TBL_M0077.numeric_value1 = 2 OR #TBL_M0077.numeric_value1 = 3 OR #TBL_M0077.numeric_value1 = 4,#TBL_M0077.text_item,'')
			,	IIF(#TBL_M0077.numeric_value1 = 5,#TBL_M0077.select_item,0)
			,	IIF(#TBL_M0077.numeric_value1 = 6,#TBL_M0077.number_item,0)
			,	@P_cre_user							--,[cre_user]
			,	@P_cre_ip							--,[cre_ip]
			,	N'M0070'							--,[cre_prg]
			,	@w_time								--,[cre_datetime]
			,	N''									--,[upd_user]
			,	N''									--,[upd_ip]
			,	N''									--,[upd_prg]
			,	NULL								--,[upd_datetime]
			,	N''									--,[del_user]
			,	N''									--,[del_ip]
			,	N''									--,[del_prg]
			,	NULL								--,[del_datetime]
			FROM #TBL_M0077
			INNER JOIN #TBL_M0077_HEAD ON (
				#TBL_M0077.work_history_kbn = #TBL_M0077_HEAD.work_history_kbn
			AND	#TBL_M0077.check_new_row = #TBL_M0077_HEAD.check_new_row
			AND	#TBL_M0077_HEAD.detail_no <> 0
			)
			LEFT JOIN M0077 ON (
			M0077.company_cd    = @P_company_cd
			AND M0077.employee_cd	= @employee_cd
			AND	M0077.work_history_kbn		= #TBL_M0077.work_history_kbn
			AND	M0077.detail_no				= #TBL_M0077_HEAD.detail_no
			AND	M0077.item_id				= #TBL_M0077.item_id
			)
			WHERE
				M0077.company_cd    IS NULL
			AND M0077.employee_cd	IS NULL
			AND M0077.detail_no	IS NULL
			AND M0077.item_id	IS NULL


			----insert detail no
			INSERT INTO M0077 
			SELECT 
				@P_company_cd
			,	@employee_cd
			,	#TBL_M0077.work_history_kbn
			,	#TBL_M0077_NEW.id + IIF(#TBL_M0077_NEW.work_history_kbn = 1,@w_max_1,@w_max_2)					
			,	#TBL_M0077.item_id	
			,	IIF(#TBL_M0077.numeric_value1 = 1,#TBL_M0077.date_from,NULL)	
			,	IIF(#TBL_M0077.numeric_value1 = 1,#TBL_M0077.date_to,NULL)	
			,	IIF(#TBL_M0077.numeric_value1 = 2 OR #TBL_M0077.numeric_value1 = 3 OR #TBL_M0077.numeric_value1 = 4,#TBL_M0077.text_item,'')
			,	IIF(#TBL_M0077.numeric_value1 = 5,#TBL_M0077.select_item,0)
			,	IIF(#TBL_M0077.numeric_value1 = 6,#TBL_M0077.number_item,0)
			,	@P_cre_user							--,[cre_user]
			,	@P_cre_ip							--,[cre_ip]
			,	N'M0070'							--,[cre_prg]
			,	@w_time								--,[cre_datetime]
			,	N''									--,[upd_user]
			,	N''									--,[upd_ip]
			,	N''									--,[upd_prg]
			,	NULL								--,[upd_datetime]
			,	N''									--,[del_user]
			,	N''									--,[del_ip]
			,	N''									--,[del_prg]
			,	NULL								--,[del_datetime]
			FROM #TBL_M0077
			INNER JOIN #TBL_M0077_NEW ON (
				#TBL_M0077.work_history_kbn = #TBL_M0077_NEW.work_history_kbn
			AND	#TBL_M0077.check_new_row = #TBL_M0077_NEW.check_new_row
			)
			INNER JOIN #TBL_M0077_HEAD ON (
				#TBL_M0077.work_history_kbn = #TBL_M0077_HEAD.work_history_kbn
			AND	#TBL_M0077.check_new_row = #TBL_M0077_HEAD.check_new_row
			AND	#TBL_M0077_HEAD.detail_no = 0
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

	DROP TABLE IF EXISTS #TBL_M0077
	DROP TABLE IF EXISTS #TBL_M0077_HEAD
	DROP TABLE IF EXISTS #TBL_M0077_NEW
END


GO
