CREATE PROCEDURE [dbo].[p_Report_billed_calls_Detail_by_Billtype2]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime , -- Required 
@Billtype	varchar(2),
@divisionID	int
 AS

--SET @Billtype = isnull(@Billtype,'')
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0   
Begin
	IF  @Billtype <>'' 
	     If @divisionID > 0
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location, fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  
			   tblBilltype.Billtype = tblcallsBilled.billtype and  
				 tblcallsBilled.errorcode = '0' and  
				 tblCallsBilled.AgentID =@AgentID  And 
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				 tblcallsBilled.BillType  = @Billtype and
				tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				 convert (int,duration ) >5    
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				ORDER by Location, BillType
				else
				Select   Location, fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock)
			   where  
			   tblBilltype.Billtype = tblcallsBilled.billtype and  
				 tblcallsBilled.errorcode = '0' and  
				 tblCallsBilled.AgentID =@AgentID  And 
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				 tblcallsBilled.BillType  = @Billtype and
				tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				 convert (int,duration ) >5    
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				ORDER by Location, BillType
	     else
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location, fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and  
				 tblcallsBilled.errorcode = '0' and  
				 tblCallsBilled.AgentID =@AgentID  And 
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
			 tblcallsBilled.BillType  = @Billtype and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				 convert (int,duration ) >5    
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				ORDER by Location, BillType
			else
				Select   Location, fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and  
				 tblcallsBilled.errorcode = '0' and  
				 tblCallsBilled.AgentID =@AgentID  And 
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
			 tblcallsBilled.BillType  = @Billtype and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				 convert (int,duration ) >5    
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				ORDER by Location, BillType
	Else
	     If @divisionID > 0
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location, fromNo, Tono,RecordDate,   tblBilltype.Descript as   BillType ,
			 dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock),  tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   
				 tblCallsBilled.AgentID =@AgentID  And 
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		ORDER by Location, BillType
		else
		Select   Location, fromNo, Tono,RecordDate,   tblBilltype.Descript as   BillType ,
			 dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock),  tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock)
			   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   
				 tblCallsBilled.AgentID =@AgentID  And 
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		ORDER by Location, BillType
	     else
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location, fromNo, Tono,RecordDate,   tblBilltype.Descript as   BillType ,
			 dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock),  tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock)
			   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   
				 tblCallsBilled.AgentID =@AgentID  And 
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		ORDER by Location, BillType
		else
		Select   Location, fromNo, Tono,RecordDate,   tblBilltype.Descript as   BillType ,
			 dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock),  tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock)
			   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   
				 tblCallsBilled.AgentID =@AgentID  And 
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblcallsbilled.FacilityID =  tblFacility.FacilityID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		ORDER by Location, BillType


End
Else
---------------------------
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
Begin
	IF  @Billtype <>'' 
	     If @divisionID > 0
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location, fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblcommrateAgent with(nolock)
			   where  
			   tblBilltype.Billtype = tblcallsBilled.billtype and  
				 tblcallsBilled.errorcode = '0' and  
				 tblCallsBilled.AgentID =@AgentID  And 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsBilled.BillType  = @Billtype and
				tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				 convert (int,duration ) >5    
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				ORDER by Location, BillType
			else
				Select   Location, fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblCommrate with(nolock)
			   where  
			   tblBilltype.Billtype = tblcallsBilled.billtype and  
				 tblcallsBilled.errorcode = '0' and  
				 tblCallsBilled.AgentID =@AgentID  And 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsBilled.BillType  = @Billtype and
				tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				 convert (int,duration ) >5    
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				ORDER by Location, BillType
	     else
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location, fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblcommrateAgent with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and  
				 tblcallsBilled.errorcode = '0' and  
				 tblCallsBilled.AgentID =@AgentID  And 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
			 tblcallsBilled.BillType  = @Billtype and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				 convert (int,duration ) >5    
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				ORDER by Location, BillType
			else
				Select   Location, fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblCommrate with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and  
				 tblcallsBilled.errorcode = '0' and  
				 tblCallsBilled.AgentID =@AgentID  And 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
			 tblcallsBilled.BillType  = @Billtype and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				 convert (int,duration ) >5    
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				ORDER by Location, BillType

	Else
	     If @divisionID > 0
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location, fromNo, Tono,RecordDate,   tblBilltype.Descript as   BillType ,
			 dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock),  tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblcommrateAgent with(nolock)
			   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   
				 tblCallsBilled.AgentID =@AgentID  And 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		ORDER by Location, BillType
		else
		Select   Location, fromNo, Tono,RecordDate,   tblBilltype.Descript as   BillType ,
			 dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock),  tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblCommrate with(nolock)
			   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   
				 tblCallsBilled.AgentID =@AgentID  And 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				tblCallsBilled.facilityID = @divisionID and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		ORDER by Location, BillType

	     else
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select   Location, fromNo, Tono,RecordDate,   tblBilltype.Descript as   BillType ,
			 dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock),  tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblcommrateAgent with(nolock)
			   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   
				 tblCallsBilled.AgentID =@AgentID  And 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		ORDER by Location, BillType
		else
		Select   Location, fromNo, Tono,RecordDate,   tblBilltype.Descript as   BillType ,
			 dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock),  tblBilltype  with(nolock), tblFacility with(nolock)
			  , tblCommrate with(nolock)
			   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   
				 tblCallsBilled.AgentID =@AgentID  And 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		ORDER by Location, BillType
End
Else
Begin
	IF  @Billtype <>'' 
	if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select   fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			   dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblCommrateAgent with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   tblcallsbilled.FacilityID = @FacilityID  And 
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				tblcallsBilled.BillType  = @Billtype and convert (int,duration ) >5    
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	else
	
		Select   fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			   dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblcommrate with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   tblcallsbilled.FacilityID = @FacilityID  And 
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				tblcallsBilled.BillType  = @Billtype and convert (int,duration ) >5    
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				
	Else
	if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select   fromNo, Tono,RecordDate,   tblBilltype.Descript as   BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock),  tblBilltype  with(nolock), tblCommrateAgent with(nolock)
			   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   tblcallsbilled.FacilityID = @FacilityID  And
				 tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		ORDER by BillType
	else
		Select   fromNo, Tono,RecordDate,   tblBilltype.Descript as   BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock),  tblBilltype  with(nolock), tblcommrate with(nolock)
			   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   tblcallsbilled.FacilityID = @FacilityID  And
				 tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		ORDER by BillType
end
