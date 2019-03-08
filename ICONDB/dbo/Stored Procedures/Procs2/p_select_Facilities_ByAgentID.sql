CREATE PROCEDURE [dbo].[p_select_Facilities_ByAgentID]
( 
	@AgentID int,
	@MasterUserGroupID int,
	@UserGroupID int
)
AS
	SET NOCOUNT ON;
If @AgentID = 1
	SELECT    FacilityID, Location, Address, City, State, Zipcode, ContactName,  AgentID,
			             (Select count(*)  as [transcriptOpt] from tblFacilityKeyWords 
	where   tblFacilityKeyWords.FacilityID = tblFacility.FacilityID) as transcriptOpt
	FROM    tblFacility  with(nolock)
	WHERE  status =1
	ORDER BY Location Asc
else
	if (@MasterUserGroupID =@UserGroupID)
	begin
		SELECT FacilityID, Location, Address, City, State, Zipcode, ContactName,  AgentID,
			             (Select count(*)  as [transcriptOpt] from tblFacilityKeyWords 
		where tblFacilityKeyWords.FacilityID = tblFacility.FacilityID) as transcriptOpt
		FROM  tblFacility  with(nolock)
		WHERE AgentID = @AgentID  And status =1
		ORDER BY Location Asc
	end
	else
	begin
		SELECT F.FacilityID, Location, Address, City, State, Zipcode, ContactName,  F.AgentID,
			             (Select count(*)  as [transcriptOpt] from tblFacilityKeyWords 
						  where tblFacilityKeyWords.FacilityID = F.FacilityID) as transcriptOpt
		FROM  tblFacility F with(nolock) join tblUserGroupFacility U with (nolock) on F.FacilityID=U.FacilityID 
		WHERE F.AgentID = @AgentID  And status =1 and MasterUserGroupID= @MasterUserGroupID
		ORDER BY Location Asc
	end
	
