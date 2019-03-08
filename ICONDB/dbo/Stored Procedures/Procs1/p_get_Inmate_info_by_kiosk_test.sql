-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Inmate_info_by_kiosk_test] 
	@PublicIP varchar(16),
	@PrivateIP varchar(16),
	@PIN	varchar(12)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
   Declare  @StationID varchar(25), @confirmID bigint,@facilityID int,  @inmateID varchar(12),@roomID int, @visitType tinyint,
   @timeZone tinyint, @localTime datetime, @timePass int,@LocationID int;
   Declare @VisitorName varchar(50),	@InmateName  varchar(50) ,	@AppDateTime	datetime ,	@AppDuration int ,	@SessionID	varchar(20) ,
	@VisitorID	int ,	@RecordOpt  char(1) ,	@TextOpt    char(1),	@RemainTime bigint , 	@ChatServerIP varchar(20) ;
 
    
   SET @facilityID =0 ;
   select @facilityID= FacilityID,@StationID=StationID,@LocationID = LocationID    FROM [leg_Icon].[dbo].tblVisitPhone with(nolock) where ExtID =@PublicIP;
 --  if(@StationID <>'')
 --   begin
	--	Update [leg_Icon].[dbo].tblVisitPhone set [status]=2 where ExtID =@PublicIP;
		
	--end
   if(@facilityID =0) 
		select @facilityID= FacilityID   FROM [leg_Icon].[dbo].[tblVisitLocation] with(nolock) where LocationIP=@PublicIP;
		--Hardcode for testing
   
   
   
   SET @RecordOpt='Y';
   SET @TextOpt='N';
   SET @VisitorName ='';
   SET @InmateName='';
   SET @AppDateTime='1/1/2000';
   SET @AppDuration =0;
   SET @SessionID='';
   SET @VisitorID =0;
   SET @ChatSerVerIP = '207.141.248.179';
   SET @inmateID ='';
   SET @timeZone =0	;
   SET @RemainTime =0;
   --if(@PIN = '77777772205') set @facilityID =27;  --- Test from Hampton
  
   
   
   select @inmateID = inmateID from tblInmate with(nolock) where FacilityId =@facilityID and PIN =@PIN and [Status]=1;
   select  @inmateID;
   if (@inmateID ='')
	Begin
		SET  @SessionID='NA';
		Select @VisitorName as VisitorName,	@InmateName as  InmateName,	@AppDateTime	as AppDateTime ,@AppDuration as AppDuration ,	
			@SessionID	as RoomID ,	@VisitorID as VisitorID ,	@RecordOpt  as RecordOpt ,	@TextOpt as TextOpt,@RemainTime as RemainTime , @ChatServerIP as ChatServerIP ;

		return -1;
	End
   else
    begin
		if (select COUNT(*) from tblVisitInmateConfig with(nolock)  where FacilityID = @FacilityID and InmateID = @inmateID) >0
			Update tblVisitInmateConfig set LocationID = @LocationID,ModifyDate =GETDATE() where FacilityID = @FacilityID and InmateID = @inmateID ;
		else
			if(@FacilityID >0)	
				insert tblVisitInmateConfig(InmateID ,FacilityID ,LocationID ,InputDate)
									   values(@inmateID , @facilityID ,@LocationID ,GETDATE());
					 
	end	
	--if(@facilityID=0)
	-- begin
			
	--		select @facilityID = t1.FacilityId, @inmateID =t1.InmateID ,@RecordOpt = t1.RecordOpt
	--		from leg_Icon.dbo.tblVisitEnduserSchedule t1 ,leg_Icon.dbo.tblVisitors t2,leg_Icon.dbo.tblVisitType t3, tblInmate t4
	--		where t1.FacilityID = t2.FacilityID 
	--			  and t1.VisitorID = t2.VisitorID 
	--			  and t1.visitType = t3.VisitTypeID 
	--			  and t1.FacilityID =t4.FacilityId 
	--			  and t1.InmateID = t4.InmateID
	--			  and t4.PIN = @PIN
	--			  and t1.status in (2,3)
	--			  order by  ApmDate, ApmTime;
			
	-- end
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

	SET  @timePass =DATEDIFF (MINUTE,@AppDateTime,@localTime )
	
	if(@timePass < @AppDuration and @timePass>0)
		SET @AppDuration =@AppDuration- @timePass;
		
	
	select @VisitorName= left(VFirstName,24) + ' ' + left(VLastName,24), @RecordOpt= isnull(RecordOpt,'Y') from  leg_Icon.dbo.tblVisitors with(nolock) where VisitorID =@VisitorID;
	if(@AppDateTime='1/1/2000')
		SET @RemainTime =0;
	else
	 begin
		SET @RemainTime= DATEDIFF(SS, @localTime,@AppDateTime)
		Update leg_Icon.dbo.tblVisitEnduserSchedule SET StationID = @StationID, locationID =@LocationID where  ApmNo=@SessionID;
		SELECT @ChatSerVerIP=ChatServerIP from  leg_Icon.dbo.tblVisitPhoneServer  where facilityID =@facilityID	;
		--select @roomID, @facilityID ,@inmateID ,@InmateName ,@StationID ,@AppDateTime ,3,@visitType,@AppDuration, @VisitorName ,NULL,@locationID,@RecordOpt, GETDATE(),@ChatSerVerIP ;
		if(select COUNT(*) from tblVisitOnline where RoomID = @roomID) = 0
			INSERT tblVisitOnline(RoomID,FacilityID,  InmateID , InmateName , StationID  , ApmDate , [status] ,visitType ,LimitTime ,  VisitorName ,   VisitorIP, locationID , RecordOpt, InmateLoginTime,ChatServerIP)
					values(@roomID, @facilityID ,@PIN ,@InmateName ,@StationID ,@AppDateTime ,4,@visitType,@AppDuration, @VisitorName ,NULL,@locationID,@RecordOpt, GETDATE(),@ChatSerVerIP )
		else
			Update tblVisitOnline SET  StationID = @StationID,locationID = @locationID, status =5, InmateLoginTime=GETDATE() where RoomID = @roomID ;
	 
	 end	
	
	Select @VisitorName as VisitorName,	@InmateName as  InmateName,	@AppDateTime	as AppDateTime ,@AppDuration as AppDuration ,	
			@SessionID	as RoomID ,	@VisitorID as VisitorID ,	@RecordOpt  as RecordOpt ,	@TextOpt as TextOpt,@RemainTime as RemainTime , @ChatServerIP as ChatServerIP ;

END


