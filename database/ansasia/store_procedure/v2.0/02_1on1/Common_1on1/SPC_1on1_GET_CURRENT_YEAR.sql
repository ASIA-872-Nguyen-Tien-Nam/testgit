IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_1on1_GET_CURRENT_YEAR]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].SPC_1on1_GET_CURRENT_YEAR
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：COMMON - SPC_1on1_GET_CURRENT_YEAR
 *
 *  作成日  ：2020/12/10
 *  作成者  ：ANS-ASIA datNT
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_1on1_GET_CURRENT_YEAR]
	@P_company_cd				SMALLINT	= 0		
,	@P_date						NVARCHAR(20)		= ''
,	@P_mode						INT					=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_year					INT			= 0
	,	@beginning_date			DATE		= NULL
	,	@year_end				DATE		= NULL	
	,	@P_year_date_from		DATE		= NULL	
	,	@year_end_30day				DATE		= NULL	
	SELECT	
		--@beginning_date		=	M0100.beginning_date
		@beginning_date		=	M9100.[1on1_beginning_date]
	FROM M9100
	WHERE
		M9100.company_cd			=	@P_company_cd
	AND M9100.del_datetime IS NULL
	--
	IF(@P_date = '')
	BEGIN
		SET @P_date = NULL
	END
	--
	IF @P_mode = 1 
	BEGIN
		SET @w_year = @P_date
	END
	ELSE
	BEGIN
		SET @w_year =  (SELECT  dbo.FNC_GET_YEAR_1ON1(@P_company_cd , @P_date))
	END
	IF @beginning_date IS NOT NULL
	BEGIN
		SET @P_year_date_from	= CAST((CAST(@w_year AS nvarchar(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		SET @year_end			= DATEADD(DD,-1,DATEADD(YYYY,1,@P_year_date_from))
	END
	ELSE
	BEGIN 
		--
		SET @year_end			=	CAST((CAST(@w_year AS nvarchar(4)) + '/12/31') AS DATE)
	END

	SET @year_end_30day = DATEADD(DD,30,@year_end)
	--[0]
	SELECT 
		@w_year				AS fiscal_year
	,	FORMAT(@year_end_30day,'yyyy/MM/dd')		AS year_end_30day
END

GO
