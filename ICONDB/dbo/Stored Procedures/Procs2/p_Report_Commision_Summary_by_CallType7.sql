CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_CallType7]

@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@CallType	varchar(2),
@DivisionID	int
AS
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0
 
	If(@CallType <>'')
	     If @DivisionID > 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	       Begin
	         
		select tblFacility.Location, tblCallType.Descript as CallType,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
		 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

		from tblcallsbilled with(nolock),  tblCallType with(nolock) , tblCommrateAgent with(nolock) ,  tblBadDebt with(nolock)  ,tblFacility with(nolock) where 
							tblcallsbilled.CallType = tblCalltype.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.CallType = @CallType  and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							tblcallsbilled.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
							  convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location, State, tblCallType.Descript
		Order by tblFacility.Location, State, tblCallType.Descript 
	        
                        End
		else
		Begin
	         
		select tblFacility.Location, tblCallType.Descript as CallType,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

		from tblcallsbilled with(nolock),  tblCallType with(nolock) , tblCommrate with(nolock) ,  tblBadDebt with(nolock)  ,tblFacility with(nolock) where 
							tblcallsbilled.CallType = tblCallType.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.Calltype = @CallType  and
							tblcallsbilled.facilityID = tblCommrate.FacilityID AND
							tblcallsbilled.AgentID = tblCommrate.AgentID AND
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype =  tblCommrate.Calltype and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							tblcallsbilled.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
							  convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location, State, tblCallType.Descript
		Order by tblFacility.Location, State, tblCallType.Descript
	        
                        End
	    Else --Division = 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	          Begin
                      
		select tblFacility.Location, tblCallType.Descript as CallType,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
		 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

		from tblcallsbilled with(nolock),  tblCallType with(nolock) , tblCommrateAgent with(nolock) ,  tblBadDebt with(nolock)  ,tblFacility with(nolock) where 
							tblcallsbilled.CallType = tblCallType.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.CallType = @CallType  and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
							  convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location, State, tblCallType.Descript
		Order by tblFacility.Location, State, tblCallType.Descript
                       
                    End
		else
		Begin
                      
		select tblFacility.Location, tblCallType.Descript as CallType,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
		 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

		from tblcallsbilled with(nolock),  tblCallType with(nolock) , tblCommrate with(nolock) ,  tblBadDebt with(nolock)  ,tblFacility with(nolock) where 
							tblcallsbilled.CallType = tblCallType.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.CallType = @CallType  and
							tblcallsbilled.facilityID = tblCommrate.FacilityID AND
							tblcallsbilled.AgentID = tblCommrate.AgentID AND
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype =  tblCommrate.Calltype and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
							  convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location, State, tblCallType.Descript
		Order by tblFacility.Location, State, tblCallType.Descript
                       
                    End
	Else --CallType = ''
                   If @DivisionID > 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
                       Begin
	         
		select tblFacility.Location, tblCallType.Descript as CallType,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

		from tblcallsbilled with(nolock),  tblCallType with(nolock) , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,tblFacility with(nolock) where 
							tblcallsbilled.CallType = tblCallType.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							tblcallsbilled.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
							  convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location, State, tblCallType.Descript 
		Order by  tblFacility.Location, State, tblCallType.Descript
                      
	           End
		else
		Begin
	         
		select tblFacility.Location, tblCallType.Descript as BillType,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,
		 sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

		from tblcallsbilled with(nolock),  tblCallType with(nolock) , tblCommrate with(nolock), tblBadDebt with(nolock) ,tblFacility with(nolock) where 
							tblcallsbilled.CallType = tblCallType.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.facilityID = tblCommrate.FacilityID AND
							tblcallsbilled.AgentID = tblCommrate.AgentID AND
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype =  tblCommrate.Calltype and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							tblcallsbilled.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
							  convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location, State, tblCallType.Descript
		Order by  tblFacility.Location, State, tblCallType.Descript
                      
	           End


	      Else --Division = 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
 		Begin
		
		select tblFacility.Location, tblCallType.Descript as CallType,  count(CallRevenue ) CallCount, 
		sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

		from tblcallsbilled with(nolock),  tblCallType with(nolock) , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,tblFacility with(nolock) where 
							tblcallsbilled.CallType = tblCallType.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
							  convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location,  State, tblCallType.Descript
		Order by  tblFacility.Location, State, tblCallType.Descript
                       
		end
		else
		Begin
		
		select tblFacility.Location, tblCallType.Descript as CallType,  count(CallRevenue ) CallCount, 
		sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		sum(CallRevenue *  isnull( Rate,0))   as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

		from tblcallsbilled with(nolock),  tblCallType with(nolock) , tblCommrate with(nolock), tblBadDebt with(nolock) ,tblFacility with(nolock) where 
							tblcallsbilled.CallType = tblCallType.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.facilityID = tblCommrate.FacilityID AND
							tblcallsbilled.AgentID = tblCommrate.AgentID AND
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype =  tblCommrate.Calltype and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
							  convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location,  State, tblCallType.Descript
		Order by  tblFacility.Location, State, tblCallType.Descript
                       
		end
 
Else
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )= 0
 Begin
	If(@CallType <>'')
	
	
	      If @DivisionID > 0
                       if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	         begin
		select tblFacility.Location,tblCallType.Descript as CallType,    count(CallRevenue ) CallCount, 
		sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,
		'0'  as BadDebt,  
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, State
		from tblcallsbilled with(nolock),  tblCallType with(nolock) , tblCommrateAgent with(nolock),tblFacility with(nolock)  where 
							tblcallsbilled.CallType = tblCallType.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.CallType = @CallType  and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							tblcallsbilled.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
							 convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location, State, tblCallType.Descript
		Order by tblFacility.Location, State, tblCallType.Descript
	    end  
	else
	Begin
	     
                       
		select tblFacility.Location,tblCallType.Descript as CallType,    count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
		 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, 
		'0'  as BadDebt,   
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, State
		from tblcallsbilled with(nolock),  tblCallType with(nolock) , tblCommrate with(nolock),tblFacility with(nolock)  where 
							tblcallsbilled.CallType = tblCallType.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.CallType = @CallType  and
							tblcallsbilled.facilityID = tblCommrate.FacilityID AND
							tblcallsbilled.AgentID = tblCommrate.AgentID AND
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype =  tblCommrate.Calltype and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							tblcallsbilled.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
							 convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location, State, tblCallType.Descript
		Order by tblFacility.Location, State, tblCallType.Descript
	 end              
	
	Else --Division = 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Begin
		select tblFacility.Location, tblCallType.Descript as CallType,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		'0'  as BadDebt,   
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, State
		from tblcallsbilled with(nolock),  tblCallType with(nolock) , tblCommrateAgent with(nolock),tblFacility with(nolock) where 
							tblcallsbilled.CallType = tblCallType.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.CallType = @CallType  and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
							 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and 
							 convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location,State, tblCallType.Descript
		Order by tblFacility.Location, State, tblCallType.Descript
	            End
		else
		Begin
		select tblFacility.Location, tblCallType.Descript as CallType,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, 
		'0'  as BadDebt,    
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, State
		from tblcallsbilled with(nolock),  tblCallType with(nolock) , tblCommrate with(nolock),tblFacility with(nolock) where 
							tblcallsbilled.CallType = tblCallType.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.CallType = @CallType  and
							tblcallsbilled.facilityID = tblCommrate.FacilityID AND
							tblcallsbilled.AgentID = tblCommrate.AgentID AND
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype =  tblCommrate.Calltype and
							 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and 
							 convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location,State, tblCallType.Descript
		Order by tblFacility.Location, State, tblCallType.Descript 
	            End
	Else
	            If @DivisionID > 0
                        
		select tblFacility.Location,tblCallType.Descript as CallType,    count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
		 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		'0'  as BadDebt,   
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, State
		from tblcallsbilled with(nolock),  tblCallType with(nolock) , tblCommrateAgent with(nolock),tblFacility with(nolock)  where 
							tblcallsbilled.CallType = tblCallType.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							tblcallsbilled.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
							  convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location, State, tblCallType.Descript 
		Order by tblFacility.Location, State, tblCallType.Descript
	         
	
	Else --Division = 0
		
		select tblFacility.Location, tblCallType.Descript as CallType,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		'0'  as BadDebt,   
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, State
		from tblcallsbilled with(nolock),  tblCallType with(nolock) , tblCommrateAgent with(nolock),tblFacility with(nolock) where 
							tblcallsbilled.CallType = tblCallType.Abrev and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
							 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
							 convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location,State, tblCallType.Descript
		Order by tblFacility.Location, State, tblCallType.Descript
		
		

 End
Else ---facilityid  . 0
 Begin
	If(@CallType <>'')
	
		select tblCallType.Descript as CallType,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, 0 as Pif, 
		0 as BadDebt,    
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid
		from tblcallsbilled with(nolock),  tblCallType with(nolock) , tblcommrate with(nolock) where 
							tblcallsbilled.CallType = tblCallType.Abrev and
							tblcallsbilled.facilityID	= @facilityID  And
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.CallType = @CallType  and
							--tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							   
							   convert (int,duration ) >5 
							  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		group by  tblCallType.Descript
		Order by  tblCallType.Descript
	
	Else
		select tblCallType.Descript as CallType,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
		 sum(CallRevenue) CallRevenue, 0 as Pif ,   
		0  as BadDebt,   
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid
		from tblcallsbilled with(nolock),  tblCallType with(nolock) , tblcommrate with(nolock) where 
							tblcallsbilled.CallType =  tblCallType.Abrev and
							tblcallsbilled.facilityID	= @facilityID  And
							 tblcallsBilled.errorcode = '0' and 
							--tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							  convert (int,duration ) >5
							 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		group by  tblCallType.Descript 
		Order by  tblCallType.Descript
 End
