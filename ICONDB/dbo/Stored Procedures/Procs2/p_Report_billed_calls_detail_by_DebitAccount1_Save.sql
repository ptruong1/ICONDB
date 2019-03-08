
CREATE PROCEDURE [dbo].[p_Report_billed_calls_detail_by_DebitAccount1_Save]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime , -- Required 
@AccountNo	varchar(12),
@divisionID	int

 AS
set @AccountNo = ltrim(@AccountNo)
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0   

Begin

	If(@AccountNo <> '') 
	    If @divisionID > 0
		Select    Location, AccountNo as [Prepaid Card]   , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
				tblcallsBilled.errorcode = '0' and  
				 tblDebit.FacilityID =  tblcallsBilled.FacilityID  And
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID and
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				 tblDebit.AccountNo = tblcallsBilled.CreditcardNo  and
				 tblDebit.AccountNo = @AccountNo	and
				 tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				    and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, AccountNo, RecordDate
	   else
		Select    Location, AccountNo as [Prepaid Card]   , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
				tblcallsBilled.errorcode = '0' and  
				 tblDebit.FacilityID =  tblcallsBilled.FacilityID  And
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID and
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				 tblDebit.AccountNo = tblcallsBilled.CreditcardNo  and
				 tblDebit.AccountNo = @AccountNo	and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				    and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, AccountNo, RecordDate
	Else
	     If @divisionID > 0
		Select    Location, AccountNo as [Prepaid Card]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
			   tblcallsBilled.errorcode = '0' and 
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID and
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				 tblDebit.FacilityID =  tblcallsBilled.FacilityID  And 
				 tblDebit.AccountNo = tblcallsBilled.CreditcardNo   and
				tblCallsBilled.facilityID = @divisionID and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, AccountNo, RecordDate
	 else
		Select    Location, AccountNo as [Prepaid Card]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
			   tblcallsBilled.errorcode = '0' and 
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID and
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				 tblDebit.FacilityID =  tblcallsBilled.FacilityID  And 
				 tblDebit.AccountNo = tblcallsBilled.CreditcardNo   and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, AccountNo, RecordDate
 End
else
-------------------
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
Begin

	If(@AccountNo <> '') 
	    If @divisionID > 0
		Select    Location, AccountNo as [Prepaid Card]   , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
				tblcallsBilled.errorcode = '0' and  
				 tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID and
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblDebit.FacilityID =  tblcallsBilled.FacilityID  And
				 tblDebit.AccountNo = tblcallsBilled.CreditcardNo  and
				 tblDebit.AccountNo = @AccountNo	and
				tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				    and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, AccountNo, RecordDate
	     else
		Select    Location, AccountNo as [Prepaid Card]   , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
				tblcallsBilled.errorcode = '0' and  
				 tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID and
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblDebit.FacilityID =  tblcallsBilled.FacilityID  And
				 tblDebit.AccountNo = tblcallsBilled.CreditcardNo  and
				 tblDebit.AccountNo = @AccountNo	and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				    and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, AccountNo, RecordDate
	Else
	     If @divisionID > 0
		Select    Location, AccountNo as [Prepaid Card]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
			   tblcallsBilled.errorcode = '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID and
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblDebit.FacilityID =  tblcallsBilled.FacilityID  And 
				 tblDebit.AccountNo = tblcallsBilled.CreditcardNo   and
				tblCallsBilled.facilityID = @divisionID and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, AccountNo, RecordDate
	    else
		Select    Location, AccountNo as [Prepaid Card]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
			   tblcallsBilled.errorcode = '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID and
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblDebit.FacilityID =  tblcallsBilled.FacilityID  And 
				 tblDebit.AccountNo = tblcallsBilled.CreditcardNo   and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, AccountNo, RecordDate

 End
else
 Begin
	If(@AccountNo <> '') 
		Select    AccountNo as [Prepaid Card]   , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblDebit  with(nolock), tblcommrate with(nolock)
			   where  tblcallsBilled.FacilityID = @FacilityID and
			   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and  
				tblDebit.FacilityID =  tblcallsBilled.FacilityID  And 
				     tblcallsBilled.errorcode = '0' and 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblDebit.AccountNo =  tblcallsBilled.CreditcardNo   and   tblDebit.AccountNo = @AccountNo	 and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	
	Else
		Select    AccountNo as [Prepaid Card]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblDebit  with(nolock), tblcommrate with(nolock) 
			   where  tblcallsBilled.FacilityID = @FacilityID and
			   tblcallsBilled.errorcode = '0' and
			   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and  
				 tblDebit.FacilityID =  tblcallsBilled.FacilityID  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblDebit.AccountNo = tblcallsBilled.CreditcardNo   and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  AccountNo, RecordDate
 End
