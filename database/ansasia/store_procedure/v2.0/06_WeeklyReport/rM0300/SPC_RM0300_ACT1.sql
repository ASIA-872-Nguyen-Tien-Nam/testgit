DROP PROCEDURE [SPC_RM0300_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  SPC_RM0300_ACT1 - SAVE
 *

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	SAVE DATA
--*		
--* 作成日/create date			:	2023/04/17										
--*	作成者/creater				:	namnt			
--*   		
--****************************************************************************************/
CREATE PROCEDURE [SPC_RM0300_ACT1] 
	@P_json			NVARCHAR(MAX)
	--
,	@P_cre_user		NVARCHAR(50) = ''
,	@P_cre_ip		NVARCHAR(50) = ''
,	@P_company_cd	SMALLINT	 = 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time						DATETIME2	 = SYSDATETIME()
	,	@ERR_TBL					ERRTABLE	
	,	@w_group_cd					SMALLINT
	,	@w_group_nm					NVARCHAR(20)
	,	@mode						SMALLINT
	,	@w_belong_cd1				NVARCHAR(20)
	,	@w_belong_cd2				NVARCHAR(20)
	,	@w_belong_cd3				NVARCHAR(20)
	,	@w_belong_cd4				NVARCHAR(20)
	,	@w_belong_cd5				NVARCHAR(20)
	,	@w_belong_cd2_1				NVARCHAR(20)
	,	@w_belong_cd2_2				NVARCHAR(20)
	,	@w_belong_cd2_3				NVARCHAR(20)
	,	@w_belong_cd2_4				NVARCHAR(20)
	,	@w_belong_cd2_5				NVARCHAR(20)
	,	@w_browse_position_typ		SMALLINT
	,	@w_browse_department_typ	SMALLINT

	--
	CREATE TABLE #M4601(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	attribute				SMALLINT
	,	code					SMALLINT
	)
	CREATE TABLE #M4602(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	attribute				SMALLINT
	,	code					SMALLINT
	)
	--
	SET @w_group_cd					=	ISNULL(JSON_VALUE(@P_json,'$.group_cd'),0)
	SET @w_group_nm					=	ISNULL(JSON_VALUE(@P_json,'$.group_nm'),'')
	SET @mode						=	ISNULL(JSON_VALUE(@P_json,'$.mode'),0)	--0:insert , 1:update
	SET @w_belong_cd1				=	IIF(JSON_VALUE(@P_json,'$.organization_step1') ='-1','',JSON_VALUE(@P_json,'$.organization_step1'))
	SET @w_belong_cd2				=	IIF(JSON_VALUE(@P_json,'$.organization_step2') ='-1','',JSON_VALUE(@P_json,'$.organization_step2'))
	SET @w_belong_cd3				=	IIF(JSON_VALUE(@P_json,'$.organization_step3') ='-1','',JSON_VALUE(@P_json,'$.organization_step3'))
	SET @w_belong_cd4				=	IIF(JSON_VALUE(@P_json,'$.organization_step4') ='-1','',JSON_VALUE(@P_json,'$.organization_step4'))
	SET @w_belong_cd5				=	IIF(JSON_VALUE(@P_json,'$.organization_step5') ='-1','',JSON_VALUE(@P_json,'$.organization_step5'))
	SET @w_belong_cd2_1				=	IIF(JSON_VALUE(@P_json,'$.organization_step2_1') ='-1','',JSON_VALUE(@P_json,'$.organization_step2_1'))
	SET @w_belong_cd2_2				=	IIF(JSON_VALUE(@P_json,'$.organization_step2_2') ='-1','',JSON_VALUE(@P_json,'$.organization_step2_2'))
	SET @w_belong_cd2_3				=	IIF(JSON_VALUE(@P_json,'$.organization_step2_3') ='-1','',JSON_VALUE(@P_json,'$.organization_step2_3'))
	SET @w_belong_cd2_4				=	IIF(JSON_VALUE(@P_json,'$.organization_step2_4') ='-1','',JSON_VALUE(@P_json,'$.organization_step2_4'))
	SET @w_belong_cd2_5				=	IIF(JSON_VALUE(@P_json,'$.organization_step2_5') ='-1','',JSON_VALUE(@P_json,'$.organization_step2_5'))
	SET @w_browse_position_typ		=	JSON_VALUE(@P_json,'$.browse_position_typ')
	SET @w_browse_department_typ	=	JSON_VALUE(@P_json,'$.browse_department_typ')
	--
	INSERT INTO #M4601
	SELECT 
		@P_company_cd
	,	2
	,	code
	FROM OPENJSON (@P_json,'$.list_m0030') WITH(
		code	SMALLINT
	)AS json_table
	UNION ALL
	SELECT 
		@P_company_cd
	,	1
	,	code
	FROM OPENJSON (@P_json,'$.list_m0040') WITH(
		code	SMALLINT
	)AS json_table
	UNION ALL 
	SELECT 
		@P_company_cd
	,	3
	,	code
	FROM OPENJSON (@P_json,'$.list_m0050') WITH(
		code	SMALLINT
	)AS json_table
	UNION ALL 
	SELECT 
		@P_company_cd
	,	4
	,	code
	FROM OPENJSON (@P_json,'$.list_m0060') WITH(
		code	SMALLINT
	)AS json_table

	INSERT INTO #M4602
	SELECT 
		@P_company_cd
	,	2
	,	code
	FROM OPENJSON (@P_json,'$.list_m0030_2') WITH(
		code	SMALLINT
	)AS json_table
	UNION ALL
	SELECT 
		@P_company_cd
	,	1
	,	code
	FROM OPENJSON (@P_json,'$.list_m0040_2') WITH(
		code	SMALLINT
	)AS json_table
	UNION ALL 
	SELECT 
		@P_company_cd
	,	3
	,	code
	FROM OPENJSON (@P_json,'$.list_m0050_2') WITH(
		code	SMALLINT
	)AS json_table
	UNION ALL 
	SELECT 
		@P_company_cd
	,	4
	,	code
	FROM OPENJSON (@P_json,'$.list_m0060_2') WITH(
		code	SMALLINT
	)AS json_table
	--
	IF @w_group_cd = 0
	BEGIN
		SET @w_group_cd = (SELECT ISNULL(MAX(M4600.group_cd),0)+1 FROM M4600 WHERE M4600.company_cd = @P_company_cd)
	END
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
		IF EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
		GOTO COMPLETE_QUERY
		END
	BEGIN TRANSACTION
	BEGIN TRY
		IF EXISTS(SELECT 1 FROM M4600 WHERE M4600.company_cd = @P_company_cd AND M4600.group_cd = @w_group_cd)
		BEGIN
			UPDATE M4600
			SET 
			M4600.group_nm = @w_group_nm
		,	M4600.browse_position_typ	= @w_browse_position_typ 
		,	M4600.browse_department_typ = @w_browse_department_typ
		,	upd_user = @P_cre_user
		,	upd_ip = @P_cre_ip
		,	upd_prg = 'rM0300'
		,	upd_datetime = @w_time
		,	del_user = null
		,	del_ip = null
		,	del_prg = ''
		,	del_datetime = null
			WHERE
			M4600.company_cd = @P_company_cd
		AND M4600.group_cd = @w_group_cd
		END
		ELSE
		BEGIN
		INSERT INTO M4600
		SELECT
			@P_company_cd
		,	@w_group_cd
		,	@w_group_nm
		,	@w_browse_position_typ
		,	@w_browse_department_typ
		,	0
		,	@P_cre_user
		,	@P_cre_ip
		,	'rM0300'
		,	@w_time
		,	NULL
		,	NULL
		,	''
		,	NULL
		,	NULL
		,	NULL
		,	''
		,	NULL
	END

	IF EXISTS (SELECT 1 FROM M4601 WHERE M4601.company_cd = @P_company_cd AND M4601.group_cd = @w_group_cd)
	BEGIN
	UPDATE M4601
	SET 
		M4601.upd_user = @P_cre_user
	,	M4601.upd_ip = @P_cre_ip
	,	M4601.upd_prg = 'rM0300'
	,	M4601.upd_datetime = @w_time
	,	M4601.del_user = null
	,	M4601.del_ip = null
	,	M4601.del_prg = ''
	,	M4601.del_datetime = null
	,	M4601.organization_cd_1= @w_belong_cd1 
	,	M4601.organization_cd_2 = @w_belong_cd2 
	,	M4601.organization_cd_3 = @w_belong_cd3 
	,	M4601.organization_cd_4 = @w_belong_cd4 
	,	M4601.organization_cd_5 = @w_belong_cd5
	WHERE M4601.company_cd = @P_company_cd 
	AND M4601.group_cd = @w_group_cd 
	END
	ELSE
	BEGIN
	INSERT INTO M4601
	SELECT 
		@P_company_cd
	,	@w_group_cd
	,	@w_belong_cd1
	,	@w_belong_cd2
	,	@w_belong_cd3
	,	@w_belong_cd4
	,	@w_belong_cd5
	,	0
	,	@P_cre_user
	,	@P_cre_ip
	,	'rM0300'
	,	@w_time
	,	NULL
	,	NULL
	,	''
	,	NULL
	,	NULL
	,	NULL
	,	''
	,	NULL
	END

	IF EXISTS (SELECT 1 FROM M4603 WHERE M4603.company_cd = @P_company_cd AND M4603.group_cd = @w_group_cd)
	BEGIN
	UPDATE M4603
	SET 
		M4603.upd_user = @P_cre_user
	,	M4603.upd_ip = @P_cre_ip
	,	M4603.upd_prg = 'rM0300'
	,	M4603.upd_datetime = @w_time
	,	M4603.del_user = null
	,	M4603.del_ip = null
	,	M4603.del_prg = ''
	,	M4603.del_datetime = null
	,	M4603.organization_cd_1 = @w_belong_cd2_1 
	,	M4603.organization_cd_2 = @w_belong_cd2_2 
	,	M4603.organization_cd_3 = @w_belong_cd2_3 
	,	M4603.organization_cd_4 = @w_belong_cd2_4 
	,	M4603.organization_cd_5 = @w_belong_cd2_5
	WHERE M4603.company_cd = @P_company_cd 
	AND M4603.group_cd = @w_group_cd 
	END
	ELSE
	BEGIN
	INSERT INTO M4603
	SELECT 
		@P_company_cd
	,	@w_group_cd
	,	@w_belong_cd2_1
	,	@w_belong_cd2_2
	,	@w_belong_cd2_3
	,	@w_belong_cd2_4
	,	@w_belong_cd2_5
	,	0
	,	@P_cre_user
	,	@P_cre_ip
	,	'rM0300'
	,	@w_time
	,	NULL
	,	NULL
	,	''
	,	NULL
	,	NULL
	,	NULL
	,	''
	,	NULL
	END
	
	UPDATE M4602
	SET 
		upd_user = @P_cre_user
	,	upd_ip =	@P_cre_ip
	,	upd_prg =	'rM0300'
	,	upd_datetime =	@w_time
	,	del_user = NULL
	,	del_ip =	NULL
	,	del_prg =	''
	,	del_datetime =	NULL
	FROM #M4601 INNER JOIN M4602 ON(
		#M4601.company_cd=M4602.company_cd 
	AND M4602.group_cd = @w_group_cd 
	AND #M4601.attribute=M4602.attribute 
	AND #M4601.code=M4602.code)
	UPDATE M4602
	SET 
		del_user = @P_cre_user
	,	del_ip =	@P_cre_ip
	,	del_prg =	'rM0300'
	,	del_datetime =	@w_time
	FROM #M4601 FULL JOIN M4602 ON(
		#M4601.company_cd	=	M4602.company_cd 
	AND M4602.group_cd		=	@w_group_cd 
	AND #M4601.attribute	=	M4602.attribute 
	AND #M4601.code			=	M4602.code)
	WHERE 
		#M4601.company_cd	IS NULL
	AND M4602.company_cd	= @P_company_cd
	AND M4602.group_cd		= @w_group_cd
	INSERT INTO M4602
	SELECT 
		@P_company_cd
	,	@w_group_cd
	,	#M4601.attribute
	,	#M4601.code
	,	0
	,	@P_cre_user
	,	@P_cre_ip
	,	'rM0300'
	,	@w_time
	,	NULL
	,	NULL
	,	''
	,	NULL
	,	NULL
	,	NULL
	,	''
	,	NULL
	FROM #M4601 LEFT JOIN M4602 ON(
		#M4601.company_cd	=	M4602.company_cd 
	AND M4602.group_cd		=	@w_group_cd 
	AND #M4601.attribute	=	M4602.attribute 
	AND #M4601.code			=	M4602.code)
	WHERE M4602.group_cd IS NULL

	UPDATE M4604
	SET 
		upd_user = @P_cre_user
	,	upd_ip =	@P_cre_ip
	,	upd_prg =	'rM0300'
	,	upd_datetime =	@w_time
	,	del_user = NULL
	,	del_ip =	NULL
	,	del_prg =	''
	,	del_datetime =	NULL
	FROM #M4602 INNER JOIN M4604 ON(
		#M4602.company_cd=M4604.company_cd 
	AND M4604.group_cd = @w_group_cd  
	AND #M4602.attribute=M4604.attribute 
	AND #M4602.code=M4604.code)
	WHERE  M4604.company_cd = @P_company_cd
	AND M4604.group_cd = @w_group_cd
	UPDATE M4604
	SET 
		del_user = @P_cre_user
	,	del_ip =	@P_cre_ip
	,	del_prg =	'rM0300'
	,	del_datetime =	@w_time
	FROM #M4602 FULL JOIN M4604 ON(#M4602.company_cd=M4604.company_cd  and #M4602.attribute=M4604.attribute and #M4602.code=M4604.code)
	WHERE #M4602.company_cd IS NULL
	AND M4604.company_cd = @P_company_cd
	AND M4604.group_cd = @w_group_cd
	INSERT INTO M4602
	SELECT 
		@P_company_cd
	,	@w_group_cd
	,	#M4601.attribute
	,	#M4601.code
	,	0
	,	@P_cre_user
	,	@P_cre_ip
	,	'rM0300'
	,	@w_time
	,	NULL
	,	NULL
	,	''
	,	NULL
	,	NULL
	,	NULL
	,	''
	,	NULL
	FROM #M4601 
	FULL JOIN M4602 ON(
		#M4601.company_cd	=	M4602.company_cd
	AND M4602.company_cd	=	@P_company_cd 
	AND M4602.group_cd		=	@w_group_cd
	AND #M4601.attribute	=	M4602.attribute 
	AND #M4601.code			=	M4602.code)
	WHERE M4602.group_cd IS NULL
	INSERT INTO M4604
	SELECT 
		@P_company_cd
	,	@w_group_cd
	,	#M4602.attribute
	,	#M4602.code
	,	0
	,	@P_cre_user
	,	@P_cre_ip
	,	'rM0300'
	,	@w_time
	,	NULL
	,	NULL
	,	''
	,	NULL
	,	NULL
	,	NULL
	,	''
	,	NULL
	FROM #M4602 FULL JOIN M4604 ON(
		#M4602.company_cd	=	M4604.company_cd 
	AND @P_company_cd		=	M4604.company_cd
	AND M4604.group_cd		=	@w_group_cd
	AND #M4602.attribute	=	M4604.attribute 
	AND #M4602.code			=	M4604.code)
	WHERE M4604.group_cd	IS NULL
	
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
