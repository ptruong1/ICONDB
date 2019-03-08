-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_determine_inmate_visit_per_day]
(
	@facilityID int,
	@InmateID varchar(12),
	@scheduleDate smalldatetime,
	@VisitPerDay smallint
)
RETURNS tinyint
AS
BEGIN
	if ((select COUNT(*) from tblVisitEnduserScheduleTemp with(nolock) where FacilityID = @facilityID and InmateID = @InmateID and ApmDate = @scheduleDate) + (select COUNT(*) from tblVisitEnduserSchedule with(nolock) where FacilityID = @facilityID and InmateID = @InmateID and ApmDate = @scheduleDate and [status] in (1,2,3,5,8) ) >=  @VisitPerDay)
	 begin
		RETURN 0;
	 end
	 
	RETURN  1;
	
END
