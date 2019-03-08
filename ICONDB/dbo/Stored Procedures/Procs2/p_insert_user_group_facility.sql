
CREATE PROCEDURE [dbo].[p_insert_user_group_facility]
(
	@FacilityID int,
	@AgentID int,
	@UserGroupID int,
	@MasterUserGroupID int
)
AS

SET NOCOUNT OFF;

	INSERT INTO [tblUserGroupFacility] ( AgentID ,UserGroupID, FacilityID, MasterUserGroupID) VALUES ( @AgentID, @UserGroupID, @FacilityID, @MasterUserGroupID)
	
