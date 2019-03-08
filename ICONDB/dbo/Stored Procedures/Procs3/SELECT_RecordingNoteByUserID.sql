


CREATE PROCEDURE [dbo].[SELECT_RecordingNoteByUserID]
( @NoteID bigint)
AS
	SET NOCOUNT ON;
SELECT        tblRecordingNote.*
FROM            tblRecordingNote
WHERE NoteID = @NoteID



