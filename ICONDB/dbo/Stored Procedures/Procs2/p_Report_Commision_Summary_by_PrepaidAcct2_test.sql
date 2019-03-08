CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_PrepaidAcct2_test]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@AccountNo	varchar(10),
@divisionID	int
AS
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0
 Begin
	If(@AccountNo <> '')
	    If @divisionID > 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select   tblcallsBilled.billtono as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,  
			CAST ((sum(CallRevenue) * isnull( Rate,0)) as numeric(7,2))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(7,2) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0)  - sum(Pif) )   *tblCommrateAgent.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblPrepaid with(nolock), tblBadDebt with(nolock)  where  
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
							 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								tblcallsbilled.billtype =  tblBadDebt.billtype and
								tblcallsbilled.billtype = '10' and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID = @divisionID and
								 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblPrepaid.PhoneNo = @AccountNo and convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by   tblcallsBilled.billtono, tblCommRateAgent.CommRate,Rate, PifPaid  
			Order by   tblcallsBilled.billtono, tblCommRateAgent.CommRate,Rate, PifPaid  
		else
			select   tblcallsBilled.billtono as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,  
			CAST ((sum(CallRevenue) * isnull( Rate,0)) as numeric(7,2))  as BadDebt, (tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrate.CommRate)  as numeric(7,2) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0)  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRate with(nolock), tblPrepaid with(nolock), tblBadDebt with(nolock)  where  
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and  
								tblcallsbilled.FacilityID =  tblCommrate.FacilityID and
							 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								tblcallsbilled.billtype =  tblBadDebt.billtype and
								tblcallsbilled.billtype = '10' and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID = @divisionID and
								 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblPrepaid.PhoneNo = @AccountNo and convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by   tblcallsBilled.billtono, tblCommRate.CommRate,Rate, PifPaid  
			Order by   tblcallsBilled.billtono, tblCommRate.CommRate,Rate, PifPaid  
	    else
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select   tblcallsBilled.billtono as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,  
			CAST ((sum(CallRevenue) * isnull( Rate,0)) as numeric(7,2))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(7,2) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0)  - sum(Pif) )   *tblCommrateAgent.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblPrepaid with(nolock), tblBadDebt with(nolock)  where  
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
							 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								tblcallsbilled.billtype =  tblBadDebt.billtype and
								tblcallsbilled.billtype = '10' and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblPrepaid.PhoneNo = @AccountNo and convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by   tblcallsBilled.billtono, tblCommRateAgent.CommRate,Rate, PifPaid  
			Order by   tblcallsBilled.billtono, tblCommRateAgent.CommRate,Rate, PifPaid  
		else
			select   tblcallsBilled.billtono as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,  
			CAST ((sum(CallRevenue) * isnull( Rate,0)) as numeric(7,2))  as BadDebt, (tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrate.CommRate)  as numeric(7,2) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0)  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRate with(nolock), tblPrepaid with(nolock), tblBadDebt with(nolock)  where  
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and  
								tblcallsbilled.FacilityID =  tblCommrate.FacilityID and
							 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								tblcallsbilled.billtype =  tblBadDebt.billtype and
								tblcallsbilled.billtype = '10' and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblPrepaid.PhoneNo = @AccountNo and convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by   tblcallsBilled.billtono, tblCommRate.CommRate,Rate, PifPaid  
			Order by   tblcallsBilled.billtono, tblCommRate.CommRate,Rate, PifPaid  
	
	Else
	    If @divisionID > 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select  tblcallsBilled.billtono as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,
			CAST ((sum(CallRevenue) * isnull( Rate,0)) as numeric(7,2))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(7,2) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) - sum(Pif) )   *tblCommrateAgent.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblPrepaid with(nolock), tblBadDebt with(nolock)  where  
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
							 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and 							 
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								tblcallsbilled.billtype =  tblBadDebt.billtype and
								tblcallsbilled.billtype = '10' and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID = @divisionID and
								 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by   tblcallsBilled.billtono, tblCommRateAgent.CommRate,Rate, PifPaid  
			Order by   tblcallsBilled.billtono, tblCommRateAgent.CommRate,Rate, PifPaid
		else
			select  tblcallsBilled.billtono as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,
			CAST ((sum(CallRevenue) * isnull( Rate,0)) as numeric(7,2))  as BadDebt, (tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrate.CommRate)  as numeric(7,2) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRate with(nolock), tblPrepaid with(nolock), tblBadDebt with(nolock)  where  
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and  
								tblcallsbilled.FacilityID =tblCommrate.FacilityID and		
							 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and 					 
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								tblcallsbilled.billtype =  tblBadDebt.billtype and
								tblcallsbilled.billtype = '10' and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID = @divisionID and
								 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by   tblcallsBilled.billtono, tblCommRate.CommRate,Rate, PifPaid  
			Order by   tblcallsBilled.billtono, tblCommRate.CommRate,Rate, PifPaid
	    else
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select  tblcallsBilled.billtono as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,
			CAST ((sum(CallRevenue) * isnull( Rate,0)) as numeric(7,2))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(7,2) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) - sum(Pif) )   *tblCommrateAgent.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblPrepaid with(nolock), tblBadDebt with(nolock)  where  
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
							 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and 							 
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								tblcallsbilled.billtype =  tblBadDebt.billtype and
								tblcallsbilled.billtype = '10' and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by   tblcallsBilled.billtono, tblCommRateAgent.CommRate,Rate, PifPaid  
			Order by   tblcallsBilled.billtono, tblCommRateAgent.CommRate,Rate, PifPaid  
		else
			select  tblcallsBilled.billtono as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,
			CAST ((sum(CallRevenue) * isnull( Rate,0)) as numeric(7,2))  as BadDebt, (tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrate.CommRate)  as numeric(7,2) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRate with(nolock), tblPrepaid with(nolock), tblBadDebt with(nolock)  where  
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and 
								tblcallsbilled.FacilityID =  tblCommrate.FacilityID and 
							 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and 	
														 
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								tblcallsbilled.billtype =  tblBadDebt.billtype and
								tblcallsbilled.billtype = '10' and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by   tblcallsBilled.billtono, tblCommRate.CommRate,Rate, PifPaid  
			Order by   tblcallsBilled.billtono, tblCommRate.CommRate,Rate, PifPaid  
 End
Else
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) = 0
 Begin
	If(@AccountNo <> '')
	    If @divisionID > 0
		select  tblPrepaid.PhoneNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,  
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblPrepaid with(nolock)  where  
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							tblcallsbilled.billtype = '10' and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and							  
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID = @divisionID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblPrepaid.PhoneNo = @AccountNo and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblPrepaid.PhoneNo, tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
		Order by  tblPrepaid.PhoneNo, tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
	    else
		select  tblPrepaid.PhoneNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,  
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblPrepaid with(nolock)  where  
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							tblcallsbilled.billtype = '10' and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and							  
							tblcallsbilled.agentID = @agentID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblPrepaid.PhoneNo = @AccountNo and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblPrepaid.PhoneNo, tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
		Order by  tblPrepaid.PhoneNo, tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
	
	Else
	     If @divisionID > 0
		select tblPrepaid.PhoneNo as AccountNo,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblPrepaid with(nolock)  where  
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and 							 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.billtype = '10' and
							tblcallsbilled.FacilityID = @divisionID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblPrepaid.PhoneNo, tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
		Order by  tblPrepaid.PhoneNo, tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
	     else
		select tblPrepaid.PhoneNo as AccountNo,count(CallRevenue ) CallCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblPrepaid with(nolock)  where  
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and 							 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.billtype = '10' and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblPrepaid.PhoneNo, tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
		Order by  tblPrepaid.PhoneNo, tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
 End
Else
If (@facilityID > 0)
 Begin
	If(@AccountNo <> '')
	
		select tblPrepaid.PhoneNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif,0 BadDebtRate,  
		0 as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock), tblPrepaid with(nolock)  where  
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and 							
							tblcallsbilled.facilityID	= @facilityID  And
							tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblPrepaid.PhoneNo = @AccountNo  and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblPrepaid.PhoneNo, tblCommRate.CommRate,BadDebtRate, PifPaid  
		Order by  tblPrepaid.PhoneNo, tblCommRate.CommRate,BadDebtRate, PifPaid  
	
	Else
		
		select tblPrepaid.PhoneNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,BadDebtRate,  
		CAST ((sum(CallRevenue) * BadDebtRate) as numeric(7,2))  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock), tblPrepaid with(nolock)  where  
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and							  
							tblcallsbilled.facilityID	= @facilityID  And
							tblcallsbilled.agentID = @agentID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							 CAST (ResponseCode as int) < 100  and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblPrepaid.PhoneNo, tblCommRate.CommRate,BadDebtRate, PifPaid  
		Order by  tblPrepaid.PhoneNo,tblCommRate.CommRate,BadDebtRate, PifPaid  
 End
