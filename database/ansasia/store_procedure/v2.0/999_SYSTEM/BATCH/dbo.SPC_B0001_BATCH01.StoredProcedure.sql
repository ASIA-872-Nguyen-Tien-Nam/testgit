DROP PROCEDURE [SPC_B0001_BATCH01]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ EXECUTE SPC_B0001_BATCH01
--  
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	B0001
--*  
--*  作成日/create date			:	2018/09/10						
--*　作成者/creater				:	S.Miyashita								
--*   					
--*  更新日/update date			:  
--*　更新者/updater				:　
--*　更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [SPC_B0001_BATCH01]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@w_processing_date DATE
	,	@w_first_month     DATE
	,	@w_time            DATETIME2    = SYSDATETIME()
	,	@P_cre_user		   NVARCHAR(50) = 'system'
	,	@P_cre_ip		   NVARCHAR(50) = ''
	--
	CREATE TABLE #M0001(
		company_cd                 SMALLINT
	,	contract_attribute         SMALLINT
	,	contract_company_attribute SMALLINT
	)
	--
	SET @w_processing_date  = EOMONTH(@w_time , -1)
	SET @w_first_month      = DATEADD(dd,1,EOMONTH(@w_processing_date, -1))
	--
	INSERT INTO #M0001
	SELECT 
		company_cd
	,	evaluation_contract_attribute
	,	contract_company_attribute
	FROM M0001
	WHERE (M0001.contract_company_attribute = 2)	 
	  AND ((    (M0001.evaluation_contract_attribute = 2)
	        AND (M0001.evaluation_use_start_dt  <= @w_processing_date)
	        AND (   (@w_processing_date <= M0001.evaluation_user_end_dt)
	             OR (M0001.evaluation_user_end_dt IS NULL)
			    )
		   )
		   OR
           (    (M0001.[1on1_contract_attribute] = 2)
	        AND (M0001.[1on1_use_start_dt]  <= @w_processing_date)
	        AND (   (@w_processing_date <= M0001.[1on1_user_end_dt])
	             OR (M0001.[1on1_user_end_dt] IS NULL)
			    )
		   )
		   OR
           (    (M0001.multireview_contract_attribute = 2)
	        AND (M0001.multireview_use_start_dt  <= @w_processing_date)
	        AND (   (@w_processing_date <= M0001.multireview_user_end_dt)
	             OR (M0001.multireview_user_end_dt IS NULL)
			    )
		   )
		  )
	  AND (M0001.del_datetime IS NULL)
    --
	INSERT INTO F0001
	SELECT
		#M0001.company_cd         AS company_cd
	,	@w_first_month            AS processing_date
	,	#M0001.contract_company_attribute AS contract_company_attribute
	,	count(*)                  AS num_of_people
	,	@P_cre_user               AS cre_user
	,	@P_cre_ip                 AS cre_ip
	,	@w_time                   AS cre_datetime
	,	''                        AS upd_user
	,	''                        AS upd_ip
	,	NULL                      AS upd_datetime
	,	''                        AS del_user
	,	''                        AS del_ip
	,	NULL                      AS del_datetime
	FROM #M0001
	LEFT OUTER JOIN M0070 ON
		(#M0001.company_cd = M0070.company_cd)
	WHERE (M0070.company_in_dt <= @w_processing_date)
	  AND ((@w_processing_date <= M0070.company_out_dt)
	   OR  (M0070.company_out_dt IS NULL))
	  AND (M0070.del_datetime IS NULL)
	GROUP BY
		#M0001.company_cd 
	,	#M0001.contract_company_attribute
	--
	DROP TABLE #M0001
END
GO
