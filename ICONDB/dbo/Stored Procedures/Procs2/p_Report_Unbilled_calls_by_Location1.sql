CREATE PROCEDURE [dbo].[p_Report_Unbilled_calls_by_Location1]
@FacilityID	int,
@FromDate	smalldatetime,
@toDate	smalldatetime,
@LocationID int

 AS
If (@LocationID >0)
	select  tblFacilityLocation.Descript as Location ,fromno,tono,RecordDate  as Calldate, tblbilltype.Descript as Billtype ,tblErrortype.Descript   as Reason, Count(RecordDate)  as Calls
	 from tblcallsUnbilled , tblErrortype , tblFacilityLocation  with(nolock) , tblANIs with(nolock) , tblBilltype with(nolock) 
		  where  tblFacilityLocation.LocationID	= 	tblANIs.LocationID and	tblBilltype.Billtype = tblcallsUnbilled.billtype and 
			 tblANIs.ANIno = 	tblcallsunbilled.FromNo and	
			 tblErrortype.errorType >0  and   tblFacilityLocation.LocationID = @LocationID and
			 tblErrortype.errorType = tblcallsUnbilled.errorType  and tblcallsunbilled.FacilityID	= @FacilityID and (RecordDate between @fromDate and dateadd(d,1,@todate) ) 	
			Group by tblFacilityLocation.Descript ,fromno,tono,RecordDate,  tblbilltype.Descript  ,tblErrortype.Descript

Else
	select  tblFacilityLocation.Descript as Location ,fromno,tono,RecordDate as CallDate, tblbilltype.Descript as Billtype ,tblErrortype.Descript   as Reason, Count(RecordDate)  as Calls
	 from tblcallsUnbilled , tblErrortype , tblFacilityLocation  with(nolock) , tblANIs with(nolock) , tblBilltype with(nolock) 
		  where  tblFacilityLocation.LocationID	= 	tblANIs.LocationID and	tblBilltype.Billtype = tblcallsUnbilled.billtype and 
			 tblANIs.ANIno = 	tblcallsunbilled.FromNo and	
			 tblErrortype.errorType >0  and  
			 tblErrortype.errorType = tblcallsUnbilled.errorType  and tblcallsunbilled.FacilityID	= @FacilityID and (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			Group by tblFacilityLocation.Descript ,fromno,tono,RecordDate,  tblbilltype.Descript  ,tblErrortype.Descript
