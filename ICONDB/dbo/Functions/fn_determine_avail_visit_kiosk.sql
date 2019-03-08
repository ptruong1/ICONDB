-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_determine_avail_visit_kiosk] 
(
	@facilityID int,
	@scheduleDate smalldatetime,
	@ScheduleTime time(0)
)
RETURNS smallint
AS
BEGIN 
	Declare @currentApm smallint, @currentApmTemp smallint, @NumOfVisitKiosk smallint;
	SET @currentApm  =0;
	SET @currentApmTemp =0;
	SET @NumOfVisitKiosk =0;
		select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] 
							where FacilityID = @facilityID and
								  ApmDate  = @scheduleDate and 								  	
								  visitType =1 and
								 ((ApmTime >= @ScheduleTime and ApmTime< DATEADD(MINUTE,LimitTime,@ScheduleTime)) or  (ApmTime = @ScheduleTime)) and					  
								  [status] <= 3  ;
							  
		select @currentApmTemp= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] 
							where FacilityID = @facilityID and
								  ApmDate  = @scheduleDate and 
								  visitType =1 and					  
								  ApmTime  = @ScheduleTime ;
	 
	SET  @currentApm = @currentApm  + @currentApmTemp;

	select  @NumOfVisitKiosk=  count(*) from tblvisitphone with(nolock) where facilityID = @facilityID and stationType =1 and [status]=1 ;

	if(@currentApm >=  @NumOfVisitKiosk)

		return 0;

	Return 1;
	
	

END
