CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_PIN3]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@PIN		varchar(12),
@divisionID	int
AS
 declare @InmateID varchar(12) = ''
 IF  @PIN	> 0
	select @InmateID = (InmateID) from tblInmate where FacilityId = @FacilityID and PIN = @PIN
	
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0
 Begin
	If(@InmateID <> '')
	    If @divisionID > 0
		select  tblcallsbilled.InmateID as InmateID, PIN,
			tblcallsbilled.calldate,
			count(CallRevenue ) CallCount, 
			sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
			sum(CallRevenue) CallRevenue, 
			Sum(Pif) as Pif,
			Rate,  
			CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,
			 (tblCommrateAgent.CommRate * 100) as CommRate ,  
				(CASE PifPaid  
				when 
					0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
				Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0)  - sum(Pif) )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
				from tblcallsbilled with(nolock), tblCommRateAgent with(nolock),  tblBadDebt with(nolock)  where 
									tblcallsbilled.agentID = @AgentID and   
									
									 tblcallsBilled.errorcode = '0' and 
									tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
									tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
									 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
								 	
									
									tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
									tblcallsbilled.billtype =  tblBadDebt.billtype and
									  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
									  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID = @divisionID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblcallsbilled.InmateID	= @InmateID and convert (int,duration ) >5  
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
				group by  tblcallsbilled.InmateID, PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,Rate, PifPaid  
				Order by  tblcallsbilled.InmateID, PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,Rate, PifPaid 
	    else
		select  tblcallsbilled.InmateID as InmateID, PIN,
			tblcallsbilled.calldate,
			count(CallRevenue ) CallCount, 
			sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
			sum(CallRevenue) CallRevenue, 
			Sum(Pif) as Pif,
			Rate,  
			CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,
			 (tblCommrateAgent.CommRate * 100) as CommRate ,  
				(CASE PifPaid  
				when 
					0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
				Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0)  - sum(Pif) )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
				from tblcallsbilled with(nolock), tblCommRateAgent with(nolock),  tblBadDebt with(nolock)  where 
									tblcallsbilled.agentID = @AgentID and   
									
									 tblcallsBilled.errorcode = '0' and 
									tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
									tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
									 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
								 	
									
									tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
									tblcallsbilled.billtype =  tblBadDebt.billtype and
									  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
									  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblcallsbilled.InmateID	= @InmateID and convert (int,duration ) >5  
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
				group by  tblcallsbilled.InmateID, PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,Rate, PifPaid  
				Order by  tblcallsbilled.InmateID, PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,Rate, PifPaid 
	
	Else
	    If @divisionID > 0
		select  tblcallsbilled.InmateID as InmateID, PIN,
			tblcallsbilled.calldate,
			count(CallRevenue ) CallCount, 
			sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
			sum(CallRevenue) CallRevenue, 
			Sum(Pif) as Pif,
			Rate,  
			CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,
			 (tblCommrateAgent.CommRate * 100) as CommRate ,  
				(CASE PifPaid  
				when 
					0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
				Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0)  - sum(Pif) )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
				from tblcallsbilled with(nolock), tblCommRateAgent with(nolock),  tblBadDebt with(nolock)  where 
									tblcallsbilled.agentID = @AgentID and   
									
									 tblcallsBilled.errorcode = '0' and 
									tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
									tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
									 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
								 	
									
									tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
									tblcallsbilled.billtype =  tblBadDebt.billtype and
									  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
									  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
									tblcallsbilled.FacilityID = @divisionID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
				group by  tblcallsbilled.InmateID, PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,Rate, PifPaid  
				Order by  tblcallsbilled.InmateID, PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,Rate, PifPaid   
	    else	
		select  tblcallsbilled.InmateID as InmateID, PIN,
			tblcallsbilled.calldate,
			count(CallRevenue ) CallCount, 
			sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
			sum(CallRevenue) CallRevenue, 
			Sum(Pif) as Pif,
			Rate,  
			CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,
			 (tblCommrateAgent.CommRate * 100) as CommRate ,  
				(CASE PifPaid  
				when 
					0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
				Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0)  - sum(Pif) )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
				from tblcallsbilled with(nolock), tblCommRateAgent with(nolock),  tblBadDebt with(nolock)  where 
									tblcallsbilled.agentID = @AgentID and   
									
									 tblcallsBilled.errorcode = '0' and 
									tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
									tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
									 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
								 	
									
									tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
									tblcallsbilled.billtype =  tblBadDebt.billtype and
									  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
									  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
									 (RecordDate between @fromDate and dateadd(d,1,@toDate) ) and convert (int,duration ) >5 
									and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				group by  tblcallsbilled.InmateID, PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,Rate, PifPaid  
				Order by  tblcallsbilled.InmateID, PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,Rate, PifPaid  

 End
Else
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) = 0
 Begin
	If(@InmateID <> '')
	    If @divisionID > 0
		select  tblCallsBilled.InmateID as InmateID, tblCallsBilled.PIN, tblcallsbilled.calldate,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblInmate with(nolock)  where 
							tblcallsbilled.FacilityID=  tblInmate.FacilityID and   
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblInmate.InmateID <>  '0' and
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblcallsbilled.InmateID = tblInmate.InmateID and
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID=  @divisionID and  
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblcallsbilled.InmateID	= @InmateID and convert (int,duration ) >5  
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblCallsBilled.InmateID, tblCallsBilled.PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
		Order by  tblCallsBilled.InmateID, tblCallsBilled.PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
	    else
		select  tblCallsBilled.InmateID as InmateID, tblCallsBilled.PIN, tblcallsbilled.calldate,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblInmate with(nolock)  where 
							tblcallsbilled.FacilityID=  tblInmate.FacilityID and   
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblInmate.InmateID <>  '0' and
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblcallsbilled.InmateID = tblInmate.InmateID and
							tblcallsbilled.agentID = @agentID and
							
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblcallsbilled.InmateID	= @InmateID and convert (int,duration ) >5  
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblCallsBilled.InmateID, tblCallsBilled.PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
		Order by  tblCallsBilled.InmateID, tblCallsBilled.PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
	
	Else
	    If @divisionID > 0
		select  tblCallsBilled.InmateID as InmateID, tblCallsBilled.PIN, tblcallsbilled.calldate,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblInmate with(nolock)  where 
							tblcallsbilled.FacilityID=  tblInmate.FacilityID and   
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblInmate.InmateID <>  '0' and
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblcallsbilled.InmateID = tblInmate.InmateID and
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID=  @divisionID and 
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblCallsBilled.InmateID, tblCallsBilled.PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,BadDebtRate, PifPaid    
		Order by  tblCallsBilled.InmateID, tblCallsBilled.PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,BadDebtRate, PifPaid   

	    else
		select  tblcallsbilled.InmateID as InmateID, tblcallsbilled.PIN, tblcallsbilled.calldate,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblInmate with(nolock)  where 
							tblcallsbilled.FacilityID=  tblInmate.FacilityID and   
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and
							tblInmate.InmateID <>  '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblcallsbilled.InmateID = tblInmate.InmateID and
							tblcallsbilled.agentID = @agentID and
							
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblcallsbilled.InmateID, tblcallsbilled.PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,BadDebtRate, PifPaid    
		Order by  tblcallsbilled.InmateID, tblcallsbilled.PIN, tblcallsbilled.calldate,tblCommRateAgent.CommRate,BadDebtRate, PifPaid   

 End
Else
If (@facilityID > 0)
 Begin
	If(@InmateID <> '')
	
		--select  tblInmate.InmateID as InmateID,tblcallsbilled.calldate,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,BadDebtRate,  
		--CAST ((sum(CallRevenue) * BadDebtRate) as numeric(7,2))  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		--(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
			--	      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		select  tblcallsbilled.InmateID as InmateID, tblcallsbilled.PIN, tblcallsbilled.calldate, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, 0  as Pif,0 BadDebtRate,  
		0  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock), tblInmate with(nolock)  where 
							tblcallsbilled.FacilityID=  tblInmate.FacilityID and   
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblcallsbilled.InmateID = tblInmate.InmateID and
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  
							tblcallsbilled.InmateID	= @InmateID and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		group by  tblcallsbilled.InmateID, tblcallsbilled.PIN, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid  
		Order by  tblcallsbilled.InmateID, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid  
	
	Else
		
		--select  tblInmate.InmateID as InmateID,tblcallsbilled.calldate,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,BadDebtRate,  
		--CAST ((sum(CallRevenue) * BadDebtRate) as numeric(7,2))  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		--(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate )   * tblCommrate.CommRate)  as numeric(7,2) )  
			--	      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * BadDebtRate  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		select  tblcallsbilled.InmateID as InmateID, tblcallsbilled.PIN, tblcallsbilled.calldate, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, 0  as Pif,0 BadDebtRate,  
		0  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock), tblInmate with(nolock)  where 
							tblcallsbilled.FacilityID=  tblInmate.FacilityID and  
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblcallsbilled.InmateID = tblInmate.InmateID and
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							  convert (int,duration ) >5
							 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by tblcallsbilled.InmateID, tblcallsbilled.PIN, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid  
		Order by  tblcallsbilled.InmateID, tblcallsbilled.PIN, tblcallsbilled.calldate,tblCommRate.CommRate,BadDebtRate, PifPaid
 End
