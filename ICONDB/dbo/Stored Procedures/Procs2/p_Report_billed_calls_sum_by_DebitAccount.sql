

CREATE PROCEDURE [dbo].[p_Report_billed_calls_sum_by_DebitAccount]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 
 AS

If( @AgentID >1  and @facilityID =0 ) 
Begin
	Select    AccountNo  
		,  Count( AccountNo) as CallsCount, CEILING( Sum( duration /60.00)   ) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) 
		   where  tblcallsBilled.AgentID = @AgentID and  
			
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0' and   tblDebit.AccountNo = tblcallsBilled.CreditcardNo  and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
		   Group by   AccountNo
End
Else
Begin
	Select    AccountNo  
		,  Count( AccountNo) as CallsCount, CEILING( Sum( duration /60.00)   ) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) 
		   where  tblcallsBilled.FacilityID = @FacilityID and  
			 --tblDebit.FacilityID =  tblcallsBilled.FacilityID  And 
			 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and tblcallsBilled.errorcode = '0' and   tblDebit.AccountNo = tblcallsBilled.CreditcardNo  and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
		   Group by   AccountNo
end

