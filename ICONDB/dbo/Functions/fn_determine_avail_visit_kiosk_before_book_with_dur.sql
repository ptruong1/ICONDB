-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_determine_avail_visit_kiosk_before_book_with_dur] 
(
	@facilityID int,
	@scheduleDate smalldatetime,
	@ScheduleTime time(0),
	@dur int
)
RETURNS smallint
AS
BEGIN 
	Declare @currentApm smallint, @currentApmTemp smallint, @NumOfVisitKiosk smallint;
	SET @currentApm  =0;
	SET @currentApmTemp =0;
	SET @NumOfVisitKiosk =0;
	/*
		select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] 
							where FacilityID = @facilityID and
								  ApmDate  = @scheduleDate and 								  	
								  visitType =1 and
								 ((ApmTime >= @ScheduleTime and ApmTime< DATEADD(MINUTE,LimitTime,@ScheduleTime)) or  (ApmTime = @ScheduleTime)) and					  
								  [status] <= 3  ;
    */
	select @currentApm= COUNT(*)  from tblVisitEnduserSchedule where FacilityID =@facilityID and ApmDate  =@scheduleDate and status <=3
		and  (dateadd(MINUTE,datepart(MINUTE, @ScheduleTime), Dateadd( HOUR, Datepart(HOUR, @ScheduleTime),  @scheduleDate)) )  between  (dateadd(MINUTE,datepart(MINUTE, ApmTime), Dateadd( HOUR, Datepart(HOUR, ApmTime),  ApmDate )) )  and
	DATEADD(MINUTE, LimitTime -1, (dateadd(MINUTE,datepart(MINUTE, ApmTime), Dateadd( HOUR, Datepart(HOUR, ApmTime),  ApmDate )))) ;

	
	select @currentApmTemp=COUNT(*)   from tblVisitEnduserSchedule where FacilityID = @facilityID and ApmDate  =@scheduleDate and status <=3
		and DateAdd(MINUTE, @dur-1 , (dateadd(MINUTE,datepart(MINUTE, @ScheduleTime), Dateadd( HOUR, Datepart(HOUR, @ScheduleTime),  @scheduleDate)) ))  between  (dateadd(MINUTE,datepart(MINUTE, ApmTime), Dateadd( HOUR, Datepart(HOUR, ApmTime),  ApmDate )) )  and
		DATEADD(MINUTE, LimitTime -1, (dateadd(MINUTE,datepart(MINUTE, ApmTime), Dateadd( HOUR, Datepart(HOUR, ApmTime),  ApmDate ))))
		and   (dateadd(MINUTE,datepart(MINUTE, ApmTime), Dateadd( HOUR, Datepart(HOUR, ApmTime),  ApmDate )) )  >  (dateadd(MINUTE,datepart(MINUTE, @ScheduleTime), Dateadd( HOUR, Datepart(HOUR, @ScheduleTime),  @scheduleDate)) ) ;
	
    SET  @currentApm = @currentApm + @currentApmTemp ;
	select  @NumOfVisitKiosk=  count(*) from tblvisitphone with(nolock) where facilityID = @facilityID and stationType =1 and [status]=1 ;

	if(@currentApm >=  @NumOfVisitKiosk)

		return 0;

	Return 1 ;
	
	

END
