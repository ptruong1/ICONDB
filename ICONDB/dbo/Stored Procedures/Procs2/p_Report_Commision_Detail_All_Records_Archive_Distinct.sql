CREATE PROCEDURE [dbo].[p_Report_Commision_Detail_All_Records_Archive_Distinct]
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
			select Calldate, Location, fromno,('#'+tono) as tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid, FromState as State,
				(CASE when errorCode > 0 then 
					tblErrorType.Descript 
				 Else '' End)   ErrorDescript,
				 
				(CASE when errorCode > 0 then 
					(-1)	
			    Else Null End)   CallAdjust,
			    
			    (CASE when errorCode > 0 then 
					dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )	* (-1)
			    Else Null End)   DurationAdjust,
			     
				(CASE when errorCode > 0 then 
					(CallRevenue * (-1))
				 Else Null End)   RevenueAdjust,
				 (CASE when errorCode > 0 then 
					Case 
					when PifPaid = 0 then 
					((CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ))) * (-1)
					else
					(CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)) * (-1)
					end
				 Else Null End)   CommAdjust
		 
				from tblCallsBilledAll with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock), tblErrorType with(nolock)
				WHERE
								tblCallsBilledAll.Billtype = tblBilltype.Billtype and
								tblCallsBilledAll.errorCode = tblErrorType.ErrorType and 
								tblCallsBilledAll.Calltype = tblCalltype.Abrev and
								tblCallsBilledAll.AgentID=  tblCommrateAgent.AgentID and
								tblCallsBilledAll.Billtype =  tblCommrateAgent.billtype and
								 tblCallsBilledAll.Calltype = tblCommrateAgent.Calltype and
								 tblCallsBilledAll.FacilityID = tblBadDebt.FacilityID and
								  tblCallsBilledAll.billtype =  tblBadDebt.billtype and
								  tblCallsBilledAll.Calltype =  tblBadDebt.Calltype and
								  tblCallsBilledAll.AgentID =  tblBadDebt.AgentID and
								tblCallsBilledAll.FacilityID =  tblFacility.FacilityID and
								tblCallsBilledAll.FacilityID =  @divisionID and
								 tblCallsBilledAll.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			Order by tblCallsBilledAll.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		else
			select Calldate,  Location, fromno,('#'+tono) as tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrate.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid, State,
				(CASE when errorCode > 0 then 
					tblErrorType.Descript 
				 Else '' End)   ErrorDescript,
				 
				 (CASE when errorCode > 0 then 
					(-1)	
			    Else Null End)   CallAdjust,
			    
			    (CASE when errorCode > 0 then 
					dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )	* (-1)	
			    Else Null End)   DurationAdjust,
			     
				(CASE when errorCode > 0 then 
					(CallRevenue * (-1))
				 Else Null End)   RevenueAdjust,
				 (CASE when errorCode > 0 then 
					Case 
					when PifPaid = 0 then 
					((CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ))) * (-1)
					when PifPaid > 0 then
					(CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)) * (-1)
					end
				 Else Null End)   CommAdjust
				from tblCallsBilledAll with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock), tblErrorType with(nolock)
				WHERE
								tblCallsBilledAll.Billtype = tblBilltype.Billtype and
								tblCallsBilledAll.errorCode = tblErrorType.ErrorType and
								tblCallsBilledAll.Calltype = tblCalltype.Abrev and
								tblCallsBilledAll.AgentID=  tblCommrate.AgentID and
								tblCallsBilledAll.Billtype =  tblCommrate.billtype and
								 tblCallsBilledAll.Calltype = tblCommrate.Calltype and
								  tblCallsBilledAll.FacilityID =  tblCommrate.FacilityID and
								 tblCallsBilledAll.FacilityID = tblBadDebt.FacilityID and
								  tblCallsBilledAll.billtype =  tblBadDebt.billtype and
								  tblCallsBilledAll.Calltype =  tblBadDebt.Calltype and
								  tblCallsBilledAll.AgentID =  tblBadDebt.AgentID and
								tblCallsBilledAll.FacilityID =  tblFacility.FacilityID and
								tblCallsBilledAll.FacilityID =  @divisionID and
								 tblCallsBilledAll.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			Order by tblCallsBilledAll.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		
	      else	
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select Calldate, RecordID, Location, fromno,('#'+tono) as tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid, State,
				(CASE when errorCode > 0 then 
					tblErrorType.Descript 
				 Else '' End)   ErrorDescript, 
				 
				 (CASE when errorCode > 0 then 
					(-1)	
			    Else Null End)   CallAdjust,
			    
			    (CASE when errorCode > 0 then 
					dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )	* (-1)	
			    Else Null End)   DurationAdjust,
			     
				(CASE when errorCode > 0 then 
					(CallRevenue * (-1))
				 Else Null End)   RevenueAdjust,
				 (CASE when errorCode > 0 then 
					Case 
					when PifPaid = 0 then 
					((CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ))) * (-1)
					Else
					(CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)) * (-1)
					end
				 Else Null End)   CommAdjust
				from tblCallsBilledAll with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock), tblErrorType with(nolock)
				WHERE
								tblCallsBilledAll.Billtype = tblBilltype.Billtype and
								tblCallsBilledAll.errorCode = tblErrorType.ErrorType and
								tblCallsBilledAll.Calltype = tblCalltype.Abrev and
								tblCallsBilledAll.AgentID=  tblCommrateAgent.AgentID and
								tblCallsBilledAll.Billtype =  tblCommrateAgent.billtype and
								 tblCallsBilledAll.Calltype = tblCommrateAgent.Calltype and
								 tblCallsBilledAll.FacilityID = tblBadDebt.FacilityID and
								  tblCallsBilledAll.billtype =  tblBadDebt.billtype and
								  tblCallsBilledAll.Calltype =  tblBadDebt.Calltype and
								  tblCallsBilledAll.AgentID =  tblBadDebt.AgentID and
								tblCallsBilledAll.FacilityID =  tblFacility.FacilityID and
								 tblCallsBilledAll.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			Order by tblCallsBilledAll.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		else
			select Calldate, Location, fromno,('#'+tono) as tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrate.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid, State,
				(CASE when errorCode > 0 then 
					tblErrorType.Descript 
				 Else '' End)   ErrorDescript, 
				 
				 (CASE when errorCode > 0 then 
					(-1)	
			    Else Null End)   CallAdjust,
			    
			    (CASE when errorCode > 0 then 
					dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )	* (-1)	
			    Else Null End)   DurationAdjust,
			     
				(CASE when errorCode > 0 then 
					(CallRevenue * (-1))
				 Else Null End)   RevenueAdjust,
				 (CASE when errorCode > 0 then 
					Case 
					when PifPaid = 0 then 
					((CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ))) * (-1)
					Else
					(CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)) * (-1)
					end
				 Else Null End)   CommAdjust
				from tblCallsBilledAll with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock), tblErrorType with(nolock)
				WHERE
								tblCallsBilledAll.Billtype = tblBilltype.Billtype and
								tblCallsBilledAll.errorCode = tblErrorType.ErrorType and
								tblCallsBilledAll.Calltype = tblCalltype.Abrev and
								tblCallsBilledAll.AgentID=  tblCommrate.AgentID and
								tblCallsBilledAll.Billtype =  tblCommrate.billtype and
								 tblCallsBilledAll.Calltype = tblCommrate.Calltype and
							                tblCallsBilledAll.FacilityID = tblCommrate.FacilityID and
								 tblCallsBilledAll.FacilityID = tblBadDebt.FacilityID and						
								  tblCallsBilledAll.billtype =  tblBadDebt.billtype and
								  tblCallsBilledAll.Calltype =  tblBadDebt.Calltype and
								  tblCallsBilledAll.AgentID =  tblBadDebt.AgentID and
								tblCallsBilledAll.FacilityID =  tblFacility.FacilityID and
								 tblCallsBilledAll.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			Order by tblCallsBilledAll.calldate, Location, tblbilltype.Descript, tblCallType.Descript
	
	else
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) = 0
	    
		If @divisionID > 0
			select Calldate, Location, fromno,('#'+tono) as tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif, 0  BadDebtRate,  
			0 as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
			(CASE PifPaid  when 0 then  CAST((( CallRevenue  )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
			 Else CAST((( CallRevenue - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid, State,
			(CASE when errorCode > 0 then 
			tblErrorType.Descript 
				 Else '' End)   ErrorDescript, 
				 
				 (CASE when errorCode > 0 then 
					(-1)	
			    Else Null End)   CallAdjust,
			    
			    (CASE when errorCode > 0 then 
					dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )	* (-1)	
			    Else Null End)   DurationAdjust,
			     
				(CASE when errorCode > 0 then 
					(CallRevenue * (-1))
				 Else Null End)   RevenueAdjust,
				 (CASE when errorCode > 0 then 
					Case 
					when PifPaid = 0 then 
					((CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ))) * (-1)
					Else
					(CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)) * (-1)
					end
				 Else Null End)   CommAdjust
		 
				from tblCallsBilledAll with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock), tblErrorType with(nolock)
				WHERE
								tblCallsBilledAll.Billtype = tblBilltype.Billtype and
								tblCallsBilledAll.errorCode = tblErrorType.ErrorType and 
							tblCallsBilledAll.Calltype = tblCalltype.Abrev and
							tblCallsBilledAll.AgentID=  tblCommrateAgent.AgentID and
							tblCallsBilledAll.Billtype =  tblCommrateAgent.billtype and
							 tblCallsBilledAll.Calltype = tblCommrateAgent.Calltype and
							tblCallsBilledAll.FacilityID =  tblFacility.FacilityID and
							 tblCallsBilledAll.agentID = @agentID and
							tblCallsBilledAll.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		Order by tblCallsBilledAll.calldate, Location, tblbilltype.Descript, tblCallType.Descript

		Else

		select Calldate, Location, fromno,('#'+tono) as tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif, 0  BadDebtRate,  
			0 as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
			(CASE PifPaid  when 0 then  CAST((( CallRevenue  )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
			 Else CAST((( CallRevenue - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid, State,
			(CASE when errorCode > 0 then 
			tblErrorType.Descript 
			 Else '' End)   ErrorDescript, 
			 
			 (CASE when errorCode > 0 then 
					(-1)	
			    Else Null End)   CallAdjust,
			    
			    (CASE when errorCode > 0 then 
					dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )	* (-1)	
			    Else Null End)   DurationAdjust,
			     
			(CASE when errorCode > 0 then 
				(CallRevenue * (-1))
			 Else Null End)   RevenueAdjust,
			 (CASE when errorCode > 0 then 
			Case 
			when PifPaid = 0 then 
			((CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ))) * (-1)
			Else
			(CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)) * (-1)
			end
		 Else Null End)   CommAdjust
		 
				from tblCallsBilledAll with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock), tblErrorType with(nolock)
				WHERE
								tblCallsBilledAll.Billtype = tblBilltype.Billtype and
								tblCallsBilledAll.errorCode = tblErrorType.ErrorType and 
								tblCallsBilledAll.Calltype = tblCalltype.Abrev and
							tblCallsBilledAll.AgentID=  tblCommrateAgent.AgentID and
							tblCallsBilledAll.Billtype =  tblCommrateAgent.billtype and
							 tblCallsBilledAll.Calltype = tblCommrateAgent.Calltype and
							tblCallsBilledAll.FacilityID =  tblFacility.FacilityID and
							 tblCallsBilledAll.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		Order by tblCallsBilledAll.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		
 	end	
Else
 	

	select Calldate, fromno,('#'+tono) as tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate,  '1' as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue,0  Pif, 0  BadDebtRate,  
		0 as BadDebt, (tblCommrate.CommRate * 100) as CommRate,
		(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
		 Else CAST((( CallRevenue - (CallRevenue * isnull(BadDebtRate,0) ) -isnull(Pif,0) )  *tblCommrate.CommRate)  as Numeric(12,4) ) + isnull( PIf,0)     End)  as CommPaid, FromState as State,
		(CASE when errorCode > 0 then 
			tblErrorType.Descript 
			 Else '' End)   ErrorDescript, 
			 
			 (CASE when errorCode > 0 then 
					(-1)	
			    Else Null End)   CallAdjust,
			    
			    (CASE when errorCode > 0 then 
					dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )	* (-1)	
			    Else Null End)   DurationAdjust,
			     
			(CASE when errorCode > 0 then 
				(CallRevenue * (-1))
			 Else Null End)   RevenueAdjust,
			 
		 (CASE when errorCode > 0 then 
			Case 
			when PifPaid = 0 then 
			((CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ))) * (-1)
			Else
			(CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)) * (-1)
			end
		 Else Null End)   CommAdjust
		 
				from tblCallsBilledAll with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock), tblErrorType with(nolock)
				WHERE
								tblCallsBilledAll.Billtype = tblBilltype.Billtype and
								tblCallsBilledAll.errorCode = tblErrorType.ErrorType and 
						tblCallsBilledAll.Calltype = tblCalltype.Abrev and
						tblCallsBilledAll.FacilityID=  tblCommrate.FacilityID and
						tblCallsBilledAll.Billtype =  tblCommrate.billtype and
						 tblCallsBilledAll.Calltype = tblCommrate.Calltype and
						tblCallsBilledAll.facilityID	= @facilityID  And
						--tblCallsBilledAll.agentID = @agentID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
	Order by tblCallsBilledAll.calldate, tblbilltype.Descript, tblCallType.Descript
