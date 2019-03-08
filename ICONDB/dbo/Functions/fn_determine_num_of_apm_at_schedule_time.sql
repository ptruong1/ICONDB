-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_determine_num_of_apm_at_schedule_time] 
(
	@facilityID int,
	@scheduleDate smalldatetime,
	@locationID int,
	@ScheduleTime time(0),
	@VisitType tinyint
)
RETURNS smallint
AS
BEGIN 
	Declare @currentApm smallint, @currentApmTemp smallint;
	SET @currentApm  =0;
	if(@VisitType  =2)
	 begin
		select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] 
							where FacilityID = @facilityID and
								  ApmDate  = @scheduleDate and 
								  LocationID = @locationID and
								 (ApmTime >= @ScheduleTime and ApmTime< DATEADD(MINUTE,LimitTime,@ScheduleTime)) and					  
								  [status] <= 3  ;
		select @currentApmTemp= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] 
							where FacilityID = @facilityID and
								  ApmDate  = @scheduleDate and 
								  LocationID = @locationID and					  
								  ApmTime  = @ScheduleTime ;
	 end
	else
	 begin
		select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] 
							where FacilityID = @facilityID and
								  ApmDate  = @scheduleDate and 
								  LocationID = @locationID and		
								  visitType =1 and
								 (ApmTime >= @ScheduleTime and ApmTime< DATEADD(MINUTE,LimitTime,@ScheduleTime)) and					  
								  [status] <= 3  ;
							  
		select @currentApmTemp= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] 
							where FacilityID = @facilityID and
								  ApmDate  = @scheduleDate and 
								  LocationID = @locationID and		
								  visitType =1 and					  
								  ApmTime  = @ScheduleTime ;
	 end
	RETURN @currentApm + @currentApmTemp;

END
