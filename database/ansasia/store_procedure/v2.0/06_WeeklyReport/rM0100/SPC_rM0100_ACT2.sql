SET ANSI_NULLS ON
GO
DROP PROCEDURE [dbo].[SPC_rM0100_ACT2]
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	DELETE DATA
--*  
--* 作成日/create date			:	2023/04/11									
--*	作成者/creater				:	quangnd						
--*   					
--*	更新日/update date			:  			
--*	更新者/updater				:　 						     	 
--*	更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_rM0100_ACT2] 
	@P_report_kind					SMALLINT			= 0	
,	@P_question_no					SMALLINT			= 0
,	@P_company_cd_refer				SMALLINT			= 0
,	@P_cre_user						NVARCHAR(50)		= ''
,	@P_cre_ip						NVARCHAR(50)		= ''
,	@P_company_cd					SMALLINT			= 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time							DATETIME2			= SYSDATETIME()
	,	@ERR_TBL						ERRTABLE			  
	,	@order_by_min					INT					= 0
	
	--
	IF ( @P_company_cd_refer = 0 AND @P_company_cd <> 0)
	BEGIN
		INSERT INTO @ERR_TBL VALUES(
			122
		,	'#company_cd_refer'
		,	0-- oderby
		,	1-- dialog  
		,	0
		,	0
		,	'not have permission'
		)
	END
	IF EXISTS (SELECT 1 FROM @ERR_TBL)  GOTO COMPLETE_QUERY
	--
	IF NOT EXISTS (SELECT 1 FROM M4125 WHERE company_cd = @P_company_cd AND report_kind = @P_report_kind AND question_no = @P_question_no AND del_datetime IS NULL)
	BEGIN
		INSERT INTO @ERR_TBL VALUES(
			21
		,	'#report_kind'
		,	0-- oderby
		,	1-- dialog  
		,	0
		,	0
		,	'report_kind not found'
		)
	END
	IF EXISTS (SELECT 1 FROM @ERR_TBL)  GOTO COMPLETE_QUERY
	--
	IF EXISTS	(	SELECT 1
					FROM M4201
					INNER JOIN M4200 ON (
						M4201.company_cd	= M4200.company_cd
					AND M4201.report_kind	= M4200.report_kind
					AND M4201.sheet_cd		= M4200.sheet_cd
					AND M4201.adaption_date	= M4200.adaption_date
					AND M4200.del_datetime IS NULL
					)
					WHERE
						M4201.company_cd	= @P_company_cd
					AND (M4201.report_kind	= @P_report_kind
						OR @P_report_kind	= 0)
					AND M4201.question_no	= @P_question_no
					AND M4201.del_datetime IS NULL
				)
	BEGIN
		INSERT INTO @ERR_TBL VALUES(
			155
		,	'question_no'
		,	0-- oderby
		,	1-- dialog  
		,	0
		,	0
		,	'question_no EXISTS'
		)
	END
	IF EXISTS (SELECT 1 FROM @ERR_TBL)  GOTO COMPLETE_QUERY
		-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			--M4125
			UPDATE M4125
			SET
				del_user		=	@P_cre_user
			,	del_ip			=	@P_cre_ip
			,	del_prg			=	'rM0100'
			,	del_datetime	=	@w_time
			WHERE
				company_cd		=	@P_company_cd
			AND	report_kind		=	@P_report_kind
			AND question_no		=	@P_question_no
			
			--M4126
			UPDATE M4126
			SET
				del_user		=	@P_cre_user
			,	del_ip			=	@P_cre_ip
			,	del_prg			=	'rM0100'
			,	del_datetime	=	@w_time
			WHERE
				company_cd		=	@P_company_cd
			AND question_no		=	@P_question_no
			
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
