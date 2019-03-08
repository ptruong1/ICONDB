
CREATE PROCEDURE [dbo].[SELECT_ANIsByAgentID] 
(
	@AgentID int
)
AS
	SET NOCOUNT ON;

	SELECT tblANIs.PhoneID, (tblANIs.ANINo + ', ' + tblFacility.Location) as ANINo FROM tblANIs 
	INNER JOIN tblFacility ON tblANIs.facilityID = tblFacility.FacilityID
	 WHERE (tblFacility.AgentID = @AgentID)
	order by location
