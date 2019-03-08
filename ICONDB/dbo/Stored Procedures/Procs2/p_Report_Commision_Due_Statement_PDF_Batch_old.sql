CREATE PROCEDURE [dbo].[p_Report_Commision_Due_Statement_PDF_Batch_old]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@DivisionID	int
AS


If( @AgentID >1 AND @DivisionID >0 ) 
 Begin
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) > 0
	    IF @divisionID > 0
		begin
			if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
				select   tblbilltype.Descript as "Bill Type" , tblCallType.Descript as "Call Type", count(CallRevenue ) "Call Count", 
				sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as "Duration", 
				sum(CAST (CallRevenue as numeric(9,4))) "Call Duration",
					 (tblCommrateAgent.CommRate * 100)  as "Comm Rate",  
					(CASE PifPaid  when 0 then  CAST((sum( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
					 Else 
					 CAST((sum( CAST(CallRevenue as Numeric(9,4)) - (CAST(CallRevenue as Numeric(9,4)) * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +sum(isnull( PIf ,0)) 
					    End)  as "Comm Paid"
				from tblcallsbilled with(nolock),  tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent with(nolock) , tblbadDebt with(nolock) where 
									tblcallsbilled.Billtype = tblBilltype.Billtype and
									 tblcallsBilled.errorcode = '0' and 
									tblcallsbilled.Calltype = tblCalltype.Abrev and
									tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
									 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
									tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
									  tblcallsbilled.billtype =  tblBadDebt.billtype and
									  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
									  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
									   tblcallsbilled.FacilityID =  tblBadDebt.FacilityID and
									 tblcallsbilled.FacilityID =  @divisionID and
									tblcallsbilled.agentID = @agentID and							
									(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
									   convert (int,duration ) >5    and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				group by   tblbilltype.Descript, tblCallType.Descript,tblCommrateAgent.CommRate, PifPaid
				Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrateAgent.CommRate
			else
				select   tblbilltype.Descript as "Bill Type" , tblCallType.Descript as "Call Type", count(CallRevenue ) "Call Count", 
				sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as "Duration", 
				sum(CAST (CallRevenue as numeric(9,4))) "Call Duration",
					 (tblCommrate.CommRate * 100)  as "Comm Rate",  
					(CASE PifPaid  when 0 then  CAST((sum( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
					 Else CAST((sum( CAST(CallRevenue as Numeric(9,4)) - (CAST(CallRevenue as Numeric(9,4)) * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +sum(isnull( PIf ,0))    End)  as "Comm Paid"
				from tblcallsbilled with(nolock),  tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRate with(nolock) , tblbadDebt with(nolock) where 
									tblcallsbilled.Billtype = tblBilltype.Billtype and
									 tblcallsBilled.errorcode = '0' and 
									tblcallsbilled.Calltype = tblCalltype.Abrev and
									tblcallsbilled.Billtype =  tblCommrate.billtype and
									 tblcallsbilled.Calltype = tblCommrate.Calltype and
									tblcallsbilled.AgentID = tblCommrate.AgentID AND
									tblcallsbilled.FacilityID =  tblCommrate.FacilityID and
									  tblcallsbilled.billtype =  tblBadDebt.billtype and
									  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
									  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
									   tblcallsbilled.FacilityID =  tblBadDebt.FacilityID and
									   
									 tblcallsbilled.FacilityID =  @divisionID and
									tblcallsbilled.agentID = @agentID and							
									(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
									   convert (int,duration ) >5    and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				group by   tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate, PifPaid
				Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate

	 	end 
	     else
	 	begin
			if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
				select   tblbilltype.Descript as "Bill Type" , tblCallType.Descript as "Call Type", count(CallRevenue ) "Call Count", 
				sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as "Duration", 
				sum(CAST (CallRevenue as numeric(9,4))) "Call Duration",
					 (tblCommrateAgent.CommRate * 100)  as "Comm Rate",  
					(CASE PifPaid  when 0 then  
					CAST((sum( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
					 Else 
					 CAST((sum( CAST(CallRevenue as Numeric(9,4)) - (CAST(CallRevenue as Numeric(9,4)) * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +sum(isnull( PIf ,0))    
					 End)  as "Comm Paid"
				from tblcallsbilled with(nolock),  tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent with(nolock) , tblbadDebt with(nolock) where 
									tblcallsbilled.Billtype = tblBilltype.Billtype and
									 tblcallsBilled.errorcode = '0' and 
									tblcallsbilled.Calltype = tblCalltype.Abrev and
									tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
									 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
									tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
									  tblcallsbilled.billtype =  tblBadDebt.billtype and
									  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
									  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
									   tblcallsbilled.FacilityID =  tblBadDebt.FacilityID and
									
									tblcallsbilled.agentID = @agentID and
									(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
									   convert (int,duration ) >5    and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				group by   tblbilltype.Descript, tblCallType.Descript,tblCommrateAgent.CommRate, PifPaid
				Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrateAgent.CommRate
			else
				select   tblbilltype.Descript as Billtype , tblCallType.Descript as "Call Type", count(CallRevenue ) "Call Count", 
				sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as "Duration", 
				sum(CAST (CallRevenue as numeric(9,4))) "Call Duration",
					 (tblCommrate.CommRate * 100)  as "Comm Rate",  
					(CASE PifPaid  when 0 then  
					CAST((sum( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
					 Else 
					 CAST((sum( CAST(CallRevenue as Numeric(9,4)) - (CAST(CallRevenue as Numeric(9,4)) * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +sum(isnull( PIf ,0))
					     End)  as "Comm Paid"
				from tblcallsbilled with(nolock),  tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRate with(nolock) , tblbadDebt with(nolock) where 
									tblcallsbilled.Billtype = tblBilltype.Billtype and
									 tblcallsBilled.errorcode = '0' and 
									tblcallsbilled.Calltype = tblCalltype.Abrev and
									tblcallsbilled.Billtype =  tblCommrate.billtype and
									 tblcallsbilled.Calltype = tblCommrate.Calltype and
									tblcallsbilled.AgentID = tblCommrate.AgentID AND
									tblcallsbilled.FacilityID =  tblCommrate.FacilityID and
									  tblcallsbilled.billtype =  tblBadDebt.billtype and
									  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
									  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
									   tblcallsbilled.FacilityID =  tblBadDebt.FacilityID and 
									
									tblcallsbilled.agentID = @agentID and							
									(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
									   convert (int,duration ) >5    and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				group by   tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate, PifPaid
				Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate
	            end 
	
	
	Else
	
	    If @divisionID > 0
		begin
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select  tblbilltype.Descript as "Bill Type" , tblCallType.Descript as "Call Type", count(CallRevenue ) "Call Count", 
			sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as "Duration", 
			sum(CAST (CallRevenue as numeric(9,4))) "Call Duration",
				 (tblCommrateAgent.CommRate * 100)  as "Comm Rate",  
				(CASE PifPaid  when 0 then  
				CAST((sum( CallRevenue )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else 
				 CAST((sum( CAST(CallRevenue as Numeric(12,4))  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +sum(isnull( PIf ,0))
				     End)  as "Comm Paid"
			from tblcallsbilled with(nolock),  tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent with(nolock)  where 
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
								 tblcallsbilled.FacilityID =  @divisionID and
								tblcallsbilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
								   convert (int,duration ) >5    and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			group by  tblbilltype.Descript, tblCallType.Descript,tblCommrateAgent.CommRate, PifPaid
			Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrateAgent.CommRate
		else
			select  tblbilltype.Descript as Billtype , tblCallType.Descript as "Call Type", count(CallRevenue ) "Call Count", 
			sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as "Duration", 
			sum(CAST (CallRevenue as numeric(9,4))) "Call Duration",
				 (tblCommrate.CommRate * 100)  as "Comm Rate",  
				(CASE PifPaid  when 0 then 
				 CAST((sum( CallRevenue )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else 
				 CAST((sum( CAST(CallRevenue as Numeric(12,4))  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +sum(isnull( PIf ,0))
				     End)  as "Comm Paid"
			from tblcallsbilled with(nolock),  tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRate  with(nolock)  where 
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								tblcallsbilled.AgentID = tblCommrate.AgentID AND
								tblcallsbilled.facilityID = tblCommrate.facilityID AND
								 tblcallsbilled.FacilityID =  @divisionID and
								tblcallsbilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
								   convert (int,duration ) >5    and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			group by  tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate, PifPaid
			Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate
		end
	    else
		select  tblbilltype.Descript as "Bill Type" , tblCallType.Descript as "Call Type", count(CallRevenue ) "Call Count", 
		sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as "Duration", 
		sum(CAST (CallRevenue as numeric(9,4))) "Call Duration",
			 (tblCommrateAgent.CommRate * 100)  as "Comm Rate",  
			(CASE PifPaid  when 0 then  
			CAST((sum( CallRevenue )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
			 Else 
			 CAST((sum( CAST(CallRevenue as Numeric(12,4))  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +sum(isnull( PIf ,0)) 
			    End)  as "Comm Paid"
		from tblcallsbilled with(nolock),  tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent with(nolock)  where 
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							
							tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							   convert (int,duration ) >5    and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		group by  tblbilltype.Descript, tblCallType.Descript,tblCommrateAgent.CommRate, PifPaid
		Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrateAgent.CommRate

 End 

Else

 Begin

	select  tblbilltype.Descript as "Bill Type" , tblCallType.Descript as "Call Type", count(CallRevenue ) as "Call Count", 
	sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as Duration, sum(CallRevenue) as "Call Revenue",
		  (tblCommrate.CommRate * 100)  as "Comm Rate", 
		  CAST ((sum(CallRevenue) * tblCommrate.CommRate)  as numeric(12,2) )  as "Comm Paid"
	from tblcallsbilled with(nolock),  tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRate where 
						tblcallsbilled.Billtype = tblBilltype.Billtype and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.Calltype = tblCalltype.Abrev and
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						tblcallsbilled.facilityID	= @facilityID  And
						
						(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
						   convert (int,duration ) >5    and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	group by  tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate
	Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate
 	
 end
