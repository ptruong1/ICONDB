CREATE PROCEDURE [dbo].[p_Report_billed_calls_Detail_by_PIN2]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@PIN		int,
@divisionID	int
 AS
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0  

Begin
	IF  @PIN	> 0
	     If @divisionID > 0
		Select   Location, PIN ,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				-- PIN <>  '0' and	
				 tblcallsBilled.AgentID = @AgentID  And
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				tblcallsBilled.PIN = @PIN and
				tblCallsBilled.facilityID = @divisionID and
				  
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				  convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, PIN
	     else
		Select   Location, PIN ,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			  where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				-- PIN <>  '0' and	
				 tblcallsBilled.AgentID = @AgentID  And
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				tblcallsBilled.PIN = @PIN and
				--tblCallsBilled.facilityID = @divisionID and
				  
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				  convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, PIN
	Else
	     If @divisionID > 0
		Select    Location, PIN ,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				--PIN <>  '0' and 
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
			order by Location, PIN
	     else
		Select    Location, PIN ,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				--PIN <>  '0' and 
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
			order by Location, PIN
End
Else

---------------
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
Begin
	IF  @PIN	> 0
	     If @divisionID > 0
		Select   Location, PIN ,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				 PIN <>  '0' and	
				 tblcallsBilled.AgentID = @AgentID  And
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				tblcallsBilled.PIN = @PIN and
				tblCallsBilled.facilityID = @divisionID and
				  
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				  convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, PIN
	     else
		Select   Location, PIN ,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and
				PIN <>  '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				tblCallsBilled.facilityID = @divisionID and
				 tblcallsBilled.AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				 tblcallsBilled.PIN = @PIN 
				 and convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, PIN
	Else
	     If @divisionID > 0
		Select    Location, PIN ,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				PIN <>  '0' and 
			   tblcallsBilled.AgentID = @AgentID  And 
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			tblCallsBilled.facilityID = @divisionID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, PIN
	     else
		Select    Location, PIN ,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				PIN <>  '0' and 
			   tblcallsBilled.AgentID = @AgentID  And 
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by Location, PIN
End
Else
Begin

	IF  @PIN	> 0
	
		Select   PIN ,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock), tblcommrate with(nolock) 
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and
				tblcallsbilled.FacilityID = @FacilityID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				and tblcallsBilled.PIN = @PIN 
				and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	
	Else
		Select    PIN ,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
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
			order by PIN
End
