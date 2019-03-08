

CREATE PROCEDURE [dbo].[p_get_billed_calls_by_watchlist]
@watchlistID	int,
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 
 AS
SET NOCount ON
create table #temp_Bill(RecordID int,  FromNo char(10), toNo char(10),  RecordDate Datetime,  Calltype char(2), Billtype varchar(25), Duration  varchar(10),  HostName varchar(10),  channel int,  FolderDate varchar(10), RecordFile varchar(20))
Insert  #temp_Bill
	Select  RecordId,  fromNo , toNo,   RecordDate as  ConnectDateTime  ,  Calltype,  tblBilltype.Descript  as  BillType  
		,dbo.fn_ConvertSecToMin( duration) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock)
	  where   tblcallsBilled.Billtype = tblBilltype.billtype and  
		 tblcallsBilled.FacilityID = @FacilityID  and 
		tblcallsBilled.UserName = tblACPs.IPAddress  And 
		RecordDate >= @fromDate  and   convert(varchar(10), RecordDate ,101) <= @toDate  and
		fromno in (select ANI from tblWatchList with(nolock) where watchListID = @watchlistID and  WatchByID =1)
Insert  #temp_Bill
	
	Select  RecordId,  fromNo , toNo,   RecordDate as  ConnectDateTime  ,  Calltype,  tblBilltype.Descript  as  BillType  
		,dbo.fn_ConvertSecToMin( duration) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock)
	  where   tblcallsBilled.Billtype = tblBilltype.billtype and  
		 tblcallsBilled.FacilityID = @FacilityID  and 
		tblcallsBilled.UserName = tblACPs.IPAddress  And 
		RecordDate >= @fromDate  and   convert(varchar(10), RecordDate ,101) <= @toDate  and
		tono in (select DNI from tblWatchList with(nolock) where watchListID = @watchlistID and  WatchByID =2) and   RecordId not in (select recordID from #temp_Bill with(nolock))
Insert  #temp_Bill
		
	Select  RecordId,  fromNo , toNo,   RecordDate as  ConnectDateTime  ,  Calltype,  tblBilltype.Descript  as  BillType  
		,dbo.fn_ConvertSecToMin( duration) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock)
	  where   tblcallsBilled.Billtype = tblBilltype.billtype and  
		 tblcallsBilled.FacilityID = @FacilityID  and 
		tblcallsBilled.UserName = tblACPs.IPAddress  And 
		RecordDate >= @fromDate  and   convert(varchar(10), RecordDate ,101) <= @toDate  and
		fromno in (select CallingNo  from  tblLivemonitor  with(nolock) where watchListID = @watchlistID and  WatchBy =3) and   RecordId not in (select recordID from #temp_Bill with(nolock))

Select * from   #temp_Bill  Order by RecordID

Drop table   #temp_Bill

