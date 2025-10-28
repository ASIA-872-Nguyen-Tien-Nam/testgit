DROP PROCEDURE [SPC_PASSWORD_NOTIFICATION_MAIL_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC [SPC_PASSWORD_NOTIFICATION_MAIL_INQ1]
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	PASSWORD NOTIFICATION LIST MAIL
--*  
--*  作成日/create date			:	2021/07/14				
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:  
--*　更新者/updater				:　
--*　更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [SPC_PASSWORD_NOTIFICATION_MAIL_INQ1]

AS
BEGIN
	SET NOCOUNT ON;
	--[0]
	SELECT
		ISNULL(M0070.employee_nm,'')						AS	employee_nm
	,	ISNULL(F0902.send_mailaddress,'')					AS	send_mail_address
	,	ISNULL(S0010.[password],'')							AS	[password]
	,	IIF(S0010.language = 2,N'MiraiC Login Password Notification',N'MIRAIC ログインパスワードの通知')		AS	[subject]
	,	S0010.language 										AS  [language]
	,	ISNULL(F0902.serial_no,0)							AS	serial_no
	FROM F0902 WITH(NOLOCK) 
	LEFT OUTER JOIN M0070 ON (
		F0902.company_cd		=	M0070.company_cd
	AND F0902.employee_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT OUTER JOIN S0010 ON (
		F0902.company_cd		=	S0010.company_cd
	AND F0902.employee_cd		=	S0010.employee_cd
	AND S0010.del_datetime IS NULL
	)
	WHERE 
		F0902.del_datetime IS NULL
    AND F0902.send_datetime IS NULL
	AND F0902.send_mailaddress <> ''
END	
GO
