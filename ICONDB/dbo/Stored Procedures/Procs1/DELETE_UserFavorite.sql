


CREATE PROCEDURE [dbo].[DELETE_UserFavorite]
(
	@UserID varchar(20),
	@Title varchar(50),
	@URL varchar(100)
)
AS
DELETE FROM [dbo].[tblUserFavorites]
      FROM [leg_Icon].[dbo].[tblUserFavorites]
  where userID = @userID and title = @Title and url=@URL

