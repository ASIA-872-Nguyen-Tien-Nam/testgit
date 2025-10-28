DROP PROCEDURE [SPC_B0010_BATCH01]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SPC_B0010_BATCH01]
--****************************************************************************************
--*   											
--*  èàóùäTóv/process overview	:	B0010
--*  
--*  çÏê¨ì˙/create date			:	2018/10/17						
--*Å@çÏê¨é“/creater				:	yamazaki
--*   					
--*  çXêVì˙/update date			:   2022/04/22
--*Å@çXêVé“/updater				:Å@ yamazaki
--*Å@çXêVì‡óe/update content	:	çÌèúçœÇ›ÇÃé–àıÇèúäOÇ∑ÇÈ
--*Å@Å@Å@Å@Å@Å@Å@Å@Å@Å@Å@Å@Å@Å@Å@Å@ ñ¢é¿é{é“ÇÃí ímëŒè€ïœçX(îÌï]âøé“Ç∆ëççáä«óùé“)
--*   					
--*  çXêVì˙/update date			:   2023/09/27
--*Å@çXêVé“/updater				:Å@ yamazaki
--*Å@çXêVì‡óe/update content	:	É^ÉCÉgÉãÅEñ{ï∂ÇÕÉXÉPÉWÉÖÅ[Éãê›íËÇ≈Ç»Ç≠ìñì˙éûì_ÇÃÉÅÅ[Éãê›íËÇéQè∆Ç∑ÇÈ
--*   					
--****************************************************************************************
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @w_now  datetime = getdate()
          , @w_date date
	--
	SET @w_date =@w_now
	--
	--Å´2022/04/22 í«â¡Å´
	CREATE TABLE #M0070(
		company_cd                  smallint
	,   general_manager_employee_cd nvarchar(20)
	)
	--
	INSERT INTO #M0070
	SELECT 
		M0070.company_cd
	,	M0070.employee_cd
	FROM S0010
         INNER JOIN M0070 ON (S0010.company_cd  = M0070.company_cd)
                         AND (S0010.employee_cd = M0070.employee_cd)
						 AND (M0070.del_datetime IS NULL)
	WHERE (S0010.authority_typ = 5)
	  AND (S0010.del_datetime IS NULL)
	--Å™2022/04/22 í«â¡Å™
	--
    --(ñ⁄ïWä«óù/íËê´ï]âø)
	--ï]âøé“ÉCÉìÉtÉHÉÅÅ[ÉVÉáÉìí ím
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
		 --Å´2023/09/27 èCê≥Å´
         --, F0300.notice_title      AS infomation_title
         --, 'ëŒè€:' + M0070_H.employee_nm + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + F0300.notice_message AS infomation_message
         , M0311.notice_title      AS infomation_title
         , 'ëŒè€:' + M0070_H.employee_nm + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + M0311.notice_message AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd             = M0200.company_cd)
                    AND (F0300.period_detail_no       = M0200.evaluation_period)
					AND (F0300.category               = M0200.sheet_kbn)
    INNER JOIN F0100 ON (F0300.company_cd             = F0100.company_cd)
                    AND (F0300.fiscal_year            = F0100.fiscal_year)
    				AND (M0200.sheet_cd               = F0100.sheet_cd)
    INNER JOIN F0030 ON (F0100.company_cd             = F0030.company_cd)
                    AND (F0100.fiscal_year            = F0030.fiscal_year)
    				AND (F0100.employee_cd            = F0030.employee_cd)
	--Å´2022/04/22 èCê≥Å´
    --INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
    --                AND (   F0030.rater_employee_cd_1 = M0070.employee_cd
    --				     OR F0030.rater_employee_cd_2 = M0070.employee_cd
    --					 OR F0030.rater_employee_cd_3 = M0070.employee_cd
    --					 OR F0030.rater_employee_cd_4 = M0070.employee_cd)
    INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
                    AND (   (((F0300.category=1 AND F0300.status_cd = 5) OR (F0300.category=2 AND F0300.status_cd = 3)) AND F0030.rater_employee_cd_2 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 6) OR (F0300.category=2 AND F0300.status_cd = 4)) AND F0030.rater_employee_cd_3 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 7) OR (F0300.category=2 AND F0300.status_cd = 5)) AND F0030.rater_employee_cd_4 = M0070.employee_cd)
						 OR (((F0300.category=1 AND F0300.status_cd NOT IN (3,5,6,7,8,9)) OR (F0300.category=2 AND F0300.status_cd NOT IN (1,3,4,5,6,7))) AND F0030.rater_employee_cd_1 = M0070.employee_cd))
					AND (M0070.del_datetime IS NULL)
    --Å™2022/04/22 èCê≥Å™
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category in (1,2))
	  AND (F0300.notice_information = 1)
      AND DATEADD(day,F0300.notice_send_date * -1,F0300.start_date) = @w_date
      AND (   F0300.notice_sending_target = 1
           OR F0300.notice_sending_target = 2)
	  AND (M0070_H.del_datetime IS NULL)  --2022/04/22 í«â¡
    UNION
    --îÌï]âøé“ÉCÉìÉtÉHÉÅÅ[ÉVÉáÉìí ím
    SELECT F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 1                       AS infomationn_typ
         , @w_date                 AS infomation_date
         , F0100.employee_cd       AS target_employee_cd
		 , F0100.fiscal_year       AS fiscal_year
         , F0100.sheet_cd          AS sheet_cd
         , F0100.employee_cd       AS employee_cd
		 --Å´2023/09/27 èCê≥Å´
         --, F0300.notice_title      AS infomation_title
         --, F0300.notice_message    AS infomation_message
         , M0311.notice_title      AS infomation_title
         , M0311.notice_message    AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd       = M0200.company_cd)
                    AND (F0300.period_detail_no = M0200.evaluation_period)
					AND (F0300.category         = M0200.sheet_kbn)
    INNER JOIN F0100 ON (F0300.company_cd       = F0100.company_cd)
                    AND (F0300.fiscal_year      = F0100.fiscal_year)
    				AND (M0200.sheet_cd         = F0100.sheet_cd)
    				--AND (F0300.status_cd        = F0100.status_cd)
    LEFT OUTER JOIN M0070 ON (F0100.company_cd  = M0070.company_cd)
                         AND (F0100.employee_cd = M0070.employee_cd)
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category in (1,2))
	  AND (F0300.notice_information = 1)
      AND DATEADD(day,F0300.notice_send_date * -1,F0300.start_date) = @w_date
      AND (   F0300.notice_sending_target = 1
           OR F0300.notice_sending_target = 3)
	  AND (M0070.del_datetime IS NULL)  --2022/04/22 í«â¡
    UNION
	--Å´2022/04/22 í«â¡Å´
    --ñ¢é¿é{é“ÉCÉìÉtÉHÉÅÅ[ÉVÉáÉìí ím
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
		 --Å´2023/09/27 èCê≥Å´
         --, F0300.notice_title      AS infomation_title
         --, 'ëŒè€:' + M0070_H.employee_nm + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + F0300.notice_message AS infomation_message
         , M0311.notice_title      AS infomation_title
         , 'ëŒè€:' + M0070_H.employee_nm + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + M0311.notice_message AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
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
    LEFT OUTER JOIN #M0070 AS M0070_G ON (F0030.company_cd  = M0070_G.company_cd)
    INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
                    AND (   ( (F0300.category=1 AND F0300.status_cd = 1) AND F0030.employee_cd = M0070.employee_cd)
    				     OR (((F0300.category=1 AND F0300.status_cd = 3) OR (F0300.category=2 AND F0300.status_cd = 1)) AND F0030.employee_cd = M0070.employee_cd)
    				     OR (((F0300.category=1 AND F0300.status_cd = 5) OR (F0300.category=2 AND F0300.status_cd = 3)) AND F0030.rater_employee_cd_2 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 6) OR (F0300.category=2 AND F0300.status_cd = 4)) AND F0030.rater_employee_cd_3 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 7) OR (F0300.category=2 AND F0300.status_cd = 5)) AND F0030.rater_employee_cd_4 = M0070.employee_cd)
						 OR (((F0300.category=1 AND F0300.status_cd = 8) OR (F0300.category=2 AND F0300.status_cd = 6)) AND M0070_G.general_manager_employee_cd = M0070.employee_cd)
						 OR (((F0300.category=1 AND F0300.status_cd = 9) OR (F0300.category=2 AND F0300.status_cd = 7)) AND M0070_G.general_manager_employee_cd = M0070.employee_cd)
						 OR (((F0300.category=1 AND F0300.status_cd NOT IN (1,3,5,6,7,8,9)) OR (F0300.category=2 AND F0300.status_cd NOT IN (1,3,4,5,6,7))) AND F0030.rater_employee_cd_1 = M0070.employee_cd))
					AND (M0070.del_datetime IS NULL)
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category in (1,2))
	  AND (F0300.notice_information = 1)
      AND DATEADD(day,F0300.notice_send_date * -1,F0300.start_date) = @w_date
      AND (F0300.notice_sending_target = 4)
	  AND (M0070_H.del_datetime IS NULL) 
    --Å™2022/04/22 í«â¡Å™
    UNION
    --ï]âøé“ÉAÉâÅ[Égí ím
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
		 --Å´2023/09/27 èCê≥Å´
         --, F0300.alert_title       AS infomation_title
         --, 'ëŒè€:' + M0070_H.employee_nm + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + F0300.alert_message AS infomation_message
         , M0311.alert_title       AS infomation_title
         , 'ëŒè€:' + M0070_H.employee_nm + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + M0311.alert_message AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd             = M0200.company_cd)
                    AND (F0300.period_detail_no       = M0200.evaluation_period)
					AND (F0300.category               = M0200.sheet_kbn)
    INNER JOIN F0100 ON (F0300.company_cd             = F0100.company_cd)
                    AND (F0300.fiscal_year            = F0100.fiscal_year)
    				AND (M0200.sheet_cd               = F0100.sheet_cd)
    				AND (F0300.status_cd              = F0100.status_cd)
    INNER JOIN F0030 ON (F0100.company_cd             = F0030.company_cd)
                    AND (F0100.fiscal_year            = F0030.fiscal_year)
    				AND (F0100.employee_cd            = F0030.employee_cd)
    --Å´2022/04/22 èCê≥Å´
    --INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
    --                AND (   F0030.rater_employee_cd_1 = M0070.employee_cd
    --				     OR F0030.rater_employee_cd_2 = M0070.employee_cd
    --					 OR F0030.rater_employee_cd_3 = M0070.employee_cd
    --					 OR F0030.rater_employee_cd_4 = M0070.employee_cd)
    INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
                    AND (   (((F0300.category=1 AND F0300.status_cd = 5) OR (F0300.category=2 AND F0300.status_cd = 3)) AND F0030.rater_employee_cd_2 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 6) OR (F0300.category=2 AND F0300.status_cd = 4)) AND F0030.rater_employee_cd_3 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 7) OR (F0300.category=2 AND F0300.status_cd = 5)) AND F0030.rater_employee_cd_4 = M0070.employee_cd)
						 OR (((F0300.category=1 AND F0300.status_cd NOT IN (3,5,6,7,8,9)) OR (F0300.category=2 AND F0300.status_cd NOT IN (1,3,4,5,6,7))) AND F0030.rater_employee_cd_1 = M0070.employee_cd))
					AND (M0070.del_datetime IS NULL)
    --Å™2022/04/22 èCê≥Å™
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category in (1,2))
	  AND (F0300.alert_information = 1)
	  --Å´2022/05/13 èCê≥Å´
      --AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date
	  AND DATEADD(day,1,DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date)) = @w_date
	  --Å™2022/05/13 èCê≥Å™
      AND (   F0300.alert_sending_target = 1
           OR F0300.alert_sending_target = 2)
	  AND (M0070_H.del_datetime IS NULL)  --2022/04/22 í«â¡
    UNION
    --îÌï]âøé“ÉAÉâÅ[Égí ím
    SELECT F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 2                       AS infomationn_typ
         , @w_date                 AS infomation_date
         , F0100.employee_cd       AS target_employee_cd
		 , F0100.fiscal_year       AS fiscal_year
         , F0100.sheet_cd          AS sheet_cd
         , F0100.employee_cd       AS employee_cd
		 --Å´2023/09/27 èCê≥Å´
         --, F0300.alert_title       AS infomation_title
         --, F0300.alert_message     AS infomation_message
         , M0311.alert_title       AS infomation_title
         , M0311.alert_message     AS infomation_message
		  --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd       = M0200.company_cd)
                    AND (F0300.period_detail_no = M0200.evaluation_period)
					AND (F0300.category         = M0200.sheet_kbn)
    INNER JOIN F0100 ON (F0300.company_cd       = F0100.company_cd)
                    AND (F0300.fiscal_year      = F0100.fiscal_year)
    				AND (M0200.sheet_cd         = F0100.sheet_cd)
    				AND (F0300.status_cd        = F0100.status_cd)
    LEFT OUTER JOIN M0070 ON (F0100.company_cd  = M0070.company_cd)
                         AND (F0100.employee_cd = M0070.employee_cd)
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category in (1,2))
	  AND (F0300.alert_information = 1)
	  --Å´2022/05/13 èCê≥Å´
      --AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date
	  AND DATEADD(day,1,DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date)) = @w_date
	  --Å™2022/05/13 èCê≥Å™
      AND (   F0300.alert_sending_target = 1
           OR F0300.alert_sending_target = 3)
	  AND (M0070.del_datetime IS NULL)  --2022/04/22 í«â¡
    UNION
    --ñ¢é¿é{é“ÉAÉâÅ[Égí ím
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
		 --Å´2023/09/27 èCê≥Å´
         --, F0300.alert_title       AS infomation_title
         --, 'ëŒè€:' + M0070_H.employee_nm + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + F0300.alert_message AS infomation_message
         , M0311.alert_title       AS infomation_title
         , 'ëŒè€:' + M0070_H.employee_nm + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + M0311.alert_message AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
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
	--Å´2022/04/22 èCê≥Å´
    --INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
    --                AND (   (((F0300.category=1 AND F0300.status_cd NOT IN (5,6,7)) OR (F0300.category=2 AND F0300.status_cd NOT IN (3,4,5))) AND F0030.rater_employee_cd_1 = M0070.employee_cd)
    --				       OR (((F0300.category=1 AND F0300.status_cd = 5) OR (F0300.category=2 AND F0300.status_cd = 3)) AND F0030.rater_employee_cd_2 = M0070.employee_cd)
    --					   OR (((F0300.category=1 AND F0300.status_cd = 6) OR (F0300.category=2 AND F0300.status_cd = 4)) AND F0030.rater_employee_cd_3 = M0070.employee_cd)
    --					   OR (((F0300.category=1 AND F0300.status_cd = 7) OR (F0300.category=2 AND F0300.status_cd = 5)) AND F0030.rater_employee_cd_4 = M0070.employee_cd))
    LEFT OUTER JOIN #M0070 AS M0070_G ON (F0030.company_cd  = M0070_G.company_cd)
    INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
                    AND (   ( (F0300.category=1 AND F0300.status_cd = 1) AND F0030.employee_cd = M0070.employee_cd)
    				     OR (((F0300.category=1 AND F0300.status_cd = 3) OR (F0300.category=2 AND F0300.status_cd = 1)) AND F0030.employee_cd = M0070.employee_cd)
    				     OR (((F0300.category=1 AND F0300.status_cd = 5) OR (F0300.category=2 AND F0300.status_cd = 3)) AND F0030.rater_employee_cd_2 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 6) OR (F0300.category=2 AND F0300.status_cd = 4)) AND F0030.rater_employee_cd_3 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 7) OR (F0300.category=2 AND F0300.status_cd = 5)) AND F0030.rater_employee_cd_4 = M0070.employee_cd)
						 OR (((F0300.category=1 AND F0300.status_cd = 8) OR (F0300.category=2 AND F0300.status_cd = 6)) AND M0070_G.general_manager_employee_cd = M0070.employee_cd)
						 OR (((F0300.category=1 AND F0300.status_cd = 9) OR (F0300.category=2 AND F0300.status_cd = 7)) AND M0070_G.general_manager_employee_cd = M0070.employee_cd)
						 OR (((F0300.category=1 AND F0300.status_cd NOT IN (1,3,5,6,7,8,9)) OR (F0300.category=2 AND F0300.status_cd NOT IN (1,3,4,5,6,7))) AND F0030.rater_employee_cd_1 = M0070.employee_cd))
					AND (M0070.del_datetime IS NULL)
    --Å™2022/04/22 èCê≥Å™
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category in (1,2))
	  AND (F0300.alert_information = 1)
	  --Å´2022/05/13 èCê≥Å´
      --AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date
	  AND DATEADD(day,1,DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date)) = @w_date
	  --Å™2022/05/13 èCê≥Å™
      AND (F0300.alert_sending_target = 4)
	  AND (M0070_H.del_datetime IS NULL)    --2022/04/22 í«â¡
    UNION
    --(ä˙íÜñ ík)
	--ï]âøé“ÉCÉìÉtÉHÉÅÅ[ÉVÉáÉìí ím
    SELECT F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 1                       AS infomationn_typ
         , @w_date                 AS infomation_date
         , F0100.employee_cd       AS target_employee_cd
		 , F0100.fiscal_year       AS fiscal_year
         , MAX(F0100.sheet_cd)     AS sheet_cd
         , M0070.employee_cd       AS employee_cd
		 --Å´2023/09/27 èCê≥Å´
         --, MAX(F0300.notice_title) AS infomation_title
         --, 'ëŒè€:' + MAX(M0070_H.employee_nm) + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + MAX(F0300.notice_message) AS infomation_message
         , MAX(M0311.notice_title) AS infomation_title
         , 'ëŒè€:' + MAX(M0070_H.employee_nm) + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + MAX(M0311.notice_message) AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd          = M0200.company_cd)
                    AND (F0300.period_detail_no    = M0200.evaluation_period)
					AND (M0200.del_datetime IS NULL)
    INNER JOIN F0100 ON (F0300.company_cd          = F0100.company_cd)
                    AND (F0300.fiscal_year         = F0100.fiscal_year)
    				AND (M0200.sheet_cd            = F0100.sheet_cd)
    INNER JOIN F0030 ON (F0100.company_cd          = F0030.company_cd)
                    AND (F0100.fiscal_year         = F0030.fiscal_year)
    				AND (F0100.employee_cd         = F0030.employee_cd)
    INNER JOIN M0070 ON (F0030.company_cd          = M0070.company_cd)
                    AND (F0030.rater_employee_cd_1 = M0070.employee_cd)
					AND (M0070.del_datetime IS NULL)    --2022/04/22 í«â¡
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category = 3)
	  AND (F0300.notice_information = 1)
      AND DATEADD(day,F0300.notice_send_date * -1,F0300.start_date) = @w_date
      AND (   F0300.notice_sending_target = 1
           OR F0300.notice_sending_target = 2)
	  AND (M0070_H.del_datetime IS NULL)    --2022/04/22 í«â¡
    GROUP BY F0300.company_cd
           , F0300.category
           , F0300.status_cd
           , F0100.employee_cd
		   , F0100.fiscal_year
		   , M0070.employee_cd
    UNION
    --îÌï]âøé“ÉCÉìÉtÉHÉÅÅ[ÉVÉáÉìí ím
    SELECT F0300.company_cd          AS company_cd
         , F0300.category            AS category
         , F0300.status_cd           AS status_cd
         , 1                         AS infomationn_typ
         , @w_date                   AS infomation_date
         , F0100.employee_cd         AS target_employee_cd
		 , F0100.fiscal_year         AS fiscal_year
         , MAX(F0100.sheet_cd)       AS sheet_cd
         , F0100.employee_cd         AS employee_cd
		 --Å´2023/09/27 èCê≥Å´
         --, MAX(F0300.notice_title)   AS infomation_title
         --, MAX(F0300.notice_message) AS infomation_message
         , MAX(M0311.notice_title)   AS infomation_title
         , MAX(M0311.notice_message) AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd       = M0200.company_cd)
                    AND (F0300.period_detail_no = M0200.evaluation_period)
    INNER JOIN F0100 ON (F0300.company_cd       = F0100.company_cd)
                    AND (F0300.fiscal_year      = F0100.fiscal_year)
    				AND (M0200.sheet_cd         = F0100.sheet_cd)
    LEFT OUTER JOIN M0070 ON (F0100.company_cd  = M0070.company_cd)
                         AND (F0100.employee_cd = M0070.employee_cd)
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category = 3)
	  AND (F0300.notice_information = 1)
      AND DATEADD(day,F0300.notice_send_date * -1,F0300.start_date) = @w_date
      AND (   F0300.notice_sending_target = 1
           OR F0300.notice_sending_target = 3)
	  AND (M0070.del_datetime IS NULL)    --2022/04/22 í«â¡
    GROUP BY F0300.company_cd
           , F0300.category
           , F0300.status_cd
           , F0100.employee_cd
		   , F0100.fiscal_year
    UNION
    --ï]âøé“ÉAÉâÅ[Égí ím
    SELECT 
           F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 2                       AS infomationn_typ
         , @w_date                 AS infomation_date
         , F0100.employee_cd       AS target_employee_cd
		 , F0100.fiscal_year       AS fiscal_year
         , MAX(F0100.sheet_cd)     AS sheet_cd
         , M0070.employee_cd       AS employee_cd
		 --Å´2023/09/27 èCê≥Å´
         --, MAX(F0300.alert_title)  AS infomation_title
         --, 'ëŒè€:' + MAX(M0070_H.employee_nm) + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + MAX(F0300.alert_message) AS infomation_message
         , MAX(M0311.alert_title)  AS infomation_title
         , 'ëŒè€:' + MAX(M0070_H.employee_nm) + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + MAX(M0311.alert_message) AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd          = M0200.company_cd)
                    AND (F0300.period_detail_no    = M0200.evaluation_period)
    INNER JOIN F0100 ON (F0300.company_cd          = F0100.company_cd)
                    AND (F0300.fiscal_year         = F0100.fiscal_year)
    				AND (M0200.sheet_cd            = F0100.sheet_cd)
    INNER JOIN F0030 ON (F0100.company_cd          = F0030.company_cd)
                    AND (F0100.fiscal_year         = F0030.fiscal_year)
    				AND (F0100.employee_cd         = F0030.employee_cd)
    INNER JOIN M0070 ON (F0030.company_cd          = M0070.company_cd)
                    AND (F0030.rater_employee_cd_1 = M0070.employee_cd)
					AND (M0070.del_datetime IS NULL)    --2022/04/22
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
    LEFT OUTER JOIN F0122 ON (F0300.company_cd             = F0122.company_cd)
                         AND (F0300.fiscal_year            = F0122.fiscal_year)
    				     AND (F0300.period_detail_no       = F0122.period_detail_no)
						 AND (F0300.status_cd              = F0122.interview_no)
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category = 3)
	  AND (F0300.alert_information = 1)
	  --Å´2022/05/13 èCê≥Å´
      --AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date
	  AND DATEADD(day,1,DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date)) = @w_date
	  --Å™2022/05/13 èCê≥Å™
      AND (   F0300.alert_sending_target = 1
           OR F0300.alert_sending_target = 2)
	  AND (M0070_H.del_datetime IS NULL)    --2022/04/22 í«â¡
	  AND (F0122.company_cd IS NULL)
    GROUP BY F0300.company_cd
           , F0300.category
           , F0300.status_cd
           , F0100.employee_cd
		   , F0100.fiscal_year
		   , M0070.employee_cd
    UNION
    --îÌï]âøé“ÉAÉâÅ[Égí ím
    SELECT F0300.company_cd         AS company_cd
         , F0300.category           AS category
         , F0300.status_cd          AS status_cd
         , 2                        AS infomationn_typ
         , @w_date                  AS infomation_date
         , F0100.employee_cd        AS target_employee_cd
		 , F0100.fiscal_year        AS fiscal_year
         , MAX(F0100.sheet_cd)      AS sheet_cd
         , F0100.employee_cd        AS employee_cd
		 --Å´2023/09/27 èCê≥Å´
         --, MAX(F0300.alert_title)   AS infomation_title
         --, MAX(F0300.alert_message) AS infomation_message
         , MAX(M0311.alert_title)   AS infomation_title
         , MAX(M0311.alert_message) AS infomation_message
		  --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd       = M0200.company_cd)
                    AND (F0300.period_detail_no = M0200.evaluation_period)
    INNER JOIN F0100 ON (F0300.company_cd       = F0100.company_cd)
                    AND (F0300.fiscal_year      = F0100.fiscal_year)
    				AND (M0200.sheet_cd         = F0100.sheet_cd)
    LEFT OUTER JOIN M0070 ON (F0100.company_cd  = M0070.company_cd)
                         AND (F0100.employee_cd = M0070.employee_cd)
    LEFT OUTER JOIN F0122 ON (F0300.company_cd       = F0122.company_cd)
                         AND (F0300.fiscal_year      = F0122.fiscal_year)
    				     AND (F0300.period_detail_no = F0122.period_detail_no)
						 AND (F0300.status_cd        = F0122.interview_no)
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category = 3)
	  AND (F0300.alert_information = 1)
	  --Å´2022/05/13 èCê≥Å´
      --AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date
	  AND DATEADD(day,1,DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date)) = @w_date
	  --Å™2022/05/13 èCê≥Å™
      AND (   F0300.alert_sending_target = 1
           OR F0300.alert_sending_target = 3)
	  AND (M0070.del_datetime IS NULL)    --2022/04/22 í«â¡
	  AND (F0122.company_cd IS NULL)
    GROUP BY F0300.company_cd
           , F0300.category
           , F0300.status_cd
           , F0100.employee_cd
		   , F0100.fiscal_year
    UNION
    --ñ¢é¿é{é“ÉAÉâÅ[Égí ím
    SELECT DISTINCT 
           F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 2                       AS infomationn_typ
         , @w_date                 AS infomation_date
         , F0100.employee_cd       AS target_employee_cd
		 , F0100.fiscal_year       AS fiscal_year
         , MAX(F0100.sheet_cd)     AS sheet_cd
         , M0070.employee_cd       AS employee_cd
		 --Å´2023/09/27 èCê≥Å´
         --, MAX(F0300.alert_title)  AS infomation_title
         --, 'ëŒè€:' + MAX(M0070_H.employee_nm) + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + MAX(F0300.alert_message) AS infomation_message
         , MAX(M0311.alert_title)  AS infomation_title
         , 'ëŒè€:' + MAX(M0070_H.employee_nm) + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + MAX(M0311.alert_message) AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd          = M0200.company_cd)
                    AND (F0300.period_detail_no    = M0200.evaluation_period)
    INNER JOIN F0100 ON (F0300.company_cd          = F0100.company_cd)
                    AND (F0300.fiscal_year         = F0100.fiscal_year)
    				AND (M0200.sheet_cd            = F0100.sheet_cd)
    INNER JOIN F0030 ON (F0100.company_cd          = F0030.company_cd)
                    AND (F0100.fiscal_year         = F0030.fiscal_year)
    				AND (F0100.employee_cd         = F0030.employee_cd)
    INNER JOIN M0070 ON (F0030.company_cd          = M0070.company_cd)
                    AND (F0030.rater_employee_cd_1 = M0070.employee_cd)
					AND (M0070.del_datetime IS NULL)    --2022/04/22 í«â¡
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
    LEFT OUTER JOIN F0122 ON (F0300.company_cd             = F0122.company_cd)
                         AND (F0300.fiscal_year            = F0122.fiscal_year)
    				     AND (F0300.period_detail_no       = F0122.period_detail_no)
						 AND (F0300.status_cd              = F0122.interview_no)
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category = 3)
	  AND (F0300.alert_information = 1)
	  --Å´2022/05/13 èCê≥Å´
      --AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date
	  AND DATEADD(day,1,DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date)) = @w_date
	  --Å™2022/05/13 èCê≥Å™
      AND (F0300.alert_sending_target = 4)
	  AND (M0070_H.del_datetime IS NULL)    --2022/04/22 í«â¡
	  AND F0122.company_cd IS NULL			--2022/08/05 í«â¡
    GROUP BY F0300.company_cd
           , F0300.category
           , F0300.status_cd
           , F0100.employee_cd
		   , F0100.fiscal_year
		   , M0070.employee_cd
	--
    --(ñ⁄ïWä«óù/íËê´ï]âø)
    --ï]âøé“ÉCÉìÉtÉHÉÅÅ[ÉVÉáÉìÉÅÅ[Éã
    INSERT INTO F0901
    SELECT DISTINCT 
           F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 1                       AS infomationn_typ
         , @w_date                 AS infomation_date
		 --Å´2021/07/06 èCê≥Å´
         --, F0100.employee_cd     AS target_employee_cd 
		 , '0'                     AS target_employee_cd
		 --Å™2021/07/06 èCê≥Å™
		 , F0100.fiscal_year       AS fiscal_year
		 --Å´2021/07/06 èCê≥Å´
         --, F0100.sheet_cd        AS sheet_cd
		 , 0                       AS sheet_cd
		 --Å™2021/07/06 èCê≥Å™
         , M0070.employee_cd       AS employee_cd
    	 , M0070.mail              AS send_mailaddress
		 --Å´2023/09/27 èCê≥Å´
         --, F0300.notice_title      AS infomation_title
		 ----Å´2021/07/06 èCê≥Å´
         ----, 'ëŒè€:' + M0070_H.employee_nm + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + F0300.notice_message AS infomation_message
         --, F0300.notice_message AS infomation_message
		 ----Å™2021/07/06 èCê≥Å™
         , M0311.notice_title      AS infomation_title
         , M0311.notice_message    AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
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
    --Å´2022/04/22 èCê≥Å´
    --INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
    --                AND (   F0030.rater_employee_cd_1 = M0070.employee_cd
    --				     OR F0030.rater_employee_cd_2 = M0070.employee_cd
    --					 OR F0030.rater_employee_cd_3 = M0070.employee_cd
    --					 OR F0030.rater_employee_cd_4 = M0070.employee_cd)
    INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
                    AND (   (((F0300.category=1 AND F0300.status_cd = 5) OR (F0300.category=2 AND F0300.status_cd = 3)) AND F0030.rater_employee_cd_2 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 6) OR (F0300.category=2 AND F0300.status_cd = 4)) AND F0030.rater_employee_cd_3 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 7) OR (F0300.category=2 AND F0300.status_cd = 5)) AND F0030.rater_employee_cd_4 = M0070.employee_cd)
						 OR (((F0300.category=1 AND F0300.status_cd NOT IN (3,5,6,7,8,9)) OR (F0300.category=2 AND F0300.status_cd NOT IN (1,3,4,5,6,7))) AND F0030.rater_employee_cd_1 = M0070.employee_cd))
					AND (M0070.del_datetime IS NULL)
    --Å™2022/04/22 èCê≥Å™
    --Å´2021/07/06 çÌèúÅ´
    --LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
    --                                AND (F0030.employee_cd = M0070_H.employee_cd)
    --Å™2021/07/06 çÌèúÅ™
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category in (1,2))
	  AND (F0300.notice_mail = 1)
      AND DATEADD(day,F0300.notice_send_date * -1,F0300.start_date) = @w_date
      AND (   F0300.notice_sending_target = 1
           OR F0300.notice_sending_target = 2)
    UNION
    --îÌï]âøé“ÉCÉìÉtÉHÉÅÅ[ÉVÉáÉìÉÅÅ[Éã
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
		 --Å´2023/09/27 èCê≥Å´
         --, F0300.notice_title      AS infomation_title
         --, F0300.notice_message    AS infomation_message
         , M0311.notice_title      AS infomation_title
         , M0311.notice_message    AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
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
					AND (M0070.del_datetime IS NULL)    --2022/04/22 í«â¡
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category in (1,2))
	  AND (F0300.notice_mail = 1)
      AND DATEADD(day,F0300.notice_send_date * -1,F0300.start_date) = @w_date
      AND (   F0300.notice_sending_target = 1
           OR F0300.notice_sending_target = 3)
    UNION
    ----Å´2022/04/22Å´
    --ñ¢é¿é{é“ÉCÉìÉtÉHÉÅÅ[ÉVÉáÉìÉÅÅ[Éã
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
		 --Å´2023/09/27 èCê≥Å´
         --, F0300.notice_title      AS infomation_title
         --, 'ëŒè€:' + M0070_H.employee_nm + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + F0300.notice_message AS infomation_message
         , M0311.notice_title      AS infomation_title
         , 'ëŒè€:' + M0070_H.employee_nm + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + M0311.notice_message AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
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
    LEFT OUTER JOIN #M0070 AS M0070_G ON (F0030.company_cd  = M0070_G.company_cd)
    INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
                    AND (   ( (F0300.category=1 AND F0300.status_cd = 1) AND F0030.employee_cd = M0070.employee_cd)
    				     OR (((F0300.category=1 AND F0300.status_cd = 3) OR (F0300.category=2 AND F0300.status_cd = 1)) AND F0030.employee_cd = M0070.employee_cd)
    				     OR (((F0300.category=1 AND F0300.status_cd = 5) OR (F0300.category=2 AND F0300.status_cd = 3)) AND F0030.rater_employee_cd_2 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 6) OR (F0300.category=2 AND F0300.status_cd = 4)) AND F0030.rater_employee_cd_3 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 7) OR (F0300.category=2 AND F0300.status_cd = 5)) AND F0030.rater_employee_cd_4 = M0070.employee_cd)
						 OR (((F0300.category=1 AND F0300.status_cd = 8) OR (F0300.category=2 AND F0300.status_cd = 6)) AND M0070_G.general_manager_employee_cd = M0070.employee_cd)
						 OR (((F0300.category=1 AND F0300.status_cd = 9) OR (F0300.category=2 AND F0300.status_cd = 7)) AND M0070_G.general_manager_employee_cd = M0070.employee_cd)
						 OR (((F0300.category=1 AND F0300.status_cd NOT IN (1,3,5,6,7,8,9)) OR (F0300.category=2 AND F0300.status_cd NOT IN (1,3,4,5,6,7))) AND F0030.rater_employee_cd_1 = M0070.employee_cd))
					AND (M0070.del_datetime IS NULL)
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category in (1,2))
	  AND (F0300.notice_mail = 1)
      AND DATEADD(day,F0300.notice_send_date * -1,F0300.start_date) = @w_date
      AND (F0300.notice_sending_target = 4)
	  AND (M0070_H.del_datetime IS NULL)
    --Å™2022/04/22Å™
    UNION
    --ï]âøé“ÉAÉâÅ[ÉgÉÅÅ[Éã
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
		 --Å´2023/09/27 èCê≥Å´
         --, F0300.alert_title       AS infomation_title
         --, 'ëŒè€:' + M0070_H.employee_nm + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + F0300.alert_message AS infomation_message
         , M0311.alert_title       AS infomation_title
         , 'ëŒè€:' + M0070_H.employee_nm + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + M0311.alert_message AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd             = M0200.company_cd)
                    AND (F0300.period_detail_no       = M0200.evaluation_period)
					AND (F0300.category               = M0200.sheet_kbn)
    INNER JOIN F0100 ON (F0300.company_cd             = F0100.company_cd)
                    AND (F0300.fiscal_year            = F0100.fiscal_year)
    				AND (M0200.sheet_cd               = F0100.sheet_cd)
    				AND (F0300.status_cd              = F0100.status_cd)
    INNER JOIN F0030 ON (F0100.company_cd             = F0030.company_cd)
                    AND (F0100.fiscal_year            = F0030.fiscal_year)
    				AND (F0100.employee_cd            = F0030.employee_cd)
    --Å´2022/04/22 èCê≥Å´
    --INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
    --                AND (   F0030.rater_employee_cd_1 = M0070.employee_cd
    --				     OR F0030.rater_employee_cd_2 = M0070.employee_cd
    --					 OR F0030.rater_employee_cd_3 = M0070.employee_cd
    --					 OR F0030.rater_employee_cd_4 = M0070.employee_cd)
    INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
                    AND (   (((F0300.category=1 AND F0300.status_cd = 5) OR (F0300.category=2 AND F0300.status_cd = 3)) AND F0030.rater_employee_cd_2 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 6) OR (F0300.category=2 AND F0300.status_cd = 4)) AND F0030.rater_employee_cd_3 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 7) OR (F0300.category=2 AND F0300.status_cd = 5)) AND F0030.rater_employee_cd_4 = M0070.employee_cd)
						 OR (((F0300.category=1 AND F0300.status_cd NOT IN (3,5,6,7,8,9)) OR (F0300.category=2 AND F0300.status_cd NOT IN (1,3,4,5,6,7))) AND F0030.rater_employee_cd_1 = M0070.employee_cd))
					AND (M0070.del_datetime IS NULL)
    --Å™2022/04/22 èCê≥Å™
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category in (1,2))
	  AND (F0300.alert_mail = 1)
	  --Å´2022/05/13 èCê≥Å´
      --AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date
	  AND DATEADD(day,1,DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date)) = @w_date
	  --Å™2022/05/13 èCê≥Å™
      AND (   F0300.alert_sending_target = 1
           OR F0300.alert_sending_target = 2)
	  AND (M0070_H.del_datetime IS NULL)    --2022/04/22 í«â¡
    UNION
    --îÌï]âøé“ÉAÉâÅ[ÉgÉÅÅ[Éã
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
		 --Å´2023/09/27 èCê≥Å´
         --, F0300.alert_title       AS infomation_title
         --, F0300.alert_message     AS infomation_message
         , M0311.alert_title       AS infomation_title
         , M0311.alert_message     AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd       = M0200.company_cd)
                    AND (F0300.period_detail_no = M0200.evaluation_period)
					AND (F0300.category         = M0200.sheet_kbn)
    INNER JOIN F0100 ON (F0300.company_cd       = F0100.company_cd)
                    AND (F0300.fiscal_year      = F0100.fiscal_year)
    				AND (M0200.sheet_cd         = F0100.sheet_cd)
    				AND (F0300.status_cd        = F0100.status_cd)
    INNER JOIN M0070 ON (F0100.company_cd       = M0070.company_cd)
                    AND (F0100.employee_cd      = M0070.employee_cd)
					AND (M0070.del_datetime IS NULL)    --2022/04/22
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category in (1,2))
	  AND (F0300.alert_mail = 1)
	  --Å´2022/05/13 èCê≥Å´
      --AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date
	  AND DATEADD(day,1,DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date)) = @w_date
	  --Å™2022/05/13 èCê≥Å™
      AND (   F0300.alert_sending_target = 1
           OR F0300.alert_sending_target = 3)
    UNION
    --ñ¢é¿é{é“ÉAÉâÅ[ÉgÉÅÅ[Éã
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
		 --Å´2023/09/27 èCê≥Å´
         --, F0300.alert_title       AS infomation_title
         --, 'ëŒè€:' + M0070_H.employee_nm + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + F0300.alert_message AS infomation_message
         , M0311.alert_title       AS infomation_title
         , 'ëŒè€:' + M0070_H.employee_nm + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + M0311.alert_message AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
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
    ----Å´2022/04/22 èCê≥Å´
    --INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
    --                AND (   (((F0300.category=1 AND F0300.status_cd NOT IN (5,6,7)) OR (F0300.category=2 AND F0300.status_cd NOT IN (3,4,5))) AND F0030.rater_employee_cd_1 = M0070.employee_cd)
    --				       OR (((F0300.category=1 AND F0300.status_cd = 5) OR (F0300.category=2 AND F0300.status_cd = 3)) AND F0030.rater_employee_cd_2 = M0070.employee_cd)
    --					   OR (((F0300.category=1 AND F0300.status_cd = 6) OR (F0300.category=2 AND F0300.status_cd = 4)) AND F0030.rater_employee_cd_3 = M0070.employee_cd)
    --					   OR (((F0300.category=1 AND F0300.status_cd = 7) OR (F0300.category=2 AND F0300.status_cd = 5)) AND F0030.rater_employee_cd_4 = M0070.employee_cd))
    LEFT OUTER JOIN #M0070 AS M0070_G ON (F0030.company_cd  = M0070_G.company_cd)
    INNER JOIN M0070 ON (F0030.company_cd             = M0070.company_cd)
                    AND (   ( (F0300.category=1 AND F0300.status_cd = 1) AND F0030.employee_cd = M0070.employee_cd)
    				     OR (((F0300.category=1 AND F0300.status_cd = 3) OR (F0300.category=2 AND F0300.status_cd = 1)) AND F0030.employee_cd = M0070.employee_cd)
    				     OR (((F0300.category=1 AND F0300.status_cd = 5) OR (F0300.category=2 AND F0300.status_cd = 3)) AND F0030.rater_employee_cd_2 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 6) OR (F0300.category=2 AND F0300.status_cd = 4)) AND F0030.rater_employee_cd_3 = M0070.employee_cd)
    					 OR (((F0300.category=1 AND F0300.status_cd = 7) OR (F0300.category=2 AND F0300.status_cd = 5)) AND F0030.rater_employee_cd_4 = M0070.employee_cd)
						 OR (((F0300.category=1 AND F0300.status_cd = 8) OR (F0300.category=2 AND F0300.status_cd = 6)) AND M0070_G.general_manager_employee_cd = M0070.employee_cd)
						 OR (((F0300.category=1 AND F0300.status_cd = 9) OR (F0300.category=2 AND F0300.status_cd = 7)) AND M0070_G.general_manager_employee_cd = M0070.employee_cd)
						 OR (((F0300.category=1 AND F0300.status_cd NOT IN (1,3,5,6,7,8,9)) OR (F0300.category=2 AND F0300.status_cd NOT IN (1,3,4,5,6,7))) AND F0030.rater_employee_cd_1 = M0070.employee_cd))
					AND (M0070.del_datetime IS NULL)
    --Å™2022/04/22 èCê≥Å™
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category in (1,2))
	  AND (F0300.alert_mail = 1)
	  --Å´2022/05/13 èCê≥Å´
      --AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date
	  AND DATEADD(day,1,DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date)) = @w_date
	  --Å™2022/05/13 èCê≥Å™
      AND (F0300.alert_sending_target = 4)
	  AND (M0070_H.del_datetime IS NULL)   --2022/04/22 í«â¡
    UNION
    --(íÜä‘ñ ík)
    --ï]âøé“ÉCÉìÉtÉHÉÅÅ[ÉVÉáÉìÉÅÅ[Éã
    SELECT DISTINCT 
           F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 1                       AS infomationn_typ
         , @w_date                 AS infomation_date
		 --Å´2021/07/06 èCê≥Å´
         --, F0100.employee_cd     AS target_employee_cd
		 , '0'                     AS target_employee_cd
		 --Å™2021/07/06 èCê≥Å™
		 , F0100.fiscal_year       AS fiscal_year
		 --Å´2021/07/06 èCê≥Å´
         --, MAX(F0100.sheet_cd)   AS sheet_cd
		 , 0                       AS sheet_cd
		 --Å™2021/07/06 èCê≥Å™
         , M0070.employee_cd       AS employee_cd
    	 , MAX(M0070.mail)         AS send_mailaddress
		 --Å´2023/09/27 èCê≥Å´
    	 --, MAX(F0300.notice_title) AS infomation_title
		 ----Å´2021/07/06 èCê≥Å´
         ----, 'ëŒè€:' + MAX(M0070_H.employee_nm) + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + MAX(F0300.notice_message) AS infomation_message
    	 --, MAX(F0300.notice_message) AS infomation_message
		 ----Å™2021/07/06 èCê≥Å™
         , MAX(M0311.notice_title)   AS infomation_title
		 , MAX(M0311.notice_message) AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd          = M0200.company_cd)
                    AND (F0300.period_detail_no    = M0200.evaluation_period)
    INNER JOIN F0100 ON (F0300.company_cd          = F0100.company_cd)
                    AND (F0300.fiscal_year         = F0100.fiscal_year)
    				AND (M0200.sheet_cd            = F0100.sheet_cd)
    INNER JOIN F0030 ON (F0100.company_cd          = F0030.company_cd)
                    AND (F0100.fiscal_year         = F0030.fiscal_year)
    				AND (F0100.employee_cd         = F0030.employee_cd)
    INNER JOIN M0070 ON (F0030.company_cd          = M0070.company_cd)
                    AND (F0030.rater_employee_cd_1 = M0070.employee_cd)
					AND (M0070.del_datetime IS NULL)  --2022/04/22
    --Å´2021/07/06 çÌèúÅ´
    --LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
    --                                AND (F0030.employee_cd = M0070_H.employee_cd)
	--Å™2021/07/06 çÌèúÅ™
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category = 3)
	  AND (F0300.notice_mail = 1)
      AND DATEADD(day,F0300.notice_send_date * -1,F0300.start_date) = @w_date
      AND (   F0300.notice_sending_target = 1
           OR F0300.notice_sending_target = 2)
    GROUP BY F0300.company_cd
           , F0300.category
           , F0300.status_cd
           , F0100.employee_cd
		   , F0100.fiscal_year
		   , M0070.employee_cd
    HAVING MAX(M0070.mail)!=''
    UNION
    --îÌï]âøé“ÉCÉìÉtÉHÉÅÅ[ÉVÉáÉìÉÅÅ[Éã
    SELECT F0300.company_cd          AS company_cd
         , F0300.category            AS category
         , F0300.status_cd           AS status_cd
         , 1                         AS infomationn_typ
         , @w_date                   AS infomation_date
         , F0100.employee_cd         AS target_employee_cd
		 , F0100.fiscal_year         AS fiscal_year
         , MAX(F0100.sheet_cd)       AS sheet_cd
         , F0100.employee_cd         AS employee_cd
    	 , MAX(M0070.mail)           AS send_mailaddress
		 --Å´2023/09/27 èCê≥Å´
         --, MAX(F0300.notice_title)   AS infomation_title
         --, MAX(F0300.notice_message) AS infomation_message
         , MAX(M0311.notice_title)   AS infomation_title
         , MAX(M0311.notice_message) AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd       = M0200.company_cd)
                    AND (F0300.period_detail_no = M0200.evaluation_period)
    INNER JOIN F0100 ON (F0300.company_cd       = F0100.company_cd)
                    AND (F0300.fiscal_year      = F0100.fiscal_year)
    				AND (M0200.sheet_cd         = F0100.sheet_cd)
    INNER JOIN M0070 ON (F0100.company_cd       = M0070.company_cd)
                    AND (F0100.employee_cd      = M0070.employee_cd)
					AND (M0070.del_datetime IS NULL)  --2022/04/22
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category = 3)
	  AND (F0300.notice_mail = 1)
      AND DATEADD(day,F0300.notice_send_date * -1,F0300.start_date) = @w_date
      AND (   F0300.notice_sending_target = 1
           OR F0300.notice_sending_target = 3)
    GROUP BY F0300.company_cd
           , F0300.category
           , F0300.status_cd
           , F0100.employee_cd
		   , F0100.fiscal_year
    HAVING MAX(M0070.mail)!=''
    UNION
    --ï]âøé“ÉAÉâÅ[ÉgÉÅÅ[Éã
    SELECT DISTINCT 
           F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 2                       AS infomationn_typ
         , @w_date                 AS infomation_date
         , F0100.employee_cd       AS target_employee_cd
		 , F0100.fiscal_year       AS fiscal_year
         , MAX(F0100.sheet_cd)     AS sheet_cd
         , M0070.employee_cd       AS employee_cd
    	 , MAX(M0070.mail)         AS send_mailaddress
		 --Å´2023/09/27 èCê≥Å´
         --, MAX(F0300.alert_title)  AS infomation_title
         --, 'ëŒè€:' + MAX(M0070_H.employee_nm) + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + MAX(F0300.alert_message) AS infomation_message
         , MAX(M0311.alert_title)  AS infomation_title
         , 'ëŒè€:' + MAX(M0070_H.employee_nm) + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + MAX(M0311.alert_message) AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd          = M0200.company_cd)
                    AND (F0300.period_detail_no    = M0200.evaluation_period)
    INNER JOIN F0100 ON (F0300.company_cd          = F0100.company_cd)
                    AND (F0300.fiscal_year         = F0100.fiscal_year)
    				AND (M0200.sheet_cd            = F0100.sheet_cd)
    INNER JOIN F0030 ON (F0100.company_cd          = F0030.company_cd)
                    AND (F0100.fiscal_year         = F0030.fiscal_year)
    				AND (F0100.employee_cd         = F0030.employee_cd)
    INNER JOIN M0070 ON (F0030.company_cd          = M0070.company_cd)
                    AND (F0030.rater_employee_cd_1 = M0070.employee_cd)
					AND (M0070.del_datetime IS NULL)  --2022/04/22 í«â¡
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
    LEFT OUTER JOIN F0122 ON (F0300.company_cd             = F0122.company_cd)
                         AND (F0300.fiscal_year            = F0122.fiscal_year)
    				     AND (F0300.period_detail_no       = F0122.period_detail_no)
						 AND (F0300.status_cd              = F0122.interview_no)
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category = 3)
	  AND (F0300.alert_mail = 1)
	  --Å´2022/05/13 èCê≥Å´
      --AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date
	  AND DATEADD(day,1,DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date)) = @w_date
	  --Å™2022/05/13 èCê≥Å™
      AND (   F0300.alert_sending_target = 1
           OR F0300.alert_sending_target = 2)
	  AND (M0070_H.del_datetime IS NULL)  --2022/04/22 í«â¡
	  AND (F0122.company_cd IS NULL)
    GROUP BY F0300.company_cd
           , F0300.category
           , F0300.status_cd
           , F0100.employee_cd
		   , F0100.fiscal_year
		   , M0070.employee_cd
    HAVING MAX(M0070.mail)!=''
    UNION
    --îÌï]âøé“ÉAÉâÅ[ÉgÉÅÅ[Éã
    SELECT F0300.company_cd         AS company_cd
         , F0300.category           AS category
         , F0300.status_cd          AS status_cd
         , 2                        AS infomationn_typ
         , @w_date                  AS infomation_date
         , F0100.employee_cd        AS target_employee_cd
		 , F0100.fiscal_year        AS fiscal_year
         , MAX(F0100.sheet_cd)      AS sheet_cd
         , F0100.employee_cd        AS employee_cd
    	 , MAX(M0070.mail)          AS send_mailaddress
		 --Å´2023/09/27 èCê≥Å´
         --, MAX(F0300.alert_title)   AS infomation_title
         --, MAX(F0300.alert_message) AS infomation_message
         , MAX(M0311.alert_title)   AS infomation_title
         , MAX(M0311.alert_message) AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd       = M0200.company_cd)
                    AND (F0300.period_detail_no = M0200.evaluation_period)
    INNER JOIN F0100 ON (F0300.company_cd       = F0100.company_cd)
                    AND (F0300.fiscal_year      = F0100.fiscal_year)
    				AND (M0200.sheet_cd         = F0100.sheet_cd)
    INNER JOIN M0070 ON (F0100.company_cd       = M0070.company_cd)
                    AND (F0100.employee_cd      = M0070.employee_cd)
					AND (M0070.del_datetime IS NULL)  --2022/04/22
    LEFT OUTER JOIN F0122 ON (F0300.company_cd       = F0122.company_cd)
                         AND (F0300.fiscal_year      = F0122.fiscal_year)
    				     AND (F0300.period_detail_no = F0122.period_detail_no)
						 AND (F0300.status_cd        = F0122.interview_no)
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category = 3)
	  AND (F0300.alert_mail = 1)
	  --Å´2022/05/13 èCê≥Å´
      --AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date
	  AND DATEADD(day,1,DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date)) = @w_date
	  --Å™2022/05/13 èCê≥Å™
      AND (   F0300.alert_sending_target = 1
           OR F0300.alert_sending_target = 3)
	  AND F0122.company_cd IS NULL
    GROUP BY F0300.company_cd
           , F0300.category
           , F0300.status_cd
           , F0100.employee_cd
		   , F0100.fiscal_year
    HAVING MAX(M0070.mail)!=''
    UNION
    --ñ¢é¿é{é“ÉAÉâÅ[ÉgÉÅÅ[Éã
    SELECT DISTINCT 
           F0300.company_cd        AS company_cd
         , F0300.category          AS category
         , F0300.status_cd         AS status_cd
         , 2                       AS infomationn_typ
         , @w_date                 AS infomation_date
         , F0100.employee_cd       AS target_employee_cd
		 , F0100.fiscal_year       AS fiscal_year
         , MAX(F0100.sheet_cd)     AS sheet_cd
         , M0070.employee_cd       AS employee_cd
    	 , MAX(M0070.mail)         AS send_mailaddress
		 --Å´2023/09/27 èCê≥Å´
         --, MAX(F0300.alert_title)  AS infomation_title
         --, 'ëŒè€:' + MAX(M0070_H.employee_nm) + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + MAX(F0300.alert_message) AS infomation_message
         , MAX(M0311.alert_title)  AS infomation_title
         , 'ëŒè€:' + MAX(M0070_H.employee_nm) + 'Ç≥ÇÒ'+ CHAR(13) + CHAR(10) + MAX(M0311.alert_message) AS infomation_message
		 --Å™2023/09/27 èCê≥Å™
		 , null
		 , 'system', '', 'B0010', @w_now, '', '', '', null, '', '', '', null
    FROM F0300
    INNER JOIN M0200 ON (F0300.company_cd          = M0200.company_cd)
                    AND (F0300.period_detail_no    = M0200.evaluation_period)
    INNER JOIN F0100 ON (F0300.company_cd          = F0100.company_cd)
                    AND (F0300.fiscal_year         = F0100.fiscal_year)
    				AND (M0200.sheet_cd            = F0100.sheet_cd)
    INNER JOIN F0030 ON (F0100.company_cd          = F0030.company_cd)
                    AND (F0100.fiscal_year         = F0030.fiscal_year)
    				AND (F0100.employee_cd         = F0030.employee_cd)
    INNER JOIN M0070 ON (F0030.company_cd          = M0070.company_cd)
                    AND (F0030.rater_employee_cd_1 = M0070.employee_cd)
					AND (M0070.del_datetime IS NULL)  --2022/04/22 í«â¡
    LEFT OUTER JOIN M0070 AS M0070_H ON (F0030.company_cd  = M0070_H.company_cd)
                                    AND (F0030.employee_cd = M0070_H.employee_cd)
    LEFT OUTER JOIN F0122 ON (F0300.company_cd       = F0122.company_cd)
                         AND (F0300.fiscal_year      = F0122.fiscal_year)
    				     AND (F0300.period_detail_no = F0122.period_detail_no)
						 AND (F0300.status_cd        = F0122.interview_no)
	--Å´2023/09/27 í«â¡Å´
    INNER JOIN M0311 ON (F0300.company_cd = M0311.company_cd)
	                AND (F0300.category   = M0311.category)
					AND (F0300.status_cd  = M0311.status_cd)
					AND (M0311.del_datetime IS NULL)
    --Å™2023/09/27 í«â¡Å™
    WHERE (F0300.category = 3)
	  AND (F0300.alert_mail = 1)
	  --Å´2022/05/13 èCê≥Å´
      --AND DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date) = @w_date 
	  AND DATEADD(day,1,DATEADD(day,F0300.alert_send_date * 1,F0300.deadline_date)) = @w_date 
	  --Å™2022/05/13 èCê≥Å™
      AND (F0300.alert_sending_target = 4)
	  AND (M0070_H.del_datetime IS NULL)	--2022/04/22 í«â¡
	  AND F0122.company_cd IS NULL			--2022/08/05 í«â¡
    GROUP BY F0300.company_cd
           , F0300.category
           , F0300.status_cd
           , F0100.employee_cd
		   , F0100.fiscal_year
		   , M0070.employee_cd
    HAVING MAX(M0070.mail)!=''
END
GO
