CREATE PROCEDURE [dbo].[p_insert_userfavorite]
(
	@UserID varchar(20),
	@Title varchar(50),
	@URL varchar(100),
	@ID smallint
	)
AS

SET NOCOUNT OFF;

IF (SELECT Count (*) FROM tblUserFavorites where UserID =@UserID and URL = @URL and Title =@Title) >0
	BEGIN
	   UPDATE [tblUserFavorites] SET InputDate =GETDATE(), ModifyDate =GETDATE()
	END
ELSE
	BEGIN
	  INSERT INTO [tblUserFavorites] ([UserID], [Title], [URL], [InputDate], [ModifyDate], [ID]) VALUES (@UserID, @Title, @URL, GETDATE(), GETDATE(), @ID)
	END

