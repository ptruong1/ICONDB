CREATE PROCEDURE [dbo].[INSERT_LocationTimeRestrictPeriod]
(
	@FacilityID int,
	@DivisionID int,
	@LocationID int,
	@day tinyint,
	@PeriodID int,
	@fromTime varchar(5),
	@ToTime varchar(5),
	@userName varchar(20),
	@modifydate smalldatetime
)
AS
	SET NOCOUNT OFF;
Update tblFacilityLocation Set   DayTimeRestrict = 1 where LocationID = @LocationID;

---EXEC  INSERT_ActivityLogs1   @FacilityID,6, 0,	@userName,'', @FacilityID
if(@fromTime = '' or  @ToTime ='' or @fromTime = @ToTime )
	Return;

IF @day in (SELECT day FROM [tblLocationTimeCallPeriod] WHERE FacilityID = @FacilityID AND DivisionID = @DivisionID AND LocationID = @LocationID and day = @day and periodID = @PeriodID)
	BEGIN
		UPDATE [tblLocationTimeCallPeriod] SET [FromTime] = @FromTime, [ToTime] = @ToTime,[userName] = @userName, [modifydate] = @modifydate
		 WHERE (([FacilityID] = @FacilityID) AND ([DivisionID] = @DivisionID)  AND  ([LocationID] = @LocationID) and ([day] = @day) and (periodID = @PeriodID));
		RETURN;
	END
ELSE
	BEGIN
		INSERT INTO [tblLocationTimeCallPeriod] ([FacilityID], [DivisionID], [LocationID], [day], [PeriodID],[FromTime], [ToTime], [userName], [modifydate]) VALUES (@FacilityID, @DivisionID, @LocationID, @day, @periodID,@FromTime, @ToTime, @userName, @modifydate);
		RETURN;
	END
