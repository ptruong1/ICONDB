-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_visitor_info_by_confirmID] 
	@confirmID int,
	@VisitorName varchar(50) OUTPUT,
	@InmateName  varchar(50) OUTPUT,	
	@AppDateTime	datetime OUTPUT,
	@AppDuration int OUTPUT,
	@SessionID	varchar(20) OUTPUT,
	@VisitorID	int OUTPUT,
	@RecordOpt  char(1) OUTPUT,
	@TextOpt    char(1)OUTPUT,
	@RemainTime bigint OUTPUT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
   Declare  @StationID varchar(50), @InmateID varchar(12),@facilityID int,@timeZone tinyint,@flatform tinyint,
   @localTime datetime,@timePass int
   SET @VisitorName=''
   SET @InmateName=''
   
   SET @RecordOpt='Y'
   SET @TextOpt='N'
   SET @AppDateTime='1/1/2000'	
   SET @SessionID=''
   SET @VisitorID=0
   SET @RemainTime=0
   select @SessionID=ApmNo,@InmateName=inmateName, @InmateID=InmateID,@VisitorID=VisitorID,@AppDuration=LimitTime,@StationID=StationID,
   @AppDateTime=  ApmDate + ApmTime , @facilityID = FacilityID  from leg_Icon.dbo.tblVisitEnduserSchedule
	where   RoomID=@confirmID and (status=2 or status=3)
   if(@VisitorID >0)
    Begin	
	   Select @timeZone = timeZone,@flatform =flatform from tblFacility where facilityID =@facilityID
	   SET @localTime = DATEADD(HH, @timeZone,GETDATE())
	   SET  @timePass =DATEDIFF (mi,@AppDateTime,@localTime )
	   if( @timePass >0)
		begin
		   if(@timePass < @AppDuration)
			begin
				SET @AppDuration =@AppDuration- @timePass
				SET @RemainTime= DATEDIFF(S, @localTime,@AppDateTime)
			end
		   else
			begin
				SET @AppDuration=0
				SET @SessionID =0
				SET @RemainTime =9999999999
			end 
			
		end
		else
		 begin
		   SET @RemainTime= DATEDIFF(S, @localTime,@AppDateTime)
		 end
	   select @VisitorName= VFirstName + ' ' + VLastName from  leg_Icon.dbo.tblVisitors where VisitorID =@VisitorID
   
	end
END

