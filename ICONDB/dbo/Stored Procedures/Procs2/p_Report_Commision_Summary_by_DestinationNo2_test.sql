CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_DestinationNo2_test]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@ToNo	varchar(10),
@divisionID	int
AS

If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0
 Begin 
	If(@ToNo <> '')
	     If @divisionID > 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
			sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,  
			CAST (sum(CallRevenue *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,  
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state		
			from tblcallsbilled with(nolock), tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock)  where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.Billtype = tblBilltype.Billtype and
							 	tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.FacilityID =  @divisionID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and ToNo = @ToNo  and
								 CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by ToNo, Location, State 
			Order by ToNo, Location, State 
		else
			select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
			sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,  
			CAST (sum(CallRevenue *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,  
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state		

			from tblcallsbilled with(nolock), tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRate with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock)  where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								tblcallsbilled.FacilityID =  tblCommrate.FacilityID and
								tblcallsbilled.Billtype = tblBilltype.Billtype and
							 	tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.FacilityID =  @divisionID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and ToNo = @ToNo  and
								 CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by ToNo, Location, State 
			Order by ToNo, Location, State  
	    else
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
			sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,  
			CAST (sum(CallRevenue *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,  
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state
				  		
			from tblcallsbilled with(nolock), tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock)  where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.Billtype = tblBilltype.Billtype and
							 	tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and ToNo = @ToNo  and
								 CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by ToNo, Location, State 
			Order by ToNo, Location, State  
		else
			select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
			sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,  
			CAST (sum(CallRevenue *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,  
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state
				  		
			from tblcallsbilled with(nolock), tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRate with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock)  where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								tblcallsbilled.FacilityID =  tblCommrate.FacilityID and
								tblcallsbilled.Billtype = tblBilltype.Billtype and
							 	tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and ToNo = @ToNo  and
								 CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by ToNo, Location, State 
			Order by ToNo, Location, State 
	
	Else
	     If @divisionID > 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
			sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,  
			CAST (sum(CallRevenue *  isnull( Rate,0)) as numeric(12,4))  as BadDebt, 
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

			from tblcallsbilled with(nolock), tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent with(nolock) ,tblBadDebt with(nolock),  tblFacility with(nolock)  where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.Billtype = tblBilltype.Billtype and
							 	tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.FacilityID =  @divisionID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
								 CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by ToNo, Location, State 
			Order by ToNo, Location, State 
		else
			select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
			 sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,  
			CAST (sum(CallRevenue *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,  
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state
				  		
			from tblcallsbilled with(nolock), tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRate with(nolock) ,tblBadDebt with(nolock),  tblFacility with(nolock)  where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								 tblcallsbilled.FacilityID =  tblCommrate.FacilityID and
								tblcallsbilled.Billtype = tblBilltype.Billtype and
							 	tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.FacilityID =  @divisionID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
								 CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by ToNo, Location, State 
			Order by ToNo, Location, State
	     else
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
			 sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif, 
			CAST (sum(CallRevenue *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state
		
			from tblcallsbilled with(nolock), tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent with(nolock) ,tblBadDebt with(nolock),  tblFacility with(nolock)  where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.Billtype = tblBilltype.Billtype and
							 	tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
								 CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by ToNo, Location, State 
			Order by ToNo, Location, State
		else
			select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
			sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,  
			CAST (sum(CallRevenue *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state
				  	
			from tblcallsbilled with(nolock), tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRate with(nolock) ,tblBadDebt with(nolock),  tblFacility with(nolock)  where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								 tblcallsbilled.FacilityID =  tblCommrate.FacilityID and
								tblcallsbilled.Billtype = tblBilltype.Billtype and
							 	tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
						
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
								 CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by ToNo, Location, State 
			Order by ToNo, Location, State
 End 
Else
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) = 0
 Begin 
	If(@ToNo <> '')
	    If @divisionID > 0
		select ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, '0'  as BadDebt,  
		CAST ((sum(CallRevenue   * tblCommrateAgent.CommRate)) as Numeric(12,4))      as CommPaid, State
					
		from tblcallsbilled with(nolock), tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent with(nolock),  tblFacility with(nolock)  where 
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.Billtype = tblBilltype.Billtype and
						 	tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							tblcallsbilled.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and ToNo = @ToNo  and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by ToNo, Location, State 
			Order by ToNo, Location, State
	    else
		select ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif, '0'  as BadDebt,  
		CAST ((sum(CallRevenue   * tblCommrateAgent.CommRate)) as Numeric(12,4))      as CommPaid, State
					
		from tblcallsbilled with(nolock), tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent with(nolock),  tblFacility with(nolock)  where 
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.Billtype = tblBilltype.Billtype and
						 	tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and ToNo = @ToNo  and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by ToNo, Location, State 
			Order by ToNo, Location, State
	
	Else
	     If @divisionID > 0
		select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif, '0'  as BadDebt,  
		CAST ((sum(CallRevenue   * tblCommrateAgent.CommRate)) as Numeric(12,4))      as CommPaid, State
					
		from tblcallsbilled with(nolock), tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent with(nolock),  tblFacility with(nolock)   where 
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.Billtype = tblBilltype.Billtype and
						 	tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							tblcallsbilled.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by ToNo, Location, State 
			Order by ToNo, Location, State
	     else
		select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif, '0'  as BadDebt,    
		CAST ((sum(CallRevenue   * tblCommrateAgent.CommRate)) as Numeric(12,4))      as CommPaid, State
					
		from tblcallsbilled with(nolock), tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent with(nolock),  tblFacility with(nolock)   where 
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.Billtype = tblBilltype.Billtype and
						 	tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by ToNo, Location, State 
			Order by ToNo, Location, State
 End 
Else
 Begin
 If(@ToNo <> '')
	
		select  ToNo, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, 0  as Pif, 0  as BadDebt,   
		CAST ((sum(CallRevenue   * tblCommrate.CommRate)) as Numeric(12,4))      as CommPaid
					
		from tblcallsbilled with(nolock), tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRate  where 
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							tblcallsbilled.facilityID	= @facilityID  And
							tblcallsbilled.Billtype = tblBilltype.Billtype and
						 	tblcallsbilled.Calltype = tblCalltype.Abrev and
							--tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )   and ToNo = @ToNo  and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
		group by ToNo 
			Order by ToNo
	
	Else
		select  ToNo,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, 0 as Pif,	0 as BadDebt,  
		CAST ((sum(CallRevenue   * tblCommrate.CommRate)) as Numeric(12,4))      as CommPaid
					
		from tblcallsbilled with(nolock), tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRate  where 
		
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							tblcallsbilled.facilityID	= @facilityID  And
							tblcallsbilled.Billtype = tblBilltype.Billtype and
						 	tblcallsbilled.Calltype = tblCalltype.Abrev and
							--tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
		group by ToNo
		Order by ToNo
 End
