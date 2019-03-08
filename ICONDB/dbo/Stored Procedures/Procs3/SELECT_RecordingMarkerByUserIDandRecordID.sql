







CREATE PROCEDURE [dbo].[SELECT_RecordingMarkerByUserIDandRecordID]
( 
	@UserID varchar(25),
	@RecordID bigint
)
AS
	SET NOCOUNT ON;
SELECT        NoteID,RecordID,Note,PlayMark,RecordingMarkerName,Username,InputDate
FROM            tblRecordingNote   with(nolock)
WHERE UserName = @UserID AND RecordID = @RecordID

