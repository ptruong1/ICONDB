CREATE PROCEDURE [dbo].[p_Report_Houston_ElectricMessage_By_InmateID_Save] 
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
T.inmateID,
T.CallType,
--T.Tcount,
T.MessageDate,
T.Charge as CallRevenue, 
T.commrate, 
T.CommPaid as Commpaid
--T.recordCode
,T.TVisitCount as ToTalTrans
,T.TCallRevenue as TotalRevenue
,T.TCommPaid as TotalComm
 
from

(select t1.FacilityID,
t9.Location, 
t9.Address,
t9.Zipcode,
t9.State,
t1.inmateID,
t5.Descript as CallType,
1 as Tcount,
t2.MessageDate,
Cast(cast(t2.Charge as float) as Numeric(12,2)) as Charge, 
(t10.Comm * 100) as commrate, 
cast(Cast((t2.Charge * t10.Comm) as float) as Numeric(12,2)) as Commpaid,
'2' as recordCode 
,NULL  TVisitCount
,NULL  TCallRevenue
,NULL  TCommPaid 

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
(t2.MessageDate between @fromDate and dateadd(d,1,@toDate)) and 
t1.FacilityID = @facilityID 

Union 

select t1.FacilityID,
t9.Location, 
t9.Address,
t9.Zipcode,
t9.State,
t1.inmateID,
t5.Descript as CallType,
1 as Tcount,
t2.MessageDate,
Cast(cast(t2.Charge as float) as Numeric(12,2)) as CallRevenue, 
(t10.Comm * 100) as commrate, 
cast(Cast((t2.Charge * t10.Comm) as float) as Numeric(12,2)) as Commpaid,
'2' as recordCode  
,NULL  TVisitCount
,NULL  TCallRevenue
,NULL  TCommPaid 
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
(t2.MessageDate between @fromDate and dateadd(d,1,@toDate)) and 
t1.FacilityID = @facilityID  
	
Union All -- Get Total

select X.FacilityID,
X.Location, 
X.Address,
X.Zipcode,
X.State,
X.inmateID,
'' CallType,
NULL as TCount,
NULL as MessageDate,
NULL as CallRevenue, 
NULL as commrate, 
NULL as Commpaid,
'3' as recordCode 
,SUM(X.Tcount)  TVisitCount
,Sum(X.Charge)  TCallRevenue
,Sum(CommPaid)  TCommPaid 
From

(select t1.FacilityID,
t9.Location, 
t9.Address,
t9.Zipcode,
t9.State,
t1.inmateID,
t5.Descript as CallType,
1 as Tcount,
t2.MessageDate,
Cast(cast(t2.Charge as float) as Numeric(12,2)) as Charge, 
(t10.Comm * 100) as commrate, 
cast(Cast((t2.Charge * t10.Comm) as float) as Numeric(12,2)) as Commpaid,
'3' as recordCode 
,NULL  TVisitCount
,NULL  TCallRevenue
,NULL  TCommPaid 

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
(t2.MessageDate between @fromDate and dateadd(d,1,@toDate)) and 
t1.FacilityID = @facilityID  
Union all

select t1.FacilityID,
t9.Location, 
t9.Address,
t9.Zipcode,
t9.State,
t1.inmateID,
t5.Descript as CallType,
1 as TCount,
t2.MessageDate,
Cast(cast(t2.Charge as float) as Numeric(12,2)) as CallRevenue, 
(t10.Comm * 100) as commrate, 
cast(Cast((t2.Charge * t10.Comm) as float) as Numeric(12,2)) as Commpaid,
'2' as recordCode  
,NULL  TVisitCount
,NULL  TCallRevenue
,NULL  TCommPaid 

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
(t2.MessageDate between @fromDate and dateadd(d,1,@toDate)) and 
t1.FacilityID = @facilityID  
	) as X

Group by X.FacilityID,
X.Location, 
X.Address,
X.Zipcode,
X.State,
X.inmateID ) as T


Order By
T.FacilityID,
T.Location, 
T.Address,
T.Zipcode,
T.State,
T.inmateID,
T.recordCode
