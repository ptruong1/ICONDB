-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Inmate_info_by_kiosh] 
	@PublicIP varchar(16),
	@PrivateIP varchar(16),
	@PIN	varchar(12),
	@VisitorName varchar(50) OUTPUT,
	@InmateName  varchar(50) OUTPUT,	
	@AppDateTime	datetime OUTPUT,
	@AppDuration int OUTPUT,
	@SessionID	varchar(20) OUTPUT,
	@VisitorID	int OUTPUT,
	@RecordOpt  char(1) OUTPUT,
	@TextOpt    char(1) OUTPUT,
	@RemainTime bigint OUTPUT,
	@ChatServerIP varchar(20) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
   Declare  @StationID varchar(25), @confirmID bigint,@facilityID int,  @inmateID varchar(12),
   @timeZone tinyint, @localTime datetime, @timePass int,@LocationID int;
    
   SET @facilityID =0 ;
   select @facilityID= FacilityID,@StationID=StationID,@LocationID = LocationID    FROM [leg_Icon].[dbo].tblVisitPhone where ExtID =@PublicIP;
   if(@StationID <>'')
    begin
		Update [leg_Icon].[dbo].tblVisitPhone set [status]=2 where ExtID =@PublicIP;
		
	end
   if(@facilityID =0) 
		select @facilityID= FacilityID   FROM [leg_Icon].[dbo].[tblVisitLocation] where LocationIP=@PublicIP;
		
   
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
   if(@PIN = '77777772205') set @facilityID =27;
  
   
   
   select @inmateID = inmateID from tblInmate where FacilityId =@facilityID and PIN =@PIN;
	
   if (@inmateID ='')
	Begin
		SET  @SessionID='NA';
		return -1;
	End
   else
		Update tblVisitInmateConfig set LocationID = @LocationID where FacilityID = @FacilityID and InmateID = @inmateID  and ( LocationID =0 or LocationID is null);			 
		
	if(@facilityID=0)
			select @facilityID = t1.FacilityId, @inmateID =t1.InmateID ,@RecordOpt = t1.RecordOpt
			from leg_Icon.dbo.tblVisitEnduserSchedule t1 ,leg_Icon.dbo.tblVisitors t2,leg_Icon.dbo.tblVisitType t3, tblInmate t4
			where t1.FacilityID = t2.FacilityID 
				  and t1.VisitorID = t2.VisitorID 
				  and t1.visitType = t3.VisitTypeID 
				  and t1.FacilityID =t4.FacilityId 
				  and t1.InmateID = t4.InmateID
				  and t4.PIN = @PIN
				  and t1.status in (2,3)
				  order by  ApmDate, ApmTime;
	if(@facilityID=0)
	 Begin
		SET  @SessionID='NA';
		return -1;
	 End
	else
		Select @timeZone = timeZone from tblFacility where facilityID =@facilityID;
	 
  
	SET @localTime = DATEADD(HH, @timeZone,GETDATE());

	select top 1 @SessionID=ApmNo,@InmateName=inmateName, @InmateID=InmateID,@VisitorID=VisitorID,@AppDuration=LimitTime,
		@AppDateTime=  ApmDate + ApmTime   from leg_Icon.dbo.tblVisitEnduserSchedule
		where   InmateID=@inmateID and FacilityID = @facilityID and (status=2 or status=3) and DATEDIFF (mi,@localTime, ApmDate + ApmTime )> -LimitTime
		order by  ApmDate + ApmTime;

	SET  @timePass =DATEDIFF (MI,@AppDateTime,@localTime )
	if(@timePass < @AppDuration and @timePass>0)
		SET @AppDuration =@AppDuration- @timePass;
		
	
	select @VisitorName= VFirstName + ' ' + VLastName, @RecordOpt= isnull(RecordOpt,'Y') from  leg_Icon.dbo.tblVisitors where VisitorID =@VisitorID
	if(@AppDateTime='1/1/2000')
		SET @RemainTime =9999999999;
	else
	 begin
		SET @RemainTime= DATEDIFF(SS, @localTime,@AppDateTime)
		Update leg_Icon.dbo.tblVisitEnduserSchedule SET StationID = @StationID, locationID =@LocationID where  ApmNo=@SessionID;
	 end	
	SELECT @ChatSerVerIP=ChatServerIP from  leg_Icon.dbo.tblVisitPhoneServer  where facilityID =@facilityID	;

END


