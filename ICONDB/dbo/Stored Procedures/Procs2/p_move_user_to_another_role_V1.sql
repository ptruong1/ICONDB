
Create PROCEDURE [dbo].[p_move_user_to_another_role_V1]
(
	@currentAuthID int,
	@newAuthID int,
	@Username varchar(20),
	@UserID varchar(20),
	@UserIP varchar(25)
)
AS

SET NOCOUNT OFF;
Declare  @UserAction varchar(200) ;
	update [tblUserprofiles] set authID =@newAuthID
    where authID =@currentAuthID and UserID =@UserId
	Set @UserAction = 'Update Auth User  ' + '" ' + @Username + ' "' + ' from' + cast(@currentAuthID as varchar(7)) +' to ' + cast(@newAuthID as varchar(7))
	EXEC  INSERT_ActivityLogs5   @newAuthID ,5, @UserAction, @UserID, @UserIP
	RETURN 0;


