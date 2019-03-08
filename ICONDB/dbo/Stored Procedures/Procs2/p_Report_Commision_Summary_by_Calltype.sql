

CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_Calltype]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@Calltype	varchar(2)
AS
If (@AgentID >0)
 Begin
	If(@Calltype <>'')
	
		select tblcalltype.Descript as Calltype,   tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,BadDebtRate,  
		CAST ((sum(CallRevenue) * BadDebtRate) as numeric(7,2))  as BadDebt,  tblCommrate.CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblcommrate with(nolock) where 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsbilled.Calltype = @Calltype  and
							  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by tblcallsbilled.calldate, tblCalltype.Descript, tblcommrate.CommRate,BadDebtRate,PifPaid 
		Order by tblcallsbilled.calldate, tblCalltype.Descript,tblcommrate.CommRate,BadDebtRate,PifPaid 
	
	Else
		select tblcalltype.Descript as Calltype,   tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,BadDebtRate,  
		CAST ((sum(CallRevenue) * BadDebtRate) as numeric(7,2))  as BadDebt,  tblCommrate.CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblcommrate with(nolock) where 
							tblcallsbilled.Calltype =  tblCalltype.Abrev and
							tblcallsbilled.facilityID	= @facilityID  And
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) )    and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by tblcallsbilled.calldate, tblCalltype.Descript, tblcommrate.CommRate,BadDebtRate,PifPaid 
		Order by tblcallsbilled.calldate, tblCalltype.Descript,tblcommrate.CommRate,BadDebtRate,PifPaid
 End
Else
 Begin
	If(@Calltype <>'')
	
		select tblcalltype.Descript as Calltype,   tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif,0 BadDebtRate,  
		0 as BadDebt,  tblCommrate.CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblcommrate with(nolock) where 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.facilityID	= @facilityID  And
							 tblcallsBilled.errorcode = '0' and 
							--tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblcallsbilled.Calltype = @Calltype  and
							  CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
		group by tblcallsbilled.calldate, tblCalltype.Descript, tblcommrate.CommRate,BadDebtRate,PifPaid 
		Order by tblcallsbilled.calldate, tblCalltype.Descript,tblcommrate.CommRate,BadDebtRate,PifPaid 
	
	Else
		select tblcalltype.Descript as Calltype,   tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif , 0 BadDebtRate,  
		0  as BadDebt,  tblCommrate.CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock),  tblcalltype with(nolock) , tblcommrate with(nolock) where 
							tblcallsbilled.Calltype =  tblCalltype.Abrev and
							tblcallsbilled.facilityID	= @facilityID  And
							 tblcallsBilled.errorcode = '0' and 
							--tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
		group by tblcallsbilled.calldate, tblCalltype.Descript, tblcommrate.CommRate,BadDebtRate,PifPaid 
		Order by tblcallsbilled.calldate, tblCalltype.Descript,tblcommrate.CommRate,BadDebtRate,PifPaid
 End

