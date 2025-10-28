IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_OI1011_INQ1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_OI1011_INQ1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：OI1011 - Refer
 *
 *  作成日  ：2020/11/10
 *  作成者  ：ANS-ASIA nghianm
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_OI1011_INQ1]
	@P_mail_kbn			SMALLINT = 0
,	@P_company_cd		SMALLINT = 0
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
		ISNULL(M2500.company_cd,0)		AS		company_cd
	,	ISNULL(M2500.mail_kbn,0)		AS		mail_kbn
	,	ISNULL(M2500.infomation,0)		AS		infomation
	,	ISNULL(M2500.mail,0)			AS		mail
	,	ISNULL(M2500.title,'')			AS		title
	,	ISNULL(M2500.[message],'')		AS		[message]
	,	ISNULL(M2500.sending_target,0)	AS		sending_target
	,	ISNULL(M2500.send_date,'')		AS		send_date
	,	ISNULL(M2500.send_kbn,0)		AS		send_kbn
	,	ISNULL(M2500.arrange_order,0)	AS		arrange_order
	FROM M2500
	WHERE M2500.company_cd = @P_company_cd
	AND   M2500.mail_kbn   = @P_mail_kbn
	AND	  del_datetime IS NULL

END

GO
