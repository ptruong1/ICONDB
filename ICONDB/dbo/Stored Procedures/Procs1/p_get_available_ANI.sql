-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_available_ANI]
@facilityID int,
@Device varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
	Declare @ANI varchar(10), @deviceName varchar(30), @stationID varchar(30), @ACPcode int, @FacilityName as Varchar(150), @timezone smallint ;
	SET @ANI  ='NA';
	SET @ACPcode =11;
	SET  @deviceName ='NA';
	SET  @timezone =0;
	Select top 1 @ANI= ANIno from tblANIs with(nolock) where facilityID = @facilityID and AccessTypeID=5 and  ANINoStatus= 4 ;
	Update tblANIs set ANINoStatus=1 where ANINo = @ANI;

	if(@Device = 'InmateKiosk')
	 begin
		select top 1 @deviceName = extID, @stationID= StationID from tblVisitPhone with(nolock) where FacilityID = @facilityID and StationType = 2 and status=4;
		Update  tblVisitPhone set status= 1 where FacilityID = @facilityID and StationType = 2 and status= 4 and ExtID= @deviceName;
	 end
	else if(@Device = 'VisitorKiosk')
	 begin
		select top 1 @deviceName = extID, @stationID= StationID from tblVisitPhone with(nolock) where FacilityID = @facilityID and StationType = 1 and status=4;
		Update  tblVisitPhone set status= 1 where FacilityID = @facilityID and StationType = 1 and status= 4 and ExtID= @deviceName;
	 end
	else
	 begin
		select top 1 @deviceName =TabletID, @stationID ='' from tblTablets with(nolock) where FacilityID = @facilityID ;
	 end
    select @FacilityName = location,  @timezone = timeZone from tblfacility with(nolock) where FacilityID = @facilityID;
	if(@timezone=0)
		SET @ACPcode =11;
    else if (@timezone=1)
		SET @ACPcode =12;
	else if (@timezone=2)
		SET @ACPcode =13;
	else if (@timezone=3)
		SET @ACPcode =14;
	select @ANI as ANI ,@deviceName  as DeviceName,  @stationID as StationID, @ACPcode as ACPcode, @FacilityName as  FacilityName ;
	
END

