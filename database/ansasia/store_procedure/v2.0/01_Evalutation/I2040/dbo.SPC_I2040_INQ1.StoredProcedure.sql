DROP PROCEDURE [SPC_I2040_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ 
-- EXEC [SPC_I2030_INQ1] '807','2'
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	I2030
--*  
--*  作成日/create date			:	2018/09/26				
--*　作成者/creater				:	Longvv								
--*   					
--*  更新日/update date			:	2021/04/02
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	when authority_typ = 3 (admin) & authority=0,1(I2040) -> set authority_typ = 2 (rater)
--*   					
--*  更新日/update date			:	2022/08/16
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	upgrade 1.9
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_I2040_INQ1]
	@P_company_cd		SMALLINT		=	0
,	@P_user_id			NVARCHAR(50)	=	''
AS
BEGIN
	DECLARE 
		@feedbackEvaluatorButton		INT				=	0
	,	@feedbackRaterButton			INT				=	0
	,	@importButton					INT				=	0
	,	@saveButton						INT				=	1
	,	@cancelButton					INT				=	1
	,	@confirmButton					INT				=	1
	,	@authority_typ					SMALLINT		=	0
	,	@authority_cd					SMALLINT		=	0
	,	@authority						SMALLINT		=	0
	,	@employee_cd_login				NVARCHAR(20)	=	''
	SET NOCOUNT ON;
	--
	--S0010
	SELECT 
		@authority_typ		=	S0010.authority_typ
	,	@authority_cd		=	S0010.authority_cd
	,	@employee_cd_login	=	S0010.employee_cd
	FROM S0010
	WHERE 
		S0010.company_cd	=	@P_company_cd
	AND	S0010.user_id		=	@P_user_id
	--↓↓↓　add by viettd 2021/04/02
	SELECT 
		@authority = ISNULL(authority,0)
	FROM S0021
	WHERE company_cd = @P_company_cd
	AND authority_cd = @authority_cd
	AND function_id = 'I2040'
	AND del_datetime IS NULL
	--↑↑↑　end add by viettd 2021/04/02
	--↓↓↓　add by viettd 2028/08/16
	IF @authority_typ = 6
	BEGIN
		SET @authority_typ = 2 -- RATER
	END
	--↑↑↑　end add by viettd 2028/08/16
	--IF @authority_typ = 3
	--	BEGIN
	--		IF NOT EXISTS (
	--		SELECT 1 FROM F0100
	--		WHERE 
	--			F0100.company_cd	=	@P_company_cd
	--		AND
	--		(
	--				rater_employee_cd_1 = @employee_cd_login 
	--			OR	rater_employee_cd_2 = @employee_cd_login 
	--			OR	rater_employee_cd_3 = @employee_cd_login 
	--			OR	rater_employee_cd_4 = @employee_cd_login
	--		)
	--		AND F0100.del_datetime IS NULL
	--		)
	--		BEGIN
	--			SET	@saveButton		= 0
	--			SET	@confirmButton	= 0
	--			SET	@cancelButton	= 0
	--		END
	--	END
	--
	SELECT  
		@feedbackRaterButton	=	CASE WHEN ISNULL(M0100.feedback_use_typ ,0)  = 1 AND (@authority_typ IN(3,4,5))
											 THEN 1
											 ELSE 0
										END	
	,	@feedbackEvaluatorButton		=	ISNULL(M0100.feedback_use_typ ,0)
	FROM M0100 
	WHERE company_cd = @P_company_cd

	SET @importButton = CASE 
							WHEN  @authority_typ = 2 THEN 0
							ELSE 1
						END 
	IF @authority_typ = 3 AND @authority IN(0,1)
	BEGIN
		SET @feedbackEvaluatorButton	= 0
		SET @feedbackRaterButton		= 0
		SET @importButton				= 0
		SET @saveButton					= 0
		SET @confirmButton				= 0
		SET @cancelButton				= 0
	END
	--[0]
	SELECT 
		@feedbackEvaluatorButton	AS	i2040FeedbackEvaluatorButton
	,	@feedbackRaterButton		AS	i2040FeedbackRaterButton 
	,	@importButton				AS	i2040ImportButton
	,	@saveButton					AS	i2040SaveButton
	,	@confirmButton				AS	i2040ConfirmButton2
	,	@cancelButton				AS	I2040DecisionCancelButton
	--[1]
	SELECT @authority_typ	AS	authority_typ
END
GO