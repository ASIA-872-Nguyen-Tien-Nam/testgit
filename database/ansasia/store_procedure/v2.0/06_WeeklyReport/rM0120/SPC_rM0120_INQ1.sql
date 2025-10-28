BEGIN
    DROP PROCEDURE [dbo].[SPC_rM0120_INQ1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：rM0120 - Refer
 *
 *  作成日  ：2023/04/07
 *  作成者  ：ANS-ASIA quangnd
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_rM0120_INQ1]
	@P_company_cd		SMALLINT		= 0
,	@P_mark_kbn			SMALLINT		= 1
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_mark_type		SMALLINT	= 1
		--
	SELECT 
		@w_mark_type  = ISNULL(mark_type,1)
	FROM M4122
	WHERE 
		company_cd	= @P_company_cd
	AND	mark_kbn	= @P_mark_kbn
	AND del_datetime IS NULL
	--[0]
	IF EXISTS (SELECT 1 FROM M4122 WHERE M4122.company_cd = @P_company_cd AND M4122.mark_kbn = @P_mark_kbn AND M4122.del_datetime IS NULL)
	BEGIN
	SELECT
		ISNULL(M4122.mark_kbn,0)							AS mark_kbn
	,	ISNULL(M4122.[name],'')								AS [name]
	,	ISNULL(M4122.mark_type,0)							AS mark_type
	,	1													AS check_exits
	FROM M4122
	WHERE
		M4122.company_cd	= @P_company_cd
	AND	M4122.mark_kbn		= @P_mark_kbn
	AND	M4122.del_datetime IS NULL
	END
	ELSE
	BEGIN
	----[0]
	SELECT
		@P_mark_kbn										AS 	mark_kbn											
	,	''												AS [name]
	,	1												AS mark_type			
	,	0												AS check_exits
	END
END
GO
