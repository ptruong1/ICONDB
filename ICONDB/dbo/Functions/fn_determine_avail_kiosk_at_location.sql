-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_determine_avail_kiosk_at_location] 
(
	@facilityID int,
	@scheduleDate smalldatetime,
	@ScheduleTime time(0),
	@locationID int
)
RETURNS smallint
AS
BEGIN 
	Declare @currentApm smallint, @currentApmTemp smallint, @NumOfLocKiosk smallint;
	SET @currentApm  =0;
	SET @currentApmTemp =0;
	SET @NumOfLocKiosk =0;
	
		select @currentApm= COUNT(*) from [tblVisitEnduserSchedule] 
							where FacilityID = @facilityID and
								  ApmDate  = @scheduleDate and 								  	
								  locationID =@locationID and
								 (ApmTime >= @ScheduleTime and ApmTime< DATEADD(MINUTE,LimitTime,@ScheduleTime)) and					  
								  [status] <= 3  ;
							  
		select @currentApmTemp= COUNT(*) from [tblVisitEnduserScheduleTemp] 
							where FacilityID = @facilityID and
								  ApmDate  = @scheduleDate and 
								  locationID =@locationID and			  
								  ApmTime  = @ScheduleTime ;
	 
	SET  @currentApm = @currentApm  + @currentApmTemp;

	select   @NumOfLocKiosk=  count(*) from tblvisitphone with(nolock) where facilityID = @facilityID and LocationID = @locationID and stationType =2 and [status]=1 ;

	if(@currentApm >  @NumOfLocKiosk)

		return 0;

	Return 1;
	
	

END
