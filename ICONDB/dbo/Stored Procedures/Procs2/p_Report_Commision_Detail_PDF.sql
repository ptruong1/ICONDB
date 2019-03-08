CREATE PROCEDURE [dbo].[p_Report_Commision_Detail_PDF]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@DivisionID	int
AS

If(@AgentID	>1 AND @facilityID =0 )
 	Begin
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) > 0
	   if @divisionID > 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select Calldate as 'Call Date', Location, tblbilltype.Descript as 'Bill type' , tblCallType.Descript as 'Call type' , 
			 fromno as 'Station ID' ,tono as 'Destination No', CONVERT(VARCHAR(8),RecordDate,108) AS 'Connect Time',
			
			 dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as Duration,  
			CallRevenue as 'Call Revenue', cast(tblCommrateAgent.CommRate * 100 as Numeric(12,4)) as 'Comm Rate', 
				(CASE PifPaid  when 0 then  
				CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else 
				 CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    
				 End)  as 'Comm Paid'
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
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			Order by tblcallsbilled.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		else
			select Calldate as 'Call Date',  Location, tblbilltype.Descript as 'Bill type' , tblCallType.Descript as 'Call type' , 
			fromno as 'Station ID' ,tono as 'Destination No', CONVERT(VARCHAR(8),RecordDate,108) AS 'Connect Time',
			
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as 'Duration',  CallRevenue as 'Call Revenus',  
				Cast(tblCommrate.CommRate * 100 as Numeric(12,4)) as 'Comm Rate', 
				(CASE PifPaid  when 0 then  
				CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else 
				 CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    
				 End)  as 'Comm Paid'
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
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			Order by tblcallsbilled.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		
	      else	
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			select Calldate as 'Call Date',  Location, tblbilltype.Descript as 'Bill type' , tblCallType.Descript as 'Call type' ,
			fromno as 'Station ID',tono as 'Destination No', CONVERT(VARCHAR(8),RecordDate,108) AS 'Connect Time',
			 
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as 'Duration',  CallRevenue as 'Call Revenue', 
				 Cast(tblCommrateAgent.CommRate * 100 as Numeric(12,4)) as 'Comm Rate', 
				(CASE PifPaid  when 0 then  
				CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else
				  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)   
				   End)  as 'Comm Paid'
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
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			Order by tblcallsbilled.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		else
			select Calldate as 'Call Date',  Location,  tblbilltype.Descript as 'Bill type' , tblCallType.Descript as 'Call type' , 
			 fromno as 'Station ID',tono as 'Destination No', CONVERT(VARCHAR(8),RecordDate,108) AS 'Connect Time',
			
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as 'Duration',  CallRevenue as 'Call Revenue', 
				 Cast(tblCommrate.CommRate * 100 as Numeric(12,4)) as 'Comm Rate', 
				(CASE PifPaid  when 0 then  
				CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else
				  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)   
				   End)  as 'Comm Paid'
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
								(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
			Order by tblcallsbilled.calldate, Location, tblbilltype.Descript, tblCallType.Descript
	
	else
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) = 0
	    
		If @divisionID > 0
			select Calldate as 'Call Date' ,  Location,  tblbilltype.Descript as 'Bill type' , tblCallType.Descript as 'Call type' ,
			fromno as 'Station ID' ,tono as 'Desrination No', 
			 CONVERT(VARCHAR(8),RecordDate,108) AS 'Connect Time', 
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as 'Duration',  CallRevenue as 'Call Revenue',
			 Cast(tblCommrateAgent.CommRate * 100 as Numeric(12,4)) as 'Comm Rate', 
			(CASE PifPaid  when 0 then  
			CAST((( CallRevenue  )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
			 Else 
			 CAST((( CallRevenue - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    
			 End)  as 'Comm Paid'
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
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		Order by tblcallsbilled.calldate, Location, tblbilltype.Descript, tblCallType.Descript

		Else

		select Calldate as 'Call Date', Location, tblbilltype.Descript as 'Bill type' , tblCallType.Descript as 'Call type' ,
		fromno as 'Station ID',tono as 'Destination No', CONVERT(VARCHAR(8),RecordDate,108) AS 'Connect Time',
		 
		  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as 'Duration',  CallRevenue as 'Call Revenue',
			Cast(tblCommrateAgent.CommRate * 100 as Numeric(12,4)) as 'Comm Rate', 
			(CASE PifPaid  when 0 then  
			CAST((( CallRevenue  )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
			 Else 
			 CAST((( CallRevenue - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)   
			  End)  as 'Comm Paid'
			from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock),  tblFacility with(nolock)  WHERE
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.AgentID=  tblCommrateAgent.AgentID and
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							 tblcallsbilled.agentID = @agentID and
							(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
							and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
		Order by tblcallsbilled.calldate, Location, tblbilltype.Descript, tblCallType.Descript
		
 	end	
Else
 	

	select Calldate as 'Call Date', tblbilltype.Descript as 'Bill type' , tblCallType.Descript as 'Call type' ,
	fromno as 'Station ID',tono as 'Destination No', CONVERT(VARCHAR(8),RecordDate,108) AS 'Connect Time',
		dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as 'Duration',  CallRevenue as 'Call Revenue',  
		Cast(tblCommrate.CommRate * 100  as Numeric(12,4)) as 'Comm Rate',
		(CASE PifPaid  when 0 then  
		CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
		 Else
		 CAST((( CallRevenue - (CallRevenue * isnull(BadDebtRate,0) ) -isnull(Pif,0) )  *tblCommrate.CommRate)  as Numeric(12,4) ) + isnull( PIf,0)    
		  End)  as 'Comm Paid' 
		from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock)  WHERE
						tblcallsbilled.Billtype = tblBilltype.Billtype and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.Calltype = tblCalltype.Abrev and
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						tblcallsbilled.facilityID	= @facilityID  And
						--tblcallsbilled.agentID = @agentID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
	Order by tblcallsbilled.calldate, tblbilltype.Descript, tblCallType.Descript
