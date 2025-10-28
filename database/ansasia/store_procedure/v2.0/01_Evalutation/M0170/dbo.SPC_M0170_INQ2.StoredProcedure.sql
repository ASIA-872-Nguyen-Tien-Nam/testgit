DROP PROCEDURE [SPC_M0170_INQ2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ M0170
-- EXEC [SPC_M0170_INQ2] '','';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	M0170
--*  
--*  作成日/create date			:	2018/09/14						
--*　作成者/creater				:	Tuantv								
--*   					
--*  更新日/update date			:	2022/03/11
--*　更新者/updater				:　	vietdt
--*　更新内容/update content		:	cr add target_self_assessment_typ
--*  更新日/update date			:   2022/08/22
--*　更新者/updater				:　 tuyedn
--*　更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_M0170_INQ2]
	@P_company_cd	SMALLINT = 0
,	@P_language		NVARCHAR(MAX)	= ''   -- add tuyendn 2022/08/22
AS
BEGIN
	--add by vietdt 2022/03/11
	SET NOCOUNT ON;
	DECLARE 
		@w_evaluation_self_assessment_typ	SMALLINT		=	0
	

	
	--[0]
	SELECT 
		L0010.name_typ
	,	L0010.number_cd
	,	CASE																		--add tuyendn 2022/08/22
			WHEN	@P_language = 'en'
			THEN	ISNULL(L0010.name_english,'')
			ELSE	ISNULL(L0010.name,'')
		END													AS	[name]
	FROM L0010
	WHERE L0010.name_typ = 7
	AND L0010.del_datetime IS NULL
	ORDER BY  
		L0010.arrange_order ASC
	,	L0010.number_cd

	--[1]
	SELECT 
		M0120.company_cd
	,	M0120.point_kinds
	,	ISNULL(M0120.point_kinds_nm,'')		AS point_kinds_nm
	,	ISNULL(M0120.arrange_order,0)		AS arrange_order
	FROM M0120
	WHERE M0120.company_cd = @P_company_cd
	AND M0120.del_datetime IS NULL
	ORDER BY  
		M0120.arrange_order ASC
	,	M0120.point_kinds

	--[2]
	SELECT 
		ROW_NUMBER() OVER(ORDER BY M0101.detail_no ASC) AS id
	,	M0101.company_cd
	,	M0101.detail_no
	,	ISNULL(M0101.period_nm,'')			AS period_nm
	FROM M0101
	WHERE 
		M0101.company_cd = @P_company_cd
	AND M0101.del_datetime IS NULL 
	ORDER BY  
		M0101.detail_no

	--[3]
	SELECT 
		ROW_NUMBER() OVER(ORDER BY L0010.number_cd ASC) AS id	
	,	L0010.name_typ
	,	L0010.number_cd
	,	CASE																		--add tuyendn 2022/08/22
			WHEN	@P_language = 'en'
			THEN	ISNULL(L0010.name_english,'')
			ELSE	ISNULL(L0010.name,'')
		END													AS	[name]
	FROM L0010
	WHERE L0010.name_typ = 6
	AND L0010.del_datetime IS NULL
	ORDER BY  
		L0010.arrange_order ASC
	,	L0010.number_cd
	--[4]
	--add by vietdt 2022/03/11
	SET @w_evaluation_self_assessment_typ = (SELECT ISNULL(evaluation_self_assessment_typ,0) FROM M0100 WHERE del_datetime IS NULL AND company_cd = @P_company_cd)
	--
	SELECT @w_evaluation_self_assessment_typ	AS evaluation_self_assessment_typ
END
GO