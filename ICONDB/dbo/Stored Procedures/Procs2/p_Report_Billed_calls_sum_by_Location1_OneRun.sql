

CREATE PROCEDURE [dbo].[p_Report_Billed_calls_sum_by_Location1_OneRun]
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
	select  tblFacilityLocation.Descript as Location,  count(CallRevenue ) CallCount,sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityLocation  with(nolock) , tblANIs  with(nolock) where  tblFacilityLocation.LocationID	= 	tblANIs.LocationID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
						tblcallsbilled.AgentID	= @AgentID  And
						tblcallsbilled.agentID = @agentID and  tblcallsBilled.errorcode = '0' and 
						 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	group by  tblFacilityLocation.Descript
	Order by   tblFacilityLocation.Descript
End
Else
begin
	select  tblFacilityLocation.Descript as Location,  count(CallRevenue ) CallCount,sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as CallDuration, sum(CallRevenue) CallRevenue
	from tblCallsBilledArchive_ComBined  with(nolock), tblFacilityLocation  with(nolock) , tblANIs  with(nolock) 

	where  tblFacilityLocation.LocationID=tblANIs.LocationID and	
		tblANIs.ANIno =	tblCallsBilledArchive_ComBined.FromNo and	
		tblCallsBilledArchive_ComBined.errorcode = '0' and 
		tblCallsBilledArchive_ComBined.facilityID	= @facilityID  And
		(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   AND ( (tblCallsBilledArchive_ComBined.billtype in ( '01','00','02','10'))  or  (tblCallsBilledArchive_ComBined.billtype in ('03','05') and complete =2))
	group by  tblFacilityLocation.Descript
	Order by   tblFacilityLocation.Descript
end
