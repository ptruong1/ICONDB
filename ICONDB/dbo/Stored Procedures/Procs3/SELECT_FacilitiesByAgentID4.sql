CREATE PROCEDURE [dbo].[SELECT_FacilitiesByAgentID4]
( 
	@AgentID int
	
)
AS
	SET NOCOUNT ON;

SELECT        FacilityID, '(' + CAST(facilityID as CHAR(4)) + ')' + Location as Location, Address, City, State, Zipcode, ContactName,  AgentID

FROM            tblFacility  with(nolock)

WHERE AgentID = @AgentID  And status =1
	

ORDER BY Location Asc
