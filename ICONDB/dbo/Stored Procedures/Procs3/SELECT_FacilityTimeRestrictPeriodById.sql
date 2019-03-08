CREATE PROCEDURE [dbo].[SELECT_FacilityTimeRestrictPeriodById]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        FacilityID, day, FromTime, ToTime, userName, modifydate, PeriodID
FROM            tblFacilityTimeCallPeriod  with(nolock)
WHERE        (FacilityID = @FacilityID)
		order by day, PeriodID
