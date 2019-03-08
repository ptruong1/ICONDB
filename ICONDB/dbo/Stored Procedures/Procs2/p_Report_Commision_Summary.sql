

CREATE PROCEDURE [dbo].[p_Report_Commision_Summary] 
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime
AS

If( @AgentID >1  and @facilityID =0 ) 
 Begin
	select Calldate, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, isnull(BadDebtRate,0) BadDebtRate ,  
		CAST ((sum(CallRevenue) * isnull(BadDebtRate,0)) as numeric(7,2))  as BadDebt,  (tblCommRateAgent.CommRate * 100) as CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( BadDebtRate,0) )   * tblCommRateAgent.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull(BadDebtRate,0)  - sum(Pif) )   * tblCommRateAgent.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
	from tblcallsbilled with(nolock),  tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent  where 
						tblcallsbilled.Billtype = tblBilltype.Billtype and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.Calltype = tblCalltype.Abrev and
						tblcallsbilled.Billtype =  tblCommRateAgent.billtype and
						 tblcallsbilled.Calltype = tblCommRateAgent.Calltype and
						tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
						tblcallsbilled.agentID = @agentID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
						  CAST (ResponseCode as int) < 100   and convert (int,duration ) >15  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
	group by tblcallsbilled.calldate, tblbilltype.Descript, tblCallType.Descript,tblCommRateAgent.CommRate,BadDebtRate, PifPaid 
	Order by tblcallsbilled.calldate, tblbilltype.Descript, tblCallType.Descript,tblCommRateAgent.CommRate,BadDebtRate ,PifPaid

 End 

Else

 Begin


	select Calldate, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue,  
		0  Pif , 0  BadDebtRate ,0   BadDebt ,   tblCommrate.CommRate ,  CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
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
						  CAST (ResponseCode as int) < 100   and convert (int,duration ) >15  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
	group by tblcallsbilled.calldate, tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate,BadDebtRate, PifPaid 
	Order by tblcallsbilled.calldate, tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate,BadDebtRate ,PifPaid

 end

