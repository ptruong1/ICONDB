

CREATE PROCEDURE [dbo].[SELECT_ANIsByFacilityID_102814]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        ANINo, StationID, T.Descript as [AccessType] , A.IDrequired, A.PINRequired, A.DayTimeRestrict, 
D.DepartmentName as Division, L.Descript as Location, S.Descript as Status, A.DivisionID, A.LocationID, A.ANINoStatus  
FROM            tblANIs A   with(nolock)
		INNER JOIN tblfacilityDivision D with(nolock) ON A.DivisionID =  D.DivisionID
		INNER JOIN tblfacilityLocation L with(nolock) ON A.LocationID =  L.LocationID
		INNER JOIN tblPhoneStatus S with(nolock) ON A.ANINoStatus =  S.StatusID
		INNER JOIN tblAccessType T  with(nolock)  ON T.AccessTypeID = A.AccessTypeID
WHERE        (A.facilityID = @FacilityID)
ORDER BY A.inputdate DESC;

