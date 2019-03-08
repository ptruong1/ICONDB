CREATE PROCEDURE [dbo].[p_Report_billed_calls_Detail_by_Division2_Test]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime , -- Required 
@DivisionID	int
 AS

If( @AgentID >1  and @facilityID =0 ) 
Begin
	IF  @DivisionID >0 
	
		Select    tblFacility.Location as Division ,fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			 dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,	   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacility with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and
				   tblcallsBilled.errorcode = '0' and 
				   tblcallsBilled.FromNo = tblANIs.ANIno and
				   tblANIs.FacilityID   =  tblFacility .FacilityID and   tblFacility .FacilityID =  @DivisionID	 and 
				   tblcallsBilled.AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5    AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
			order by  tblFacility.Location, RecordDate
	Else
		Select    tblFacility.Location as Division , fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			 dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacility with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and
				    tblcallsBilled.errorcode = '0' and 
				   tblcallsBilled.FromNo = tblANIs.ANIno and
				   tblANIs.FacilityID   =  tblFacility .FacilityID and   
				   tblcallsBilled.AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
			order by  tblFacility.Location, RecordDate
End
Else
Begin

	IF  @DivisionID >0 
	
		Select    tblFacilityDivision.DepartmentName as Division , fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,	   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacilityDivision with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and
				   tblcallsBilled.errorcode = '0' and 
				   tblcallsBilled.FromNo = tblANIs.ANIno and
				   tblANIs.DivisionID   =  tblFacilityDivision .DivisionID and   tblFacilityDivision .DivisionID =  @DivisionID	 and 
				   tblcallsBilled.FacilityID = @FacilityID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5    AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	
	Else
		Select    tblFacilityDivision.DepartmentName as Division , fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )   as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacilityDivision with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and
				    tblcallsBilled.errorcode = '0' and 
				   tblcallsBilled.FromNo = tblANIs.ANIno and
				   tblANIs.DivisionID   =  tblFacilityDivision .DivisionID and   
				   tblcallsBilled.FacilityID = @FacilityID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
			order by  tblFacilityDivision.DepartmentName, RecordDate
End
