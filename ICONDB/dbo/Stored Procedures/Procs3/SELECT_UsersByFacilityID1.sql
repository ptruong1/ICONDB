﻿
CREATE PROCEDURE [dbo].[SELECT_UsersByFacilityID1]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        tblUserprofiles.UserID, tblUserprofiles.LastName, tblUserprofiles.FirstName, tblStatus.Descrip as Status, tblAuth.admin, tblAuth.monitor, tblAuth.finance, tblAuth.dataEntry
FROM            tblUserprofiles  with(nolock)
	  INNER JOIN
                         tblAuth   with(nolock) ON tblUserprofiles.authID = tblAuth.authID
	 INNER JOIN
		tblStatus   with(nolock) ON tblUserprofiles.Status = tblStatus.StatusID
		
WHERE facilityID = @FacilityID
ORDER BY tblUserprofiles.inputdate DESC

