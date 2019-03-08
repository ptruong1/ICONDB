CREATE PROCEDURE [dbo].[SELECT_GPSTracer]
(@FacilityID int)
AS

SET NOCOUNT ON;

If (@FacilityID = 74 or @FacilityID = 75 or @FacilityID =76 )
	
	SELECT [FacilityID], [TraceBy], [TraceNo], [TraceInterval], [InputBy], [InputDate], [ModifyDate] 
		FROM [tblGPSTracer] inner join tblGPSTracerType on tblGPSTracer.TraceBy = tblGPSTracerType.TraceType
		
	WHERE FacilityID = 74 or FacilityID = 75 or FacilityID =76 

else 

	SELECT [FacilityID], [TraceBy], [TraceNo], [TraceInterval], [InputBy], [InputDate], [ModifyDate], tblGPSTracerType.Descript as TraceDescription ,
		tblTraceType.Descript as IntervalDescription 
		FROM [tblGPSTracer] 
		inner join tblGPSTracerType on tblGPSTracer.TraceBy = tblGPSTracerType.TraceType
		inner join tblTraceType on  tblGPSTracer.TraceInterval = tblTraceType.TraceID
		
	WHERE FacilityID = @FacilityID
