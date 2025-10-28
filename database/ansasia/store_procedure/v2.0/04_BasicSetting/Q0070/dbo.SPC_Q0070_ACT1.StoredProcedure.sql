DROP PROCEDURE [SPC_Q0070_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_Q0070_ACT1 '{}','','::1','';

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	Q0070_社員情報管理【パスワード一括発行】
--*  
--* 作成日/create date			:	2019/09/11											
--*	作成者/creater				:	longvv						
--*   					
--*  更新日/update date			:	2021/06/03
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
--*　				
--*  更新日/update date			:	2022/08/22
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	Ver 1.9
--****************************************************************************************
CREATE PROCEDURE [SPC_Q0070_ACT1] 
	-- Add the parameters for the stored procedure here
	@P_json			NVARCHAR(MAX)	= ''
,	@P_cre_user		NVARCHAR(50)	= ''
,	@P_cre_ip		NVARCHAR(50)	= ''
,	@P_company_cd	SMALLINT		= 0
,	@P_user_id		NVARCHAR(50)	=   '' -- S0010
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE 
		@w_time								DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL							ERRTABLE	
	,	@order_by_min						INT					=	0
	,	@password_length					TINYINT				=	8
	,	@password_character_limit			TINYINT				=	0
	,	@CharPool1							NVARCHAR(100)		=	''	
	,	@CharPool2							NVARCHAR(100)		=	''	
	,	@CharPool3							NVARCHAR(100)		=	''	
	,	@PoolLength1						INT					=	0	
	,	@PoolLength2						INT					=	0	
	,	@PoolLength3						INT					=	0	
	,	@LoopCount							INT					=	0	
	,	@RandomString						VARCHAR(20)			=	''
	,	@i									INT					=	1
	,	@max_row							INT					=	0	
	,	@P_employee_cd						NVARCHAR(20)		=	''        
	,	@P_employee_nm						NVARCHAR(40)		=	''  
	,	@P_employee_typ             		SMALLINT			=	-1
	,	@P_organization_step1		 		NVARCHAR(40)		=	-1
	,	@P_organization_step2		 		NVARCHAR(40)		=	-1
	,	@P_organization_step3		 		NVARCHAR(40)		=	-1
	,	@P_organization_step4		 		NVARCHAR(40)		=	-1
	,	@P_organization_step5		 		NVARCHAR(40)		=	-1
	,	@P_position_cd              		INT					=	-1
	,	@P_grade                    		SMALLINT			=	-1
	,	@P_fiscal_year              		SMALLINT			=	0
	,	@P_group_cd                 		SMALLINT			=	-1
	,	@P_ck_search						SMALLINT			=	0
	,	@P_company_out_dt_flg				SMALLINT			=	0
	,	@authority_typ						SMALLINT			=	0
	,	@employee_cd						NVARCHAR(20)		=	''
	,	@authority_cd						SMALLINT			=	0
	,	@position_cd						INT					=	0
	,	@arrange_order						INT					=	0
	--,	@countAuthority						SMALLINT			=	0
	,	@YEAR								SMALLINT			=	0
	,	@count_belong_cd2					INT					=	0
	,	@count_belong_cd3					INT					=	0
	,	@count_belong_cd4					INT					=	0
	,	@count_belong_cd5					INT					=	0
	,	@choice_in_screen					INT					=	0
	,	@current_year						INT					=	0
	,	@count_item							INT					=	0
	-- add by viettd 2021/06/03
	,	@w_evaluation_organization_cnt		INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	--
	SET @current_year = YEAR(SYSDATETIME())
	SET	@YEAR =  YEAR(@w_time)	
	--SET
	SELECT 
		@authority_typ	=	ISNULL(authority_typ,0) 
	,	@employee_cd	=	M0070.employee_cd
	,	@authority_cd	=	ISNULL(S0010.authority_cd,0)
	,	@position_cd	=	ISNULL(M0070.position_cd,0)
	FROM S0010 LEFT JOIN M0070 ON (
		M0070.company_cd		=	S0010.company_cd
	AND M0070.employee_cd		=	S0010.employee_cd
	AND M0070.del_datetime		IS NULL 
	) 
	WHERE 
		S0010.user_id		= @P_user_id 
	AND S0010.company_cd	= @P_company_cd 
	AND S0010.del_datetime  IS NULL
	--add vietdt 2022/08/22 
	IF	@authority_typ = 6
	BEGIN
		SET @authority_typ = 2
	END
	SET @authority_typ = ISNULL(@authority_typ,0) 
	SET @arrange_order = ISNULL((SELECT ISNULL(M0040.arrange_order,0) FROM M0040 WHERE M0040.del_datetime IS NULL AND M0040.position_cd		=	@position_cd AND M0040.company_cd = @P_company_cd),0)
	-- COUNT ALL ORGANIZATIONS OF S0022 -- add by viettd 2021/06/03
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@authority_cd,1)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@authority_cd,1)
	--#TEMP_S0022
	CREATE TABLE #TABLE_ORGANIZATION(
		organization_typ			tinyint
	,	organization_cd_1			nvarchar(20)
	,	organization_cd_2			nvarchar(20)
	,	organization_cd_3			nvarchar(20)
	,	organization_cd_4			nvarchar(20)
	,	organization_cd_5			nvarchar(20)	
	,	choice_in_screen				tinyint		-- 1.choice in screen 0.get from master S0022
	)
	
	INSERT INTO #TABLE_ORGANIZATION
	EXEC SPC_REFER_ORGANIZATION_FND1 @P_json,@P_user_id,@P_company_cd
	--
	SELECT 
		@password_length			=	CASE 
											WHEN M9100.password_length IS NULL  OR M9100.password_length = ''
											THEN 8
											ELSE ISNULL(M9100.password_length,0)
										END													
	,	@password_character_limit	=	ISNULL(M9100.password_character_limit,0)			
	FROM M9100
	WHERE 
		M9100.company_cd			=	@P_company_cd
	AND M9100.del_datetime IS NULL 

	SET @password_length			= ISNULL(@password_length,0)
	SET @password_character_limit	= ISNULL(@password_character_limit,0)

	SET @CharPool1		=	'0123456789'				--数字を含める
	SET @PoolLength1	=	LEN(@CharPool1) 
	SET @CharPool2		=	'abcdefghijklmnopqrstuvwxyz'	--英字を含める
	SET @PoolLength2	=	LEN(@CharPool2) 
	SET @CharPool3		=	'!@#$%^&*()_+-={}[]:;<>,.?/'	--記号を含める
	SET @PoolLength3	=	LEN(@CharPool3) 
	--v1.7	
	CREATE TABLE #TEMP_M0072(
		employee_cd		NVARCHAR(20)
	)
	-- processing search in M0072 
	INSERT INTO  #TEMP_M0072
	EXEC SPC_ALTERNATIVE_ITEM_FIND1 @P_json,@P_company_cd,0

		--end v1.7
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY

		-- insert new data
		CREATE TABLE #M0070_SEARCH (
			employee_cd		NVARCHAR(10)
		,	password		NVARCHAR(20) 
		,	belong_cd1		NVARCHAR(40) 
		,	belong_cd2		NVARCHAR(40) 
		,	belong_cd3		NVARCHAR(40) 
		,	belong_cd4		NVARCHAR(40) 
		,	belong_cd5		NVARCHAR(40) 
		)

		-- insert new data
		CREATE TABLE #M0070 (
			ID				INT			IDENTITY(1,1)	
		,	employee_cd		NVARCHAR(10)
		,	password		NVARCHAR(20) 
		,	belong_cd1		NVARCHAR(40) 
		,	belong_cd2		NVARCHAR(40) 
		,	belong_cd3		NVARCHAR(40) 
		,	belong_cd4		NVARCHAR(40) 
		,	belong_cd5		NVARCHAR(40) 
		)
		-- insert new data
		CREATE TABLE #TEMP_M0070 (
			ID				INT			IDENTITY(1,1)	
		,	employee_cd		NVARCHAR(10)
		,	password		NVARCHAR(20) 
		,	authority_typ	SMALLINT
		)
		--
		--
		INSERT INTO #M0070_SEARCH
		SELECT
			JSON_VALUE([value],'$.tb_employee_cd')		AS	employee_cd
		,	''
		,	''
		,	''
		,	''
		,	''
		,	''
		FROM OPENJSON(@P_json,'$.tr_employee')
		UPDATE #M0070_SEARCH 
		SET 
			#M0070_SEARCH.belong_cd1	= M0070.belong_cd1
		,	#M0070_SEARCH.belong_cd2	= M0070.belong_cd2
		,	#M0070_SEARCH.belong_cd3	= M0070.belong_cd3
		,	#M0070_SEARCH.belong_cd4	= M0070.belong_cd4
		,	#M0070_SEARCH.belong_cd5	= M0070.belong_cd5
		FROM #M0070_SEARCH INNER JOIN M0070 ON(
			#M0070_SEARCH.employee_cd = M0070.employee_cd
		AND @P_company_cd			  =	M0070.company_cd
		)
		WHERE M0070.del_datetime IS NULL 
		IF NOT EXISTS (SELECT 1 FROM #M0070_SEARCH)
		BEGIN
			-- assign
			SET	@P_employee_cd							=	JSON_VALUE(@P_json,'$.employee_cd')								
			SET	@P_employee_nm							=	JSON_VALUE(@P_json,'$.employee_name')					
			SET	@P_employee_typ             			=	JSON_VALUE(@P_json,'$.employee_typ')	             
			SET	@P_position_cd              			=	JSON_VALUE(@P_json,'$.position_cd')	              
			SET	@P_grade                    			=	JSON_VALUE(@P_json,'$.grade')	                    
			SET	@P_fiscal_year              			=	JSON_VALUE(@P_json,'$.fiscal_year')	              
			SET	@P_group_cd                 			=	JSON_VALUE(@P_json,'$.group_cd')	                 
			SET	@P_ck_search							=	JSON_VALUE(@P_json,'$.ck_search')											
			SET @P_company_out_dt_flg					=	JSON_VALUE(@P_json,'$.company_out_dt_flg')											
			
		
			-- #TEMP_F0030
			CREATE TABLE #TEMP_F0030 (
				id				INT IDENTITY(1,1) NOT NULL
			,	employee_cd		NVARCHAR(20)	
			)

			--
			INSERT INTO #TEMP_F0030
			SELECT
				F0030.employee_cd 
			FROM F0030
			WHERE
				F0030.company_cd	=	@P_company_cd
			AND ((@P_fiscal_year		= -1  AND @current_year = F0030.fiscal_year) OR F0030.fiscal_year	=	@P_fiscal_year)
			AND (@P_group_cd		= -1 OR F0030.group_cd		=	@P_group_cd) -- dat 2019-12-11
			AND F0030.del_datetime	IS NULL
			AND (
					(F0030.rater_employee_cd_1 =	@employee_cd	AND	@authority_typ	= 2)
				OR	(F0030.rater_employee_cd_2 =	@employee_cd	AND	@authority_typ	= 2)
				OR	(F0030.rater_employee_cd_3 =	@employee_cd	AND	@authority_typ	= 2)
				OR	(F0030.rater_employee_cd_4 =	@employee_cd	AND	@authority_typ	= 2)
				OR @authority_typ  <> 2
			)
			GROUP BY F0030.employee_cd 
			--
			INSERT INTO #M0070_SEARCH 
			SELECT DISTINCT
				M0070.employee_cd			
			,	''
			,	M0070.belong_cd1
			,	M0070.belong_cd2
			,	M0070.belong_cd3
			,	M0070.belong_cd4
			,	M0070.belong_cd5
			FROM M0070 
			INNER JOIN #TEMP_M0072 ON(
				M0070.company_cd	=	@P_company_cd
			AND	M0070.employee_cd	=	#TEMP_M0072.employee_cd
			)
			LEFT JOIN M0060 ON (
				M0060.company_cd			=	M0070.company_cd
			AND M0060.employee_typ			=	M0070.employee_typ
			--AND M0060.del_datetime			IS NULL 
			) 
			LEFT JOIN M0030 ON (
				M0030.company_cd			=	M0070.company_cd
			AND M0030.job_cd				=	M0070.job_cd
			--AND M0030.del_datetime			IS NULL 
			) 
			LEFT JOIN M0040 ON (
				M0040.company_cd			=	M0070.company_cd
			AND M0040.position_cd			=	M0070.position_cd
			--AND M0040.del_datetime			IS NULL 
			) 
			LEFT JOIN M0050 ON (
				M0050.company_cd			=	M0070.company_cd
			AND M0050.grade					=	M0070.grade
			--AND M0050.del_datetime			IS NULL 
			) 
			LEFT JOIN #TEMP_F0030 ON (
				M0070.employee_cd	=	#TEMP_F0030.employee_cd 
			)
			LEFT OUTER JOIN S0020 ON (
				M0070.company_cd	=	S0020.company_cd
			AND	@authority_cd		=	S0020.authority_cd
			)
			WHERE
				M0070.company_cd				=	@P_company_cd
			AND (@P_employee_cd					= ''	OR	M0070.employee_cd	=	@P_employee_cd)
			AND (@P_employee_typ				= -1	OR	M0070.employee_typ	=	@P_employee_typ)
			AND (@P_position_cd					= -1	OR	M0070.position_cd	=	@P_position_cd)
			AND (@P_grade						= -1	OR	M0070.grade			=	@P_grade)
			AND	(@P_employee_nm = ''	OR (
												dbo.FNC_COM_REPLACE_SPACE(M0070.employee_nm)		LIKE '%' + dbo.FNC_COM_REPLACE_SPACE(@P_employee_nm) + '%' 
											OR	dbo.FNC_COM_REPLACE_SPACE(M0070.furigana)			LIKE '%' + dbo.FNC_COM_REPLACE_SPACE(@P_employee_nm) + '%' 
											)
			)
			AND M0070.del_datetime	IS NULL
			AND (	(@P_ck_search = 0 AND ((#TEMP_F0030.employee_cd IS NOT NULL AND @P_fiscal_year <> - 1) 
										OR (@authority_typ = 2 AND #TEMP_F0030.employee_cd IS NOT NULL) 
										OR (@P_fiscal_year = -1 AND @authority_typ <> 2)) 
					 )    
				OR	( @P_ck_search = 1 AND  #TEMP_F0030.employee_cd IS NULL AND @authority_typ <> 2) 
			)
			AND (
				(@P_company_out_dt_flg	=	1)
			OR	(@P_company_out_dt_flg	=	0	AND (M0070.company_out_dt IS  NULL OR M0070.company_out_dt >  @w_time))
			)
			AND(
			@authority_typ <> 3
				OR
					(ISNULL(S0020.use_typ,0)	<> 1 OR ( ISNULL(S0020.use_typ,0)  = 1 AND ISNULL(M0040.arrange_order,0) > @arrange_order ))
			)
		END

		IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION ) 
	BEGIN
		SET @choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)

		-- 1.choice in screen 
		-- 0.get from master S0022
		-- Filter organization_typ = 1
		IF @choice_in_screen = 1
		BEGIN
			DELETE D FROM #M0070_SEARCH AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.belong_cd1			=	S.organization_cd_1
			AND D.belong_cd2			=	S.organization_cd_2
			AND D.belong_cd3			=	S.organization_cd_3
			AND D.belong_cd4			=	S.organization_cd_4
			AND D.belong_cd5			=	S.organization_cd_5
			)
			WHERE 
				D.employee_cd IS NULL
			OR	S.organization_typ IS NULL
		END
		ELSE IF NOT (@authority_typ = 3 AND @w_evaluation_organization_cnt = 0 AND @w_organization_belong_person_typ = 0)	-- edited by viettd 2021/06/03
		BEGIN
			DELETE D FROM #M0070_SEARCH AS D
			FULL OUTER JOIN #TABLE_ORGANIZATION AS S ON (
				D.belong_cd1			=	S.organization_cd_1
			AND D.belong_cd2			=	S.organization_cd_2
			AND D.belong_cd3			=	S.organization_cd_3
			AND D.belong_cd4			=	S.organization_cd_4
			AND D.belong_cd5			=	S.organization_cd_5
			)
			WHERE 
				D.employee_cd IS NULL
			OR	S.organization_typ IS NULL
			AND @authority_typ NOT IN(4,5) --4.会社管理者 5.総合管理者
		END
	END
	INSERT INTO #M0070 
	SELECT
		employee_cd	
	,	password	
	,	belong_cd1	
	,	belong_cd2	
	,	belong_cd3	
	,	belong_cd4	
	,	belong_cd5	
	FROM #M0070_SEARCH
	
		----UPDATE RANDOM PASSWORD
		IF @password_character_limit = 2
		BEGIN
			SET @max_row	= (SELECT COUNT(ID) FROM #M0070)
			WHILE @i <=  @max_row
			BEGIN
				SET @RandomString	=	''
				SET @LoopCount		=	0
				WHILE (@LoopCount < @password_length-2) 
				BEGIN
					SELECT @RandomString = @RandomString + 
					    SUBSTRING(@Charpool1+@CharPool2+@CharPool3,CAST(CEILING(RAND()*(@PoolLength1+@PoolLength2+@PoolLength3)) AS INT), 1)
					SELECT @LoopCount = @LoopCount + 1
				END
				SELECT @RandomString =	@RandomString +	CASE 
															WHEN	@RandomString	LIKE '%[0-9]%'
															THEN	
																CASE 
																	WHEN @RandomString	LIKE '%[A-Za-z]%'
																	THEN 
																		CASE 
																			WHEN @RandomString	LIKE '%[^a-zA-Z0-9]%'
																			THEN SUBSTRING(@Charpool1+@CharPool2+@CharPool3,CAST(CEILING(RAND()*(@PoolLength1+@PoolLength2+@PoolLength3)) AS INT), 1)
																			ELSE SUBSTRING(@Charpool3,CAST(CEILING(RAND()*(@PoolLength3)) AS INT), 1)
																		END
																	ELSE SUBSTRING(@Charpool2,CAST(CEILING(RAND()*(@PoolLength2)) AS INT), 1)
																END
															ELSE	SUBSTRING(@Charpool1,CAST(CEILING(RAND()*(@PoolLength1)) AS INT), 1)
														END
				SELECT @RandomString =	@RandomString +	CASE 
															WHEN	@RandomString	LIKE '%[0-9]%'
															THEN	
																CASE 
																	WHEN @RandomString	LIKE '%[A-Za-z]%'
																	THEN 
																		CASE 
																			WHEN @RandomString	LIKE '%[^a-zA-Z0-9]%'
																			THEN SUBSTRING(@Charpool1+@CharPool2+@CharPool3,CAST(CEILING(RAND()*(@PoolLength1+@PoolLength2+@PoolLength3)) AS INT), 1)
																			ELSE SUBSTRING(@Charpool3,CAST(CEILING(RAND()*(@PoolLength3)) AS INT), 1)
																		END
																	ELSE SUBSTRING(@Charpool2,CAST(CEILING(RAND()*(@PoolLength2)) AS INT), 1)
																END
															ELSE	SUBSTRING(@Charpool1,CAST(CEILING(RAND()*(@PoolLength1)) AS INT), 1)
														END
				UPDATE #M0070 
				SET password = @RandomString
				FROM #M0070
				WHERE #M0070.ID = @i
				SET @i = @i+1
			END
		END
		ELSE
		BEGIN

			SET @max_row	= (SELECT COUNT(ID) FROM #M0070)
			WHILE @i <=  @max_row
			BEGIN
				SET @RandomString	=	''
				SET @LoopCount		=	0
				WHILE (@LoopCount < @password_length-1) 
				BEGIN
					SELECT @RandomString = @RandomString + 
					    SUBSTRING(@Charpool1+@CharPool2,CAST(CEILING(RAND()*(@PoolLength1+@PoolLength2)) AS INT), 1)
					SELECT @LoopCount = @LoopCount + 1
				END
				SELECT @RandomString =	@RandomString +	CASE 
															WHEN	@RandomString	LIKE '%[0-9]%'
															THEN	
																CASE 
																	WHEN @RandomString	LIKE '%[A-Za-z]%'
																	THEN SUBSTRING(@Charpool1+@CharPool2,CAST(CEILING(RAND()*(@PoolLength1+@PoolLength2)) AS INT), 1)
																	ELSE SUBSTRING(@Charpool2,CAST(CEILING(RAND()*(@PoolLength2)) AS INT), 1)
																END
															ELSE	SUBSTRING(@Charpool1,CAST(CEILING(RAND()*(@PoolLength1)) AS INT), 1)
														END
				UPDATE #M0070 
				SET password = @RandomString
				FROM #M0070
				WHERE #M0070.ID = @i
				SET @i = @i+1
			END
		END
		--- validate  when chose employee with no password
		IF NOT EXISTS (SELECT 1 FROM #M0070 INNER JOIN S0010 ON(
																S0010.company_cd	= @P_company_cd 
															AND #M0070.employee_cd	= S0010.employee_cd 
															AND S0010.del_datetime	IS NULL))
		BEGIN
			INSERT INTO @ERR_TBL VALUES(
				21
			,	'#employee_cd'
			,	0-- oderby
			,	2-- dialog  
			,	0
			,	0
			,	'employee_cd not found'
			)
		END
		IF NOT EXISTS (SELECT 1 FROM #M0070)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(
				21
			,	'#employee_cd'
			,	0-- oderby
			,	2-- dialog  
			,	0
			,	0
			,	'employee_cd not found'
			)
		END
			IF NOT EXISTS (
				SELECT 1 FROM #M0070
				LEFT OUTER JOIN F0030	WITH(NOLOCK) ON (
					@P_company_cd		=	F0030.company_cd	
				AND	@YEAR				=	F0030.fiscal_year
				AND	F0030.del_datetime	IS	NULL
				AND	(
					#M0070.employee_cd	=	F0030.rater_employee_cd_1
				OR	#M0070.employee_cd	=	F0030.rater_employee_cd_2
				OR	#M0070.employee_cd	=	F0030.rater_employee_cd_3
				OR	#M0070.employee_cd	=	F0030.rater_employee_cd_4
					)
				)
				LEFT JOIN S0010 ON (
					@P_company_cd		=	S0010.company_cd
				AND	#M0070.employee_cd	=	S0010.employee_cd
				AND	S0010.del_datetime	IS	NULL
				)
				WHERE 
					S0010.company_cd		IS NOT	NULL
				AND	#M0070.employee_cd		<>	''
			)
			BEGIN 
				INSERT INTO @ERR_TBL VALUES(
					21
				,	'#employee_cd'
				,	0-- oderby
				,	2-- dialog  
				,	0
				,	0
				,	'employee_cd not found'
			)
			END
			--INSERT INTO @ERR_TBL 
			--SELECT
			--	55
			--,	'#employee_cd'
			--,	0-- oderby
			--,	4-- dialog  
			--,	#TEMP.ID
			--,	0
			--,	s0010.user_id
			--FROM S0010
			-- INNER JOIN(
			--	SELECT 
			--	#M0070.employee_cd ,
			--	#M0070.ID
			--	FROM #M0070
			--LEFT OUTER JOIN F0030	WITH(NOLOCK) ON (
			--	@P_company_cd		=	F0030.company_cd	
			--AND	@YEAR				=	F0030.fiscal_year
			--AND	F0030.del_datetime	IS	NULL
			--AND	(
			--	#M0070.employee_cd	=	F0030.rater_employee_cd_1
			--OR	#M0070.employee_cd	=	F0030.rater_employee_cd_2
			--OR	#M0070.employee_cd	=	F0030.rater_employee_cd_3
			--OR	#M0070.employee_cd	=	F0030.rater_employee_cd_4
			--	)
			--)
			--LEFT JOIN S0010 ON (
			--	@P_company_cd		=	S0010.company_cd
			--AND	#M0070.employee_cd	=	S0010.employee_cd
			--AND	S0010.del_datetime	IS	NULL
			--)
			--WHERE 
			--	S0010.company_cd		IS	NULL
			--AND	#M0070.employee_cd		<>	''
			--) AS #TEMP ON (
			--	S0010.company_cd	= @P_company_cd
			--AND S0010.user_id		= #TEMP.employee_cd
			--)
			----INNER JOIN #M0070  AS #A ON(
			----	S0010.company_cd		= @P_company_cd
			----AND S0010.employee_cd		= #A.employee_cd
			----)
			--WHERE 
			--	S0010.company_cd	=	@P_company_cd
			--AND S0010.del_datetime	IS NULL
		-- do stuff
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			--UPDATE S0010
			UPDATE S0010 SET 
				S0010.password			=	#M0070.password
			,	pass_change_datetime	=	@w_time
			,	upd_user				=	@P_cre_user			
			,	upd_ip					=	@P_cre_ip	
			,	upd_prg					= 	'Q0070'
			,	upd_datetime			=	@w_time	
			--,	del_user				=	SPACE(0)
			--,	del_ip					=	SPACE(0)
			--,	del_prg					= 	SPACE(0)
			--,	del_datetime			=	NULL	
			FROM S0010
			INNER JOIN #M0070 ON (
				S0010.company_cd	= @P_company_cd
			AND S0010.employee_cd	= #M0070.employee_cd
			)
			WHERE 
				S0010.company_cd	=	@P_company_cd
			AND S0010.del_datetime	IS NULL
			--INSERT INTO S0010
			--INSERT INTO	#TEMP_M0070
			--SELECT DISTINCT
			--	#M0070.employee_cd
			--,	#M0070.password
			--,	CASE
			--		WHEN	F0030.company_cd IS	NOT NULL
			--		THEN	2
			--		ELSE	1
			--	END
			--FROM #M0070
			--LEFT OUTER JOIN F0030	WITH(NOLOCK) ON (
			--	@P_company_cd		=	F0030.company_cd	
			--AND	@YEAR				=	F0030.fiscal_year
			--AND	F0030.del_datetime	IS	NULL
			--AND	(
			--	#M0070.employee_cd	=	F0030.rater_employee_cd_1
			--OR	#M0070.employee_cd	=	F0030.rater_employee_cd_2
			--OR	#M0070.employee_cd	=	F0030.rater_employee_cd_3
			--OR	#M0070.employee_cd	=	F0030.rater_employee_cd_4
			--	)
			--)
			--LEFT JOIN S0010 ON (
			--	@P_company_cd		=	S0010.company_cd
			--AND	#M0070.employee_cd	=	S0010.employee_cd
			--AND	S0010.del_datetime	IS	NULL
			--)
			--WHERE 
			--	S0010.company_cd		IS	NULL
			--AND	#M0070.employee_cd		<>	''
			--DELETE S0010 
			--DELETE S0010 
			--FROM S0010 
			--INNER JOIN #M0070 ON (
			--	S0010.user_id	=	#M0070.employee_cd
			--)
			--WHERE 
			--	S0010.company_cd		=	@P_company_cd
			--AND	S0010.del_datetime		IS	NOT NULL
			----

			--INSERT INTO S0010
			--SELECT 
			--	@P_company_cd									--company_cd					
			--,	#TEMP_M0070.employee_cd							--user_id
			--,	#TEMP_M0070.employee_cd							--employee_cd
			--,	#TEMP_M0070.password							--password
			--,	''												--sso_user
			--,	#TEMP_M0070.authority_typ						--authority_typ
			--,	0												--authority_cd
			--,	''												--remember_token
			--,	0												--failed_login_count
			--,	@w_time											--pass_change_datetime
			--,	''												--last_login_ip
			--,	NULL											--last_login_datetime
			--,	@P_cre_user										--cre_user
			--,	@P_cre_ip										--cre_ip
			--,	'Q0070'											--cre_prg
			--,	@w_time											--cre_datetime
			--,	SPACE(0)										--upd_user
			--,	SPACE(0)										--upd_ip
			--,	SPACE(0)										--upd_prg
			--,	NULL											--upd_datetime
			--,	SPACE(0)										--del_user
			--,	SPACE(0)										--del_ip
			--,	SPACE(0)										--del_prg
			--,	NULL											--del_datetime
			--FROM #TEMP_M0070						
													
			--■DROP TABLE
			DROP TABLE #M0070
			DROP TABLE #TEMP_M0070
		END
	END TRY
	BEGIN CATCH
	IF (@@TRANCOUNT > 0)
		BEGIN
			ROLLBACK TRANSACTION
		END
		DELETE FROM @ERR_TBL
		INSERT INTO @ERR_TBL
		SELECT	
			0
		,	'EXCEPTION'
		,	0
		,	999 -- exception error
		,	0
		,	0
		,	'Error'                                                          + CHAR(13) + CHAR(10) +
            'Procedure : ' + ISNULL(ERROR_PROCEDURE(), '???')                + CHAR(13) + CHAR(10) +
            'Line : '      + ISNULL(CAST(ERROR_LINE() AS NVARCHAR(10)), '0') + CHAR(13) + CHAR(10) +
            'Message : '   + ISNULL(ERROR_MESSAGE(), 'An unexpected error occurred.')
	END CATCH
	--DELETE FROM @ERR_TBL
	IF(@@TRANCOUNT > 0)
	BEGIN
		COMMIT TRANSACTION
	END
    -- Insert statements for procedure here
	COMPLETE_QUERY:
	-- GET ERROR_TYPE MIN
	SELECT 
		@order_by_min = MIN(order_by)
	FROM @ERR_TBL
	--[0] SELECT ERROR TABLE
	SELECT 
		message_no
	,	item
	,	order_by
	,	error_typ
	,	value1
	,	value2
	,	remark
	FROM @ERR_TBL
	WHERE order_by = @order_by_min
	ORDER BY 
		order_by
END

GO