



CREATE PROCEDURE [dbo].[INSERT_RecordingPlaylist]
(
	@PlayListName varchar(50),
	@UserName varchar(25)
)
AS

SET NOCOUNT OFF;
DECLARE  @count int;
Declare  @return_value int, @nextID int, @ID int, @tblRecordingPlayList nvarchar(32) ;
SET @count = 0;
SELECT @count = COUNT(*) FROM [tblRecordingPlayList] WHERE Username = @UserName AND PlayListName = @PlayListName;
IF @count > 0
	RETURN -1;
ELSE
BEGIN
    EXEC   @return_value = p_create_nextID 'tblRecordingPlayList', @nextID   OUTPUT
    set           @ID = @nextID ;  
	INSERT INTO [tblRecordingPlayList] ([PlayListID] ,[PlayListName], [UserName]) VALUES (@ID, @PlayListName, @UserName)
	RETURN 0;
END

--SET NOCOUNT OFF;
--DECLARE  @count int;
--SET @count = 0;
--SELECT @count = COUNT(*) FROM [tblRecordingPlayList] WHERE Username = @UserName AND PlayListName = @PlayListName;
--IF @count > 0
--	RETURN -1;
--ELSE
--BEGIN
--	INSERT INTO [tblRecordingPlayList] ([PlayListName], [UserName]) VALUES (@PlayListName, @UserName)
--	RETURN 0;
--END

