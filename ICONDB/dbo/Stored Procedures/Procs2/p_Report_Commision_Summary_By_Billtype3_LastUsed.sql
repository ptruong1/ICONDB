CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_By_Billtype3_LastUsed]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@billtype	varchar(2),
@divisionID	int
AS
--SET @billtype = isnull(@billtype,'')
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0
 Begin 
	If(@billtype	<> '')
	    If @divisionID > 0
		
			select tblFacility.Location, tblbilltype.Descript as Billtype,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,  
			CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0)  - sum(Pif) -Sum(NIF) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock),  tblBilltype with(nolock) , tblCommrateAgent with(nolock) , tblBadDebt with(nolock) ,tblFacility with(nolock) where 
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								tblcallsbilled.Billtype = tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype =tblCommrateAgent.Calltype and 
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.FacilityID =  @divisionID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsbilled.Billtype = @billtype and 
								 convert (int,duration ) >5      and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0)
			group by  tblFacility.Location,  tblbilltype.Descript, tblCommrateAgent.CommRate,Rate,PifPaid 
			Order by  tblFacility.Location, tblbilltype.Descript,tblCommrateAgent.CommRate,Rate,PifPaid  
		
	    else
		
			select tblFacility.Location, tblbilltype.Descript as Billtype,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,  
			CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull( Rate,0)  - sum(Pif) -Sum(NIF) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock),  tblBilltype with(nolock) , tblCommrateAgent with(nolock) , tblBadDebt with(nolock) ,tblFacility with(nolock) where 
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								tblcallsbilled.Billtype = tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype =tblCommrateAgent.Calltype and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsbilled.Billtype = @billtype and 
								 convert (int,duration ) >5      and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0)
			group by  tblFacility.Location,  tblbilltype.Descript, tblCommrateAgent.CommRate,Rate,PifPaid 
			Order by  tblFacility.Location, tblbilltype.Descript,tblCommrateAgent.CommRate,Rate,PifPaid  
		 
	
	else -- BillType = ''
	     If @divisionID > 0
		
			select  tblFacility.Location, tblbilltype.Descript as Billtype,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,  
			CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull(Rate,0)  - sum(Pif) -Sum(NIF))   * tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock),  tblBilltype with(nolock) , tblCommrateAgent with(nolock), tblBadDebt with(nolock)  ,tblFacility with(nolock) where
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								tblcallsbilled.Billtype = tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype =tblCommrateAgent.Calltype and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.FacilityID =  @divisionID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5      and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0)
			group by  tblFacility.Location,  tblbilltype.Descript, tblCommrateAgent.CommRate,Rate,PifPaid 
			Order by  tblFacility.Location, tblbilltype.Descript,tblCommrateAgent.CommRate,Rate,PifPaid  
		
	     else
		
			select  tblFacility.Location, tblbilltype.Descript as Billtype,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,Rate,  
			CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) * isnull(Rate,0)  - sum(Pif) -Sum(NIF))   * tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock),  tblBilltype with(nolock) , tblCommrateAgent with(nolock), tblBadDebt with(nolock)  ,tblFacility with(nolock) where
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.agentID = @agentID and
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								tblcallsbilled.Billtype = tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype =tblCommrateAgent.Calltype and 
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5      and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0)
			group by  tblFacility.Location,  tblbilltype.Descript, tblCommrateAgent.CommRate,Rate,PifPaid 
			Order by  tblFacility.Location, tblbilltype.Descript,tblCommrateAgent.CommRate,Rate,PifPaid  
		

 End 
Else
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) = 0
 Begin 

	If(@billtype	<> '')
	    If @divisionID > 0
		select tblFacility.Location, tblbilltype.Descript as Billtype,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,  
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid

		from tblcallsbilled with(nolock),  tblBilltype with(nolock) , tblCommrateAgent with(nolock)  ,tblFacility with(nolock) where 
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype = tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =tblCommrateAgent.Calltype and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							tblcallsbilled.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsbilled.Billtype = @billtype and 
							 convert (int,duration ) >5      and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0)
		group by tblFacility.Location,tblbilltype.Descript, tblCommrateAgent.CommRate,BadDebtRate,PifPaid 
		Order by tblFacility.Location, tblbilltype.Descript,tblCommrateAgent.CommRate,Rate,BadDebtRate,PifPaid 
	    else
		select tblFacility.Location, tblbilltype.Descript as Billtype,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,  
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid

		from tblcallsbilled with(nolock),  tblBilltype with(nolock) , tblCommrateAgent with(nolock)  ,tblFacility with(nolock) where 
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype = tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =tblCommrateAgent.Calltype and 
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsbilled.Billtype = @billtype and 
							  convert (int,duration ) >5      and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0)
		group by tblFacility.Location,tblbilltype.Descript, tblCommrateAgent.CommRate,BadDebtRate,PifPaid 
		Order by tblFacility.Location, tblbilltype.Descript,tblCommrateAgent.CommRate,Rate,BadDebtRate,PifPaid 
	
	else --- BillType = ''
	     If @divisionID > 0
		select tblFacility.Location,  tblbilltype.Descript as Billtype,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid

		from tblcallsbilled with(nolock),  tblBilltype with(nolock) , tblCommrateAgent with(nolock)   ,tblFacility with(nolock) where  
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype = tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =tblCommrateAgent.Calltype and
							 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							 tblcallsbilled.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
							  convert (int,duration ) >5      and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0)
		group by tblFacility.Location, tblbilltype.Descript, tblCommrateAgent.CommRate,BadDebtRate,PifPaid 
		Order by tblFacility.Location,tblbilltype.Descript,tblCommrateAgent.CommRate,Rate,BadDebtRate,PifPaid
	     else
		select tblFacility.Location,  tblbilltype.Descript as Billtype,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,'0' BadDebtRate, 0 as Rate,
		'0'  as BadDebt,  (tblCommrateAgent.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrateAgent.CommRate) as Numeric(12,4))      as CommPaid

		from tblcallsbilled with(nolock),  tblBilltype with(nolock) , tblCommrateAgent with(nolock)   ,tblFacility with(nolock) where  
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype = tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =tblCommrateAgent.Calltype and
							 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
							  convert (int,duration ) >5      and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0)
		group by tblFacility.Location, tblbilltype.Descript, tblCommrateAgent.CommRate,BadDebtRate,PifPaid 
		Order by tblFacility.Location,tblbilltype.Descript,tblCommrateAgent.CommRate,Rate,BadDebtRate,PifPaid 
	
 End 
Else
If ( @facilityID > 0 )
 Begin 

  	If(@billtype	<> '')
		select tblbilltype.Descript as Billtype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif,0 BadDebtRate,  
		0 as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		--(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0) )   * tblCommrate.CommRate)  as numeric(7,2) )  
			--	      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0)  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock),  tblBilltype with(nolock) , tblcommrate with(nolock) where 
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and  
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsbilled.Billtype = @billtype and 
							  convert (int,duration ) >5      and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0)
		group by tblbilltype.Descript, tblcommrate.CommRate,BadDebtRate,PifPaid 
		Order by  tblbilltype.Descript,tblcommrate.CommRate,BadDebtRate,PifPaid 
	
	else
		select tblbilltype.Descript as Billtype,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif, 0 BadDebtRate,  
		0  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		--(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0) )   * tblCommrate.CommRate)  as numeric(7,2) )  
			--	      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( BadDebtRate,0)  - sum(Pif) )   *tblCommrate.CommRate)  as numeric(7,2) )  + sum(Pif)    end) as CommPaid
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock),  tblBilltype with(nolock) , tblcommrate with(nolock) where 
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and
							tblcallsbilled.facilityID	= @facilityID  And
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and	
							--tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							 convert (int,duration ) >5     and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0) 
		group by  tblbilltype.Descript, tblcommrate.CommRate,BadDebtRate,PifPaid 
		Order by  tblbilltype.Descript,tblcommrate.CommRate,BadDebtRate,PifPaid

 End
