CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_PrepaidAcct_Orig]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@AccountNo	varchar(10)
AS
If(@AgentID >1 AND @facilityID =0 )
 Begin
	If(@AccountNo <> '')
	
		select  tblPrepaid.PhoneNo as AccountNo,tblcallsbilled.calldate,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,BadDebtRate,  
		CAST ((sum(CallRevenue) * BadDebtRate) as numeric(7,2))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrateAgent.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrateAgent.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblPrepaid with(nolock)  where  
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and
							  
							tblcallsbilled.agentID = @agentID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblPrepaid.PhoneNo = @AccountNo and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblPrepaid.PhoneNo, tblcallsbilled.calldate,tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
		Order by  tblPrepaid.PhoneNo, tblcallsbilled.calldate,tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
	
	Else
		
		select tblPrepaid.PhoneNo as AccountNo,tblcallsbilled.calldate,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(12,2)))/60 as Numeric(12,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,BadDebtRate,  
		CAST ((sum(CallRevenue) * BadDebtRate) as numeric(7,2))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrateAgent.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrateAgent.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblPrepaid with(nolock)  where  
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and 
							 
							tblcallsbilled.agentID = @agentID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblPrepaid.PhoneNo, tblcallsbilled.calldate,tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
		Order by  tblPrepaid.PhoneNo, tblcallsbilled.calldate,tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
 End
Else
 Begin
	If(@AccountNo <> '')
	
		select tblPrepaid.PhoneNo as AccountNo,tblcallsbilled.calldate,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(12,2)))/60 as Numeric(12,2)) as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif,0 BadDebtRate,  
		0 as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock), tblPrepaid with(nolock)  where  
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and 
							
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblPrepaid.PhoneNo = @AccountNo  and convert (int,duration ) >15 
		group by  tblPrepaid.PhoneNo, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid  
		Order by  tblPrepaid.PhoneNo, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid  
	
	Else
		
		select tblPrepaid.PhoneNo as AccountNo,tblcallsbilled.calldate,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(12,2)))/60 as Numeric(12,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,BadDebtRate,  
		CAST ((sum(CallRevenue) * BadDebtRate) as numeric(7,2))  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock), tblPrepaid with(nolock)  where  
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and
							  
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
		group by  tblPrepaid.PhoneNo, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid  
		Order by  tblPrepaid.PhoneNo, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid  
 End
