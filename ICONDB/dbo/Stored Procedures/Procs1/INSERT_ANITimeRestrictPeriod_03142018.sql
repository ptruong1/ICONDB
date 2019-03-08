CREATE PROCEDURE [dbo].[INSERT_ANITimeRestrictPeriod_03142018]
(
	@FacilityID int,
	@ANINo char(10),
	@day tinyint,
	@PeriodID int,
	@fromTime varchar(5),
	@ToTime varchar(5),
	@userName varchar(20),
	@modifydate smalldatetime
)
AS
	SET NOCOUNT OFF;
Update tblANIs Set   DayTimeRestrict = 1 where ANIno = @ANINo;

---EXEC  INSERT_ActivityLogs1   @FacilityID,6, 0,	@userName,'', @FacilityID
--if(@fromTime = '' or  @ToTime ='' or @fromTime = @ToTime )
--	Return;

IF @day in (SELECT day FROM [tblANITimeCallPeriod] WHERE FacilityID = @FacilityID AND ANI = @ANINo AND day = @day and periodID = @PeriodID)
	BEGIN
		UPDATE [tblANITimeCallPeriod] SET [FromTime] = @FromTime, [ToTime] = @ToTime,[userName] = @userName, [modifydate] = @modifydate
		 WHERE (([FacilityID] = @FacilityID) AND ([ANI] = @ANINo)  AND ([day] = @day) and (periodID = @PeriodID));
		RETURN;
	END
ELSE
	BEGIN
		INSERT INTO [tblANITimeCallPeriod] ([FacilityID], [ANI], [day], [PeriodID],[FromTime], [ToTime], [userName], [modifydate]) VALUES (@FacilityID, @ANINo, @day, @periodID,@FromTime, @ToTime, @userName, @modifydate);
		RETURN;
	END
