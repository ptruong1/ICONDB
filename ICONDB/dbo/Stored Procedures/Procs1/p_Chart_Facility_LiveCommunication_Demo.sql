CREATE PROCEDURE [dbo].[p_Chart_Facility_LiveCommunication_Demo]
@FacilityID  int


AS
SET NOCOUNT ON;

declare @SignalRTableName      varchar(50), @sql nvarchar(max),  @table varchar(30), @recCount int, @Test int 
--declare @active table(ACount int)
Begin
set @SignalRTableName = ''
		 begin
		 select @SignalRTableName=TableName from tblFacilityACP with(nolock) where  facilityID = @facilityID  ;
		 end

End

set @table = @SignalRTableName

set @table = REPLACE(@table, 'LiveCall', 'tblLive')
set @Sql = '(select @Test = Count(*) from [Leg_LiveCast].[dbo].' + @table + ' where facilityID = @facilityID and status = ''Active'') '

exec sp_executesql @sql, N'@Test int OUTPUT, @FacilityID int' ,@Test OUTPUT, @FacilityID

--select @Test as output
--set @RecCount = @@ROWCOUNT
--PRINT '@count = ' + CAST(@count AS VARCHAR(4))
--print @sql

Declare @LiveComm table([TotalPhones] int, [ActivePhones] int, [TotalVVSKiosks] int, [ActiveVVSKiosks] int, [TotalPhoneVisit] int, [ActivePhone] int);

Insert @LiveComm
select (select COUNT(PhoneID) from tblANIs with(nolock) where facilityID = @FacilityID and  ANINoStatus=1) ,
		(select @Test),
		(select COUNT(stationID) from tblVisitPhone where FacilityID =@FacilityID and (StationType=1 or StationType=2)  and [status]=1) ,
		( select COUNT(a.RoomID) from tblVisitOnline a join tblVisitLocation  b on (a.FacilityID = b.facilityID and a.locationID = b.LocationID)	    
			where a.FacilityID = @FacilityID  and status = 3 and ( a.ApmDate >= DATEADD(MINUTE,-a.LimitTime,DATEADD(HOUR, 0 ,GETDATE())) and a.ApmDate <  DATEADD(MINUTE,a.LimitTime,DATEADD(HOUR, 0 ,GETDATE())))),
			(select count(*) from tblVisitPhone with(nolock) where FacilityID= @FacilityID and (StationType=3)  and [status]=1) , (select count(*) from tblvisitphoneOnline with(nolock) where FacilityID =@FacilityID) ;


select ([TotalPhones]-[ActivePhones]) [Inactive Phones], [ActivePhones] as [Active Phones],([TotalVVSKiosks]- [ActiveVVSKiosks]) [Inactive VVS Kiosks] ,[ActiveVVSKiosks] as [Active VVS Kiosks],([TotalPhoneVisit] - [ActivePhone]) as [Inactive Phone Visit], [ActivePhone] as [Active Phone Visit]  from 	@LiveComm	;


