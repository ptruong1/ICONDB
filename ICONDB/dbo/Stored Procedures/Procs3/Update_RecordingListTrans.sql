
CREATE PROCEDURE [dbo].[Update_RecordingListTrans]
(
	@TranscriptListID int,
	@TranscriptName varchar(50),
	@Words varchar(500)
)
AS

SET NOCOUNT OFF;

UPDATE [tblRecordingTranscript]  SET  [Words] = @Words, [TranscriptName]=@TranscriptName  WHERE TranscriptListID = @TranscriptListID;

