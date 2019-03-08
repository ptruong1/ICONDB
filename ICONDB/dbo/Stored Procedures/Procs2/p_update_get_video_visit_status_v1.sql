-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_get_video_visit_status_v1] ---- Script Date: 12/8/2017 8:59:29 AM ******/
	@ConfirmID bigint,
	@status tinyint,
	@LocationIP  varchar(16),
	@UserType tinyint  --1: inmate, 2: visitor 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @UserID varchar(20), @GroupID varchar(6), @AppDuration smallint, @ChatServerIP varchar(100),@timeZone tinyint,@CurrentStatus tinyint,
		@AppDateTime	datetime ,@localTime datetime, @timePass int,@RecordOpt  char(1) ,	@TextOpt    char(1),@facilityID	 int;
	SET @RecordOpt  ='Y';
	SET @TextOpt  = 'N';
	SET @timeZone = 0;
	SET @timePass =0;
	SET @facilityID =0;
	SET @UserID ='';
	SET @ChatSerVerIP ='';
	if(@UserType =1)
	 begin	
		select @UserID=InmateID,@AppDuration=LimitTime,	
			   @AppDateTime=  ApmDate + ApmTime, 
			   @facilityID = FacilityID ,
			   @RecordOpt = RecordOpt,
			   @CurrentStatus = [status]
			from leg_Icon.dbo.tblVisitEnduserSchedule with(nolock) where  RoomID = @ConfirmID and status in (2,3);
		Select @timeZone = timeZone from tblFacility where facilityID =@facilityID ; 
		SET @localTime = DATEADD(HH, @timeZone,GETDATE());
		SET  @timePass =DATEDIFF (MI,@AppDateTime,@localTime );
		if(@timePass < @AppDuration and @timePass>=0)
			SET @AppDuration =@AppDuration- @timePass;

		else
			SET @AppDuration =0;	
		if @CurrentStatus =2 and  @AppDuration >0
		 begin
			update leg_Icon.dbo.tblVisitEnduserSchedule set [status] = @status, InmateLogInID=@LocationIP  where RoomID =@ConfirmID;		
		 end
		 SET @UserID = CAST(@ConfirmID as varchar(10)) + '-' + @UserID + 'I';
	 end
	else
	 begin
		select @UserID=CAST(VisitorID as varchar(10)),@AppDuration=LimitTime,	
			   @AppDateTime=  ApmDate + ApmTime, 
			   @facilityID = FacilityID ,
			   @RecordOpt = RecordOpt,
			   @CurrentStatus = [status]
			from leg_Icon.dbo.tblVisitEnduserSchedule with(nolock) where  RoomID = @ConfirmID and status in (2,3);
		Select @timeZone = timeZone from tblFacility where facilityID =@facilityID;
		SET @localTime = DATEADD(HH, @timeZone,GETDATE());
		SET  @timePass =DATEDIFF (MI,@AppDateTime,@localTime );
		if(@timePass < @AppDuration and @timePass>=0)
			SET @AppDuration =@AppDuration- @timePass;

		else
			SET @AppDuration =0;	
		if @CurrentStatus =2 and  @AppDuration >0
		 begin
			update leg_Icon.dbo.tblVisitEnduserSchedule set [status] = @status, VisitorLogInID=@LocationIP  where RoomID =@ConfirmID
		 end
		 SET @UserID =CAST(@ConfirmID as varchar(10)) + '-' + @UserID + 'V';
	 end 
	--select @AppDateTime
	SELECT @ChatSerVerIP=[Description] from  leg_Icon.dbo.tblVisitPhoneServer with(nolock) where facilityID =@facilityID	;
	SET @GroupID = @facilityID ; -- For now
	Select @GroupID as GroupID, @ConfirmID as RoomID ,@UserID as UserID, 'C' as UserType,	@AppDuration as Duration,	
				@RecordOpt  as RecordOpt ,	@TextOpt as TextOpt, @ChatServerIP as ChatServerIP ;
			
    
END

