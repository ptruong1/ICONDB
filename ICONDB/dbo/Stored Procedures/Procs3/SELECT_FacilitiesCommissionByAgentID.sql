CREATE PROCEDURE [dbo].[SELECT_FacilitiesCommissionByAgentID]
( 
	
	@AgentID int
	
)
AS
	SET NOCOUNT ON;
If @AgentID = 1
	SELECT        FacilityID, Location
		FROM            tblFacility  with(nolock)
		             
			where   AgentID = @AgentID and 
				status =1
	and facilityID not in (select facilityID from tblCommRate)


ORDER BY Location Asc
else
	SELECT        AgentID, Company
		FROM            tblAgent  with(nolock)
		             
			where  AgentID not in (select AgentID from tblCommRateAgent)
	
	ORDER BY Company Asc
