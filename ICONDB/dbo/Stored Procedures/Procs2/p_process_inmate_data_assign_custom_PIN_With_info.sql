
CREATE PROCEDURE [dbo].[p_process_inmate_data_assign_custom_PIN_With_info]
@InmateID	varchar(12),
@firstName	varchar(25),
@lastName	varchar(25),
@MidName	varchar(20),
@facilityFolder	varchar(20),
@BookingID varchar(12),
@BookingDate	varchar(12),
@DOB	varchar(10),
@CounrtDate	varchar(12),
@BailAmount	numeric(10,2),
@AtLocation	varchar(20),
@At_Cell	varchar(20),
@ReleaseDate varchar(12),
@AtInd		varchar(12),
@Address	varchar(100),
@City		Varchar(30),
@State		varchar(2),
@Zip		varchar(5),
@chargeCode varchar(20),
@ChargeDescipt varchar(200),
@adminSEG		varchar(20)
AS
SET NOCOUNT ON
Declare @facilityId int, @flatform int, @sendStatus tinyint, @autoPin tinyint, @AtCurrLoc varchar(20), @i tinyint, @locationID int, @PIN varchar(12),@Status smallint ;
Declare @OldPIN varchar(12); 
SET @OldPIN = '';
set @facilityId =1;
SET @flatform = 2;
SET @sendStatus =0;
SET @autoPin =0;
SET @AtCurrLoc ='';
SET @locationID =0;
SET @Status =0;
select @facilityId = FacilityID ,@sendStatus= isnull(inmateStatus,0),@autoPin= isnull(autoPin ,0) from tblFacilityOption with(nolock)  where FTPfolderName = @facilityFolder;
--if(@DOB <> '' and @DOB is not null)
--	SET @PIN = @InmateID + left(@DOB,2) + SUBSTRING(@DOB,4,2);
--Else
--	SET @PIN = @InmateID;
--select @Status = status, @OldPIN = PIN from tblinmate where facilityID = @facilityID and inmateID = @inmateID ;
--if(@Status  =0)
--	insert tblinmate(FacilityId , InmateID,LastName,FirstName,DOB,PIN,inputdate,Status,UserName)
--			values(@facilityId, @InmateID , @lastName, @firstName, @DOB, @PIN ,getdate(),1, 'FTPfile') ;
--else if(@Status  >1)
-- begin
--	if(@PIN = @OldPIN)
--		Update  tblinmate set [status] = 1, LastName= @lastName, FirstName= @FirstName,ReBook=1, RebookDate= getdate(), ModifyDate= getdate()  where facilityID = @facilityID and inmateID = @inmateID and pin = @PIN ;
--	else
--		Update  tblinmate set [status] = 1, LastName= @lastName, FirstName= @FirstName,ReBook=1, RebookDate= getdate(), ModifyDate= getdate() where facilityID = @facilityID and inmateID = @inmateID;
-- end
--else
--	Update  tblinmate SET LastName= @lastName, FirstName= @FirstName, ModifyDate= getdate() where facilityID = @facilityID and inmateID = @inmateID and pin = @PIN ;

exec [dbo].[p_process_inmate_data_with_autoPIN1]
					@InmateID	,
					@bookingID	,
					@firstName	,
					@lastName	,
					@MidName	,
					1,
					@facilityID,
					@SendStatus    

if(@AtLocation <>'')
Begin 
	if(@adminSEG <>'')
		SET @AtLocation = @adminSEG;
    select @AtCurrLoc = isnull(AtLocation,''),@i= COUNT(AtLocation) from  tblVisitInmateConfig	with(nolock)
		where FacilityID =@facilityId and InmateID =@InmateID group by AtLocation ;
		
    select @locationID = isnull(locationID,0) from tblVisitLocation with(nolock) where FacilityID = @facilityId and LocationName = @AtLocation ;
    if(@locationID =0)
		select @locationID = isnull(locationID,0) from tblVisitLocation with(nolock) where FacilityID = @facilityId and LocationName like @AtLocation + '%' ;
    if(@locationID =0)
		select @locationID = isnull(locationID,0) from tblVisitPhone  with(nolock) where FacilityID = @facilityId and StationID  like @AtLocation + '%' ;
	
   if (@i >0 ) 
    begin
		if (@AtCurrLoc <> @AtLocation )
			update tblVisitInmateConfig set AtLocation = @AtLocation, LocationID =@locationID where FacilityID =@facilityId and InmateID =@InmateID;
	end
   else
    begin  
		if(select count(*) from 	leg_Icon.dbo.tblVisitInmateConfig where facilityID = @facilityId and inmateID = @inmateID)=0
			Insert leg_Icon.dbo.tblVisitInmateConfig (InmateID,FacilityID,AtLocation,LocationID)
					 values(@InmateID ,@facilityId,@AtLocation,@locationID);
	end

	if(@BookingID <>'' and @BookingID is not null )
	 begin
		if(select count(*) from tblInmateInfo with(nolock)  where BookingNo= @BookingID and PIN = @PIN and FacilityID = @facilityId) =0		
		 begin
			insert  tblInmateInfo (BookingNo, PIN, FacilityID, BirthDate,Location, Address1,City, State,Zip, BookingDate, InmateID)
					values(@BookingID , @InmateID , @facilityId, @DOB, @AtLocation + @At_Cell,@Address,@City,@State,@zip,@BookingDate, @inmateID);
		 end
		 if(select count(*) from  tblInmateBookInfo with(nolock) where BookingNo= @BookingID and PIN = @PIN and FacilityID = @facilityId and ChargeCode=@chargeCode and ChargeDescript = @ChargeDescipt) =0
			 insert  tblInmateBookInfo (BookingNO,FacilityID ,PIN , chargecode,ChargeDescript,  BAILAMOUNT , ApperanceDate,ReleaseDate,inmateID)
					values(@BookingID, @facilityId, @PIN,@chargecode,@ChargeDescipt , @BailAmount,@CounrtDate,@ReleaseDate,@InmateID) ;
						
	 end
	 

end



