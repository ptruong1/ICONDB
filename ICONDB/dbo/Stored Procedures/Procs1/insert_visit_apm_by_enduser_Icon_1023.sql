-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[insert_visit_apm_by_enduser_Icon_1023]
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
@VisitorID int,
@StationID varchar(25),
@Relationship varchar(20),
@ApmNo		varchar(11) OUTPUT,
@RoomID int OUTPUT
AS
BEGIN

	SET NOCOUNT ON;
	declare @currentDate as datetime, @locationID int, @recordOpt  varchar(1);
    set  @currentDate=GETDATE();
	SET @recordOpt ='Y';
    --set @ApmNo= right(CONVERT(varchar(6),@currentDate,12),4)+ LEFT( REPLACE( convert(varchar(15),@currentDate,14),':',''),6)
	DECLARE	@return_value int,		@visitConfirmID int ;
	Select @locationID = locationID from tblVisitInmateConfig where facilityID = @FacilityID and InmateID =@InmateID ;
	Select @recordOpt = isnull(recordOpt,'Y') from  tblVisitFacilityConfig with(nolock)  where  facilityID =facilityID;
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
    [status], 
    CreatedBy ,  
    visitType, 
    VisitorID,
    StationID,
    Relationship,locationID ,RecordOpt,
    ChatServerIP,
    TotalCharge)
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
	@Status, 
	@CreatedBy ,
	@visitType ,
	@VisitorID,
	@StationID,
	@Relationship,@locationID , @recordOpt,
	(select MediaServerIP from dbo.tblAVChatWebsite where @FacilityID = facilityID),
	0)
	SET      @ApmNo =   @visitConfirmID
	SET		 @RoomID = @visitConfirmID

	update  tblVisitInmateConfig set VisitRemain =VisitRemain-1 where FacilityID= @FacilityID and InmateID =@InmateID ;

END

