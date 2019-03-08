CREATE PROCEDURE [dbo].[p_insert_VisitLocationSchedule]
(
	@FacilityID int,
	@LocationID int,
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
	@RFromTime1 varchar(5),
	@RToTime1 varchar(5),
	@RFromTime2 varchar(5),
	@RToTime2 varchar(5),
	@RFromTime3 varchar(5),
	@RToTime3 varchar(5),
	@RFromTime4 varchar(5),
	@RToTime4 varchar(5),
	@ScheduleDay tinyint
)
AS
	SET NOCOUNT OFF;

EXEC  INSERT_ActivityLogs1   @FacilityID,6, 0,	@userName,'', @FacilityID

IF @ScheduleDay in (SELECT ScheduleDay FROM [tblVisitLocationSchedule] 
WHERE FacilityID = @FacilityID AND ScheduleDay = @ScheduleDay and LocationID = @LocationID)
	BEGIN
		UPDATE [tblVisitLocationSchedule] 
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
		 WHERE (([FacilityID] = @FacilityID) AND (ScheduleDay = @ScheduleDay) and (VisitType=1)and LocationID = @LocationID);
		 
		 
		 UPDATE [tblVisitLocationSchedule] 
		SET [FromTime1] = @RFromTime1, 
			[ToTime1] = @RToTime1,
			[FromTime2] = @RFromTime2, 
			[ToTime2] = @RToTime2,
			[FromTime3] = @RFromTime3, 
			[ToTime3] = @RToTime3,
			[FromTime4] = @RFromTime4, 
			[ToTime4] = @RToTime4,
			[LimitTime] = @LimitTime,
			[userName] = @userName, 
			[modifydate] = GETDATE()
		 WHERE (([FacilityID] = @FacilityID) AND (ScheduleDay = @ScheduleDay)and (VisitType=2) and LocationID = @LocationID);
		 
		RETURN;
	END
ELSE
	BEGIN
		INSERT INTO [tblVisitLocationSchedule] 
		([FacilityID],
		 [LocationID],
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
		   @LocationID, 
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
		   1);
		   
		   INSERT INTO [tblVisitLocationSchedule] 
		([FacilityID],
		 [LocationID],
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
		   @LocationID, 
		   @ScheduleDay, 
		   @RFromTime1, 
		   @RToTime1,
		   @RFromTime2, 
		   @RToTime2,
		   @RFromTime3, 
		   @RToTime3,
		   @RFromTime4, 
		   @RToTime4,
		   @LimitTime,
		   @userName, 
		   GETDATE(),
		   2);
		  
		RETURN;
	END

