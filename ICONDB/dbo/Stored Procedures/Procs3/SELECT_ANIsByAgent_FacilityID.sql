
CREATE PROCEDURE [dbo].[SELECT_ANIsByAgent_FacilityID] 
(
	@AgentID int,
	@FacilityID int
)
AS
	SET NOCOUNT ON;
	IF @FacilityID = -1

	SELECT tblANIs.PhoneID, (tblANIs.ANINo + ', ' + tblFacility.Location) as ANINo FROM tblANIs 
	INNER JOIN tblFacility ON tblANIs.facilityID = tblFacility.FacilityID
	 WHERE (tblFacility.AgentID = @AgentID)
	order by location

	else

	SELECT tblANIs.PhoneID, (tblANIs.ANINo + ', ' + tblFacility.Location) as ANINo FROM tblANIs 
	INNER JOIN tblFacility ON tblANIs.facilityID = tblFacility.FacilityID
	 WHERE (tblFacility.AgentID = @AgentID) and tblANIs.FacilityID = @FacilityID
	order by location
