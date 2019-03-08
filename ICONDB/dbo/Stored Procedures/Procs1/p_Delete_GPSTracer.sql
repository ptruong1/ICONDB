

CREATE PROCEDURE [dbo].[p_Delete_GPSTracer]
(
	@TraceNo char(10),
	@FacilityID int,
	@UserID varchar(20),
	@UserIP varchar(25)
)
AS
	SET NOCOUNT OFF;
	Declare @UserAction varchar(200);	
Set @UserAction = 'Delete GPS Monitor: ' + @TraceNo
EXEC  INSERT_ActivityLogs5   @FacilityID,13, @UserAction, @UserID, @UserIP
DELETE FROM [tblGPSTracer] WHERE (([TraceNo] = @TraceNo) AND ([FacilityID] = @FacilityID))
