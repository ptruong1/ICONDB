

CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_By_Billtype]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@billtype	varchar(2)
AS

If (@AgentID >1)
 Begin 

	If(@billtype	<> '')
		select tblbilltype.Descript as Billtype,  tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,BadDebtRate,  
		CAST ((sum(CallRevenue) *  isnull( BadDebtRate,0)) as numeric(7,2))  as BadDebt,  tblCommrate.CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0) )   * tblCommrate.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0)  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock),  tblBilltype with(nolock) , tblcommrate with(nolock) where 
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and errorCode =0  and 
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsbilled.Billtype = @billtype and 
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15      and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0)
		group by tblcallsbilled.calldate, tblbilltype.Descript, tblcommrate.CommRate,BadDebtRate,PifPaid 
		Order by tblcallsbilled.calldate, tblbilltype.Descript,tblcommrate.CommRate,BadDebtRate,PifPaid 
	
	else
		select tblbilltype.Descript as Billtype,tblcallsbilled.calldate,   count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,BadDebtRate,  
		CAST ((sum(CallRevenue) *  isnull( BadDebtRate,0)) as numeric(7,2))  as BadDebt,  tblCommrate.CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0) )   * tblCommrate.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0)  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
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
Else
 Begin 
  	If(@billtype	<> '')
		select tblbilltype.Descript as Billtype,  tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif,0 BadDebtRate,  
		0 as BadDebt,  tblCommrate.CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
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
		0  as BadDebt,  tblCommrate.CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock),  tblBilltype with(nolock) , tblcommrate with(nolock) where 
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							tblcallsbilled.facilityID	= @facilityID  And
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and	
							--tblcallsbilled.agentID = @agentID
							 errorCode =0  and 
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							 CAST (ResponseCode as int) < 100   and convert (int,duration ) >15     and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0) 
		group by tblcallsbilled.calldate, tblbilltype.Descript, tblcommrate.CommRate,BadDebtRate,PifPaid 
		Order by tblcallsbilled.calldate, tblbilltype.Descript,tblcommrate.CommRate,BadDebtRate,PifPaid

 End

