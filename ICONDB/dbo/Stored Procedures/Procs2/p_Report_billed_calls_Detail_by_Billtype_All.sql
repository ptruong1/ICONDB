
CREATE PROCEDURE [dbo].[p_Report_billed_calls_Detail_by_Billtype_All]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime , -- Required 
@Billtype	varchar(2)
 AS

SET @Billtype = isnull(@Billtype,'')
if @FacilityID > 0
Begin
	IF  @Billtype <>'' 

	Select   tblCallsBilled.FacilityID,DepartmentName, fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
		  dbo.fn_ConvertSecToMin( duration) as CallDuration,
		   CallRevenue 
		  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblFacilityDivision
		   where  tblBilltype.Billtype = tblcallsBilled.billtype and 
			 tblcallsBilled.errorcode = '0' and   tblCallsBilled.FacilityID = @FacilityID  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
			tblcallsBilled.BillType  = @Billtype and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
			
	Else
	Select    tblCallsBilled.FacilityID,DepartmentName, fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
		  dbo.fn_ConvertSecToMin( duration) as CallDuration,
		   CallRevenue 
		  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblFacilityDivision
		   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
			 tblcallsBilled.errorcode = '0' and   tblCallsBilled.FacilityID = @FacilityID  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	ORDER by BillType
End
else
Begin
	IF  @Billtype <>'' 

	Select    tblCallsBilled.FacilityID,DepartmentName, fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
		  dbo.fn_ConvertSecToMin( duration) as CallDuration,
		   CallRevenue 
		  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblFacilityDivision
		   where  tblBilltype.Billtype = tblcallsBilled.billtype and 
			 tblcallsBilled.errorcode = '0' and   
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and 
			tblcallsBilled.BillType  = @Billtype and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
			
	Else
	Select    tblCallsBilled.FacilityID,DepartmentName, fromNo, Tono,RecordDate,  tblBilltype.Descript  as  BillType ,
		  dbo.fn_ConvertSecToMin( duration) as CallDuration,
		   CallRevenue 
		  from tblcallsBilled  with(nolock), tblBilltype  with(nolock), tblFacilityDivision
		   where   tblBilltype.Billtype = tblcallsBilled.billtype and 
			 tblcallsBilled.errorcode = '0' and    
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	ORDER by BillType
End

