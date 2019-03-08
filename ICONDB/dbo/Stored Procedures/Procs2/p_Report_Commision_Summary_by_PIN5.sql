CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_PIN5]

@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@Pin	varchar(12),
@DivisionID       int
AS

declare @InmateID varchar(12) = ''
 IF  @PIN	<> ''
	select @InmateID = (InmateID) from tblInmate where FacilityId = @FacilityID and PIN = @PIN
	
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0
 Begin 
	If(@PIN <> '')
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			If @DivisionID > 0
			select  InmateID, PIN,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
			 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,   
			sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.agentID = @agentID and
								
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and InmateID = @InmateID  
								and  tblcallsbilled.FacilityID = @DivisionID
								and PIN <> '0' and PIN <> ''
								
			group by State, InmateID,  PIN
			Order by State, InmateID,  PIN
			Else --- DivisionId = 0
			select  InmateID, PIN,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
			 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
			sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.agentID = @agentID and
								
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and PIN <> '0' and PIN <> ''
								and InmateID = @InmateID 
								----and  tblcallsbilled.FacilityID = @DivisionID
								
			group by State, InmateID,  PIN
			Order by State, InmateID,  PIN
		else --- CommRateAgent not found
		 If @DivisionID > 0
			select  InmateID, PIN, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
			sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,   
			sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

			from tblcallsbilled with(nolock), tblCommRate with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								 tblcallsbilled.FacilityID =tblCommrate.FacilityID and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and PIN <> '0' and PIN <> ''
								and InmateID = @InmateID 
								and  tblcallsbilled.FacilityID = @DivisionID
								 
			group by State, InmateID,  PIN
			Order by State, InmateID,  PIN
			Else --- DivisionID = 0
			select  InmateID, PIN, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
			 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, 
			sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

			from tblcallsbilled with(nolock), tblCommRate with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								 tblcallsbilled.FacilityID =tblCommrate.FacilityID and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and PIN <> '0' and PIN <> ''
								and InmateID = @InmateID 
								---- and  tblcallsbilled.FacilityID = @DivisionID
								 
			group by State, InmateID,  PIN
			Order by State, InmateID,  PIN
	Else ---PIN = ''
	
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		 If @DivisionID > 0
			select  InmateID, PIN,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
			 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, 
			sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )   and
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and PIN <> '0' and PIN <> ''
								and tblcallsbilled.FacilityID =  @DivisionID
								 
			group by State, InmateID,  PIN
			Order by State, InmateID,  PIN
			Else -- Dvision = 0
			select  InmateID, PIN,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
			 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,   
			sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state
			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )   and
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and PIN <> '0' and PIN <> ''
								----and tblcallsbilled.FacilityID =  @DivisionID
								 
			group by State, InmateID,  PIN
			Order by State, InmateID,  PIN
		else ---CommRateAgent Not found
		If @DivisionID > 0
			select  InmateID, PIN,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
			 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
			sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

			from tblcallsbilled with(nolock), tblCommRate with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								 tblcallsbilled.FacilityID = tblCommrate.FacilityID and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )   and
								convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and PIN <> '0' and PIN <> ''
								and tblcallsbilled.FacilityID =  @DivisionID
								 
			group by State, InmateID,  PIN
			Order by State, InmateID,  PIN
			Else
			select  InmateID, PIN,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
			 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,   
			sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

			from tblcallsbilled with(nolock), tblCommRate with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								 tblcallsbilled.FacilityID = tblCommrate.FacilityID and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )   and
								convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and PIN <> '0' and PIN <> ''
								--and tblcallsbilled.FacilityID =  @DivisionID
								 
			group by State, InmateID,  PIN
			Order by State, InmateID,  PIN
		End
		
	Else --- 
	If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
	Begin 
	If(@PIN <> '')
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		If @DivisionID > 0
			select  InmateID, PIN,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
			 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, 0 as BadDebt,  
			(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, State
			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.agentID = @agentID and
								
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and PIN <> '0' and PIN <> ''
								and InmateID = @InmateID
								and tblcallsbilled.FacilityID =  @DivisionID
								
			group by State, InmateID,  PIN
			Order by State, InmateID,  PIN
			Else --Division = 0
			select  InmateID, PIN,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
			 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, 0 as BadDebt,
			   
			(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid
			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.agentID = @agentID and
								
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and PIN <> '0' and PIN <> ''
								and InmateID = @InmateID
								--and tblcallsbilled.FacilityID =  @DivisionID
								
			group by State, InmateID,  PIN
			Order by State, InmateID,  PIN
		else ---NoCommRateAgent
		 If @DivisionID > 0
			select  InmateID, PIN, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
			 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, 0 as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, State
			from tblcallsbilled with(nolock), tblCommRate with(nolock), tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								 tblcallsbilled.FacilityID =tblCommrate.FacilityID and
								tblcallsbilled.agentID = @agentID and
								 
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and PIN <> '0' and PIN <> ''
								and InmateID = @InmateID
								and tblcallsbilled.FacilityID =  @DivisionID 
								
			group by State, InmateID,  PIN
			Order by State, InmateID,  PIN
			else --
			select  InmateID, PIN, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
			 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, 0 as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, State
			from tblcallsbilled with(nolock), tblCommRate with(nolock), tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								 tblcallsbilled.FacilityID =tblCommrate.FacilityID and
								tblcallsbilled.agentID = @agentID and
								 
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and PIN <> '0' and PIN <> ''
								and InmateID = @InmateID
								--and tblcallsbilled.FacilityID =  @DivisionID 
								
			group by State, InmateID,  PIN
			Order by State, InmateID,  PIN
	Else ----PIN = 0
	
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		 If @DivisionID > 0
			select  InmateID, PIN,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
			 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, 0 as BadDebt, 
			(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, State

			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.agentID = @agentID and
								 
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and PIN <> '0' and PIN <> ''
								and tblcallsbilled.FacilityID =  @DivisionID 
								 
			group by State, InmateID,  PIN
			Order by State, InmateID,  PIN
		else ---Division = 0
			select  InmateID, PIN,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
			 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, 0 as BadDebt,  
			(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, State

			from tblcallsbilled with(nolock), tblCommRate with(nolock),   tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								 tblcallsbilled.FacilityID = tblCommrate.FacilityID and
								tblcallsbilled.agentID = @agentID and
								 
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
								convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and PIN <> '0' and PIN <> ''
								--and tblcallsbilled.FacilityID =  @DivisionID 
			group by State, InmateID,  PIN
			Order by State, InmateID,  PIN
	
 End 
	

else
If (@facilityID > 0)
 Begin
 If(@PIN <> '')
	
		select  InmateID, PIN, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
		 sum(CallRevenue) CallRevenue, 0  as Pif, 0  as BadDebt,  
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid

		from tblcallsbilled with(nolock), tblCommRate with(nolock)  where 
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )   and InmateID = @InmateID  and
							 convert (int,duration ) >5 
							 and PIN <> '0' and PIN <> ''
		group by  InmateID,  PIN
			Order by InmateID,  PIN
	
	Else
		select  InmateID, PIN,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
		 sum(CallRevenue) CallRevenue, 0 as Pif, 0 as BadDebt,   
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid

		from tblcallsbilled with(nolock), tblCommRate with(nolock)  where 
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							  convert (int,duration ) >5 
							  and PIN <> '0' and PIN <> ''
		group by  InmateID,  PIN
			Order by InmateID,  PIN
 End
