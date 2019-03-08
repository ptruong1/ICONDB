

CREATE PROCEDURE [dbo].[INSERT_UserSetting]
(
	@UserID varchar(80)
     ,@UserSaveSettings nvarchar(max)
)
AS
	SET NOCOUNT OFF;
Declare @PIN varchar(12), @i int

IF (SELECT Count( userID)  FROM [tblUserSetting_Test] WHERE UserID  = @UserID and UserSaveSettings=@UserSaveSettings)  >0
	UPDATE tblUserSetting_Test 
	set UserID=@UserID
		,UserSaveSettings=@UserSaveSettings
	where UserID = @userID
	
ELSE
	BEGIN
			
		INSERT INTO [tblUserSetting_Test]
           ([UserID]
           ,[UserSaveSettings])
     VALUES
           (@userID
           ,@UserSaveSettings)
	END

