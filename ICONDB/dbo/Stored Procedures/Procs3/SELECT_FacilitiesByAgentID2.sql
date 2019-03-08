CREATE PROCEDURE [dbo].[SELECT_FacilitiesByAgentID2]
( 
	@AgentID int
	
)
AS
	SET NOCOUNT ON;
If @AgentID = 1
	SELECT        FacilityID, Location, Address, City, State, Zipcode, ContactName,  AgentID,

		             (Select count(*)  as [transcriptOpt] from tblFacilityKeyWords 
			where   tblFacilityKeyWords.FacilityID = tblFacility.FacilityID) as transcriptOpt
FROM            tblFacility  with(nolock)

WHERE  status =1
	

ORDER BY Location asc

else

SELECT        FacilityID, Location, Address, City, State, Zipcode, ContactName,  AgentID,

		             (Select count(*)  as [transcriptOpt] from tblFacilityKeyWords 
			where   tblFacilityKeyWords.FacilityID = tblFacility.FacilityID) as transcriptOpt
FROM            tblFacility  with(nolock)

WHERE AgentID = @AgentID  And status =1
	

ORDER BY Location asc
