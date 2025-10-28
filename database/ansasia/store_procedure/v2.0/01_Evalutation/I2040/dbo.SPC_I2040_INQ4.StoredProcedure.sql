DROP PROCEDURE [SPC_I2040_INQ4]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	I2040
--*  
--*  作成日/create date			:	2020/01/17			
--*　作成者/creater				:	datnt								
--*   					
--*  更新日/update date			:	2022/08/08
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	when rater_1~ rater_4 then show prev evalutation comment
--*   					
--*  更新日/update date			:	2022/09/28
--*　更新者/updater				:　	vietdt
--*　更新内容/update content		:	ver 1.9
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_I2040_INQ4]
	@P_company_cd						SMALLINT		=	0
,	@P_fiscal_year						SMALLINT		=	0
,	@P_employee_cd						NVARCHAR(50)	=	0
,	@P_treatment_applications_no		NVARCHAR(50)	=	0
,	@P_valuation_step					SMALLINT		=	0	-- add by viettd 2022/08/08
,	@P_language							NVARCHAR(2)		=	'jp'-- add by vietdt 2022/09/28
AS
BEGIN
	--[0]
	SELECT 
		CASE evaluation_step 
			WHEN 1 THEN IIF(@P_language = 'en','First Evaluation','一次評価')
			WHEN 2 THEN IIF(@P_language = 'en','Second Evaluation','二次評価')	
			WHEN 3 THEN IIF(@P_language = 'en','Third Evaluation','三次評価')
			WHEN 4 THEN IIF(@P_language = 'en','Fourth Evaluation','四次評価')
			ELSE ''
		END AS evaluation_step
	,	ISNULL(comment,'') AS comment
	FROM F0200
	WHERE
		F0200.company_cd					=	@P_company_cd
	AND F0200.fiscal_year					=	@P_fiscal_year
	AND	F0200.employee_cd					=	@P_employee_cd
	AND	F0200.treatment_applications_no		=	@P_treatment_applications_no
	--↓↓↓ add by viettd 2022/08/08
	AND (
		@P_valuation_step = 5
	OR	@P_valuation_step <> 5 AND F0200.evaluation_step <= @P_valuation_step
	)
	--↑↑↑ end add by viettd 2022/08/08
	AND F0200.del_datetime IS NULL
END
GO