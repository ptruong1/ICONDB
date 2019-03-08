CREATE PROCEDURE [dbo].[p_verify_schedulevisit]
	@InmateID varchar(12),
	@facilityID	int,
	@visitorID int
 AS
 SET NOCOUNT ON;
 select  ApmNo,  InmateID, InmateName, EndUserID, RequestedTime, ApmDate, ApmTime, status,  VisitorID                    
 from tblVisitEnduserSchedule where FacilityID =@facilityID and VisitorID =@visitorID and InmateID = @InmateID and status =1

