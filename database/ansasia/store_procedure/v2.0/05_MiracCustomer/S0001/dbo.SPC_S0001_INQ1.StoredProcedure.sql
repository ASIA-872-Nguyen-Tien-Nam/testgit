DROP PROCEDURE [SPC_S0001_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- [SPC_S0001_INQ1]
--****************************************************************************************
--*   				
--*  作成日/create date			:	
--*　作成者/creater				:											
--*  更新日/update date			:	
--*
--*　更新者/updater				:　	
--*　更新内容/update content		:	
--* 
--****************************************************************************************
CREATE PROCEDURE [SPC_S0001_INQ1] 
	
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time						DATETIME2					=	SYSDATETIME()
	,	@ERR_TBL					ERRTABLE	
	SELECT 
		client_id
	,	client_secret 
	,	ISNULL(kot_client_id, '') AS kot_client_id
	,	ISNULL(kot_client_secret, '') AS kot_client_secret
	FROM S0001 
	WHERE 
		del_datetime IS NULL
	SELECT 
		ISNULL(client_id,'') AS client_id
	,	ISNULL(detail_no,0) AS detail_no
	,	ISNULL(access_token,'') AS  access_token
	,	ISNULL(refresh_token,'') AS refresh_token
	,	ISNULL([status],'')AS [status]
	,	FORMAT(S0002.effective_date, 'yyyy/MM/dd HH:mm:ss')  AS effective_date
	FROM S0002
	WHERE 
		del_datetime IS NULL
	SELECT 
		ISNULL(access_token,'') AS access_token
	,	ISNULL(refresh_token,'') AS refresh_token
	FROM S0002
	WHERE 
		S0002.[status] = 0
	AND	del_datetime IS NULL
END

GO
