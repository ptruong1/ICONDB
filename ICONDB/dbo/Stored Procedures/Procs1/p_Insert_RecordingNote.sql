


CREATE PROCEDURE [dbo].[p_Insert_RecordingNote]
(
	@RecordID bigint,
	@Note varchar(200),
	@PlayMark int,
	@RecordingMarkerName varchar(25),
	@UserName varchar(25),
	@UserIP varchar(25)
)
AS
	SET NOCOUNT OFF;
	
	
Declare @facilityID int
Declare  @UserAction varchar(100),@ActTime datetime;
SET  @UserAction =  'Added Notes/Markers to Recording RecordID: ' + CAST (@RecordID as varchar(15));
select @facilityID =facilityID, @UserName= a.username   from tblUserLogs a inner join tblUserprofiles  b on (a.userName = b.UserID ) 
Where a.userName=  @UserName

EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;

EXEC  INSERT_ActivityLogs3	@FacilityID ,4 ,@ActTime, 0,@UserName ,@UserIP, @RecordID,@UserAction ;  

INSERT INTO [tblRecordingNote] ([RecordID], [Note], [PlayMark], [RecordingMarkerName], [UserName], [modifyDate]) VALUES (@RecordID, @Note, @PlayMark, @RecordingMarkerName, @UserName, getdate());


