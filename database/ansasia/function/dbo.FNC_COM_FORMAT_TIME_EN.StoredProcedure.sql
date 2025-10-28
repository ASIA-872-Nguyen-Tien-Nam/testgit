IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FNC_COM_FORMAT_TIME_EN]') AND type IN (N'F', N'FN'))
BEGIN
    DROP FUNCTION [dbo].[FNC_COM_FORMAT_TIME_EN]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
/****************************************************************************************************
 *
 *  処理概要：COMMON
 *
 *  作成日  ：2022/09/09
 *  作成者  ：ANS-ASIA VIETDT
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
/*パラメータ*/
CREATE FUNCTION [dbo].[FNC_COM_FORMAT_TIME_EN](
	--
	@P_Times INT	= 0
)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE 
		@w_text		NVARCHAR(30) =	''

	SET @w_text = ( 
		SELECT Cast(
			@P_Times AS VARCHAR(15)) + 
	   CASE 
			WHEN @P_Times % 100 IN (11,12,13) THEN 'th' 
			WHEN @P_Times % 10 = 1 THEN 'st' 
			WHEN @P_Times % 10 = 2 THEN 'nd' 
			WHEN @P_Times % 10 = 3 THEN 'rd' 
	   ELSE 'th' 
	   END
	  )
	--
	RETURN @w_text
END
--
--
GO