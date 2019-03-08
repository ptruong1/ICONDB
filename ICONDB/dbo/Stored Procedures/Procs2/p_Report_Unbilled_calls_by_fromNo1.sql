CREATE PROCEDURE [dbo].[p_Report_Unbilled_calls_by_fromNo1]
@FacilityID	int,
@FromDate	smalldatetime,
@toDate	smalldatetime,
@FromNo	varchar(10)

 AS
If(@FromNo	<>'')
	select  fromno,tono,RecordDate as CallDate, tblbilltype.Descript as Billtype  ,tblErrortype.Descript, Count(RecordDate)  as Calls
	 from tblcallsUnbilled  with(nolock), tblErrortype with(nolock), tblBilltype with(nolock), tblANIs with(nolock) 
	where tblErrortype.errorType >0  and  tblBilltype.Billtype = tblcallsUnbilled.billtype and 
		tblANIs.ANIno = 	tblcallsUnbilled.FromNo and
		tblANIs.facilityid = tblcallsUnbilled.facilityId and
		tblErrortype.errorType = tblcallsUnbilled.errorType  and 
		tblcallsUnbilled.FacilityID	= @FacilityID and (RecordDate between @fromDate and dateadd(d,1,@todate) ) and	
		Fromno = @FromNo
	Group by fromno,tono,RecordDate, tblbilltype.Descript ,tblErrortype.Descript
else
	select  fromno,tono,RecordDate as Calldate, tblbilltype.Descript as Billtype  ,tblErrortype.Descript, Count(RecordDate)  as Calls
	 from tblcallsUnbilled  with(nolock), tblErrortype with(nolock), tblBilltype with(nolock) , tblANIs with(nolock)
	where tblErrortype.errorType >0  and  tblBilltype.Billtype = tblcallsUnbilled.billtype and 
		tblANIs.ANIno = 	tblcallsUnbilled.FromNo and
		tblANIs.facilityid = tblcallsUnbilled.facilityId and
		tblErrortype.errorType = tblcallsUnbilled.errorType  and 
		tblcallsUnbilled.FacilityID	= @FacilityID and (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		
	Group by fromno,tono,RecordDate, tblbilltype.Descript ,tblErrortype.Descript
