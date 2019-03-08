

CREATE PROCEDURE [dbo].[p_determine_local_call_by_Facility] 
(@facilityID int, @CalledNo char(10))
As 
BEGIN 
	declare @fromNPA char(3) , @toNPA char(3), @fromNo char(10),@fromNPANXX char(6)
			,@toNPANXX char(6), @i  int
	Select @fromNo = phone  from tblfacility where facilityID =@facilityID
	SET @fromNPANXX =  left(@fromNo, 6 ) 
	set @fromNPA  =  left(@fromNo, 3) 
	SET @toNPANXX = left(@CalledNo,6)		
	set @toNPA  =   left(@CalledNo,3) 
	
	
	 IF(@fromNPANXX = @toNPANXX) 
		RETURN 1 ;
	 IF  (dbo.fn_CalculateMileage (@fromNPANXX, @toNPANXX  ) < 2)  
		return 1 ;
	
	set @i =0;
/*

    
	If( @fromNPA  in ( '402' , '757',  '218' ,   '559' ,'770' , '605') or @fromNPANXX in( '310802','310750','310349' ))
	 Begin
		
		if(select count(*) from tblLocal  with(nolock) where  frNPANXX = @fromNPANXX  and  NPA = @toNPA  and NXX =  right(@toNPANXX,3)  and [Local] = 'Y')  > 0 
		  Begin
				Return 1;
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
	
	*/
	If(( select count(*) from tblLocal where FacilityID= @facilityID) >0 )
	 begin
		if(select count(*) from tblLocal  with(nolock) where  frNPANXX = @fromNPANXX  and  NPA = @toNPA  and NXX =  right(@toNPANXX,3)  and [Local] = 'Y')  > 0 		  
				Return 1;
	 end
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
					 ((LEC_CP.BASE)=1) AND ((LEC_CP.ISDN)=0))) and LEC_LCA.TELNUM =@toNPANXX ;
	  End
			
	if (@i>0) 
		SET @i=1;
	return @i;
	
END

































