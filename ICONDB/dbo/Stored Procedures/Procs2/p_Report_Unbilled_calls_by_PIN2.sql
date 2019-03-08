CREATE PROCEDURE [dbo].[p_Report_Unbilled_calls_by_PIN2]
@FacilityID	int,
@FromDate	smalldatetime,
@toDate	smalldatetime,
@PIN	varchar(12)

 AS
 declare @InmateID varchar(12) = '0'
 IF  @PIN	> 0
	select @InmateID = (InmateID) from tblInmate where FacilityId = @FacilityID and PIN = @PIN
If( @InmateID >0)
	select  InmateID, PIN,fromno,tono,RecordDate as CallDate, tblbilltype.Descript as Billtype ,tblErrortype.Descript as Reason, Count(RecordDate)  as Calls
		 from tblcallsUnbilled   with(nolock) , tblErrortype  with(nolock), tblBilltype with(nolock) ,tblANIs with(nolock)
		where tblErrortype.errorType >0  and tblBilltype.billtype = tblcallsUnbilled.billtype and
			tblANIs.ANIno = 	tblcallsUnbilled.FromNo and
			tblANIs.facilityid = tblcallsUnbilled.facilityId and
			tblErrortype.errorType = tblcallsUnbilled.errorType  and 
			tblcallsunbilled.FacilityID	= @FacilityID and (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			InmateID = @InmateID
		Group by InmateID,PIN,fromno,tono,RecordDate, tblbilltype.Descript ,tblErrortype.Descript
Else
	select  InmateID, PIN,fromno,tono,RecordDate  as CallDate, tblbilltype.Descript as Billtype ,tblErrortype.Descript as Reason, Count(RecordDate)  as Calls
		 from tblcallsUnbilled   with(nolock) , tblErrortype  with(nolock), tblBilltype with(nolock) ,tblANIs with(nolock)
		where tblErrortype.errorType >0  and tblBilltype.billtype = tblcallsUnbilled.billtype and
			tblANIs.ANIno = 	tblcallsUnbilled.FromNo and
			tblANIs.facilityid = tblcallsUnbilled.facilityId and
			tblErrortype.errorType = tblcallsUnbilled.errorType  and 
			tblcallsunbilled.FacilityID	= @FacilityID and (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		
		Group by InmateID,PIN,fromno,tono,RecordDate, tblbilltype.Descript ,tblErrortype.Descript
