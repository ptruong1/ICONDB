
CREATE PROCEDURE [dbo].[p_Chart_facility_dashboard]
@FacilityID  int, 
@Last15Days varchar(10)

 AS
--DATE_FORMAT(somedate, "%d/%l/%Y")
(select CONVERT(CHAR(10),RecordDate,101) as days, count(CallRevenue) as CallCount, 1 as recordID     
 from tblcallsBilled   WITH(NOLOCK) 
		where RecordDate between @Last15Days and  dateadd(d,1,GETDATE()) and 
             tblcallsBilled.errorcode = '0' and
             tblcallsBilled.FacilityID = @FacilityID
       group by CONVERT(CHAR(10),RecordDate,101)
                    
Union
select CONVERT(CHAR(10),ApmDate,101) as days, count(TotalCharge) as VideoCount,  2 as recordID from tblVisitEnduserSchedule   WITH(NOLOCK) 
where ApmDate between @Last15Days and  dateadd(d,1,GETDATE()) and
      tblVisitEnduserSchedule.FacilityID = @FacilityID
       and (status = '5' )
 group by CONVERT(CHAR(10),ApmDate,101))
 order by recordid, days desc
                    


