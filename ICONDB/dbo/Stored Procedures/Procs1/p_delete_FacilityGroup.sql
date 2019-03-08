
CREATE PROCEDURE [dbo].[p_delete_FacilityGroup]
(
	@GroupId int,
	@UserID varchar(20),
	@AgentId int,
	@UserIP varchar(25)
)
AS
	SET NOCOUNT OFF;
Declare @UserAction varchar(200), @currentGroupName varchar(200);
select @currentGroupName = GroupName from tblFacilityGroups	WHERE GroupId=@GroupId
DELETE FROM tblFacilityGroups WHERE [GroupId] = @GroupId

Delete FROM tblFacilityGroupDetail WHERE [GroupId] = @GroupId

Set @UserAction = 'Delete Facility Group Name: ' + @currentGroupName 
EXEC  INSERT_ActivityLogs5   @AgentId,12, @UserAction, @UserID, @UserIP


