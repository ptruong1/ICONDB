CREATE PROCEDURE [dbo].[INSERT_PINTimeRestrictPeriod]
(
	@FacilityID int,
	@PIN varchar(12),
	@day tinyint,
	@PeriodID int,
	@fromTime varchar(5),
	@ToTime varchar(5),
	@userName varchar(20),
	@modifydate smalldatetime
)
AS
	SET NOCOUNT OFF;
Update tblInmate Set   DateTimeRestrict = 1 where PIN = @PIN

---EXEC  INSERT_ActivityLogs1   @FacilityID,6, 0,	@userName,'', @FacilityID

IF @day in (SELECT day FROM [tblPINTimeCallPeriod] WHERE FacilityID = @FacilityID AND PIN = @PIN AND day = @day and periodID = @PeriodID)
	BEGIN
		UPDATE [tblPINTimeCallPeriod] SET [FromTime] = @FromTime, [ToTime] = @ToTime,[userName] = @userName, [modifydate] = @modifydate
		 WHERE (([FacilityID] = @FacilityID) AND ([PIN] = @PIN)  AND ([day] = @day) and (periodID = @PeriodID));
		RETURN;
	END
ELSE
	BEGIN
		INSERT INTO [tblPINTimeCallPeriod] ([FacilityID], [PIN], [day], [PeriodID],[FromTime], [ToTime], [userName], [modifydate]) VALUES (@FacilityID, @PIN, @day, @periodID,@FromTime, @ToTime, @userName, @modifydate);
		RETURN;
	END
