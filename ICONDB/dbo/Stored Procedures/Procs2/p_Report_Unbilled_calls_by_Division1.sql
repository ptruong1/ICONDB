CREATE PROCEDURE [dbo].[p_Report_Unbilled_calls_by_Division1]
@FacilityID	int,
@FromDate	smalldatetime,
@toDate	smalldatetime,
@DivisionID int

 AS
If(@DivisionID > 0)
	select  tblFacilityDivision.DepartmentName  as Division ,fromno,tono,RecordDate  as Calldate, tblBilltype.Descript as Billtype  ,tblErrortype.Descript as Reason, Count(RecordDate)  as Calls
	 from tblcallsUnbilled with(nolock) , tblErrortype  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock)  , tblBilltype with(nolock) 
		  where  tblFacilityDivision.DivisionID	= 	tblANIs.DivisionID and	 tblBilltype.Billtype = tblcallsUnbilled.billtype and 
			 tblANIs.ANIno = 	tblcallsunbilled.FromNo and	
			 tblErrortype.errorType >0  and   tblFacilityDivision.DivisionID = @DivisionID and
			 tblErrortype.errorType = tblcallsUnbilled.errorType  and tblcallsunbilled.FacilityID	= @FacilityID and (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			Group by tblFacilityDivision.DepartmentName,fromno,tono,RecordDate,  tblBilltype.Descript  ,tblErrortype.Descript

Else
	select  tblFacilityDivision.DepartmentName  as Division ,fromno,tono,RecordDate  as Calldate,  tblBilltype.Descript as Billtype ,tblErrortype.Descript as Reason, Count(RecordDate)  as Calls
	 from tblcallsUnbilled with(nolock) , tblErrortype  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock) , tblBilltype with(nolock) 
		  where  tblFacilityDivision.DivisionID	= 	tblANIs.DivisionID and	 tblBilltype.Billtype = tblcallsUnbilled.billtype and 
			 tblANIs.ANIno = 	tblcallsUnbilled.FromNo and	
			 tblErrortype.errorType >0  and  
			 tblErrortype.errorType = tblcallsUnbilled.errorType  and tblcallsunbilled.FacilityID	= @FacilityID and (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			Group by tblFacilityDivision.DepartmentName,fromno,tono,RecordDate,  tblBilltype.Descript  ,tblErrortype.Descript
