

CREATE PROCEDURE [dbo].[SELECT_RecoverPassword]
(
	@UserID varchar(20),
	@Email varchar(30)
)
AS
	SET NOCOUNT ON;
SELECT	UserID,	Password  
FROM tblUserprofiles 
WHERE UserID = @UserID AND Email = @Email

