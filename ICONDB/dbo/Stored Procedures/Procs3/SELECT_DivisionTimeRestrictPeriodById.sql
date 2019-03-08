CREATE PROCEDURE [dbo].[SELECT_DivisionTimeRestrictPeriodById]
(
	@FacilityID int,
	@DivisionID int
)
AS
	SET NOCOUNT ON;
SELECT        FacilityID, DivisionID, day, FromTime, ToTime, userName, modifydate, PeriodID
FROM            tblDivisionTimeCallPeriod  with(nolock)
WHERE        (FacilityID = @FacilityID) and (DivisionID = @DivisionID)
		order by day, PeriodID
