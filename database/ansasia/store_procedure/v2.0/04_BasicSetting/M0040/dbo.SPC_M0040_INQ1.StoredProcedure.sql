DROP PROCEDURE [SPC_M0040_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	LIST DATA
--*  
--* 作成日/create date			:	2018/08/20											
--*	作成者/creater				:	longvv				
--*   					
--*	更新日/update date			:  						
--*	更新者/updater				:　  　								     	 
--*	更新内容/update content		:	　	
--****************************************************************************************
CREATE PROCEDURE [SPC_M0040_INQ1]
	@P_position_cd	int
,	@P_company_cd	smallint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		position_cd
	,	position_nm
	,	position_ab_nm
	,	arrange_order
	,	import_cd
	FROM M0040
	WHERE
		company_cd	=	@P_company_cd
	AND	position_cd	=	@P_position_cd
END

GO
