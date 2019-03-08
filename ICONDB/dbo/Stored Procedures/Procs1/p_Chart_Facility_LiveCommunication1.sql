CREATE PROCEDURE [dbo].[p_Chart_Facility_LiveCommunication1]
@FacilityID  int 

AS
--If there is no video visit
--IF ((select COUNT(ApmNo) from tblVisitEnduserSchedule where FacilityID = @FacilityID and status =3) =0)and ((select COUNT(RecordID) from tblOnCalls where FacilityID = @FacilityID and duration is null) <>0)
--select ((select COUNT(PhoneID) from tblANIs where facilityID = @FacilityID) - (select COUNT(RecordID) from tblOnCalls where FacilityID = @FacilityID and duration is null)) as 'Inactive Phones',
--		(select COUNT(RecordID) from tblOnCalls where FacilityID = @FacilityID and duration is null and Errorcode ='0' and datediff(hh,recorddate,getdate()) <2 ) as  'Active Phones',
--		((select COUNT(stationID) from tblVisitPhone where FacilityID =@FacilityID) - (select COUNT(ApmNo) from tblVisitEnduserSchedule where FacilityID = @FacilityID and status =3)) as 'Inactive VVS Kiosks'
		
----If there is no call		
--Else If ((select COUNT(ApmNo) from tblVisitEnduserSchedule where FacilityID = @FacilityID and status =3) <> 0) and ((select COUNT(RecordID) from tblOnCalls where FacilityID = @FacilityID and duration is null) =0)
--select ((select COUNT(PhoneID) from tblANIs where facilityID = @FacilityID) - (select COUNT(RecordID) from tblOnCalls where FacilityID = @FacilityID and duration is null)) as 'Inactive Phones',
--		((select COUNT(stationID) from tblVisitPhone where FacilityID =@FacilityID) - (select COUNT(ApmNo) from tblVisitEnduserSchedule where FacilityID = @FacilityID and status =3)) as 'Inactive VVS Kiosks',
--		(select COUNT(ApmNo) from tblVisitEnduserSchedule where FacilityID = @FacilityID and status =3) as 'Active VVS Kiosks'

----If there is no video		
--Else IF (((select COUNT(ApmNo) from tblVisitEnduserSchedule where FacilityID = @FacilityID and status =3) =0) and ((select COUNT(RecordID) from tblOnCalls where FacilityID = @FacilityID and duration is null) =0))
--			select ((select COUNT(PhoneID) from tblANIs where facilityID = @FacilityID) - (select COUNT(RecordID) from tblOnCalls where FacilityID = @FacilityID and duration is null)) as 'Inactive Phones',
--			((select COUNT(stationID) from tblVisitPhone where FacilityID =@FacilityID) - (select COUNT(ApmNo) from tblVisitEnduserSchedule where FacilityID = @FacilityID and status =3)) as 'Inactive VVS Kiosks'
--Else 

select ((select COUNT(PhoneID) from tblANIs with(nolock) where facilityID = @FacilityID and  ANINoStatus=1) - (select COUNT(RecordID) from tblOnCalls where FacilityID = @FacilityID and duration is null)) as 'Inactive Phones',
		(select COUNT(RecordID) from tblOnCalls where FacilityID = @FacilityID and duration is null and Errorcode ='0' and datediff(hh,recorddate,getdate()) <2 ) as 'Active Phones',
		((select COUNT(stationID) from tblVisitPhone where FacilityID =@FacilityID and (StationType=1 or StationType=2)  and [status]=1) - (select COUNT(ApmNo) from tblVisitEnduserSchedule where FacilityID = @FacilityID and status =3))as 'Inactive VVS Kiosks',	
		( select COUNT(a.RoomID) from tblVisitOnline a join tblVisitLocation  b on (a.FacilityID = b.facilityID and a.locationID = b.LocationID)	    
			where a.FacilityID = @FacilityID and  status = 3 and 
			( a.ApmDate >= DATEADD(MINUTE,-a.LimitTime,DATEADD(HOUR, 0 ,GETDATE())) and a.ApmDate <  DATEADD(MINUTE,a.LimitTime,DATEADD(HOUR, 0 ,GETDATE())) )) as 'Active VVS Kiosks'
		


