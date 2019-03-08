
CREATE PROCEDURE [dbo].[p_Chart_Agent_Dashboard_CallVideo_Lastdays]
@AgentID  int, 
@LastDays varchar(10)

 AS
--DATE_FORMAT(somedate, "%d/%l/%Y")
(select CONVERT(CHAR(10),RecordDate,101) as days, count(CallRevenue) as CallCount, 1 as recordID     
 from tblcallsBilled   WITH(NOLOCK) 
		where RecordDate between @LastDays and  dateadd(day,datediff(day,0,GETDATE()),0) and 
            tblcallsBilled.errorcode = '0' and
		   convert (int,duration ) >5 and 
		   tblcallsBilled.FacilityID in (select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1)
		   group by CONVERT(CHAR(10),RecordDate,101)
                    
Union
select CONVERT(CHAR(10),ApmDate,101) as days, count(TotalCharge) as VideoCount,  2 as recordID from tblVisitEnduserSchedule   WITH(NOLOCK) 
where ApmDate between @LastDays and  dateadd(day,datediff(day,0,GETDATE()),-1) and
      tblVisitEnduserSchedule.FacilityID  in (select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1)
       and (status = '5' )
 group by CONVERT(CHAR(10),ApmDate,101))
 order by recordid, days desc
                    
