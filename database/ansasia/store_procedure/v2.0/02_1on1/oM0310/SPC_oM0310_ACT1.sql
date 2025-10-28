IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_oM0310_ACT1]') AND type IN (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[SPC_oM0310_ACT1]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 *
 *  処理概要：oM0310 - SAVE/UPDATE
 *
 *  作成日  ：2020/11/06
 *  作成者  ：ANS-ASIA DUONGNTT
 *
 *  更新日  ：
 *  更新者  ：
 *  更新内容：
 *
 ****************************************************************************************************/
CREATE PROCEDURE [SPC_oM0310_ACT1] 
	@P_json			NVARCHAR(MAX)
	--
,	@P_cre_user		NVARCHAR(50) = ''
,	@P_cre_ip		NVARCHAR(50) = ''
,	@P_company_cd	SMALLINT	 = 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2	 = SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	

	--
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
	CREATE TABLE #M2610(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	[1on1_group_cd]			SMALLINT
	,	coach_position_cd		SMALLINT
	,	frequency				TINYINT	
	,	times					SMALLINT
	,	interview_cd			SMALLINT
	)

	--
	CREATE TABLE #M2620(
		id						INT IDENTITY(1,1)
	,	company_cd				SMALLINT
	,	[1on1_group_cd]			SMALLINT
	,	times					SMALLINT
	)
		
	--
	INSERT INTO #M2610
	SELECT 
		@P_company_cd
	,	[1on1_group_cd]
	,	coach_position_cd
	,	frequency
	,	times_interview
	,	interview_cd
	FROM OPENJSON(@P_json, '$.data_group') WITH(
		[1on1_group_cd]		SMALLINT
	,	coach_position_cd	SMALLINT
	,	frequency			TINYINT	
	,	times_interview		SMALLINT
	,	interview_cd		SMALLINT
	)

	--
	INSERT INTO #M2620
	SELECT
		M2620.company_cd
	,	M2620.[1on1_group_cd]
	,	MAX(M2620.times)
	FROM M2620
	INNER JOIN #M2610 ON (
		M2620.company_cd		=	#M2610.company_cd
	AND M2620.[1on1_group_cd]	=	#M2610.[1on1_group_cd]
	AND M2620.del_datetime IS NULL
	)
	GROUP BY
		M2620.company_cd
	,	M2620.[1on1_group_cd]

	--
	UPDATE #M2610
	SET 
		#M2610.times		=	CASE 
									WHEN #M2610.frequency = 1 THEN 6
									WHEN #M2610.frequency = 2 THEN 12
									WHEN #M2610.frequency = 3 THEN 24
									ELSE 0
								END 
	FROM #M2610
	WHERE 
		#M2610.frequency	<>	4
	--
	
	INSERT INTO @ERR_TBL 
	SELECT 
		138								
	,	'.error_group'											
	,	0-- oderby						
	,	4-- dialog  					
	,	#M2610.id								
	,	0								
	,	'times have been setting'		
	FROM #M2610 
	INNER JOIN #M2620 ON (
		#M2610.company_cd		=	#M2620.company_cd
	AND #M2610.[1on1_group_cd]	=	#M2620.[1on1_group_cd]
	)
	WHERE 
		#M2610.times			<>	#M2620.times
	--
	BEGIN TRANSACTION
	BEGIN TRY
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			--UPDATE M2610
			UPDATE M2610
			SET	
				coach_position_cd		=	#M2610.coach_position_cd	
			,	frequency				=	#M2610.frequency			
			,	[1on1_times]			=	IIF(#M2610.frequency <> 4,NULL,#M2610.times)		
			,	interview_cd			=	#M2610.interview_cd		
			--
			,	upd_user				=	@P_cre_user
			,	upd_ip					=	@P_cre_ip
			,	upd_prg					=	'oM0310'
			,	upd_datetime			=	@w_time
			--
			,	del_user				=	SPACE(0)
			,	del_ip					=	SPACE(0)
			,	del_prg					=	SPACE(0)
			,	del_datetime			=	NULL
			FROM M2610
			LEFT JOIN #M2610 ON (
				M2610.company_cd		=	#M2610.company_cd
			AND M2610.[1on1_group_cd]	=	#M2610.[1on1_group_cd]
			)
			WHERE 
				#M2610.id IS NOT NULL

			--INSERT
			INSERT INTO M2610
			SELECT
				#M2610.company_cd			
			,	#M2610.[1on1_group_cd]		
			,	#M2610.coach_position_cd	
			,	#M2610.frequency			
			,	IIF(#M2610.frequency <> 4,NULL,#M2610.times)			
			,	#M2610.interview_cd	
			,	NULL
			,	@P_cre_user	
			,	@P_cre_ip
			,	'oM0310'	
			,	@w_time
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL
			,	SPACE(0)
			,	SPACE(0)
			,	SPACE(0)
			,	NULL
			FROM #M2610
			LEFT JOIN M2610 ON (
				#M2610.company_cd		=	M2610.company_cd
			AND #M2610.[1on1_group_cd]	=	M2610.[1on1_group_cd]
			AND M2610.del_datetime IS NULL
			)
			WHERE M2610.[1on1_group_cd] IS NULL

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
	ELSE
	BEGIN
		ROLLBACK TRANSACTION
	END
    -- Insert statements for procedure here
	COMPLETE_QUERY:
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

	--
	DROP TABLE #M2610
	DROP TABLE #M2620
END

GO
