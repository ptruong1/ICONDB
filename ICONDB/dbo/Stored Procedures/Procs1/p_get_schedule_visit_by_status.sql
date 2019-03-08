Create Proc p_get_schedule_visit_by_status
@EndUserID varchar(12), @FacilityID	int, @InmateID varchar(12), @Status tinyint 
As
Begin
	select InmateName, ApmDate, ApmTime from tblVisitEnduserSchedule where EndUserID = @EndUserID and FacilityID = @FacilityID and InmateID = @InmateID and Status = @Status
End