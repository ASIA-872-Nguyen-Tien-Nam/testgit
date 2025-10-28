DROP PROCEDURE [SPC_M0001_ACT3]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC XXX '{}','','::1';

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	SAVE DATA
--*  
--* 作成日/create date			:	2018/09/05											
--*	作成者/creater				:	Longvv						
--*   					
--*	更新日/update date			:	2021/12/13						
--*	更新者/updater				:	Vietdt　  　								     	 
--*	更新内容/update content		:	CR ver1.7
--*   					
--*	更新日/update date			:	2023/3/29						
--*	更新者/updater				:	namnt 　								     	 
--*	更新内容/update content		:	CR ver2.0
--*   					
--*	更新日/update date			:	2024/03/18						
--*	更新者/updater				:	viettd 　								     	 
--*	更新内容/update content		:	upgrade ver2.1
--****************************************************************************************
CREATE PROCEDURE [SPC_M0001_ACT3] 
	-- Add the parameters for the stored procedure here
	@P_json			nvarchar(max)	=	''
	-- common
,	@P_cre_user		nvarchar(50)	=	''
,	@P_cre_ip		nvarchar(50)	=	''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			int					=	0
	,	@P_company_cd			smallint			=	0
	,	@P_user_id				nvarchar(50)		=	''
	,	@P_password				nvarchar(20)		=	''
	,	@P_sso_user				nvarchar(255)		=	''
	
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY 
		SET	@P_company_cd			=	JSON_VALUE(@P_json,'$.company_cd')
		SET	@P_user_id				=	JSON_VALUE(@P_json,'$.m0001_user_id')
		SET	@P_password				=	JSON_VALUE(@P_json,'$.password')
		SET	@P_sso_user				=	JSON_VALUE(@P_json,'$.sso_user')
		--edit by vietdt 2021/12/13
		IF EXISTS (SELECT 1 FROM S0010 WHERE 
									S0010.company_cd		=	@P_company_cd 
								AND	S0010.user_id			=	@P_user_id
								AND	S0010.authority_typ		=	4
								AND	S0010.del_datetime	IS NULL )
		BEGIN
			UPDATE S0010
			SET
				password			=	@P_password
			,	upd_user			=	@P_cre_user
			,	upd_ip				=	@P_cre_ip
			,	upd_prg				=	'M0001'	
			,	upd_datetime		=	@w_time
			FROM S0010 
			WHERE 
				S0010.company_cd		=	@P_company_cd 
			AND	S0010.user_id			=	@P_user_id
			AND	S0010.authority_typ		=	4
			AND	S0010.del_datetime	IS NULL 
		END
		ELSE
		BEGIN
			--
			IF EXISTS (SELECT 1 FROM S0010 WHERE company_cd = @P_company_cd) OR @P_company_cd = 0
			BEGIN
				INSERT INTO @ERR_TBL VALUES(
					63
				,	'#user_id'
				,	0-- oderby
				,	2-- dialog  
				,	0
				,	0
				,	'user_id not found'
				)
			END
			--
			IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
			BEGIN
				INSERT INTO S0010
				SELECT
					@P_company_cd			
				,	@P_user_id
				,	0			-- employee_cd
				,	@P_password
				,	@P_sso_user
				,	4				-- authority_typ
				,	0				-- authority_cd
				,	4				-- 1on1_authority_typ
				,	0				-- 1on1_authority_cd
				,	4				-- multireview_authority_typ
				,	0				-- multireview_authority_cd
				,	4				-- report_authority_typ
				,	0				-- report_authority_cd
				,	4				-- empinfo_authority_typ
				,	0				-- empinfo_authority_cd
				,	4				-- setting_authority_typ
				,	0				-- setting_authority_cd
				,	1				-- language
				,	NULL
				,	''
				,	NULL
				,	NULL
				,	@w_time
				,	''
				,	NULL
				,	@P_cre_user
				,	@P_cre_ip
				,	'M0001'	
				,	@w_time
				,	''
				,	''
				,	''
				,	NULL
				,	''
				,	''
				,	''
				,	NULL
			END
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
END

GO
