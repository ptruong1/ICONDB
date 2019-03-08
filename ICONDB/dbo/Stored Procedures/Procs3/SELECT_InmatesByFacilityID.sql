

CREATE PROCEDURE [dbo].[SELECT_InmatesByFacilityID]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        InmateID, LastName, FirstName, PIN, MidName, tblStatus.descrip as [Status]
FROM            tblInmate INNER JOIN tblStatus ON tblInmate.Status = tblStatus.statusID
WHERE facilityID = @FacilityID
ORDER BY inputdate DESC
