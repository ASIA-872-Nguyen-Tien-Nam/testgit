DROP PROCEDURE [SPC_M0150_ACT2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+ SPC_M0150_LST1
-- EXEC SPC_M0150_LST1 '','1','807';
-- select * from m0070
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	M0100_商品登録
--*  
--*  作成日/create date			:	2017/11/03						
--*　作成者/creater				:	tannq								
--*   					
--*  更新日/update date			:  
--*　更新者/updater				:　
--*　更新内容/update content		:	
--****************************************************************************************
CREATE PROCEDURE [SPC_M0150_ACT2]
	-- Add the parameters for the stored procedure here
	@P_group_cd									SMALLINT		=	0
,	@P_cre_user									NVARCHAR(50)	=	''
,	@P_cre_ip									NVARCHAR(50)	=	''
,	@P_company_cd								INT				=	0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL				ERRTABLE
	,	@order_by_min			INT					=	0
	,	@count1					INT					=	0
	,	@count2					INT					=	0
	,	@pg_id					nvarchar(30)		=	'M0150'	
	
	-- START TRANSACTION 
	BEGIN TRANSACTION
	BEGIN TRY

	CREATE TABLE #SHEET(
		id			INT IDENTITY(1,1) 
	,	company_cd	SMALLINT
	,	sheet_cd	SMALLINT
	,	status_cd	SMALLINT
	)


		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- VALIDATE
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		--
		IF NOT EXISTS (SELECT 1 FROM M0150 WHERE M0150.company_cd =	@P_company_cd AND M0150.group_cd = @P_group_cd AND M0150.del_datetime IS NULL)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(		
				21									-- ma l?i (trung v?i ma trong b?ng message) 					
			,	''									-- id ho?c class c?a item(#id , .class), l?i d?ng dialog thi ?? tr?ng  				
			,	0-- oderby							-- gia tr? cang be thi l?i ???c hi?n th? tr??c  				
			,	1-- dialog  						-- Ki?u hi?n th? l?i : 0. tooltip , 1.dialog 				
			,	0									-- Tuy y : co th? l?u v? tri index c?a dong c?a l?i 				
			,	0									-- Tuy y
			,	'L?i update b?n ghi khong t?n t?i'	-- Comment n?i dung l?i (ch? y?u la dung khi ??c code)
			)
		END

		INSERT INTO #SHEET
		SELECT 
			F0030.company_cd
		,	F0100.sheet_cd
		,	F0100.status_cd
		FROM F0030
		LEFT JOIN F0100 ON (
			F0030.company_cd  = F0100.company_cd
		AND F0030.fiscal_year = F0100.fiscal_year
		AND F0030.employee_cd = F0100.employee_cd
		)
		WHERE F0030.company_cd = @P_company_cd
		AND F0030.group_cd	   = @P_group_cd
		AND F0030.del_datetime IS NULL
		AND F0100.del_datetime IS NULL
		--select '#SHEET',* from #SHEET
		--SET @count1 = (
		--	SELECT COUNT (1)
		--	FROM #SHEET
		--	INNER JOIN M0200 ON(
		--		#SHEET.company_cd	= M0200.company_cd
		--	AND #SHEET.sheet_cd		= M0200.sheet_cd
		--	AND 1					= M0200.sheet_kbn
		--	)
		--	WHERE #SHEET.status_cd <> 12
		--)

		--SET @count2 = (
		--	SELECT COUNT (1)
		--	FROM #SHEET
		--	INNER JOIN M0200 ON(
		--		#SHEET.company_cd	= M0200.company_cd
		--	AND #SHEET.sheet_cd		= M0200.sheet_cd
		--	AND 2					= M0200.sheet_kbn
		--	)
		--	WHERE #SHEET.status_cd <> 10
		--)

		IF EXISTS(
			SELECT 1
			FROM #SHEET
			LEFT JOIN M0200 ON (
				#SHEET.company_cd	= M0200.company_cd
			AND #SHEET.sheet_cd		= M0200.sheet_cd
			)	
			WHERE 
				(M0200.sheet_kbn = 1 AND #SHEET.status_cd <> 12)
			OR	(M0200.sheet_kbn = 2 AND #SHEET.status_cd <> 10)
		)
		BEGIN
			INSERT INTO @ERR_TBL VALUES(		
					82									
				,	''													
				,	0						
				,	1	-- dialog  						
				,	0									
				,	0									
				,	'msg 82'	
				)
		END

		
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- PROCESS
		--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		-- Ch? nay dung ?? vi?t code x? ly d? li?u sau khi validate xong
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			UPDATE M0150 SET 
				del_user		=	@P_cre_user	
			,	del_ip			=	@P_cre_ip	
			,	del_prg			=	'M0150'	
			,	del_datetime	=	@w_time		
			WHERE
				M0150.company_cd			=	@P_company_cd
			AND M0150.group_cd				=	@P_group_cd
			-- 
			UPDATE M0151 SET 
				del_user		=	@P_cre_user	
			,	del_ip			=	@P_cre_ip	
			,	del_prg			=	'M0150'		
			,	del_datetime	=	@w_time										
			WHERE
				M0151.company_cd			=	@P_company_cd
			AND M0151.group_cd				=	@P_group_cd
		END
		-- END PROCESS
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
		,	'EXCETION'
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
