IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_RM0200_ACT1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_rM0200_ACT1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
 * EXEC SPC_rM0200_ACT1 '1','namnt2444','1','2023/04/03','1','1','1','[{"question":"ADQWDFASD","arrange_order":""},{"question":"sdfsdf","arrange_order":""},{"question":"fgnbfgbfbdvbdcv","arrange_order":""},{"question":"nn","arrange_order":""}]','1','1','::1','10039';

 *  処理概要：rM0200 - SAVE/UPDATE
 *
 *  作成日  ：2023-04-11
 *  作成者  ：ANS-ASIA namnt 
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 * 
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_rM0200_ACT1] 
	@P_sheet_cd				SMALLINT		=	0
,	@P_sheet_nm				NVARCHAR(50)	=	''
,	@P_report_kind			SMALLINT		=	0
,	@P_adaption_date		DATE			=	NULL
,	@P_business_use_typ		TINYINT			=	0
,	@P_other_use_typ		TINYINT			=	0
,	@P_comment_use_typ		TINYINT			=	0
,	@P_json					NVARCHAR(MAX)
,	@P_adequacy_use_typ		TINYINT			=	0
,	@P_cre_user				NVARCHAR(50) = ''
,	@P_cre_ip				NVARCHAR(50) = ''
,	@P_company_cd			SMALLINT	 = 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time						DATETIME2	 = SYSDATETIME()
	,	@ERR_TBL					ERRTABLE	
	,	@mark_type					SMALLINT		= 0
	,	@w_sheet_cd					SMALLINT	=	0
	,	@w_max_detail				SMALLINT	=	0
	IF ISJSON(@P_json) <= 0
	BEGIN
		INSERT INTO @ERR_TBL VALUES(		
			22								
		,	''											
		,	0-- oderby						
		,	1-- dialog  					
		,	0								
		,	0								
		,	'json format'					
		)
	END
	-------- get new sheet cd
	SET @w_max_detail = (SELECT ISNULL(MAX(sheet_detail_no),0) FROM M4201 WHERE company_cd = @P_company_cd AND report_kind = @P_report_kind AND sheet_cd = @P_sheet_cd AND adaption_date = @P_adaption_date)
	IF @P_sheet_cd = 0 
	BEGIN
	SET @w_sheet_cd = (SELECT ISNULL(MAX(sheet_cd),0) + 1 FROM M4200 WHERE company_cd = @P_company_cd AND report_kind = @P_report_kind AND del_datetime IS NULL)
	END
	ELSE
	BEGIN
	SET @w_sheet_cd = @P_sheet_cd
	END
	-------
	CREATE TABLE #M4201 (
		Id      int identity(1,1)
	,	question			nvarchar(200)
	,	question_no			tinyint
	,	arrange_order		int
	)
	INSERT INTO #M4201
	SELECT 
		question
	,	question_no
	,	question_id
	FROM OPENJSON(@P_json) WITH(
			question			nvarchar(200)
		,	question_no			TINYINT
		,	question_id			SMALLINT
	)

	IF NOT EXISTS(SELECT 1 FROM #M4201 ) 
	BEGIN
		INSERT INTO @ERR_TBL
		SELECT 
			116
		,	''
		,	0
		,	1 -- exception error
		,	0
		,	0
		,	'no row in table question'
	END
	IF EXISTS(SELECT 1
				FROM #M4201
				GROUP BY question_no
				HAVING COUNT(question_no) > 1
			) 
	BEGIN
		INSERT INTO @ERR_TBL
		SELECT 
			32
		,	'.err_question_cd'
		,	0
		,	1 -- exception error
		,	0
		,	#M4201.id-1
		,	'duplicate question'
		FROM #M4201 INNER JOIN
		(
			SELECT 
				question_no
			FROM #M4201
			GROUP BY question_no
			HAVING COUNT(question_no) > 1
		) AS B ON (
			#M4201.question_no = B.question_no
		)
	END
	IF NOT EXISTS (
		SELECT 1 
		FROM M4120 
		WHERE 
			mark_kbn				=	1 
		AND company_cd				=	@P_company_cd 
		AND del_datetime			IS NULL
	) 
	AND @P_adequacy_use_typ		=	1
	BEGIN
		INSERT INTO @ERR_TBL
		SELECT 
			156
		,	''
		,	0
		,	1 -- exception error
		,	0
		,	0
		,	'adequacy not registered'
	END
	IF NOT EXISTS (
		SELECT 1 
		FROM M4120 
		WHERE 
			mark_kbn				=	2 
		AND company_cd				=	@P_company_cd 
		AND del_datetime			IS NULL
	)
	AND @P_business_use_typ		=	1
	BEGIN
		INSERT INTO @ERR_TBL
		SELECT 
			157
		,	''
		,	0
		,	1 -- exception error
		,	0
		,	0
		,	'busyness not registered'
	END
	IF NOT EXISTS (
		SELECT 1 
		FROM M4120 
		WHERE 
			mark_kbn				=	3 
		AND company_cd				=	@P_company_cd 
		AND del_datetime			IS NULL
	)
	AND @P_other_use_typ		=	1
	BEGIN
		INSERT INTO @ERR_TBL
		SELECT 
			158
		,	''
		,	0
		,	1 -- exception error
		,	0
		,	0
		,	'other not registered'
	END
	IF EXISTS (SELECT 1 FROM @ERR_TBL) GOTO COMPLETE_QUERY
	BEGIN TRANSACTION
	BEGIN TRY
		--save to m4201----
			DELETE FROM M4201 WHERE M4201.company_cd = @P_company_cd
			AND M4201.report_kind = @P_report_kind
			AND M4201.sheet_cd = @w_sheet_cd
			AND M4201.adaption_date = @P_adaption_date
			INSERT INTO M4201
			SELECT 
				@P_company_cd
			,	@P_report_kind
			,	@w_sheet_cd
			,	@P_adaption_date
			,	ROW_NUMBER() OVER (PARTITION BY @P_company_cd,@P_report_kind,@w_sheet_cd,@P_adaption_date ORDER BY @P_sheet_cd) 
			,	#M4201.question_no
			,	#M4201.question
			,	0
			,	@P_cre_user		
			,	@P_cre_ip	
			,	'rM0200'		
			,	@w_time		
			,	null	
			,	null	
			,	''	
			,	null	
			,	null	
			,	null	
			,	''	
			,	null	
			FROM #M4201 LEFT JOIN M4201 ON (
				@P_company_cd = M4201.company_cd
			AND @P_report_kind = M4201.report_kind
			AND @w_sheet_cd = M4201.sheet_cd
			AND @P_adaption_date = M4201.adaption_date
			AND #M4201.arrange_order = M4201.sheet_detail_no
			)
			WHERE M4201.sheet_detail_no IS NULL
			--------save to M4200
			IF NOT EXISTS (SELECT 1 FROM M4200 WHERE company_cd		= @P_company_cd 
												AND report_kind		= @P_report_kind 
												AND sheet_cd		= @P_sheet_cd 
												AND adaption_date		= @P_adaption_date 
												)
			BEGIN
				INSERT INTO M4200
				SELECT 
					@P_company_cd
				,	@P_report_kind			
				,	@w_sheet_cd							
				,	@P_adaption_date			
				,	@P_sheet_nm		
				,	@P_adequacy_use_typ		
				,	@P_business_use_typ		
				,	@P_other_use_typ		
				,	@P_comment_use_typ			
				,	0	            
				,	@P_cre_user		
				,	@P_cre_ip	
				,	'rM0200'		
				,	@w_time		
				,	null	
				,	null	
				,	''	
				,	null	
				,	null	
				,	null	
				,	''	
				,	null	
			END 
			IF EXISTS (SELECT 1 FROM M4200 WHERE company_cd			= @P_company_cd 
												AND report_kind		= @P_report_kind 
												AND sheet_cd		= @P_sheet_cd 
												AND adaption_date		= @P_adaption_date 
												)
			BEGIN
				UPDATE M4200
				SET 
					company_cd				=	@P_company_cd
				,	report_kind				=	@P_report_kind				
				,	sheet_cd				=	@P_sheet_cd			
				,	sheet_nm				=	@P_sheet_nm			
				,	arrange_order			=	0			            	
				--,	upd_user				=	@P_cre_user
				--,	upd_ip					=	@P_cre_ip
				--,	upd_prg					=	'rM0200'
				--,	upd_datetime			=	@w_time
				FROM M4200
				WHERE M4200.company_cd		= @P_company_cd 
				AND sheet_cd				= @P_sheet_cd 
				AND report_kind				= @P_report_kind 
				----
				UPDATE M4200
				SET 	
					adequacy_use_typ		=	@P_adequacy_use_typ		
				,	busyness_use_typ		=	@P_business_use_typ	
				,	other_use_typ			=	@P_other_use_typ	
				,	comment_use_typ			=	@P_comment_use_typ		
				,	upd_user				=	@P_cre_user
				,	upd_ip					=	@P_cre_ip
				,	upd_prg					=	'rM0200'
				,	upd_datetime			=	@w_time
				,	del_user				=	NULL
				,	del_ip					=	NULL
				,	del_prg					=	''
				,	del_datetime			=	NULL
				FROM M4200
				WHERE M4200.company_cd		= @P_company_cd 
				AND sheet_cd				= @P_sheet_cd 
				AND report_kind				= @P_report_kind 
				AND adaption_date			= @P_adaption_date 
			END
		
			--
			
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
	--
	IF (SELECT COUNT(1) FROM @ERR_TBL) > 1
	BEGIN
		ROLLBACK TRANSACTION
	END
	--DELETE FROM @ERR_TBL
	IF(@@TRANCOUNT > 0)
	BEGIN
		COMMIT TRANSACTION
	END
	COMPLETE_QUERY:
	-- GET ERROR_TYPE MIN

	
	--[0]
	SELECT 
		message_no
	,	item
	,	order_by
	,	error_typ
	,	value1
	,	value2
	,	remark
	FROM @ERR_TBL
	ORDER BY 
		order_by
END

GO
