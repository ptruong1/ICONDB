CREATE PROCEDURE [dbo].[INSERT_GPSTracer]
(
	
	@FacilityID int,
	@TraceBy tinyint,
	@TraceNo varchar(15),
	@TraceInterval tinyint,
	@UserID varchar(20),
	@ModifyDate Datetime
)
AS
	SET NOCOUNT OFF;
INSERT INTO tblGPSTracer ([FacilityID], [TraceBy], [TraceNo], [TraceInterval], [InputBy], [InputDate], [modifydate]) VALUES (@FacilityID, @TraceBy, @TraceNo, @TraceInterval, @UserID, getdate(), @ModifyDate);

EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@UserID,'', @TraceNo
