



CREATE PROCEDURE [dbo].[SELECT_FacilitiesByAgentID]
( 
	@AgentID int 
)
AS
	SET NOCOUNT ON;
SELECT        FacilityID, Location, Address, City, State, Zipcode, ContactName,   AgentID
FROM            tblFacility  with(nolock)
WHERE AgentID = @AgentID  and status =1
ORDER BY FacilityID DESC

