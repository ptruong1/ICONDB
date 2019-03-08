
CREATE PROCEDURE [dbo].[p_Report_Third_Party_Calls]
@FacilityID  int ,
@AgentID   int,
@fromDate   smalldatetime,  --Required
@toDate	smalldatetime  --Required

 AS
If( @AgentID > 0 ) 
	SELECT B.RecordID, B.RecordDate, A.fromno, A.tono, dbo.fn_ConvertSecToMin(A.duration) as Duration,  C.Descript, B.CallRevenue
	 FROM tblOutboundCalls A 
	 INNER JOIN tblCallsBilled B ON A.OpseqNo = B.RecordID
	 INNER JOIN tblDisconnectType C ON A.DisconnectType = C.DisType
	  where 		
	(B.RecordDate between @fromDate and dateadd(d,1,@todate) ) and FacilityID = @FacilityID and AgentID = @AgentID and A.DisconnectType > 0
		order by B.RecordDate desc

Else
	SELECT B.RecordID, B.RecordDate, A.fromno, A.tono, dbo.fn_ConvertSecToMin(A.duration) as Duration,  C.Descript, B.CallRevenue
	 FROM tblOutboundCalls A 
	 INNER JOIN tblCallsBilled B ON A.OpseqNo = B.RecordID
	 INNER JOIN tblDisconnectType C ON A.DisconnectType = C.DisType
	  where 		
	(B.RecordDate between @fromDate and dateadd(d,1,@todate) ) and FacilityID = @FacilityID and A.DisconnectType > 0
		order by B.RecordDate desc

