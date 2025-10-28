DROP PROCEDURE [SPC_MY_PURPOSE_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC [SPC_I2010_INQ1] '2018','ans721','1','999';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	REFER MY PURPOSE
--*  
--*  作成日/create date			:	2023/03/28						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:　	
--*　更新内容/update content		:	
--*   		
--****************************************************************************************
CREATE PROCEDURE [SPC_MY_PURPOSE_INQ1]
	@P_employee_cd				nvarchar(10)	=	''
,	@P_company_cd				smallint		=	0
AS
BEGIN
	SET NOCOUNT ON;
	--[0]
	SELECT 
		ISNULL(F9000.mypurpose,'')			AS	mypurpose
	,	ISNULL(F9000.comment,'')			AS	comment
	FROM F9000
	WHERE 
		F9000.company_cd		=	@P_company_cd
	AND F9000.employee_cd		=	@P_employee_cd
	AND F9000.del_datetime IS NULL
END
GO