CREATE PROCEDURE [dbo].[p_ChangeUserPassword] 
	@id uniqueidentifier,
	@NewPassword varchar(20)
AS
Declare @UserID varchar(20)
Declare @EnCryptPass  varbinary(200)
Select @UserID = UserID from tblResetPassword where TempPassword = @id
If @UserID IS NULL
Begin
	Select 0 as IsPasswordChanged
End
Else
Begin  
    --EXEC [dbo].[LegEncrypt] @NewPassword,	@EnCryptPass  OUTPUT
	Update tblUserprofiles set Password =@NewPassword where UserID=@UserID
	Delete from tblResetPassword where TempPassword = @id
	Select 1 as IsPasswordChanged
End
