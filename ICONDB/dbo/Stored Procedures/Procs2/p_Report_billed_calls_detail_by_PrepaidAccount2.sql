
CREATE PROCEDURE [dbo].[p_Report_billed_calls_detail_by_PrepaidAccount2]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime , -- Required 
@AccountNo	varchar(10),
@divisionID	int

 AS
set @AccountNo = ltrim(@AccountNo)

If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0   
Begin

	If(@AccountNo <> '')
	      If @divisionID > 0
	      if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, PhoneNo as [Account No]    , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock),  tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and  
				
				 tblcallsBilled.errorcode = '0' and 
				
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsbilled.Billtype =  '10' and 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				tblPrepaid.PhoneNo = tblcallsBilled.billtono  and
				tblCallsBilled.facilityID = @divisionID and
				 PhoneNo = @AccountNo	 and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and   convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, PhoneNo, RecordDate
		else
		Select    Location, PhoneNo as [Account No]    , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock),  tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and  
				
				 tblcallsBilled.errorcode = '0' and 
				tblcallsbilled.Billtype =  '10' and
				 tblcallsbilled.AgentID = tblCommrate.AgentID AND
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and 
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				tblPrepaid.PhoneNo = tblcallsBilled.billtono  and
				tblCallsBilled.facilityID = @divisionID and
				 PhoneNo = @AccountNo	 and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and   convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, PhoneNo, RecordDate

	      Else --
	      if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, PhoneNo as [Account No]    , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock),  tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and  
				
				 tblcallsBilled.errorcode = '0' and 
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsbilled.Billtype =  '10' and 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				tblPrepaid.PhoneNo = tblcallsBilled.billtono  and
				 PhoneNo = @AccountNo	 and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and   convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, PhoneNo, RecordDate
		else
		Select    Location, PhoneNo as [Account No]    , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock),  tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and  
				tblcallsbilled.Billtype =  '10' and
				 tblcallsBilled.errorcode = '0' and 
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and 
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				tblPrepaid.PhoneNo = tblcallsBilled.billtono  and
				 PhoneNo = @AccountNo	 and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and   convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, PhoneNo, RecordDate

	Else --
	     If @divisionID > 0
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	             	Select    Location, PhoneNo as [Account No]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and  
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsBilled.errorcode = '0' and
				 tblcallsbilled.Billtype =  '10' and 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				  tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				tblPrepaid.PhoneNo = tblcallsBilled.billtono  and
				PhoneNo = tblcallsBilled.billtono   and
				tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  PhoneNo = tblcallsBilled.billtono   and convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, PhoneNo, RecordDate
		else
		Select    Location, PhoneNo as [Account No]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and  
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				 tblcallsBilled.errorcode = '0' and 
				 tblcallsbilled.Billtype =  '10' and
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				  tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				tblPrepaid.PhoneNo = tblcallsBilled.billtono  and
				PhoneNo = tblcallsBilled.billtono   and
				tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  PhoneNo = tblcallsBilled.billtono   and convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, PhoneNo, RecordDate
	     Else --
	     
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, PhoneNo as [Account No]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and  
				tblcallsBilled.errorcode = '0' and
				tblcallsbilled.Billtype =  '10' and
				tblcallsbilled.AgentID =  tblCommrateAgent.AgentID and
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				 tblPrepaid.PhoneNo = tblcallsBilled.billtono  and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and   convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, PhoneNo, RecordDate
		 else
			Select    Location, PhoneNo as [Account No]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and  
				tblcallsBilled.errorcode = '0' and
				tblcallsbilled.Billtype =  '10' and
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				tblcallsbilled.AgentID =  tblCommrate.AgentID and
				tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				 tblPrepaid.PhoneNo = tblcallsBilled.billtono  and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and   convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, PhoneNo, RecordDate

 End
else --
---------
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
Begin

	If(@AccountNo <> '')
	      If @divisionID > 0
	      if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, PhoneNo as [Account No]    , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock),  tblFacility with(nolock)
			  , tblCommrateAgent with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and  
				
				tblcallsbilled.Billtype =  '10' and 
				tblcallsBilled.errorcode = '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				  
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			 tblPrepaid.FacilityID =  tblcallsBilled.FacilityID  And
				PhoneNo = tblcallsBilled.billtono  and
				tblCallsBilled.facilityID = @divisionID and
				 PhoneNo = @AccountNo	 and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  PhoneNo = tblcallsBilled.billtono   and convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, PhoneNo, RecordDate
		else
		Select    Location, PhoneNo as [Account No]    , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock),  tblFacility with(nolock)
			  , tblCommrate with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and  
				
				tblcallsbilled.Billtype =  '10' and 
				tblcallsBilled.errorcode = '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrate.AgentID AND
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and 
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
			 tblPrepaid.FacilityID =  tblcallsBilled.FacilityID  And
				PhoneNo = tblcallsBilled.billtono  and
				tblCallsBilled.facilityID = @divisionID and
				 PhoneNo = @AccountNo	 and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  PhoneNo = tblcallsBilled.billtono   and convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, PhoneNo, RecordDate
	      Else --
	      if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, PhoneNo as [Account No]    , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock),  tblFacility with(nolock)
			  , tblCommrateAgent with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and  
				tblcallsbilled.Billtype =  '10' and
				 tblcallsBilled.errorcode = '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				  
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			 tblPrepaid.FacilityID =  tblcallsBilled.FacilityID  And
				PhoneNo = tblcallsBilled.billtono  and
				 PhoneNo = @AccountNo	 and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  PhoneNo = tblcallsBilled.billtono   and convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, PhoneNo, RecordDate
		else
		Select    Location, PhoneNo as [Account No]    , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock),  tblFacility with(nolock)
			  , tblCommrate with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and  
				tblcallsbilled.Billtype =  '10' and
				 tblcallsBilled.errorcode = '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrate.AgentID AND
				  tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
			 tblPrepaid.FacilityID =  tblcallsBilled.FacilityID  And
				PhoneNo = tblcallsBilled.billtono  and
				 PhoneNo = @AccountNo	 and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  PhoneNo = tblcallsBilled.billtono   and convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, PhoneNo, RecordDate
	Else--
	     If @divisionID > 0
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	             	Select    Location, PhoneNo as [Account No]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock)
			  , tblCommrateAgent with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and  
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsbilled.Billtype =  '10' and 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			 tblPrepaid.FacilityID =  tblcallsBilled.FacilityID  And
				PhoneNo = tblcallsBilled.billtono   and
				tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  PhoneNo = tblcallsBilled.billtono   and convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, PhoneNo, RecordDate
		 else
		 
			Select    Location, PhoneNo as [Account No]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock)
			  , tblCommrate with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and 
			   tblcallsbilled.Billtype =  '10' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrate.AgentID AND
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
			 tblPrepaid.FacilityID =  tblcallsBilled.FacilityID  And
				PhoneNo = tblcallsBilled.billtono   and
				tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  PhoneNo = tblcallsBilled.billtono   and convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, PhoneNo, RecordDate
				 
	     Else--
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, PhoneNo as [Account No]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock)
			  , tblCommrateAgent with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and  
			   tblcallsbilled.Billtype =  '10' and
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				  
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			 tblPrepaid.FacilityID =  tblcallsBilled.FacilityID  And
				PhoneNo = tblcallsBilled.billtono   and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and  PhoneNo = tblcallsBilled.billtono   and convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, PhoneNo, RecordDate
		 else
		 Select    Location, PhoneNo as [Account No]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock)
			  , tblCommrate with(nolock)
			   where  tblcallsBilled.AgentID = @AgentID and  
			   tblcallsbilled.Billtype =  '10' and
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrate.AgentID AND
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and 
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
			 tblPrepaid.FacilityID =  tblcallsBilled.FacilityID  And
				PhoneNo = tblcallsBilled.billtono   and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and  PhoneNo = tblcallsBilled.billtono   and convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, PhoneNo, RecordDate

 End
else --
Begin

	If(@AccountNo <> '')
	    if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	    Select    Location, PhoneNo as [Account No]    , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock),  tblFacility with(nolock), tblCommrateAgent with(nolock)
			   where    
				tblcallsbilled.Billtype =  '10' and
				 tblcallsBilled.errorcode = '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			 tblPrepaid.FacilityID =  tblcallsBilled.FacilityID  And
			 tblcallsBilled.facilityID = @facilityID and 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  PhoneNo = tblcallsBilled.billtono  and   PhoneNo = @AccountNo	 and convert (int,duration ) >5   
				  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, PhoneNo, RecordDate
	    else  
		Select    Location, PhoneNo as [Account No]    , fromNo, tono,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock),  tblFacility with(nolock), tblcommrate with(nolock)
			   where    
				tblcallsbilled.Billtype =  '10' and 
				 tblcallsBilled.errorcode = '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and
			 tblPrepaid.FacilityID =  tblcallsBilled.FacilityID  And
			 tblcallsBilled.facilityID = @facilityID and 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  PhoneNo = tblcallsBilled.billtono  and   PhoneNo = @AccountNo	 and convert (int,duration ) >5   
				  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Order by  Location, PhoneNo, RecordDate
	Else
	if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select    Location, PhoneNo as [Account No]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock), tblCommrateAgent with(nolock)
			   where    
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			 tblcallsBilled.errorcode = '0' and
			 tblcallsbilled.Billtype =  '10' and
			 tblcallsBilled.facilityID = @facilityID and
				 tblPrepaid.FacilityID =  tblcallsBilled.FacilityID  And 
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and  PhoneNo = tblcallsBilled.billtono   and convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, PhoneNo, RecordDate
	else
		Select    Location, PhoneNo as [Account No]   , fromNo, tono,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as TotalMinutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock), tblcommrate with(nolock)
			   where 
			   tblcallsbilled.Billtype =  '10' and   
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and
			 tblcallsBilled.errorcode = '0' and
			 tblcallsBilled.facilityID = @facilityID and
				 tblPrepaid.FacilityID =  tblcallsBilled.FacilityID  And 
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and  PhoneNo = tblcallsBilled.billtono   and convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		 Order by  Location, PhoneNo, RecordDate

 End
