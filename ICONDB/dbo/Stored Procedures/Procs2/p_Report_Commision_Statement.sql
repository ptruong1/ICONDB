
CREATE PROCEDURE [dbo].[p_Report_Commision_Statement]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime
AS


If( @AgentID >0) 
 Begin
	select  tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue,
		  tblCommrate.CommRate ,  
						       CAST ((sum(CallRevenue) * tblCommrate.CommRate)  as numeric(7,2) )  as CommPaid
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
	group by  tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate
	Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate

 End 

Else

 Begin

	select  tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype, count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue,
		  tblCommrate.CommRate ,  						       CAST ((sum(CallRevenue) * tblCommrate.CommRate)  as numeric(7,2) )  as CommPaid
	from tblcallsbilled with(nolock),  tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRate where 
						tblcallsbilled.Billtype = tblBilltype.Billtype and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.Calltype = tblCalltype.Abrev and
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						tblcallsbilled.facilityID	= @facilityID  And
						
						 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
						  CAST (ResponseCode as int) < 100   and convert (int,duration ) >15  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
	group by  tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate
	Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate
 	
 end

