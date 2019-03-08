
CREATE PROCEDURE [dbo].[p_Chart_Dashboard_CallVideo_ByHour]
@FacilityID  int 
AS
--(Select   Left(ConnectTime,2) as [Hour],  Count(Left(CallDate,2) ) as CallsCount, 1 as recordID   
--from tblcallsBilled  with(nolock), tblcommrate with(nolock)
--where  tblcallsbilled.FacilityID = 352  and  tblcallsBilled.errorcode = '0' and
--       tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
--	   tblcallsbilled.Billtype =  tblCommrate.billtype and
--	   tblcallsbilled.Calltype = tblCommrate.Calltype and
--	   convert(varchar(10), RecordDate, 102)  = convert(varchar(10), getdate(), 102) and
--	   convert (int,duration ) >5   and
--	   tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
--Group by Left(connectTime,2) ----> COUNT BASED ON COMMISSION
-- COUNT BASED ON CALLBILLED 
(Select   Left(ConnectTime,2) as [Hour],  Count(Left(CallDate,2) ) as CallsCount, 1 as recordID   
from tblcallsBilled  with(nolock)
where  FacilityID = @FacilityID  and  errorcode = '0' and
       convert(varchar(10), RecordDate, 102)  = convert(varchar(10), getdate(), 102) and
	   convert (int,duration ) >5  
Group by Left(connectTime,2)
                    
Union
Select LEFT(ApmTime, 2) as [Hour], COUNT(LEFT(ApmTime, 2))  as CallsCount, 2 as recordID   
from tblVisitEnduserSchedule
where FacilityID = @FacilityID and 
      convert(varchar(10), ApmDate, 102)  = convert(varchar(10), getdate(), 102) and
      status = 5
Group by LEFT(ApmTime, 2))
 order by recordid, Hour asc

       
 
