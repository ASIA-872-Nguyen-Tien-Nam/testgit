DROP PROCEDURE [SPC_M0070_03_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	
--*  
--*  作成日/create date			:	2024/04/04
--*　作成者/creater				:	manhnd						
--*  作成内容/create content		:	SAVE TAB03 M0070		
--*	 更新日/update date			:  	
--*	 更新者/updater				:　 
--*	 更新内容/update content	:	
--****************************************************************************************
CREATE PROCEDURE [SPC_M0070_03_ACT1] 
	-- Add the parameters for the stored procedure here
	@P_json									NVARCHAR(MAX)
	-- common
,	@P_cre_user								NVARCHAR(50)
,	@P_cre_ip								NVARCHAR(50)
,	@P_company_cd							SMALLINT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time								DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL							ERRTABLE	
	,	@w_order_by_min						INT					=	0
	,	@w_max_no							INT					=	0
	-- SCREEN
	,	@w_detail_no						SMALLINT			=	0
	,	@w_employee_cd						NVARCHAR(10)		=	N''
	,	@w_count							INT					=	0

	-- TABLES
	CREATE TABLE #M0070_03 (
        id									BIGINT			IDENTITY(1,1)
    ,   company_cd							SMALLINT
    ,   employee_cd							NVARCHAR(10)
    ,   detail_no							SMALLINT
    ,   training_cd							INT
    ,   training_nm							NVARCHAR(50)
    ,   training_category_cd				SMALLINT
    ,   training_course_format_cd			SMALLINT
    ,   lecturer_name						NVARCHAR(20)
    ,   training_date_from					DATE
    ,   training_date_to					DATE
    ,   training_status						SMALLINT
    ,   passing_date						DATE
    ,   diploma_file						NVARCHAR(50)
    --,   diploma_file_name					NVARCHAR(50)
    ,   diploma_file_name					NVARCHAR(100)
    ,   diploma_file_uploaddatetime			DATETIME
    ,   report_submission					SMALLINT
    ,   report_submission_date				DATE
    ,   report_storage_location				NVARCHAR(50)
    ,   nationality							NVARCHAR(50)
	,	delete_file							SMALLINT
    )

	CREATE TABLE #TBL_INSERT (
        id									BIGINT			IDENTITY(1,1)
    ,   company_cd							SMALLINT
    ,   employee_cd							NVARCHAR(10)
    ,   detail_no							SMALLINT
    ,   training_cd							INT	
    ,   training_nm							NVARCHAR(50)
    ,   training_category_cd				SMALLINT
    ,   training_course_format_cd			SMALLINT
    ,   lecturer_name						NVARCHAR(20)
    ,   training_date_from					DATE
    ,   training_date_to					DATE
    ,   training_status						SMALLINT
    ,   passing_date						DATE
    ,   diploma_file						NVARCHAR(50)
    --,   diploma_file_name					NVARCHAR(50)
	,   diploma_file_name					NVARCHAR(100)
    ,   diploma_file_uploaddatetime			DATETIME
    ,   report_submission					SMALLINT
    ,   report_submission_date				DATE
    ,   report_storage_location				NVARCHAR(50)
    ,   nationality							NVARCHAR(50)
	,	delete_file							SMALLINT
    )

	--SET DATA
	SET @w_employee_cd					=	JSON_VALUE(@P_json,'$.employee_cd')
	--SET MAX DETAIL_ID
	SELECT 
		@w_max_no = ISNULL(MAX(detail_no),0)
	FROM M0076
	WHERE
		company_cd		=	@P_company_cd
	AND employee_cd		=	@w_employee_cd
		
	--TABLE M0070_03
	INSERT INTO #M0070_03
	SELECT 
		@P_company_cd																														AS	company_cd
	,	@w_employee_cd																														AS	employee_cd
	,	JSON_VALUE([value],'$.detail_no')																									AS	detail_no
	,	JSON_VALUE([value],'$.training_cd')																									AS	training_cd
	,	JSON_VALUE([value],'$.training_nm')																									AS	training_nm
	,	JSON_VALUE([value],'$.training_category_cd')																						AS	training_category_cd
	,	JSON_VALUE([value],'$.training_course_format_cd')																					AS	training_course_format_cd
	,	JSON_VALUE([value],'$.lecturer_name')																								AS	lecturer_name
	,	IIF(JSON_VALUE([value],'$.training_date_from') = N'', NULL, REPLACE(JSON_VALUE([value],'$.training_date_from'), N'\', N''))			AS	training_date_from
	,	IIF(JSON_VALUE([value],'$.training_date_to') = N'', NULL, REPLACE(JSON_VALUE([value],'$.training_date_to'), N'\', N'')) 			AS	training_date_to
	,	JSON_VALUE([value],'$.training_status')																								AS	training_status
	,	IIF(JSON_VALUE([value],'$.passing_date') = N'', NULL, REPLACE(JSON_VALUE([value],'$.passing_date'), N'\', N'')) 					AS	passing_date
	,	JSON_VALUE([value],'$.diploma_file')																								AS	diploma_file
	,	JSON_VALUE([value],'$.diploma_file_name')																							AS	diploma_file_name
	,	IIF(JSON_VALUE([value],'$.diploma_file_name') IS NULL, NULL, @w_time)																AS	diploma_file_uploaddatetime
	,	JSON_VALUE([value],'$.report_submission')																							AS	report_submission
	,	IIF(JSON_VALUE([value],'$.report_submission_date') = N'', NULL, REPLACE(JSON_VALUE([value],'$.report_submission_date'), N'\', N'')) AS	report_submission_date
	,	JSON_VALUE([value],'$.report_storage_location')																						AS	report_storage_location
	,	JSON_VALUE([value],'$.nationality')																									AS	nationality
	,	JSON_VALUE([value],'$.delete_file')																									AS	delete_file
	FROM OPENJSON(@P_json,'$.list_tab_03')

	SELECT 
		@w_count	=	COUNT(1)
	FROM #M0070_03

	--TABLE INSERT
	INSERT INTO #TBL_INSERT 
	SELECT 
		company_cd
	,	employee_cd
	,	ROW_NUMBER() OVER(ORDER BY id) + @w_max_no
	,	training_cd
	,	training_nm
	,	training_category_cd
	,	training_course_format_cd
	,	lecturer_name
	,	training_date_from
	,	training_date_to
	,	training_status
	,	passing_date
	,	diploma_file
	,	diploma_file_name
	,	diploma_file_uploaddatetime
	,	report_submission
	,	report_submission_date
	,	report_storage_location
	,	nationality
	,	delete_file
	FROM #M0070_03
	WHERE
		detail_no		=	0

	--VALIDATE
	--INSERT INTO @ERR_TBL
	--SELECT 
	--	24
	--,	N'.display-input' 
	--,	0-- oderby
	--,	0-- dialog  
	--,	@w_count - #M0070_03.id + 1
	--,	0
	--,	N'diploma_file_name'
	--FROM #M0070_03
	--WHERE
	--	LEN(diploma_file_name) > 50

	-- CHECK DATE FROM
	INSERT INTO @ERR_TBL
	SELECT 
		24
	,	N'.training_date_from' 
	,	0-- oderby
	,	0-- dialog  
	,	@w_count - #M0070_03.id + 1
	,	0
	,	N'training_date_from'
	FROM #M0070_03
	WHERE
		training_date_from > training_date_to
	-- CHECK DATE TO
	INSERT INTO @ERR_TBL
	SELECT 
		24
	,	N'.training_date_to' 
	,	0-- oderby
	,	0-- dialog  
	,	@w_count - #M0070_03.id + 1
	,	0
	,	N'training_date_to'
	FROM #M0070_03
	WHERE
		training_date_to < training_date_from
	-- CHECK TRAINING_CD NOT EXIST IN MASTER
	INSERT INTO @ERR_TBL
	SELECT
		162
	,	N'.training_cd' 
	,	0-- oderby
	,	0-- dialog  
	,	@w_count - #M0070_03.id + 1
	,	0
	,	N'training_cd'
	FROM #M0070_03
	LEFT JOIN M5030 ON (
		#M0070_03.company_cd	=	M5030.company_cd
	AND	#M0070_03.training_cd	=	M5030.training_cd
	)
	WHERE
		#M0070_03.training_cd <> 0
	AND	(
		(#M0070_03.detail_no = 0 AND M5030.company_cd IS NULL)
	OR	(#M0070_03.detail_no <> 0 AND (M5030.company_cd IS NULL OR M5030.del_datetime IS NOT NULL))
	)

	IF EXISTS (SELECT 1 FROM @ERR_TBL)
	BEGIN
		GOTO COMPLETE_QUERY
	END

	--START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		--M0076
		--DELETE
		UPDATE M0076 SET
			M0076.del_user				=	@P_cre_user
		,	M0076.del_ip				=	@P_cre_ip
		,	M0076.del_prg				=	N'M0070'
		,	M0076.del_datetime			=	@w_time
		FROM M0076
		LEFT OUTER JOIN #M0070_03 ON (
			M0076.company_cd			=	#M0070_03.company_cd
		AND	M0076.employee_cd			=	#M0070_03.employee_cd
		AND M0076.detail_no				=	#M0070_03.detail_no
		)
		WHERE
			#M0070_03.company_cd IS NULL
		AND M0076.company_cd = @P_company_cd
		AND M0076.employee_cd = @w_employee_cd
		AND M0076.del_datetime IS NULL

		--UPDATE

		--select 
		--	#M0070_03.delete_file	as	'#M0070_03.delete_file'
		--,	#M0070_03.diploma_file	as	'#M0070_03.diploma_file'
		--,	M0076.diploma_file		as	'M0076.diploma_file'
		--,
		--	CASE
		--		WHEN #M0070_03.delete_file = 1 THEN N''
		--		WHEN #M0070_03.diploma_file = N'' THEN M0076.diploma_file
		--		WHEN #M0070_03.diploma_file <> N'' THEN #M0070_03.diploma_file
		--	END
		--FROM #M0070_03
		--INNER JOIN M0076 ON (
		--	#M0070_03.company_cd				=	M0076.company_cd
		--AND	#M0070_03.employee_cd				=	M0076.employee_cd
		--AND	#M0070_03.detail_no					=	M0076.detail_no
		--)
		--WHERE
		--	M0076.del_datetime IS NULL
		--AND M0076.employee_cd = @w_employee_cd
		--AND M0076.company_cd = @P_company_cd

		UPDATE M0076 SET
			M0076.training_cd					=	#M0070_03.training_cd
		,	M0076.training_nm					=	#M0070_03.training_nm
		,	M0076.training_category_cd			=	#M0070_03.training_category_cd
		,	M0076.training_course_format_cd		=	#M0070_03.training_course_format_cd
		,	M0076.lecturer_name					=	#M0070_03.lecturer_name
		,	M0076.training_date_from			=	#M0070_03.training_date_from
		,	M0076.training_date_to				=	#M0070_03.training_date_to
		,	M0076.training_status				=	#M0070_03.training_status
		,	M0076.passing_date					=	#M0070_03.passing_date
		--,	M0076.diploma_file					=	IIF(#M0070_03.diploma_file = N'', M0076.diploma_file, #M0070_03.diploma_file)
		--,	M0076.diploma_file_name				=	IIF(#M0070_03.diploma_file = N'', M0076.diploma_file_name, #M0070_03.diploma_file_name)
		--,	M0076.diploma_file_uploaddatetime	=	IIF(#M0070_03.diploma_file = N'', M0076.diploma_file_uploaddatetime, @w_time)

		--,	M0076.diploma_file					=	CASE
		--												WHEN #M0070_03.delete_file = 1 THEN N''
		--												WHEN #M0070_03.diploma_file = N'' THEN M0076.diploma_file
		--												WHEN #M0070_03.diploma_file <> N'' THEN #M0070_03.diploma_file
		--											END
		--,	M0076.diploma_file_name				=	CASE
		--												WHEN #M0070_03.delete_file = 1 THEN N''
		--												WHEN #M0070_03.diploma_file = N'' THEN M0076.diploma_file_name
		--												WHEN #M0070_03.diploma_file <> N'' THEN #M0070_03.diploma_file_name
		--											END
		--,	M0076.diploma_file_uploaddatetime	=	CASE
		--												WHEN #M0070_03.delete_file = 1 THEN NULL
		--												WHEN #M0070_03.diploma_file = N'' THEN M0076.diploma_file_uploaddatetime
		--												WHEN #M0070_03.diploma_file <> N'' THEN @w_time
		--											END

		,	M0076.diploma_file					=	CASE
														WHEN #M0070_03.delete_file = 1 THEN N''
														WHEN #M0070_03.diploma_file IS NULL THEN M0076.diploma_file
														WHEN #M0070_03.diploma_file IS NOT NULL THEN #M0070_03.diploma_file
													END
		,	M0076.diploma_file_name				=	CASE
														WHEN #M0070_03.delete_file = 1 THEN N''
														WHEN #M0070_03.diploma_file IS NULL THEN M0076.diploma_file_name
														WHEN #M0070_03.diploma_file IS NOT NULL THEN #M0070_03.diploma_file_name
													END
		,	M0076.diploma_file_uploaddatetime	=	CASE
														WHEN #M0070_03.delete_file = 1 THEN NULL
														WHEN #M0070_03.diploma_file IS NULL THEN M0076.diploma_file_uploaddatetime
														WHEN #M0070_03.diploma_file IS NOT NULL THEN @w_time
													END

		,	M0076.report_submission				=	#M0070_03.report_submission
		,	M0076.report_submission_date		=	#M0070_03.report_submission_date
		,	M0076.report_storage_location		=	#M0070_03.report_storage_location
		,	M0076.nationality					=	#M0070_03.nationality
		,	M0076.upd_user						=	@P_cre_user
		,	M0076.upd_ip						=	@P_cre_ip
		,	M0076.upd_prg						=	N'M0070'
		,	M0076.upd_datetime					=	@w_time
		FROM #M0070_03
		INNER JOIN M0076 ON (
			#M0070_03.company_cd				=	M0076.company_cd
		AND	#M0070_03.employee_cd				=	M0076.employee_cd
		AND	#M0070_03.detail_no					=	M0076.detail_no
		)
		WHERE
			M0076.del_datetime IS NULL
		AND M0076.employee_cd = @w_employee_cd
		AND M0076.company_cd = @P_company_cd
		--INSERT
		INSERT INTO M0076
		SELECT
			company_cd
		,	employee_cd
		,	detail_no
		,	training_cd
		,	training_nm
		,	training_category_cd
		,	training_course_format_cd
		,	lecturer_name
		,	training_date_from
		,	training_date_to
		,	training_status
		,	passing_date
		,	diploma_file
		,	diploma_file_name
		,	diploma_file_uploaddatetime
		,	report_submission
		,	report_submission_date
		,	report_storage_location
		,	nationality
		,	@P_cre_user
		,	@P_cre_ip
		,	N'M0070'
		,	@w_time
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	NULL
		,	SPACE(0)
		,	SPACE(0)
		,	SPACE(0)
		,	NULL
		FROM #TBL_INSERT

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
		@w_order_by_min = MIN(order_by)
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
	WHERE order_by = @w_order_by_min
	ORDER BY 
		order_by
END
GO
