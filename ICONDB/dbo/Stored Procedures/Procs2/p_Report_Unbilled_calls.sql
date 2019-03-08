﻿

CREATE PROCEDURE [dbo].[p_Report_Unbilled_calls]
@FacilityID	int,
@FromDate	smalldatetime,
@toDate	smalldatetime

 AS

select  fromno,tono,RecordDate  as Calldate, tblbilltype.Descript as Billtype  ,tblErrortype.Descript  as Reason, PIN 
 from tblcallsUnbilled   with(nolock) , tblErrortype  with(nolock), tblBilltype with(nolock) 
where  tblBilltype.Billtype =  tblcallsUnbilled.Billtype and
	 tblErrortype.errorType >0  and tblErrortype.errorType = tblcallsUnbilled.errorType  and FacilityID	= @FacilityID and  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
	Order by  fromno, RecordDate
