CREATE PROCEDURE [dbo].[p_Report_billed_calls_sum_by_Calltype2]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@divisionID	int
 AS


If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0   
Begin
       If @divisionID > 0
       if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select    tblCalltype.Descript  as CallType, Location
		,  Count(tblcallsBilled.Calltype) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock), tblcalltype with(nolock) , tblFacility with(nolock)
		  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
		   where  tblcallsBilled.Calltype = tblCalltype.Abrev and   tblcallsBilled.AgentID = @AgentID   And 
		tblCallsBilled.facilityID = tblfacility.FacilityID and 
		tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
		tblCallsBilled.facilityID = @divisionID and 
		  tblcallsBilled.errorcode = '0' and  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		  and convert (int,duration ) >5   
		  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		   Group by  Location, tblCalltype.Descript
		   Order by   Location, tblCalltype.Descript
		   else
		   Select    tblCalltype.Descript  as CallType, Location
		,  Count(tblcallsBilled.Calltype) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock), tblcalltype with(nolock) , tblFacility with(nolock)
		  , tblCommrate with(nolock), tblBaddebt with(nolock)
		   where  tblcallsBilled.Calltype = tblCalltype.Abrev and   tblcallsBilled.AgentID = @AgentID   And 
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
		  tblcallsBilled.errorcode = '0' and  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		  and convert (int,duration ) >5   
		  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		   Group by  Location, tblCalltype.Descript
		   Order by   Location, tblCalltype.Descript
       Else ----
       if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select    tblCalltype.Descript  as CallType, Location
		,  Count(tblcallsBilled.Calltype) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock), tblcalltype with(nolock) , tblFacility with(nolock)
		  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
		   where  tblcallsBilled.Calltype = tblCalltype.Abrev and   tblcallsBilled.AgentID = @AgentID   And 
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
		  tblcallsBilled.errorcode = '0' and  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		  and convert (int,duration ) >5   
		  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		   Group by  Location, tblCalltype.Descript
		   Order by   Location, tblCalltype.Descript
		   else
		   Select    tblCalltype.Descript  as CallType, Location
		,  Count(tblcallsBilled.Calltype) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock), tblcalltype with(nolock) , tblFacility with(nolock)
		  , tblCommrate with(nolock), tblBaddebt with(nolock)
		   where  tblcallsBilled.Calltype = tblCalltype.Abrev and   tblcallsBilled.AgentID = @AgentID   And 
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		tblcallsbilled.AgentID = tblCommrate.AgentID AND
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
		  tblcallsBilled.errorcode = '0' and  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		  and convert (int,duration ) >5   
		  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		   Group by  Location, tblCalltype.Descript
		   Order by   Location, tblCalltype.Descript
End
Else --
--------------
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
Begin
       If @divisionID > 0
       if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select    tblCalltype.Descript  as CallType, Location
		,  Count(tblcallsBilled.Calltype) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock), tblcalltype with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
		   where  tblcallsBilled.Calltype = tblCalltype.Abrev and   tblcallsBilled.AgentID = @AgentID   And 
		tblCallsBilled.facilityID = tblfacility.FacilityID and 
		tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
		tblCallsBilled.facilityID = @divisionID and 
		  tblcallsBilled.errorcode = '0' and  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		  and convert (int,duration ) >5   
		  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		   Group by  Location, tblCalltype.Descript
		   Order by   Location, tblCalltype.Descript
		   else
		   
Select    tblCalltype.Descript  as CallType, Location
		,  Count(tblcallsBilled.Calltype) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock), tblcalltype with(nolock) , tblFacility with(nolock), tblCommrate with(nolock)
		   where  tblcallsBilled.Calltype = tblCalltype.Abrev and   tblcallsBilled.AgentID = @AgentID   And 
		tblCallsBilled.facilityID = tblfacility.FacilityID and 
		tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
		tblCallsBilled.facilityID = @divisionID and 
		  tblcallsBilled.errorcode = '0' and  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		  and convert (int,duration ) >5   
		  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		   Group by  Location, tblCalltype.Descript
		   Order by   Location, tblCalltype.Descript

       Else--
       if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select    tblCalltype.Descript  as CallType, Location
		,  Count(tblcallsBilled.Calltype) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock), tblcalltype with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
		   where  tblcallsBilled.Calltype = tblCalltype.Abrev and   tblcallsBilled.AgentID = @AgentID   And 
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
		  tblcallsBilled.errorcode = '0' and  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		  and convert (int,duration ) >5   
		  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		   Group by  Location, tblCalltype.Descript
		   Order by   Location, tblCalltype.Descript
		else
		Select    tblCalltype.Descript  as CallType, Location
		,  Count(tblcallsBilled.Calltype) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock), tblcalltype with(nolock) , tblFacility with(nolock), tblCommrate with(nolock)
		   where  tblcallsBilled.Calltype = tblCalltype.Abrev and   tblcallsBilled.AgentID = @AgentID   And 
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
		  tblcallsBilled.errorcode = '0' and  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		  and convert (int,duration ) >5   
		  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		   Group by  Location, tblCalltype.Descript
		   Order by   Location, tblCalltype.Descript
End
Else--

Begin
	If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
	Select   tblCalltype.Descript  as CallType
		,  Count(tblcallsBilled.Calltype) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock), tblcalltype with(nolock), tblCommrateAgent with(nolock)
		   where  tblcallsBilled.Calltype = tblCalltype.Abrev and
		   tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
		      tblcallsBilled.FacilityID = @FacilityID   And  
		  tblcallsBilled.errorcode = '0' and  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		  and convert (int,duration ) >5   
		  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		   Group by tblCalltype.Descript

	else
	Select   tblCalltype.Descript  as CallType
		,  Count(tblcallsBilled.Calltype) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock), tblcalltype with(nolock), tblcommrate with(nolock)
		   where  tblcallsBilled.Calltype = tblCalltype.Abrev and
		   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			tblcallsbilled.Billtype =  tblCommrate.billtype and
			tblcallsbilled.Calltype = tblCommrate.Calltype and
		      tblcallsBilled.FacilityID = @FacilityID   And  
		  tblcallsBilled.errorcode = '0' and  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		  and convert (int,duration ) >5   
		  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		   Group by tblCalltype.Descript
end
