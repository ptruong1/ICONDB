
CREATE PROCEDURE [dbo].[p_Insert_RecordingListTrans_07142017]
(
	@TranscriptName varchar(50),
	@UserName varchar(25),
	@Words varchar(500),
	@UserIP varchar(25),
	@FacilityID	int

)
AS

SET NOCOUNT OFF;
DECLARE  @count int;
Declare  @return_value int, @nextID int, @ID int, @tblRecordingTranscript nvarchar(32) ;
SET @count = 0;

Declare  @UserAction varchar(100),@ActTime datetime;
SET  @UserAction =  'Insert List Transcript Name:' +  @TranscriptName ;
SELECT @count = COUNT(*) FROM [tblRecordingTranscript] WHERE Username = @UserName AND TranscriptName = @TranscriptName;
IF @count > 0
	RETURN -1;
ELSE
BEGIN
	EXEC [p_get_facility_time] @FacilityID ,@ActTime OUTPUT ;
	EXEC  INSERT_ActivityLogs3	@FacilityID ,41 ,@ActTime, 0,@UserName ,@UserIP, @UserName,@UserAction ;    
	
	EXEC   @return_value = p_create_nextID 'tblRecordingTranscript', @nextID   OUTPUT
                set           @ID = @nextID ;
	INSERT INTO [tblRecordingTranscript] ([TranscriptListID], [TranscriptName], [UserName], Words) VALUES (@ID, @TranscriptName, @UserName, @words)
	RETURN 0;
END

