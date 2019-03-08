
CREATE PROCEDURE [dbo].[p_select_RecordingListTrans]
(
	@UserName varchar(25)
	)
AS

SET NOCOUNT OFF;

SELECT TranscriptListID, TranscriptName, Words FROM [tblRecordingTranscript] 
WHERE Username = @UserName and TranscriptName <> @UserName


