
CREATE PROCEDURE [dbo].[p_delete_RecordingListTrans]
(
	@UserName varchar(25),
	@TranscriptListID int
	)
AS

SET NOCOUNT OFF;
DELETE FROM [tblRecordingTranscript] WHERE (([UserName] = @UserName) and TranscriptListID = @TranscriptListID)


