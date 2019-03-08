CREATE PROCEDURE [dbo].[p_Report_Houston_Detail_N] 
(
	@facilityID	int,
	@fromDate	smalldatetime,
	@todate	smalldatetime
)
AS
	SET NOCOUNT ON;
	
	select 
T.FacilityID,
T.Location, 
T.Address,
T.Zipcode,
T.State,
T.FromNo,
T.StationID,
T.Descript,
T.RecordDate,
T.[ToNo], 
T.CallType,
T.CallCount as Counts,
T.CallDuration,
T.CallRevenue, 
Cast(cast(T.commrate as float) as Numeric(12,2)) as commrate,
T.CommPaid

From
((select tblfacility.facilityID, tblfacility.Location, tblfacility.Address,tblfacility.Zipcode,tblfacility.State, 
1 as CallCount, fromno, tblANIs.StationID, tblFacilityLocation.Descript, RecordDate, tono, tblCallType.Descript as Calltype ,  
		dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue,  
		Cast(tblCommrate.CommRate * 100 as Numeric(6,2)) as CommRate, 
		(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,2) ) 
		 Else CAST((( CallRevenue - (CallRevenue * isnull(BadDebtRate,0) ) -isnull(Pif,0) )  *tblCommrate.CommRate)  as Numeric(12,2) ) + isnull( PIf,0)     End)  as CommPaid,
		 '1' as recordCode
		from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , 
		tblCommrate with(nolock), tblfacility with(nolock),
		tblANIs with(nolock), tblFacilityLocation with(nolock) 
		
		 WHERE
						tblcallsbilled.Billtype = tblBilltype.Billtype and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.Calltype = tblCalltype.Abrev and
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						 tblcallsbilled.fromNo = tblANIs.ANINo and
						 tblANIs.LocationID = tblFacilityLocation.LocationID and
					 	tblcallsbilled.facilityID	= @facilityID  And
						tblfacility.facilityID = @facilityID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	
	Union 
	
	select t1.FacilityID,
t9.Location, 
t9.Address,
t9.Zipcode,
t9.State,
1 as CallCount,
(t7.LastName + ', ' + t7.FirstName) as [FromNo],
'' as StationID,
'' as Descript,
t2.MessageDate as RecordDate,
(t3.LastName + ', ' + t3.FirstName) as [ToNo], 
t5.Descript as CallType,
1 as CallDuration,
Cast(cast(t2.Charge as float) as Numeric(12,2)) as CallRevenue, 
(t10.Comm * 100) as commrate, 
cast(Cast((t2.Charge * t10.Comm) as float) as Numeric(12,2)) as Commpaid, 
'2' as recordCode

from tblMailboxDetail t2  with(nolock) 	
left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 	
left join tblInmate  t3  with(nolock) on t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID 	
left join tblMessageRate t4  with(nolock) on t2.MessageTypeID = t4.MessageTypeID and t1.FacilityID = t4.FacilityID 	
left join tblMessageType t5  with(nolock) on t2.MessageTypeID = t5.MessageTypeID 	
left join tblPrepaid t7 with(nolock) on t2.MessengerNo = t7.PhoneNo 	
left join tblMessageStatus t8 with(nolock) on isnull(t2.MessageStatus,1) = t8.MessStatus  
left join tblfacility t9 with(nolock) on (t1.facilityID) = t9.facilityID
left join tblMessageRate t10 with(nolock) on (t1.facilityID) = t10.facilityID and t2.MessageTypeID = t10.MessageTypeID

Where   
(t2.MessageDate between @fromDate and dateadd(d,1,@todate)) and 
t1.FacilityID = @facilityID 	

Union 

select t1.FacilityID,
t9.Location, 
t9.Address,
t9.Zipcode,
t9.State,
1 as CallCount,
(t7.LastName + ', ' + t7.FirstName) as [FromNo],
'' as StationID,
'' as Descript,
t2.MessageDate as RecordDate,
(t3.LastName + ', ' + t3.FirstName) as [ToNo], 
t5.Descript as CallType,
1 as CallDuration,
Cast(cast(t2.Charge as float) as Numeric(12,2)) as CallRevenue, 
(t10.Comm * 100) as commrate, 
cast(Cast((t2.Charge * t10.Comm) as float) as Numeric(12,2)) as Commpaid, 
'2' as recordCode  

from tblMailboxDetailF t2  with(nolock) 	
left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.SenderMailBoxID 	
left join tblInmate  t3  with(nolock) on t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID 	
left join tblMessageRate t4  with(nolock) on t2.MessageTypeID = t4.MessageTypeID and t1.FacilityID = t4.FacilityID 	
left join tblMessageType t5  with(nolock) on t2.MessageTypeID = t5.MessageTypeID 	
left join tblMailboxF t6 with(nolock) on t2.MailBoxID = t6.MailBoxID 	
left join tblPrepaid t7 with(nolock) on t6.AccountNo = t7.PhoneNo 	
left join tblMessageStatus t8 with(nolock) on isnull(t2.MessageStatus,1) = t8.MessStatus
left join tblfacility t9 with(nolock) on (t1.facilityID) = t9.facilityID 
left join tblMessageRate t10 with(nolock) on (t1.facilityID) = t10.facilityID and t2.MessageTypeID = t10.MessageTypeID 

Where  
(t2.MessageDate between @fromDate and dateadd(d,1,@todate)) and 
t1.FacilityID = @facilityID   	) 

Union All

select X.FacilityID,
X.Location, 
X.Address,
X.Zipcode,
X.State,
sum(CallCount) as CallCount,
X.FromNo,
X.StationID,
X.Descript,
NULL as RecordDate,
'' as [ToNo], 
'TOTAL BY PHONE NO' as CallType,
sum(CallDuration) as CallDuration,
SUM(CallRevenue) as CallRevenue, 
NULL as commrate, 
SUM(Commpaid) as CommPaid, 
'3' as recordCode

From

(select tblfacility.facilityID, tblfacility.Location, tblfacility.Address,tblfacility.Zipcode,tblfacility.State, 
1 as CallCount, fromno, tblANIs.StationID, tblFacilityLocation.Descript, RecordDate, tono, tblCallType.Descript as Calltype ,  
		dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue,  
		Cast(tblCommrate.CommRate * 100 as Numeric(6,2)) as CommRate, 
		(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,2) ) 
		 Else CAST((( CallRevenue - (CallRevenue * isnull(BadDebtRate,0) ) -isnull(Pif,0) )  *tblCommrate.CommRate)  as Numeric(12,2) ) + isnull( PIf,0)     End)  as CommPaid,
		 '1' as recordCode
		from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , 
		tblCommrate with(nolock), tblfacility with(nolock),
		tblANIs with(nolock), tblFacilityLocation with(nolock) 
		
		 WHERE
						tblcallsbilled.Billtype = tblBilltype.Billtype and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.Calltype = tblCalltype.Abrev and
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						 tblcallsbilled.fromNo = tblANIs.ANINo and
						 tblANIs.LocationID = tblFacilityLocation.LocationID and
					 	tblcallsbilled.facilityID	= @facilityID  And
						tblfacility.facilityID = @facilityID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	
	Union
	
select t1.FacilityID,
t9.Location, 
t9.Address,
t9.Zipcode,
t9.State,
1 as CallCount,
(t7.LastName + ', ' + t7.FirstName) as [FromNo],
'' as StationID,
'' as Descript,
t2.MessageDate as RecordDate,
(t3.LastName + ', ' + t3.FirstName) as [ToNo], 
t5.Descript as CallType,
'1' as CallDuration,
Cast(cast(t2.Charge as float) as Numeric(12,2)) as CallRevenue, 
(t10.Comm * 100) as commrate, 
cast(Cast((t2.Charge * t10.Comm) as float) as Numeric(12,2)) as Commpaid, 
'2' as recordCode

from tblMailboxDetail t2  with(nolock) 	
left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 	
left join tblInmate  t3  with(nolock) on t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID 	
left join tblMessageRate t4  with(nolock) on t2.MessageTypeID = t4.MessageTypeID and t1.FacilityID = t4.FacilityID 	
left join tblMessageType t5  with(nolock) on t2.MessageTypeID = t5.MessageTypeID 	
left join tblPrepaid t7 with(nolock) on t2.MessengerNo = t7.PhoneNo 	
left join tblMessageStatus t8 with(nolock) on isnull(t2.MessageStatus,1) = t8.MessStatus  
left join tblfacility t9 with(nolock) on (t1.facilityID) = t9.facilityID
left join tblMessageRate t10 with(nolock) on (t1.facilityID) = t10.facilityID and t2.MessageTypeID = t10.MessageTypeID

Where   
(t2.MessageDate between @fromDate and dateadd(d,1,@todate)) and 
t1.FacilityID = @facilityID 	

Union

select t1.FacilityID,
t9.Location, 
t9.Address,
t9.Zipcode,
t9.State,
1 as CallCount,
(t7.LastName + ', ' + t7.FirstName) as [FromNo],
'' as StationID,
'' as Descript,
t2.MessageDate as recordDate,
(t3.LastName + ', ' + t3.FirstName) as [ToNo], 
t5.Descript as CallType,
'1' as CallDuration,
Cast(cast(t2.Charge as float) as Numeric(12,2)) as CallRevenue, 
(t10.Comm * 100) as commrate, 
cast(Cast((t2.Charge * t10.Comm) as float) as Numeric(12,2)) as Commpaid, 
'2' as recordCode  

from tblMailboxDetailF t2  with(nolock) 	
left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.SenderMailBoxID 	
left join tblInmate  t3  with(nolock) on t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID 	
left join tblMessageRate t4  with(nolock) on t2.MessageTypeID = t4.MessageTypeID and t1.FacilityID = t4.FacilityID 	
left join tblMessageType t5  with(nolock) on t2.MessageTypeID = t5.MessageTypeID 	
left join tblMailboxF t6 with(nolock) on t2.MailBoxID = t6.MailBoxID 	
left join tblPrepaid t7 with(nolock) on t6.AccountNo = t7.PhoneNo 	
left join tblMessageStatus t8 with(nolock) on isnull(t2.MessageStatus,1) = t8.MessStatus
left join tblfacility t9 with(nolock) on (t1.facilityID) = t9.facilityID 
left join tblMessageRate t10 with(nolock) on (t1.facilityID) = t10.facilityID and t2.MessageTypeID = t10.MessageTypeID 

Where  
(t2.MessageDate between @fromDate and dateadd(d,1,@todate)) and 
t1.FacilityID = @facilityID ) as X

group by X.FacilityID,
X.Location, 
X.Address,
X.Zipcode,
x.State,
X.FromNo,
X.StationID,
X.Descript
) as T

order by T.FacilityID,
T.Location, 
T.Address,
T.Zipcode,
T.State,
T.FromNo,
T.recordCode
