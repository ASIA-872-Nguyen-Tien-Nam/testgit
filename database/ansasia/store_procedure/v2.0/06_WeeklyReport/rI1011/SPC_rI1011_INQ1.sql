BEGIN
    DROP PROCEDURE [dbo].[SPC_rI1011_INQ1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：rI1011 - Refer
 *
 *  作成日  ：2020/11/10
 *  作成者  ：ANS-ASIA quangnd
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_rI1011_INQ1]
	@P_mail_kbn			SMALLINT = 0
,	@P_company_cd		SMALLINT = 0
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
		ISNULL(M4500.company_cd,0)		AS		company_cd
	,	ISNULL(M4500.mail_kbn,0)		AS		mail_kbn
	,	ISNULL(M4500.information,0)		AS		information
	,	ISNULL(M4500.mail,0)			AS		mail
	,	ISNULL(M4500.title,'')			AS		title
	,	ISNULL(M4500.[message],'')		AS		[message]
	,	ISNULL(M4500.sending_target,0)	AS		sending_target
	,	ISNULL(M4500.send_date,'')		AS		send_date
	,	ISNULL(M4500.send_kbn,0)		AS		send_kbn
	,	ISNULL(M4500.arrange_order,0)	AS		arrange_order
	FROM M4500
	WHERE M4500.company_cd = @P_company_cd
	AND   M4500.mail_kbn   = @P_mail_kbn
	AND	  del_datetime IS NULL

END

GO
