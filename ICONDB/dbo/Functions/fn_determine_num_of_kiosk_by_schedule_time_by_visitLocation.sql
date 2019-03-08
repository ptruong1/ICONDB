-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_determine_num_of_kiosk_by_schedule_time_by_visitLocation] 
(
	@facilityID int,
	@scheduleDate smalldatetime,
	@locationID int,
	@ScheduleTime time(0),
	@NumOfStations smallint,
	@visitType tinyint,
	@VisitLocationID int
)
RETURNS smallint
AS
BEGIN 
	if(select count(*) from tblVisitCellSchedule with(nolock)  where facilityID = @facilityID and locID = @locationID and ScheduleDay=  datepart(dw,  @scheduleDate)) > 0
		   begin
			   select  @NumOfStations= count( ExtID) from tblVisitCellSchedule  with(nolock) where 
						 ScheduleDay=  datepart(dw,  @scheduleDate) and FacilityID=@facilityID and VisitType=@visitType  and locid =@locationID
						  and FromTime1  <= @ScheduleTime and ToTime1 >= @ScheduleTime ;


		   end
	If (@visitType =1 and  [dbo].[fn_determine_avail_visit_kiosk_by_visitLocation] ( @facilityID, @scheduleDate,@ScheduleTime,@VisitLocationID ) =0)
		Return 0;
	If ( @locationID > 0 and [dbo].fn_determine_avail_kiosk_at_location (@facilityID, @scheduleDate,@ScheduleTime,@locationID) =0)
		Return 0;
	RETURN @NumOfStations;
END
