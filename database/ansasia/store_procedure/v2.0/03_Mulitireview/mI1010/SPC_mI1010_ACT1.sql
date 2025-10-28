IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_mI1010_ACT1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_mI1010_ACT1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：mI1010 - SAVE/UPDATE
 *
 *  作成日  ：	2020-12-25
 *  作成者  ：	ANS-ASIA DUONGNTT
 *
 *  更新日  ：	2021/06/16
 *  更新者  ：	viettd
 *  更新内容：	set S0010.multireview_authority_typ = 2 for rater_1 
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_mI1010_ACT1] 
	@P_company_cd		SMALLINT		= 0
,	@P_json				NVARCHAR(MAX)	= ''
,	@P_cre_user			NVARCHAR(50)	= ''
,	@P_cre_ip			NVARCHAR(50)	= ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time							DATETIME2	 = SYSDATETIME()
	,	@ERR_TBL						ERRTABLE	
	--
	,	@w_fiscal_year					INT					=	0
	,	@w_year							INT					=	0
	,	@w_employee_cd					NVARCHAR(10)		=	''
	,	@w_msg128						NVARCHAR(100)		=	''
	--
	SET @w_msg128 = (SELECT [message] FROM L0020 WHERE message_cd = 128 AND del_datetime IS NULL)
	-- check json 
	IF ISJSON(@P_json) <= 0
	BEGIN
		INSERT INTO @ERR_TBL VALUES(		
			22								-- mã lỗi (trùng với mã trong bảng message) 					
		,	''								-- id hoặc class của item(#id , .class), lỗi dạng dialog thì để trống  				
		,	0-- oderby						-- giá trị càng bé thì lỗi được hiển thị trước  				
		,	1-- dialog  					-- Kiểu hiển thị lối : 0. tooltip , 1.dialog 				
		,	0								-- Tùy ý : có thể lưu vị trí index của dòng của lỗi 				
		,	0								-- Tùy ý
		,	'json format'					-- Comment nội dung lỗi (chủ yếu là dùng khi đọc code)
		)
	END
	--
	CREATE TABLE #SUPPORTERS(
		id								INT IDENTITY(1,1)
	,	supporter_cd					NVARCHAR(10)
	,	other_browsing_kbn				SMALLINT
	)
	--
	CREATE TABLE #SUPPORTERS_DELETE(
		company_cd						SMALLINT
	,	supporter_cd					NVARCHAR(10)
	,	is_supported					TINYINT			-- 0.NO 1.YES 
	)
	--
	CREATE TABLE #F3020(
		id								INT IDENTITY(1,1)
	,	company_cd						SMALLINT
	,	fiscal_year						SMALLINT
	,	employee_cd						NVARCHAR(10)
	,	supporter_cd					NVARCHAR(10)
	,	other_browsing_kbn				SMALLINT
	--
	,	check_duplicate_supporter		INT		--1:TRUE
	,	flg_mode						INT		--0:INSERT, 1:UPDATE
	,	cre_user						NVARCHAR(50)
	,	cre_ip							NVARCHAR(50)
	,	cre_prg							NVARCHAR(20)
	,	cre_datetime					DATETIME
	)
	--↓↓↓ add by viettd 2021/06/16
	CREATE TABLE #TABLE_F0030_RATER1(
		id								INT IDENTITY(1,1)
	,	employee_cd						NVARCHAR(10)
	,	rater_employee_cd_1				NVARCHAR(10)
	)
	--
	INSERT INTO #SUPPORTERS
	SELECT 
		supporter_cd
	,	other_browsing_kbn
	FROM OPENJSON(@P_json,'$.list_supporters') WITH(
		supporter_cd					NVARCHAR(10)
	,	other_browsing_kbn				SMALLINT
	)
	--
	IF NOT EXISTS (SELECT 1 FROM #SUPPORTERS)
	BEGIN
		INSERT INTO @ERR_TBL VALUES(		
			126								
		,	''										
		,	0-- oderby						
		,	1-- dialog  					
		,	0								
		,	0								
		,	'no row detail is checked'		
		)
	END
	--
	SET @w_fiscal_year		=	JSON_VALUE(@P_json,'$.fiscal_year')	
	SET @w_employee_cd		=	JSON_VALUE(@P_json,'$.employee_cd')			
	--
	INSERT INTO #F3020
	SELECT
		@P_company_cd
	,	@w_fiscal_year
	,	@w_employee_cd
	,	#SUPPORTERS.supporter_cd
	,	#SUPPORTERS.other_browsing_kbn
	,	COUNT(1) OVER (PARTITION BY #SUPPORTERS.supporter_cd)	
	,	0
	,	NULL	
	,	NULL	
	,	NULL	
	,	NULL	
	FROM #SUPPORTERS
	WHERE 
		#SUPPORTERS.supporter_cd <> ''
	--CHECK  employee_cd = supporter_cd
	IF EXISTS (SELECT 1 FROM #SUPPORTERS WHERE #SUPPORTERS.supporter_cd = @w_employee_cd AND #SUPPORTERS.supporter_cd <> '')
	BEGIN
		INSERT INTO @ERR_TBL VALUES(	
			32								
		,	''										
		,	0-- oderby						
		,	1-- dialog   					
		,	0							
		,	0								
		,	'the coincidence of employee_cd and supporter_cd'	
		)	
	END
	--CHECK DUPLICATE DETAIL
	INSERT INTO @ERR_TBL
	SELECT		
		32								
	,	'.supporter_nm'										
	,	0-- oderby						
	,	4 					
	,	#SUPPORTERS.id							
	,	0								
	,	'duplicate detail'		
	FROM #F3020
	INNER JOIN #SUPPORTERS ON (
		#F3020.supporter_cd		=	#SUPPORTERS.supporter_cd
	)
	WHERE check_duplicate_supporter > 1
	--CHECK MASTER
	IF NOT EXISTS(SELECT 1 FROM M0070 WHERE M0070.company_cd = @P_company_cd AND M0070.employee_cd = @w_employee_cd AND M0070.del_datetime IS NULL)
	BEGIN
		INSERT INTO @ERR_TBL VALUES(	
			128								
		,	'#employee_nm'										
		,	0-- oderby						
		,	3-- dialog  					
		,	1							
		,	0								
		,	@w_msg128		
		)
	END
	--CHECK MASTER DETAIL
	INSERT INTO @ERR_TBL
	SELECT		
		128								
	,	'.supporter_nm'										
	,	0-- oderby						
	,	4 					
	,	#SUPPORTERS.id							
	,	0								
	,	'duplicate detail'		
	FROM #F3020
	INNER JOIN #SUPPORTERS ON (
		#F3020.supporter_cd		=	#SUPPORTERS.supporter_cd
	)
	LEFT JOIN M0070 ON (
		#F3020.company_cd		=	M0070.company_cd
	AND #F3020.supporter_cd		=	M0070.employee_cd
	AND M0070.del_datetime IS NULL
	)
	WHERE M0070.employee_cd IS NULL
	--
	BEGIN TRANSACTION
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM @ERR_TBL)
		BEGIN
			--↓↓↓ add by viettd 2021/06/16
			INSERT INTO #TABLE_F0030_RATER1
			SELECT 
				DISTINCT
				@w_employee_cd
			,	F0030.rater_employee_cd_1
			FROM F0030
			WHERE 
				F0030.company_cd		=	@P_company_cd
			AND F0030.fiscal_year		=	@w_fiscal_year
			AND F0030.employee_cd		=	@w_employee_cd
			AND F0030.del_datetime IS NULL
			--↑↑↑ end add by viettd 2021/06/16
			--	supporter deleted
			INSERT INTO #SUPPORTERS_DELETE
			SELECT 
				F3020.company_cd
			,	F3020.supporter_cd
			,	0					-- NO
			FROM F3020
			LEFT JOIN #F3020 ON (
				F3020.company_cd		=	#F3020.company_cd	
			AND F3020.fiscal_year		=	#F3020.fiscal_year	
			AND F3020.employee_cd		=	#F3020.employee_cd	
			AND F3020.supporter_cd		=	#F3020.supporter_cd	
			)
			WHERE 
				F3020.company_cd	=	@P_company_cd
			AND F3020.fiscal_year	=	@w_fiscal_year
			AND F3020.employee_cd	=	@w_employee_cd
			AND	#F3020.supporter_cd	IS NULL
			AND F3020.del_datetime IS NULL
			--	update #F3020
			UPDATE #F3020 SET
				flg_mode			=	1
			,	cre_user			=	F3020.cre_user		
			,	cre_ip				=	F3020.cre_ip			
			,	cre_prg				=	F3020.cre_prg			
			,	cre_datetime		=	F3020.cre_datetime	
			FROM #F3020
			LEFT OUTER JOIN F3020 ON(
				#F3020.company_cd	=	F3020.company_cd
			AND #F3020.fiscal_year	=	F3020.fiscal_year
			AND #F3020.employee_cd	=	F3020.employee_cd
			AND #F3020.supporter_cd	=	F3020.supporter_cd
			AND F3020.del_datetime IS NULL
			)
			WHERE 
				F3020.supporter_cd IS NOT NULL
			--	delete F3020
			DELETE FROM F3020
			WHERE 
				F3020.company_cd	=	@P_company_cd
			AND F3020.fiscal_year	=	@w_fiscal_year
			AND F3020.employee_cd	=	@w_employee_cd
			-- insert F3020
			INSERT INTO F3020
			SELECT
				company_cd			
			,	fiscal_year			
			,	employee_cd			
			,	supporter_cd		
			,	other_browsing_kbn	
			,	IIF(#F3020.flg_mode = 0,@P_cre_user,#F3020.cre_user)
			,	IIF(#F3020.flg_mode = 0,@P_cre_ip,#F3020.cre_ip)
			,	IIF(#F3020.flg_mode = 0,'MI1010 ',#F3020.cre_prg)
			,	IIF(#F3020.flg_mode = 0,@w_time,#F3020.cre_datetime)
			,	IIF(#F3020.flg_mode = 0,SPACE(0),@P_cre_user)
			,	IIF(#F3020.flg_mode = 0,SPACE(0),@P_cre_ip)
			,	IIF(#F3020.flg_mode = 0,SPACE(0),'MI1010 ')
			,	IIF(#F3020.flg_mode = 0,NULL,@w_time)
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL
			FROM #F3020
			-- GET THIS YEAR
			SET @w_year =  (SELECT  dbo.FNC_GET_YEAR(@P_company_cd , GETDATE()))
			-- IF @@w_fiscal_year = @w_year then process (this year)
			IF	(@w_year = @w_fiscal_year)
			BEGIN
				-- check is_supported
				UPDATE #SUPPORTERS_DELETE SET 
					is_supported = 1 -- IS is_supported
				FROM #SUPPORTERS_DELETE
				INNER JOIN (
					SELECT 
						F3020.company_cd		AS	company_cd
					,	F3020.supporter_cd		AS	supporter_cd
					FROM F3020
					WHERE 
						F3020.company_cd		=	@P_company_cd
					AND F3020.fiscal_year		=	@w_year				-- THIS YEAR
					AND F3020.del_datetime IS NULL
					GROUP BY
						F3020.company_cd	
					,	F3020.supporter_cd	
				) AS F3020_COACH ON (
					#SUPPORTERS_DELETE.company_cd	=	F3020_COACH.company_cd
				AND #SUPPORTERS_DELETE.supporter_cd	=	F3020_COACH.supporter_cd
				)
				-- UPDATE S0010 WHEN DELETE SUPPOTER
				UPDATE S0010 SET
					S0010.multireview_authority_typ		=	0
				,	S0010.upd_user						=	@P_cre_user
				,	S0010.upd_ip						=	@P_cre_ip
				,	S0010.upd_prg						=	'MI1010 '
				,	S0010.upd_datetime					=	@w_time
				FROM S0010
				INNER JOIN #SUPPORTERS_DELETE ON (
					S0010.company_cd	=	#SUPPORTERS_DELETE.company_cd
				AND S0010.employee_cd	=	#SUPPORTERS_DELETE.supporter_cd				
				)
				WHERE 
					S0010.company_cd		=	@P_company_cd
				AND	S0010.del_datetime IS NULL
				AND S0010.multireview_authority_typ		<	3
				AND #SUPPORTERS_DELETE.is_supported = 0 -- NOT supported
				-- UPDATE S0010 WHEN SUPPORTER
				UPDATE S0010 SET
					S0010.multireview_authority_typ		=	2
				,	S0010.upd_user						=	@P_cre_user
				,	S0010.upd_ip						=	@P_cre_ip
				,	S0010.upd_prg						=	'MI1010 '
				,	S0010.upd_datetime					=	@w_time
				FROM S0010
				INNER JOIN #F3020 ON (
					S0010.company_cd	=	#F3020.company_cd
				AND S0010.employee_cd	=	#F3020.supporter_cd				
				)
				WHERE 
					S0010.del_datetime IS NULL
				AND S0010.multireview_authority_typ		<	2
				--↓↓↓ add by viettd 2021/06/16
				-- UPDATE S0010 WHEN RATER_1
				UPDATE S0010 SET
					S0010.multireview_authority_typ		=	2
				,	S0010.upd_user						=	@P_cre_user
				,	S0010.upd_ip						=	@P_cre_ip
				,	S0010.upd_prg						=	'MI1010 '
				,	S0010.upd_datetime					=	@w_time
				FROM S0010
				INNER JOIN #TABLE_F0030_RATER1 ON (
					S0010.company_cd	=	@P_company_cd
				AND S0010.employee_cd	=	#TABLE_F0030_RATER1.rater_employee_cd_1				
				)
				WHERE 
					S0010.del_datetime IS NULL
				AND S0010.multireview_authority_typ		<	2
				--↑↑↑ end add by viettd 2021/06/16
			END
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
	--[0]
	SELECT 
		message_no
	,	item
	,	order_by
	,	error_typ
	,	value1
	,	value2
	,	remark
	FROM @ERR_TBL
	ORDER BY 
		order_by
END
GO