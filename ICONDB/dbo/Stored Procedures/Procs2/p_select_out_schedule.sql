-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_out_schedule]
@period as smallint,
@InterApm  as smallint,
@ApmIncrement as  smallint,
@RecordOpt as  char(1),
@hourbeforevisit as  smallint,
@NumOfStations  as smallint,
@InmateID as  varchar(12),
@visitorID as  int,
@scheduleDate as  date,
@localTime as  datetime,
@tempSchedule as typeVisitAvailSchedule readonly
AS
BEGIN
	select  ScheduleTime,@period -@InterApm as ApmTimeMin,  @period -@InterApm +@ApmIncrement * 2  as ApmTimeLimit,@ApmIncrement as ApmIncrement, @RecordOpt as  RecordOpt 
	from @tempSchedule where CurrentApm < @NumOfStations and DATEADD(hh,DATEPART(hh,ScheduleTime), ScheduleDate) > DATEADD(Hour,@hourbeforevisit, @localTime) 
	and ScheduleTime not in (select apmtime from [leg_Icon].[dbo].[tblVisitEnduserSchedule] where (InmateID=@InmateID or VisitorID =@visitorID) and ApmDate = @scheduleDate and status <4 );
END

