CREATE PROCEDURE [dbo].[p_Report_billed_calls_sum_by_hours2]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@divisionID	int
 AS

If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0   

begin
      If @divisionID > 0
      if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select   Location, Left(ConnectTime,2) as [Hour],  Count(Left(CallDate,2) ) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
 			sum(CallRevenue ) As TotalRevenue
		 from tblcallsBilled  with(nolock), tblFacility with(nolock)
		 , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
		   where tblcallsBilled.AgentID = @AgentID  and  tblcallsBilled.errorcode = '0' and 
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				  
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
		tblCallsBilled.facilityID = @divisionID and
		 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5
		   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by location,Left(connectTime,2)
		   Order by   location,Left(connectTime,2)
		   else
		   Select   Location, Left(ConnectTime,2) as [Hour],  Count(Left(CallDate,2) ) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
 			sum(CallRevenue ) As TotalRevenue
		 from tblcallsBilled  with(nolock), tblFacility with(nolock)
		 , tblCommrate with(nolock), tblBaddebt with(nolock)
		   where tblcallsBilled.AgentID = @AgentID  and  tblcallsBilled.errorcode = '0' and 
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		tblcallsbilled.AgentID = tblCommrate.AgentID AND
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
		tblCallsBilled.facilityID = @divisionID and
		 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5
		   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by location,Left(connectTime,2)
		   Order by   location,Left(connectTime,2)
      Else--
      if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select   Location, Left(ConnectTime,2) as [Hour],  Count(Left(CallDate,2) ) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
 			sum(CallRevenue ) As TotalRevenue
		 from tblcallsBilled  with(nolock), tblFacility with(nolock)
		 , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
		   where tblcallsBilled.AgentID = @AgentID  and  tblcallsBilled.errorcode = '0' and 
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				  
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and 
		 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5 
		 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by location,Left(connectTime,2)
		   Order by   location,Left(connectTime,2)
		   else
		   Select   Location, Left(ConnectTime,2) as [Hour],  Count(Left(CallDate,2) ) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
 			sum(CallRevenue ) As TotalRevenue
		 from tblcallsBilled  with(nolock), tblFacility with(nolock)
		 , tblCommrate with(nolock), tblBaddebt with(nolock)
		   where tblcallsBilled.AgentID = @AgentID  and  tblcallsBilled.errorcode = '0' and 
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		tblcallsbilled.AgentID = tblCommrate.AgentID AND
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and 
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and 
		 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5 
		 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by location,Left(connectTime,2)
		   Order by   location,Left(connectTime,2)

End
Else--
-----
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
begin
      If @divisionID > 0
      if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select   Location, Left(ConnectTime,2) as [Hour],  Count(Left(CallDate,2) ) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
 			sum(CallRevenue ) As TotalRevenue
		 from tblcallsBilled  with(nolock), tblFacility with(nolock), tblcommrateAgent with(nolock)
		   where tblcallsBilled.AgentID = @AgentID  and  tblcallsBilled.errorcode = '0' and 
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				  
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
		tblCallsBilled.facilityID = @divisionID and
		 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5
		   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by location,Left(connectTime,2)
		   Order by   location,Left(connectTime,2)
		   else
		  Select   Location, Left(ConnectTime,2) as [Hour],  Count(Left(CallDate,2) ) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
 			sum(CallRevenue ) As TotalRevenue
		 from tblcallsBilled  with(nolock), tblFacility with(nolock), tblCommrate with(nolock)
		   where tblcallsBilled.AgentID = @AgentID  and  tblcallsBilled.errorcode = '0' and 
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		tblcallsbilled.AgentID = tblCommrate.AgentID AND
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and 
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
		tblCallsBilled.facilityID = @divisionID and
		 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5
		   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by location,Left(connectTime,2)
		   Order by   location,Left(connectTime,2) 
      Else--
      if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select   Location, Left(ConnectTime,2) as [Hour],  Count(Left(CallDate,2) ) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
 			sum(CallRevenue ) As TotalRevenue
		 from tblcallsBilled  with(nolock), tblFacility with(nolock), tblcommrateAgent with(nolock)
		   where tblcallsBilled.AgentID = @AgentID  and  tblcallsBilled.errorcode = '0' and 
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				  
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
		 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5 
		and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by location,Left(connectTime,2)
		   Order by   location,Left(connectTime,2)
		   else
		   Select   Location, Left(ConnectTime,2) as [Hour],  Count(Left(CallDate,2) ) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
 			sum(CallRevenue ) As TotalRevenue
		 from tblcallsBilled  with(nolock), tblFacility with(nolock), tblCommrate with(nolock)
		   where tblcallsBilled.AgentID = @AgentID  and  tblcallsBilled.errorcode = '0' and 
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		tblcallsbilled.AgentID = tblCommrate.AgentID AND
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and 
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
		 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5 
		and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by location,Left(connectTime,2)
		   Order by   location,Left(connectTime,2)
End
Else--
Begin
	if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select   Left(ConnectTime,2) as [Hour],  Count(Left(CallDate,2) ) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes, 
 			sum(CallRevenue ) As TotalRevenue
		 from tblcallsBilled  with(nolock), tblCommrateAgent with(nolock)
		   where  tblcallsbilled.FacilityID = @FacilityID  and  tblcallsBilled.errorcode = '0' and
		   tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
		     (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
		 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by Left(connectTime,2)
		   Order by  Left(connectTime,2)
	else
	Select   Left(ConnectTime,2) as [Hour],  Count(Left(CallDate,2) ) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes, 
 			sum(CallRevenue ) As TotalRevenue
		 from tblcallsBilled  with(nolock), tblcommrate with(nolock)
		   where  tblcallsbilled.FacilityID = @FacilityID  and  tblcallsBilled.errorcode = '0' and
		   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and
		     (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
		 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by Left(connectTime,2)
		   Order by  Left(connectTime,2)
end
