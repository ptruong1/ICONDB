CREATE PROCEDURE [dbo].[p_Report_billed_calls1]
@FromNo	varchar(10),
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 
 AS


If( @AgentID >1  and @facilityID =0 ) 

Begin
	If ( rtrim(@FromNo)	<> ''  and @FromNo is not null )
	
		Select   fromNo , toNo,   RecordDate as  ConnectDateTime  ,  Calltype,  tblBilltype.Descript  as  BillType, callRevenue  
			,CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2))  as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock)
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and  
			 tblcallsBilled.AgentID =@AgentID  and 
			 tblcallsBilled.errorcode = '0' and 
			fromNo = @fromNo and 
			tblcallsBilled.UserName = tblACPs.IPAddress  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) )  and  AgentID = @AgentID  and convert (int,duration ) >5  AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
			Order by fromNo, RecordDate
	
	
	Else
		Select   fromNo , toNo,  RecordDate as  ConnectDateTime  ,  Calltype,  tblBilltype.Descript  as  BillType, callRevenue
			,CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2))  as Duration, tblACPs.ComputerName as HostName   , Channel, FolderDate , RecordFile  from tblcallsBilled with(nolock), tblACPs with(nolock) , tblBilltype with(nolock)
			  where   tblcallsBilled.Billtype = tblBilltype.billtype and  
				 tblcallsBilled.errorcode = '0' and 
				 tblcallsBilled.AgentID =@AgentID  and 
				tblcallsBilled.UserName = tblACPs.IPAddress  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5  AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
			Order by fromNo, RecordDate


End 


else
Begin
	If ( rtrim(@FromNo)	<> ''  and @FromNo is not null )
	
		Select   fromNo , toNo,   RecordDate as  ConnectDateTime  ,  Calltype,  tblBilltype.Descript  as  BillType , callRevenue  
			,CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2))  as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock)
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and  
			 tblcallsBilled.FacilityID = @FacilityID  and 
			 tblcallsBilled.errorcode = '0' and 
			fromNo = @fromNo and 
			tblcallsBilled.UserName = tblACPs.IPAddress  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) )  and  AgentID = @AgentID  and convert (int,duration ) >5  AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
			Order by fromNo, RecordDate
	
	
	Else
		Select   fromNo , toNo,  RecordDate as  ConnectDateTime  ,  Calltype,  tblBilltype.Descript  as  BillType, callRevenue  
			,CAST( CAST(duration as numeric(7,2))/60 as Numeric(9,2)) as Duration, tblACPs.ComputerName as HostName   , Channel, FolderDate , RecordFile  from tblcallsBilled with(nolock), tblACPs with(nolock) , tblBilltype with(nolock)
			  where   tblcallsBilled.Billtype = tblBilltype.billtype and  
				 tblcallsBilled.errorcode = '0' and 
				tblcallsBilled.FacilityID = @FacilityID AND
				tblcallsBilled.UserName = tblACPs.IPAddress  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5  AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
			Order by fromNo, RecordDate


End
