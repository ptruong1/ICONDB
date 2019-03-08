CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_Division2]

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
			select  tblFacility.Location as DiVision, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif, isnull(Rate,0) BadDebtRate,  
			CAST ((sum(CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)) as numeric(12,5))  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum(CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
					      Else  CAST( CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum(CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif) - Sum(NIF) )   * tblCommrateAgent.CommRate )  as numeric(12,4) )  + sum(CAST(Pif as numeric(6,4))) as Numeric(12,4))  end) as CommPaid
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
			group by tblFacility.Location, tblcommrateAgent.CommRate,Rate, PifPaid 
			Order by tblFacility.Location, tblcommrateAgent.CommRate,Rate,PifPaid 
		else
			select  tblFacility.Location as DiVision, count(CallRevenue ) CallCount,sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif, isnull(Rate,0) BadDebtRate,  
			CAST ((sum(CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0) )   * tblCommrate.CommRate)  as numeric(12,4) )  
					     Else   (sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF) )   * tblCommrate.CommRate   + sum(Cast(Pif as numeric(6,4)))    end) as CommPaid
					   -- ( sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF) )   * tblCommrateAgent.CommRate
					     -- Else  CAST( CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF) )   * tblCommrateAgent.CommRate  )  as numeric(12,4) )  + sum(Pif)  AS Numeric(12,4))  end) as CommPaid
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
								
			group by  tblFacility.Location, tblcommrate.CommRate,Rate, PifPaid 
			Order by  tblFacility.Location, tblcommrate.CommRate,Rate,PifPaid 
			
	
	Else
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select  tblFacility.Location as DiVision, count(CallRevenue ) CallCount,sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif, isnull(Rate,0) BadDebtRate,  
			CAST ((sum(CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
					     Else   (sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF) )   * tblCommrateAgent.CommRate   + sum(Cast(Pif as numeric(6,4)))    end) as CommPaid
					   -- ( sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF) )   * tblCommrateAgent.CommRate
					     -- Else  CAST( CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF) )   * tblCommrateAgent.CommRate  )  as numeric(12,4) )  + sum(Pif)  AS Numeric(12,4))  end) as CommPaid
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
								
			group by  tblFacility.Location, tblcommrateAgent.CommRate,Rate, PifPaid 
			Order by  tblFacility.Location, tblcommrateAgent.CommRate,Rate,PifPaid 
		else
			select  tblFacility.Location as DiVision, count(CallRevenue ) CallCount,sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif, isnull(Rate,0) BadDebtRate,  
			CAST ((sum(CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0) )   * tblCommrate.CommRate)  as numeric(12,4) )  
					     Else   (sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF) )   * tblCommrate.CommRate   + sum(Cast(Pif as numeric(6,4)))    end) as CommPaid
					   -- ( sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF) )   * tblCommrateAgent.CommRate
					     -- Else  CAST( CAST (((sum(CAST(CallRevenue as numeric(9,4))) - sum( CAST(CallRevenue as numeric(9,4))) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF) )   * tblCommrateAgent.CommRate  )  as numeric(12,4) )  + sum(Pif)  AS Numeric(12,4))  end) as CommPaid
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
								
			group by  tblFacility.Location, tblcommrate.CommRate,Rate, PifPaid 
			Order by  tblFacility.Location, tblcommrate.CommRate,Rate,PifPaid 
 End
Else
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )= 0
 Begin
	If(@divisionID >0)
	
		select  tblFacility.Location as DiVision,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif, '0' BadDebtRate, 0 as Rate,
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
		from tblcallsbilled with(nolock), tblcommrateAgent with(nolock),  tblFacility  with(nolock) , tblANIs  with(nolock) where 							
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and 
							tblFacility.FacilityId	= 	tblANIs.facilityID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
							tblcallsbilled.agentID = @agentID and
							
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblFacility.FacilityId	= @divisionID and
							  convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location, tblcommrateAgent.CommRate,BadDebtRate, PifPaid 
		Order by  tblFacility.Location, tblcommrateAgent.CommRate,BadDebtRate, PifPaid 
	
	Else
		select  tblFacility.Location as DiVision, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST(CallRevenue as numeric(9,4))) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate, 
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
		from tblcallsbilled with(nolock), tblcommrateAgent with(nolock),  tblFacility  with(nolock) , tblANIs  with(nolock)  where 							
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and 
							 tblFacility.FacilityId	= 	tblANIs.facilityID and
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
							tblcallsbilled.agentID = @agentID and
							
							 (RecordDate between @fromDate and dateadd(d,1,@todate) )  AND
							  convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
							
		group by  tblFacility.Location,tblcommrateAgent.CommRate,BadDebtRate, PifPaid 
		Order by  tblFacility.Location, tblcommrateAgent.CommRate,BadDebtRate, PifPaid 
 End
Else
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
		select Division
	,sum(CallCount) as CallCount
	, sum(CallDuration)  as CallDuration
	, sum(CallRevenue) CallRevenue
	, (CommRate) as CommRate 
	,  sum(commPaid)      as CommPaid
	,  sum(BadDebt)      as BadDebt
	from
	(select  tblFacilityDivision.DepartmentName as DiVision,  1 CallCount, (dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, (CallRevenue) CallRevenue, 0 as Pif, 0 BadDebtRate,  
		0  as BadDebt,   (tblCommrate.CommRate * 100) as CommRate ,  
		--(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0) )   * tblCommrate.CommRate)  as numeric(7,2) )  
			--	      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0)  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		CAST (((CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblcommrate with(nolock),  tblFacilityDivision  with(nolock) , tblANIs  with(nolock) where 
							
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and 
							 tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
							tblANIs.ANIno = 	tblcallsbilled.FromNo and	
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and    
							 convert (int,duration ) >5  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0))
		
						   as X
	
						    
	group by X.Division, X.Commrate
	Order by X.Division, X.Commrate
	
		--select  tblFacilityDivision.DepartmentName as DiVision,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif, 0 BadDebtRate,  
		--0  as BadDebt,   (tblCommrate.CommRate * 100) as CommRate ,  
		----(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0) )   * tblCommrate.CommRate)  as numeric(7,2) )  
		--	--	      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0)  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		--CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		--from tblcallsbilled with(nolock), tblcommrate with(nolock),  tblFacilityDivision  with(nolock) , tblANIs  with(nolock) where 
							
		--					tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
		--					 tblcallsBilled.errorcode = '0' and 
		--					tblcallsbilled.Billtype =  tblCommrate.billtype and
		--					 tblcallsbilled.Calltype = tblCommrate.Calltype and 
		--					 tblFacilityDivision.DivisionId	= 	tblANIs.DivisionID and	
		--					tblANIs.ANIno = 	tblcallsbilled.FromNo and	
		--					tblcallsbilled.facilityID	= @facilityID  And
		--					--tblcallsbilled.agentID = @agentID and
		--					(RecordDate between @fromDate and dateadd(d,1,@todate) ) and    
		--					 convert (int,duration ) >5 
		--group by  tblFacilityDivision.DepartmentName,tblcommrate.CommRate,BadDebtRate, PifPaid 
		--Order by  tblFacilityDivision.DepartmentName,tblcommrate.CommRate,BadDebtRate,PifPaid
 End
