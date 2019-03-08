CREATE PROCEDURE [dbo].[p_Report_billed_calls_sum_by_Billtype2]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@divisionID     	int
 AS

If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0   

begin
       If @divisionID > 0
	Select   Location,    tblBilltype.Descript as   BilledType , Count( CallDate) as CallsCount,
			Sum( dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
			   Sum(CallRevenue) as TotalRevenue
			  from tblcallsBilled  with(nolock),  tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   tblCallsBilled.AgentID =@AgentID  And 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				   and convert (int,duration ) >5    
				   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Group by Location, tblBilltype.Descript 
		ORDER by Location, tblBilltype.Descript 
       Else
	Select   Location,    tblBilltype.Descript as   BilledType , Count( CallDate) as CallsCount,
			Sum( dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
			   Sum(CallRevenue) as TotalRevenue
			  from tblcallsBilled  with(nolock),  tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   tblCallsBilled.AgentID =@AgentID  And 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				   and convert (int,duration ) >5    
				   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Group by Location, tblBilltype.Descript 
		ORDER by Location, tblBilltype.Descript 
End
Else
------
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
begin
       If @divisionID > 0
	Select   Location,    tblBilltype.Descript as   BilledType , Count( CallDate) as CallsCount,
			Sum( dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
			   Sum(CallRevenue) as TotalRevenue
			  from tblcallsBilled  with(nolock),  tblBilltype  with(nolock), tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   tblCallsBilled.AgentID =@AgentID  And 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				   and convert (int,duration ) >5    
				   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Group by Location, tblBilltype.Descript 
		ORDER by Location, tblBilltype.Descript 
       Else
	Select   Location,    tblBilltype.Descript as   BilledType , Count( CallDate) as CallsCount,
			Sum( dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
			   Sum(CallRevenue) as TotalRevenue
			  from tblcallsBilled  with(nolock),  tblBilltype  with(nolock), tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   tblCallsBilled.AgentID =@AgentID  And 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				   and convert (int,duration ) >5    
				   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Group by Location, tblBilltype.Descript 
		ORDER by Location, tblBilltype.Descript 
End
Else
begin
	Select    tblBilltype.Descript as   BilledType , Count( CallDate) as CallsCount,
			 sum( dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
			  Sum(CallRevenue) as TotalRevenue
			  from tblcallsBilled  with(nolock),  tblBilltype  with(nolock), tblcommrate with(nolock)
			   where   tblBilltype.Billtype = tblcallsBilled.billtype and
			     tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsBilled.errorcode = '0' and   tblcallsBilled.FacilityID = @FacilityID  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		
		   Group by tblBilltype.Descript
		   Order by tblBilltype.Descript
End
