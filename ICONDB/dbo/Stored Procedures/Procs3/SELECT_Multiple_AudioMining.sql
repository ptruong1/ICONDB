
CREATE PROCEDURE [dbo].[SELECT_Multiple_AudioMining]

( 
	@AgentID int
	
)
AS
	SET NOCOUNT ON;
If @AgentID = 1
	SELECT        FacilityID, Location, Address, City, State, Zipcode, ContactName,  AgentID,

		             (Select count(*)  as [transcriptOpt] from tblFacilityOption 
			where   tblFacilityOption.FacilityID = tblFacility.FacilityID) as transcriptOpt
FROM            tblFacility  with(nolock)

WHERE  status =1
	

ORDER BY FacilityID DESC

else

SELECT        FacilityID, Location, Address, City, State, Zipcode, ContactName,  AgentID,

		             (Select count(*)  as [transcriptOpt] from tblFacilityOption 
			where   tblFacilityOption.FacilityID = tblFacility.FacilityID) as transcriptOpt
FROM            tblFacility  with(nolock)

WHERE AgentID = @AgentID  And status =1
	

ORDER BY Location Asc
