DROP PROCEDURE [SPC_I2040_INQ3]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	I2040
--*  
--*  作成日/create date			:	2020/01/17			
--*　作成者/creater				:	datnt								
--*   					
--*  更新日/update date			:	2022/08/19
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	update ver 1.9	
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_I2040_INQ3]
	@P_company_cd	SMALLINT		=	0
,	@P_user_id		NVARCHAR(50)	=	0
,	@P_fiscal_year	SMALLINT		=	0
,	@P_mode			NVARCHAR(50)	=	0
AS
BEGIN
	DECLARE 
	@order_no		INT				=	0
,	@w_language		SMALLINT		=	1	--add by vietdt	2022/08/19 
,	@w_text			NVARCHAR(20)	=	'年度'	--add by vietdt	2022/08/19 
	-- TABLE NAME OF COLUMN
	CREATE TABLE #NAME_COLUMN(
		item_cd			INT
	,	col_nm			NVARCHAR(50)
	,	item_order		NVARCHAR(50)
	)
	--add by vietdt	2022/08/19 
	SELECT 
		@w_language			=	ISNULL(S0010.language,1)	
	FROM S0010
	WHERE 
		S0010.company_cd	= @P_company_cd 
	AND S0010.user_id		= @P_user_id
	AND S0010.del_datetime IS NULL
	--
	INSERT INTO #NAME_COLUMN
	VALUES
	(1,'employee_cd','employee_cd_order_by'),
	(2,'employee_nm','furigana'),
	(3,'employee_typ_nm','employee_typ'),
	(4,'belong1_nm','belong_cd1'),
	(5,'belong2_nm','belong_cd2'),
	(6,'belong3_nm','belong_cd3'),
	(7,'belong4_nm','belong_cd4'),
	(8,'belong5_nm','belong_cd5'),
	(9,'job_nm','job_cd'),
	(10,'position_nm','position_cd'),
	(11,'grade_nm','grade'),
	(12,'rank_prev_3_nm','rank_prev_3_nm'),
	(13,'rank_prev_2_nm','rank_prev_2_nm'),
	(14,'rank_prev_1_nm','rank_prev_1_nm'),
	(15,'','')
--[0]
	IF(@P_mode = 0) -- for poup
	BEGIN
		IF EXISTS(SELECT 1 FROM S0011 WHERE company_cd = @P_company_cd AND user_id = @P_user_id AND del_datetime IS NULL)
		BEGIN
		set @order_no = (SELECT max(order_no) + 1  from S0011 where company_cd = @P_company_cd AND user_id = @P_user_id AND  del_datetime IS NULL)
			SELECT
				L0031.item_cd
			,		CASE WHEN  L0031.item_cd >= 4 AND L0031.item_cd <= 8 AND M0022.use_typ =1 THEN ISNULL(M0022.organization_group_nm,IIF(@w_language = 2,L0031.item_nm_english,L0031.item_nm))
					 ELSE   IIF(@w_language = 2,L0031.item_nm_english,L0031.item_nm)
				END AS item_nm
			,	ISNULL(S0011.display_kbn,0) AS display_kbn
			,	ISNULL(s0011.order_no,@order_no) AS order_no
			FROM L0031
			LEFT JOIN  S0011  ON(
				S0011.company_cd = @P_company_cd
			AND	S0011.item_cd = L0031.item_cd
			AND s0011.item_cd > 0
			AND S0011.user_id = @P_user_id
			AND S0011.del_datetime IS NULL 
			)LEFT JOIN M0022 ON(
				S0011.company_cd = M0022.company_cd
			AND S0011.item_cd	 = M0022.organization_typ + 3	-- (item_cd = 4) equivalent to (organization_typ = 1)
			AND M0022.del_datetime IS NULL
			)
			WHERE 
			 (
				M0022.use_typ = 1 OR M0022.company_cd IS NULL
			)
			
			AND L0031.del_datetime IS NULL
			ORDER BY ISNULL(S0011.order_no,@order_no)
		END
		ELSE
		BEGIN
			SELECT 
				L0031.item_cd
			,	CASE WHEN  L0031.item_cd >= 4 AND L0031.item_cd <= 8 AND M0022.use_typ =1 THEN ISNULL(M0022.organization_group_nm,IIF(@w_language = 2,L0031.item_nm_english,L0031.item_nm))
					 ELSE   IIF(@w_language = 2,L0031.item_nm_english,L0031.item_nm)
				END AS item_nm
			,	1				AS display_kbn
			,	L0031.item_cd	AS order_no
			FROM L0031
			LEFT JOIN M0022 ON(
				@P_company_cd = M0022.company_cd
			AND L0031.item_cd	 = M0022.organization_typ + 3	-- (item_cd = 4) equivalent to (organization_typ = 1)
			AND M0022.del_datetime IS NULL
			)
			WHERE
			L0031.item_cd < 4 OR L0031.item_cd > 8 OR	M0022.use_typ = 1 OR M0022.company_cd IS NULL
			ORDER BY ISNULL(L0031.order_no,999)
		END
	END
	ELSE
	BEGIN
		--IF EXISTS(SELECT 1 FROM S0011 WHERE company_cd = @P_company_cd AND user_id = @P_user_id)
		--BEGIN
			--[6]#1
			SELECT 
				L0031.item_cd
			,	CASE WHEN  L0031.item_cd >= 4 AND L0031.item_cd <= 8 AND M0022.use_typ =1 THEN ISNULL(M0022.organization_group_nm,IIF(@w_language = 2,L0031.item_nm_english,L0031.item_nm))
					 ELSE   IIF(@w_language = 2,L0031.item_nm_english,L0031.item_nm)
				END AS item_nm
			,	#NAME_COLUMN.col_nm
			,	#NAME_COLUMN.item_order
			FROM  L0031 
			LEFT JOIN S0011 ON(
				S0011.company_cd	= @P_company_cd
			AND S0011.item_cd		= L0031.item_cd
			AND S0011.user_id		= @P_user_id
			AND S0011.del_datetime IS NULL
			)
			LEFT JOIN #NAME_COLUMN ON(
			 L0031.item_cd = #NAME_COLUMN.item_cd
			)
			LEFT JOIN M0022 ON(
				@P_company_cd		= M0022.company_cd
			AND L0031.item_cd		= M0022.organization_typ + 3	-- (item_cd = 4) equivalent to (organization_typ = 1)
			)
			WHERE 
			(S0011.company_cd IS NULL 
			OR
				(	S0011.company_cd IS NOT NULL 
				AND S0011.display_kbn = 1
				AND S0011.user_id = @P_user_id
				)
			)
			AND L0031.item_cd > 0
			AND L0031.item_cd NOT IN (12,13,14)
			AND (
				L0031.item_cd < 4 OR L0031.item_cd > 8 
				OR	M0022.use_typ = 1 OR M0022.company_cd IS NULL
			)
			ORDER BY ISNULL (S0011.order_no,L0031.order_no)
			--
			IF	@w_language = 2
			BEGIN
				SET @w_text = ''
			END

			--[7]#1
			SELECT 
				L0031.item_cd
			,	CASE L0031.item_cd	WHEN 14 THEN		CAST(@P_fiscal_year - 3 AS NVARCHAR(20)) + @w_text 
									WHEN 13 THEN		CAST(@P_fiscal_year - 2 AS NVARCHAR(20)) + @w_text 
									WHEN 12 THEN		CAST(@P_fiscal_year - 1 AS NVARCHAR(20)) + @w_text
									ELSE ''
									END AS item_nm
			,	#NAME_COLUMN.col_nm
			FROM L0031 
			LEFT JOIN S0011 ON(
				S0011.company_cd	= @P_company_cd
			AND S0011.item_cd		= L0031.item_cd
			AND S0011.user_id		= @P_user_id
			AND S0011.del_datetime IS NULL
			)
			LEFT JOIN #NAME_COLUMN ON(
			 L0031.item_cd = #NAME_COLUMN.item_cd
			)
			WHERE 
			(	S0011.company_cd IS NULL 
			OR
				( S0011.company_cd IS NOT NULL 
				AND S0011.display_kbn = 1
				AND s0011.item_cd > 0
				AND S0011.user_id = @P_user_id
				)
			)
			AND L0031.item_cd  IN (12,13,14)
			AND @P_fiscal_year <> 0
			ORDER BY ISNULL(S0011.order_no,L0031.order_no) DESC
		--END
		
	END
END
GO
