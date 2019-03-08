CREATE PROCEDURE [dbo].[SELECT_InmatesByFacilityID2]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT       tblInmate.InmateID, LastName, FirstName, tblInmate.PIN, MidName, tblInmateStatus.Descipt as [Status], BookingNo, BirthDate
FROM            tblInmate INNER JOIN tblInmateStatus ON tblInmate.Status = tblInmateStatus.statusID
		INNER join tblInmateInfo ON tblInmate.PIN = tblInmateInfo.PIN and tblInmate.facilityID = tblInmateInfo.FacilityID
WHERE tblInmate.facilityID = @facilityID
ORDER BY inputdate DESC