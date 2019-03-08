CREATE PROCEDURE [dbo].[p_Chart_Agent_LiveCommunication4]
@AgentID  int,
@MasterUserGroupID int,
@UserGroupID int

AS
SET NOCOUNT ON;
declare @SignalRTableName      varchar(50), @sql nvarchar(max),  @table varchar(30), @recCount int, @Test int 

Declare @userFacility table (UserFacility int)
Insert @userFacility(UserFacility) 
select a.FacilityID from tblUserGroupFacility a, tblfacility b where a.agentID = b.agentID and a.FacilityID = b.FacilityID and  a.AgentID = @AgentID and a.UserGroupID = @UserGroupID and a.MasterUserGroupID = @MasterUserGroupID and b.status=1;

Declare @LiveComm table([TotalPhones] int, [ActivePhones] int, [TotalVVSKiosks] int, [ActiveVVSKiosks] int, [TotalPhoneVisit] int, [ActivePhone] int);

Insert @LiveComm
select (select COUNT(PhoneID) from tblANIs with(nolock) where facilityID in (select UserFacility from  @userFacility )) ,
	(select count(*) from [172.77.10.22\bigdaddyicon].[Leg_LiveCast].[dbo].tblOnlineAllACPs where facilityID in (select UserFacility from  @userFacility ) and Status = 'Active') ,
	(select COUNT(stationID) from tblVisitPhone where facilityID in (select UserFacility from  @userFacility) and (StationType=1 or StationType=2)) ,
	(select COUNT(a.RoomID) from tblVisitOnline a 
			where a.facilityId in  (select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1)  
			and  a.RecordOpt ='Y' and status <9  
			and	( a.ApmDate >= DATEADD(MINUTE,-a.LimitTime,DATEADD(HOUR, (select timezone from tblfacility where FacilityID = a.facilityID) ,GETDATE())) 
			and a.ApmDate <  DATEADD(MINUTE,a.LimitTime,DATEADD(HOUR, (select timezone from tblfacility where FacilityID = a.facilityID) ,GETDATE())) )) ,
	(select count(*) from tblVisitPhone with(nolock) where FacilityID in (select UserFacility from  @userFacility) and (StationType=3)  ) , 
	(select count(*) from tblvisitphoneOnline with(nolock) where FacilityID in (select UserFacility from  @userFacility))  ;

select ([TotalPhones]-[ActivePhones]) [Inactive Phones], [ActivePhones] as [Active Phones],([TotalVVSKiosks]- [ActiveVVSKiosks]) [Inactive VVS Kiosks] ,[ActiveVVSKiosks] as [Active VVS Kiosks],([TotalPhoneVisit] - [ActivePhone]) as [Inactive Visitation Phones], [ActivePhone] as [Active Visitation Phones]  from 	@LiveComm	;

