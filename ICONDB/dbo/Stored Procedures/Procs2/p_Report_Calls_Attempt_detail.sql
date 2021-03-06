﻿



CREATE PROCEDURE [dbo].[p_Report_Calls_Attempt_detail]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime ,
@startRowIndex int,
 @maximumRows int,
@totalRecord	int  OUTPUT
 AS

DECLARE @first_id int, @startRow int
	
SET NOCOUNT ON

--SET @totalRecord =0


	create table  #tempCallAtempt  ([RecordID] [bigint] IDENTITY (1, 1) NOT NULL ,fromNo char(10), toNo varchar(18), ConnectDateTime datetime, BillType  varchar(25),  Reason varchar(30),  Duration varchar(10), CallRevenue  numeric(5,2))
	
	Insert   #tempCallAtempt  (fromNo , toNo , ConnectDateTime , BillType  ,  Reason , Duration,CallRevenue  )
	
		Select   fromNo , toNo,   RecordDate as  ConnectDateTime ,  tblBilltype.Descript  as  BillType , 'Completed' as  Reason,
			dbo.fn_ConvertSecToMin( duration) as Duration, CallRevenue  from tblcallsBilled with(nolock)  ,  tblBilltype with(nolock) ,tblANIs with(nolock)
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and  
			tblcallsBilled.Fromno = tblANIs.ANIno and
			--AgentID = @AgentID and
			RecordDate >= @fromDate  and 
			convert(varchar(10), RecordDate ,101) <= @toDate  and   duration >10 and  errorcode ='0' and
			 tblcallsBilled.FacilityID = @FacilityID  
			 UNION
			
	
		select  fromno,tono,RecordDate  as ConnectDateTime,  tblbilltype.Descript as Billtype  ,tblErrortype.Descript  as Reason,
		 	'00:01:00' as Duration, 0 
		 from tblcallsUnbilled   with(nolock) , tblErrortype  with(nolock), tblBilltype with(nolock)  ,tblANIs with(nolock) 
		where   tblcallsUnbilled.Billtype = tblBilltype.Billtype  and
			tblcallsUnBilled.FromNo = tblANIs.ANIno and
			 tblErrortype.errorType >0  and 
			 tblErrortype.errorType = tblcallsUnbilled.errorType  and 
			tblANIs.FacilityID	= @FacilityID and RecordDate >= @FromDate and  convert(varchar(10), RecordDate ,101)  <= @toDate
			--Order by  ConnectDateTime Desc  
			UNION

		 select  ANI as fromno, 'CTS'  as Tono ,      ReportTime   as ConnectDateTime   ,  'CTS'  as BillType ,    'Call To Staff'      as      Reason     ,
			  '00:01:00' as Duration, 0  as  CallRevenue  from tblincidentreport  with(nolock) where 	
			FacilityID	= @FacilityID and InputDate  >= @FromDate and  convert(varchar(10), InputDate  ,101)  <= @toDate
			Order by  ConnectDateTime Desc 

select @totalRecord = count(*) from   #tempCallAtempt  

SET NOCOUNT OFF

SET @startRowIndex = @startRowIndex + 1




SET ROWCOUNT @maximumRows

select  fromNo , toNo , ConnectDateTime , BillType  ,  Reason , Duration ,  CallRevenue  from  #tempCallAtempt   WHERE   RecordID >= @startRowIndex

set ROWCOUNT 0

drop table   #tempCallAtempt

