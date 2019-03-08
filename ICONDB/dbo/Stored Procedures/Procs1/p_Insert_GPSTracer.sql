CREATE PROCEDURE [dbo].[p_Insert_GPSTracer]
(
	
	@FacilityID int,
	@TraceBy tinyint,
	@TraceNo varchar(15),
	@TraceInterval tinyint,
	@UserID varchar(20),
	@ModifyDate Datetime,
	@UserIP varchar(25)
)
AS
	SET NOCOUNT OFF;
	Declare @UserAction varchar(200);	

INSERT INTO tblGPSTracer ([FacilityID], [TraceBy], [TraceNo], [TraceInterval], [InputBy], [InputDate], [modifydate]) VALUES (@FacilityID, @TraceBy, @TraceNo, @TraceInterval, @UserID, getdate(), @ModifyDate);

--EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@UserID,'', @TraceNo
Set @UserAction = 'Add GPS Monitor: ' + @TraceNo
EXEC  INSERT_ActivityLogs5   @FacilityID,13, @UserAction, @UserID, @UserIP
