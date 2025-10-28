DROP PROCEDURE [SPC_M0070_01_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		namnb
-- Create date: 2018/08/20
-- Description:	get right content
-- =============================================
CREATE PROCEDURE [SPC_M0070_01_INQ1]
	@P_employee_cd			NVARCHAR(MAX)	=	''
,	@P_company_cd			SMALLINT		=	0
,	@P_user_id				NVARCHAR(100)	=	''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE
		@w_language							SMALLINT		=	1	--1 jp / 2 en

	SET @w_language = (SELECT S0010.language FROM S0010 
						WHERE S0010.del_datetime IS NULL
						AND S0010.company_cd	= @P_company_cd 
						AND S0010.user_id	= @P_user_id) 

    -- SELECT procedure here
	SELECT 
			M0074.blood_type
		,	M0074.headquarters_prefectures
		,	M0074.headquarters_other
		,	M0074.possibility_transfer
		,	CASE
				WHEN @w_language = 2
				THEN IIF(ISNULL(L0012.name_en,'') = '',M0074.nationality,L0012.name_en)
				ELSE IIF(ISNULL(L0012.name,'') = '',M0074.nationality,L0012.name)
			END														AS		nationality
		,	M0074.nationality										AS		nationality_cd
		,	M0074.residence_card_no
		,	M0074.status_residence
		,	FORMAT(M0074.expiry_date,'yyyy/MM/dd')					AS		expiry_date	
		,	M0074.permission_activities
		,	M0074.disability_classification
		,	M0074.disability_content
		,	FORMAT(M0074.disability_recognition_date,'yyyy/MM/dd')	AS disability_recognition_date	
		,	M0074.common_name
		,	M0074.common_name_furigana
		,	M0074.maiden_name
		,	M0074.maiden_name_furigana
		,	M0074.business_name
		,	M0074.business_name_furigana
		,	M0074.attached_file1
		,	M0074.attached_file1_name
		,	FORMAT(M0074.attached_file1_uploaddatetime,'yyyy/MM/dd HH:mm')	AS attached_file1_uploaddatetime	
		,	M0074.attached_file2
		,	M0074.attached_file2_name
		,	FORMAT(M0074.attached_file2_uploaddatetime,'yyyy/MM/dd HH:mm')	AS attached_file2_uploaddatetime	
		,	M0074.attached_file3
		,	M0074.attached_file3_name
		,	FORMAT(M0074.attached_file3_uploaddatetime,'yyyy/MM/dd HH:mm')	AS attached_file3_uploaddatetime	
		,	M0074.attached_file4
		,	M0074.attached_file4_name
		,	FORMAT(M0074.attached_file4_uploaddatetime,'yyyy/MM/dd HH:mm')	AS attached_file4_uploaddatetime	
		,	M0074.attached_file5
		,	M0074.attached_file5_name
		,	FORMAT(M0074.attached_file5_uploaddatetime,'yyyy/MM/dd HH:mm')	AS attached_file5_uploaddatetime	
		,	M0074.base_style
		,	M0074.sub_style
		,	M0074.driver_point
		,	M0074.analytical_point
		,	M0074.expressive_point
		,	M0074.amiable_point
		FROM M0074 
		LEFT JOIN L0011 ON(
			M0074.headquarters_prefectures	=	L0011.number_cd
		AND L0011.del_datetime IS NULL
		)
		LEFT JOIN L0012 ON(
			M0074.nationality	=	L0012.number_cd
		AND L0012.del_datetime IS NULL
		)
		WHERE M0074.del_datetime IS NULL
		AND M0074.company_cd	= @P_company_cd 
		AND M0074.employee_cd	= @P_employee_cd

	SELECT marcopolo_use_typ FROM M0001 WHERE company_cd = @P_company_cd
END

GO