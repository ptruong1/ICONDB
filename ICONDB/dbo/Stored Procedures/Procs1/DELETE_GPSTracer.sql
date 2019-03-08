

CREATE PROCEDURE [dbo].[DELETE_GPSTracer]
(
	@TraceNo char(10),
	@FacilityID int
)
AS
	SET NOCOUNT OFF;
DELETE FROM [tblGPSTracer] WHERE (([TraceNo] = @TraceNo) AND ([FacilityID] = @FacilityID))
