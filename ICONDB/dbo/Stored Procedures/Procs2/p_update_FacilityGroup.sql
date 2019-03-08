
Create PROCEDURE [dbo].[p_update_FacilityGroup]
(
	@GroupId int,
	@UserID varchar(20),
	@AgentId int,
	@GroupName varchar(30),
	@UserIP varchar(25)
)
AS
	SET NOCOUNT OFF;
Declare @UserAction varchar(200), @currentGroupName varchar(200);
select @currentGroupName = GroupName from tblFacilityGroups	WHERE GroupId=@GroupId
UPDATE tblFacilityGroups SET GroupName=@GroupName WHERE @GroupId=@GroupId

Set @UserAction = 'Update GroupName from ' + @currentGroupName + ' to ' + @GroupName
EXEC  INSERT_ActivityLogs5   @AgentId,12, @UserAction, @UserID, @UserIP


