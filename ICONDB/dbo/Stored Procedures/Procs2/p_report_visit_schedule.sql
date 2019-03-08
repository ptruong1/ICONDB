-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_report_visit_schedule] 
@FacilityID int,
@Status tinyint
AS
BEGIN
	if(@status = 1 or @status = 2)
	 begin
		select  a.ApmNo as VisitConfirmNumber, IsNULL( b.EntityID,'NA')  EntityID, CASE c.VisitRemain When -1 then 0 else c.VisitRemain end VisitBalance , DATEADD (MINUTE,datepart(MINUTE, Apmtime),  DATEADD(hour,  datepart(hour, Apmtime),ApmDate)) ApmDateTime, a.InmateID
		from tblVisitEnduserSchedule a,  tblVisitors b, tblVisitInmateConfig c
		where a.visitorID = b.visitorID and
		  a.inmateid = c.inmateID and
		  a.facilityID = c.facilityID and  
		  c.facilityID = @facilityID and
		  a.Status = @status and  
		   a.apmdate > DATEADD(DAY,1, getdate() ) and
		  (a.SendJMS =0 or a.SendJMS is null) ;
	

			Update tblVisitEnduserSchedule  set SendJMS =1 from tblVisitEnduserSchedule a,  tblVisitors b, tblVisitInmateConfig c
			where a.visitorID = b.visitorID and
			  a.inmateid = c.inmateID and
			  a.facilityID = c.facilityID and  
			  c.facilityID = @facilityID and
			  a.Status = @status and  
			  a.apmdate > DATEADD(DAY, 1, getdate() ) and
			  (a.SendJMS =0 or a.SendJMS is null) ;
	  end
    else if(@status = 4 )
	 begin
		select  a.ApmNo as VisitConfirmNumber, IsNULL( b.EntityID,'NA')  EntityID, CASE c.VisitRemain When -1 then 0 else c.VisitRemain end VisitBalance , DATEADD (MINUTE,datepart(MINUTE, Apmtime),  DATEADD(hour,  datepart(hour, Apmtime),ApmDate)) ApmDateTime, a.InmateID
		from tblVisitEnduserSchedule a,  tblVisitors b, tblVisitInmateConfig c
		where a.visitorID = b.visitorID and
		  a.inmateid = c.inmateID and
		  a.facilityID = c.facilityID and  
		  c.facilityID = @facilityID and
		  a.Status = @status and  
		   a.apmdate > DATEADD(DAY, -1, getdate() ) and
		  (a.SendJMS =1 ) ;
	

			Update tblVisitEnduserSchedule  set SendJMS =4 from tblVisitEnduserSchedule a,  tblVisitors b, tblVisitInmateConfig c
			where a.visitorID = b.visitorID and
			  a.inmateid = c.inmateID and
			  a.facilityID = c.facilityID and  
			  c.facilityID = @facilityID and
			  a.Status = @status and  
			  a.apmdate > DATEADD(DAY, -1, getdate() ) and
			 (a.SendJMS =1 ) ;
	 end
END

