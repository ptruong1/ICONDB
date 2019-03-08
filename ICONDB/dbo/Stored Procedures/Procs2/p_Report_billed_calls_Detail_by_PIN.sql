

CREATE PROCEDURE [dbo].[p_Report_billed_calls_Detail_by_PIN]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@PIN		int
 AS
If( @AgentID >1  and @facilityID =0 ) 
Begin
		IF  @PIN	> 0
	
		Select   PIN ,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_ConvertSecToMin( duration) as CallDuration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) 
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.PIN = @PIN and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	
	Else
		Select    PIN ,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_ConvertSecToMin( duration) as CallDuration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) 
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  tblcallsBilled.errorcode = '0' and   AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
			order by PIN
End
Else
Begin

	IF  @PIN	> 0
	
		Select   PIN ,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_ConvertSecToMin( duration) as CallDuration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) 
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				FacilityID = @FacilityID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.PIN = @PIN and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	
	Else
		Select    PIN ,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_ConvertSecToMin( duration) as CallDuration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) 
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  tblcallsBilled.errorcode = '0' and   FacilityID = @FacilityID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
			order by PIN
End

