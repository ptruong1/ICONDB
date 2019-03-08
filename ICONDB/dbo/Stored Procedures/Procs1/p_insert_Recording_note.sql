
CREATE PROCEDURE [dbo].[p_insert_Recording_note]
@userName	varchar(25),
@RecordID	bigint,
@Note		varchar(200)

AS
SET NOCOUNT ON
 INSERT INTO tblRecordingNote(RecordID ,  Note, UserName)

Values( @RecordID, @Note	, @userName)

