


CREATE PROCEDURE [dbo].[INSERT_ActivityLogs5]
(
	@FacilityID int,
	@ActivityID tinyint,
	@UserAction varchar(500),
	@UserName varchar(25),
	@UserIP varchar(25)

)
AS
Begin
	SET NOCOUNT ON;
	Declare @ActTime datetime;
	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;

	Declare @return_value int, @nextID int, @ID int, @tblActivityLog nvarchar(32) ;

	EXEC	@return_value = p_create_nextID 'tblActivityLog', @nextID   OUTPUT
	set		@ID = @nextID	;
INSERT INTO [tblActivityLog] ([ActivityLogID],[FacilityID], [ActivityID], [RecordID],Acttime,  [Username], [UserIP],  UserAction)
	               VALUES (@ID, @FacilityID, @ActivityID, 0,@ActTime, @Username, @UserIP,@UserAction);
 
	Return @@error;
End

