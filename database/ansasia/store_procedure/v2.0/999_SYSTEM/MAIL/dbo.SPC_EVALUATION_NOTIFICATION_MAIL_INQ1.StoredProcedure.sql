DROP PROCEDURE [SPC_EVALUATION_NOTIFICATION_MAIL_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC [SPC_MAIL_INQ1]'','';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	EVALUTATION NOTIFICATION MAIL SEND
--*  
--*  作成日/create date			:	2021/11/30				
--*　作成者/creater				:	viettd								
--*   					
--*  更新日/update date			:	2022/08/31
--*　更新者/updater				:　	viettd
--*　更新内容/update content		:	add 彼評価者
--*   					
--*  更新日/update date			:	2022/08/16
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	upgrade 1.9
--*   					
--*  更新日/update date			:	2023/05/25
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	upgrade 2.0 add @P_mail_type = 4
--*   					
--*  更新日/update date			:	2024/07/11
--*　更新者/updater				:	viettd　
--*　更新内容/update content		:	I2040: confirm and feedback of mail batch process
--****************************************************************************************
CREATE PROCEDURE [SPC_EVALUATION_NOTIFICATION_MAIL_INQ1]
	@P_company_cd				smallint		=	0
,	@P_employee_cd				nvarchar(max)	=	''
,	@P_mail_type				tinyint			=	0
,	@P_target_employee_cd		nvarchar(10)	=	''	-- add by viettd 2022/08/31
,	@P_mail_message				nvarchar(500)	=	''	-- add by viettd 2024/07/11
,	@P_cre_user					nvarchar(50)	=	''	-- add by viettd 2024/07/11
,	@P_cre_ip					nvarchar(50)	=	''	-- add by viettd 2024/07/11
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@w_employee_cd				nvarchar(10)	=	''
	,	@w_time						DATETIME2		=	SYSDATETIME()
	,	@order_by_min				INT				=	0
	,	@ERR_TBL					ERRTABLE	
	,	@w_detail_no				SMALLINT		=	0
	,	@w_today					DATE			=	GETDATE()
	--
	CREATE TABLE #TABLE_MAIL(
		id						int		identity(1,1)
	,	employee_cd_rater		nvarchar(10)
	,	employee_cd				nvarchar(10)
	)
	--
	CREATE TABLE #TABLE_F0903 (
		id						INT		IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	information_date		DATE
	,	information_typ			TINYINT
	,	employee_cd				NVARCHAR(10)
	,	detail_no				SMALLINT
	)
	-- START TRANSACTION 
	BEGIN TRANSACTION
	BEGIN TRY
		-- GET #TABLE_MAIL
		IF @P_mail_type = 2
		BEGIN
			IF ISJSON(@P_employee_cd) = 1
			BEGIN
				INSERT INTO #TABLE_MAIL
				SELECT
					ISNULL(json_table.employee_cd_rater,'')
				,	ISNULL(json_table.employee_cd,'')					
				FROM OPENJSON(@P_employee_cd,'$.rater') WITH(
					employee_cd_rater			nvarchar(10)
				,	employee_cd					nvarchar(10)
				)AS json_table
			END
			--
			INSERT INTO #TABLE_F0903
			SELECT 
				@P_company_cd						AS	company_cd
			,	@w_today							AS	information_date
			,	1									AS	information_typ
			,	#TABLE_MAIL.employee_cd_rater		AS	employee_cd
			,	1									AS	detail_no
			FROM #TABLE_MAIL
			GROUP BY
				#TABLE_MAIL.employee_cd_rater
			-- UPDATE F0903.detail_no
			UPDATE #TABLE_F0903 SET 
				detail_no = ISNULL(F0903_MAX.detail_no,0) + #TABLE_F0903.detail_no
			FROM #TABLE_F0903
			INNER JOIN (
				SELECT 
					F0903.company_cd				AS	company_cd
				,	F0903.information_date			AS	information_date
				,	F0903.information_typ			AS	information_typ
				,	F0903.employee_cd				AS	employee_cd
				,	ISNULL(MAX(F0903.detail_no),0)	AS	detail_no
				FROM F0903
				WHERE 
					F0903.company_cd		=	@P_company_cd
				AND F0903.information_date	=	@w_today
				AND F0903.information_typ	=	1
				GROUP BY
					F0903.company_cd		
				,	F0903.information_date	
				,	F0903.information_typ	
				,	F0903.employee_cd			
			) AS F0903_MAX ON (
				#TABLE_F0903.company_cd			=	F0903_MAX.company_cd
			AND #TABLE_F0903.information_date	=	F0903_MAX.information_date
			AND #TABLE_F0903.information_typ	=	F0903_MAX.information_typ
			AND #TABLE_F0903.employee_cd		=	F0903_MAX.employee_cd
			)
			-- ADD
			INSERT INTO F0903
			SELECT
				#TABLE_F0903.company_cd				AS	company_cd
			,	#TABLE_F0903.information_date		AS	information_date
			,	#TABLE_F0903.information_typ		AS	information_typ	-- 1（評価完了通知メール）
			,	#TABLE_F0903.employee_cd			AS	employee_cd		-- 次の評価者の社員番号
			,	ISNULL(#TABLE_F0903.detail_no,0)	AS	detail_no
			,	ISNULL(M0070.mail,'')				AS	send_mailaddress
			,	CASE
					WHEN	ISNULL(S0010.[language],1) = 2
					THEN	'Notice of Personnel Evaluation System'
					ELSE	N'人事評価システムのお知らせ'
				END									AS	information_title
			,	@P_mail_message						AS	information_message
			,	(
				SELECT 
					M0070.employee_cd		AS	"cd"
				,	M0070.employee_nm		AS	"name"
				FROM #TABLE_MAIL
				LEFT OUTER JOIN M0070 ON (
					@P_company_cd				=	M0070.company_cd
				AND #TABLE_MAIL.employee_cd		=	M0070.employee_cd
				)
				WHERE 
					#TABLE_MAIL.employee_cd_rater = #TABLE_F0903.employee_cd
				GROUP BY
					M0070.employee_cd
				,	M0070.employee_nm
				FOR JSON PATH
				)									AS	target_employee_list
			,	NULL								AS	send_datetime
			,	@P_cre_user							AS	cre_user
			,	@P_cre_ip							AS	cre_ip
			,	'I2040_MAIL_POPUP'					AS	cre_prg
			,	@w_time								AS	cre_datetime
			,	SPACE(0)							AS	upd_user
			,	SPACE(0)							AS	upd_ip
			,	SPACE(0)							AS	upd_prg
			,	NULL								AS	upd_datetime
			,	SPACE(0)							AS	del_user
			,	SPACE(0)							AS	del_ip
			,	SPACE(0)							AS	del_prg
			,	NULL								AS	del_datetime
			FROM #TABLE_F0903
			LEFT OUTER JOIN M0070 ON (
				#TABLE_F0903.company_cd			=	M0070.company_cd
			AND	#TABLE_F0903.employee_cd		=	M0070.employee_cd
			AND M0070.del_datetime IS NULL
			)
			LEFT OUTER JOIN S0010 ON (
				#TABLE_F0903.company_cd			=	S0010.company_cd
			AND	#TABLE_F0903.employee_cd		=	S0010.employee_cd
			AND S0010.del_datetime IS NULL
			)
		END
		ELSE IF @P_mail_type = 3
		BEGIN
			IF ISJSON(@P_employee_cd) = 1
			BEGIN
				INSERT INTO #TABLE_MAIL
				SELECT
					SPACE(0)
				,	ISNULL(json_table.employee_cd,'')					
				FROM OPENJSON(@P_employee_cd,'$.rater') WITH(
					employee_cd					nvarchar(10)
				)AS json_table
			END
			--
			INSERT INTO #TABLE_F0903
			SELECT 
				@P_company_cd
			,	@w_today							AS	information_date
			,	2									AS	information_typ
			,	#TABLE_MAIL.employee_cd				AS	employee_cd	
			,	1									AS	detail_no
			FROM #TABLE_MAIL
			GROUP BY
				#TABLE_MAIL.employee_cd
			-- UPDATE F0903.detail_no
			UPDATE #TABLE_F0903 SET 
				detail_no = ISNULL(F0903_MAX.detail_no,0) + #TABLE_F0903.detail_no
			FROM #TABLE_F0903
			INNER JOIN (
				SELECT 
					F0903.company_cd				AS	company_cd
				,	F0903.information_date			AS	information_date
				,	F0903.information_typ			AS	information_typ
				,	F0903.employee_cd				AS	employee_cd
				,	ISNULL(MAX(F0903.detail_no),0)	AS	detail_no
				FROM F0903
				WHERE 
					F0903.company_cd		=	@P_company_cd
				AND F0903.information_date	=	@w_today
				AND F0903.information_typ	=	2
				GROUP BY
					F0903.company_cd		
				,	F0903.information_date	
				,	F0903.information_typ	
				,	F0903.employee_cd			
			) AS F0903_MAX ON (
				#TABLE_F0903.company_cd			=	F0903_MAX.company_cd
			AND #TABLE_F0903.information_date	=	F0903_MAX.information_date
			AND #TABLE_F0903.information_typ	=	F0903_MAX.information_typ
			AND #TABLE_F0903.employee_cd		=	F0903_MAX.employee_cd
			)
			-- INSERT INTO F0903
			INSERT INTO F0903
			SELECT
				#TABLE_F0903.company_cd				AS	company_cd
			,	#TABLE_F0903.information_date		AS	information_date
			,	#TABLE_F0903.information_typ		AS	information_typ	-- 2（フィードバック通知メール）	
			,	#TABLE_F0903.employee_cd			AS	employee_cd-- 被評価者の社員番号
			,	ISNULL(#TABLE_F0903.detail_no,0)	AS	detail_no
			,	ISNULL(M0070.mail,'')				AS	send_mailaddress
			,	CASE
					WHEN	ISNULL(S0010.[language],1) = 2
					THEN	'Notice of Personnel Evaluation System'
					ELSE	N'人事評価システムのお知らせ'
				END									AS	information_title
			,	@P_mail_message						AS	information_message
			,	SPACE(0)							AS	target_employee_list
			,	NULL								AS	send_datetime
			,	@P_cre_user			
			,	@P_cre_ip
			,	'I2040_MAIL_POPUP'
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL
			FROM #TABLE_F0903
			LEFT OUTER JOIN M0070 ON (
				@P_company_cd					=	M0070.company_cd
			AND	#TABLE_F0903.employee_cd		=	M0070.employee_cd
			AND M0070.del_datetime IS NULL
			)
			LEFT OUTER JOIN S0010 ON (
				#TABLE_F0903.company_cd			=	S0010.company_cd
			AND	#TABLE_F0903.employee_cd		=	S0010.employee_cd
			AND S0010.del_datetime IS NULL
			)
		END
		ELSE IF @P_mail_type = 4
		BEGIN
			--employees
			IF ISJSON(@P_employee_cd) = 1
			BEGIN
				SET @w_employee_cd = ISNULL(JSON_VALUE(@P_employee_cd,'$.employee_cd'),'')
				--
				INSERT INTO #TABLE_MAIL
				SELECT
					@P_target_employee_cd
				,	ISNULL(json_table.employee_cd,'')					
				FROM OPENJSON(@P_employee_cd,'$.employees') WITH(
					employee_cd					nvarchar(10)
				)AS json_table
			END
			-- [0]
			SELECT
				#TABLE_MAIL.employee_cd_rater			AS	employee_cd_rater
			,	ISNULL(M0070_RATER.employee_nm,'')		AS	target_employee_nm
			,	ISNULL(M0070_REPOTER.employee_nm,'')	AS	repoter_employee_nm
			--
			,	ISNULL(M0070.mail,'')				AS	mail
			,	ISNULL(M0070.employee_nm,'')		AS	employee_nm
			,	CASE
					WHEN	ISNULL(S0010.[language],1) = 2
					THEN	'Notice Of Personnel Evaluation System'
					ELSE	N'人事評価システムのお知らせ'
				END									AS	[subject]
			,	ISNULL(S0010.[language],1)			AS	[language]
			FROM #TABLE_MAIL
			LEFT OUTER JOIN M0070 ON (
				@P_company_cd				=	M0070.company_cd
			AND	#TABLE_MAIL.employee_cd		=	M0070.employee_cd
			AND M0070.del_datetime IS NULL
			)
			LEFT OUTER JOIN M0070 AS M0070_RATER ON (
				@P_company_cd					=	M0070_RATER.company_cd
			AND	#TABLE_MAIL.employee_cd_rater	=	M0070_RATER.employee_cd
			AND M0070_RATER.del_datetime IS NULL
			)
			LEFT OUTER JOIN M0070 AS M0070_REPOTER ON (
				@P_company_cd					=	M0070_REPOTER.company_cd
			AND	@w_employee_cd					=	M0070_REPOTER.employee_cd
			AND M0070_REPOTER.del_datetime IS NULL
			)
			LEFT JOIN S0010 ON (
				@P_company_cd					= S0010.company_cd
			AND	#TABLE_MAIL.employee_cd			= S0010.employee_cd
			AND S0010.del_datetime IS NULL
			)
		END
		ELSE
		BEGIN
			--[0]
			SELECT 
				ISNULL(M0070.employee_cd,'')			AS	employee_cd
			,	ISNULL(M0070.mail,'')					AS	mail
			,	ISNULL(M0070.employee_nm,'')			AS	employee_nm
			,	CASE
					WHEN	ISNULL(S0010.language,1) = 2
					THEN	'Notice Of Personnel Evaluation System'
					ELSE	N'人事評価システムのお知らせ'
				END										AS	[subject]
			,	ISNULL(S0010.[language],1)		AS	[language]
			,	ISNULL(M0070_TARGET.employee_nm,'')		AS	target_employee_nm		-- add by viettd 2022/08/31
			FROM M0070
			LEFT OUTER JOIN M0070 AS M0070_TARGET ON (
				M0070_TARGET.company_cd		=	@P_company_cd
			AND M0070_TARGET.employee_cd	=	@P_target_employee_cd
			)
			LEFT JOIN S0010 ON (
				@P_company_cd			= S0010.company_cd
			AND	M0070.employee_cd		= S0010.employee_cd
			AND S0010.del_datetime IS NULL
			)
			WHERE 
				M0070.company_cd		=	@P_company_cd
			AND M0070.employee_cd		=	@P_employee_cd
			AND M0070.del_datetime IS NULL
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
	COMPLETE_QUERY:
	--
	IF EXISTS(SELECT 1 FROM @ERR_TBL AS ERR_TBL WHERE ERR_TBL.item = 'EXCEPTION')
	BEGIN
		IF @@TRANCOUNT >0
		BEGIN
			ROLLBACK TRANSACTION
		END
	END
	ELSE
	BEGIN
		COMMIT TRANSACTION
	END
	-- 総合評価：2.確定 3.本人フィードバック
	IF @P_mail_type IN (2,3)
	BEGIN
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
END	
GO