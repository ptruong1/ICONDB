CREATE PROCEDURE [dbo].[p_insert_VisitCellSchedule]
(
	@FacilityID int,
	@ExtID varchar(25),
	@UserName varchar(25),
	@LimitTime tinyint,
	@FromTime1 varchar(5),
	@ToTime1 varchar(5),
	@FromTime2 varchar(5),
	@ToTime2 varchar(5),
	@FromTime3 varchar(5),
	@ToTime3 varchar(5),
	@FromTime4 varchar(5),
	@ToTime4 varchar(5),
	@ScheduleDay tinyint,
	@visitType tinyint
)
AS
	SET NOCOUNT OFF;

EXEC  INSERT_ActivityLogs1   @FacilityID,6, 0,	@userName,'', @FacilityID

IF @ScheduleDay in (SELECT ScheduleDay FROM [tblVisitCellSchedule] 
WHERE FacilityID = @FacilityID AND ScheduleDay = @ScheduleDay and ExtID = @ExtID)
	BEGIN
		UPDATE [tblVisitCellSchedule] 
		SET [FromTime1] = @FromTime1, 
			[ToTime1] = @ToTime1,
			[FromTime2] = @FromTime2, 
			[ToTime2] = @ToTime2,
			[FromTime3] = @FromTime3, 
			[ToTime3] = @ToTime3,
			[FromTime4] = @FromTime4, 
			[ToTime4] = @ToTime4,
			[LimitTime] = @LimitTime,
			[userName] = @userName, 
			[modifydate] = GETDATE()
		 WHERE (([FacilityID] = @FacilityID) AND (ScheduleDay = @ScheduleDay) and  ExtID = @ExtID);
		 		 
		RETURN;
	END
ELSE
	BEGIN
		INSERT INTO [tblVisitCellSchedule] 
		([FacilityID],
		 [ExtID],
		 [ScheduleDay],
		  [FromTime1],
		   [ToTime1],
		  [FromTime2],
		   [ToTime2],
		    [FromTime3],
		   [ToTime3],
		  [FromTime4],
		   [ToTime4],
		   [LimitTime],
		   [userName],
		   [InputDate],
		   [VisitType])
		   
		   VALUES 
		   (@FacilityID,
		   @ExtID, 
		   @ScheduleDay, 
		   @FromTime1, 
		   @ToTime1,
		   @FromTime2, 
		   @ToTime2,
		   @FromTime3, 
		   @ToTime3,
		   @FromTime4, 
		   @ToTime4,
		   @LimitTime,
		   @userName, 
		   GETDATE(),
		   @visitType);
		
		  
		RETURN;
	END

