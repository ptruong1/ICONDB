CREATE PROCEDURE [dbo].[p_insert_TabletFacilitySchedule]
(
	@FacilityID int,
	@UserName varchar(25),
	@FromTime1 varchar(5),
	@ToTime1 varchar(5),
	@FromTime2 varchar(5),
	@ToTime2 varchar(5),
	@FromTime3 varchar(5),
	@ToTime3 varchar(5),
	@FromTime4 varchar(5),
	@ToTime4 varchar(5),
	@ScheduleDay tinyint
)
AS
	SET NOCOUNT OFF;

EXEC  INSERT_ActivityLogs1   @FacilityID,6, 0,	@userName,'', @FacilityID

IF @ScheduleDay in (SELECT ScheduleDay FROM [tblTabletFacilitySchedule] 
WHERE FacilityID = @FacilityID AND ScheduleDay = @ScheduleDay )
	BEGIN
		UPDATE [tblTabletFacilitySchedule] 
		SET [FromTime1] = @FromTime1, 
			[ToTime1] = @ToTime1,
			[FromTime2] = @FromTime2, 
			[ToTime2] = @ToTime2,
			[FromTime3] = @FromTime3, 
			[ToTime3] = @ToTime3,
			[FromTime4] = @FromTime4, 
			[ToTime4] = @ToTime4,
			[userName] = @userName, 
			[modifydate] = GETDATE()
		 WHERE (([FacilityID] = @FacilityID) AND (ScheduleDay = @ScheduleDay) )
	RETURN;
	END
ELSE
	BEGIN
		INSERT INTO [tblTabletFacilitySchedule] 
		([FacilityID],
		 [ScheduleDay],
		  [FromTime1],
		   [ToTime1],
		  [FromTime2],
		   [ToTime2],
		    [FromTime3],
		   [ToTime3],
		  [FromTime4],
		   [ToTime4],
		   [userName],
		   [InputDate])
		   
		   VALUES 
		   (@FacilityID,
		    @ScheduleDay, 
		   @FromTime1, 
		   @ToTime1,
		   @FromTime2, 
		   @ToTime2,
		   @FromTime3, 
		   @ToTime3,
		   @FromTime4, 
		   @ToTime4,
		   @userName, 
		   GETDATE());
	RETURN;
	END

