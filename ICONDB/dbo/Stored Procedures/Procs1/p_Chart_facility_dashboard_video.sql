
CREATE PROCEDURE [dbo].[p_Chart_facility_dashboard_video]
@FacilityID  int ,
@AgentID   int,
@day varchar(11)

 AS
Begin
	    select CONVERT(CHAR(10),ApmDate,112) as days, count(TotalCharge) as VideoCount	from tblVisitEnduserSchedule   WITH(NOLOCK) 
		where 	
		ApmDate >=DATEADD(day, -7, getdate() )and
			tblVisitEnduserSchedule.FacilityID = @FacilityID	
			and (status = '5' or status = '3')
	
		group by CONVERT(CHAR(10),ApmDate,112)
			order by days
	

End

