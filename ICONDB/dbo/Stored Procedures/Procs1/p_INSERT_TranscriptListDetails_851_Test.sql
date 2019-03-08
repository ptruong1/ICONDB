
Create PROCEDURE [dbo].[p_INSERT_TranscriptListDetails_851_Test]
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
INSERT INTO [tblRecordingListTrans] 
			([RecordID], 
			[TranscriptListID],
			[status]
           ,[processTime]
           ,[InputDate]
           ,[OutStatus]
           ,[InStatus]
           ,[SearchWord])
		    VALUES 
			(@RecordID
			,@TranscriptListID
			,0
           ,Null
           ,GetDate()
           ,0
           ,0
           ,''
			);

update   tblRecordingTranscript  set status = 0 where  transcriptlistid =  @TranscriptListID;

