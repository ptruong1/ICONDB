


CREATE PROCEDURE [dbo].[p_Report_Unbilled_calls_by_RejectType]
@FacilityID	int,
@FromDate	smalldatetime,
@toDate	smalldatetime,
@errorCode	 int  --- get from table tblErrorType  by Drop down list

 AS
If (@errorCode >0)
	select   tblErrortype.Descript as Reason ,convert(varchar(10), RecordDate ,101) as Calldate , Count(RecordDate)  as Calls
	 from tblcallsUnbilled with(nolock) , tblErrortype  with(nolock)
		  where  
			 tblErrortype.errorType = tblcallsUnbilled.errorType   
			 and (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
			 and tblErrortype.errorType = @errorCode	
			 and facilityID = @facilityID  
			Group by  tblErrortype.Descript ,convert(varchar(10), RecordDate ,101)

Else
	select   tblErrortype.Descript as Reason ,convert(varchar(10), RecordDate ,101) as Calldate  , Count(RecordDate)  as Calls 
	 from tblcallsUnbilled with(nolock) , tblErrortype  with(nolock)
		  where  tblErrortype.errorType = tblcallsUnbilled.errorType and
			  tblErrortype.errorType > 0 and
			 (RecordDate between @fromDate and dateadd(d,1,@todate) )
			 and facilityID = @facilityID  
			Group by  tblErrortype.Descript ,convert(varchar(10), RecordDate ,101)
