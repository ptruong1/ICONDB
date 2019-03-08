-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_visitor_info_by_confirmID_Webservice_v1] 
	@PublicIP  varchar(16),
	@KioskName	varchar(16),
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
	@facilityID int,@timeZone tinyint,@flatform tinyint,  @localTime datetime,@timePass bigint;
   SET @VisitorName='';
   SET @InmateName='';
   SET @ChatSerVerIP = 'https://www.legacyvisit.com:5080/Chat/index.html?';
   SET @RecordOpt='Y';
   SET @TextOpt='Y';
   SET @AppDateTime='1/1/2000'	;
   SET @VisitorID=0;
   SET @RemainTime =9999999999;
   
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
	   SELECT  @ChatSerVerIP= rtrim(ltrim( isnull( [Description], @ChatSerVerIP)))  from  leg_Icon.dbo.tblVisitPhoneServer with(nolock) where facilityID =@facilityID	;
	   Select @VisitorName = VFirstName + ' ' + VLastName, @RecordOpt = isnull(RecordOpt,'Y') from tblVisitors with(nolock) where VisitorID= @VisitorID;
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
	Else
	 begin
		--SET @VisitorID = 0;
		SET @AppDuration =0;

	 end 

	if(@RemainTime <10000)
	 begin
	    --Print 'test'
		If( @RemainTime <0)
			SET  @RemainTime =0;
	    
		Update leg_Icon.dbo.tblVisitEnduserSchedule set status =3  where RoomID = @confirmID ;

		if(select COUNT(*) from tblVisitOnline where RoomID = @confirmID) = 0
		 begin
			INSERT tblVisitOnline(RoomID,FacilityID,  InmateID , InmateName , StationID  , ApmDate , [status] ,visitType ,LimitTime ,  VisitorName ,   VisitorIP, locationID , RecordOpt, InmateLoginTime,ChatServerIP)
					values(@confirmID, @facilityID ,@InmateID ,@InmateName ,@KioskName ,@AppDateTime ,3,@visitType,@AppDuration, @VisitorName ,@PublicIP,@locationID,@RecordOpt, GETDATE(),@ChatSerVerIP );
			
		 end
		else
			Update tblVisitOnline SET  StationID = @StationID,locationID = @locationID, status =5, InmateLoginTime=GETDATE(), VisitorIP =@PublicIP  where RoomID = @confirmID ;
		
	 end
	 
	 Select @VisitorName as VisitorName,	@InmateName as  InmateName, CAST(  @AppDateTime as varchar(20)) as AppDateTime ,@AppDuration as AppDuration ,	
			@confirmID	as RoomID ,	@VisitorID as VisitorID ,	@RecordOpt  as RecordOpt ,	@TextOpt as TextOpt,@RemainTime as RemainTime , @ChatServerIP as ChatServerIP ;

	 return 0;
 
END

