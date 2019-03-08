

CREATE PROCEDURE [dbo].[p_Report_billed_calls_sum_by_PIN2]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@divisionID	int
 AS

 	
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  > 0 
begin
        if @divisionID > 0
        if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select    Location, InmateID, PIN,  Count(InmateID) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock) , tblFacility with(nolock)
		  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID   And   tblcallsBilled.errorcode = '0' and
		
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
			
		   Group by  Location, InmateID, PIN
		   Order by  Location, InmateID, PIN
       else 
	Select    Location, InmateID, PIN,  Count(InmateID) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock) , tblFacility with(nolock)
		  , tblCommrate with(nolock), tblBaddebt with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID   And   tblcallsBilled.errorcode = '0' and
		   tblcallsbilled.AgentID = tblCommrate.AgentID AND
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
		tblCallsBilled.facilityID = @divisionID and
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		  and convert (int,duration ) >5   
		  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			
		   Group by  Location, InmateID, PIN
		   Order by  Location, InmateID, PIN
   else --division = -1
   if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select    Location, InmateID, PIN,  Count(InmateID) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock) , tblFacility with(nolock)
		  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID   And   tblcallsBilled.errorcode = '0' and
		
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
			
		   Group by  Location, InmateID, PIN
		   Order by  Location, InmateID, PIN
       else 
	Select    Location, InmateID, PIN,  Count(InmateID) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock) , tblFacility with(nolock)
		  , tblCommrate with(nolock), tblBaddebt with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID   And   tblcallsBilled.errorcode = '0' and
		   tblcallsbilled.AgentID = tblCommrate.AgentID AND
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
		
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		  and convert (int,duration ) >5   
		  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			
		   Group by  Location, InmateID, PIN
		   Order by  Location, InmateID, PIN
end
else --
-----
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
begin
        if @divisionID > 0
        
        if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select    Location, InmateID, PIN,  Count(InmateID) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID   And   tblcallsBilled.errorcode = '0' and
		
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
		tblCallsBilled.facilityID = @divisionID and
		  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		  and convert (int,duration ) >5   
		  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			
		   Group by  Location, InmateID, PIN
		   Order by  Location, InmateID, PIN
		else
		   Select    Location, InmateID, PIN,  Count(InmateID) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock) , tblFacility with(nolock), tblCommrate with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID   And   tblcallsBilled.errorcode = '0' and
		
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
		tblCallsBilled.facilityID = @divisionID and
		  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		  and convert (int,duration ) >5   
		  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			
		   Group by  Location, InmateID, PIN
		   Order by  Location, InmateID, PIN
  
		 
	else	--division = 0
	if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select    Location, InmateID, PIN,  Count(InmateID) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID   And   tblcallsBilled.errorcode = '0' and
		
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
		
		  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		  and convert (int,duration ) >5   
		  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			
		   Group by  Location, InmateID, PIN
		   Order by  Location, InmateID, PIN
		   else
		   Select    Location, InmateID, PIN,  Count(InmateID) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock) , tblFacility with(nolock), tblCommrate with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID   And   tblcallsBilled.errorcode = '0' and
		
		tblCallsBilled.facilityID = tblfacility.FacilityID and
		tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
		
		  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		  and convert (int,duration ) >5   
		  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			
		   Group by  Location, InmateID, PIN
		   Order by  Location, InmateID, PIN
      
end
else
begin
if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
Select    InmateID, PIN  
		,  Count(InmateID) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock) , tblCommrateAgent with(nolock)
		   where  tblcallsBilled.FacilityID = @FacilityID   And   tblcallsBilled.errorcode = '0' and
		   tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			 tblcallsbilled.Calltype = tblCommrateAgent.Calltype
		   and  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		   and convert (int,duration ) >5   
		   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			
		   Group by  InmateID, PIN
else
Select    InmateID, PIN  
		,  Count(InmateID) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock) , tblcommrate with(nolock)
		   where  tblcallsBilled.FacilityID = @FacilityID   And   tblcallsBilled.errorcode = '0' and
		   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype
		   and  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		   and convert (int,duration ) >5   
		   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			
		   Group by  InmateID, PIN
end
