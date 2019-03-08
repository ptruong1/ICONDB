
CREATE PROCEDURE [dbo].[p_update_user_group]
(
	@UserGroupName varchar(30),
	@Descript varchar(50),
	@UserID varchar(20),
	@UserIP varchar(25),
	@UserGroupID int 
)
AS

SET NOCOUNT OFF;
Declare  @UserAction varchar(200) ;
	update [tblUserGroup] set UserGroupName =@UserGroupName, Descript=@Descript
    where UserGroupID =@UserGroupID
	
	DELETE FROM [tblUserGroupFacility] WHERE ((UserGroupID = @UserGroupID))
	Set @UserAction = 'Update User Groups ' + '" ' + cast(@UserGroupID as varchar(5)) + ' "'
	EXEC  INSERT_ActivityLogs5   @UserGroupID ,54, @UserAction, @UserID, @UserIP
	RETURN 0;


