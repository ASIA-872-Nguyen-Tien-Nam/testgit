DROP PROCEDURE [SPC_sS0030_INQ1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- +--TEST--+ [SPC_sS0030_INQ1]
-- EXEC [SPC_sS0030_INQ1]'';
--****************************************************************************************
--*   											
--*  処理概要/process overview	:	
--*  
--*  作成日/create date			:	2018/08/24				
--*　作成者/creater				:	Tuantv								
--*   					
--*	更新日/update date			:  	2020/10/22				
--*	更新者/updater				:　 nghianm 　								     	 
--*	更新内容/update content		:	copy from 人事評価システム→基本設定システム(S9020~S9022)
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_sS0030_INQ1]
	@P_company_cd		SMALLINT	=	0
,	@P_authority_cd		SMALLINT	=	0
,	@P_authority_typ	SMALLINT	=	0
AS
BEGIN
	DECLARE
		@countAuthority			SMALLINT	=	0
	SET @countAuthority = (
		SELECT COUNT(S9022.authority_cd) 
		FROM S9022 
		WHERE 
			S9022.company_cd	= @P_company_cd 
		AND S9022.authority_cd	= @P_authority_cd 
		AND S9022.authority		= 1
		AND S9022.del_datetime IS NULL
	)
	--[0]
	SELECT 
		M0020.organization_typ
	,	M0020.organization_cd_1
	,	M0020.organization_cd_2
	,	M0020.organization_cd_3
	,	M0020.organization_cd_4
	,	M0020.organization_cd_5
	,	M0020.organization_nm
	,	M0020.arrange_order 
	,	@P_authority_typ	AS authority_typ
	FROM M0020 WITH(NOLOCK)
	LEFT OUTER JOIN S9022 WITH(NOLOCK) ON(
		M0020.company_cd		=	S9022.company_cd
	AND	@P_authority_cd			= 	S9022.authority_cd
	AND	M0020.organization_cd_1	= 	S9022.organization_cd_1
	AND	M0020.organization_cd_2	= 	S9022.organization_cd_2
	AND	M0020.organization_cd_3	= 	S9022.organization_cd_3
	AND	M0020.organization_cd_4	= 	S9022.organization_cd_4
	AND	M0020.organization_cd_5	= 	S9022.organization_cd_5
	AND	S9022.del_datetime		IS NULL
	)
	 WHERE 
			(M0020.company_cd		= @P_company_cd)
	 AND	(M0020.organization_typ = 1)
	 AND	(@P_authority_typ <> 3 OR (@P_authority_typ =3 AND	((S9022.authority	= 1 AND @countAuthority > 0) OR @countAuthority = 0)))
	 AND	(M0020.del_datetime IS NULL)
	 ORDER BY 
		M0020.arrange_order
	,	M0020.organization_cd_1 
	,	M0020.organization_cd_2 
	,	M0020.organization_cd_3 
	,	M0020.organization_cd_4 
	,	M0020.organization_cd_5 

	  --[1]
	 SELECT 
		M0020.organization_typ
	,	M0020.organization_cd_1
	,	M0020.organization_cd_2
	,	M0020.organization_cd_3
	,	M0020.organization_cd_4
	,	M0020.organization_cd_5
	,	M0020.organization_nm
	,	M0020.organization_ab_nm
	FROM M0020 WITH(NOLOCK)
	LEFT OUTER JOIN S9022 WITH(NOLOCK) ON(
			M0020.company_cd		=	S9022.company_cd
	　	AND	@P_authority_cd			= 	S9022.authority_cd
	　	AND	M0020.organization_cd_1	= 	S9022.organization_cd_1
	　	AND	M0020.organization_cd_2	= 	S9022.organization_cd_2
	　	AND	M0020.organization_cd_3	= 	S9022.organization_cd_3
	　	AND	M0020.organization_cd_4	= 	S9022.organization_cd_4
	　	AND	M0020.organization_cd_5	= 	S9022.organization_cd_5
		AND	S9022.del_datetime		IS NULL
		)
	WHERE
		(M0020.company_cd				=	@P_company_cd)
	AND	(@P_authority_typ <> 3 OR (@P_authority_typ =3 AND	S9022.authority	= 1))
	AND	(M0020.del_datetime				IS NULL)
	AND	M0020.organization_typ			=	2
	ORDER BY 
		M0020.arrange_order
	,	M0020.organization_cd_1
	,	M0020.organization_cd_2
	,	M0020.organization_cd_3
	,	M0020.organization_cd_4
	,	M0020.organization_cd_5

	  --[2]
	 SELECT 
		M0040.position_cd					AS position_cd
	 ,	ISNULL(M0040.position_nm,'')		AS position_nm
	 FROM M0040 WITH(NOLOCK)
	 WHERE (M0040.company_cd	 = @P_company_cd)
	 AND  (M0040.del_datetime IS NULL)
	 ORDER BY 
		M0040.arrange_order ASC
	 ,	M0040.position_cd

	 --[3]
	 SELECT 
		S9020.authority_cd					AS authority_cd
	 ,	ISNULL(S9020.authority_nm,'')		AS authority_nm
	 FROM S9020 WITH(NOLOCK)
	 WHERE (S9020.company_cd	 = @P_company_cd)
	 AND  (S9020.del_datetime IS NULL)
	 ORDER BY 
		S9020.arrange_order	ASC
	,	S9020.authority_cd

	 --[4]
	 SELECT 
		M0060.company_cd					AS company_cd
	 ,	M0060.employee_typ					AS employee_typ
	 ,	M0060.employee_typ_nm				AS employee_typ_nm
	 FROM M0060 WITH(NOLOCK)
	 WHERE (M0060.company_cd	 = @P_company_cd)
	 AND  (M0060.del_datetime IS NULL)
	 ORDER BY 
		M0060.arrange_order ASC
	,	M0060.employee_typ

END
GO


