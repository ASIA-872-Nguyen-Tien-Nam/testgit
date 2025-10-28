DROP PROCEDURE [SPC_B0030_BATCH01]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SPC_B0030_BATCH01]
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	B0030 *社員情報：フリーアドレスの座席初期化
--*  
--*  作成日/create date			:	2024/07/02
--*　作成者/creater				:	yamazaki
--*   					
--*  更新日/update date			:  
--*　更新者/updater				:　
--*　更新内容/update content	:	
--****************************************************************************************
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @w_now          datetime     = getdate()
          , @P_cre_user	    nvarchar(50) = 'system'
	      , @P_cre_ip	    nvarchar(50) = ''
		  , @P_cre_prg      nvarchar(20) = 'B0030'
	--
	CREATE TABLE #M5200 (
		company_cd		smallint
	,	floor_id		smallint
	)
	INSERT INTO #M5200
	SELECT M5200.company_cd,M5201.floor_id
	       FROM M5200
		        LEFT OUTER JOIN M5201 ON (M5200.company_cd = M5201.company_cd)
		   WHERE M5200.seating_chart_use_typ = 1 --1:座席表を利用する
		     AND M5201.seating_chart_typ     = 2 --2:フリーアドレス
		     AND M5200.del_datetime IS NULL
	--
	UPDATE F5100
	SET del_user		=	@P_cre_user
	,	del_ip			=	@P_cre_ip
	,	del_prg         =	@P_cre_prg
	,	del_datetime	=	@w_now
	FROM F5100
	INNER JOIN #M5200 ON (
		F5100.company_cd	=	#M5200.company_cd
	AND F5100.floor_id	    =	#M5200.floor_id
	)
END
GO
