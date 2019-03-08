CREATE PROCEDURE [dbo].[Delete_FacilityTimeRestrict]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
DELETE FROM  tblFacilityTimeCall   
WHERE        (FacilityID = @FacilityID)
