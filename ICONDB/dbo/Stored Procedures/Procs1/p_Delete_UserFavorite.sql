


CREATE PROCEDURE [dbo].[p_Delete_UserFavorite]
(
	@UserID varchar(20),
	@Title varchar(50),
	@URL varchar(100)
)
AS
SET NOCOUNT ON;
if(@Title ='')
	DELETE FROM [dbo].[tblUserFavorites]      
				where userID = @userID and  url=@URL;
else
	DELETE FROM [dbo].[tblUserFavorites]      
				where userID = @userID and title = @Title and url=@URL;






