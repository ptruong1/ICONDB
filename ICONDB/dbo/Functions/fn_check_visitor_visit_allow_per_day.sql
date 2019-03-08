-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_check_visitor_visit_allow_per_day] 
(
	@facilityID int,
	@visitorID int,
	@scheduleDate date,
	@PerDay tinyint
)
RETURNS smallint
AS
BEGIN 
	
	 if( ( select COUNT(*) from [tblVisitEnduserSchedule] where FacilityID = @facilityID and VisitorID = @visitorID and  ApmDate  = @scheduleDate and  [status] in (1,2,3,5)  ) + 
		 (select COUNT(*) from [tblVisitEnduserScheduleTemp] where FacilityID = @facilityID and VisitorID = @visitorID and  ApmDate  = @scheduleDate) >= @PerDay)
		return 0;
	 
		
	return 1;
END
