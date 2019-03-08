CREATE PROCEDURE [dbo].[p_Report_Calls_Rejected]
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
			select recordID, Calldate, Location, fromno,('#'+tono) as tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
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
		 
				from tblCallsBilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock), tblErrorType with(nolock)
				WHERE
								tblCallsBilled.Billtype = tblBilltype.Billtype and
								tblCallsBilled.errorCode = tblErrorType.ErrorType and 
								tblCallsBilled.Calltype = tblCalltype.Abrev and
								tblCallsBilled.AgentID=  tblCommrateAgent.AgentID and
								tblCallsBilled.Billtype =  tblCommrateAgent.billtype and
								 tblCallsBilled.Calltype = tblCommrateAgent.Calltype and
								 tblCallsBilled.FacilityID = tblBadDebt.FacilityID and
								  tblCallsBilled.billtype =  tblBadDebt.billtype and
								  tblCallsBilled.Calltype =  tblBadDebt.Calltype and
								  tblCallsBilled.AgentID =  tblBadDebt.AgentID and
								tblCallsBilled.FacilityID =  tblFacility.FacilityID and
								tblCallsBilled.FacilityID =  @divisionID and
								 tblCallsBilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and tblCallsBilled.errorCode <> 0
			Order by tblCallsBilled.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		else
			select recordID, Calldate, Location, fromno,('#'+tono) as tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
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
				from tblCallsBilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock), tblErrorType with(nolock)
				WHERE
								tblCallsBilled.Billtype = tblBilltype.Billtype and
								tblCallsBilled.errorCode = tblErrorType.ErrorType and
								tblCallsBilled.Calltype = tblCalltype.Abrev and
								tblCallsBilled.AgentID=  tblCommrate.AgentID and
								tblCallsBilled.Billtype =  tblCommrate.billtype and
								 tblCallsBilled.Calltype = tblCommrate.Calltype and
								  tblCallsBilled.FacilityID =  tblCommrate.FacilityID and
								 tblCallsBilled.FacilityID = tblBadDebt.FacilityID and
								  tblCallsBilled.billtype =  tblBadDebt.billtype and
								  tblCallsBilled.Calltype =  tblBadDebt.Calltype and
								  tblCallsBilled.AgentID =  tblBadDebt.AgentID and
								tblCallsBilled.FacilityID =  tblFacility.FacilityID and
								tblCallsBilled.FacilityID =  @divisionID and
								 tblCallsBilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and tblCallsBilled.errorCode <> 0 
			Order by tblCallsBilled.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		
	      else	
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select recordID, Calldate, Location, fromno,('#'+tono) as tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
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
				from tblCallsBilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock), tblErrorType with(nolock)
				WHERE
								tblCallsBilled.Billtype = tblBilltype.Billtype and
								tblCallsBilled.errorCode = tblErrorType.ErrorType and
								tblCallsBilled.Calltype = tblCalltype.Abrev and
								tblCallsBilled.AgentID=  tblCommrateAgent.AgentID and
								tblCallsBilled.Billtype =  tblCommrateAgent.billtype and
								 tblCallsBilled.Calltype = tblCommrateAgent.Calltype and
								 tblCallsBilled.FacilityID = tblBadDebt.FacilityID and
								  tblCallsBilled.billtype =  tblBadDebt.billtype and
								  tblCallsBilled.Calltype =  tblBadDebt.Calltype and
								  tblCallsBilled.AgentID =  tblBadDebt.AgentID and
								tblCallsBilled.FacilityID =  tblFacility.FacilityID and
								 tblCallsBilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
								and tblCallsBilled.errorCode <> 0
			Order by tblCallsBilled.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		else
			select recordID, Calldate, Location, fromno,('#'+tono) as tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
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
				from tblCallsBilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock), tblErrorType with(nolock)
				WHERE
								tblCallsBilled.Billtype = tblBilltype.Billtype and
								tblCallsBilled.errorCode = tblErrorType.ErrorType and
								tblCallsBilled.Calltype = tblCalltype.Abrev and
								tblCallsBilled.AgentID=  tblCommrate.AgentID and
								tblCallsBilled.Billtype =  tblCommrate.billtype and
								 tblCallsBilled.Calltype = tblCommrate.Calltype and
							                tblCallsBilled.FacilityID = tblCommrate.FacilityID and
								 tblCallsBilled.FacilityID = tblBadDebt.FacilityID and						
								  tblCallsBilled.billtype =  tblBadDebt.billtype and
								  tblCallsBilled.Calltype =  tblBadDebt.Calltype and
								  tblCallsBilled.AgentID =  tblBadDebt.AgentID and
								tblCallsBilled.FacilityID =  tblFacility.FacilityID and
								 tblCallsBilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
								and tblCallsBilled.errorCode <> 0
			Order by tblCallsBilled.calldate, Location, tblbilltype.Descript, tblCallType.Descript
	
	else
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) = 0
	    
		If @divisionID > 0
			select recordID, Calldate, Location, fromno,('#'+tono) as tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif, 0  BadDebtRate,  
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
		 
				from tblCallsBilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock), tblErrorType with(nolock)
				WHERE
								tblCallsBilled.Billtype = tblBilltype.Billtype and
								tblCallsBilled.errorCode = tblErrorType.ErrorType and 
							tblCallsBilled.Calltype = tblCalltype.Abrev and
							tblCallsBilled.AgentID=  tblCommrateAgent.AgentID and
							tblCallsBilled.Billtype =  tblCommrateAgent.billtype and
							 tblCallsBilled.Calltype = tblCommrateAgent.Calltype and
							tblCallsBilled.FacilityID =  tblFacility.FacilityID and
							 tblCallsBilled.agentID = @agentID and
							tblCallsBilled.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
							and tblCallsBilled.errorCode <> 0
		Order by tblCallsBilled.calldate, Location, tblbilltype.Descript, tblCallType.Descript

		Else

		select recordID, Calldate, Location, fromno,('#'+tono) as tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif, 0  BadDebtRate,  
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
		 
				from tblCallsBilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock), tblErrorType with(nolock)
				WHERE
								tblCallsBilled.Billtype = tblBilltype.Billtype and
								tblCallsBilled.errorCode = tblErrorType.ErrorType and 
								tblCallsBilled.Calltype = tblCalltype.Abrev and
							tblCallsBilled.AgentID=  tblCommrateAgent.AgentID and
							tblCallsBilled.Billtype =  tblCommrateAgent.billtype and
							 tblCallsBilled.Calltype = tblCommrateAgent.Calltype and
							tblCallsBilled.FacilityID =  tblFacility.FacilityID and
							 tblCallsBilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
							and tblCallsBilled.errorCode <> 0 
		Order by tblCallsBilled.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		
 	end	
Else
 	

	select recordID, Calldate, fromno,('#'+tono) as tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate,  '1' as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue,0  Pif, 0  BadDebtRate,  
		0 as BadDebt, (tblCommrate.CommRate * 100) as CommRate, FromState as State,
		(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
		 Else CAST((( CallRevenue - (CallRevenue * isnull(BadDebtRate,0) ) -isnull(Pif,0) )  *tblCommrate.CommRate)  as Numeric(12,4) ) + isnull( PIf,0)     End)  as CommPaid,
		 (CASE when errorCode > 0 then tblErrorType.Descript Else '' End)   ErrorDescript, 
		(CASE when errorCode > 0 then (-1)	Else Null End)   CallAdjust,
		(CASE when errorCode > 0 then dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)* (-1) Else Null End)   DurationAdjust,
		(CASE when errorCode > 0 then (CallRevenue * (-1)) Else Null End)   RevenueAdjust,
		(CASE when errorCode > 0 then
		 Case when PifPaid = 0 then 
			((CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ))) * (-1)
			Else
			(CAST((( CallRevenue - (CallRevenue * isnull(BadDebtRate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)) * (-1)
			end
		 Else Null End)   CommAdjust
		from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock), tblErrorType with(nolock) 
		 WHERE
						tblcallsBilled.errorcode = tblErrorType.ErrorType and
						tblcallsbilled.Billtype = tblBilltype.Billtype and
						 tblcallsBilled.errorcode <> '0' and 
						tblcallsbilled.Calltype = tblCalltype.Abrev and
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						tblcallsbilled.facilityID	= 373  And
						--tblcallsbilled.agentID = @agentID and
						(RecordDate between '11/01/2014' and dateadd(d,1,'11/30/2014') )   and convert (int,duration ) >5
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
						 
	Order by tblcallsbilled.calldate, tblbilltype.Descript, tblCallType.Descript
