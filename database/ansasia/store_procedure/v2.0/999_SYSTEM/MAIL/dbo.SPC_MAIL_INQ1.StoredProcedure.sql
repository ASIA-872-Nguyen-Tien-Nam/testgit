DROP PROCEDURE [SPC_MAIL_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ [SPC_MAIL_INQ1]
-- EXEC [SPC_MAIL_INQ1]'','';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	MAIL
--*  
--*  作成日/create date			:	2018/12/06				
--*　作成者/creater				:	sondh								
--*   					
--*  更新日/update date			:	2019/04/24		
--*　更新者/updater				:　	longvv
--*　更新内容/update content	:	Bccのメールを追加。
--*   					
--*  更新日/update date			:	2023/06/21		
--*　更新者/updater				:　	yamazaki
--*　更新内容/update content	:	週報機能を追加
--*   					
--****************************************************************************************
CREATE PROCEDURE [SPC_MAIL_INQ1]

AS
BEGIN
    DECLARE @BCC AS nvarchar(50) = 'm-yamazaki@ans-net.co.jp'
	SET NOCOUNT ON;
	--[0]
	SELECT
		ISNULL(F0901.company_cd,0)												AS company_cd
	,	CONCAT(ISNULL(F0901.company_cd,0),'_',ISNULL(M0001.company_nm,''))		AS company_nm
	,	ISNULL(F0901.employee_cd,'')											AS employee_cd
	,	ISNULL(M0070.employee_nm,'')											AS employee_nm
	,	ISNULL(F0901.send_mailaddress,'')										AS send_mailaddress
	,	ISNULL(F0901.infomation_title,'')										AS infomation_title
	,	FORMAT(F0901.infomation_date,'yyyy/MM/dd')								AS infomation_date
	,	ISNULL(F0901.infomation_message,'')										AS infomation_message
	,	@BCC 												                    AS mail_bcc
	,	ISNULL(S0010.language,'')												AS [language]
	FROM F0901 WITH(NOLOCK) 
	LEFT JOIN M0001 ON (
		F0901.company_cd =	M0001.company_cd
	AND M0001.del_datetime IS NULL
	)
	LEFT JOIN M0070 ON (
		F0901.company_cd	= M0070.company_cd
	AND F0901.employee_cd	=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT JOIN S0010 ON (
		F0901.company_cd		=	S0010.company_cd
	AND F0901.employee_cd		=	S0010.employee_cd
	AND S0010.del_datetime IS NULL
	)
	WHERE 
		F0901.del_datetime IS NULL
    AND F0901.send_mailaddress !=''
	AND F0901.send_datetime IS NULL
	UNION
	SELECT
		ISNULL(F2901.company_cd,0)												AS company_cd
	,	CONCAT(ISNULL(F2901.company_cd,0),'_',ISNULL(M0001.company_nm,''))		AS company_nm
	,	ISNULL(F2901.employee_cd,'')											AS employee_cd
	,	ISNULL(M0070.employee_nm,'')											AS employee_nm
	,	ISNULL(F2901.send_mailaddress,'')										AS send_mailaddress
	,	ISNULL(F2901.infomation_title,'')										AS infomation_title
	,	FORMAT(F2901.infomation_date,'yyyy/MM/dd')								AS infomation_date
	,	ISNULL(F2901.infomation_message,'')										AS infomation_message
	,	@BCC 												                    AS mail_bcc
	,	ISNULL(S0010.language,'')												AS [language]
	FROM F2901 WITH(NOLOCK) 
	LEFT JOIN M0001 ON (
		F2901.company_cd =	M0001.company_cd
	AND M0001.del_datetime IS NULL
	)
	LEFT JOIN M0070 ON (
		F2901.company_cd	= M0070.company_cd
	AND F2901.employee_cd	=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT JOIN S0010 ON (
		F2901.company_cd		=	S0010.company_cd
	AND F2901.employee_cd		=	S0010.employee_cd
	AND S0010.del_datetime IS NULL
	)
	WHERE 
		F2901.del_datetime IS NULL
    AND F2901.send_mailaddress !=''
	AND F2901.send_datetime IS NULL
	--
	--2023/06/21 add by yamazaki
	UNION
	SELECT
		ISNULL(F4901.company_cd,0)												AS company_cd
	,	CONCAT(ISNULL(F4901.company_cd,0),'_',ISNULL(M0001.company_nm,''))		AS company_nm
	,	ISNULL(F4901.employee_cd,'')											AS employee_cd
	,	ISNULL(M0070.employee_nm,'')											AS employee_nm
	,	ISNULL(F4901.send_mailaddress,'')										AS send_mailaddress
	,	ISNULL(F4901.infomation_title,'')										AS infomation_title
	,	FORMAT(F4901.infomation_date,'yyyy/MM/dd')								AS infomation_date
	,	ISNULL(F4901.infomation_message,'')										AS infomation_message
	,	@BCC 												                    AS mail_bcc
	,	ISNULL(S0010.language,'')												AS [language]
	FROM F4901 WITH(NOLOCK) 
	LEFT JOIN M0001 ON (
		F4901.company_cd =	M0001.company_cd
	AND M0001.del_datetime IS NULL
	)
	LEFT JOIN M0070 ON (
		F4901.company_cd	= M0070.company_cd
	AND F4901.employee_cd	=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT JOIN S0010 ON (
		F4901.company_cd		=	S0010.company_cd
	AND F4901.employee_cd		=	S0010.employee_cd
	AND S0010.del_datetime IS NULL
	)
	WHERE 
		F4901.del_datetime IS NULL
    AND F4901.send_mailaddress !=''
	AND F4901.send_datetime IS NULL
END	
GO
