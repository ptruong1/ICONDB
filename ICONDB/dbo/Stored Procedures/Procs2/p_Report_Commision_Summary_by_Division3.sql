CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_Division3]

@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@divisionID	int
AS
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0
 Begin
	If(@divisionID >0)
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select  tblFacility.Location as DiVision, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
			sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, 
			  
			sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

			from tblcallsbilled with(nolock), tblcommrateAgent with(nolock),  tblFacility  with(nolock) , tblANIs  with(nolock), tblBadDebt with(nolock) where 							
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and 
								 tblFacility.FacilityID	= 	tblANIs.FacilityID and	
								tblANIs.ANIno = 	tblcallsbilled.FromNo and	
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblCallsbilled.facilityId	= @divisionID and
								  convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by tblFacility.Location, State
			Order by tblFacility.Location, State
		else
			select  tblFacility.Location as DiVision, count(CallRevenue ) CallCount,sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
			sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
			sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

			from tblcallsbilled with(nolock), tblcommrate with(nolock),  tblFacility  with(nolock) , tblANIs  with(nolock), tblBadDebt  with(nolock)  where 							
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and 
								 tblFacility.FacilityId	= 	 tblCommrate.facilityID and	
								 tblFacility.FacilityId	= 	tblANIs.facilityID and	
								tblANIs.ANIno = 	tblcallsbilled.FromNo and	
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								 (RecordDate between @fromDate and dateadd(d,1,@todate) )  AND  tblCallsbilled.facilityId	= @divisionID and
								  convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
								
			group by tblFacility.Location, State
			Order by tblFacility.Location, State
			
	
	Else
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select  tblFacility.Location as DiVision, count(CallRevenue ) CallCount,sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
			sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
			sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

			from tblcallsbilled with(nolock), tblcommrateAgent with(nolock),  tblFacility  with(nolock) , tblANIs  with(nolock), tblBadDebt  with(nolock)  where 							
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and 
								 tblFacility.FacilityId	= 	tblANIs.facilityID and	
								tblANIs.ANIno = 	tblcallsbilled.FromNo and	
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								 (RecordDate between @fromDate and dateadd(d,1,@todate) )  AND
								  convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
								
			group by tblFacility.Location, State
			Order by tblFacility.Location, State
		else
			select  tblFacility.Location as DiVision, count(CallRevenue ) CallCount,sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
			sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,   
			
			sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

			from tblcallsbilled with(nolock), tblcommrate with(nolock),  tblFacility  with(nolock) , tblANIs  with(nolock), tblBadDebt  with(nolock)  where 							
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and 
								 tblFacility.FacilityId	= 	 tblCommrate.facilityID and	
								 tblFacility.FacilityId	= 	tblANIs.facilityID and	
								tblANIs.ANIno = 	tblcallsbilled.FromNo and	
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								 (RecordDate between @fromDate and dateadd(d,1,@todate) )  AND
								  convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
								
			group by tblFacility.Location, State
			Order by tblFacility.Location, State
 End
Else
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )= 0
 Begin
	If(@divisionID >0)
	
		select  tblFacilityDivision.DepartmentName as DiVision,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif,0 BadDebtRate,  
		0 as BadDebt,   (tblCommrate.CommRate * 100) as CommRate ,  
		--(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0) )   * tblCommrate.CommRate)  as numeric(7,2) )  
			--	      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0)  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblcommrate with(nolock),  tblFacilityDivision  with(nolock) , tblANIs  with(nolock) where 
							
							
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and 
							 tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblFacilityDivision.DivisionId	= @divisionID and
							  convert (int,duration ) >5 
		group by  tblFacilityDivision.DepartmentName, tblcommrate.CommRate,BadDebtRate, PifPaid 
		Order by  tblFacilityDivision.DepartmentName, tblcommrate.CommRate,BadDebtRate,PifPaid 
	
	Else
		select  tblFacilityDivision.DepartmentName as DiVision,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif, 0 BadDebtRate,  
		0  as BadDebt,   (tblCommrate.CommRate * 100) as CommRate ,  
		--(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0) )   * tblCommrate.CommRate)  as numeric(7,2) )  
			--	      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0)  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblcommrate with(nolock),  tblFacilityDivision  with(nolock) , tblANIs  with(nolock) where 
							
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and 
							 tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
							tblcallsbilled.facilityID	= 747  And
							--tblcallsbilled.agentID = @agentID and
							(RecordDate between '08/08/2016' and dateadd(d,1,'08/08/2016') ) and  
							 convert (int,duration ) >5 
		group by  tblFacilityDivision.DepartmentName,tblcommrate.CommRate,BadDebtRate, PifPaid 
		Order by  tblFacilityDivision.DepartmentName,tblcommrate.CommRate,BadDebtRate,PifPaid
 End
