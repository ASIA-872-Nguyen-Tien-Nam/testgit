DROP PROCEDURE [SPC_M0140_ACT1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC XXX '{}','','::1';

--****************************************************************************************
--*   											
--* 処理概要/process overview	:	SAVE DATA
--*  
--* 作成日/create date			:	2018/08/20											
--*	作成者/creater				:	longvv				
--*   					
--*	更新日/update date			:  						
--*	更新者/updater				:　  　								     	 
--*	更新内容/update content		:	　	
--****************************************************************************************
CREATE PROCEDURE [SPC_M0140_ACT1] 
	-- Add the parameters for the stored procedure here
	@P_json			nvarchar(max)
	-- common
,	@P_cre_user		nvarchar(50)
,	@P_cre_ip		nvarchar(50)
,	@P_company_cd	smallint

AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@w_time					DATETIME2			=	SYSDATETIME()
	,	@ERR_TBL				ERRTABLE	
	,	@order_by_min			INT					= 0
	,	@organization_cd		NVARCHAR(40)					= ''
	,	@arrange_order			INT					= 0
	,	@P_authority_typ		INT					= 0
	,	@P_authority_cd			INT					= 0
	,	@countAuthority			SMALLINT			=	0
	
	CREATE TABLE #M0300(
		id						INT IDENTITY(1,1)
	,	company_cd				INT
	,	organization_cd			NVARCHAR(40)
	,	position_cd				INT
	,	rater_position_cd_1		INT
	,	rater_position_cd_2		INT
	,	rater_position_cd_3		INT
	,	rater_position_cd_4		INT
	)
	CREATE TABLE #M0020(
		id						INT IDENTITY(1,1)
	,	company_cd				INT
	,	organization_cd			NVARCHAR(40)
	)
	-- START TRANSACTION
	BEGIN TRANSACTION
	BEGIN TRY
		-- assign
		SET @organization_cd		=	JSON_VALUE(@P_json,'$.organization_cd')

		SET @arrange_order			=	JSON_VALUE(@P_json,'$.arrange_order')
		SELECT @P_authority_typ	= 	authority_typ FROM S0010 WHERE S0010.company_cd = @P_company_cd AND user_id = @P_cre_user
		SELECT @P_authority_cd	= 	authority_cd FROM S0010 WHERE S0010.company_cd = @P_company_cd AND user_id = @P_cre_user
		SET @countAuthority = (SELECT COUNT(1) FROM S0022 WHERE S0022.company_cd = @P_company_cd AND S0022.authority_cd = @P_authority_cd AND S0022.authority	= 1)
		--check json
		IF ISJSON(@P_json) <= 0
			BEGIN
				INSERT INTO @ERR_TBL VALUES(		
					8									-- ma l?i (trung v?i ma trong b?ng message) 					
				,	''									-- id ho?c class c?a item(#id , .class), l?i d?ng dialog thi ?? tr?ng  				
				,	0-- oderby							-- gia tr? cang be thi l?i ???c hi?n th? tr??c  				
				,	1-- dialog  						-- Ki?u hi?n th? l?i : 0. tooltip , 1.dialog 				
				,	0									-- Tuy y : co th? l?u v? tri index c?a dong c?a l?i 				
				,	0									-- Tuy y
				,	'json format'						-- Comment n?i dung l?i (ch? y?u la dung khi ??c code)
				)
			END
		INSERT INTO #M0020
		SELECT 
			@P_company_cd
		,	M0020.organization_cd_1
		FROM M0020 WITH(NOLOCK)
		LEFT OUTER JOIN S0022 WITH(NOLOCK) ON(
			M0020.company_cd		=	S0022.company_cd
	　	AND	@P_authority_cd			= 	S0022.authority_cd
	　	 AND	M0020.organization_typ	= 	1
	　	 AND	M0020.organization_cd_1	= 	S0022.organization_cd_1
		 AND	M0020.organization_cd_2	= 	S0022.organization_cd_2
		 AND	M0020.organization_cd_3	= 	S0022.organization_cd_3
		 AND	M0020.organization_cd_4	= 	S0022.organization_cd_4
		 AND	M0020.organization_cd_5	= 	S0022.organization_cd_5
		AND	S0022.del_datetime		IS NULL
		)
		WHERE 
			(M0020.company_cd		= @P_company_cd)
		AND	(M0020.organization_typ = 1)
		AND	(@P_authority_typ <> 3 OR (@P_authority_typ =3 AND	(S0022.authority	= 1 OR @countAuthority = 0)))
		AND	(M0020.del_datetime IS NULL)
		ORDER BY 
		M0020.arrange_order
	,	M0020.organization_cd_1
	
		INSERT INTO #M0300
		SELECT
			@P_company_cd 																
		,	[row].organization_cd
		,	IIF([row].position_cd			= -1,0,[row].position_cd)												
		,	IIF([row].rater_position_cd_1	= -1,0,[row].rater_position_cd_1)												
		,	IIF([row].rater_position_cd_2	= -1,0,[row].rater_position_cd_2)											
		,	IIF([row].rater_position_cd_3	= -1,0,[row].rater_position_cd_3)												
		,	IIF([row].rater_position_cd_4	= -1,0,[row].rater_position_cd_4)												
		FROM OPENJSON(@P_json,'$.list') WITH(			
			organization_cd			NVARCHAR(40)
		,	position_cd				INT
		,	rater_position_cd_1		INT
		,	rater_position_cd_2		INT
		,	rater_position_cd_3		INT
		,	rater_position_cd_4		INT
		) AS [row] 
		
		--select '#M0300',* from #M0300 WHERE #M0300.rater_position_cd_1 = 0
		IF NOT EXISTS(SELECT 1 FROM #M0300 INNER JOIN #M0300 AS #M0300_1 ON(
											#M0300.company_cd			=	#M0300_1.company_cd
											AND #M0300.organization_cd	=	#M0300_1.organization_cd
											AND	#M0300.position_cd		=	#M0300_1.position_cd
											AND	0						<>	#M0300_1.rater_position_cd_1))
		BEGIN
			INSERT INTO @ERR_TBL 
			SELECT		
				8						
			,	'.rater_position_cd_1'						
			,	0-- oderby				
			,	0			  			
			,	0							
			,	1			
			,	'required'		
		END
		IF NOT EXISTS (SELECT 1 FROM @ERR_TBL)
		BEGIN
			INSERT INTO @ERR_TBL 
			SELECT		
				8						
			,	'.rater_position_cd_1'						
			,	0-- oderby				
			,	0			  			
			,	#M0300.id							
			,	2			
			,	'required'		
			FROM #M0300
			WHERE (#M0300.rater_position_cd_4 <> 0 
			OR #M0300.rater_position_cd_3 <> 0 
			OR #M0300.rater_position_cd_2 <> 0 )
			AND	#M0300.rater_position_cd_1 = 0
			--
			INSERT INTO @ERR_TBL 
			SELECT		
				8						
			,	'.rater_position_cd_2'						
			,	0-- oderby				
			,	0			  			
			,	#M0300.id							
			,	2			
			,	'required'		
			FROM #M0300
			WHERE	(#M0300.rater_position_cd_4 <> 0 
					OR #M0300.rater_position_cd_3 <> 0 )
			AND		#M0300.rater_position_cd_2 = 0
			--
			INSERT INTO @ERR_TBL 
			SELECT		
				8						
			,	'.rater_position_cd_3'						
			,	0-- oderby				
			,	0			  			
			,	#M0300.id							
			,	2			
			,	'required'		
			FROM #M0300
			WHERE	(#M0300.rater_position_cd_4 <> 0 )
			AND		#M0300.rater_position_cd_3 = 0
		END
		--
		
		IF NOT EXISTS(SELECT message_no FROM @ERR_TBL)
		BEGIN
		DELETE D FROM M0300 AS D 
					LEFT JOIN #M0300 ON(
						D.company_cd		=	@P_company_cd
					AND	D.organization_cd	=	@organization_cd
					AND D.position_cd		=	#M0300.position_cd
					)
					WHERE #M0300.company_cd IS NULL
				AND	D.company_cd		=	@P_company_cd
				AND	D.organization_cd	=	@organization_cd
				--AND D.position_cd		=	#M0300.position_cd

			IF(@organization_cd <> '-1' AND @organization_cd <> '')
		BEGIN
		--select * from #M0300 return
			UPDATE M0300
			SET
				M0300.rater_position_cd_1		=	#M0300.rater_position_cd_1
			,	M0300.rater_position_cd_2		=	#M0300.rater_position_cd_2
			,	M0300.rater_position_cd_3		=	#M0300.rater_position_cd_3
			,	M0300.rater_position_cd_4		=	#M0300.rater_position_cd_4
			,	M0300.arrange_order				=	@arrange_order
			,	M0300.upd_user					=	@P_cre_user
			,	M0300.upd_ip					=	@P_cre_ip
			,	M0300.upd_prg					=	'M0140'
			,	M0300.upd_datetime				=	@w_time
			,	M0300.del_user					=	SPACE(0)
			,	M0300.del_prg					=	SPACE(0)
			,	M0300.del_ip					=	SPACE(0)
			,	M0300.del_datetime				=	NULL
			FROM M0300 LEFT JOIN #M0300 ON(
				M0300.company_cd		=	#M0300.company_cd
			AND	M0300.organization_cd	=	@organization_cd
			AND M0300.position_cd		=	#M0300.position_cd
			)
			WHERE M0300.company_cd		=	@P_company_cd
			AND	M0300.organization_cd	=	@organization_cd
			AND M0300.position_cd		=	#M0300.position_cd
			--AND M0300.del_datetime	IS NULL

			INSERT INTO M0300
			SELECT 
				#M0300.company_cd
			,	@organization_cd
			,	#M0300.position_cd
			,	#M0300.rater_position_cd_1
			,	#M0300.rater_position_cd_2
			,	#M0300.rater_position_cd_3
			,	#M0300.rater_position_cd_4
			,	@arrange_order
			,	@P_cre_user
			,	@P_cre_ip
			,	'M0140'
			,	@w_time
			,	''									
			,	''									
			,	''
			,	NULL								
			,	''									
			,	''
			,	''									
			,	NULL												
			FROM #M0300 
			LEFT JOIN M0300 ON(
				#M0300.company_cd		=	M0300.company_cd
			AND	@organization_cd		=	M0300.organization_cd
			AND	#M0300.position_cd		=	M0300.position_cd
			)
			WHERE M0300.organization_cd IS NULL
		END
		ELSE
		BEGIN
			DELETE D FROM M0300 AS D 
					LEFT JOIN M0020 ON(
						D.company_cd		=	M0020.company_cd
					AND 1					=	M0020.organization_typ
					AND	D.organization_cd	=	M0020.organization_cd_1
					AND M0020.del_datetime IS NULL
					)
					WHERE M0020.company_cd IS NULL
			UPDATE M0300
			SET
				M0300.rater_position_cd_1		=	#M0300.rater_position_cd_1
			,	M0300.rater_position_cd_2		=	#M0300.rater_position_cd_2
			,	M0300.rater_position_cd_3		=	#M0300.rater_position_cd_3
			,	M0300.rater_position_cd_4		=	#M0300.rater_position_cd_4
			,	M0300.arrange_order				=	@arrange_order
			,	M0300.upd_user					=	@P_cre_user
			,	M0300.upd_ip					=	@P_cre_ip
			,	M0300.upd_prg					=	'M0140'
			,	M0300.upd_datetime				=	@w_time
			,	M0300.del_user					=	SPACE(0)
			,	M0300.del_ip					=	SPACE(0)
			,	M0300.del_prg					=	SPACE(0)
			,	M0300.del_datetime				=	NULL
			FROM M0300 INNER JOIN #M0300 ON(
				M0300.company_cd		=	#M0300.company_cd
			AND M0300.position_cd		=	#M0300.position_cd
			)
			LEFT JOIN #M0020 ON (
				M0300.company_cd		=	#M0020.company_cd
			AND	M0300.organization_cd	=	#M0020.organization_cd
			)
			WHERE M0300.organization_cd	=	#M0020.organization_cd
			
			INSERT INTO M0300
			SELECT 
				#M0300.company_cd
			,	#M0020.organization_cd
			,	#M0300.position_cd
			,	#M0300.rater_position_cd_1
			,	#M0300.rater_position_cd_2
			,	#M0300.rater_position_cd_3
			,	#M0300.rater_position_cd_4
			,	@arrange_order
			,	@P_cre_user
			,	@P_cre_ip
			,	'M0140'
			,	@w_time
			,	''									
			,	''
			,	''									
			,	NULL								
			,	''									
			,	''
			,	''									
			,	NULL												
			FROM #M0300 
			LEFT JOIN #M0020 ON (
				#M0300.company_cd = #M0020.company_cd
			)
			LEFT JOIN M0300 ON(
				#M0300.company_cd		=	M0300.company_cd
			AND	#M0020.organization_cd	=	M0300.organization_cd
			AND	#M0300.position_cd		=	M0300.position_cd
			)
			WHERE M0300.organization_cd IS NULL
			
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
