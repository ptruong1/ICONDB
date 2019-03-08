


CREATE PROCEDURE [dbo].[INSERT_ActivityLogs]
(
	@FacilityID int,
	@ActivityID tinyint,
	@RecordID bigint,
	@UserName varchar(25),
	@UserIP varchar(25)
)
AS
	SET NOCOUNT OFF;

Declare @timeZone smallint, @ActTime datetime,@reference varchar(20),@UserAction varchar(200);
Declare @ActivityTime varchar(25);

SET @timeZone = 0;
Select @timeZone = timeZone from tblFacility with(nolock) where FacilityID =  @FacilityID;

--SET  @ActTime = dateadd(hh, @timeZone,getdate());
	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;
    Declare @return_value int, @nextID int, @ID int, @tblActivityLog nvarchar(32) ;
    EXEC	@return_value = p_create_nextID 'tblActivityLog', @nextID   OUTPUT
	set		@ID = @nextID	;

if(@RecordID > 0) SET @reference =CAST(@RecordID as varchar(20));

if (@ActivityID =2) 
  	SET @UserAction = 'Requested to Listen to Recording: ' + CAST (@RecordID as varchar(15));
else if (@ActivityID =3) 
	SET @UserAction = 'Requested to Download Recording: ' + CAST (@RecordID as varchar(15));
else if (@ActivityID =4) 
	SET @UserAction = 'Requested to Add Notes/Markers to Recording: ' + CAST (@RecordID as varchar(15));
else if (@ActivityID =18) 
	SET @UserAction = 'Update Visit Schedule for EndUserID: ' + CAST (@RecordID as varchar(15));
else if (@ActivityID =24) 
	SET @UserAction = 'Requested to Watch Video Visit: ' + CAST (@RecordID as varchar(15));
	else if (@ActivityID =25) 
SET @UserAction = 'Requested to Download Video Visit: ' + CAST (@RecordID as varchar(15));
else if (@ActivityID =26) 
	SET @UserAction = 'Read Email Inmate ID: ' + CAST (@RecordID as varchar(15));
else if (@ActivityID =27) 
	SET @UserAction = 'Requested to Transcribe Recording: ' + CAST (@RecordID as varchar(15));
else if (@ActivityID =28) 
	SET @UserAction = 'Requested to Search Addess: ' + CAST (@RecordID as varchar(15));
else if (@ActivityID =29) 
	SET @UserAction = 'Requested to Watch Video Message: ' + CAST (@RecordID as varchar(15));
else if (@ActivityID =31) 
	SET @UserAction = 'Requested to Listen to Voice Message: ' + CAST (@RecordID as varchar(15));
else if (@ActivityID =32) 
	SET @UserAction = 'Requested to Download Voice  Message: ' + CAST (@RecordID as varchar(15));
else if (@ActivityID =33) 
	SET @UserAction = 'Live Monitor for Video Visit: ' + CAST (@RecordID as varchar(15));
else if (@ActivityID =34) 
	SET @UserAction = 'Live Monitor for Inmate Call: ' + CAST (@RecordID as varchar(15));
else if (@ActivityID =35) 
	SET @UserAction = 'Live Monitor for Phone Visit: ' + CAST (@RecordID as varchar(15));
else if (@ActivityID =39) 
	SET @UserAction = 'Requested to Listen to Recording Phone Visit: ' + CAST (@RecordID as varchar(15));
else if (@ActivityID =40) 
	SET @UserAction = 'Requested to Download  Recording Phone Visit: ' + CAST (@RecordID as varchar(15));
else if (@ActivityID =43) 
	SET @UserAction = 'Added Notes/Markers to Video Visit: ' + CAST (@RecordID as varchar(15));

INSERT INTO [tblActivityLog] ([ActivityLogID],[FacilityID], [ActivityID], [RecordID],Acttime,  [Username], [UserIP], [Reference],  UserAction)
	               VALUES (@ID, @FacilityID, @ActivityID, @RecordID,@ActTime, @Username, @UserIP,@RecordID, @UserAction);


--SET @ActivityTime = convert (varchar(25), @ActTime,109);
--	EXEC [172.77.10.22\bigdaddyicon].Leg_LiveCast.dbo.p_update_user_activity @UserName, @FacilityID, @ActivityID, @UserAction,@ActivityTime;

