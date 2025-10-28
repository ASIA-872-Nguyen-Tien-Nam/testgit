IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_MQ2000_ACT1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_MQ2000_ACT1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：OM0400 - SAVE/UPDATE
 *
 *  作成日  ：2021-01-12
 *  作成者  ：ANS-ASIA nghianm
 *
 *  更新日  ：2021/04/08
 *  更新者  ：ANS-ASIA vietdt
 *  更新内容：edit authority_row_typ
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_MQ2000_ACT1] 
	@P_json			NVARCHAR(MAX)
	--
,	@P_cre_user		NVARCHAR(50) = ''
,	@P_cre_ip		NVARCHAR(50) = ''
,	@P_company_cd	SMALLINT	 = 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2	 = SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	

	--
	CREATE TABLE #F3001(
		id							INT IDENTITY(1,1)
	,	company_cd					SMALLINT
	,	employee_cd					NVARCHAR(10)
	,	detail_no					SMALLINT	
	,	rater_employee_cd_1			NVARCHAR(10)
	,	rater_employee_comment_1	NVARCHAR(50)
	,	importance_point			NUMERIC(2,1)
	,	point						NUMERIC(2,1)
	,	authority_row_typ			TINYINT
	)
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
	--
	BEGIN TRANSACTION
	BEGIN TRY
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			--get data from json
			INSERT INTO #F3001
			SELECT 
				@P_company_cd
			,	employee_cd
			,	detail_no
			,	rater_employee_cd_1
			,	rater_employee_comment_1
			,	importance_point
			,	point
			,	authority_row_typ
			FROM OPENJSON(@P_json, '$.list_importance_point') WITH(
				employee_cd					NVARCHAR(10)
			,	detail_no					SMALLINT
			,	rater_employee_cd_1			NVARCHAR(10)
			,	rater_employee_comment_1	NVARCHAR(50)
			,	importance_point			NVARCHAR(10)
			,	point						NVARCHAR(10)	
			,	authority_row_typ			TINYINT
			)
			--
			DELETE FROM #F3001 WHERE authority_row_typ <> 2 -- 0.not view | 1.can view | 2.edited --edited by vietdt 2021/04/08
			-- update table F3001
			UPDATE F3001 SET  
				rater_employee_comment_1	= #F3001.rater_employee_comment_1						-- 一時評価者コメント
			,	importance_point			= CAST(#F3001.importance_point  AS NUMERIC(2,1)) * 1.0	-- 重要度
			,	point						= CAST(#F3001.point  AS NUMERIC(2,1)) * 1.0				-- 点数
			,	upd_user					= @P_cre_user
			,	upd_ip						= @P_cre_ip
			,	upd_prg						= 'mQ2000'
			,	upd_datetime				= @w_time
			FROM F3001
			INNER JOIN #F3001 ON (
				F3001.company_cd			= #F3001.company_cd
			AND F3001.employee_cd			= #F3001.employee_cd
			AND F3001.detail_no				= #F3001.detail_no
			AND F3001.rater_employee_cd_1	= #F3001.rater_employee_cd_1
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
