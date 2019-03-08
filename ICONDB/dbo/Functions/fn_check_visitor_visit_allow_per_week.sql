-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_check_visitor_visit_allow_per_week] 
(
	@facilityID int,
	@visitorID int,
	@scheduleDate date,
	@PerWeek tinyint

)
RETURNS smallint
AS
BEGIN 
	
	
	 if( ( select COUNT(*) from [tblVisitEnduserSchedule] where FacilityID = @facilityID and VisitorID = @visitorID and  datepart(WEEK, ApmDate)  = datepart(WEEK, @scheduleDate) and  [status] in (1,2,3,5)  ) +
		(select COUNT(*) from [tblVisitEnduserScheduletemp] where FacilityID = @facilityID and VisitorID = @visitorID and  datepart(WEEK, ApmDate)  = datepart(WEEK, @scheduleDate)) >= @PerWeek)
		return 0;
	 
		
	return 1;
END
