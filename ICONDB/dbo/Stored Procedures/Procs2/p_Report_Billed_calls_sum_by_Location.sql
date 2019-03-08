

CREATE PROCEDURE [dbo].[p_Report_Billed_calls_sum_by_Location]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime

AS
/*
If(@LocationID >0)

	select  tblFacilityLocation.Descript as Location, tblcallsbilled.calldate, count(CallRevenue ) CallCount,dbo.fn_ConvertSecToMin(sum( duration)) as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityLocation  with(nolock) , tblANIs  with(nolock) where  tblFacilityLocation.LocationID	= 	tblANIs.LocationID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
						tblcallsbilled.facilityID	= @facilityID  And
						tblcallsbilled.agentID = @agentID and
						 RecordDate >= @fromDate and   convert(varchar(10), RecordDate ,101) <= dateadd(d, 1,@toDate )    and tblFacilityLocation.LocationID	= @LocationID
	group by  tblFacilityLocation.Descript, tblcallsbilled.calldate
	Order by   tblFacilityLocation.Descript, tblcallsbilled.calldate

Else
*/	

If( @AgentID >1  and @facilityID =0 ) 
begin
	select  tblFacilityLocation.Descript as Location, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityLocation  with(nolock) , tblANIs  with(nolock) where  tblFacilityLocation.LocationID	= 	tblANIs.LocationID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
						tblcallsbilled.AgentID	= @AgentID  And
						tblcallsbilled.agentID = @agentID and  tblcallsBilled.errorcode = '0' and 
						 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	group by  tblFacilityLocation.Descript, tblcallsbilled.calldate
	Order by   tblFacilityLocation.Descript, tblcallsbilled.calldate
End
Else
begin
	select  tblFacilityLocation.Descript as Location, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityLocation  with(nolock) , tblANIs  with(nolock) where  tblFacilityLocation.LocationID	= 	tblANIs.LocationID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
						tblcallsbilled.facilityID	= @facilityID  And
						tblcallsbilled.agentID = @agentID and  tblcallsBilled.errorcode = '0' and 
						 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	group by  tblFacilityLocation.Descript, tblcallsbilled.calldate
	Order by   tblFacilityLocation.Descript, tblcallsbilled.calldate
end

