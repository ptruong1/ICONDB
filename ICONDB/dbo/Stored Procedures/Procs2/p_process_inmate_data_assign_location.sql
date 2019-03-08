CREATE PROCEDURE [dbo].[p_process_inmate_data_assign_location] 
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
@HairColore		varchar(20),
@Sex		varchar(1)
AS
SET NOCOUNT ON
Declare @facilityId int, @flatform int, @sendStatus tinyint, @autoPin tinyint, @AtCurrLoc varchar(20), @i tinyint, @locationID int, @PIN varchar(12),@Status smallint ;
Declare @OldPIN varchar(12) , @DivisionID int, @Div varchar(25), @Loc varchar(25); 
SET @OldPIN = '';
set @facilityId =1;
SET @flatform = 2;
SET @sendStatus =0;
SET @autoPin =0;
SET @AtCurrLoc ='';
SET @locationID =0;
SET @Status =0;
select @facilityId = FacilityID ,@sendStatus= isnull(inmateStatus,0),@autoPin= isnull(autoPin ,0) from tblFacilityOption with(nolock)  where FTPfolderName = @facilityFolder;
    /*
	exec [dbo].[p_process_inmate_data_with_autoPIN1]
					@InmateID	,
					@bookingID	,
					@firstName	,
					@lastName	,
					@MidName	,
					1,
					@facilityID,
					@SendStatus    ;
	

    select @AtCurrLoc = isnull(AtLocation,''),@i= COUNT(*) from  tblVisitInmateConfig	with(nolock)
						where FacilityID =@facilityId and InmateID =@InmateID group by AtLocation ;
		
    select @locationID = isnull(locationID,0) from tblVisitLocation with(nolock) where FacilityID = @facilityId and LocationName = @AtLocation ;
    if(@locationID =0)
		select @locationID = isnull(locationID,0) from tblVisitLocation with(nolock) where FacilityID = @facilityId and LocationName like @AtLocation + '%' ;
    if(@locationID =0)
		select @locationID = isnull(locationID,0) from tblVisitPhone  with(nolock) where FacilityID = @facilityId and StationID  like @AtLocation + '%' ;
	
   if (@i >0 ) 
    begin
		if (@AtCurrLoc <> @AtLocation )
			update tblVisitInmateConfig set AtLocation = @AtLocation, LocationID =@locationID, ModifyDate= getdate() where FacilityID =@facilityId and InmateID =@InmateID;
	end
   else
    begin  
		if(select count(*) from 	leg_Icon.dbo.tblVisitInmateConfig where facilityID = @facilityId and inmateID = @inmateID)=0
			Insert leg_Icon.dbo.tblVisitInmateConfig (InmateID,FacilityID,AtLocation,LocationID, InputDate)
					 values(@InmateID ,@facilityId,@AtLocation,@locationID,getdate());
	end
	*/

	if(@BookingID <>'' and @BookingID is not null )
	 begin
		if(select count(*) from tblInmateInfo with(nolock)  where BookingNo= @BookingID and PIN = @InmateID and FacilityID = @facilityId) =0		
		 begin
			insert  tblInmateInfo (BookingNo, PIN, FacilityID, BirthDate,Location, Address1,City, State,Zip, BookingDate,Sex)
					values(@BookingID , @InmateID , @facilityId, @DOB, @AtLocation + @At_Cell,@Address,@City,@State,@zip,@BookingDate,@Sex);
		 end
		 if @ChargeDescipt <> '' and (select count(*) from  tblInmateBookInfo with(nolock) where BookingNo= @BookingID and PIN = @InmateID and FacilityID = @facilityId and ChargeCode=@chargeCode) =0
			 insert  tblInmateBookInfo (BookingNO,FacilityID ,PIN , chargecode,ChargeDescript,  BAILAMOUNT , ApperanceDate,ReleaseDate)
					values(@BookingID, @facilityId, @InmateID,@chargecode,@ChargeDescipt , @BailAmount,@CounrtDate,@ReleaseDate) ;					

     end
	 If(@At_Cell <>'' and @InmateID <>''  )
	  begin
		SET @locationID =0;
		SET @DivisionID=0;
		SET @Div = left(@At_Cell,2)
		SET @Loc = SUBSTRING(@At_Cell,4,2);
		Select @DivisionID = DivisionID from tblfacilityDivision with(nolock) where DepartmentName =@div and FacilityID= @facilityId;
		select @locationID = locationID from tblfacilitylocation with(nolock) where Descript  = @Loc  and DivisionID = @DivisionID;
		if(@DivisionID >0) 
			Update tblinmate set AssignToDivision = @DivisionID, AssignToLocation = null, AssignToStation =null where facilityID = @facilityId and InmateID = @InmateID;
		if(@locationID >0)
			Update tblinmate set AssignToLocation = @LocationID where facilityID = @facilityId and InmateID = @InmateID;	
	  end



