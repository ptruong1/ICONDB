Create PROCEDURE [dbo].[p_Report_Inmate_Suspicious_851]
@FacilityID  int ,
@AgentID   int,
@fromDate   smalldatetime,  --Required
@toDate	smalldatetime  --Required

 AS
If( @AgentID > 1 ) 
	SELECT B.RecordID, B.RecordDate, A.PIN, I.Firstname as FName, I.LastName as LName, A.fromno, A.tono, 
	CAST( CAST(A.duration as numeric(7,2))/60 as Numeric(9,2)) as Duration,  C.Descript, B.CallRevenue, 1 as callsCount
	, A.DetectTime, ThirdParty1, ThirdParty2, ThirdParty3, B.RecordFile
	 FROM tblInmateSuspiciousDectectRecord A 
	 INNER JOIN tblCallsBilled B ON A.recordID = B.RecordID
	 INNER JOIN tblInmate I ON A.PIN = I.PIN and A.FacilityID = I.FacilityId
	 INNER JOIN tblDisconnectType C ON A.detectType = C.DisType
	  where 		
	(B.RecordDate between @fromDate and dateadd(d,1,@todate) ) and A.FacilityID in (select FacilityID from tblfacility F where  F.AgentID = @AgentID) and A.detectType > 0
		order by B.RecordDate desc

Else
	SELECT B.RecordID, B.RecordDate, A.PIN, I.Firstname as FName, I.LastName as LName, A.fromno, A.tono, CAST( CAST(A.duration as numeric(7,2))/60 as Numeric(9,2)) as Duration,  C.Descript, B.CallRevenue, 1 as callsCount
	, A.DetectTime, ThirdParty1, ThirdParty2, ThirdParty3, B.RecordFile
	 FROM tblInmateSuspiciousDectectRecord A 
	 INNER JOIN tblCallsBilled B ON A.recordID = B.RecordID
	 INNER JOIN tblInmate I ON A.PIN = I.PIN and A.FacilityID = I.FacilityId
	 INNER JOIN tblDisconnectType C ON A.detectType = C.DisType
	  where 		
	(B.RecordDate between @fromDate and dateadd(d,1,@todate) ) and A.FacilityID = @FacilityID and A.detectType > 0
		order by B.RecordDate desc
