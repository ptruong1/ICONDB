CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_PIN4]

@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@Pin	varchar(12),
@DivisionID       int
AS

declare @InmateID varchar(12) = ''
 IF  @PIN	<> ''
	select @InmateID = (InmateID) from tblInmate where FacilityId = @FacilityID and PIN = @PIN
	
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0
 Begin 
	If(@PIN <> '')
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			If @DivisionID > 0
			select  InmateID, PIN,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, Rate,  
			CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF)  )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.agentID = @agentID and
								
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and InmateID = @InmateID  
								and  tblcallsbilled.FacilityID = @DivisionID
								
			group by InmateID,  PIN, tblCommrateAgent.CommRate,Rate, PifPaid 
			Order by InmateID,  PIN, tblCommrateAgent.CommRate,Rate ,PifPaid
			Else --- DivisionId = 0
			select  InmateID, PIN,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, Rate,  
			CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF)  )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.agentID = @agentID and
								
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and InmateID = @InmateID 
								----and  tblcallsbilled.FacilityID = @DivisionID
								
			group by InmateID,  PIN, tblCommrateAgent.CommRate,Rate, PifPaid 
			Order by InmateID,  PIN, tblCommrateAgent.CommRate,Rate ,PifPaid
		else --- CommRateAgent not found
		 If @DivisionID > 0
			select  InmateID, PIN, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, Rate,  
			CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt, (tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   * tblCommrate.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF)  )   *tblCommrate.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRate with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								 tblcallsbilled.FacilityID =tblCommrate.FacilityID and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and InmateID = @InmateID 
								and  tblcallsbilled.FacilityID = @DivisionID
								 
			group by InmateID,  PIN, tblCommrate.CommRate,Rate, PifPaid 
			Order by InmateID,  PIN, tblCommrate.CommRate,Rate ,PifPaid
			Else --- DivisionID = 0
			select  InmateID, PIN, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, Rate,  
			CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt, (tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   * tblCommrate.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF)  )   *tblCommrate.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRate with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								 tblcallsbilled.FacilityID =tblCommrate.FacilityID and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and InmateID = @InmateID 
								---- and  tblcallsbilled.FacilityID = @DivisionID
								 
			group by InmateID,  PIN, tblCommrate.CommRate,Rate, PifPaid 
			Order by InmateID,  PIN, tblCommrate.CommRate,Rate ,PifPaid
	Else ---PIN = ''
	
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		 If @DivisionID > 0
			select  InmateID, PIN,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, Rate,  
			CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF)  )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )   and
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and tblcallsbilled.FacilityID =  @DivisionID
								 
			group by InmateID,  PIN, tblCommrateAgent.CommRate,Rate, PifPaid 
			Order by InmateID,  PIN, tblCommrateAgent.CommRate,Rate ,PifPaid 
			Else -- Dvision = 0
			select  InmateID, PIN,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, Rate,  
			CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF)  )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )   and
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								----and tblcallsbilled.FacilityID =  @DivisionID
								 
			group by InmateID,  PIN, tblCommrateAgent.CommRate,Rate, PifPaid 
			Order by InmateID,  PIN, tblCommrateAgent.CommRate,Rate ,PifPaid 
		else ---CommRateAgent Not found
		If @DivisionID > 0
			select  InmateID, PIN,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, Rate,  
			CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt, (tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   * tblCommrate.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF)  )   *tblCommrate.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRate with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								 tblcallsbilled.FacilityID = tblCommrate.FacilityID and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )   and
								convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and tblcallsbilled.FacilityID =  @DivisionID
								 
			group by InmateID,  PIN, tblCommrate.CommRate,Rate, PifPaid 
			Order by InmateID,  PIN, tblCommrate.CommRate,Rate ,PifPaid
			Else
			select  InmateID, PIN,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, Rate,  
			CAST ((sum(CallRevenue) *  isnull( Rate,0)) as numeric(12,4))  as BadDebt, (tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0) )   * tblCommrate.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  isnull( Rate,0)  - sum(Pif)  - Sum(NIF)  )   *tblCommrate.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRate with(nolock), tblBadDebt with(nolock),  tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								 tblcallsbilled.FacilityID = tblCommrate.FacilityID and
								tblcallsbilled.agentID = @agentID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) )   and
								convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								--and tblcallsbilled.FacilityID =  @DivisionID
								 
			group by InmateID,  PIN, tblCommrate.CommRate,Rate, PifPaid 
			Order by InmateID,  PIN, tblCommrate.CommRate,Rate ,PifPaid
		End
		
	Else --- 
	If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
	Begin 
	If(@PIN <> '')
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		If @DivisionID > 0
			select  InmateID, PIN,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,   
			CAST ((sum(CallRevenue) *  0) as numeric(12,4))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  0 )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  0  - sum(Pif)  - Sum(NIF)  )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.agentID = @agentID and
								
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and InmateID = @InmateID
								and tblcallsbilled.FacilityID =  @DivisionID
								
			group by InmateID,  PIN, tblCommrateAgent.CommRate, PifPaid 
			Order by InmateID,  PIN, tblCommrateAgent.CommRate, PifPaid
			Else --Division = 0
			select  InmateID, PIN,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,   
			CAST ((sum(CallRevenue) *  0) as numeric(12,4))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  0 )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  0  - sum(Pif)  - Sum(NIF)  )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.agentID = @agentID and
								
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and InmateID = @InmateID
								--and tblcallsbilled.FacilityID =  @DivisionID
								
			group by InmateID,  PIN, tblCommrateAgent.CommRate, PifPaid 
			Order by InmateID,  PIN, tblCommrateAgent.CommRate, PifPaid
		else ---NoCommRateAgent
		 If @DivisionID > 0
			select  InmateID, PIN, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, 
			CAST ((sum(CallRevenue) *  0) as numeric(12,4))  as BadDebt, (tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  0 )   * tblCommrate.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  0  - sum(Pif)  - Sum(NIF)  )   *tblCommrate.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRate with(nolock), tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								 tblcallsbilled.FacilityID =tblCommrate.FacilityID and
								tblcallsbilled.agentID = @agentID and
								 
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and InmateID = @InmateID
								and tblcallsbilled.FacilityID =  @DivisionID 
								
			group by InmateID,  PIN, tblCommrate.CommRate, PifPaid 
			Order by InmateID,  PIN, tblCommrate.CommRate, PifPaid
			else --
			select  InmateID, PIN, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, 
			CAST ((sum(CallRevenue) *  0) as numeric(12,4))  as BadDebt, (tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  0 )   * tblCommrate.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  0  - sum(Pif)  - Sum(NIF)  )   *tblCommrate.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRate with(nolock), tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								 tblcallsbilled.FacilityID =tblCommrate.FacilityID and
								tblcallsbilled.agentID = @agentID and
								 
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and InmateID = @InmateID
								--and tblcallsbilled.FacilityID =  @DivisionID 
								
			group by InmateID,  PIN, tblCommrate.CommRate, PifPaid 
			Order by InmateID,  PIN, tblCommrate.CommRate, PifPaid
	Else ----PIN = 0
	
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		 If @DivisionID > 0
			select  InmateID, PIN,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, 0 Rate,  
			CAST ((sum(CallRevenue) *  0) as numeric(12,4))  as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  0 )   * tblCommrateAgent.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  0  - sum(Pif)  - Sum(NIF)  )   *tblCommrateAgent.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRateAgent with(nolock), tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.agentID = @agentID and
								 
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
								 convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								and tblcallsbilled.FacilityID =  @DivisionID 
								 
			group by InmateID,  PIN, tblCommrateAgent.CommRate, PifPaid 
			Order by InmateID,  PIN, tblCommrateAgent.CommRate, PifPaid
		else ---Division = 0
			select  InmateID, PIN,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,0 Rate,  
			CAST ((sum(CallRevenue) *  0) as numeric(12,4))  as BadDebt, (tblCommrate.CommRate * 100) as CommRate ,  
			(CASE PifPaid  when 0 then CAST (((sum(CallRevenue) - sum(CallRevenue) *  0 )   * tblCommrate.CommRate)  as numeric(12,4) )  
					      Else   CAST (((sum(CallRevenue) - sum(CallRevenue) *  0  - sum(Pif)  - Sum(NIF)  )   *tblCommrate.CommRate)  as numeric(12,4) )  + sum(Pif)    end) as CommPaid
			from tblcallsbilled with(nolock), tblCommRate with(nolock),   tblFacility with(nolock) where 
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								 tblcallsbilled.FacilityID = tblCommrate.FacilityID and
								tblcallsbilled.agentID = @agentID and
								 
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
								convert (int,duration ) >5 
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								--and tblcallsbilled.FacilityID =  @DivisionID 
			group by InmateID,  PIN, tblCommrate.CommRate, PifPaid 
			Order by InmateID,  PIN, tblCommrate.CommRate, PifPaid
	
 End 
	

else
If (@facilityID > 0)
 Begin
 If(@PIN <> '')
	
		select  InmateID, PIN, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, 0  as Pif,0 BadDebtRate,  
		0  as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock)  where 
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							tblcallsbilled.facilityID	= @facilityID  And
							--tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )   and InmateID = @InmateID  and
							 convert (int,duration ) >5 
		group by InmateID,PIN,tblCommrate.CommRate,BadDebtRate, PifPaid 
		Order by InmateID,PIN,tblCommrate.CommRate,BadDebtRate ,PifPaid
	
	Else
	select InmateId
		,PIN
		,sum(CallCount) as CallCount
		, sum(CallDuration)  as CallDuration
		, sum(CallRevenue) CallRevenue
		, (CommRate) as CommRate 
		,  sum(commPaid)      as CommPaid
		,  sum(BadDebt)      as BadDebt
		from
		(select  InmateID, PIN,  1 CallCount, (dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, (CallRevenue) CallRevenue, 0 as Pif, 0 BadDebtRate,  
		0 as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		CAST (((CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		from tblcallsbilled with(nolock), tblCommRate with(nolock)  where 
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							tblcallsbilled.facilityID	= @facilityID  And
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							  convert (int,duration ) >5
							 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
								 )
		
							   as X
	
						    
		group by X.InmateID,PIN, X.Commrate
		Order by X.InmateID,PIN, X.Commrate
		--select  InmateID, PIN,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, 0 as Pif, 0 BadDebtRate,  
		--0 as BadDebt,  (tblCommrate.CommRate * 100) as CommRate ,  
		--CAST ((sum(CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2))      as CommPaid
		--from tblcallsbilled with(nolock), tblCommRate with(nolock)  where 
		--					tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
		--					 tblcallsBilled.errorcode = '0' and 
		--					tblcallsbilled.Billtype =  tblCommrate.billtype and
		--					 tblcallsbilled.Calltype = tblCommrate.Calltype and
		--					tblcallsbilled.facilityID	= @facilityID  And
		--					--tblcallsbilled.agentID = @agentID and
		--					(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
		--					  convert (int,duration ) >5 
		--group by InmateID,PIN,tblCommrate.CommRate,BadDebtRate, PifPaid 
		--Order by InmateID,PIN,tblCommrate.CommRate,BadDebtRate ,PifPaid
 End
