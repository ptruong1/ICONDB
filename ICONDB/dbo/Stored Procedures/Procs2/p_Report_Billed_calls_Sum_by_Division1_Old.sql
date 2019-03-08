

CREATE PROCEDURE [dbo].[p_Report_Billed_calls_Sum_by_Division1_Old]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@divisionID	int

AS

If( @AgentID >1  and @facilityID =0 ) 
begin
     If @divisionID > 0
	select  tblFacilityDivision.DepartmentName as DiVision, count(CallRevenue ) CallCount,  sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement))  as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock) where  tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.agentID = @agentID and
						tblcallsbilled.facilityID = @divisionID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	group by  tblFacilityDivision.DepartmentName
	Order by  tblFacilityDivision.DepartmentName
     Else
	select  tblFacilityDivision.DepartmentName as DiVision, count(CallRevenue ) CallCount,  sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement))  as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock) where  tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.agentID = @agentID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	group by  tblFacilityDivision.DepartmentName
	Order by  tblFacilityDivision.DepartmentName
End
Else
begin
	select  tblFacilityDivision.DepartmentName as DiVision, count(CallRevenue ) CallCount,  sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement))  as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock) where  tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
						  tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.facilityID = @facilityID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	group by  tblFacilityDivision.DepartmentName
	Order by  tblFacilityDivision.DepartmentName
end
