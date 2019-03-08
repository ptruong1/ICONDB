
CREATE PROCEDURE [dbo].[UPDATE_PlaylistDetails]
(
	@RecordID bigint,
	@PlayListID varchar(200),
	@UserName varchar(25),
	@inputdate smalldatetime,
	@Original_RecordID bigint,
	@Original_PlayListID varchar(200)
)
AS
	SET NOCOUNT OFF;
UPDATE [tblRecordingList] SET [RecordID] = @RecordID, [PlayListID] = @PlayListID, [UserName] = @UserName, [inputdate] = @inputdate WHERE (([RecordID] = @Original_RecordID) AND ([PlayListID] = @Original_PlayListID));
	
SELECT RecordID, PlayListID, UserName, inputDate FROM tblRecordingList WHERE (PlayListID = @PlayListID) AND (RecordID = @RecordID)

