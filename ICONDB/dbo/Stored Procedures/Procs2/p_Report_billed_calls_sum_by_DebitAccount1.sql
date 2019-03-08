

CREATE PROCEDURE [dbo].[p_Report_billed_calls_sum_by_DebitAccount1]
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
		Select   Location,  AccountNo  ,  Count( AccountNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) , tblFacility with(nolock)
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
				tblDebit.facilityID = tblCallsBilled.FacilityID and
			tblCallsBilled.facilityID = @divisionID and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0' and   tblDebit.AccountNo = tblcallsBilled.CreditcardNo  and convert (int,duration ) >15  
			 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by   Location, AccountNo
		   Order by   Location, AccountNo
		   else
		   Select   Location,  AccountNo  ,  Count( AccountNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) , tblFacility with(nolock)
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
				tblDebit.facilityID = tblCallsBilled.FacilityID and
			tblCallsBilled.facilityID = @divisionID and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0' and   tblDebit.AccountNo = tblcallsBilled.CreditcardNo  and convert (int,duration ) >15  
			 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by   Location, AccountNo
		   Order by   Location, AccountNo
        Else
        if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location,  AccountNo  ,  Count( AccountNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) , tblFacility with(nolock)
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
				tblDebit.facilityID = tblCallsBilled.FacilityID and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0' and   tblDebit.AccountNo = tblcallsBilled.CreditcardNo  
			 and convert (int,duration ) >5  
			 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by   Location, AccountNo
		   Order by   Location, AccountNo
		   else
		   Select   Location,  AccountNo  ,  Count( AccountNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) , tblFacility with(nolock)
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
				tblDebit.facilityID = tblCallsBilled.FacilityID and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0' and   tblDebit.AccountNo = tblcallsBilled.CreditcardNo  
			 and convert (int,duration ) >5  
			 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by   Location, AccountNo
		   Order by   Location, AccountNo
End
Else--
--------
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
Begin
        if @divisionID > 0
        if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location,  AccountNo  ,  Count( AccountNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID and  
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			tblDebit.facilityID = tblCallsBilled.FacilityID and
			tblCallsBilled.facilityID = @divisionID and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0' and   tblDebit.AccountNo = tblcallsBilled.CreditcardNo  and convert (int,duration ) >15  
			 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by   Location, AccountNo
		   Order by   Location, AccountNo
		   else
		   Select   Location,  AccountNo  ,  Count( AccountNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) , tblFacility with(nolock), tblCommrate with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID and  
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			 tblcallsbilled.AgentID = tblCommrate.AgentID AND
			tblcallsbilled.FacilityID=  tblCommrate.FacilityID and	 
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
			tblDebit.facilityID = tblCallsBilled.FacilityID and
			tblCallsBilled.facilityID = @divisionID and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0' and   tblDebit.AccountNo = tblcallsBilled.CreditcardNo  and convert (int,duration ) >15  
			 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by   Location, AccountNo
		   Order by   Location, AccountNo
        Else--
		Select   Location,  AccountNo  ,  Count( AccountNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
		   where  tblcallsBilled.AgentID = @AgentID and  
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			tblDebit.facilityID = tblCallsBilled.FacilityID and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0' and   tblDebit.AccountNo = tblcallsBilled.CreditcardNo  
			 and convert (int,duration ) >5  
			 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by   Location, AccountNo
		   Order by   Location, AccountNo
End
Else
Begin
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    AccountNo  
		,  Count( AccountNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock),  tblDebit  with(nolock), tblCommrateAgent with(nolock)
		   where  tblcallsBilled.FacilityID = @FacilityID and  
			 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and 
			tblDebit.facilityID = tblCallsBilled.FacilityID and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0' and   tblDebit.AccountNo = tblcallsBilled.CreditcardNo  
			 and convert (int,duration ) >5  
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by   AccountNo
		else
		Select    AccountNo  
		,  Count( AccountNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock),  tblDebit  with(nolock), tblcommrate with(nolock)
		   where  tblcallsBilled.FacilityID = @FacilityID and  
			 
			 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and 
			tblDebit.facilityID = tblCallsBilled.FacilityID and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0' and   tblDebit.AccountNo = tblcallsBilled.CreditcardNo  
			 and convert (int,duration ) >5  
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by   AccountNo
end
