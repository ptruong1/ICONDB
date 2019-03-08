


CREATE PROCEDURE [dbo].[INSERT_ActivityLogs4]
(
	@FacilityID int,
	@ActivityID tinyint,
	@ID bigint,
	@UserName varchar(25),
	@UserIP varchar(25)

)
AS
Begin
	SET NOCOUNT ON;
	Declare @UserAction varchar(500),@ActTime datetime, @reference	varchar(25);
	set @reference = @ID
	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;
	select @UserAction = Descript from tblActivity where ActivityID = @ActivityID
	set @UserAction = @UserAction + ': ' + CAST (@ID as varchar(15))

	Declare @ActivityTime varchar(25), @return_value int, @nextID int, @LogID int, @tblActivityLog nvarchar(32) ;

	EXEC	@return_value = p_create_nextID 'tblActivityLog', @nextID   OUTPUT
	set		@LogID = @nextID	;	
	INSERT INTO [tblActivityLog] ([ActivityLogID], [FacilityID], [ActivityID], [RecordID],Acttime,  [Username], [UserIP], [Reference],[UserAction])
					   VALUES (@LogID, @FacilityID, @ActivityID, 0,@ActTime, @Username, @UserIP,@reference,@UserAction	);
	Return @@error;
End

