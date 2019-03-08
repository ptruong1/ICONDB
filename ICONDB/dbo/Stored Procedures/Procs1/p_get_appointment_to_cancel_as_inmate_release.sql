-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_appointment_to_cancel_as_inmate_release]

AS
BEGIN

    Declare  @CancelApm table(FacilityID int, ConfirmNo varchar(12), ApmDate date, apmTime time(0), VisitType tinyint, InmateName varchar(50), 	VisitorName varchar(50), VisitorEmail varchar(70), VisitorText varchar(70), VisitorNamePhone varchar(12),ReasonOfCancel varchar(20)) ;
	Declare @CurrentDate datetime;
	SET @CurrentDate = getdate();
	Insert @CancelApm (facilityID,ConfirmNo , ApmDate , apmTime , VisitType ,InmateName, VisitorName, VisitorEmail, VisitorText , VisitorNamePhone,ReasonOfCancel )
	select a.FacilityID,  a.ApmNo, a.ApmDate,a.ApmTime, a.VisitType, a.InmateName, b.VlastName +', '+ b.VfirstName , b.Email,(a.AlertCellPhone + a.AlertCellCarrier ), a.EndUserID, 
	 'Released' as ReasonOfCancel 
	from tblVisitEnduserSchedule a  with(nolock), tblvisitors b  with(nolock), tblinmate c  with(nolock), tblVisitInmateConfig d with(nolock)  where 
	a.FacilityID = b.FacilityID and
	a.FacilityID =c.FacilityId and
	a.FacilityID = d.FacilityID and
	a.VisitorID = b.VisitorID and 
	a.InmateID = c.inmateID and
	a.InmateID = d.InmateID and
	(a.status = 2 or a.status = 1) and 
	c.Status >1 and
	a.ApmDate > @CurrentDate
	order by ApmNo;
  

	Insert @CancelApm (facilityID,ConfirmNo , ApmDate , apmTime , VisitType ,InmateName, VisitorName, VisitorEmail, VisitorText , VisitorNamePhone,ReasonOfCancel )
	select a.FacilityID,  a.ApmNo, a.ApmDate,a.ApmTime,a.VisitType, a.InmateName, b.VlastName +', '+ b.VfirstName , b.Email,(a.AlertCellPhone + a.AlertCellCarrier ), a.EndUserID, 
	 'Suspended' as ReasonOfCancel 
		from tblVisitEnduserSchedule a  with(nolock), tblvisitors b  with(nolock), tblinmate c  with(nolock), tblVisitInmateConfig d with(nolock) where 
		a.FacilityID = b.FacilityID and
		a.FacilityID =c.FacilityId and
		a.FacilityID = d.FacilityID and
		a.VisitorID = b.VisitorID and 
		a.InmateID = c.inmateID and
		a.InmateID = d.InmateID and
		(a.ApmDate between d.SusStartDate and d.SusEndDate) and
		(a.status = 2 or a.status = 1)  and 
		c.Status =1 and
		a.ApmDate > @CurrentDate
		order by ApmNo;


	Insert @CancelApm (facilityID,ConfirmNo , ApmDate , apmTime , VisitType ,InmateName, VisitorName, VisitorEmail, VisitorText , VisitorNamePhone,ReasonOfCancel )
	select a.FacilityID,  a.ApmNo, a.ApmDate,a.ApmTime,a.VisitType, a.InmateName, b.VlastName +', '+ b.VfirstName , b.Email,(a.AlertCellPhone + a.AlertCellCarrier ), a.EndUserID, 
	   'Relocated' as ReasonOfCancel 
			from tblVisitEnduserSchedule a  with(nolock), tblvisitors b  with(nolock), tblinmate c  with(nolock), tblVisitInmateConfig d with(nolock) where 
			a.FacilityID = b.FacilityID and
			a.FacilityID =c.FacilityId and
			a.FacilityID = d.FacilityID and
			a.VisitorID = b.VisitorID and 
			a.InmateID = c.inmateID and
			a.InmateID = d.InmateID and
			a.locationID <> d.LocationID and
			(a.status = 2 or a.status = 1)  and 
			c.Status =1 and
			a.ApmDate > @CurrentDate
			order by ApmNo;
	

select a.facilityID,b.Location, a.ConfirmNo , a.ApmDate , a.apmTime ,c.Descript, a.InmateName, a.VisitorName,isnull( a.VisitorEmail,'') VisitorEmail ,isnull( a.VisitorText,'') VisitorText , a.VisitorNamePhone,a.ReasonOfCancel
	 from @CancelApm a , tblFacility b with(nolock) , tblVisitType c with(nolock) 
	 where a.FacilityID = b.FacilityID and
		   a.VisitType = c.VisitTypeID ;


  -- Update Apm to cancel, will uncomment when run live
 
 -- Update tblVisitEnduserSchedule set [status]= 4, CancelBy = 'System', CancelDate = @CurrentDate,note = a.ReasonOfCancel
	--	from @CancelApm a , tblVisitEnduserSchedule b with(nolock) where a.ConfirmNo = b.ApmNo
  
	 
END

