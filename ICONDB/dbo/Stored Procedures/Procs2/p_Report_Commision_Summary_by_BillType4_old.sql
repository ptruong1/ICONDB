CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_BillType4_old]

@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@BillType	varchar(2),
@DivisionID	int
AS
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0
 
	If(@BillType <>'')
	     If @DivisionID > 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	       Begin
	         
		select tblFacility.Location, tblBillType.Descript as BillType,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
		 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		CAST (sum(CallRevenue *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

		from tblcallsbilled with(nolock),  tblBillType with(nolock) , tblCommrateAgent with(nolock) ,  tblBadDebt with(nolock)  ,tblFacility with(nolock) where 
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.BillType = @BillType  and
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
		group by  tblFacility.Location, State, tblBillType.Descript
		Order by tblFacility.Location, State, tblBillType.Descript 
	        
                        End
		else
		Begin
	         
		select tblFacility.Location, tblBillType.Descript as BillType,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		CAST (sum(CallRevenue *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

		from tblcallsbilled with(nolock),  tblBillType with(nolock) , tblCommrate with(nolock) ,  tblBadDebt with(nolock)  ,tblFacility with(nolock) where 
							tblcallsbilled.BillType = tblBillType.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.Calltype = @BillType  and
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
		group by  tblFacility.Location, State, tblBillType.Descript
		Order by tblFacility.Location, State, tblBillType.Descript
	        
                        End
	    Else --Division = 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	          Begin
                      
		select tblFacility.Location, tblBillType.Descript as BillType,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
		 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		CAST (sum(CallRevenue *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

		from tblcallsbilled with(nolock),  tblBillType with(nolock) , tblCommrateAgent with(nolock) ,  tblBadDebt with(nolock)  ,tblFacility with(nolock) where 
							tblcallsbilled.BillType = tblBillType.BillType and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.BillType = @BillType  and
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
		group by  tblFacility.Location, State, tblBillType.Descript
		Order by tblFacility.Location, State, tblBillType.Descript
                       
                    End
		else
		Begin
                      
		select tblFacility.Location, tblBillType.Descript as BillType,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
		 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		CAST (sum(CallRevenue *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

		from tblcallsbilled with(nolock),  tblBillType with(nolock) , tblCommrate with(nolock) ,  tblBadDebt with(nolock)  ,tblFacility with(nolock) where 
							tblcallsbilled.BillType = tblBillType.BillType and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.BillType = @BillType  and
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
		group by  tblFacility.Location, State, tblBillType.Descript
		Order by tblFacility.Location, State, tblBillType.Descript
                       
                    End
	Else --BillType = ''
                   If @DivisionID > 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
                       Begin
	         
		select tblFacility.Location, tblBillType.Descript as BillType,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		CAST (sum(CallRevenue *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

		from tblcallsbilled with(nolock),  tblBillType with(nolock) , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,tblFacility with(nolock) where 
							tblcallsbilled.BillType = tblBillType.BillType and
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
		group by  tblFacility.Location, State, tblBillType.Descript 
		Order by  tblFacility.Location, State, tblBillType.Descript
                      
	           End
		else
		Begin
	         
		select tblFacility.Location, tblBillType.Descript as BillType,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,
		 CAST (sum(CallRevenue *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

		from tblcallsbilled with(nolock),  tblBillType with(nolock) , tblCommrate with(nolock), tblBadDebt with(nolock) ,tblFacility with(nolock) where 
							tblcallsbilled.BillType = tblBillType.BillType and
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
		group by  tblFacility.Location, State, tblBillType.Descript
		Order by  tblFacility.Location, State, tblBillType.Descript
                      
	           End


	      Else --Division = 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
 		Begin
		
		select tblFacility.Location, tblBillType.Descript as BillType,  count(CallRevenue ) CallCount, 
		sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		CAST (sum(CallRevenue *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

		from tblcallsbilled with(nolock),  tblBillType with(nolock) , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,tblFacility with(nolock) where 
							tblcallsbilled.BillType = tblBillType.BillType and
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
		group by  tblFacility.Location,  State, tblBillType.Descript
		Order by  tblFacility.Location, State, tblBillType.Descript
                       
		end
		else
		Begin
		
		select tblFacility.Location, tblBillType.Descript as BillType,  count(CallRevenue ) CallCount, 
		sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		CAST (sum(CallRevenue *  isnull( Rate,0)) as numeric(12,4))  as BadDebt,
			(sum(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, state

		from tblcallsbilled with(nolock),  tblBillType with(nolock) , tblCommrate with(nolock), tblBadDebt with(nolock) ,tblFacility with(nolock) where 
							tblcallsbilled.BillType = tblBillType.BillType and
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
		group by  tblFacility.Location,  State, tblBillType.Descript
		Order by  tblFacility.Location, State, tblBillType.Descript
                       
		end
 
Else
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )= 0
 Begin
	If(@BillType <>'')
	
	
	      If @DivisionID > 0
                       if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	         begin
		select tblFacility.Location,tblBillType.Descript as BillType,    count(CallRevenue ) CallCount, 
		sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,
		'0'  as BadDebt,  
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, State
		from tblcallsbilled with(nolock),  tblBillType with(nolock) , tblCommrateAgent with(nolock),tblFacility with(nolock)  where 
							tblcallsbilled.BillType = tblBillType.BillType and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.BillType = @BillType  and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							tblcallsbilled.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
							 convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location, State, tblBillType.Descript
		Order by tblFacility.Location, State, tblBillType.Descript
	    end  
	else
	Begin
	     
                       
		select tblFacility.Location,tblBillType.Descript as BillType,    count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
		 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, 
		'0'  as BadDebt,   
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, State
		from tblcallsbilled with(nolock),  tblBillType with(nolock) , tblCommrate with(nolock),tblFacility with(nolock)  where 
							tblcallsbilled.BillType = tblBillType.BillType and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.BillType = @BillType  and
							tblcallsbilled.facilityID = tblCommrate.FacilityID AND
							tblcallsbilled.AgentID = tblCommrate.AgentID AND
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype =  tblCommrate.Calltype and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							tblcallsbilled.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
							 convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location, State, tblBillType.Descript
		Order by tblFacility.Location, State, tblBillType.Descript
	 end              
	
	Else --Division = 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Begin
		select tblFacility.Location, tblBillType.Descript as BillType,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		'0'  as BadDebt,   
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, State
		from tblcallsbilled with(nolock),  tblBillType with(nolock) , tblCommrateAgent with(nolock),tblFacility with(nolock) where 
							tblcallsbilled.BillType = tblBillType.BillType and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.BillType = @BillType  and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
							 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and 
							 convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location,State, tblBillType.Descript
		Order by tblFacility.Location, State, tblBillType.Descript
	            End
		else
		Begin
		select tblFacility.Location, tblBillType.Descript as BillType,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue, Sum(Pif) as Pif, 
		'0'  as BadDebt,    
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, State
		from tblcallsbilled with(nolock),  tblBillType with(nolock) , tblCommrate with(nolock),tblFacility with(nolock) where 
							tblcallsbilled.BillType = tblBillType.BillType and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.BillType = @BillType  and
							tblcallsbilled.facilityID = tblCommrate.FacilityID AND
							tblcallsbilled.AgentID = tblCommrate.AgentID AND
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype =  tblCommrate.Calltype and
							 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and 
							 convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location,State, tblBillType.Descript
		Order by tblFacility.Location, State, tblBillType.Descript 
	            End
	Else
	            If @DivisionID > 0
                        
		select tblFacility.Location,tblBillType.Descript as BillType,    count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
		 sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		'0'  as BadDebt,   
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, State
		from tblcallsbilled with(nolock),  tblBillType with(nolock) , tblCommrateAgent with(nolock),tblFacility with(nolock)  where 
							tblcallsbilled.BillType = tblBillType.BillType and
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
		group by  tblFacility.Location, State, tblBillType.Descript 
		Order by tblFacility.Location, State, tblBillType.Descript
	         
	
	Else --Division = 0
		
		select tblFacility.Location, tblBillType.Descript as BillType,  count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, Sum(Pif) as Pif,  
		'0'  as BadDebt,   
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid, State
		from tblcallsbilled with(nolock),  tblBillType with(nolock) , tblCommrateAgent with(nolock),tblFacility with(nolock) where 
							tblcallsbilled.BillType = tblBillType.BillType and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype =  tblCommrateAgent.Calltype and
							 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and
							 convert (int,duration ) >5 
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblFacility.Location,State, tblBillType.Descript
		Order by tblFacility.Location, State, tblBillType.Descript
		
		

 End
Else ---facilityid  . 0
 Begin
	If(@BillType <>'')
	
		select tblBillType.Descript as BillType,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, 
		sum(CallRevenue) CallRevenue, 0 as Pif, 
		0 as BadDebt,    
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid
		from tblcallsbilled with(nolock),  tblBillType with(nolock) , tblcommrate with(nolock) where 
							tblcallsbilled.BillType = tblBillType.BillType and
							tblcallsbilled.facilityID	= @facilityID  And
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.BillType = @BillType  and
							--tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							   
							   convert (int,duration ) >5 
							  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		group by  tblBillType.Descript
		Order by  tblBillType.Descript
	
	Else
		select tblBillType.Descript as BillType,   count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration,
		 sum(CallRevenue) CallRevenue, 0 as Pif ,   
		0  as BadDebt,   
		(sum(CASE PifPaid  when 0 then  CAST(( CallRevenue   *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) )
				  +isnull( PIf ,0)    End))  as CommPaid
		from tblcallsbilled with(nolock),  tblBillType with(nolock) , tblcommrate with(nolock) where 
							tblcallsbilled.BillType =  tblBillType.BillType and
							tblcallsbilled.facilityID	= @facilityID  And
							 tblcallsBilled.errorcode = '0' and 
							--tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							  convert (int,duration ) >5
							 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		group by  tblBillType.Descript 
		Order by  tblBillType.Descript
 End
