IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_oQ2010_FND1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_oQ2010_FND1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：OQ2010 - SEARCH
 *
 *  作成日  ：2020-12-15
 *  作成者  ：ANS-ASIA DUONGNTT
 *
 *  更新日  ：2021/05/14
 *  更新者  ：VIETDT
 *  更新内容：CR add checkbox 管理者のみ閲覧コメントあり
 *
 *  更新日  ：2021/05/18
 *  更新者  ：viettd
 *  更新内容：login user can view times when not coach at times
 *
 *  更新日  ：2021/06/03
 *  更新者  ：viettd
 *  更新内容：when 3.管理者(authority_typ = 3) and not choice organization in S0022 then view all employees
 *
 *	更新日	：	2022/01/11
 *  更新者	：	vietdt
 *  更新内容	：	cr add condition F2200.fullfillment_type,next_action		
 *EXEC SPC_oQ2010_FND1 '740','721','{"fiscal_year":"2022","group_cd":"1","employee_cd":"","position_cd":"-1","job_cd":"-1","grade":"-1","employee_typ":"-1","coach_cd":"","only_admin_comments":"0","fullfillment_type":"-1","page":1,"cb_page":20,"list_organization_step1":[],"list_organization_step2":[],"list_organization_step3":[],"list_organization_step4":[],"list_organization_step5":[]}';

 *  更新日   :	2022/01/13
 *　更新者   :	vietdt　
 *　更新内容 :	CR add permission of coach when [1on1_beginning_date] = NULL
 *
 ****************************************************************************************************/
CREATE PROCEDURE [dbo].[SPC_oQ2010_FND1]
	-- Add the parameters for the stored procedure here	
	@P_company_cd		SMALLINT		=	0
,	@P_user_id			NVARCHAR(50)	=	''
,	@P_json				NVARCHAR(MAX)	=	''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@ERR_TBL							ERRTABLE
	,	@w_time								DATETIME2		=	SYSDATETIME()
	,	@P_current_page						SMALLINT		= 0
	,	@P_page_size						SMALLINT		= 0
	,	@totalRecord						BIGINT			=	0
	,	@pageNumber							INT				=	0
	,	@count								INT				=	0
	,	@w_fiscal_year						INT				=	0
	,	@w_group_cd							INT				=	0
	,	@w_employee_cd						NVARCHAR(10)	=	''
	,	@w_position_cd						INT				=	0
	,	@w_job_cd							SMALLINT		=	0
	,	@w_grade							SMALLINT		=	0
	,	@w_employee_typ						SMALLINT		=	0
	,	@w_coach_cd							NVARCHAR(10)	=	''
	,	@w_fullfillment_type				SMALLINT		=	0
	,	@w_only_admin_comments				SMALLINT		=	0
	--
	,	@string_column						NVARCHAR(MAX)	=	''
	,	@string_column1						NVARCHAR(MAX)	=	''
	,	@string_sql							NVARCHAR(MAX)	=	''
	,	@string_sql2						NVARCHAR(MAX)	=	''
	,	@times								INT				=	0
	,	@end_while							INT				=	1
	,	@start_while						INT				=	1
	,	@num_group_times					INT				=	1
	,	@start_for							INT				=	1
	,	@times_start						INT				=	1
	,	@times_end							INT				=	1
	--	
	,	@w_chk_display_employee_cd			INT				=	0	
	,	@w_chk_display_employee_nm			INT				=	0	
	,	@w_chk_display_base_style			INT				=	0	
	,	@w_chk_display_belong_cd1			INT				=	0	
	,	@w_chk_display_belong_cd2			INT				=	0	
	,	@w_chk_display_belong_cd3			INT				=	0	
	,	@w_chk_display_belong_cd4			INT				=	0	
	,	@w_chk_display_belong_cd5			INT				=	0		
	,	@w_chk_display_coach_cd				INT				=	0	
	,	@w_1on1_authority_typ				INT				=	0
	,	@w_1on1_authority_cd				INT				=	0
	--
	,	@cnt_display_header					INT				=	0
	,	@cnt_column_detail					INT				=	5	--default = 5
	,	@mark_type							SMALLINT		=	0
	,	@choice_in_screen					INT				=	0
	,	@name_typ							SMALLINT		=	0
	--
	,	@w_authority_oq2010					SMALLINT		=	0		-- edited by vietdt 2021/04/06
	,	@login_employee_cd					NVARCHAR(10)	=	''		-- edited by vietdt 2021/04/06
	-- add by viettd 2021/06/03
	,	@w_1on1_organization_cnt			INT				=	0	-- 0.view all 1.only view organization choiced
	,	@w_organization_belong_person_typ	SMALLINT		=	0
	--add vietdt 2022/01/13
	,	@w_beginning_date					date			=	NULL
	,	@w_language							SMALLINT		=	1
	--
	CREATE TABLE #DATA_HEADER(
		company_cd						SMALLINT				--company_cd
	,	employee_cd						NVARCHAR(10)			--employee_cd
	,	employee_nm						NVARCHAR(101)			--employee_nm
	,	base_style						SMALLINT				--base_style
	,	emp_base_style_nm				NVARCHAR(50)			--emp_base_style_nm
	,	belong_cd1						NVARCHAR(50)			--belong_cd1
	,	belong_cd2						NVARCHAR(50)			--belong_cd2
	,	belong_cd3						NVARCHAR(50)			--belong_cd3
	,	belong_cd4						NVARCHAR(50)			--belong_cd4
	,	belong_cd5						NVARCHAR(50)			--belong_cd5
	,	belong_cd1_nm					NVARCHAR(50)			--belong_nm1
	,	belong_cd2_nm					NVARCHAR(50)			--belong_nm2
	,	belong_cd3_nm					NVARCHAR(50)			--belong_nm3
	,	belong_cd4_nm					NVARCHAR(50)			--belong_nm4
	,	belong_cd5_nm					NVARCHAR(50)			--belong_nm5
	,	job_cd							SMALLINT				--job_cd
	,	job_nm							NVARCHAR(50)			--job_nm
	,	position_cd						INT						--position_cd
	,	position_nm						NVARCHAR(50)			--position_nm
	,	grade							SMALLINT				--grade
	,	grade_nm						NVARCHAR(50)			--grade_nm
	,	employee_typ					SMALLINT				--employee_typ
	,	employee_typ_nm					NVARCHAR(50)			--employee_typ_nm
	--
	,	target1							NVARCHAR(1000)			--target1
	,	target2							NVARCHAR(1000)			--target2
	,	target3							NVARCHAR(1000)			--target3
	,	comment							NVARCHAR(400)			--comment
	)

	--
	CREATE TABLE #M2610(
		company_cd						SMALLINT
	,	[1on1_group_cd]					SMALLINT
	,	frequency						INT
	,	times_total						INT
	,	times_group						INT
	,	title_group						NVARCHAR(40)
	)

	--
	CREATE TABLE #TIME(
		times							INT
	)

	--
	CREATE TABLE #GROUP_TIME(
		id 								INT IDENTITY(1,1)
	,	times_start						INT
	,	times_end						INT
	)

	--
	CREATE TABLE #F2001(
		company_cd						INT										
	,	fiscal_year						INT										
	,	employee_cd						NVARCHAR(10)										
	,	times							NVARCHAR(10)	
	,	fullfillment_type				INT
	,	data_json_detail				NVARCHAR(MAX)
	)

	--
	CREATE TABLE #DISPLAY_KBN(
		item_cd							INT										
	,	item_nm							NVARCHAR(50)										
	,	order_no						INT										
	,	display_kbn						INT	
	,	col_nm							NVARCHAR(100)
	,	organization_chk				INT
	)

	--
	CREATE TABLE #M2121(
		mark_typ					SMALLINT
	,	item_no						SMALLINT
	,	mark_cd						SMALLINT
	,	remark1						NVARCHAR(100)
	)

	--
	CREATE TABLE #TABLE_ORGANIZATION(
		organization_typ			tinyint
	,	organization_cd_1			nvarchar(20)
	,	organization_cd_2			nvarchar(20)
	,	organization_cd_3			nvarchar(20)
	,	organization_cd_4			nvarchar(20)
	,	organization_cd_5			nvarchar(20)	 
	,	choice_in_screen			tinyint		-- 1.choice in screen 0.get from master S0022
	)

	--
	CREATE TABLE #TABLE_MEMBER_OF_COACH_ (
		company_cd					smallint
	,	fiscal_year					smallint
	,	employee_cd					nvarchar(10)
	,	employee_nm					nvarchar(101)
	)

	--
	CREATE TABLE #LIST_ORGANIZATION
	(
		organization_typ			TINYINT
	,	organization_group_nm		NVARCHAR(50)
	,	organization_step			INT		 
	)

	--
	CREATE TABLE #COUNT
	(
		id 							INT IDENTITY(1,1)
	,	employee_cd					NVARCHAR(20) 
	)
	--add by duongntt 2021/01/19
	CREATE TABLE #NAME_COLUMN(
		item_cd						INT
	,	col_nm						NVARCHAR(50)
	)
	--
	INSERT INTO #NAME_COLUMN
	VALUES
		(1,'employee_cd')
	,	(2,'employee_nm')
	,	(3,'emp_base_style_nm')
	,	(4,'belong_cd1_nm')
	,	(5,'belong_cd2_nm')
	,	(6,'belong_cd3_nm')
	,	(7,'belong_cd4_nm')
	,	(8,'belong_cd5_nm')
	,	(9,'position_nm')
	,	(10,'job_nm')
	,	(11,'grade_nm')
	,	(12,'employee_typ_nm')
	,	(13,'target1')
	,	(14,'target2')
	,	(15,'target3')
	,	(16,'comment')

	--
	SET @w_fiscal_year				=	JSON_VALUE(@P_json,'$.fiscal_year')
	SET	@w_group_cd					=	JSON_VALUE(@P_json,'$.group_cd')
	SET	@w_employee_cd				=	JSON_VALUE(@P_json,'$.employee_cd')
	SET	@w_position_cd				=	JSON_VALUE(@P_json,'$.position_cd')
	SET	@w_job_cd					=	JSON_VALUE(@P_json,'$.job_cd')
	SET	@w_grade					=	JSON_VALUE(@P_json,'$.grade')
	SET	@w_employee_typ				=	JSON_VALUE(@P_json,'$.employee_typ')
	SET	@w_coach_cd					=	JSON_VALUE(@P_json,'$.coach_cd')
	SET	@w_fullfillment_type		=	JSON_VALUE(@P_json,'$.fullfillment_type')
	SET	@w_only_admin_comments		=	JSON_VALUE(@P_json,'$.only_admin_comments')
	SET	@P_current_page				=	JSON_VALUE(@P_json,'$.page')
	SET	@P_page_size				=	JSON_VALUE(@P_json,'$.cb_page')

	--
	SET	@w_chk_display_employee_cd	=	(SELECT TOP 1 ISNULL(S2011.display_kbn,1) FROM L0032 LEFT JOIN S2011 ON (L0032.item_cd=S2011.item_cd AND S2011.company_cd=@P_company_cd AND S2011.[user_id]=@P_user_id AND S2011.del_datetime IS NULL) WHERE L0032.item_cd=1 AND L0032.del_datetime IS NULL)
	SET	@w_chk_display_employee_nm	=	(SELECT TOP 1 ISNULL(S2011.display_kbn,1) FROM L0032 LEFT JOIN S2011 ON (L0032.item_cd=S2011.item_cd AND S2011.company_cd=@P_company_cd AND S2011.[user_id]=@P_user_id AND S2011.del_datetime IS NULL) WHERE L0032.item_cd=2 AND L0032.del_datetime IS NULL)
	SET	@w_chk_display_belong_cd1	=	(SELECT TOP 1 ISNULL(S2011.display_kbn,1) FROM L0032 LEFT JOIN S2011 ON (L0032.item_cd=S2011.item_cd AND S2011.company_cd=@P_company_cd AND S2011.[user_id]=@P_user_id AND S2011.del_datetime IS NULL) WHERE L0032.item_cd=4 AND L0032.del_datetime IS NULL)
	SET	@w_chk_display_belong_cd2	=	(SELECT TOP 1 ISNULL(S2011.display_kbn,1) FROM L0032 LEFT JOIN S2011 ON (L0032.item_cd=S2011.item_cd AND S2011.company_cd=@P_company_cd AND S2011.[user_id]=@P_user_id AND S2011.del_datetime IS NULL) WHERE L0032.item_cd=5 AND L0032.del_datetime IS NULL)
	SET	@w_chk_display_belong_cd3	=	(SELECT TOP 1 ISNULL(S2011.display_kbn,1) FROM L0032 LEFT JOIN S2011 ON (L0032.item_cd=S2011.item_cd AND S2011.company_cd=@P_company_cd AND S2011.[user_id]=@P_user_id AND S2011.del_datetime IS NULL) WHERE L0032.item_cd=6 AND L0032.del_datetime IS NULL)
	SET	@w_chk_display_belong_cd4	=	(SELECT TOP 1 ISNULL(S2011.display_kbn,1) FROM L0032 LEFT JOIN S2011 ON (L0032.item_cd=S2011.item_cd AND S2011.company_cd=@P_company_cd AND S2011.[user_id]=@P_user_id AND S2011.del_datetime IS NULL) WHERE L0032.item_cd=7 AND L0032.del_datetime IS NULL)
	SET	@w_chk_display_belong_cd5	=	(SELECT TOP 1 ISNULL(S2011.display_kbn,1) FROM L0032 LEFT JOIN S2011 ON (L0032.item_cd=S2011.item_cd AND S2011.company_cd=@P_company_cd AND S2011.[user_id]=@P_user_id AND S2011.del_datetime IS NULL) WHERE L0032.item_cd=8 AND L0032.del_datetime IS NULL)
	SET	@w_chk_display_coach_cd		=	(SELECT TOP 1 ISNULL(S2011.display_kbn,1) FROM L0032 LEFT JOIN S2011 ON (L0032.item_cd=S2011.item_cd AND S2011.company_cd=@P_company_cd AND S2011.[user_id]=@P_user_id AND S2011.del_datetime IS NULL) WHERE L0032.item_cd=17 AND L0032.del_datetime IS NULL)
	SET	@w_chk_display_base_style	=	(SELECT TOP 1 ISNULL(S2011.display_kbn,1) FROM L0032 LEFT JOIN S2011 ON (L0032.item_cd=S2011.item_cd AND S2011.company_cd=@P_company_cd AND S2011.[user_id]=@P_user_id AND S2011.del_datetime IS NULL) WHERE L0032.item_cd=18 AND L0032.del_datetime IS NULL)
	--add vietdt 2022/01/13 get @w_beginning_date 
	SELECT 
		@w_beginning_date = M9100.[1on1_beginning_date] 
	FROM M9100
	WHERE 
		M9100.company_cd		=	@P_company_cd
	AND M9100.del_datetime IS NULL
	--
	--add namnt 2022/08/29 get @w_language 
	SELECT 
		@w_language = S0010.[language]
	FROM S0010
	WHERE 
		S0010.company_cd		=	@P_company_cd
	AND S0010.[user_id]			=	@P_user_id
	AND S0010.del_datetime IS NULL
	--
	SELECT 
		@w_1on1_authority_typ			=	ISNULL(S0010.[1on1_authority_typ],0) 
	,	@w_1on1_authority_cd			=	ISNULL(S0010.[1on1_authority_cd],0)
	,	@login_employee_cd				=	ISNULL(S0010.employee_cd,'')
	,	@w_authority_oq2010				=	ISNULL(S2021.authority,0)
	FROM S0010 
	LEFT JOIN M0070 ON (
		M0070.company_cd		=	S0010.company_cd
	AND M0070.employee_cd		=	S0010.employee_cd
	AND M0070.del_datetime		IS NULL 
	)
	LEFT JOIN S2021 ON (
		S0010.company_cd			=	S2021.company_cd
	AND	S0010.[1on1_authority_cd]	=	S2021.authority_cd
	AND	'oQ2010'					=	S2021.function_id
	AND	S2021.del_datetime	IS NULL
	)
	WHERE 
		S0010.user_id			= @P_user_id 
	AND S0010.company_cd		= @P_company_cd 
	AND S0010.del_datetime  IS NULL
	-- COUNT ALL ORGANIZATIONS OF S2022 -- add by viettd 2021/06/03
	SET @w_1on1_organization_cnt = [dbo].FNC_GET_NUMBER_OF_ORGANIZATION(@P_company_cd,@w_1on1_authority_cd,2)
	-- GET @w_organization_belong_person_typ add by viettd 2021/06/03
	SET @w_organization_belong_person_typ = [dbo].FNC_GET_ORGANIZATION_BELONG_PERSON_TYP(@P_company_cd,@w_1on1_authority_cd,2)
	--
	INSERT INTO #DISPLAY_KBN
	SELECT
		ISNULL(L0032.item_cd,0)			AS	item_cd
	,	CASE 
			WHEN @w_language = 2 THEN L0032.item_nm_english
			ELSE L0032.item_nm	
		END AS item_nm
	,	IIF(S2011.order_no IS NOT NULL,S2011.order_no,ISNULL(L0032.order_no,0)) 		
										AS	order_no
	,	ISNULL(S2011.display_kbn,1)		AS	display_kbn
	,	#NAME_COLUMN.col_nm				AS	col_nm
	,	0
	FROM L0032
	LEFT JOIN S2011 ON (
		L0032.item_cd		=	S2011.item_cd
	AND S2011.company_cd	=	@P_company_cd
	AND S2011.[user_id]		=	@P_user_id
	AND S2011.del_datetime IS NULL
	)
	LEFT JOIN #NAME_COLUMN ON (
		L0032.item_cd		=	#NAME_COLUMN.item_cd
	)
	WHERE 
		L0032.del_datetime IS NULL
	ORDER BY 
		CASE	
		WHEN S2011.order_no IS NOT NULL THEN S2011.order_no
		ELSE L0032.order_no
		END ASC
	
	--
	UPDATE #DISPLAY_KBN
	SET 
		#DISPLAY_KBN.item_nm	=	CASE	
										WHEN #DISPLAY_KBN.item_cd	=	13 AND M2100.target1_nm IS NOT NULL THEN M2100.target1_nm
										WHEN #DISPLAY_KBN.item_cd	=	14 AND M2100.target2_nm IS NOT NULL THEN M2100.target2_nm
										WHEN #DISPLAY_KBN.item_cd	=	15 AND M2100.target3_nm IS NOT NULL THEN M2100.target3_nm
										WHEN #DISPLAY_KBN.item_cd	=	16 AND M2100.comment_nm IS NOT NULL THEN M2100.comment_nm
										ELSE #DISPLAY_KBN.item_nm
									END
	FROM #DISPLAY_KBN
	LEFT JOIN M2100 ON (
		M2100.company_cd		=	@P_company_cd
	AND M2100.fiscal_year		=	@w_fiscal_year
	AND M2100.del_datetime IS NULL
	)
	WHERE 
		#DISPLAY_KBN.item_cd	>=	13
	AND #DISPLAY_KBN.item_cd	<=	16

	-- SET NUMBER COLUMN DISPLAY OR DISABLE
	SET @cnt_display_header = (SELECT COUNT(item_cd) FROM #DISPLAY_KBN where #DISPLAY_KBN.display_kbn = 1 AND #DISPLAY_KBN.item_cd <= 16)
	--
	IF(@w_chk_display_coach_cd = 0)
	BEGIN
		SET @cnt_column_detail	=	@cnt_column_detail - 1
	END
	--
	IF(@w_chk_display_base_style = 0 OR @w_1on1_authority_typ <> 4)
	BEGIN
		SET @cnt_column_detail	=	@cnt_column_detail - 1
	END
	
	--
	SET @mark_type = (SELECT M2120.mark_type FROM M2120 WHERE M2120.company_cd = @P_company_cd AND M2120.del_datetime IS NULL)
	SET @name_typ  = ( CASE 
							WHEN @mark_type = 1 THEN 22
							WHEN @mark_type = 2 THEN 23
							WHEN @mark_type = 3 THEN 25
							WHEN @mark_type = 4 THEN 26
							WHEN @mark_type = 5 THEN 24
							ELSE 0
						END)
	--
	INSERT INTO #M2121
	SELECT
		M2121.mark_typ
	,	M2121.item_no	
	,	M2121.mark_cd
	,	ISNULL(L0010.remark1,'')
	FROM M2121
	LEFT JOIN L0010  ON(
		M2121.mark_cd		=	L0010.number_cd	
	AND L0010.name_typ		=	@name_typ
	AND L0010.del_datetime IS NULL	
	)
	WHERE
		M2121.company_cd	=	@P_company_cd
	AND M2121.mark_typ		=	@mark_type
	AND M2121.del_datetime IS NULL

	--
	INSERT INTO #M2610 
	SELECT 
		 M2610.company_cd
	,	 M2610.[1on1_group_cd]
	,	 M2610.frequency
	,	CASE 
			WHEN M2610.frequency = 1 THEN 6
			WHEN M2610.frequency = 2 THEN 12
			WHEN M2610.frequency = 3 THEN 24
			WHEN M2610.frequency = 4 THEN M2610.[1on1_times]
			ELSE 0
		END 
	,	M2620.times
	,	CASE
			WHEN	ISNULL(M2620.[1on1_title],'') = '' AND @w_language = 2
			THEN	'Times '+CONVERT(NVARCHAR(5),M2620.times)
			WHEN	ISNULL(M2620.[1on1_title],'') = '' AND @w_language = 1
			THEN	CONVERT(NVARCHAR(5),M2620.times)+'回目'
			ELSE	M2620.[1on1_title]
		END
	FROM M2610 
	INNER JOIN M2620 ON (
		M2610.company_cd		=	M2620.company_cd
	AND M2610.[1on1_group_cd]	=	M2620.[1on1_group_cd]
	AND M2620.fiscal_year		=	@w_fiscal_year
	AND M2620.del_datetime IS NULL
	)
	WHERE 
		M2610.company_cd		=	@P_company_cd
	AND M2610.[1on1_group_cd]	=	@w_group_cd
	AND M2610.del_datetime IS NULL

	SET @times	=	ISNULL((SELECT TOP 1 times_total FROM  #M2610),0)
	--
	IF(@times > 0)
	BEGIN
		SET @num_group_times = (IIF(@times % 3 = 0,(@times/3),(@times/3) + 1 ))
		SET @start_for = 0
		WHILE @start_for < @num_group_times
		BEGIN
			SET @times_start   = (@start_for*3) + 1
			SET @times_end     = @times_start  + 2
			IF((@start_for+1)  = @num_group_times)
			BEGIN
				SET @times_end = @times
			END
			--
			INSERT INTO #GROUP_TIME
			SELECT
				@times_start
			,	@times_end
			SET @start_for = @start_for + 1
		END
	END
	--
	INSERT INTO #DATA_HEADER
	SELECT
		M0070.company_cd			
	,	M0070.employee_cd			
	,	ISNULL(M0070.employee_nm,'')			
	,	ISNULL('',0)	
	,	ISNULL('','')	
	,	ISNULL(M0070.belong_cd1,'')			
	,	ISNULL(M0070.belong_cd2,'')			
	,	ISNULL(M0070.belong_cd3,'')			
	,	ISNULL(M0070.belong_cd4,'')			
	,	ISNULL(M0070.belong_cd5,'')			
	,CASE
		WHEN ISNULL(M0020_1.organization_ab_nm,'') = '' THEN ISNULL(M0020_1.organization_nm,'')	
		ELSE M0020_1.organization_ab_nm
	END
	,CASE
		WHEN ISNULL(M0020_2.organization_ab_nm,'') = '' THEN ISNULL(M0020_2.organization_nm,'')		
		ELSE M0020_2.organization_ab_nm
	END
	,CASE
		WHEN ISNULL(M0020_3.organization_ab_nm,'') = '' THEN ISNULL(M0020_3.organization_nm,'')		
		ELSE M0020_3.organization_ab_nm
	END
	,CASE
		WHEN ISNULL(M0020_4.organization_ab_nm,'') = '' THEN ISNULL(M0020_4.organization_nm,'')		
		ELSE M0020_4.organization_ab_nm
	END
	,CASE
		WHEN ISNULL(M0020_5.organization_ab_nm,'') = '' THEN ISNULL(M0020_5.organization_nm,'')		
		ELSE M0020_5.organization_ab_nm
	END		
	,	ISNULL(M0070.job_cd,0)				
	,CASE
		WHEN ISNULL(m0030.job_ab_nm,'') = '' THEN ISNULL(m0030.job_nm,'')		
		ELSE m0030.job_ab_nm
	END			
	,	ISNULL(M0070.position_cd,0)				
	,CASE
		WHEN ISNULL(M0040.position_ab_nm,'') = '' THEN ISNULL(M0040.position_nm,'')		
		ELSE M0040.position_ab_nm
	END
	,	ISNULL(M0070.grade	 ,0)				
	,	ISNULL(M0050.grade_nm,'')				
	,	ISNULL(M0070.employee_typ	,0)			
	,	ISNULL(M0060.employee_typ_nm,'')	
	--
	,	ISNULL(F2100.target1,'')		
	,	ISNULL(F2100.target2,'')		
	,	ISNULL(F2100.target3,'')		
	,	ISNULL(F2100.comment,'')		
	FROM M0070
	INNER JOIN F2000 ON (
		M0070.company_cd				=	F2000.company_cd
	AND M0070.employee_cd				=	F2000.employee_cd
	AND F2000.fiscal_year				=	@w_fiscal_year
	AND F2000.[1on1_group_cd]			=	@w_group_cd
	AND F2000.del_datetime IS NULL
	)
	LEFT OUTER JOIN F2100 ON (
		M0070.company_cd				=	F2100.company_cd
	AND M0070.employee_cd				=	F2100.employee_cd
	AND F2000.fiscal_year				=	F2100.fiscal_year
	AND F2100.del_datetime IS NULL
	)
	LEFT OUTER JOIN M0020 AS M0020_1 ON (
		M0070.company_cd				=	M0020_1.company_cd
	AND M0070.belong_cd1				=	M0020_1.organization_cd_1
	AND SPACE(0)						=	M0020_1.organization_cd_2
	AND SPACE(0)						=	M0020_1.organization_cd_3
	AND SPACE(0)						=	M0020_1.organization_cd_4
	AND SPACE(0)						=	M0020_1.organization_cd_5
	AND	1								=	M0020_1.organization_typ
	)
	LEFT OUTER JOIN M0020 AS M0020_2 ON (
		M0070.company_cd				=	M0020_2.company_cd
	AND M0070.belong_cd1				=	M0020_2.organization_cd_1
	AND M0070.belong_cd2				=	M0020_2.organization_cd_2
	AND SPACE(0)						=	M0020_1.organization_cd_3
	AND SPACE(0)						=	M0020_1.organization_cd_4
	AND SPACE(0)						=	M0020_1.organization_cd_5
	AND	2								=	M0020_2.organization_typ
	)
	LEFT OUTER JOIN M0020 AS M0020_3 ON (
		M0070.company_cd				=	M0020_3.company_cd
	AND M0070.belong_cd1				=	M0020_3.organization_cd_1
	AND M0070.belong_cd2				=	M0020_3.organization_cd_2
	AND M0070.belong_cd3				=	M0020_3.organization_cd_3
	AND SPACE(0)						=	M0020_1.organization_cd_4
	AND SPACE(0)						=	M0020_1.organization_cd_5
	AND	3								=	M0020_3.organization_typ
	)
	LEFT OUTER JOIN M0020 AS M0020_4 ON (
		M0070.company_cd				=	M0020_4.company_cd
	AND M0070.belong_cd1				=	M0020_4.organization_cd_1
	AND M0070.belong_cd2				=	M0020_4.organization_cd_2
	AND M0070.belong_cd3				=	M0020_4.organization_cd_3
	AND M0070.belong_cd4				=	M0020_4.organization_cd_4
	AND SPACE(0)						=	M0020_1.organization_cd_5
	AND	4								=	M0020_4.organization_typ
	)
	LEFT OUTER JOIN M0020 AS M0020_5 ON (
		M0070.company_cd				=	M0020_5.company_cd
	AND M0070.belong_cd1				=	M0020_5.organization_cd_1
	AND M0070.belong_cd2				=	M0020_5.organization_cd_2
	AND M0070.belong_cd3				=	M0020_5.organization_cd_3
	AND M0070.belong_cd4				=	M0020_5.organization_cd_4
	AND M0070.belong_cd5				=	M0020_5.organization_cd_5
	AND	5								=	M0020_5.organization_typ
	)
	LEFT OUTER JOIN M0030 ON (
		M0070.company_cd				=	M0030.company_cd
	AND M0070.job_cd					=	M0030.job_cd
	)
	LEFT OUTER JOIN M0040 ON (
		M0070.company_cd				=	M0040.company_cd
	AND M0070.position_cd				=	M0040.position_cd
	)
	LEFT OUTER JOIN M0050 ON (
		M0070.company_cd				=	M0050.company_cd
	AND M0070.grade						=	M0050.grade
	)
	LEFT OUTER JOIN M0060 ON (
		M0070.company_cd				=	M0060.company_cd
	AND M0070.employee_typ				=	M0060.employee_typ
	)
	WHERE 
		M0070.company_cd				=	@P_company_cd
	AND (
		@w_employee_cd					=	''
	OR	M0070.employee_cd				=	@w_employee_cd
	)
	AND (
		@w_position_cd					=	-1
	OR	M0070.position_cd				=	@w_position_cd
	)
	AND (
		@w_job_cd						=	-1
	OR	M0070.job_cd					=	@w_job_cd
	)
	AND (
		@w_grade						=	-1
	OR	M0070.grade						=	@w_grade
	)
	AND (
		@w_employee_typ					=	-1
	OR	M0070.employee_typ				=	@w_employee_typ
	)
	AND M0070.del_datetime IS NULL
	--add vietdt 2022/01/13
	AND (
		(@w_1on1_authority_typ = 2 AND @w_beginning_date IS NOT NULL)
	OR	@w_1on1_authority_typ <> 2
	)
	-- GET ORGANIZATION
	INSERT INTO #TABLE_ORGANIZATION
	EXEC SPC_REFER_ORGANIZATION_FND1 @P_json,@P_user_id,@P_company_cd,2

	-- GET MEMBER_OF_COACH
	INSERT INTO #TABLE_MEMBER_OF_COACH_
	EXEC SPC_REFER_MEMBER_1ON1_FND1 @w_fiscal_year,@P_user_id,@P_company_cd
	--DELETE MEMBER_OF_COACH
	--IF EXISTS (SELECT 1 FROM #TABLE_MEMBER_OF_COACH_ ) --edit vietdt issue 2022/01/17  
	--BEGIN
		DELETE D
		FROM #DATA_HEADER AS D
		LEFT OUTER JOIN #TABLE_MEMBER_OF_COACH_ AS S ON (
			D.company_cd		=	S.company_cd
		AND D.employee_cd		=	S.employee_cd
		)
		WHERE 
			S.employee_cd IS NULL
	--END

	--DELETE ORGANIZATION NOT IN #ORG_TEMP
	IF EXISTS (SELECT 1 FROM #TABLE_ORGANIZATION ) AND (@w_1on1_authority_typ IN(3,4,5)) --edit vietdt 2022/01/19 check with @w_1on1_authority_typ IN(3,4,5)
	BEGIN
		SET @choice_in_screen = (SELECT TOP 1 choice_in_screen FROM #TABLE_ORGANIZATION WHERE choice_in_screen = 1)
		-- 1.choice in screen 
		-- 0.get from master S0022
		-- Filter organization_typ = 1
		IF @choice_in_screen = 1
		BEGIN
			DELETE D FROM #DATA_HEADER AS D
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
		ELSE IF NOT (@w_1on1_authority_typ = 3 AND @w_1on1_organization_cnt = 0 AND @w_organization_belong_person_typ = 0) -- edited by viettd 2021/06/03
		BEGIN
			DELETE D FROM #DATA_HEADER AS D
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
			AND @w_1on1_authority_typ NOT IN (4,5) --4.会社管理者 5.総合管理者
		END
	END
	--
	INSERT INTO #LIST_ORGANIZATION
	SELECT 
		ISNULL(M0022.organization_typ,0)			AS	organization_typ
	,	ISNULL(M0022.organization_group_nm,'')		AS	organization_group_nm
	,	ROW_NUMBER() OVER(ORDER BY M0022.organization_typ)			
													AS	organization_step
	FROM M0022
	WHERE 
		M0022.company_cd	=	@P_company_cd
	AND M0022.use_typ		=	1 -- 0.OFF | 1.ON 
	AND M0022.del_datetime IS NULL
	--
	IF (EXISTS (SELECT 1 FROM #LIST_ORGANIZATION WHERE organization_typ = 1) AND (@w_chk_display_belong_cd1 = 0))
	BEGIN
		DELETE FROM #LIST_ORGANIZATION
		WHERE organization_typ = 1
		--
		DELETE FROM #DISPLAY_KBN
		WHERE item_cd = 4
	END
	IF (NOT EXISTS (SELECT 1 FROM #LIST_ORGANIZATION WHERE organization_typ = 1) AND (@w_chk_display_belong_cd1 = 1))
	BEGIN
		SET @w_chk_display_belong_cd1	=	0
		SET @cnt_display_header			=	@cnt_display_header - 1
		--
		DELETE FROM #DISPLAY_KBN
		WHERE item_cd = 4
	END
	--
	IF (EXISTS (SELECT 1 FROM #LIST_ORGANIZATION WHERE organization_typ = 2) AND (@w_chk_display_belong_cd2 = 0))
	BEGIN
		DELETE FROM #LIST_ORGANIZATION
		WHERE organization_typ = 2
		--
		DELETE FROM #DISPLAY_KBN
		WHERE item_cd = 5
	END
	IF (NOT EXISTS (SELECT 1 FROM #LIST_ORGANIZATION WHERE organization_typ = 2) AND (@w_chk_display_belong_cd2 = 1))
	BEGIN
		SET @w_chk_display_belong_cd2	=	0
		SET @cnt_display_header			=	@cnt_display_header - 1
		--
		DELETE FROM #DISPLAY_KBN
		WHERE item_cd = 5
	END
	--
	IF (EXISTS (SELECT 1 FROM #LIST_ORGANIZATION WHERE organization_typ = 3) AND (@w_chk_display_belong_cd3 = 0))
	BEGIN
		DELETE FROM #LIST_ORGANIZATION
		WHERE organization_typ = 3
		--
		DELETE FROM #DISPLAY_KBN
		WHERE item_cd = 6
	END
	IF (NOT EXISTS (SELECT 1 FROM #LIST_ORGANIZATION WHERE organization_typ = 3) AND (@w_chk_display_belong_cd3 = 1))
	BEGIN
		SET @w_chk_display_belong_cd3	=	0
		SET @cnt_display_header			=	@cnt_display_header - 1
		--
		DELETE FROM #DISPLAY_KBN
		WHERE item_cd = 6
	END
	--
	IF (EXISTS (SELECT 1 FROM #LIST_ORGANIZATION WHERE organization_typ = 4) AND (@w_chk_display_belong_cd4 = 0))
	BEGIN
		DELETE FROM #LIST_ORGANIZATION
		WHERE organization_typ = 4
		--
		DELETE FROM #DISPLAY_KBN
		WHERE item_cd = 7
	END
	IF (NOT EXISTS (SELECT 1 FROM #LIST_ORGANIZATION WHERE organization_typ = 4) AND (@w_chk_display_belong_cd4 = 1))
	BEGIN
		SET @w_chk_display_belong_cd4	=	0
		SET @cnt_display_header			=	@cnt_display_header - 1
		--
		DELETE FROM #DISPLAY_KBN
		WHERE item_cd = 7
	END
	--
	IF (EXISTS (SELECT 1 FROM #LIST_ORGANIZATION WHERE organization_typ = 5) AND (@w_chk_display_belong_cd5 = 0))
	BEGIN
		DELETE FROM #LIST_ORGANIZATION
		WHERE organization_typ = 5
		--
		DELETE FROM #DISPLAY_KBN
		WHERE item_cd = 8
	END
	IF (NOT EXISTS (SELECT 1 FROM #LIST_ORGANIZATION WHERE organization_typ = 5) AND (@w_chk_display_belong_cd5 = 1))
	BEGIN
		SET @w_chk_display_belong_cd5	=	0
		SET @cnt_display_header			=	@cnt_display_header - 1
		--
		DELETE FROM #DISPLAY_KBN
		WHERE item_cd = 8
	END

	--delete item have display_kbn = 0
	DELETE FROM #DISPLAY_KBN
	WHERE display_kbn = 0

	--
	IF (EXISTS (SELECT 1 FROM M2100 
						WHERE 
							M2100.company_cd		=	@P_company_cd
						AND M2100.target1_use_typ	=	0
						AND M2100.fiscal_year		=	@w_fiscal_year
						AND M2100.del_datetime IS NULL
						) AND EXISTS (SELECT 1 FROM #DISPLAY_KBN WHERE item_cd = 13))
	BEGIN
		--
		SET @cnt_display_header			=	@cnt_display_header - 1
		--
		DELETE FROM #DISPLAY_KBN
		WHERE item_cd = 13
	END

	--
	IF (EXISTS (SELECT 1 FROM M2100 
						WHERE 
							M2100.company_cd		=	@P_company_cd
						AND M2100.target2_use_typ	=	0
						AND M2100.fiscal_year		=	@w_fiscal_year
						AND M2100.del_datetime IS NULL
						) AND EXISTS (SELECT 1 FROM #DISPLAY_KBN WHERE item_cd = 14))
	BEGIN
		--
		SET @cnt_display_header			=	@cnt_display_header - 1
		--
		DELETE FROM #DISPLAY_KBN
		WHERE item_cd = 14
	END

	--
	IF (EXISTS (SELECT 1 FROM M2100 
						WHERE 
							M2100.company_cd		=	@P_company_cd
						AND M2100.target3_use_typ	=	0
						AND M2100.fiscal_year		=	@w_fiscal_year
						AND M2100.del_datetime IS NULL
						) AND EXISTS (SELECT 1 FROM #DISPLAY_KBN WHERE item_cd = 15))
	BEGIN
		--
		SET @cnt_display_header			=	@cnt_display_header - 1
		--
		DELETE FROM #DISPLAY_KBN
		WHERE item_cd = 15
	END

	--
	IF (EXISTS (SELECT 1 FROM M2100 
						WHERE 
							M2100.company_cd		=	@P_company_cd
						AND M2100.comment_use_typ	=	0
						AND M2100.fiscal_year		=	@w_fiscal_year
						AND M2100.del_datetime IS NULL
						) AND EXISTS (SELECT 1 FROM #DISPLAY_KBN WHERE item_cd = 16))
	BEGIN
		--
		SET @cnt_display_header			=	@cnt_display_header - 1
		--
		DELETE FROM #DISPLAY_KBN
		WHERE item_cd = 16
	END

	--
	IF EXISTS (SELECT 1 FROM #LIST_ORGANIZATION)
	BEGIN
		UPDATE #DISPLAY_KBN
		SET
			item_nm				=	 #LIST_ORGANIZATION.organization_group_nm
		,	organization_chk	=	1
		FROM #DISPLAY_KBN
		INNER JOIN #LIST_ORGANIZATION ON (
			#LIST_ORGANIZATION.organization_step	=	1
		)
		WHERE #DISPLAY_KBN.item_cd					=	4
		--
		UPDATE #DISPLAY_KBN
		SET
			item_nm				=	 #LIST_ORGANIZATION.organization_group_nm
		,	organization_chk	=	1
		FROM #DISPLAY_KBN
		INNER JOIN #LIST_ORGANIZATION ON (
			#LIST_ORGANIZATION.organization_step	=	2
		)
		WHERE #DISPLAY_KBN.item_cd					=	5
		--
		UPDATE #DISPLAY_KBN
		SET
			item_nm				=	 #LIST_ORGANIZATION.organization_group_nm
		,	organization_chk	=	1
		FROM #DISPLAY_KBN
		INNER JOIN #LIST_ORGANIZATION ON (
			#LIST_ORGANIZATION.organization_step	=	3
		)
		WHERE #DISPLAY_KBN.item_cd					=	6
		--
		UPDATE #DISPLAY_KBN
		SET
			item_nm				=	 #LIST_ORGANIZATION.organization_group_nm
		,	organization_chk	=	1
		FROM #DISPLAY_KBN
		INNER JOIN #LIST_ORGANIZATION ON (
			#LIST_ORGANIZATION.organization_step	=	4
		)
		WHERE #DISPLAY_KBN.item_cd					=	7
		--
		UPDATE #DISPLAY_KBN
		SET
			item_nm				=	 #LIST_ORGANIZATION.organization_group_nm
		,	organization_chk	=	1
		FROM #DISPLAY_KBN
		INNER JOIN #LIST_ORGANIZATION ON (
			#LIST_ORGANIZATION.organization_step	=	5
		)
		WHERE #DISPLAY_KBN.item_cd					=	8
	END

	---
	IF(@times > 0)
	BEGIN
	SET @end_while = @start_while + @times
	WHILE @start_while < @end_while
	BEGIN
		INSERT INTO #TIME
		SELECT
		@start_while
		--
		IF @start_while <200
		BEGIN
			SET @string_column = @string_column + ',[A'+ CAST((@start_while) AS NVARCHAR(10))+']'
		END
		IF @start_while>=200
		BEGIN
			SET @string_column1 = @string_column1 + ',[A'+ CAST((@start_while) AS NVARCHAR(10))+']'
		END
		SET @start_while = @start_while + 1
	END
	SET @string_column = Stuff(@string_column, 1, 1, '')
	SET @string_column1 = Stuff(@string_column1, 1, 1, '')
	END
	-- edited by viettd 2021/05/18
	-- add item check_f2200_coach_inserted
	INSERT INTO #F2001 
	SELECT 
		#DATA_HEADER.company_cd			
	,	F2001.fiscal_year			
	,	#DATA_HEADER.employee_cd			
	,	'A'+CAST(#TIME.times AS nvarchar(5))
	,	ISNULL(F2200.fullfillment_type,0)
	,	'{"coach_cd":"'+ISNULL(F2001.coach_cd,'')+'"
		,"coach_nm":"'+ISNULL(M0070.employee_nm,'')+'"
		,"base_style":"'+ISNULL(CONVERT(VARCHAR(10),''),'')+'"
		,"base_style_nm":"'+ISNULL(CONVERT(NVARCHAR(30),''),'')+'"
		,"fullfillment_type":"'+ISNULL(CONVERT(VARCHAR(10),F2200.fullfillment_type),'')+'"
		,"remark1":"'+ISNULL(#M2121.remark1,'')+'"
		,"next_action":"'+
		--add vietdt  2022/01/11
			CASE
				WHEN F2200.fin_datetime_member	IS NOT NULL
				THEN ISNULL(REPLACE(REPLACE(F2200.next_action, CHAR(13),'<br />'), CHAR(10),'<br />'),'')
				ELSE ''
			END
		+'","interview_date":"'+
			CASE 
				WHEN F2010.[1on1_schedule_date] IS NOT NULL AND F2200.interview_date IS NULL
				THEN CONVERT(VARCHAR(10),FORMAT(F2010.[1on1_schedule_date],'yyyy/MM/dd'))
				WHEN F2010.[1on1_schedule_date] IS NOT NULL AND F2200.interview_date IS NOT NULL
				THEN CONVERT(VARCHAR(10),FORMAT(F2200.interview_date,'yyyy/MM/dd'))
				WHEN F2010.[1on1_schedule_date] IS NULL AND F2200.interview_date IS NOT NULL
				THEN CONVERT(VARCHAR(10),FORMAT(F2200.interview_date,'yyyy/MM/dd'))
				ELSE ''
			END
		+'"
		,"times":"'+CONVERT(VARCHAR(10),F2001.times)+'"
		,"check_ex_f2010":"'+CONVERT(VARCHAR(10),IIF(F2010.[1on1_schedule_date] IS NULL,0,1))+'"
		,"check_ex_f2200":"'+CONVERT(VARCHAR(10),IIF(F2200.submit_datetime_member IS NULL,0,1))+'"
		,"check_f2200_coach_inserted":"'+CONVERT(VARCHAR(10),IIF(F2200.fin_datetime_coach IS NULL,0,1))+'"
		,"is_coach":"'+CASE
					WHEN @w_1on1_authority_typ IN (4,5)
					THEN '1'
					WHEN @w_1on1_authority_typ = 3 AND @w_authority_oq2010 = 2 
					THEN '1'
					WHEN @w_1on1_authority_typ = 3 AND @w_authority_oq2010 IN (0,1) AND (F2001.employee_cd	=	@login_employee_cd OR	F2001.coach_cd	=	@login_employee_cd)
					THEN '1' 
					WHEN @w_1on1_authority_typ NOT IN (3,4,5) AND (F2001.employee_cd	=	@login_employee_cd OR	F2001.coach_cd	=	@login_employee_cd)
					THEN '1'
					ELSE '0'
				END+
		'"}'
	FROM #DATA_HEADER 
	CROSS JOIN #TIME
	LEFT JOIN F2000 ON (
		#DATA_HEADER.company_cd		=	F2000.company_cd
	AND #DATA_HEADER.employee_cd	=	F2000.employee_cd
	AND F2000.fiscal_year			=	@w_fiscal_year
	AND F2000.[1on1_group_cd]		=	@w_group_cd
	AND F2000.del_datetime IS NULL
	)
	LEFT JOIN F2001 ON(
		F2000.company_cd			=	F2001.company_cd
	AND F2000.fiscal_year			=	F2001.fiscal_year
	AND F2000.employee_cd			=	F2001.employee_cd
	AND #TIME.times					=	F2001.times
	AND F2001.del_datetime IS NULL
	)
	LEFT JOIN F2010 ON(
		F2001.company_cd			=	F2010.company_cd
	AND F2001.fiscal_year			=	F2010.fiscal_year
	AND F2001.employee_cd			=	F2010.employee_cd
	AND F2001.times					=	F2010.times
	AND F2010.del_datetime IS NULL
	)
	LEFT JOIN F2200 ON(
		F2001.company_cd			=	F2200.company_cd
	AND F2001.fiscal_year			=	F2200.fiscal_year
	AND F2001.employee_cd			=	F2200.employee_cd
	AND F2001.times					=	F2200.times
	AND F2001.interview_cd			=	F2200.interview_cd
	AND F2001.adaption_date			=	F2200.adaption_date
	AND F2200.del_datetime IS NULL
	)
	LEFT JOIN M0070 ON (
		F2001.company_cd			=	M0070.company_cd
	AND F2001.coach_cd				=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	LEFT JOIN #M2121 ON(
		F2200.fullfillment_type		=	#M2121.mark_cd
	--add vietdt  2022/01/11
	AND	F2200.submit_datetime_member IS NOT NULL
	)
	WHERE 
		(
			@w_fullfillment_type		=	-1
		OR	F2200.fullfillment_type		=	@w_fullfillment_type
		)
	 --edited by vietdt 2021/05/14
	AND
		(
			@w_only_admin_comments		=	0
		OR	F2200.coach_comment2		<>	''
		)
	--edited by vietdt 2021/05/14
	AND
	 (
			@w_coach_cd					=	''
		OR	F2001.coach_cd				=	@w_coach_cd
	)
	--
	INSERT INTO #COUNT
	SELECT
		#F2001.employee_cd
	FROM #F2001
	GROUP BY 
		#F2001.employee_cd

	--[0]
	IF @string_column <> ''
	BEGIN
	SET @string_sql = 
	'
	SELECT 
		company_cd	
	,	'+CONVERT(VARCHAR(10),@w_fiscal_year)+'		AS 		fiscal_year
	,	employee_cd			
	,	employee_nm	
	,	base_style	
	,	emp_base_style_nm	
	,	belong_cd1			
	,	belong_cd2			
	,	belong_cd3			
	,	belong_cd4			
	,	belong_cd5			
	,	belong_cd1_nm		
	,	belong_cd2_nm		
	,	belong_cd3_nm		
	,	belong_cd4_nm		
	,	belong_cd5_nm		
	,	job_cd				
	,	job_nm				
	,	position_cd			
	,	position_nm			
	,	grade				
	,	grade_nm			
	,	employee_typ		
	,	employee_typ_nm	
	,	target1				
	,	target2				
	,	target3				
	,	comment		
	,	'+@string_column+'
	FROM
	(
	SELECT 
		#F2001.company_cd				
	,	#F2001.employee_cd			
	,	#DATA_HEADER.employee_nm	
	,	#DATA_HEADER.base_style	
	,	#DATA_HEADER.emp_base_style_nm
	,	#DATA_HEADER.belong_cd1			
	,	#DATA_HEADER.belong_cd2			
	,	#DATA_HEADER.belong_cd3			
	,	#DATA_HEADER.belong_cd4			
	,	#DATA_HEADER.belong_cd5			
	,	#DATA_HEADER.belong_cd1_nm		
	,	#DATA_HEADER.belong_cd2_nm		
	,	#DATA_HEADER.belong_cd3_nm		
	,	#DATA_HEADER.belong_cd4_nm		
	,	#DATA_HEADER.belong_cd5_nm		
	,	#DATA_HEADER.job_cd				
	,	#DATA_HEADER.job_nm				
	,	#DATA_HEADER.position_cd			
	,	#DATA_HEADER.position_nm			
	,	#DATA_HEADER.grade				
	,	#DATA_HEADER.grade_nm			
	,	#DATA_HEADER.employee_typ		
	,	#DATA_HEADER.employee_typ_nm	
	,	#DATA_HEADER.target1				
	,	#DATA_HEADER.target2				
	,	#DATA_HEADER.target3				
	,	#DATA_HEADER.comment
	,	#F2001.times
	,	#F2001.data_json_detail
	FROM #F2001 
	INNER JOIN #DATA_HEADER ON(
		#F2001.employee_cd	=	#DATA_HEADER.employee_cd
	)
	) AS P
	Pivot(MAX(data_json_detail) FOR times IN ('+@string_column+')) AS A
	ORDER BY	
		CASE ISNUMERIC(employee_cd) 
		   WHEN 1 
		   THEN CAST(employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	employee_cd
	OFFSET '+CAST(((@P_current_page-1) * @P_page_size)AS NVARCHAR(20))+' ROWS
	FETCH NEXT '+CAST(@P_page_size AS NVARCHAR)+' ROWS ONLY
	'
	print @string_sql
	EXECUTE (@string_sql)
	END 
	ELSE
	BEGIN
		SELECT
		employee_cd	
	,	@w_fiscal_year		AS 		fiscal_year
	,	employee_nm			
	,	base_style	
	,	emp_base_style_nm		
	,	belong_cd1			
	,	belong_cd2			
	,	belong_cd3			
	,	belong_cd4			
	,	belong_cd5			
	,	belong_cd1_nm		
	,	belong_cd2_nm		
	,	belong_cd3_nm		
	,	belong_cd4_nm		
	,	belong_cd5_nm		
	,	job_cd				
	,	job_nm				
	,	position_cd			
	,	position_nm			
	,	grade				
	,	grade_nm			
	,	employee_typ		
	,	employee_typ_nm		
	--
	,	target1				
	,	target2				
	,	target3				
	,	comment		
	FROM #DATA_HEADER
	END
	--[1]
	SELECT 
		@times							AS	times_group
	,	(@times*@cnt_column_detail)		AS	colspan_group
	,	@cnt_display_header				AS	colspan_header
	,	@cnt_column_detail				AS	num_cl_detail
	,	((@times*@cnt_column_detail) + @cnt_display_header)
										AS	colspan_nodata

	--[2]
	SELECT
		id								AS	id
	,	times_start						AS	times_start	
	,	times_end						AS	times_end	
	FROM #GROUP_TIME
	--[3]
	SELECT
		@w_chk_display_employee_cd		AS	display_employee_cd		
	,	@w_chk_display_employee_nm		AS	display_employee_nm	
	,	@w_chk_display_coach_cd			AS	display_coach_cd	
	,	@w_chk_display_base_style		AS	display_base_style		
	,	@w_1on1_authority_typ					AS	authority_typ

	--[4]
	SET @totalRecord = (SELECT COUNT(1) FROM #COUNT)
	SET @pageNumber = CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
	SELECT @totalRecord AS totalRecord
	,	 @pageNumber AS pageMax
	,	 @P_current_page AS [page]
	,	 @P_page_size AS pagesize
	,	((@P_current_page - 1) * @P_page_size + 1) AS offset

	--[5]
	SELECT 
		times_group						AS	times_group	
	,	title_group						AS 	title_group
	,	@cnt_column_detail				AS	num_cl_detail
	FROM #M2610

	--[6]
	IF NOT EXISTS(SELECT 1 FROM #LIST_ORGANIZATION)
	BEGIN
		SELECT	0				AS	chk_list_organization	
	END
	ELSE
	BEGIN
	SELECT
		1						AS	chk_list_organization
	,	organization_typ		AS	organization_typ			
	,	organization_group_nm	AS	organization_group_nm	
	,	organization_step		AS	organization_step		
	FROM #LIST_ORGANIZATION
	END
	--[7]
	SELECT
		item_cd			
	,	item_nm			
	,	order_no		
	,	display_kbn		
	,	col_nm		
	,	organization_chk	
	FROM #DISPLAY_KBN
	WHERE item_cd <= 16
	ORDER BY
		order_no

	--[]
	IF @string_column <> ''
	BEGIN
	SET @string_sql2 = 
	'
	SELECT 
		employee_cd					
	,	'+@string_column1+'
	FROM
	(
	SELECT 
		#F2001.employee_cd			
	,	#F2001.times
	,	#F2001.data_json_detail
	FROM #F2001 
	INNER JOIN #DATA_HEADER ON(
		#F2001.employee_cd	=	#DATA_HEADER.employee_cd
	)
	) AS P
	Pivot(MAX(data_json_detail) FOR times IN ('+@string_column1+')) AS A
	ORDER BY	
		CASE ISNUMERIC(employee_cd) 
		   WHEN 1 
		   THEN CAST(employee_cd AS BIGINT) 
		   ELSE 999999999999999 
		END 
    ,	employee_cd
	OFFSET '+CAST(((@P_current_page-1) * @P_page_size)AS NVARCHAR(20))+' ROWS
	FETCH NEXT '+CAST(@P_page_size AS NVARCHAR)+' ROWS ONLY
	'
	EXECUTE (@string_sql2)
	END 

	--DROP TABLE
	DROP TABLE #DATA_HEADER
	DROP TABLE #F2001
	DROP TABLE #M2610
	DROP TABLE #TIME
	DROP TABLE #GROUP_TIME
	DROP TABLE #DISPLAY_KBN
	DROP TABLE #M2121
	DROP TABLE #TABLE_ORGANIZATION
	DROP TABLE #LIST_ORGANIZATION
	DROP TABLE #COUNT
	DROP TABLE #NAME_COLUMN
END
GO