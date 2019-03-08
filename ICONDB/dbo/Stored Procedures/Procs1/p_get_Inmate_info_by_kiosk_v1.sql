-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Inmate_info_by_kiosk_v1] 
	@PublicIP varchar(16),
	@KioskName varchar(16),
	@InmateID varchar(12),
	@PIN	varchar(12)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
   Declare  @StationID varchar(30), @confirmID bigint,@facilityID int,  @roomID bigint, @visitType tinyint, @ServerType varchar(10),
   @timeZone tinyint, @localTime datetime, @timePass bigint,@LocationID int;
   Declare @VisitorName varchar(60),	@InmateName  varchar(60) ,	@AppDateTime	datetime ,	@AppDuration int ,	@SessionID	varchar(20) ,
	@VisitorID	int ,	@RecordOpt  char(1) ,	@TextOpt    char(1),	@RemainTime bigint , 	@ChatServerIP varchar(60) ;
 
    
   SET @facilityID =0 ;
   select @facilityID= FacilityID,@StationID=StationID,@LocationID = LocationID    FROM [leg_Icon].[dbo].tblVisitPhone with(nolock) where ExtID =@KioskName;

	--select 	@facilityID ;
	--end
   if(@facilityID =0) 
		select @facilityID= FacilityID   FROM [leg_Icon].[dbo].[tblVisitLocation] with(nolock) where LocationIP=@PublicIP;
		--Hardcode for testing
   if(@facilityID =0)  SET @facilityID = 43;	
   
   SET @RecordOpt='Y';
   SET @TextOpt='Y';
   SET @VisitorName ='';
   SET @InmateName='';
   SET @AppDateTime='1/1/2000';
   SET @AppDuration =0;
   SET @SessionID='0';
   SET @VisitorID =0;
   SET @ChatSerVerIP = 'https://www.legacyvisit.com:5080/Chat/index.html?';
   SET @timeZone =0	;
   SET @RemainTime =0;
  
   
   
   if (select count(*) from tblInmate with(nolock) where FacilityId =@facilityID and PIN =@PIN and InmateID = @InmateID and [Status]=1 ) =0
	Begin
		SET  @SessionID='NA';

		Select @VisitorName as VisitorName,	@InmateName as  InmateName,	@AppDateTime	as AppDateTime ,@AppDuration as AppDuration ,	
			@SessionID	as RoomID ,	@VisitorID as VisitorID ,	@RecordOpt  as RecordOpt ,	@TextOpt as TextOpt,@RemainTime as RemainTime , @ChatServerIP as ChatServerIP ;
			
		return -1;
	End
   
	if(@facilityID=0)
	 Begin
		SET  @SessionID='NA';
		Select @VisitorName as VisitorName,	@InmateName as  InmateName,	@AppDateTime	as AppDateTime ,@AppDuration as AppDuration ,	
			@SessionID	as RoomID ,	@VisitorID as VisitorID ,	@RecordOpt  as RecordOpt ,	@TextOpt as TextOpt,@RemainTime as RemainTime , @ChatServerIP as ChatServerIP ;

		return -1;
	 End
	else
		Select @timeZone = timeZone from tblFacility with(nolock) where facilityID =@facilityID;
		
	
  
	SET @localTime = DATEADD(HH, @timeZone,GETDATE());

	select top 1 @SessionID=ApmNo,@InmateName=inmateName, @InmateID=InmateID,@VisitorID=VisitorID,@AppDuration=LimitTime,@RecordOpt = isnull(recordopt,'Y'),
		@AppDateTime=  ApmDate + ApmTime , @roomID = RoomID ,@visitType =visitType  from leg_Icon.dbo.tblVisitEnduserSchedule with(nolock)
		where   InmateID=@inmateID and FacilityID = @facilityID and (status=2 or status=3) and DATEDIFF (MINUTE,@localTime, ApmDate + ApmTime )> -LimitTime
		order by  ApmDate + ApmTime;

	SET  @timePass =DATEDIFF (MINUTE,@AppDateTime,@localTime );
	
	if(@timePass < @AppDuration and @timePass>0)
		SET @AppDuration =@AppDuration- @timePass;
		
	
	select @VisitorName= left(VFirstName,24) + ' ' + left(VLastName,24), @RecordOpt= isnull(RecordOpt,'Y') from  leg_Icon.dbo.tblVisitors with(nolock) where VisitorID =@VisitorID;
	if(@AppDateTime='1/1/2000')
		SET @RemainTime =0;
	else
	 begin
		SET @RemainTime= DATEDIFF(SS, @localTime,@AppDateTime) ;
		Update leg_Icon.dbo.tblVisitEnduserSchedule SET StationID = @StationID, locationID =@LocationID where  ApmNo=@SessionID;

		SELECT  @ChatSerVerIP= rtrim(ltrim( isnull( [Description], @ChatSerVerIP)))  from  leg_Icon.dbo.tblVisitPhoneServer with(nolock) where facilityID =@facilityID	;

		--select @roomID, @facilityID ,@inmateID ,@InmateName ,@StationID ,@AppDateTime ,3,@visitType,@AppDuration, @VisitorName ,NULL,@locationID,@RecordOpt, GETDATE(),@ChatSerVerIP ;
		if(select COUNT(*) from tblVisitOnline where RoomID = @roomID) = 0
			INSERT tblVisitOnline(RoomID,FacilityID,  InmateID , InmateName , StationID  , ApmDate , [status] ,visitType ,LimitTime ,  VisitorName ,   VisitorIP, locationID , RecordOpt, InmateLoginTime,ChatServerIP)
					values(@roomID, @facilityID ,@PIN ,@InmateName ,@StationID ,@AppDateTime ,4,@visitType,@AppDuration, @VisitorName ,NULL,@locationID,@RecordOpt, GETDATE(),@ChatSerVerIP );
		else
			Update tblVisitOnline SET  StationID = @StationID,locationID = @locationID, status =5, InmateLoginTime=GETDATE() where RoomID = @roomID ;
	 
	 end	
	EXEC  p_insert_kiosk_activity 	@KioskName ,	1,	@FacilityID,	@InmateID ;
	Select @VisitorName as VisitorName,	@InmateName as  InmateName,CAST(@AppDateTime as varchar(20))	as AppDateTime ,@AppDuration as AppDuration ,	
			@SessionID	as RoomID ,	@VisitorID as VisitorID ,	@RecordOpt  as RecordOpt ,	@TextOpt as TextOpt,@RemainTime as RemainTime , @ChatServerIP as ChatServerIP ;

END


