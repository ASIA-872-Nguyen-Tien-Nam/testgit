DROP PROCEDURE [SPC_EMPLOYEE_TAB_AUTHORITY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ SM0100
--  EXEC [SPC_EMPLOYEE_TAB_AUTHORITY] '740';

--****************************************************************************************
--*   											
--*  処理概要/process overview	:	
--*  
--*  作成日/create date			:	2024/03/20					
--*　作成者/creater				:	namnt								
--* 
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_EMPLOYEE_TAB_AUTHORITY]
		@P_company_cd	SMALLINT		= 0
	,	@P_lang			NVARCHAR(5)		= N'jp'
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
		L0034.tab_id	
	,	ISNULL(IIF(@P_lang = N'en',L0034.tab_nm_en,L0034.tab_nm),N'') as tab_nm
	,	M9102.use_typ
	FROM L0034 WITH(NOLOCK) 
	LEFT JOIN M9102 WITH(NOLOCK)  ON(
		M9102.company_cd = @P_company_cd
	AND	L0034.tab_id = M9102.tab_id
	)
	WHERE
		L0034.refer_user_typ = 1
	AND L0034.del_datetime IS NULL
	AND M9102.del_datetime IS NULL
END
GO