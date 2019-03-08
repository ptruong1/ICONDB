CREATE PROCEDURE [dbo].[p_Report_Commision_Detail2]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime
AS

If(@AgentID	>1 AND @facilityID =0 )
 Begin
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) > 0
		select Calldate, fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, CAST( CAST(duration as numeric(14,4))/60 as Numeric(12,4)) as CallDuration,  CallRevenue, Pif,  isnull(Rate,0) BadDebtRate,  
			CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
			(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
			 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid
			from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) 
			WHERE
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.AgentID=  tblCommrateAgent.AgentID and
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							 tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		Order by tblcallsbilled.calldate, tblbilltype.Descript, tblCallType.Descript
	else
		select Calldate, fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, CAST( CAST(duration as numeric(12,4))/60 as Numeric(12,4)) as CallDuration,  CallRevenue, Pif, 0  BadDebtRate,  
			0 as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
			(CASE PifPaid  when 0 then  CAST((( CallRevenue  )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
			 Else CAST((( CallRevenue - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid
			from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock)  WHERE
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.AgentID=  tblCommrateAgent.AgentID and
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							 tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		Order by tblcallsbilled.calldate, tblbilltype.Descript, tblCallType.Descript
 End
Else
  Begin

	select Calldate, fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, CAST( CAST(duration as numeric(12,4))/60 as Numeric(12,4)) as CallDuration,  CallRevenue,0  Pif, 0  BadDebtRate,  
		0 as BadDebt, (tblCommrate.CommRate * 100) as CommRate,
		(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
		 Else CAST((( CallRevenue - (CallRevenue * isnull(BadDebtRate,0) ) -isnull(Pif,0) )  *tblCommrate.CommRate)  as Numeric(12,4) ) + isnull( PIf,0)     End)  as CommPaid
		from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock)  WHERE
						tblcallsbilled.Billtype = tblBilltype.Billtype and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.Calltype = tblCalltype.Abrev and
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						tblcallsbilled.facilityID	= @facilityID  And
						--tblcallsbilled.agentID = @agentID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
	Order by tblcallsbilled.calldate, tblbilltype.Descript, tblCallType.Descript
 End
