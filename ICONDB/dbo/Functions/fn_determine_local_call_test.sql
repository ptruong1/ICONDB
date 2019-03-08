

CREATE FUNCTION [dbo].[fn_determine_local_call_test] (@fromNPANXX char(6), @toNPANXX char(6))  
RETURNS int  AS  
BEGIN 
	declare @fromNPA char(3) , @toNPA char(3)
	set @fromNPA  =  left(@fromNPANXX, 3 ) 
	set @toNPA  =   left(@toNPANXX ,3) 
	 IF(@fromNPANXX = @toNPANXX) RETURN 1
	 If  (dbo.fn_CalculateMileage (@fromNPANXX, @toNPANXX  ) < 2)  return 1
	 declare  @i  int
	 set @i =0
	If( @fromNPA  in ( '402' , '757',  '218' ,   '559' ,'770'  )  )
	 Begin
		If  (@fromNPANXX   =  '757488')  
		  Begin
			if(select count(*) from tblLocal  with(nolock) where  NPA = @toNPA  and  (NXX =  right(@toNPANXX,3) or NXX='*')    and [Local] = 'Y')  > 0 
				Return 1
		  End
		else
		 Begin
			
			SELECT  @i = count( LEC_LCA.TELNUM)
			FROM (([Tel_info]  with(nolock)  INNER JOIN LCA_LIST  with(nolock) ON [Tel_info].CLUST = LCA_LIST.TERM_CLUST) 
				INNER JOIN LEC_LCA   with(nolock) ON LCA_LIST.ORIG_CLUST = LEC_LCA.CLUST)
				 INNER JOIN LEC_CP  with(nolock) ON (LEC_LCA.ST = LEC_CP.ST) AND (LCA_LIST.CPNUM = LEC_CP.CPNUM)
			WHERE
				 ( -- ((LEC_LCA.COTYPE)<>'W') AND
				-- ((LEC_CP.RESIDENT)=1) AND
				 (([Tel_Info].TELNUM)= @fromNPANXX  AND ((LEC_CP.TELCOID)=[LEC_LCA].[TELCO]) AND
				 ((LEC_CP.BASE)=1) AND ((LEC_CP.ISDN)=0))) and LEC_LCA.TELNUM =@toNPANXX
			
		 End
		

		
	 End
	Else
	  Begin
		SELECT  @i = count( LEC_LCA.TELNUM)
		FROM (([Tel_info]  with(nolock)  INNER JOIN LCA_LIST  with(nolock) ON [Tel_info].CLUST = LCA_LIST.TERM_CLUST) 
			INNER JOIN LEC_LCA   with(nolock) ON LCA_LIST.ORIG_CLUST = LEC_LCA.CLUST)
			 INNER JOIN LEC_CP  with(nolock) ON (LEC_LCA.ST = LEC_CP.ST) AND (LCA_LIST.CPNUM = LEC_CP.CPNUM)
		WHERE
			 (((LEC_LCA.COTYPE)<>'W') AND ((LEC_CP.RESIDENT)=1) AND
			 (([Tel_Info].TELNUM)= @fromNPANXX  AND ((LEC_CP.TELCOID)=[LEC_LCA].[TELCO]) AND
			 ((LEC_CP.BASE)=1) AND ((LEC_CP.ISDN)=0))) and LEC_LCA.TELNUM =@toNPANXX
	 End
	
	if @i>0 SET @i =1
	
	return @i
END





























