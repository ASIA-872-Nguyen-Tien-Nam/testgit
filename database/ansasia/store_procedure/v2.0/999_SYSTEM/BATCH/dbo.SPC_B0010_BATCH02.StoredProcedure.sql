DROP PROCEDURE [SPC_B0010_BATCH02]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SPC_B0010_BATCH02]
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	B0010
--*  
--*  作成日/create date			:	2021/03/30						
--*　作成者/creater				:	yamazaki
--*   					
--*  更新日/update date			:  
--*　更新者/updater				:　
--*　更新内容/update content	:	
--****************************************************************************************
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @w_now  date = getdate()
          , @w_date date
	--
	SET @w_date = @w_now--DATEADD(day,-1,@w_now) 
	--
	CREATE TABLE #F2900 (
		company_cd		    smallint
	,   information_typ     tinyint
	,   infomation          tinyint
	,   mail                tinyint
	,   information_date    date
	,	target_employee_cd  nvarchar(10)
	,   fiscal_year         int
	,   employee_cd         nvarchar(10)
	,   information_title   nvarchar(30)
	,   information_message nvarchar(50)
	)
	--
    INSERT INTO #F2900 
    --メンバーインフォメーション
    SELECT DISTINCT 
           M2500.company_cd
         , M2500.mail_kbn
		 , M2500.infomation
		 , M2500.mail
         , @w_date
         , F2010.employee_cd
		 , F2010.fiscal_year
         , F2010.employee_cd
         , M2500.title
         , M2500.message
    FROM M2500
    INNER JOIN F2010 ON (M2500.company_cd  = F2010.company_cd)
    WHERE (M2500.mail_kbn   = 1)
      AND (M2500.sending_target = 1 OR M2500.sending_target = 3)
      AND (DATEADD(day,M2500.send_date * CASE WHEN M2500.send_kbn=1 THEN -1 ELSE 1 END,F2010.[1on1_schedule_date]) = @w_date)
	  AND (M2500.del_datetime IS NULL)
    UNION
    --コーチインフォメーション
    SELECT M2500.company_cd
         , M2500.mail_kbn
		 , M2500.infomation
		 , M2500.mail
         , @w_date
         , F2010.employee_cd
		 , F2010.fiscal_year
         , F2001.coach_cd
         , M2500.title
         , M2500.message AS information_message
    FROM M2500
    INNER JOIN F2010 ON (M2500.company_cd             = F2010.company_cd)
    INNER JOIN F2001 ON (F2010.company_cd             = F2001.company_cd)
	                AND (F2010.fiscal_year            = F2001.fiscal_year)
	                AND (F2010.employee_cd            = F2001.employee_cd)
	                AND (F2010.times                  = F2001.times)
    WHERE (M2500.mail_kbn   = 1)
      AND (M2500.sending_target = 1 OR M2500.sending_target = 2)
      AND (DATEADD(day,M2500.send_date * CASE WHEN M2500.send_kbn=1 THEN -1 ELSE 1 END,F2010.[1on1_schedule_date]) = @w_date)
	  AND (M2500.del_datetime IS NULL)
    UNION
    --メンバーアラート
    SELECT DISTINCT 
           M2500.company_cd
         , M2500.mail_kbn
		 , M2500.infomation
		 , M2500.mail
         , @w_date
         , F2010.employee_cd
		 , F2010.fiscal_year
         , F2010.employee_cd
         , M2500.title
         , M2500.message
    FROM M2500
    INNER JOIN F2010 ON (M2500.company_cd             = F2010.company_cd)
    INNER JOIN F2200 ON (F2010.company_cd             = F2200.company_cd)
	                AND (F2010.fiscal_year            = F2200.fiscal_year)
	                AND (F2010.employee_cd            = F2200.employee_cd)
	                AND (F2010.times                  = F2200.times)
    WHERE (M2500.mail_kbn   = 2)
	  AND (M2500.infomation = 1)
      AND (M2500.sending_target = 1 OR M2500.sending_target = 2)
      AND (DATEADD(day,M2500.send_date * CASE WHEN M2500.send_kbn=1 THEN -1 ELSE 1 END,F2010.[1on1_schedule_date]) = @w_date)
	  AND (M2500.del_datetime IS NULL)
	  AND (F2200.fin_datetime_coach IS NULL)
    UNION
    --コーチアラート
    SELECT DISTINCT 
           M2500.company_cd
         , M2500.mail_kbn
		 , M2500.infomation
		 , M2500.mail
         , @w_date
         , F2010.employee_cd
		 , F2010.fiscal_year
         , F2001.coach_cd
         , M2500.title
         , M2500.message
    FROM M2500
    INNER JOIN F2010 ON (M2500.company_cd             = F2010.company_cd)
    INNER JOIN F2001 ON (F2010.company_cd             = F2001.company_cd)
	                AND (F2010.fiscal_year            = F2001.fiscal_year)
	                AND (F2010.employee_cd            = F2001.employee_cd)
	                AND (F2010.times                  = F2001.times)
    INNER JOIN F2200 ON (F2010.company_cd             = F2200.company_cd)
	                AND (F2010.fiscal_year            = F2200.fiscal_year)
	                AND (F2010.employee_cd            = F2200.employee_cd)
	                AND (F2010.times                  = F2200.times)
    WHERE (M2500.mail_kbn   = 2)
      AND (M2500.sending_target = 1 OR M2500.sending_target = 3)
      AND (DATEADD(day,M2500.send_date * CASE WHEN M2500.send_kbn=1 THEN -1 ELSE 1 END,F2010.[1on1_schedule_date]) = @w_date)
	  AND (M2500.del_datetime IS NULL)
	  AND (F2200.fin_datetime_coach IS NULL)
    --未実施者アラート
    SELECT DISTINCT 
           M2500.company_cd
         , M2500.mail_kbn
		 , M2500.infomation
         , @w_date
         , F2010.employee_cd
		 , F2010.fiscal_year
         , F2010.employee_cd
         , M2500.title
         , M2500.message
    FROM M2500
    INNER JOIN F2010 ON (M2500.company_cd                  = F2010.company_cd)
    LEFT OUTER JOIN F2200 ON (F2010.company_cd             = F2200.company_cd)
	                     AND (F2010.fiscal_year            = F2200.fiscal_year)
	                     AND (F2010.employee_cd            = F2200.employee_cd)
	                     AND (F2010.times                  = F2200.times)
    WHERE (M2500.mail_kbn   = 2)
      AND (M2500.sending_target = 4)
      AND (DATEADD(day,M2500.send_date * CASE WHEN M2500.send_kbn=1 THEN -1 ELSE 1 END,F2010.[1on1_schedule_date]) = @w_date)
	  AND (M2500.del_datetime IS NULL)
	  AND (F2200.fin_datetime_member IS NULL)
    UNION
    --未実施者アラート
    SELECT DISTINCT 
           M2500.company_cd
         , M2500.mail_kbn
		 , M2500.infomation
         , @w_date
         , F2010.employee_cd
		 , F2010.fiscal_year
         , F2001.coach_cd
         , M2500.title
         , M2500.message AS information_message
    FROM M2500
    INNER JOIN F2010 ON (M2500.company_cd                 = F2010.company_cd)
    INNER JOIN F2001 ON (F2010.company_cd                 = F2001.company_cd)
	                AND (F2010.fiscal_year                = F2001.fiscal_year)
	                AND (F2010.employee_cd                = F2001.employee_cd)
	                AND (F2010.times                      = F2001.times)
    LEFT OUTER JOIN F2200 ON (F2010.company_cd            = F2200.company_cd)
	                     AND (F2010.fiscal_year           = F2200.fiscal_year)
	                     AND (F2010.employee_cd           = F2200.employee_cd)
	                     AND (F2010.times                 = F2200.times)
    WHERE (M2500.mail_kbn   = 2)
      AND (M2500.sending_target = 4)
      AND (DATEADD(day,M2500.send_date * CASE WHEN M2500.send_kbn=1 THEN -1 ELSE 1 END,F2010.[1on1_schedule_date]) = @w_date)
	  AND (M2500.del_datetime IS NULL)
	  AND (F2200.fin_datetime_coach IS NULL)
    UNION
    --メンバーアンケートアラート
    SELECT DISTINCT 
           M2500.company_cd
         , M2500.mail_kbn
		 , M2500.infomation
         , @w_date
         , F2010.employee_cd
		 , F2010.fiscal_year
         , F2010.employee_cd
         , M2500.title
         , M2500.message
    FROM M2500
    INNER JOIN F2010 ON (M2500.company_cd             = F2010.company_cd)
    INNER JOIN F2301 ON (F2010.company_cd             = F2301.company_cd)
	                AND (F2010.fiscal_year            = F2301.fiscal_year)
	                AND (F2010.employee_cd            = F2301.employee_cd)
	                AND (F2010.times                  = F2301.times)
					AND (2                            = F2301.submit)
    WHERE (M2500.mail_kbn   = 3)
      AND (M2500.sending_target = 1 OR M2500.sending_target = 2)
      AND (DATEADD(day,M2500.send_date * CASE WHEN M2500.send_kbn=1 THEN -1 ELSE 1 END,F2010.[1on1_schedule_date]) = @w_date)
	  AND (M2500.del_datetime IS NULL)
    UNION
    --コーチアンケートアラート
    SELECT DISTINCT 
           M2500.company_cd
         , M2500.mail_kbn
		 , M2500.infomation
         , @w_date
         , F2010.employee_cd
		 , F2010.fiscal_year
         , F2001.coach_cd
         , M2500.title
         , M2500.message
    FROM M2500
    INNER JOIN F2010 ON (M2500.company_cd  = F2010.company_cd)
    INNER JOIN F2001 ON (F2010.company_cd  = F2001.company_cd)
	                AND (F2010.fiscal_year = F2001.fiscal_year)
	                AND (F2010.employee_cd = F2001.employee_cd)
	                AND (F2010.times       = F2001.times)
    INNER JOIN F2301 ON (F2010.company_cd  = F2301.company_cd)
	                AND (F2010.fiscal_year = F2301.fiscal_year)
	                AND (F2001.coach_cd    = F2301.employee_cd)
	                AND (F2010.times       = F2301.times)
					AND (1                 = F2301.submit)
    WHERE (M2500.mail_kbn   = 3)
      AND (M2500.sending_target = 1 OR M2500.sending_target = 3)
      AND (DATEADD(day,M2500.send_date * CASE WHEN M2500.send_kbn=1 THEN -1 ELSE 1 END,F2010.[1on1_schedule_date]) = @w_date)
	  AND (M2500.del_datetime IS NULL)
    --未実施者アンケートアラート
    SELECT DISTINCT 
           M2500.company_cd
         , M2500.mail_kbn
		 , M2500.infomation
         , @w_date
         , F2010.employee_cd
		 , F2010.fiscal_year
         , F2010.employee_cd
         , M2500.title
         , M2500.message
    FROM M2500
    INNER JOIN F2010 ON (M2500.company_cd             = F2010.company_cd)
    INNER JOIN F2301 ON (F2010.company_cd             = F2301.company_cd)
	                AND (F2010.fiscal_year            = F2301.fiscal_year)
	                AND (F2010.employee_cd            = F2301.employee_cd)
	                AND (F2010.times                  = F2301.times)
					AND (2                            = F2301.submit)
    WHERE (M2500.mail_kbn   = 4)
      AND (M2500.sending_target = 4)
      AND (DATEADD(day,M2500.send_date * CASE WHEN M2500.send_kbn=1 THEN -1 ELSE 1 END,F2010.[1on1_schedule_date]) = @w_date)
	  AND (M2500.del_datetime IS NULL)
	  AND (F2301.send_datetime IS NULL)
    UNION
    --未実施者アンケートアラート
    SELECT DISTINCT 
           M2500.company_cd
         , M2500.mail_kbn
		 , M2500.infomation
         , @w_date
         , F2010.employee_cd
		 , F2010.fiscal_year
         , F2001.coach_cd
         , M2500.title
         , M2500.message
    FROM M2500
    INNER JOIN F2010 ON (M2500.company_cd             = F2010.company_cd)
    INNER JOIN F2001 ON (F2010.company_cd             = F2001.company_cd)
	                AND (F2010.fiscal_year            = F2001.fiscal_year)
	                AND (F2010.employee_cd            = F2001.employee_cd)
	                AND (F2010.times                  = F2001.times)
    INNER JOIN F2301 ON (F2010.company_cd             = F2301.company_cd)
	                AND (F2010.fiscal_year            = F2301.fiscal_year)
	                AND (F2010.employee_cd            = F2301.employee_cd)
	                AND (F2010.times                  = F2301.times)
					AND (2                            = F2301.submit)
    WHERE (M2500.mail_kbn   = 4)
      AND (M2500.sending_target = 4)
      AND (DATEADD(day,M2500.send_date * CASE WHEN M2500.send_kbn=1 THEN -1 ELSE 1 END,F2010.[1on1_schedule_date]) = @w_date)
	  AND (M2500.del_datetime IS NULL)
	  AND (F2301.send_datetime IS NULL)
   --
   --インフォメーションデータ作成
   INSERT INTO F2900
   SELECT company_cd
        , infomationn_typ
        , 0
        , infomation_date
        , target_employee_cd
        , fiscal_year
        , employee_cd
        , infomation_title
        , '対象:' + M0070_H.employee_nm + 'さん'+ CHAR(13) + CHAR(10) + information_message AS information_message
   	 , null
   	 , 'system'
   	 , ''
   	 , 'B0010_2'
   	 , @w_date
   	 , ''
   	 , ''
   	 , ''
   	 , null
   	 , ''
   	 , ''
   	 , ''
   	 , null
          FROM #F2900 as WRK
          LEFT OUTER JOIN M0070 AS M0070_H ON (WRK.company_cd  = M0070_H.company_cd)
                                          AND (WRK.employee_cd = M0070_H.employee_cd)
   	   WHERE infomation = 1
   --メールデータ作成
   INSERT INTO F2901
   SELECT company_cd
        , infomationn_typ
        , infomation_date
        , target_employee_cd
        , fiscal_year
        , employee_cd
   	 , M0070_H.mail
        , infomation_title
        , '対象:' + M0070_H.employee_nm + 'さん'+ CHAR(13) + CHAR(10) + information_message AS information_message
   	 , null
   	 , 'system'
   	 , ''
   	 , 'B0010_2'
   	 , @w_date
   	 , ''
   	 , ''
   	 , ''
   	 , null
   	 , ''
   	 , ''
   	 , ''
   	 , null
          FROM #F2900 as WRK
          LEFT OUTER JOIN M0070 AS M0070_H ON (WRK.company_cd  = M0070_H.company_cd)
                                          AND (WRK.employee_cd = M0070_H.employee_cd)
   	   WHERE mail = 1
END
GO
