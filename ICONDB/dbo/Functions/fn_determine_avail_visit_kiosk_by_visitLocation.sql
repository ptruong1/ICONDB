-- =============================================
-- Author:		<Author,,Name>
-- Create date: <2/20/2019>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_determine_avail_visit_kiosk_by_visitLocation] 
(
	@facilityID int,
	@scheduleDate smalldatetime,
	@ScheduleTime time(0),
	@VisitLocationID int
)
RETURNS smallint
AS
BEGIN 
	Declare @currentApm smallint, @currentApmTemp smallint, @NumOfVisitKiosk smallint;
	SET @currentApm  =0;
	SET @currentApmTemp =0;
	SET @NumOfVisitKiosk =0;
	SELECT @currentApm= COUNT(*) from [tblVisitEnduserSchedule] 
							where FacilityID = @facilityID and
								  ApmDate  = @scheduleDate and 								  	
								  visitType =1 and
								 ((ApmTime >= @ScheduleTime and ApmTime< DATEADD(MINUTE,LimitTime,@ScheduleTime)) or  (ApmTime = @ScheduleTime)) and					  
								  [status] <= 3 and VisitLocationID= @VisitLocationID ;
							  
	SELECT @currentApmTemp= COUNT(*) from [tblVisitEnduserScheduleTemp] 
							where FacilityID = @facilityID and
								  ApmDate  = @scheduleDate and 
								  visitType =1 and					  
								  ApmTime  = @ScheduleTime and VisitLocationID= @VisitLocationID;
	 
	SET  @currentApm = @currentApm  + @currentApmTemp;

	select  @NumOfVisitKiosk=  count(*) from tblvisitphone with(nolock) where facilityID = @facilityID and stationType =1 and [status]=1 and LocationID=  @VisitLocationID ;

	if(@currentApm >=  @NumOfVisitKiosk)

		return 0;

	Return 1;
	
	

END
