DROP PROCEDURE [SPC_EVALUATION_NOTIFICATION_MAIL_INQ2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC [SPC_MAIL_INQ1]'','';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	REFER EVALUTATION NOTIFICATION MAIL FROM F0903
--*  
--*  作成日/create date			:	2024/07/12				
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:　	
--*　更新内容/update content		:	
--*	 
--****************************************************************************************
CREATE PROCEDURE [SPC_EVALUATION_NOTIFICATION_MAIL_INQ2]
AS
BEGIN
	SET NOCOUNT ON;
	--[0]
	SELECT
		F0903.company_cd					AS	company_cd
	,	F0903.information_date				AS	information_date
	,	F0903.information_typ				AS	information_typ
	,	F0903.employee_cd					AS	employee_cd
	,	ISNULL(M0070.employee_nm,'')		AS	employee_nm
	,	F0903.send_mailaddress				AS	send_mailaddress
	,	F0903.information_title				AS	[subject]
	,	F0903.information_message			AS	[mail_message]
	,	F0903.target_employee_list			AS	target_employee_list
	,	ISNULL(S0010.language,0)			AS  [language]
	,	CASE 
			WHEN F0903.information_typ = 1
			THEN 2	--　2.評価確定 
			ELSE 3	--　3.本人フィードバック
		END									AS	mail_type
	FROM F0903 WITH(NOLOCK) 
	LEFT OUTER JOIN M0070 ON (
		F0903.company_cd		=	M0070.company_cd
	AND F0903.employee_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT OUTER JOIN S0010 ON (
		F0903.company_cd		=	S0010.company_cd
	AND F0903.employee_cd		=	S0010.employee_cd
	AND S0010.del_datetime IS NULL
	)
	WHERE 
		F0903.del_datetime IS NULL
    AND F0903.send_datetime IS NULL
	AND F0903.send_mailaddress <> ''
END	
GO