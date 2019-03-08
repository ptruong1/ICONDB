-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[insert_visit_apm_by_enduser_Icon_10052015]
@FacilityID int , 
@InmateID varchar(12) , 
@InmateName varchar(40),  
@EndUserID varchar(12),
@VisitorName varchar(25), 
@RequestedTime datetime,
@ApprovedTime datetime,
@ApprovedBy varchar(25),
@ApmDate   Datetime,  
@ApmTime  varchar(5),
@CreatedBy  varchar(25) ,  
@visitType tinyint, 
@Status tinyint,
@LimitTime int,
@RecordOpt varchar(1),
@VisitorID int,
@StationID varchar(25),
@Relationship varchar(20),
@VisitorEmail varchar(50),
@VisitorAddress varchar(50),
@VisitorCity varchar(25),
@VisitorState Int,
@VisitorDriverID varchar(20),
@VisitorZipCode varchar(5),
@VisitorPrimaryPhone varchar(10),
@VisitorAlterPhone varchar(10),
@RelationShipID int,
@ApmNo		varchar(11) OUTPUT,
@RoomID int OUTPUT
AS
BEGIN

	SET NOCOUNT ON;
	declare @currentDate as datetime, @locationID int,  @ChatServerIP varchar(30),@visitLocationID int ;
    set  @currentDate=GETDATE();
	SET @visitLocationID  =0;
	SET @ChatServerIP = 'v1.legacyinmate.com';
    --set @ApmNo= right(CONVERT(varchar(6),@currentDate,12),4)+ LEFT( REPLACE( convert(varchar(15),@currentDate,14),':',''),6)
	DECLARE	@return_value int,		@visitConfirmID int ;
	Select @locationID = locationID from tblVisitInmateConfig with(nolock) where FacilityID= @FacilityID and InmateID =@InmateID ;
	select  @ChatServerIP = ChatServerIP from dbo.tblVisitPhoneServer  with(nolock) where @FacilityID = facilityID;
	Select @recordOpt = isnull(recordOpt,'Y') from  tblVisitFacilityConfig with(nolock)  where  facilityID =facilityID;
	SET @visitLocationID = [dbo].[fn_get_onsite_visiting_location_by_inmate](@facilityID ,@inmateID);	
	EXEC	@return_value = [dbo].[p_create_visitConfirmID]
			@visitConfirmID = @visitConfirmID OUTPUT	;
	Insert INTO [tblVisitEnduserSchedule] 
	( 
	RoomID ,
	ApmNo,
	FacilityID , 
	InmateID , 
	InmateName ,  
	EndUserID,
	RequestedTime , 
	RequestBy ,
	ApprovedTime,
	ApprovedBy,
    ApmDate ,  
    ApmTime, 
    LimitTime,
    RecordOpt,
    [status], 
    CreatedBy ,  
    visitType, 
    VisitorID,
    StationID,
    Relationship,locationID ,
    ChatServerIP,
    TotalCharge,
	visitLocationID )
	Values
	(
	@visitConfirmID,
	@visitConfirmID,
	@FacilityID , 
	@InmateID ,
	@InmateName ,
	@EndUserID ,
	@RequestedTime,
	1,
	@ApprovedTime,
	@ApprovedBy,
	@ApmDate,
	@ApmTime ,
	@LimitTime,
	@RecordOpt,
	@Status, 
	@CreatedBy ,
	@visitType ,
	@VisitorID,
	@StationID,
	@Relationship,@locationID ,
	@ChatServerIP,
	0,
	@visitLocationID )
	SET      @ApmNo =   @visitConfirmID ;
	SET		 @RoomID = @visitConfirmID ;
	
	Update tblvisitors 	set 
	phone1 = @EndUserID,
	EndUserID= @EndUserID , 
	Email= @VisitorEmail,
	Address = @VisitorAddress ,
	City = @VisitorCity ,
	State = @VisitorState ,
	DriverLicense = @VisitorDriverID ,
	Zipcode =@VisitorZipCode,
	Phone2 =@VisitorAlterPhone ,
	RelationshipID= @RelationShipID,
	Relationship = @Relationship,
	CountryId = 203
	
	where visitorID =@VisitorID;
	update  tblVisitInmateConfig set VisitRemain =VisitRemain-1 where FacilityID= @FacilityID and InmateID =@InmateID ;

END

