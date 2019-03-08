CREATE FUNCTION dbo.fn_count_current_schedule 
(
	@facilityID int,
	@scheduleDate datetime2,
	@ScheduleTime varchar(50),
	@dur int
)
RETURNS int
AS
BEGIN
	declare @count tinyint = 0;

	declare @InputScheduleDateTime datetime2
	set @InputScheduleDateTime = DATEADD(day, DATEDIFF(day, 0, @scheduleDate), @ScheduleTime)

	declare @ApmDate datetime2, @ApmTime varchar(50)
	DECLARE VisitEnduserSchedule_cursor CURSOR FOR Select ApmDate, ApmTime from tblVisitEnduserSchedule where Status<=3 and FacilityID = 574 and ApmDate = @scheduleDate

	OPEN VisitEnduserSchedule_cursor  

	FETCH NEXT FROM VisitEnduserSchedule_cursor INTO @ApmDate, @ApmTime  

	WHILE @@FETCH_STATUS = 0  
	BEGIN
		declare @BeginingExistingDateTime datetime2, @EndingExistingDateTime datetime2  
		set @BeginingExistingDateTime = DATEADD(day, DATEDIFF(day, 0, @ApmDate), @ApmTime)
		set @EndingExistingDateTime = DATEADD(mi,@dur, DATEADD(day, DATEDIFF(day, 0, @ApmDate), @ApmTime))

		if(@InputScheduleDateTime between @BeginingExistingDateTime and @EndingExistingDateTime)
		begin
			set @count = @count + 1
		end
		FETCH NEXT FROM VisitEnduserSchedule_cursor INTO @ApmDate, @ApmTime 
	END
	CLOSE VisitEnduserSchedule_cursor  
	DEALLOCATE VisitEnduserSchedule_cursor  

	RETURN @count

END
