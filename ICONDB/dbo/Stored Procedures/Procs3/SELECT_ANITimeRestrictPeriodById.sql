CREATE PROCEDURE [dbo].[SELECT_ANITimeRestrictPeriodById]
(
	@FacilityID int,
	@ANINo varchar(12)
)
AS
	SET NOCOUNT ON;
SELECT        FacilityID, ANI, day, FromTime, ToTime, userName, modifydate, PeriodID
FROM            tblANITimeCallPeriod  with(nolock)
WHERE        (FacilityID = @FacilityID) and (ANI = @ANINo)
		order by day, PeriodID
