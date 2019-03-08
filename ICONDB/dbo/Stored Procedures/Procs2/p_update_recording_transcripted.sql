CREATE PROCEDURE [dbo].[p_update_recording_transcripted]
@TranscriptID	int  ,
@RecordID	int ,
@wordsMatch  int


As


Update    leg_Icon1.dbo.tblRecordingListTrans  SET   [status] =2  where  transcriptListID = @TranscriptID and  recordID = @RecordID
Update    leg_Icon2.dbo.tblRecordingListTrans  SET   [status] =2  where  transcriptListID = @TranscriptID and  recordID = @RecordID

