

CREATE PROCEDURE [dbo].[p_Report_Unbilled_calls_by_PIN]
@FacilityID	int,
@FromDate	smalldatetime,
@toDate	smalldatetime,
@PIN	int

 AS
If( @PIN >0)
	select  PIN,RecordDate as CallDate, tblbilltype.Descript as Billtype ,tblErrortype.Descript as Reason
		 from tblcallsUnbilled   with(nolock) , tblErrortype  with(nolock), tblBilltype with(nolock) 
		where tblErrortype.errorType >0  and tblBilltype.billtype = tblcallsUnbilled.billtype and
			tblErrortype.errorType = tblcallsUnbilled.errorType  and 
			FacilityID	= @FacilityID and (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			PIN = @PIN
		Group by PIN,RecordDate, tblbilltype.Descript ,tblErrortype.Descript
Else
	select  PIN,RecordDate  as CallDate, tblbilltype.Descript as Billtype ,tblErrortype.Descript as Reason
		 from tblcallsUnbilled   with(nolock) , tblErrortype  with(nolock), tblBilltype with(nolock) 
		where tblErrortype.errorType >0  and tblBilltype.billtype = tblcallsUnbilled.billtype and
			tblErrortype.errorType = tblcallsUnbilled.errorType  and 
			FacilityID	= @FacilityID and (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		
		Group by PIN,RecordDate, tblbilltype.Descript ,tblErrortype.Descript

