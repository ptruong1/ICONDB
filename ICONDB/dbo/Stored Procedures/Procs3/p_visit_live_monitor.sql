-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_visit_live_monitor]
	@facilityID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @localtime datetime, @timezone tinyint;
	SET @timezone = 0;
	select @timezone = timezone from tblfacility where FacilityID = @facilityID ;
	SET @localtime = DATEADD(HOUR, @timezone ,GETDATE()) ;
	--select @localtime 
    select a.RoomID as ConfirmNo, b.LocationName,a.StationID as KioskName,a.InmateName,a.ApmDate,a.VisitorName,a.LimitTime,a.VisitorIP as VisitorLocation , RecordOpt, a.ChatServerIP
	from tblVisitOnline a join tblVisitLocation  b on (a.FacilityID = b.facilityID and a.locationID = b.LocationID) 
				    
	where a.FacilityID = @facilityID and 
	   --a.inmateLoginTime  is not null and 
	   --a.VisitorLogintime is  not null and
	   a.RecordOpt ='Y' and
	   ( a.ApmDate >= DATEADD(MINUTE,-a.LimitTime,@localtime) and a.ApmDate <  DATEADD(MINUTE,a.LimitTime,@localtime) ) 
	   Order by b.LocationName,a.StationID;
END

