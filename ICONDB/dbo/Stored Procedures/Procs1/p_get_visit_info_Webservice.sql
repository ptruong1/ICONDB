-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_visit_info_Webservice] 
	@IP   varchar(16),
	@InmateID varchar(12), ---Confirm ID
	@PIN	   varchar(12)  --Phone
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   Declare @VisitorName varchar(50) ,	@InmateName  varchar(50),	@AppDateTime	datetime ,	@AppDuration int,	@ChatSerVerIP	varchar(60),	@VisitorID	int, @confirmID bigint, @visitType tinyint, @locationID int ;
   Declare 	@RecordOpt  char(1) ,	@TextOpt    char(1),	@RemainTime bigint,   @StationID varchar(50),	@facilityID int,@timeZone tinyint,@flatform tinyint,  @localTime datetime,@timePass int, @CurrentDateTime datetime;
   SET @VisitorName='';
   SET @InmateName='';
   SET @ChatSerVerIP = 'v1.legacyinmate.com';
   SET @RecordOpt='Y';
   SET @TextOpt='N';
   SET @AppDateTime='1/1/2000'	;
   SET @VisitorID=0;
   SET @RemainTime =1440;
   SET @AppDuration = 0;
   SET @facilityID=0;
   SET @CurrentDateTime = getdate();
   ---TESTING
   --insert chatLog(chatRoomId, userName) values(5,@IP);

   if(@InmateID ='12345' and @PIN='12345' ) -- for testing
    begin
	 Select 'http://v1.legacyinmate.com:8080/Chat/flex/?RoomID=5&UserID=' + @InmateID + 'I&UserType=C&SessionID=' + @InmateID  + 'I&Duration=15&Record=Y&TextChat=N&videoDisplayW=640&videoDisplayH=480&WaitTime=1' as httpLink ;
	 return 0;
    end
   if(@InmateID ='5678' and @PIN='5678') -- for testing
    begin
	 Select 'http://v1.legacyinmate.com:8080/Chat/flex/?RoomID=6&UserID=' + @InmateID + 'I&UserType=C&SessionID=' + @InmateID  + 'I&Duration=15&Record=Y&TextChat=N&videoDisplayW=1280&videoDisplayH=960&WaitTime=1' as httpLink ;
	 return 0;
    end
   /*  
   if(@InmateID <>'0')
	   --select  * from tblvisitphone where chatroomid
	   select top 1 @InmateName=b.inmateName, @VisitorID=b.VisitorID,@AppDuration=b.LimitTime,@StationID=b.StationID, @confirmID = b.apmNo, @visitType = b.visitType, @locationID = b.locationID,
		   @AppDateTime=  b.ApmDate + b.ApmTime , @facilityID = a.FacilityID  from tblInmate a  with(nolock), tblvisitEnduserSchedule b with(nolock)
			 where a.facilityID = b.facilityID and  a.inmateID = b.inmateID and a.inmateID = @InmateID and a.PIN = @PIN and a.status =1 and b.status in (2,3) and b.ApmDate =  convert (date, getdate())
			   order by   b.ApmDate,b.ApmTime;
	*/
	-- New Edit begin
	if(@InmateID <>'0')
	 begin
		 select top 1 @InmateName=b.inmateName, @VisitorID=b.VisitorID,@AppDuration=b.LimitTime,@StationID=b.StationID, @confirmID = b.apmNo, @visitType = b.visitType, @locationID = b.locationID, 
		   @AppDateTime=  b.ApmDate + b.ApmTime , @facilityID = a.FacilityID, @timeZone = c.timeZone  from tblInmate a  with(nolock), tblvisitEnduserSchedule b with(nolock), tblfacility c with(nolock)
			 where a.facilityID = b.facilityID and  a.inmateID = b.inmateID and b.FacilityID = c.FacilityID 
					and a.inmateID = @InmateID and a.PIN = @PIN 
					and a.status =1 and b.status in (2,3) 
					and  DATEDIFF (mi,b.ApmDate + b.ApmTime,dateadd(HOUR,  c.timeZone, @CurrentDateTime )) >=-11
					and  DATEDIFF (mi,b.ApmDate + b.ApmTime,dateadd(HOUR,  c.timeZone, @CurrentDateTime))  < b.LimitTime
			   order by   b.ApmDate,b.ApmTime;
	 end

	 ---- New edit End
    if( @facilityID = 0)
		 select top 1 @InmateName=b.inmateName, @VisitorID=b.VisitorID,@AppDuration=b.LimitTime,@StationID=b.StationID, @confirmID = b.apmNo,  @visitType = b.visitType, @locationID = b.locationID,
		   @AppDateTime=  b.ApmDate + b.ApmTime , @facilityID = b.FacilityID  from  tblvisitEnduserSchedule b with(nolock)
			 where  RoomID= @InmateID  and  b.EndUserID= @PIN and b.status in (2,3) and ApmDate =  convert (date, getdate()) ;
	

   if(@VisitorID >0)
    Begin	
	   --Select @timeZone = timeZone,@flatform =flatform from tblFacility with(nolock)  where facilityID =@facilityID;
	   SELECT @ChatSerVerIP=ChatServerIP from  leg_Icon.dbo.tblVisitPhoneServer with(nolock)  where facilityID =@facilityID;
	   SET @localTime = DATEADD(HH, @timeZone,@CurrentDateTime);
	   SET  @timePass =DATEDIFF (mi,@AppDateTime,@localTime ) ;

	   --print  @AppDateTime;
	   if( @timePass >0)
		begin
		   if(@timePass < @AppDuration)
			begin
				SET @AppDuration =@AppDuration- @timePass;
				SET @RemainTime= 0;
			end
		   else
			begin
				SET @AppDuration=0;				
				SET @RemainTime =9999999999;
			end 
			
		end
		
		SET @RemainTime= DATEDIFF(MINUTE, @localTime,@AppDateTime);
	          
	end	
 
	if(@AppDuration >0 and  @RemainTime <10)
	 begin
		if(select COUNT(*) from tblVisitOnline where RoomID = @confirmID) = 0
			INSERT tblVisitOnline(RoomID,FacilityID,  InmateID , InmateName , StationID  , ApmDate , [status] ,visitType ,LimitTime ,  VisitorName ,   VisitorIP, locationID , RecordOpt, InmateLoginTime,ChatServerIP)
					values(@confirmID, @facilityID ,@PIN ,@InmateName ,@StationID ,@AppDateTime ,4,@visitType,@AppDuration, @VisitorName ,NULL,@locationID,@RecordOpt, GETDATE(),@ChatSerVerIP )
		else
			Update tblVisitOnline SET  StationID = @StationID,locationID = @locationID, status =5, InmateLoginTime=GETDATE() where RoomID = @confirmID ;

		If(@ChatSerVerIP ='https://www.legacyvisit.com')
			Select ( @ChatSerVerIP + ':5080/Chat/flex/index.html?RoomID=' + CAST(@confirmID as varchar(15)) + '&UserID=' + CAST(@confirmID as varchar(15))  + 'I&UserType=C&SessionID=' +  CAST(@confirmID as varchar(15))  + 'I&Duration=' + CAST(@AppDuration as varchar(15)) + '&Record=' + @RecordOpt + '&TextChat=' + @TextOpt + '&videoDisplayW=640&videoDisplayH=480' + '&WaitTime='+  CAST(@RemainTime as varchar(12)) ) AS httpLink
		else

			Select ('http://' + @ChatSerVerIP + ':8080/Chat/flex/?RoomID=' + CAST(@confirmID as varchar(15)) + '&UserID=' + CAST(@confirmID as varchar(15))  + 'I&UserType=C&SessionID=' +  CAST(@confirmID as varchar(15))  + 'I&Duration=' + CAST(@AppDuration as varchar(15)) + '&Record=' + @RecordOpt + '&TextChat=' + @TextOpt + '&videoDisplayW=640&videoDisplayH=480' + '&WaitTime='+  CAST(@RemainTime as varchar(12)) ) AS httpLink
	 end
    else
		select ('Invalid')  as httpLink
END

