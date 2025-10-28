DROP PROCEDURE [SPC_EMPLOYEE_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- +--TEST--+ SPC_EMPLOYEE_INQ1
-- EXEC [SPC_EMPLOYEE_INQ1]]'';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	
--*  
--*  作成日/create date			:	2018/08/21				
--*　作成者/creater				:	Tuantv								
--*   					
--*  更新日/update date			:	2021/01/07
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	add system (1.人事評価 2.1on1 3.マルチレビュー 4.共通設定) 5.週報 6.社員情報
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_EMPLOYEE_INQ1]
	@P_company_cd		SMALLINT		=	0
,	@P_user_id			NVARCHAR(MAX)	=	''
,	@P_system			SMALLINT		=	1	-- 1.人事評価 2.1on1 3.マルチレビュー 4.共通設定  5.週報　6.社員情報
AS
BEGIN	
	SET NOCOUNT ON;
	--[0]M0010 --
	EXECUTE SPC_COMBOBOX_INQ1 'M0010','1',@P_user_id,@P_company_cd,@P_system
	--[1]
	EXECUTE SPC_COMBOBOX_INQ1 'M0020','1',@P_user_id,@P_company_cd,@P_system
	 --[2]
	EXECUTE SPC_COMBOBOX_INQ1 'M0030','1',@P_user_id,@P_company_cd,@P_system
	 --[3]
	EXECUTE SPC_COMBOBOX_INQ1 'M0040','1',@P_user_id,@P_company_cd,@P_system
	--[4]
	EXECUTE SPC_COMBOBOX_INQ1 'M0050','1',@P_user_id,@P_company_cd,@P_system
	--[5]
	EXECUTE SPC_COMBOBOX_INQ1 'M0060','1',@P_user_id,@P_company_cd,@P_system

END
GO