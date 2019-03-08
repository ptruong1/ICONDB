
CREATE PROCEDURE [dbo].[p_update_user_group_facility]
(
	@FacilityID int,
	@AgentID int,
	@UserGroupID int
)
AS

SET NOCOUNT OFF;

INSERT INTO [tblUserGroupFacility] ( AgentID ,UserGroupID, FacilityID) VALUES ( @AgentID, @UserGroupID, @FacilityID)
--IF (SELECT count(UserGroupID) FROM [tblUserGroupFacility] WHERE UserGroupID = @UserGroupID and FacilityID=@FacilityID) =0 
--	BEGIN
--		INSERT INTO [tblUserGroupFacility] ( AgentID ,UserGroupID, FacilityID) VALUES ( @AgentID, @UserGroupID, @FacilityID)
--	END
