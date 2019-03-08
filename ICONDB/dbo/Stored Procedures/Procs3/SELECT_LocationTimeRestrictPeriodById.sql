CREATE PROCEDURE [dbo].[SELECT_LocationTimeRestrictPeriodById]
(
	@FacilityID int,
	@DivisionID int,
	@LocationID int
)
AS
	SET NOCOUNT ON;
SELECT        @FacilityID, DivisionID, LocationID, day, FromTime, ToTime, userName, modifydate, PeriodID
FROM            tblLocationTimeCallPeriod  with(nolock)
WHERE        (DivisionID = @DivisionID) and (LocationID = @LocationID)
		order by day, PeriodID;
