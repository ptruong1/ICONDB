-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_local_NPANXX_by_NPANXX]
@NPANXX char(6)
AS
BEGIN
	SELECT   LEC_LCA.TELNUM
		FROM (([Tel_info]  with(nolock)  INNER JOIN LCA_LIST  with(nolock) ON [Tel_info].CLUST = LCA_LIST.TERM_CLUST) 
			INNER JOIN LEC_LCA   with(nolock) ON LCA_LIST.ORIG_CLUST = LEC_LCA.CLUST)
			 INNER JOIN LEC_CP  with(nolock) ON (LEC_LCA.ST = LEC_CP.ST) AND (LCA_LIST.CPNUM = LEC_CP.CPNUM)
		WHERE
			 (((LEC_LCA.COTYPE)<>'W') AND ((LEC_CP.RESIDENT)=1) AND
			 (([Tel_Info].TELNUM)=@NPANXX AND ((LEC_CP.TELCOID)=[LEC_LCA].[TELCO]) AND
			 ((LEC_CP.BASE)=1) AND ((LEC_CP.ISDN)=0))) ;
END

