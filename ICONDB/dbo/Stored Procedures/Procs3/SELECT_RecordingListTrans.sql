
CREATE PROCEDURE [dbo].[SELECT_RecordingListTrans]
(
	@TranscriptListID int
 	
)
AS

SET NOCOUNT OFF;

SELECT  TranscriptName, Words  FROM [tblRecordingTranscript] WHERE TranscriptListID = @TranscriptListID

