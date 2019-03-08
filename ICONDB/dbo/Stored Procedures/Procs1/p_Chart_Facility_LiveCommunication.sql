CREATE PROCEDURE [dbo].[p_Chart_Facility_LiveCommunication]
@FacilityID  int 

AS

select (select COUNT(RecordID) from tblOnCalls where FacilityID = @FacilityID and duration is null) as CallMonitor,
			(select COUNT(ApmNo) from tblVisitEnduserSchedule where FacilityID = @FacilityID and status =3) as VideoMonitor,
	        ((select COUNT(RecordID) from tblOnCalls where FacilityID = @FacilityID and duration is null) +
			    (select COUNT(ApmNo) from tblVisitEnduserSchedule where FacilityID =352and status =3)) as TotalMonitor,
		
		  ((select COUNT(PhoneID) from tblANIs where facilityID = @FacilityID) +  (select COUNT(stationID) from tblVisitPhone where FacilityID =@FacilityID) - 
		      (select COUNT(RecordID) from tblOnCalls where FacilityID = @FacilityID and duration is null) +
			    (select COUNT(ApmNo) from tblVisitEnduserSchedule where FacilityID =@FacilityID and status =3)) as Available
