

CREATE PROCEDURE [dbo].[p_Report_Calls_Attempt]
@FacilityID  int ,
@AgentID   int,
@fromDate   smalldatetime,  --Required
@toDate	smalldatetime  --Required

 AS
If( @AgentID > 0 ) 
	select  OpseqNo,  FromNo ,    DialedNo ,       RecordDate as  ConnectDateTime   from tblCallAttempt with(nolock)  
	  where  RecordDate >= @fromDate  and    convert(varchar(10), RecordDate ,101) <= @toDate	 and AgentID = @AgentID
		order by RecordDate 

Else
	select   OpseqNo,  FromNo ,    DialedNo ,       RecordDate as  ConnectDateTime   from tblCallAttempt with(nolock)   
		 where 		(RecordDate between @fromDate and dateadd(d,1,@todate) ) and FacilityID = @FacilityID
		order by RecordDate

