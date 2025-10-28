IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_oM0310_INQ1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_oM0310_INQ1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：oM0310 - Refer
 *
 *  作成日  ：2020/11/06
 *  作成者  ：ANS-ASIA DUONGNTT
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_oM0310_INQ1]
	@P_company_cd		SMALLINT = 0
AS
BEGIN
	SET NOCOUNT ON;

	CREATE TABLE #M2200 (
		id					INT IDENTITY(1, 1)
	,	adaption_date		NVARCHAR(50)
	,	interview_cd		SMALLINT
	,	interview_nm		NVARCHAR(50)
	)
	--[0]
	SELECT
		M2600.[1on1_group_cd]	
	,	M2600.[1on1_group_nm]		
	--	
	,	M2610.coach_position_cd				AS coach_position_cd
	,	M2610.frequency						AS frequency
	,	ISNULL(M2610.[1on1_times],0)				AS times
	,	M2610.interview_cd					AS interview_cd
	FROM M2600
	LEFT JOIN M2610 ON (
		M2600.[1on1_group_cd]	=	M2610.[1on1_group_cd]
	AND M2600.company_cd		=	M2610.company_cd
	AND M2610.del_datetime IS NULL
	)
	WHERE 
		M2600.company_cd		=	@P_company_cd
	AND M2600.del_datetime IS NULL
	ORDER BY 
		M2600.[1on1_group_cd]
	--M2200
	INSERT INTO #M2200
	SELECT
		MIN(M2200.adaption_date)
	,	M2200.interview_cd	
	,	''		
	FROM M2200
	WHERE 
		M2200.company_cd	=	@P_company_cd
	AND M2200.del_datetime IS NULL
	GROUP BY 
		M2200.interview_cd	
	
	UPDATE #M2200
	SET interview_nm			=	M2200.interview_nm
	FROM #M2200
	INNER JOIN M2200 ON (
		#M2200.interview_cd		=	M2200.interview_cd
	AND #M2200.adaption_date	=	M2200.adaption_date
	AND M2200.company_cd		=	@P_company_cd
	AND M2200.del_datetime IS NULL
	)
	--[1]
	SELECT
		#M2200.interview_cd	AS interview_cd
	,	#M2200.interview_nm	AS interview_nm
	FROM #M2200
	ORDER BY 
		#M2200.interview_cd

	--
	DROP TABLE #M2200
END
GO
