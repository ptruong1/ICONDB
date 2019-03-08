


CREATE PROCEDURE [dbo].[INSERT_ActivityLogs3_New]
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
	
	Declare @ActivityTime varchar(25), @return_value int, @nextID int, @ID int, @tblActivityLog nvarchar(32) ;

	EXEC	@return_value = p_create_nextID 'tblActivityLog', @nextID   OUTPUT
	set		@ID = @nextID	;	
	INSERT INTO [tblActivityLog_Test] ([ActivityLogID], [FacilityID], [ActivityID], [RecordID],Acttime,  [Username], [UserIP], [Reference],[UserAction])
					   VALUES (@ID, @FacilityID, @ActivityID, @RecordID,@ActTime, @Username, @UserIP,@reference,@UserAction	);
	Return @@error;
End
	               
	               
	               
