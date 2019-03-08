

CREATE PROCEDURE [dbo].[p_Report_billed_calls_sum_by_DebitAccount2]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@divisionID	int
 AS

If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0   

Begin
        if @divisionID > 0
        if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location,  tblcallsBilled.CreditcardNo as AccountNo ,  Count( tblcallsBilled.CreditcardNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock), tblFacility with(nolock)
		  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID and  
			tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				tblcallsBilled.BillType = 7 and
			tblCallsBilled.facilityID = @divisionID and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0'  and convert (int,duration ) >15  
			 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by   Location, tblcallsBilled.CreditcardNo
		   Order by   Location, tblcallsBilled.CreditcardNo
		   else
		   Select   Location,  tblcallsBilled.CreditcardNo as AccountNo ,  Count( tblcallsBilled.CreditcardNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock), tblFacility with(nolock)
		  , tblCommrate with(nolock), tblBaddebt with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID and  
			tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrate.AgentID AND
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				tblcallsBilled.BillType = 7 and
			tblCallsBilled.facilityID = @divisionID and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0'  and convert (int,duration ) >15  
			 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by   Location, tblcallsBilled.CreditcardNo
		   Order by   Location, tblcallsBilled.CreditcardNo
        Else
        if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location,tblcallsBilled.CreditcardNo as AccountNo  ,  Count( tblcallsBilled.CreditcardNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock), tblFacility with(nolock)
		  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID and  
			tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				tblcallsBilled.BillType = 7 and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0'  
			 and convert (int,duration ) >5  
			 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by   Location, tblcallsBilled.CreditcardNo
		   Order by   Location, tblcallsBilled.CreditcardNo
		   else
		   Select   Location,  tblcallsBilled.CreditcardNo as AccountNo ,  Count( tblcallsBilled.CreditcardNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock), tblFacility with(nolock)
		  , tblCommrate with(nolock), tblBaddebt with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID and  
			tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				tblcallsBilled.BillType = 7 and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0' 
			 and convert (int,duration ) >5  
			 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by   Location, tblcallsBilled.CreditcardNo
		   Order by   Location, tblcallsBilled.CreditcardNo
End
Else--
--------
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
Begin
        if @divisionID > 0
        if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location,  tblcallsBilled.CreditcardNo AccountNo  ,  Count( tblcallsBilled.CreditcardNo ) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock), tblFacility with(nolock), tblcommrateAgent with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID and  
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			tblcallsBilled.BillType = 7 and
			tblCallsBilled.facilityID = @divisionID and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0' and convert (int,duration ) >15  
			 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by   Location, tblcallsBilled.CreditcardNo
		   Order by   Location, tblcallsBilled.CreditcardNo
		   else
		   Select   Location, tblcallsBilled.CreditcardNo as AccountNo  ,  Count( tblcallsBilled.CreditcardNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock), tblFacility with(nolock), tblCommrate with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID and  
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			 tblcallsbilled.AgentID = tblCommrate.AgentID AND
			tblcallsbilled.FacilityID=  tblCommrate.FacilityID and	 
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
			tblcallsBilled.BillType = 7 and
			tblCallsBilled.facilityID = @divisionID and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0' and convert (int,duration ) >15  
			 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by   Location, tblcallsBilled.CreditcardNo
		   Order by   Location, tblcallsBilled.CreditcardNo
        Else--
		Select   Location,  tblcallsBilled.CreditcardNo as AccountNo  ,  Count(tblcallsBilled.CreditcardNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock),  tblFacility with(nolock), tblcommrateAgent with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID and  
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			tblcallsBilled.BillType = 7 and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0'   
			 and convert (int,duration ) >5  
			 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by   Location, tblcallsBilled.CreditcardNo
		   Order by   Location, tblcallsBilled.CreditcardNo
End
Else
Begin
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   tblcallsBilled.CreditcardNo AccountNo  
		,  Count(tblcallsBilled.CreditcardNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock),  tblCommrateAgent with(nolock)
		   where  tblcallsBilled.FacilityID = @FacilityID and  
			 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and 
			tblcallsBilled.BillType = 7 and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0'   
			 and convert (int,duration ) >5  
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by  tblcallsBilled.CreditcardNo
		else
		Select    tblcallsBilled.CreditcardNo AccountNo  
		,  Count(tblcallsBilled.CreditcardNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock), tblcommrate with(nolock)
		   where  tblcallsBilled.FacilityID = @FacilityID and  
			 
			 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and 
			tblcallsBilled.BillType = 7 and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0'  
			 and convert (int,duration ) >5  
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by   tblcallsBilled.CreditcardNo
end
