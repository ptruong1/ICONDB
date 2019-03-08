CREATE PROCEDURE [dbo].[INSERT_FacilityVisitSchedule]
(
	@FacilityID int,
	@LocationID int,
	@UserName varchar(25),
	@LimitTime tinyint,
	@FromTime1 varchar(5),
	@ToTime1 varchar(5),
	@FromTime2 varchar(5),
	@ToTime2 varchar(5),
	@ScheduleDay tinyint
)
AS
	SET NOCOUNT OFF;

EXEC  INSERT_ActivityLogs1   @FacilityID,6, 0,	@userName,'', @FacilityID

IF @ScheduleDay in (SELECT ScheduleDay FROM [tblVisitFacilitySchedule] 
WHERE FacilityID = @FacilityID AND ScheduleDay = @ScheduleDay and LocationID = @LocationID)
	BEGIN
		UPDATE [tblVisitFacilitySchedule] 
		SET [FromTime1] = @FromTime1, 
			[ToTime1] = @ToTime1,
			[FromTime2] = @FromTime2, 
			[ToTime2] = @ToTime2,
			[LimitTime] = @LimitTime,
			[userName] = @userName, 
			[modifydate] = GETDATE()
		 WHERE (([FacilityID] = @FacilityID) AND (ScheduleDay = @ScheduleDay));
		RETURN;
	END
ELSE
	BEGIN
		INSERT INTO [tblVisitFacilitySchedule] 
		([FacilityID],
		 [LocationID],
		 [ScheduleDay],
		  [FromTime1],
		   [ToTime1],
		  [FromTime2],
		   [ToTime2],
		   [LimitTime],
		   [userName],
		   [InputDate])
		   
		   VALUES 
		   (@FacilityID,
		   @LocationID, 
		   @ScheduleDay, 
		   @FromTime1, 
		   @ToTime1,
		   @FromTime2, 
		   @ToTime2,
		   @LimitTime,
		   @userName, 
		   GETDATE());
		  
		RETURN;
	END

