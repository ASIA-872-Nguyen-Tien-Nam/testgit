DROP PROCEDURE [SPC_M0010_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ M0010
-- EXEC [SPC_M0010_INQ1] '','';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	M0010
--*  
--*  作成日/create date			:	2018/08/20						
--*　作成者/creater				:	Tuantv								
--*   					
--*  更新日/update date			:  
--*　更新者/updater				:　
--*　更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_M0010_INQ1]
	@P_company_cd	SMALLINT = 0
,	@P_office_cd	SMALLINT = 0
AS
BEGIN
--[0]
	SELECT 
		M0010.company_cd								AS company_cd
	 ,  M0010.office_cd									AS office_cd
	 ,	ISNULL(M0010.office_nm,'')						AS office_nm
	 ,	ISNULL(M0010.office_ab_nm,'')					AS office_ab_nm
	 ,	IIF((M0010.zip_cd != NULL OR M0010.zip_cd !=''),(LEFT(M0010.zip_cd,3)+'-'+RIGHT(M0010.zip_cd,4)),'')	AS zip_cd
	 ,	ISNULL(M0010.address1,'')						AS address1
	 ,	ISNULL(M0010.address2,'')						AS address2
	 ,	ISNULL(M0010.address3,'')						AS address3
	 ,	ISNULL(M0010.tel,'')							AS tel
	 ,	ISNULL(M0010.fax,'')							AS fax
	 ,	ISNULL(M0010.responsible_cd,'')					AS responsible_cd
	 ,	ISNULL(M0010.arrange_order,0)					AS arrange_order
	 ,	ISNULL(M0010.responsible_cd,'')					AS employee_cd
	 ,	ISNULL(M0070.employee_nm,'')					AS employee_nm
	 FROM M0010 WITH(NOLOCK)
	 LEFT JOIN M0070 ON (
		M0010.company_cd = M0070.company_cd
	 AND M0010.responsible_cd = M0070.employee_cd
	 )
	 WHERE (M0010.company_cd = @P_company_cd)
	 AND(M0010.office_cd	 = @P_office_cd)
END
GO