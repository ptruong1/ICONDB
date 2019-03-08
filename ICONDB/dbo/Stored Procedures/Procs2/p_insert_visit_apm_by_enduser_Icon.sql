-- =============================================
-- Author:		<Author,,Name> p
-- Modified date: 2/20/2019
-- Description:	modify to prevent overbook by visitor area
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_visit_apm_by_enduser_Icon] 
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
@VisitorEmail varchar(50),
@UserIP varchar(25),
@ApmNo		varchar(11) OUTPUT,
@RoomID int OUTPUT
AS
BEGIN

	SET NOCOUNT ON;
	declare @currentDate as datetime, @locationID int,  @ChatServerIP varchar(30), @NumOfStations smallint, @currentApm smallint, @availStaion smallint ;
	Declare  @UserAction varchar(100),@ActTime datetime, @RecordOpt char(1), @ScheduleTime time(0), @visitLocationID int;

    set  @currentDate=GETDATE();
	SET  @RecordOpt ='Y';
	SET @ChatServerIP = 'v1.legacyinmate.com';
	SET @NumOfStations =0;
	SET @currentApm =0;
    --set @ApmNo= right(CONVERT(varchar(6),@currentDate,12),4)+ LEFT( REPLACE( convert(varchar(15),@currentDate,14),':',''),6)
	DECLARE	@return_value int,		@visitConfirmID int ;
	Select @locationID = locationID from tblVisitInmateConfig with(nolock) where FacilityID= @FacilityID and InmateID =@InmateID ;
	select  @ChatServerIP = ChatServerIP from dbo.tblVisitPhoneServer  with(nolock) where facilityID = @FacilityID;
	EXEC	@return_value = [dbo].[p_create_visitConfirmID]
			@visitConfirmID = @visitConfirmID OUTPUT	;
	Select @RecordOpt = recordOpt from tblVisitFacilityconfig with(nolock) where facilityID = @FacilityID;
	if(@RecordOpt ='Y')
		Select @RecordOpt =isnull( recordOpt,'Y') from tblVisitors with(nolock)  where VisitorID =@VisitorID;

	--SELECT @NumOfStations = [dbo].[fn_get_number_station] (	@FacilityID,@locationID ,''   ,@VisitType) ;
				
    --SET @availStaion = [dbo].[fn_determine_num_of_kiosk_by_schedule_time] (@facilityID  , @ApmDate, @locationID ,	@ApmTime, @NumOfStations,@VisitType);
    SET @ScheduleTime = CAST( @apmtime as time(0));
    SET @availStaion = [dbo].[fn_check_avail_by_schedule_time_with_dur] (@facilityID,	@ApmDate ,	@locationID ,	@ApmTime,	@visitType,@LimitTime);
	SET @visitLocationID = [dbo].[fn_get_onsite_visiting_location_by_inmate](@facilityID ,@inmateID);
	if(	@availStaion >0 )
	Begin
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
		Relationship,locationID ,
		ChatServerIP,
		TotalCharge,
		visitLocationID)
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
		@Relationship,@locationID ,
		@ChatServerIP,
		0,
		@visitLocationID)
		SET      @ApmNo =   @visitConfirmID ;
		SET		 @RoomID = @visitConfirmID ;
	
		Update tblvisitors set phone1 = @EndUserID,EndUserID= @EndUserID , Email= @VisitorEmail where visitorID =@VisitorID;
		update  tblVisitInmateConfig set VisitRemain =VisitRemain-1 where FacilityID= @FacilityID and InmateID =@InmateID ;

		Delete tblVisitEnduserScheduleTemp where ApmNo = @ApmNo ;
	
		SET  @UserAction =  'Schedule Visit for InmateID: ' + @InmateID;

		EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;

		EXEC  INSERT_ActivityLogs3	@FacilityID ,19 ,@ActTime, 0,@CreatedBy ,@UserIP, @InmateID,@UserAction ;  
	end
	Else
	begin
		SET      @ApmNo =   0 ;
		SET		 @RoomID = 0;
	end

END

