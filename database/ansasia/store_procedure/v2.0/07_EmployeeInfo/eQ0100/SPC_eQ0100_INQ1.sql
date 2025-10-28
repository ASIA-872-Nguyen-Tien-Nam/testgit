DROP PROCEDURE [SPC_eQ0100_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC SPC_eQ0100_INQ1 '500','782';

-- +--TEST--+
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	CHECK PERMISSION OF M0070 TABS
--*  
--* 作成日/create date			:	2024/04/02										
--*	作成者/creater				:	viettd				
--*   					
--*	更新日/update date			:	
--*	更新者/updater				:　 			     	 
--*	更新内容/update content		:	
--* 				
--****************************************************************************************
CREATE PROCEDURE [SPC_eQ0100_INQ1]
	@P_user_id			nvarchar(50)	=	''	-- LOGIN USER
,	@P_company_cd		smallint		=	0
AS
BEGIN
	SET NOCOUNT ON;
    --
	DECLARE 
		@w_empinfo_authority_typ		smallint		=	0	
	,	@w_empinfo_authority_cd			smallint		=	0	--	login user authority_cd
	,	@w_i							int				=	1
	,	@w_cnt							int				=	0
	,	@w_tab_id						smallint		=	0
	,	@w_number_cd					smallint		=	0
	,	@w_language						INT				=	1
	-- CREATE
	CREATE TABLE #TABLE_RESULT(
		id			int		identity(1,1)
	,	number_cd	smallint
	)

	CREATE TABLE #TABLE_L0010(
		id				int		identity(1,1)
	,	number_cd		smallint
	,	numeric_value1	int
	)
	--
	SELECT 
		@w_empinfo_authority_typ	=	ISNULL(S0010.empinfo_authority_typ,0)
	,	@w_empinfo_authority_cd		=	ISNULL(S0010.empinfo_authority_cd,0)
	,	@w_language					=	ISNULL(S0010.language,1)
	FROM S0010 
	WHERE 
		S0010.company_cd	=	@P_company_cd
	AND	S0010.user_id		=	@P_user_id 
	AND S0010.del_datetime IS NULL

	INSERT INTO #TABLE_L0010
	SELECT 
		L0010.number_cd
	,	L0010.numeric_value1
	FROM L0010 
	WHERE 
		L0010.name_typ = 79
	AND L0010.del_datetime IS NULL

	-- CHECK FROM sm0100
	-- 会社毎の人事情報利用設定を確認：M9100.empinf_user_typ = 1 、M9101.empsrch_use_typ = 1 の会社
	IF NOT EXISTS (SELECT 1 FROM M9100 WHERE company_cd = @P_company_cd AND empinf_use_typ = 1 AND del_datetime IS NULL)
	BEGIN
		INSERT INTO #TABLE_RESULT
		SELECT 
			L0010.number_cd
		FROM L0010 
		WHERE 
			L0010.name_typ = 79
		AND L0010.numeric_value1 = 0
		AND L0010.del_datetime IS NULL
		GOTO COMPLETED
	END
	-- 
	IF NOT EXISTS (SELECT 1 FROM M9101 WHERE company_cd = @P_company_cd AND empsrch_use_typ = 1 AND del_datetime IS NULL)
	BEGIN
		INSERT INTO #TABLE_RESULT
		SELECT 
			L0010.number_cd
		FROM L0010 
		WHERE 
			L0010.name_typ = 79
		AND L0010.numeric_value1 = 0
		AND L0010.del_datetime IS NULL
		GOTO COMPLETED
	END

	-- insert from eM0100 and em0100

	-- COMMON
	INSERT INTO #TABLE_RESULT
	SELECT 
		L0010.number_cd
	FROM L0010 
	WHERE 
		L0010.name_typ = 79
	AND L0010.numeric_value1 = 0
	AND L0010.del_datetime IS NULL

	SET @w_cnt = (SELECT COUNT(1) FROM #TABLE_L0010)
	WHILE @w_i <= @w_cnt
	BEGIN
		SELECT 
			@w_number_cd	= #TABLE_L0010.number_cd
		,	@w_tab_id		= #TABLE_L0010.numeric_value1
		FROM #TABLE_L0010
		WHERE 
			#TABLE_L0010.id = @w_i

		IF EXISTS (SELECT 1 FROM M9102 WHERE company_cd = @P_company_cd AND tab_id = @w_tab_id AND M9102.use_typ = 1 AND del_datetime IS NULL)
		BEGIN
			IF @w_empinfo_authority_typ IN (4,5)
			BEGIN
				INSERT INTO #TABLE_RESULT
				SELECT 
					L0010.number_cd
				FROM L0010 
				WHERE 
					L0010.name_typ = 79
				AND L0010.number_cd	= @w_number_cd
				AND L0010.numeric_value1	= @w_tab_id
				AND L0010.del_datetime IS NULL
			END

			-- @w_empinfo_authority_cd IN (3)
			IF @w_empinfo_authority_typ = 3
			BEGIN
				-- M5100
				INSERT INTO #TABLE_RESULT
				SELECT 
					L0010.number_cd
				FROM L0010 
				INNER JOIN M5100 ON (
					@P_company_cd			= M5100.company_cd
				AND @w_empinfo_authority_cd = M5100.authority_cd
				AND L0010.numeric_value1	= M5100.tab_id
				AND M5100.use_typ			= 1
				AND M5100.del_datetime IS NULL
				)
				WHERE 
					L0010.name_typ = 79
				AND L0010.number_cd	= @w_number_cd
				AND L0010.numeric_value1 <> 0
				AND L0010.del_datetime IS NULL
			END
		END
	SET @w_i = @w_i + 1
	END
	
COMPLETED:
	--[0]
	SELECT 
		#TABLE_RESULT.number_cd															AS	number_cd
	,	ISNULL(IIF(@w_language = 2,L0010.name_english,L0010.name),'')					AS	[name]
	,	L0010.numeric_value2															AS	numeric_value2
	FROM #TABLE_RESULT
	LEFT OUTER JOIN L0010 ON (
		79						=	L0010.name_typ
	AND #TABLE_RESULT.number_cd	=	L0010.number_cd
	)
	-- drop table 
	DROP TABLE #TABLE_RESULT
	DROP TABLE #TABLE_L0010
END
GO
