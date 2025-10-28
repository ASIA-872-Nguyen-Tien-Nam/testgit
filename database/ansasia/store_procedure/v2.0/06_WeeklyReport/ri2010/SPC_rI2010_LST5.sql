IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_rI2010_LST5]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_rI2010_LST5]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_rI2010_LST5 '901','1','782';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	GET COMMENT OPTIONS
--*  
--*  作成日/create date			:	2024/03/26						
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	
--*　更新者/updater				:	
--*　更新内容/update content		:	
--*  
--****************************************************************************************
CREATE PROCEDURE [SPC_rI2010_LST5]
	@P_comment_typ			SMALLINT		=	0	-- ログインユーザーが承認者の場合は「１」、閲覧者の場合は「2」
,	@P_login_employee_cd	NVARCHAR(10)	=	''
,	@P_company_cd			SMALLINT		=	0
AS
BEGIN
	--
	CREATE TABLE #TABLE_RESULT (
		id			int			identity(1,1)
	,	detail_no	smallint
	,	comment		nvarchar(30)
	,	view_typ	smallint
	)
	--[0]
	INSERT INTO #TABLE_RESULT
	SELECT 
		ISNULL(F4300.detail_no,0)					AS	detail_no
	,	ISNULL(F4300.comment,'')					AS	comment
	,	1											AS	view_typ
	FROM F4300 WITH(NOLOCK)
	WHERE 
		F4300.company_cd	=	@P_company_cd
	AND F4300.employee_cd	=	@P_login_employee_cd
	AND F4300.comment_typ	=	@P_comment_typ
	AND F4300.del_datetime	IS NULL
	--
	IF NOT EXISTS (SELECT 1 FROM #TABLE_RESULT)
	BEGIN
		INSERT INTO #TABLE_RESULT VALUES (0,'',0)
	END
	--[0]
	SELECT 
		#TABLE_RESULT.detail_no					AS	detail_no
	,	#TABLE_RESULT.comment					AS	comment
	,	#TABLE_RESULT.id						AS	row_index
	,	#TABLE_RESULT.view_typ					AS	view_typ
	FROM #TABLE_RESULT
	-- DROP
	DROP TABLE #TABLE_RESULT
END
GO
