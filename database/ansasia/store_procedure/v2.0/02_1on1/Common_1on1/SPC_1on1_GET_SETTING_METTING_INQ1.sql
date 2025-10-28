IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_1on1_GET_SETTING_METTING_INQ1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].SPC_1on1_GET_SETTING_METTING_INQ1
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	COMMON - GET SETTING MEETING
--*  
--* 作成日/create date			:	2020/12/10								
--*	作成者/creater				:	datnt				
--*   					
--*	更新日/update date			:	2021/04/06		
--*	更新者/updater				:　 	vietdt					     	 
--*	更新内容/update content		:	add decentralization
--*   					
--*	更新日/update date			:	2021/04/22		
--*	更新者/updater				:　 	viettd					     	 
--*	更新内容/update content		:	change M0100.beginning_date => M0100.1on1_beginning_date
--* 				
--****************************************************************************************
CREATE PROCEDURE [SPC_1on1_GET_SETTING_METTING_INQ1]
	@P_company_cd				SMALLINT		= 0
,	@P_fiscal_year				SMALLINT		= 0
,	@P_employee_cd				NVARCHAR(10)	= ''
,	@P_times					SMALLINT		= 0
,	@P_from						NVARCHAR(20)	= ''
,	@P_cre_employee_cd			NVARCHAR(10)	= ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@year							NVARCHAR(10)		=	''
	,	@w_1on1_is_coach_member			INT					=	0	-- 1. IS COACH OR MEMBER || 0.NOT COACH NOT MEMBER	-- add by vietdt 2021/04/06
	,	@w_fiscal_year					INT					=	dbo.FNC_GET_YEAR_1ON1(@P_company_cd , NULL)					-- add by vietdt 2021/04/06
	,	@w_authority					SMALLINT			=	0														-- add by vietdt 2021/04/06
	,	@w_1on1_authority_typ			SMALLINT			=	0														-- add by vietdt 2021/04/05	
	,	@w_permission					SMALLINT			=	1	-- 0. not view,1. view , 2.edited					-- add by vietdt 2021/04/05
	--[0]
	SELECT 
		FORMAT([1on1_schedule_date],'yyyy/MM/dd')	 AS oneonone_schedule_date	
	,	[time]				
	,	title				
	,	place				
	FROM F2010
	WHERE 
		company_cd	= @P_company_cd
	AND fiscal_year	= @P_fiscal_year
	AND employee_cd	= @P_employee_cd
	AND times		= @P_times
	AND F2010.del_datetime IS NULL
	-- GET DATA FROM S2020 + S2021
	IF EXISTS (SELECT 1 FROM F2001 
						WHERE 
							F2001.company_cd		=	@P_company_cd
						AND	F2001.fiscal_year		=	@P_fiscal_year
						AND	F2001.employee_cd		=	@P_employee_cd
						AND	(
								F2001.coach_cd		=	@P_cre_employee_cd
							OR	F2001.employee_cd	=	@P_cre_employee_cd
						)
						AND	F2001.times				=	@P_times
						AND	F2001.del_datetime	IS NULL)
	BEGIN
		SET @w_1on1_is_coach_member = 1	-- is coach or member
	END

	SELECT 
		@w_1on1_authority_typ	=	ISNULL(S0010.[1on1_authority_typ],0)	
	,	@w_authority			=	ISNULL(S2021.authority,0)
	FROM S0010
	LEFT JOIN S2021  ON (
		S0010.company_cd			=	S2021.company_cd
	AND	S0010.[1on1_authority_cd]	=	S2021.authority_cd
	AND	@P_from						=	S2021.function_id
	AND	S2021.del_datetime	IS NULL
	)
	WHERE 
		S0010.company_cd	= @P_company_cd 
	AND S0010.employee_cd	= @P_cre_employee_cd
	AND S0010.del_datetime IS NULL
	-- is coach or member
	IF	@w_1on1_is_coach_member = 1
	BEGIN
		SET @w_permission = 2
	END
	-- not coach or member
	IF	@w_1on1_is_coach_member <> 1 
	BEGIN
		--
		IF	@w_1on1_authority_typ IN(4,5)
		BEGIN
			SET @w_permission = 2
		END
		--
		IF	@w_1on1_authority_typ = 3  AND @w_authority = 2
		BEGIN
			SET @w_permission = 2
		END
	END
	--[1]
	SELECT @w_permission AS permission
END

GO
