DROP PROCEDURE [SPC_M0001_COOPORATE_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************
--*   											
--*  処理概要/process overview	:	M0030,M0040
--*  
--*  作成日/create date			:	2019/01/14						
--*　作成者/creater				:	DATNT
--*   					
--*  更新日/update date			:  
--*　更新者/updater				:　
--*　更新内容/update content	:	
--****************************************************************************************
CREATE PROCEDURE [SPC_M0001_COOPORATE_INQ1]
@P_company_cd	INT = 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @w_date date = getdate()
		,	@addNewButton				INT =	1
		,	@saveButton					INT	=	1
		,	@deleteButton				INT	=	1
		,	@CreateDepartmentButton		INT	=	1
		,	@deleteParentButton			INT	=	1
		,	@CreateDivisionButton		INT	=	1
		,	@deleteDivisionButton		INT	=	1
	--
	IF(SELECT cooperation_typ FROM M0001 WHERE company_cd = @P_company_cd) = 1
	BEGIN
		SET @addNewButton				= 0
		SET	@saveButton					= 0
		SET	@deleteButton				= 0
		SET @CreateDepartmentButton		= 0
		SET @deleteParentButton			= 0
		SET @CreateDivisionButton		= 0
		SET @deleteDivisionButton		= 0
	END
	--[0]
	SELECT	@addNewButton				AS addNewButton
		,	@saveButton					AS saveButton
		,	@deleteButton				AS deleteButton
		,	@CreateDepartmentButton		AS CreateDepartmentButton	
		,	@deleteParentButton			AS deleteParentButton		
		,	@CreateDivisionButton		AS CreateDivisionButton	
		,	@deleteDivisionButton		AS deleteDivisionButton	
END
GO
