-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_visitor_onsite_login] 
	@confirmID int,
	@AcctNo	   varchar(12)
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   Declare @VisitorName varchar(50) ,	@InmateName  varchar(50),	@AppDateTime	datetime ,
	@AppDuration int,	@ChatSerVerIP	varchar(20),	@VisitorID	int ,	@RecordOpt  char(1) ,
	@TextOpt    char(1),	@RemainTime bigint,   @StationID varchar(50), @InmateID varchar(12),
	@facilityID int,@timeZone tinyint,@flatform tinyint,  @localTime datetime,@timePass int;
   SET @VisitorName='';
   SET @InmateName='';
   SET @RecordOpt='Y';
   SET @TextOpt='N';
   SET @AppDateTime='1/1/2000'	;
   SET @VisitorID=0;
   SET @RemainTime =9999999999;
   
   if(@AcctNo <>'0')
	   select @InmateName=inmateName, @InmateID=InmateID,@VisitorID=VisitorID,@AppDuration=LimitTime,@StationID=StationID,
	   @AppDateTime=  ApmDate + ApmTime , @facilityID = FacilityID  from leg_Icon.dbo.tblVisitEnduserSchedule with(nolock) 
		where   RoomID=@confirmID and (status=2 or status=3) and EndUserID =@AcctNo ;
   else
		select @InmateName=inmateName, @InmateID=InmateID,@VisitorID=VisitorID,@AppDuration=LimitTime,@StationID=StationID,
	   @AppDateTime=  ApmDate + ApmTime , @facilityID = FacilityID  from leg_Icon.dbo.tblVisitEnduserSchedule with(nolock) 
		where   RoomID=@confirmID and (status=2 or status=3) ;
   if(@VisitorID >0)
    Begin	
	   Select @timeZone = timeZone,@flatform =flatform from tblFacility with(nolock) where facilityID =@facilityID;
	   SELECT @ChatSerVerIP=ChatServerIP from  leg_Icon.dbo.tblVisitPhoneServer  where facilityID =@facilityID;
	   SET @localTime = DATEADD(HH, @timeZone,GETDATE());
	   SET  @timePass =DATEDIFF (mi,@AppDateTime,@localTime );
	   if( @timePass >0)
		begin
		   if(@timePass < @AppDuration)
			begin
				SET @AppDuration =@AppDuration- @timePass;
				SET @RemainTime= DATEDIFF(S, @localTime,@AppDateTime);
			end
		   else
			begin
				SET @AppDuration=0;
				
				SET @RemainTime =9999999999;
			end 
			
		end
		else
		 begin
		   SET @RemainTime= DATEDIFF(S, @localTime,@AppDateTime);
		 end
	          
	end
	
END

