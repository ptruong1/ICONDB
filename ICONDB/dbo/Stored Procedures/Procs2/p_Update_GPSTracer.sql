CREATE PROCEDURE [dbo].[p_Update_GPSTracer]
(
	@FacilityID int,
	@TraceBy tinyint,
	@TraceNo varchar(15),
	@TraceInterval tinyint,
	@UserID varchar(20),
	@ModifyDate Datetime,
	@Original_TraceNo char(10),
	@UserIP varchar(25)
	
)
AS
Declare @UserAction varchar(200);	
Set @UserAction = 'Update GPS Monitor: ' + @TraceNo
EXEC  INSERT_ActivityLogs5   @FacilityID,13, @UserAction, @UserID, @UserIP

IF @TraceNo in (SELECT PhoneNo FROM tblNonRecordPhones WHERE PhoneNo <> @Original_TraceNo AND (FacilityID=@FacilityID or FacilityID=1))
	BEGIN
		RETURN -1;
	END
ELSE
	BEGIN
		UPDATE [tblGPSTracer] 
		SET 	[TraceNo] = @TraceNo,
			[TraceBy]=@TraceBy,
			[TraceInterval]=@TraceInterval,
			[InputBy] = @UserID,
			[modifydate] = @modifydate 
		WHERE TraceNo = @Original_TraceNo and FacilityID = @FacilityID;
		RETURN 0;
	END
	

