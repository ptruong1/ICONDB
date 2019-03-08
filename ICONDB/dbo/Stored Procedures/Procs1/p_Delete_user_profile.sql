
create PROCEDURE [dbo].[p_Delete_user_profile]
(
	@AuthId int,
	@UserID varchar(20),
	@UserIP varchar(25)
)
AS
SET NOCOUNT OFF;
Declare @UserAction varchar(200)

DELETE FROM [dbo].tblUserprofiles WHERE AuthID = @AuthId and UserID=@UserID

Set @UserAction = 'Delete User Group: " ' + @UserID + ' "'
EXEC  INSERT_ActivityLogs5   @AuthId,5, @UserAction, @UserID, @UserIP


