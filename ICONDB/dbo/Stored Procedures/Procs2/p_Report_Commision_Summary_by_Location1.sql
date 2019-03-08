CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_Location1]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@LocationID	int
AS

If (@AgentId >1 AND @facilityID =0 )

 Begin

	If(@LocationID >0)
	
		select  tblFacilityLocation.Descript as Location, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(12,4)))/60 as Numeric(12,4)) as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,Rate,  
		CAST ((sum(CAST(CallRevenue as numeric(9,4))) * Rate) as numeric(12,4))  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * Rate )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
				      Else   CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum(CAST(CallRevenue as numeric(9,4))) * Rate  - sum(Pif) - Sum(NIF) )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum( CAST(Pif as numeric(6,4)))    end) as CommPaid
		from tblcallsbilled with(nolock), tblcommrateAgent with(nolock),  tblFacilityLocation  with(nolock) , tblANIs  with(nolock) , tblBadDebt with(nolock) where 
							tblcallsbilled.FacilityID = tblANIs.FacilityID and 
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  tblFacilityLocation.LocationID	= 	tblANIs.LocationID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
							tblcallsbilled.agentID = @agentID and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblFacilityLocation.LocationID= @LocationID
							and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacilityLocation.Descript, tblcallsbilled.calldate,tblcommrateAgent.CommRate,Rate, PifPaid 
		Order by  tblFacilityLocation.Descript, tblcallsbilled.calldate,tblcommrateAgent.CommRate,Rate,PifPaid 
	
	
	Else
		
		select  tblFacilityLocation.Descript as Location, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(12,4)))/60 as Numeric(12,4)) as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,Rate,  
		CAST ((sum(CAST(CallRevenue as numeric(9,4))) * Rate) as numeric(12,4))  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * Rate )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
				      Else   CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( cast(CallRevenue as numeric(9,4))) * Rate  - sum(Pif) -sum(NIF))   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(CAST(Pif as numeric(6,4)))  end) as CommPaid
		from tblcallsbilled with(nolock), tblcommrateAgent with(nolock),  tblFacilityLocation  with(nolock) , tblANIs  with(nolock) , tblBadDebt with(nolock) where 
							tblcallsbilled.FacilityID = tblANIs.FacilityID and 
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  tblFacilityLocation.LocationID	= 	tblANIs.LocationID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
							tblcallsbilled.agentID = @agentID and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
							and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacilityLocation.Descript, tblcallsbilled.calldate,tblcommrateAgent.CommRate,Rate, PifPaid 
		Order by  tblFacilityLocation.Descript, tblcallsbilled.calldate,tblcommrateAgent.CommRate,Rate,PifPaid 
 end
else
   Begin

	If(@LocationID >0)
	
		select  tblFacilityLocation.Descript as Location, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif,0 BadDebtRate,  
		0  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblcommrate with(nolock),  tblFacilityLocation  with(nolock) , tblANIs  with(nolock) where 
							
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  tblFacilityLocation.LocationID	= 	tblANIs.LocationID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblFacilityLocation.LocationID= @LocationID
							and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
		group by  tblFacilityLocation.Descript, tblcallsbilled.calldate,tblcommrate.CommRate,BadDebtRate, PifPaid 
		Order by  tblFacilityLocation.Descript, tblcallsbilled.calldate,tblcommrate.CommRate,BadDebtRate,PifPaid 
	
	
	Else
		
		select  tblFacilityLocation.Descript as Location, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif, 0 BadDebtRate,  
		0 as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblcommrate with(nolock),  tblFacilityLocation  with(nolock) , tblANIs  with(nolock) where 
							
							
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  tblFacilityLocation.LocationID	= 	tblANIs.LocationID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							  CAST (ResponseCode as int) < 100   and convert (int,duration ) >15 
		group by  tblFacilityLocation.Descript, tblcallsbilled.calldate,tblcommrate.CommRate,BadDebtRate, PifPaid 
		Order by  tblFacilityLocation.Descript, tblcallsbilled.calldate,tblcommrate.CommRate,BadDebtRate,PifPaid
 end
