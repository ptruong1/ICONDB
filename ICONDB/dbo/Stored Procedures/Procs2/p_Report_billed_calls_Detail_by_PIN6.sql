create PROCEDURE [dbo].[p_Report_billed_calls_Detail_by_PIN6]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@PIN		varchar(12),
@divisionID	int
 AS
 
 declare @InmateID varchar(12) = '0'
 IF  @PIN	> 0
	select @InmateID = (InmateID) from tblInmate where FacilityId = @FacilityID and PIN = @PIN
 
 
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0  

Begin
	IF  @InmateID	> 0
		
	     If @divisionID > 0
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location, tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,   fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock) , tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				-- InmateID <>  '0' and	
				 tblcallsBilled.AgentID = @AgentID  And
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				tblcallsBilled.InmateID = @InmateID and
				tblCallsBilled.facilityID = @divisionID and
				  
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				  convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				 and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by Location, tblInmate.InmateID
			else
			Select   Location, tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock), tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				-- InmateID <>  '0' and	
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
				tblcallsBilled.InmateID = @InmateID and
				tblCallsBilled.facilityID = @divisionID and
				  
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				  convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				 and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by Location, tblInmate.InmateID
			
	     else ---
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location, tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock),tblInmate with(nolock)
			  where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				-- InmateID <>  '0' and	
				 tblcallsBilled.AgentID = @AgentID  And
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				tblcallsBilled.InmateID = @InmateID and
				--tblCallsBilled.facilityID = @divisionID and
				  
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				  convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				 and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by Location, tblInmate.InmateID

			else
			Select   Location, tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock),tblInmate with(nolock)
			  where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				-- InmateID <>  '0' and	
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
				tblcallsBilled.InmateID = @InmateID and
				--tblCallsBilled.facilityID = @divisionID and
				  
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				  convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				 and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by Location, tblInmate.InmateID
			
	Else ---
	     If @divisionID > 0
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location, tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock), tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				--InmateID <>  '0' and 
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
			  and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by Location, tblInmate.InmateID
			else
			Select   Location, tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock), tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				--InmateID <>  '0' and 
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
			and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by Location, tblInmate.InmateID
			
	     else --
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location, tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock), tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				--InmateID <>  '0' and 
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
			and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by Location, tblInmate.InmateID
			else
			Select   Location, tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock) , tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				--InmateID <>  '0' and 
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
			and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by Location, tblInmate.InmateID
End
Else --

---------------
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
Begin
	IF  @InmateID	> 0
	     If @divisionID > 0
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			Select   Location, tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock) , tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				 tblinmate.InmateID <>  '0' and	
				 tblcallsBilled.AgentID = @AgentID  And
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				tblcallsBilled.InmateID = @InmateID and
				tblCallsBilled.facilityID = @divisionID and
				  
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				  convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				  and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by Location, tblInmate.InmateID
			else
			
	Select   Location, tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock), tblCommrate with(nolock),  tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				 tblinmate.InmateID <>  '0' and	
				 tblcallsBilled.AgentID = @AgentID  And
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				tblcallsBilled.InmateID = @InmateID and
				tblCallsBilled.facilityID = @divisionID and
				  
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				  convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				 and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by Location, tblInmate.InmateID

			
	     else --
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			Select   Location, tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock),  tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and
				tblinmate.InmateID <>  '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				tblCallsBilled.facilityID = @divisionID and
				 tblcallsBilled.AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				 tblcallsBilled.InmateID = @InmateID 
				 and convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by Location, tblInmate.InmateID
			else
			Select   Location, tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock), tblCommrate with(nolock), tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and
				tblInmate.InmateID <>  '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				tblCallsBilled.facilityID = @divisionID and
				 tblcallsBilled.AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				 tblcallsBilled.InmateID = @InmateID 
				 and convert (int,duration ) >5   
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				 and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by Location, tblInmate.InmateID

			
	Else --
	     If @divisionID > 0
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location, tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock), tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				tblInmate.InmateID <>  '0' and 
			   tblcallsBilled.AgentID = @AgentID  And 
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			tblCallsBilled.facilityID = @divisionID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by Location, tblInmate.InmateID
			else
			Select   Location, tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock), tblCommrate with(nolock), tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				tblInmate.InmateID <>  '0' and 
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
			and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by Location, tblInmate.InmateID
			
	     else --
	    if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0 
		Select   Location, tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock), tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				tblInmate.InmateID <>  '0' and 
			   tblcallsBilled.AgentID = @AgentID  And 
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by Location, tblInmate.InmateID

			
			else
					Select   Location, tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock), tblCommrate with(nolock), tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and
				tblInmate.InmateID <>  '0' and 
			   tblcallsBilled.AgentID = @AgentID  And 
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
			(RecordDate between @fromDate and dateadd(d,1,@todate) )						  
			and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by Location, tblInmate.InmateID
End
Else --
Begin

	IF  @InmateID	> 0
	if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select    tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock), tblCommrateAgent with(nolock) , tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				tblcallsbilled.FacilityID = @FacilityID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				and tblcallsBilled.InmateID = @InmateID 
				and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by  tblInmate.InmateID

	else
		Select    tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock), tblcommrate with(nolock)  , tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   
				 tblcallsBilled.errorcode = '0' and 
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and
				tblcallsbilled.FacilityID = @FacilityID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				and tblcallsBilled.InmateID = @InmateID 
				and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				 and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by  tblInmate.InmateID
				
	
	Else --
	if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select    tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock), tblCommrateAgent with(nolock) , tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and 
			   tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
			   tblcallsbilled.FacilityID = @FacilityID  And 
			   (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			   and convert (int,duration ) >5   
			   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			   and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by  tblInmate.InmateID

			
	else
			Select    tblInmate.InmateID , tblInmate.PIN, (tblInmate.FirstName + ' ' + tblInmate.LastName) InmateName,  fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock), tblcommrate with(nolock)  , tblInmate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
			   tblcallsBilled.errorcode = '0' and 
			   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and  
			   tblcallsbilled.FacilityID = @FacilityID  And 
			   (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			   and convert (int,duration ) >5   
			   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			    and tblInmate.PIN <> '0' and tblInmate.PIN <> ''  and
				 tblInmate.FacilityId= tblCallsBilled.FacilityID and
				 tblInmate.InmateID= tblCallsBilled.InmateID and
				 tblInmate.PIN = tblCallsBilled.PIN 
			order by  tblInmate.InmateID
End
