CREATE PROCEDURE [dbo].[p_Report_Third_Party_Calls1]
@FacilityID  int ,
@AgentID   int,
@fromDate   smalldatetime,  --Required
@toDate	smalldatetime  --Required

 AS
If( @AgentID > 0 ) 
	SELECT B.RecordID, B.RecordDate, A.fromno, A.tono, CAST( CAST(A.duration as numeric(7,2))/60 as Numeric(9,2)) as Duration,  C.Descript, B.CallRevenue, 1 as callsCount
	 FROM tblThirdPartyDectectRecord A 
	 INNER JOIN tblCallsBilled B ON A.recordID = B.RecordID
	 INNER JOIN tblDisconnectType C ON A.detectType = C.DisType
	  where 		
	(B.RecordDate between @fromDate and dateadd(d,1,@todate) ) and A.FacilityID = @FacilityID and AgentID = @AgentID and A.detectType > 0
		order by B.RecordDate desc

Else
	SELECT B.RecordID, B.RecordDate, A.fromno, A.tono, CAST( CAST(A.duration as numeric(7,2))/60 as Numeric(9,2)) as Duration,  C.Descript, B.CallRevenue, 1 as callsCount
	 FROM tblThirdPartyDectectRecord A 
	 INNER JOIN tblCallsBilled B ON A.recordID = B.RecordID
	 INNER JOIN tblDisconnectType C ON A.detectType = C.DisType
	  where 		
	(B.RecordDate between @fromDate and dateadd(d,1,@todate) ) and A.FacilityID = @FacilityID and A.detectType > 0
		order by B.RecordDate desc
