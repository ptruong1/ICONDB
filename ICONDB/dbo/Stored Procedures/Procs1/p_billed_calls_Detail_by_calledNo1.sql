
CREATE PROCEDURE [dbo].[p_billed_calls_Detail_by_calledNo1]
@calledNo	varchar(18), -- Required
@fromDate	date,   -- Required
@toDate	date  -- Required

AS


Begin
	
	
	Select   fromCity, FromState , Tono, tocity, toState, RecordDate As Calldate,  tblBilltype.Descript  as  BillType ,
			  dbo.fn_ConvertSecToMin( duration) as CallDuration, CAST (CallRevenue  as smallmoney) as CallRevenue
			  from tblcallsBilled  with(nolock) Inner join tblBilltype  with(nolock) on tblBilltype.Billtype = tblcallsBilled.billtype
			   where  
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) 
				and ToNo = @calledNo
				
End

