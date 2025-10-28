IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_mI1010_INQ3]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_mI1010_INQ3]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：mi1010 - Refer default browsing_kbn
 *
 *  作成日  ：2021/02/09
 *  作成者  ：ANS-ASIA DUONGNTT
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_mI1010_INQ3]
	@P_company_cd		SMALLINT		=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@w_browsing_kbn					INT					=	0
	
	--
	IF EXISTS (SELECT 1 FROM M3000 WHERE M3000.company_cd	=	@P_company_cd AND	M3000.del_datetime IS NULL )
	BEGIN
		--
		IF EXISTS (
					SELECT 1 
					FROM M3000
					WHERE 
						M3000.company_cd			=	@P_company_cd
					AND M3000.browsing_all_y_kbn	=	1
					AND	M3000.del_datetime IS NULL
		)
		BEGIN
			SET @w_browsing_kbn	=	1
		END
		--
		IF EXISTS (
					SELECT 1 
					FROM M3000
					WHERE 
						M3000.company_cd			=	@P_company_cd
					AND M3000.browsing_all_n_kbn	=	1
					AND	M3000.del_datetime IS NULL
		)
		BEGIN
			SET @w_browsing_kbn	=	2
		END
		--
		IF EXISTS (
					SELECT 1 
					FROM M3000
					WHERE 
						M3000.company_cd			=	@P_company_cd
					AND M3000.browsing_position_kbn	=	1
					AND	M3000.del_datetime IS NULL
		)
		BEGIN
			SET @w_browsing_kbn	=	3
		END
	END

	--[0]
	SELECT @w_browsing_kbn			AS	browsing_kbn
	--[1]
	IF (@w_browsing_kbn = 3)
	BEGIN
		SELECT
			M3001.browsing_position_cd	AS	browsing_position_cd
		FROM M3001
		WHERE 
			M3001.company_cd	=	@P_company_cd
		AND	M3001.del_datetime IS NULL
	END
END

GO
