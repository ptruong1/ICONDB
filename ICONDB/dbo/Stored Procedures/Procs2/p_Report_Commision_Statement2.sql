﻿CREATE PROCEDURE [dbo].[p_Report_Commision_Statement2]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@DivisionID	int
AS


If( @AgentID >1 AND @facilityID =0 ) 
 Begin
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) > 0
	    IF @divisionID > 0
		begin
			if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
				select   tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST (CallRevenue as numeric(9,4))) CallRevenue,
					 (tblCommrateAgent.CommRate * 100)  as CommRate,  
					(CASE PifPaid  when 0 then  CAST((sum( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
					 Else CAST((sum( CAST(CallRevenue as Numeric(9,4)) - (CAST(CallRevenue as Numeric(9,4)) * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +sum(isnull( PIf ,0))    End)  as CommPaid
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
									  convert (int,duration ) >5  and tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
				group by   tblbilltype.Descript, tblCallType.Descript,tblCommrateAgent.CommRate, PifPaid
				Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrateAgent.CommRate
			else
				select   tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST (CallRevenue as numeric(9,4))) CallRevenue,
					 (tblCommrate.CommRate * 100)  as CommRate,  
					(CASE PifPaid  when 0 then  CAST((sum( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
					 Else CAST((sum( CAST(CallRevenue as Numeric(9,4)) - (CAST(CallRevenue as Numeric(9,4)) * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +sum(isnull( PIf ,0))    End)  as CommPaid
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
									 convert (int,duration ) >5  and tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
				group by   tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate, PifPaid
				Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate

	 	end 
	     else
	 	begin
			if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
				select   tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST (CallRevenue as numeric(9,4))) CallRevenue,
					 (tblCommrateAgent.CommRate * 100)  as CommRate,  
					(CASE PifPaid  when 0 then  CAST((sum( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
					 Else CAST((sum( CAST(CallRevenue as Numeric(9,4)) - (CAST(CallRevenue as Numeric(9,4)) * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +sum(isnull( PIf ,0))    End)  as CommPaid
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
									  convert (int,duration ) >5  and tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
				group by   tblbilltype.Descript, tblCallType.Descript,tblCommrateAgent.CommRate, PifPaid
				Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrateAgent.CommRate
			else
				select   tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST (CallRevenue as numeric(9,4))) CallRevenue,
					 (tblCommrate.CommRate * 100)  as CommRate,  
					(CASE PifPaid  when 0 then  CAST((sum( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
					 Else CAST((sum( CAST(CallRevenue as Numeric(9,4)) - (CAST(CallRevenue as Numeric(9,4)) * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +sum(isnull( PIf ,0))    End)  as CommPaid
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
									 convert (int,duration ) >5  and tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
				group by   tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate, PifPaid
				Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate
	            end 
	
	
	Else
	
	    If @divisionID > 0
		begin
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select  tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST (CallRevenue as numeric(9,4))) CallRevenue,
				 (tblCommrateAgent.CommRate * 100)  as CommRate,  
				(CASE PifPaid  when 0 then  CAST((sum( CallRevenue )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((sum( CAST(CallRevenue as Numeric(12,4))  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +sum(isnull( PIf ,0))    End)  as CommPaid
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
								   convert (int,duration ) >5  and tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by  tblbilltype.Descript, tblCallType.Descript,tblCommrateAgent.CommRate, PifPaid
			Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrateAgent.CommRate
		else
			select  tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST (CallRevenue as numeric(9,4))) CallRevenue,
				 (tblCommrate.CommRate * 100)  as CommRate,  
				(CASE PifPaid  when 0 then  CAST((sum( CallRevenue )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((sum( CAST(CallRevenue as Numeric(12,4))  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +sum(isnull( PIf ,0))    End)  as CommPaid
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
								  convert (int,duration ) >5  and tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by  tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate, PifPaid
			Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate
		end
	    else
		select  tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CAST (CallRevenue as numeric(9,4))) CallRevenue,
			 (tblCommrateAgent.CommRate * 100)  as CommRate,  
			(CASE PifPaid  when 0 then  CAST((sum( CallRevenue )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
			 Else CAST((sum( CAST(CallRevenue as Numeric(12,4))  - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +sum(isnull( PIf ,0))    End)  as CommPaid
		from tblcallsbilled with(nolock),  tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRateAgent with(nolock)  where 
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							
							tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
							 convert (int,duration ) >5  and tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		group by  tblbilltype.Descript, tblCallType.Descript,tblCommrateAgent.CommRate, PifPaid
		Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrateAgent.CommRate

 End 

Else

 --Begin

	--select  tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype, count(CallRevenue ) CallCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ))  as CallDuration, sum(CallRevenue) CallRevenue,
	--	  (tblCommrate.CommRate * 100)  as CommRate,  						       CAST ((sum(CallRevenue) * tblCommrate.CommRate)  as numeric(12,4) )  as CommPaid
	--from tblcallsbilled with(nolock),  tblCalltype with(nolock), tblBilltype  with(nolock) , tblCommRate where 
	--					tblcallsbilled.Billtype = tblBilltype.Billtype and
	--					 tblcallsBilled.errorcode = '0' and 
	--					tblcallsbilled.Calltype = tblCalltype.Abrev and
	--					tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
	--					tblcallsbilled.Billtype =  tblCommrate.billtype and
	--					 tblcallsbilled.Calltype = tblCommrate.Calltype and
	--					tblcallsbilled.facilityID	= @facilityID  And
						
	--					(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
	--					 convert (int,duration ) >5 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
	--group by  tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate
	--Order by  tblbilltype.Descript, tblCallType.Descript,tblCommrate.CommRate
 	
 --end

 Begin
 	select 
	 X.Bill as "BillType" 
	, X.Call as "CallType"
	, sum(X.callcount) as "CallCount" 
	,sum(X.duration)  as CallDuration 
	,sum(X.CallRevenue) as "CallRevenue"
	,X.CommRate   as "CommRate" 
	,(sum(X.commpaid))   as "CommPaid"
	
	from
	(select Calldate, tblbilltype.Descript as Bill , tblCallType.Descript as call, 1 as callcount,
	fromno ,tono , 
		dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ) as duration,  CallRevenue,  
		Cast(tblCommrate.CommRate * 100  as Numeric(12,4)) as commrate ,
		CAST (((CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2)) as commpaid
		from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock)  WHERE
						tblcallsbilled.Billtype = tblBilltype.Billtype and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.Calltype = tblCalltype.Abrev and
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						tblcallsbilled.facilityID	= @facilityID  And
						
						(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
	) X
	group by  X.Bill, X.Call,x.CommRate
	Order by  X.Bill, X.Call,x.CommRate

	End
