
CREATE PROCEDURE p_watchList_live_monitor
@watchListID  int
AS
If (Select count(*)   From tblLiveMonitor  with(nolock)  where  watchListID = @watchListID  and datediff(ss,LastUpdate,getdate()) <25 ) > 0
	select (CASE tblLiveMonitor.Status When 'A' Then 'Listen'  When 'C' Then 'Listen' Else 'N/A' end ) as Listen, 
	(CASE  tblLiveMonitor.Status When 'A' Then 'Stop'  Else 'N/A' end )  as Terminate, (CASE tblLiveMonitor.Status When 'A' Then 'Add'  When 'C' Then 'Add' Else 'N/A' end ) as AddNote, Isnull( tblLiveMonitor.RecordID,0) RecordID ,
  	 isnull(CallingNo,'')  CallingNo , isnull (CalledNo,'') CalledNo  ,isnull(   tblLiveMonitor.InmateID ,0)  InmateID  , isnull(   tblLiveMonitor.PIN ,0)  PIN , isnull( (tblInmate.LastName + ', ' + tblInmate.firstName ),'N/A')  InmateName,  
	 ( CASE RelationshipID when 1 then 'Parents' when 2 then 'Sibling' when 3 then 'Friend' when 4 then 'Others'  else 'N/A' end)  as  RelationShip ,
	 isnull( (tblPhones.LastName + ', ' + tblPhones.firstName ),'N/A')  CalledName, Isnull(Convert(varchar(10), Cast(CallDate as smalldatetime), 101),'') as Calldate, 
	 Isnull(( left(CallTime,2) +':'+ substring(CallTime,3,2)+':' + right( CallTime ,  2)) ,'') as Calltime, 
	isnull(tblBillType.Descript,'') as  BilledType, Isnull(tblFacilityLocation.Descript,'N/A') as Location , (CASE tblLiveMonitor.Status When 'A' Then 'N/A'  When 'C' Then 'Download' Else 'N/A' end ) as Download,
	 tblLiveMonitor.Status,dbo.fn_ConvertSecToMin( isnull(duration,0)) as Duration, isnull(  Channel,0)  Channel ,  isnull(HostName,'') HostName , isnull(FolderDate ,'') FolderDate , isnull (RecordFileName,'NA')  RecordFileName 
	From tblLiveMonitor  left outer join tblInmate with(nolock) on tblLiveMonitor.PIN = tblInmate.PIN  
	Left outer join tblphones  with(nolock) on tblLiveMonitor.CalledNo =tblphones.phoneNo 
	left outer join tblBillType with(nolock) on tblLiveMonitor.billtype = tblBillType.BillType 
	Left outer join tblFacilityLocation with(nolock)  on tblLiveMonitor.LocationID  = tblFacilityLocation.LocationID
	where 	  tblLiveMonitor.watchListID = @watchListID
else
	return  -1
