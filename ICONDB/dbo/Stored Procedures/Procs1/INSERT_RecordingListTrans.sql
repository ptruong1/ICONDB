
CREATE PROCEDURE [dbo].[INSERT_RecordingListTrans]
(
	@TranscriptName varchar(50),
	@UserName varchar(25),
	@Words varchar(500)
)
AS

SET NOCOUNT OFF;
DECLARE  @count int;
Declare  @return_value int, @nextID int, @ID int, @tblRecordingTranscript nvarchar(32) ;
SET @count = 0;
SELECT @count = COUNT(*) FROM [tblRecordingTranscript] WHERE Username = @UserName AND TranscriptName = @TranscriptName;
IF @count > 0
	RETURN -1;
ELSE
BEGIN
    EXEC   @return_value = p_create_nextID 'tblRecordingTranscript', @nextID   OUTPUT
    set           @ID = @nextID ;    
	INSERT INTO [tblRecordingTranscript] ([TranscriptListID] ,[TranscriptName], [UserName], Words) 
		VALUES (@ID, @TranscriptName, @UserName, @words)
	RETURN 0;
END


--SET NOCOUNT OFF;
--DECLARE  @count int;
--SET @count = 0;
--SELECT @count = COUNT(*) FROM [tblRecordingTranscript] WHERE Username = @UserName AND TranscriptName = @TranscriptName;
--IF @count > 0
--	RETURN -1;
--ELSE
--BEGIN
--	INSERT INTO [tblRecordingTranscript] ([TranscriptName], [UserName], Words) VALUES (@TranscriptName, @UserName, @words)
--	RETURN 0;
--END

