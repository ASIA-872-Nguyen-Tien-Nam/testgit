DROP PROCEDURE [SPC_I1010_FND1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC SPC_M0130_INQ1 '';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	I1010_評価年度マスタ
--*  
--*  作成日/create date			:	2018/09/19					
--*　作成者/creater				:	datnt								
--*   					
--*  更新日/update date			:  
--*　更新者/updater				:　
--*　更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [SPC_I1010_FND1]
	-- Add the parameters for the stored procedure here
	@P_company_cd				SMALLINT		= 0
,	@P_fiscal_year				INT				= 0
,	@P_user_id					NVARCHAR(50)	=	''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATE				=	SYSDATETIME()
	,	@beginning_date         DATE				= NULL
	,	@start_date				DATE				= NULL
	,	@fiscal_year			INT					= 0
	SET @beginning_date = (SELECT beginning_date FROM M9100 WHERE company_cd = @P_company_cd)
	IF @beginning_date IS NOT NULL
	BEGIN
		SET @start_date = CAST((FORMAT(@w_time,'yyyy') + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		IF(@w_time < @start_date)
		BEGIN 
			SET @fiscal_year =  FORMAT(DATEADD(YYYY,-1,@w_time),'yyyy')
		END
		ELSE
		BEGIN
			SET @fiscal_year = FORMAT(@start_date,'yyyy')
		END
		--SET @year_month_day = CAST((CAST(@fiscal_year AS nvarchar(4)) + '/' + FORMAT(@beginning_date,'MM/dd')) AS DATE)
		--SET @year_month_day = DATEADD(DD,-1,DATEADD(YYYY,1,@year_month_day))
	END
	ELSE
	BEGIN 
		SET @start_date		= CAST((FORMAT(@w_time,'yyyy') + '/01/01') AS DATE)
		IF(@w_time < @start_date)
		BEGIN 
			SET @fiscal_year = FORMAT(DATEADD(YYYY,-1,@w_time),'yyyy')
		END
		ELSE
		BEGIN
			SET @fiscal_year = FORMAT(@start_date,'yyyy')
		END
	END
	--[0]
	SELECT @fiscal_year AS cur_year
	--[1]
	SELECT
		M0102.detail_no
	,	treatment_applications_nm
	,	F0011.use_typ
	,	ISNULL(F0011.sheet_use_typ, 0) AS sheet_use_typ
	FROM M0102
	LEFT JOIN F0011 ON (
		M0102.company_cd	=	F0011.company_cd
	AND M0102.detail_no		=	F0011.treatment_applications_no		
	AND	fiscal_year			=	CASE @P_fiscal_year WHEN 0 THEN @fiscal_year
													ELSE 	@P_fiscal_year
								END
	)
	WHERE M0102.company_cd	= @P_company_cd
	AND	M0102.del_datetime IS NULL
END


GO
