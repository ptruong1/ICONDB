
CREATE PROCEDURE [dbo].[p_Chart_Dashboard_CallVideo_ByMonth]
@FacilityID  int
AS
declare @today date; 
declare @startDate date; 
set @today = CURRENT_TIMESTAMP;
set @startDate = dateadd(day, -(day(@today)) + 1, @today)
(select CONVERT(CHAR(10),RecordDate,101) as days, count(CallRevenue) as CallCount, 1 as recordID     
 from tblcallsBilled   WITH(NOLOCK) 
		where RecordDate between @startDate and  dateadd(d,1,GETDATE()) and 
             tblcallsBilled.errorcode = '0' and
             tblcallsBilled.FacilityID = @FacilityID
       group by CONVERT(CHAR(10),RecordDate,101)
                    
Union
select CONVERT(CHAR(10),ApmDate,101) as days, count(TotalCharge) as VideoCount,  2 as recordID from tblVisitEnduserSchedule   WITH(NOLOCK) 
where ApmDate between @startDate and  dateadd(d,1,GETDATE()) and
      tblVisitEnduserSchedule.FacilityID = @FacilityID
       and (status = '5' )
 group by CONVERT(CHAR(10),ApmDate,101))
 order by recordid, days asc
                    


