
CREATE PROCEDURE [dbo].[p_Chart_Dashboard_CallVideo_ByWeek]
@FacilityID  int

AS
(select DATENAME(weekday, RecordDate) as days, count(CallRevenue) as CallCount, 1 as recordID,
 ( case DATENAME(weekday, RecordDate) 
	WHEN 'Monday' THEN 1 
	  WHEN 'Tuesday' THEN 2
     WHEN 'Wednesday' THEN 3
     WHEN 'Thursday' THEN 4
     WHEN 'Friday' THEN 5
     WHEN 'Saturday' THEN 6
     WHEN 'Sunday' THEN 7
 end
 )as ConvertdaytoNumber
from tblCallsBilled  WITH(NOLOCK) 
where RecordDate between DATEADD(week, DATEDIFF(day, 0, GETDATE())/7, 0) and  dateadd(d,1,GETDATE())
      and FacilityID = @FacilityID
      and errorcode = '0'
group by DATENAME(weekday, RecordDate)
                    
Union all
select DATENAME(weekday, ApmDate) as days, count(TotalCharge) as VideoCount,  2 as recordID,
( case DATENAME(weekday,ApmDate ) 
	WHEN 'Monday' THEN 1 
	  WHEN 'Tuesday' THEN 2
     WHEN 'Wednesday' THEN 3
     WHEN 'Thursday' THEN 4
     WHEN 'Friday' THEN 5
     WHEN 'Saturday' THEN 6
     WHEN 'Sunday' THEN 7
 end
 )as ConvertdaytoNumber 
from tblVisitEnduserSchedule   WITH(NOLOCK) 
where ApmDate between DATEADD(week, DATEDIFF(day, 0, GETDATE())/7, 0) and  dateadd(d,1,GETDATE())
       and FacilityID = @FacilityID
       and (status = '5' )
 group by DATENAME(weekday, ApmDate))
 
 order by recordID, ConvertdaytoNumber
