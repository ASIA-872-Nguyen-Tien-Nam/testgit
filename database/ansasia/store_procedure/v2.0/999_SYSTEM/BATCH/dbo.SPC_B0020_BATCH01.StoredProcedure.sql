DROP PROCEDURE [SPC_B0020_BATCH01]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SPC_B0020_BATCH01]
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	B0020
--*  
--*  作成日/create date			:	2021/03/18
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
          , @w_date         date
	      ,	@beginning_date	date         = NULL
	      ,	@fiscal_year    int	         = NULL
	      , @P_cre_user	    nvarchar(50) = 'system'
	      , @P_cre_ip	    nvarchar(50) = ''
	--
	SET @w_date = @w_now
	--
	CREATE TABLE #M0100 (
		company_cd		smallint
	,   beginning_date  date
	,	fiscal_year		int	
	)
	INSERT INTO #M0100
	SELECT company_cd,CAST((FORMAT(@w_date,'yyyy') + '/' + FORMAT(beginning_date,'MM/dd')) AS DATE),FORMAT(@w_date,'yyyy')
	       FROM M9100
		   WHERE MONTH(beginning_date)=MONTH(@w_date)
		     AND DAY(beginning_date)  =DAY(@w_date)
		     AND M9100.del_datetime IS NULL
	--
	--1on1権限更新
	--1:メンバー
	UPDATE S0010
	SET S0010.[1on1_authority_typ]		    =	CASE WHEN F2001.company_cd IS NULL THEN 0  ELSE 1 END
	,	S0010.upd_user						=	@P_cre_user
	,	S0010.upd_ip						=	@P_cre_ip
	,	S0010.upd_prg						=	'B0020'
	,	S0010.upd_datetime					=	@w_now
	FROM S0010
	INNER JOIN #M0100 ON (
		S0010.company_cd	=	#M0100.company_cd
	)
	LEFT OUTER JOIN F2001 ON (
		#M0100.company_cd  = F2001.company_cd
	AND #M0100.fiscal_year = F2001.fiscal_year
	AND S0010.employee_cd  = F2001.employee_cd
	)
	WHERE 
		S0010.[1on1_authority_typ]	< 3
    AND S0010.del_datetime IS NULL
	--2:コーチ
	UPDATE S0010
	SET S0010.[1on1_authority_typ]		    =	2
	,	S0010.upd_user						=	@P_cre_user
	,	S0010.upd_ip						=	@P_cre_ip
	,	S0010.upd_prg						=	'B0020'
	,	S0010.upd_datetime					=	@w_now
	FROM S0010
	INNER JOIN #M0100 ON (
		S0010.company_cd	=	#M0100.company_cd
	)
	INNER JOIN F2001 ON (
		#M0100.company_cd  = F2001.company_cd
	AND #M0100.fiscal_year = F2001.fiscal_year
	AND S0010.employee_cd  = F2001.coach_cd
	)
	WHERE 
		S0010.[1on1_authority_typ]	< 3
    AND S0010.del_datetime IS NULL
	--
	--マルチレビュー権限更新
	--0:権限なし 2:サポーター
	UPDATE S0010
	SET S0010.multireview_authority_typ		=	CASE WHEN F3020.company_cd IS NULL THEN 0  ELSE 2 END
	,	S0010.upd_user						=	@P_cre_user
	,	S0010.upd_ip						=	@P_cre_ip
	,	S0010.upd_prg						=	'B0020'
	,	S0010.upd_datetime					=	@w_now
	FROM S0010
	INNER JOIN #M0100 ON (
		S0010.company_cd	=	#M0100.company_cd
	)
	LEFT OUTER JOIN F3020 ON (
		#M0100.company_cd  = F3020.company_cd
	AND #M0100.fiscal_year = F3020.fiscal_year
	AND S0010.employee_cd  = F3020.supporter_cd
	)
	WHERE 
		S0010.multireview_authority_typ	< 3
    AND S0010.del_datetime IS NULL
END
GO
