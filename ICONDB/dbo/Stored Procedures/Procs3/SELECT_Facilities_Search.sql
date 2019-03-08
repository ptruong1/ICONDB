
CREATE PROCEDURE [dbo].[SELECT_Facilities_Search]
@facilityID int
AS
	SET NOCOUNT ON;
SELECT        FacilityID, Location, Address, City, State, Zipcode, ContactName, AgentID
FROM            tblFacility  with(nolock)
	where facilityID = @facilityID
ORDER BY FacilityID DESC

