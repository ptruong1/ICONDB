CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_Location2]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@LocationID	int
AS

If( @AgentID >1  and @facilityID =0 ) 
Begin
	IF  @LocationID >0 
	
		Select    tblFacilityLocation.Descript as Location , Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,	   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacilityLocation  with(nolock), tblcommrate with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and
				   tblcallsBilled.errorcode = '0' and
				   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and 
				   tblcallsBilled.FromNo = tblANIs.ANIno and
				   tblANIs.LocationID   =  tblFacilityLocation.LocationID  and   tblFacilityLocation.LocationID =  @LocationID	 and 
				   tblcallsBilled.AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				   and convert (int,duration ) >5   
				   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
	
	Else
		Select    tblFacilityLocation.Descript as Location , Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,	   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacilityLocation  with(nolock), tblcommrate with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and
				    tblcallsBilled.errorcode = '0' and
				    tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and 
				   tblcallsBilled.FromNo = tblANIs.ANIno and
				   tblANIs.LocationID   =  tblFacilityLocation.LocationID and 
				   tblcallsBilled.AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				   and convert (int,duration ) >5  
				   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
End
Else
Begin
	IF  @LocationID >0 
	
		Select    tblFacilityLocation.Descript as Location , Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,	   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacilityLocation  with(nolock), tblcommrate with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and
				   tblcallsBilled.errorcode = '0' and
				   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and 
				   tblcallsBilled.FromNo = tblANIs.ANIno and
				   tblANIs.LocationID   =  tblFacilityLocation.LocationID  and   tblFacilityLocation.LocationID =  @LocationID	 and 
				   tblcallsBilled.FacilityID = @FacilityID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				   and convert (int,duration ) >5   
				   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
	
	Else
		Select    tblFacilityLocation.Descript as Location , Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration,	   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacilityLocation  with(nolock), tblcommrate with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and
				    tblcallsBilled.errorcode = '0' and 
				    tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and
				   tblcallsBilled.FromNo = tblANIs.ANIno and
				   tblANIs.LocationID   =  tblFacilityLocation.LocationID and 
				   tblcallsBilled.FacilityID = @FacilityID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				   and convert (int,duration ) >5  
				   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
End
