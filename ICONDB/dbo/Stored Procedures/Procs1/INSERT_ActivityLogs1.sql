


CREATE PROCEDURE [dbo].[INSERT_ActivityLogs1]
(
	@FacilityID int,
	@ActivityID tinyint,
	@RecordID bigint,
	@UserName varchar(25),
	@UserIP varchar(25),
	@reference	varchar(25)
)
AS
	SET NOCOUNT OFF;

Declare @timeZone smallint, @ActTime datetime;
SET @timeZone = 0;
Select @timeZone = timeZone from tblFacility with(nolock) where FacilityID =  @FacilityID;

SET  @ActTime = dateadd(hh, @timeZone,getdate());
if(@RecordID > 0) SET @reference =CAST(@RecordID as varchar(20));

Declare @return_value int, @nextID int, @ID int, @tblActivityLog nvarchar(32) ;

	EXEC	@return_value = p_create_nextID 'tblActivityLog', @nextID   OUTPUT
	set		@ID = @nextID	;
INSERT INTO [tblActivityLog] ([ActivityLogID], [FacilityID], [ActivityID], [RecordID],Acttime,  [Username], [UserIP], [Reference])
	               VALUES (@ID, @FacilityID, @ActivityID, @RecordID,@ActTime, @Username, @UserIP,@reference);
