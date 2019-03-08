CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_Calltype4]

@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@Calltype	varchar(2),
@divisionID	int
AS
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0
 Begin
	If(@Calltype <>'')
	    If @divisionID > 0   --- facility ID 
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0    --- have Agent comm
			select Location, tblcalltype.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,  
			CAST ((sum(CallRevenue) * Rate) as numeric(12,4))  as BadDebt, ( tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   *  tblCommrateAgent.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif) - Sum(NIF) )   *  tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblCommrateAgent with(nolock) ,  tblBadDebt with(nolock)  ,tblFacility with(nolock) where 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.FacilityID =  @divisionID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsbilled.Calltype = @Calltype  and
								  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by  Location, tblCalltype.Descript,  tblCommrateAgent.CommRate,Rate,PifPaid 
			Order by Location, tblCalltype.Descript, tblCommrateAgent.CommRate,Rate,PifPaid 
		else
			select Location, tblcalltype.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,  
			CAST ((sum(CallRevenue) * Rate) as numeric(12,4))  as BadDebt, ( tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   *  tblCommrate.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif) - Sum(NIF) )   *  tblCommrate.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblCommrate with(nolock) ,  tblBadDebt with(nolock)  ,tblFacility with(nolock) where 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype =  tblCommrate.Calltype and
								  tblcallsbilled.FacilityID = tblCommrate.FacilityID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.FacilityID =  @divisionID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsbilled.Calltype = @Calltype  and
								  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by  Location, tblCalltype.Descript,  tblCommrate.CommRate,Rate,PifPaid 
			Order by Location, tblCalltype.Descript, tblCommrate.CommRate,Rate,PifPaid 
			
	    else  -- all facility
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select Location, tblcalltype.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,  
			CAST ((sum(CallRevenue) * Rate) as numeric(12,4))  as BadDebt, ( tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   *  tblCommrateAgent.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif) - Sum(NIF) )   *  tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblCommrateAgent with(nolock) ,  tblBadDebt with(nolock)  ,tblFacility with(nolock) where 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsbilled.Calltype = @Calltype  and
								  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by  Location, tblCalltype.Descript,  tblCommrateAgent.CommRate,Rate,PifPaid 
			Order by Location, tblCalltype.Descript, tblCommrateAgent.CommRate,Rate,PifPaid 
		else
			select Location, tblcalltype.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,  
			CAST ((sum(CallRevenue) * Rate) as numeric(12,4))  as BadDebt, ( tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   *  tblCommrate.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif) - Sum(NIF) )   *  tblCommrate.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblCommrate with(nolock) ,  tblBadDebt with(nolock)  ,tblFacility with(nolock) where 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype =  tblCommrate.Calltype and
								  tblcallsbilled.FacilityID = tblCommrate.FacilityID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsbilled.Calltype = @Calltype  and
								  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by  Location, tblCalltype.Descript,  tblCommrate.CommRate,Rate,PifPaid 
			Order by Location, tblCalltype.Descript, tblCommrate.CommRate,Rate,PifPaid 
	
	Else
	     If @divisionID > 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select Location, tblcalltype.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,  
			CAST ((sum(CallRevenue) * Rate) as numeric(12,4))  as BadDebt, ( tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   *  tblCommrateAgent.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif)  -Sum(NIF))   *  tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,tblFacility with(nolock) where 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.FacilityID =  @divisionID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
								  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by  Location, tblCalltype.Descript, tblCommrateAgent.CommRate,Rate,PifPaid 
			Order by  Location, tblCalltype.Descript, tblCommrateAgent.CommRate,Rate,PifPaid 
		else
			select Location, tblcalltype.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,  
			CAST ((sum(CallRevenue) * Rate) as numeric(12,4))  as BadDebt, ( tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   *  tblCommrate.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif)  -Sum(NIF))   *  tblCommrate.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblCommrate with(nolock), tblBadDebt with(nolock) ,tblFacility with(nolock) where 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype =  tblCommrate.Calltype and
								  tblcallsbilled.FacilityID =   tblCommrate.FacilityID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.FacilityID =  @divisionID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
								  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by  Location, tblCalltype.Descript, tblCommrate.CommRate,Rate,PifPaid 
			Order by  Location, tblCalltype.Descript, tblCommrate.CommRate,Rate,PifPaid 
	     else
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select Location, tblcalltype.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,  
			CAST ((sum(CallRevenue) * Rate) as numeric(12,4))  as BadDebt, ( tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   *  tblCommrateAgent.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif)  -Sum(NIF))   *  tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,tblFacility with(nolock) where 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
								  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by  Location, tblCalltype.Descript, tblCommrateAgent.CommRate,Rate,PifPaid 
			Order by  Location, tblCalltype.Descript, tblCommrateAgent.CommRate,Rate,PifPaid 
		else
			select Location, tblcalltype.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,  
			CAST ((sum(CallRevenue) * Rate) as numeric(12,4))  as BadDebt, ( tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   *  tblCommrate.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif)  -Sum(NIF))   *  tblCommrate.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblCommrate  with(nolock), tblBadDebt with(nolock) ,tblFacility with(nolock) where 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype =  tblCommrate.Calltype and
								 tblcallsbilled.FacilityID = tblCommrate.FacilityID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
								  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by  Location, tblCalltype.Descript, tblCommrate.CommRate,Rate,PifPaid 
			Order by  Location, tblCalltype.Descript, tblCommrate.CommRate,Rate,PifPaid 

 End
Else

If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) = 0
 Begin
	If(@Calltype <>'')
	    If @divisionID > 0
		select Location, tblcalltype.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,  
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
		from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblCommrateAgent with(nolock), tblfacility  where 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @AgentID and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
							tblcallsbilled.facilityId = tblfacility.facilityID and
							tblcallsbilled.facilityId = @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsbilled.Calltype = @CallType  and
							  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  Location, tblCalltype.Descript, tblCommrateAgent.CommRate,BadDebtRate,PifPaid 
		Order by  Location, tblCalltype.Descript, tblCommrateAgent.CommRate,BadDebtRate,PifPaid

	    else	
		select Location, tblcalltype.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,  
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
		from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblCommrateAgent with(nolock), tblfacility  where 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @AgentID and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
							tblcallsbilled.facilityId = tblfacility.facilityID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsbilled.Calltype = @CallType  and
							  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  Location, tblCalltype.Descript, tblCommrateAgent.CommRate,BadDebtRate,PifPaid 
		Order by  Location, tblCalltype.Descript, tblCommrateAgent.CommRate,BadDebtRate,PifPaid

	
	Else
	     If @divisionID > 0
		select Location, tblcalltype.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,  
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
		from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblCommrateAgent with(nolock), tblfacility  where 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @AgentID and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
							tblcallsbilled.facilityId = tblfacility.facilityID and
							tblcallsbilled.facilityId = @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
							  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  Location, tblCalltype.Descript,  tblCommrateAgent.CommRate,BadDebtRate,PifPaid 
		Order by  Location, tblCalltype.Descript, tblCommrateAgent.CommRate,BadDebtRate,PifPaid
	     else
		select Location, tblcalltype.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,  
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
		from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblCommrateAgent with(nolock), tblfacility  where 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @AgentID and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
							tblcallsbilled.facilityId = tblfacility.facilityID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
							  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  Location, tblCalltype.Descript,  tblCommrateAgent.CommRate,BadDebtRate,PifPaid 
		Order by  Location, tblCalltype.Descript, tblCommrateAgent.CommRate,BadDebtRate,PifPaid
end
Else
If ( @facilityID > 0 )
 Begin
	If(@Calltype <>'')
	
		select tblcalltype.Descript as Calltype,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif,0 BadDebtRate,  
		0 as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		--(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0) )   * tblCommrate.CommRate)  as numeric(7,2) )  
			--	      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0)  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblcommrate with(nolock) where 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.facilityID	= @facilityID  And
							 tblcallsBilled.errorcode = '0' and 
							--tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							   tblcallsbilled.Calltype = @Calltype  and
							  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
		group by  tblCalltype.Descript, tblcommrate.CommRate,BadDebtRate,PifPaid 
		Order by  tblCalltype.Descript,tblcommrate.CommRate,BadDebtRate,PifPaid 
	
	Else
		select tblcalltype.Descript as Calltype,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif , 0 BadDebtRate,  
		0  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		--(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0) )   * tblCommrate.CommRate)  as numeric(7,2) )  
			--	      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0)  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblcommrate with(nolock) where 
							tblcallsbilled.Calltype =  tblCalltype.Abrev and
							tblcallsbilled.facilityID	= @facilityID  And
							 tblcallsBilled.errorcode = '0' and 
							--tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
		group by  tblCalltype.Descript, tblcommrate.CommRate,BadDebtRate,PifPaid 
		Order by  tblCalltype.Descript,tblcommrate.CommRate,BadDebtRate,PifPaid
 End
