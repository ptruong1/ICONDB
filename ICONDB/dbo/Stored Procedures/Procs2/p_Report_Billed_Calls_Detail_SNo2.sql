CREATE PROCEDURE [dbo].[p_Report_Billed_Calls_Detail_SNo2]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@FromNo	varchar(10),
@divisionID	int
 AS
 
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0  

Begin
	IF  @fromNo	> '0'
		
	     If @divisionID > 0
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location, InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				-- fromNo <>  '0' and	
				 tblcallsBilled.AgentID = @AgentID  And
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				tblcallsBilled.fromNo = @fromNo and
				tblCallsBilled.facilityID = @divisionID and
				  
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				  convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, fromNo
			else
			Select   Location, InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				-- fromNo <>  '0' and	
				 tblcallsBilled.AgentID = @AgentID  And
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				tblcallsBilled.fromNo = @fromNo and
				tblCallsBilled.facilityID = @divisionID and
				  
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				  convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, fromNo
			
	     else ---
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location, InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			  where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				-- fromNo <>  '0' and	
				 tblcallsBilled.AgentID = @AgentID  And
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				tblcallsBilled.fromNo = @fromNo and
				--tblCallsBilled.facilityID = @divisionID and
				  
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				  convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, fromNo
			else
			Select   Location, InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock)
			  where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				-- fromNo <>  '0' and	
				 tblcallsBilled.AgentID = @AgentID  And
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				tblcallsBilled.fromNo = @fromNo and
				--tblCallsBilled.facilityID = @divisionID and
				  
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				  convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, fromNo
			
	Else ---
	     If @divisionID > 0
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				--fromNo <>  '0' and 
			   tblcallsBilled.AgentID = @AgentID  And 
			tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
			tblCallsBilled.facilityID = @divisionID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, fromNo
			else
			Select    Location, InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				--fromNo <>  '0' and 
			   tblcallsBilled.AgentID = @AgentID  And 
			tblcallsbilled.AgentID = tblCommrate.AgentID AND
			tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
			tblCallsBilled.facilityID = @divisionID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, fromNo
			
	     else --
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				--fromNo <>  '0' and 
			   tblcallsBilled.AgentID = @AgentID  And 
			tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, fromNo
			else
			Select    Location, InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				--fromNo <>  '0' and 
			   tblcallsBilled.AgentID = @AgentID  And 
			tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			tblcallsbilled.AgentID = tblCommrate.AgentID AND
			tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, fromNo
End
Else --

---------------
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
Begin
	IF  @fromNo	> '0'
	     If @divisionID > 0
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location, InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				 fromNo <>  '0' and	
				 tblcallsBilled.AgentID = @AgentID  And
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				tblcallsBilled.fromNo = @fromNo and
				tblCallsBilled.facilityID = @divisionID and
				  
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				  convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, fromNo
			else
			
Select   Location, InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock), tblCommrate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				 fromNo <>  '0' and	
				 tblcallsBilled.AgentID = @AgentID  And
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				tblcallsBilled.fromNo = @fromNo and
				tblCallsBilled.facilityID = @divisionID and
				  
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				  convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, fromNo

			
	     else --
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location, InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and
				fromNo <>  '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				tblCallsBilled.facilityID = @divisionID and
				 tblcallsBilled.AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				 tblcallsBilled.fromNo = @fromNo 
				 and convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, fromNo
			else
			Select   Location, InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock), tblCommrate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and
				fromNo <>  '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				tblCallsBilled.facilityID = @divisionID and
				 tblcallsBilled.AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				 tblcallsBilled.fromNo = @fromNo 
				 and convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, fromNo

			
	Else --
	     If @divisionID > 0
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				fromNo <>  '0' and 
			   tblcallsBilled.AgentID = @AgentID  And 
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			tblCallsBilled.facilityID = @divisionID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, fromNo
			else
			Select    Location, InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock), tblCommrate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				fromNo <>  '0' and 
			   tblcallsBilled.AgentID = @AgentID  And 
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
			tblCallsBilled.facilityID = @divisionID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, fromNo
			
	     else --
	    if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0 
		Select    Location, InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				fromNo <>  '0' and 
			   tblcallsBilled.AgentID = @AgentID  And 
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, fromNo
			else
			Select    Location, InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock), tblCommrate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				fromNo <>  '0' and 
			   tblcallsBilled.AgentID = @AgentID  And 
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, fromNo
End
Else --
Begin

	IF  @fromNo	> '0'
	if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select   InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock), tblCommrateAgent with(nolock) 
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				tblcallsbilled.FacilityID = @FacilityID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				and tblcallsBilled.fromNo = @fromNo 
				and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	else
		Select   InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock), tblcommrate with(nolock) 
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and
				tblcallsbilled.FacilityID = @FacilityID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				and tblcallsBilled.fromNo = @fromNo 
				and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				
				
	
	Else --
	if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select    InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock), tblCommrateAgent with(nolock) 
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and 
			   tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
			   tblcallsbilled.FacilityID = @FacilityID  And 
			   (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			   and convert (int,duration ) >5   
			   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by fromNo
	else
		Select    InmateID , PIN,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock), tblcommrate with(nolock) 
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and 
			   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and  
			   tblcallsbilled.FacilityID = @FacilityID  And 
			   (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			   and convert (int,duration ) >5   
			   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by fromNo
End
