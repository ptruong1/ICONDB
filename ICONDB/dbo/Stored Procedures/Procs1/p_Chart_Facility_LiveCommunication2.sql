CREATE PROCEDURE [dbo].[p_Chart_Facility_LiveCommunication2]
@FacilityID  int 

AS
SET NOCOUNT ON;


Declare @LiveComm table([TotalPhones] int, [ActivePhones] int, [TotalVVSKiosks] int, [ActiveVVSKiosks] int, [TotalPhoneVisit] int, [ActivePhone] int);

Insert @LiveComm
select (select COUNT(PhoneID) from tblANIs with(nolock) where facilityID = @FacilityID and  ANINoStatus=1) ,
		(select COUNT(*) from [172.77.10.22\bigdaddyicon].[Leg_LiveCast].[dbo].[tblLivePhoneCalls_Test] where facilityID = @facilityID and status = 'Active'),
		(select COUNT(stationID) from tblVisitPhone where FacilityID =@FacilityID and (StationType=1 or StationType=2)  and [status]=1) ,
		( select COUNT(a.RoomID) from tblVisitOnline a join tblVisitLocation  b on (a.FacilityID = b.facilityID and a.locationID = b.LocationID)	    
			where a.FacilityID = @FacilityID  and status = 3 and ( a.ApmDate >= DATEADD(MINUTE,-a.LimitTime,DATEADD(HOUR, 0 ,GETDATE())) and a.ApmDate <  DATEADD(MINUTE,a.LimitTime,DATEADD(HOUR, 0 ,GETDATE())))),
			(select count(*) from tblVisitPhone with(nolock) where FacilityID= @FacilityID and (StationType=3)  and [status]=1) , (select count(*) from tblvisitphoneOnline with(nolock) where FacilityID =@FacilityID) ;


select ([TotalPhones]-[ActivePhones]) [Inactive Phones], [ActivePhones] as [Active Phones],([TotalVVSKiosks]- [ActiveVVSKiosks]) [Inactive VVS Kiosks] ,[ActiveVVSKiosks] as [Active VVS Kiosks],([TotalPhoneVisit] - [ActivePhone]) as [Inactive Phone Visit], [ActivePhone] as [Active Phone Visit]  from 	@LiveComm	;

