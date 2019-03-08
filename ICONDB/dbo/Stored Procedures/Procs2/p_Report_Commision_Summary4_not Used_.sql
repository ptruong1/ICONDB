CREATE PROCEDURE [dbo].[p_Report_Commision_Summary4(not Used)]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime
AS


If( @AgentID >1  and @facilityID =0 ) 
 Begin
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) > 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select Calldate, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as Numeric(9,4))) CallRevenue, Sum(Pif) as Pif, isnull(Rate,0) BadDebtRate ,  
				CAST ((sum(CAST(CallRevenue as Numeric(9,4))) * isnull(Rate,0)) as numeric(12,4))  as BadDebt,  (tblCommRateAgent.CommRate * 100) as CommRate ,  
				(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommRateAgent.CommRate)  as numeric(12,4) )  
						      Else   CAST (((sum(CAST(CallRevenue as Numeric(9,4))) - sum(CAST(CallRevenue as Numeric(9,4))) * isnull(Rate,0)  - sum(Pif)   -  sum(isnull(Nif,0)))   * tblCommRateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock),  tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent with(nolock),  tblBadDebt with(nolock),  tblFacility with(nolock)  where 
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.Billtype =  tblCommRateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommRateAgent.Calltype and
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								 tblcallsbilled.FacilityID =  tblBadDebt.FacilityID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
								  convert (int,duration ) >15  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by tblcallsbilled.calldate, Location, tblCommRateAgent.CommRate,Rate, PifPaid 
			Order by tblcallsbilled.calldate, Location, tblCommRateAgent.CommRate,Rate ,PifPaid
		else
			select Calldate, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as Numeric(9,4))) CallRevenue, Sum(Pif) as Pif, isnull(Rate,0) BadDebtRate ,  
				CAST ((sum(CAST(CallRevenue as Numeric(9,4))) * isnull(Rate,0)) as numeric(12,4))  as BadDebt,  (tblCommRate.CommRate * 100) as CommRate ,  
				(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommRate.CommRate)  as numeric(12,4) )  
						      Else   CAST (((sum(CAST(CallRevenue as Numeric(9,4))) - sum(CAST(CallRevenue as Numeric(9,4))) * isnull(Rate,0)  - sum(Pif)   -  sum(isnull(Nif,0)))   * tblCommRate.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock),  tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRate  with(nolock),  tblBadDebt with(nolock),  tblFacility with(nolock)  where 
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.Billtype =  tblCommRate.billtype and
								 tblcallsbilled.Calltype = tblCommRate.Calltype and
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								tblcallsbilled.facilityID = tblCommrate.facilityID AND
								 tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								 tblcallsbilled.FacilityID =  tblBadDebt.FacilityID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
								   convert (int,duration ) >15  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by tblcallsbilled.calldate, Location, tblCommRate.CommRate,Rate, PifPaid 
			Order by tblcallsbilled.calldate, Location, tblCommRate.CommRate,Rate ,PifPaid
	else
	if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		select Calldate, Location,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif, 0 BadDebtRate ,  
			0 as BadDebt,  (tblCommRateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CAST(CallRevenue as Numeric(9,4))) )   * tblCommRateAgent.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CAST(CallRevenue as Numeric(9,4))) - sum(Pif)   -  sum(isnull(Nif,0)))   * tblCommRateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock),  tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent with(nolock),  tblFacility with(nolock)  where 
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.Billtype =  tblCommRateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommRateAgent.Calltype and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by tblcallsbilled.calldate, Location,tblCommRateAgent.CommRate, PifPaid 
		Order by tblcallsbilled.calldate, Location, tblCommRateAgent.CommRate,PifPaid
	else ---
	select Calldate, Location, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as Numeric(9,4))) CallRevenue, Sum(Pif) as Pif, isnull(Rate,0) BadDebtRate ,  
				CAST ((sum(CAST(CallRevenue as Numeric(9,4))) * isnull(Rate,0)) as numeric(12,4))  as BadDebt,  (tblCommRate.CommRate * 100) as CommRate ,  
				(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommRate.CommRate)  as numeric(12,4) )  
						      Else   CAST (((sum(CAST(CallRevenue as Numeric(9,4))) - sum(CAST(CallRevenue as Numeric(9,4))) * isnull(Rate,0)  - sum(Pif)   -  sum(isnull(Nif,0)))   * tblCommRate.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock),  tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRate  with(nolock),  tblBadDebt with(nolock),  tblFacility with(nolock)  where 
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.Billtype =  tblCommRate.billtype and
								 tblcallsbilled.Calltype = tblCommRate.Calltype and
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								tblcallsbilled.facilityID = tblCommrate.facilityID AND
								 
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
								   convert (int,duration ) >15  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by tblcallsbilled.calldate, Location, tblCommRate.CommRate,Rate, PifPaid 
			Order by tblcallsbilled.calldate, Location, tblCommRate.CommRate,Rate ,PifPaid
 End 

Else
	
 Begin


	select callDate, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue,  
		0  Pif , 0  BadDebtRate ,0   BadDebt ,  (tblCommrate.CommRate * 100) as CommRate ,  CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
	from tblcallsbilled with(nolock),  tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRate where 
						tblcallsbilled.Billtype = tblBilltype.Billtype and
						 tblcallsBilled.errorcode = '0' and
						tblcallsbilled.Calltype = tblCalltype.Abrev and
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						tblcallsbilled.facilityID	= @facilityID  And
						--tblcallsbilled.agentID = @agentID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
						   convert (int,duration ) >5  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
	group by tblcallsbilled.callDate,tblCommrate.CommRate
	Order by tblcallsbilled.callDate,tblCommrate.CommRate

 end
