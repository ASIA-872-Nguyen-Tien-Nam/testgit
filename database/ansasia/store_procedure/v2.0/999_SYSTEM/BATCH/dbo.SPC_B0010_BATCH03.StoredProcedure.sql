DROP PROCEDURE [SPC_B0010_BATCH03]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SPC_B0010_BATCH03]
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	B0010（週報機能：ｲﾝﾌｫﾒｰｼｮﾝ・ｱﾗｰﾄデータ作成）
--*  
--*  作成日/create date			:	2023/06/21
--*　作成者/creater				:	yamazaki
--*   					
--*  更新日/update date			:  
--*　更新者/updater				:　
--*　更新内容/update content	:	
--*   					
--****************************************************************************************
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @w_now  date = getdate()
          , @w_date date
	--
	SET @w_date = @w_now
	--
	CREATE TABLE #F4900 (
		company_cd		    smallint
	,   information_typ     tinyint
	,   information         tinyint
	,   mail                tinyint
	,   information_date    date
	,   fiscal_year         int
	,	employee_cd         nvarchar(10) --送付先の社員
	,	report_kind         smallint
	,	report_no           smallint
	,	title               nvarchar(20)
	,   target_employee_cd  nvarchar(10) --対象週報の社員
	,   information_title   nvarchar(30)
	,   information_message nvarchar(50)
	)
	--M2500
    INSERT INTO #F4900 
    --報告者インフォメーション
    SELECT DISTINCT 
           M4500.company_cd
         , M4500.mail_kbn
		 , M4500.information
		 , M4500.mail
         , @w_date
		 , F4200.fiscal_year
         , F4200.employee_cd
		 , F4200.report_kind
		 , F4200.report_no
		 , F4200.title
         , F4200.employee_cd
         , M4500.title
         , M4500.message
    FROM M4500
    INNER JOIN F4100 ON (M4500.company_cd  = F4100.company_cd)
	                AND (F4100.notice      = 1)
	INNER JOIN F4200 ON (F4100.company_cd  = F4200.company_cd)
	                AND (F4100.fiscal_year = F4200.fiscal_year)
	                AND (F4100.report_kind = F4200.report_kind)
	                AND (F4100.detail_no   = F4200.times)
					AND (F4100.year        = F4200.year)
					AND (F4100.month       = F4200.month)
    WHERE (M4500.mail_kbn   = 1)
      AND (M4500.sending_target = 1 OR M4500.sending_target = 3)
      AND (DATEADD(day,M4500.send_date * CASE WHEN M4500.send_kbn=1 THEN -1 ELSE 1 END,F4100.start_date) = @w_date)
	  AND (M4500.del_datetime IS NULL)
	  AND (F4200.del_datetime IS NULL)
    UNION
    --承認者インフォメーション
    SELECT M4500.company_cd
         , M4500.mail_kbn
		 , M4500.information
		 , M4500.mail
         , @w_date
		 , F4200.fiscal_year
         , F4200.approver_employee_cd_1
		 , F4200.report_kind
		 , F4200.report_no
		 , F4200.title
         , F4200.employee_cd
         , M4500.title
         , M4500.message AS information_message
    FROM M4500
    INNER JOIN F4100 ON (M4500.company_cd  = F4100.company_cd)
	                AND (F4100.notice      = 1)
	INNER JOIN F4200 ON (F4100.company_cd  = F4200.company_cd)
	                AND (F4100.fiscal_year = F4200.fiscal_year)
	                AND (F4100.report_kind = F4200.report_kind)
	                AND (F4100.detail_no   = F4200.times)
					AND (F4100.year        = F4200.year)
					AND (F4100.month       = F4200.month)
    WHERE (M4500.mail_kbn   = 1)
      AND (M4500.sending_target = 1 OR M4500.sending_target = 2)
      AND (DATEADD(day,M4500.send_date * CASE WHEN M4500.send_kbn=1 THEN -1 ELSE 1 END,F4100.start_date) = @w_date)
	  AND (M4500.del_datetime IS NULL)
	  AND (F4200.del_datetime IS NULL)
    UNION
    --報告者アラート
    SELECT DISTINCT 
           M4500.company_cd
         , M4500.mail_kbn
		 , M4500.information
		 , M4500.mail
         , @w_date
		 , F4200.fiscal_year
         , F4200.employee_cd
		 , F4200.report_kind
		 , F4200.report_no
		 , F4200.title
         , F4200.employee_cd
         , M4500.title
         , M4500.message
    FROM M4500
    INNER JOIN F4100 ON (M4500.company_cd  = F4100.company_cd)
	                AND (F4100.alert       = 1)
	INNER JOIN F4200 ON (F4100.company_cd  = F4200.company_cd)
	                AND (F4100.fiscal_year = F4200.fiscal_year)
	                AND (F4100.report_kind = F4200.report_kind)
	                AND (F4100.detail_no   = F4200.times)
					AND (F4100.year        = F4200.year)
					AND (F4100.month       = F4200.month)
	INNER JOIN F4201 ON (F4200.company_cd  = F4201.company_cd)
	                AND (F4200.fiscal_year = F4201.fiscal_year)
	                AND (F4200.report_kind = F4201.report_kind)
	                AND (F4200.report_no   = F4201.report_no)
    WHERE (M4500.mail_kbn   = 2)
      AND (M4500.sending_target = 1 OR M4500.sending_target = 2)
      AND (DATEADD(day,M4500.send_date * CASE WHEN M4500.send_kbn=1 THEN -1 ELSE 1 END,F4100.deadline_date) = @w_date)
	  AND (M4500.del_datetime IS NULL)
	  AND (F4200.del_datetime IS NULL)
    UNION
    --承認者アラート
    SELECT DISTINCT 
           M4500.company_cd
         , M4500.mail_kbn
		 , M4500.information
		 , M4500.mail
         , @w_date
		 , F4200.fiscal_year
         , F4200.approver_employee_cd_1
		 , F4200.report_kind
		 , F4200.report_no
		 , F4200.title
         , F4200.employee_cd
         , M4500.title
         , M4500.message
    FROM M4500
    INNER JOIN F4100 ON (M4500.company_cd  = F4100.company_cd)
	                AND (F4100.alert       = 1)
	INNER JOIN F4200 ON (F4100.company_cd  = F4200.company_cd)
	                AND (F4100.fiscal_year = F4200.fiscal_year)
	                AND (F4100.report_kind = F4200.report_kind)
	                AND (F4100.detail_no   = F4200.times)
					AND (F4100.year        = F4200.year)
					AND (F4100.month       = F4200.month)
    WHERE (M4500.mail_kbn   = 2)
      AND (M4500.sending_target = 1 OR M4500.sending_target = 3)
      AND (DATEADD(day,M4500.send_date * CASE WHEN M4500.send_kbn=1 THEN -1 ELSE 1 END,F4100.deadline_date) = @w_date)
	  AND (M4500.del_datetime IS NULL)
	  AND (F4200.del_datetime IS NULL)
    UNION
    --未実施者アラート
	--報告者
    SELECT DISTINCT 
           M4500.company_cd
         , M4500.mail_kbn
		 , M4500.information
		 , M4500.mail
         , @w_date
		 , F4200.fiscal_year
         , F4200.employee_cd
		 , F4200.report_kind
		 , F4200.report_no
		 , F4200.title
         , F4200.employee_cd
         , M4500.title
         , M4500.message
    FROM M4500
    INNER JOIN F4100 ON (M4500.company_cd  = F4100.company_cd)
	                AND (F4100.alert       = 1)
	INNER JOIN F4200 ON (F4100.company_cd  = F4200.company_cd)
	                AND (F4100.fiscal_year = F4200.fiscal_year)
	                AND (F4100.report_kind = F4200.report_kind)
	                AND (F4100.detail_no   = F4200.times)
					AND (F4100.year        = F4200.year)
					AND (F4100.month       = F4200.month)
    WHERE (M4500.mail_kbn   = 2)
      AND (M4500.sending_target = 4)
      AND (DATEADD(day,M4500.send_date * CASE WHEN M4500.send_kbn=1 THEN -1 ELSE 1 END,F4100.deadline_date) = @w_date)
	  AND (M4500.del_datetime IS NULL)
	  AND (F4200.status_cd =1)
	  AND (F4200.del_datetime IS NULL)
    UNION
	--承認者１
    SELECT DISTINCT 
           M4500.company_cd
         , M4500.mail_kbn
		 , M4500.information
		 , M4500.mail
         , @w_date
		 , F4200.fiscal_year
         , F4200.approver_employee_cd_1
		 , F4200.report_kind
		 , F4200.report_no
		 , F4200.title
         , F4200.employee_cd
         , M4500.title
         , M4500.message AS information_message
    FROM M4500
    INNER JOIN F4100 ON (M4500.company_cd  = F4100.company_cd)
	                AND (F4100.alert       = 1)
	INNER JOIN F4200 ON (F4100.company_cd  = F4200.company_cd)
	                AND (F4100.fiscal_year = F4200.fiscal_year)
	                AND (F4100.report_kind = F4200.report_kind)
	                AND (F4100.detail_no   = F4200.times)
					AND (F4100.year        = F4200.year)
					AND (F4100.month       = F4200.month)
    WHERE (M4500.mail_kbn   = 2)
      AND (M4500.sending_target = 4)
      AND (DATEADD(day,M4500.send_date * CASE WHEN M4500.send_kbn=1 THEN -1 ELSE 1 END,F4100.deadline_date) = @w_date)
	  AND (M4500.del_datetime IS NULL)
	  AND (F4200.status_cd =2)
	  AND (F4200.del_datetime IS NULL)
    UNION
  　--承認者２
    SELECT DISTINCT 
           M4500.company_cd
         , M4500.mail_kbn
		 , M4500.information
		 , M4500.mail
         , @w_date
		 , F4200.fiscal_year
         , F4200.approver_employee_cd_2
		 , F4200.report_kind
		 , F4200.report_no
		 , F4200.title
         , F4200.employee_cd
         , M4500.title
         , M4500.message AS information_message
    FROM M4500
    INNER JOIN F4100 ON (M4500.company_cd  = F4100.company_cd)
	                AND (F4100.alert       = 1)
	INNER JOIN F4200 ON (F4100.company_cd  = F4200.company_cd)
	                AND (F4100.fiscal_year = F4200.fiscal_year)
	                AND (F4100.report_kind = F4200.report_kind)
	                AND (F4100.detail_no   = F4200.times)
					AND (F4100.year        = F4200.year)
					AND (F4100.month       = F4200.month)
    WHERE (M4500.mail_kbn   = 2)
      AND (M4500.sending_target = 4)
      AND (DATEADD(day,M4500.send_date * CASE WHEN M4500.send_kbn=1 THEN -1 ELSE 1 END,F4100.deadline_date) = @w_date)
	  AND (M4500.del_datetime IS NULL)
	  AND (F4200.status_cd =3)
	  AND (F4200.del_datetime IS NULL)
    UNION
  　--承認者３
    SELECT DISTINCT 
           M4500.company_cd
         , M4500.mail_kbn
		 , M4500.information
		 , M4500.mail
         , @w_date
		 , F4200.fiscal_year
         , F4200.approver_employee_cd_3
		 , F4200.report_kind
		 , F4200.report_no
		 , F4200.title
         , F4200.employee_cd
         , M4500.title
         , M4500.message AS information_message
    FROM M4500
    INNER JOIN F4100 ON (M4500.company_cd  = F4100.company_cd)
	                AND (F4100.alert       = 1)
	INNER JOIN F4200 ON (F4100.company_cd  = F4200.company_cd)
	                AND (F4100.fiscal_year = F4200.fiscal_year)
	                AND (F4100.report_kind = F4200.report_kind)
	                AND (F4100.detail_no   = F4200.times)
					AND (F4100.year        = F4200.year)
					AND (F4100.month       = F4200.month)
    WHERE (M4500.mail_kbn   = 2)
      AND (M4500.sending_target = 4)
      AND (DATEADD(day,M4500.send_date * CASE WHEN M4500.send_kbn=1 THEN -1 ELSE 1 END,F4100.deadline_date) = @w_date)
	  AND (M4500.del_datetime IS NULL)
	  AND (F4200.status_cd =4)
	  AND (F4200.del_datetime IS NULL)
    UNION
  　--承認者４
    SELECT DISTINCT 
           M4500.company_cd
         , M4500.mail_kbn
		 , M4500.information
		 , M4500.mail
         , @w_date
		 , F4200.fiscal_year
         , F4200.approver_employee_cd_4
		 , F4200.report_kind
		 , F4200.report_no
		 , F4200.title
         , F4200.employee_cd
         , M4500.title
         , M4500.message AS information_message
    FROM M4500
    INNER JOIN F4100 ON (M4500.company_cd  = F4100.company_cd)
	                AND (F4100.alert       = 1)
	INNER JOIN F4200 ON (F4100.company_cd  = F4200.company_cd)
	                AND (F4100.fiscal_year = F4200.fiscal_year)
	                AND (F4100.report_kind = F4200.report_kind)
	                AND (F4100.detail_no   = F4200.times)
					AND (F4100.year        = F4200.year)
					AND (F4100.month       = F4200.month)
    WHERE (M4500.mail_kbn   = 2)
      AND (M4500.sending_target = 4)
      AND (DATEADD(day,M4500.send_date * CASE WHEN M4500.send_kbn=1 THEN -1 ELSE 1 END,F4100.deadline_date) = @w_date)
	  AND (M4500.del_datetime IS NULL)
	  AND (F4200.status_cd =5)
	  AND (F4200.del_datetime IS NULL)
   --
   --インフォメーションデータ作成
   INSERT INTO F4900
   SELECT WRK.company_cd
        , WRK.information_typ
        , WRK.fiscal_year
        , WRK.employee_cd
        , WRK.report_kind
        , WRK.report_no
        , WRK.target_employee_cd
        , ''
        , WRK.information_date
        , WRK.information_title
        , '対象:' + M0070_H.employee_nm + 'さんの'+ WRK.title + CHAR(13) + CHAR(10) + information_message AS information_message
		, CASE WHEN information_typ=1 THEN DATEADD(day,12,information_date) ELSE NULL END
   	    , null
   	    , 'system'
   	    , ''
   	    , 'B0010_3'
   	    , @w_date
   	    , ''
   	    , ''
   	    , ''
   	    , null
   	    , ''
   	    , ''
   	    , ''
   	    , null
          FROM #F4900 as WRK
          LEFT OUTER JOIN M0070 AS M0070_H ON (WRK.company_cd         = M0070_H.company_cd)
                                          AND (WRK.target_employee_cd = M0070_H.employee_cd)
          LEFT OUTER JOIN F4900 ON (WRK.company_cd         = F4900.company_cd)
		                       AND (WRK.information_typ    = F4900.infomation_typ)
        	                   AND (WRK.fiscal_year        = F4900.fiscal_year)
						       AND (WRK.employee_cd        = F4900.employee_cd)
        	                   AND (WRK.report_kind        = F4900.report_kind)
        	                   AND (WRK.report_no          = F4900.report_no)
						       AND (WRK.employee_cd        = F4900.to_employee_cd)
						       AND (WRK.target_employee_cd = F4900.from_employee_cd)
   	   WHERE WRK.information = 1
	     AND F4900.company_cd IS NULL
   --メールデータ作成
   INSERT INTO F4901
   SELECT WRK.company_cd
        , WRK.information_typ
        , WRK.information_date
        , WRK.target_employee_cd
        , WRK.fiscal_year
        , WRK.employee_cd
   	    , MAX(M0070_H.mail)
        , MAX(WRK.information_title)
        , MAX('対象:' + M0070_T.employee_nm + 'さんの'+ WRK.title + CHAR(13) + CHAR(10) + information_message) AS information_message
   	    , null
   	    , 'system'
   	    , ''
   	    , 'B0010_3'
   	    , @w_date
   	    , ''
   	    , ''
   	    , ''
   	    , null
   	    , ''
   	    , ''
   	    , ''
   	    , null
          FROM #F4900 as WRK
          LEFT OUTER JOIN M0070 AS M0070_H ON (WRK.company_cd  = M0070_H.company_cd)
                                          AND (WRK.employee_cd = M0070_H.employee_cd)
          LEFT OUTER JOIN M0070 AS M0070_T ON (WRK.company_cd         = M0070_T.company_cd)
                                          AND (WRK.target_employee_cd = M0070_T.employee_cd)
          LEFT OUTER JOIN F4901 ON (WRK.company_cd         = F4901.company_cd)
		                       AND (WRK.information_typ    = F4901.infomation_typ)
							   AND (WRK.information_date   = F4901.infomation_date)
        	                   AND (WRK.fiscal_year        = F4901.fiscal_year)
						       AND (WRK.employee_cd        = F4901.employee_cd)
        	                   AND (WRK.target_employee_cd = F4901.target_employee_cd)
   	   WHERE WRK.mail = 1
	     AND F4901.company_cd IS NULL
	   GROUP BY WRK.company_cd
	          , WRK.information_typ
			  , WRK.information_date
			  , WRK.target_employee_cd
			  , WRK.fiscal_year
			  , WRK.employee_cd
END
GO
