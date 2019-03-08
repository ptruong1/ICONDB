

CREATE PROCEDURE [dbo].[SELECT_ANIsByFacilityID]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        ANINo, StationID, T.Descript as [AccessType] , A.IDrequired, PINRequired, DayTimeRestrict
FROM            tblANIs A   with(nolock) INNER JOIN tblAccessType T  with(nolock)  ON T.AccessTypeID = A.AccessTypeID
WHERE        (facilityID = @FacilityID)
ORDER BY inputdate DESC

