

CREATE PROCEDURE [dbo].[p_Report_billed_calls_sum_by_PIN]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 
 AS


If( @AgentID >1  and @facilityID =0 ) 
begin
	Select    PIN  
		,  Count( PIN) as CallsCount, CAST( Sum( cast(duration as int )/60.00)  as numeric(6,2) ) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock) 
		   where  tblcallsBilled.AgentID = @AgentID   And   tblcallsBilled.errorcode = '0' and  (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
			
		   Group by  PIN
end
else
begin
Select    PIN  
		,  Count( PIN) as CallsCount, CAST( Sum( cast(duration as int )/60.00)  as numeric(6,2) ) as TotalMinutes,
		sum(CallRevenue ) As TotalRevenue
		  from tblcallsBilled  with(nolock) 
		   where  tblcallsBilled.FacilityID = @FacilityID   And   tblcallsBilled.errorcode = '0' and  (RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
			
		   Group by  PIN
end

