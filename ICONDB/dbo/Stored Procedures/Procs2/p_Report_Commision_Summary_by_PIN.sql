﻿

CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_PIN]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@PIN	int
AS
If(@AgentID >0)
 Begin
	If(@PIN >0)
	
		select  tblInmate.PIN as PIN,tblcallsbilled.calldate,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,BadDebtRate,  
		CAST ((sum(CallRevenue) * BadDebtRate) as numeric(7,2))  as BadDebt,  tblCommrate.CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock), tblInmate with(nolock)  where  
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblcallsbilled.PIN = tblInmate.PIN and
							tblcallsbilled.facilityID	= @facilityID  And
							tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsbilled.PIN	= @PIN and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblInmate.PIN, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid  
		Order by  tblInmate.PIN, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid  
	
	Else
		
		select  tblInmate.PIN as PIN,tblcallsbilled.calldate,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif,0 BadDebtRate,  
		0  as BadDebt,  tblCommrate.CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock), tblInmate with(nolock)  where  
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblcallsbilled.PIN = tblInmate.PIN and
							tblcallsbilled.facilityID	= @facilityID  And
							tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblInmate.PIN, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid  
		Order by  tblInmate.PIN, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid
 End
Else
 Begin
	If(@PIN >0)
	
		select  tblInmate.PIN as PIN,tblcallsbilled.calldate,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif,0 BadDebtRate,  
		0 as BadDebt,  tblCommrate.CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock), tblInmate with(nolock)  where  
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
		
		select  tblInmate.PIN as PIN,tblcallsbilled.calldate,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,BadDebtRate,  
		CAST ((sum(CallRevenue) * BadDebtRate) as numeric(7,2))  as BadDebt,  tblCommrate.CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock), tblInmate with(nolock)  where  
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblcallsbilled.PIN = tblInmate.PIN and
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
		group by  tblInmate.PIN, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid  
		Order by  tblInmate.PIN, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid
 End

