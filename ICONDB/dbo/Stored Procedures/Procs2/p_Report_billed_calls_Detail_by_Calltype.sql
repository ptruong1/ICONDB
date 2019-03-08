

CREATE PROCEDURE [dbo].[p_Report_billed_calls_Detail_by_Calltype]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@calltype	varchar(2)
 AS

SET @calltype	 = isnull(@calltype ,'')
If( @AgentID >1  and @facilityID =0 ) 
Begin
	IF  @calltype <> ''
	
		Select    fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_ConvertSecToMin( duration) as CallDuration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) 
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
				 AgentID = @AgentID  And 
				 tblcallsBilled.errorcode = '0' and 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				tblcallsBilled.calltype = @calltype  and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
			Order by    tblCalltype.Descript ,  RecordDate
	
	Else
		Select    fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_ConvertSecToMin( duration) as CallDuration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) 
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   tblcallsBilled.errorcode = '0' and   AgentID = @AgentID    And
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
			Order by    tblCalltype.Descript ,  RecordDate
End
Else
Begin
	IF  @calltype <> ''
	
		Select    fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_ConvertSecToMin( duration) as CallDuration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) 
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
				 FacilityID = @FacilityID  And 
				 tblcallsBilled.errorcode = '0' and 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				tblcallsBilled.calltype = @calltype  and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
			Order by    tblCalltype.Descript ,  RecordDate 
	
	Else
		Select    fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_ConvertSecToMin( duration) as CallDuration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) 
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   tblcallsBilled.errorcode = '0' and  FacilityID = @FacilityID  And
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
			Order by    tblCalltype.Descript ,  RecordDate
End

