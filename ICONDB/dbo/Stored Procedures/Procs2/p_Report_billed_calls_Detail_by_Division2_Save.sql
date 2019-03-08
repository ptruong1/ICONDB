CREATE PROCEDURE [dbo].[p_Report_billed_calls_Detail_by_Division2_Save]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime , -- Required 
@DivisionID	int
 AS

If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0 
Begin
	IF  @DivisionID >0 
	
		Select    tblFacility.Location as Division ,fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			 dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,	   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where   tblcallsBilled.Billtype = tblBilltype.billtype and 
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				   tblANIs.FacilityID   =  tblFacility .FacilityID and   tblFacility .FacilityID =  @DivisionID	 and 
				   tblcallsBilled.AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				   and convert (int,duration ) >5    
				   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by  tblFacility.Location, RecordDate
	Else
		Select    tblFacility.Location as Division , fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			 dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacility with(nolock)
			 			   , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where   tblcallsBilled.Billtype = tblBilltype.billtype and 
							tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				   tblANIs.FacilityID   =  tblFacility .FacilityID and   
				   tblcallsBilled.AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				   and convert (int,duration ) >5   
				   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by  tblFacility.Location, RecordDate
End
Else

-------------------
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
Begin
	IF  @DivisionID >0 
	
		Select    tblFacility.Location as Division ,fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			 dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,	   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacility with(nolock), tblcommrate with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and
				   tblcallsBilled.errorcode = '0' and 
				   tblcallsBilled.FromNo = tblANIs.ANIno and
				   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and
				   tblANIs.FacilityID   =  tblFacility .FacilityID and   tblFacility .FacilityID =  @DivisionID	 and 
				   tblcallsBilled.AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				   and convert (int,duration ) >5    
				   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by  tblFacility.Location, RecordDate
	Else
		Select    tblFacility.Location as Division , fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			 dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacility with(nolock), tblcommrate with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and
				    tblcallsBilled.errorcode = '0' and 
				   tblcallsBilled.FromNo = tblANIs.ANIno and
				   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and
				   tblANIs.FacilityID   =  tblFacility .FacilityID and   
				   tblcallsBilled.AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				   and convert (int,duration ) >5   
				   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by  tblFacility.Location, RecordDate
End
Else
Begin

	IF  @DivisionID >0 
	
		Select    tblFacilityDivision.DepartmentName as Division , fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,	   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacilityDivision with(nolock), tblcommrate with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and
				   tblcallsBilled.errorcode = '0' and 
				   tblcallsBilled.FromNo = tblANIs.ANIno and
				   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and
				   tblANIs.DivisionID   =  tblFacilityDivision .DivisionID and   tblFacilityDivision .DivisionID =  @DivisionID	 and 
				   tblcallsBilled.FacilityID = @FacilityID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				   and convert (int,duration ) >5    
				   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	
	Else
		Select    tblFacilityDivision.DepartmentName as Division , fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacilityDivision with(nolock), tblcommrate with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and
				    tblcallsBilled.errorcode = '0' and 
				   tblcallsBilled.FromNo = tblANIs.ANIno and
				   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and
				   tblANIs.DivisionID   =  tblFacilityDivision .DivisionID and   
				   tblcallsBilled.FacilityID = @FacilityID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				   and convert (int,duration ) >5   
				   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			order by  tblFacilityDivision.DepartmentName, RecordDate
End
