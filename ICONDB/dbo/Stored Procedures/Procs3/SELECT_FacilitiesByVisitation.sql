
CREATE PROCEDURE [dbo].[SELECT_FacilitiesByVisitation]


AS
	SET NOCOUNT ON;


SELECT        F.FacilityID, Location, Address, City, State, Zipcode, ContactName,  AgentID,

		             V.VisitOpt, O.Descript
			
FROM            tblFacility F with(nolock), tblVisitFacilityConfig V with(nolock), tblVisitOption O with(nolock)
WHERE  F.facilityID = V.facilityID  and V.VisitOpt <> 0 and V.VisitOpt = O.VisitOptID
	

ORDER BY Location Asc
