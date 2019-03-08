CREATE PROCEDURE [dbo].[INSERT_FacilityTimeRestrictPeriod_01302018]
(
	@FacilityID int,
	@day tinyint,
	@PeriodID int,
	@fromTime varchar(5),
	@ToTime varchar(5),
	@userName varchar(20),
	@modifydate smalldatetime
)
AS
	SET NOCOUNT OFF;
Update tblFacility  Set   DayTimeRestrict = 1 where FacilityID = @FacilityID;

--EXEC  INSERT_ActivityLogs1   @FacilityID,6, 0,	@userName,'', @FacilityID;

--if(@fromTime = '' or  @ToTime ='' or @fromTime = @ToTime )
--	Return;

IF @day in (SELECT day FROM [tblFacilityTimeCallPeriod] WHERE FacilityID = @FacilityID AND day = @day and periodID = @PeriodID)
	BEGIN
		UPDATE [tblFacilityTimeCallPeriod] SET [FromTime] = @FromTime, [ToTime] = @ToTime,[userName] = @userName, [modifydate] = @modifydate
		 WHERE (([FacilityID] = @FacilityID) AND ([day] = @day) and (periodID = @PeriodID));
		RETURN;
	END
ELSE
	BEGIN
		INSERT INTO [tblFacilityTimeCallPeriod] ([FacilityID], [day], [PeriodID],[FromTime], [ToTime], [userName], [modifydate]) VALUES (@FacilityID, @day, @periodID,@FromTime, @ToTime, @userName, @modifydate);
		RETURN;
	END
