CREATE PROCEDURE [dbo].[p_Report_Commission_OCC_Year]

@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@FromNo	varchar(10),
@DivisionID	int
AS

If(@AgentID	>1 AND @facilityID =0 )
 	Begin
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) > 0
	   if @divisionID > 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0

		select X.Location, X.FromNo,

	 	sum(case when M=1 then callsCount else 0 end) as M1,
		  sum(case when M=2 then callsCount else 0 end) as M2,
		  sum(case when M=3 then callsCount else 0 end) as M3,
		  sum(case when M=4 then callsCount else 0 end) as M4,
		  sum(case when M=5 then callsCount else 0 end) as M5,
		  sum(case when M=6 then callsCount else 0 end) as M6,
		  sum(case when M=7 then callsCount else 0 end) as M7,
		  sum(case when M=8 then callsCount else 0 end) as M8,
		  sum(case when M=9 then callsCount else 0 end) as M9,
		  sum(case when M=10 then callsCount else 0 end) as M10,
		  sum(case when M=11 then callsCount else 0 end) as M11,
		  sum(case when M=12 then callsCount else 0 end) as M12,
		  
		  
		  sum(callsCount) as Total
	from
	
	
	(Select   Location, FromNo, DATEPART(mm,RecordDate) as M, Count(calldate) as CallsCount
	 			
			from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock)
				WHERE
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.AgentID=  tblCommrateAgent.AgentID and
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.FacilityID =  @divisionID and
								tblcallsbilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@toDate) )   and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by Location, FromNo, DATEPART(mm,RecordDate)) as X
			
		  Group by X.Location, X.FromNo
		Order by X.Location, X.FromNo

		else
			select X.Location, X.FromNo,

		 sum(case when M=1 then callsCount else 0 end) as M1,
		  sum(case when M=2 then callsCount else 0 end) as M2,
		  sum(case when M=3 then callsCount else 0 end) as M3,
		  sum(case when M=4 then callsCount else 0 end) as M4,
		  sum(case when M=5 then callsCount else 0 end) as M5,
		  sum(case when M=6 then callsCount else 0 end) as M6,
		  sum(case when M=7 then callsCount else 0 end) as M7,
		  sum(case when M=8 then callsCount else 0 end) as M8,
		  sum(case when M=9 then callsCount else 0 end) as M9,
		  sum(case when M=10 then callsCount else 0 end) as M10,
		  sum(case when M=11 then callsCount else 0 end) as M11,
		  sum(case when M=12 then callsCount else 0 end) as M12,
	  
	  sum(callsCount) as Total
	from
	
	
	(Select   Location, FromNo, DATEPART(mm,RecordDate) as M, Count(calldate) as CallsCount
	 			
			from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock)
				WHERE
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.AgentID=  tblCommrate.AgentID and
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								  tblcallsbilled.FacilityID =  tblCommrate.FacilityID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.FacilityID =  @divisionID and
								 tblcallsbilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@toDate) )   and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by Location, FromNo, DATEPART(mm,RecordDate)) as X
			
		  Group by X.Location, X.FromNo
		Order by X.Location, X.FromNo
		
	      else	
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select X.Location, X.FromNo,

	  	  sum(case when M=1 then callsCount else 0 end) as M1,
		  sum(case when M=2 then callsCount else 0 end) as M2,
		  sum(case when M=3 then callsCount else 0 end) as M3,
		  sum(case when M=4 then callsCount else 0 end) as M4,
		  sum(case when M=5 then callsCount else 0 end) as M5,
		  sum(case when M=6 then callsCount else 0 end) as M6,
		  sum(case when M=7 then callsCount else 0 end) as M7,
		  sum(case when M=8 then callsCount else 0 end) as M8,
		  sum(case when M=9 then callsCount else 0 end) as M9,
		  sum(case when M=10 then callsCount else 0 end) as M10,
		  sum(case when M=11 then callsCount else 0 end) as M11,
		  sum(case when M=12 then callsCount else 0 end) as M12,
	  
	  sum(callsCount) as Total
	from
	
	
	(Select   Location, FromNo, DATEPART(mm,RecordDate) as M, Count(calldate) as CallsCount 
	 			
			from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock)
				WHERE
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.AgentID=  tblCommrateAgent.AgentID and
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@toDate) )  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by Location, FromNo, DATEPART(mm,RecordDate)) as X
			
		  Group by X.Location, X.FromNo
		Order by X.Location, X.FromNo

		else
			select X.Location, X.FromNo,

		  sum(case when M=1 then callsCount else 0 end) as M1,
		  sum(case when M=2 then callsCount else 0 end) as M2,
		  sum(case when M=3 then callsCount else 0 end) as M3,
		  sum(case when M=4 then callsCount else 0 end) as M4,
		  sum(case when M=5 then callsCount else 0 end) as M5,
		  sum(case when M=6 then callsCount else 0 end) as M6,
		  sum(case when M=7 then callsCount else 0 end) as M7,
		  sum(case when M=8 then callsCount else 0 end) as M8,
		  sum(case when M=9 then callsCount else 0 end) as M9,
		  sum(case when M=10 then callsCount else 0 end) as M10,
		  sum(case when M=11 then callsCount else 0 end) as M11,
		  sum(case when M=12 then callsCount else 0 end) as M12,
	  
	  sum(callsCount) as Total
	from
	
	
	(Select   Location, FromNo, DATEPART(mm,RecordDate) as M, Count(calldate) as CallsCount
	 			
			from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock)
				WHERE
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.AgentID=  tblCommrate.AgentID and
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
							                tblcallsbilled.FacilityID = tblCommrate.FacilityID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and						
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@toDate) )  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by Location, FromNo, DATEPART(mm,RecordDate)) as X
			
		  Group by X.Location, X.FromNo
		Order by X.Location, X.FromNo
	
	else
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) = 0
	    
		If @divisionID > 0
		select X.Location, X.FromNo,

	  sum(case when M=1 then callsCount else 0 end) as M1,
		  sum(case when M=2 then callsCount else 0 end) as M2,
		  sum(case when M=3 then callsCount else 0 end) as M3,
		  sum(case when M=4 then callsCount else 0 end) as M4,
		  sum(case when M=5 then callsCount else 0 end) as M5,
		  sum(case when M=6 then callsCount else 0 end) as M6,
		  sum(case when M=7 then callsCount else 0 end) as M7,
		  sum(case when M=8 then callsCount else 0 end) as M8,
		  sum(case when M=9 then callsCount else 0 end) as M9,
		  sum(case when M=10 then callsCount else 0 end) as M10,
		  sum(case when M=11 then callsCount else 0 end) as M11,
		  sum(case when M=12 then callsCount else 0 end) as M12,
		  
		  
		  sum(callsCount) as Total
		from
		
		
		(Select   Location, FromNo, DATEPART(mm,RecordDate) as M, Count(calldate) as CallsCount
			from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock),  tblFacility with(nolock)  WHERE
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.AgentID=  tblCommrateAgent.AgentID and
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							 tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID =  @divisionID and
							(RecordDate between @fromDate and dateadd(d,1,@toDate) ) and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by Location, FromNo, DATEPART(mm,RecordDate)) as X
			
		  Group by X.Location, X.FromNo
		 Order by X.Location, X.FromNo

		Else

		select X.Location, X.FromNo,

	 sum(case when M=1 then callsCount else 0 end) as M1,
		  sum(case when M=2 then callsCount else 0 end) as M2,
		  sum(case when M=3 then callsCount else 0 end) as M3,
		  sum(case when M=4 then callsCount else 0 end) as M4,
		  sum(case when M=5 then callsCount else 0 end) as M5,
		  sum(case when M=6 then callsCount else 0 end) as M6,
		  sum(case when M=7 then callsCount else 0 end) as M7,
		  sum(case when M=8 then callsCount else 0 end) as M8,
		  sum(case when M=9 then callsCount else 0 end) as M9,
		  sum(case when M=10 then callsCount else 0 end) as M10,
		  sum(case when M=11 then callsCount else 0 end) as M11,
		  sum(case when M=12 then callsCount else 0 end) as M12,
		  
		  
		  sum(callsCount) as Total
		from
		
		
		(Select   Location, FromNo, DATEPART(mm,RecordDate) as M, Count(calldate) as CallsCount
	 			
			from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock),  tblFacility with(nolock)  WHERE
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.AgentID=  tblCommrateAgent.AgentID and
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							 tblcallsbilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@toDate) )   and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by Location, FromNo, DATEPART(mm,RecordDate)) as X
			
		  Group by X.Location, X.FromNo
		Order by X.Location, X.FromNo
		
 	end	
Else
 	

	select X.FacilityID, X.FromNo,

	  sum(case when M=1 then callsCount else 0 end) as M1,
		  sum(case when M=2 then callsCount else 0 end) as M2,
		  sum(case when M=3 then callsCount else 0 end) as M3,
		  sum(case when M=4 then callsCount else 0 end) as M4,
		  sum(case when M=5 then callsCount else 0 end) as M5,
		  sum(case when M=6 then callsCount else 0 end) as M6,
		  sum(case when M=7 then callsCount else 0 end) as M7,
		  sum(case when M=8 then callsCount else 0 end) as M8,
		  sum(case when M=9 then callsCount else 0 end) as M9,
		  sum(case when M=10 then callsCount else 0 end) as M10,
		  sum(case when M=11 then callsCount else 0 end) as M11,
		  sum(case when M=12 then callsCount else 0 end) as M12,
		  
		  
		  sum(callsCount) as Total
		from
		
		
		(Select   tblcallsbilled.facilityID, FromNo, DATEPART(mm,RecordDate) as M, Count(calldate) as CallsCount
	 			
			from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock)  WHERE
						tblcallsbilled.Billtype = tblBilltype.Billtype and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.Calltype = tblCalltype.Abrev and
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						tblcallsbilled.facilityID	= @facilityID  And
						--tblcallsbilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@toDate) )  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by tblcallsbilled.FacilityID, FromNo, DATEPART(mm,RecordDate)) as X
			
		  Group by X.FacilityID, X.FromNo
		Order  by X.FacilityID, X.FromNo
