
CREATE PROCEDURE [dbo].[p_Report_Calls_Attempt_total]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime ,
@total	int  OUTPUT

 AS
SET NOCOUNT ON
Declare @t1 int , @t2 int


	Select  @t1= count(tblcallsBilled.fromNo) from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock)
	  where   tblcallsBilled.Billtype = tblBilltype.billtype and  
		--AgentID = @AgentID and
		(RecordDate between @fromDate and dateadd(d,1,@todate) ) and errorcode ='0' and
		 tblcallsBilled.FacilityID = @FacilityID    and   duration >10  
		

	select @t2 = count(fromNo)  	 from tblcallsUnbilled   with(nolock) , tblErrortype  with(nolock), tblBilltype with(nolock) 
	where  tblBilltype.Billtype =  tblcallsUnbilled.Billtype and
		 tblErrortype.errorType >0  and 
		 tblErrortype.errorType = tblcallsUnbilled.errorType  and 
		FacilityID	= @FacilityID and (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
SET @total = @t1 + @t2

