
CREATE PROCEDURE [dbo].[p_process_inmate_data_new_v2]
@facilityFolder	varchar(20),
@InmateID	varchar(12),
@PIN	varchar(12),
@firstName	varchar(25),
@lastName	varchar(25),
@MidName	varchar(20),
@bookingNo		varchar(12),
@bookingDate	varchar(12),
@Sex			varchar(1),
@Race			varchar(1),
@DOB			varchar(12),
@SSN		    varchar(9),
@Address        varchar(100),
@City			varchar(30),
@State		    varchar(20),
@Zip			varchar(5),
@DivName		varchar(20),
@LocName		varchar(20),
@AtCurrLoc		varchar(30),
@status		tinyint

AS
SET NOCOUNT ON
Declare @facilityId int, @flatform int, @sendStatus tinyint, @autoPin tinyint, @i smallint,@locationID int, @AtLocation varchar(30),@Ext varchar(12), @visitPerDay tinyint;
set @facilityId =1;
SET @flatform = 2;
SET @sendStatus =0;
SET @autoPin =0;
SET @locationID =0;
SET  @visitPerDay  =0;
if(@Sex ='' or @Sex is null)
	SET @Sex='U';

select @facilityId = FacilityID ,@sendStatus= isnull(inmateStatus,0),@autoPin= isnull(autoPin ,0) from tblFacilityOption  where FTPfolderName = @facilityFolder	

if(@facilityId =761 and @DOB <>'')
 begin
	SET @PIN =right(replace (@DOB,'/',''),4)
 end

SET @InmateID = replace(@InmateID,'"','');
	SET @InmateID = RTRIM(ltrim(@InmateID));
	SET @PIN = replace(@PIN,'"','');

	set @PIN = ltrim(rtrim(@PIN));
	if(ISNUMERIC(@PIN)=0  AND LEN(@PIN)>0) 
		Return 0;
	set @firstName	 = ltrim(@firstName);
	SET @lastName = ltrim(@lastName);
	SET @firstName = replace(@firstName,'"','');
	SET @lastName = replace(@lastName,'"','');
	if (len(@PIN) =3)  SET @PIN = '0' + @PIN ;
	if (len(@PIN) =2)  SET @PIN = '00' + @PIN ;
	If(@facilityId =577) 
	  begin
	   SET @InmateID =@PIN;
	   SET  @visitPerDay =1;
	  end
	if(@PIN = '' or @PIN is null) SET @PIN = @InmateID;
	
	If (((select count(*) from  tblInmate  where FacilityID =   @facilityID and InmateID= @InmateID) =  0)  and @PIN <>'' )
 	  Begin
		INSERT tblInmate(InmateID   ,    LastName       ,     FirstName ,MidName  ,  Status, DNIRestrict, DateTimeRestrict,    DNILimit ,FacilityId,   PIN,inputdate, modifyDate , DOB ,SEX )
			Values( @InmateID,@lastName, @FirstName,@MidName,@status, 0,0,0, @facilityID,  @PIN,getdate(),getdate(), @DOB , @Sex);

	  End
	else
	 Begin
		if (@status=1 or @sendStatus =1)
		 begin
			UPDATE tblInmate SET  [status] = 1, modifyDate = getdate() ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName, ReBook=1,RebookDate=GETDATE() where [Status] >1 and inmateID = @InmateID and FacilityID = @facilityID ;
			UPDATE tblInmate SET  [status] = 1 , modifyDate = getdate() ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName where [Status] =1 and inmateID = @InmateID and FacilityID = @facilityID  ;
		 end
		else
			UPDATE tblInmate SET  [status] = @status ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName, modifyDate = getdate(),ReBook=0 ,RebookDate=null  where  inmateID = @InmateID and FacilityID = @facilityID ;
	 End
	 
if( @AtCurrLoc<>'')
Begin 
   if(@facilityId = 675) -- hardcode for long beach
	 begin
		if (@AtCurrLoc in ('TKM','TKF') or @Sex ='F')
		 begin
			set @AtCurrLoc ='INMATE FEMALE';
			set @Ext = 'ICON-LBC-03';
		 end
		ELSE if (@AtCurrLoc in ('DORM'))
		 begin
			set @AtCurrLoc = 'TRUSTEE';
			SET @Ext ='ICON-TRUSTEE';
		 end
		ELSE
		 begin
			set @AtCurrLoc = 'INMATE MALE';
			set @Ext = 'ICON-LBC-01';
		 end
			
	 end


 
   -----------------------------------New Edit on 1/31/2018-------------
   	
	if(@facilityId = 784)  --- hardcode for coffee
	 begin
		if( @AtCurrLoc like '%WCB%')
			Set @locationID =7727;
		Else if( @AtCurrLoc like '%ECB%')
			Set @locationID =7726;
		Else if( @AtCurrLoc like '%1')
			SET @locationID =7729;
		Else if( @AtCurrLoc like '%2')
			SET @locationID =7730;
		Else if(@AtCurrLoc like '%4')
			SET @locationID =7731;	

        if(@AtCurrLoc like '%ISO%')
			SET @locationID =0;	
	end
   Else
    begin		
	   select @locationID =  a.LocationID FROM tblVisitLocation a with(nolock), tblVisitPhone b with(nolock) where a.facilityID = b.facilityID
			and a.LocationID = b.LocationID and b.StationType =2 and a.FacilityID = @facilityId and (LocationName = @AtCurrLoc or LocationName = @LocName );
	   if(@locationID =0)
			select @locationID =  a.LocationID FROM tblVisitLocation a with(nolock), tblVisitPhone b with(nolock) where a.facilityID = b.facilityID
			and a.LocationID = b.LocationID and b.StationType =2 and a.FacilityID = @facilityId  and  (LocationName like @AtCurrLoc + '%' );
	   if(@locationID =0)
			select @locationID =  a.LocationID FROM tblVisitLocation a with(nolock), tblVisitPhone b with(nolock) where a.facilityID = b.facilityID
			and a.LocationID = b.LocationID and b.StationType =2 and a.FacilityID = @facilityId  and  ( LocationName like @LocName + '%');
   
	   if(@locationID =0)
			select @locationID =  a.LocationID FROM tblVisitLocation a with(nolock), tblVisitPhone b with(nolock) where a.facilityID = b.facilityID
			and a.LocationID = b.LocationID and b.StationType =2 and a.FacilityID = @facilityId  and  (LocationName = left(@LocName,3));
	   if(@locationID =0)
			select @locationID =  a.LocationID FROM tblVisitLocation a with(nolock), tblVisitPhone b with(nolock) where a.facilityID = b.facilityID
			and a.LocationID = b.LocationID and b.StationType =2 and a.FacilityID = @facilityId  and  (LocationName = left(@LocName,4));
  
	   if(@locationID =0)
			select @locationID = isnull(locationID,0) from tblVisitPhone  with(nolock) where FacilityID = @facilityId and StationType =2 and StationID   like '%'+ @AtCurrLoc + '%' ;

		--- Hard code for TUOLUMNE -747
		 If ( @AtCurrLoc like 'TUOLUMNE J%'  and @locationID =0)
			SET @locationID =7643; 
		 Else If (@AtCurrLoc like 'TUOLUMNE N%' )
			SET @locationID =7640; 
     end  
  
	select  @AtLocation = isnull(AtLocation,''),@i= COUNT(*) from  tblVisitInmateConfig	with(nolock)
				where FacilityID =@facilityId and InmateID =@InmateID group by AtLocation ;
		
   if (@i >0 ) 
    begin
		  if (@locationID >0)
			 update tblVisitInmateConfig set AtLocation = @AtCurrLoc, LocationID =@locationID, ExtID =@Ext, ModifyDate = getdate() where FacilityID =@facilityId and InmateID =@InmateID;
          If (@AtCurrLoc <>'' and @locationID =0)
			  update tblVisitInmateConfig set AtLocation = @AtCurrLoc, ExtID =@Ext, ModifyDate = getdate() where FacilityID =@facilityId and InmateID =@InmateID;
		  Update tblVisitEnduserSchedule  set LocationID = @locationID , Note ='Inmate Moved'  where FacilityID =@facilityId and InmateID =@InmateID and status in (1,2);;
	end
   else
    begin   	
		Insert leg_Icon.dbo.tblVisitInmateConfig (InmateID,FacilityID,AtLocation,ExtID , LocationID, VisitPerDay  )
					values(@InmateID ,@facilityId,@AtCurrLoc,@Ext,@locationID,@visitPerDay);
	end

	
	if ((select count(*) from  tblInmateInfo  with(nolock) where PIN =@PIN and FacilityID=@facilityID and BookingNo = @BookingNo )  =0 and @bookingNo <>'0' and @bookingNo <>'')
	begin
		insert tblInmateInfo  (FacilityID , PIN, BookingNo , BookingDate , BirthDate, FullName,ssn, Address1, city,state,zip, InmateID )
				values (@facilityID, @PIN,  @BookingNo, @BookingDate, @DOB,   @firstName + ' ' + @lastName, @ssn, @address, @city, @state,@zip, @InmateID)
	end	


	return @@error;
end
