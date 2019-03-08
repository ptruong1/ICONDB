-- =============================================
-- Author:		<Paul>
-- Create date: <2/6/2012>
-- Description:	<GPS >
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_GPS_tracer] 
@PIN varchar(12),
@toNo	varchar(16),
@facilityID int,
@traceFreg	tinyint output
AS
BEGIN
	
	SET NOCOUNT ON;
	SET @traceFreg =0;
	if(@PIN <>'')
		select @traceFreg = TraceInterval From tblGPSTracer with(nolock) where facilityID =@facilityID and  TraceNo= @PIN and TraceBy =2;
	if(  @traceFreg > 0) 
		return 0;
	if(@toNo <> '')
		select @traceFreg = TraceInterval From tblGPSTracer with(nolock) where facilityID =@facilityID and  TraceNo= @toNo  and TraceBy =1;
		
	if(@traceFreg >3)
		SET @traceFreg =3;	
	return 0;
END

