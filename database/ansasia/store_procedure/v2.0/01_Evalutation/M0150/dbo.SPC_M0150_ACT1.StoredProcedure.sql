DROP PROCEDURE [SPC_M0150_ACT1]
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
--*  更新日/update date			:	2023/11/27
--*　更新者/updater				:　	yamazaki
--*　更新内容/update content		:	M0151.code SMALLINT→INT
--*
--****************************************************************************************
CREATE PROCEDURE [SPC_M0150_ACT1]
	-- Add the parameters for the stored procedure here
	@P_json										NVARCHAR(MAX)	=	''
,	@P_cre_user									NVARCHAR(100)	=	''
,	@P_cre_ip									NVARCHAR(50)	=	''
,	@P_company_cd								SMALLINT		=	0

AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2				=	SYSDATETIME()
	,	@ERR_TBL				ERRTABLE
	,	@order_by_min			INT					=	0
	,	@group_cd				SMALLINT			=	JSON_VALUE(@P_json,'$.group_cd')
	,	@group_nm				NVARCHAR(50)		=	JSON_VALUE(@P_json,'$.group_nm')
	,	@arrange_order			INT					=	JSON_VALUE(@P_json,'$.arrange_order')
	,	@max_group_cd			SMALLINT			=	0
	--
	SET @max_group_cd = (ISNULL((SELECT MAX(group_cd) FROM M0150 WHERE M0150.company_cd = @P_company_cd),0) + 1)

	-- M0060
	CREATE TABLE #_M0060(
		id					INT		IDENTITY(1,1)
	,	employee_typ		SMALLINT
	,	employee_typ_nm		NVARCHAR(50)
	,	attribute			INT
	)
	
	-- M0030
	CREATE TABLE #_M0030(
		id					INT		IDENTITY(1,1)
	,	job_cd				SMALLINT
	,	job_nm				NVARCHAR(50)
	,	attribute			INT
	)

	-- M0040
	CREATE TABLE #_M0040(
		id					INT		IDENTITY(1,1)
	,	position_cd			INT
	,	position_nm			NVARCHAR(50)
	,	attribute			INT
	)

	-- M0050
	CREATE TABLE #_M0050(
		id					INT		IDENTITY(1,1)
	,	grade				SMALLINT
	,	grade_nm			NVARCHAR(10)
	,	attribute			INT
	)

	-- M0151 
	CREATE TABLE #_CODE(
		id					INT		IDENTITY(1,1)
	,	code				SMALLINT
	,	code_nm				NVARCHAR(20)
	,	attribute			SMALLINT
	)

	--
	INSERT INTO @ERR_TBL 
	SELECT		
		8									-- ma l?i (trung v?i ma trong b?ng message) 					
	,	'#group_nm'							-- id ho?c class c?a item(#id , .class), l?i d?ng dialog thi ?? tr?ng  				
	,	0-- oderby							-- gia tr? cang be thi l?i ???c hi?n th? tr??c  				
	,	0			  						-- Ki?u hi?n th? l?i : 0. tooltip , 1.dialog 				
	,	0									-- Tuy y : co th? l?u v? tri index c?a dong c?a l?i 				
	,	0									-- Tuy y
	,	'json format'						-- Comment n?i dung l?i (ch? y?u la dung khi ??c code)
	WHERE @group_nm = ''

	BEGIN TRANSACTION
	BEGIN TRY
		--
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
			-- #_M0060
			INSERT INTO #_M0060 
			SELECT
				JSON_TABLE.code
			,	M0060.employee_typ_nm
			,	1
			FROM OPENJSON(@P_json,'$.m0060') WITH(
				chk								INT						
			,	code							SMALLINT						
			) AS JSON_TABLE 
			LEFT JOIN M0060 ON (
				M0060.company_cd = @P_company_cd
			AND M0060.del_datetime IS NULL 
			AND M0060.employee_typ	=	JSON_TABLE.code
			)
			WHERE JSON_TABLE.chk <> 0

			-- #_M0030
			INSERT INTO #_M0030 
			SELECT
				JSON_TABLE.code
			,	M0030.job_nm
			,	2
			FROM OPENJSON(@P_json,'$.m0030') WITH(
				chk								INT						
			,	code							SMALLINT						
			) AS JSON_TABLE 
			LEFT JOIN M0030 ON (
				M0030.company_cd = @P_company_cd
			AND M0030.del_datetime IS NULL 
			AND M0030.job_cd	=	JSON_TABLE.code
			)
			WHERE JSON_TABLE.chk <> 0

			-- #_M0040
			INSERT INTO #_M0040 
			SELECT
				JSON_TABLE.code
			,	M0040.position_nm
			,	3
			FROM OPENJSON(@P_json,'$.m0040') WITH(
				chk								INT						
			,	code							INT	--2023/11/27 SMALLINT→INT						
			) AS JSON_TABLE 
			LEFT JOIN M0040 ON (
				M0040.company_cd = @P_company_cd
			AND M0040.del_datetime IS NULL 
			AND M0040.position_cd	=	JSON_TABLE.code
			)
			WHERE JSON_TABLE.chk <> 0

			-- #_M0050
			INSERT INTO #_M0060 
			SELECT
				JSON_TABLE.code
			,	M0050.grade_nm
			,	4
			FROM OPENJSON(@P_json,'$.m0050') WITH(
				chk								INT						
			,	code							SMALLINT						
			) AS JSON_TABLE 
			LEFT JOIN M0050 ON (
				M0050.company_cd = @P_company_cd
			AND M0050.del_datetime IS NULL	
			AND M0050.grade		=	JSON_TABLE.code
			)
			WHERE JSON_TABLE.chk <> 0

			-- INSERT
			IF NOT EXISTS (SELECT 1 FROM M0150 WHERE del_datetime IS NULL  AND M0150.group_cd = @group_cd AND M0150.company_cd = @P_company_cd)
			BEGIN
				SET @group_cd	=	@max_group_cd
				-- M0150
				INSERT INTO M0150 
				SELECT 
					@P_company_cd
				,	@group_cd
				,	@group_nm
				,	@arrange_order
				,	@P_cre_user
				,	@P_cre_ip
				,	'M0150'
				,	@w_time
				,	SPACE(0)
				,	SPACE(0)
				,	SPACE(0)
				,	NULL
				,	SPACE(0)
				,	SPACE(0)
				,	SPACE(0)
				,	NULL
				
			END
			ELSE
			BEGIN
				UPDATE M0150 SET
					M0150.group_nm			=	@group_nm
				,	M0150.arrange_order		=	@arrange_order
				,	M0150.upd_user			=	@P_cre_user
				,	M0150.upd_ip			=	@P_cre_ip
				,	M0150.upd_prg			=	'M0150'
				,	M0150.upd_datetime		=	@w_time
				WHERE 
					M0150.company_cd	=	@P_company_cd
				AND M0150.group_cd		=	@group_cd

			END

			-- DELETE FROM M0151
			DELETE FROM M0151 WHERE 
				M0151.del_datetime IS NULL 
			AND M0151.group_cd		=	@group_cd
			AND M0151.company_cd	=	@P_company_cd
			--
			--select 11
			-- M0151
			INSERT INTO M0151 
			SELECT
				@P_company_cd
			,	@group_cd
			,	GROUP_CODE.attribute
			,	ROW_NUMBER() OVER(ORDER BY @group_cd,GROUP_CODE.attribute,@P_company_cd ASC) AS detail_no
			,	GROUP_CODE.code
			,	M0150.cre_user
			,	M0150.cre_ip
			,	M0150.cre_prg
			,	M0150.cre_datetime
			,	M0150.upd_user
			,	M0150.upd_ip
			,	M0150.upd_prg
			,	M0150.upd_datetime
			,	M0150.del_user
			,	M0150.del_ip
			,	M0150.cre_prg
			,	M0150.del_datetime
			FROM (
				SELECT 
					#_M0060.employee_typ		AS code
				,	#_M0060.employee_typ_nm		AS code_nm
				,	#_M0060.attribute
				,	#_M0060.id
				FROM #_M0060
				UNION
				SELECT 
					#_M0030.job_cd AS code
				,	#_M0030.job_nm		AS code_nm
				,	#_M0030.attribute
				,	#_M0030.id
				FROM #_M0030
				UNION
				SELECT 
					#_M0040.position_cd		AS code
				,	#_M0040.position_nm		AS code_nm
				,	#_M0040.attribute
				,	#_M0040.id
				FROM #_M0040
				UNION
				SELECT 
					#_M0050.grade			AS code
				,	#_M0050.grade_nm		AS code_nm
				,	#_M0050.attribute
				,	#_M0050.id
				FROM #_M0050
			) AS  GROUP_CODE LEFT JOIN M0150 ON (
					M0150.company_cd	= @P_company_cd
				AND M0150.del_datetime IS NULL	
				AND M0150.group_cd		= @group_cd
			)
			
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
	--[1]
	SELECT @group_cd AS group_cd
END
GO
