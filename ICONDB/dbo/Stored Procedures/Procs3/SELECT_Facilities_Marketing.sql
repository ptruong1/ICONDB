


CREATE PROCEDURE [dbo].[SELECT_Facilities_Marketing]
AS
	SET NOCOUNT ON;
SELECT        FacilityID, Location, Address, City, State, Zipcode, ContactName,  AgentID
FROM            tblFacility  with(nolock)
ORDER BY Location asc

