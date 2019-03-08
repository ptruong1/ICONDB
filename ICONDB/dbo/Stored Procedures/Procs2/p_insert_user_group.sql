
CREATE PROCEDURE [dbo].[p_insert_user_group]
(
	@UserGroupName varchar(30),
	@Descript varchar(50),
	@UserID varchar(20),
	@AgentID int,
	@UserIP varchar(25),
	@UserGroupID int output
)
AS

SET NOCOUNT OFF;
DECLARE  @count int;
Declare  @return_value int, @nextID int, @ID int, @tblUserGroup nvarchar(32), @UserAction varchar(200) ;
SET @count = 0;
SELECT @count = COUNT(*) FROM [tblUserGroup] WHERE UserGroupName = @UserGroupName AND Descript = @Descript;
IF @count > 0
	RETURN -1;
ELSE
BEGIN
    EXEC   @return_value = p_create_nextID 'tblUserGroup', @nextID   OUTPUT
	set @UserGroupID =@nextID
    set           @ID = @nextID ;  
	INSERT INTO [tblUserGroup] (UserGroupID, UserGroupName ,Descript) VALUES (@ID, @UserGroupName, @Descript)
	
	Set @UserAction = 'Insert User Groups ' + '" ' + @UserGroupName + ' "'
	EXEC  INSERT_ActivityLogs5   @AgentID,52, @UserAction, @UserID, @UserIP
	RETURN 0;
END

