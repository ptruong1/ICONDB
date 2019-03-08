CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_DestinationNo_Orig]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@ToNo	varchar(10)
AS

If(@AgentID	>1  AND @facilityID =0 )
 Begin 
	If(@ToNo <> '')
	
		select  ToNo, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(12,5)))/60 as Numeric(12,5)) as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,Rate,  
		CAST ((sum(CAST(CallRevenue as numeric(9,4))) *  isnull(Rate,0)) as numeric(12,5))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,5) )  
				      Else   CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif)  -sum(NIF) )   *tblCommrateAgent.CommRate)  as numeric(12,5) )  + sum(CAST(Pif as numeric(6,4)))    end) as CommPaid,	
					tblcalltype.Descript as Calltype,  tblBilltype.Descript as Billtype
		from tblcallsbilled with(nolock), tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent with(nolock), tblBadDebt with(nolock)  where 
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
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and ToNo = @ToNo  and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by ToNo, tblcallsbilled.calldate,tblcalltype.Descript, tblBilltype.Descript,tblCommrateAgent.CommRate,Rate, PifPaid 
		Order by ToNo, tblcallsbilled.calldate,tblcalltype.Descript, tblBilltype.Descript,tblCommrateAgent.CommRate,Rate, PifPaid  
	
	Else
		
		select  ToNo, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(12,5)))/60 as Numeric(12,5)) as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,Rate,  
		CAST ((sum(CAST(CallRevenue as Numeric(9,4))) *  isnull( Rate,0)) as numeric(12,5))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum(CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,5) )  
				      Else   CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif) - Sum(NIF) )   *tblCommrateAgent.CommRate)  as numeric(12,5) )  + sum(CAST(Pif as numeric(6,4)))    end) as CommPaid,
					tblcalltype.Descript as Calltype,  tblBilltype.Descript as Billtype
		from tblcallsbilled with(nolock), tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent with(nolock) ,tblBadDebt with(nolock)  where 
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
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by ToNo, tblcallsbilled.calldate,tblcalltype.Descript, tblBilltype.Descript,tblCommrateAgent.CommRate,Rate, PifPaid 
		Order by ToNo, tblcallsbilled.calldate,tblcalltype.Descript, tblBilltype.Descript,tblCommrateAgent.CommRate,Rate, PifPaid
 End 
Else
 Begin
 If(@ToNo <> '')
	
		select  ToNo, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, 0  as Pif,0 BadDebtRate,  
		0  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid,
					tblcalltype.Descript as Calltype,  tblBilltype.Descript as Billtype
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
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
		group by ToNo, tblcallsbilled.calldate,tblcalltype.Descript, tblBilltype.Descript,tblCommrate.CommRate,BadDebtRate, PifPaid 
		Order by ToNo, tblcallsbilled.calldate,tblcalltype.Descript, tblBilltype.Descript,tblCommrate.CommRate,BadDebtRate, PifPaid
	
	Else
		select  ToNo, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(12,2)))/60 as Numeric(12,2)) as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif, 0 BadDebtRate,  
		0 as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid,
					tblcalltype.Descript as Calltype,  tblBilltype.Descript as Billtype
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
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
		group by ToNo, tblcallsbilled.calldate,tblcalltype.Descript, tblBilltype.Descript,tblCommrate.CommRate,BadDebtRate, PifPaid 
		Order by ToNo, tblcallsbilled.calldate,tblcalltype.Descript, tblBilltype.Descript,tblCommrate.CommRate,BadDebtRate, PifPaid
 End
