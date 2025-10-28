DROP PROCEDURE [SPC_OQ3010_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：OQ3010 - SAVE/UPDATE
 *
 *  作成日  ：2020-12-08
 *  作成者  ：ANS-ASIA nghianm
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_OQ3010_ACT1] 
	-- Add the parameters for the stored procedure here
	@P_json						NVARCHAR(MAX)			=	''
	-- common
,	@P_cre_user					NVARCHAR(50)			=	''
,	@P_cre_ip					NVARCHAR(50)			=	''
,	@P_company_cd				SMALLINT				=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2			=	GETDATE()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			int					=	0
	-----------------------SCREEN DATA-------------------------
	,	@fiscal_year			int					=	0

	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	--CREATE TEMP TABLE
	--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	IF object_id('tempdb..#TABLE_JSON', 'U') IS NOT NULL
	BEGIN
		DROP TABLE #TABLE_JSON
	END
	--
	CREATE TABLE #TABLE_JSON (
		id							INT				IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	fiscal_year					SMALLINT
	,	[1on1_group_cd]				SMALLINT
	,	times						SMALLINT
	,	submit						TINYINT
	,	questionnaire_cd			SMALLINT
	)
	CREATE TABLE #HISTORY_F2300 (
		company_cd				SMALLINT
	,	fiscal_year				SMALLINT
	,	[1on1_group_cd]			SMALLINT
	,	times					SMALLINT
	,	submit					TINYINT
	,	questionnaire_cd		SMALLINT
	,	cre_user				NVARCHAR(50)
	,	cre_ip					NVARCHAR(50)
	,	cre_prg					NVARCHAR(20)
	,	cre_datetime			DATETIME
	,	upd_user				NVARCHAR(50)
	,	upd_ip					NVARCHAR(50)
	,	upd_prg					NVARCHAR(20)
	,	upd_datetime			DATETIME
	,	del_user				NVARCHAR(50)
	,	del_ip					NVARCHAR(50)
	,	del_prg					NVARCHAR(20)
	,	del_datetime			DATETIME
	)
	--
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		--VALIDATE
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		IF ISJSON(@P_json) <= 0
		BEGIN
			INSERT INTO @ERR_TBL VALUES(		
				22									-- ma l?i (trung v?i ma trong b?ng message) 					
			,	''									-- id ho?c class c?a item(#id , .class), l?i d?ng dialog thi ?? tr?ng  				
			,	0-- oderby							-- gia tr? cang be thi l?i ???c hi?n th? tr??c  				
			,	1-- dialog  						-- Ki?u hi?n th? l?i : 0. tooltip , 1.dialog 				
			,	0									-- Tuy y : co th? l?u v? tri index c?a dong c?a l?i 				
			,	0									-- Tuy y
			,	'json format'						-- Comment n?i dung l?i (ch? y?u la dung khi ??c code)
			)
		END
		--
		-- get data from json
		SET	@fiscal_year			=	JSON_VALUE(@P_json,'$.fiscal_year')
		-- get list from json data
		INSERT INTO #TABLE_JSON
		SELECT
			@P_company_cd
		,	@fiscal_year
		,	JSON_TABLE.group_cd
		,	JSON_TABLE.times
		,	JSON_TABLE.submit
		,	JSON_TABLE.questionnaire_cd
		FROM OPENJSON(@P_json,'$.list_group') WITH(
			group_cd			SMALLINT
		,	times				SMALLINT
		,	submit				TINYINT
		,	questionnaire_cd	SMALLINT
		)  AS JSON_TABLE;
		--
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			--UPDATE F2300
			INSERT INTO #HISTORY_F2300
			SELECT 
				company_cd		
			,	fiscal_year		
			,	[1on1_group_cd]	
			,	times			
			,	submit			
			,	questionnaire_cd
			,	cre_user		
			,	cre_ip			
			,	cre_prg			
			,	cre_datetime	
			,	upd_user		
			,	upd_ip			
			,	upd_prg			
			,	upd_datetime	
			,	del_user		
			,	del_ip			
			,	del_prg			
			,	del_datetime	
			FROM F2300
			WHERE	F2300.company_cd		= @P_company_cd 
			AND		F2300.fiscal_year	= @fiscal_year
			AND		F2300.del_datetime IS NULL
			--DELETE F2300
			DELETE FROM F2300 WHERE company_cd = @P_company_cd AND fiscal_year = @fiscal_year
			--INSERT INTO F2300
			INSERT INTO F2300
			SELECT
				#TABLE_JSON.company_cd
			,	#TABLE_JSON.fiscal_year
			,	#TABLE_JSON.[1on1_group_cd]
			,	#TABLE_JSON.times
			,	#TABLE_JSON.submit
			,	#TABLE_JSON.questionnaire_cd
			,	@P_cre_user
			,	@P_cre_ip
			,	'oQ3010'
			,	@w_time
			,	''
			,	''
			,	''
			,	NULL
			,	''
			,	''
			,	''
			,	NULL
			FROM #TABLE_JSON
			--UPDATE F2300 (del+add)
			UPDATE F2300 SET
				cre_user		= CASE WHEN #HISTORY_F2300.del_datetime IS NOT NULL
								THEN @P_cre_user
								ELSE
									#HISTORY_F2300.cre_user
								END
			,	cre_ip			= CASE WHEN #HISTORY_F2300.del_datetime IS NOT NULL
								THEN @P_cre_ip
								ELSE
									#HISTORY_F2300.cre_ip
								END
			,	cre_datetime	= CASE WHEN #HISTORY_F2300.del_datetime IS NOT NULL
								THEN @w_time
								ELSE
									#HISTORY_F2300.cre_datetime
								END
			,	upd_prg			= CASE WHEN #HISTORY_F2300.del_datetime IS NOT NULL
								THEN SPACE(0)
								ELSE
									'oQ3010'
								END
			,	upd_user		= CASE WHEN #HISTORY_F2300.del_datetime IS NOT NULL
								THEN SPACE(0)
								ELSE
									@P_cre_user
								END
			,	upd_ip			= CASE WHEN #HISTORY_F2300.del_datetime IS NOT NULL
								THEN SPACE(0)
								ELSE
									@P_cre_ip
								END
			,	upd_datetime	= CASE WHEN #HISTORY_F2300.del_datetime IS NOT NULL
								THEN NULL
								ELSE
									@w_time
								END
			FROM F2300
			INNER JOIN #HISTORY_F2300 ON(
				F2300.company_cd			=	#HISTORY_F2300.company_cd
			AND F2300.fiscal_year			=	#HISTORY_F2300.fiscal_year
			)
		END
		--------
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
END
GO
