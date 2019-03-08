CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_DestinationNo1]
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
			select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,Rate,  
			CAST ((sum(CAST(CallRevenue as numeric(9,4))) *  isnull(Rate,0)) as numeric(12,5))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,5) )  
					      Else   CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif)  -sum(NIF) )   *tblCommrateAgent.CommRate)  as numeric(12,5) )  + sum(CAST(Pif as numeric(6,4)))    end) as CommPaid
						
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
			group by ToNo, Location, tblCommrateAgent.CommRate,Rate, PifPaid 
			Order by ToNo, Location,tblCommrateAgent.CommRate,Rate, PifPaid  
		else
			select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,Rate,  
			CAST ((sum(CAST(CallRevenue as numeric(9,4))) *  isnull(Rate,0)) as numeric(12,5))  as BadDebt, (tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0) )   * tblCommrate.CommRate)  as numeric(12,5) )  
					      Else   CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif)  -sum(NIF) )   *tblCommrate.CommRate)  as numeric(12,5) )  + sum(CAST(Pif as numeric(6,4)))    end) as CommPaid
						
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
			group by ToNo, Location, tblCommrate.CommRate,Rate, PifPaid 
			Order by ToNo, Location,tblCommrate.CommRate,Rate, PifPaid  
	    else
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,Rate,  
			CAST ((sum(CAST(CallRevenue as numeric(9,4))) *  isnull(Rate,0)) as numeric(12,5))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,5) )  
					      Else   CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif)  -sum(NIF) )   *tblCommrateAgent.CommRate)  as numeric(12,5) )  + sum(CAST(Pif as numeric(6,4)))    end) as CommPaid
						
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
			group by ToNo, Location, tblCommrateAgent.CommRate,Rate, PifPaid 
			Order by ToNo, Location,tblCommrateAgent.CommRate,Rate, PifPaid  
		else
			select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,Rate,  
			CAST ((sum(CAST(CallRevenue as numeric(9,4))) *  isnull(Rate,0)) as numeric(12,5))  as BadDebt, (tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0) )   * tblCommrate.CommRate)  as numeric(12,5) )  
					      Else   CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif)  -sum(NIF) )   *tblCommrate.CommRate)  as numeric(12,5) )  + sum(CAST(Pif as numeric(6,4)))    end) as CommPaid
						
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
			group by ToNo, Location, tblCommrate.CommRate,Rate, PifPaid 
			Order by ToNo, Location,tblCommrate.CommRate,Rate, PifPaid  
	
	Else
	     If @divisionID > 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,Rate,  
			CAST ((sum(CAST(CallRevenue as Numeric(9,4))) *  isnull( Rate,0)) as numeric(12,5))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum(CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,5) )  
					      Else   CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif) - Sum(NIF) )   *tblCommrateAgent.CommRate)  as numeric(12,5) )  + sum(CAST(Pif as numeric(6,4)))    end) as CommPaid
						
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
			group by ToNo, Location, tblCommrateAgent.CommRate,Rate, PifPaid 
			Order by ToNo, Location, tblCommrateAgent.CommRate,Rate, PifPaid
		else
			select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,Rate,  
			CAST ((sum(CAST(CallRevenue as Numeric(9,4))) *  isnull( Rate,0)) as numeric(12,5))  as BadDebt, (tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum(CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0) )   * tblCommrate.CommRate)  as numeric(12,5) )  
					      Else   CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif) - Sum(NIF) )   *tblCommrate.CommRate)  as numeric(12,5) )  + sum(CAST(Pif as numeric(6,4)))    end) as CommPaid
						
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
			group by ToNo, Location, tblCommrate.CommRate,Rate, PifPaid 
			Order by ToNo, Location, tblCommrate.CommRate,Rate, PifPaid
	     else
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,Rate,  
			CAST ((sum(CAST(CallRevenue as Numeric(9,4))) *  isnull( Rate,0)) as numeric(12,5))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum(CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,5) )  
					      Else   CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif) - Sum(NIF) )   *tblCommrateAgent.CommRate)  as numeric(12,5) )  + sum(CAST(Pif as numeric(6,4)))    end) as CommPaid
						
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
			group by ToNo, Location, tblCommrateAgent.CommRate,Rate, PifPaid 
			Order by ToNo, Location, tblCommrateAgent.CommRate,Rate, PifPaid
		else
			select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,Rate,  
			CAST ((sum(CAST(CallRevenue as Numeric(9,4))) *  isnull( Rate,0)) as numeric(12,5))  as BadDebt, (tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum(CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0) )   * tblCommrate.CommRate)  as numeric(12,5) )  
					      Else   CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif) - Sum(NIF) )   *tblCommrate.CommRate)  as numeric(12,5) )  + sum(CAST(Pif as numeric(6,4)))    end) as CommPaid
						
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
			group by ToNo, Location, tblCommrate.CommRate,Rate, PifPaid 
			Order by ToNo, Location, tblCommrate.CommRate,Rate, PifPaid
 End 
Else
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) = 0
 Begin 
	If(@ToNo <> '')
	    If @divisionID > 0
		select ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
					
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
		group by ToNo, Location, tblCommrateAgent.CommRate,BadDebtRate, PifPaid 
		Order by ToNo, Location, tblCommrateAgent.CommRate,BadDebtRate, PifPaid
	    else
		select ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
					
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
		group by ToNo, Location, tblCommrateAgent.CommRate,BadDebtRate, PifPaid 
		Order by ToNo, Location, tblCommrateAgent.CommRate,BadDebtRate, PifPaid
	
	Else
	     If @divisionID > 0
		select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
					
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
		group by ToNo, Location, tblCommrateAgent.CommRate,BadDebtRate, PifPaid
		Order by ToNo, Location, tblCommrateAgent.CommRate,BadDebtRate, PifPaid
	     else
		select  ToNo, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
					
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
		group by ToNo, Location, tblCommrateAgent.CommRate,BadDebtRate, PifPaid
		Order by ToNo, Location, tblCommrateAgent.CommRate,BadDebtRate, PifPaid
 End 
Else
 Begin
 If(@ToNo <> '')
	
		select  ToNo, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, 0  as Pif,0 BadDebtRate,  
		0  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
					
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
		group by ToNo, tblCommrate.CommRate,BadDebtRate, PifPaid 
		Order by ToNo,tblCommrate.CommRate,BadDebtRate, PifPaid
	
	Else
		select toNo
		,sum(CallCount) as CallCount
		, sum(CallDuration)  as CallDuration
		, sum(CallRevenue) CallRevenue
		, (CommRate) as CommRate 
		,  sum(commPaid)      as CommPaid
		,  sum(BadDebt)      as BadDebt
		from
		(select  ToNo,  1 CallCount, (dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, (CallRevenue) CallRevenue, 0 as Pif, 0 BadDebtRate,  
			0 as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
			CAST (((CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
					
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
						   convert (int,duration ) >5  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0))
		
							   as X
	
						    
		group by X.toNo,X.CommRate
		Order by X.toNo,X.CommRate
	
		--select  ToNo,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif, 0 BadDebtRate,  
		--0 as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		--CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
					
		--from tblcallsbilled with(nolock), tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRate  where 
		
		--					tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
		--					 tblcallsBilled.errorcode = '0' and 
		--					tblcallsbilled.Billtype =  tblCommrate.billtype and
		--					 tblcallsbilled.Calltype = tblCommrate.Calltype and
		--					tblcallsbilled.facilityID	= @facilityID  And
		--					tblcallsbilled.Billtype = tblBilltype.Billtype and
		--				 	tblcallsbilled.Calltype = tblCalltype.Abrev and
		--					--tblcallsbilled.agentID = @agentID and
		--					(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
		--					 CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
		--group by ToNo, tblCommrate.CommRate,BadDebtRate, PifPaid 
		--Order by ToNo,tblCommrate.CommRate,BadDebtRate, PifPaid
 End
