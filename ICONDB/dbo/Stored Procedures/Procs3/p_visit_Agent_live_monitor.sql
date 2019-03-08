-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_visit_Agent_live_monitor]
	@AgentID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @localtime datetime, @timezone tinyint;
	SET @timezone = 0;
	--select @timezone = timezone from tblfacility where FacilityID = @facilityID ;
	SET @localtime = DATEADD(HOUR, @timezone ,GETDATE()) ;
	--select @localtime 
    select a.FacilityID, a.RoomID as ConfirmNo, (CASE a.status WHEN 3 THEN 'Visitor Waiting' WHEN 4 THEN 'Inmate Waiting' Else 'Conferencing' End) [Status] , 
	b.LocationName,a.StationID as KioskName,a.InmateName, a.InmateID as PIN, a.ApmDate,a.VisitorName,a.LimitTime,a.VisitorIP as VisitorLocation ,
	 RecordOpt, a.ChatServerIP
	from tblVisitOnline a join tblVisitLocation  b on (a.FacilityID in (select facilityID from  tblFacility  with(nolock) WHERE Status = 1 and AgentID = '1') 
	and a.locationID = b.LocationID) 
				    
	where a.FacilityID in (select facilityID from  tblFacility  with(nolock) WHERE Status = 1 and AgentID = '1') and 
	   --a.inmateLoginTime  is not null and 
	   --a.VisitorLogintime is  not null and
	   a.RecordOpt ='Y' and status <9 and 
	   ( a.ApmDate >= DATEADD(MINUTE,-a.LimitTime,DATEADD(HOUR, (select timezone from tblfacility where FacilityID = a.facilityID) ,GETDATE())) and 
	   a.ApmDate <  DATEADD(MINUTE,a.LimitTime,DATEADD(HOUR, (select timezone from tblfacility where FacilityID = a.facilityID) ,GETDATE())) ) 
	   Order by b.LocationName,a.StationID;
END

