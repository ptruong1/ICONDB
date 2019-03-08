CREATE PROCEDURE [dbo].[p_Report_Third_Party_Calls_110912017]
@FacilityID  int ,
@AgentID   int,
@fromDate   smalldatetime,  --Required
@toDate	smalldatetime  --Required

 AS
If( @AgentID > 1 ) 
	SELECT A.RecordID, A.recordDate, A.PIN, A.InmateId, I.Firstname as FName, I.LastName as LName, B.fromno, B.tono, 
	CAST( CAST(A.duration as numeric(7,2))/60 as Numeric(9,2)) as Duration,  C.Descript, B.CallRevenue, 1 as callsCount, A.DetectTime, SuspiciousId, SuspiciousCallees, Confidence,
	[InmateEnrolledSample],[SuspiciousSample]
	 FROM tblThirdPartyDectectRecord A 
	 INNER JOIN tblCallsBilled B ON A.recordID = B.RecordID
	 INNER JOIN tblInmate I ON A.PIN = I.PIN and A.FacilityID = I.FacilityId
	 INNER JOIN tblDisconnectType C ON A.detectType = C.DisType
	  where 		
	(A.recordDate between @fromDate and dateadd(d,1,@todate) ) and A.FacilityID in (select FacilityID from tblfacility F where  F.AgentID = @AgentID) and A.detectType > 0
		order by A.recordDate desc

Else
	SELECT A.RecordID, A.recordDate, A.PIN,  A.InmateId, I.Firstname as FName, I.LastName as LName, B.fromno, B.tono,
	 CAST( CAST(A.duration as numeric(7,2))/60 as Numeric(9,2)) as Duration,  C.Descript, B.CallRevenue, 1 as callsCount, A.DetectTime, SuspiciousId, SuspiciousCallees, Confidence,
	 [InmateEnrolledSample],[SuspiciousSample]
	 FROM tblThirdPartyDectectRecord A 
	 INNER JOIN tblCallsBilled B ON A.recordID = B.RecordID
	 INNER JOIN tblInmate I ON A.PIN = I.PIN and A.FacilityID = I.FacilityId
	 INNER JOIN tblDisconnectType C ON A.detectType = C.DisType
	  where 		
	(A.recordDate between @fromDate and dateadd(d,1,@todate) ) and A.FacilityID = @FacilityID and A.detectType > 0
		order by A.recordDate desc
	--SELECT B.RecordID, B.RecordDate, A.PIN, I.Firstname as FName, I.LastName as LName, B.fromno, B.tono,
	-- CAST( CAST(A.duration as numeric(7,2))/60 as Numeric(9,2)) as Duration,  C.Descript, B.CallRevenue, 1 as callsCount, A.DetectTime, Score
	-- FROM tblThirdPartyDectectRecord A 
	-- INNER JOIN tblCallsBilled B ON A.recordID = B.RecordID
	-- INNER JOIN tblInmate I ON A.PIN = I.PIN and A.FacilityID = I.FacilityId
	-- INNER JOIN tblDisconnectType C ON A.detectType = C.DisType
	--  where 		
	--(B.RecordDate between @fromDate and dateadd(d,1,@todate) ) and A.FacilityID = @FacilityID and A.detectType > 0
	--	order by B.RecordDate desc
