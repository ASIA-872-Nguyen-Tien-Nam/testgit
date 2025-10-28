DROP PROCEDURE [SPC_B0010_BATCH01]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SPC_B0010_BATCH01]
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	B0010
--*  
--*  作成日/create date			:	2018/10/17						
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
    --評価者インフォメーション通知
    INSERT INTO F0900 
    SELECT DISTINCT 
           F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 1                       AS infomationn_typ
         , @w_date                 AS infomation_date
         , F0100.employee_cd       AS target_employee_cd
		 , F0100.fiscal_year       AS fiscal_year
         , F0100.sheet_cd          AS sheet_cd
         , M0070.employee_cd       AS employee_cd
         , F0300.notice_title      AS infomation_title
         , '対象:' + M0070_H.employee_nm + 'さん'+ CHAR(13) + CHAR(10) + F0300.notice_message AS infomation_message
		 , null
		 , 'system'
		 , ''
		 , 'B0010'
		 , @w_date
		 , ''
		 , ''
		 , ''
		 , null
		 , ''
		 , ''
		 , ''
		 , null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd             = M0200.company_cd)
                    AND (F0300.period_detail_no       = M0200.evaluation_period)
					AND (F0300.category               = M0200.sheet_kbn)
    INNER JOIN F0100 ON (F0300.company_cd             = F0100.company_cd)
                    AND (F0300.fiscal_year            = F0100.fiscal_year)
    				AND (M0200.sheet_cd               = F0100.sheet_cd)
    				--AND (F0300.status_cd              = F0100.status_cd)
    INNER JOIN F0030 ON (F0100.company_cd             = F0030.company_cd)
                    AND (F0100.fiscal_year            = F0030.fiscal_year)
    				AND (F0100.employee_cd            = F0030.employee_cd)
    INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
                    AND (   F0030.rater_employee_cd_1 = M0070.employee_cd
    				     OR F0030.rater_employee_cd_2 = M0070.employee_cd
    					 OR F0030.rater_employee_cd_3 = M0070.employee_cd
    					 OR F0030.rater_employee_cd_4 = M0070.employee_cd)
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
    WHERE (F0300.notice_information = 1)
      AND DATEADD(day,F0300.notice_send_date * -1,F0300.start_date) = @w_date
      AND (   F0300.notice_sending_target = 1
           OR F0300.notice_sending_target = 2)
    UNION
    --被評価者インフォメーション通知
    SELECT F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 1                       AS infomationn_typ
         , @w_date                 AS infomation_date
         , F0100.employee_cd       AS target_employee_cd
		 , F0100.fiscal_year       AS fiscal_year
         , F0100.sheet_cd          AS sheet_cd
         , F0100.employee_cd       AS employee_cd
         , F0300.notice_title      AS infomation_title
         , F0300.notice_message    AS infomation_message
		 , null
		 , 'system'
		 , ''
		 , 'B0010'
		 , @w_date
		 , ''
		 , ''
		 , ''
		 , null
		 , ''
		 , ''
		 , ''
		 , null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd       = M0200.company_cd)
                    AND (F0300.period_detail_no = M0200.evaluation_period)
					AND (F0300.category               = M0200.sheet_kbn)
    INNER JOIN F0100 ON (F0300.company_cd       = F0100.company_cd)
                    AND (F0300.fiscal_year      = F0100.fiscal_year)
    				AND (M0200.sheet_cd         = F0100.sheet_cd)
    				--AND (F0300.status_cd        = F0100.status_cd)
    WHERE (F0300.notice_information = 1)
      AND DATEADD(day,F0300.notice_send_date * -1,F0300.start_date) = @w_date
      AND (   F0300.notice_sending_target = 1
           OR F0300.notice_sending_target = 3)
    UNION
    --評価者アラート通知
    SELECT DISTINCT 
           F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 2                       AS infomationn_typ
         , @w_date                 AS infomation_date
         , F0100.employee_cd       AS target_employee_cd
		 , F0100.fiscal_year       AS fiscal_year
         , F0100.sheet_cd          AS sheet_cd
         , M0070.employee_cd       AS employee_cd
         , F0300.alert_title       AS infomation_title
         , '対象:' + M0070_H.employee_nm + 'さん'+ CHAR(13) + CHAR(10) + F0300.alert_message AS infomation_message
		 , null
		 , 'system'
		 , ''
		 , 'B0010'
		 , @w_date
		 , ''
		 , ''
		 , ''
		 , null
		 , ''
		 , ''
		 , ''
		 , null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd             = M0200.company_cd)
                    AND (F0300.period_detail_no       = M0200.evaluation_period)
					AND (F0300.category               = M0200.sheet_kbn)
    INNER JOIN F0100 ON (F0300.company_cd             = F0100.company_cd)
                    AND (F0300.fiscal_year            = F0100.fiscal_year)
    				AND (M0200.sheet_cd               = F0100.sheet_cd)
    				AND (F0300.status_cd             >= F0100.status_cd)
    INNER JOIN F0030 ON (F0100.company_cd             = F0030.company_cd)
                    AND (F0100.fiscal_year            = F0030.fiscal_year)
    				AND (F0100.employee_cd            = F0030.employee_cd)
    INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
                    AND (   F0030.rater_employee_cd_1 = M0070.employee_cd
    				     OR F0030.rater_employee_cd_2 = M0070.employee_cd
    					 OR F0030.rater_employee_cd_3 = M0070.employee_cd
    					 OR F0030.rater_employee_cd_4 = M0070.employee_cd)
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
    WHERE (F0300.alert_information = 1)
      AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date
      AND (   F0300.alert_sending_target = 1
           OR F0300.alert_sending_target = 2)
    UNION
    --被評価者アラート通知
    SELECT F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 2                       AS infomationn_typ
         , @w_date                 AS infomation_date
         , F0100.employee_cd       AS target_employee_cd
		 , F0100.fiscal_year       AS fiscal_year
         , F0100.sheet_cd          AS sheet_cd
         , F0100.employee_cd       AS employee_cd
         , F0300.alert_title       AS infomation_title
         , F0300.alert_message     AS infomation_message
		 , null
		 , 'system'
		 , ''
		 , 'B0010'
		 , @w_date
		 , ''
		 , ''
		 , ''
		 , null
		 , ''
		 , ''
		 , ''
		 , null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd       = M0200.company_cd)
                    AND (F0300.period_detail_no = M0200.evaluation_period)
					AND (F0300.category         = M0200.sheet_kbn)
    INNER JOIN F0100 ON (F0300.company_cd       = F0100.company_cd)
                    AND (F0300.fiscal_year      = F0100.fiscal_year)
    				AND (M0200.sheet_cd         = F0100.sheet_cd)
    				AND (F0300.status_cd       >= F0100.status_cd)
    WHERE (F0300.alert_information = 1)
      AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date
      AND (   F0300.alert_sending_target = 1
           OR F0300.alert_sending_target = 3)
    UNION
    --未実施者アラート通知
    SELECT DISTINCT 
           F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 2                       AS infomationn_typ
         , @w_date                 AS infomation_date
         , F0100.employee_cd       AS target_employee_cd
		 , F0100.fiscal_year       AS fiscal_year
         , F0100.sheet_cd          AS sheet_cd
         , M0070.employee_cd       AS employee_cd
         , F0300.alert_title       AS infomation_title
         , '対象:' + M0070_H.employee_nm + 'さん'+ CHAR(13) + CHAR(10) + F0300.alert_message AS infomation_message
		 , null
		 , 'system'
		 , ''
		 , 'B0010'
		 , @w_date
		 , ''
		 , ''
		 , ''
		 , null
		 , ''
		 , ''
		 , ''
		 , null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd             = M0200.company_cd)
                    AND (F0300.period_detail_no       = M0200.evaluation_period)
					AND (F0300.category               = M0200.sheet_kbn)
    INNER JOIN F0100 ON (F0300.company_cd             = F0100.company_cd)
                    AND (F0300.fiscal_year            = F0100.fiscal_year)
    				AND (M0200.sheet_cd               = F0100.sheet_cd)
    				AND (F0300.status_cd             >= F0100.status_cd)
    INNER JOIN F0030 ON (F0100.company_cd             = F0030.company_cd)
                    AND (F0100.fiscal_year            = F0030.fiscal_year)
    				AND (F0100.employee_cd            = F0030.employee_cd)
    INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
                    AND (   (((F0300.category=1 AND F0300.status_cd NOT IN (5,6,7)) OR (F0300.category=2 AND F0300.status_cd NOT IN (3,4,5))) AND F0030.rater_employee_cd_1 = M0070.employee_cd)
    				     OR (((F0300.category=1 AND F0300.status_cd = 5) OR (F0300.category=2 AND F0300.status_cd = 3)) AND F0030.rater_employee_cd_2 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 6) OR (F0300.category=2 AND F0300.status_cd = 4)) AND F0030.rater_employee_cd_3 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 7) OR (F0300.category=2 AND F0300.status_cd = 5)) AND F0030.rater_employee_cd_4 = M0070.employee_cd))
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
    WHERE (F0300.alert_information = 1)
      AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date
      AND (F0300.alert_sending_target = 4)

    --評価者インフォメーションメール
    INSERT INTO F0901
    SELECT DISTINCT 
           F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 1                       AS infomationn_typ
         , @w_date                 AS infomation_date
         , F0100.employee_cd       AS target_employee_cd
		 , F0100.fiscal_year       AS fiscal_year
         , F0100.sheet_cd          AS sheet_cd
         , M0070.employee_cd       AS employee_cd
    	 , M0070.mail              AS send_mailaddress
         , F0300.notice_title      AS infomation_title
         , '対象:' + M0070_H.employee_nm + 'さん'+ CHAR(13) + CHAR(10) + F0300.notice_message AS infomation_message
		 , null
		 , 'system'
		 , ''
		 , 'B0010'
		 , @w_date
		 , ''
		 , ''
		 , ''
		 , null
		 , ''
		 , ''
		 , ''
		 , null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd             = M0200.company_cd)
                    AND (F0300.period_detail_no       = M0200.evaluation_period)
					AND (F0300.category               = M0200.sheet_kbn)
    INNER JOIN F0100 ON (F0300.company_cd             = F0100.company_cd)
                    AND (F0300.fiscal_year            = F0100.fiscal_year)
    				AND (M0200.sheet_cd               = F0100.sheet_cd)
    				--AND (F0300.status_cd              = F0100.status_cd)
    INNER JOIN F0030 ON (F0100.company_cd             = F0030.company_cd)
                    AND (F0100.fiscal_year            = F0030.fiscal_year)
    				AND (F0100.employee_cd            = F0030.employee_cd)
    INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
                    AND (   F0030.rater_employee_cd_1 = M0070.employee_cd
    				     OR F0030.rater_employee_cd_2 = M0070.employee_cd
    					 OR F0030.rater_employee_cd_3 = M0070.employee_cd
    					 OR F0030.rater_employee_cd_4 = M0070.employee_cd)
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
    WHERE (F0300.notice_mail = 1)
      AND DATEADD(day,F0300.notice_send_date * -1,F0300.start_date) = @w_date
      AND (   F0300.notice_sending_target = 1
           OR F0300.notice_sending_target = 2)
    UNION
    --被評価者インフォメーションメール
    SELECT F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 1                       AS infomationn_typ
         , @w_date                 AS infomation_date
         , F0100.employee_cd       AS target_employee_cd
		 , F0100.fiscal_year       AS fiscal_year
         , F0100.sheet_cd          AS sheet_cd
         , F0100.employee_cd       AS employee_cd
    	 , M0070.mail              AS send_mailaddress
         , F0300.notice_title      AS infomation_title
         , F0300.notice_message    AS infomation_message
		 , null
		 , 'system'
		 , ''
		 , 'B0010'
		 , @w_date
		 , ''
		 , ''
		 , ''
		 , null
		 , ''
		 , ''
		 , ''
		 , null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd       = M0200.company_cd)
                    AND (F0300.period_detail_no = M0200.evaluation_period)
					AND (F0300.category         = M0200.sheet_kbn)
    INNER JOIN F0100 ON (F0300.company_cd       = F0100.company_cd)
                    AND (F0300.fiscal_year      = F0100.fiscal_year)
    				AND (M0200.sheet_cd         = F0100.sheet_cd)
    				--AND (F0300.status_cd        = F0100.status_cd)
    INNER JOIN M0070 ON (F0100.company_cd       = M0070.company_cd)
                    AND (F0100.employee_cd      = M0070.employee_cd)
    WHERE (F0300.notice_mail = 1)
      AND DATEADD(day,F0300.notice_send_date * -1,F0300.start_date) = @w_date
      AND (   F0300.notice_sending_target = 1
           OR F0300.notice_sending_target = 3)
    UNION
    --評価者アラートメール
    SELECT DISTINCT 
           F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 2                       AS infomationn_typ
         , @w_date                 AS infomation_date
         , F0100.employee_cd       AS target_employee_cd
		 , F0100.fiscal_year       AS fiscal_year
         , F0100.sheet_cd          AS sheet_cd
         , M0070.employee_cd       AS employee_cd
    	 , M0070.mail              AS send_mailaddress
         , F0300.alert_title       AS infomation_title
         , '対象:' + M0070_H.employee_nm + 'さん'+ CHAR(13) + CHAR(10) + F0300.alert_message AS infomation_message
		 , null
		 , 'system'
		 , ''
		 , 'B0010'
		 , @w_date
		 , ''
		 , ''
		 , ''
		 , null
		 , ''
		 , ''
		 , ''
		 , null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd             = M0200.company_cd)
                    AND (F0300.period_detail_no       = M0200.evaluation_period)
					AND (F0300.category               = M0200.sheet_kbn)
    INNER JOIN F0100 ON (F0300.company_cd             = F0100.company_cd)
                    AND (F0300.fiscal_year            = F0100.fiscal_year)
    				AND (M0200.sheet_cd               = F0100.sheet_cd)
    				AND (F0300.status_cd             >= F0100.status_cd)
    INNER JOIN F0030 ON (F0100.company_cd             = F0030.company_cd)
                    AND (F0100.fiscal_year            = F0030.fiscal_year)
    				AND (F0100.employee_cd            = F0030.employee_cd)
    INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
                    AND (   F0030.rater_employee_cd_1 = M0070.employee_cd
    				     OR F0030.rater_employee_cd_2 = M0070.employee_cd
    					 OR F0030.rater_employee_cd_3 = M0070.employee_cd
    					 OR F0030.rater_employee_cd_4 = M0070.employee_cd)
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
    WHERE (F0300.alert_mail = 1)
      AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date
      AND (   F0300.alert_sending_target = 1
           OR F0300.alert_sending_target = 2)
    UNION
    --被評価者アラートメール
    SELECT F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 2                       AS infomationn_typ
         , @w_date                 AS infomation_date
         , F0100.employee_cd       AS target_employee_cd
		 , F0100.fiscal_year       AS fiscal_year
         , F0100.sheet_cd          AS sheet_cd
         , F0100.employee_cd       AS employee_cd
    	 , M0070.mail              AS send_mailaddress
         , F0300.alert_title       AS infomation_title
         , F0300.alert_message     AS infomation_message
		 , null
		 , 'system'
		 , ''
		 , 'B0010'
		 , @w_date
		 , ''
		 , ''
		 , ''
		 , null
		 , ''
		 , ''
		 , ''
		 , null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd       = M0200.company_cd)
                    AND (F0300.period_detail_no = M0200.evaluation_period)
					AND (F0300.category         = M0200.sheet_kbn)
    INNER JOIN F0100 ON (F0300.company_cd       = F0100.company_cd)
                    AND (F0300.fiscal_year      = F0100.fiscal_year)
    				AND (M0200.sheet_cd         = F0100.sheet_cd)
    				AND (F0300.status_cd       >= F0100.status_cd)
    INNER JOIN M0070 ON (F0100.company_cd       = M0070.company_cd)
                    AND (F0100.employee_cd      = M0070.employee_cd)
    WHERE (F0300.alert_mail = 1)
      AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date
      AND (   F0300.alert_sending_target = 1
           OR F0300.alert_sending_target = 3)
    UNION
    --未実施者アラートメール
    SELECT DISTINCT 
           F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 2                       AS infomationn_typ
         , @w_date                 AS infomation_date
         , F0100.employee_cd       AS target_employee_cd
		 , F0100.fiscal_year       AS fiscal_year
         , F0100.sheet_cd          AS sheet_cd
         , M0070.employee_cd       AS employee_cd
    	 , M0070.mail              AS send_mailaddress
         , F0300.alert_title       AS infomation_title
         , '対象:' + M0070_H.employee_nm + 'さん'+ CHAR(13) + CHAR(10) + F0300.alert_message AS infomation_message
		 , null
		 , 'system'
		 , ''
		 , 'B0010'
		 , @w_date
		 , ''
		 , ''
		 , ''
		 , null
		 , ''
		 , ''
		 , ''
		 , null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd             = M0200.company_cd)
                    AND (F0300.period_detail_no       = M0200.evaluation_period)
					AND (F0300.category               = M0200.sheet_kbn)
    INNER JOIN F0100 ON (F0300.company_cd             = F0100.company_cd)
                    AND (F0300.fiscal_year            = F0100.fiscal_year)
    				AND (M0200.sheet_cd               = F0100.sheet_cd)
    				AND (F0300.status_cd             >= F0100.status_cd)
    INNER JOIN F0030 ON (F0100.company_cd             = F0030.company_cd)
                    AND (F0100.fiscal_year            = F0030.fiscal_year)
    				AND (F0100.employee_cd            = F0030.employee_cd)
    INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
                    AND (   (((F0300.category=1 AND F0300.status_cd NOT IN (5,6,7)) OR (F0300.category=2 AND F0300.status_cd NOT IN (3,4,5))) AND F0030.rater_employee_cd_1 = M0070.employee_cd)
    				     OR (((F0300.category=1 AND F0300.status_cd = 5) OR (F0300.category=2 AND F0300.status_cd = 3)) AND F0030.rater_employee_cd_2 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 6) OR (F0300.category=2 AND F0300.status_cd = 4)) AND F0030.rater_employee_cd_3 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 7) OR (F0300.category=2 AND F0300.status_cd = 5)) AND F0030.rater_employee_cd_4 = M0070.employee_cd))
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
    WHERE (F0300.alert_mail = 1)
      AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date
      AND (F0300.alert_sending_target = 4)
END
GO
