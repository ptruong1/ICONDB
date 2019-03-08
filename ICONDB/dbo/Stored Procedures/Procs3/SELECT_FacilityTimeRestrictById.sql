
CREATE PROCEDURE [dbo].[SELECT_FacilityTimeRestrictById]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        FacilityID, days, hours, userName, modifydate
FROM            tblFacilityTimeCall  with(nolock)
WHERE        (FacilityID = @FacilityID)

