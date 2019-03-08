
CREATE PROCEDURE [dbo].[SELECT_Playlists]
AS
	SET NOCOUNT ON;
SELECT        RecordID, PlayListID, UserName,inputdate
FROM            tblRecordingList   with(nolock)

