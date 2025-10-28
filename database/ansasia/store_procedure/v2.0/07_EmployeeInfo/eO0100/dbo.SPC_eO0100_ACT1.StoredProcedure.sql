DROP PROCEDURE [SPC_eO0100_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	
--*  
--*  作成日/create date			:	2024/04/11
--*　作成者/creater				:	manhnd						
--*  作成内容/create content		:	import eo0100					
--*	 更新日/update date			:  	
--*	 更新者/updater				:　 
--*	 更新内容/update content	:	
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_eO0100_ACT1]
	-- Add the parameters for the stored procedure here
	@P_json									NVARCHAR(MAX)		=	N''
,	@P_exec_user							NVARCHAR(100)		=	N''
,	@P_company_cd							SMALLINT			=	0	
,	@P_cre_user								NVARCHAR(50)		=	N''
,	@P_cre_ip								NVARCHAR(50)		=	N''
,	@P_no									INT					=	0
,	@P_count								INT					=	0
,	@P_language								NVARCHAR(2)			=	N''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 	
		@w_time								DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL							ERRTABLE	
	,	@w_order_by_min						INT					=	0
	,	@w_max_qualification_cd				INT					=	0
	--
	CREATE TABLE #TBL_M5010 (
		id									INT					IDENTITY(1,1)
	,	exec_user							NVARCHAR(100)
	,	company_cd							SMALLINT
	,	qualification_cd					NVARCHAR(50)
	,	qualification_nm					NVARCHAR(100)
	,	qualification_ab_nm					NVARCHAR(100)
	,	qualification_typ					NVARCHAR(20)
	,	arrange_order						NVARCHAR(20)
	)
	-- GET DATA
	INSERT INTO #TBL_M5010
	SELECT
		@P_exec_user + '_' + CAST(@P_no AS NVARCHAR(10))
	,	@P_company_cd
	,	IIF(JSON_VALUE(@P_json,'$.qualification_cd') = N'', '0', JSON_VALUE(@P_json,'$.qualification_cd'))
	,	JSON_VALUE(@P_json,'$.qualification_nm')		
	,	JSON_VALUE(@P_json,'$.qualification_ab_nm')			
	,	JSON_VALUE(@P_json,'$.qualification_typ')			
	,	JSON_VALUE(@P_json,'$.arrange_order')		
	FROM OPENJSON(@P_json) WITH (
		qualification_cd					NVARCHAR(50)
	,	qualification_nm					NVARCHAR(100)
	,	qualification_ab_nm					NVARCHAR(100)
	,	qualification_typ					NVARCHAR(20)
	,	arrange_order						NVARCHAR(20)
	)
	
	SET @w_max_qualification_cd = (SELECT ISNULL(MAX(M5010.qualification_cd),0)+@P_no FROM M5010 WHERE M5010.company_cd = @P_company_cd)
	
	--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
	--VALIDATE
	--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
	IF ISJSON(@P_json) <= 0
	BEGIN
		INSERT INTO @ERR_TBL VALUES (		
			22						-- mã lỗi (trùng với mã trong bảng message) 					
		,	N''						-- id hoặc class của item(#id , .class), lỗi dạng dialog thì để trống  				
		,	0-- oderby				-- giá trị càng bé thì lỗi được hiển thị trước  				
		,	1-- dialog  			-- Kiểu hiển thị lối : 0. tooltip , 1.dialog 				
		,	0						-- Tùy ý : có thể lưu vị trí index của dòng của lỗi 				
		,	0						-- Tùy ý
		,	N'json format'			-- Comment nội dung lỗi (chủ yếu là dùng khi đọc code)
		)
	END

	--VALIDATE MAXLENGTH
	--VALIDATE MAXLENGTH qualification_nm 
	INSERT INTO @ERR_TBL
	SELECT
		28				
	,	N'qualification_nm'				
	,	0				
	,	1				
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Qualification name','資格名')	
	FROM #TBL_M5010 
	WHERE
		LEN(qualification_nm) > 50
	--VALIDATE REQUIRED qualification_nm
	INSERT INTO @ERR_TBL
	SELECT
		8				
	,	N'qualification_nm'				
	,	0				
	,	1				
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Qualification name','資格名')	
	FROM #TBL_M5010
	WHERE	
		qualification_nm = ''

	--VALIDATE MAXLENGTH qualification_ab_nm 
	INSERT INTO @ERR_TBL
	SELECT
		28				
	,	N'qualification_ab_nm'				
	,	0				
	,	1				
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Qualification abbreviation','資格略称')
	FROM #TBL_M5010 
	WHERE
		LEN(qualification_ab_nm) > 20

	--VALIDATE NUMBER
	--VALIDATE NUMBER qualification_cd
	IF EXISTS (	SELECT 1 
				FROM #TBL_M5010 
				WHERE
					#TBL_M5010.qualification_cd LIKE '%[^0-9]%'
	)
	BEGIN
		INSERT INTO @ERR_TBL
		SELECT
			11				
		,	N'qualification_cd'				
		,	0
		,	1
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Qualification code','資格コード')
		
		INSERT INTO @ERR_TBL
		SELECT
			160		
		,	N'qualification_cd'				
		,	0
		,	1
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Qualification code','資格コード')
	END	


	--INSERT INTO @ERR_TBL
	--SELECT
	--	11				
	--,	N'qualification_cd'				
	--,	0
	--,	1
	--,	0				
	--,	0				
	--,	IIF(@P_language = 'en','Qualification code','資格コード')
	--FROM #TBL_M5010 
	--WHERE
	--	#TBL_M5010.qualification_cd LIKE '%[^0-9]%'

	--VALIDATE MAXLENGTH NUMBER qualification_cd
	INSERT INTO @ERR_TBL
	SELECT
		28				
	,	N'qualification_cd'				
	,	0				
	,	1				
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Qualification code','資格コード')	
	FROM #TBL_M5010 
	WHERE
		LEN(qualification_cd) > 4
	
	--VALIDATE NUMBER qualification_typ
	INSERT INTO @ERR_TBL
	SELECT
		11				
	,	N'qualification_typ'				
	,	0
	,	1
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Qualification type','資格種別')
	FROM #TBL_M5010 
	WHERE
		#TBL_M5010.qualification_typ LIKE '%[^0-9]%'
	--VALIDATE MAXLENGTH NUMBER qualification_typ
	INSERT INTO @ERR_TBL
	SELECT
		28				
	,	N'qualification_typ'				
	,	0				
	,	1				
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Qualification type','資格種別')	
	FROM #TBL_M5010 
	WHERE
		LEN(qualification_typ) > 4
	
	--VALIDATE qualification_typ not in L0010
	IF NOT EXISTS (	SELECT 1
					FROM #TBL_M5010
					INNER JOIN L0010 ON (
						#TBL_M5010.qualification_typ = L0010.number_cd
					AND L0010.name_typ	=	57
					)
					WHERE
						#TBL_M5010.qualification_typ NOT LIKE '%[^0-9]%'
	)
	BEGIN
		INSERT INTO @ERR_TBL
		SELECT
			70				
		,	N'qualification_typ'				
		,	0				
		,	1				
		,	0				
		,	0				
		,	IIF(@P_language = 'en','Qualification type','資格種別')	
	END

	--VALIDATE NUMBER arrange_order
	INSERT INTO @ERR_TBL
	SELECT
		11				
	,	N'arrange_order'				
	,	0
	,	1
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Sort order','並び順')
	FROM #TBL_M5010 
	WHERE
		#TBL_M5010.arrange_order LIKE '%[^0-9]%'
	--VALIDATE MAXLENGTH NUMBER arrange_order
	INSERT INTO @ERR_TBL
	SELECT
		28				
	,	N'arrange_order'				
	,	0				
	,	1				
	,	0				
	,	0				
	,	IIF(@P_language = 'en','Sort order','並び順')	
	FROM #TBL_M5010 
	WHERE
		LEN(arrange_order) > 4

		
	--Khi 資格コード không là blank hoặc 0, nếu chưa được đăng kí ở master 資格マスタ thì báo lỗi
	IF EXISTS (SELECT 1 FROM #TBL_M5010 WHERE qualification_cd <> '0' AND qualification_cd NOT LIKE '%[^0-9]%')
	BEGIN 
		IF NOT EXISTS (	SELECT 1
						FROM #TBL_M5010
						INNER JOIN M5010 ON (
							#TBL_M5010.company_cd		=	M5010.company_cd
						AND #TBL_M5010.qualification_cd	=	M5010.qualification_cd
						)
						WHERE
							#TBL_M5010.qualification_cd <> 0
						AND M5010.del_datetime IS NULL
		)
		BEGIN
			INSERT INTO @ERR_TBL
			SELECT
				160				
			,	N'qualification_cd'				
			,	0
			,	1
			,	0				
			,	0				
			,	IIF(@P_language = 'en','Qualification code','資格コード')
		END
	END
	
	-- START TRANSACTION 
	BEGIN TRANSACTION
	BEGIN TRY
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- PROCESS
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		IF NOT EXISTS (SELECT 1 FROM @ERR_TBL)
		BEGIN
			DELETE W
			FROM WRK_M5010 AS W 
			LEFT JOIN #TBL_M5010 ON (
				W.company_cd		=	@P_company_cd
			AND W.exec_user	=	#TBL_M5010.exec_user
			)
			WHERE
				#TBL_M5010.company_cd IS NOT NULL
			
			-- UPDATE QUALIFICATION_CD IF VALUE = 0
			UPDATE #TBL_M5010 SET
				qualification_cd	=	@w_max_qualification_cd
			FROM #TBL_M5010
			WHERE
				qualification_cd	=	0

			-- CASE INSERT
			INSERT INTO WRK_M5010 
			SELECT 
				#TBL_M5010.exec_user
			,	#TBL_M5010.company_cd
			,	#TBL_M5010.qualification_cd		
			,	#TBL_M5010.qualification_nm	
			,	#TBL_M5010.qualification_ab_nm	
			,	#TBL_M5010.qualification_typ	
			,	#TBL_M5010.arrange_order
			,	@P_cre_user			
			,	@P_cre_ip	
			,	N'eO0100'		
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL
			FROM #TBL_M5010
		END
		ELSE
		BEGIN
			INSERT INTO WRK_M5010 
			SELECT 
				CONCAT('WRK_M5010_', CAST(@P_no AS NVARCHAR(10)))
			,	company_cd
			,	0				
			,	''	
			,	''	
			,	0
			,	0
			,	@P_cre_user			
			,	@P_cre_ip	
			,	'eO0100'		
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			FROM #TBL_M5010
		END
		--
		IF @P_no = @P_count - 1
		BEGIN 
			IF (EXISTS(SELECT 1 FROM @ERR_TBL) OR EXISTS(SELECT 1 FROM WRK_M5010 WHERE exec_user LIKE '%WRK_M5010%'))
			BEGIN
				TRUNCATE TABLE WRK_M5010
				--
				GOTO COMPLETE_QUERY
			END

			--REAL TABLE
			UPDATE M5010 SET
				M5010.qualification_nm		=	WRK_M5010.qualification_nm
			,	M5010.qualification_ab_nm	=	WRK_M5010.qualification_ab_nm
			,	M5010.qualification_typ		=	WRK_M5010.qualification_typ
			,	M5010.arrange_order			=	WRK_M5010.arrange_order
			,	M5010.upd_user				=	@P_cre_user	
			,	M5010.upd_ip				=	@P_cre_ip		
			,	M5010.upd_prg				=	N'eO0100'		
			,	M5010.upd_datetime			=	@w_time		
			FROM WRK_M5010
			INNER JOIN M5010 ON (
				WRK_M5010.company_cd			=	M5010.company_cd
			AND WRK_M5010.qualification_cd		=	M5010.qualification_cd
			)
			
			INSERT INTO M5010
			SELECT 
				WRK_M5010.company_cd
			,	WRK_M5010.qualification_cd
			,	WRK_M5010.qualification_nm
			,	WRK_M5010.qualification_ab_nm	
			,	WRK_M5010.qualification_typ
			,	WRK_M5010.arrange_order
			,	@P_cre_user			
			,	@P_cre_ip	
			,	'eO0100'		
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL	
			FROM WRK_M5010
			LEFT JOIN M5010 ON (
				WRK_M5010.company_cd	=	M5010.company_cd	
			AND WRK_M5010.qualification_cd		=	M5010.qualification_cd		
			)
			WHERE 
				M5010.qualification_cd IS NULL	

			TRUNCATE TABLE WRK_M5010
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

	SELECT 
		@w_order_by_min = MIN(order_by)
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
	WHERE order_by = @w_order_by_min
	ORDER BY 
		order_by
END
GO
