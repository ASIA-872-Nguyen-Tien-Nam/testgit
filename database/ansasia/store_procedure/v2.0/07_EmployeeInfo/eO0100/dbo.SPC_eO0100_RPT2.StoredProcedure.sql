DROP PROCEDURE [SPC_eO0100_RPT2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+TEST+
-- 
/****************************************************************************************************
 *
 *  処理概要:  export csv file
 *
 *  作成日  ： 2018/10/01
 *  作成者  ： sondh
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [dbo].[SPC_eO0100_RPT2]
	@P_company_cd			SMALLINT		= 	0
,	@P_language				NVARCHAR(2)		= 	N''
AS
BEGIN
	SET NOCOUNT ON;
	--[0]
	CREATE TABLE #DATA 
	(
		id										INT				IDENTITY(1,1)
	,	training_cd								NVARCHAR(20)
	,	training_nm								NVARCHAR(50)
	,	training_ab_nm							NVARCHAR(20)
	,	training_category_cd					NVARCHAR(20)
	,	training_course_format_cd				NVARCHAR(20)
	,	editable_kbn							NVARCHAR(20)
	,	arrange_order							NVARCHAR(20)
	)	
	--	
	IF (@P_language = N'en')
	BEGIN
		INSERT INTO #DATA
		SELECT 
			N'Training Code'					AS	training_cd		
		,	N'Training Name'					AS	training_nm		
		,	N'Abbreviation'						AS	training_ab_nm	
		,	N'Category Code'					AS	training_category_cd			
		,	N'Course Format Code'				AS	training_course_format_cd		
		,	N'Change Category'					AS	editable_kbn		
		,	N'Order'							AS	arrange_order	
	END
	ELSE
	BEGIN
		INSERT INTO #DATA
		SELECT 
			N'研修コード'					AS	training_cd		
		,	N'研修名'						AS	training_nm		
		,	N'研修名略称'					AS	training_ab_nm	
		,	N'研修カテゴリー'					AS	training_category_cd			
		,	N'受講形式'						AS	training_course_format_cd		
		,	N'変更区分'						AS	editable_kbn		
		,	N'並び順'						AS	arrange_order	
	END
	--
	INSERT INTO #DATA
	SELECT 
		ISNULL(training_cd,N'0')							AS training_cd		
	,	ISNULL(training_nm,N'')								AS training_nm		
	,	ISNULL(training_ab_nm,N'')							AS training_ab_nm	
	,	ISNULL(training_category_cd,N'0')					AS training_category_cd			
	,	ISNULL(training_course_format_cd,N'0')				AS training_course_format_cd		
	,	ISNULL(editable_kbn,N'0')							AS editable_kbn		
	,	ISNULL(arrange_order,N'0')							AS arrange_order	
	FROM M5030
	WHERE 
		company_cd	=	@P_company_cd
	AND del_datetime IS NULL
	ORDER BY 
		arrange_order
	,	training_cd

	--[0]
	SELECT
		#DATA.training_cd		
	,	#DATA.training_nm		
	,	#DATA.training_ab_nm	
	,	#DATA.training_category_cd			
	,	#DATA.training_course_format_cd		
	,	#DATA.editable_kbn		
	,	#DATA.arrange_order	
	FROM #DATA
	ORDER BY 
		id
END
GO
