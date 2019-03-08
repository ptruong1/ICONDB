CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_FromNo1]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@fromNo	varchar(10)
AS

If(@AgentID	>1  AND @facilityID =0 )
 Begin 
	If(@fromNo <> '')
	
		select  FromNo, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(12,4)))/60 as Numeric(12,4)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, Rate,  
		CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF)  )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblBadDebt with(nolock)  where 
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.agentID = @agentID and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and FromNo = @fromNo  and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by tblcallsbilled.calldate,FromNo,tblCommrateAgent.CommRate,Rate, PifPaid 
		Order by tblcallsbilled.calldate,FromNo,tblCommrateAgent.CommRate,Rate ,PifPaid
	
	Else
		
		select  FromNo, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(12,4)))/60 as Numeric(12,4)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,  
		CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF) )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock) , tblBadDebt with(nolock) where 
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.agentID = @agentID and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by tblcallsbilled.calldate,FromNo,tblCommrateAgent.CommRate,Rate, PifPaid 
		Order by tblcallsbilled.calldate,FromNo,tblCommrateAgent.CommRate,Rate ,PifPaid
 End 
Else
 Begin
 If(@fromNo <> '')
	
		select  FromNo, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, 0  as Pif,0 BadDebtRate,  
		0  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock)  where 
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )   and FromNo = @fromNo  and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
		group by tblcallsbilled.calldate,FromNo,tblCommrate.CommRate,BadDebtRate, PifPaid 
		Order by tblcallsbilled.calldate,FromNo,tblCommrate.CommRate,BadDebtRate ,PifPaid
	
	Else
		select  FromNo, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif, 0 BadDebtRate,  
		0 as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock)  where 
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
		group by tblcallsbilled.calldate,FromNo,tblCommrate.CommRate,BadDebtRate, PifPaid 
		Order by tblcallsbilled.calldate,FromNo,tblCommrate.CommRate,BadDebtRate ,PifPaid
 End
