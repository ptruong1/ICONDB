-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_check_avail_by_schedule_time] 
(
	@facilityID int,
	@scheduleDate smalldatetime,
	@locationID int,
	@ScheduleTime time(0),
	@visitType tinyint
)
RETURNS smallint
AS
BEGIN 
	If (@visitType =1 and  [dbo].[fn_determine_avail_visit_kiosk] ( @facilityID, @scheduleDate,@ScheduleTime ) =0)
		Return 0;
	If ( @locationID > 0 and [dbo].fn_determine_avail_kiosk_at_location (@facilityID, @scheduleDate,@ScheduleTime,@locationID) =0)
		Return 0;
	RETURN 1;
END
