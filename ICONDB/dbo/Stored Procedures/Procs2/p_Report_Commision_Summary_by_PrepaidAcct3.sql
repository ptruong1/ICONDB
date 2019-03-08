CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_PrepaidAcct3]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@AccountNo	varchar(10),
@divisionID	int
AS

If (@AgentId >1 AND @facilityID =0 ) 
if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
 Begin
	If(@AccountNo <> '')
	    If @divisionID > 0
		select  tblPrepaid.PhoneNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,	'0'  as BadDebt,   
		CAST ((sum(CallRevenue   * tblCommrateAgent.CommRate)) as Numeric(12,4))      as CommPaid, tblfacility.State
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblPrepaid with(nolock), tblfacility  where
							tblCallsBilled.facilityID = tblfacility.FacilityID and  
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
		group by  tblPrepaid.PhoneNo, tblfacility.State  
		Order by  tblPrepaid.PhoneNo, tblfacility.State  
	    else
		select  tblPrepaid.PhoneNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
		 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, '0'  as BadDebt,    
		CAST ((sum(CallRevenue   * tblCommrateAgent.CommRate)) as Numeric(12,4))      as CommPaid, tblfacility.State
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblPrepaid with(nolock), tblFacility  where 
							tblCallsBilled.facilityID = tblfacility.FacilityID and 
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							tblcallsbilled.billtype = '10' and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and  
						 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and							  
							tblcallsbilled.agentID = @agentID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblPrepaid.PhoneNo = @AccountNo and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblPrepaid.PhoneNo, tblfacility.State  
		Order by  tblPrepaid.PhoneNo, tblfacility.State  
	
	Else
	     If @divisionID > 0
		select tblPrepaid.PhoneNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,	'0'  as BadDebt,   
		CAST ((sum(CallRevenue   * tblCommrateAgent.CommRate)) as Numeric(12,4))      as CommPaid, tblfacility.State
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblPrepaid with(nolock), tblFacility  where
							tblCallsBilled.facilityID = tblfacility.FacilityID and  
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
		group by  tblPrepaid.PhoneNo, tblfacility.State  
		Order by  tblPrepaid.PhoneNo, tblfacility.State  
	     else
		select tblPrepaid.PhoneNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,	'0'  as BadDebt,   
		CAST ((sum(CallRevenue   * tblCommrateAgent.CommRate)) as Numeric(12,4))      as CommPaid, tblfacility.State
		from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblPrepaid with(nolock) , tblFacility
			 where  tblcallsBilled.AgentID = @AgentID and 
			   tblcallsBilled.errorcode = '0' and  
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.billtype = '10' and
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblPrepaid.FacilityID = tblCallsBilled.FacilityID and
				tblPrepaid.PhoneNo = tblcallsBilled.billtono   and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				   convert (int,duration ) >5  
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		group by  tblPrepaid.PhoneNo, tblfacility.State  
		Order by  tblPrepaid.PhoneNo, tblfacility.State  
 End
 else --No tblcommrateAgent, use tblcommrate
Begin
If(@AccountNo <> '')
	    If @divisionID > 0
		select  tblPrepaid.PhoneNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,	'0'  as BadDebt,    
		CAST ((sum(CallRevenue   * tblCommrate.CommRate)) as Numeric(12,4))      as CommPaid, tblfacility.State
		from tblcallsbilled with(nolock), tblCommrate with(nolock), tblPrepaid with(nolock), tblfacility  where
							tblCallsBilled.facilityID = tblfacility.FacilityID and  
							tblcallsbilled.AgentID = tblCommrate.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							tblcallsbilled.billtype = '10' and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and							  
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID = @divisionID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblPrepaid.PhoneNo = @AccountNo and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblPrepaid.PhoneNo, tblfacility.State  
		Order by  tblPrepaid.PhoneNo, tblfacility.State   
	    else
		select  tblPrepaid.PhoneNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, 
		Sum(Pif) as Pif, '0'  as BadDebt,   
		CAST ((sum(CallRevenue   * tblCommrate.CommRate)) as Numeric(12,4))      as CommPaid, tblfacility.State
		from tblcallsbilled with(nolock), tblCommrate with(nolock), tblPrepaid with(nolock), tblFacility  where 
							tblCallsBilled.facilityID = tblfacility.FacilityID and 
							tblcallsbilled.AgentID = tblCommrate.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							tblcallsbilled.billtype = '10' and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and							  
							tblcallsbilled.agentID = @agentID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblPrepaid.PhoneNo = @AccountNo and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblPrepaid.PhoneNo, tblfacility.State  
		Order by  tblPrepaid.PhoneNo, tblfacility.State
	
	Else
	     If @divisionID > 0
		select tblPrepaid.PhoneNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
		 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,	'0'  as BadDebt,   
		CAST ((sum(CallRevenue   * tblCommrate.CommRate)) as Numeric(12,4))      as CommPaid, tblfacility.State
		from tblcallsbilled with(nolock), tblCommrate with(nolock), tblPrepaid with(nolock), tblFacility  where
							tblCallsBilled.facilityID = tblfacility.FacilityID and  
							tblcallsbilled.AgentID = tblCommrate.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and 							 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.billtype = '10' and
							tblcallsbilled.FacilityID = @divisionID and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblPrepaid.PhoneNo, tblfacility.State  
		Order by  tblPrepaid.PhoneNo, tblfacility.State  
	     else
		select tblPrepaid.PhoneNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,	'0'  as BadDebt,   
		CAST ((sum(CallRevenue   * tblCommrate.CommRate)) as Numeric(12,4))      as CommPaid, tblfacility.State
		from tblcallsbilled with(nolock), tblCommrate with(nolock), tblPrepaid with(nolock) , tblFacility
			 where  tblcallsBilled.AgentID = @AgentID and 
			   tblcallsBilled.errorcode = '0' and  
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.billtype = '10' and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblPrepaid.FacilityID = tblCallsBilled.FacilityID and
				tblPrepaid.PhoneNo = tblcallsBilled.billtono   and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				   convert (int,duration ) >5  
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		group by  tblPrepaid.PhoneNo, tblfacility.State  
		Order by  tblPrepaid.PhoneNo, tblfacility.State  
 End

Else

If (@facilityID > 0)
 Begin
	If(@AccountNo <> '')
	
		select tblPrepaid.PhoneNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
		 sum(CallRevenue) CallRevenue, 0 as Pif, 0 as BadDebt,   
		CAST ((sum(CallRevenue   * tblCommrate.CommRate)) as Numeric(12,4))      as CommPaid, tblfacility.State
		from tblcallsbilled with(nolock), tblCommRate with(nolock), tblPrepaid, tblFacility with(nolock)  where  
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and 							
							tblcallsbilled.facilityID	= @facilityID  And
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.billtype = '10' and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblPrepaid.PhoneNo = @AccountNo  and convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblPrepaid.PhoneNo, tblfacility.State  
		Order by  tblPrepaid.PhoneNo, tblfacility.State
	
	Else
		
		select tblPrepaid.PhoneNo as AccountNo,count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, 0 as BadDebt,  
		 
		CAST ((sum(CallRevenue   * tblCommrate.CommRate)) as Numeric(12,4))      as CommPaid, tblfacility.State
		from tblcallsbilled with(nolock), tblCommRate with(nolock), tblPrepaid with(nolock), tblFacility with(nolock)  where  
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
						 	tblPrepaid.PhoneNo = tblcallsBilled.billtono  and							  
							tblcallsbilled.facilityID	= @facilityID  And
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.billtype = '10' and
							 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							  convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblPrepaid.PhoneNo, tblfacility.State  
		Order by  tblPrepaid.PhoneNo, tblfacility.State 
 End
