DROP PROCEDURE [SPC_RI0020_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 -- +--TEST--+
-- EXEC SPC_RI0020_ACT1 782,2023,'721'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	SAVE TARGET OF EMPLOYEE rI0020 個人目標登録
--*  
--*  作成日/create date			:	2023/05/08						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_RI0020_ACT1] 
	@P_fiscal_year		SMALLINT		=	0
,	@P_target1			NVARCHAR(1000)	=	''
,	@P_target2			NVARCHAR(1000)	=	''
,	@P_target3			NVARCHAR(1000)	=	''
,	@P_target4			NVARCHAR(1000)	=	''
,	@P_target5			NVARCHAR(1000)	=	''
,	@P_employee_cd		NVARCHAR(10)	=	''
,	@P_cre_user			NVARCHAR(50)	=	''
,	@P_cre_ip			NVARCHAR(50)	=	''
,	@P_company_cd		SMALLINT		=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2	 = SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	BEGIN TRY
	BEGIN TRANSACTION
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			IF EXISTS (SELECT 1 FROM F4000 WHERE company_cd = @P_company_cd AND fiscal_year = @P_fiscal_year AND employee_cd = @P_employee_cd)
			BEGIN
				UPDATE F4000 SET 
					target1			=	CASE 
											WHEN ISNULL(M4000.target1_use_typ,0) = 1 
											THEN @P_target1
											ELSE SPACE(0)
										END
				,	target2			=	CASE 
											WHEN ISNULL(M4000.target2_use_typ,0) = 1 
											THEN @P_target2
											ELSE SPACE(0)
										END
				,	target3			=	CASE 
											WHEN ISNULL(M4000.target3_use_typ,0) = 1 
											THEN @P_target3
											ELSE SPACE(0)
										END
				,	target4			=	CASE 
											WHEN ISNULL(M4000.target4_use_typ,0) = 1 
											THEN @P_target4
											ELSE SPACE(0)
										END
				,	target5			=	CASE 
											WHEN ISNULL(M4000.target5_use_typ,0) = 1 
											THEN @P_target5
											ELSE SPACE(0)
										END
				,	upd_user		=	@P_cre_user
				,	upd_ip			=	@P_cre_ip
				,	upd_prg			=	'ri0020'
				,	upd_datetime	=	@w_time
				,	del_user		=	SPACE(0)
				,	del_ip			=	SPACE(0)
				,	del_prg			=	SPACE(0)
				,	del_datetime	=	NULL					
				FROM F4000
				INNER JOIN M4000 ON (
					F4000.company_cd		=	M4000.company_cd
				AND F4000.fiscal_year		=	M4000.fiscal_year
				AND M4000.del_datetime IS NULL
				)
				WHERE 
					F4000.company_cd	=	@P_company_cd
				AND F4000.fiscal_year	=	@P_fiscal_year
				AND F4000.employee_cd	=	@P_employee_cd
			END
			ELSE
			BEGIN
				INSERT INTO F4000
				SELECT 
					@P_company_cd
				,	@P_fiscal_year
				,	@P_employee_cd
				,	CASE 
						WHEN ISNULL(M4000.target1_use_typ,0) = 1 
						THEN @P_target1
						ELSE SPACE(0)
					END
				,	CASE 
						WHEN ISNULL(M4000.target2_use_typ,0) = 1 
						THEN @P_target2
						ELSE SPACE(0)
					END
				,	CASE 
						WHEN ISNULL(M4000.target3_use_typ,0) = 1 
						THEN @P_target3
						ELSE SPACE(0)
					END
				,	CASE 
						WHEN ISNULL(M4000.target4_use_typ,0) = 1 
						THEN @P_target4
						ELSE SPACE(0)
					END
				,	CASE 
						WHEN ISNULL(M4000.target5_use_typ,0) = 1 
						THEN @P_target5
						ELSE SPACE(0)
					END
				,	@P_cre_user
				,	@P_cre_ip
				,	'ri0020'
				,	@w_time
				,	SPACE(0)
				,	SPACE(0)
				,	SPACE(0)
				,	NULL
				,	SPACE(0)
				,	SPACE(0)
				,	SPACE(0)
				,	NULL
				FROM M4000
				WHERE 
					M4000.company_cd	=	@P_company_cd
				AND M4000.fiscal_year	=	@P_fiscal_year
				AND M4000.del_datetime IS NULL
				
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
