-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_chat_session_status] 
	@RoomID int,
	@userID varchar(12),
	@status		int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @facilityID int, @apmDate datetime, @apmTime time(0), @limitTime smallint, @timeZone tinyint,@localTime datetime, @finishTime datetime;
	SET  @timeZone = 0 ;
	
	if (@status =9)
		begin
			update leg_Icon.dbo.tblVisitEnduserSchedule set [status] =@status where RoomID=@RoomID and status = 3;
			update leg_Icon.dbo.tblVisitOnline  set [status] =@status where RoomID=@RoomID ;
			
		end
	else
	 begin
		Select @facilityID = facilityID,@apmDate=apmDate,@apmTime =apmTime, @limitTime = LimitTime   from tblVisitEnduserSchedule  where RoomID = @RoomID;
		select @timeZone  = timezone from tblfacility with(nolock) where FacilityID =@facilityID ; 
		SET @localTime  = DATEADD(hour,@timezone,getdate());
		SET @finishTime = DATEADD(MINUTE,@limitTime,DATEADD(MINUTE,DATEPART(MINUTE,@ApmTime),  DATEADD(HOUR,DATEPART(HOUR,@ApmTime), @ApmDate ))) ;
		--select @finishTime, @localtime
		if( @localTime > @finishTime)
			update leg_Icon.dbo.tblVisitEnduserSchedule set [status] =@status where RoomID=@RoomID and status = 3;
	 end
	select @@error as UpdateChatSession;
END




