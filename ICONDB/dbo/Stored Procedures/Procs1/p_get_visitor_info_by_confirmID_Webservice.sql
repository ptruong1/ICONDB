-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_visitor_info_by_confirmID_Webservice] 
	@confirmID int,
	@AcctNo	   varchar(12)
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   Declare @VisitorName varchar(50) ,	@InmateName  varchar(50),	@AppDateTime	datetime , @visitType tinyint,@locationID int,
	@AppDuration int,	@ChatSerVerIP	varchar(60),	@VisitorID	int ,	@RecordOpt  char(1) ,
	@TextOpt    char(1),	@RemainTime bigint,   @StationID varchar(50), @InmateID varchar(12),
	@facilityID int,@timeZone tinyint,@flatform tinyint,  @localTime datetime,@timePass int;
   SET @VisitorName='';
   SET @InmateName='';
   SET @ChatSerVerIP = 'http://v1.legacyinmate.com';
   SET @RecordOpt='Y';
   SET @TextOpt='N';
   SET @AppDateTime='1/1/2000'	;
   SET @VisitorID=0;
   SET @RemainTime =9999999999;
   if(@confirmID =12344)
    begin
	 Select 'http://v1.legacyinmate.com:8080/Chat/flex/?RoomID=5' + '&UserID=' + CAST(@confirmID as varchar(15))  + 'V&UserType=C&SessionID=' +  CAST(@confirmID as varchar(15))  + 'V&Duration=16&Record=Y&TextChat=N&videoDisplayW=320&videoDisplayH=240&WaitTime=1' as httpLink
	 return 0;
    end

   if(@AcctNo <>'0')
	   select @InmateName=inmateName, @InmateID=InmateID,@VisitorID=VisitorID,@AppDuration=LimitTime,@StationID=StationID, @visitType = visittype,@locationID = locationID,
	   @AppDateTime=  ApmDate + ApmTime , @facilityID = FacilityID  from leg_Icon.dbo.tblVisitEnduserSchedule with(nolock)
		where   RoomID=@confirmID and (status=2 or status=3) and EndUserID =@AcctNo ;
   else
		select @InmateName=inmateName, @InmateID=InmateID,@VisitorID=VisitorID,@AppDuration=LimitTime,@StationID=StationID, @visitType = visittype,@locationID = locationID,
	   @AppDateTime=  ApmDate + ApmTime , @facilityID = FacilityID  from leg_Icon.dbo.tblVisitEnduserSchedule with(nolock)
		where   RoomID=@confirmID and (status=2 or status=3) ;

   if(@VisitorID >0)
    Begin	
	   Select @timeZone = timeZone,@flatform =flatform from tblFacility with(nolock) where facilityID =@facilityID;
	   SELECT @ChatSerVerIP=ChatServerIP from  leg_Icon.dbo.tblVisitPhoneServer with(nolock)  where facilityID =@facilityID;
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
	if(@RemainTime <600)
	 begin
	    --Print 'test'
		If( @RemainTime <0)
			SET  @RemainTime =0;
		Else
			SET @RemainTime =  @RemainTime/60;
	    

		if(select COUNT(*) from tblVisitOnline where RoomID = @confirmID) = 0
		 begin
			INSERT tblVisitOnline(RoomID,FacilityID,  InmateID , InmateName , StationID  , ApmDate , [status] ,visitType ,LimitTime ,  VisitorName ,   VisitorIP, locationID , RecordOpt, InmateLoginTime,ChatServerIP)
					values(@confirmID, @facilityID ,@InmateID ,@InmateName ,@StationID ,@AppDateTime ,3,@visitType,@AppDuration, @VisitorName ,NULL,@locationID,@RecordOpt, GETDATE(),@ChatSerVerIP );
			Update leg_Icon.dbo.tblVisitEnduserSchedule set status =3  where RoomID = @confirmID ;
		 end
		else
			Update tblVisitOnline SET  StationID = @StationID,locationID = @locationID, status =5, InmateLoginTime=GETDATE() where RoomID = @confirmID ;
		
		If(@ChatSerVerIP ='https://www.legacyvisit.com')
			Select ('http://' + @ChatSerVerIP + ':5080/Chat/flex/index.html?RoomID=' + CAST(@confirmID as varchar(15)) + '&UserID=' + CAST(@confirmID as varchar(15))  + 'I&UserType=C&SessionID=' +  CAST(@confirmID as varchar(15))  + 'I&Duration=' + CAST(@AppDuration as varchar(15)) + '&Record=' + @RecordOpt + '&TextChat=' + @TextOpt + '&videoDisplayW=640&videoDisplayH=480' + '&WaitTime='+  CAST(@RemainTime as varchar(12)) ) AS httpLink
		else
			Select ('http://' + @ChatSerVerIP + ':8080/Chat/flex/?RoomID=' + CAST(@confirmID as varchar(15)) + '&UserID=' + CAST(@confirmID as varchar(15))  + 'V&UserType=C&SessionID=' +  CAST(@confirmID as varchar(15))  + 'V&Duration=' + CAST(@AppDuration as varchar(15)) + '&Record=' + @RecordOpt + '&TextChat=' + @TextOpt + '&videoDisplayW=320&videoDisplayH=240&WaitTime='+ CAST( @RemainTime as varchar(10))) AS httpLink
		return 0;
	 end
    else
		select ('Invalid')  as httpLink;
END

