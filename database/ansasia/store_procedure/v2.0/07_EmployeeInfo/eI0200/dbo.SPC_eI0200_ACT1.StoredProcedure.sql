DROP PROCEDURE [SPC_eI0200_ACT1]
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
--*  作成日/create date			:	2024/04/03
--*　作成者/creater				:	manhnd						
--*  作成内容/create content		:	save ei0200			
--*	 更新日/update date			:  	
--*	 更新者/updater				:　 
--*	 更新内容/update content	:	
--****************************************************************************************
CREATE PROCEDURE [SPC_eI0200_ACT1] 
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
	-- SCREEN
	,	@w_initial_floor_id					SMALLINT			=	0
	,	@w_employee_cd						NVARCHAR(10)		=	N''
	,	@w_picture							NVARCHAR(100)		=	N''
	,	@w_clear_file						SMALLINT			=	0
	-- TABLES
	CREATE TABLE #TABLE_DETAILS (
        id									BIGINT			IDENTITY(1,1)
    ,   company_cd							SMALLINT
    ,   employee_cd							NVARCHAR(10)
    ,   field_cd							SMALLINT
    ,   registered_value					NVARCHAR(100)
    )
	--START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		--SET VALUES
		SET @w_initial_floor_id				=	JSON_VALUE(@P_json,'$.initial_floor_id')
		SET @w_employee_cd					=	IIF(JSON_VALUE(@P_json,'$.employee_cd') = N'', N'0', JSON_VALUE(@P_json,'$.employee_cd'))
		SET @w_picture						=	JSON_VALUE(@P_json,'$.file_name')
		SET @w_clear_file					=	JSON_VALUE(@P_json,'$.clear_file')

		INSERT INTO #TABLE_DETAILS
		SELECT 
			@P_company_cd
		,	@w_employee_cd
		,	JSON_VALUE([value],'$.field_cd')			AS	field_cd
		,	JSON_VALUE([value],'$.registered_value')	AS	registered_value
		FROM OPENJSON(@P_json,'$.tr')

		--F5000
		IF NOT EXISTS (SELECT 1 FROM F5000 WHERE company_cd = @P_company_cd AND employee_cd = @w_employee_cd AND del_datetime IS NULL)
		BEGIN
			INSERT INTO F5000
			SELECT
				@P_company_cd
			,	@w_employee_cd
			,	@w_picture
			,	@w_initial_floor_id
			,	@P_cre_user				--cre_user
			,	@P_cre_ip				--cre_ip
			,	N'eI0200'				--cre_prg
			,	@w_time					--cre_datetime
			,	SPACE(0)				--upd_user
			,	SPACE(0)				--upd_ip
			,	SPACE(0)				--upd_prg
			,	NULL					--upd_datetime
			,	SPACE(0)				--del_user
			,	SPACE(0)				--del_ip
			,	SPACE(0)				--del_prg
			,	NULL					--del_datetime
		END	
		ELSE 
		BEGIN
			UPDATE F5000 SET
				picture				=	CASE 
											WHEN @w_clear_file = 0 AND @w_picture IS NOT NULL THEN @w_picture
											WHEN @w_clear_file = 0 AND @w_picture IS NULL THEN picture
											WHEN @w_clear_file = 1 THEN N''
										END
			,	initial_floor_id	=	@w_initial_floor_id
			,	upd_user			=	@P_cre_user
			,	upd_ip				=	@P_cre_ip
			,	upd_prg				=	N'eI0200'
			,	upd_datetime		=	@w_time
			WHERE
				company_cd			=	@P_company_cd
			AND	employee_cd			=	@w_employee_cd
			AND del_datetime IS NULL
		END

		--F5001
		--DELETE
		UPDATE F5001 SET
			F5001.del_user				=	@P_cre_user
		,	F5001.del_ip				=	@P_cre_ip
		,	F5001.del_prg				=	N'eI0200'
		,	F5001.del_datetime			=	@w_time
		FROM F5001
		LEFT OUTER JOIN #TABLE_DETAILS ON (
			F5001.company_cd			=	#TABLE_DETAILS.company_cd
		AND	F5001.employee_cd			=	#TABLE_DETAILS.employee_cd
		AND	F5001.field_cd				=	#TABLE_DETAILS.field_cd
		)
		WHERE
			#TABLE_DETAILS.field_cd IS NULL
		AND F5001.company_cd			=	@P_company_cd
		AND F5001.employee_cd			=	@w_employee_cd

		--UPDATE
		UPDATE F5001 SET
			F5001.registered_value		=	#TABLE_DETAILS.registered_value
		,	F5001.upd_user				=	@P_cre_user
		,	F5001.upd_ip				=	@P_cre_ip
		,	F5001.upd_prg				=	N'eI0200'
		,	F5001.upd_datetime			=	@w_time
		FROM #TABLE_DETAILS
		INNER JOIN F5001 ON (
			#TABLE_DETAILS.company_cd				=	F5001.company_cd
		AND	#TABLE_DETAILS.employee_cd				=	F5001.employee_cd
		AND	#TABLE_DETAILS.field_cd					=	F5001.field_cd
		)

		--INSERT
		INSERT INTO F5001
		SELECT
			@P_company_cd
		,	@w_employee_cd
		,	#TABLE_DETAILS.field_cd
		,	#TABLE_DETAILS.registered_value
		,	@P_cre_user				--cre_user
		,	@P_cre_ip				--cre_ip
		,	N'eI0200'				--cre_prg
		,	@w_time					--cre_datetime
		,	SPACE(0)				--upd_user
		,	SPACE(0)				--upd_ip
		,	SPACE(0)				--upd_prg
		,	NULL					--upd_datetime
		,	SPACE(0)				--del_user
		,	SPACE(0)				--del_ip
		,	SPACE(0)				--del_prg
		,	NULL					--del_datetime
		FROM #TABLE_DETAILS
		LEFT OUTER JOIN F5001 ON (
			#TABLE_DETAILS.company_cd				=	F5001.company_cd
		AND	#TABLE_DETAILS.employee_cd				=	F5001.employee_cd
		AND	#TABLE_DETAILS.field_cd					=	F5001.field_cd
		)
		WHERE
			F5001.company_cd IS NULL

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
