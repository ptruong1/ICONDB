

CREATE PROCEDURE [dbo].[SELECT_UsersByFacilityID]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        tblUserprofiles.UserID, tblUserprofiles.LastName, tblUserprofiles.FirstName, tblAuth.admin, tblAuth.monitor, tblAuth.finance, tblAuth.dataEntry
FROM            tblUserprofiles  with(nolock)  INNER JOIN
                         tblAuth   with(nolock) ON tblUserprofiles.authID = tblAuth.authID
WHERE facilityID = @FacilityID
ORDER BY tblUserprofiles.inputdate DESC

