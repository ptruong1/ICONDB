CREATE PROCEDURE [dbo].[p_Chart_Agent_LiveCommunication]
@AgentID  int


AS
SET NOCOUNT ON;
Declare @LiveComm table([TotalPhones] int, [ActivePhones] int, [TotalVVSKiosks] int, [ActiveVVSKiosks] int, [TotalPhoneVisit] int, [ActivePhone] int);

Insert @LiveComm
select (select COUNT(PhoneID) from tblANIs with(nolock) where facilityID in (select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1)) ,

--(Select COUNT(RecordID) from tblOnCalls where facilityID in
--		(select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1) and duration is null and Errorcode ='0' and datediff(hh,recorddate,getdate()) <2 ) ,
(select COUNT(RecordID) from [172.77.10.22\BigdaddyICON].[Leg_LiveCast].[dbo].tblLivePhoneCalls  with(nolock) 
		where status='active' and  facilityID in (select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID )),

(select COUNT(stationID) from tblVisitPhone where facilityID in
		(select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1)
		and (StationType=1 or StationType=2)) ,

(select COUNT(a.RoomID) from tblVisitOnline a 
			where a.facilityId in  (select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1)  
			and  a.RecordOpt ='Y' and status <9  
			--and ( a.ApmDate >= DATEADD(MINUTE,-a.LimitTime,DATEADD(HOUR, 0 ,GETDATE())) and a.ApmDate <  DATEADD(MINUTE,a.LimitTime,DATEADD(HOUR, 0 ,GETDATE())))),

		and	( a.ApmDate >= DATEADD(MINUTE,-a.LimitTime,DATEADD(HOUR, (select timezone from tblfacility where FacilityID = a.facilityID) ,GETDATE())) and 
	   a.ApmDate <  DATEADD(MINUTE,a.LimitTime,DATEADD(HOUR, (select timezone from tblfacility where FacilityID = a.facilityID) ,GETDATE())) )) ,

(select count(*) from tblVisitPhone with(nolock) where FacilityID in
			(select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1) 
			and (StationType=3)  ) , 
(select count(*) from tblvisitphoneOnline with(nolock) where FacilityID in
			(select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1) ) ;


select ([TotalPhones]-[ActivePhones]) [Inactive Phones], [ActivePhones] as [Active Phones],([TotalVVSKiosks]- [ActiveVVSKiosks]) [Inactive VVS Kiosks] ,[ActiveVVSKiosks] as [Active VVS Kiosks],([TotalPhoneVisit] - [ActivePhone]) as [Inactive Phone Visit], [ActivePhone] as [Active Phone Visit]  from 	@LiveComm	;

