CREATE PROCEDURE [dbo].[p_Report_Unbilled_calls_by_PIN1]
@FacilityID	int,
@FromDate	smalldatetime,
@toDate	smalldatetime,
@PIN	varchar(12)

 AS
If( @PIN >0)
	select  PIN,fromno,tono,RecordDate as CallDate, tblbilltype.Descript as Billtype ,tblErrortype.Descript as Reason, Count(RecordDate)  as Calls
		 from tblcallsUnbilled   with(nolock) , tblErrortype  with(nolock), tblBilltype with(nolock) ,tblANIs with(nolock)
		where tblErrortype.errorType >0  and tblBilltype.billtype = tblcallsUnbilled.billtype and
			tblANIs.ANIno = 	tblcallsUnbilled.FromNo and
			tblErrortype.errorType = tblcallsUnbilled.errorType  and 
			tblcallsunbilled.FacilityID	= @FacilityID and (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			PIN = @PIN
		Group by PIN,fromno,tono,RecordDate, tblbilltype.Descript ,tblErrortype.Descript
Else
	select  PIN,fromno,tono,RecordDate  as CallDate, tblbilltype.Descript as Billtype ,tblErrortype.Descript as Reason, Count(RecordDate)  as Calls
		 from tblcallsUnbilled   with(nolock) , tblErrortype  with(nolock), tblBilltype with(nolock) ,tblANIs with(nolock)
		where tblErrortype.errorType >0  and tblBilltype.billtype = tblcallsUnbilled.billtype and
			tblANIs.ANIno = 	tblcallsUnbilled.FromNo and
			tblErrortype.errorType = tblcallsUnbilled.errorType  and 
			tblcallsunbilled.FacilityID	= @FacilityID and (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		
		Group by PIN,fromno,tono,RecordDate, tblbilltype.Descript ,tblErrortype.Descript
