DROP PROCEDURE [SPC_RM0010_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ 
--****************************************************************************************
--*   											
--*  �����T�v/process overview	:	RM0010
--*  
--*  �쐬��/create date			:	2023/04/04						
--*�@�쐬��/creater				:	namnt								
--*
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_RM0010_INQ1]
	@P_company_cd	SMALLINT = 0
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
		ISNULL(company_cd,0)								AS	company_cd										
	,	ISNULL(annualreport_user_typ,0)						AS	annualreport_user_typ	
	,	CASE 
			WHEN	ISNULL(annualreport_user_typ,0) = 1 
			THEN	'active'
			ELSE	''
		END													AS	annualreport_user_typ_class									
	,	ISNULL(semi_annualreport_user_typ,0)						AS	semi_annualreport_user_typ	
	,	CASE 
			WHEN	ISNULL(semi_annualreport_user_typ,0) = 1 
			THEN	'active'
			ELSE	''
		END													AS	semi_annualreport_user_typ_class										
	,	ISNULL(quarterlyreport_user_typ,0)							AS	quarterlyreport_user_typ	
	,	CASE 
			WHEN	ISNULL(quarterlyreport_user_typ,0) = 1 
			THEN	'active'
			ELSE	''
		END													AS	quarterlyreport_user_typ_class	
	,	ISNULL(monthlyreport_user_typ,0)							AS	monthly_report_typ	
	,	CASE 
			WHEN	ISNULL(monthlyreport_user_typ,0) = 1 
			THEN	'active'
			ELSE	''
		END													AS	monthly_report_typ_class									
	,	ISNULL(weeklyreport_user_typ,0)							AS	weekly_report_typ	
	,	CASE 
			WHEN	ISNULL(weeklyreport_user_typ,0) = 1 
			THEN	'active'
			ELSE	''
		END													AS	weekly_report_typ_class													
	,	ISNULL(annualreport_first_approval,0)					AS	first_annual_report_typ
	,	CASE 
			WHEN	ISNULL(annualreport_user_typ,0) = 0		--OR	ISNULL(target_self_assessment_typ,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(annualreport_first_approval,0)=1,'active','')
		END													AS	first_annual_report_typ_class	
	,	ISNULL(annualreport_second_approval,0)					AS	second_annual_report_typ
	,	CASE 
			WHEN	ISNULL(annualreport_user_typ,0) = 0	OR	ISNULL(annualreport_first_approval,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(annualreport_second_approval,0)=1,'active','')
		END													AS	second_annual_report_typ_class	
	,	ISNULL(annualreport_third_approval,0)					AS	third_annual_report_typ
	,	CASE 
			WHEN	ISNULL(annualreport_user_typ,0) = 0	OR	ISNULL(annualreport_first_approval,0) = 0 OR	ISNULL(annualreport_second_approval,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(annualreport_third_approval,0)=1,'active','')
		END													AS	third_annual_report_typ_class	
	,	ISNULL(annualreport_fourth_approval,0)					AS	fourth_annual_report_typ
	,	CASE 
			WHEN	ISNULL(annualreport_user_typ,0) = 0	OR	ISNULL(annualreport_first_approval,0) = 0 OR	ISNULL(annualreport_second_approval,0) = 0
					OR	ISNULL(annualreport_third_approval,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(annualreport_fourth_approval,0)=1,'active','')
		END													AS	fourth_annual_report_typ_class	
	,	ISNULL(semi_annualreport_first_approval,0)					AS	first_semi_annualreport_user_typ
	,	CASE 
			WHEN	ISNULL(semi_annualreport_user_typ,0) = 0		--OR	ISNULL(target_self_assessment_typ,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(semi_annualreport_first_approval,0)=1,'active','')
		END													AS	first_semi_annualreport_user_typ_class
	,	ISNULL(semi_annualreport_second_approval,0)					AS	second_semi_annualreport_user_typ
	,	CASE 
			WHEN	ISNULL(semi_annualreport_user_typ,0) = 0	OR	ISNULL(semi_annualreport_first_approval,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(semi_annualreport_second_approval,0)=1,'active','')
		END													AS	second_semi_annualreport_user_typ_class	
	,	ISNULL(semi_annualreport_third_approval,0)					AS	third_semi_annualreport_user_typ
	,	CASE 
			WHEN	ISNULL(semi_annualreport_user_typ,0) = 0	OR	ISNULL(semi_annualreport_first_approval,0) = 0
					OR	ISNULL(semi_annualreport_second_approval,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(semi_annualreport_third_approval,0)=1,'active','')
		END													AS	third_semi_annualreport_user_typ_class	
	,	ISNULL(semi_annualreport_fourth_approval,0)					AS	fourth_semi_annualreport_user_typ
	,	CASE 
			WHEN	ISNULL(semi_annualreport_user_typ,0) = 0	OR	ISNULL(semi_annualreport_first_approval,0) = 0
					OR	ISNULL(semi_annualreport_second_approval,0) = 0 OR	ISNULL(semi_annualreport_third_approval,0) = 0 
			THEN	''
			ELSE	IIF(ISNULL(semi_annualreport_fourth_approval,0)=1,'active','')
		END													AS	fourth_semi_annualreport_user_typ_class	
	,	ISNULL(quarterlyreport_first_approval,0)					AS	first_quarterly_report_typ
	,	CASE 
			WHEN	ISNULL(quarterlyreport_user_typ,0) = 0		--OR	ISNULL(target_self_assessment_typ,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(quarterlyreport_first_approval,0)=1,'active','')
		END													AS	first_quarterly_report_typ_class
	,	ISNULL(quarterlyreport_second_approval,0)					AS	second_quarterly_report_typ
	,	CASE 
			WHEN	ISNULL(quarterlyreport_user_typ,0) = 0	OR	ISNULL(quarterlyreport_first_approval,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(quarterlyreport_second_approval,0)=1,'active','')
		END													AS	second_quarterly_report_typ_class
	,	ISNULL(quarterlyreport_third_approval,0)					AS	third_quarterly_report_typ
	,	CASE 
			WHEN	ISNULL(quarterlyreport_user_typ,0) = 0	OR	ISNULL(quarterlyreport_first_approval,0) = 0
					OR ISNULL(quarterlyreport_second_approval,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(quarterlyreport_third_approval,0)=1,'active','')
		END													AS	third_quarterly_report_typ_class
	,	ISNULL(quarterlyreport_fourth_approval,0)					AS	fourth_quarterly_report_typ
	,	CASE 
			WHEN	ISNULL(quarterlyreport_user_typ,0) = 0	OR	ISNULL(quarterlyreport_first_approval,0) = 0
					OR ISNULL(quarterlyreport_second_approval,0) = 0 OR ISNULL(quarterlyreport_third_approval,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(quarterlyreport_fourth_approval,0)=1,'active','')
		END													AS	fourth_quarterly_report_typ_class
	,	ISNULL(monthlyreport_First_Approval,0)					AS	first_monthly_report_typ
	,	CASE 
			WHEN	ISNULL(monthlyreport_user_typ,0) = 0		--OR	ISNULL(target_self_assessment_typ,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(monthlyreport_First_Approval,0)=1,'active','')
		END														AS	first_monthly_report_typ_class
	,	ISNULL(monthlyreport_Second_Approval,0)					AS	second_monthly_report_typ
	,	CASE 
			WHEN	ISNULL(monthlyreport_user_typ,0) = 0	OR	ISNULL(monthlyreport_First_Approval,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(monthlyreport_Second_Approval,0)=1,'active','')
		END														AS	second_monthly_report_typ_class
	,	ISNULL(monthlyreport_third_approval,0)					AS	third_monthly_report_typ
	,	CASE 
			WHEN	ISNULL(monthlyreport_user_typ,0) = 0	OR	ISNULL(monthlyreport_First_Approval,0) = 0
					OR	ISNULL(monthlyreport_Second_Approval,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(monthlyreport_third_approval,0)=1,'active','')
		END														AS	third_monthly_report_typ_class
	,	ISNULL(monthlyreport_fourth_approval,0)					AS	fourth_monthly_report_typ
	,	CASE 
			WHEN	ISNULL(monthlyreport_user_typ,0) = 0	OR	ISNULL(monthlyreport_First_Approval,0) = 0
					OR	ISNULL(monthlyreport_Second_Approval,0) = 0 OR	ISNULL(monthlyreport_third_approval,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(monthlyreport_fourth_approval,0)=1,'active','')
		END														AS	fourth_monthly_report_typ_class
	,	ISNULL(weeklyreport_first_approval,0)					AS	first_weekly_report_typ
	,	CASE 
			WHEN	ISNULL(weeklyreport_user_typ,0) = 0	
			THEN	''
			ELSE	IIF(ISNULL(weeklyreport_first_approval,0)=1,'active','')
		END													AS first_weekly_report_typ_class
	,	ISNULL(weeklyreport_second_approval,0)					AS	second_weekly_report_typ
	,	CASE 
			WHEN	ISNULL(weeklyreport_user_typ,0) = 0	OR	ISNULL(weeklyreport_first_approval,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(weeklyreport_second_approval,0)=1,'active','')
		END													AS second_weekly_report_typ_class
	,	ISNULL(weeklyreport_third_approval,0)					AS	third_weekly_report_typ
	,	CASE 
			WHEN	ISNULL(weeklyreport_user_typ,0) = 0	OR	ISNULL(weeklyreport_first_approval,0) = 0
					OR ISNULL(weeklyreport_second_approval,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(weeklyreport_third_approval,0)=1,'active','')
		END													AS third_weekly_report_typ_class
	,	ISNULL(weeklyreport_fourth_approval,0)					AS	fourth_weekly_report_typ
	,	CASE 
			WHEN	ISNULL(weeklyreport_user_typ,0) = 0	OR	ISNULL(weeklyreport_first_approval,0) = 0
					OR ISNULL(weeklyreport_second_approval,0) = 0 OR ISNULL(weeklyreport_third_approval,0) = 0
			THEN	''
			ELSE	IIF(ISNULL(weeklyreport_fourth_approval,0)=1,'active','')
		END													AS fourth_weekly_report_typ_class
	,	monthlyreport_deadline	AS monthlyreport_deadline
	,	ISNULL(weeklyreport_deadline,0) AS weeklyreport_deadline
	,	ISNULL(weeklyreport_judgment_date,0) AS weeklyreport_judgment_date
	,	ISNULL(viewable_deadline_kbn,0) AS viewable_deadline_kbn
	,	ISNULL(viewer_sharing,0) AS viewer_sharing
	,	ISNULL(share_notify_reporter,0) AS share_notify_reporter
	,	ISNULL(comment_option_use_typ,0) AS comment_option_use_typ
	,	ISNULL(comment_option_authorizer_use_typ,0) AS comment_option_authorizer_use_typ
	,	ISNULL(comment_option_viewer_use_typ,0) AS comment_option_viewer_use_typ
	FROM M4100 WITH(NOLOCK)
	WHERE 
		(M4100.company_cd = @P_company_cd)
	AND	(M4100.del_datetime IS NULL)
	--[1]--note approver
	SELECT 
	row_number() OVER (ORDER BY detail_no) AS id
	,	ISNULL(M4101.detail_no,0) AS detail_no
	,	ISNULL(M4101.note_color,0) AS note_color
	,	ISNULL(M4101.note_name,'') AS note_name
	,	ISNULL(L0010.name,'') AS color_value
	FROM M4101 
	LEFT JOIN L0010 ON(
		M4101.note_color = L0010.number_cd
	AND	L0010.name_typ = 47
	)
	WHERE 
		@P_company_cd = M4101.company_cd 
	AND M4101.note_kind = 1
	AND M4101.del_datetime IS NULL
	--[2]
	SELECT 
		row_number() OVER (ORDER BY detail_no) AS id
	,	ISNULL(M4101.detail_no,0) AS detail_no
	,	ISNULL(M4101.note_color,0) AS note_color
	,	ISNULL(M4101.note_name,'') AS note_name
	,	ISNULL(L0010.name,'') AS color_value
	FROM M4101 
	LEFT JOIN L0010 ON(
		M4101.note_color = L0010.number_cd
	AND	L0010.name_typ = 47
	)
	WHERE 
		@P_company_cd = M4101.company_cd 
	AND M4101.note_kind = 2
	AND M4101.del_datetime IS NULL
END
GO
