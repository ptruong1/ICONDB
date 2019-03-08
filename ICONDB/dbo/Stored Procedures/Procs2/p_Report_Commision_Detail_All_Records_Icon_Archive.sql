CREATE PROCEDURE [dbo].[p_Report_Commision_Detail_All_Records_Icon_Archive]
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
				from tblCallsBilledArchive1 with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock)
				WHERE
								tblCallsBilledArchive1.Billtype = tblBilltype.Billtype and
								 tblCallsBilledArchive1.errorcode = '0' and 
								tblCallsBilledArchive1.Calltype = tblCalltype.Abrev and
								tblCallsBilledArchive1.AgentID=  tblCommrateAgent.AgentID and
								tblCallsBilledArchive1.Billtype =  tblCommrateAgent.billtype and
								 tblCallsBilledArchive1.Calltype = tblCommrateAgent.Calltype and
								 tblCallsBilledArchive1.FacilityID = tblBadDebt.FacilityID and
								  tblCallsBilledArchive1.billtype =  tblBadDebt.billtype and
								  tblCallsBilledArchive1.Calltype =  tblBadDebt.Calltype and
								  tblCallsBilledArchive1.AgentID =  tblBadDebt.AgentID and
								tblCallsBilledArchive1.FacilityID =  tblFacility.FacilityID and
								tblCallsBilledArchive1.FacilityID =  @divisionID and
								 tblCallsBilledArchive1.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			Order by tblCallsBilledArchive1.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		else
			select Calldate, Location, fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrate.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid, State
				from tblCallsBilledArchive1 with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock)
				WHERE
								tblCallsBilledArchive1.Billtype = tblBilltype.Billtype and
								 tblCallsBilledArchive1.errorcode = '0' and 
								tblCallsBilledArchive1.Calltype = tblCalltype.Abrev and
								tblCallsBilledArchive1.AgentID=  tblCommrate.AgentID and
								tblCallsBilledArchive1.Billtype =  tblCommrate.billtype and
								 tblCallsBilledArchive1.Calltype = tblCommrate.Calltype and
								  tblCallsBilledArchive1.FacilityID =  tblCommrate.FacilityID and
								 tblCallsBilledArchive1.FacilityID = tblBadDebt.FacilityID and
								  tblCallsBilledArchive1.billtype =  tblBadDebt.billtype and
								  tblCallsBilledArchive1.Calltype =  tblBadDebt.Calltype and
								  tblCallsBilledArchive1.AgentID =  tblBadDebt.AgentID and
								tblCallsBilledArchive1.FacilityID =  tblFacility.FacilityID and
								tblCallsBilledArchive1.FacilityID =  @divisionID and
								 tblCallsBilledArchive1.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			Order by tblCallsBilledArchive1.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		
	      else	
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select Calldate, Location, fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid, State
				from tblCallsBilledArchive1 with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock)
				WHERE
								tblCallsBilledArchive1.Billtype = tblBilltype.Billtype and
								 tblCallsBilledArchive1.errorcode = '0' and 
								tblCallsBilledArchive1.Calltype = tblCalltype.Abrev and
								tblCallsBilledArchive1.AgentID=  tblCommrateAgent.AgentID and
								tblCallsBilledArchive1.Billtype =  tblCommrateAgent.billtype and
								 tblCallsBilledArchive1.Calltype = tblCommrateAgent.Calltype and
								 tblCallsBilledArchive1.FacilityID = tblBadDebt.FacilityID and
								  tblCallsBilledArchive1.billtype =  tblBadDebt.billtype and
								  tblCallsBilledArchive1.Calltype =  tblBadDebt.Calltype and
								  tblCallsBilledArchive1.AgentID =  tblBadDebt.AgentID and
								tblCallsBilledArchive1.FacilityID =  tblFacility.FacilityID and
								 tblCallsBilledArchive1.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			Order by tblCallsBilledArchive1.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		else
			select Calldate, Location, fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrate.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid, State
				from tblCallsBilledArchive1 with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock)
				WHERE
								tblCallsBilledArchive1.Billtype = tblBilltype.Billtype and
								 tblCallsBilledArchive1.errorcode = '0' and 
								tblCallsBilledArchive1.Calltype = tblCalltype.Abrev and
								tblCallsBilledArchive1.AgentID=  tblCommrate.AgentID and
								tblCallsBilledArchive1.Billtype =  tblCommrate.billtype and
								 tblCallsBilledArchive1.Calltype = tblCommrate.Calltype and
							                tblCallsBilledArchive1.FacilityID = tblCommrate.FacilityID and
								 tblCallsBilledArchive1.FacilityID = tblBadDebt.FacilityID and						
								  tblCallsBilledArchive1.billtype =  tblBadDebt.billtype and
								  tblCallsBilledArchive1.Calltype =  tblBadDebt.Calltype and
								  tblCallsBilledArchive1.AgentID =  tblBadDebt.AgentID and
								tblCallsBilledArchive1.FacilityID =  tblFacility.FacilityID and
								 tblCallsBilledArchive1.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			Order by tblCallsBilledArchive1.calldate, Location, tblbilltype.Descript, tblCallType.Descript
	
	else
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) = 0
	    
		If @divisionID > 0
			select Calldate, Location, fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif, 0  BadDebtRate,  
			0 as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
			(CASE PifPaid  when 0 then  CAST((( CallRevenue  )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
			 Else CAST((( CallRevenue - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid, State
			from tblCallsBilledArchive1 with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock),  tblFacility with(nolock)  WHERE
							tblCallsBilledArchive1.Billtype = tblBilltype.Billtype and
							 tblCallsBilledArchive1.errorcode = '0' and 
							tblCallsBilledArchive1.Calltype = tblCalltype.Abrev and
							tblCallsBilledArchive1.AgentID=  tblCommrateAgent.AgentID and
							tblCallsBilledArchive1.Billtype =  tblCommrateAgent.billtype and
							 tblCallsBilledArchive1.Calltype = tblCommrateAgent.Calltype and
							tblCallsBilledArchive1.FacilityID =  tblFacility.FacilityID and
							 tblCallsBilledArchive1.agentID = @agentID and
							tblCallsBilledArchive1.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		Order by tblCallsBilledArchive1.calldate, Location, tblbilltype.Descript, tblCallType.Descript

		Else

		select Calldate, Location, fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif, 0  BadDebtRate,  
			0 as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
			(CASE PifPaid  when 0 then  CAST((( CallRevenue  )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
			 Else CAST((( CallRevenue - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid, State
			from tblCallsBilledArchive1 with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock),  tblFacility with(nolock)  WHERE
							tblCallsBilledArchive1.Billtype = tblBilltype.Billtype and
							 tblCallsBilledArchive1.errorcode = '0' and 
							tblCallsBilledArchive1.Calltype = tblCalltype.Abrev and
							tblCallsBilledArchive1.AgentID=  tblCommrateAgent.AgentID and
							tblCallsBilledArchive1.Billtype =  tblCommrateAgent.billtype and
							 tblCallsBilledArchive1.Calltype = tblCommrateAgent.Calltype and
							tblCallsBilledArchive1.FacilityID =  tblFacility.FacilityID and
							 tblCallsBilledArchive1.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		Order by tblCallsBilledArchive1.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		
 	end	
Else
 	

	select Calldate, fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate,  '1' as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue,0  Pif, 0  BadDebtRate,  
		0 as BadDebt, (tblCommrate.CommRate * 100) as CommRate,
		(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
		 Else CAST((( CallRevenue - (CallRevenue * isnull(BadDebtRate,0) ) -isnull(Pif,0) )  *tblCommrate.CommRate)  as Numeric(12,4) ) + isnull( PIf,0)     End)  as CommPaid, FromState as State
		from tblCallsBilledArchive1 with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock)  WHERE
						tblCallsBilledArchive1.Billtype = tblBilltype.Billtype and
						 tblCallsBilledArchive1.errorcode = '0' and 
						tblCallsBilledArchive1.Calltype = tblCalltype.Abrev and
						tblCallsBilledArchive1.FacilityID=  tblCommrate.FacilityID and
						tblCallsBilledArchive1.Billtype =  tblCommrate.billtype and
						 tblCallsBilledArchive1.Calltype = tblCommrate.Calltype and
						tblCallsBilledArchive1.facilityID	= @facilityID  And
						--tblCallsBilledArchive1.agentID = @agentID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
	Order by tblCallsBilledArchive1.calldate, tblbilltype.Descript, tblCallType.Descript
