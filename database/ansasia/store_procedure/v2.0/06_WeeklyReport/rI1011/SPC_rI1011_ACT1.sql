DROP PROCEDURE [SPC_rI1011_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC SPC_rI1011_ACT1 '{"mail_kbn":"1","information":"0","mail":"1","title":"The Interview has been decided","message":"The 1on1 is on yyyy\/mm\/dd \nPlease fill in the member Sheet","sending_target":"0","send_date":"123","send_kbn":"1"}','740','721','::1';
/****************************************************************************************************
 *
 *  処理概要：rI1011 - SAVE/UPDATE
 *
 *  作成日  ：2023-04-20
 *  作成者  ：ANS-ASIA quangnd
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_rI1011_ACT1] 
	@P_json			NVARCHAR(MAX)
,	@P_company_cd	SMALLINT	 = 0
,	@P_cre_user		NVARCHAR(50) = ''
,	@P_cre_ip		NVARCHAR(50) = ''
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
	IF EXISTS (SELECT 1 FROM @ERR_TBL) GOTO COMPLETE_QUERY
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
	CREATE TABLE #M4500 (
		company_cd		SMALLINT
	,	mail_kbn		SMALLINT
	,	information		TINYINT
	,	mail			TINYINT
	,	title			NVARCHAR(50)
	,	[message]		NVARCHAR(200)
	,	sending_target	TINYINT
	,	send_date		NVARCHAR(10)
	,	send_kbn		TINYINT
	)
	--
	INSERT INTO #M4500
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
	--
	BEGIN TRANSACTION
	BEGIN TRY
			UPDATE M4500
			SET 
				company_cd		=	@P_company_cd	
			,	mail_kbn		=	@mail_kbn		
			,	information		=	@information	
			,	mail			=	@mail			
			,	title			=	@title			
			,	[message]		=	@message		
			,	sending_target	=	@sending_target	
			,	send_date		=	@send_date		
			,	send_kbn		=	@send_kbn		
			,	upd_user		=	@P_cre_user
			,	upd_ip			=	@P_cre_ip
			,	upd_prg			=	'rI1011'
			,	upd_datetime	=	@w_time
			,	del_user		=	''
			,	del_ip			=	''
			,	del_prg			=	''
			,	del_datetime	=	NULL
			FROM M4500
			WHERE
				M4500.company_cd		= @P_company_cd
			AND	M4500.mail_kbn			= @mail_kbn
			AND M4500.del_datetime		IS NULL
			--
			UPDATE M4500
			SET 
				company_cd		=	@P_company_cd	
			,	mail_kbn		=	@mail_kbn		
			,	information		=	@information	
			,	mail			=	@mail			
			,	title			=	@title			
			,	[message]		=	@message		
			,	sending_target	=	@sending_target	
			,	send_date		=	@send_date		
			,	send_kbn		=	@send_kbn		
			,	cre_user		=	@P_cre_user
			,	cre_ip			=	@P_cre_ip
			,	cre_prg			=	'rI1011'
			,	cre_datetime	=	@w_time
			,	upd_user		=	''
			,	upd_ip			=	''
			,	upd_prg			=	''
			,	upd_datetime	=	NULL
			,	del_user		=	''
			,	del_ip			=	''
			,	del_prg			=	''
			,	del_datetime	=	NULL
			FROM M4500
			WHERE
				M4500.company_cd		= @P_company_cd
			AND	M4500.mail_kbn			= @mail_kbn
			AND M4500.del_datetime	IS NOT NULL
			--insert
			INSERT INTO M4500
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
			,	'rI1011'
			,	@w_time
			,	''
			,	''
			,	''
			,	NULL
			,	''
			,	''
			,	''
			,	NULL
			FROM #M4500
			LEFT JOIN M4500 ON(
				@P_company_cd 		=	M4500.company_cd
			AND #M4500.mail_kbn 	=	M4500.mail_kbn		
			)
			WHERE  
				M4500.company_cd IS NULL
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
