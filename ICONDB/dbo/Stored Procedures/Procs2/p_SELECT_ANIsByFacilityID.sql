

CREATE PROCEDURE [dbo].[p_SELECT_ANIsByFacilityID]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        ANINo, StationID, S.Descript as PhoneStatus,  D.DepartmentName as Division, S2.Descript as DivisionStatus, L.Descript as Location, S1.Descript as LocationStatus,   A.DivisionID, A.LocationID,			
				A.IDrequired, A.PINRequired, A.DayTimeRestrict, T.Descript as [AccessType]  ,D.DivisonStatus as DivisionStatusID, L.LocationStatus as LocationStatusID , A.ANINoStatus as PhoneStatusID
FROM            tblANIs A   with(nolock)
		INNER JOIN tblfacilityDivision D with(nolock) ON A.DivisionID =  D.DivisionID
		INNER JOIN tblfacilityLocation L with(nolock) ON A.LocationID =  L.LocationID
		INNER JOIN tblPhoneStatus S with(nolock) ON A.ANINoStatus =  S.StatusID
		INNER JOIN tblAccessType T  with(nolock)  ON T.AccessTypeID = A.AccessTypeID
		INNER JOIN tblPhoneStatus S1  with(nolock)  ON L.LocationStatus = S1.StatusID
		INNER JOIN tblPhoneStatus S2  with(nolock)  ON D.DivisonStatus = S2.StatusID
WHERE        (A.facilityID = @facilityId)
ORDER BY A.inputdate DESC;

