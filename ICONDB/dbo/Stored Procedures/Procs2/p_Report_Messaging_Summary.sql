-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Report_Messaging_Summary] 
	@facilityID int,
	@fromDate datetime,
	@toDate datetime
	
AS
BEGIN
	
	SET NOCOUNT ON;

Select X.FacilityID, X.Descript,
	sum(X.Charge) as TotalCharge,
	Sum(X.MsgCount) as TotalCount,
	sum(X.CommDue) as TotalCommDue

From

(select t1.FacilityID, t1.MailboxID, t5.Descript ,MessageID, 'Inbox' as Box, t1.InmateID, MessengerNo as AccountNo, 
(T7.FirstName + ' ' + T7.LastName) as [From], (T3.FirstName + ' ' + T3.LastName) as [To], 
t1.status,  MessageDate ,MessageName, t2.folderDate,
t2.Charge, t4.Comm, (t2.Charge * t4.Comm) as CommDue, 1 as MsgCount 
	from tblMailboxDetail t2  with(nolock)
	left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID
	left join tblInmate  t3  with(nolock) on t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID
	left join tblMessageRate t4  with(nolock) on t2.MessageTypeID = t4.MessageTypeID and t1.FacilityID = t4.FacilityID 
	left join tblMessageType t5  with(nolock) on t2.MessageTypeID = t5.MessageTypeID
	left join tblPrepaid t7 with(nolock) on t2.MessengerNo = t7.PhoneNo
	
	where 
	 t1.FacilityID = @facilityID
	 and (t2.MessageDate between @fromDate and dateadd(d,1,@toDate)) 
	 Union
	 
	 select t1.FacilityID, t1.MailboxID, t5.Descript ,MessageID, 'Sent Items' as Box, t1.InmateID, t6.AccountNo as AccountNo,
	(T3.FirstName + ' ' + T3.LastName) as [From], (T7.FirstName + ' ' + T7.LastName) as [To], t1.status,  MessageDate ,MessageName, t2.folderDate,
	t2.Charge, t4.Comm, (t2.Charge * t4.Comm) as CommDue, 1 as MsgCount  
	from tblMailboxDetailF t2  with(nolock)
	left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.SenderMailBoxID
	left join tblInmate  t3  with(nolock) on t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID
	left join tblMessageRate t4  with(nolock) on t2.MessageTypeID = t4.MessageTypeID and t1.FacilityID = t4.FacilityID 
	left join tblMessageType t5  with(nolock) on t2.MessageTypeID = t5.MessageTypeID
	left join tblMailboxF t6 with(nolock) on t2.MailBoxID = t6.MailBoxID 
	left join tblPrepaid t7 with(nolock) on t6.AccountNo = t7.PhoneNo
	
	where 
	 t1.FacilityID = @facilityID
	 and (t2.MessageDate between @fromDate and dateadd(d,1,@toDate)) ) X
	 
	 --order by   t1.MailboxID  ,MessageID
	group by X.facilityID, X.Descript
order by X.facilityID, X.Descript
 
	
END

