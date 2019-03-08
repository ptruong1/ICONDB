-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_Inmate_by_LastName_or_FirstName_v1] 
	@facilityID int,
	@AccountPhoneNo varchar(12),
	@LastName	varchar(25),
	@FirstName varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	declare @fl int, @locationID int, @InmateID varchar(12), @RelationshipID tinyint;
	SET @locationID =0;
	SET @InmateID  ='0';
	if(@facilityID is null)	SET @facilityID =1;
    -- Insert statements for procedure here
    SET @LastName = LTRIM(rtrim(@lastName));
    SET @FirstName = LTRIM(rtrim(@firstName));
    SET @LastName = ISNULL (@LastName,'');
    SET @FirstName = ISNULL (@firstname,'');

	Select @inmateID = isnull(InmateID,'0'),  @RelationshipID= RelationshipID from tblvisitors where FacilityID= @facilityID and EndUserID=@AccountPhoneNo ;

	if(select count(*) from tblVisitPodSchedule where facilityID = @facilityID) >0
	 begin
		SELECT LastName,FirstName, a.InmateID as PIN, @locationID as LocationID  from leg_Icon.dbo.tblInmate a join tblVisitInmateConfig b
					on ( a.FacilityId = b.FacilityID and a.InmateID = b.InmateID ) where  a.FacilityId =  @facilityID  and a.LastName like  @LastName + '%' and a.FirstName like '%' + @FirstName +'%' and Status=1;
	 end
    else
	 begin
	
		If(@RelationshipID not in (0,7,8) and @inmateID not in ('0',''))
		 Begin
			if(select count(*) from leg_Icon.dbo.tblInmate a join tblVisitInmateConfig b on ( a.FacilityId = b.FacilityID and a.InmateID = b.InmateID ) where  a.FacilityId =  @facilityID and a.InmateID =@InmateID and a.LastName like  @LastName + '%' and a.FirstName like '%' + @FirstName +'%' and Status=1) >0
				SELECT LastName,FirstName, a.InmateID as PIN, b.LocationID  from leg_Icon.dbo.tblInmate a join tblVisitInmateConfig b
					on ( a.FacilityId = b.FacilityID and a.InmateID = b.InmateID ) where  a.FacilityId =  @facilityID and a.InmateID =@InmateID and a.LastName like  @LastName + '%' and a.FirstName like '%' + @FirstName +'%' and Status=1;
			else
				SELECT LastName,FirstName, a.InmateID as PIN, b.LocationID  from leg_Icon.dbo.tblInmate a join tblVisitInmateConfig b
					 on ( a.FacilityId = b.FacilityID and a.InmateID = b.InmateID ) where  a.FacilityId =  @facilityID and a.LastName like  @LastName + '%' and a.FirstName like '%' + @FirstName +'%' and Status=1;
		 End
		Else
		 Begin
			if(select COUNT(*) from leg_Icon.dbo.tblVisitInmateConfig where FacilityID =@facilityID ) =0
			  begin
	        
				if(@LastName <>'' and @LastName <>'""' and @FirstName <>'' and  @FirstName <>'""')
					SELECT LastName,FirstName, InmateID as PIN, @locationID as LocationID  from leg_Icon.dbo.tblInmate where 
						FacilityId =@facilityID and LastName like  @LastName + '%' and FirstName like '%' + @FirstName +'%' and Status=1; 
						--and ((FacilityId in (select distinct facilityID from tblCommRate with(nolock) where BillType ='07')) or (FacilityId in ( select distinct FacilityID  from tblVisitFacilityConfig )))
				Else if(@LastName <>'' and  @LastName <>'""')
					SELECT LastName,FirstName, InmateID as PIN,@locationID as LocationID from leg_Icon.dbo.tblInmate where 
						FacilityId =@facilityID and LastName like  @LastName + '%' and Status=1;
						--and ((FacilityId in (select distinct facilityID from tblCommRate with(nolock) where BillType ='07')) or (FacilityId in ( select distinct FacilityID  from tblVisitFacilityConfig )))
				Else if (@FirstName <>'' and  @FirstName <>'""')
					SELECT LastName,FirstName, InmateID as PIN,@locationID as LocationID  from leg_Icon.dbo.tblInmate where 
						FacilityId =@facilityID and  FirstName like  + @FirstName +'%' and Status=1 ;
						--and ((FacilityId in (select distinct facilityID from tblCommRate with(nolock) where BillType ='07')) or (FacilityId in ( select distinct FacilityID  from tblVisitFacilityConfig )))
				else
					SELECT LastName,FirstName, InmateID as PIN,@locationID as locationID  from leg_Icon.dbo.tblInmate where 
						FacilityId =@facilityID and Status=1;
						--and ((FacilityId in (select distinct facilityID from tblCommRate with(nolock) where BillType ='07')) or (FacilityId in ( select distinct FacilityID  from tblVisitFacilityConfig )))
			  end
			  else
			 Begin				
			
				if(@LastName <>'' and @LastName <>'""' and @FirstName <>'' and  @FirstName <>'""')
					SELECT distinct LastName,FirstName, L1.InmateID as PIN, L2.LocationID 
					from (leg_Icon.dbo.tblInmate L1 join leg_Icon.dbo.tblVisitLocation L2 on l1.FacilityId = L2.FacilityID )
					 join leg_Icon.dbo.tblVisitPhone L3 on (l2.LocationID = l3.LocationID )
					join  leg_Icon.dbo.tblVisitInmateConfig L4 on (l3.LocationID  = L4.locationID and l1.InmateID = l4.InmateID  )
					where 	
						L1.FacilityId =@facilityID and 				
						LastName like  @LastName + '%' and 
						FirstName like '%' + @FirstName +'%' and L1.Status=1
						--and ((L1.FacilityId in (select distinct facilityID from tblCommRate with(nolock) where BillType ='07')) or (L1.FacilityId in ( select distinct FacilityID  from tblVisitFacilityConfig )))
				Else if(@LastName <>'' and @LastName <>'""')
					SELECT distinct LastName,FirstName, L1.InmateID as PIN, L2.LocationID 
					from (leg_Icon.dbo.tblInmate L1 join leg_Icon.dbo.tblVisitLocation L2 on l1.FacilityId = L2.FacilityID )
					 join leg_Icon.dbo.tblVisitPhone L3 on (l2.LocationID = l3.LocationID )
					join  leg_Icon.dbo.tblVisitInmateConfig L4 on (l3.LocationID  = L4.locationID and l1.InmateID = l4.InmateID  )
					where
						L1.FacilityId =@facilityID and  					
						LastName like  @LastName + '%' and L1.Status=1;
						--and ((L1.FacilityId in (select distinct facilityID from tblCommRate with(nolock) where BillType ='07')) or (L1.FacilityId in ( select distinct FacilityID  from tblVisitFacilityConfig )))
				Else if (@FirstName <>'' and  @FirstName <>'""')
					SELECT distinct LastName,FirstName, L1.InmateID as PIN, L2.LocationID 
					from (leg_Icon.dbo.tblInmate L1 join leg_Icon.dbo.tblVisitLocation L2 on l1.FacilityId = L2.FacilityID )
					 join leg_Icon.dbo.tblVisitPhone L3 on (l2.LocationID = l3.LocationID )
					join  leg_Icon.dbo.tblVisitInmateConfig L4 on (l3.LocationID  = L4.locationID and l1.InmateID = l4.InmateID  )
					WHERE					
						L1.FacilityId =@facilityID and 
						FirstName like '%' + @FirstName +'%' and L1.Status=1
						--and ((L1.FacilityId in (select distinct facilityID from tblCommRate with(nolock) where BillType ='07')) or (L1.FacilityId in ( select distinct FacilityID  from tblVisitFacilityConfig )))
				else
					SELECT distinct LastName,FirstName, L1.InmateID as PIN, L2.LocationID 
					from (leg_Icon.dbo.tblInmate L1 join leg_Icon.dbo.tblVisitLocation L2 on l1.FacilityId = L2.FacilityID )
					 join leg_Icon.dbo.tblVisitPhone L3 on (l2.LocationID = l3.LocationID )
					join  leg_Icon.dbo.tblVisitInmateConfig L4 on (l3.LocationID  = L4.locationID and l1.InmateID = l4.InmateID  )
					where 
						L1.FacilityId =@facilityID and L1.Status=1;
						--and ((L1.FacilityId in (select distinct facilityID from tblCommRate with(nolock) where BillType ='07')) or (L1.FacilityId in ( select distinct FacilityID  from tblVisitFacilityConfig )))
			 end
		 
	
	
		End
	 
	End
		
END

