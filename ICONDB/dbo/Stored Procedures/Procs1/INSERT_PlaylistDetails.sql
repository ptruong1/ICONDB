

CREATE PROCEDURE [dbo].[INSERT_PlaylistDetails]
(
	@RecordID bigint,
	@PlayListID int,
	@UserName varchar(25)
)
AS
	SET NOCOUNT OFF;
INSERT INTO [tblRecordingList] ([RecordID], [PlayListID], [UserName]) VALUES (@RecordID, @PlayListID, @UserName)

