CREATE PROCEDURE [dbo].[p_Report_Commision_Detail3_Archive]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@DivisionID	int
AS

If(@AgentID	>1 AND @facilityID =0 )
 	Begin
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) > 0
	   if @divisionID > 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select Calldate, Location, fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid, State
				from tblCallsBilledArchive with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock)
				WHERE
								tblCallsBilledArchive.Billtype = tblBilltype.Billtype and
								 tblCallsBilledArchive.errorcode = '0' and 
								tblCallsBilledArchive.Calltype = tblCalltype.Abrev and
								tblCallsBilledArchive.AgentID=  tblCommrateAgent.AgentID and
								tblCallsBilledArchive.Billtype =  tblCommrateAgent.billtype and
								 tblCallsBilledArchive.Calltype = tblCommrateAgent.Calltype and
								 tblCallsBilledArchive.FacilityID = tblBadDebt.FacilityID and
								  tblCallsBilledArchive.billtype =  tblBadDebt.billtype and
								  tblCallsBilledArchive.Calltype =  tblBadDebt.Calltype and
								  tblCallsBilledArchive.AgentID =  tblBadDebt.AgentID and
								tblCallsBilledArchive.FacilityID =  tblFacility.FacilityID and
								tblCallsBilledArchive.FacilityID =  @divisionID and
								 tblCallsBilledArchive.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			Order by tblCallsBilledArchive.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		else
			select Calldate, Location, fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrate.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid, State
				from tblCallsBilledArchive with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock)
				WHERE
								tblCallsBilledArchive.Billtype = tblBilltype.Billtype and
								 tblCallsBilledArchive.errorcode = '0' and 
								tblCallsBilledArchive.Calltype = tblCalltype.Abrev and
								tblCallsBilledArchive.AgentID=  tblCommrate.AgentID and
								tblCallsBilledArchive.Billtype =  tblCommrate.billtype and
								 tblCallsBilledArchive.Calltype = tblCommrate.Calltype and
								  tblCallsBilledArchive.FacilityID =  tblCommrate.FacilityID and
								 tblCallsBilledArchive.FacilityID = tblBadDebt.FacilityID and
								  tblCallsBilledArchive.billtype =  tblBadDebt.billtype and
								  tblCallsBilledArchive.Calltype =  tblBadDebt.Calltype and
								  tblCallsBilledArchive.AgentID =  tblBadDebt.AgentID and
								tblCallsBilledArchive.FacilityID =  tblFacility.FacilityID and
								tblCallsBilledArchive.FacilityID =  @divisionID and
								 tblCallsBilledArchive.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			Order by tblCallsBilledArchive.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		
	      else	
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select Calldate, Location, fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid, State
				from tblCallsBilledArchive with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock)
				WHERE
								tblCallsBilledArchive.Billtype = tblBilltype.Billtype and
								 tblCallsBilledArchive.errorcode = '0' and 
								tblCallsBilledArchive.Calltype = tblCalltype.Abrev and
								tblCallsBilledArchive.AgentID=  tblCommrateAgent.AgentID and
								tblCallsBilledArchive.Billtype =  tblCommrateAgent.billtype and
								 tblCallsBilledArchive.Calltype = tblCommrateAgent.Calltype and
								 tblCallsBilledArchive.FacilityID = tblBadDebt.FacilityID and
								  tblCallsBilledArchive.billtype =  tblBadDebt.billtype and
								  tblCallsBilledArchive.Calltype =  tblBadDebt.Calltype and
								  tblCallsBilledArchive.AgentID =  tblBadDebt.AgentID and
								tblCallsBilledArchive.FacilityID =  tblFacility.FacilityID and
								 tblCallsBilledArchive.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			Order by tblCallsBilledArchive.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		else
			select Calldate, Location, fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrate.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid, State
				from tblCallsBilledArchive with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock)
				WHERE
								tblCallsBilledArchive.Billtype = tblBilltype.Billtype and
								 tblCallsBilledArchive.errorcode = '0' and 
								tblCallsBilledArchive.Calltype = tblCalltype.Abrev and
								tblCallsBilledArchive.AgentID=  tblCommrate.AgentID and
								tblCallsBilledArchive.Billtype =  tblCommrate.billtype and
								 tblCallsBilledArchive.Calltype = tblCommrate.Calltype and
							                tblCallsBilledArchive.FacilityID = tblCommrate.FacilityID and
								 tblCallsBilledArchive.FacilityID = tblBadDebt.FacilityID and						
								  tblCallsBilledArchive.billtype =  tblBadDebt.billtype and
								  tblCallsBilledArchive.Calltype =  tblBadDebt.Calltype and
								  tblCallsBilledArchive.AgentID =  tblBadDebt.AgentID and
								tblCallsBilledArchive.FacilityID =  tblFacility.FacilityID and
								 tblCallsBilledArchive.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			Order by tblCallsBilledArchive.calldate, Location, tblbilltype.Descript, tblCallType.Descript
	
	else
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) = 0
	    
		If @divisionID > 0
			select Calldate, Location, fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif, 0  BadDebtRate,  
			0 as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
			(CASE PifPaid  when 0 then  CAST((( CallRevenue  )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
			 Else CAST((( CallRevenue - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid, State
			from tblCallsBilledArchive with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock),  tblFacility with(nolock)  WHERE
							tblCallsBilledArchive.Billtype = tblBilltype.Billtype and
							 tblCallsBilledArchive.errorcode = '0' and 
							tblCallsBilledArchive.Calltype = tblCalltype.Abrev and
							tblCallsBilledArchive.AgentID=  tblCommrateAgent.AgentID and
							tblCallsBilledArchive.Billtype =  tblCommrateAgent.billtype and
							 tblCallsBilledArchive.Calltype = tblCommrateAgent.Calltype and
							tblCallsBilledArchive.FacilityID =  tblFacility.FacilityID and
							 tblCallsBilledArchive.agentID = @agentID and
							tblCallsBilledArchive.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		Order by tblCallsBilledArchive.calldate, Location, tblbilltype.Descript, tblCallType.Descript

		Else

		select Calldate, Location, fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif, 0  BadDebtRate,  
			0 as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
			(CASE PifPaid  when 0 then  CAST((( CallRevenue  )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
			 Else CAST((( CallRevenue - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid, State
			from tblCallsBilledArchive with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock),  tblFacility with(nolock)  WHERE
							tblCallsBilledArchive.Billtype = tblBilltype.Billtype and
							 tblCallsBilledArchive.errorcode = '0' and 
							tblCallsBilledArchive.Calltype = tblCalltype.Abrev and
							tblCallsBilledArchive.AgentID=  tblCommrateAgent.AgentID and
							tblCallsBilledArchive.Billtype =  tblCommrateAgent.billtype and
							 tblCallsBilledArchive.Calltype = tblCommrateAgent.Calltype and
							tblCallsBilledArchive.FacilityID =  tblFacility.FacilityID and
							 tblCallsBilledArchive.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		Order by tblCallsBilledArchive.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		
 	end	
Else
 	

	select Calldate, fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate,  '1' as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue,0  Pif, 0  BadDebtRate,  
		0 as BadDebt, (tblCommrate.CommRate * 100) as CommRate,
		(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
		 Else CAST((( CallRevenue - (CallRevenue * isnull(BadDebtRate,0) ) -isnull(Pif,0) )  *tblCommrate.CommRate)  as Numeric(12,4) ) + isnull( PIf,0)     End)  as CommPaid, FromState as State
		from tblCallsBilledArchive with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock)  WHERE
						tblCallsBilledArchive.Billtype = tblBilltype.Billtype and
						 tblCallsBilledArchive.errorcode = '0' and 
						tblCallsBilledArchive.Calltype = tblCalltype.Abrev and
						tblCallsBilledArchive.FacilityID=  tblCommrate.FacilityID and
						tblCallsBilledArchive.Billtype =  tblCommrate.billtype and
						 tblCallsBilledArchive.Calltype = tblCommrate.Calltype and
						tblCallsBilledArchive.facilityID	= @facilityID  And
						--tblCallsBilledArchive.agentID = @agentID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
	Order by tblCallsBilledArchive.calldate, tblbilltype.Descript, tblCallType.Descript
