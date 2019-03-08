CREATE PROCEDURE [dbo].[p_Report_billed_calls_Detail_by_Calltype2_Save]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@calltype	varchar(2),
@divisionID	int
 AS

--SET @calltype	 = isnull(@calltype ,'')
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0  
Begin
	IF  @calltype <> ''
	     If @divisionID > 0
		Select    Location, fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsBilled.errorcode = '0' and 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				    tblFacility .FacilityID =  @DivisionID	 and 
				   tblcallsBilled.AgentID = @AgentID  And
				   tblcallsBilled.calltype = @calltype and 
				   (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				   and convert (int,duration ) >5    
				   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by    Location, tblCalltype.Descript ,  RecordDate
	     else
		Select    Location, fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsBilled.errorcode = '0' and 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				   -- tblFacility .FacilityID =  @DivisionID	 and 
				   tblcallsBilled.AgentID = @AgentID  And
				   tblcallsBilled.calltype = @calltype and 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				 convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by    Location, tblCalltype.Descript ,  RecordDate
	
	Else
	     If @divisionID > 0
		Select    Location, fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			  where  tblcallsBilled.calltype = tblCalltype.Abrev and  
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsBilled.errorcode = '0' and 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				    tblFacility .FacilityID =  @DivisionID	 and 
				   tblcallsBilled.AgentID = @AgentID  And
				  -- tblcallsBilled.calltype = @calltype and 
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by   Location, tblCalltype.Descript ,  RecordDate
	     else
		Select    Location, fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock)
			, tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			  where  tblcallsBilled.calltype = tblCalltype.Abrev and  
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsBilled.errorcode = '0' and 
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				    --tblFacility .FacilityID =  @DivisionID	 and 
				   tblcallsBilled.AgentID = @AgentID  And
				   --tblcallsBilled.calltype = @calltype and 
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by   Location, tblCalltype.Descript ,  RecordDate
End
Else
------------------------------------------
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
Begin
	IF  @calltype <> ''
	     If @divisionID > 0
		Select    Location, fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
				  tblcallsBilled.AgentID = @AgentID  And 
				 tblcallsBilled.errorcode = '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				tblCallsBilled.facilityID = @divisionID and
				tblcallsBilled.calltype = @calltype  and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by    Location, tblCalltype.Descript ,  RecordDate
	     else
		Select    Location, fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
				  tblcallsBilled.AgentID = @AgentID  And 
				 tblcallsBilled.errorcode = '0' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				tblcallsBilled.calltype = @calltype  and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by    Location, tblCalltype.Descript ,  RecordDate
	
	Else
	     If @divisionID > 0
		Select    Location, fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   tblcallsBilled.errorcode = '0' and  tblcallsBilled.AgentID = @AgentID    And
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			tblCallsBilled.facilityID = @divisionID and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by   Location, tblCalltype.Descript ,  RecordDate
	     else
		Select    Location, fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblFacility with(nolock), tblcommrateAgent with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   tblcallsBilled.errorcode = '0' and  tblcallsBilled.AgentID = @AgentID    And
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by   Location, tblCalltype.Descript ,  RecordDate
End
Else
Begin
	IF  @calltype <> ''
	
		Select    fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock)  , tblCalltype  with(nolock) , tblcommrate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and  
				 tblcallsBilled.FacilityID = @FacilityID  And 
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsBilled.errorcode = '0' and 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				tblcallsBilled.calltype = @calltype  and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by    tblCalltype.Descript ,  RecordDate 
	
	Else
		Select    fromno,tono, RecordDate   , tblCalltype.Descript  as CallType,
			dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			CallRevenue 
			  from tblcallsBilled  with(nolock), tblCalltype  with(nolock) , tblcommrate with(nolock)
			   where  tblcallsBilled.calltype = tblCalltype.Abrev and   tblcallsBilled.errorcode = '0'
			   and tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and 
			    tblcallsBilled.FacilityID = @FacilityID  And
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by    tblCalltype.Descript ,  RecordDate
End
