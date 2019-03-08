


CREATE PROCEDURE [dbo].[INSERT_ActivityLogs3_test]
(
	@FacilityID int,
	@ActivityID tinyint,
	@ActTime datetime,
	@RecordID bigint,
	@UserName varchar(25),
	@UserIP varchar(25),
	@reference	varchar(25),
	@UserAction	varchar(500)
)
AS
Begin
	SET NOCOUNT ON;
	Declare @ActivityTime varchar(25);
	INSERT INTO [tblActivityLog] ([FacilityID], [ActivityID], [RecordID],Acttime,  [Username], [UserIP], [Reference],[UserAction])
					   VALUES (@FacilityID, @ActivityID, @RecordID,@ActTime, @Username, @UserIP,@reference,@UserAction	);
    SET @ActivityTime = convert (varchar(25), @ActTime,109);
	EXEC [172.77.10.22\bigdaddyicon].Leg_LiveCast.dbo.p_update_user_activity @UserName, @FacilityID, @ActivityID, @UserAction,@ActivityTime;
   -- Update [172.77.10.22\bigdaddyicon].Leg_LiveCast.dbo.tblLiveUserAct set activityID = @ActivityID, activity =@UserAction, activitytime= @ActivityTime
			--where userID = @UserName and facilityID = @ActivityID;
	Return @@error;
End
	               
	               
	               
