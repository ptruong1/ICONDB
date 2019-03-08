CREATE PROCEDURE [dbo].[Delete_FacilityTimeRestrictPeriodById]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
DELETE FROM  tblFacilityTimeCallPeriod  
WHERE        (FacilityID = @FacilityID)
