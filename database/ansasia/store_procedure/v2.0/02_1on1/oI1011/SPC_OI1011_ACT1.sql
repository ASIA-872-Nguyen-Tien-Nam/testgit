DROP PROCEDURE [SPC_OI1011_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：OI1011 - SAVE/UPDATE
 *
 *  作成日  ：2020-11-10
 *  作成者  ：ANS-ASIA nghianm
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_OI1011_ACT1] 
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
	,	@mail_kbn				SMALLINT
	,	@information			TINYINT
	,	@mail					TINYINT
	,	@title					NVARCHAR(50)
	,	@message				NVARCHAR(200)
	,	@sending_target			TINYINT
	,	@send_date				NVARCHAR(10)
	,	@send_kbn				TINYINT

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
	SET @mail_kbn				=	ISNULL(JSON_VALUE(@P_json,'$.mail_kbn'),0)
	SET @information			=	ISNULL(JSON_VALUE(@P_json,'$.information'),0)
	SET @mail					=	ISNULL(JSON_VALUE(@P_json,'$.mail'),0)
	SET @title					=	ISNULL(JSON_VALUE(@P_json,'$.title'),'')
	SET @message				=	ISNULL(JSON_VALUE(@P_json,'$.message'),'')
	SET @sending_target			=	ISNULL(JSON_VALUE(@P_json,'$.sending_target'),0)
	SET @send_date				=	ISNULL(JSON_VALUE(@P_json,'$.send_date'),'')
	SET @send_kbn				=	ISNULL(JSON_VALUE(@P_json,'$.send_kbn'),0)
	--
	CREATE TABLE #HISTORY_M2500 (
		company_cd		SMALLINT
	,	mail_kbn		SMALLINT
	,	cre_user		NVARCHAR(50)
	,	cre_ip			NVARCHAR(50)
	,	cre_prg			NVARCHAR(20)
	,	cre_datetime	DATETIME
	,	upd_user		NVARCHAR(50)
	,	upd_ip			NVARCHAR(50)
	,	upd_prg			NVARCHAR(20)
	,	upd_datetime	DATETIME
	,	del_user		NVARCHAR(50)
	,	del_ip			NVARCHAR(50)
	,	del_prg			NVARCHAR(20)
	,	del_datetime	DATETIME
	)
	--
	--INSERT INTO #HISTORY_M2500
	INSERT INTO #HISTORY_M2500
	SELECT 
		M2500.company_cd
	,	M2500.mail_kbn
	,	M2500.cre_user
	,	M2500.cre_ip
	,	M2500.cre_prg
	,	M2500.cre_datetime
	,	M2500.upd_user
	,	M2500.upd_ip
	,	M2500.upd_prg
	,	M2500.upd_datetime
	,	M2500.del_user
	,	M2500.del_ip
	,	M2500.del_prg
	,	M2500.del_datetime
	FROM M2500
	WHERE M2500.company_cd = @P_company_cd 
	AND M2500.mail_kbn = @mail_kbn
	AND M2500.del_datetime IS NULL
	--
	BEGIN TRANSACTION
	BEGIN TRY
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			DELETE FROM M2500 WHERE company_cd = @P_company_cd AND mail_kbn = @mail_kbn 
			INSERT INTO M2500
			SELECT
				@P_company_cd
			,	@mail_kbn
			,	@information
			,	@mail
			,	@title
			,	@message
			,	@sending_target
			,	@send_date
			,	@send_kbn
			,	0
			,	@P_cre_user
			,	@P_cre_ip
			,	'oI1011'
			,	@w_time
			,	''
			,	''
			,	''
			,	NULL
			,	''
			,	''
			,	''
			,	NULL
			--
			UPDATE M2500 SET
				cre_user		= CASE WHEN #HISTORY_M2500.del_datetime IS NOT NULL
									THEN @P_cre_user
									ELSE
										#HISTORY_M2500.cre_user
									END
			,	cre_prg			= CASE WHEN #HISTORY_M2500.del_datetime IS NOT NULL
									THEN 'oI1011'
									ELSE
										#HISTORY_M2500.cre_prg
									END
			,	cre_ip			= CASE WHEN #HISTORY_M2500.del_datetime IS NOT NULL
								THEN @P_cre_ip
								ELSE
									#HISTORY_M2500.cre_ip
								END
			,	cre_datetime	= CASE WHEN #HISTORY_M2500.del_datetime IS NOT NULL
								THEN @w_time
								ELSE
									#HISTORY_M2500.cre_datetime
								END
			,	upd_prg			= CASE WHEN #HISTORY_M2500.del_datetime IS NOT NULL
								THEN SPACE(0)
								ELSE
									'oI1011'
								END
			,	upd_user		= CASE WHEN #HISTORY_M2500.del_datetime IS NOT NULL
								THEN SPACE(0)
								ELSE
									@P_cre_user
								END
			,	upd_ip			= CASE WHEN #HISTORY_M2500.del_datetime IS NOT NULL
								THEN SPACE(0)
								ELSE
									@P_cre_ip
								END
			,	upd_datetime	= CASE WHEN #HISTORY_M2500.del_datetime IS NOT NULL
								THEN NULL
								ELSE
									@w_time
								END
			FROM M2500
			INNER JOIN #HISTORY_M2500 ON(
				M2500.company_cd	=	#HISTORY_M2500.company_cd
			AND M2500.mail_kbn		=	#HISTORY_M2500.mail_kbn
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
