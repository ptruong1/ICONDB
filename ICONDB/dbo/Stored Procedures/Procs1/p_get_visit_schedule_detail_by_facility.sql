CREATE proc [dbo].[p_get_visit_schedule_detail_by_facility] (@facilityID int)
as
begin
	BEGIN TRY 
		Declare @timezone smallint;
		Select @timezone = timeZone from tblfacility where FacilityID=@facilityID;
 		select   ApmNo , InmateName , CONVERT(varchar,ApmDate,101) as ApmDate, ApmTime,  a.LimitTime 
		from Leg_ICON.dbo.tblVisitEnduserSchedule a 
		where 
		a.FacilityID = @FacilityID AND a.status= 2 and  day(ApmDate) = day( dateadd( hour, @timezone, getdate()))  and dateadd(minute, datepart(Minute,ApmTime) , dateadd(hour, datepart(hour,ApmTime), ApmDate) ) >=  dateadd( hour, @timezone, getdate());
		--order by ApmTime ASC
	END TRY  
	BEGIN CATCH  
	END CATCH; 
end