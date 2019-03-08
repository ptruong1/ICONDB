

CREATE PROCEDURE [dbo].[p_Report_Billed_calls_Sum_by_Division]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime

AS
/*
If(@divisionID >0)

	select  tblFacilityDivision.DepartmentName as DiVision, tblcallsbilled.calldate, count(CallRevenue ) CallCount,dbo.fn_ConvertSecToMin(sum( duration)) as CallDuration, sum(CallRevenue) CallRevenue
		
	from tblcallsbilled  with(nolock), tblFacilityDivision  with(nolock) , tblANIs  with(nolock) where  tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
						tblcallsbilled.facilityID	= @facilityID  And
						tblcallsbilled.agentID = @agentID and
						 RecordDate >= @fromDate and   convert(varchar(10), RecordDate ,101) <= dateadd(d, 1,@toDate )    and tblFacilityDivision.DivisionId	= @divisionID
	group by  tblFacilityDivision.DepartmentName, tblcallsbilled.calldate
	Order by  tblFacilityDivision.DepartmentName, tblcallsbilled.calldate

Else

*/

If( @AgentID >1  and @facilityID =0 ) 
begin
	select  tblFacilityDivision.DepartmentName as DiVision, tblcallsbilled.calldate, count(CallRevenue ) CallCount,  CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock) where  tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.agentID = @agentID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	group by  tblFacilityDivision.DepartmentName, tblcallsbilled.calldate
	Order by  tblFacilityDivision.DepartmentName, tblcallsbilled.calldate
End
Else
begin
	select  tblFacilityDivision.DepartmentName as DiVision, tblcallsbilled.calldate, count(CallRevenue ) CallCount,  CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock) where  tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
						  tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.agentID = @agentID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	group by  tblFacilityDivision.DepartmentName, tblcallsbilled.calldate
	Order by  tblFacilityDivision.DepartmentName, tblcallsbilled.calldate
end

