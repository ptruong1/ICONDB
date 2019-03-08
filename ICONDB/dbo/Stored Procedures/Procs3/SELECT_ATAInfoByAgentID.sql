
CREATE PROCEDURE [dbo].[SELECT_ATAInfoByAgentID] 
(
	@AgentID int
)
AS
	SET NOCOUNT ON;

	SELECT        U.FacilityID, Location, ATAIP, ATASubnet, ATAlocation, B.Descrip
	FROM            tblFacilityATAInfo U   with(nolock)
	 INNER JOIN    tblFacility A  with(nolock) ON U.FacilityID = A.FacilityID
	INNER JOIN    tblStatus  B  with(nolock) ON U.Status = B.StatusID
	WHERE	U. AgentID = @AgentID

