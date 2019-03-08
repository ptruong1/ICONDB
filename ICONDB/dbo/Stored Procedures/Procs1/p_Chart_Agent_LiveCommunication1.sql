CREATE PROCEDURE [dbo].[p_Chart_Agent_LiveCommunication1]
@AgentID  int


AS
SET NOCOUNT ON;

declare @SignalRTableName      varchar(50), @sql nvarchar(max),  @table varchar(30), @recCount int, @Test int 
--declare @active table(ACount int)
Begin
set @SignalRTableName = ''
	
		 Begin
		 select @SignalRTableName=TableName from tblFacilityACP with(nolock) where  AgentID = @AgentID  ;
		 End
End

set @table = @SignalRTableName

set @table = REPLACE(@table, 'LiveCall', 'tblLive')
set @Sql = '(select @Test = Count(*) from [172.77.10.22\bigdaddyicon].[Leg_LiveCast].[dbo].' + @table + ' where AgentID = @AgentID and status = ''Active'') '

exec sp_executesql @sql, N'@Test int OUTPUT, @AgentID int' ,@Test OUTPUT, @AgentID

--select @Test as output
--set @RecCount = @@ROWCOUNT
--PRINT '@count = ' + CAST(@count AS VARCHAR(4))
--print @sql

Declare @LiveComm table([TotalPhones] int, [ActivePhones] int, [TotalVVSKiosks] int, [ActiveVVSKiosks] int, [TotalPhoneVisit] int, [ActivePhone] int);

Insert @LiveComm
select (select COUNT(PhoneID) from tblANIs with(nolock) where facilityID in (select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1)) ,
(case when @AgentId > 1 then @Test 
else

  (select count(*) from [172.77.10.22\bigdaddyicon].[Leg_LiveCast].[dbo].tblLiveACP11 where AgentID = @AgentID and Status = 'Active') +
  (select count(*) from [172.77.10.22\bigdaddyicon].[Leg_LiveCast].[dbo].tblLiveACP12 where AgentID = @AgentID and Status = 'Active') +
  (select count(*) from [172.77.10.22\bigdaddyicon].[Leg_LiveCast].[dbo].tblLiveACP13 where AgentID = @AgentID and Status = 'Active') +
  (select count(*) from [172.77.10.22\bigdaddyicon].[Leg_LiveCast].[dbo].tblLiveACP14 where AgentID = @AgentID and Status = 'Active') +
  (select count(*) from [172.77.10.22\bigdaddyicon].[Leg_LiveCast].[dbo].tblLiveACP15 where AgentID = @AgentID and Status = 'Active') +
  (select count(*) from [172.77.10.22\bigdaddyicon].[Leg_LiveCast].[dbo].tblLiveACP16 where AgentID = @AgentID and Status = 'Active') +
  (select count(*) from [172.77.10.22\bigdaddyicon].[Leg_LiveCast].[dbo].tblLiveACP21 where AgentID = @AgentID and Status = 'Active') +
  (select count(*) from [172.77.10.22\bigdaddyicon].[Leg_LiveCast].[dbo].tblLiveACP22 where AgentID = @AgentID and Status = 'Active') +
  (select count(*) from [172.77.10.22\bigdaddyicon].[Leg_LiveCast].[dbo].tblLiveACP23 where AgentID = @AgentID and Status = 'Active') +
  (select count(*) from [172.77.10.22\bigdaddyicon].[Leg_LiveCast].[dbo].tblLiveACP33 where AgentID = @AgentID and Status = 'Active') +
  (select count(*) from [172.77.10.22\bigdaddyicon].[Leg_LiveCast].[dbo].tblLiveACP113 where AgentID = @AgentID and Status = 'Active') +
  (select count(*) from [172.77.10.22\bigdaddyicon].[Leg_LiveCast].[dbo].tblLiveACP114 where AgentID = @AgentID and Status = 'Active') 

   end),

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

