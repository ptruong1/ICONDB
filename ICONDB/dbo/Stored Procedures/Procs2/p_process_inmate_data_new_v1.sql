
CREATE PROCEDURE [dbo].[p_process_inmate_data_new_v1]
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
@DivName		varchar(20),
@LocName		varchar(20),
@AtCurrLoc		varchar(30),
@status		tinyint

AS
SET NOCOUNT ON;
Declare @facilityId int, @flatform int, @sendStatus tinyint, @autoPin tinyint, @i smallint,@locationID int, @AtLocation varchar(30),@Ext varchar(12), 
@VisitPerDay tinyint, @visitPerWeek tinyint, @VisitPerMonth tinyint, @curLocationID int, @AssignLocationOpt  tinyint, @PhoneLocationID int ;
set @facilityId =1;
SET @flatform = 2;
SET @sendStatus =0;
SET @autoPin =0;
SET @locationID =0;
SET @VisitPerDay =1;
SET @visitPerWeek =4;
SET @VisitPerMonth=12;
SET @curLocationID =0;
SET @AssignLocationOpt  =0;
if(@Sex ='' or @Sex is null)
	SET @Sex='U';

select @facilityId = FacilityID ,@sendStatus= isnull(inmateStatus,0),@autoPin= isnull(autoPin ,0), @AssignLocationOpt  = isnull(AssignLocationOpt ,0) from tblFacilityOption  where FTPfolderName = @facilityFolder	;
----edit for phone location auto update
if(@AssignLocationOpt  =1)
 begin
	select @PhoneLocationID = c.locationID from tblfacility a, tblfacilityDivision b , tblFacilityLocation c where a.FacilityID = b.FacilityID and b.DivisionID = c.DivisionID and a.FacilityID = @facilityId and c.Descript = @AtCurrLoc;
 end

if(@facilityId =761 and @DOB <>'')
 begin
	SET @PIN =right(replace (@DOB,'/',''),4);
 end
Else if(@facilityId =803 and @DOB <>'')
 begin
	set @PIN = @InmateID + left(@DOB,2) + SUBSTRING(@DOB,4,2);
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
If(@facilityId =577) SET @InmateID =@PIN;

Select @VisitPerDay =isnull(VisitPerDay,0), @visitPerWeek = isnull(visitPerWeek,0), @visitPerMonth = isnull(visitPerMonth,0)  from tblVisitFacilityConfig with(nolock) where facilityID =@facilityID;

If(@autoPin =1 )
 begin

	EXEC p_process_inmate_data_with_autoPIN_v2
	     				@InmateID	,
						@bookingNo	,
						@firstName	,
						@lastName	,
						@MidName	,
						@status		,
						@facilityID	,
						@DOB ,
						@SEX  ,
						@PIN   OUTPUT

 end
Else
 begin
	
	If (((select count(*) from  tblInmate  where  FacilityID =   @facilityID and InmateID= @InmateID  ) =  0)  and @PIN >'0' )
 		Begin
			 INSERT tblInmate(InmateID   ,    LastName       ,     FirstName ,MidName  ,  Status, DNIRestrict, DateTimeRestrict,    DNILimit ,FacilityId,   PIN,inputdate, modifyDate , DOB ,SEX, AssignToLocation )
					Values( @InmateID,@lastName, @FirstName,@MidName,@status, 0,0,0, @facilityID,  @PIN,getdate(),getdate(), @DOB , @Sex,  @PhoneLocationID);

		End
	else
		Begin
			if (@sendStatus =1 or @Status =1)
			  begin
				if (@facilityID = 675 or @facilityID = 807)
				 begin
					UPDATE tblInmate SET  [status] = 1 , modifyDate = getdate() ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName, PIN = @PIN where  inmateID = @InmateID and FacilityID = @facilityID ;
				 end
				else
				begin
					if( @AssignLocationOpt =0)
					 begin
						UPDATE tblInmate SET  [status] = 1 , modifyDate = getdate() ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName, ReBook=1,RebookDate=GETDATE() where [Status] >1 and inmateID = @InmateID and FacilityID = @facilityID;
						UPDATE tblInmate SET  modifyDate = getdate() ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName where [Status] =1 and inmateID = @InmateID and FacilityID = @facilityID ;
					 end
					else 
					 begin
						UPDATE tblInmate SET  [status] = 1 , modifyDate = getdate() ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName, ReBook=1,RebookDate=GETDATE(), AssignToLocation = @PhoneLocationID where [Status] >1 and inmateID = @InmateID and FacilityID = @facilityID;-- and pin = @PIN ;
						UPDATE tblInmate SET  modifyDate = getdate() ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName,  AssignToLocation = @PhoneLocationID where [Status] =1 and inmateID = @InmateID and FacilityID = @facilityID ;
					 end
				end
			 end
			else
				UPDATE tblInmate SET  [status] = @status ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName, modifyDate = getdate(),ReBook=0 ,RebookDate=null,  AssignToLocation = @PhoneLocationID  where  inmateID = @InmateID and FacilityID = @facilityID; 
		End
 end

if(@PIN = '' or @PIN is null) 
 Begin
		SET @PIN = @InmateID;
		SET @VisitPerDay =1;
 end


if( @AtCurrLoc<>'')
Begin 
   if(@facilityId = 675)
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
   select  @AtLocation = isnull(AtLocation,''),@i= COUNT(*) from  tblVisitInmateConfig	with(nolock)
		where FacilityID =@facilityId and InmateID =@InmateID group by AtLocation ;
   select @curLocationID =locationID  from  tblVisitInmateConfig	with(nolock) where FacilityID =@facilityId and InmateID =@InmateID ;		
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
        
   If ( @AtCurrLoc like 'TUOLUMNE J%'  and @locationID =0)
		SET @locationID =7643;
    Else If (@AtCurrLoc like 'TUOLUMNE N%' )
		SET @locationID =7640;  
		
   if (@i >0 ) 
    begin
		if ((@AtCurrLoc <> @AtLocation ) or(@curLocationID <> @locationID and  @locationID >0))
		begin
			update tblVisitInmateConfig set AtLocation = @AtCurrLoc, LocationID =@locationID, ExtID =@Ext, ModifyDate = getdate() where FacilityID =@facilityId and InmateID =@InmateID;
			Update tblVisitEnduserSchedule  set LocationID = @locationID , Note ='Inmate Moved'  where FacilityID =@facilityId and InmateID =@InmateID;
		end
	end
   else
    begin   	
		Insert leg_Icon.dbo.tblVisitInmateConfig (InmateID,FacilityID,AtLocation,ExtID , LocationID, VisitPerDay , VisitPerWeek, VisitPerMonth )
					values(@InmateID ,@facilityId,@AtCurrLoc,@Ext,@locationID,@VisitPerDay,@visitPerWeek, @VisitPerMonth);
	end

end

if( @bookingNo <>'0' and @bookingNo <>'') --- Modify on 10/2/2017
 begin
	 if ((select count(*) from  tblInmateInfo  with(nolock) where InmateID =@InmateID and FacilityID=@facilityID and BookingNo = @BookingNo )  =0 )
		begin
			insert tblInmateInfo  (FacilityID , InmateID, PIN, BookingNo , BookingDate , BirthDate, FullName )
					values (@facilityID, @InmateID,@PIN,  @BookingNo, @BookingDate, @DOB,   @firstName + ' ' + @lastName)
		end	
 end

 return @@error;
