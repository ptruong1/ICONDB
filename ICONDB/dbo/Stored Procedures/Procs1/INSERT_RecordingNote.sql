


CREATE PROCEDURE [dbo].[INSERT_RecordingNote]
(
	@RecordID bigint,
	@Note varchar(200),
	@PlayMark int,
	@RecordingMarkerName varchar(25),
	@UserName varchar(25)
)
AS
	SET NOCOUNT OFF;
	Declare  @return_value int, @nextID int, @ID int, @tblRecordingNote nvarchar(32) ;
    EXEC   @return_value = p_create_nextID 'tblRecordingNote', @nextID   OUTPUT
    set           @ID = @nextID ;  
    INSERT INTO [tblRecordingNote] ([NoteID] ,[RecordID], [Note], [PlayMark], [RecordingMarkerName], [UserName], [modifyDate])
         VALUES (@ID, @RecordID, @Note, @PlayMark, @RecordingMarkerName, @UserName, getdate());

--INSERT INTO [tblRecordingNote] ([RecordID], [Note], [PlayMark], [RecordingMarkerName], [UserName], [modifyDate]) VALUES (@RecordID, @Note, @PlayMark, @RecordingMarkerName, @UserName, getdate());

