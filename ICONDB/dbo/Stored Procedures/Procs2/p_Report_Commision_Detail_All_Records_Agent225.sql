CREATE PROCEDURE [dbo].[p_Report_Commision_Detail_All_Records_Agent225]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@DivisionID	int
AS

select Calldate, recordID, Location, fromno,('#'+tono) as tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, '1' as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
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
				from tblCallsBilledArchive1 with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock), tblErrorType with(nolock)
				WHERE
								tblCallsBilledArchive1.Billtype = tblBilltype.Billtype and
								tblCallsBilledArchive1.errorCode = tblErrorType.ErrorType and
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
		
