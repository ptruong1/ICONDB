-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_check_visitor_visit_allow_per_day_per_inmate] 
(
	@facilityID int,
	@visitorID int,
	@scheduleDate date,
	@PerDay tinyint,
	@InmateID varchar(12)

)
RETURNS smallint
AS
BEGIN 
	 if(( select COUNT(*) from [tblVisitEnduserSchedule] where FacilityID = @facilityID and  ApmDate  = @scheduleDate and VisitorID = @visitorID and InmateID = @InmateID and  [status] in (1,2,3,5))  + 
		(SELECT COUNT (*) FROM [tblVisitEnduserScheduleTemp] WHERE FacilityID = @facilityID and  ApmDate  = @scheduleDate and VisitorID = @visitorID and InmateID = @InmateID)>= @PerDay)
		return 0;
	 
		
	return 1;
END
