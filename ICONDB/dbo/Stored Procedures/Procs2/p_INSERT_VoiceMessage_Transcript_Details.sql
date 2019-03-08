
CREATE PROCEDURE [dbo].[p_INSERT_VoiceMessage_Transcript_Details]
(
	@MailBoxId int,
	@MessageId int,
	@TranscriptName varchar(50),
	@UserName varchar(25)
	
)
AS
	SET NOCOUNT OFF;

	DECLARE  @count int;
	DECLARE  @identity int;
SET @count = 0;
set  @identity = 0;


SELECT @count = COUNT(*) FROM [tblRecordingVoiveMessages] WHERE MailBoxId = @MailBoxId and MessageId = @MessageId
IF @count > 0
	RETURN -1;
ELSE
INSERT INTO [tblRecordingVoiveMessages] ([MailBoxId], [MessageId], [TranscriptListID], [Status]) 
VALUES (@MailBoxId, @MessageId, (select TranscriptListID from tblRecordingTranscript WHERE Username = @UserName AND TranscriptName = @TranscriptName), 0);


