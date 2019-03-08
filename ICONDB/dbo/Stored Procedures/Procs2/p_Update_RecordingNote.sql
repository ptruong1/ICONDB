

CREATE PROCEDURE [dbo].[p_Update_RecordingNote]
(
	@Note varchar(200),
	@UserName varchar(25),
	@NoteID bigint,
	@UserIP varchar(25)
)
AS
	SET NOCOUNT OFF;
	
Declare @facilityID int
Declare  @UserAction varchar(100),@ActTime datetime;
SET  @UserAction =  'Update Notes/Markers to Recording Note: ' + @Note;
select @facilityID =facilityID, @UserName= a.username   from tblUserLogs a inner join tblUserprofiles  b on (a.userName = b.UserID ) 
Where a.userName=  @UserName


EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;

EXEC  INSERT_ActivityLogs3	@FacilityID ,4 ,@ActTime, 0,@UserName ,@UserIP, @Note,@UserAction ;  

UPDATE [tblRecordingNote] SET [Note] = @Note, [UserName] = @UserName , [modifyDate] = getdate() WHERE ([NoteID] = @NoteID)

