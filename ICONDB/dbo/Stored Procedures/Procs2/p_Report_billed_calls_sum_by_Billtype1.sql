CREATE PROCEDURE [dbo].[p_Report_billed_calls_sum_by_Billtype1]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 
 AS

If( @AgentID >1  and @facilityID =0 ) 
begin
	Select  tblBilltype.Descript   as   BilledType 
		,  Count( tblBilltype.Descript ) as CallsCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock) ,   tblBilltype with (nolock)  where   tblcallsBilled.Billtype = tblBilltype.billtype and
		     AgentID = @AgentID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
		   Group by tblBilltype.Descript
End
Else
begin
	Select  tblBilltype.Descript   as   BilledType 
		,  Count( tblBilltype.Descript ) as CallsCount, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock) ,   tblBilltype with (nolock)  where   tblcallsBilled.Billtype = tblBilltype.billtype and
		     FacilityID = @FacilityID  And (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
		   Group by tblBilltype.Descript
End
