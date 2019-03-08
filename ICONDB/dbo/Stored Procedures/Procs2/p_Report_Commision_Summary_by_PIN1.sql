CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_PIN1]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@PIN	varchar(12)
AS
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0
 Begin
	If(@PIN <> '')
	
		select  tblInmate.PIN as PIN,tblcallsbilled.calldate,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(12,4)))/60 as Numeric(12,4)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,  
		CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,	 (tblCommrateAgent.CommRate * 100) as CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
			Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0)  - sum(Pif) )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblInmate with(nolock), tblBadDebt with(nolock)  where 
							tblcallsbilled.FacilityID=  tblInmate.FacilityID and   
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblcallsbilled.PIN = tblInmate.PIN and
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblcallsbilled.PIN	= @PIN and convert (int,duration ) >15  
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblInmate.PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,Rate, PifPaid  
		Order by  tblInmate.PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,Rate, PifPaid  
	
	Else
		
		select  tblInmate.PIN as PIN,tblcallsbilled.calldate,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(12,4)))/60 as Numeric(12,4)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,  
		CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,	 (tblCommrateAgent.CommRate * 100) as CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
			Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0)  - sum(Pif) )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblInmate with(nolock), tblBadDebt with(nolock)  where 
							tblcallsbilled.FacilityID=  tblInmate.FacilityID and   
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblcallsbilled.PIN = tblInmate.PIN and
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblInmate.PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,Rate, PifPaid  
		Order by  tblInmate.PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,Rate, PifPaid  

 End
Else
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) = 0
 Begin
	If(@PIN <> '')
	
		select  tblInmate.PIN as PIN,tblcallsbilled.calldate,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(12,4)))/60 as Numeric(12,4)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblInmate with(nolock)  where 
							tblcallsbilled.FacilityID=  tblInmate.FacilityID and   
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblcallsbilled.PIN = tblInmate.PIN and
							tblcallsbilled.agentID = @agentID and
							
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblcallsbilled.PIN	= @PIN and convert (int,duration ) >15  
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblInmate.PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
		Order by  tblInmate.PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
	
	Else
		
		select  tblInmate.PIN as PIN,tblcallsbilled.calldate,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(12,4)))/60 as Numeric(12,4)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblInmate with(nolock)  where 
							tblcallsbilled.FacilityID=  tblInmate.FacilityID and   
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblcallsbilled.PIN = tblInmate.PIN and
							tblcallsbilled.agentID = @agentID and
							
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblInmate.PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,BadDebtRate, PifPaid    
		Order by  tblInmate.PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,BadDebtRate, PifPaid   

 End
Else
 Begin
	If(@PIN <> '')
	
		--select  tblInmate.PIN as PIN,tblcallsbilled.calldate,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,BadDebtRate,  
		--CAST ((sum(CallRevenue) * BadDebtRate) as numeric(7,2))  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		--(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
			--	      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		select  tblInmate.PIN as PIN, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, 0  as Pif,0 BadDebtRate,  
		0  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock), tblInmate with(nolock)  where 
							tblcallsbilled.FacilityID=  tblInmate.FacilityID and   
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblcallsbilled.PIN = tblInmate.PIN and
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblcallsbilled.PIN	= @PIN and convert (int,duration ) >15 
		group by  tblInmate.PIN, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid  
		Order by  tblInmate.PIN, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid  
	
	Else
		
		--select  tblInmate.PIN as PIN,tblcallsbilled.calldate,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,BadDebtRate,  
		--CAST ((sum(CallRevenue) * BadDebtRate) as numeric(7,2))  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		--(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
			--	      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		select  tblInmate.PIN as PIN, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(12,2)))/60 as Numeric(12,2)) as CallDuration, sum(CallRevenue) CallRevenue, 0  as Pif,0 BadDebtRate,  
		0  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock), tblInmate with(nolock)  where 
							tblcallsbilled.FacilityID=  tblInmate.FacilityID and  
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblcallsbilled.PIN = tblInmate.PIN and
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
		group by tblInmate.PIN, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid  
		Order by  tblInmate.PIN, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid
 End
