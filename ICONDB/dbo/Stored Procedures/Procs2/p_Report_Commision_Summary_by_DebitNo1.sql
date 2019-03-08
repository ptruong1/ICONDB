CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_DebitNo1]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@AccountNo	varchar(12),
@divisionID	int
AS
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0
 Begin
	If(@AccountNo <> '')
	    If @divisionID > 0
		select  tblDebit.AccountNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,  
		CAST ((sum(CallRevenue) * isnull( Rate,0)) as numeric(7,2))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0)  - sum(Pif) )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblDebit with(nolock), tblBadDebt with(nolock)  where  
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
							--tblcallsbilled.Billtype = '07' and
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblDebit.FacilityID and
							tblcallsBilled.CreditcardNo	= @AccountNo and
							tblcallsbilled.FacilityID = @divisionID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and  convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblDebit.AccountNo, tblCommRateAgent.CommRate,Rate, PifPaid  
		Order by  tblDebit.AccountNo, tblCommRateAgent.CommRate,Rate, PifPaid  
	    else
		select  tblDebit.AccountNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,  
		CAST ((sum(CallRevenue) * isnull( Rate,0)) as numeric(7,2))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0)  - sum(Pif) )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblDebit with(nolock), tblBadDebt with(nolock)  where  
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
							--tblcallsbilled.Billtype = '07' and
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblDebit.FacilityID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.CreditcardNo	= @AccountNo and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblDebit.AccountNo, tblCommRateAgent.CommRate,Rate, PifPaid  
		Order by  tblDebit.AccountNo, tblCommRateAgent.CommRate,Rate, PifPaid  
	
	Else
	     If @divisionID > 0
		select  tblDebit.AccountNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, Rate,  
		CAST ((sum(CallRevenue) * isnull( Rate,0)) as numeric(7,2))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0)  - sum(Pif) )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblDebit with(nolock), tblBadDebt with(nolock)  where  
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblDebit.FacilityID and
							tblcallsbilled.FacilityID = @divisionID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblDebit.AccountNo, tblCommRateAgent.CommRate, Rate, PifPaid  
		Order by  tblDebit.AccountNo, tblCommRateAgent.CommRate, Rate, PifPaid  
	     else		
		select  tblDebit.AccountNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, Rate,  
		CAST ((sum(CallRevenue) * isnull( Rate,0)) as numeric(7,2))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
		(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
				      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0)  - sum(Pif) )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblDebit with(nolock), tblBadDebt with(nolock)  where  
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							 tblcallsbilled.FacilityID =  tblDebit.FacilityID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblDebit.AccountNo, tblCommRateAgent.CommRate, Rate, PifPaid  
		Order by  tblDebit.AccountNo, tblCommRateAgent.CommRate, Rate, PifPaid  
 End
Else
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) = 0
 Begin
	If(@AccountNo <> '')
	    If @divisionID > 0
		select  tblDebit.AccountNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate, 
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid

		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblDebit with(nolock) where  
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and   
						 	tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
							tblcallsbilled.FacilityID =  tblDebit.FacilityID and
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID = @divisionID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.CreditcardNo	= @AccountNo and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblDebit.AccountNo, tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
		Order by  tblDebit.AccountNo, tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
	    else
		select  tblDebit.AccountNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate, 
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid

		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblDebit with(nolock) where  
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and     
						 	tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
							tblcallsbilled.FacilityID =  tblDebit.FacilityID and
							tblcallsbilled.agentID = @agentID and
							
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.CreditcardNo	= @AccountNo and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblDebit.AccountNo, tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
		Order by  tblDebit.AccountNo, tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
	
	Else
	     If @divisionID > 0
		select  tblDebit.AccountNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate, 
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid

		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblDebit with(nolock) where  
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and   
						 	tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
							tblcallsbilled.FacilityID =  tblDebit.FacilityID and
							tblcallsbilled.agentID = @agentID and
							
							tblcallsbilled.FacilityID = @divisionID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblDebit.AccountNo, tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
		Order by  tblDebit.AccountNo, tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
	     else
		select  tblDebit.AccountNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate, 
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid

		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblDebit with(nolock) where  
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and   
						 	tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
							tblcallsbilled.FacilityID =  tblDebit.FacilityID and
							tblcallsbilled.agentID = @agentID and
							
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblDebit.AccountNo, tblCommRateAgent.CommRate,BadDebtRate, PifPaid  
		Order by  tblDebit.AccountNo, tblCommRateAgent.CommRate,BadDebtRate, PifPaid   
 End
Else
If (@facilityID > 0)
 Begin
	If(@AccountNo <> '')
	
		select  tblDebit.AccountNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif,0 BadDebtRate,  
		0 as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock), tblDebit with(nolock)  where  
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblcallsBilled.CreditcardNo	= @AccountNo and convert (int,duration ) >5 
		group by  tblDebit.AccountNo, tblCommRate.CommRate,BadDebtRate, PifPaid  
		Order by  tblDebit.AccountNo, tblCommRate.CommRate,BadDebtRate, PifPaid  
	
	Else
		
		select  tblDebit.AccountNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,BadDebtRate,  
		CAST ((sum(CallRevenue) * BadDebtRate) as numeric(7,2))  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock), tblDebit with(nolock)  where  
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							  convert (int,duration ) >5 
		group by  tblDebit.AccountNo, tblCommRate.CommRate,BadDebtRate, PifPaid  
		Order by  tblDebit.AccountNo, tblCommRate.CommRate,BadDebtRate, PifPaid
 End
