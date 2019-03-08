CREATE PROCEDURE [dbo].[p_Report_Frequently_calls_by_Division2]
@facilityID          int,
@DivisionID	int,
@fromDate	smalldatetime,
@toDate	smalldatetime
 AS

If(@DivisionID> 0 )
	
		
		 select  tblFacilityDivision.DepartmentName as DiVision, count(CallRevenue ) CallsCount,  sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement))  as Duration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock), tblcommrate with(nolock)
	 where  tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and	
						  tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.facilityID = @facilityID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
						and convert (int,duration ) >5   
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
						and tblFacilityDivision.DivisionID =@DivisionID
	group by  tblFacilityDivision.DepartmentName
	Order by  tblFacilityDivision.DepartmentName

Else
  
		 
		 select  tblFacilityDivision.DepartmentName as DiVision, count(CallRevenue ) CallsCount,  sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement))  as Duration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock), tblcommrate with(nolock)
	 where  tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and	
						  tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.facilityID = @facilityID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
						and convert (int,duration ) >5   
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	group by  tblFacilityDivision.DepartmentName
	Order by  tblFacilityDivision.DepartmentName
