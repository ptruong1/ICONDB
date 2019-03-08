-- =============================================
-- Author:		<Author,,Name>
-- Create date: <2/20/2019>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_visit_schedule]
@tempSchedule as typeVisitAvailSchedule readonly,
@MinTimeVisit tinyint,
@MaxTimevisit int,
@ApmIncrement tinyint,
@RecordOpt varchar(1),
@hourbeforevisit smallint,
@localTime datetime,
@CurrentDate date,
@scheduleDate date,
@InmateID varchar(12),
@visitorID int,
@InterApm smallint,
@Curenttime time(0)

AS
BEGIN

	SET NOCOUNT ON;
	If (@MinTimeVisit =0 or @MinTimeVisit is null) SET @MinTimeVisit =@MaxTimevisit;
	If (@MinTimeVisit> @MaxTimevisit) SET @MaxTimevisit = @MinTimeVisit;
	if(@CurrentDate < @scheduleDate)
		select  ScheduleTime,@MinTimeVisit as ApmTimeMin,  @MaxTimevisit  as ApmTimeLimit,@ApmIncrement as ApmIncrement, @RecordOpt as  RecordOpt 
		from @tempSchedule where  DATEADD(MI,DATEPART(HOUR ,ScheduleTime) *60 +   DATEPART(MI ,ScheduleTime), ScheduleDate) >= DATEADD(Hour,@hourbeforevisit, @localTime) 
		and ScheduleTime not in (select apmtime from [leg_Icon].[dbo].[tblVisitEnduserSchedule] where (InmateID=@InmateID or VisitorID =@visitorID) and ApmDate = @scheduleDate and status <4 );
	else
	 begin
				select  ScheduleTime,  @MinTimeVisit  as ApmTimeMin,  @MaxTimevisit  as ApmTimeLimit,@ApmIncrement as ApmIncrement, @RecordOpt as  RecordOpt 
				from @tempSchedule where  ScheduleTime >= Dateadd(MINUTE,@InterApm, @Curenttime) 
				and ScheduleTime not in (select apmtime from [leg_Icon].[dbo].[tblVisitEnduserSchedule] where (InmateID=@InmateID or VisitorID =@visitorID) and ApmDate = @scheduleDate and status <4 );
	
	 end

END
