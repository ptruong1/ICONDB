-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_setup_kiosk]
@facilityID int,
@KioskType tinyint,
@locationID int,
@DeviceName	varchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
	Declare @ANI varchar(10),  @stationID varchar(30), @ACPcode int, @FacilityName as Varchar(150), @timezone smallint, @phoneOpt tinyint ,@phoneNo varchar(10) ;
	Declare  @lastANI varchar(10), @PhoneLoc int, @PhoneDiv int, @phoneID int;
	SET @ANI  ='NA';
	SET @ACPcode =11;
	SET  @timezone =0;
	SET @phoneOpt =0;
	SET  @stationID = @DeviceName	;
	if(@KioskType = 4)
	 begin
		if(select count(*) from tblTablets  where TabletID =@DeviceName) = 0
		Insert  tblFacilityKiosk(FacilityID,KioskName,KioskAlias)
				values(@facilityID,@DeviceName,@DeviceName);
	 end
	else 
	 begin
		if(select count(*) from tblVisitPhone where extID =@DeviceName) = 0
			insert tblVisitPhone (ExtID, FacilityID,StationID, LocationID,StationType,status,inputDate, PinRequired,IDRequired)
							values(@DeviceName,@facilityID, @DeviceName, @locationID,@KioskType,1,getdate(),1,1);
		else
			select @stationID = stationID from tblVisitPhone  where extID =@DeviceName;
	 end
    select @FacilityName = location,  @timezone = timeZone, @phoneNo =Phone from tblfacility with(nolock) where FacilityID = @facilityID;
	select @phoneOpt =softphoneOpt  from tblFacilityOption where facilityID = @facilityID;
	if(@phoneOpt =1 and @KioskType=2)
	 begin
		select  @ANI  = ANIno from tblANIs with(nolock) where facilityID = @facilityID and StationID= @DeviceName;
		if(@ANI ='NA')
		 begin
			select  @lastANI = ANIno from tblANIs with(nolock) where facilityID = @facilityID order by ANINo;
			
			SET @ANI  = CAST ((cast(@lastANI as bigint) + 1) as varchar(10));
			--select  @lastANI , @ANI
			EXEC  [dbo].[p_create_nextID] 'tblANIs', @phoneID  OUTPUT;
			EXEC  [dbo].[p_create_nextID] 'tblFacilityDivision', @phoneDiv  OUTPUT;
			EXEC  [dbo].[p_create_nextID] 'tblFacilityLocation', @PhoneLoc  OUTPUT;
			insert tblANIs(PhoneID,ANINo, StationID,  facilityID,DivisionID,LocationID,inputdate,UserName)
						values(@phoneID, @ANI, @DeviceName,  @facilityID,@PhoneDiv,@PhoneLoc,getdate(),'Auto');
		 end
		else
		 begin
			SET @DeviceName ='Y';
		 end
		 select @ACPcode = right(UserName,2) from tblFacilityACP with(nolock) where facilityID  = @FacilityID;
	 end


	if(@timezone=0)
		SET @ACPcode =11;
    else if (@timezone=1)
		SET @ACPcode =12;
	else if (@timezone=2)
		SET @ACPcode =13;
	else if (@timezone=3)
		SET @ACPcode =14;
	select @ANI as ANI ,@deviceName  as DeviceName,  @stationID as StationID, @ACPcode as ACPcode ;
	
END

