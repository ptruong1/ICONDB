CREATE PROCEDURE [dbo].[INSERT_DivisionTimeRestrictPeriod]
(
	@FacilityID int,
	@DivisionID int,
	@day tinyint,
	@PeriodID int,
	@fromTime varchar(5),
	@ToTime varchar(5),
	@userName varchar(20),
	@modifydate smalldatetime
)
AS
	SET NOCOUNT OFF;
Update tblFacilityDivision Set   DayTimeRestrict = 1 where DivisionID = @DivisionID;

if(@fromTime = '' or  @ToTime ='' or @fromTime = @ToTime )
	Return;

IF @day in (SELECT day FROM [tblDivisionTimeCallPeriod] WHERE FacilityID = @FacilityID AND DivisionID = @DivisionID AND day = @day and periodID = @PeriodID)
	BEGIN
		UPDATE [tblDivisionTimeCallPeriod] SET [FromTime] = @FromTime, [ToTime] = @ToTime,[userName] = @userName, [modifydate] = @modifydate
		 WHERE (([FacilityID] = @FacilityID) AND ([DivisionID] = @DivisionID)  AND ([day] = @day) and (periodID = @PeriodID));
		RETURN;
	END
ELSE
	BEGIN
		INSERT INTO [tblDivisionTimeCallPeriod] ([FacilityID], [DivisionID], [day], [PeriodID],[FromTime], [ToTime], [userName], [modifydate]) VALUES (@FacilityID, @DivisionID, @day, @periodID,@FromTime, @ToTime, @userName, @modifydate);
		RETURN;
	END
