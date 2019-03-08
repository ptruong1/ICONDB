
CREATE PROCEDURE [dbo].[p_Report_billed_calls_detail_by_DebitAccount2]
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
	    if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock), tblFacility with(nolock)
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
				 tblcallsBilled.Billtype = 7  and
				 tblcallsBilled.CreditcardNo = @AccountNo	and
				 tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				    and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, tblcallsBilled.CreditcardNo, RecordDate
		else
		Select    Location, tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock), tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
				tblcallsBilled.errorcode = '0' and  
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.AgentID = tblCommrate.AgentID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				 tblcallsBilled.Billtype = 7  and
				 tblcallsBilled.CreditcardNo = @AccountNo	and
				 tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				    and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, tblcallsBilled.CreditcardNo, RecordDate

	   else --
	   if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock), tblFacility with(nolock)
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
				 tblcallsBilled.BillType = 7  and
				 tblcallsBilled.CreditcardNo = @AccountNo	and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				    and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, tblcallsBilled.CreditcardNo, RecordDate
		else
		Select    Location, tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
				tblcallsBilled.errorcode = '0' and  
				
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.AgentID = tblCommrate.AgentID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				 tblcallsBilled.BillType = tblcallsBilled.CreditcardNo  and
				 tblcallsBilled.CreditcardNo = @AccountNo	and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				    and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location,tblcallsBilled.CreditcardNo, RecordDate
	Else
	     If @divisionID > 0
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock), tblFacility with(nolock)
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
				 tblcallsBilled.Billtype =  7  And 
				 
				tblCallsBilled.facilityID = @divisionID and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, tblcallsBilled.CreditcardNo, RecordDate
		 else
		 Select    Location, tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock), tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
			   tblcallsBilled.errorcode = '0' and 
				 tblcallsbilled.AgentID = tblCommrate.AgentID and
				tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				 tblcallsBilled.BillType =  7  And 
				 
				tblCallsBilled.facilityID = @divisionID and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, tblcallsBilled.CreditcardNo, RecordDate
	 else ---
	 if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock), tblFacility with(nolock)
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
				 tblcallsBilled.BillType =  7 and
			
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, tblcallsBilled.CreditcardNo, RecordDate
		 else
		 Select    Location, tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
			   tblcallsBilled.errorcode = '0' and 
				 tblcallsbilled.AgentID = tblCommrate.AgentID and
				tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				 tblcallsBilled.BillType =  7  And 
				 
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, tblcallsBilled.CreditcardNo, RecordDate

 End
else
-------------------
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
Begin

	If(@AccountNo <> '') 
	    If @divisionID > 0
	    if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock), tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
				tblcallsBilled.errorcode = '0' and  
				 tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID and
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 
				 tblcallsBilled.BillType = 7  and
				 tblcallsBilled.CreditcardNo = @AccountNo	and
				tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				    and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, tblcallsBilled.CreditcardNo, RecordDate
		else
		Select    Location, tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock), tblFacility with(nolock), tblCommrate with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
				tblcallsBilled.errorcode = '0' and  
				 tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrate.AgentID and
				tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 
				 tblcallsBilled.Billtype = 7  and
				 tblcallsBilled.CreditcardNo = @AccountNo	and
				tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				    and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, tblcallsBilled.CreditcardNo, RecordDate
	     else --
	    if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
 
		Select    Location, tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),   tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
				tblcallsBilled.errorcode = '0' and  
				 tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID and
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 
				 tblcallsBilled.Billtype = 7  and
				 tblcallsBilled.CreditcardNo = @AccountNo	and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				    and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location,tblcallsBilled.CreditcardNo, RecordDate
		else
		Select    Location, tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblFacility with(nolock), tblCommrate with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
				tblcallsBilled.errorcode = '0' and  
				 tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrate.AgentID and
				tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 
				 tblcallsBilled.BillType = 7  and
				 tblcallsBilled.CreditcardNo = @AccountNo	and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				    and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, tblcallsBilled.CreditcardNo, RecordDate
		
	Else --
	     If @divisionID > 0
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock), tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
			   tblcallsBilled.errorcode = '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID and
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 
				 tblcallsBilled.BillType = 7   and
				tblCallsBilled.facilityID = @divisionID and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, tblcallsBilled.CreditcardNo, RecordDate
		 else
		 Select    Location, tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock), tblFacility with(nolock), tblCommrate with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
			   tblcallsBilled.errorcode = '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrate.AgentID and
				tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 
				 tblcallsBilled.BillType = 7   and
				tblCallsBilled.facilityID = @divisionID and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, tblcallsBilled.CreditcardNo, RecordDate
		 
	    else --
	    if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock), tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
			   tblcallsBilled.errorcode = '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID and
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 
				 tblcallsBilled.BillType = 7   and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, tblcallsBilled.CreditcardNo, RecordDate
		 else
		Select    Location, tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock), tblFacility with(nolock), tblCommrate with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
			   tblcallsBilled.errorcode = '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrate.AgentID and
				tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 
				 tblcallsBilled.BillType = 7  and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, tblcallsBilled.CreditcardNo, RecordDate

 End
else ---
 Begin
	If(@AccountNo <> '')
	if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select    tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock), tblCommrateAgent with(nolock)
			   where  tblcallsBilled.FacilityID = @FacilityID and
			   tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
				 
				     tblcallsBilled.errorcode = '0' and 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblcallsBilled.BillType =  7  and   tblcallsBilled.CreditcardNo = @AccountNo	 and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	else 
		Select    tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblcommrate with(nolock)
			   where  tblcallsBilled.FacilityID = @FacilityID and
			   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and  
				
				     tblcallsBilled.errorcode = '0' and 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblcallsBilled.BillType =  7   and   tblcallsBilled.CreditcardNo = @AccountNo	 and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	
	Else --
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblCommrateAgent with(nolock) 
			   where  tblcallsBilled.FacilityID = @FacilityID and
			   tblcallsBilled.errorcode = '0' and
			   tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
				 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblcallsBilled.BillType = 7   and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  tblcallsBilled.CreditcardNo, RecordDate
		else
		Select    tblcallsBilled.CreditcardNo as [Prepaid Card]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock), tblcommrate with(nolock) 
			   where  tblcallsBilled.FacilityID = @FacilityID and
			   tblcallsBilled.errorcode = '0' and
			   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and  
				 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblcallsBilled.BillType = 7   and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  tblcallsBilled.CreditcardNo, RecordDate
 End
