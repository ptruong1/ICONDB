-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_check_avail_by_schedule_time_with_dur] 
(
	@facilityID int,
	@scheduleDate smalldatetime,
	@locationID int,
	@ScheduleTime time(0),
	@visitType tinyint,
	@dur int
)
RETURNS smallint
AS
BEGIN 
	If (@visitType =1 and  [dbo].[fn_determine_avail_visit_kiosk_before_book_with_dur] ( @facilityID, @scheduleDate,@ScheduleTime , @dur) =0)
		Return 0;
	If ( @locationID > 0 and [dbo].[fn_determine_avail_kiosk_at_location_before_book_with_dur] (@facilityID, @scheduleDate,@ScheduleTime,@locationID,@dur) =0)
		Return 0;
	RETURN 1;
END
