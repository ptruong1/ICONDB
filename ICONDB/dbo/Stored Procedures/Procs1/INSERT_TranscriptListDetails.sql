
CREATE PROCEDURE [dbo].[INSERT_TranscriptListDetails]
(
	@RecordID bigint,
	@TranscriptListID int
	
)
AS
	SET NOCOUNT OFF;
DECLARE  @count int;
SET @count = 0;
SELECT @count = COUNT(*) FROM [tblRecordingListTrans] WHERE RecordID = @RecordID;
IF @count > 0
	RETURN -1;
ELSE
INSERT INTO [tblRecordingListTrans] ([RecordID], [TranscriptListID]) VALUES (@RecordID, @TranscriptListID);

update   tblRecordingTranscript  set status = 0 where  transcriptlistid =  @TranscriptListID;

