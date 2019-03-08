

CREATE PROCEDURE [dbo].[p_Report_billed_calls_sum_by_Friend_Family]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 
 AS


	Select    PhoneNo as [Account No] 
		,  Count(  PhoneNo) as CallsCount, CEILING( Sum( duration /60.00)   ) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) 
		   where  tblcallsBilled.FacilityID = @FacilityID and  
			 --tblDebit.FacilityID =  tblcallsBilled.FacilityID  And 
			 tblcallsBilled.errorcode = '0' and 
			(RecordDate between @fromDate and dateadd(d,1,@todate) )  and   tblPrepaid.PhoneNo = tblcallsBilled.billtono  and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
		   Group by    PhoneNo

