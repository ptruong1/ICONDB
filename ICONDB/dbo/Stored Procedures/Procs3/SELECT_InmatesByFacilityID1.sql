CREATE PROCEDURE [dbo].[SELECT_InmatesByFacilityID1]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        InmateID, LastName, FirstName, PIN, MidName, tblInmateStatus.Descipt as [Status]
FROM            tblInmate INNER JOIN tblInmateStatus ON tblInmate.Status = tblInmateStatus.statusID
WHERE facilityID = @FacilityID
ORDER BY inputdate DESC
