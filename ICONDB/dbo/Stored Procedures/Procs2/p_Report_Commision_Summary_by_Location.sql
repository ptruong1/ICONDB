

CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_Location]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@LocationID	int
AS

If (@AgentId >0)

 Begin

	If(@LocationID >0)
	
		select  tblFacilityLocation.Descript as Location, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,BadDebtRate,  
		CAST ((sum(CallRevenue) * BadDebtRate) as numeric(7,2))  as BadDebt,  tblCommrate.CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock), tblcommrate with(nolock),  tblFacilityLocation  with(nolock) , tblANIs  with(nolock) where 
							
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  tblFacilityLocation.LocationID	= 	tblANIs.LocationID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
							tblcallsbilled.facilityID	= @facilityID  And
							tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblFacilityLocation.LocationID= @LocationID
							and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacilityLocation.Descript, tblcallsbilled.calldate,tblcommrate.CommRate,BadDebtRate, PifPaid 
		Order by  tblFacilityLocation.Descript, tblcallsbilled.calldate,tblcommrate.CommRate,BadDebtRate,PifPaid 
	
	
	Else
		
		select  tblFacilityLocation.Descript as Location, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,BadDebtRate,  
		CAST ((sum(CallRevenue) * BadDebtRate) as numeric(7,2))  as BadDebt,  tblCommrate.CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock), tblcommrate with(nolock),  tblFacilityLocation  with(nolock) , tblANIs  with(nolock) where 
							
							
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  tblFacilityLocation.LocationID	= 	tblANIs.LocationID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
							tblcallsbilled.facilityID	= @facilityID  And
							tblcallsbilled.agentID = @agentID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
							and  CAST (ResponseCode as int) < 100   and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacilityLocation.Descript, tblcallsbilled.calldate,tblcommrate.CommRate,BadDebtRate, PifPaid 
		Order by  tblFacilityLocation.Descript, tblcallsbilled.calldate,tblcommrate.CommRate,BadDebtRate,PifPaid
 end
else
   Begin

	If(@LocationID >0)
	
		select  tblFacilityLocation.Descript as Location, tblcallsbilled.calldate, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif,0 BadDebtRate,  
		0  as BadDebt,  tblCommrate.CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
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
		0 as BadDebt,  tblCommrate.CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock), tblcommrate with(nolock),  tblFacilityLocation  with(nolock) , tblANIs  with(nolock) where 
							
							
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  tblFacilityLocation.LocationID	= 	tblANIs.LocationID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) )  
							and  CAST (ResponseCode as int) < 100   and convert (int,duration ) >15 
		group by  tblFacilityLocation.Descript, tblcallsbilled.calldate,tblcommrate.CommRate,BadDebtRate, PifPaid 
		Order by  tblFacilityLocation.Descript, tblcallsbilled.calldate,tblcommrate.CommRate,BadDebtRate,PifPaid
 end

