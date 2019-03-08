CREATE PROCEDURE [dbo].[SELECT_InmatesByFacilityID5]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        InmateID, LastName, FirstName, PIN, MidName, tblInmateStatus.Descipt as [Status], isnull(BioRegister,0) as BioRegister
				, isnull(NameRecorded,0) as NameRecorded, isnull(CustodialOpt,0) as CustodialOpt
FROM            tblInmate INNER JOIN tblInmateStatus ON tblInmate.Status = tblInmateStatus.statusID
WHERE facilityID = @FacilityID
ORDER BY inputdate DESC

