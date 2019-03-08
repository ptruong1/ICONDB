CREATE PROCEDURE [dbo].[p_Report_billed_calls_Detail_by_Location1]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime , -- Required 
@LocationID	int
 AS


If( @AgentID >1  and @facilityID =0 ) 
Begin
	IF  @LocationID >0 
	
		Select    tblFacilityLocation.Descript as Location , Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, 		   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacilityLocation  with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and
				   tblcallsBilled.errorcode = '0' and 
				   tblcallsBilled.FromNo = tblANIs.ANIno and
				   tblANIs.LocationID   =  tblFacilityLocation.LocationID  and   tblFacilityLocation.LocationID =  @LocationID	 and 
				   tblcallsBilled.AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	
	Else
		Select    tblFacilityLocation.Descript as Location , Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, 		   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacilityLocation  with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and
				    tblcallsBilled.errorcode = '0' and 
				   tblcallsBilled.FromNo = tblANIs.ANIno and
				   tblANIs.LocationID   =  tblFacilityLocation.LocationID and 
				   tblcallsBilled.AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15  AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
End
Else
Begin
	IF  @LocationID >0 
	
		Select    tblFacilityLocation.Descript as Location , Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, 		   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacilityLocation  with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and
				   tblcallsBilled.errorcode = '0' and 
				   tblcallsBilled.FromNo = tblANIs.ANIno and
				   tblANIs.LocationID   =  tblFacilityLocation.LocationID  and   tblFacilityLocation.LocationID =  @LocationID	 and 
				   tblcallsBilled.FacilityID = @FacilityID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	
	Else
		Select    tblFacilityLocation.Descript as Location , Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, 		   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblANIs with(nolock) , tblFacilityLocation  with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and
				    tblcallsBilled.errorcode = '0' and 
				   tblcallsBilled.FromNo = tblANIs.ANIno and
				   tblANIs.LocationID   =  tblFacilityLocation.LocationID and 
				   tblcallsBilled.FacilityID = @FacilityID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15  AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
End
