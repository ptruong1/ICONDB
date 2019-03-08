
CREATE PROCEDURE [dbo].[p_Delete_user_groups]
(
	@UserGroupName varchar(30),
	@UserGroupID int,
	@UserID varchar(20),
	@AgentID int,
	@UserIP varchar(25)
)
AS
SET NOCOUNT OFF;
Declare @UserAction varchar(200)
Delete From [tblUserGroup] where UserGroupID = @UserGroupID 
Delete From tblUserGroupFacility where UserGroupID =@UserGroupID and AgentID =@AgentID

UPDATE [tblUserprofiles] SET  UserGroupID= -1, MasterUserGroupID = -1 WHERE UserGroupID = @UserGroupID; 

Set @UserAction = 'Delete User Group: " ' + @UserGroupName + ' "'
EXEC  INSERT_ActivityLogs5   @AgentID,53, @UserAction, @UserID, @UserIP


