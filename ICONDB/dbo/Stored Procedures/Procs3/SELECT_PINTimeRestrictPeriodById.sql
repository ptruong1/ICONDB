CREATE PROCEDURE [dbo].[SELECT_PINTimeRestrictPeriodById]
(
	@FacilityID int,
	@PIN varchar(12)
)
AS
	SET NOCOUNT ON;
SELECT        FacilityID, PIN, day, FromTime, ToTime, userName, modifydate, PeriodID
FROM            tblPINTimeCallPeriod  with(nolock)
WHERE        (FacilityID = @FacilityID) and (PIN = @PIN)
		order by day, PeriodID
