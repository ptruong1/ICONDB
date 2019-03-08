
CREATE PROCEDURE p_watchList_monitor 
@watchListID  int
AS

SET NOCOUNT ON
select (CASE tblLiveMonitor.Status When 'A' Then 'Listen'  When 'C' Then 'Listen' Else 'N/A' end ) as Listen,
	(CASE  tblLiveMonitor.Status When 'A' Then 'Stop'  Else 'N/A' end )  as Terminate,  (CASE tblLiveMonitor.Status When 'A' Then 'Add'  When 'C' Then 'Add' Else 'N/A' end ) as AddNote,  isnull(tblLiveMonitor.RecordID,0)  RecordID,
  	 isnull(CallingNo,'')  CallingNo , isnull (CalledNo,'') CalledNo ,isnull(   tblLiveMonitor.InmateID ,0)  InmateID ,  isnull(   tblLiveMonitor.PIN ,0)  PIN , isnull( (tblInmate.LastName + ', ' + tblInmate.firstName ),'N/A')  InmateName,  
	 isnull( (tblPhones.LastName + ', ' + tblPhones.firstName ),'N/A')  CalledName, ( CASE RelationshipID when 1 then 'Parents' when 2 then 'Sibling' when 3 then 'Friend' when 4 then 'Others'  else 'N/A' end)  as  RelationShip ,
	 Isnull(Convert(varchar(10), Cast(CallDate as smalldatetime), 101),'') as Calldate,  Isnull(( left(CallTime,2) +':'+ substring(CallTime,3,2)+':' + right( CallTime ,  2)) ,'') as Calltime,
	 Isnull(tblBillType.Descript , 'N/A') as Billedtype, Isnull(tblFacilityLocation.Descript,'N/A') as Location  , (CASE tblLiveMonitor.Status When 'A' Then 'N/A'  When 'C' Then 'Download' Else 'N/A' end ) as Download,
	 tblLiveMonitor.Status,dbo.fn_ConvertSecToMin( isnull(duration,0)) as Duration, isnull(  Channel,0)  Channel ,  isnull(HostName,'') HostName , isnull(FolderDate ,'') FolderDate , isnull (RecordFileName,'NA')  RecordFileName 
	From tblLiveMonitor  with(nolock) left outer join tblInmate with(nolock) on tblLiveMonitor.PIN = tblInmate.PIN 
	left outer join tblphones  with(nolock)  on tblLiveMonitor.CalledNo =tblphones.phoneNo
	left outer join tblBillType with(nolock) on tblLiveMonitor.billtype = tblBillType.BillType 
	left outer join tblFacilityLocation with(nolock) on tblLiveMonitor.LocationID =tblFacilityLocation.LocationID
	where	 tblLiveMonitor.watchListID = @watchListID
