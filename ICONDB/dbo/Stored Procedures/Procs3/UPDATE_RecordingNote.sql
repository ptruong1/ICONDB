

CREATE PROCEDURE [dbo].[UPDATE_RecordingNote]
(
	@Note varchar(200),
	@UserName varchar(25),
	@NoteID bigint
)
AS
	SET NOCOUNT OFF;
UPDATE [tblRecordingNote] SET [Note] = @Note, [UserName] = @UserName , [modifyDate] = getdate() WHERE ([NoteID] = @NoteID)

