IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_oQ2010_INQ1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_oQ2010_INQ1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：OQ1020 - REFER DATA POPUP
 *
 *  作成日  ：2020-12-16
 *  作成者  ：ANS-ASIA DUONGNTT
 *
 *  更新日  ：2021/03/15
 *  更新者  ：viettd
 *  更新内容：get name of organization from M0022 + target from M2100
 *  EXEC SPC_oQ2010_INQ1 '740','721','2022';
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_oQ2010_INQ1] 
	@P_company_cd		SMALLINT		= 0
,	@P_user_id			NVARCHAR(50)	= ''
,	@P_fiscal_year		SMALLINT		= 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@check_all						INT				=	1
	--	目標
	,	@w_target1_use_typ				tinyint			=	NULL
	,	@w_target2_use_typ				tinyint			=	NULL
	,	@w_target3_use_typ				tinyint			=	NULL
	,	@w_comment_use_typ				tinyint			=	NULL
	--	組織
	,	@w_organization_use_typ_1		tinyint			=	NULL
	,	@w_organization_use_typ_2		tinyint			=	NULL
	,	@w_organization_use_typ_3		tinyint			=	NULL
	,	@w_organization_use_typ_4		tinyint			=	NULL
	,	@w_organization_use_typ_5		tinyint			=	NULL
	,	@w_organization_group_nm_1		nvarchar(20)	=	''
	,	@w_organization_group_nm_2		nvarchar(20)	=	''
	,	@w_organization_group_nm_3		nvarchar(20)	=	''
	,	@w_organization_group_nm_4		nvarchar(20)	=	''
	,	@w_organization_group_nm_5		nvarchar(20)	=	''
	,	@w_language						SMALLINT		=	1
		--add namnt 2022/08/29 get @w_language 
	SELECT 
		@w_language = S0010.[language]
	FROM S0010
	WHERE 
		S0010.company_cd		=	@P_company_cd
	AND S0010.[user_id]			=	@P_user_id
	AND S0010.del_datetime IS NULL
	-- TABLE RESULT
	CREATE TABLE #TABLE_RESULT (
		item_cd				smallint
	,	item_nm				nvarchar(50)
	,	order_no			smallint
	,	display_kbn			tinyint		-- 表示区分
	)
	--[0]
	INSERT INTO #TABLE_RESULT
	SELECT
		ISNULL(L0032.item_cd,0)			AS	item_cd		
	,	CASE 
			WHEN @w_language = 2 THEN L0032.item_nm_english
			ELSE L0032.item_nm	
		END AS item_nm
	,	IIF(S2011.order_no IS NOT NULL,S2011.order_no,ISNULL(L0032.order_no,0)) 
										AS	order_no
	,	ISNULL(S2011.display_kbn,1)		AS	display_kbn
	FROM L0032
	LEFT JOIN S2011 ON (
		L0032.item_cd		=	S2011.item_cd
	AND S2011.company_cd	=	@P_company_cd
	AND S2011.[user_id]		=	@P_user_id
	AND S2011.del_datetime IS NULL
	)
	WHERE 
		L0032.del_datetime IS NULL
	ORDER BY 
	CASE	
		WHEN S2011.order_no IS NOT NULL 
		THEN S2011.order_no
		ELSE L0032.order_no
	END ASC
	--------------- UPDATE ITEM_NM AND DELETE ITEM NOT USE -------------
	SELECT 
		@w_organization_use_typ_1		= ISNULL(M0022.use_typ,0)
	,	@w_organization_group_nm_1		= ISNULL(M0022.organization_group_nm,'')
	FROM M0022
	WHERE 
		M0022.company_cd = @P_company_cd
	AND M0022.organization_typ = 1
	AND M0022.del_datetime IS NULL
	--
	SELECT 
		@w_organization_use_typ_2		= ISNULL(M0022.use_typ,0)
	,	@w_organization_group_nm_2		= ISNULL(M0022.organization_group_nm,'')
	FROM M0022
	WHERE 
		M0022.company_cd = @P_company_cd
	AND M0022.organization_typ = 2
	AND M0022.del_datetime IS NULL
	--
	SELECT 
		@w_organization_use_typ_3		= ISNULL(M0022.use_typ,0)
	,	@w_organization_group_nm_3		= ISNULL(M0022.organization_group_nm,'')
	FROM M0022
	WHERE 
		M0022.company_cd = @P_company_cd
	AND M0022.organization_typ = 3
	AND M0022.del_datetime IS NULL
	--
	SELECT 
		@w_organization_use_typ_4		= ISNULL(M0022.use_typ,0)
	,	@w_organization_group_nm_4		= ISNULL(M0022.organization_group_nm,'')
	FROM M0022
	WHERE 
		M0022.company_cd = @P_company_cd
	AND M0022.organization_typ = 4
	AND M0022.del_datetime IS NULL
	--
	SELECT 
		@w_organization_use_typ_5		= ISNULL(M0022.use_typ,0)
	,	@w_organization_group_nm_5		= ISNULL(M0022.organization_group_nm,'')
	FROM M0022
	WHERE 
		M0022.company_cd = @P_company_cd
	AND M0022.organization_typ = 5
	AND M0022.del_datetime IS NULL
	--
	SELECT 
		@w_target1_use_typ = ISNULL(M2100.target1_use_typ,0)
	,	@w_target2_use_typ = ISNULL(M2100.target2_use_typ,0)
	,	@w_target3_use_typ = ISNULL(M2100.target3_use_typ,0)
	,	@w_comment_use_typ = ISNULL(M2100.comment_use_typ,0)
	FROM M2100
	WHERE 
		M2100.company_cd	=	@P_company_cd
	AND M2100.fiscal_year	=	@P_fiscal_year
	AND M2100.del_datetime IS NULL
	--  UPDATE organization from M0022
	UPDATE #TABLE_RESULT SET 
		item_nm =	CASE 
						WHEN item_cd = 4
						THEN IIF(@w_organization_group_nm_1 <> '', @w_organization_group_nm_1, item_nm)
						WHEN item_cd = 5
						THEN IIF(@w_organization_group_nm_2 <> '', @w_organization_group_nm_2, item_nm)
						WHEN item_cd = 6
						THEN IIF(@w_organization_group_nm_3 <> '', @w_organization_group_nm_3, item_nm)
						WHEN item_cd = 7
						THEN IIF(@w_organization_group_nm_4 <> '', @w_organization_group_nm_4, item_nm)
						WHEN item_cd = 8
						THEN IIF(@w_organization_group_nm_5 <> '', @w_organization_group_nm_5, item_nm)
						ELSE item_nm
					END
	FROM #TABLE_RESULT
	-- UPDATE target from M2100
	UPDATE #TABLE_RESULT SET 
		item_nm =	CASE 
						WHEN ISNULL(#TABLE_RESULT.item_cd,0) = 13
						THEN IIF(ISNULL(M2100.target1_nm,'') <> '',M2100.target1_nm,#TABLE_RESULT.item_nm)
						WHEN ISNULL(#TABLE_RESULT.item_cd,0) = 14
						THEN IIF(ISNULL(M2100.target2_nm,'') <> '',M2100.target2_nm,#TABLE_RESULT.item_nm)
						WHEN ISNULL(#TABLE_RESULT.item_cd,0) = 15
						THEN IIF(ISNULL(M2100.target3_nm,'') <> '',M2100.target3_nm,#TABLE_RESULT.item_nm)
						WHEN ISNULL(#TABLE_RESULT.item_cd,0) = 16
						THEN IIF(ISNULL(M2100.comment_nm,'') <> '',M2100.comment_nm,#TABLE_RESULT.item_nm)
						ELSE #TABLE_RESULT.item_nm
					END
	FROM #TABLE_RESULT
	INNER JOIN M2100 ON (
		@P_company_cd	=	M2100.company_cd
	AND @P_fiscal_year	=	M2100.fiscal_year
	AND M2100.del_datetime IS NULL
	)
	--
	IF @w_organization_use_typ_1 = 0
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D WHERE D.item_cd = 4
	END
	--
	IF @w_organization_use_typ_2 = 0
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D WHERE D.item_cd = 5
	END
	--
	IF @w_organization_use_typ_3 = 0
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D WHERE D.item_cd = 6
	END
	--
	IF @w_organization_use_typ_4 = 0
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D WHERE D.item_cd = 7
	END
	--
	IF @w_organization_use_typ_5 = 0
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D WHERE D.item_cd = 8
	END
	--
	IF @w_target1_use_typ = 0
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D WHERE D.item_cd = 13
	END
	--
	IF @w_target2_use_typ = 0
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D WHERE D.item_cd = 14
	END
	--
	IF @w_target3_use_typ = 0
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D WHERE D.item_cd = 15
	END
	--
	IF @w_comment_use_typ = 0
	BEGIN
		DELETE D FROM #TABLE_RESULT AS D WHERE D.item_cd = 16
	END
	------------------------------------------------------------
	SELECT
		item_cd
	,	item_nm
	,	order_no
	,	display_kbn
	FROM #TABLE_RESULT
	ORDER BY
		order_no
	--[1]
	IF EXISTS (SELECT 1 FROM L0032
					LEFT JOIN S2011 ON (
						L0032.item_cd		=	S2011.item_cd
					AND S2011.company_cd	=	@P_company_cd
					AND S2011.[user_id]		=	@P_user_id
					AND S2011.del_datetime IS NULL
					)
					WHERE 
						L0032.del_datetime IS NULL
					AND S2011.display_kbn	=	0
					AND S2011.item_cd IS NOT NULL
				)
	BEGIN
		SET @check_all	=	0
	END
	--
	IF NOT EXISTS (SELECT 1 FROM S2011 WHERE S2011.company_cd = @P_company_cd AND S2011.[user_id] =	@P_user_id AND S2011.del_datetime IS NULL)
	BEGIN
		SET @check_all	=	1
	END
	--
	SELECT @check_all	AS	check_all
	--DROP TABLE 
	DROP TABLE #TABLE_RESULT
END
GO
