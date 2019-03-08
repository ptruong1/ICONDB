CREATE proc [dbo].[p_get_visit_schedule_detail_by_location] (@facilityID int, @deviceName varchar(25))
as
begin
	BEGIN TRY 
		Declare @LocationID int, @timezone smallint;
		Select  @LocationID = locationID from tblVisitPhone where FacilityID= @facilityID and ExtID= @deviceName;
		Select @timezone = timeZone from tblfacility where FacilityID=@facilityID;
 		select  LocationName, ApmNo , InmateName , CONVERT(varchar,ApmDate,101) as ApmDate, ApmTime,  a.LimitTime 
		from Leg_ICON.dbo.tblVisitEnduserSchedule a,Leg_ICON.dbo.tblVisitInmateConfig b, tblVisitLocation c
		where 
		a.inmateID = b.inmateID and b.locationID = @LocationID and 
		b.locationID = c.locationID and
		a.facilityID = c.FacilityID and
		a.facilityID = b.FacilityID and
		a.FacilityID = @FacilityID AND a.status= 2 and  day(ApmDate) = day( dateadd( hour, @timezone, getdate()))  and dateadd(minute, datepart(Minute,ApmTime) , dateadd(hour, datepart(hour,ApmTime), ApmDate) ) >=  dateadd( hour, @timezone, getdate()) ;
		--order by ApmTime ASC
	END TRY  
	BEGIN CATCH  
	END CATCH; 
end