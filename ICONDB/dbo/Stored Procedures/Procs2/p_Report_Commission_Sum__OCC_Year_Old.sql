CREATE PROCEDURE [dbo].[p_Report_Commission_Sum__OCC_Year_Old]

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
			select X.Location,

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
	
	
	(Select   Location, DATEPART(mm,RecordDate) as M, Count(calldate) as CallsCount
	 			
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
								(RecordDate between @fromDate and dateadd(d,1,@toDate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by Location, DATEPART(mm,RecordDate)) as X
			
		  Group by X.Location
		else
			select X.Location,

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
	
	
	(Select   Location, DATEPART(mm,RecordDate) as M, Count(calldate) as CallsCount
	 			
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
								--tblcallsbilled.FacilityID =  @divisionID and
								 tblcallsbilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@toDate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by Location, DATEPART(mm,RecordDate)) as X
			
		  Group by X.Location
		
	      else	
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select X.Location,

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
	
	
	(Select   Location, DATEPART(mm,RecordDate) as M, Count(calldate) as CallsCount
	 			
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
								(RecordDate between @fromDate and dateadd(d,1,@toDate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by Location, DATEPART(mm,RecordDate)) as X
			
		  Group by X.Location
		else
			select X.Location,

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
	
	
	(Select   Location, DATEPART(mm,RecordDate) as M, Count(calldate) as CallsCount
	 			
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
								(RecordDate between @fromDate and dateadd(d,1,@toDate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by Location, DATEPART(mm,RecordDate)) as X
			
		  Group by X.Location
	
	else
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) = 0
	    
		If @divisionID > 0
		select X.Location,

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
	
	
	(Select   Location, DATEPART(mm,RecordDate) as M, Count(calldate) as CallsCount
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
							(RecordDate between @fromDate and dateadd(d,1,@toDate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by Location, DATEPART(mm,RecordDate)) as X
			
		  Group by X.Location

		Else

		select X.Location,

	  sum(case when D=1 then callsCount else 0 end) as D1,
	  sum(case when D=2 then callsCount else 0 end) as D2,
	  sum(case when D=3 then callsCount else 0 end) as D3,
	  sum(case when D=4 then callsCount else 0 end) as D4,
	  sum(case when D=5 then callsCount else 0 end) as D5,
	  sum(case when D=6 then callsCount else 0 end) as D6,
	  sum(case when D=7 then callsCount else 0 end) as D7,
	  sum(case when D=8 then callsCount else 0 end) as D8,
	  sum(case when D=9 then callsCount else 0 end) as D9,
	  sum(case when D=10 then callsCount else 0 end) as D10,
	  sum(case when D=11 then callsCount else 0 end) as D11,
	  sum(case when D=12 then callsCount else 0 end) as D12,
	  sum(case when D=13 then callsCount else 0 end) as D13,
	  sum(case when D=14 then callsCount else 0 end) as D14,
	  sum(case when D=15 then callsCount else 0 end) as D15,
	  --
	  sum(case when D=16 then callsCount else 0 end) as D16,
	  sum(case when D=17 then callsCount else 0 end) as D17,
	  sum(case when D=18 then callsCount else 0 end) as D18,
	  sum(case when D=19 then callsCount else 0 end) as D19,
	  sum(case when D=20 then callsCount else 0 end) as D20,
	  sum(case when D=21 then callsCount else 0 end) as D21,
	  sum(case when D=22 then callsCount else 0 end) as D22,
	  sum(case when D=23 then callsCount else 0 end) as D23,
	  sum(case when D=24 then callsCount else 0 end) as D24,
	  sum(case when D=25 then callsCount else 0 end) as D25,
	  sum(case when D=26 then callsCount else 0 end) as D26,
	  sum(case when D=27 then callsCount else 0 end) as D27,
	  sum(case when D=28 then callsCount else 0 end) as D28,
	  sum(case when D=29 then callsCount else 0 end) as D29,
	  sum(case when D=30 then callsCount else 0 end) as D30,
	  sum(case when D=31 then callsCount else 0 end) as D31,
	  
	  sum(callsCount) as Total
	from
	
	
	(Select   Location, DATEPART(dd,tblcallsbilled.RecordDate) as D, Count(calldate) as CallsCount 
	 			
			from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock),  tblFacility with(nolock)  WHERE
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.AgentID=  tblCommrateAgent.AgentID and
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							 tblcallsbilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@toDate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by Location, DATEPART(dd,RecordDate)) as X
			
		  Group by X.Location
		
 	end	
Else
 	

	select X.FacilityID,

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
	
	
	(Select  tblcallsbilled.FacilityID, DATEPART(mm,RecordDate) as M, Count(calldate) as CallsCount
	 			
			from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock)  WHERE
						tblcallsbilled.Billtype = tblBilltype.Billtype and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.Calltype = tblCalltype.Abrev and
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						tblcallsbilled.facilityID	= @facilityID  And
						--tblcallsbilled.agentID = @agentID and
								(RecordDate between @fromDate and dateadd(d,1,@toDate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			group by tblcallsbilled.FacilityID, DATEPART(mm,RecordDate)) as X
			
		  Group by X.FacilityID
