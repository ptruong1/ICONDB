
Create PROCEDURE [dbo].[p_INSERT_TranscriptListDetails_851]
(
	@RecordID bigint,
	@TranscriptName varchar(50),
	@UserName varchar(25),
	@Word varchar(100)
	
)
AS
	SET NOCOUNT OFF;

	DECLARE  @count int;
	DECLARE  @identity int;
SET @count = 0;
set  @identity = 0;


SELECT @count = COUNT(*) FROM [tblRecordingListTrans] WHERE RecordID = @RecordID;
IF @count > 0
	RETURN -1;
ELSE
INSERT INTO [tblRecordingListTrans_851] ([RecordID], [TranscriptListID], SearchWord, [Status]) VALUES (@RecordID, 
(select TranscriptListID from tblRecordingTranscript WHERE Username = @UserName AND TranscriptName = @TranscriptName), @Word, 0);


