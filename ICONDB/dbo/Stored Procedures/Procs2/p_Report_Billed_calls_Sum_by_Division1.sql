CREATE PROCEDURE [dbo].[p_Report_Billed_calls_Sum_by_Division1]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@divisionID	int

AS

If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0   
begin
     If @divisionID > 0
     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	select  tblFacilityDivision.DepartmentName as DiVision, count(CallRevenue ) CallCount,  sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement))  as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock) 
	, tblCommRateAgent with(nolock), tblBaddebt with(nolock)
	where  tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
						 tblcallsBilled.errorcode = '0' and
						 
						 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
						 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
						 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
						 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
						  tblcallsbilled.billtype =  tblBadDebt.billtype and
						  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
						  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
						tblcallsbilled.agentID = @agentID and
						tblcallsbilled.facilityID = @divisionID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
						and convert (int,duration ) >5   
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	group by  tblFacilityDivision.DepartmentName
	Order by  tblFacilityDivision.DepartmentName
	else
	select  tblFacilityDivision.DepartmentName as DiVision, count(CallRevenue ) CallCount,  sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement))  as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock) 
	, tblCommrate with(nolock), tblBaddebt with(nolock)
	where  tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
						 tblcallsBilled.errorcode = '0' and
						 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						 tblcallsbilled.AgentID = tblCommrate.AgentID AND
						 tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
						  tblcallsbilled.billtype =  tblBadDebt.billtype and
						  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
						  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
						tblcallsbilled.agentID = @agentID and
						tblcallsbilled.facilityID = @divisionID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
						and convert (int,duration ) >5   
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	group by  tblFacilityDivision.DepartmentName
	Order by  tblFacilityDivision.DepartmentName

     Else--
     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	select  tblFacilityDivision.DepartmentName as DiVision, count(CallRevenue ) CallCount,  sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement))  as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock)
	, tblCommRateAgent with(nolock), tblBaddebt with(nolock)
	 where  tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.agentID = @agentID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
						and convert (int,duration ) >5   
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	group by  tblFacilityDivision.DepartmentName
	Order by  tblFacilityDivision.DepartmentName
	else
	select  tblFacilityDivision.DepartmentName as DiVision, count(CallRevenue ) CallCount,  sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement))  as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock)
	, tblCommrate with(nolock), tblBaddebt with(nolock)
	 where  tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.agentID = @agentID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
						and convert (int,duration ) >5   
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	group by  tblFacilityDivision.DepartmentName
	Order by  tblFacilityDivision.DepartmentName
End
Else --
---------
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
begin
     If @divisionID > 0
     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	select  tblFacilityDivision.DepartmentName as DiVision, count(CallRevenue ) CallCount,  sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement))  as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock) , tblcommrateAgent with(nolock)
	where  tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
						 tblcallsBilled.errorcode = '0' and
						  tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
						 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
						 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
						tblcallsbilled.agentID = @agentID and
						tblcallsbilled.facilityID = @divisionID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
						and convert (int,duration ) >5   
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	group by  tblFacilityDivision.DepartmentName
	Order by  tblFacilityDivision.DepartmentName
	else
	select  tblFacilityDivision.DepartmentName as DiVision, count(CallRevenue ) CallCount,  sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement))  as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock) , tblCommrate with(nolock)
	where  tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
						 tblcallsBilled.errorcode = '0' and
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						  tblcallsbilled.AgentID = tblCommrate.AgentID AND
						 tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						tblcallsbilled.agentID = @agentID and
						tblcallsbilled.facilityID = @divisionID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
						and convert (int,duration ) >5   
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	group by  tblFacilityDivision.DepartmentName
	Order by  tblFacilityDivision.DepartmentName
	
     Else--
     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	select  tblFacilityDivision.DepartmentName as DiVision, count(CallRevenue ) CallCount,  sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement))  as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock), tblcommrateAgent with(nolock)
	 where  tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and
							 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
						 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
						 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.agentID = @agentID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
						and convert (int,duration ) >5   
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	group by  tblFacilityDivision.DepartmentName
	Order by  tblFacilityDivision.DepartmentName
	else
	select  tblFacilityDivision.DepartmentName as DiVision, count(CallRevenue ) CallCount,  sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement))  as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock), tblCommrate with(nolock)
	 where  tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and
							 tblcallsbilled.AgentID = tblCommrate.AgentID AND
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						 tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.agentID = @agentID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
						and convert (int,duration ) >5   
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	group by  tblFacilityDivision.DepartmentName
	Order by  tblFacilityDivision.DepartmentName
End
Else --
begin
	if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	select  tblFacilityDivision.DepartmentName as DiVision, count(CallRevenue ) CallCount,  sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement))  as CallDuration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityDivision  with(nolock) , tblANIs with(nolock), tblCommrateAgent with(nolock)
	 where  tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and	
						  tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.facilityID = @facilityID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
						and convert (int,duration ) >5   
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	group by  tblFacilityDivision.DepartmentName
	Order by  tblFacilityDivision.DepartmentName
	else
	select  tblFacilityDivision.DepartmentName as DiVision, count(CallRevenue ) CallCount,  sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement))  as CallDuration, sum(CallRevenue) CallRevenue
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
end
