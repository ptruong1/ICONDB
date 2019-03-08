CREATE PROCEDURE [dbo].[p_Report_billed_calls_Detail_by_Billtype1]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime , -- Required 
@Billtype	varchar(2)
 AS

SET @Billtype = isnull(@Billtype,'')
If( @AgentID >1  and @facilityID =0 ) 
Begin
	IF  @Billtype <>'' 
	
		Select   fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and  
				 tblcallsBilled.errorcode = '0' and   AgentID =@AgentID  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				tblcallsBilled.BillType  = @Billtype and convert (int,duration ) >15    AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
				
	Else
		Select   fromNo, Tono,RecordDate,   tblBilltype.Descript as   BillType ,
			  CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock),  tblBilltype  with(nolock)
			   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   AgentID =@AgentID  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
		ORDER by BillType
End
Else
Begin
	IF  @Billtype <>'' 
	
		Select   fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
			  CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock), tblBilltype  with(nolock)
			   where  tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   FacilityID = @FacilityID  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
				tblcallsBilled.BillType  = @Billtype and convert (int,duration ) >15    AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
				
	Else
		Select   fromNo, Tono,RecordDate,   tblBilltype.Descript as   BillType ,
			 CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration,
			   CallRevenue 
			  from tblcallsBilled  with(nolock),  tblBilltype  with(nolock)
			   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
				 tblcallsBilled.errorcode = '0' and   FacilityID = @FacilityID  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
		ORDER by BillType
end
