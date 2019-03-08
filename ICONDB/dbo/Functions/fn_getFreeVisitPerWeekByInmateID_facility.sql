

CREATE FUNCTION [dbo].[fn_getFreeVisitPerWeekByInmateID_facility] (@InmateId varchar(12), @scheduleDate datetime, @facilityID int, @visitType tinyint )
RETURNS int  AS  
BEGIN 
	Declare  @visit smallint ;

	select @visit=  COUNT(*) from tblVisitEnduserSchedule where FacilityID =@facilityID  and  DATEPART(wk,ApmDate) =DATEPART(wk,@scheduleDate) and InmateID =@InmateID and visitType =@visitType and  TotalCharge=0  and status in(1,2,3,5,8);
	
	return    @visit;
END



