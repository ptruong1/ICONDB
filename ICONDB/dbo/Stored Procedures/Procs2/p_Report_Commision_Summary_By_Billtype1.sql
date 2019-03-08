CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_By_Billtype1]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@billtype	varchar(2)
AS
SET @billtype = isnull(@billtype,'')
If (@AgentID >1 AND @facilityID =0 )
 Begin 

	If(@billtype	<> '')
		select tblbilltype.Descript as Billtype,  tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(12,4)))/60 as Numeric(9,2)) as CallDuration, sum(CAST(CallRevenue as Numeric(9,4))) CallRevenue, Sum(Pif) as Pif,Rate,  
		CAST ((sum(CAST(CallRevenue as Numeric(9,4))) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
				      Else   CAST (((sum(CAST(CallRevenue as Numeric(9,4))) - sum(CAST(CallRevenue as numeric(9,4))) * isnull(Rate,0)  - sum(Pif) -Sum(NIF))   * tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(CAST(Pif as numeric(6,4)))    end) as CommPaid
		from tblcallsbilled with(nolock) INNER JOIN  tblBilltype with(nolock) on
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID 
							Join tblCommrateAgent with(nolock) on
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype = tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =tblCommrateAgent.Calltype and errorCode =0 
							join tblBadDebt with(nolock) on
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID 
							Where
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsbilled.Billtype = @billtype and 
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15      and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0)
		group by tblcallsbilled.calldate, tblbilltype.Descript, tblCommrateAgent.CommRate,Rate,PifPaid 
		Order by tblcallsbilled.calldate, tblbilltype.Descript,tblCommrateAgent.CommRate,Rate,PifPaid 
	
	else
		select tblbilltype.Descript as Billtype,  tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(12,4)))/60 as Numeric(12,4)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,  
		CAST ((sum(CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
				      Else   CAST (((sum(CAST(CallRevenue as Numeric(9,4))) - sum(CAST(CallRevenue as numeric(9,4))) * isnull(Rate,0)  - sum(Pif) -Sum(NIF))   * tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(CAST(Pif as numeric(6,4)))    end) as CommPaid
		from tblcallsbilled with(nolock) INNER JOIN  tblBilltype with(nolock) on
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID 
							 Join tblCommrateAgent with(nolock) on
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype = tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =tblCommrateAgent.Calltype and errorCode =0 
							 join tblBadDebt with(nolock) on
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID 
							Where
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15      and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0)
		group by tblcallsbilled.calldate, tblbilltype.Descript, tblCommrateAgent.CommRate,Rate,PifPaid 
		Order by tblcallsbilled.calldate, tblbilltype.Descript,tblCommrateAgent.CommRate, Rate,PifPaid 

 End 
Else
 Begin 
  	If(@billtype	<> '')
		select tblbilltype.Descript as Billtype,  tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif,0 BadDebtRate,  
		0 as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		--(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0) )   * tblCommrate.CommRate)  as numeric(7,2) )  
			--	      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0)  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock),  tblBilltype with(nolock) , tblcommrate with(nolock) where 
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							tblcallsbilled.facilityID	= @facilityID  And
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and errorCode =0  and 
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsbilled.Billtype = @billtype and 
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15      and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0)
		group by tblcallsbilled.calldate, tblbilltype.Descript, tblcommrate.CommRate,BadDebtRate,PifPaid 
		Order by tblcallsbilled.calldate, tblbilltype.Descript,tblcommrate.CommRate,BadDebtRate,PifPaid 
	
	else
		select tblbilltype.Descript as Billtype,tblcallsbilled.calldate,   count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif, 0 BadDebtRate,  
		0  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		--(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0) )   * tblCommrate.CommRate)  as numeric(7,2) )  
			--	      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0)  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock),  tblBilltype with(nolock) , tblcommrate with(nolock) where 
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							tblcallsbilled.facilityID	= @facilityID  And
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and	
							tblcallsbilled.agentID = @agentID and errorCode =0  and 
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							 CAST (ResponseCode as int) < 100   and convert (int,duration ) >15     and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0) 
		group by tblcallsbilled.calldate, tblbilltype.Descript, tblcommrate.CommRate,BadDebtRate,PifPaid 
		Order by tblcallsbilled.calldate, tblbilltype.Descript,tblcommrate.CommRate,BadDebtRate,PifPaid

 End
