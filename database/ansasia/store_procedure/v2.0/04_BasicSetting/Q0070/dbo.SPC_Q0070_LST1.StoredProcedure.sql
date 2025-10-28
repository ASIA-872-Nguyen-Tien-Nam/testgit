DROP PROCEDURE [SPC_Q0070_LST1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_Q0070_LST1 '{}','','::1','';

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	SAVE LIST EMPLOYEE MAIL INTO F0902
--*  
--* 作成日/create date			:	2019/09/11											
--*	作成者/creater				:	longvv						
--*   					
--*	更新日/update date			:  	2021/06/03					
--*	更新者/updater				:　 viettd　 　								     	 
--*	更新内容/update content		:	when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees　	
--*   					
--*	更新日/update date			:  	2021/07/14					
--*	更新者/updater				:　 viettd　 　								     	 
--*	更新内容/update content		:	insert list employee mails into F0902
--*   					
--*  更新日/update date			:	2022/08/22
--*　更新者/updater				:	vietdt　
--*　更新内容/update content		:	Ver 1.9
--****************************************************************************************
CREATE PROCEDURE [SPC_Q0070_LST1] 
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
	,	@P_employee_cd						NVARCHAR(20)		=	''        
	,	@P_employee_nm						NVARCHAR(40)		=	''  
	,	@P_employee_typ             		SMALLINT			=	-1
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
	,	@choice_in_screen					INT					=	0
	,	@current_year						INT					=	2000
	,	@count_item							INT					=	0
	-- add by viettd 2021/06/03
	,	@w_evaluation_organization_cnt		INT					=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT			=	0
	,	@w_serial_no						INT					=	0	-- add by viettd 2021/07/14
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
	SET @current_year = YEAR(SYSDATETIME())
	SET @authority_typ	= ISNULL(@authority_typ,0) 
	SET @arrange_order	= ISNULL((SELECT ISNULL(M0040.arrange_order,0) FROM M0040 WHERE M0040.del_datetime IS NULL AND M0040.position_cd		=	@position_cd AND M0040.company_cd = @P_company_cd),0)
	-- COUNT ALL ORGANIZATIONS OF S0022 -- add by viettd 2021/06/03
	SET @w_evaluation_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@authority_cd,1)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@authority_cd,1)
	--get all ORGANIZATION with authority
	CREATE TABLE #TABLE_ORGANIZATION(
		organization_typ			tinyint
	,	organization_cd_1			nvarchar(20)
	,	organization_cd_2			nvarchar(20)
	,	organization_cd_3			nvarchar(20)
	,	organization_cd_4			nvarchar(20)
	,	organization_cd_5			nvarchar(20)	
	,	choice_in_screen			tinyint		-- 1.choice in screen 0.get from master S0022
	)
	-- insert new data
	CREATE TABLE #M0070 (
		ID				INT			IDENTITY(1,1)	
	,	employee_cd		NVARCHAR(10)
	,	belong_cd1		NVARCHAR(30)
	,	belong_cd2		NVARCHAR(30)
	,	belong_cd3		NVARCHAR(30)
	,	belong_cd4		NVARCHAR(30)
	,	belong_cd5		NVARCHAR(30)
	)
	-- insert new data
	CREATE TABLE #TEMP_MAIL (
		ID				INT			IDENTITY(1,1)	
	,	employee_cd		NVARCHAR(10)
	,	employee_nm		NVARCHAR(101)
	,	password		NVARCHAR(20)
	,	mail			NVARCHAR(50)
	)
	-- #TEMP_M0072	
	CREATE TABLE #TEMP_M0072(
		employee_cd		NVARCHAR(20)
	)
	-- #TEMP_F0030
	CREATE TABLE #TEMP_F0030 (
		id				INT IDENTITY(1,1) NOT NULL
	,	employee_cd		NVARCHAR(20)	
	)
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		-- insert #TABLE_ORGANIZATION
		INSERT INTO #TABLE_ORGANIZATION
		EXEC SPC_REFER_ORGANIZATION_FND1 @P_json,@P_user_id,@P_company_cd
		-- insert #M0070 from json paramater (when choice in screen)
		INSERT INTO #M0070
		SELECT
			JSON_VALUE([value],'$.tb_employee_cd')		AS	employee_cd
		,	''
		,	''
		,	''
		,	''
		,	''
		FROM OPENJSON(@P_json,'$.tr_employee')
		-- when don't choice in screen then insert #M0070 from master
		IF NOT EXISTS (SELECT 1 FROM #M0070)
		BEGIN
			-- assign
			SET	@P_employee_cd							=	JSON_VALUE(@P_json,'$.employee_cd')								
			SET	@P_employee_nm							=	JSON_VALUE(@P_json,'$.employee_name')					
			SET	@P_employee_typ             			=	JSON_VALUE(@P_json,'$.employee_typ')	             
			--
			SET	@P_position_cd              			=	JSON_VALUE(@P_json,'$.position_cd')	              
			SET	@P_grade                    			=	JSON_VALUE(@P_json,'$.grade')	                    
			SET	@P_fiscal_year              			=	JSON_VALUE(@P_json,'$.fiscal_year')	              
			SET	@P_group_cd                 			=	JSON_VALUE(@P_json,'$.group_cd')	                 
			SET	@P_ck_search							=	JSON_VALUE(@P_json,'$.ck_search')											
			SET @P_company_out_dt_flg					=	JSON_VALUE(@P_json,'$.company_out_dt_flg')											
			-- processing search in M0072 
			INSERT INTO  #TEMP_M0072
			EXEC SPC_ALTERNATIVE_ITEM_FIND1 @P_json,@P_company_cd,0
			-- insert into #TEMP_F0030
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
			-- insert into #M0070
			INSERT INTO #M0070 
			SELECT DISTINCT
				M0070.employee_cd	
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
			AND(
					@authority_typ <> 3
				OR
					(ISNULL(S0020.use_typ,0)	<> 1 OR ( ISNULL(S0020.use_typ,0)  = 1 AND ISNULL(M0040.arrange_order,0) > @arrange_order ))
			)
			AND (
				(@P_company_out_dt_flg	=	1)
			OR	(@P_company_out_dt_flg	=	0	AND (M0070.company_out_dt IS  NULL OR M0070.company_out_dt >  @w_time))
			)
			--DELETE ORGANIZATION NOT IN #ORG_TEMP
			IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION ) 
			BEGIN
				SET @choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
				-- 1.choice in screen 
				-- 0.get from master S0022
				-- Filter organization_typ = 1
				IF @choice_in_screen = 1
				BEGIN
					DELETE D FROM #M0070 AS D
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
					DELETE D FROM #M0070 AS D
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
		END
		-- Has not data into #M0070 then show error
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
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		-- PROCESS DATA
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			-- GET ALL MAIL
			INSERT #TEMP_MAIL
			SELECT 
				M0070.employee_cd		
			,	M0070.employee_nm		
			,	ISNULL(S0010.password,'')			
			,	ISNULL(M0070.mail,'')
			FROM S0010
			INNER JOIN #M0070 AS TEMP ON (
				S0010.company_cd	= @P_company_cd
			AND S0010.employee_cd	= TEMP.employee_cd
			)
			INNER JOIN M0070 ON (
				S0010.company_cd	= M0070.company_cd
			AND S0010.employee_cd	= M0070.employee_cd
			)
			WHERE 
				S0010.company_cd	= @P_company_cd
			AND	S0010.del_datetime	IS NULL
			AND S0010.[password] <> ''
			AND ISNULL(M0070.mail,'') != ''
			-- GET MAX (F0902.serial_no)
			SET @w_serial_no = (SELECT ISNULL(MAX(F0902.serial_no),0) FROM F0902)
			-- INSERT DATA INTO TABLE F0902
			INSERT INTO F0902
			SELECT 
				#TEMP_MAIL.ID + @w_serial_no		AS	serial_no
			,	@P_company_cd
			,	#TEMP_MAIL.employee_cd
			,	#TEMP_MAIL.mail
			,	NULL								AS	send_datetime
			,	@P_cre_user
			,	@P_cre_ip
			,	'Q0070'
			,	getdate()
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL
			FROM #TEMP_MAIL
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