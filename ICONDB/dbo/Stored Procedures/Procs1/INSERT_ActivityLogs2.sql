


CREATE PROCEDURE [dbo].[INSERT_ActivityLogs2]
(
	@FacilityID int,
	@ActivityID tinyint,
	@RecordID bigint,
	@UserName varchar(25),
	@UserIP varchar(25),
	@reference	varchar(25),
	@UserAction	varchar(500)
)
AS
SET NOCOUNT ON;

Declare @timeZone smallint, @ActTime datetime,@ActivityTime varchar(25);
SET @timeZone = 0;
Select @timeZone = timeZone from tblFacility with(nolock) where FacilityID =  @FacilityID;

SET  @ActTime = dateadd(hh, @timeZone,getdate());

Declare @return_value int, @nextID int, @ID int, @tblActivityLog nvarchar(32) ;

	EXEC	@return_value = p_create_nextID 'tblActivityLog', @nextID   OUTPUT
	set		@ID = @nextID	;	
	INSERT INTO [tblActivityLog] ([ActivityLogID], [FacilityID], [ActivityID], [RecordID],Acttime,  [Username], [UserIP], [Reference],[UserAction])
					   VALUES (@ID, @FacilityID, @ActivityID, @RecordID,@ActTime, @Username, @UserIP,@reference,@UserAction	);	

--INSERT INTO [tblActivityLog] ([FacilityID], [ActivityID], [RecordID],Acttime,  [Username], [UserIP], [Reference],[UserAction])
--	               VALUES (@FacilityID, @ActivityID, @RecordID,@ActTime, @Username, @UserIP,@reference,@UserAction	);


--SET @ActivityTime = convert (varchar(25), @ActTime,109);
--	EXEC [172.77.10.22\bigdaddyicon].Leg_LiveCast.dbo.p_update_user_activity @UserName, @FacilityID, @ActivityID, @UserAction,@ActivityTime;

