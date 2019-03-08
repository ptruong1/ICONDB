CREATE PROCEDURE [dbo].[SELECT_FacilitiesByCommAgent]
( 
	@AgentID int
	
)
AS
	SET NOCOUNT ON;

SELECT        FacilityID, Location
		             
FROM            tblFacility  with(nolock)

WHERE AgentID = @AgentID  And status =1
	

ORDER BY FacilityID Asc
