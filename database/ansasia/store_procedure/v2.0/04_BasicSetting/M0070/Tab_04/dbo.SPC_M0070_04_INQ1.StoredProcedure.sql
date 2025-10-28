DROP PROCEDURE [SPC_M0070_04_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ 
--* EXEC SPC_M0070_04_INQ1 '5', '740', '721'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	M0070_04
--*  
--*  作成日/create date			:						
--*　作成者/creater				:									
--*	
--****************************************************************************************
CREATE PROCEDURE [SPC_M0070_04_INQ1]
	-- Add the parameters for the stored procedure here	
	@P_employee_cd			NVARCHAR(10)	=	N''
,	@P_company_cd			SMALLINT		=	0
,	@P_user_id				NVARCHAR(100)	=	N''
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE
		@w_sql	nvarchar(max) = ''
	,	@w_str nvarchar(200) = ''
	,	@w_i								int				=	1
	,	@w_cnt								int				=	0
	,	@w_i_2								int				=	1
	,	@w_cnt_2							int				=	0
	,	@w_detail_no						SMALLINT		
	,	@w_detail_no_2						SMALLINT


	CREATE TABLE #TABLE_M5020(
		work_history_kbn			SMALLINT
	,	item_id						SMALLINT
	,	numeric_value2				INT
	,	numeric_value1				INT
	,	item_title					NVARCHAR(50)
	,	item_display_kbn			SMALLINT
	,	item_arrangement_column		SMALLINT
	,	item_arrangement_line		SMALLINT
	,	detail_no					SMALLINT
	,	date_from					VARCHAR(10)
	,	date_to						VARCHAR(10)
	,	text_item					NVARCHAR(150)
	,	select_item					SMALLINT
	,	number_item					NUMERIC(10,2)
	,	combobox					NVARCHAR(MAX)
	)

	CREATE TABLE #M5020_REQ (
		row_count  int  
	,	detail_no	smallint
	,	work_history_kbn			SMALLINT
	,	item_id		smallint
	,	detail_json	nvarchar(max)
	)

	CREATE TABLE #M0077_DETAIL_1 (
		id					int			identity(1,1)
	,	detail_no			smallint
	)

	CREATE TABLE #M0077_DETAIL_2 (
		id					int			identity(1,1)
	,	detail_no			smallint
	)

	-- detail no work 1
	INSERT INTO #M0077_DETAIL_1
	SELECT
	 M0077.detail_no
	FROM M0077
	WHERE 
		M0077.company_cd	= @P_company_cd
	AND	M0077.employee_cd	= @P_employee_cd
	AND M0077.work_history_kbn =  1
	AND M0077.del_datetime IS NULL
	GROUP BY 
		 M0077.detail_no


	-- detail no work 2
	INSERT INTO #M0077_DETAIL_2
	SELECT
	 M0077.detail_no
	FROM M0077
	WHERE 
		M0077.company_cd	= @P_company_cd
	AND	M0077.employee_cd	= @P_employee_cd
	AND M0077.work_history_kbn =  2
	AND M0077.del_datetime IS NULL
	GROUP BY 
		 M0077.detail_no

	INSERT INTO #TABLE_M5020
	SELECT
			M5020.work_history_kbn					AS work_history_kbn
		,	M5020.item_id							AS item_id
		,	L0010.numeric_value2					AS numeric_value2
		,	L0010.numeric_value1					AS numeric_value1
		,	M5020.item_title						AS item_title
		,	M5020.item_display_kbn					AS item_display_kbn
		,	M5020.item_arrangement_column			AS item_arrangement_column
		,	M5020.item_arrangement_line				AS item_arrangement_line
		,	ISNULL(M0077.detail_no,0)				AS	detail_no
		,	ISNULL( CONVERT(VARCHAR(10), M0077.date_from, 111), NULL)	AS	date_from
		,	ISNULL( CONVERT(VARCHAR(10), M0077.date_to, 111), NULL)	AS	date_to	
		,	M0077.text_item
		,	M0077.select_item
		,	M0077.number_item
		,	(
				SELECT
					M5021.arrange_order								AS arrange_order
				,	M5021.selected_items_no							AS selected_items_no
				,	M5021.selected_items_nm							AS selected_items_nm
				FROM M5021
				WHERE
					M5021.company_cd		=	@P_company_cd
				AND	M5021.work_history_kbn	=	M5020.work_history_kbn
				AND	M5021.item_id			=	M5020.item_id
				AND M5021.del_datetime	IS NULL
				ORDER BY arrange_order,selected_items_no
				FOR JSON PATH
			)													AS	combobox
		FROM M5020
		INNER JOIN M0077 ON (		
			M0077.work_history_kbn	= M5020.work_history_kbn
		AND	M0077.company_cd	= @P_company_cd
		AND	M0077.employee_cd	= @P_employee_cd
		AND	M0077.item_id	= M5020.item_id
		AND M0077.del_datetime IS NULL
		)
		LEFT JOIN L0010 ON(
			M5020.item_id	=	L0010.number_cd
		AND	78				=	L0010.name_typ
		AND L0010.del_datetime IS NULL
		)
		WHERE
			M5020.company_cd		=	@P_company_cd
		AND M5020.del_datetime IS NULL

	-- insert item no has M0077
	SET @w_cnt = IIF((SELECT COUNT(1) FROM #M0077_DETAIL_1) = 0, 1, (SELECT COUNT(1) FROM #M0077_DETAIL_1))
	WHILE @w_i <= @w_cnt
	BEGIN
		SELECT 
			@w_detail_no = #M0077_DETAIL_1.detail_no
		FROM #M0077_DETAIL_1
		WHERE 
			#M0077_DETAIL_1.id = @w_i

		INSERT INTO #TABLE_M5020
		SELECT	
			M5020.work_history_kbn					AS work_history_kbn
		,	M5020.item_id							AS item_id
		,	L0010.numeric_value2					AS numeric_value2
		,	L0010.numeric_value1					AS numeric_value1
		,	M5020.item_title						AS item_title
		,	M5020.item_display_kbn					AS item_display_kbn
		,	M5020.item_arrangement_column			AS item_arrangement_column
		,	M5020.item_arrangement_line				AS item_arrangement_line
		,	ISNULL(@w_detail_no,0)					AS	detail_no
		,	ISNULL( CONVERT(VARCHAR(10), M0077.date_from, 111), NULL)	AS	date_from
		,	ISNULL( CONVERT(VARCHAR(10), M0077.date_to, 111), NULL)	AS	date_to	
		,	M0077.text_item
		,	M0077.select_item
		,	M0077.number_item
		,	(
				SELECT
					M5021.arrange_order								AS arrange_order
				,	M5021.selected_items_no							AS selected_items_no
				,	M5021.selected_items_nm							AS selected_items_nm
				FROM M5021
				WHERE
					M5021.company_cd		=	@P_company_cd
				AND	M5021.work_history_kbn	=	M5020.work_history_kbn
				AND	M5021.item_id			=	M5020.item_id
				AND M5021.del_datetime	IS NULL
				ORDER BY arrange_order,selected_items_no
				FOR JSON PATH
			)													AS	combobox
		FROM M5020
		LEFT JOIN M0077 ON (		
			M0077.work_history_kbn	= M5020.work_history_kbn
		AND	M0077.company_cd	= @P_company_cd
		AND	M0077.employee_cd	= @P_employee_cd
		AND	M0077.item_id	= M5020.item_id
		AND M0077.del_datetime IS NULL
		)
		LEFT JOIN L0010 ON(
			M5020.item_id	=	L0010.number_cd
		AND	78				=	L0010.name_typ
		AND L0010.del_datetime IS NULL
		)
		WHERE
			M5020.company_cd		=	@P_company_cd
		AND M5020.work_history_kbn = 1
		AND M5020.del_datetime IS NULL
		AND M0077.detail_no IS NULL
		AND M0077.item_id IS NULL
	SET @w_i = @w_i + 1
	END

	SET @w_cnt_2 =  IIF((SELECT COUNT(1) FROM #M0077_DETAIL_2) = 0, 1, (SELECT COUNT(1) FROM #M0077_DETAIL_2))
	WHILE @w_i_2 <= @w_cnt_2
	BEGIN
		SELECT 
			@w_detail_no_2 = #M0077_DETAIL_2.detail_no
		FROM #M0077_DETAIL_2
		WHERE 
			#M0077_DETAIL_2.id = @w_i_2

		INSERT INTO #TABLE_M5020
		SELECT	
			M5020.work_history_kbn					AS work_history_kbn
		,	M5020.item_id							AS item_id
		,	L0010.numeric_value2					AS numeric_value2
		,	L0010.numeric_value1					AS numeric_value1
		,	M5020.item_title						AS item_title
		,	M5020.item_display_kbn					AS item_display_kbn
		,	M5020.item_arrangement_column			AS item_arrangement_column
		,	M5020.item_arrangement_line				AS item_arrangement_line
		,	ISNULL(@w_detail_no_2,0)					AS	detail_no
		,	ISNULL( CONVERT(VARCHAR(10), M0077.date_from, 111), NULL)	AS	date_from
		,	ISNULL( CONVERT(VARCHAR(10), M0077.date_to, 111), NULL)	AS	date_to	
		,	M0077.text_item
		,	M0077.select_item
		,	M0077.number_item
		,	(
				SELECT
					M5021.arrange_order								AS arrange_order
				,	M5021.selected_items_no							AS selected_items_no
				,	M5021.selected_items_nm							AS selected_items_nm
				FROM M5021
				WHERE
					M5021.company_cd		=	@P_company_cd
				AND	M5021.work_history_kbn	=	M5020.work_history_kbn
				AND	M5021.item_id			=	M5020.item_id
				AND M5021.del_datetime	IS NULL
				ORDER BY arrange_order,selected_items_no
				FOR JSON PATH
			)													AS	combobox
		FROM M5020
		LEFT JOIN M0077 ON (		
			M0077.work_history_kbn	= M5020.work_history_kbn
		AND	M0077.company_cd	= @P_company_cd
		AND	M0077.employee_cd	= @P_employee_cd
		AND	M0077.item_id	= M5020.item_id
		AND M0077.del_datetime IS NULL
		)
		LEFT JOIN L0010 ON(
			M5020.item_id	=	L0010.number_cd
		AND	78				=	L0010.name_typ
		AND L0010.del_datetime IS NULL
		)
		WHERE
			M5020.company_cd		=	@P_company_cd
		AND M5020.work_history_kbn = 2
		AND M5020.del_datetime IS NULL
		AND M0077.detail_no IS NULL
		AND M0077.item_id IS NULL
	SET @w_i_2 = @w_i_2 + 1
	END

		
	INSERT INTO #M5020_REQ
	SELECT 
		ROW_NUMBER() OVER
		(PARTITION BY #TABLE_M5020.detail_no,#TABLE_M5020.work_history_kbn ORDER BY 
		#TABLE_M5020.detail_no			ASC
	,	#TABLE_M5020.item_display_kbn			DESC
	,	#TABLE_M5020.item_arrangement_line		ASC
	,	#TABLE_M5020.item_arrangement_column	ASC)
	,	#TABLE_M5020.detail_no
	,	#TABLE_M5020.work_history_kbn
	,	#TABLE_M5020.item_id
	,	(
		SELECT *
		FROM #TABLE_M5020 AS S
		WHERE
			S.item_id	=	#TABLE_M5020.item_id
		AND S.detail_no	=	#TABLE_M5020.detail_no
		AND S.work_history_kbn	=	#TABLE_M5020.work_history_kbn
		FOR JSON PATH
	) 
	FROM #TABLE_M5020
	ORDER BY 
		#TABLE_M5020.detail_no			ASC
	,	#TABLE_M5020.item_display_kbn			DESC
	,	#TABLE_M5020.item_arrangement_line		ASC
	,	#TABLE_M5020.item_arrangement_column	ASC

	UPDATE #M5020_REQ SET 
		row_count				=		row_count + 2			
	WHERE 
		#M5020_REQ.row_count >= 20			

	SELECT @w_str = stuff((select ', ['+ cast((number_cd) as nvarchar(10))+']'
								 from L0010
								 where 
									L0010.name_typ = 78
								 for xml path('')),1,1,'')
	
	SET @w_sql = '
		SELECT 
			detail_no
		,'+@w_str+'
		FROM 
		(
			SELECT 
				#M5020_REQ.row_count		AS	row_count
			,	#M5020_REQ.detail_no		AS	detail_no
			,	#M5020_REQ.detail_json		AS	detail_json
			FROM #M5020_REQ
			WHERE #M5020_REQ.work_history_kbn = 1
		) AS P
		Pivot(MAX(detail_json) FOR row_count IN ('+@w_str+')) AS A
		ORDER BY 
			A.detail_no			DESC


		SELECT 
			detail_no
		,'+@w_str+'
		FROM 
		(
			SELECT 
				#M5020_REQ.row_count		AS	row_count
			,	#M5020_REQ.detail_no		AS	detail_no
			,	#M5020_REQ.detail_json		AS	detail_json
			FROM #M5020_REQ
			WHERE #M5020_REQ.work_history_kbn = 2
		) AS P
		Pivot(MAX(detail_json) FOR row_count IN ('+@w_str+')) AS A
		ORDER BY 
			A.detail_no			DESC

	'
	EXEC(@w_sql)
	

END
GO
