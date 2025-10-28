DROP PROCEDURE [SPC_M0070_LST2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--++ TEST ++
-- EXEC SPC_M0070_LST2 '103'
-- EXEC SPC_M0070_LST2 '2'
--****************************************************************************************
--*   											
--* 処理概要/process overview	:	RANDOM PASSWORD
--*  
--* 作成日/create date			:	2018/12/26											
--*	作成者/creater				:	viettd						
--*   					
--*	更新日/update date			:  	2018/08/30						
--*	更新者/updater				:　 longvv　								     	 
--*	更新内容/update content		:	Update randompassword　	
--****************************************************************************************
CREATE PROCEDURE [SPC_M0070_LST2]
	@P_company_cd		smallint
AS
BEGIN
	SET NOCOUNT ON;
	--[0]	
	DECLARE 
		@password_length			TINYINT			=	8 --初期桁数は８桁
	,	@password_character_limit	TINYINT			=	0
	--,	@password_age				TINYINT			=	0
	,	@password					NVARCHAR(20)	=	''
	,	@CharPool1					NVARCHAR(100)	=	''	
	,	@CharPool2					NVARCHAR(100)	=	''	
	,	@CharPool3					NVARCHAR(100)	=	''
	,	@PoolLength1				INT				=	0	
	,	@PoolLength2				INT				=	0	
	,	@PoolLength3				INT				=	0	
	,	@LoopCount					INT				=	0	
	,	@RandomString				VARCHAR(20)		=	''
	SELECT 
		@password_length			=	CASE 
											WHEN ISNULL(M9100.password_length,0) = 0
											THEN 8
											ELSE ISNULL(M9100.password_length,0)
										END													
	,	@password_character_limit	=	ISNULL(M9100.password_character_limit,0)			
	--,	@password_age				=	ISNULL(M0100.password_age,0)						
	FROM M9100
	WHERE 
		M9100.company_cd			=	@P_company_cd
	AND M9100.del_datetime IS NULL
	--
	SET @CharPool1		=	'0123456789'					--数字を含める
	SET @PoolLength1	=	LEN(@CharPool1) 
	SET @CharPool2		=	'abcdefghijklmnopqrstuvwxyz'	--英字を含める
	SET @PoolLength2	=	LEN(@CharPool2) 
	SET @CharPool3		=	'!@#$%^&*()_+-={}[]:;<>,.?/'	--記号を含める
	SET @PoolLength3	=	LEN(@CharPool3) 
	--
	IF @password_character_limit = 2
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
				SET @password = @RandomString
			END
		ELSE
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
				SET @password = @RandomString
		END
		SELECT @password as password
END

GO
